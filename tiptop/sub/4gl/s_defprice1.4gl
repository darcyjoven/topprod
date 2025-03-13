# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_defprice1.4gl
# Descriptions...: 取得採購單價
# Date & Author..: 06/03/08 By vivien
# Usage..........: LET l_price,lt_price=s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_dbs)
# Input Parameter: p_part   料件編號 
#                  p_vender 供應商編號
#                  p_curr   幣別
#                  p_date   有效日期
#                  p_qty    數量                            #NO:7178
#                  p_task   作業編號==>一般採購單,委外採購單 傳''       #NO:7178
#                                   ==>製程委外採購單        傳作業編號 #NO:7178
#                  p_tax    稅別
#                  p_rate   稅率
#                  p_type   資料型態
#                  p_dbs    運營中心別
# Return code....: l_price,lt_price 未稅單價,含稅單價 
# Modify.........: No.FUN-670099 06/08/11 By Nicola 價格管理修改
# Modify.........: No.FUN-680147 06/09/18 By czl 欄位型態定義,改為LIKE
# Modify.........: NO.MOD-740393 07/04/23 BY yiting 如果遇到錯誤時直接RETURN，會產生錯誤
# Modify.........: No.TQC-7B0011 07/11/01 By wujie  采用核價檔取價，當一顆新料在同一天有兩筆核價資料，則自動帶出的采購單價是第一筆的核價金額。
#                                                   現修改為，出現以上情況時，選擇單號最大的那筆
# Modify.........: No.MOD-7B0156 07/11/16 By claire 語法調整
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0014 07/12/18 By bnlent 新增ICD行業取價功能
# Modify.........: No.MOD-840474 08/04/23 By claire 最終供應商的料件供應商的管制要參考料件設定ima915
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.CHI-920050 09/02/12 By jan 修改sql語句
# Modify.........: No.FUN-930148 09/03/24 by ve007 采購取價和定價功能修改 `
# Modify.........: No.TQC-940165 09/04/27 By Carrier 取折扣錯誤
# Modify.........: No.TQC-930026 09/05/19 By xiaofeizhu 增加一個參數
# Modify.........: No.FUN-980094 09/09/14 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.MOD-990185 09/09/21 By Dido 增加跨營運中心函數 
# Modify.........: No:MOD-A10041 10/01/07 By Dido 最終供應商取價應以當站資料庫為主
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:MOD-AC0040 10/12/06 By sabrina p_dbs要改為LIKE azp_file.azp03
# Modify.........: No.FUN-B30192 11/05/09 By shenyang 改icb05為imaicd14 
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUN-980094 傳入的db變數應該成傳入plant 變數---------------------(S)
#FUNCTION s_defprice1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_dbs,p_type)
#FUNCTION s_defprice1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_dbs,p_type,p_unit,p_term,p_payment,p_cell)  #No.FUN-930148   #No.TQC-930026 Add p_cell
FUNCTION s_defprice1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_plant,p_type,p_unit,p_term,p_payment,p_cell) #FUN-980094
#FUN-980094 傳入的db變數應該成傳入plant 變數---------------------(E)
DEFINE p_part     LIKE pmh_file.pmh01,
       p_vender   LIKE pmh_file.pmh02,
       p_curr     LIKE pmh_file.pmh13,
       p_date     LIKE type_file.dat,          #No.FUN-680147 DATE
       p_qty      LIKE pmn_file.pmn20,#NO:7178
       p_task     LIKE pmj_file.pmj10,#NO:7178
       p_type     LIKE pmh_file.pmh22,#No.FUN-670099
       p_unit     LIKE pnn_file.pnn12,   #No.FUN-930148
       p_term     LIKE pof_file.pof01,   #No.FUN-930148
       p_payment  LIKE pof_file.pof05,   #No.FUN-930148
       p_cell     LIKE pmh_file.pmh23,#No.TQC-930026 add
       l_ima53    LIKE ima_file.ima53,
       l_ima531   LIKE ima_file.ima531,
       l_pmh12    LIKE pmh_file.pmh12,
       l_pmj02    LIKE pmj_file.pmj02, 
       l_pmj07    LIKE pmj_file.pmj07, 
       l_pmj09    LIKE pmj_file.pmj09, 
       l_price    LIKE ima_file.ima53,
      #l_sql      LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(1000)	#MOD-990185 mark
       l_sql      STRING,                      #MOD-990185
       l_sql2     STRING,		       #MOD-990185
       p_tax      LIKE gec_file.gec01,
       p_rate     LIKE gec_file.gec04,
      #p_dbs      LIKE azp_file.azp01,         #MOD-AC0040 mark  
       p_dbs      LIKE azp_file.azp03,         #MOD-AC0040 add 
       p_plant    LIKE type_file.chr20, #FUN-980094
       l_gec04    LIKE gec_file.gec04,   #稅率
       l_pmh17    LIKE pmh_file.pmh17,
       l_pmh18    LIKE pmh_file.pmh18,
       l_pmh19    LIKE pmh_file.pmh19,
       l_pmj07t   LIKE pmj_file.pmj07t, 
       lt_price   LIKE pmh_file.pmh19,
       lt_j07r05  LIKE pmj_file.pmj07, #若分量計價pmi05='Y',lt_j07r05=pmr05t
                                       #若分量計價pmi05='N',lt_j07r05=pmj07t
       lastt_price LIKE pmh_file.pmh12,
       l_tax      LIKE gec_file.gec01, #TQC-620035  稅別
       last_price LIKE pmh_file.pmh12,
       l_pmi01    LIKE pmi_file.pmi01,
       l_pmi05    LIKE pmi_file.pmi05,
       l_pmi08    LIKE pmi_file.pmi08,  #TQC-620035 稅別
       l_pmi081   LIKE pmi_file.pmi081, #TQC-620035 稅率
       l_j07r05   LIKE pmj_file.pmj07   #若分量計價pmi05='Y',l_j07r05=pmr05
                                        #若分量計價pmi05='N',l_j07r05=pmj07
DEFINE l_t        LIKE type_file.num5   #No.FUN-680147 SMALLINT         
DEFINE l_rate     LIKE azj_file.azj03
DEFINE l_flag     LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01) #FUN-610018
DEFINE l_msg      LIKE type_file.chr1000  #No.FUN-680147 VARCHAR(50)
DEFINE l_ima915   LIKE ima_file.ima915, #MOD-840474  
       l_chk      LIKE type_file.chr1   #MOD-840474
DEFINE l_pnz03    LIKE pnz_file.pnz03   #No.FUN-930148       
DEFINE l_sma83    LIKE sma_file.sma83   #MOD-A10041  
 
    LET l_pmh12=null LET l_pmj07=null LET l_pmj09=null
    LET l_pmh19=null LET l_pmj07t=null   #No.FUN-610018
    LET l_flag = 'N'                     #No.FUN-610018 Default 初值
 
   ##-----No.FUN-670099-----
   #IF cl_null(p_task) THEN 
   #   LET p_type = "1"
   #ELSE
   #   LET p_type = "2"
   #END IF
    IF cl_null(p_task) THEN
       LET p_task=" "
    END IF
   ##-----No.FUN-670099 END----- 
 
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(S)
   LET g_plant_new = p_plant CLIPPED
   CALL s_getdbs()
   LET p_dbs = g_dbs_new
 
   CALL s_gettrandbs()       #取得TRANS DB ->存在 g_dbs_tra Global變數中
   #FUN-980094 依傳入的PLANT變數取得TRANS DB ----------(E)
 
    #No.FUN-610018 --start--
    SELECT COUNT(*) INTO l_t 
    FROM azp_file
  # WHERE azp01=p_dbs
    WHERE azp01=p_plant  #FUN-980094
    IF cl_null(l_t) THEN 
       CALL cl_err(p_dbs,g_errno,0) 
    END IF
    #MOD-840474-begin-add
    LET l_chk='N'
    LET l_sql="SELECT ima915", 
              #"  FROM ",s_dbstring(p_dbs CLIPPED),"ima_file ",   #No.FUN-930148
              "  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102          
              " WHERE ima01 = '",p_part,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ima_p1 FROM l_sql                                                                                          
    IF SQLCA.SQLCODE THEN CALL cl_err('ima_p1',SQLCA.SQLCODE,1) END IF  
    DECLARE ima_c1 CURSOR FOR ima_p1          
    OPEN ima_c1                 
    FETCH ima_c1 INTO l_ima915
    IF SQLCA.SQLCODE = 100 THEN
       LET l_msg=p_dbs CLIPPED,p_part CLIPPED
       CALL cl_err(l_msg CLIPPED,"mfg3403",1)
       LET g_success='N'                                                                                               
    END IF
    IF l_ima915='2' OR l_ima915='3' THEN 
       LET l_chk = 'Y'
    END IF 
    #MOD-840474-end-add
    
#No.TQC-930026 add --begin--
    IF cl_null(p_cell) THEN
       LET p_cell = ' '
    END IF
#No.TQC-930026 add --end----    
    
    LET l_sql="SELECT pmh12,pmh17,pmh18,pmh19", 
              #"  FROM ",s_dbstring(p_dbs CLIPPED),"pmh_file ",     #料件供應商   #No.FUN-930148
              "  FROM ",cl_get_target_table(p_plant,'pmh_file'), #FUN-A50102
              " WHERE pmh01 = '",p_part,"'", 
              "   AND pmh02 = '",p_vender,"'",
              "   AND pmh13 = '",p_curr,"'",          #幣別
              "   AND pmh21 = '",p_task,"'",  #No.FUN-670099
              "   AND pmh22 = '",p_type,"'",  #No.FUN-670099
              "   AND pmh23 = '",p_cell,"'",  #No.TQC-930026
              "   AND pmhacti = 'Y'"                                           #CHI-910021
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE def_p1 FROM l_sql                                                                                          
    IF SQLCA.SQLCODE THEN CALL cl_err('def_p1',SQLCA.SQLCODE,1) END IF  
    DECLARE def_c1 CURSOR FOR def_p1          
    OPEN def_c1                 
    FETCH def_c1 INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19 
    IF SQLCA.SQLCODE <> 0 AND l_chk='Y' THEN    #MOD-840474 add l_chk
       IF SQLCA.SQLCODE = 100 THEN
         LET l_msg=p_dbs CLIPPED,p_part CLIPPED
         CALL cl_err(l_msg CLIPPED,"apm-572",1)
       ELSE 
         CALL cl_err( 'def_cl FETCH:',SQLCA.SQLCODE,1) 
       END IF                                                                                     
       LET g_success='N'                                                                                               
#       RETURN   #NO.MOD-740393                                                                                                         
    END IF      
    IF cl_null(l_pmh19) AND NOT cl_null(l_pmh12) THEN
       IF NOT cl_null(l_pmh18) THEN
          LET l_pmh19 = l_pmh12 * (1 + l_pmh18/100)   #No.TQC-620035 
          LET l_pmh19 = cl_digcut(l_pmh19,g_azi03)
       END IF
    END IF
    #No.FUN-610018 --end--
#bugno:5810 modify.............................................
 LET l_sql = 
     " SELECT pmi01,pmi05,pmi08,pmi081,pmj02,pmj07,pmj07t,pmj09 ",    #No.TQC-620035
    #"   FROM ",s_dbstring(p_dbs CLIPPED),"pmj_file,", s_dbstring(p_dbs CLIPPED),"pmi_file ",   #核價檔 NO:7178  add pmi01,pmi05 #No.FUN-610018   #No.FUN-930148  
     #"   FROM ",s_dbstring(g_dbs_tra CLIPPED),"pmj_file,", s_dbstring(g_dbs_tra CLIPPED),"pmi_file ",   #核價檔 NO:7178  add pmi01,pmi05 #No.FUN-610018   #FUN-980094 GP5.2 mod
     "   FROM ",cl_get_target_table(p_plant,'pmj_file'),",", #FUN-A50102 
                cl_get_target_table(p_plant,'pmi_file'),     #FUN-A50102
     "  WHERE pmi01 = pmj01",     #核價單號
     "    AND pmj03 = '",p_part,"'",
     "    AND pmj05 = '",p_curr,"'",
     "    AND pmj09<= '",p_date,"'"
 IF NOT cl_null(p_task) THEN
     LET l_sql = l_sql CLIPPED,
                 " AND pmj10 = '",p_task,"'" #作業編號 #NO:7178
 ELSE
     LET l_sql = l_sql CLIPPED,
                 " AND (pmj10 =' ' OR pmj10 = '' OR pmj10 IS NULL) "
 END IF
 
#No.TQC-930026 add--begin--
 IF NOT cl_null(p_cell) THEN
     LET l_sql = l_sql CLIPPED," AND pmj13 = '",p_cell,"'"
#No.TQC-930026 add --end--  
    #-MOD-990185-add-
     #LET l_sql2 = " SELECT MAX(pmj09) FROM ",s_dbstring(g_dbs_tra CLIPPED),"pmj_file ,",s_dbstring(g_dbs_tra CLIPPED),"pmi_file ", 
     LET l_sql2 = " SELECT MAX(pmj09) FROM ",cl_get_target_table(p_plant,'pmj_file'),",", #FUN-A50102 
                                             cl_get_target_table(p_plant,'pmi_file'),     #FUN-A50102
                  "   WHERE pmi01=pmj01 ",
                  "     AND pmi03= '",p_vender,"'",
                  "     AND pmj03= '",p_part,"'",
                  "     AND pmj05= '",p_curr,"'",
                  "     AND pmiconf='Y' ",
                  "     AND pmiacti='Y' ",
                  "     AND pmj13 ='",p_cell,"'",    
                  "     AND pmj09 <= '",p_date,"'" 
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
    #-MOD-990185-end-
     LET l_sql = l_sql CLIPPED,
        " AND pmj12='",p_type,"'",  #No.FUN-670099
        " AND pmiconf='Y' ",
        " AND pmiacti='Y' ",
        " AND pmi03= '",p_vender,"'",  #No:9360
       #-MOD-990185-replace-
        " AND pmj09 = (",l_sql2,")", 
       #" AND pmj09 = ",
       #" (SELECT MAX(pmj09) FROM ",s_dbstring(p_dbs CLIPPED),"pmj_file ,",s_dbstring(p_dbs CLIPPED),"pmi_file ",   #No.FUN-930148  
       #" (SELECT MAX(pmj09) FROM ",s_dbstring(g_dbs_tra CLIPPED),"pmj_file ,",s_dbstring(g_dbs_tra CLIPPED),"pmi_file ",   #FUN-980094 GP5.2 mod
       #"   WHERE pmi01=pmj01 ",
       #"     AND pmi03= '",p_vender,"'",
       #"     AND pmj03= '",p_part,"'",
       #"     AND pmj05= '",p_curr,"'",
       #"     AND pmiconf='Y' ",
       #"     AND pmiacti='Y' ",
       #"     AND pmj13 ='",p_cell,"'",    #No.TQC-930026 add
       #"     AND pmj09 <= '",p_date,"')",
       #-MOD-990185-end-
#       " ORDER BY pmj09 DESC "
        " ORDER BY pmj09 DESC,pmi01 DESC "     #No.TQC-7B0011
 ELSE                                          #No.TQC-930026 add
#No.TQC-930026 add --begin--
    LET l_sql = l_sql CLIPPED," AND (pmj13=' ' OR pmj13 IS NULL)"
    #-MOD-990185-add-
     #LET l_sql2 = " SELECT MAX(pmj09) FROM ",g_dbs_tra CLIPPED,"pmj_file ,",g_dbs_tra CLIPPED,"pmi_file ",
     LET l_sql2 = " SELECT MAX(pmj09) FROM ",cl_get_target_table(p_plant,'pmj_file'),",", #FUN-A50102 
                                             cl_get_target_table(p_plant,'pmi_file'),     #FUN-A50102
                  "   WHERE pmi01=pmj01 ",
                  "     AND pmi03= '",p_vender,"'",
                  "     AND pmj03= '",p_part,"'",
                  "     AND pmj05= '",p_curr,"'",
                  "     AND pmiconf='Y' ",
                  "     AND pmiacti='Y' ",
                  "     AND (pmj13 =' ' OR pmj13 IS NULL) ",
                  "     AND pmj09 <= '",p_date,"'" 
     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
    #-MOD-990185-end-
    LET l_sql = l_sql CLIPPED,
        " AND pmj12='",p_type,"'",  
        " AND pmiconf='Y' ",
        " AND pmiacti='Y' ",
        " AND pmi03= '",p_vender,"'", 
       #-MOD-990185-replace-
        " AND pmj09 = (",l_sql2,")", 
       #" AND pmj09 = ",
       #" (SELECT MAX(pmj09) FROM ",p_dbs CLIPPED,"pmj_file ,",p_dbs CLIPPED,"pmi_file ",
       #" (SELECT MAX(pmj09) FROM ",g_dbs_tra CLIPPED,"pmj_file ,",g_dbs_tra CLIPPED,"pmi_file ",  #FUN-980094 GP5.2 mod
       #"   WHERE pmi01=pmj01 ",
       #"     AND pmi03= '",p_vender,"'",
       #"     AND pmj03= '",p_part,"'",
       #"     AND pmj05= '",p_curr,"'",
       #"     AND pmiconf='Y' ",
       #"     AND pmiacti='Y' ",
       #"     AND (pmj13 =' ' OR pmj13 IS NULL) ",    #No.TQC-930026 add
       #"     AND pmj09 <= '",p_date,"')",
       #-MOD-990185-end-
        " ORDER BY pmj09 DESC,pmi01 DESC "    
END IF
#No.TQC-930026 add --end- 	        
#bugno:5810 end.............................................
    #end evechu 
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094 GP5.2 add
    PREPARE pmj_pre FROM l_sql
    DECLARE pmj_cur CURSOR FOR pmj_pre
    OPEN pmj_cur
    FETCH pmj_cur INTO l_pmi01,l_pmi05,l_pmi08,l_pmi081,           #No.TQC-620035
                       l_pmj02,l_j07r05,lt_j07r05,l_pmj09 #NO:7178 #No.FUN-610018
    CLOSE pmj_cur
 
    #NO:7178
    IF l_pmi05 = 'Y' THEN          #分量計價
       LET l_sql="SELECT pmr05,pmr05t", #分量計價的單價  #No.FUN-610018
                #"  FROM ",s_dbstring(p_dbs CLIPPED),"pmr_file",   #No.FUN-930148  
                 #"  FROM ",s_dbstring(g_dbs_tra CLIPPED),"pmr_file",   #FUN-980094 GP5.2 mod
                 "  FROM ",cl_get_target_table(p_plant,'pmr_file'),     #FUN-A50102
                 " WHERE pmr01 ='", l_pmi01,"' ",  #MOD-7B0156 modify
                 "   AND pmr02 ='", l_pmj02,"' ",  #MOD-7B0156 modify
                 "   AND '",p_qty,"' ",            #MOD-7B0156 modify  
                 " BETWEEN pmr03 AND pmr04",       #MOD-7B0156 modify
                 " ORDER BY pmr05"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094 GP5.2 add
       PREPARE def_p2 FROM l_sql                                                                                          
       IF SQLCA.SQLCODE THEN CALL cl_err('def_p2',SQLCA.SQLCODE,1) END IF  
       DECLARE pmr05_cur CURSOR FOR def_p2
       FOREACH pmr05_cur INTO l_j07r05,lt_j07r05   #如此的寫法是為了避免USER建立重覆範圍的資料
                                                   #No.FUN-610018
           IF NOT cl_null(l_j07r05) THEN
              EXIT FOREACH
           END IF
       END FOREACH
    END IF
    IF cl_null(l_j07r05) THEN LET l_flag='Y' END IF #MOD-5B0262 add
    #No.FUN-610018 Default
    IF cl_null(lt_j07r05) AND NOT cl_null(l_j07r05) THEN
       IF NOT cl_null(l_pmi081) THEN
          LET lt_j07r05 = l_j07r05 * (1 + l_pmi081/100)    #No.TQC-620035
          LET lt_j07r05 = cl_digcut(lt_j07r05,g_azi03)
       END IF
    END IF
    #No.FUN-610018 End
    IF cl_null(l_j07r05) OR l_j07r05 <=0 THEN 
        LET l_j07r05 = 0 
        LET lt_j07r05 = 0 
    END IF
 
    #No.B471 010430 BY ANN CHEN 
    IF g_aza.aza17 <> p_curr THEN
      #LET l_rate = s_curr3(p_curr,g_today,'S')         #MOD-A10041 mark
       LET l_rate = s_currm(p_curr,g_today,'S',p_plant) #MOD-A10041
    ELSE
       LET l_rate=1
    END IF
    #No.B471 END
    #No.TQC-620035 --start--
    LET l_sql="SELECT ima53,ima531", 
              #"  FROM ",s_dbstring(p_dbs CLIPPED),"ima_file",  #No.FUN-930148
              "  FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
              " WHERE ima01 ='", p_part,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE def_p3 FROM l_sql                                                                                          
    IF SQLCA.SQLCODE THEN CALL cl_err('def_p3',SQLCA.SQLCODE,1) END IF  
    DECLARE ima53_cur CURSOR FOR def_p3
    FOREACH ima53_cur  INTO l_ima53,l_ima531                 #料件單價
    IF SQLCA.SQLCODE THEN CALL cl_err('ima53_cur',SQLCA.SQLCODE,1) END IF  
    END FOREACH
    #No.FUN-610018 --start--
    IF cl_null(l_ima53) THEN LET l_ima53 = 0 END IF
    IF cl_null(l_ima531) THEN LET l_ima531 = 0 END IF
    #No.FUN-610018 --end--
    #No.TQC-620035 --end--
   #-MOD-A10041-add-
   #SELECT pnz03 INTO l_pnz03  FROM pnz_file WHERE pnz01 = p_term   #NO.FUN-930148
    LET l_sql="SELECT pnz03",       
              #"  FROM ",s_dbstring(p_dbs CLIPPED),"pnz_file",
              "  FROM ",cl_get_target_table(p_plant,'pnz_file'), #FUN-A50102
              " WHERE pnz01 ='",p_term,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102	
    PREPARE pnz_p FROM l_sql                                                                                          
    IF SQLCA.SQLCODE THEN CALL cl_err('pnz_p',SQLCA.SQLCODE,1) END IF  
    DECLARE pnz_c CURSOR FOR pnz_p 
    FOREACH pnz_c INTO l_pnz03   
    IF SQLCA.SQLCODE THEN CALL cl_err('pnz_c',SQLCA.SQLCODE,1) END IF  
    END FOREACH
    LET l_sql="SELECT sma83",       
              #"  FROM ",s_dbstring(p_dbs CLIPPED),"sma_file",
              "  FROM ",cl_get_target_table(p_plant,'sma_file'), #FUN-A50102
              " WHERE sma00 ='0'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102	
    PREPARE sma_p FROM l_sql                                                                                          
    IF SQLCA.SQLCODE THEN CALL cl_err('sma_p',SQLCA.SQLCODE,1) END IF  
    DECLARE sma_c CURSOR FOR sma_p 
    FOREACH sma_c INTO l_sma83   
    IF SQLCA.SQLCODE THEN CALL cl_err('sma_c',SQLCA.SQLCODE,1) END IF  
    END FOREACH
   #-MOD-A10041-add-
    CASE 
#     WHEN g_sma.sma841 = '1'   #1.[料件/供應商]採購單價 2.料件主檔[採購單價]
     WHEN l_pnz03 = '1'   #1.[料件/供應商]採購單價 2.料件主檔[採購單價]
          LET l_price = l_pmh12 
          #No.TQC-620035
          #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
          LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmh18,p_tax,p_vender,l_price,l_pmh19)  #FUN-A50102
          IF cl_null(l_pmh12) OR l_pmh12 <= 0 THEN 
             LET l_price = l_ima53/l_rate   
             #LET lt_price = s_defprice_rate1(p_rate,p_dbs,'',p_tax,p_vender,l_price,'')
             LET lt_price = s_defprice_rate1(p_rate,p_plant,'',p_tax,p_vender,l_price,'')  #FUN-A50102
          END IF
#     WHEN g_sma.sma841 = '2'   #1.[料件/供應商]採購單價 2.料件主檔[市價]
      WHEN l_pnz03 = '2'   #1.[料件/供應商]採購單價 2.料件主檔[市價] 
          LET l_price = l_pmh12
          #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
          LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmh18,p_tax,p_vender,l_price,l_pmh19) #FUN-A50102
          IF cl_null(l_pmh12) OR l_pmh12 <= 0 THEN 
             LET l_price = l_ima531 / l_rate
             #LET lt_price = s_defprice_rate1(p_rate,p_dbs,'',p_tax,p_vender,l_price,'')
             LET lt_price = s_defprice_rate1(p_rate,p_plant,'',p_tax,p_vender,l_price,'')  #FUN-A50102
          END IF
#     WHEN g_sma.sma841 = '3'      #料件主檔[最近採購單價]
      WHEN l_pnz03 = '3'      #料件主檔[最近採購單價] 
          LET l_price = l_ima53 / l_rate
          #LET lt_price = s_defprice_rate1(p_rate,p_dbs,'',p_tax,p_vender,l_price,'')
          LET lt_price = s_defprice_rate1(p_rate,p_plant,'',p_tax,p_vender,l_price,'')  #FUN-A50102
#     WHEN g_sma.sma841 = '4'      #料件主檔[市價]
      WHEN l_pnz03 = '4'      #料件主檔[市價]
          LET l_price = l_ima531 / l_rate
          #LET lt_price = s_defprice_rate1(p_rate,p_dbs,'',p_tax,p_vender,l_price,'')
          LET lt_price = s_defprice_rate1(p_rate,p_plant,'',p_tax,p_vender,l_price,'') #FUN-A50102
     #------------ 00/01/21 sma841新增 '6' --------------
#     WHEN g_sma.sma841 = '5'        #依核價單價
      WHEN l_pnz03 = '5'        #依核價單價
          LET l_price = l_j07r05
          #No.TQC-620035
          #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)
          LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmi081,p_tax,p_vender,l_price,lt_j07r05) #FUN-A50102
          IF cl_null(l_price) OR l_price <= 0 THEN
             LET l_price = l_ima53 / l_rate
             #No.TQC-620035
             #LET lt_price = s_defprice_rate1(p_rate,p_dbs,'',p_tax,p_vender,l_price,'')
             LET lt_price = s_defprice_rate1(p_rate,p_plant,'',p_tax,p_vender,l_price,'') #FUN-A50102
          END IF 
#     WHEN g_sma.sma841 = '6'      #依核價檔與料件供應商取低者
      WHEN l_pnz03 = '6'      #依核價檔與料件供應商取低者
          #NO:7178------
          IF cl_null(l_pmh12) OR l_pmh12  <=0 THEN 
             LET l_pmh12  = 0 
             LET l_pmh19  = 0    #No.FUN-610018
          END IF
          IF l_flag != 'Y' THEN #MOD-5B0262 add IF
             IF l_j07r05 < l_pmh12 THEN
                LET l_price = l_j07r05
                #No.TQC-620035
                #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)
                LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)#FUN-A50102
                LET l_tax = l_pmi08          #No.TQC-620035
             ELSE
                LET l_price = l_pmh12
                #No.TQC-620035
                #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
                LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmh18,p_tax,p_vender,l_price,l_pmh19) #FUN-A50102
                LET l_tax = l_pmh17          #No.TQC-620035
             END IF
          ELSE
             LET l_price = l_pmh12
             #No.TQC-620035
             #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
             LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmh18,p_tax,p_vender,l_price,l_pmh19) #FUN-A50102
             LET l_tax = l_pmh17          #No.TQC-620035
          END IF
         #CASE WHEN g_sma.sma83='1'   #MOD-A10041 mark            
          CASE WHEN l_sma83='1'       #MOD-A10041     
                  LET last_price=l_j07r05   #無條件更新,(以核價檔單價)
                  #No.TQC-620035
                  #LET lastt_price = s_defprice_rate1(p_rate,p_dbs,l_pmi081,p_tax,p_vender,last_price,lt_j07r05)
                  LET lastt_price = s_defprice_rate1(p_rate,p_plant,l_pmi081,p_tax,p_vender,last_price,lt_j07r05) #FUN-A50102
                  LET l_tax = l_pmi08          #No.TQC-620035
              #WHEN g_sma.sma83='2'   #MOD-A10041 mark 
               WHEN l_sma83='2'       #MOD-A10041
                  LET last_price=l_price   #較低時更新
                  LET lastt_price=lt_price #FUN-610018
              #WHEN g_sma.sma83='3'   #MOD-A10041 mark 
               WHEN l_sma83='3'       #MOD-A10041
                  LET last_price=l_pmh12   #不更新
                  #No.TQC-620035
                  #No.TQC-620035
                  #LET lastt_price = s_defprice_rate1(p_rate,p_dbs,l_pmh18,p_tax,p_vender,last_price,l_pmh19)
                  LET lastt_price = s_defprice_rate1(p_rate,p_plant,l_pmh18,p_tax,p_vender,last_price,l_pmh19) #FUN-A50102
                  LET l_tax = l_pmh17          #No.TQC-620035
               OTHERWISE EXIT CASE
          END CASE
          #MOD-490265加上last_price大於0時才update pmh_file          
          IF last_price > 0 THEN
             LET l_sql="SELECT azi03", 
                       #"  FROM ",s_dbstring(p_dbs CLIPPED),"azi_file",   #No.FUN-930148
                       "  FROM ",cl_get_target_table(p_plant,'azi_file'), #FUN-A50102
                       "  WHERE azi01 = '",p_curr,"'"     #幣別
 	         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
             PREPARE def_p4 FROM l_sql                                                                                          
             IF SQLCA.SQLCODE THEN CALL cl_err('def_p4',SQLCA.SQLCODE,1) END IF  
             DECLARE azi03_cur CURSOR FOR def_p4
             FOREACH azi03_cur  INTO t_azi03 
             IF SQLCA.SQLCODE THEN CALL cl_err('azi03_cur',SQLCA.SQLCODE,1) END IF  
             END FOREACH
             IF cl_null(t_azi03) THEN
                LET t_azi03 = g_azi03
             END IF
             LET lastt_price = cl_digcut(lastt_price,t_azi03)
             #No.TQC-620035 取得廠商料件稅種
             IF cl_null(p_tax) THEN 
                IF cl_null(l_tax) THEN
                   LET l_sql="SELECT pmc47",
                             #"  FROM ",s_dbstring(p_dbs CLIPPED) ,"pmc_file",   #No.FUN-930148
                             "  FROM ",cl_get_target_table(p_plant,'pmc_file'), #FUN-A50102  
                             " WHERE pmc01 = '",p_vender,"'"
 	               CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
                   PREPARE tax_p FROM l_sql                                                                                          
                   IF SQLCA.SQLCODE THEN CALL cl_err('tax_p',SQLCA.SQLCODE,1) END IF  
                   DECLARE tax_cur CURSOR FOR tax_p
                   OPEN tax_cur 
                   FETCH tax_cur INTO p_tax
                   IF SQLCA.SQLCODE THEN CALL cl_err('azi03_cur',SQLCA.SQLCODE,1) END IF  
                ELSE
                   LET p_tax = l_tax
                END IF
             END IF
             #No.TQC-520035 --end
             #LET l_sql="UPDATE ",s_dbstring(p_dbs CLIPPED),"pmh_file",  #No.FUN-930148
             LET l_sql="UPDATE ",cl_get_target_table(p_plant,'pmh_file'), #FUN-A50102 
                       "   SET pmh12 = ",last_price,",",
                       "       pmhdate = '",g_today,"',",  #FUN-C40009 mark
                       "       pmh17 = '",p_tax,"',",   #No.FUN-610018
                       "       pmh18 = ",p_rate,",",       #No.FUN-610018
		       "       pmh19 = ",lastt_price,      #No.FUN-610018
                       " WHERE pmh01 = ?          ",
                       "   AND pmh02 = ?          ",
                       "   AND pmh13 = ?          ",
                       "   AND pmh21 = ?          ",  #No.FUN-670099
                       "   AND pmh22 = ?          ",  #No.FUN-670099
                       "   AND pmh23 = ?          "   #No.TQC-930026 add
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
              PREPARE pmh_p4 FROM l_sql    
              EXECUTE pmh_p4 USING p_part,p_vender,p_curr,p_task,p_type,p_cell  #No.FUN-670099 #No.TQC-930026 add p_cell
              IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN #MOD-4B0099將此判斷挪到IF...END IF 內
                 LET g_errno='mfg3442'
             END IF
          END IF
          #MOD-490265  
          #NO:7178------
#     WHEN g_sma.sma841 = '7'      #依核價檔取價
      WHEN l_pnz03 = '7'      #依核價檔取價
          #NO:7178------
          LET l_price = l_j07r05
          #No.TQC-620035
          #LET lt_price = s_defprice_rate1(p_rate,p_dbs,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)
          LET lt_price = s_defprice_rate1(p_rate,p_plant,l_pmi081,p_tax,p_vender,l_price,lt_j07r05) #FUN-A50102
          IF cl_null(l_price) OR l_price <=0 THEN 
             LET l_price = 0 
             LET lt_price = 0     #No.FUN-610018
          END IF
     #No.FUN-7B0014  --Begin
#     WHEN g_sma.sma841 = '8'      #依BODY取價
      WHEN l_pnz03 = '8'      #依BODY取價
          DECLARE icg05_cs CURSOR FOR
           SELECT icg05 FROM icg_file
            WHERE icg01 =  p_part
              AND icg02 = p_workno
              AND icg03 = p_vender
          OPEN icg05_cs
          IF SQLCA.sqlcode THEN LET g_errno = SQLCA.sqlcode END IF
          FETCH icg05_cs INTO l_price
          LET lt_price = s_defprice_rate(p_rate,l_pmi081,p_tax,
                                       p_vender,l_price,l_pmh19)
          IF cl_null(l_price) OR l_price < 0 THEN
             LET l_price = 0
             LET lt_price = 0
          END IF
          CLOSE icg05_cs
     #No.FUN-7B0014  --End
     #NO.FUN-930148 --begin--
     WHEN l_pnz03 = '9'
       #CALL s_price_by_term1(p_part,p_vender,p_curr,p_date,p_dbs,p_qty,p_unit,p_term,p_payment)
       CALL s_price_by_term1(p_part,p_vender,p_curr,p_date,p_plant,p_qty,p_unit,p_term,p_payment)   #FUN-A50102
           RETURNING l_price,lt_price,l_rate
       LET lt_price = s_defprice_rate(p_rate,l_rate,p_tax,p_vender,l_price,lt_price)
       IF cl_null(l_price) OR l_price = 0 THEN
          LET l_price = 0 
          LET lt_price = 0
       END IF    
     #NO.FUN-930148 --end--
      OTHERWISE EXIT CASE 
     END CASE
     IF cl_null(l_price) THEN 
        LET l_price = 0 
        LET lt_price = 0     #No.FUN-610018
     END IF
     LET l_price = cl_digcut(l_price,t_azi03)
     LET lt_price = cl_digcut(lt_price,t_azi03)
     RETURN l_price,lt_price #No.FUN-610018 
END FUNCTION
 
#No.FUN-620035 --start--
#稅率是否改變,只有稅率改變時才以未稅價推含稅價 
#FUNCTION s_defprice_rate1(p_rate,p_dbs,p_rate1,p_tax,p_vender,p_price,pt_price)
FUNCTION s_defprice_rate1(p_rate,p_plant,p_rate1,p_tax,p_vender,p_price,pt_price)   #FUN-A50102
   DEFINE l_flag     LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) #Y:稅率改變 N:稅率未改變
          p_rate     LIKE gec_file.gec04,     #傳入稅率
          p_dbs      LIKE azp_file.azp03,     #營運中心別
          p_rate1    LIKE gec_file.gec04,     #廠商料件檔&核價檔稅率
          p_tax      LIKE gec_file.gec01,     #傳入稅別
          p_vender   LIKE pmh_file.pmh02,     #傳入廠商編號
          l_gec04    LIKE gec_file.gec04,     #使用稅率
          p_price    LIKE pmh_file.pmh12,     #廠商料件檔&核價檔未稅單價
          pt_price   LIKE pmh_file.pmh19,     #廠商料件檔&核價檔含稅單價
          lt_price   LIKE pmh_file.pmh19,     #廠商料件檔&核價檔含稅單價
          l_sql      LIKE type_file.chr1000,  #No.FUN-680147 VARCHAR(1000)
          p_plant    LIKE type_file.chr20     #FUN-A50102
 
   LET l_flag = 'Y'
   LET lt_price = pt_price
   IF cl_null(p_rate) THEN                  #未傳入稅率
      IF cl_null(p_rate1) THEN              #廠商料件檔&核價檔未抓取稅率
         IF cl_null(p_tax) THEN             #未傳入稅別
            LET l_sql="SELECT gec04 ",
                      #"  FROM ",s_dbstring(p_dbs CLIPPED),"gec_file",s_dbstring(p_dbs CLIPPED),"pmc_file ",   #No.FUN-930148
                      "  FROM ",cl_get_target_table(p_plant,'gec_file'),",", #FUN-A50102
                                cl_get_target_table(p_plant,'pmc_file'),     #FUN-A50102
                      " WHERE pmc01 = p_vender",
                      "   AND gec01 = pmc47   ",
                      "   AND gec011='1'      ", #進項
                      "   AND gecacti='Y'     "
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
            PREPARE def_p5 FROM l_sql                                                                                          
            IF SQLCA.SQLCODE THEN CALL cl_err('def_p5',SQLCA.SQLCODE,1) END IF  
            DECLARE gec04_cur CURSOR FOR def_p5
            OPEN gec04_cur  
            FETCH gec04_cur INTO l_gec04 
         ELSE
            LET l_sql="SELECT gec04 ",
                      #"  FROM ",s_dbstring(p_dbs CLIPPED),"gec_file",    #No.FUN-930148
                      "  FROM ",cl_get_target_table(p_plant,'gec_file'),     #FUN-A50102  
                      " WHERE gec01 = p_tax",
                      "   AND gec011='1'   ", #進項
                      "   AND gecacti='Y'  "
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
            PREPARE def_p6 FROM l_sql                                                                                          
            IF SQLCA.SQLCODE THEN CALL cl_err('def_p5',SQLCA.SQLCODE,1) END IF  
            DECLARE gec_cur CURSOR FOR def_p6
            OPEN gec_cur  
            FETCH gec_cur INTO l_gec04 
         END IF
      ELSE
         LET l_flag = 'N'                   #稅率未改變
         LET l_gec04 = p_rate1
      END IF
   ELSE
      IF NOT cl_null(p_rate1) AND p_rate = p_rate1 THEN
         LET l_flag = 'N'
      END IF
      LET l_gec04 = p_rate
   END IF
   IF cl_null(l_gec04) THEN
      LET l_gec04 = 0
   END IF
   IF l_flag = 'Y' THEN
      LET lt_price = p_price * (1 + l_gec04/100)
   END IF
   RETURN lt_price
END FUNCTION
#No.FUN-620035 --end--
 
#No.FUN-7B0014 --Begin
##DESCRIPTION	廠商料價單價取價
##PARAMETERS	p_icg01     料件編號
#           	p_icg02     作業編號
#           	p_icg03     廠商編號
#           	p_icg04     NULL
##RETURNING     p_icg24     參考單價
FUNCTION s_defprice_icd1(p_icg01,p_icg02,p_icg03,p_icg04)
DEFINE p_icg01  LIKE icg_file.icg01,
       p_icg02  LIKE icg_file.icg02,
       p_icg03  LIKE icg_file.icg03,
       p_icg04  LIKE icg_file.icg04,
       l_icg24  LIKE icg_file.icg24
DEFINE l_icg28  LIKE icg_file.icg28,
       l_ich02  LIKE ich_file.ich02,
       l_sql    STRING
 
 
    LET l_icg24 = 0
 
    IF cl_null(p_icg01) THEN RETURN l_icg24 END IF
    IF cl_null(p_icg02) THEN RETURN l_icg24 END IF
    IF cl_null(p_icg03) THEN RETURN l_icg24 END IF
    #IF cl_null(p_icg04) THEN RETURN l_icg24 END IF  暫不用
    SELECT icg28 INTO l_icg28 FROM icg_file
     WHERE icg01 = p_icg01
       AND icg02 = p_icg02
       AND icg03 = p_icg03
       AND icg04 = p_icg04
 
    IF cl_null(l_icg28) THEN RETURN l_icg24 END IF
 
    SELECT ich02 INTO l_ich02 FROM ich_file
     WHERE ich01 = l_icg28
    IF cl_null(l_ich02) THEN RETURN l_icg24 END IF
 
    LET g_success = 'Y'
    CALL s_defprice_icd1_cons(l_ich02) RETURNING l_sql
    IF g_success = 'N' THEN RETURN l_icg24 END IF
 
    #CHI-920050--BEGIN--
    #1.(+) 改用 left OUTER join
    #2.ima_file ==> imaicd_file
    #3.ta_imaicd01 => imaicd01
    #LET l_sql = "SELECT ",l_sql CLIPPED,
    #            "  FROM icg_file,ima_file,icb_file ",
    #            " WHERE icg01 = '",p_icg01,"'",
    #            "   AND icg02 = '",p_icg02,"'",
    #            "   AND icg03 = '",p_icg03,"'",
    #            "   AND ima01 = icg01 ",
    #            "   AND ta_imaicd01 = icb010(+) ",
    #            "   AND icg04 = '",p_icg04,"'" #暫不卡
    LET l_sql = "SELECT ",l_sql CLIPPED,
                "  FROM icg_file,imaicd_file,LEFT OUTER JOIN icb_file ",
                "    ON (imaicd01 = icb010) ",
                " WHERE icg01 = '",p_icg01,"'",
                "   AND icg02 = '",p_icg02,"'",
                "   AND icg03 = '",p_icg03,"'",
		"   AND imaicd01 = icg01 ",
                "   AND icg04 = '",p_icg04,"'" #暫不卡
   #CHI-920050--END--
    PREPARE s_defprice_icd1_pre FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('s_defprice_icd1_pre:',SQLCA.sqlcode,1)
       LET l_icg24 = 0
    END IF
 
    DECLARE s_defprice_icd1_cs CURSOR FOR s_defprice_icd1_pre
    OPEN s_defprice_icd1_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err('OPEN cs_rice1_cs:',SQLCA.sqlcode,1)
       LET l_icg24 = 0
    END IF
    FETCH s_defprice_icd1_cs INTO l_icg24
    IF SQLCA.sqlcode THEN
       CALL cl_err('fetch cs_rice1_cs:',SQLCA.sqlcode,1)
       LET l_icg24 = 0
    END IF
 
    RETURN l_icg24
END FUNCTION
 
FUNCTION s_defprice_icd1_cons(p_ich02)
   DEFINE p_ich02 LIKE ich_file.ich02
   DEFINE l_ich02 LIKE ich_file.ich02
   DEFINE l_ich01 LIKE ich_file.ich01
   DEFINE l_operator1 STRING
   DEFINE l_operator2 STRING
   DEFINE l_operand   LIKE type_file.chr1
   DEFINE l_str       STRING
   DEFINE l_sql       STRING
   DEFINE l_index     LIKE type_file.num5
   DEFINE l_length    LIKE type_file.num5
 
   LET l_index = 0
   LET l_str = p_ich02
   LET l_sql = NULL
 
   #取總長度
   LET l_length = l_str.getLength()
 
   #取運算子位置
   LET l_index = l_str.getIndexOf('+',2)
   IF l_index = 0 THEN
      LET l_index = l_str.getIndexOf('-',2)
   END IF
   IF l_index = 0 THEN
      LET l_index = l_str.getIndexOf('*',2)
   END IF
   IF l_index = 0 THEN
      LET l_index = l_str.getIndexOf('\/',2)
   END IF
   #判斷資料格式-------------------------------------------------#
   # 沒資料
     IF l_length = 0 THEN LET g_success = 'N' RETURN l_sql END IF
   # 非(符號啟始
     IF l_str.substring(1,1) <> '(' THEN LET g_success = 'N' RETURN l_sql END IF
   # 非)符號結尾
     IF l_str.substring(l_length,l_length) <> ')' THEN
        LET g_success = 'N' RETURN l_sql
     END IF
   # 找不到運算子
     IF l_index = 0 THEN LET g_success = 'N' RETURN l_sql END IF
   # 運算子在第二位
   IF l_index = 2 THEN LET g_success = 'N' RETURN l_sql END IF
   # 運算子在倒數第二位
   IF l_index = l_length-1 THEN LET g_success = 'N' RETURN l_sql END IF
   # 哇哈哈長這樣(+-*/)
   IF l_length = 3 THEN RETURN 0 END IF
   #-------------------------------------------------------------#
   LET l_operator1 = l_str.substring(2,l_index-1)
   LET l_operator2 = l_str.substring(l_index+1,l_length-1)
   LET l_operand   = l_str.substring(l_index,l_index)
   CASE l_operator1
        WHEN 'TEST TIME FOR WAFER'  LET l_sql = 'icg06'
        WHEN 'INDEX TIME FOR WAFER' LET l_sql = 'icg07'
        WHEN 'TEST TIME FOR DIE'    LET l_sql = 'icg08'
        WHEN 'INDEX TIME FOR DIE'   LET l_sql = 'icg09'
        WHEN 'Hour Rate'            LET l_sql = 'icg10'
        WHEN 'Dut'                  LET l_sql = 'icg11'
       #WHEN 'GROSS DIE'            LET l_sql = 'icb05'     #FUN-B30192
        WHEN 'GROSS DIE'            LET l_sql = 'imaicd14'  #FUN-B30192
	WHEN 'FACTOR'               LET l_sql = 'icg23'
        OTHERWISE
             LET l_ich01 = l_operator1
             SELECT ich02 INTO l_ich02 FROM ich_file
              WHERE ich01 = l_ich01
             IF SQLCA.sqlcode = 100 THEN
                IF NOT s_defprice_icd1_numchk(l_operator1) THEN
                   LET g_success = 'N'  RETURN l_sql
                END IF
                LET l_sql = l_operator1
             ELSE
                CALL s_defprice_icd1_cons(l_ich02) RETURNING l_operator1
                IF g_success = 'N' THEN RETURN l_sql END IF
                LET l_sql = l_operator1
             END IF
   END CASE
 
   LET l_sql = l_sql.append(l_operand)
 
   CASE l_operator2
        WHEN 'TEST TIME FOR WAFER'  LET l_sql = l_sql.append('icg06')
        WHEN 'INDEX TIME FOR WAFER' LET l_sql = l_sql.append('icg07')
        WHEN 'TEST TIME FOR DIE'    LET l_sql = l_sql.append('icg08')
        WHEN 'INDEX TIME FOR DIE'   LET l_sql = l_sql.append('icg09')
        WHEN 'Hour Rate'            LET l_sql = l_sql.append('icg10')
        WHEN 'Dut'                  LET l_sql = l_sql.append('icg11')
       #WHEN 'GROSS DIE'            LET l_sql = l_sql.append('icb05')  #FUN-B30192
        WHEN 'GROSS DIE'            LET l_sql = l_sql.append('imaicd14') #FUN-B30192
	WHEN 'FACTOR'               LET l_sql = l_sql.append('icg23')
        OTHERWISE
             LET l_ich02 = NULL
             LET l_ich01 = l_operator2
             SELECT ich02 INTO l_ich02 FROM ich_file
              WHERE ich01 = l_ich01
             IF SQLCA.sqlcode = 100 THEN
                IF NOT s_defprice_icd1_numchk(l_operator2) THEN
                   LET g_success = 'N'  RETURN l_sql
                END IF
                LET l_sql = l_sql.append(l_operator2)
             ELSE
                CALL s_defprice_icd1_cons(l_ich02) RETURNING l_operator2
                IF g_success = 'N' THEN RETURN l_sql END IF
                LET l_sql = l_sql.append(l_operator2)
             END IF
   END CASE
   LET l_sql = '(',l_sql CLIPPED,')'
   RETURN l_sql
END FUNCTION
 
 
#檢查數值否
FUNCTION s_defprice_icd1_numchk(p_str)
    DEFINE p_str  LIKE ich_file.ich01,
           p_str1 LIKE ich_file.ich01,
           l_i    LIKE type_file.num5,
           l_dot  LIKE type_file.num5   #計算小數點數
 
    LET l_dot = 0
    IF cl_null(p_str) THEN RETURN 0 END IF  #沒資料[錯]
    IF NOT cl_null(p_str) THEN
       IF p_str[1,1] = '.' THEN RETURN 0 END IF  #小數點在第一個字[錯]
       IF p_str[LENGTH(p_str),LENGTH(p_str)] = '.' THEN #小數點在最後[錯]
          RETURN 0
       END IF
       FOR l_i = 1 TO LENGTH(p_str)
           IF p_str[l_i,l_i] = '.' THEN LET l_dot = l_dot + 1 END IF
           IF l_dot > 1 THEN RETURN 0 END IF   #小數點出現1次以上[錯]
 
           IF p_str[l_i,l_i] = '-' AND l_i > 1 THEN
              RETURN 0                    #負號出現在第一位以外[錯]
           END IF
           IF p_str[l_i,l_i] NOT MATCHES '[-.0123456789]' THEN
              RETURN 0                    #不等於-.0123456789任一[錯]
           END IF
       END FOR
       IF p_str[1,1] = '0' AND l_dot = 0 THEN
          RETURN 0                        #第一位為0但字串中無小數點[錯]
       END IF
    END IF
    RETURN 1
END FUNCTION
#No.FUN-7B0014 --End
 
#No.FUN-930148--begin--
#FUNCTION s_price_by_term1(p_part,p_vender,p_curr,p_date,p_dbs,p_qty,p_unit,p_term,p_payment)
FUNCTION s_price_by_term1(p_part,p_vender,p_curr,p_date,p_plant,p_qty,p_unit,p_term,p_payment) #FUN-A50102
DEFINE l_price     LIKE ima_file.ima53,
       lt_price    LIKE ima_file.ima53,
       l_rate      LIKE azj_file.azj03,
       l_rate1     LIKE azj_file.azj03,
       p_part      LIKE pmh_file.pmh01,       
       p_vender    LIKE pmh_file.pmh02,
       p_curr      LIKE pmh_file.pmh13,
       p_date      LIKE type_file.dat,          
       p_qty       LIKE pmn_file.pmn20, 
      #p_dbs       LIKE azp_file.azp01,         #MOD-AC0040 mark 
       p_dbs       LIKE azp_file.azp03,         #MOD-AC0040 add 
       p_unit      LIKE pnn_file.pnn12, 
       p_term      LIKE pof_file.pof01,       
       p_payment   LIKE pof_file.pof05,
       lt_rate     LIKE pof_file.pof09 
DEFINE l_poj05     LIKE poj_file.poj05    #No.TQC-940165
DEFINE l_pog03     LIKE pog_file.pog03    #No.TQC-940165
DEFINE l_sql       STRING        
DEFINE p_plant     LIKE type_file.chr20   #FUN-A50102

    LET l_price = 0
    LET lt_price = 0   
    LET l_rate = 0
    LET l_rate1 = 0 
    LET l_sql = " SELECT pog08,pog08t,pog09,pof09,pog03",  #No.TQC-940165
                #"  FROM ",s_dbstring(p_dbs CLIPPED),"pof_file,",s_dbstring(p_dbs CLIPPED),"pog_file ",
                "  FROM ",cl_get_target_table(p_plant,'pof_file'),",", #FUN-A50102
                          cl_get_target_table(p_plant,'pog_file'),     #FUN-A50102
                " WHERE pof01 =pog01 AND pof02 = pog02 AND pof03 = pog03 ",
                "  AND pof04 = pog04 AND pof05 = pog05  ",   
                " AND pog06 ='", p_part,"' AND pof01 = '",p_term,"' AND pof02 = '",p_curr, 
                "' AND pof04 = '",p_vender,"' AND pof05 = '",p_payment,
                "' AND pof03 <='",p_date,"' AND pof06 >= '",p_date,
                "' AND pog07 = '",p_unit, 
                "' ORDER BY pof03 DESC "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE price_by_term1_p1 FROM l_sql             
    DECLARE price_by_term1 SCROLL CURSOR  FOR price_by_term1_p1 
    IF STATUS THEN 
       CALL cl_err('byterm1_curs',STATUS,1) RETURN 0
    END IF 
 
    OPEN price_by_term1
    FETCH FIRST price_by_term1 INTO l_price,lt_price,l_rate,lt_rate,l_pog03  #No.TQC-940165
    CLOSE  price_by_term1   
    
    LET l_sql = " SELECT MIN(poh09) ",
                #"  FROM ",s_dbstring(p_dbs CLIPPED),"pof_file,",s_dbstring(p_dbs CLIPPED),"poh_file ",
                "  FROM ",cl_get_target_table(p_plant,'pof_file'),",", #FUN-A50102
                          cl_get_target_table(p_plant,'poh_file'),     #FUN-A50102
                " WHERE pof01 =poh01 AND pof02 = poh02 AND pof03 = poh03 ",
                "  AND pof04 = poh04 AND pof05 = poh05  ",   
                " AND poh06 ='", p_part,"' AND poh01 = '",p_term,"' AND poh02 = '",p_curr, 
                "' AND poh04 = '",p_vender,"' AND poh05 = '",p_payment,
#               "' AND pof03 <= '",p_date,"' AND pof06 >= '",p_date,  #No.TQC-940165
                "' AND pof03 = ? ",                                   #No.TQC-940165
                "  AND poh08 <=",p_qty,                               #No.TQC-940165
                " AND poh07 = '",p_unit,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE price_by_term1_p2 FROM l_sql             
    EXECUTE price_by_term1_p2 USING l_pog03 INTO l_rate1   #No.TQC-940165
    IF STATUS THEN 
       CALL cl_err('byterm_curs2',STATUS,1) RETURN 0
    END IF 
     
    IF l_rate1<>100 THEN 
       LET l_rate = l_rate1
    END IF  
    
    LET l_price = l_price * l_rate/100
    LET lt_price = lt_price * l_rate/100
    
    IF l_price = 0 OR cl_null(l_price) THEN 
      LET l_sql = "  SELECT poj06,poj06t,poj07,poi05,poj05 ",  #No.TQC-940165
                  #" FROM ",s_dbstring(p_dbs CLIPPED),"poj_file,",s_dbstring(p_dbs CLIPPED),"poi_file",
                  " FROM ",cl_get_target_table(p_plant,'poj_file'),",", #FUN-A50102
                           cl_get_target_table(p_plant,'poi_file'),     #FUN-A50102
                  " WHERE poj01 =poi01 AND poj02 = poi02   ",
                  "   AND poj03 = '", p_part,"' AND poj01 = '",p_term,"' AND poj02 ='", p_curr ,
                  "'   AND poj05 <= '", p_date,
                  "' AND poj04 = '",p_unit,
                  "' ORDER BY poj05 DESC " 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE price_by_term1_p3 FROM l_sql 
      DECLARE price_by_term3 SCROLL CURSOR  FOR price_by_term1_p3          
      IF STATUS THEN 
         CALL cl_err('byterm_curs3',STATUS,1) RETURN 0
      END IF 
    
      OPEN price_by_term3
      FETCH FIRST price_by_term3 INTO l_price,lt_price,l_rate,lt_rate,l_poj05  #No.TQC-940165
      CLOSE  price_by_term3      #No.TQC-940165
 
       LET l_sql = "  SELECT MIN(pok07) ",
                  #" FROM ",s_dbstring(p_dbs CLIPPED),"pok_file,",s_dbstring(p_dbs CLIPPED),"poi_file",
                  " FROM ",cl_get_target_table(p_plant,'pok_file'),",", #FUN-A50102
                           cl_get_target_table(p_plant,'poi_file'),     #FUN-A50102
                  " WHERE pok01 =poi01 AND pok02 = poi02   ",
                  "   AND pok03 = '", p_part,"' AND pok01 = '",p_term,"' AND pok02 ='", p_curr ,
#                 "'   AND pok05 <= '", p_date,  #No.TQC-940165
                  "'   AND pok05 = ? ",          #No.TQC-940165
                  "   AND pok06 <=  ",p_qty,     #No.TQC-940165
                  "  AND pok04 = '",p_unit,"'"   #No.TQC-940165
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
       PREPARE price_by_term1_p4 FROM l_sql 
       EXECUTE price_by_term1_p4 USING l_poj05 INTO l_rate1  #No.TQC-940165
      IF STATUS THEN 
         CALL cl_err('byterm2_curs4',STATUS,1) RETURN 0
      END IF 
     
      IF l_rate1 <> 100 THEN 
         LET l_rate = l_rate1
      END IF  
    
      LET l_price = l_price * l_rate/100
      LET lt_price = lt_price * l_rate/100
    END IF  
    
    RETURN l_price,lt_price,lt_rate
 
END FUNCTION     
    
#No.FUN-930148 --end--
