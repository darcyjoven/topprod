# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: artt255_sub.4gl
# Descriptions...: 產生多角收貨入庫訂單出貨
# Date & Author..: NO.FUN-A10123 10/01/28 By bnlent
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A40023 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50102 10/06/09 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:FUN-BB0084 11/11/29 By lixh1 增加數量欄位小數取位&原程式BUG修改
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_post         LIKE type_file.chr1#FUN-A40023
DEFINE g_start        DATETIME MINUTE TO FRACTION(5)
DEFINE g_end          DATETIME MINUTE TO FRACTION(5)
DEFINE g_interval     INTERVAL SECOND TO FRACTION(5)
DEFINE g_stop         LIKE poy_file.poy02
DEFINE g_rui          RECORD LIKE rui_file.*

FUNCTION t255_sub_post(l_no,l_pmm904,l_pmm99,l_dbs,l_dbs_f,l_poy02,l_poy04)
DEFINE l_no             LIKE rui_file.rui01
DEFINE l_pmm904         LIKE pmm_file.pmm904
DEFINE l_pmm99          LIKE pmm_file.pmm99
DEFINE l_dbs            LIKE azp_file.azp03
DEFINE l_dbs_f          LIKE azp_file.azp03
DEFINE l_poy02          LIKE poy_file.poy02
DEFINE l_poy04          LIKE poy_file.poy04
DEFINE l_poy02_min      LIKE poy_file.poy02
DEFINE l_poy02_max      LIKE poy_file.poy02

   SELECT * INTO g_rui.* FROM rui_file WHERE rui01 = l_no AND ruiplant = g_plant
   CALL t255_sub_temptable()
   LET g_stop = l_poy02
   SELECT MIN(poy02),MAX(poy02)
     INTO l_poy02_min,l_poy02_max
     FROM poy_file
    WHERE poy01 = l_pmm904
     IF (l_poy02 = l_poy02_min) OR (l_poy02 = l_poy02_max) THEN
        LET g_post = TRUE
     ELSE
        LET g_post = FALSE
     END IF

     IF (l_poy02 >= l_poy02_min) AND (l_poy02 < l_poy02_max) THEN
        LET g_start = CURRENT MINUTE TO FRACTION(5)
        CALL t255_sub_receipt(l_pmm99,l_poy04,l_dbs)
        LET g_end = CURRENT MINUTE TO FRACTION(5)
        LET g_interval = g_end - g_start
        DISPLAY "第 ",g_stop," 站 ",l_poy04," 收貨單 used ",g_interval," seconds."
        
        LET g_start = CURRENT MINUTE TO FRACTION(5)
        #CALL t255_sub_stockin(l_dbs) #FUN-A50102
        CALL t255_sub_stockin(l_poy04) #FUN-A50102
        LET g_end = CURRENT MINUTE TO FRACTION(5)
        LET g_interval = g_end - g_start
        DISPLAY "第 ",g_stop," 站 ",l_poy04," 入庫單 used ",g_interval," seconds."

     END IF
     IF (l_poy02 > l_poy02_min) AND (l_poy02 <= l_poy02_max) THEN
 
        LET g_start = CURRENT MINUTE TO FRACTION(5)
        CALL t255_sub_order(l_pmm904,l_pmm99,l_dbs_f,l_poy02)
        LET g_end = CURRENT MINUTE TO FRACTION(5)
        LET g_interval = g_end - g_start
        DISPLAY "第 ",g_stop," 站 ",l_poy04," 訂 單 used ",g_interval," seconds."
 
        LET g_start = CURRENT MINUTE TO FRACTION(5)
        CALL t255_sub_ship(l_pmm99,l_poy04,l_dbs)
        LET g_end = CURRENT MINUTE TO FRACTION(5)
        LET g_interval = g_end - g_start
        DISPLAY "第 ",g_stop," 站 ",l_poy04," 出貨單 used ",g_interval," seconds."
     END IF
     IF l_poy02 = l_poy02_max THEN
        CALL t255_sub_y_droptable()
     END IF
END FUNCTION 

FUNCTION t255_sub_order(l_pmm904,l_pmm99,l_dbs_f,l_i)
DEFINE l_pmm904 LIKE pmm_file.pmm904
DEFINE l_pmm99  LIKE pmm_file.pmm99
DEFINE l_dbs    LIKE azp_file.azp03
DEFINE l_dbs_f  LIKE azp_file.azp03
DEFINE l_i      LIKE poy_file.poy02
DEFINE l_oea01  LIKE oea_file.oea01
DEFINE l_oea    RECORD LIKE oea_file.*
DEFINE l_oeb    RECORD LIKE oeb_file.*
DEFINE l_poy    RECORD LIKE poy_file.*
DEFINE l_sql    STRING    
DEFINE l_pod04  LIKE pod_file.pod04
DEFINE l_pmm    RECORD LIKE pmm_file.*
DEFINE li_result,l_n LIKE type_file.num5
DEFINE l_oeacont LIKE oea_file.oeacont
DEFINE l_success LIKE type_file.num5 
DEFINE l_poy04 LIKE poy_file.poy04
 
#一單到底apms010    
#    LET l_sql = "SELECT pod04 FROM ",s_dbstring(l_dbs_f CLIPPED),"pod_file"
#    PREPARE pod_cs FROM l_sql
#    EXECUTE pod_cs INTO l_pod04
    
    SELECT * INTO l_poy.* FROM poy_file WHERE poy01 = l_pmm904 AND poy02 = l_i

    LET g_plant_new = l_poy.poy04
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra

    SELECT poy04 INTO l_poy04 FROM poy_file WHERE poy01=l_pmm904 AND poy02=l_i-1
#取前一站採購資料    
    #LET l_sql = "SELECT pmm_file.* FROM ",s_dbstring(l_dbs_f CLIPPED),"pmm_file ", #FUN-A50102
    LET l_sql = "SELECT pmm_file.* FROM ",cl_get_target_table(l_poy.poy04, 'pmm_file'), #FUN-A50102
                " WHERE pmm99 = ? AND pmm99 IS NOT NULL ",
                "   AND pmmplant = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102           
    PREPARE or_pmm_cs FROM l_sql
    EXECUTE or_pmm_cs USING l_pmm99,l_poy04 INTO l_pmm.*
 
     DELETE FROM pmn_temp 
     #LET l_sql = "INSERT INTO pmn_temp SELECT pmn_file.* FROM ",s_dbstring(l_dbs_f CLIPPED),"pmn_file ", #FUN-A50102
#    LET l_sql = "INSERT INTO pmn_temp SELECT pmn_file.* FROM ",cl_get_target_table(l_poy.poy04, 'pmm_file'), #FUN-A50102
     LET l_sql = "INSERT INTO pmn_temp SELECT pmn_file.* FROM ",cl_get_target_table(l_poy.poy04, 'pmn_file'), #FUN-BB0084
                 " WHERE pmn01 = ? AND pmnplant = ?"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
     CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102            
     PREPARE ins_pmn_temp_cs FROM l_sql
     EXECUTE ins_pmn_temp_cs USING l_pmm.pmm01,l_pmm.pmmplant 
#一單到底不重新編號    
#    IF l_pod04 = 'Y' THEN
#       LET l_oea01 = l_pmm.pmm01
#    ELSE
       CALL t255_sub_def_no(l_dbs,'axm','30') RETURNING l_oea01 
       IF cl_null(l_oea01) THEN
          CALL s_errmsg('',l_dbs,'axm 30','art-330',1)
          LET g_success = 'N'
       ELSE 
          CALL s_auto_assign_no("AXM",l_oea01,l_pmm.pmm04,"30","oea_file","oea01",l_poy.poy04,"","")
                 RETURNING li_result,l_oea01
          IF (NOT li_result) THEN
              LET g_success = 'N'
              CALL s_errmsg('','','','sub-145',1)  
          END IF
       END IF
#    END IF
    
    DELETE FROM oea_temp
    INSERT INTO oea_temp (oea01,oea02,oea09,oea10,oea61,oea62,oea63,oea85,oea99,
                          oea903,oea904,oea911,oea912,
                          oea913,oea914,oea915,oea916,oeaplant,oealegal)               #FUN-A90063
           VALUES (l_oea01,l_pmm.pmm04,0,l_pmm.pmm01,l_pmm.pmm40,0,0,'2',l_pmm.pmm99,
                   l_pmm.pmm903,l_pmm.pmm904,l_pmm.pmm911,l_pmm.pmm912,
                   l_pmm.pmm913,l_pmm.pmm914,l_pmm.pmm915,l_pmm.pmm916,l_pmm.pmmplant,l_pmm.pmmlegal)  #FUN-A90063
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins oea_temp',SQLCA.sqlcode,1)
    END IF 
    LET l_oeacont = TIME
    UPDATE oea_temp
       SET oea00 = '1',
           oea06 = 0,
           oea07 = 'N',
           oea08 = '2',
           oea11 = '6',
           oea14 = g_user,
           oea15 = g_grup,
           oea161 = 0,
           oea162 = 100,
           oea163 = 0,
           oea20 = 'Y',
           oea23 = 'RMB',
           oea24 = 1,
           oea49 = '1',
           oea50 = 'N',
           oea72 = g_today,
           oea901 = 'Y',
           oea902 = 'N',
           oea905 = 'Y',
           oea906 = 'N',
           oeamksg = 'N',
           oeasign = '',
           oeadays = 0,
           oeaprit = 0,
           oeasseq = 0,
           oeasmax = 0,
           oeaconf = 'Y',
           oeaprsw = 0,
           oeauser = g_user,
           oeagrup = g_grup,
           oeaoriu = g_user,
           oeaorig = g_grup,
           oea65 = 'N',
           oeacont = l_oeacont,
           oeaconu = g_user
           
#客戶取流程代碼前一站
    LET l_sql = "UPDATE oea_temp a",
                "   SET oea03 = (SELECT poy03 FROM poy_file",
                "                 WHERE poy01 = ?",
                "                   AND poy02 = (?-1))"
    PREPARE oea_upd1 FROM l_sql
    EXECUTE oea_upd1 USING l_pmm904,l_i
    EXECUTE IMMEDIATE "UPDATE oea_temp SET oea04 = oea03,oea17 = oea03"
    LET l_sql = "UPDATE oea_temp a",
                "   SET (oea05,oea21,oea25,oea32,oea83,oea84,oeaplant) = ",
                "       (SELECT poy12,poy08,poy10,poy32,poy04,poy04,poy04",
                "          FROM poy_file",
                "         WHERE poy01 = ?",
                "           AND poy02 = ?)"
    PREPARE oea_upd2 FROM l_sql
    EXECUTE oea_upd2 USING l_pmm904,l_i
    UPDATE oea_temp SET oealegal = (SELECT azw02 FROM azw_file 
                                     WHERE azw01 = oeaplant)
#更新客戶基本資料    
    LET l_sql = "UPDATE oea_temp a",
                "   SET (oea31,oea32,oea032,oea033) = (SELECT occ44,occ45,occ02,occ11",
                "                                        FROM occ_file",
                "                                       WHERE occ01 = a.oea03)"
    EXECUTE IMMEDIATE l_sql
#取稅種    
    LET l_sql = "UPDATE oea_temp a",
                "   SET oea21 = (SELECT occ41",
                "                  FROM occ_file",
                "                 WHERE occ01 = a.oea03)",
                " WHERE oea21 IS NULL"
    EXECUTE IMMEDIATE l_sql
#稅種為空    
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM oea_temp WHERE oea21 IS NULL
    IF l_n>0 THEN
       LET g_success='N'
       CALL s_errmsg('oea03','','','afa-351',1) 
    END IF
    LET l_sql = "UPDATE oea_temp a",
                "   SET (oea211,oea212,oea213) = (SELECT gec04,gec05,gec07 ",
                #"                                   FROM ",s_dbstring(l_dbs CLIPPED),"gec_file", #FUN-A50102
                "                                   FROM ",cl_get_target_table(l_poy.poy04, 'gec_file'), #FUN-A50102
                "                                  WHERE gec01 = a.oea21",
                "                                    AND gec011 = '2')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102                
    EXECUTE IMMEDIATE l_sql
  
    LET l_sql = "UPDATE oea_temp a",
                "   SET oea902 = 'Y'",
                " WHERE EXISTS (SELECT 1 FROM poy_file",
                "                WHERE poy01 = a.oea904",
                "                  AND poy02 = (SELECT MAX(poy02) FROM poy_file",
                "                                WHERE poy01 = a.oea904)",
                "                  AND poy02 = ?)"
    PREPARE oea_upd3 FROM l_sql
    EXECUTE oea_upd3 USING l_i
    
    DELETE FROM oeb_temp    
    LET l_sql = "INSERT INTO oeb_temp",
                "(oeb01,oeb03,oeb04,oeb05,oeb05_fac,",
                " oeb06,oeb12,oeb13,oeb14,oeb14t,oeb23,oeb24,oeb25,oeb26,",
                " oeb44,oeb47,oeb48,",
               #" oeb916,oeb917,oeb15,oeb72,oeb910,",  #FUN-B20060 add oeb72   #CHI-C80060 mark
                " oeb916,oeb917,oeb15,oeb910,",        #CHI-C80060 add
                " oeb911,oeb912,oeb913,oeb914,oeb915,oebplant,oeblegal,oeb37) ",  #FUN-A90063    #FUN-AB0061 add oeb37
                "SELECT '",l_oea01 CLIPPED,"',pmn02,pmn04,pmn07,pmn09,",
                "       pmn041,pmn20,0,0,0,0,pmn20,0,0,",
                "       ' ',0,'1',",
               #"       pmn86,pmn87,pmn33,pmn33,pmn80,",  #FUN-B20060 add pmn33   #CHI-C80060 mark
                "       pmn86,pmn87,pmn33,pmn80,",        #CHI-C80060 add 
                "       pmn81,pmn82,pmn83,pmn84,pmn85,pmnplant,pmnlegal,0",   #FUN-A90063        #FUN-AB0061 add 0 
                "  FROM pmn_temp"
    PREPARE ins_oeb_temp FROM l_sql
    EXECUTE ins_oeb_temp
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins oeb_temp',SQLCA.sqlcode,1)
    END IF 
    SELECT * INTO l_oea.* FROM oea_temp
#更新經營方式    
    LET l_sql = "UPDATE oeb_temp a ",
                #"   SET oeb44 = (SELECT pmm51 FROM ",s_dbstring(l_dbs_f CLIPPED),"pmm_file", #FUN-A50102
                "   SET oeb44 = (SELECT pmm51 FROM ",cl_get_target_table(l_poy.poy04, 'pmm_file'), #FUN-A50102
                "                 WHERE pmm01 = '",l_pmm.pmm01,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
    UPDATE oeb_temp 
       SET oeb45 = 0,
           oeb47 = 0,
           oeb48 = '2',
           oeb1003 = '1',
           oeb19 = 'N',
           oeb23 = 0,
           oeb25 = 0,
           oeb26 = 0,
           oeb70 = 'N',
           oeb901 = 0,
           oeb905 = 0,
           oeb906 = 'Y',
           oebplant = l_oea.oeaplant,
           oeblegal = l_oea.oealegal
#銷售取價           
            DELETE FROM price_temp
            INSERT INTO price_temp(item,unit) SELECT DISTINCT oeb04,oeb05 FROM oeb_temp
            LET l_n = 0
            CALL t255_sub_fetch_price(l_pmm904,l_poy.poy04,'1',l_i)  RETURNING l_n
            IF l_n = 1 THEN
               IF l_oea.oea213 = 'N' THEN
                  LET l_sql = "UPDATE oeb_temp ",
                              "   SET oeb13 = (SELECT price FROM price_temp WHERE item = oeb04 AND unit = oeb05)"
                  EXECUTE IMMEDIATE l_sql    
                  UPDATE oeb_temp
                     SET oeb14 = oeb917*oeb13
                  UPDATE oeb_temp
                     SET oeb14t = oeb14*(1+l_oea.oea211/100)
               ELSE
                   LET l_sql = "UPDATE oeb_temp ",
                              "   SET oeb13 = (SELECT price FROM price_temp WHERE item = oeb04 AND unit = oeb05)"
                   EXECUTE IMMEDIATE l_sql        
                   LET l_sql = "UPDATE oeb_temp ",
                              "   SET oeb13 = oeb13*(1+",l_oea.oea211,"/100)"
                   EXECUTE IMMEDIATE l_sql        
                   UPDATE oeb_temp
                      SET oeb14t = oeb917*oeb13
                   UPDATE oeb_temp
                      SET oeb14 = oeb14t/(1+l_oea.oea211/100)
                   UPDATE oea_temp SET oea61 = (SELECT SUM(oeb14) FROM oeb_temp )  
               END IF
            END IF
   #FUN-AB0061 -----------add start------------
    LET l_sql = " UPDATE oeb_temp ",
                "    SET oeb37 = ( SELECT oeb13 FROM oeb_temp ) "
    EXECUTE IMMEDIATE l_sql
   #FUN-AB0061 ----------add end-----------------  
    IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oeb_file SELECT * FROM oeb_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_poy.poy04, 'oeb_file')," SELECT * FROM oeb_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102
         PREPARE oeb_ins FROM l_sql
         EXECUTE oeb_ins
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg("oea01",l_oea01,"INSERT INTO oeb_file",SQLCA.sqlcode,1)
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oea_file SELECT * FROM oea_temp" #FUN-A50102
           #LET l_sql = "INSERT INTO ",cl_get_target_table(l_poy.poy04, 'oeb_file')," SELECT * FROM oea_temp" #FUN-A50102   #FUN-AB0061 
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_poy.poy04, 'oea_file')," SELECT * FROM oea_temp"               #FUN-AB0061 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_poy.poy04) RETURNING l_sql  #FUN-A50102
            PREPARE oea_ins FROM l_sql
            EXECUTE oea_ins
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg("oea01",l_oea01,"INSERT INTO oea_file",SQLCA.sqlcode,1)
            END IF
         END IF
    END IF
    IF g_success = 'N' THEN
        LET g_success ='Y'
        LET g_totsuccess = 'N'
    END IF
END FUNCTION
 
#出貨單
FUNCTION t255_sub_ship(l_pmm99,l_plant,l_dbs)
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_plant LIKE pmm_file.pmmplant
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_oga01 LIKE oga_file.oga01
DEFINE l_oea RECORD LIKE oea_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_sql STRING
DEFINE l_n LIKE type_file.num5
DEFINE l_time LIKE oga_file.ogacont
 
#取預設單別   
    CALL t255_sub_def_no(l_dbs,'axm','50') RETURNING l_oga01 

    
#取訂單資料
    #LET l_sql = "SELECT oea_file.* FROM ",s_dbstring(l_dbs CLIPPED),"oea_file WHERE oea99 = ? AND oeaplant = ?" #FUN-A50102
    LET l_sql = "SELECT oea_file.* FROM ",cl_get_target_table(l_plant, 'oea_file')," WHERE oea99 = ? AND oeaplant = ?" #FUN-A50102
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
    PREPARE oea_cs FROM l_sql
    EXECUTE oea_cs USING l_pmm99,l_plant INTO l_oea.*
 
#自動編號
    IF NOT cl_null(l_oga01) THEN
       CALL s_auto_assign_no('axm',l_oga01,g_today,"50","oga_file","oga01",l_plant,"","")
            RETURNING li_result,l_oga01
       IF (NOT li_result) THEN                                                                           
          LET g_success = 'N'
          LET g_showmsg = l_oga01,"|",l_oea.oeaplant
          CALL s_errmsg('oga01,oeaplant',g_showmsg,'','sub-145',1)
       END IF
    END IF
    DELETE FROM oga_temp
    INSERT INTO oga_temp (oga01,oga50,oga52,oga53,oga54,oga85,oga94,oga161,oga162,oga163,ogaplant,ogalegal) #FUN-A90063
                      VALUES(l_oga01,0,0,0,0,' ','N',0,0,0,g_plant,g_legal) #FUN-A90063
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins oga_temp',SQLCA.sqlcode,1)
    END IF
       LET l_time = TIME
       UPDATE oga_temp
          SET oga00 = '1',
              oga02 = g_today,
              oga021= g_today,
              oga022= g_today,
              oga03 = l_oea.oea03,
              oga032= l_oea.oea032,
              oga033= l_oea.oea033,
              oga04 = l_oea.oea04,
              oga044= l_oea.oea044,
              oga05 = l_oea.oea05,
              oga06 = l_oea.oea06,
              oga07 = l_oea.oea07,
              oga08 = l_oea.oea08,
              oga09 = '6',
              oga11 = NULL,
              oga12 = NULL,
              oga14 = l_oea.oea14,
              oga15 = l_oea.oea15,
              oga16 = l_oea.oea01,
              oga161= l_oea.oea161,
              oga162= l_oea.oea162,
              oga163= l_oea.oea163,
              oga18 = l_oea.oea17,
              oga20 = 'Y',
              oga21 = l_oea.oea21,
              oga211= l_oea.oea211,
              oga212= l_oea.oea212,
              oga213= l_oea.oea213,
              oga23 = l_oea.oea23,
              oga24 = l_oea.oea24,
              oga25 = l_oea.oea25,
              oga26 = l_oea.oea26,
              oga27 = l_oea.oea27,
              oga28 = l_oea.oea18,
              oga29 = 0,
              oga30 = 'N',
              oga31 = l_oea.oea31,
              oga32 = l_oea.oea32,
              oga33 = l_oea.oea33,
              oga34 = 0,
              oga40 = l_oea.oea19,
              oga41 = l_oea.oea41,
              oga42 = l_oea.oea42,
              oga43 = l_oea.oea43,
              oga44 = l_oea.oea44,
              oga45 = l_oea.oea45,
              oga46 = l_oea.oea46,
              oga55 = '1',
              oga57 = '1', #FUN-AC0055 add
              oga65 = l_oea.oea65,
              oga69 = g_today,
              oga99 = l_pmm99,
              oga901='N',
              oga905='Y',
              oga906='N',
              oga909='Y',
              ogaconf='Y',
              ogapost='Y',
              ogaprsw=0,
              ogauser=g_user,
              ogagrup=g_grup,
              ogaoriu=g_user,
              ogaorig=g_grup,
              ogacont=l_time,
              ogadate=NULL,
              oga83 = l_oea.oea83,
              oga84 = l_oea.oea84,
              oga85 = l_oea.oea85,
              oga86 = l_oea.oea86,
              oga87 = l_oea.oea87,
              oga88 = l_oea.oea88,
              oga89 = l_oea.oea89,
              oga90 = l_oea.oea90,
              oga91 = l_oea.oea91,
              oga92 = l_oea.oea92,
              oga93 = l_oea.oea93,
              oga94 = 'N',
              ogaconu = g_user,
              ogacond = g_today,
              ogaplant = l_oea.oeaplant,
              ogalegal = l_oea.oealegal
 
    DELETE FROM ogb_temp
    LET l_sql = "INSERT INTO ogb_temp",
                "(ogb01,ogb03,ogb04,ogb05,ogb05_fac,ogb06,ogb07,",
                " ogb08,ogb09,ogb091,ogb092,ogb11,ogb12,ogb37,ogb13,ogb14,",   #FUN-AB0061 ADD ogb37
                " ogb14t,ogb15,ogb15_fac,ogb16,ogb17,ogb18,ogb19,ogb31,",
                " ogb32,ogb60,ogb63,ogb64,ogb910,ogb911,ogb912,ogb913,ogb914,",
                " ogb915,ogb916,ogb917,ogbplant,ogb1005,ogb1008,ogb1009,ogb1010,",
                " ogb44,ogb45,ogb46,ogb47,ogbplant,ogblegal)",  #FUN-A90063
                "SELECT '",l_oga01 CLIPPED,"',oeb03,oeb04,oeb05,oeb05_fac,oeb06,oeb07,",
                "       oeb08,oeb09,oeb091,oeb092,oeb11,oeb12,oeb37,oeb13,oeb14,",#FUN-AB0061 ADD oeb37 
                "       oeb14t,oeb05,1,oeb12,'N',oeb12,'Y',oeb01,",
                "       oeb03,0,0,0,oeb910,oeb911,oeb912,oeb913,oeb914,",
                "       oeb915,oeb916,oeb917,oebplant,'1',oeb1008,oeb1009,oeb1010,",
                "       oeb44,oeb45,oeb46,oeb47,oebplant,oeblegal",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"oeb_file", #FUN-A50102
                "  FROM ",cl_get_target_table(l_plant, 'oeb_file'), #FUN-A50102
                " WHERE oeb01 = '",l_oea.oea01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
    PREPARE ins_ogb_temp FROM l_sql
    EXECUTE ins_ogb_temp
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins ogb_temp',SQLCA.sqlcode,1)
    END IF
#如果是最后一站取出貨機構，否則取機構預設倉庫對應機構    
    IF g_post THEN
       LET l_sql = "UPDATE ogb_temp a ",
                   "   SET ogb09 = (SELECT ruj07 FROM ruj_file WHERE ruj01 = '",g_rui.rui01,"' AND ruj03 =a.ogb04),",
                   "       ogb091 = ' ',",
                   "       ogb092 = ' '"             
       EXECUTE IMMEDIATE l_sql
    ELSE
       #取預設成本倉   
       LET l_sql = "UPDATE ogb_temp a ",
                  #"   SET ogb09 = (SELECT rtz07 FROM rtz_file WHERE rtz01 = a.ogbplant),",    #FUN-C90049 mark 
                   "   SET ogb09 = '",s_get_coststore(l_oea.oeaplant,''),"'",                   #FUN-C90049 add           
                   "       ogb091 = ' ',",
                   "       ogb092 = ' '",             
                   " WHERE ogb44 = '1'"
       EXECUTE IMMEDIATE l_sql
       #取預設非成本倉 
       LET l_sql = "UPDATE ogb_temp a ",
                  #"   SET ogb09 = (SELECT rtz08 FROM rtz_file WHERE rtz01 = a.ogbplant),",    #FUN-C90049 mark
                   "   SET ogb09 = '",s_get_noncoststore(l_oea.oeaplant,''),"'",                   #FUN-C90049 add  
                   "       ogb091 = ' ',",
                   "       ogb092 = ' '",
                   " WHERE ogb44 <> '1'"
       EXECUTE IMMEDIATE l_sql
       SELECT COUNT(*) INTO l_n FROM ogb_temp WHERE ogb09 IS NULL
       IF l_n>0 THEN
          LET g_success='N'
          CALL s_errmsg('ogbplant','ogb09','sel rtz07/rtz08','art-524',1 )
       END IF
    END IF
#FUN-AB0061 -----------add start----------------                             
    LET l_sql = " UPDATE ogb_temp ",                                            
                "    SET ogb37 = ( SELECT ogb13 FROM ogb_temp) "                
    EXECUTE IMMEDIATE l_sql                                                     
#FUN-AB0061 -----------add end----------------  
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 ----------add start--------------
#    LET l_sql = " UPDATE ogb_temp ",
#                "    SET ogb50 = '1' WHERE ogb50 IS NULL "
#    EXECUTE IMMEDIATE l_sql
##FUN-AB0096 ----------add end---------------
#FUN-AC0055 mark ----------------------end------------------------
##FUN-C50097 ----------add start--------------
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb50 = '0' WHERE ogb50 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb51 = '0' WHERE ogb51 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb52 = '0' WHERE ogb52 IS NULL "
    EXECUTE IMMEDIATE l_sql     
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb53 = '0' WHERE ogb53 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb54 = '0' WHERE ogb54 IS NULL "
    EXECUTE IMMEDIATE l_sql
    LET l_sql = " UPDATE ogb_temp ",
                "    SET ogb55 = '0' WHERE ogb55 IS NULL "
    EXECUTE IMMEDIATE l_sql        
##FUN-C50097 ----------add end---------------
    IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"ogb_file SELECT * FROM ogb_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'ogb_file')," SELECT * FROM ogb_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
         PREPARE ogb_ins FROM l_sql
         EXECUTE ogb_ins
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg("oga01",l_oga01,"INSERT INTO ogb_file",SQLCA.sqlcode,1)
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"oga_file SELECT * FROM oga_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'oga_file')," SELECT * FROM oga_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
            PREPARE oga_ins FROM l_sql
            EXECUTE oga_ins
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg("oga01",l_oga01,"INSERT INTO oga_file",SQLCA.sqlcode,1)
            ELSE       
               #CALL t255_sub_ship_log(l_oga01,l_pmm99,l_dbs) #FUN-A50102
               CALL t255_sub_ship_log(l_oga01,l_pmm99,l_plant) #FUN-A50102
               IF g_success = 'Y' THEN
                  #CALL t255_sub_upd_ima1(l_dbs)    #FUN-A50102 mark
                   CALL t255_sub_upd_ima1(l_plant) #FUN-A50102 add
               END IF
            END IF
         END IF
    END IF
    IF g_success = 'N' THEN
        LET g_success ='Y'
        LET g_totsuccess = 'N'
    END IF
END FUNCTION
 
#img_file,tlf_file
#FUNCTION t255_sub_ship_log(l_oga01,l_pmm99,l_dbs) #FUN-A50102
FUNCTION t255_sub_ship_log(l_oga01,l_pmm99,l_plant) #FUN-A50102
DEFINE l_oga01 LIKE oga_file.oga01
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_tlf08 LIKE tlf_file.tlf08
DEFINE l_n LIKE type_file.num5
DEFINE l_ogb04 LIKE ogb_file.ogb04
DEFINE l_ogb09 LIKE ogb_file.ogb09
DEFINE l_ogb091 LIKE ogb_file.ogb091
DEFINE l_ogb092 LIKE ogb_file.ogb092
DEFINE l_ogb05 LIKE ogb_file.ogb05
DEFINE l_img09 LIKE img_file.img09
DEFINE l_ima01 LIKE ima_file.ima01               #TQC-9B0045 Add
DEFINE l_ima71 LIKE ima_file.ima71               #TQC-9B0045 Add
DEFINE l_plant LIKE pmm_file.pmmplant            #FUN-A50102
 
#最后一站更新img_file，中間站不更新
    IF g_post THEN
      #料件庫存資料不存在則新增一筆
      DELETE FROM img_temp
      LET l_sql = "INSERT INTO img_temp(img01,img02,img03,img04,img10,img21,imgplant,imglegal) ",    #FUN-A90063
                  "SELECT DISTINCT ogb04,ogb09,ogb091,ogb092,0,1,ogbplant,ogblegal FROM ogb_temp a", #FUN-A90063
                  #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                  "                    WHERE img01 = a.ogb04",
                  "                      AND img02 = a.ogb09",
                  "                      AND img03 = a.ogb091",
                  "                      AND img04 = a.ogb092)"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102                    
      EXECUTE IMMEDIATE l_sql
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins img_temp',SQLCA.sqlcode,1)
      END IF
      SELECT COUNT(img01) INTO l_n FROM img_temp
      IF l_n > 0 THEN
         LET l_sql = "UPDATE img_temp a",
                     "   SET img05 = '",l_oga01,"',",
                     "       img06 = (SELECT MIN(ogb03) FROM ogb_temp WHERE ogb04 = a.img01 AND ogb09 = a.img02),",
                     "       img13 = NULL,",
                     "       img17 = '",g_today,"',",
                     "       img20 = 1,",
                     "       img30 = 0,",
                     "       img31 = 0,",
                     "       img32 = 0,",
                     "       img33 = 0,",
                     "       img34 = 0,",
                     "       img37 = '",g_today,"'"
         EXECUTE IMMEDIATE l_sql
         LET l_sql = "UPDATE img_temp a ",
                     "       SET imgplant = (SELECT DISTINCT ogbplant FROM ogb_temp),",
                     "           imglegal = (SELECT DISTINCT ogblegal FROM ogb_temp)"
         EXECUTE IMMEDIATE l_sql
        #TQC-9B0045-Mark-Begin
#       LET l_sql = "UPDATE img_temp a",
#                   "   SET (img09,img18) = (SELECT ima25,DECODE(ima71,0,?,ima71 + ?)",
#                   "                          FROM ",s_dbstring(l_dbs CLIPPED),"ima_file",
#                   "                         WHERE ima01 = a.img01)"
#       PREPARE sh_img_upd1 FROM l_sql
#       EXECUTE sh_img_upd1 USING g_lastdat,g_today
        #TQC-9B0045-Mark-End
        #TQC-9B0045-Add-Begin
        LET l_sql = "UPDATE img_temp a",
                    "   SET img09 = (SELECT ima25",
                    #"                 FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "                 FROM ",cl_get_target_table(l_plant, 'ima_file'), #FUN-A50102
                    "                WHERE ima01 = a.img01)"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102            
        PREPARE sh_img_upd1 FROM l_sql
        EXECUTE sh_img_upd1
        LET l_sql = "   SELECT ima01,ima71 ",             
                    #"     FROM img_temp a ,",s_dbstring(l_dbs CLIPPED),"ima_file",  #FUN-A50102
                    "     FROM img_temp a ,",cl_get_target_table(l_plant, 'ima_file'),  #FUN-A50102
                    "    WHERE ima01 = a.img01"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
        PREPARE sh_ima71 FROM l_sql
        DECLARE ima_cs CURSOR FOR sh_ima71                                                                              
        FOREACH ima_cs INTO l_ima01,l_ima71
         IF l_ima71 = 0 THEN 
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",g_lastdat,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE sh_img_upd1_1 FROM l_sql
           EXECUTE sh_img_upd1_1
         ELSE
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",l_ima71+g_today,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE sh_img_upd1_2 FROM l_sql
           EXECUTE sh_img_upd1_2
         END IF
        END FOREACH
        #TQC-9B0045-Add-End
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT ime04,ime05,ime06,ime07,ime09",
                   #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"ime_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_plant, 'ime_file'), #FUN-A50102
                    "                                           WHERE ime01 = a.img02",
                    "                                             AND ime02 = a.img03 AND imeacti = 'Y')",   #FUN-D40103
                    " WHERE img22 IS NULL"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                      
        EXECUTE IMMEDIATE l_sql
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT imd10,imd11,imd12,imd13,imd08",
                   #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"imd_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_plant, 'imd_file'), #FUN-A50102
                    "                                           WHERE imd01 = a.img02)",
                    " WHERE img22 IS NULL"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102                      
        EXECUTE IMMEDIATE l_sql
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                    "SELECT * FROM img_temp"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102                      
        EXECUTE IMMEDIATE l_sql
      END IF
#判斷料件單位和庫存單位是否有轉換率
      LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                  " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                  "                    WHERE smd01 = a.ogb04",
                  "                      AND smd02 = a.ogb05",
                  #"                      AND smd03 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  "                      AND smd03 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                  "                                    WHERE img01 = a.ogb04",
                  "                                      AND img02 = a.ogb09",
                  "                                      AND img03 = a.ogb091",
                  "                                      AND img04 = a.ogb092))"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE sh_img_chk1 FROM l_sql
      EXECUTE sh_img_chk1 INTO l_n
      IF l_n > 0 THEN
         LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                     " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                     "                    WHERE smd01 = a.ogb04",
                     "                      AND smd03 = a.ogb05",
                    #"                      AND smd02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                     "                      AND smd02 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                     "                                    WHERE img01 = a.ogb04",
                     "                                      AND img02 = a.ogb09",
                     "                                      AND img03 = a.ogb091",
                     "                                      AND img04 = a.ogb092))"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
         PREPARE sh_img_chk2 FROM l_sql
         EXECUTE sh_img_chk2 INTO l_n
         IF l_n > 0 THEN
            LET l_sql = "SELECT COUNT(*) FROM ogb_temp ",
                       #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                        " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102                        "                    WHERE img01 = ogb04",
                        "                      AND img02 = ogb09",
                        "                      AND img03 = ogb091",
                        "                      AND img04 = ogb092",
                        "                      AND img09 = ogb05)"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
            PREPARE sh_img_chk3 FROM l_sql
            EXECUTE sh_img_chk3 INTO l_n
            IF l_n > 0 THEN
               LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                           " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                           "                    WHERE smc01 = a.ogb05",
                          #"                      AND smc02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                           "                      AND smc02 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                           "                                    WHERE img01 = a.ogb04",
                           "                                      AND img02 = a.ogb09",
                           "                                      AND img03 = a.ogb091",
                           "                                      AND img04 = a.ogb092))"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
               PREPARE sh_img_chk4 FROM l_sql
               EXECUTE sh_img_chk4 INTO l_n
               IF l_n > 0 THEN
                  LET l_sql = "SELECT COUNT(*) FROM ogb_temp a",
                              " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                              "                    WHERE smc02 = a.ogb05",
                             #"                      AND smc01 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                              "                      AND smc01 = (SELECT img09 FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                              "                                    WHERE img01 = a.ogb04",
                              "                                      AND img02 = a.ogb09",
                              "                                      AND img03 = a.ogb091",
                              "                                      AND img04 = a.ogb092))"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
                  PREPARE sh_img_chk5 FROM l_sql
                  EXECUTE sh_img_chk5 INTO l_n
                  IF l_n > 0 THEN
                     LET g_success = 'N'
                     LET l_sql = "SELECT ogb04,ogb09,ogb091,ogb092,ogb05 FROM ogb_temp a",
                                 " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                                 "                    WHERE smc02 = a.ogb05",
                                 "                      AND smc01 = (SELECT img09 ",
                                #"                                     FROM ",s_dbstring(l_dbs CLIPPED),"img_file",#FUN-A50102
                                 "                                     FROM ",cl_get_target_table(l_plant, 'img_file'),#FUN-A50102
                                 "                                    WHERE img01 = a.ogb04",
                                 "                                      AND img02 = a.ogb09",
                                 "                                      AND img03 = a.ogb091",
                                 "                                      AND img04 = a.ogb092))" 
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102                                 
                     DECLARE sh_img_chk_cs CURSOR FROM l_sql
                     FOREACH sh_img_chk_cs INTO l_ogb04,l_ogb09,l_ogb091,l_ogb092,l_ogb05
                        LET l_sql = "SELECT img09 ",
                                   #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                    "  FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                                    " WHERE img01 = ?",
                                    "   AND img02 = ?",
                                    "   AND img03 = ?",
                                    "   AND img04 = ?"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                        CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
                        PREPARE sh_img09_cs FROM l_sql
                        EXECUTE sh_img09_cs USING l_ogb04,l_ogb09,l_ogb091,l_ogb092 INTO l_img09
                        LET g_showmsg = l_ogb04,"|",l_ogb05,"|",l_img09
                        CALL s_errmsg('ogb04,ogb05,img09',g_showmsg,'','mfg3075',1)
                     END FOREACH
                  END IF
               END IF
            END IF
          END IF
      END IF
#更新庫存量，最近异動日期      
      #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"img_file a", #FUN-A50102
      LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'img_file')," a", #FUN-A50102
                  "   SET img10 = img10 - (SELECT ogb12 FROM ogb_temp",
                  "                         WHERE ogb04 = a.img01",
                  "                           AND ogb09 = a.img02",
                  "                           AND ogb091 = a.img03",
                  "                           AND ogb092 = a.img04),",
                  "       img16 = ?,",
                  "       img17 = ?",
                  " WHERE EXISTS (SELECT 1 FROM ogb_temp",
                  "                WHERE ogb04 = a.img01",
                  "                  AND ogb09 = a.img02",
                  "                  AND ogb091 = a.img03",
                  "                  AND ogb092 = a.img04)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
       PREPARE upd_img FROM l_sql
       EXECUTE upd_img USING g_today,g_today
     END IF
     
#tlf_file     
     DELETE FROM tlf_temp
     LET l_sql = "INSERT INTO tlf_temp ",
                 "(tlf01,tlf020,tlf021,tlf022,tlf023,tlf024,",
                 " tlf025,tlf026,tlf027,tlf030,tlf036,",
                 " tlf037,tlf10,tlf11,tlf12,tlf62,tlf63,tlf902,",
                 " tlf903,tlf904,tlf905,tlf906,tlfplant,tlflegal) ",
                 "SELECT ogb04,ogbplant,ogb09,ogb091,ogb092,ogb12,",
                 "       ogb910,ogb31,ogb32,ogbplant,ogb01,",
                 "       ogb03,ogb12,ogb15,ogb15_fac,ogb01,ogb03,ogb09,",
                 "       ogb091,ogb092,ogb01,ogb03,ogbplant,ogblegal",
                 "  FROM ogb_temp"
    PREPARE ins_tlf_temp FROM l_sql
    EXECUTE ins_tlf_temp
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       CALL s_errmsg('','','ins tlf_temp',SQLCA.sqlcode,1)
    END IF
    LET l_tlf08 = TIME
#TQC-9B0045-Mark-Begin
#   UPDATE tlf_temp
#      SET tlf02 = 50,
#          tlf03 = 724,
#          tlf06 = g_today,
#          tlf07 = g_today,
#          tlf08 = l_tlf08,
#          tlf09 = g_user,
#          tlf13 = 'axmt620',
#          tlf907 = -1,
#          tlf99 = l_pmm99,
#         #tlf61 = substr(tlf905,1,g_doc_len)  #FUN-9B0051
#          tlf61 = tlf905[1,g_doc_len]  #FUN-9B0051
#TQC-9B0045-Mark-End
#TQC-9B0045-Add-Begin
    LET l_sql = "  UPDATE tlf_temp ",
                "     SET tlf02 = 50,tlf03 = 724,",
                "         tlf06 = '",g_today,"',",
                "         tlf07 = '",g_today,"',",
                "         tlf08 = '",l_tlf08,"',",
                "         tlf09 = '",g_user,"',",
                "         tlf13 = 'axmt620',",
                "         tlf907 = -1,",
                "         tlf99 = '",l_pmm99,"',",
                "         tlf61 = tlf905[1,",g_doc_len,"]" 
      PREPARE tlf_upd_1 FROM l_sql
      EXECUTE tlf_upd_1
#TQC-9B0045-Add-End
    LET l_sql = "UPDATE tlf_temp a",
                "   SET (tlf024,tlf025) = (SELECT img10,img09",
                #"                            FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "                            FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                "                           WHERE img01 = a.tlf01",
                "                             AND img02 = a.tlf031",
                "                             AND img03 = a.tlf032",
                "                             AND img04 = a.tlf033)"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE tlf_temp a",
#                "   SET tlf18 = (SELECT ima261 + ima262 ", #FUN-A20044
#                "                  FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A20044
#                "                 WHERE ima01 = a.tlf01)"  #FUN-A20044
                 "   SET tlf18 = (SELECT SUM(img10*img21)",
                #"                  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                 "                  FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                 "                   WHERE img01 = a.tlf01 AND imgplant = a.tlfplant AND (img23 = 'Y' OR",
                 "                   img23 = 'N'))"  #FUN-A20044
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                   
    EXECUTE IMMEDIATE l_sql
    #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tlf_file", #FUN-A50102
    LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'tlf_file'), #FUN-A50102
                " SELECT * FROM tlf_temp"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
    PREPARE ins_tlf FROM l_sql
    EXECUTE ins_tlf
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       LET g_showmsg = l_oga01,'|',l_pmm99
       CALL s_errmsg('oga01,oga99',g_showmsg,'ins tlf_file ',SQLCA.sqlcode,1)
    END IF
END FUNCTION
 
#收貨單
FUNCTION t255_sub_receipt(l_pmm99,l_pmmplant,l_dbs) 
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_pmmplant LIKE pmm_file.pmmplant
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_pmm RECORD LIKE pmm_file.*
DEFINE l_rva01 LIKE rva_file.rva01
DEFINE l_rvb05 LIKE rvb_file.rvb05
DEFINE l_rvb36 LIKE rvb_file.rvb36
DEFINE l_rvb37 LIKE rvb_file.rvb37
DEFINE l_rvb38 LIKE rvb_file.rvb38
DEFINE l_rvb86 LIKE rvb_file.rvb86
DEFINE l_img09 LIKE img_file.img09
DEFINE li_result LIKE type_file.num5
DEFINE l_n   LIKE type_file.num5 
DEFINE l_ima01 LIKE ima_file.ima01                #TQC-9B0045 Add
DEFINE l_ima71 LIKE ima_file.ima71                #TQC-9B0045 Add
DEFINE l_time LIKE rva_file.rvacont
 
#取預設單別       
     CALL t255_sub_def_no(l_dbs,'apm','3') RETURNING l_rva01 
 
 
#取採購單資料  
     #LET l_sql = "SELECT pmm_file.* FROM ",s_dbstring(l_dbs CLIPPED),"pmm_file WHERE pmm99 = ? AND pmmplant = ?" #FUN-A50102
     LET l_sql = "SELECT pmm_file.* FROM ",cl_get_target_table(l_pmmplant, 'pmm_file')," WHERE pmm99 = ? AND pmmplant = ?" #FUN-A50102
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
     CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
     PREPARE receipt_pmm_cs FROM l_sql
     EXECUTE receipt_pmm_cs USING l_pmm99,l_pmmplant INTO l_pmm.*
 
#自動編號  
     IF NOT cl_null(l_rva01) THEN
        CALL s_auto_assign_no("apm",l_rva01,g_today,"3","rva_file","rva01",l_pmmplant,"","")
             RETURNING li_result,l_rva01
        IF (NOT li_result) THEN                                                                           
           LET g_success = 'N'
           CALL s_errmsg('rva01',l_rva01,'','sub-145',1)
        END IF
     END IF
     DELETE FROM rva_temp
     INSERT INTO rva_temp(rva01,rva29,rva32,rvamksg,rvaplant,rvalegal) VALUES(l_rva01,' ',' ',' ',g_plant,g_legal) #No.FUN-9C0088  #FUN-A90063
     IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rva_temp',SQLCA.sqlcode,1)
     END IF
       LET l_time = TIME 
        UPDATE rva_temp
           SET rva02 = l_pmm.pmm01,
               rva99 = l_pmm.pmm99,
               rva04 = 'N',
               rva00 = '1',   
               rva05 = l_pmm.pmm09,
               rva06 = g_today,
               rva10 = 'TAP',
               rvaprsw = 'N',
               rvaprno = 0,
               rva28 = NULL,
               rva29 = l_pmm.pmm51,
               rva30 = l_pmm.pmm52,
               rva31 = l_pmm.pmm53,
               rvaacti = 'Y',   
               rvauser = l_pmm.pmmuser,
               rvagrup = l_pmm.pmmgrup,
               rvaoriu = g_user,
               rvaorig = g_grup,
               rvacont = l_time,
               rvacrat = l_pmm.pmmcrat,
               rvaconf = 'Y',
               rvacond = l_pmm.pmmcond,
               rvaconu = l_pmm.pmmconu,
               rvaplant = l_pmm.pmmplant,
               rvalegal = l_pmm.pmmlegal
         WHERE rva01 = l_rva01
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL s_errmsg('','','upd rva_temp',SQLCA.sqlcode,1)
         END IF
     DELETE FROM rvb_temp      
     LET l_sql = "INSERT INTO rvb_temp ",
                 "(rvb01,rvb02,rvb03,rvb04,rvb05,rvb06,rvb07,rvb08,",
                 " rvb09,rvb10,rvb10t,rvb11,rvb12,rvb13,rvb14,rvb15,",
                 " rvb16,rvb17,rvb18,rvb19,rvb20,rvb21,rvb27,rvb28,",
                 " rvb29,rvb30,rvb31,rvb35,rvb36,rvb37,rvb38,rvb39,",
                 " rvb40,rvb41,rvb42,rvb43,rvb44,rvb45,rvb80,rvb81,",
                 " rvb82,rvb83,rvb84,rvb85,rvb86,rvb87,rvb88,rvb88t,rvb89,rvb90,rvbplant,rvblegal) ",
                 "SELECT '",l_rva01 CLIPPED,"',pmn02,pmn02,pmn01,pmn04,0,pmn20,pmn20,",
                 "       0,pmn31,pmn31t,0,pmn33,'','',0,",
                 "       0,'','30','1','','',0,0,",
                 "       0,pmn20,pmn20,'N','',' ',' ','N',",
                 "       '','',pmn73,pmn74,pmn75,pmn76,pmn80,pmn81,",
                 "       pmn82,pmn83,pmn84,pmn85,pmn86,pmn87,pmn88,pmn88t,'N',pmn07,pmnplant,pmnlegal",
                #"  FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
                 "  FROM ",cl_get_target_table(l_pmmplant, 'pmn_file'), #FUN-A50102
                 " WHERE pmn01 = '",l_pmm.pmm01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
      PREPARE ins_rvb_temp FROM l_sql
      EXECUTE ins_rvb_temp      
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rvb_temp',SQLCA.sqlcode,1)
      END IF
#取機構預設倉庫      
      IF l_pmm.pmm51 = '1' THEN
         UPDATE rvb_temp
           #SET rvb36 = (SELECT rtz07 FROM rtz_file WHERE rtz01 = l_pmm.pmmplant)    #FUN-C90049 mark
            SET rvb36 = s_get_coststore(l_pmm.pmmplant,'')                           #FUN-C90049 add  
      ELSE
         UPDATE rvb_temp
           #SET rvb36 = (SELECT rtz08 FROM rtz_file WHERE rtz01 = l_pmm.pmmplant)    #FUN-C90049 mark
            SET rvb36 = s_get_noncoststore(l_pmm.pmmplant,'')                           #FUN-C90049 add
      END IF
      SELECT COUNT(*) INTO l_n FROM rvb_temp WHERE rvb36 IS NULL
      IF l_n > 0 THEN
         CALL s_errmsg('rvaplant',l_pmm.pmmplant,'aooi901a','art-524',1)
         LET g_success = 'N'
      END IF
      
#如果img資料不存在則新增一筆      
      DELETE FROM img_temp
      LET l_sql = "INSERT INTO img_temp(img01,img02,img03,img04,img10,img21,imgplant,imglegal) ",  #FUN-A90063
                  "SELECT DISTINCT rvb05,rvb36,rvb37,rvb38,0,1,rvbplant,rvblegal FROM rvb_temp a", #FUN-A90063
                  #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                  "                    WHERE img01 = a.rvb05",
                  "                      AND img02 = a.rvb36",
                  "                      AND img03 = a.rvb37",
                  "                      AND img04 = a.rvb38)"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
      PREPARE ins_img_temp FROM l_sql
      EXECUTE ins_img_temp
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins img_temp',SQLCA.sqlcode,1)
      END IF
      SELECT COUNT(img01) INTO l_n FROM img_temp
      IF l_n > 0 THEN
         LET l_sql = "UPDATE img_temp a",
                     "   SET img05 = '",l_rva01,"',",
                     "       img06 = (SELECT MIN(rvb02) FROM rvb_temp WHERE rvb05 = a.img01 AND rvb36 = a.img02),",
                     "       img13 = NULL,",
                     "       img17 = '",g_today,"',",
                     "       img20 = 1,",
                     "       img30 = 0,",
                     "       img31 = 0,",
                     "       img32 = 0,",
                     "       img33 = 0,",
                     "       img34 = 0,",
                     "       img37 = '",g_today,"',",
                     "       imgplant = '",l_pmm.pmmplant,"',",
                     "       imglegal = '",l_pmm.pmmlegal,"'"
        EXECUTE IMMEDIATE l_sql
        #TQC-9B0045-Mark-Begin
#       LET l_sql = "UPDATE img_temp a",
#                   "   SET (img09,img18) = (SELECT ima25,DECODE(ima71,0,?,ima71 + ?)",
#                   "                          FROM ",s_dbstring(l_dbs CLIPPED),"ima_file",
#                   "                         WHERE ima01 = a.img01)"
#       PREPARE img_upd1 FROM l_sql
#       EXECUTE img_upd1 USING g_lastdat,g_today
        #TQC-9B0045-Mark-End
        #TQC-9B0045-Add-Begin
        LET l_sql = "UPDATE img_temp a",
                    "   SET img09 = (SELECT ima25",
                   #"                 FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "                 FROM ",cl_get_target_table(l_pmmplant, 'ima_file'), #FUN-A50102
                    "                WHERE ima01 = a.img01)"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
        PREPARE img_upd1 FROM l_sql
        EXECUTE img_upd1
        LET l_sql = "   SELECT ima01,ima71 ",   
                    #"     FROM img_temp a ,",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A50102
                    "     FROM img_temp a ,",cl_get_target_table(l_pmmplant, 'ima_file'), #FUN-A50102
                    "    WHERE ima01 = a.img01"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
        PREPARE sh_ima71_1 FROM l_sql
        DECLARE ima_cs_1 CURSOR FOR sh_ima71_1
        FOREACH ima_cs_1 INTO l_ima01,l_ima71
         IF l_ima71 = 0 THEN
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",g_lastdat,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE img_upd1_1 FROM l_sql
           EXECUTE img_upd1_1
         ELSE
           LET l_sql = "UPDATE img_temp a",
                       "   SET img18 = '",l_ima71+g_today,"'",
                       " WHERE a.img01 = '",l_ima01,"'"
           PREPARE img_upd1_2 FROM l_sql
           EXECUTE img_upd1_2
         END IF
        END FOREACH
        #TQC-9B0045-Add-End
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT ime04,ime05,ime06,ime07,ime09",
                    #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"ime_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_pmmplant, 'ime_file'), #FUN-A50102
                    "                                           WHERE ime01 = a.img02",
                    "                                             AND ime02 = a.img03 AND imeacti = 'Y')",   #FUN-D40103
                    " WHERE img22 IS NULL"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102                      
        EXECUTE IMMEDIATE l_sql
        LET l_sql = "UPDATE img_temp a",
                    "   SET (img22,img23,img24,img25,img26) = (SELECT imd10,imd11,imd12,imd13,imd08",
                    #"                                            FROM ",s_dbstring(l_dbs CLIPPED),"imd_file", #FUN-A50102
                    "                                            FROM ",cl_get_target_table(l_pmmplant, 'imd_file'), #FUN-A50102
                    "                                           WHERE imd01 = a.img02)",
                    " WHERE img22 IS NULL"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql  #FUN-A50102                      
        EXECUTE IMMEDIATE l_sql
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"img_file ", #FUN-A50102
        LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                    " SELECT * FROM img_temp"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
        PREPARE ins_img FROM l_sql
        EXECUTE ins_img
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('','','ins img_file',SQLCA.sqlcode,1)
        END IF
      END IF
#判斷是否有換算率
      LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                  " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                  "                    WHERE smd01 = a.rvb05",
                  "                      AND smd02 = a.rvb86",
                  #"                      AND smd03 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  "                      AND smd03 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                  "                                    WHERE img01 = a.rvb05",
                  "                                      AND img02 = a.rvb36",
                  "                                      AND img03 = a.rvb37",
                  "                                      AND img04 = a.rvb38))"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
      PREPARE img_chk1 FROM l_sql
      EXECUTE img_chk1 INTO l_n
      IF l_n > 0 THEN
         LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                     " WHERE NOT EXISTS (SELECT 1 FROM smd_file ",
                     "                    WHERE smd01 = a.rvb05",
                     "                      AND smd03 = a.rvb86",
                    #"                      AND smd02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                     "                      AND smd02 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                     "                                    WHERE img01 = a.rvb05",
                     "                                      AND img02 = a.rvb36",
                     "                                      AND img03 = a.rvb37",
                     "                                      AND img04 = a.rvb38))"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
         PREPARE img_chk2 FROM l_sql
         EXECUTE img_chk2 INTO l_n
         IF l_n > 0 THEN
            LET l_sql = "SELECT COUNT(*) FROM rvb_temp ",
                        #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                        "  WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                        "                    WHERE img01 = rvb05",
                        "                      AND img02 = rvb36",
                        "                      AND img03 = rvb37",
                        "                      AND img04 = rvb38",
                        "                      AND img09 = rvb86)"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
            PREPARE img_chk3 FROM l_sql
            EXECUTE img_chk3 INTO l_n
            IF l_n > 0 THEN 
               LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                           " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                           "                    WHERE smc01 = a.rvb86",
                           #"                      AND smc02 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                           "                      AND smc02 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                           "                                    WHERE img01 = a.rvb05",
                           "                                      AND img02 = a.rvb36",
                           "                                      AND img03 = a.rvb37",
                           "                                      AND img04 = a.rvb38))"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
               CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
               PREPARE img_chk4 FROM l_sql
               EXECUTE img_chk4 INTO l_n
               IF l_n > 0 THEN
                  LET l_sql = "SELECT COUNT(*) FROM rvb_temp a",
                              " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                              "                    WHERE smc02 = a.rvb86",
                              #"                      AND smc01 = (SELECT img09 FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                              "                      AND smc01 = (SELECT img09 FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                              "                                    WHERE img01 = a.rvb05",
                              "                                      AND img02 = a.rvb36",
                              "                                      AND img03 = a.rvb37",
                              "                                      AND img04 = a.rvb38))"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
                  PREPARE img_chk5 FROM l_sql
                  EXECUTE img_chk5 INTO l_n
                  IF l_n > 0 THEN
                     LET l_sql = "SELECT rvb05,rvb36,rvb37,rvb38,rvb86 FROM rvb_temp a",
                                 " WHERE NOT EXISTS (SELECT 1 FROM smc_file ",
                                 "                    WHERE smc02 = a.rvb86",
                                 "                      AND smc01 = (SELECT img09 ",
                                 #"                                     FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                 "                                     FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                                 "                                    WHERE img01 = a.rvb05",
                                 "                                      AND img02 = a.rvb36",
                                 "                                      AND img03 = a.rvb37",
                                 "                                      AND img04 = a.rvb38))"
                                 
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
                   CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102                
                     DECLARE img_chk_cs CURSOR FROM l_sql
                     LET g_success = 'N'
                     FOREACH img_chk_cs INTO l_rvb05,l_rvb36,l_rvb37,l_rvb38,l_rvb86
                        LET l_sql = "SELECT img09 ",
                                   #"  FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                                    "  FROM ",cl_get_target_table(l_pmmplant, 'img_file'), #FUN-A50102
                                    " WHERE img01 = ?",
                                    "   AND img02 = ?",
                                    "   AND img03 = ?",
                                    "   AND img04 = ?"
                        CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                        CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
                        PREPARE img09_cs FROM l_sql
                        EXECUTE img09_cs USING l_rvb05,l_rvb36,l_rvb37,l_rvb38 INTO l_img09
                        LET g_showmsg = l_pmmplant,"|",l_rvb05,"|",l_rvb86,"|",l_img09
                        CALL s_errmsg('rvbplant,rvb05,rvb86,img09',g_showmsg,'','mfg3075',1)
                     END FOREACH
                  END IF
               END IF
            END IF
          END IF
      END IF
      IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rvb_file SELECT * FROM rvb_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'rvb_file')," SELECT * FROM rvb_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
         PREPARE rvb_ins FROM l_sql
         EXECUTE rvb_ins
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL s_errmsg("rvb01",l_rva01,"INSERT INTO rvb_file",SQLCA.sqlcode,1)
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rva_file SELECT * FROM rva_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_pmmplant, 'rva_file')," SELECT * FROM rva_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_pmmplant) RETURNING l_sql      #FUN-A50102
            PREPARE rva_ins FROM l_sql
            EXECUTE rva_ins
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg("rvb01",l_rva01,"INSERT INTO rva_file",SQLCA.sqlcode,1)
            ELSE    
               #CALL t255_sub_receipt_log(l_rva01,l_dbs) #FUN-A50102
               CALL t255_sub_receipt_log(l_rva01,l_pmmplant) #FUN-A50102
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN
         LET g_success ='Y'
         LET g_totsuccess = 'N'
      END IF
END FUNCTION
 
#入庫更新料件資料
#FUNCTION t255_sub_upd_ima(l_dbs)  #FUN-A50102 mark
FUNCTION t255_sub_upd_ima(l_plant) #FUN-A50102 add
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_sql   STRING
DEFINE l_plant LIKE poy_file.poy04 #FUN-A50102 add
###########FUN-A20044----BEGIN 
#更新MPS/MRP可用庫存量
   #  LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
#   #              "   SET ima26 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A20044
     #            "                 WHERE img01= a.ima01 AND img24='Y')",
      #           " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
       #          "                WHERE rvv31 = a.ima01)"
   #  EXECUTE IMMEDIATE l_sql
#更新不可用庫存量     
   #  LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
    #             "   SET ima261 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
     #            "                 WHERE img01= a.ima01 AND img23='N')",
      #           " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
       #          "                WHERE rvv31 = a.ima01)"
  #   EXECUTE IMMEDIATE l_sql
#更新庫存可用量     
   #   LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
    #             "   SET ima262 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
     #            "                 WHERE img01= a.ima01 AND img23='Y')",
      #           " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
       #          "                WHERE rvv31 = a.ima01)"
#     EXECUTE IMMEDIATE l_sql
#更新最近异動日，最近入庫日     
     #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
     LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file a'), #FUN-A50102
                 "   SET ima29 = '",g_today,"',",
                 "       ima73 = '",g_today,"'",
                 " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
                 "                WHERE rvv31 = a.ima01)"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                   
    EXECUTE IMMEDIATE l_sql
#更新首次入庫日
    #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file a'), #FUN-A50102
                "   SET ima1013 = '",g_today,"'",
                " WHERE EXISTS (SELECT 1 FROM rvv_temp ",
                "                WHERE rvv31 = a.ima01)",
                "   AND ima1013 IS NULL"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
##########FUN-A20044-----END
END FUNCTION
 
#出貨更新料件資料
#FUNCTION t255_sub_upd_ima1(l_dbs)  #FUN-A50102 mark
FUNCTION t255_sub_upd_ima1(l_plant) #FUN-A50102 add
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_sql   STRING
DEFINE l_plant LIKE poy_file.poy04 #FUN-A50102 add
########FUN-A20044-----BEGIN 
#更新MPS/MRP可用存量
#     LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
 #                "   SET ima26 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
  #               "                 WHERE img01= a.ima01 AND img24='Y')",
   #              " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
    #             "                WHERE ogb04 = a.ima01)"
 #    EXECUTE IMMEDIATE l_sql
#更新不可用存量
  #   LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
   #              "   SET ima261 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
    #             "                 WHERE img01= a.ima01 AND img23='N')",
    #             " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
     #            "                WHERE ogb04 = a.ima01)"
 #    EXECUTE IMMEDIATE l_sql
#更新存可用量
  #    LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a",
   #              "   SET ima262 = (SELECT COALESCE(SUM(img10*img21),0) FROM ",s_dbstring(l_dbs CLIPPED),"img_file",
    #             "                 WHERE img01= a.ima01 AND img23='Y')",
     #            " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
      #           "                WHERE ogb04 = a.ima01)"
#     EXECUTE IMMEDIATE l_sql
#更新最近异動日，最近出貨日
     #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
     LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file a'), #FUN-A50102
                 "   SET ima29 = '",g_today,"',",
                 "       ima74 = '",g_today,"'",
                 " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
                 "                WHERE ogb04 = a.ima01)"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                   
    EXECUTE IMMEDIATE l_sql
#更新首次出貨日
    #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"ima_file a ", #FUN-A50102
    LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'ima_file a'), #FUN-A50102
                "   SET ima1012 = '",g_today,"'",
                " WHERE EXISTS (SELECT 1 FROM ogb_temp ",
                "                WHERE ogb04 = a.ima01)",
                "   AND ima1012 IS NULL"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql  #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
#######FUN-A20044-----END
END FUNCTION
 
#入庫單
#FUNCTION t255_sub_stockin(l_dbs)   #FUN-A50102 mark
FUNCTION t255_sub_stockin(l_plant)  #FUN-A50102 add
DEFINE l_rvu01 LIKE rvu_file.rvu01
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rva RECORD LIKE rva_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_sql STRING
DEFINE l_n     LIKE type_file.num5
DEFINE l_rvucont LIKE rvu_file.rvucont
DEFINE l_rvu03   LIKE rvu_file.rvu03
DEFINE l_rvu04   LIKE rvu_file.rvu04
DEFINE l_plant   LIKE poy_file.poy04  #FUN-A50102 add
   
#取預設單別   
   #CALL t255_sub_def_no(l_dbs,'apm','7') RETURNING l_rvu01 #FUN-A50102
   CALL t255_sub_def_no(l_plant,'apm','7') RETURNING l_rvu01 #FUN-A50102
 
#取收貨資料
   SELECT * INTO l_rva.* FROM rva_temp
   IF NOT cl_null(l_rvu01) THEN
      CALL s_auto_assign_no("apm",l_rvu01,g_today,"7","rvu_file","rvu01",l_rva.rvaplant,"","")
           RETURNING li_result,l_rvu01
      IF (NOT li_result) THEN                                                                           
         LET g_success = 'N'
         CALL s_errmsg('rvu01',l_rvu01,'','sub-145',1)
      END IF
   END IF
   DELETE FROM rvu_temp
   LET l_rvu03 = l_rva.rva06
   LET l_rvu04 = l_rva.rva05
  #TQC-B60065 Begin---
  #INSERT INTO rvu_temp(rvu01,rvu21,rvu900,rvumksg,rvupos,rvuplant,rvulegal)  #FUN-A90063
  #   VALUES(l_rvu01,' ','1','N','N',g_plant,g_legal)  #FUN-A90063
   INSERT INTO rvu_temp(rvu01,rvu21,rvu900,rvumksg,rvupos,rvuplant,rvulegal,rvu27)
      VALUES(l_rvu01,' ','1','N','N',g_plant,g_legal,'1')
  #TQC-B60065 End-----
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('','','ins rvu_temp',SQLCA.sqlcode,1)
   END IF
   LET l_rvucont = TIME
   UPDATE rvu_temp 
      SET rvu00 = '1',
          rvu99 = l_rva.rva99,
          rvu01 = l_rvu01,
          rvu02 = l_rva.rva01,
          rvu03 = l_rva.rva06,
          rvu04 = l_rva.rva05,
          rvu05 = (SELECT pmc03 FROM pmc_file WHERE pmc01=l_rva.rva05),
          rvu06 = g_grup,
          rvu07 = g_user,
          rvu08 = l_rva.rva10,
          rvu20 = 'Y',
          rvu21 = l_rva.rva29,
          rvu22 = l_rva.rva30,
          rvu23 = l_rva.rva31,
          rvuconf = 'Y',
          rvuacti = 'Y',   #No.FUN-A10123
          rvucond = l_rva.rvacond,
          rvuconu = l_rva.rvaconu,
          rvucont = l_rvucont,
          rvuuser = l_rva.rvauser,
          rvugrup = l_rva.rvagrup,
          rvuoriu = g_user,
          rvuorig = g_grup,
          rvucrat = l_rva.rvacrat,
          rvuplant = l_rva.rvaplant,
          rvulegal = l_rva.rvalegal
   
   DELETE FROM rvv_temp
      LET l_sql = "INSERT INTO rvv_temp(rvv01,rvv02,rvv03,rvv04,rvv05,  ",                  
                  "                     rvv06,rvv09,rvv17,rvv18,rvv23,rvv24,rvv25, ",      
                  "                     rvv26,rvv31,rvv031,rvv32,rvv33,rvv34,rvv35,  ",    
                  "                     rvv35_fac,rvv36,rvv37,rvv38,rvv39,rvv40,rvv41,rvv42,rvv43, ", 
                  "                     rvv80,rvv81,rvv82,rvv83,rvv84,rvv85,   ",    
                  "                     rvv86,rvv87,rvv39t,rvv38t,rvv930,rvv88,  ", 
                  "                     rvvud01,rvvud02,rvvud03,rvvud04,rvvud05,rvvud06,rvvud07,rvvud08,rvvud09,rvvud10,rvvud11,rvvud12,rvvud13,rvvud14,rvvud15,", 
                  "                     rvv89,rvvplant,rvvlegal,rvv10,rvv11,rvv12,rvv13) ", 
                  "SELECT '",l_rvu01 CLIPPED,"',rvb02,'1',rvb01,rvb02,",
                  "       '",l_rvu04 CLIPPED,"','",l_rvu03,"',rvb31,rvb34,0,' ',rvb35,",
                  "       ' ',rvb05,'',rvb36,rvb37,rvb38,rvb86,", 
                  "       '',rvb04,rvb03,rvb10,rvb88,'N',rvb25,'','', ",
                  "       rvb80,rvb81,rvb82,rvb83,rvb84,rvb85,",
                  "       rvb86,rvb87,rvb88t,rvb10t,rvb930,0,",
                  "       '','','','','','','','','','','','','','','',",
                  "       'N',rvbplant,rvblegal,rvb42,rvb43,rvb44,rvb45",
                  "  FROM rvb_temp"
      PREPARE ins_rvv_temp FROM l_sql
      EXECUTE ins_rvv_temp
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins rvv_temp',SQLCA.sqlcode,1)
      END IF
      LET l_sql = "UPDATE rvv_temp a",
                  #"   SET (rvv031,rvv35_fac) = (SELECT pmn041,pmn09 FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
                  "   SET (rvv031,rvv35_fac) = (SELECT pmn041,pmn09 FROM ",cl_get_target_table(l_plant, 'pmn_file'), #FUN-A50102
                  "                              WHERE pmn01 = a.rvv36",
                  "                                AND pmn02 = a.rvv37)"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE rvv_temp_upd FROM l_sql
      EXECUTE rvv_temp_upd
      IF g_success = 'Y' THEN
         #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rvu_file SELECT * FROM rvu_temp" #FUN-A50102
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'rvu_file')," SELECT * FROM rvu_temp" #FUN-A50102
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
         PREPARE rvu_ins FROM l_sql
         EXECUTE rvu_ins
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("rvu01",l_rvu01,'insert into rvu_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE
            #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"rvv_file SELECT * FROM rvv_temp" #FUN-A50102
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'rvv_file')," SELECT * FROM rvv_temp" #FUN-A50102
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
            PREPARE rvv_ins FROM l_sql
            EXECUTE rvv_ins
            IF SQLCA.sqlcode THEN
               CALL s_errmsg("rvv01",l_rvu01,'insert into rvv_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
            ELSE
               #CALL t255_sub_stockin_log(l_rvu01,l_rva.rva99,l_dbs) #FUN-A50102
               CALL t255_sub_stockin_log(l_rvu01,l_rva.rva99,l_plant) #FUN-A50102
               IF g_success = 'Y' THEN
                  #CALL t255_sub_upd_ima(l_dbs) #FUN-A50102 mark
                   CALL t255_sub_upd_ima(l_plant) #FUN-A50102 add
               END IF
            END IF
         END IF
      END IF
      IF g_success = 'N' THEN
         LET g_success ='Y'
         LET g_totsuccess = 'N'
      END IF
END FUNCTION
 
#收貨單日志
#FUNCTION t255_sub_receipt_log(l_rva01,l_dbs) #FUN-A50102
FUNCTION t255_sub_receipt_log(l_rva01,l_plant) #FUN-A50102
DEFINE l_rva01 LIKE rva_file.rva01
DEFINE l_rva05 LIKE rva_file.rva05
DEFINE l_rva06 LIKE rva_file.rva06
DEFINE l_rva99 LIKE rva_file.rva99
DEFINE l_tlf08 LIKE tlf_file.tlf08
DEFINE l_sql STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_plant LIKE pmm_file.pmmplant #FUN-A50102
   
   DELETE FROM tlf_temp
   INSERT INTO tlf_temp
             (tlf01,tlf020,tlf026,tlf027,tlf030,tlf031,tlf032,tlf033,
              tlf036,tlf037,tlf10,tlf62,tlf63,tlf64,tlfplant,tlflegal)
   SELECT rvb05,rvbplant,rvb04,rvb03,rvbplant,rvb36,rvb37,rvb38,
          rvb01,rvb02,rvb07,rvb04,rvb03,rvb25,rvbplant,rvblegal
     FROM rvb_temp
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('','','ins tlf_temp',SQLCA.sqlcode,1)
   END IF
   LET l_tlf08 = TIME
   SELECT rva05,rva06,rva99 
     INTO l_rva05,l_rva06,l_rva99
     FROM rva_temp WHERE rva01 = l_rva01
   LET l_sql = " UPDATE tlf_temp ",
               "    SET tlf02 = 10,",
               "        tlf03  = 20,",
               "        tlf13  = 'apmt1101',",
               "        tlf06  = '",l_rva06,"',",
               "        tlf07  = '",g_today,"',",
               "        tlf08  = '",l_tlf08,"',",
               "        tlf09  = '",g_user,"',",
               "        tlf19  = '",l_rva05,"',",
               "        tlf902 = tlf031,",
               "        tlf903 = tlf032,",
               "        tlf904 = tlf033,",
               "        tlf905 = tlf036,",
               "        tlf906 = tlf037,",
               "        tlf907 = 0,",
               "        tlf99  = '",l_rva99,"',",
               "        tlf61  = tlf036[1,'",g_doc_len,"'] "
    PREPARE tlf_upd_2 FROM l_sql
    EXECUTE tlf_upd_2

      LET l_sql = "UPDATE tlf_temp a",
                  "   SET (tlf11,tlf12) = (SELECT pmn07,pmn09",
                  #"                          FROM ",s_dbstring(l_dbs CLIPPED),"pmn_file", #FUN-A50102
                  "                          FROM ",cl_get_target_table(l_plant, 'pmn_file'), #FUN-A50102
                  "                         WHERE pmn01 = a.tlf026 ",
                  "                           AND pmn02 = a.tlf027),",
#                  "        tlf18 = (SELECT ima261 + ima262 ", #FUN-A20044
#                  "                   FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A20044
#                  "                  WHERE ima01 = a.tlf01)" #FUN-A20044
                  "         tlf18 = (SELECT SUM(img10*img21) ",
                  #"                    FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                  "                    FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                  "                     WHERE img01 = a.tlf01 AND imgplant = a.tlfplant AND (img23 = 'Y' OR",
                  "                       img23 = 'N'))"  #FUN-A20044
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE re_tlf_upd FROM l_sql
      EXECUTE re_tlf_upd
      #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tlf_file", #FUN-A50102
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'tlf_file'), #FUN-A50102
                  " SELECT * FROM tlf_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE re_ins_tlf FROM l_sql
      EXECUTE re_ins_tlf
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('rva01',l_rva01,'ins tlf_file',SQLCA.sqlcode,1)
      END IF
END FUNCTION
 
#入庫單日志
#FUNCTION t255_sub_stockin_log(l_rvu01,l_pmm99,l_dbs) #FUN-A50102
FUNCTION t255_sub_stockin_log(l_rvu01,l_pmm99,l_plant) #FUN-A50102
DEFINE l_rvu01 LIKE rvu_file.rvu01
DEFINE l_pmm99 LIKE pmm_file.pmm99
DEFINE l_dbs  LIKE azp_file.azp03
DEFINE l_sql STRING
DEFINE l_tlf08 LIKE tlf_file.tlf08
DEFINE l_plant LIKE poy_file.poy04  #FUN-A50102 
 
#中間站庫存不异動
     IF g_post THEN     
        #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"img_file a", #FUN-A50102
        LET l_sql = "UPDATE ",cl_get_target_table(l_plant, 'img_file a'), #FUN-A50102
                    "   SET img10 = img10 + (SELECT rvv17 FROM rvv_temp",
                    "                         WHERE rvv31 = a.img01",
                    "                           AND rvv32 = a.img02",
                    "                           AND rvv33 = a.img03",
                    "                           AND rvv34 = a.img04),",
                    "       img15 = ?,",
                    "       img17 = ?",
                    " WHERE EXISTS (SELECT 1 FROM rvv_temp",
                    "                WHERE rvv31 = a.img01",
                    "                  AND rvv32 = a.img02",
                    "                  AND rvv33 = a.img03",
                    "                  AND rvv34 = a.img04)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
       PREPARE st_upd_img FROM l_sql
       EXECUTE st_upd_img USING g_today,g_today
     END IF
     DELETE FROM tlf_temp
     INSERT INTO tlf_temp(tlf01,tlf020,tlf026,tlf027,tlf030,tlf031,tlf032,
                          tlf033,tlf034,tlf035,tlf036,tlf037,
                          tlf06,tlf10,tlf11,tlf12,tlf14,tlf19,
                          tlf20,tlf62,tlf63,tlf64,tlfplant,tlflegal)
     SELECT rvv31,rvvplant,rvv04,rvv05,rvvplant,rvv32,rvv33,
            rvv34,rvv17,rvv35,rvv01,rvv02,
            rvv09,rvv17,rvv35,rvv35_fac,rvv26,rvv06,
            rvv34,rvv36,rvv37,rvv41,rvvplant,rvvlegal
       FROM rvv_temp
     IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','ins tlf_temp',SQLCA.sqlcode,1)
     END IF
     LET l_tlf08 = TIME
     UPDATE tlf_temp
        SET tlf02  = 20,                #來源狀況
            tlf03=50,                   
            tlf06=g_today,
            tlf07=g_today,              #異動資料產生日期
            tlf08=l_tlf08,              #異動資料產生時:分:秒
            tlf09=g_user,               #產生人
            tlf13='apmt150',            #異動命令代號
           #tlf61=substr(tlf905,1,3),  #FUN-9B0051
            tlf61=tlf905[1,3],  #FUN-9B0051
            tlf902 = tlf031,
            tlf903 = tlf032,
            tlf904 = tlf033,
            tlf905 = tlf036,
            tlf906 = tlf037,
            tlf907 = 1,
            tlf99 = l_pmm99 
    LET l_sql = "UPDATE tlf_temp a",
                "   SET (tlf034,tlf035) = (SELECT img10,img09",
                #"                            FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "                            FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                "                           WHERE img01 = a.tlf01",
                "                             AND img02 = a.tlf031",
                "                             AND img03 = a.tlf032",
                "                             AND img04 = a.tlf033)"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
    PREPARE st_tlf_upd3 FROM l_sql
    EXECUTE st_tlf_upd3
    LET l_sql = "UPDATE tlf_temp a",
#                "   SET tlf18 = (SELECT ima261 + ima262 ", #FUN-A20044
#                "                  FROM ",s_dbstring(l_dbs CLIPPED),"ima_file", #FUN-A20044
#                "                 WHERE ima01 = a.tlf01)" #FUN-A20044
                "    SET tlf18 = (SELECT SUM(img10*img21) ",
                #"                   FROM ",s_dbstring(l_dbs CLIPPED),"img_file", #FUN-A50102
                "                   FROM ",cl_get_target_table(l_plant, 'img_file'), #FUN-A50102
                "                    WHERE img01 = a.tlf01 AND imgplant = a.tlfplant AND (img23 = 'Y' OR",
                "                      img23 = 'N'))"  #FUN-A20044
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE st_tlf_upd4 FROM l_sql
      EXECUTE st_tlf_upd4
      #LET l_sql = "INSERT INTO ",s_dbstring(l_dbs CLIPPED),"tlf_file", #FUN-A50102
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'tlf_file'), #FUN-A50102
                  " SELECT * FROM tlf_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
      PREPARE st_ins_tlf FROM l_sql
      EXECUTE st_ins_tlf
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('rvu01',l_rvu01,'ins tlf_file',SQLCA.sqlcode,1)
      END IF
END FUNCTION

FUNCTION t255_sub_temptable()
 
   SELECT * FROM oea_file WHERE 1=0 INTO TEMP oea_temp
   SELECT * FROM oeb_file WHERE 1=0 INTO TEMP oeb_temp
   SELECT pmn_file.* FROM pmn_file WHERE 1 = 0 INTO TEMP pmn_temp
   SELECT rva_file.* FROM rva_file WHERE 1 = 0 INTO TEMP rva_temp
   SELECT rvb_file.* FROM rvb_file WHERE 1 = 0 INTO TEMP rvb_temp
   SELECT rvu_file.* FROM rvu_file WHERE 1 = 0 INTO TEMP rvu_temp
   SELECT rvv_file.* FROM rvv_file WHERE 1 = 0 INTO TEMP rvv_temp
   SELECT oga_file.* FROM oga_file WHERE 1 = 0 INTO TEMP oga_temp
   SELECT ogb_file.* FROM ogb_file WHERE 1 = 0 INTO TEMP ogb_temp
   SELECT img_file.* FROM img_file WHERE 1 = 0 INTO TEMP img_temp
   SELECT tlf_file.* FROM tlf_file WHERE 1 = 0 INTO TEMP tlf_temp
   #CREATE TEMP TABLE price_temp(
   #plant1   LIKE azp_file.azp01,
   #plant2   LIKE azp_file.azp01,
   #plant3   LIKE azp_file.azp01,
   #item     LIKE rth_file.rth01,
   #unit     LIKE rth_file.rth02,
   #ima131   LIKE ima_file.ima131,
   #rtl04    LIKE rtl_file.rtl04,
   #rtl05    LIKE rtl_file.rtl05,
   #rtl06    LIKE rtl_file.rtl06,
   #price    LIKE rth_file.rth04,
   #rtg08    LIKE rtg_file.rtg08);
END FUNCTION
 
FUNCTION t255_sub_y_droptable()
    DROP TABLE pmn_temp
    DROP TABLE oea_temp
    DROP TABLE oeb_temp
    DROP TABLE rva_temp
    DROP TABLE rvb_temp
    DROP TABLE rvu_temp
    DROP TABLE rvv_temp
    DROP TABLE oga_temp
    DROP TABLE ogb_temp
    DROP TABLE img_temp
    DROP TABLE tlf_temp
    #DROP TABLE price_temp
END FUNCTION

#FUNCTION t255_sub_def_no(l_dbs,l_rye01,l_rye02) #FUN-A50102
FUNCTION t255_sub_def_no(l_plant,l_rye01,l_rye02) #FUN-A50102
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_rye01 LIKE rye_file.rye01
DEFINE l_rye02 LIKE rye_file.rye02
DEFINE l_sql STRING
DEFINE l_no LIKE rva_file.rva01
DEFINE l_plant LIKE poy_file.poy04  #FUN-A50102
 
   #LET l_sql = "SELECT rye03 FROM ",l_dbs CLIPPED,"rye_file", #FUN-A50102
   #FUN-C90050 mark begin---
   #LET l_sql = "SELECT rye03 FROM ",cl_get_target_table(l_plant, 'rye_file'), #FUN-A50102
   #            " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'" 
   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
   #CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql      #FUN-A50102
   #PREPARE rye_trans FROM l_sql
   #EXECUTE rye_trans USING l_rye01,l_rye02 INTO l_no
   #FUN-C90050 mark end-----
 
   CALL s_get_defslip(l_rye01,l_rye02,l_plant,'N') RETURNING l_no    #FUN-C90050 add  

   IF cl_null(l_no) THEN
      CALL s_errmsg('rye03',l_no,'rye_file','art-330',1)
      LET g_success = 'N'
      RETURN ''
   END IF
   RETURN l_no
END FUNCTION
FUNCTION t255_sub_fetch_price(p_no,p_org,p_type,p_num)
DEFINE p_no    LIKE poz_file.poz01
DEFINE p_org   LIKE tsk_file.tskplant
DEFINE p_type  LIKE type_file.chr1
DEFINE l_cust  LIKE tsk_file.tskplant
DEFINE p_num   LIKE type_file.num5
DEFINE l_success LIKE type_file.chr1
DEFINE l_price LIKE tqn_file.tqn05
DEFINE l_pox03 LIKE pox_file.pox03
DEFINE l_pox05 LIKE pox_file.pox05
DEFINE l_pox06 LIKE pox_file.pox06
DEFINE l_sql   STRING
DEFINE l_pmc930 LIKE pmc_file.pmc930
DEFINE l_poy03 LIKE poy_file.poy03
DEFINE l_plant LIKE pmc_file.pmc930
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_max   LIKE poy_file.poy02
DEFINE l_min   LIKE poy_file.poy02
DEFINE l_cnt   LIKE type_file.num5
 

       CALL s_pox(p_no,p_num,g_today) RETURNING l_pox03,l_pox05,l_pox06,l_cnt
       IF l_cnt = 0 THEN
          LET g_success = 'N'
          LET l_price = 0
          CALL s_errmsg('pox01',p_no,'','art-484',1) 
          RETURN 0
       END IF
       SELECT MIN(poy02),MAX(poy02) 
         INTO l_min,l_max FROM poy_file
        WHERE poy01 = p_no 
          CASE l_pox03
            WHEN '1' SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_min
            WHEN '2' IF p_num = l_min THEN
                        SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_min
                     ELSE
                       SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = (p_num-1) 
                     END IF
                     
            WHEN '3' SELECT poy04 INTO l_cust
                       FROM poy_file
                      WHERE poy01 = p_no
                        AND poy02 = l_max
            WHEN '4' IF p_num = l_max THEN
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = l_no
                          AND poy02 = l_max
                     ELSE
                        SELECT poy04 INTO l_cust
                          FROM poy_file
                         WHERE poy01 = l_no
                           AND poy02 = (p_num + 1)
                     END IF
          END CASE
       IF p_type='0' THEN
          IF p_num = l_max THEN
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
             AND poy02 = l_max
          ELSE
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
                AND poy02 = p_num + 1 
          END IF
       ELSE
          IF p_num = l_min THEN
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
             AND poy02 = l_min
          ELSE
             SELECT poy03 INTO l_poy03 FROM poy_file WHERE poy01=p_no
                AND poy02 = p_num -1
          END IF
       END IF
       LET g_plant_new = l_poy03
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       IF cl_null(l_dbs) THEN
          LET g_success = 'N'
          CALL s_errmsg('azp01',l_poy03,'','art-002',1)
          RETURN 0
       END IF
       #LET l_sql = "SELECT pmc930 FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
       LET l_sql = "SELECT pmc930 FROM ",cl_get_target_table(l_poy03, 'pmc_file'), #FUN-A50102
                   " WHERE pmc01 = ? AND pmcacti = 'Y' AND pmc05 = '1'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_poy03) RETURNING l_sql      #FUN-A50102
       PREPARE pmc_sel FROM l_sql
       EXECUTE pmc_sel USING l_poy03 INTO l_plant
       IF cl_null(l_plant) THEN
          LET g_success = 'N'
          CALL s_errmsg('pmc930',l_poy03,'','art-479',1)
          RETURN 0
       END IF
       
       LET g_plant_new = l_cust
       CALL s_gettrandbs()
       LET l_dbs=g_dbs_tra
       IF cl_null(l_dbs) THEN
          LET g_success = 'N'
          CALL s_errmsg('azp01',l_cust,'','art-002',1)
          RETURN 0
       END IF
       #LET l_sql = "SELECT pmc930 FROM ",s_dbstring(l_dbs CLIPPED),"pmc_file", #FUN-A50102
       LET l_sql = "SELECT pmc930 FROM ",cl_get_target_table(l_cust, 'pmc_file'), #FUN-A50102
                   " WHERE pmc01 = ? AND pmcacti = 'Y' AND pmc05 = '1'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
       CALL cl_parse_qry_sql(l_sql, l_cust) RETURNING l_sql      #FUN-A50102
       PREPARE pmc_sel1 FROM l_sql
       EXECUTE pmc_sel1 USING l_cust INTO l_pmc930
       IF cl_null(l_pmc930) THEN
          LET g_success = 'N'
          CALL s_errmsg('pmc930',l_cust,'','art-479',1)
          RETURN 0
       END IF
       IF p_type='0' THEN
          UPDATE price_temp SET plant1 = l_plant,
                                plant2 = p_org,
                                plant3 = l_pmc930
       ELSE
          UPDATE price_temp SET plant1 = p_org,
                                plant2 = l_plant,
                                plant3 = l_pmc930
       END IF
       CALL t255_sub_trade_price()  
       IF g_success = 'N' THEN
          RETURN 0
       END IF 
       RETURN 1
END FUNCTION
 
FUNCTION t255_sub_trade_price()
DEFINE l_sql STRING
DEFINE l_dbs LIKE azp_file.azp03
DEFINE l_rtz05 LIKE rtz_file.rtz05
DEFINE l_n LIKE type_file.num5
 
    LET l_sql = "UPDATE price_temp a ",
                "   SET ima131 = (SELECT ima131 FROM ima_file",
                "                  WHERE ima01 = a.item",
                "                    AND imaacti = 'Y')"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = a.plant2",
                "                                 AND rtl07 = a.ima131",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = '*'",
                "                                 AND rtl07 = a.ima131",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = a.plant2",
                "                                 AND rtl07 = '*'",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET (rtl04,rtl05,rtl06) = (SELECT rtl04,rtl05,rtl06",
                "                                FROM rtl_file",
                "                               WHERE rtl01 = a.plant1",
                "                                 AND rtl03 = '*'",
                "                                 AND rtl07 = '*'",
                "                                 AND rtlacti = 'Y')",
                " WHERE rtl04 IS NULL",
                "   AND rtl06 IS NULL"
    EXECUTE IMMEDIATE l_sql
    SELECT DISTINCT plant3 
      INTO g_plant_new FROM price_temp
    CALL s_gettrandbs()
    LET l_dbs=g_dbs_tra
    IF cl_null(l_dbs) THEN
       LET g_success = 'N' 
       CALL s_errmsg('azp01','','azp_file','art-330',1)
    END IF
    #LET l_sql = "SELECT DISTINCT rtz05 FROM ",s_dbstring(l_dbs),"rtz_file", #FUN-A50102
    LET l_sql = "SELECT DISTINCT rtz05 FROM ",cl_get_target_table(g_plant_new, 'rtz_file'), #FUN-A50102
               " WHERE rtz01=(SELECT DISTINCT plant3 FROM price_temp)"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
    CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql      #FUN-A50102
    PREPARE rtz05_sel FROM l_sql
    EXECUTE rtz05_sel INTO l_rtz05
    LET l_sql = "UPDATE price_temp a",
                "   SET rtg08 = (SELECT rtg08 FROM rtg_file",
                "                 WHERE rtg01 = '",l_rtz05,"'",
                "                   AND rtg03 = a.item",
                "                   AND rtg04 = a.unit",
                "                   AND rtg09 = 'Y')"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET price = (SELECT rth04 FROM rth_file",
                "                 WHERE rthacti = 'Y'",
                "                   AND rth02 = a.unit",
                "                   AND rthplant = a.plant3",
                "                   AND rth01 = a.item)",
                " WHERE rtl04 = '2'",
                "   AND rtg08 = 'Y'",
                "   AND price IS NULL"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a ",
                "   SET price = (SELECT rtg05 FROM rtg_file",
                "                 WHERE rtg01 = '",l_rtz05,"'",
                "                   AND rtg03 = a.item",
                "                   AND rtg04 = a.unit",
                "                   AND rtg09 = 'Y')",
                " WHERE rtl04 = '2'",
                "   AND price IS NULL"
    EXECUTE IMMEDIATE l_sql 
    LET l_sql = "DELETE FROM price_temp a",
                #" WHERE NOT EXISTS (SELECT 1 FROM ",s_dbstring(l_dbs CLIPPED),"tqm_file,", #FUN-A50102
                " WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(g_plant_new, 'tqm_file'),",", #FUN-A50102
                #                                    s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                                                     cl_get_target_table(g_plant_new, 'tqn_file'), #FUN-A50102
                "                    WHERE tqm01 = tqn01",
                "                      AND tqn01 = a.rtl05 ",
                "                      AND tqn03 = a.item ",
                "                      AND tqm04 = '1'",
                "                      AND tqm06 = '4'",
                "                      AND tqn06 <= '",g_today,"' ",
                "                      AND (tqn07 IS NULL OR tqn07 >='",g_today,"'))",
                "   AND rtl04 = '3'"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT tqn05 ",
                #"                  FROM ",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                   FROM ", cl_get_target_table(g_plant_new, 'tqn_file'), #FUN-A50102
                "                 WHERE tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item ",
                "                   AND tqn04 = a.unit) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"   
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, g_plant_new) RETURNING l_sql  #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
    #CALL t255_sub_umfchk(l_dbs) #FUN-A50102
    CALL t255_sub_umfchk(g_plant_new) #FUN-A50102
    UPDATE price_temp SET price = price*rtl06/100
     WHERE rtl04='2'
    SELECT COUNT(*) INTO l_n FROM price_temp WHERE price IS NULL
    IF l_n>0 THEN
       LET g_success='N'
       CALL s_errmsg('tqm01,tqn03,tqn04','rtl05','atmi227','art-340',1)
    END IF
END FUNCTION

#FUNCTION t255_sub_umfchk(l_dbs) #FUN-A50102
FUNCTION t255_sub_umfchk(p_plant) #FUN-A50102
DEFINE l_sql   STRING
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE p_plant LIKE pmc_file.pmc930 #FUN-A50102 
 
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rth04) FROM smd_file,rth_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd02 = a.unit",
                "                   AND smd03 = rth02",
                "                   AND smd01 = rth01)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rth04) FROM smd_file,rth_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd03 = a.unit",
                "                   AND smd02 = rth02",
                "                   AND smd01 = rth01)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rtg05) FROM smd_file,rtg_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd02 = a.unit",
                "                   AND smd03 = rtg04",
                "                   AND smd01 = rtg03)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*rtg05) FROM smd_file,rtg_file ",
                "                 WHERE smd01 = a.item",
                "                   AND smd03 = a.unit",
                "                   AND smd02 = rtg04",
                "                   AND smd01 = rtg03)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rth04) FROM smc_file,rth_file",
                "                 WHERE smc01 = a.unit",
                "                   AND smc02 = rth02",
                "                   AND smcacti = 'Y'",
                "                   AND rth01 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rth04) FROM smc_file,rth_file",
                "                 WHERE smc02 = a.unit",
                "                   AND smc01 = rth02",
                "                   AND smcacti = 'Y'",
                "                   AND rth01 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'",
                "   AND rtg08 = 'Y'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rtg05) FROM smc_file,rtg_file",
                "                 WHERE smc01 = a.unit",
                "                   AND smc02 = rtg04",
                "                   AND smcacti = 'Y'",
                "                   AND rtg03 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*rtg05) FROM smc_file,rtg_file",
                "                 WHERE smc02 = a.unit",
                "                   AND smc01 = rtg04",
                "                   AND smcacti = 'Y'",
                "                   AND rtg03 = a.item)",
                " WHERE price IS NULL",
                "   AND rtl04 = '2'"
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*tqn05)",
                #"                  FROM smd_file,",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM smd_file,",cl_get_target_table(p_plant, 'tqn_file'), #FUN-A50102
                "                 WHERE smd01 = tqn03",
                "                   AND smd02 = a.unit",
                "                   AND smd03 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"     
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql  #FUN-A50102                  
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smd06/smd04*tqn05)",
                #"                  FROM smd_file,",s_dbstring(l_dbs CLIPPED),"tqn_file", #FUN-A50102
                "                  FROM smd_file,",cl_get_target_table(p_plant, 'tqn_file'), #FUN-A50102
                "                 WHERE smd01 = tqn03",
                "                   AND smd03 = a.unit",
                "                   AND smd02 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"     
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql  #FUN-A50102                 
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*tqn05)",
                #"                  FROM smc_file,",s_dbstring(l_dbs CLIPPED),"tqn_file",#FUN-A50102
                "                  FROM smc_file,",cl_get_target_table(p_plant, 'tqn_file'),#FUN-A50102
                "                 WHERE smc01 = a.unit",
                "                   AND smc02 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"    
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql  #FUN-A50102                 
    EXECUTE IMMEDIATE l_sql
    LET l_sql = "UPDATE price_temp a",
                "   SET price = (SELECT MAX(smc04/smc03*tqn05)",
                #"                  FROM smc_file,",s_dbstring(l_dbs CLIPPED),"tqn_file",#FUN-A50102
                "                  FROM smc_file,",cl_get_target_table(p_plant, 'tqn_file'),#FUN-A50102
                "                 WHERE smc02 = a.unit",
                "                   AND smc01 = tqn04",
                "                   AND tqn01 = a.rtl05 ",
                "                   AND tqn03 = a.item) ",
                " WHERE rtl04 = '3'",
                "   AND price IS NULL"   
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
                  CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql  #FUN-A50102                 
    EXECUTE IMMEDIATE l_sql
 
END FUNCTION
#FUN-A10123
