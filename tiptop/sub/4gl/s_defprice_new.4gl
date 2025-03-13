# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: s_defprice_new.4gl
# Descriptions...: 採購取價
# Date & Author..: 09/08/04 By Zhangyajun
# Usage..........: LET l_price,lt_price=s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,
#                                                  p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment,p_plant)
# Input Parameter: p_part    料件編號 
#                  p_vender  供應商編號
#                  p_curr    幣別
#                  p_date    有效日期
#                  p_qty     數量                            
#                  p_task    作業編號==>一般採購單,委外採購單 傳''   
#                                 ==>製程委外採購單      傳作業編號 
#                  p_tax     稅別
#                  p_rate    稅率
#                  p_type    資料型態
#                  p_unit    單位
#                  p_cell    製程單元編號
#                  p_term    價格條件
#                  p_payment 付款方式
#                  p_plant   機構別 
# Return code....: l_price,lt_price,l_type,l_no  未稅單價,含稅單價,取價類型,價格來源 
# Modify.........: No.TQC-9A0109 09/10/21 By sunyanchun  
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No:MOD-9C0258 09/12/18 By bnlent p_tax,p_rate 位置互換
# Modify.........: No:FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A80104 10/08/26 By lixia 採購取價功能改善
# Modify.........: No:FUN-A30072 10/10/22 By jan 增加委外FT時是否依收貨等級重新取價的處理
# Modify.........: No:FUN-AB0053 10/11/12 By suncx 價格代碼取消抓取rzz_file
# Modify.........: No:TQC-AC0257 10/12/17 By shiwuying SQL錯誤
# Modify.........: No:MOD-AC0308 10/12/24 By Carrier s_defprice_A4出现-217的错误,p_qty没有定义却在使用
# Modify.........: No:TQC-B10035 11/01/10 By zhangll 修正取值多算汇率至数据失真
# Modify.........: No:MOD-B10188 11/01/24 By lixia 不同組比較價格='N'時，第一組已取到則不往下取
# Modify.........: No:MOD-B10164 11/01/25 By shiwuying 取價后截位
# Modify.........: No:MOD-B30580 11/05/10 By wuxj  單價小數位數截取時存在誤差，現改成10位進行計算，最後回傳時再截位
# Modify.........: No:MOD-B80155 11/08/16 By johung A1及A2不需做除以匯率的計算
# Modify.........: No:TQC-B90060 11/09/07 By suncx 補上對lt_price的cl_null判斷
# Modify.........: No:MOD-BA0127 11/10/20 By Vampire (1)判斷價格代碼是否再除匯率應該放到FOREACH中處理
#                                                    (2)料件最近市價、料件最近採購單價於MOD-B80155中決議不重新除匯率,避免匯差問題
# Modify.........: No:TQC-BB0093 11/11/16 By Vampire 取價失敗，無法取到相應的價格，返回值為0
# Modify.........: No:TQC-C30005 12/03/01 By lixiang 服飾零食業態下母料件關聯子料件進行取價
# Modify.........: No:TQC-C20418 12/03/02 By lixiang 修正TQC-C30005的問題
# Modify.........: No:TQC-C40042 12/05/09 By Vampire 乘算單位轉換率之後應該再依照含稅未稅否回推,不能直接個別乘於單位轉換率
# Modify.........: No:MOD-C80260 12/09/21 By Elise poj_file抓取最近那一筆的資料
# Modify.........: No:MOD-D30015 13/03/11 By Elise 調整當價格條件為 A4，需傳入 稅率及含稅金額
# Modify.........: No:MOD-D30182 13/03/22 By pauline 當價格條件來源為核價單時,當前營運中心無資料時不可取其他營運中心的資料
# Modify.........: No:MOD-D40120 13/04/17 By Vampire 當 lt_price 為 null 時應讓 lt_price 為 0

DATABASE ds
 
GLOBALS "../../config/top.global" 

DEFINE ms_pmjicd14_flag   LIKE type_file.num5  #委外FT時是否依收貨等級重新取價 FUN-A30072
DEFINE ms_pmjicd14        LIKE pmj_file.pmjicd14  #FUN-A30072

DEFINE gr_par RECORD 
       part    LIKE ima_file.ima01,
       vender  LIKE pmc_file.pmc01,
       curr    LIKE aza_file.aza17,
       date    LIKE type_file.dat,
       qty     LIKE pmn_file.pmn20,
       task    LIKE pmj_file.pmj10,
       tax     LIKE gec_file.gec01,
       rate    LIKE gec_file.gec04,
       type    LIKE pmh_file.pmh22,
       unit    LIKE pmn_file.pmn86,
       cell    LIKE pmj_file.pmj13,
       term    LIKE pof_file.pof01,
       payment LIKE pof_file.pof05,
       plant   LIKE azp_file.azp01
       END RECORD
DEFINE g_dbs      LIKE azp_file.azp03
DEFINE g_pnz04    LIKE pnz_file.pnz04
 
#FUNCTION s_defprice_new(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_rate,p_tax,p_type,p_unit,p_cell,p_term,p_payment,p_plant)
FUNCTION s_defprice_new(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment,p_plant) #No.MOD-9C0258
DEFINE p_part     LIKE ima_file.ima01
DEFINE p_vender   LIKE pmc_file.pmc01
DEFINE p_curr     LIKE aza_file.aza17
DEFINE p_date     LIKE type_file.dat         
DEFINE p_qty      LIKE pmn_file.pmn20        
DEFINE p_unit     LIKE pmn_file.pmn86       
DEFINE p_task     LIKE pmj_file.pmj10  
DEFINE p_rate     LIKE gec_file.gec04     
DEFINE p_type     LIKE pmh_file.pmh22        
DEFINE p_tax      LIKE gec_file.gec01
DEFINE p_term     LIKE pof_file.pof01        
DEFINE p_payment  LIKE pof_file.pof05         
DEFINE p_cell     LIKE pmj_file.pmj13    
DEFINE p_plant    LIKE azp_file.azp01
DEFINE l_price    LIKE ima_file.ima53   
DEFINE lt_price   LIKE pmh_file.pmh19  
DEFINE l_part     LIKE ima_file.ima01
DEFINE l_count    LIKE type_file.num5
DEFINE l_i        LIKE type_file.num5
DEFINE l_imx RECORD LIKE imx_file.*
DEFINE l_type     LIKE type_file.chr1 #取價類型   #TQC-AC0257 add
DEFINE l_no       LIKE rtu_file.rtu01 #價格來源   #TQC-AC0257 add

  #SELECT azi04 INTO t_azi04               #MOD-B10164
   SELECT azi03,azi04 INTO t_azi03,t_azi04 #MOD-B10164
      FROM azi_file
     WHERE azi01 = p_curr     #幣別
   IF cl_null(t_azi04) THEN
      LET t_azi04 = g_azi04
   END IF
   IF cl_null(t_azi03) THEN LET t_azi03 = g_azi03 END IF #MOD-B10164
   
   IF cl_null(p_task) THEN
       LET p_task = ' '
   END IF
 
   IF cl_null(p_cell) THEN
      LET p_cell = ' '
   END IF
   LET gr_par.part = p_part
   LET gr_par.vender = p_vender
   LET gr_par.curr = p_curr
   LET gr_par.date = p_date
   LET gr_par.qty = p_qty
   LET gr_par.task = p_task
   LET gr_par.tax = p_tax
   LET gr_par.rate = p_rate
   LET gr_par.type = p_type
   LET gr_par.unit = p_unit
   LET gr_par.cell = p_cell
   LET gr_par.term = p_term
   LET gr_par.payment = p_payment
   LET gr_par.plant = p_plant
   IF g_sma.sma120 = 'Y' THEN  #多屬性料件
      LET l_count = 0 
      SELECT imx_file.* INTO l_imx.* FROM imx_file
       WHERE imx_file.imx000=p_part 
      SELECT COUNT(*) INTO l_count FROM imx_file
       WHERE imx_file.imx000=p_part
      IF l_count>0 THEN 
         SELECT COUNT(*) INTO l_count FROM agb_file,ima_file 
          WHERE agb_file.agb01=ima_file.imaag1 AND ima_file.ima01=p_part
         FOR l_i = l_count TO 0 STEP -1
             #服飾最多的屬性段為3段
             CASE l_i
                WHEN 3 LET l_part=l_imx.imx00,g_sma.sma46,l_imx.imx01,
                                               g_sma.sma46,l_imx.imx02,
                                               g_sma.sma46,l_imx.imx03
                WHEN 2 LET l_part=l_imx.imx00,g_sma.sma46,l_imx.imx01,
                                               g_sma.sma46,l_imx.imx02
                WHEN 1 LET l_part=l_imx.imx00,g_sma.sma46,l_imx.imx01
                WHEN 0 LET l_part=l_imx.imx00
                OTHERWISE LET l_part=p_part
             END CASE
             CALL s_defprice_s()
                  #RETURNING l_price,lt_price             #TQC-AC0257 mark
                  RETURNING l_price,lt_price,l_type,l_no  #TQC-AC0257 add
             IF l_price <> 0 AND lt_price <>0 THEN
                EXIT FOR
             END IF
         END FOR 
      ELSE 
         CALL s_defprice_s()
              #RETURNING l_price,lt_price             #TQC-AC0257 mark
              RETURNING l_price,lt_price,l_type,l_no  #TQC-AC0257 add       
      END IF
   ELSE 
      CALL s_defprice_s()
           #RETURNING l_price,lt_price             #TQC-AC0257 mark
           RETURNING l_price,lt_price,l_type,l_no  #TQC-AC0257 add
   END IF
   LET l_price = cl_digcut(l_price,t_azi03)   #MOD-B10164
   LET lt_price = cl_digcut(lt_price,t_azi03) #MOD-B10164
  #RETURN l_price,lt_price              #TQC-AC0257 mark
   RETURN l_price,lt_price,l_type,l_no   #TQC-AC0257 add
END FUNCTION    
 
FUNCTION s_defprice_s()   
#DEFINE l_price      LIKE ima_file.ima53   #MOD-B30580 mark
#DEFINE lt_price     LIKE pmh_file.pmh19   #MOD-B30580 mark
#DEFINE l_price_min  LIKE ima_file.ima53   #MOD-B30580 mark
#DEFINE lt_price_min LIKE pmh_file.pmh19   #MOD-B30580 mark
DEFINE l_price      LIKE type_file.num26_10 #MOD-B30580 add 
DEFINE lt_price     LIKE type_file.num26_10 #MOD-B30580 add    
DEFINE l_price_min  LIKE type_file.num26_10 #MOD-B30580 add
DEFINE lt_price_min LIKE type_file.num26_10 #MOD-B30580 add
DEFINE l_pnz05      LIKE pnz_file.pnz05
DEFINE l_pnq03      LIKE pnq_file.pnq03
DEFINE l_exrate     LIKE azj_file.azj03
DEFINE l_type       LIKE type_file.chr1 #取價類型
DEFINE l_no         LIKE rtu_file.rtu01 #價格來源
DEFINE l_ima44      LIKE ima_file.ima44   
DEFINE l_ima908     LIKE ima_file.ima908
DEFINE l_unitrate   LIKE pmn_file.pmn121
DEFINE l_sw         LIKE type_file.num10
DEFINE l_sql        STRING
#FUN-A80104----start----
DEFINE l_pnz06      LIKE pnz_file.pnz06 #ADD FUN-A80104同組同類型互斥
DEFINE l_pnq04      LIKE pnq_file.pnq04 #組別
DEFINE l_pnq02      LIKE pnq_file.pnq02 #順序
#FUN-A80104----end----
 
    SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = gr_par.plant
    #LET l_sql = "SELECT pnz04,pnz05 FROM ",s_dbstring(g_dbs),"pnz_file",
    #LET l_sql = "SELECT pnz04,pnz05 FROM ",cl_get_target_table(gr_par.plant,'pnz_file'), #FUN-A50102
    LET l_sql = "SELECT pnz04,pnz05,pnz06 FROM ",cl_get_target_table(gr_par.plant,'pnz_file'), #FUN-A80104
                " WHERE pnz01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102            
    PREPARE pnz_sel FROM l_sql
    #EXECUTE pnz_sel USING gr_par.term INTO g_pnz04,l_pnz05
    EXECUTE pnz_sel USING gr_par.term INTO g_pnz04,l_pnz05,l_pnz06  #FUN-A80104
    IF g_aza.aza17 <> gr_par.curr THEN
       LET l_exrate = s_curr3(gr_par.curr,g_today,g_sma.sma904)
    ELSE
       LET l_exrate=1
    END IF

    #LET l_sql = "SELECT ima44,ima908 FROM ",s_dbstring(g_dbs),"ima_file",
    LET l_sql = "SELECT ima44,ima908 FROM ",cl_get_target_table(gr_par.plant,'ima_file'), #FUN-A50102
                " WHERE ima01 = ?"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102              
    PREPARE unit_sel FROM l_sql
    EXECUTE unit_sel USING gr_par.part
                      INTO l_ima44,l_ima908
    IF cl_null(gr_par.unit) THEN LET gr_par.unit=l_ima44 END IF 
    IF g_sma.sma116 MATCHES '[13]' THEN   
       LET l_ima44 = l_ima908
    END IF 
    LET l_unitrate = 1
    IF NOT cl_null(gr_par.unit) AND gr_par.unit <> l_ima44 THEN
       CALL s_umfchk(gr_par.part,gr_par.unit,l_ima44)
         RETURNING l_sw,l_unitrate
       IF l_sw THEN
          #單位換算率抓不到
          IF g_pnz04='N' THEN
             IF g_bgerr THEN 
                CALL s_errmsg('','','','abm-731',1)
             ELSE
                CALL cl_err('','abm-731',0)
             END IF
          END IF
          #RETURN 0,0              #TQC-AC0257 mark
          RETURN 0,0,NULL,NULL     #TQC-AC0257 add
       END IF
    END IF
    LET l_price_min=0
    LET lt_price_min=0
#FUN-A80104---start---       
    #取出指定價格條件的各個組
    LET l_sql = "SELECT pnq04 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),
                " WHERE pnq01 = '",gr_par.term,"'",
                " GROUP BY pnq04 ",
                #" ORDER BY pnq04 DESC"   #FUN-A80104 1013
                " ORDER BY pnq04 "        #MOD-B10188
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              							
    CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql 
    PREPARE pre_sel_pnq04 FROM l_sql
    DECLARE pnq04_cur CURSOR FOR pre_sel_pnq04
    FOREACH pnq04_cur INTO l_pnq04
       LET l_price = 0 
       IF l_pnq04 IS NULL THEN CONTINUE FOREACH END IF
          IF l_pnz06 = 'Y' THEN
             #FUN-AB0053 mark begin-------------------------------
             #LET l_sql = "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),",", 
             #                                                    cl_get_target_table(gr_par.plant,'rzz_file'), 
             #      " WHERE rzz00 = '1' AND rzz01 = pnq03 ",
             #      "   AND pnq01 ='",gr_par.term,"'",
             #      "   AND rzz03 = 'C'",
             #      "   AND pnq04 ='",l_pnq04,"'",
             #      " ORDER BY pnq02) ", 
             #      " UNION ALL ",
             #      "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),",", 
             #                                                    cl_get_target_table(gr_par.plant,'rzz_file'),  
             #      " WHERE rzz00 = '1' AND rzz01 = pnq03 ",
             #      "   AND pnq01 ='",gr_par.term,"'",
             #      "   AND rzz03 = 'A'",
             #      "   AND pnq04 ='",l_pnq04,"'",
             #      " ORDER BY pnq02) "
             #FUN-AB0053 mark end-------------------------------
             #FUN-AB0053 add begin-------------------------------
             LET l_sql = "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),
                         " WHERE pnq01 ='",gr_par.term,"'",
                         "   AND pnq03 LIKE 'C%' ",
                         "   AND pnq04 ='",l_pnq04,"'",
                         " ORDER BY pnq02) ",
                         " UNION ALL ",
                         "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),
                         " WHERE pnq01 ='",gr_par.term,"'",
                         "   AND pnq03 LIKE 'A%'",
                         "   AND pnq04 ='",l_pnq04,"'",
                         " ORDER BY pnq02) "
             #FUN-AB0053 add end-------------------------------
          ELSE
          	 #FUN-AB0053 mark begin-------------------------------
             #LET l_sql = "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),",", 
             #                                                    cl_get_target_table(gr_par.plant,'rzz_file'),  
             #      " WHERE rzz00 = '1' AND rzz01 = pnq03 ",
             #      "   AND pnq01 ='",gr_par.term,"'",
             #      "   AND rzz03 = 'C'",
             #      "   AND pnq04 ='",l_pnq04,"'",
             #      " ORDER BY pnq02 DESC) ", 
             #      " UNION ALL ",
             #      "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),",", 
             #                                              cl_get_target_table(gr_par.plant,'rzz_file'),  
             #      " WHERE rzz00 = '1' AND rzz01 = pnq03 ",
             #      "   AND pnq01 ='",gr_par.term,"'",
             #      "   AND rzz03 = 'A'",
             #      "   AND pnq04 ='",l_pnq04,"'",
             #      " ORDER BY pnq02 DESC) " 
             #FUN-AB0053 mark end-------------------------------
             #FUN-AB0053 add begin-------------------------------
             LET l_sql = "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'), 
                         " WHERE pnq01 ='",gr_par.term,"'",
                         "   AND pnq03 LIKE 'C%'",
                         "   AND pnq04 ='",l_pnq04,"'",
                         " ORDER BY pnq02 DESC) ", 
                         " UNION ALL ",
                         "SELECT pnq03 FROM (SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'),
                         " WHERE pnq01 ='",gr_par.term,"'",
                         "   AND pnq03 LIKE 'A%'",
                         "   AND pnq04 ='",l_pnq04,"'",
                         " ORDER BY pnq02 DESC) "  
             #FUN-AB0053 add end-------------------------------
          END IF       
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              							
          CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql              
          PREPARE pre_sel_pnq03 FROM l_sql
          DECLARE cur_pnq03 CURSOR FOR pre_sel_pnq03
          FOREACH cur_pnq03 INTO l_pnq03
             IF l_pnq03 IS NULL THEN CONTINUE FOREACH END IF             
                CASE
                   WHEN l_pnq03='A1' OR l_pnq03='A2'
                      CALL s_defprice_A12(l_pnq03) RETURNING l_price,lt_price
                   WHEN l_pnq03='A3' 
                      CALL s_defprice_A3() RETURNING l_price,lt_price
                   WHEN l_pnq03='A4' 
                      CALL s_defprice_A4() RETURNING l_price,lt_price
                   WHEN l_pnq03='A5' 
                      CALL s_defprice_A5() RETURNING l_price,lt_price
                   WHEN l_pnq03='A6' 
                      CALL s_defprice_A6(gr_par.part,gr_par.vender,gr_par.date,gr_par.curr,
                                gr_par.tax,gr_par.rate,gr_par.unit,gr_par.plant)
                      RETURNING l_price,lt_price,l_type,l_no
                   WHEN l_pnq03='C1' 
                      CALL s_defprice_C1(gr_par.part,gr_par.vender,gr_par.curr,gr_par.date,
                         gr_par.qty,gr_par.tax,gr_par.unit,gr_par.term,gr_par.payment)
                      RETURNING l_price,lt_price
                   WHEN l_pnq03='C2' 
                      CALL s_defprice_C2(gr_par.part,gr_par.vender,gr_par.curr,gr_par.date,
                          gr_par.qty,gr_par.tax,gr_par.unit,gr_par.term,gr_par.payment)
                      RETURNING l_price,lt_price 
                END CASE
             IF cl_null(l_price) THEN LET l_price=0 END IF
            #IF cl_null(lt_price) THEN LET l_price=0 END IF  #TQC-B90060 add #MOD-D40120 mark
             IF cl_null(lt_price) THEN LET lt_price=0 END IF #MOD-D40120 add
             #取到值就退出
             IF l_price>0 THEN
                EXIT FOREACH
             END IF
          END FOREACH          

          #MOD-BA0127 ----- modify start -----
          IF cl_null(l_price) THEN LET l_price=0 END IF
         #IF cl_null(lt_price) THEN LET l_price=0 END IF  #TQC-B90060 add #MOD-D40120 mark
          IF cl_null(lt_price) THEN LET lt_price=0 END IF #MOD-D40120 add
          IF l_pnq03 = 'A3' OR l_pnq03 = 'A4' OR l_pnq03 = 'C1' OR l_pnq03 = 'C2' OR
             l_pnq03 = 'A1' OR l_pnq03 = 'A2' THEN 
          #取值时已包含币种的判断，不需再行计算汇率
             #TQC-BB0093 ----- modify start -----
             #LET l_price=l_price_min*l_unitrate
             #LET lt_price=lt_price_min*l_unitrate
             LET l_price=l_price*l_unitrate
             LET lt_price=lt_price*l_unitrate  #TQC-C40042 mark #MOD-D30015 remove # 
            #MOD-D30015 add start ------
             IF l_pnq03 = 'A4' THEN
                LET lt_price = s_defprice_taxrate(gr_par.rate,gr_par.rate,gr_par.tax,gr_par.vender,l_price,lt_price)
             ELSE
            #MOD-D30015 add end   ------
                LET lt_price = s_defprice_taxrate(gr_par.rate,'',gr_par.tax,gr_par.vender,l_price,'') #TQC-C40042 add
             END IF #MOD-D30015 add
             #TQC-BB0093 -----  modify end  -----
          ELSE
             #TQC-BB0093 ----- modify start -----
             #LET l_price=l_price_min*l_unitrate/l_exrate
             #LET lt_price=lt_price_min*l_unitrate/l_exrate
             LET l_price=l_price*l_unitrate/l_exrate
             #LET lt_price=lt_price*l_unitrate/l_exrate #TQC-C40042 mark
             #TQC-BB0093 -----  modify end  -----
             LET lt_price = s_defprice_taxrate(gr_par.rate,'',gr_par.tax,gr_par.vender,l_price,'') #TQC-C40042 add
          END IF  #Add No:TQC-B10035
          LET l_price = cl_digcut(l_price,t_azi03)
          LET lt_price = cl_digcut(lt_price,t_azi03)
          #MOD-BA0127 -----  modify end  -----

          #不同組比較取價為N 
          IF l_pnz05='N' THEN 
             IF l_price>0 THEN     #FUN-A80104 1013          
                 LET l_price_min=l_price
                 LET lt_price_min=lt_price
                 EXIT FOREACH
             ELSE
                 LET l_price_min=l_price
                 LET lt_price_min=lt_price    
             END IF    
          ELSE  #不同組比較取價為Y，全部都取出來，在取最小值
             IF l_price>0 THEN
                IF l_price_min=0 THEN
                   LET l_price_min=l_price
                   LET lt_price_min=lt_price
                END IF
                IF l_price<l_price_min THEN
                   LET l_price_min=l_price
                   LET lt_price_min=lt_price
                END IF
             END IF         
          END IF                           
      END FOREACH      
      #MOD-BA0127 ----- mark start -----
      #IF cl_null(l_price) THEN LET l_price=0 END IF
      #IF cl_null(lt_price) THEN LET l_price=0 END IF  #TQC-B90060 add
      ##Add No:TQC-B10035
#     #IF l_pnq03 = 'A3' OR l_pnq03 = 'A4' OR l_pnq03 = 'C1' OR l_pnq03 = 'C2' THEN   #MOD-B80155 mark
      #IF l_pnq03 = 'A3' OR l_pnq03 = 'A4' OR l_pnq03 = 'C1' OR l_pnq03 = 'C2' OR     #MOD-B80155
      #   l_pnq03 = 'A1' OR l_pnq03 = 'A2' THEN                                       #MOD-B80155
      ##取值时已包含币种的判断，不需再行计算汇率
      #   LET l_price=l_price_min*l_unitrate
      #   LET lt_price=lt_price_min*l_unitrate
      #ELSE
      ##End Add No:TQC-B10035
      #   LET l_price=l_price_min*l_unitrate/l_exrate
      #   LET lt_price=lt_price_min*l_unitrate/l_exrate
      #END IF  #Add No:TQC-B10035
      #LET l_price = cl_digcut(l_price,t_azi03)
      #LET lt_price = cl_digcut(lt_price,t_azi03)
      #MOD-BA0127 -----  mark end  -----
      #RETURN l_price,lt_price                    #TQC-AC0257 mark
      #RETURN l_price,lt_price,l_type,l_no        #TQC-AC0257 add #TQC-BB0093 mark
      RETURN l_price_min,lt_price_min,l_type,l_no #TQC-BB0093 add
             
                
#FUN-A80104---end---
#FUN-A80104---start---    
#{    #LET l_sql = "SELECT pnq03 FROM ",s_dbstring(g_dbs),"pnq_file",
#    LET l_sql = "SELECT pnq03 FROM ",cl_get_target_table(gr_par.plant,'pnq_file'), #FUN-A50102
#                " WHERE pnq01 = ? ORDER BY pnq02 "
#    DECLARE pnq_cs CURSOR FROM l_sql
#    FOREACH pnq_cs USING gr_par.term INTO l_pnq03
#       
#       CASE
#          WHEN l_pnq03='A1' OR l_pnq03='A2'
#             CALL s_defprice_A12(l_pnq03) RETURNING l_price,lt_price
#          WHEN l_pnq03='A3' 
#             CALL s_defprice_A3() RETURNING l_price,lt_price
#          WHEN l_pnq03='A4' 
#             CALL s_defprice_A4() RETURNING l_price,lt_price
#          WHEN l_pnq03='A5' 
#             CALL s_defprice_A5() RETURNING l_price,lt_price
#          WHEN l_pnq03='A6' 
#             CALL s_defprice_A6(gr_par.part,gr_par.vender,gr_par.date,gr_par.curr,
#                                gr_par.tax,gr_par.rate,gr_par.unit,gr_par.plant)
#                   RETURNING l_price,lt_price,l_type,l_no
#          #FUN-A80104----start---- 
#          WHEN l_pnq03='C1' 
#             CALL s_defprice_C1(gr_par.part,gr_par.vender,gr_par.curr,gr_par.date,
#                    gr_par.qty,gr_par.tax,gr_par.unit,gr_par.term,gr_par.payment)
#                   RETURNING l_price,lt_price
#          WHEN l_pnq03='C2' 
#             CALL s_defprice_C2(gr_par.part,gr_par.vender,gr_par.curr,gr_par.date,
#                    gr_par.qty,gr_par.tax,gr_par.unit,gr_par.term,gr_par.payment)
#                   RETURNING l_price,lt_price         
#          #FUN-A80104----end----         
#       END CASE
#       IF cl_null(l_price) THEN LET l_price=0 END IF
#       IF l_pnz05='N' AND l_price>0 THEN
#          EXIT FOREACH
#       END IF
#       IF l_pnz05='Y' AND l_price>0 THEN
#          IF l_price_min=0 THEN
#             LET l_price_min=l_price
#             LET lt_price_min=lt_price
#          END IF
#          IF l_price<l_price_min THEN
#             LET l_price_min=l_price
#             LET lt_price_min=lt_price
#          END IF
#       END IF
#    END FOREACH 
#    IF cl_null(l_price) THEN LET l_price=0 END IF
#    LET l_price=l_price*l_unitrate/l_exrate
#    LET lt_price=lt_price*l_unitrate/l_exrate
#    LET l_price = cl_digcut(l_price,t_azi03)
#    LET lt_price = cl_digcut(lt_price,t_azi03)
#    RETURN l_price,lt_price }
#FUN-A80104---end---
END FUNCTION
 
FUNCTION s_defprice_A12(p_type)
DEFINE p_type   LIKE pnq_file.pnq03
DEFINE l_ima53  LIKE ima_file.ima53
DEFINE l_ima531 LIKE ima_file.ima531
DEFINE l_price  LIKE ima_file.ima53
DEFINE lt_price LIKE pmh_file.pmh19
DEFINE l_sql STRING
 
   #LET l_sql = "SELECT ima53,ima531 FROM ",s_dbstring(g_dbs),"ima_file",
   LET l_sql = "SELECT ima53,ima531 FROM ",cl_get_target_table(gr_par.plant,'ima_file'), #FUN-A50102  
               " WHERE ima01 = ?"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102              
   PREPARE ima_sel FROM l_sql
   EXECUTE ima_sel USING gr_par.part
                    INTO l_ima53,l_ima531
   IF p_type='A1' THEN
      #LET l_price = l_ima53
      LET l_price = l_ima531   #FUN-A80104 101013
   END IF
   IF p_type='A2' THEN
      #LET l_price = l_ima531
      LET l_price = l_ima53    #FUN-A80104 101013
   END IF
   LET lt_price = s_defprice_taxrate(gr_par.rate,'',gr_par.tax,gr_par.vender,l_price,'')
   RETURN l_price,lt_price
END FUNCTION
 
FUNCTION s_defprice_A3()
DEFINE l_pmh12 LIKE pmh_file.pmh12
DEFINE l_pmh17 LIKE pmh_file.pmh17
DEFINE l_pmh18 LIKE pmh_file.pmh18
DEFINE l_pmh19 LIKE pmh_file.pmh19
DEFINE l_price  LIKE ima_file.ima53
DEFINE lt_price LIKE pmh_file.pmh19
DEFINE l_sql STRING
DEFINE l_ima151 LIKE ima_file.ima151  #TQC-C30005 add
 
   #LET l_sql = "SELECT pmh12,pmh17,pmh18,pmh19 FROM ",s_dbstring(g_dbs),"pmh_file",
  #TQC-C30005--add--begin--
  #IF s_industry("slk") AND g_azw.azw04 = '2' THEN                                   #TQC-C20418 mark
  #   IF g_prog="apmp500_slk" OR g_prog="apmt540_slk" OR g_prog="apmt590_slk" OR     #TQC-C20418 mark
  #      g_prog="apmt720_slk" OR g_prog="apmg722_slk" OR g_prog="apmt110_slk" THEN   #TQC-C20418 mark
   IF s_industry("slk") AND g_azw.azw04 = '2' AND (g_prog="apmp500_slk" OR g_prog="apmt540_slk" OR  #TQC-C20418 add
                                                   g_prog="apmt590_slk" OR g_prog="apmt720_slk" OR  #TQC-C20418 add
                                                   g_prog="apmg722_slk" OR g_prog="apmt110_slk") THEN   #TQC-C20418 add        
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = gr_par.part
      IF l_ima151 = 'Y' THEN
          LET l_sql = "SELECT DISTINCT pmh12,pmh17,pmh18,pmh19 ", 
                      "  FROM ",cl_get_target_table(gr_par.plant,'pmh_file'),
                      " , ",cl_get_target_table(gr_par.plant,'imx_file'),
                      " WHERE pmh01 = imx000 AND imx00 = ? AND pmh02 = ?",
                      "   AND pmh13 = ? AND pmh21 = ?",
                      "   AND pmh22 = ? AND pmh23 = ?",
                      "   AND pmhacti = 'Y' "  
      ELSE
         LET l_sql = "SELECT pmh12,pmh17,pmh18,pmh19 FROM ",cl_get_target_table(gr_par.plant,'pmh_file'), #FUN-A50102
                     " WHERE pmh01 = ? AND pmh02 = ?",
                     "   AND pmh13 = ? AND pmh21 = ?",
                     "   AND pmh22 = ? AND pmh23 = ?",
                     "   AND pmhacti = 'Y' " 
      END IF
    # END IF   #TQC-C20418 mark
   ELSE   
  #TQC-C30005--add--end--
      LET l_sql = "SELECT pmh12,pmh17,pmh18,pmh19 FROM ",cl_get_target_table(gr_par.plant,'pmh_file'), #FUN-A50102
                  " WHERE pmh01 = ? AND pmh02 = ?",
                  "   AND pmh13 = ? AND pmh21 = ?",
                  "   AND pmh22 = ? AND pmh23 = ?",
                  "   AND pmhacti = 'Y' "
   END IF  #TQC-C30005 add 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102              
   PREPARE pmh_sel FROM l_sql

   EXECUTE pmh_sel USING gr_par.part,gr_par.vender,gr_par.curr,
                         gr_par.task,gr_par.type,gr_par.cell  
                    INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19
   LET l_price = l_pmh12
   LET lt_price = s_defprice_taxrate(gr_par.rate,l_pmh18,gr_par.tax,gr_par.vender,l_price,l_pmh19)
   RETURN l_price,lt_price
END FUNCTION
 
FUNCTION s_defprice_A4()
DEFINE l_max_pmj09 LIKE pmj_file.pmj09
DEFINE l_pmj02    LIKE pmj_file.pmj02
DEFINE l_pmj07    LIKE pmj_file.pmj07
DEFINE l_pmj09    LIKE pmj_file.pmj09
DEFINE l_pmi01    LIKE pmi_file.pmi01
DEFINE l_pmi05    LIKE pmi_file.pmi05
DEFINE l_pmi08    LIKE pmi_file.pmi08  #稅別
DEFINE l_pmi081   LIKE pmi_file.pmi081 #稅率
DEFINE l_j07r05   LIKE pmj_file.pmj07  #若分量計價pmi05='Y',l_j07r05=pmr05
DEFINE lt_j07r05  LIKE pmj_file.pmj07  #若分量計價pmi05='N',l_j07r05=pmj07   
DEFINE l_price  LIKE ima_file.ima53
DEFINE lt_price LIKE pmh_file.pmh19
DEFINE l_sql1,l_sql2 STRING
                                       
   LET l_sql1 = "SELECT MAX(pmj09) "
   #LET l_sql2 = "  FROM ",s_dbstring(g_dbs),"pmj_file,",
   #                       s_dbstring(g_dbs),"pmi_file ",
   LET l_sql2 = "  FROM ",cl_get_target_table(gr_par.plant,'pmj_file'),",", #FUN-A50102
                          cl_get_target_table(gr_par.plant,'pmi_file'),     #FUN-A50102
                " WHERE pmi01=pmj01 ",
                "   AND pmi03= '",gr_par.vender,"'",
                "   AND pmj03= '",gr_par.part,"'",
                "   AND pmj05= '",gr_par.curr,"'",
                "   AND pmj12= '",gr_par.type,"'",  
                "   AND pmiconf='Y' ",
                "   AND pmiacti='Y' ",
                "   AND pmj09 <= '",gr_par.date,"'"
   IF NOT cl_null(gr_par.task) THEN
      LET l_sql2 = l_sql2 CLIPPED," AND pmj10= '",gr_par.task,"'"
   ELSE
      LET l_sql2 = l_sql2 CLIPPED," AND (pmj10 =' ' OR pmj10 = '' OR pmj10 IS NULL) "
   END IF
   IF NOT cl_null(gr_par.cell) THEN 
      LET l_sql2 = l_sql2 CLIPPED," AND pmj13 = '",gr_par.cell,"'"
   ELSE
      LET l_sql2 = l_sql2 CLIPPED," AND (pmj13 =' ' OR pmj13 = '' OR pmj13 IS NULL) "
   END IF
   #FUN-A30072--begin--add-------
   IF ms_pmjicd14_flag THEN
      LET l_sql2 = l_sql2 CLIPPED," AND pmjicd14 = '",ms_pmjicd14,"'"
   END IF 
   #FUN-A30072--end--add--------
   LET l_sql1=l_sql1 CLIPPED,l_sql2
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql1,gr_par.plant) RETURNING l_sql1 #FUN-A50102 
   PREPARE pmj_p1 FROM l_sql1
   EXECUTE pmj_p1 INTO l_max_pmj09
 
   IF cl_null(l_max_pmj09) THEN LET l_max_pmj09 = g_today END IF  
 
   LET l_sql1 = " SELECT pmi01,pmi05,pmi08,pmi081,pmj02,pmj07,pmj07t,pmj09 "
   LET l_sql1 = l_sql1 CLIPPED,l_sql2
   LET l_sql1 = l_sql1 CLIPPED, " AND pmj09 = '",l_max_pmj09,"'",
                " ORDER BY pmj09 DESC,pmi01 DESC "
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1               #MOD-D30182 add
   CALL cl_parse_qry_sql(l_sql1,gr_par.plant) RETURNING l_sql1  #MOD-D30182 add
   PREPARE pmj_pre FROM l_sql1
   DECLARE pmj_cur CURSOR FOR pmj_pre
   OPEN pmj_cur
   FETCH pmj_cur INTO l_pmi01,l_pmi05,l_pmi08,l_pmi081,
                      l_pmj02,l_j07r05,lt_j07r05,l_pmj09 
   CLOSE pmj_cur
 
   IF l_pmi05 = 'Y' THEN          #分量計價
       DECLARE pmr05_cur CURSOR FOR
        SELECT pmr05,pmr05t #分量計價的單價  
          FROM pmr_file
         WHERE pmr01 = l_pmi01
           AND pmr02 = l_pmj02
         #No.MOD-AC0308  --Begin
         # AND p_qty BETWEEN pmr03 AND pmr04
           AND gr_par.qty BETWEEN pmr03 AND pmr04
         #No.MOD-AC0308  --End  
           ORDER BY pmr05
       FOREACH pmr05_cur INTO l_j07r05,lt_j07r05   
           IF NOT cl_null(l_j07r05) THEN
               EXIT FOREACH
           END IF
       END FOREACH
    END IF
 
    IF cl_null(lt_j07r05) AND NOT cl_null(l_j07r05) THEN
       IF NOT cl_null(l_pmi081) THEN
          LET lt_j07r05 = l_j07r05 * (1 + l_pmi081/100)
          LET lt_j07r05 = cl_digcut(lt_j07r05,g_azi03)
       END IF
    END IF
    IF cl_null(l_j07r05) OR l_j07r05 <=0 THEN 
       LET l_j07r05 = 0 
       LET lt_j07r05 = 0 
    END IF
    LET l_price = l_j07r05
    LET lt_price = s_defprice_taxrate(gr_par.rate,l_pmi081,gr_par.tax,gr_par.vender,l_price,lt_j07r05)
    RETURN l_price,lt_price
END FUNCTION
 
FUNCTION s_defprice_A5()
DEFINE l_sql STRING
DEFINE l_price  LIKE ima_file.ima53
DEFINE lt_price LIKE pmh_file.pmh19
 
   IF cl_null(gr_par.task) THEN
      #LET l_sql="SELECT icg05 FROM ",s_dbstring(g_dbs),"icg_file ",
      LET l_sql="SELECT icg05 FROM ",cl_get_target_table(gr_par.plant,'icg_file'),     #FUN-A50102
                " WHERE icg01 = '",gr_par.part,"' ",
                "   AND icg03 = '",gr_par.vender,"' ",
                " ORDER BY icg02"
   ELSE
      #LET l_sql="SELECT icg05 FROM ",s_dbstring(g_dbs),"icg_file ",
      LET l_sql="SELECT icg05 FROM ",cl_get_target_table(gr_par.plant,'icg_file'),     #FUN-A50102
                " WHERE icg01 = '",gr_par.part,"' ",
                "   AND icg02 = '",gr_par.task,"' ",
                "   AND icg03 = '",gr_par.vender,"' " 
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
    CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102
   DECLARE icg05_cs CURSOR FROM l_sql
   OPEN icg05_cs
   IF SQLCA.sqlcode THEN LET g_errno = SQLCA.sqlcode END IF
   FETCH icg05_cs INTO l_price
   LET lt_price = s_defprice_taxrate(gr_par.rate,'',gr_par.tax,gr_par.vender,l_price,'')
   IF cl_null(l_price) OR l_price < 0 THEN
      LET l_price = 0
      LET lt_price = 0
   END IF
   RETURN l_price,lt_price
END FUNCTION
 
FUNCTION s_defprice_A6(p_part,p_vender,p_date,p_curr,p_tax,p_rate,p_unit,p_plant)
DEFINE p_part   LIKE pmh_file.pmh01          #料件編號                                                                         
DEFINE p_vender LIKE pmh_file.pmh02          #供應商編號                                                                       
DEFINE p_date   LIKE type_file.dat           #有效日期                                                                         
DEFINE p_unit   LIKE pmn_file.pmn07          #采購單位                                                                         
DEFINE p_plant  LIKE azp_file.azp01          #機構別
DEFINE p_curr   LIKE aza_file.aza17
DEFINE p_rate   LIKE gec_file.gec04          #稅率
DEFINE p_tax    LIKE gec_file.gec01          #稅別
DEFINE l_price  LIKE rtv_file.rtv07 #稅前價格
DEFINE lt_price LIKE rtv_file.rtv07 #稅后價格
DEFINE l_type   LIKE type_file.chr1 #取價類型
DEFINE l_no     LIKE rtu_file.rtu01 #價格來源
DEFINE l_gec07  LIKE gec_file.gec07
DEFINE l_pmc930 LIKE pmc_file.pmc930
DEFINE l_gec04  LIKE gec_file.gec04
DEFINE li_result LIKE type_file.num5
DEFINE l_sql STRING
 
   LET gr_par.part=p_part
   LET gr_par.vender=p_vender
   LET gr_par.date=p_date
   LET gr_par.unit=p_unit
   LET gr_par.plant=p_plant
   LET gr_par.rate=p_rate
   LET gr_par.tax=p_tax
   LET gr_par.curr=p_curr
 
   SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=p_plant
   #pmc930如果為null，則是外部供應商
   SELECT pmc930 INTO l_pmc930 FROM pmc_file WHERE pmc01 = gr_par.vender
   IF cl_null(l_pmc930) THEN     #外部供應商 
      CALL s_defprice_A6_s()
           RETURNING l_price,lt_price,l_type,l_no
   ELSE                          #內部供應商
      IF cl_null(gr_par.rate) THEN
         SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM pmc_file,gec_file 
          WHERE pmc01 = gr_par.vender AND pmc47 = gec01 AND gec011 = '1'
         LET gr_par.rate = l_gec04
      END IF
      CALL s_trade_price(l_pmc930,gr_par.plant,gr_par.plant,gr_par.part,gr_par.unit) 
         RETURNING li_result,l_price
      IF (NOT li_result) THEN                   
         IF g_pnz04='N' THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','','sub-206',1)
            ELSE                                                                             
               CALL cl_err('','sub-206',0)
            END IF
         END IF
         RETURN 0,0,'',''                                                                                                    
      END IF
      IF l_gec07 = 'Y' THEN
         LET lt_price = l_price
         LET l_price = lt_price/(1+gr_par.rate/100)
      ELSE
         LET lt_price = l_price * (1 + gr_par.rate/100)
      END IF
      LET l_type = '4'
      LET l_no = ''
   END IF
  #MOD-B10164 Begin---
  #SELECT azi04 INTO t_azi04
  #  FROM azi_file
  # WHERE azi01 = gr_par.curr     #幣別
  #IF cl_null(t_azi04) THEN
  #   LET t_azi04 = g_azi04
  #END IF   
  #LET l_price = cl_digcut(l_price,t_azi04)
  #LET lt_price = cl_digcut(lt_price,t_azi04) 
  #MOD-B10164 End-----
   RETURN l_price,lt_price,l_type,l_no
END FUNCTION
 
#外部供應商獲得協議價格
FUNCTION s_defprice_A6_s()
DEFINE l_rts01     LIKE rts_file.rts01           #采購協議編號
DEFINE l_rtu01     LIKE rtu_file.rtu01           #促銷協議編號
DEFINE l_rtt01     LIKE rtt_file.rtt01           #采購協議編號
DEFINE l_price     LIKE rtv_file.rtv07           #價格
DEFINE l_type      LIKE type_file.chr1           #取價類型
DEFINE l_no        LIKE rtu_file.rtu01           #價格來源
DEFINE l_sql       STRING
DEFINE l_rtv07     LIKE rtv_file.rtv07           #促銷價格
DEFINE l_rtt06     LIKE rtt_file.rtt06           #采購價格
DEFINE lt_price    LIKE rtv_file.rtv07          #未稅價格(稅前價格)
DEFINE l_rtv07t    LIKE rtv_file.rtv07t         
DEFINE l_rtt06t    LIKE rtt_file.rtt06t
DEFINE l_rtv14     LIKE rtv_file.rtv05
DEFINE l_rtt14     LIKE rtt_file.rtt14
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_fac       LIKE type_file.num20_6
DEFINE l_msg       LIKE type_file.chr50
 
   #取采購協議編號
   LET l_sql = "SELECT DISTINCT rts01 ",
               #"  FROM ",s_dbstring(g_dbs),"rts_file,",
               #          s_dbstring(g_dbs),"rto_file,",
               #          s_dbstring(g_dbs),"rtt_file ",
               "  FROM ",cl_get_target_table(gr_par.plant,'rts_file'),",", #FUN-A50102
                         cl_get_target_table(gr_par.plant,'rto_file'),",", #FUN-A50102
                         cl_get_target_table(gr_par.plant,'rtt_file'),     #FUN-A50102
               " WHERE rto01 = rts04 AND rtt01 = rts01",
               "   AND rts02 = rtt02 AND rtsplant = rttplant",
               "   AND rtt04= ? AND rto05 = ?",
               "   AND rto08 <= ? AND rto09 >= ?",
               "   AND rtoconf = 'Y' AND rtsconf = 'Y'",
               "   AND rtsplant = ?"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102              
   PREPARE rts01_sel FROM l_sql
   EXECUTE rts01_sel USING gr_par.part,gr_par.vender,
                           gr_par.date,gr_par.date,gr_par.plant
                      INTO l_rts01
   
   #獲取促銷協議編號
   LET l_sql = "SELECT DISTINCT rtu01 ",
               #"  FROM ",s_dbstring(g_dbs),"rtu_file",
               "  FROM ",cl_get_target_table(gr_par.plant,'rtu_file'),     #FUN-A50102
               "      ,",cl_get_target_table(gr_par.plant,'rtv_file'),     #TQC-AC0257
               " WHERE rtu04 = ? AND rtu05 = ?",
               "   AND rtu09 <= ? AND rtu10 >= ?", 
               "   AND rtuplant = ? AND rtuconf = 'Y'"
              ,"   AND rtu01=rtv01 AND rtu02=rtv02 AND rtuplant=rtvplant AND rtv04=?" #TQC-AC0257
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102              
   PREPARE rtu01_cs FROM l_sql
   EXECUTE rtu01_cs USING l_rts01,gr_par.vender,
                          gr_par.date,gr_par.date,gr_par.plant
                         ,gr_par.part                        #TQC-AC0257
                     INTO l_rtu01
   IF NOT cl_null(l_rtu01) THEN 
      #如果有促銷，取促銷價格
     #TQC-AC0257 Begin---
     #LET l_sql="SELECT rtv14,rtv07,rtv07t",
     #          #"  FROM ",s_dbstring(g_dbs),"rtv_file",
     #          "  FROM ",cl_get_target_table(gr_par.plant,'rtv_file'),     #FUN-A50102 
     #          " WHERE rtv01 = l_rtu01 AND rtv04 = p_part",
     #          "   AND rtvplant = p_org"
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     #CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102            
     #PREPARE rtv_sel FROM l_sql
     #EXECUTE rtv_sel USING l_rtu01,gr_par.part,gr_par.plant
     #                 INTO l_rtv14,l_rtv07,l_rtv07t
      LET l_sql="SELECT DISTINCT rtv14,rtv07,rtv07t",
                "  FROM ",cl_get_target_table(gr_par.plant,'rtv_file'),
                " WHERE rtv01 = ? AND rtv04 = ? ",    
                "   AND rtvplant = ? "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql
      PREPARE rtv_sel FROM l_sql
      EXECUTE rtv_sel USING l_rtu01,gr_par.part,gr_par.plant    
                       INTO l_rtv14,l_rtv07,l_rtv07t
     #TQC-AC0257 End-----
      #單位轉換
      CALL s_umfchk(gr_par.part,gr_par.unit,l_rtv14) RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         IF g_pnz04='N' THEN
            IF g_bgerr THEN
               CALL s_errmsg('',l_rtv14||'|'||gr_par.unit,'','aqc-500',1)
            ELSE
               LET l_msg = l_rtv14,"->",gr_par.unit
               CALL cl_err(l_msg CLIPPED,'aqc-500',0)
            END IF
         END IF
         RETURN l_price,lt_price,l_type,l_no
      END IF
      LET l_type = '2'
      LET l_no = l_rtu01
      LET l_price = l_rtv07*l_fac
      LET lt_price = l_rtv07t*l_fac
   ELSE
      LET l_sql="SELECT rtt14,rtt06,rtt06t",
                #"  FROM ",s_dbstring(g_dbs),"rtt_file",
                "  FROM ",cl_get_target_table(gr_par.plant,'rtt_file'),     #FUN-A50102 
                " WHERE rtt01 = ? AND rtt04 = ?", 
                "   AND rttplant = ?  AND rtt15 = 'Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,gr_par.plant) RETURNING l_sql #FUN-A50102            
      PREPARE rtt_sel FROM l_sql
      EXECUTE rtt_sel USING l_rts01,gr_par.part,gr_par.plant
                       INTO l_rtt14,l_rtt06,l_rtt06t
      #單位轉換                                                                                                                     
      CALL s_umfchk(gr_par.part,gr_par.unit,l_rtt14) RETURNING l_flag,l_fac 
      IF l_flag = 1 THEN
         IF g_pnz04='N' THEN
            IF g_bgerr THEN
               CALL s_errmsg('',l_rtt14||'|'||gr_par.unit,'','aqc-500',1)
            ELSE
               LET l_msg = l_rtt14,"->",gr_par.unit  
               CALL cl_err(l_msg CLIPPED,'aqc-500',0)   
            END IF
         END IF
         RETURN l_price,lt_price,l_type,l_no 
      END IF
      LET l_type = '3'
      LET l_no = l_rts01
      LET l_price = l_rtt06
      LET lt_price = l_rtt06t
   END IF
 
   IF cl_null(l_price) THEN LET l_price = 0 END IF
   IF cl_null(lt_price) THEN LET lt_price = 0 END IF
 
   RETURN l_price,lt_price,l_type,l_no  
END FUNCTION
 
FUNCTION s_defprice_taxrate(p_rate,p_rate1,p_tax,p_vender,p_price,pt_price)
   DEFINE l_flag     LIKE type_file.chr1,     #Y:稅率改變 N:稅率未改變
          p_rate     LIKE gec_file.gec04,     #傳入稅率
          p_rate1    LIKE gec_file.gec04,     #廠商料件檔&核價檔稅率
          p_tax      LIKE gec_file.gec01,     #傳入稅別
          p_vender   LIKE pmh_file.pmh02,     #傳入廠商編號
          l_gec04    LIKE gec_file.gec04,     #使用稅率
          p_price    LIKE pmh_file.pmh12,     #廠商料件檔&核價檔未稅單價
          pt_price   LIKE pmh_file.pmh19,     #廠商料件檔&核價檔含稅單價
          lt_price   LIKE pmh_file.pmh19      #廠商料件檔&核價檔含稅單價
 
   LET l_flag = 'Y'
   LET lt_price = pt_price
   IF cl_null(p_rate) THEN                  #未傳入稅率
      IF cl_null(p_rate1) THEN              #廠商料件檔&核價檔未抓取稅率
         IF cl_null(p_tax) THEN             #未傳入稅別
            SELECT gec04 INTO l_gec04
              FROM gec_file,pmc_file 
             WHERE pmc01 = p_vender
               AND gec01 = pmc47
               AND gec011='1'  #進項
               AND gecacti='Y'
         ELSE
            SELECT gec04 INTO l_gec04
              FROM gec_file
             WHERE gec01 = p_tax
               AND gec011='1'  #進項
               AND gecacti='Y'
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
#FUN-870007
#No.TQC-9A0109----END---

#FUN-A80104----start----
FUNCTION s_defprice_C1(p_part,p_vender,p_curr,p_date,p_qty,p_tax,p_unit,p_term,p_payment)
DEFINE p_part     LIKE pmh_file.pmh01      #料件編號                                                                         
DEFINE p_vender   LIKE pmh_file.pmh02      #供應商編號
DEFINE p_curr     LIKE aza_file.aza17      #幣別                                                                 
DEFINE p_date     LIKE type_file.dat       #有效日期 
DEFINE p_qty      LIKE pmn_file.pmn20      #採購數量
DEFINE p_tax      LIKE gec_file.gec01      #稅別
DEFINE p_unit     LIKE pmn_file.pmn07      #采購單位
DEFINE p_term     LIKE pof_file.pof01      #價格條件  
DEFINE p_payment  LIKE pof_file.pof05      #付款方式
DEFINE l_pog03    LIKE pog_file.pog03      #生效日期
DEFINE l_rate     LIKE azj_file.azj03      #折扣 
DEFINE l_rate1     LIKE azj_file.azj03     #折扣 
DEFINE lt_rate    LIKE pof_file.pof03      #數量折扣 
DEFINE l_price    LIKE rtv_file.rtv07      #未稅
DEFINE lt_price   LIKE rtv_file.rtv07      #含稅
DEFINE l_sql1,l_sql2 STRING

   LET l_price = 0
   LET lt_price = 0   
   LET l_rate = 0
   LET l_rate1 = 0 
   IF cl_null(p_qty) THEN
      LET p_qty = 0
   END IF
   LET l_sql1 = "SELECT pog08,pog08t,pog09,pof09,pog03 ",
                "  FROM ",cl_get_target_table(gr_par.plant,'pof_file'),",",
                          cl_get_target_table(gr_par.plant,'pog_file'), 
                " WHERE pof01 =pog01  AND pof02 = pog02 AND pof03 = pog03 ",
                "   AND pof04 = pog04 AND pof05 = pog05 ",
                "   AND pog06 = '",p_part,"'",
                "   AND pof01 = '",p_term,"'",
                "   AND pof02 = '",p_curr,"'",								
                "   AND pof04 = '",p_vender,"'",
                "   AND pof05 = '",p_payment,"'",								
                "   AND pog07 = '",p_unit,"'",								
                "   AND pof03 <= '",p_date,"'",
                "   AND pof06 >= '",p_date,"'",								
                "   AND pof08 = '",p_tax,"'"								
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              							
   CALL cl_parse_qry_sql(l_sql1,gr_par.plant) RETURNING l_sql1            
   PREPARE pog_sel FROM l_sql1
   EXECUTE pog_sel INTO l_price,lt_price,l_rate,lt_rate,l_pog03            						
                       
   LET l_sql2 = "SELECT MIN(poh09) ",
                "  FROM ",cl_get_target_table(gr_par.plant,'pof_file'),",", 
                          cl_get_target_table(gr_par.plant,'poh_file'),     
                " WHERE pof01 =poh01 AND pof02 = poh02 AND pof03 = poh03 ",								
                "   AND pof04 = poh04 AND pof05 = poh05 ",								
                "   AND poh06 = '",p_part,"'",
                "   AND poh01 = '",p_term,"'",
                "   AND poh02 = '",p_curr,"'",								
                "   AND poh04 = '",p_vender,"'",
                "   AND poh05 = '",p_payment,"'",								
                "   AND poh07 = '",p_unit,"'",								
                "   AND poh03 = '",l_pog03,"'",                 								
                "   AND poh08 <= '",p_qty,"'",								
                "   AND pof08 = '",p_tax,"'"      
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              							
   CALL cl_parse_qry_sql(l_sql2,gr_par.plant) RETURNING l_sql2            
   PREPARE poh_sel FROM l_sql2
   EXECUTE poh_sel INTO l_rate1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('sel poh_file',SQLCA.SQLCODE,1)
      RETURN 0
   END IF                 
   IF l_rate1 <> 100 THEN  #如果數量有折扣，則取數量的折扣
      LET l_rate = l_rate1   
   END IF
   LET l_price = l_price * l_rate/100
   LET lt_price = lt_price * l_rate/100
   RETURN l_price,lt_price
END FUNCTION

FUNCTION s_defprice_C2(p_part,p_vender,p_curr,p_date,p_qty,p_tax,p_unit,p_term,p_payment)
DEFINE p_part     LIKE pmh_file.pmh01      #料件編號                                                                         
DEFINE p_vender   LIKE pmh_file.pmh02      #供應商編號
DEFINE p_curr     LIKE aza_file.aza17      #幣別                                                                 
DEFINE p_date     LIKE type_file.dat       #有效日期 
DEFINE p_qty      LIKE pmn_file.pmn20      #採購數量
DEFINE p_tax      LIKE gec_file.gec01      #稅別
DEFINE p_unit     LIKE pmn_file.pmn07      #采購單位
DEFINE p_term     LIKE pof_file.pof01      #價格條件  
DEFINE p_payment  LIKE pof_file.pof05      #付款方式
DEFINE l_poj05    LIKE poj_file.poj05      #生效日期
DEFINE l_rate     LIKE azj_file.azj03      #折扣 
DEFINE l_rate1     LIKE azj_file.azj03     #折扣 
DEFINE lt_rate    LIKE pof_file.pof03      #數量折扣 
DEFINE l_price    LIKE rtv_file.rtv07      #未稅
DEFINE lt_price   LIKE rtv_file.rtv07      #含稅
DEFINE l_sql1,l_sql2 STRING

   LET l_price = 0
   LET lt_price = 0   
   LET l_rate = 0
   LET l_rate1 = 0
   IF cl_null(p_qty) THEN
      LET p_qty = 0
   END IF 
   LET l_sql1 = "SELECT poj06,poj06t,poj07,poi05,poj05 ",
                "  FROM ",cl_get_target_table(gr_par.plant,'poj_file'),",",
                          cl_get_target_table(gr_par.plant,'poi_file'), 
                " WHERE poj01 =poi01 AND poj02 = poi02 ",
                "   AND poj03 = '",p_part,"'",
                "   AND poj01 = '",p_term,"'",
                "   AND poj02 = '",p_curr,"'",								
                "   AND poj04 = '",p_unit,"'",								
                "   AND poj05 <= '",p_date,"'",
                "   AND poi04 = '",p_tax,"'",
                "   AND rownum = 1",             #MOD-C80260 add
                " ORDER BY poj05 DESC" 
   CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1              							
   CALL cl_parse_qry_sql(l_sql1,gr_par.plant) RETURNING l_sql1            
   PREPARE poj_sel FROM l_sql1
   EXECUTE poj_sel INTO l_price,lt_price,l_rate,lt_rate,l_poj05           						
                       
   LET l_sql2 = "SELECT MIN(pok07) ",
                "  FROM ",cl_get_target_table(gr_par.plant,'poi_file'),",", 
                          cl_get_target_table(gr_par.plant,'pok_file'),     
                " WHERE poi01 =pok01 AND poi02 = pok02 ",								
                "   AND pok03 = '",p_part,"'",
                "   AND pok01 = '",p_term,"'",
                "   AND pok02 = '",p_curr,"'",								
                "   AND pok04 = '",p_unit,"'",								
                "   AND pok05 = '",l_poj05,"'",                 								
                "   AND pok06 <= '",p_qty,"'",								
                "   AND poi04 = '",p_tax,"'"      
   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              							
   CALL cl_parse_qry_sql(l_sql2,gr_par.plant) RETURNING l_sql2            
   PREPARE pok_sel FROM l_sql2
   EXECUTE pok_sel INTO l_rate1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('sel pok_file',SQLCA.SQLCODE,1)
      RETURN 0
   END IF                 
   IF l_rate1 <> 100 THEN  #如果數量有折扣，則取數量的折扣
      LET l_rate = l_rate1   
   END IF
   LET l_price = l_price * l_rate/100
   LET lt_price = lt_price * l_rate/100
   RETURN l_price,lt_price
END FUNCTION   
#FUN-A80104----end----


#FUN-A30072--begin--add----------------
FUNCTION s_defprice_new_price(p_pmjicd14)
DEFINE p_pmjicd14  LIKE pmj_file.pmjicd14
   LET ms_pmjicd14_flag = TRUE
   LET ms_pmjicd14 = p_pmjicd14
END FUNCTION

FUNCTION s_defprice_new_init()
   LET ms_pmjicd14_flag = FALSE
   LET ms_pmjicd14 = NULL
END FUNCTION
#FUN-A30072--add--end--------------------    
