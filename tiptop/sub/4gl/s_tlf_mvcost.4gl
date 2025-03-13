# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: s_tlf_mvcost.4gl
# Descriptions...: 過帳計算移動加權平均成本
# Date & Author..: 13/02/17 By fengrui NO.FUN-BC0062
# Modify.........: No.TQC-D30052 13/03/20 By lixh1 當tlf907 = 0 時返回TRUE
# Modify.........: No.FUN-D30065 13/03/22 By lixh1 移動加權平均成本cfa12計算方式調整
# Modify.........: No.TQC-D30071 13/03/27 By lixh1 出庫情況只有倉退抓畫面檔單價,其他情況取最近入庫成本作為單價
# Modify.........: No.TQC-D40026 13/04/15 By fengrui 1.倉庫間調撥不計算;2.倉退單視為入庫負項、銷退單視為出庫負項
# Modify.........: No.TQC-D40032 13/04/16 By fengrui 重抓g_ccz相關數據
# Modify.........: No.TQC-D40117 13/04/28 By fengrui 調整移動加權成本的單價、數量、金額的小數取位
# Modify.........: No.TQC-D60060 13/06/18 By fengrui 倉退單視為入庫負項、銷退單視為出庫負項時的金額調整
# Modify.........: No.FUN-D60091 13/06/20 By lixh1 調整FUN-BC0062規格修改內容
# Modify.........: No.FUN-D70070 13/07/12 By lixh1 如果出货单走签收,则出货单过帐时不处理,签收单过帐时才写cfa_file,
#                                                  同理,如果走发出商品,在出货单/销退单过帐时也不处理,开票单过帐时才写cfa_file
# Modify.........: No.TQC-D80002 13/08/01 By lixh1 axmt700銷退oha09 = '5' 時，cfa08/cfa09從oha_file抓取ohb13/ohb14

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_tlf_mvcost(p_plant)
DEFINE p_plant  LIKE azp_file.azp01 
DEFINE l_cfa02  LIKE cfa_file.cfa02
DEFINE l_cfa10  LIKE cfa_file.cfa10
DEFINE l_cfa11  LIKE cfa_file.cfa11
DEFINE l_time   LIKE type_file.chr50
DEFINE l_cfa    RECORD LIKE cfa_file.*  
DEFINE l_yy     LIKE type_file.num5 
DEFINE l_mm     LIKE type_file.num5
DEFINE g_sql    STRING
DEFINE l_oga65  LIKE oga_file.oga65    #FUN-D70070  add
DEFINE l_omf10  LIKE omf_file.omf10    #FUN-D70070  add
DEFINE l_oha09  LIKE oha_file.oha09    #TQC-D80002
DEFINE l_ohb14  LIKE ohb_file.ohb14    #TQC-D80002
   
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'  #TQC-D40032
   SELECT oaz_file.* INTO g_oaz.* FROM oaz_file WHERE oaz00='0'  #FUN-D70070
   IF g_ccz.ccz28 <> '6' THEN RETURN TRUE END IF
   #TQC-D40026--add--str--
   IF g_tlf.tlf13 = 'aimt324' OR g_tlf.tlf13 = 'aimt325' OR g_tlf.tlf13 = 'aimt720' THEN
      RETURN TRUE 
   END IF
   #TQC-D40026--add--end--
#FUN-D70070 -----Begin----
   IF g_tlf.tlf13 = 'axmt620' OR g_tlf.tlf13 = 'axmt650' THEN  # 出貨走簽收不產生cfa_file
      SELECT oga65 INTO l_oga65 FROM oga_file
       WHERE oga01 = g_tlf.tlf905
      IF l_oga65 = 'Y' THEN
         RETURN TRUE
      END IF 
   END IF   
   IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN    #走發出商品
      IF g_tlf.tlf13 = 'axmt620' OR g_tlf.tlf13 = 'axmt650' OR g_tlf.tlf13 = 'aomt800' THEN  #出貨/銷退不產生cfa_file,由axmt670產生
         RETURN TRUE
      END IF
   END IF    
#FUN-D70070 -----End------
   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF
   LET g_plant_new = p_plant 
#工單流程也需計算移動加權成本
#FUN-D30065 ----------Begin----------
#  #使用移動加權成本只適用於流通進銷存,不可走工單流程 
#  IF g_tlf.tlf13[1,3] = 'asf' THEN 
#  #  RETURN FALSE
#     RETURN RTUE
#  END IF
#FUN-D30065 ----------End------------
   #取得單據扣帳日期的年度期別
   CALL s_yp(g_tlf.tlf06) RETURNING l_yy,l_mm
   IF l_mm = 1 THEN
      LET l_mm = 12
      LET l_yy = l_yy-1
   ELSE
      LET l_mm  = l_mm-1
   END IF
   #只有入庫和出庫的單據才會產生cfa_file的資料，不對庫存產生異動的單據不需要產生cfa_file的資料
   LET l_cfa.cfa04 = g_tlf.tlf907     #lixh1
   #TQC-D40026--add--str--
   IF g_tlf.tlf13='aomt800' THEN
      LET l_cfa.cfa04 = '-1'
   END IF  
   IF g_tlf.tlf13='apmt1072' THEN
      LET l_cfa.cfa04 = '1'
   END IF  
   #TQC-D40026--add--end--
#FUN-D70070 ----Begin-----
   IF g_tlf.tlf13='axmt670' THEN
      SELECT omf10 INTO l_omf10 FROM omf_file
       WHERE omf00 = g_tlf.tlf905
         AND omf21 = g_tlf.tlf906
      IF l_omf10 = '2' THEN   #銷退
         LET l_cfa.cfa04 = '-1'
      END IF
   END IF
#FUN-D70070 ----End-------
 # IF l_cfa.cfa04 = 0 THEN RETURN FALSE END IF     #lixh1  #TQC-D30052 mark
   IF l_cfa.cfa04 = 0 THEN RETURN TRUE END IF      #TQC-D30052
   #cfa00 yymmddhhmmss--
   LET l_time =CURRENT YEAR TO FRACTION(4)
   LET l_time = l_time[1,4],l_time[6,7],l_time[9,10],l_time[12,13],l_time[15,16],l_time[18,19],l_time[21,22]
   LET l_cfa.cfa00 = l_time
   
   LET l_cfa.cfa01 = g_tlf.tlf01

   #SELECT MAX(cfa02)+1 INTO l_cfa02 FROM cfa_file WHERE cfa01 = g_tlf.tlf01
   LET g_sql = "SELECT MAX(cfa02)+1 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
               " WHERE cfa01 = '", g_tlf.tlf01 ,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE mvcost_pre1 FROM g_sql
   DECLARE mvcost_cs1 CURSOR FOR mvcost_pre1
   OPEN mvcost_cs1
   FETCH mvcost_cs1 INTO l_cfa02
   
   IF cl_null(l_cfa02) THEN LET l_cfa02 = 1 END IF 
   LET l_cfa.cfa02 = l_cfa02
   LET l_cfa.cfa03 = g_tlf.tlf13
#  LET l_cfa.cfa04 = p_tlf907
   IF l_cfa.cfa04 = 0 THEN RETURN FALSE END IF     #lixh1
   #cfa04=-1先給cfa12賦值
   #抓取最近一次入庫單價
   LET g_sql = "SELECT cfa12 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
               " WHERE cfa01= '", l_cfa.cfa01 ,"' AND cfa04=1 ",
               "   AND cfa02=(SELECT MAX(cfa02) FROM cfa_file WHERE cfa01='",l_cfa.cfa01,"' AND cfa04=1 )"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE mvcost_pre2 FROM g_sql
   DECLARE mvcost_cs2 CURSOR FOR mvcost_pre2
   OPEN mvcost_cs2
   FETCH mvcost_cs2 INTO l_cfa.cfa12
      
   LET l_cfa.cfa05 = g_tlf.tlf905
   LET l_cfa.cfa06 = g_tlf.tlf906
   LET l_cfa.cfa07 = g_tlf.tlf10 
   #cfa08异动单价/cfa09异动金额
   IF l_cfa.cfa04 = 1 THEN 
      IF l_cfa.cfa03 = 'aimt302' OR l_cfa.cfa03 = 'aimt312' THEN 
         #单价抓inb13/inb14
         LET g_sql = "SELECT inb13,inb14 FROM ",cl_get_target_table(g_plant_new,'inb_file'),
                     " WHERE inb01 = '", g_tlf.tlf905 ,"' AND inb03 = '",g_tlf.tlf906,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE mvcost_pre3 FROM g_sql
         DECLARE mvcost_cs3 CURSOR FOR mvcost_pre3
         OPEN mvcost_cs3
         FETCH mvcost_cs3 INTO l_cfa.cfa08,l_cfa.cfa09
         LET l_cfa.cfa08 = l_cfa.cfa08/g_tlf.tlf12    #FUN-D60091 add
      END IF 
      IF l_cfa.cfa03 = 'apmt150' OR l_cfa.cfa03 = 'apmt230' THEN 
         #单价抓rvv38; 金额抓rvv39
         LET g_sql = "SELECT rvv38,rvv39 FROM ",cl_get_target_table(g_plant_new,'rvv_file'),
                     " WHERE rvv01 = '", g_tlf.tlf905 ,"' AND rvv02 = '",g_tlf.tlf906,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE mvcost_pre4 FROM g_sql
         DECLARE mvcost_cs4 CURSOR FOR mvcost_pre4
         OPEN mvcost_cs4
         FETCH mvcost_cs4 INTO l_cfa.cfa08,l_cfa.cfa09
         LET l_cfa.cfa08 = l_cfa.cfa08/g_tlf.tlf12    #FUN-D60091 add
      END IF 
 #FUN-D30065 --------Begin-----------
 #    #銷退->axmt700
 #    IF l_cfa.cfa03 = 'aomt800' THEN 
 #       #单价抓ohb13; 金额抓ohb14
 #       LET g_sql = "SELECT ohb13,ohb14 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
 #                   " WHERE ohb01 = '", g_tlf.tlf905 ,"' AND ohb03 = '",g_tlf.tlf906,"' "
 #       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
 #       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
 #       PREPARE mvcost_pre5 FROM g_sql
 #       DECLARE mvcost_cs5 CURSOR FOR mvcost_pre5
 #       OPEN mvcost_cs5
 #       FETCH mvcost_cs5 INTO l_cfa.cfa08,l_cfa.cfa09
 #    END IF 
 #FUN-D30065 --------End--------------
      #TQC-D40026--add--str--
      IF l_cfa.cfa03 = 'apmt1072' THEN      #採購單倉退 
         #採購單倉退单价抓rvv38; 金额抓rvv39
         LET g_sql = "SELECT rvv38,rvv39 FROM ",cl_get_target_table(g_plant_new,'rvv_file'),
                     " WHERE rvv01 = '", g_tlf.tlf905 ,"' AND rvv02 = '",g_tlf.tlf906,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE mvcost_pre12 FROM g_sql
         DECLARE mvcost_cs12 CURSOR FOR mvcost_pre12
         OPEN mvcost_cs12
         FETCH mvcost_cs12 INTO l_cfa.cfa08,l_cfa.cfa09
         #因为rvv38,rvv39非必輸欄位,所以當rvv38 = 0 時取最近一次入庫單價
         IF l_cfa.cfa08 = 0 THEN
            LET l_cfa.cfa08 = l_cfa.cfa12
            LET l_cfa.cfa09 = l_cfa.cfa07 * l_cfa.cfa08
         END IF
      END IF 
      #TQC-D40026--add--str--
    # IF l_cfa.cfa03 = 'aimp880' OR l_cfa.cfa03 = 'artt215' THEN     #FUN-D30065 mark
   #FUN-D70070 --------Begin--------
    # IF l_cfa.cfa03 = 'aimp880' OR l_cfa.cfa03 = 'artt215' OR l_cfa.cfa03 = 'aomt800' OR g_tlf.tlf13[1,3] = 'asf' THEN   #FUN-D30065
      IF l_cfa.cfa03 = 'aimp880' OR l_cfa.cfa03 = 'artt215' OR l_cfa.cfa03 = 'aomt800' OR g_tlf.tlf13[1,3] = 'asf'
         OR (l_cfa.cfa03 = 'axmt670' AND l_omf10 = '2') THEN
   #FUN-D70070 --------End----------
         #单价抓cfa12; 金额抓cfa07*cfa08
         LET g_sql = "SELECT cfa12 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
                     " WHERE cfa01= '", l_cfa.cfa01 ,"' AND cfa04=1 ",
                     "   AND cfa02=(SELECT MAX(cfa02) FROM cfa_file WHERE cfa01='",l_cfa.cfa01,"' AND cfa04=1 )"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE mvcost_pre6 FROM g_sql
         DECLARE mvcost_cs6 CURSOR FOR mvcost_pre6
         OPEN mvcost_cs6
         FETCH mvcost_cs6 INTO l_cfa.cfa08
         LET l_cfa.cfa09 = l_cfa.cfa07 * l_cfa.cfa08
      END IF 
      #調撥
      #TQC-D40026--mark--add--
      #IF l_cfa.cfa03 = 'aimt324' OR l_cfa.cfa03 = 'aimt325' OR l_cfa.cfa03 = 'aimt720' THEN
      #   LET g_sql = "SELECT cfa08,cfa09 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
      #               " WHERE cfa01 = '", l_cfa.cfa01 ,"' AND cfa04 = -1 ",
      #               "   AND cfa05 = '",g_tlf.tlf905,"'",
      #               "   AND cfa06 = '",g_tlf.tlf906,"'"
      #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      #   PREPARE mvcost_pre13 FROM g_sql
      #   DECLARE mvcost_cs13 CURSOR FOR mvcost_pre13
      #   OPEN mvcost_cs13
      #   FETCH mvcost_cs13 INTO l_cfa.cfa08,l_cfa.cfa09
      #END IF   
      #TQC-D40026--mark--end--
      #產品還入
      IF l_cfa.cfa03 = 'artt263' THEN
         LET g_sql = "SELECT rur08,rur15 FROM ",cl_get_target_table(g_plant_new,'rur_file'),
                     " WHERE rur00 = '2'", 
                     "   AND rur01 = '",g_tlf.tlf905,"'",
                     "   AND rur02 = '",g_tlf.tlf906,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE mvcost_pre14 FROM g_sql
         DECLARE mvcost_cs14 CURSOR FOR mvcost_pre14
         OPEN mvcost_cs14
         FETCH mvcost_cs14 INTO l_cfa.cfa08,l_cfa.cfa09
      END IF   
      IF l_cfa.cfa03 = 'aimt306' OR l_cfa.cfa03 = 'aemt201' THEN  #其他入庫視同出庫處理,抓取最近一次入庫的cfa12
         LET l_cfa.cfa08 = l_cfa.cfa12
         LET l_cfa.cfa09 = l_cfa.cfa07 * l_cfa.cfa08
      END IF
   END IF 
   IF l_cfa.cfa04 = -1 THEN 
   #  IF l_cfa.cfa03 = 'apmt1072' OR l_cfa.cfa03 = 'artt262' THEN   #採購單倉退    #FUN-D30065 mark
   #  IF l_cfa.cfa03 = 'apmt1072' OR l_cfa.cfa03 = 'artt262' OR l_cfa.cfa03 = 'axmt620' THEN   #FUN-D30065    #TQC-D30071  mark
         #TQC-D40026--mark--str--   
         #IF l_cfa.cfa03 = 'apmt1072' THEN      #採購單倉退 
         #   #採購單倉退单价抓rvv38; 金额抓rvv39
         #   LET g_sql = "SELECT rvv38,rvv39 FROM ",cl_get_target_table(g_plant_new,'rvv_file'),
         #               " WHERE rvv01 = '", g_tlf.tlf905 ,"' AND rvv02 = '",g_tlf.tlf906,"' "
         #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         #   PREPARE mvcost_pre12 FROM g_sql
         #   DECLARE mvcost_cs12 CURSOR FOR mvcost_pre12
         #   OPEN mvcost_cs12
         #   FETCH mvcost_cs12 INTO l_cfa.cfa08,l_cfa.cfa09
         #   #FUN-D30065 --------Begin-------
         #   #因为rvv38,rvv39非必輸欄位,所以當rvv38 = 0 時取最近一次入庫單價
         #   IF l_cfa.cfa08 = 0 THEN
         #      LET l_cfa.cfa08 = l_cfa.cfa12
         #      LET l_cfa.cfa09 = l_cfa.cfa07 * l_cfa.cfa08
         #   END IF
         #   #FUN-D30065 --------End---------
         #TQC-D40026--mark--end--
   #TQC-D30071 --------Begin----------
   #     END IF
   #     IF l_cfa.cfa03 = 'artt262' THEN 
   #     #借出單抓取rur08,rur15 
   #        LET g_sql = "SELECT rur08,rur15 FROM ",cl_get_target_table(g_plant_new,'rur_file'),
   #                    " WHERE rur00 = '1'",
   #                    "   AND rur01 = '",g_tlf.tlf905,"'",
   #                    "   AND rur02 = '",g_tlf.tlf906,"' "
   #        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   #        PREPARE mvcost_pre15 FROM g_sql
   #        DECLARE mvcost_cs15 CURSOR FOR mvcost_pre15
   #        OPEN mvcost_cs15
   #        FETCH mvcost_cs15 INTO l_cfa.cfa08,l_cfa.cfa09
   #     END IF
   #  #FUN-D30065 --------Begin---------
   #     IF l_cfa.cfa03 = 'axmt620' THEN
   #     #出貨單價抓取ogb13,ogb14
   #        LET g_sql = "SELECT ogb13,ogb14 FROM ",cl_get_target_table(g_plant_new,'ogb_file'),
   #                    " WHERE ogb01 = '",g_tlf.tlf905,"'",
   #                    "   AND ogb03 = '",g_tlf.tlf906,"' "
   #        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   #        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   #        PREPARE mvcost_pre16 FROM g_sql
   #        DECLARE mvcost_cs16 CURSOR FOR mvcost_pre16
   #        OPEN mvcost_cs16
   #        FETCH mvcost_cs16 INTO l_cfa.cfa08,l_cfa.cfa09
   #     END IF
   #  #FUN-D30065 --------End-----------
   #TQC-D30071 --------End-----------
      #ELSE    #TQC-D40026 mark  #'aomt800'  銷退走此段
         #cfa08=cfa12, cfa09=cfa07*cfa08(要先算cfa12,再反算cfa08/cfa09)
         LET l_cfa.cfa08 = l_cfa.cfa12
         LET l_cfa.cfa09 = l_cfa.cfa07 * l_cfa.cfa08
      #END IF  #TQC-D40026 mark 
    #TQC-D80002 ----------Begin--------
       IF l_cfa.cfa03 = 'aomt800' THEN
          LET g_sql = "SELECT oha09,ohb14 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),
                      ",",cl_get_target_table(g_plant_new,'oha_file'),
                      " WHERE oha01 = ohb01 ",
                      "   AND ohb01 = '",g_tlf.tlf905,"'",
                      "   AND ohb03 = '",g_tlf.tlf906,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
          PREPARE mvcost_pre20 FROM g_sql
          DECLARE mvcost_cs20 CURSOR FOR mvcost_pre20
          OPEN mvcost_cs20
          FETCH mvcost_cs20 INTO l_oha09,l_ohb14
          IF l_oha09 = '5' THEN
             LET l_cfa.cfa09 = l_ohb14
          END IF
       END IF
    #TQC-D80002 ----------End----------
   END IF 
   IF cl_null(l_cfa.cfa08) THEN LET l_cfa.cfa08 = 0 END IF    #lixh1
   IF cl_null(l_cfa.cfa09) THEN LET l_cfa.cfa09 = 0 END IF    #lixh1
   #TQC-D40026--add--str--
 # IF l_cfa.cfa03 = 'aomt800' OR l_cfa.cfa03 = 'apmt1072' THEN    #FUN-D70070 mark
   IF l_cfa.cfa03 = 'aomt800' OR l_cfa.cfa03 = 'apmt1072' OR (l_cfa.cfa03 ='axmt670' AND l_omf10 = '2') THEN   #FUN-D70070 add 
      IF l_cfa.cfa07 > 0 THEN
         LET l_cfa.cfa07 = l_cfa.cfa07 * -1
      END IF 
      IF l_cfa.cfa09 > 0 THEN
         LET l_cfa.cfa09 = l_cfa.cfa09 * -1
      END IF
   END IF  
   #TQC-D40026--add--str--
   #cfa10结存库存数量
   LET g_sql = "SELECT cfa10 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
               " WHERE cfa01= '", l_cfa.cfa01 ,"' ",
               "   AND cfa02=(SELECT MAX(cfa02) FROM cfa_file WHERE cfa01='",l_cfa.cfa01,"' )"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE mvcost_pre7 FROM g_sql
   DECLARE mvcost_cs7 CURSOR FOR mvcost_pre7
   OPEN mvcost_cs7
   FETCH mvcost_cs7 INTO l_cfa10
   IF cl_null(l_cfa10) THEN 
      LET g_sql = "SELECT cca11 FROM ",cl_get_target_table(g_plant_new,'cca_file'),
                  " WHERE cca01= '", l_cfa.cfa01 ,"' ",
                  "   AND cca02= '", l_yy ,"' ",
                  "   AND cca03= '", l_mm ,"' ",
                  "   AND cca06= '", g_ccz.ccz28 ,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE mvcost_pre8 FROM g_sql
      DECLARE mvcost_cs8 CURSOR FOR mvcost_pre8
      OPEN mvcost_cs8
      FETCH mvcost_cs8 INTO l_cfa10
   END IF 
   IF cl_null(l_cfa10) THEN LET l_cfa10=0 END IF 
   #LET l_cfa.cfa10 = l_cfa10 + l_cfa.cfa04*l_cfa.cfa07  #TQC-D40026 mark
   #TQC-D60060--mark--str--
   ##TQC-D40026--add--str--
   #IF l_cfa.cfa03 = 'aomt800' OR l_cfa.cfa03 = 'apmt1072' THEN  #驗退、倉退異動金額為負值
   #   LET l_cfa.cfa10 = l_cfa10 + l_cfa.cfa07
   #ELSE 
   #   LET l_cfa.cfa10 = l_cfa10 + l_cfa.cfa04*l_cfa.cfa07
   #END IF   
   ##TQC-D40026--add--str-
   #TQC-D60060--mark--end--
  #LET l_cfa.cfa10 = l_cfa10 + l_cfa.cfa04*l_cfa.cfa07  #TQC-D60060 add   #FUN-D60091 mark
   LET l_cfa.cfa10 = l_cfa10 + l_cfa.cfa04*l_cfa.cfa07*g_tlf.tlf12        #FUN-D60091 add 
   #cfa11结存库存金额
   LET g_sql = "SELECT cfa11 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
               " WHERE cfa01= '", l_cfa.cfa01 ,"' ",
               "   AND cfa02=(SELECT MAX(cfa02) FROM cfa_file WHERE cfa01='",l_cfa.cfa01,"' )"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE mvcost_pre9 FROM g_sql
   DECLARE mvcost_cs9 CURSOR FOR mvcost_pre9
   OPEN mvcost_cs9
   FETCH mvcost_cs9 INTO l_cfa11
   IF cl_null(l_cfa11) THEN 
      LET g_sql = "SELECT cca12 FROM ",cl_get_target_table(g_plant_new,'cca_file'),
                  " WHERE cca01= '", l_cfa.cfa01 ,"' ",
                  "   AND cca02= '", l_yy ,"' ",
                  "   AND cca03= '", l_mm ,"' ",
                  "   AND cca06= '", g_ccz.ccz28 ,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE mvcost_pre10 FROM g_sql
      DECLARE mvcost_cs10 CURSOR FOR mvcost_pre10
      OPEN mvcost_cs10
      FETCH mvcost_cs10 INTO l_cfa11
   END IF 
   IF cl_null(l_cfa11) THEN LET l_cfa11=0 END IF 
   LET l_cfa.cfa11 = l_cfa11 + l_cfa.cfa04*l_cfa.cfa09  #TQC-D40026  #TQC-D60060 remark
   #TQC-D60060--mark--str--
   ##TQC-D40026--add--str--
   #IF l_cfa.cfa03 = 'aomt800' OR l_cfa.cfa03 = 'apmt1072' THEN  #驗退、倉退異動金額為負值
   #   LET l_cfa.cfa11 = l_cfa11 + l_cfa.cfa09  
   #ELSE
   #   LET l_cfa.cfa11 = l_cfa11 + l_cfa.cfa04*l_cfa.cfa09
   #END IF
   ##TQC-D40026--add--str-
   #TQC-D60060--mark--end--
   #cfa12移動加權平均成本
   IF l_cfa.cfa04 = 1 THEN 
      LET l_cfa.cfa12=l_cfa.cfa11 / l_cfa.cfa10
   END IF 
   #倉退->apmt722
   #IF l_cfa.cfa04 = -1 AND l_cfa.cfa03 = 'apmt1072' THEN   #倉退lixh1  #TQC-D40026
   #FUN-D60091--mark--str--
   #IF l_cfa.cfa04 = -1 AND l_cfa.cfa03 = 'aomt800' THEN     #TQC-D40026 add  #驗退
   #   LET l_cfa.cfa12=l_cfa.cfa11 / l_cfa.cfa10
   #END IF
   #FUN-D60091--mark--end--
#TQC-D30071 ----------Begin---------
#  #借出單->artt262
#  IF l_cfa.cfa04 = -1 AND l_cfa.cfa03 = 'artt262' THEN
#     LET l_cfa.cfa12=l_cfa.cfa11 / l_cfa.cfa10
#  END IF
#  #FUN-D30065 -----Begin--------
#  #出貨單
#  IF l_cfa.cfa04 = -1 AND l_cfa.cfa03 = 'axmt620' THEN
#     LET l_cfa.cfa12=l_cfa.cfa11 / l_cfa.cfa10
#  END IF 
#  #FUN-D30065 -----End----------
#TQC-D30071 ----------End-----------
   IF cl_null(l_cfa.cfa12) OR l_cfa.cfa12<0 THEN 
      LET g_sql = "SELECT cfa12 FROM ",cl_get_target_table(g_plant_new,'cfa_file'),
                  " WHERE cfa01= '", l_cfa.cfa01 ,"' AND cfa04=1 ",
                  "   AND cfa02=(SELECT MAX(cfa02) FROM cfa_file WHERE cfa01='",l_cfa.cfa01,"' AND cfa04=1 )"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE mvcost_pre11 FROM g_sql
      DECLARE mvcost_cs11 CURSOR FOR mvcost_pre11
      OPEN mvcost_cs11
      FETCH mvcost_cs11 INTO l_cfa.cfa12
   END IF 
   #cfa13结存调整金额 cfa11-(cfa10*cfa12)
   LET l_cfa.cfa13 = l_cfa.cfa11 - (l_cfa.cfa10 * l_cfa.cfa12)
   LET l_cfa.cfa14 = g_tlf.tlf902
   LET l_cfa.cfa15 = g_tlf.tlf903
   LET l_cfa.cfa16 = g_tlf.tlf904
   LET l_cfa.cfa17 = g_tlf.tlf11
   LET l_cfa.cfa18 = g_tlf.tlf06
   LET l_cfa.cfalegal = g_legal

   #TQC-D40117--mark--str--
   #IF l_cfa.cfa04 = 1 THEN    #FUN-D30065 
   #   LET l_cfa.cfa08=cl_digcut(l_cfa.cfa08,g_azi03)
   #   LET l_cfa.cfa12=cl_digcut(l_cfa.cfa12,g_azi03)
   #   LET l_cfa.cfa09=cl_digcut(l_cfa.cfa09,g_ccz.ccz26)    #lixh1
   #   LET l_cfa.cfa11=cl_digcut(l_cfa.cfa11,g_ccz.ccz26)
   #   LET l_cfa.cfa13=cl_digcut(l_cfa.cfa13,g_ccz.ccz26)
   #END IF     #FUN-D30065
   #TQC-D40117--mark--end--
   LET l_cfa.cfa11=cl_digcut(l_cfa.cfa11,g_ccz.ccz26)  #TQC-D40117 add
   LET l_cfa.cfa13=cl_digcut(l_cfa.cfa13,g_ccz.ccz26)  #TQC-D40117 add
   IF cl_null(l_cfa.cfa08) THEN LET l_cfa.cfa08=0 END IF 
   IF cl_null(l_cfa.cfa09) THEN LET l_cfa.cfa09=0 END IF 
   IF cl_null(l_cfa.cfa10) THEN LET l_cfa.cfa10=0 END IF 
   IF cl_null(l_cfa.cfa11) THEN LET l_cfa.cfa11=0 END IF 
   IF cl_null(l_cfa.cfa12) THEN LET l_cfa.cfa12=0 END IF
   IF cl_null(l_cfa.cfa13) THEN LET l_cfa.cfa13=0 END IF

   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'cfa_file'),"(",
                 "cfa00,cfa01,cfa02,cfa03,cfa04,cfa05,cfa06,cfa07,cfa08,cfa09,",
                 "cfa10,cfa11,cfa12,cfa13,cfa14,cfa15,cfa16,cfa17,cfa18,cfalegal ",
                 ") VALUES",  
                 "(?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?) "   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE ins_mvcost_cfa FROM g_sql
   EXECUTE ins_mvcost_cfa USING l_cfa.cfa00,l_cfa.cfa01,l_cfa.cfa02,l_cfa.cfa03,l_cfa.cfa04,
                                l_cfa.cfa05,l_cfa.cfa06,l_cfa.cfa07,l_cfa.cfa08,l_cfa.cfa09,
                                l_cfa.cfa10,l_cfa.cfa11,l_cfa.cfa12,l_cfa.cfa13,l_cfa.cfa14,
                                l_cfa.cfa15,l_cfa.cfa16,l_cfa.cfa17,l_cfa.cfa18,l_cfa.cfalegal
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN  
         CALL s_errmsg('cfa01',l_cfa.cfa01,'ins cfa',STATUS,1)
      ELSE
         CALL cl_err3("sel","cfa_file",l_cfa.cfa01,"",STATUS,"","",1) 
      END IF
      LET g_success='N'
      RETURN FALSE 
   END IF
   RETURN TRUE 
END FUNCTION 
#FUN-BC0062
