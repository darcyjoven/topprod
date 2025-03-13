# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_industry.4gl
# Descriptions...: 行業別程式的相關設定與檢查
# Date & Author..: 07/01/03 by kim (FUN-6C0006)
# Modify.........: No.FUN-710037 07/01/16 By kim add s_industry_set()
# Modify.........: No.FUN-730018 07/03/23 By kim add s_industry_init(),s_industry_combo()
# Modify.........: No.FUN-810038 07/11/06 By kim 修改s_industry
# Modify.........: No.FUN-7B0018 08/01/30 By hellen 新增服飾版的ins/del調用函數
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.FUN-830121 08/03/31 By hongmei 修改服飾版的ins/del調用函數
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No.TQC-860002 08/06/02 By bnlent 使用cl_null()來判斷
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.FUN-870117 08/07/28 BY ve007 增加制單號(sfaislk02)
# Modify.........: No.FUN-890100 08/09/22 By hongmei 增加制單號(pnbislk01a,pnbislk01b)
# Modify.........: No.TQC-8A0065 08/10/23 By Dido 版更過單
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-990002 09/09/01 By lilingyu 如果配件配件增加特殊要求,產生工單單身時,會提示報錯
# Modify.........: No.FUN-980094 09/09/16 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50066 10/06/15 By jan sfai_file新增key值sfai012/sfai013
# Modify.........: No.FUN-A60035 10/07/05 By chenls ogbiplant判斷
# Modify.........: No.FUN-A50102 10/07/07 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70125 10/07/28 By lilingyu 平行工藝
# Modify.........: No.FUN-A70138 10/07/29 By jan sgyi_file新增KEY值sgyi012
# Modify.........: No.TQC-AA0112 10/10/20 By jan 判斷***iplant為null時,則給g_plant
# Modify.........: No:FUN-A40022 10/10/25 BY jan 增加批號控管否(imaicd13)
# Modify.........: No:FUN-B30192 11/05/18 BY jan imaicd_file新增字段imaicd14/imaicd15/imaicd16
# Modify.........: No:FUN-B30187 11/06/21 By jason 新增ICD版的ins/del調用函數
# Modify.........: No:FUN-B90104 11/10/17 BY huangrh 新增服飾版ohbi_file,ohbislk01,ohbislk02字段,ogbislk01,ogbislk02
# Modify.........: No:FUN-C20101 12/02/24 By qiaozy 新增服飾版inbi_file,inbislk01,inbislk02字段
# Modify.........: No:TQC-C20418 12/03/02 By lixiang 修正FUN-C20101的問題
# Modify.........: No:MOD-C30236 12/03/10 By bart 拋資料拋轉產生異常,自動關閉無法執行.
# Modify.........: No:FUN-C30289 12/04/03 By bart 增加欄位
# Modify.........: No:FUN-C30274 12/04/17 By jason sfaiicd06 預設值為'N'
# Modify.........: No:FUN-C30057 12/05/02 By linlin 增加？,ponislk02,03 
# Modify.........: No.CHI-C80009 12/08/22 By Sakura s_ins_rvvi新增值給予rvviicd02,rvviicd05預設值為空


DATABASE ds #FUN-850069
 
GLOBALS "../../config/top.global"
 
#FUN-810038
# Descriptions...: 判斷目前行業別是否為 p_opt (傳入null視為std)
# Usage..........: IF s_industry('std') THEN =>當行業別為std成立
#                  IF s_industry('icd') THEN =>當行業別為icd成立
#                  IF s_industry('slk') THEN =>當行業別為slk成立
#                  IF NOT s_industry('std') THEN =>當行業別為不為std時成立
 
FUNCTION s_industry(p_opt) 
   DEFINE p_opt LIKE smb_file.smb01
 
   IF cl_null(g_sma.sma124) THEN #初始化
      SELECT * INTO g_sma.*
        FROM sma_file
       WHERE sma00='0'
   END IF
   CASE
      WHEN cl_null(g_sma.sma124) #null 視為 std
         RETURN (p_opt='std')
      WHEN cl_null(p_opt)  #null 視為 std
         RETURN (g_sma.sma124='std')
      OTHERWISE
         RETURN (p_opt=g_sma.sma124)
   END CASE
END FUNCTION
 
#FUN-730018............begin
# Descriptions...: 初始化行業別判斷作業
 
FUNCTION s_industry_init()
   DEFINE l_smb01 LIKE smb_file.smb01
 
   SELECT smb01 INTO l_smb01 FROM smb_file
                            WHERE smb02=g_lang
                              AND smb05='Y'
   IF SQLCA.sqlcode OR cl_null(l_smb01) THEN
      CALL cl_err('','asm-290',1)
   END IF
   RETURN l_smb01
END FUNCTION
 
# Descriptions...: 設定行業別的 ComboBox 選項
 
FUNCTION s_industry_combo(ps_field_name)
  DEFINE ps_values,ps_items  STRING
  DEFINE ps_field_name       STRING
  DEFINE l_smb               RECORD LIKE smb_file.*
 
  DECLARE p_industry_item_cs CURSOR FOR 
     SELECT * FROM smb_file WHERE smb02=g_lang
                              ORDER BY smb01
  IF SQLCA.SQLCODE THEN
     CALL cl_err("smb_file", "asm-290", 1)
     RETURN
  END IF
 
  LET ps_values = ''
  LET ps_items = ''
 
  FOREACH p_industry_item_cs INTO l_smb.*
     LET ps_values = ps_values, l_smb.smb01, ','
    #LET ps_items = ps_items, l_smb.smb01, ' ', l_smb.smb04 CLIPPED, ','
     LET ps_items = ps_items, l_smb.smb01, ' ', l_smb.smb03, ' (', l_smb.smb04 CLIPPED, '),'
  END FOREACH
  LET ps_values = ps_values.subString(1, ps_values.getLength() - 1)
  LET ps_items = ps_items.subString(1, ps_items.getLength() - 1)
  CALL cl_set_combo_items(ps_field_name, ps_values, ps_items)
 
END FUNCTION
#FUN-730018............end
 
#FUN-810038.............begin
# Descriptions...: 新增一筆icd行業別ima_file的資料
# Memo...........: p_imaicd-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_imaicd(p_imaicd,p_dbname)
FUNCTION s_ins_imaicd(p_imaicd,p_plant)    #FUN-A50102
 
   DEFINE p_imaicd   RECORD LIKE imaicd_file.*
   DEFINE p_dbname   LIKE azp_file.azp03  
   DEFINE p_plant    LIKE azp_file.azp01   #FUN-A50102
   DEFINE l_sql      STRING
   DEFINE l_crossdb  STRING
   DEFINE l_legal   LIKE oebi_file.oebilegal    #FUN-A50102	
   DEFINE l_dbs_tra LIKE type_file.chr21        #FUN-A50102

   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       
   LET l_dbs_tra = g_dbs_tra   
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
   #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017#FUN-A50102
 
   #預設值指派
   IF cl_null(p_imaicd.imaicd12) THEN
      LET p_imaicd.imaicd12=0
   END IF
   IF cl_null(p_imaicd.imaicd08) THEN
      LET p_imaicd.imaicd08='N'
   END IF
   IF cl_null(p_imaicd.imaicd09) THEN
      LET p_imaicd.imaicd09='N'
   END IF
   IF cl_null(p_imaicd.imaicd13) THEN #FUN-A40022
      LET p_imaicd.imaicd13='N'       #FUN-A40022
   END IF                             #FUN-A40022
   #FUN-B30192--begin--add----
   IF cl_null(p_imaicd.imaicd14) THEN
      LET p_imaicd.imaicd14=0
   END IF
   IF cl_null(p_imaicd.imaicd15) THEN
      LET p_imaicd.imaicd15=0
   END IF
   #FUN-B30192--end--add-----
   #MOD-C30236---begin
   IF cl_null(p_imaicd.imaicd17) THEN
      LET p_imaicd.imaicd17 = '3'
   END IF 
   #MOD-C30236---end
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002   
      INSERT INTO imaicd_file VALUES (p_imaicd.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"imaicd_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'imaicd_file'), #FUN-A50102
                " (imaicd00,imaicd01,imaicd02,imaicd03,imaicd04,imaicd05,imaicd06,imaicd07,imaicd08,imaicd09,imaicd10",   #MOD-C30236
                " ,imaicd11,imaicd12,imaicd13,imaicd14,imaicd15,imaicd16,imaicd17,imaicd18,imaicd19,imaicd20,imaicd21 )", #MOD-C30236
                "  VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"	#FUN-A40022 #FUN-B30192  #MOD-C30236 add 5?
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102            
      PREPARE ins_imaicd_p FROM l_sql
      EXECUTE ins_imaicd_p USING p_imaicd.imaicd00,
                                 p_imaicd.imaicd01,
                                 p_imaicd.imaicd02,
                                 p_imaicd.imaicd03,
                                 p_imaicd.imaicd04,
                                 p_imaicd.imaicd05,
                                 p_imaicd.imaicd06,
                                 p_imaicd.imaicd07,
                                 p_imaicd.imaicd08,
                                 p_imaicd.imaicd09,
                                 p_imaicd.imaicd10,
                                 p_imaicd.imaicd11,
                                 p_imaicd.imaicd12,
                                 p_imaicd.imaicd13,   #FUN-A40022
                                 p_imaicd.imaicd14,   #FUN-B30192
                                 p_imaicd.imaicd15,   #FUN-B30192
                                 p_imaicd.imaicd16,   #FUN-B30192
                                 p_imaicd.imaicd17,   #MOD-C30236
                                 p_imaicd.imaicd18,   #MOD-C30236
                                 p_imaicd.imaicd19,   #MOD-C30236
                                 p_imaicd.imaicd20,   #MOD-C30236
                                 p_imaicd.imaicd21    #MOD-C30236
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg("imaicd00",p_imaicd.imaicd00,"INS imaicd_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","imaicd_file",p_imaicd.imaicd00,"",SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別imaicd_file的資料
# Memo...........: p_imaicd-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_del_imaicd(p_ima01,p_dbname)
FUNCTION s_del_imaicd(p_ima01,p_plant)   #FUN-A50102
   DEFINE p_ima01 LIKE ima_file.ima01
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE p_plant  LIKE azp_file.azp01   #FUN-A50102
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
 
   #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017#FUN-A50102
 
   #LET l_sql="DELETE FROM ",l_crossdb,"imaicd_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(p_plant,'imaicd_file'), #FUN-A50102
             "   WHERE imaicd00 = ?"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102           
   PREPARE del_imaicd_p FROM l_sql
   EXECUTE del_imaicd_p USING p_ima01
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg("imaicd00",p_ima01,"DEL imaicd_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","imaicd_file",p_ima01,"",SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 新增一筆行業別oebi_file的資料
# Memo...........: p_oebi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_oebi(p_oebi,p_dbname)
FUNCTION s_ins_oebi(p_oebi,p_plant)  #FUN-980094
   DEFINE p_oebi RECORD LIKE oebi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_legal  LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_oebi.oebiicd03) THEN
      LET p_oebi.oebiicd03=0
   END IF
   IF cl_null(p_oebi.oebiicd05) THEN
      LET p_oebi.oebiicd05='N'
   END IF
   IF cl_null(p_oebi.oebiicd06) THEN
      LET p_oebi.oebiicd06=0
   END IF
   IF cl_null(p_oebi.oebiicd08) THEN
      LET p_oebi.oebiicd08='N'
   END IF
 
   LET p_oebi.oebiplant=p_plant   #FUN-980012 
   LET p_oebi.oebilegal=l_legal   #FUN-980012  
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO oebi_file VALUES (p_oebi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"oebi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'oebi_file'), #FUN-A50102
                "   VALUES (?,?,  ?,?,  ?,?,  ?,?,  ?,?,  ?,?, ?,?,?,?)"   #FUN-980012 add #FUN-B90104
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102           
      PREPARE ins_oebi_p FROM l_sql
      EXECUTE ins_oebi_p USING p_oebi.oebi01,
                               p_oebi.oebi03,
                               p_oebi.oebiicd01,
                               p_oebi.oebiicd02,
                               p_oebi.oebiicd03,
                               p_oebi.oebiicd04,
                               p_oebi.oebiicd05,
                               p_oebi.oebiicd06,
                               p_oebi.oebiicd07,
                               p_oebi.oebiicd08,
                               p_oebi.oebiicd09,
                               p_oebi.oebislk01,
                               p_oebi.oebiplant, #FUN-980012 add
                               p_oebi.oebilegal, #FUN-980012 add
                               p_oebi.oebislk02, #FUN-B90104 add
                               p_oebi.oebislk03  #FUN-B90104 add
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_oebi.oebi01,"||",p_oebi.oebi03
         CALL s_errmsg("oebi01,oebi03",l_sql,"INS oebi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","oebi_file",p_oebi.oebi01,p_oebi.oebi03,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別oebi_file的資料
# Memo...........: p_oeb01,p_oeb03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_del_oebi(p_oeb01,p_oeb03,p_dbname)
FUNCTION s_del_oebi(p_oeb01,p_oeb03,p_plant)  
   DEFINE p_oeb01 LIKE oeb_file.oeb01
   DEFINE p_oeb03 LIKE oeb_file.oeb03
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-820094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"oebi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'oebi_file'), #FUN-A50102
             "   WHERE oebi01 = '",p_oeb01,"'"
   IF NOT cl_null(p_oeb03) THEN #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND oebi03=",p_oeb03
      LET l_sql=l_sql," AND oebi03= '",p_oeb03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_oebi_p FROM l_sql
   EXECUTE del_oebi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_oeb01,"||",p_oeb03
         CALL s_errmsg("oebi01,oebi03",l_sql,"DEL oebi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","oebi_file",p_oeb01,p_oeb03,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 新增一筆行業別ogbi_file的資料
# Memo...........: p_ogbi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_ogbi(p_ogbi,p_dbname)
FUNCTION s_ins_ogbi(p_ogbi,p_plant)  
   DEFINE p_ogbi RECORD LIKE ogbi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
   

#FUN-A60035 add begin
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
#FUN-A60035 add end 
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_ogbi.ogbiicd01) THEN
      LET p_ogbi.ogbiicd01='N'
   END IF
   IF cl_null(p_ogbi.ogbiicd02) THEN
      LET p_ogbi.ogbiicd02=0
   END IF
   IF cl_null(p_ogbi.ogbiicd03) THEN
      LET p_ogbi.ogbiicd03='0'
   END IF
 
   LET p_ogbi.ogbiplant=p_plant   #FUN-980012 
   LET p_ogbi.ogbilegal=l_legal   #FUN-980012  
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO ogbi_file VALUES (p_ogbi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"ogbi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'ogbi_file'), #FUN-A50102
                "   VALUES (?,?,  ?,?,  ?,?,  ?,?, ?,?, ?,?, ?)"   #FUN-980012 add  #FUN-B30187 #FUN-B90104 add ,?,? #FUN-C30289 add ?
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
      PREPARE ins_ogbi_p FROM l_sql
      EXECUTE ins_ogbi_p USING p_ogbi.ogbi01,
                               p_ogbi.ogbi03,
                               p_ogbi.ogbiicd01,
                               p_ogbi.ogbiicd02,
                               p_ogbi.ogbiicd03,
                               p_ogbi.ogbiicd04,
                               p_ogbi.ogbiplant,  #FUN-980012 add
                               p_ogbi.ogbilegal,  #FUN-980012 add
                               p_ogbi.ogbiicd028, #FUN-B30187
                               p_ogbi.ogbiicd029  #FUN-B30187
                              ,p_ogbi.ogbislk01,  #FUN-B90104
                               p_ogbi.ogbislk02,  #FUN-B90104
                               p_ogbi.ogbiicd07   #FUN-C30289
 
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_ogbi.ogbi01,"||",p_ogbi.ogbi03
         CALL s_errmsg("ogbi01,ogbi03",l_sql,"INS ogbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","ogbi_file",p_ogbi.ogbi01,p_ogbi.ogbi03,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別ogbi_file的資料
# Memo...........: p_ogb01,p_ogb03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_ogbi(p_ogb01,p_ogb03,p_dbname)
FUNCTION s_del_ogbi(p_ogb01,p_ogb03,p_plant) 
   DEFINE p_ogb01 LIKE ogb_file.ogb01
   DEFINE p_ogb03 LIKE ogb_file.ogb03
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094

#FUN-A60035 add begin
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
#FUN-A60035 add end 
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"ogbi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'ogbi_file'), #FUN-A50102
             "   WHERE ogbi01 = '",p_ogb01,"'"
   IF NOT cl_null(p_ogb03) THEN #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND ogbi03=",p_ogb03
      LET l_sql=l_sql," AND ogbi03= '",p_ogb03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_ogbi_p FROM l_sql
   EXECUTE del_ogbi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_ogb01,"||",p_ogb03
         CALL s_errmsg("ogbi01,ogbi03",l_sql,"DEL ogbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","ogbi_file",p_ogb01,p_ogb03,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 新增一筆行業別pmni_file的資料
# Memo...........: p_pmni-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_pmni(p_pmni,p_dbname)
FUNCTION s_ins_pmni(p_pmni,p_plant)  
   DEFINE p_pmni RECORD LIKE pmni_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_pmni.pmniicd03) THEN
      LET p_pmni.pmniicd03=' '
   END IF
   IF cl_null(p_pmni.pmniicd04) THEN
      LET p_pmni.pmniicd04='N'
   END IF
   IF cl_null(p_pmni.pmniicd05) THEN
      LET p_pmni.pmniicd05='N'
   END IF
   IF cl_null(p_pmni.pmniicd06) THEN
      LET p_pmni.pmniicd06='N'
   END IF
   IF cl_null(p_pmni.pmniicd07) THEN
      LET p_pmni.pmniicd07=0
   END IF
   IF cl_null(p_pmni.pmniicd08) THEN
      LET p_pmni.pmniicd08='N'
   END IF
   IF cl_null(p_pmni.pmniicd09) THEN
      LET p_pmni.pmniicd09=0
   END IF
   IF cl_null(p_pmni.pmniicd10) THEN
      LET p_pmni.pmniicd10='N'
   END IF
   IF cl_null(p_pmni.pmniicd12) THEN
      LET p_pmni.pmniicd12=' '
   END IF
   IF cl_null(p_pmni.pmniicd13) THEN
      LET p_pmni.pmniicd13=0
   END IF
 
   LET p_pmni.pmniplant=p_plant   #FUN-980012 add
   LET p_pmni.pmnilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO pmni_file VALUES (p_pmni.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"pmni_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'pmni_file'), #FUN-A50102
                "   VALUES (?,?,  ?,?,  ?,?,  ?,?,  ?,?,   ",
                "        ?,?,  ?,?,  ?,?,  ?,?,  ?,?,  ?,  ?,?,?,?)"  #FUN-980012 add#FUN-B90104 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      PREPARE ins_pmni_p FROM l_sql
      EXECUTE ins_pmni_p USING p_pmni.pmni01,
                               p_pmni.pmni02,
                               p_pmni.pmniicd01,
                               p_pmni.pmniicd02,
                               p_pmni.pmniicd03,
                               p_pmni.pmniicd04,
                               p_pmni.pmniicd05,
                               p_pmni.pmniicd06,
                               p_pmni.pmniicd07,
                               p_pmni.pmniicd08,
                               p_pmni.pmniicd09,
                               p_pmni.pmniicd10,
                               p_pmni.pmniicd11,
                               p_pmni.pmniicd12,
                               p_pmni.pmniicd13,
                               p_pmni.pmniicd14,
                               p_pmni.pmniicd15,
                               p_pmni.pmniicd16,
                               p_pmni.pmniicd17,
                               p_pmni.pmniicd18,
                               p_pmni.pmnislk01,
                               p_pmni.pmniplant,   #FUN-980012 add
                               p_pmni.pmnilegal    #FUN-980012 add
                              ,p_pmni.pmnislk02,   #FUN-B90104
                               p_pmni.pmnislk03    #FUN-B90104
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pmni.pmni01,"||",p_pmni.pmni02
         CALL s_errmsg("pmni01,pmni02",l_sql,"INS pmni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","pmni_file",p_pmni.pmni01,p_pmni.pmni02,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別pmni_file的資料
# Memo...........: p_pmn01,p_pmn02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_pmni(p_pmn01,p_pmn02,p_dbname)
FUNCTION s_del_pmni(p_pmn01,p_pmn02,p_plant)  
   DEFINE p_pmn01 LIKE pmn_file.pmn01
   DEFINE p_pmn02 LIKE pmn_file.pmn02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra      LIKE type_file.chr21  #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"pmni_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'pmni_file'), #FUN-A50102
             "   WHERE pmni01 = '",p_pmn01,"'"
   IF NOT cl_null(p_pmn02) THEN #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pmni02=",p_pmn02
      LET l_sql=l_sql," AND pmni02= '",p_pmn02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_pmni_p FROM l_sql
   EXECUTE del_pmni_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pmn01,"||",p_pmn02
         CALL s_errmsg("pmni01,pmni02",l_sql,"DEL pmni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","pmni_file",p_pmn01,p_pmn02,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 新增一筆行業別rvbi_file的資料
# Memo...........: p_rvbi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_rvbi(p_rvbi,p_dbname)
FUNCTION s_ins_rvbi(p_rvbi,p_plant)  
   DEFINE p_rvbi RECORD LIKE rvbi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_rvbi.rvbiicd03) THEN
      LET p_rvbi.rvbiicd03=' '
   END IF
   IF cl_null(p_rvbi.rvbiicd04) THEN
      LET p_rvbi.rvbiicd04='N'
   END IF
   IF cl_null(p_rvbi.rvbiicd05) THEN
      LET p_rvbi.rvbiicd05='N'
   END IF
   IF cl_null(p_rvbi.rvbiicd06) THEN
      LET p_rvbi.rvbiicd06=0
   END IF
   IF cl_null(p_rvbi.rvbiicd07) THEN
      LET p_rvbi.rvbiicd07=0
   END IF
   IF cl_null(p_rvbi.rvbiicd09) THEN
      LET p_rvbi.rvbiicd09='N'
   END IF
   IF cl_null(p_rvbi.rvbiicd10) THEN
      LET p_rvbi.rvbiicd10='N'
   END IF
   IF cl_null(p_rvbi.rvbiicd13) THEN
      LET p_rvbi.rvbiicd13=' '
   END IF
 
   LET p_rvbi.rvbiplant=p_plant   #FUN-980012 add
   LET p_rvbi.rvbilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO rvbi_file VALUES (p_rvbi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"rvbi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'rvbi_file'), #FUN-A50102
                "   VALUES (?,?,  ?,?,  ?,?,  ?,?,  ?,?,   ",
                "        ?,?,  ?,?,  ?,?,  ?,?,  ?,  ?,?, ?,?)"    #FUN-980012 add #FUN-B90104
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102          
      PREPARE ins_rvbi_p FROM l_sql
      EXECUTE ins_rvbi_p USING p_rvbi.rvbi01,
                               p_rvbi.rvbi02,
                               p_rvbi.rvbiicd01,
                               p_rvbi.rvbiicd02,
                               p_rvbi.rvbiicd03,
                               p_rvbi.rvbiicd04,
                               p_rvbi.rvbiicd05,
                               p_rvbi.rvbiicd06,
                               p_rvbi.rvbiicd07,
                               p_rvbi.rvbiicd08,
                               p_rvbi.rvbiicd09,
                               p_rvbi.rvbiicd10,
                               p_rvbi.rvbiicd11,
                               p_rvbi.rvbiicd12,
                               p_rvbi.rvbiicd13,
                               p_rvbi.rvbiicd14,
                               p_rvbi.rvbiicd15,
                               p_rvbi.rvbiicd16,
                               p_rvbi.rvbiicd17,
                               p_rvbi.rvbiplant,   #FUN-980012 add
                               p_rvbi.rvbilegal,   #FUN-980012 add
                               p_rvbi.rvbislk01,   #FUN-B90104
                               p_rvbi.rvbislk02    #FUN-B90104
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_rvbi.rvbi01,"||",p_rvbi.rvbi02
         CALL s_errmsg("rvbi01,rvbi02",l_sql,"INS rvbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","rvbi_file",p_rvbi.rvbi01,p_rvbi.rvbi02,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別rvbi_file的資料
# Memo...........: p_rvb01,p_rvb02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_del_rvbi(p_rvb01,p_rvb02,p_dbname)
FUNCTION s_del_rvbi(p_rvb01,p_rvb02,p_plant)  
   DEFINE p_rvb01 LIKE rvb_file.rvb01
   DEFINE p_rvb02 LIKE rvb_file.rvb02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"rvbi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'rvbi_file'), #FUN-A50102
             "   WHERE rvbi01 = '",p_rvb01,"'"
   IF NOT cl_null(p_rvb02) THEN #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND rvbi02=",p_rvb02
      LET l_sql=l_sql," AND rvbi02= '",p_rvb02,"'"
      #No.FUN-7B0018 modify 080220 --end
      LET l_sql=l_sql," AND rvbi02=",p_rvb02
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_rvbi_p FROM l_sql
   EXECUTE del_rvbi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_rvb01,"||",p_rvb02
         CALL s_errmsg("rvbi01,rvbi02",l_sql,"DEL rvbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","rvbi_file",p_rvb01,p_rvb02,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 新增一筆icd行業別sfb_file的資料
# Memo...........: p_sfbi01-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_sfbi(p_sfbi,p_dbname)
FUNCTION s_ins_sfbi(p_sfbi,p_plant)  
   DEFINE p_sfbi RECORD LIKE sfbi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_sfbi.sfbiicd04) THEN
      LET p_sfbi.sfbiicd04=0
   END IF
   IF cl_null(p_sfbi.sfbiicd05) THEN
      LET p_sfbi.sfbiicd05=0
   END IF
   IF cl_null(p_sfbi.sfbiicd06) THEN
      LET p_sfbi.sfbiicd06=0
   END IF
   IF cl_null(p_sfbi.sfbiicd09) THEN
      LET p_sfbi.sfbiicd09=' '
   END IF
   IF cl_null(p_sfbi.sfbiicd10) THEN
      LET p_sfbi.sfbiicd10='N'
   END IF
   #No.FUN-7B0018 add 080220 --begin
   IF cl_null(p_sfbi.sfbiicd15) THEN
      LET p_sfbi.sfbiicd15=0
   END IF
   IF cl_null(p_sfbi.sfbiicd17) THEN
      LET p_sfbi.sfbiicd17=0
   END IF
   #No.FUN-7B0018 add 080220 --end
 
   LET p_sfbi.sfbiplant=p_plant   #FUN-980012 add
   LET p_sfbi.sfbilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO sfbi_file VALUES (p_sfbi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
#     LET l_sql="INSERT INTO ",l_crossdb,"sfbi01_file ",         #No.FUN-7B0018
      #LET l_sql="INSERT INTO ",l_crossdb,"sfbi_file ",           #No.FUN-7B0018
      LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'sfbi_file'), #FUN-A50102
#               "VALUES (?,  ?,?,  ?,?,  ?,?,  ?,?,  ?,?,  ?,?)" #No.FUN-7B0018
                "   VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,  ?,?)" #No.FUN-7B0018 #FUN-980012 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102               
      PREPARE ins_sfbi_p FROM l_sql
      EXECUTE ins_sfbi_p USING p_sfbi.sfbi01,
                               p_sfbi.sfbiicd01,
                               p_sfbi.sfbiicd02,
                               p_sfbi.sfbiicd03,
                               p_sfbi.sfbiicd04,
                               p_sfbi.sfbiicd05,
                               p_sfbi.sfbiicd06,
                               p_sfbi.sfbiicd07,
                               p_sfbi.sfbiicd08,
                               p_sfbi.sfbiicd09,
                               p_sfbi.sfbiicd10,
                               p_sfbi.sfbiicd11,
                               p_sfbi.sfbiicd12,
                               p_sfbi.sfbiicd13,
                               p_sfbi.sfbiicd14,
                               p_sfbi.sfbiicd15,
                               p_sfbi.sfbiicd16,
                               p_sfbi.sfbiicd17,
                               p_sfbi.sfbiicd18,
                               p_sfbi.sfbiplant,   #FUN-980012 add
                               p_sfbi.sfbilegal    #FUN-980012 add
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg("sfbi01",p_sfbi.sfbi01,"INS sfbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sfbi_file",p_sfbi.sfbi01,"",SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別sfbi_file的資料
# Memo...........: p_sfbi01-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_sfbi(p_sfbi01,p_dbname)
FUNCTION s_del_sfbi(p_sfbi01,p_plant)  
   DEFINE p_sfbi01 LIKE sfbi_file.sfbi01
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"sfbi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sfbi_file'), #FUN-A50102
             "   WHERE sfbi01 = ?"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_sfbi_p FROM l_sql
   EXECUTE del_sfbi_p USING p_sfbi01
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg("sfbi01",p_sfbi01,"DEL sfbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sfbi_file",p_sfbi01,"",SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 新增一筆行業別sfai_file的資料
# Memo...........: p_sfai-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_sfai(p_sfai,p_dbname)
FUNCTION s_ins_sfai(p_sfai,p_plant)  
   DEFINE p_sfai RECORD LIKE sfai_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE l_cnt        LIKE type_file.num5    #MOD-990002 
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_sfai.sfai03) THEN
      LET p_sfai.sfai03=' '
   END IF
   IF cl_null(p_sfai.sfaiicd01) THEN
      LET p_sfai.sfaiicd01=0
   END IF
   IF cl_null(p_sfai.sfaiicd04) THEN
      LET p_sfai.sfaiicd04=0
   END IF
   IF cl_null(p_sfai.sfaiicd05) THEN
      LET p_sfai.sfaiicd05=0
   END IF
   #No.FUN-7B0018 add 080220 --begin
   IF cl_null(p_sfai.sfaislk01) THEN
      LET p_sfai.sfaislk01=0
   END IF
   #No.FUN-7B0018 add 080220 --end
 
   LET p_sfai.sfaiplant=p_plant   #FUN-980012 add
   LET p_sfai.sfailegal=l_legal   #FUN-980012 add
   #FUN-C30289---begin
   IF cl_null(p_sfai.sfaiicd06) THEN
      LET p_sfai.sfaiicd06 = 'N'   #FUN-C30274 ' '>'N' 
   END IF 
   #FUN-C30289---end
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
#MOD-990002 --begin--
      SELECT COUNT(*) INTO l_cnt FROM sfai_file
       WHERE sfai01 = p_sfai.sfai01
         AND sfai03 = p_sfai.sfai03
         AND sfai08 = p_sfai.sfai08
         AND sfai12 = p_sfai.sfai12
         AND sfai27 = p_sfai.sfai27
         AND sfai012 = p_sfai.sfai012  #FUN-A50066
         AND sfai013 = p_sfai.sfai013  #FUN-A50066  
      IF l_cnt > 0 THEN 
         UPDATE sfai_file SET sfai_file.* = p_sfai.*
      ELSE      
#MOD-990002 --end--    
#FUN-A70125 --begin--
         IF cl_null(p_sfai.sfai012) THEN
            LET p_sfai.sfai012 = ' ' 
         END IF 
         IF cl_null(p_sfai.sfai013) THEN
            LET p_sfai.sfai013 = 0 
         END IF 
#FUN-A70125 --end--
         INSERT INTO sfai_file VALUES (p_sfai.*)
      END IF         #MOD-990002   
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"sfai_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'sfai_file'), #FUN-A50102
#               "VALUES (?,?,  ?,?,  ?,?,  ?,?,  ?)"      #No.FUN-7B0018
#               "VALUES (?,?,  ?,?,?,  ?,?,  ?,?,  ?,?)"    #No.FUN-7B0018 #CHI-7B0034
                "   VALUES (?,?,  ?,?,?,  ?,?,  ?,?,  ?,?,?,  ?,?, ?,?, ?)"    #No.FUN-7B0018 #CHI-7B0034     #No.FUN-870117 #FUN-980012 add #FUN-A50066 #FUN-C30289 add ?
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE ins_sfai_p FROM l_sql
      EXECUTE ins_sfai_p USING p_sfai.sfai01,
                               p_sfai.sfai03,
                               p_sfai.sfai08,
                               p_sfai.sfai12,
                               p_sfai.sfaiicd01,
                               p_sfai.sfaiicd02,
                               p_sfai.sfaiicd03,
                               p_sfai.sfaiicd04,
                               p_sfai.sfaiicd05,
                               p_sfai.sfaislk01,     #No.FUN-7B0018
                               p_sfai.sfai27, #CHI-7B0034
                               p_sfai.sfaislk02,     #No.FUN-870117
                               p_sfai.sfaiplant,     #FUN-980012 
                               p_sfai.sfailegal,     #FUN-980012 
                               p_sfai.sfai012,       #FUN-A50066
                               p_sfai.sfai013,       #FUN-A50066
                               p_sfai.sfaiicd06      #FUN-C30289
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfai.sfai01,"||",p_sfai.sfai03,"||",p_sfai.sfai08,"||",p_sfai.sfai12,"||",p_sfai.sfai012,"||",p_sfai.sfai013  #FUN-A50066
         CALL s_errmsg("sfai01,sfai03,sfai08,sfai12",l_sql,"INS sfai_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sfai_file",p_sfai.sfai01,p_sfai.sfai03,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
 
# Descriptions...: 刪除一筆icd行業別sfai_file的資料
# Memo...........: 如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_sfai(p_sfai01,p_sfai03,p_sfai08,p_sfai12,p_sfai27,p_dbname) #CHI-7B0034
FUNCTION s_del_sfai(p_sfai01,p_sfai03,p_sfai08,p_sfai12,p_sfai27,p_sfai012,p_sfai013,p_plant)  #FUN-A50066
   DEFINE p_sfai01 LIKE sfai_file.sfai01
   DEFINE p_sfai03 LIKE sfai_file.sfai03
   DEFINE p_sfai08 LIKE sfai_file.sfai08
   DEFINE p_sfai12 LIKE sfai_file.sfai12
   DEFINE p_sfai27 LIKE sfai_file.sfai27
   DEFINE p_sfai012  LIKE sfai_file.sfai012  #FUN-A50066
   DEFINE p_sfai013  LIKE sfai_file.sfai013  #FUN-A50066
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"sfai_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sfai_file'), #FUN-A50102
             "   WHERE sfai01 = '",p_sfai01,"'"
   IF (NOT cl_null(p_sfai03)) OR (NOT p_sfai03=' ') THEN #如果有給作業編號的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sfai03=",p_sfai03
      LET l_sql=l_sql," AND sfai03= '",p_sfai03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   IF NOT cl_null(p_sfai08) THEN #如果有給的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sfai08=",p_sfai08
      LET l_sql=l_sql," AND sfai08= '",p_sfai08,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   IF NOT cl_null(p_sfai12) THEN #如果有給的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sfai12=",p_sfai12
      LET l_sql=l_sql," AND sfai12= '",p_sfai12,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   #CHI-7B0034
   IF NOT cl_null(p_sfai27) THEN #如果有給的話
      LET l_sql=l_sql," AND sfai27= '",p_sfai27,"'"
   END IF
   #--
   #FUN-A50066--begin--add-------------------
   IF NOT cl_null(p_sfai012) THEN #如果有給的話
      LET l_sql=l_sql," AND sfai012= '",p_sfai012,"'"
   END IF
   IF NOT cl_null(p_sfai013) THEN #如果有給的話
      LET l_sql=l_sql," AND sfai013= '",p_sfai013,"'"
   END IF
   #FUN-A50066--end--add-------------------- 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_sfai_p FROM l_sql
   EXECUTE del_sfai_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfai01,"||",p_sfai03,"||",p_sfai08,"||",p_sfai12,"||",p_sfai27,"||",p_sfai012,"||",p_sfai013  #FUN-A50066
         CALL s_errmsg("sfai01,sfai03,sfai08,sfai12",l_sql,"DEL sfai_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sfai_file",p_sfai01,p_sfai03,SQLCA.sqlcode,"","",1)
#        LET g_success='N'                #NO.FUN-7B0018
      END IF
      RETURN FALSE                        #NO.FUN-7B0018
   END IF
   RETURN TRUE                            #NO.FUN-7B0018
END FUNCTION
#FUN-810038.............end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別ogdi_file的資料
# Memo...........: p_ogdi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_ogdi(p_ogdi,p_dbname)
FUNCTION s_ins_ogdi(p_ogdi,p_plant)  
   DEFINE p_ogdi    RECORD LIKE ogdi_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_ogdi.ogdi03) THEN
      LET p_ogdi.ogdi03 = 0
   END IF
   IF cl_null(p_ogdi.ogdi04) THEN
      LET p_ogdi.ogdi04 = 0
   END IF
 
   LET p_ogdi.ogdiplant=p_plant   #FUN-980012 add
   LET p_ogdi.ogdilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO ogdi_file VALUES (p_ogdi.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"ogdi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'ogdi_file'), #FUN-A50102
                "   VALUES (?,?,?,?,  ?,?)"         #FUN-980012 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102               
      PREPARE ins_ogdi_p FROM l_sql
      EXECUTE ins_ogdi_p USING p_ogdi.ogdi01,
                               p_ogdi.ogdi03,
                               p_ogdi.ogdi04,
                               p_ogdi.ogdislk01,
                               p_ogdi.ogdiplant, #FUN-980012 
                               p_ogdi.ogdilegal  #FUN-980012
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_ogdi.ogdi01,"||",p_ogdi.ogdi03,"||",p_ogdi.ogdi04
         CALL s_errmsg("ogdi01,ogdi03,ogdi04",l_sql,"INS ogdi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","ogdi_file",p_ogdi.ogdi01,p_ogdi.ogdi03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別ogdi_file的資料
# Memo...........: p_ogd01,p_ogd03,p_ogd04
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_del_ogdi(p_ogd01,p_ogd03,p_ogd04,p_dbname)
FUNCTION s_del_ogdi(p_ogd01,p_ogd03,p_ogd04,p_plant)  
   DEFINE p_ogd01   LIKE ogd_file.ogd01
   DEFINE p_ogd03   LIKE ogd_file.ogd03
   DEFINE p_ogd04   LIKE ogd_file.ogd04
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"ogdi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'ogdi_file'), #FUN-A50102
             "   WHERE ogdi01 = '",p_ogd01,"'"
 
   IF NOT cl_null(p_ogd03) THEN      #如果有給的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND ogdi03=",p_ogd03
      LET l_sql=l_sql," AND ogdi03= '",p_ogd03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_ogd04) THEN      #如果有給的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND ogdi04=",p_ogd04
      LET l_sql=l_sql," AND ogdi04= '",p_ogd04,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_ogdi_p FROM l_sql
   EXECUTE del_ogdi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_ogd01,"||",p_ogd03,"||",p_ogd04
         CALL s_errmsg("ogdi01,ogdi03,ogdi04",l_sql,"DEL ogdi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","ogdi_file",p_ogd01,p_ogd03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別pmli_file的資料
# Memo...........: p_pmli-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_pmli(p_pmli,p_dbname)
FUNCTION s_ins_pmli(p_pmli,p_plant)  
   DEFINE p_pmli    RECORD LIKE pmli_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_pmli.pmli02) THEN
      LET p_pmli.pmli02 = 0
   END IF
 
   LET p_pmli.pmliplant=p_plant   #FUN-980012 add
   LET p_pmli.pmlilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO pmli_file VALUES (p_pmli.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"pmli_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'pmli_file'), #FUN-A50102
                "   VALUES (?,?,?,  ?,?, ?,?)"    #FUN-980012 add #FUN-B90104
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102	          
      PREPARE ins_pmli_p FROM l_sql
      EXECUTE ins_pmli_p USING p_pmli.pmli01,
                               p_pmli.pmli02,
                               p_pmli.pmlislk01,
                               p_pmli.pmliplant,  #FUN-980012
                               p_pmli.pmlilegal,  #FUN-980012
                               p_pmli.pmlislk02,  #FUN-B90104
                               p_pmli.pmlislk02   #FUN-B90104
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pmli.pmli01,"||",p_pmli.pmli02
         CALL s_errmsg("pmli01,pmli02",l_sql,"INS pmli_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","pmli_file",p_pmli.pmli01,p_pmli.pmli02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別pmli_file的資料
# Memo...........: p_pml01,p_pml02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_pmli(p_pml01,p_pml02,p_dbname)
FUNCTION s_del_pmli(p_pml01,p_pml02,p_plant)  
   DEFINE p_pml01   LIKE pml_file.pml01
   DEFINE p_pml02   LIKE pml_file.pml02
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"pmli_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'pmli_file'), #FUN-A50102
             "   WHERE pmli01 = '",p_pml01,"'"
 
   IF NOT cl_null(p_pml02) THEN      #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pmli02=",p_pml02
      LET l_sql=l_sql," AND pmli02= '",p_pml02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_pmli_p FROM l_sql
   EXECUTE del_pmli_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pml01,"||",p_pml02
         CALL s_errmsg("pmli01,pmli02",l_sql,"DEL pmli_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","pmli_file",p_pml01,p_pml02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別pnbi_file的資料
# Memo...........: p_pnbi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_ins_pnbi(p_pnbi,p_dbname)
FUNCTION s_ins_pnbi(p_pnbi,p_plant)  
   DEFINE p_pnbi    RECORD LIKE pnbi_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
   
 
   #預設值指派
   IF cl_null(p_pnbi.pnbi02) THEN
      LET p_pnbi.pnbi02 = 0
   END IF
   
   IF cl_null(p_pnbi.pnbi03) THEN
      LET p_pnbi.pnbi03 = 0
   END IF
   
   LET p_pnbi.pnbiplant=p_plant   #FUN-980012 add
   LET p_pnbi.pnbilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO pnbi_file VALUES (p_pnbi.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"pnbi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'pnbi_file'), #FUN-A50102
                "   VALUES (?,?,?,?,?,  ?,?)"     #No.FUN-890100
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      PREPARE ins_pnbi_p FROM l_sql
      EXECUTE ins_pnbi_p USING p_pnbi.pnbi01,
                               p_pnbi.pnbi02,
                               p_pnbi.pnbi03,
                               p_pnbi.pnbislk01a,    #No.FUN-890100
                               p_pnbi.pnbislk01b,    #No.FUN-890100  
                               p_pnbi.pnbiplant,     #FUN-980092
                               p_pnbi.pnbilegal      #FUN-980092
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pnbi.pnbi01,"||",p_pnbi.pnbi02,"||",p_pnbi.pnbi03
         CALL s_errmsg("pnbi01,pnbi02,pnbi03",l_sql,"INS pnbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","pnbi_file",p_pnbi.pnbi01,p_pnbi.pnbi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別pnbi_file的資料
# Memo...........: p_pnb01,p_pnb02,p_pnb03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_pnbi(p_pnb01,p_pnb02,p_pnb03,p_dbname)
FUNCTION s_del_pnbi(p_pnb01,p_pnb02,p_pnb03,p_plant)  
   DEFINE p_pnb01   LIKE pnb_file.pnb01
   DEFINE p_pnb02   LIKE pnb_file.pnb02
   DEFINE p_pnb03   LIKE pnb_file.pnb03
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
 
   #LET l_sql="DELETE FROM ",l_crossdb,"pnbi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'pnbi_file'), #FUN-A50102
             "   WHERE pnbi01 = '",p_pnb01,"'"
 
   IF NOT cl_null(p_pnb02) THEN      #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pnbi02=",p_pnb02
      LET l_sql=l_sql," AND pnbi02= '",p_pnb02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_pnb03) THEN      #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pnbi03=",p_pnb03
      LET l_sql=l_sql," AND pnbi03= '",p_pnb03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_pnbi_p FROM l_sql
   EXECUTE del_pnbi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pnb01,"||",p_pnb02,"||",p_pnb03
         CALL s_errmsg("pnbi01,pnbi02,pnbi03",l_sql,"DEL pnbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","pnbi_file",p_pnb01,p_pnb02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別pnni_file的資料
# Memo...........: p_pnni-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_pnni(p_pnni,p_dbname)
FUNCTION s_ins_pnni(p_pnni,p_plant)  
   DEFINE p_pnni    RECORD LIKE pnni_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
   
 
   #預設值指派
   IF cl_null(p_pnni.pnni02) THEN
      LET p_pnni.pnni02 = 0
   END IF
   
#  IF cl_null(p_pnni.pnni03) THEN
#     LET p_pnni.pnni03 = 0
#  END IF
   
#  IF cl_null(p_pnni.pnni05) THEN
#     LET p_pnni.pnni05 = 0
#  END IF
   
#  IF cl_null(p_pnni.pnni06) THEN
#     LET p_pnni.pnni06 = 0
#  END IF
   
   LET p_pnni.pnniplant=p_plant   #FUN-980012 add
   LET p_pnni.pnnilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO pnni_file VALUES (p_pnni.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"pnni_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'pnni_file'), #FUN-A50102
                "   VALUES (?,?,?,?,?,?,  ?,?)"    #FUN-980012 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE ins_pnni_p FROM l_sql
      EXECUTE ins_pnni_p USING p_pnni.pnni01,
                               p_pnni.pnni02,
                               p_pnni.pnni03,
                               p_pnni.pnni05,
                               p_pnni.pnni06,
                               p_pnni.pnnislk01,
                               p_pnni.pnniplant, #FUN-980092
                               p_pnni.pnnilegal  #FUN-980092
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pnni.pnni01,"||",p_pnni.pnni02,"||",p_pnni.pnni03,
                   p_pnni.pnni05,"||",p_pnni.pnni06
         CALL s_errmsg("pnni01,pnni02,pnni03,pnni05,pnni06",l_sql,"INS pnni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","pnni_file",p_pnni.pnni01,p_pnni.pnni02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別pnni_file的資料
# Memo...........: p_pnn01,p_pnn02,p_pnn03,p_pnn05,p_pnn06
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_pnni(p_pnn01,p_pnn02,p_pnn03,p_pnn05,p_pnn06,p_dbname)
FUNCTION s_del_pnni(p_pnn01,p_pnn02,p_pnn03,p_pnn05,p_pnn06,p_plant) 
   DEFINE p_pnn01   LIKE pnn_file.pnn01
   DEFINE p_pnn02   LIKE pnn_file.pnn02
   DEFINE p_pnn03   LIKE pnn_file.pnn03
   DEFINE p_pnn05   LIKE pnn_file.pnn05
   DEFINE p_pnn06   LIKE pnn_file.pnn06
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"pnni_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'pnni_file'), #FUN-A50102
             "   WHERE pnni01 = '",p_pnn01,"'"
 
   IF NOT cl_null(p_pnn02) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pnni02=",p_pnn02
      LET l_sql=l_sql," AND pnni02= '",p_pnn02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_pnn03) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pnni03=",p_pnn03
      LET l_sql=l_sql," AND pnni03= '",p_pnn03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_pnn05) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pnni05=",p_pnn05
      LET l_sql=l_sql," AND pnni05= '",p_pnn05,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_pnn06) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND pnni06=",p_pnn06
      LET l_sql=l_sql," AND pnni06= '",p_pnn06,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_pnni_p FROM l_sql
   EXECUTE del_pnni_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pnn01,"||",p_pnn02,"||",p_pnn03,
                   p_pnn05,"||",p_pnn06
         CALL s_errmsg("pnni01,pnni02,pnni03,pnn05,pnn06",l_sql,"DEL pnni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","pnni_file",p_pnn01,p_pnn02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別poni_file的資料
# Memo...........: p_poni-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_poni(p_poni,p_dbname)
FUNCTION s_ins_poni(p_poni,p_plant)  
   DEFINE p_poni    RECORD LIKE poni_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
   
 
   #預設值指派
   IF cl_null(p_poni.poni02) THEN
      LET p_poni.poni02 = 0
   END IF
   
   LET p_poni.poniplant=p_plant   #FUN-980012 add
   LET p_poni.ponilegal=l_legal   #FUN-980012 add
 
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO poni_file VALUES (p_poni.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"poni_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'poni_file'), #FUN-A50102
                "   VALUES (?,?,?,  ?,?,?,?)"   #FUN-980012 add  #FUN-C30057 add ? ?
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
      PREPARE ins_poni_p FROM l_sql
      EXECUTE ins_poni_p USING p_poni.poni01,
                               p_poni.poni02,
                               p_poni.ponislk01,
                               p_poni.poniplant, #FUN-980012
                               p_poni.ponilegal, #FUN-980012
                               p_poni.ponislk02, #FUN-C30057
                               p_poni.ponislk03  #FUN-C30057 
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_poni.poni01,"||",p_poni.poni02
         CALL s_errmsg("poni01,poni02",l_sql,"INS poni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","poni_file",p_poni.poni01,p_poni.poni02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別poni_file的資料
# Memo...........: p_pon01,p_pon02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_poni(p_pon01,p_pon02,p_dbname)
FUNCTION s_del_poni(p_pon01,p_pon02,p_plant) 
   DEFINE p_pon01   LIKE pon_file.pon01
   DEFINE p_pon02   LIKE pon_file.pon02
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"poni_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'poni_file'), #FUN-A50102
             "   WHERE poni01 = '",p_pon01,"'"
 
   IF NOT cl_null(p_pon02) THEN      #如果有給項次的話
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND poni02=",p_pon02
      LET l_sql=l_sql," AND poni02= '",p_pon02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_poni_p FROM l_sql
   EXECUTE del_poni_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_pon01,"||",p_pon02
         CALL s_errmsg("poni01,poni02",l_sql,"DEL poni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","poni_file",p_pon01,p_pon02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別sfci_file的資料
# Memo...........: p_sfci-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_sfci(p_sfci,p_dbname)
FUNCTION s_ins_sfci(p_sfci,p_plant)            #FUN-A50102
   DEFINE p_sfci    RECORD LIKE sfci_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant   LIKE type_file.chr20        #FUN-A50102
   DEFINE l_legal   LIKE oebi_file.oebilegal    #FUN-A50102	
   DEFINE l_dbs_tra LIKE type_file.chr21        #FUN-A50102
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF

   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
   #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO sfci_file VALUES (p_sfci.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"sfci_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'sfci_file'), #FUN-A50102
                "   VALUES (?,?,?,?,?,?)"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102          
      PREPARE ins_sfci_p FROM l_sql
      EXECUTE ins_sfci_p USING p_sfci.sfci01,
                               p_sfci.sfcislk01,
                               p_sfci.sfcislk02,
                               p_sfci.sfcislk03,
                               p_sfci.sfcislk04,
                               p_sfci.sfcislk05
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfci.sfci01
         CALL s_errmsg("sfci01",l_sql,"INS sfci_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sfci_file",p_sfci.sfci01,'',SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別sfci_file的資料
# Memo...........: p_sfc01
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_sfci(p_sfc01,p_dbname)
FUNCTION s_del_sfci(p_sfc01,p_plant)   #FUN-A50102
   DEFINE p_sfc01   LIKE sfc_file.sfc01
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-A50102
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017 
 
   #LET l_sql="DELETE FROM ",l_crossdb,"sfci_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(p_plant,'sfci_file'), #FUN-A50102
             "   WHERE sfci01 = '",p_sfc01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE del_sfci_p FROM l_sql
   EXECUTE del_sfci_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfc01,"||"
         CALL s_errmsg("sfci01",l_sql,"DEL sfci_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sfci_file",p_sfc01,'',SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別sgui_file的資料
# Memo...........: p_sgui-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_sgui(p_sgui,p_dbname)
FUNCTION s_ins_sgui(p_sgui,p_plant)  
   DEFINE p_sgui    RECORD LIKE sgui_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_sgui.sgui02) THEN
      LET p_sgui.sgui02 = 0
   END IF
   
   IF cl_null(p_sgui.sgui04) THEN
      LET p_sgui.sgui04 = 0
   END IF   
   
   #No.FUN-7B0018 add 080220 --begin
   IF cl_null(p_sgui.sguislk02) THEN
      LET p_sgui.sguislk02 = 0
   END IF   
 
   IF cl_null(p_sgui.sguislk03) THEN
      LET p_sgui.sguislk03 = 0
   END IF   
 
   IF cl_null(p_sgui.sguislk04) THEN
      LET p_sgui.sguislk04 = 0
   END IF   
 
   IF cl_null(p_sgui.sguislk06) THEN
      LET p_sgui.sguislk06 = 0
   END IF   
 
   IF cl_null(p_sgui.sguislk07) THEN
      LET p_sgui.sguislk07 = 0
   END IF   
 
   IF cl_null(p_sgui.sguislk08) THEN
      LET p_sgui.sguislk08 = 0
   END IF   
   #No.FUN-7B0018 add 080220 --end
 
   LET p_sgui.sguiplant=p_plant   #FUN-980012 add
   LET p_sgui.sguilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO sgui_file VALUES (p_sgui.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"sgui_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'sgui_file'), #FUN-A50102
                "   VALUES (?,?,?,?,?,?,?,?,?,?,?,  ?,?)"  #FUN-980012 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE ins_sgui_p FROM l_sql
      EXECUTE ins_sgui_p USING p_sgui.sgui01,
                               p_sgui.sgui02,
                               p_sgui.sgui04,
                               p_sgui.sguislk01,
                               p_sgui.sguislk02,
                               p_sgui.sguislk03,
                               p_sgui.sguislk04,
                               p_sgui.sguislk05,
                               p_sgui.sguislk06,
                               p_sgui.sguislk07,
                               p_sgui.sguislk08,
                               p_sgui.sguiplant,   #FUN-980012
                               p_sgui.sguilegal    #FUN-980012
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql = p_sgui.sgui01,"||",p_sgui.sgui02,"||",p_sgui.sgui04
         CALL s_errmsg("sgui01,sgui02,sgui04",l_sql,"INS sgui_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sgui_file",p_sgui.sgui01,p_sgui.sgui02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別sgui_file的資料
# Memo...........: p_sgu01,p_sgu02,p_sgu04
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_sgui(p_sgu01,p_sgu02,p_sgu04,p_dbname)
FUNCTION s_del_sgui(p_sgu01,p_sgu02,p_sgu04,p_plant) 
   DEFINE p_sgu01   LIKE sgu_file.sgu01
   DEFINE p_sgu02   LIKE sgu_file.sgu02
   DEFINE p_sgu04   LIKE sgu_file.sgu04
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"sgui_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sgui_file'), #FUN-A50102
             "   WHERE sgui01 = '",p_sgu01,"'"
             
   IF NOT cl_null(p_sgu02) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sgui02=",p_sgu02
      LET l_sql=l_sql," AND sgui02= '",p_sgu02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_sgu04) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sgui04=",p_sgu04
      LET l_sql=l_sql," AND sgui04= '",p_sgu04,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF           
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_sgui_p FROM l_sql
   EXECUTE del_sgui_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql = p_sgu01,"||",p_sgu02,"||",p_sgu04
         CALL s_errmsg("sgui01,sgui02,sgui04",l_sql,"DEL sgui_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sgui_file",p_sgu01,p_sgu02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 新增一筆行業別sgyi_file的資料
# Memo...........: p_sgyi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_sgyi(p_sgyi,p_dbname)
FUNCTION s_ins_sgyi(p_sgyi,p_plant)  
   DEFINE p_sgyi    RECORD LIKE sgyi_file.*
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
   
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
   
   #預設值指派
   IF cl_null(p_sgyi.sgyi02) THEN
      LET p_sgyi.sgyi02 = 0
   END IF
   
   IF cl_null(p_sgyi.sgyi03) THEN
      LET p_sgyi.sgyi03 = 0
   END IF   
 
#  IF cl_null(p_sgyi.sgyi05) THEN
#     LET p_sgyi.sgyi05 = 0
#  END IF   
 
   #No.FUN-7B0018 add 080220 --begin
   IF cl_null(p_sgyi.sgyislk01) THEN
      LET p_sgyi.sgyislk01 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk03) THEN
      LET p_sgyi.sgyislk03 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk04) THEN
      LET p_sgyi.sgyislk04 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk05) THEN
      LET p_sgyi.sgyislk05 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk06) THEN
      LET p_sgyi.sgyislk06 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk08) THEN
      LET p_sgyi.sgyislk08 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk09) THEN
      LET p_sgyi.sgyislk09 = 0
   END IF   
 
   IF cl_null(p_sgyi.sgyislk10) THEN
      LET p_sgyi.sgyislk10 = 0
   END IF   
   #No.FUN-7B0018 add 080220 --end

   #FUN-A70138--begin--add--------------
   IF cl_null(p_sgyi.sgyi012) THEN
      LET p_sgyi.sgyi012 = ' '
   END IF
   #FUN-A70138--end--add---------------
 
   LET p_sgyi.sgyiplant=p_plant   #FUN-980012 add
   LET p_sgyi.sgyilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN   #有新增欄位不需改 #No.TQC-860002
      INSERT INTO sgyi_file VALUES (p_sgyi.*)
   ELSE                        #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"sgyi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'sgyi_file'), #FUN-A50102
         #      "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #No.FUN-830121
                "   VALUES (?,?,?,?,?,?,?,?,?,?,?,?,  ?,?,?)"         #No.FUN-830121 #FUN-980012 add #FUN-A70138
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102	           
      PREPARE ins_sgyi_p FROM l_sql
      EXECUTE ins_sgyi_p USING p_sgyi.sgyi01,
                               p_sgyi.sgyi02,
                               p_sgyi.sgyi03,
                               p_sgyi.sgyi05,
                               p_sgyi.sgyislk01,
                         #     p_sgyi.sgyislk02,   #No.FUN-83121
                               p_sgyi.sgyislk03,
                               p_sgyi.sgyislk04,
                               p_sgyi.sgyislk05,
                               p_sgyi.sgyislk06,
                         #     p_sgyi.sgyislk07,   #No.FUN-830121
                               p_sgyi.sgyislk08,
                               p_sgyi.sgyislk09,
                               p_sgyi.sgyislk10,
                               p_sgyi.sgyiplant,   #FUN-980012
                               p_sgyi.sgyilegal,   #FUN-980012
                               p_sgyi.sgyi012      #FUN-A70138
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql = p_sgyi.sgyi01,"||",p_sgyi.sgyi02,"||",
                     p_sgyi.sgyi03,"||",p_sgyi.sgyi05,"||",p_sgyi.sgyi012 #FUN-A70138
         CALL s_errmsg("sgyi01,sgyi02,sgyi03,sgyi05",l_sql,"INS sgyi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sgyi_file",p_sgyi.sgyi01,p_sgyi.sgyi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080130 add --begin
# Descriptions...: 刪除一筆icd行業別sgyi_file的資料
# Memo...........: p_sgy01,p_sgy02,p_sgy03,p_sgy05
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
 
#FUNCTION s_del_sgyi(p_sgy01,p_sgy02,p_sgy03,p_sgy05,p_dbname)
FUNCTION s_del_sgyi(p_sgy01,p_sgy02,p_sgy03,p_sgy05,p_sgy012,p_plant) #FUN-A70138
   DEFINE p_sgy01   LIKE sgy_file.sgy01
   DEFINE p_sgy02   LIKE sgy_file.sgy02
   DEFINE p_sgy03   LIKE sgy_file.sgy03
   DEFINE p_sgy05   LIKE sgy_file.sgy05
   DEFINE p_sgy012  LIKE sgy_file.sgy012  #FUN-A70138
   DEFINE p_dbname  LIKE azp_file.azp03
   DEFINE l_sql     STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   IF s_industry('icd') THEN
      RETURN TRUE
   END IF
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"sgyi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sgyi_file'), #FUN-A50102
             "  WHERE sgyi01 = '",p_sgy01,"'"
   
   IF NOT cl_null(p_sgy02) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sgyi02=",p_sgy02
      LET l_sql=l_sql," AND sgyi02= '",p_sgy02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_sgy03) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sgyi03=",p_sgy03
      LET l_sql=l_sql," AND sgyi03= '",p_sgy03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF           
   
   IF NOT cl_null(p_sgy05) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND sgyi05=",p_sgy05
      LET l_sql=l_sql," AND sgyi05= '",p_sgy05,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   #FUN-A70138-begin--add----------
   IF NOT cl_null(p_sgy012) THEN
      LET l_sql=l_sql," AND sgyi012= '",p_sgy012,"'"
   END IF
   #FUN-A70138--end--add-------------
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_sgyi_p FROM l_sql
   EXECUTE del_sgyi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql = p_sgy01,"||",p_sgy02,"||",p_sgy03,"||",p_sgy05,"||",p_sgy012  #FUN-A70138
         CALL s_errmsg("sgyi01,sgyi02,sgyi03,sgyi05,sgyi012",l_sql,"DEL sgyi_file",SQLCA.sqlcode,1) #FUN-A70138
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sgyi_file",p_sgy01,p_sgy02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-7B0018 080130 add --end
 
#FUN-7B0018 080218 add --begin 
# Descriptions...: 新增一筆行業別oeqi_file的資料
# Memo...........: p_oeqi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_oeqi(p_oeqi,p_dbname)
FUNCTION s_ins_oeqi(p_oeqi,p_plant)  
   DEFINE p_oeqi RECORD LIKE oeqi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_oeqi.oeqi02) THEN
      LET p_oeqi.oeqi02 = 0
   END IF
   
   IF cl_null(p_oeqi.oeqi03) THEN
      LET p_oeqi.oeqi03 = 0
   END IF   
 
   IF cl_null(p_oeqi.oeqiicd02a) THEN
      LET p_oeqi.oeqiicd02a = 0
   END IF   
 
   IF cl_null(p_oeqi.oeqiicd02b) THEN
      LET p_oeqi.oeqiicd02b = 0
   END IF   
 
   LET p_oeqi.oeqiplant=p_plant   #FUN-980012 add
   LET p_oeqi.oeqilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO oeqi_file VALUES (p_oeqi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"oeqi_file ",
       LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'oeqi_file'), #FUN-A50102
                "   VALUES (?,?,?,?,?,?,?,?,?,?,?,  ?,?)"  #FUN-980012 add
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102               
      PREPARE ins_oeqi_p FROM l_sql
      EXECUTE ins_oeqi_p USING p_oeqi.oeqi01,
                               p_oeqi.oeqi02,
                               p_oeqi.oeqi03,
                               p_oeqi.oeqiicd01a,
                               p_oeqi.oeqiicd01b,
                               p_oeqi.oeqiicd02a,
                               p_oeqi.oeqiicd02b,
                               p_oeqi.oeqiicd03a,
                               p_oeqi.oeqiicd03b,
                               p_oeqi.oeqiicd04a,
                               p_oeqi.oeqiicd04b,
                               p_oeqi.oeqiplant,   #FUN-980012
                               p_oeqi.oeqilegal    #FUN-980012
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_oeqi.oeqi01,"||",p_oeqi.oeqi02,"||",p_oeqi.oeqi03
         CALL s_errmsg("oeqi01,oeqi02,oeqi02",l_sql,"INS oeqi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","oeqi_file",p_oeqi.oeqi01,p_oeqi.oeqi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-7B0018 080218 add --end
 
#FUN-7B0018 080218 add --begin
# Descriptions...: 刪除一筆icd行業別oeqi_file的資料
# Memo...........: p_oeq01,p_oeq02,p_oeq03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_oeqi(p_oeq01,p_oeq02,p_oeq03,p_dbname)
FUNCTION s_del_oeqi(p_oeq01,p_oeq02,p_oeq03,p_plant)  
   DEFINE p_oeq01 LIKE oeq_file.oeq01
   DEFINE p_oeq02 LIKE oeq_file.oeq02
   DEFINE p_oeq03 LIKE oeq_file.oeq03
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"oeqi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'oeqi_file'), #FUN-A50102
             "  WHERE oeqi01 = '",p_oeq01,"'"
             
   IF NOT cl_null(p_oeq02) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND oeqi02=",p_oeq02
      LET l_sql=l_sql," AND oeqi02= '",p_oeq02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   
   IF NOT cl_null(p_oeq03) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND oeqi03=",p_oeq03
      LET l_sql=l_sql," AND oeqi03= '",p_oeq03,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_oeqi_p FROM l_sql
   EXECUTE del_oeqi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_oeq01,"||",p_oeq02,"||",p_oeq03
         CALL s_errmsg("oeqi01,oeqi02,oeqi03",l_sql,"DEL oeqi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","oeqi_file",p_oeq01,p_oeq02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-7B0018 080218 add --end
 
#FUN-7B0018 080218 add --begin 
# Descriptions...: 新增一筆行業別rvvi_file的資料
# Memo...........: p_rvvi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_ins_rvvi(p_rvvi,p_dbname)
FUNCTION s_ins_rvvi(p_rvvi,p_plant) 
   DEFINE p_rvvi RECORD LIKE rvvi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        #FUN-980094
   DEFINE l_legal    LIKE oebi_file.oebilegal    #FUN-980094	
   DEFINE l_dbs_tra  LIKE type_file.chr21        #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
   
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #預設值指派
   IF cl_null(p_rvvi.rvvi02) THEN
      LET p_rvvi.rvvi02 = 0
   END IF
#CHI-C80009---add---START
   IF cl_null(p_rvvi.rvviicd02) THEN
      LET p_rvvi.rvviicd02 = ' '
   END IF
   IF cl_null(p_rvvi.rvviicd05) THEN
      LET p_rvvi.rvviicd05 = ' '
   END IF 
#CHI-C80009---add-----END
   
   LET p_rvvi.rvviplant=p_plant   #FUN-980012 add
   LET p_rvvi.rvvilegal=l_legal   #FUN-980012 add
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改 #No.TQC-860002
      INSERT INTO rvvi_file VALUES (p_rvvi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
      #LET l_sql="INSERT INTO ",l_crossdb,"rvvi_file ",
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'rvvi_file'), #FUN-A50102
                "   VALUES (?,?,?,?,?,?,?,?,?,  ?,?,?,?)"   #FUN-980012 add  #FUN-B90104 add
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE ins_rvvi_p FROM l_sql
      EXECUTE ins_rvvi_p USING p_rvvi.rvvi01,
                               p_rvvi.rvvi02,
                               p_rvvi.rvviicd01,
                               p_rvvi.rvviicd02,
                               p_rvvi.rvviicd03,
                               p_rvvi.rvviicd04,
                               p_rvvi.rvviicd05,
                               p_rvvi.rvviicd06,
                               p_rvvi.rvviicd07,
                               p_rvvi.rvviplant,  #FUN-980012
                               p_rvvi.rvvilegal,  #FUN-980012
                               p_rvvi.rvvislk01,  #FUN-B90104
                               p_rvvi.rvvislk02   #FUN-980012
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_rvvi.rvvi01,"||",p_rvvi.rvvi02
         CALL s_errmsg("rvvi01,rvvi02",l_sql,"INS rvvi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","rvvi_file",p_rvvi.rvvi01,p_rvvi.rvvi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-7B0018 080218 add --end
 
#FUN-7B0018 080218 add --begin
# Descriptions...: 刪除一筆icd行業別rvvi_file的資料
# Memo...........: p_rvv01,p_rvv02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
#FUNCTION s_del_rvvi(p_rvv01,p_rvv02,p_dbname)
FUNCTION s_del_rvvi(p_rvv01,p_rvv02,p_plant)  
   DEFINE p_rvv01 LIKE rvv_file.rvv01
   DEFINE p_rvv02 LIKE rvv_file.rvv02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  #FUN-980094
   DEFINE l_dbs_tra       LIKE type_file.chr21 #FUN-980094
 
   #TQC-AA0112--begin--add-----
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   #TQC-AA0112--end--edd------
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
  #LET l_crossdb = s_dbstring(p_dbname)     #FUN-820017
   LET l_crossdb = s_dbstring(l_dbs_tra)    #FUN-980094
 
   #LET l_sql="DELETE FROM ",l_crossdb,"rvvi_file ",
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'rvvi_file'), #FUN-A50102
             "  WHERE rvvi01 = '",p_rvv01,"'"
             
   IF NOT cl_null(p_rvv02) THEN
      #No.FUN-7B0018 modify 080220 --begin
#     LET l_sql=l_sql," AND rvvi02=",p_rvv02
      LET l_sql=l_sql," AND rvvi02= '",p_rvv02,"'"
      #No.FUN-7B0018 modify 080220 --end
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980094
   PREPARE del_rvvi_p FROM l_sql
   EXECUTE del_rvvi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_rvv01,"||",p_rvv02
         CALL s_errmsg("rvvi01,rvvi02",l_sql,"DEL rvvi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","rvvi_file",p_rvv01,p_rvv02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#FUN-7B0018 080218 add --end

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別inbi_file的資料
# Memo...........: p_inbi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_inbi(p_inbi,p_plant)  
   DEFINE p_inbi RECORD LIKE inbi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_inbi.inbiicd028 ) THEN
      LET p_inbi.inbiicd028=' '
   END IF
   IF cl_null(p_inbi.inbiicd029) THEN
      LET p_inbi.inbiicd029=' '
   END IF   
 
   LET p_inbi.inbiplant=p_plant   
   LET p_inbi.inbilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO inbi_file VALUES (p_inbi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'inbi_file'), 
                "   VALUES (?,?,  ?,?,  ?,?, ?,?)"  #FUN-C20101---MODIFY----- #TQC-C20418 add , 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_inbi_p FROM l_sql
      EXECUTE ins_inbi_p USING p_inbi.inbi01,
                               p_inbi.inbi03,
                               p_inbi.inbiicd028,
                               p_inbi.inbiicd029,
                               p_inbi.inbilegal,
                               p_inbi.inbiplant,
                               p_inbi.inbislk01,    #TQC-C20418 add
                               p_inbi.inbislk02     #TQC-C20418 add  
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_inbi.inbi01,"||",p_inbi.inbi03
         CALL s_errmsg("inbi01,inbi03",l_sql,"INS inbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","inbi_file",p_inbi.inbi01,p_inbi.inbi03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別inbi_file的資料
# Memo...........: p_inbi01,p_inbi03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_inbi(p_inb01,p_inb03,p_plant)  
   DEFINE p_inb01 LIKE inb_file.inb01
   DEFINE p_inb03 LIKE inb_file.inb03
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'inbi_file'), 
             "   WHERE inbi01 = '",p_inb01,"'"
   IF NOT cl_null(p_inb03) THEN #如果有給項次的話
      LET l_sql=l_sql," AND inbi03= '",p_inb03,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_inbi_p FROM l_sql
   EXECUTE del_inbi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_inb01,"||",p_inb03
         CALL s_errmsg("inbi01,inbi03",l_sql,"DEL inbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","inbi_file",p_inb01,p_inb03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別sfvi_file的資料
# Memo...........: p_sfvi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_sfvi(p_sfvi,p_plant)  
   DEFINE p_sfvi RECORD LIKE sfvi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_sfvi.sfviicd028 ) THEN
      LET p_sfvi.sfviicd028=' '
   END IF
   IF cl_null(p_sfvi.sfviicd029) THEN
      LET p_sfvi.sfviicd029=' '
   END IF   
 
   LET p_sfvi.sfviplant=p_plant   
   LET p_sfvi.sfvilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO sfvi_file VALUES (p_sfvi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'sfvi_file'), 
                "   VALUES (?,?,  ?,?,  ?,?)"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_sfvi_p FROM l_sql
      EXECUTE ins_sfvi_p USING p_sfvi.sfvi01,
                               p_sfvi.sfvi03,
                               p_sfvi.sfviicd028,
                               p_sfvi.sfviicd029,                               
                               p_sfvi.sfvilegal,
                               p_sfvi.sfviplant
                                 
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfvi.sfvi01,"||",p_sfvi.sfvi03
         CALL s_errmsg("sfvi01,sfvi03",l_sql,"INS sfvi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sfvi_file",p_sfvi.sfvi01,p_sfvi.sfvi03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別sfvi_file的資料
# Memo...........: p_sfvi01,p_sfvi03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_sfvi(p_sfv01,p_sfv03,p_plant)  
   DEFINE p_sfv01 LIKE sfv_file.sfv01
   DEFINE p_sfv03 LIKE sfv_file.sfv03
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sfvi_file'), 
             "   WHERE sfvi01 = '",p_sfv01,"'"
   IF NOT cl_null(p_sfv03) THEN #如果有給項次的話
      LET l_sql=l_sql," AND sfvi03= '",p_sfv03,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_sfvi_p FROM l_sql
   EXECUTE del_sfvi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfv01,"||",p_sfv03
         CALL s_errmsg("sfvi01,sfvi03",l_sql,"DEL sfvi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sfvi_file",p_sfv01,p_sfv03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別imni_file的資料
# Memo...........: p_imni-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_imni(p_imni,p_plant)  
   DEFINE p_imni RECORD LIKE imni_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_imni.imniicd028 ) THEN
      LET p_imni.imniicd028=' '
   END IF
   IF cl_null(p_imni.imniicd029) THEN
      LET p_imni.imniicd029=' '
   END IF   
 
   LET p_imni.imniplant=p_plant   
   LET p_imni.imnilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO imni_file VALUES (p_imni.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'imni_file'), 
                "   VALUES (?,?,  ?,?,  ?,?)"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_imni_p FROM l_sql
      EXECUTE ins_imni_p USING p_imni.imni01,
                               p_imni.imni02,
                               p_imni.imniicd028,
                               p_imni.imniicd029,
                               p_imni.imnilegal,                               
                               p_imni.imniplant
                                 
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_imni.imni01,"||",p_imni.imni02
         CALL s_errmsg("imni01,imni02",l_sql,"INS imni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","imni_file",p_imni.imni01,p_imni.imni02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別imni_file的資料
# Memo...........: p_imni01,p_imni02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_imni(p_imn01,p_imn02,p_plant)  
   DEFINE p_imn01 LIKE imn_file.imn01
   DEFINE p_imn02 LIKE imn_file.imn02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'imni_file'), 
             "   WHERE imni01 = '",p_imn01,"'"
   IF NOT cl_null(p_imn02) THEN #如果有給項次的話
      LET l_sql=l_sql," AND imni02= '",p_imn02,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_imni_p FROM l_sql
   EXECUTE del_imni_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_imn01,"||",p_imn02
         CALL s_errmsg("imni01,imni02",l_sql,"DEL imni_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","imni_file",p_imn01,p_imn02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別impi_file的資料
# Memo...........: p_impi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_impi(p_impi,p_plant)  
   DEFINE p_impi RECORD LIKE impi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_impi.impiicd028 ) THEN
      LET p_impi.impiicd028=' '
   END IF
   IF cl_null(p_impi.impiicd029) THEN
      LET p_impi.impiicd029=' '
   END IF   
 
   LET p_impi.impiplant=p_plant   
   LET p_impi.impilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO impi_file VALUES (p_impi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'impi_file'), 
                "   VALUES (?,?,  ?,?,  ?,?)"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_impi_p FROM l_sql
      EXECUTE ins_impi_p USING p_impi.impi01,
                               p_impi.impi02,
                               p_impi.impiicd028,
                               p_impi.impiicd029,
                               p_impi.impilegal,
                               p_impi.impiplant  
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_impi.impi01,"||",p_impi.impi02
         CALL s_errmsg("impi01,impi02",l_sql,"INS impi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","impi_file",p_impi.impi01,p_impi.impi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別impi_file的資料
# Memo...........: p_impi01,p_impi02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_impi(p_imp01,p_imp02,p_plant)  
   DEFINE p_imp01 LIKE imp_file.imp01
   DEFINE p_imp02 LIKE imp_file.imp02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'impi_file'), 
             "   WHERE impi01 = '",p_imp01,"'"
   IF NOT cl_null(p_imp02) THEN #如果有給項次的話
      LET l_sql=l_sql," AND impi02= '",p_imp02,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_impi_p FROM l_sql
   EXECUTE del_impi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_imp01,"||",p_imp02
         CALL s_errmsg("impi01,impi02",l_sql,"DEL impi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","impi_file",p_imp01,p_imp02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別imqi_file的資料
# Memo...........: p_imqi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_imqi(p_imqi,p_plant)  
   DEFINE p_imqi RECORD LIKE imqi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_imqi.imqiicd028 ) THEN
      LET p_imqi.imqiicd028=' '
   END IF
   IF cl_null(p_imqi.imqiicd029) THEN
      LET p_imqi.imqiicd029=' '
   END IF   
 
   LET p_imqi.imqiplant=p_plant   
   LET p_imqi.imqilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO imqi_file VALUES (p_imqi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'imqi_file'), 
                "   VALUES (?,?,  ?,?,  ?,?)"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_imqi_p FROM l_sql
      EXECUTE ins_imqi_p USING p_imqi.imqi01,
                               p_imqi.imqi02,
                               p_imqi.imqiicd028,
                               p_imqi.imqiicd029,
                               p_imqi.imqilegal,
                               p_imqi.imqiplant  
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_imqi.imqi01,"||",p_imqi.imqi02
         CALL s_errmsg("imqi01,imqi02",l_sql,"INS imqi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","imqi_file",p_imqi.imqi01,p_imqi.imqi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別imqi_file的資料
# Memo...........: p_imqi01,p_imqi02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_imqi(p_imq01,p_imq02,p_plant)  
   DEFINE p_imq01 LIKE imq_file.imq01
   DEFINE p_imq02 LIKE imq_file.imq02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'imqi_file'), 
             "   WHERE imqi01 = '",p_imq01,"'"
   IF NOT cl_null(p_imq02) THEN #如果有給項次的話
      LET l_sql=l_sql," AND imqi02= '",p_imq02,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_imqi_p FROM l_sql
   EXECUTE del_imqi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_imq01,"||",p_imq02
         CALL s_errmsg("imqi01,imqi02",l_sql,"DEL imqi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","imqi_file",p_imq01,p_imq02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別ohbi_file的資料
# Memo...........: p_ohbi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_ohbi(p_ohbi,p_plant)  
   DEFINE p_ohbi RECORD LIKE ohbi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_ohbi.ohbiicd028 ) THEN
      LET p_ohbi.ohbiicd028=' '
   END IF
   IF cl_null(p_ohbi.ohbiicd029) THEN
      LET p_ohbi.ohbiicd029=' '
   END IF   
 
   LET p_ohbi.ohbiplant=p_plant   
   LET p_ohbi.ohbilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO ohbi_file VALUES (p_ohbi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'ohbi_file'), 
                "   VALUES (?,?,  ?,?,  ?,?,  ?,?)"                   #FUN-B90104 add ,?,?
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_ohbi_p FROM l_sql
      EXECUTE ins_ohbi_p USING p_ohbi.ohbi01,
                               p_ohbi.ohbi03,
                               p_ohbi.ohbiicd028,
                               p_ohbi.ohbiicd029,
                               p_ohbi.ohbilegal,
                               p_ohbi.ohbiplant,
                               p_ohbi.ohbislk01,         #FUN-B90104 add
                               p_ohbi.ohbislk02          #FUN-B90104 add
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_ohbi.ohbi01,"||",p_ohbi.ohbi03
         CALL s_errmsg("ohbi01,ohbi03",l_sql,"INS ohbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","ohbi_file",p_ohbi.ohbi01,p_ohbi.ohbi03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別ohbi_file的資料
# Memo...........: p_ohbi01,p_ohbi03
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_ohbi(p_ohb01,p_ohb03,p_plant)  
   DEFINE p_ohb01 LIKE ohb_file.ohb01
   DEFINE p_ohb03 LIKE ohb_file.ohb03
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'ohbi_file'), 
             "   WHERE ohbi01 = '",p_ohb01,"'"
   IF NOT cl_null(p_ohb03) THEN #如果有給項次的話
      LET l_sql=l_sql," AND ohbi03= '",p_ohb03,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_ohbi_p FROM l_sql
   EXECUTE del_ohbi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_ohb01,"||",p_ohb03
         CALL s_errmsg("ohbi01,ohbi03",l_sql,"DEL ohbi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","ohbi_file",p_ohb01,p_ohb03,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別sfsi_file的資料
# Memo...........: p_sfsi-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_sfsi(p_sfsi,p_plant)  
   DEFINE p_sfsi RECORD LIKE sfsi_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_sfsi.sfsiicd028 ) THEN
      LET p_sfsi.sfsiicd028=' '
   END IF
   IF cl_null(p_sfsi.sfsiicd029) THEN
      LET p_sfsi.sfsiicd029=' '
   END IF   
 
   LET p_sfsi.sfsiplant=p_plant   
   LET p_sfsi.sfsilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO sfsi_file VALUES (p_sfsi.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'sfsi_file'), 
                "   VALUES (?,?,  ?,?,  ?,?)"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_sfsi_p FROM l_sql
      EXECUTE ins_sfsi_p USING p_sfsi.sfsi01,
                               p_sfsi.sfsi02,
                               p_sfsi.sfsiicd028,
                               p_sfsi.sfsiicd029,
                               p_sfsi.sfsilegal,
                               p_sfsi.sfsiplant  
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfsi.sfsi01,"||",p_sfsi.sfsi02
         CALL s_errmsg("sfsi01,sfsi02",l_sql,"INS sfsi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sfsi_file",p_sfsi.sfsi01,p_sfsi.sfsi02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別sfsi_file的資料
# Memo...........: p_sfsi01,p_sfsi02
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_sfsi(p_sfs01,p_sfs02,p_plant)  
   DEFINE p_sfs01 LIKE sfs_file.sfs01
   DEFINE p_sfs02 LIKE sfs_file.sfs02
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sfsi_file'), 
             "   WHERE sfsi01 = '",p_sfs01,"'"
   IF NOT cl_null(p_sfs02) THEN #如果有給項次的話
      LET l_sql=l_sql," AND sfsi02= '",p_sfs02,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_sfsi_p FROM l_sql
   EXECUTE del_sfsi_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfs01,"||",p_sfs02
         CALL s_errmsg("sfsi01,sfsi02",l_sql,"DEL sfsi_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sfsi_file",p_sfs01,p_sfs02,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--

#FUN-B30187 --START--
# Descriptions...: 新增一筆行業別sfei_file的資料
# Memo...........: p_sfei-Record
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_ins_sfei(p_sfei,p_plant)  
   DEFINE p_sfei RECORD LIKE sfei_file.*
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant    LIKE type_file.chr20        
   DEFINE l_legal    LIKE oebi_file.oebilegal    	
   DEFINE l_dbs_tra  LIKE type_file.chr21        
   
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF
   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
   
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   #預設值指派
   IF cl_null(p_sfei.sfeiicd028 ) THEN
      LET p_sfei.sfeiicd028=' '
   END IF
   IF cl_null(p_sfei.sfeiicd029) THEN
      LET p_sfei.sfeiicd029=' '
   END IF   
 
   LET p_sfei.sfeiplant=p_plant   
   LET p_sfei.sfeilegal=l_legal   
 
   IF cl_null(l_crossdb) THEN  #有新增欄位不需改
      INSERT INTO sfei_file VALUES (p_sfei.*)
   ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫      
      LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'sfei_file'), 
                "   VALUES (?,?,  ?,?,  ?,?)"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE ins_sfei_p FROM l_sql
      EXECUTE ins_sfei_p USING p_sfei.sfei02,
                               p_sfei.sfei28,
                               p_sfei.sfeiicd028,
                               p_sfei.sfeiicd029,
                               p_sfei.sfeilegal,
                               p_sfei.sfeiplant  
   END IF
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfei.sfei02,"||",p_sfei.sfei28
         CALL s_errmsg("sfei02,sfei28",l_sql,"INS sfei_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("ins","sfei_file",p_sfei.sfei02,p_sfei.sfei28,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION

# Descriptions...: 刪除一筆icd行業別sfei_file的資料
# Memo...........: p_sfei02,p_sfei28
#                  如果有key值傳null的,函數會自動判斷拿掉那個key值的條件
#                  p_dbname- DB name,不含"."或":",若是無跨資料庫需傳入空白
FUNCTION s_del_sfei(p_sfe02,p_sfe28,p_plant)  
   DEFINE p_sfe02 LIKE sfe_file.sfe02
   DEFINE p_sfe28 LIKE sfe_file.sfe28
   DEFINE p_dbname LIKE azp_file.azp03
   DEFINE l_sql STRING
   DEFINE l_crossdb STRING
   DEFINE p_plant        LIKE type_file.chr20  
   DEFINE l_dbs_tra      LIKE type_file.chr21  
 
   IF cl_null(p_plant) THEN
      LET p_plant = g_plant
   END IF   
   #依傳入的PLANT變數取得TRANS DB 
   LET g_plant_new = p_plant CLIPPED  
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_new Global變數中
   LET l_dbs_tra = g_dbs_tra
 
   LET l_crossdb = s_dbstring(l_dbs_tra)    
 
   LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'sfei_file'), 
             "   WHERE sfei02 = '",p_sfe02,"'"
   IF NOT cl_null(p_sfe28) THEN #如果有給項次的話
      LET l_sql=l_sql," AND sfei28= '",p_sfe28,"'"
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
   PREPARE del_sfei_p FROM l_sql
   EXECUTE del_sfei_p
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         LET l_sql=p_sfe02,"||",p_sfe28
         CALL s_errmsg("sfei02,sfei28",l_sql,"DEL sfei_file",SQLCA.sqlcode,1)
         LET g_totsuccess='N'
      ELSE
         CALL cl_err3("del","sfei_file",p_sfe02,p_sfe28,SQLCA.sqlcode,"","",1)
      END IF
      RETURN FALSE                        
   END IF
   RETURN TRUE                            
END FUNCTION
#FUN-B30187 --END--
#TQC-8A0065 
