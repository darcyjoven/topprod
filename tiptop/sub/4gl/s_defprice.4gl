# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: s_defprice.4gl
# Descriptions...: 取得採購單價
# Date & Author..: 93/02/08 By Apple
# Usage..........: LET l_price,lt_price=s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit)
# Input Parameter: p_part    料件編號 
#                  p_vender  供應商編號
#                  p_curr    幣別
#                  p_date    有效日期
#                  p_qty     數量                            #NO:7178
#                  p_task    作業編號==>一般採購單,委外採購單 傳''       #NO:7178
#                                    ==>製程委外採購單        傳作業編號 #NO:7178
#                  p_tax     稅別
#                  p_rate    稅率
#                  p_type    資料型態
#                  p_unit    單位
#                  p_cell  
#                  p_term
#                  p_payment  
# Return code....: l_price,lt_price 未稅單價,含稅單價 
# Modify.........: 00/02/11 By Kammy 加傳參數 "幣別"
# Modify.........: 01-04-30 BY ANN CHEN No.B471 做幣別換算;核價應考慮幣別
# Modify.........: No:9360 04/03/19 By Melody l_sql 段，應增加 " AND pmi03= '",p
# Modify.........: No.MOD-490265 04/09/16 By Smapmin加上last_price大於0才update pmh_file
# Modify.........: No.BUG-4B0099 04/11/15 By Mandy 將IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode 的判斷式挪到MOD-490265加的IF...END IF內
# Modify.........: No.MOD-5B0262 05/11/22 By Rosayu g_sma.sma841='6' 依核價檔與料件供應商取低者',若無核價資料,會造成單價取價錯誤
# Modify.........: No.FUN-610018 06/01/06 By ice 傳參新增稅別,稅率;回傳值增加含稅單價
# Modify.........: No.TQC-620035 06/02/11 By ice 稅率改變后,以未稅價推含稅價應增加IF判斷
# Modify.........: No.MOD-670050 06/07/11 By Tracy 嵌套sql中應考慮作業編號的條件
# Modify.........: No.FUN-670099 06/08/11 By Nicola 價格管理修改
# Modify.........: No.FUN-680147 06/09/18 By czl 欄位型態定義,改為LIKE
# Modify.........: No.MOD-680090 06/11/15 By pengu 未依據原幣單價小數位數取位
# Modify.........: No.MOD-730044 07/09/18 By claire 需考慮採購單位與料件採購資料的採購單位(ima44)或計價單位(ima908)換算
# Modify.........: No.TQC-7B0011 07/11/01 By wujie  采用核價檔取價，當一顆新料在同一天有兩筆核價資料，則自動帶出的采購單價是第一筆的核價金額。
#                                                   現修改為，出現以上情況時，選擇單號最大的那筆
# Modify.........: No.TQC-7C0096 07/12/08 By zLynn  取匯率時不應該直接抓'S'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0014 07/12/18 By bnlent 新增ICD行業取價功能
# Modify.........: No.FUN-810016 08/01/18 By ve007 采購價格分段定價時的取價功能
                                                  #可按照工藝單元取價功能
# Modify.........: No.FUN-810038 08/12/18 By bnlent 新增ICD行業取價功能
# Modify.........: No.FUN-840001 NO.FUN-840178 08/04/01 By ve007 pmh23 is PK  debug 810016 
# Modify.........: No.MOD-840295 08/04/21 By claire 調整FUN-810016,pmj13 is PK 
# Modify.........: No.FUN-8A0136 08/10/30 By arman  l_count1 -->l_price,l_count2--->lt_price
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920099 09/03/10 By Carrier 服飾版三段屬性時，取價錯誤 & 調整本支作業，使后續維護簡易
# Modify.........: No.FUN-930148 09/03/24 by ve007 采購取價和定價功能修改
# Modify.........: No.TQC-940165 09/04/27 By Carrier 取折扣錯誤
# Modify.........: No.FUN-940139 09/04/30 By Carrier 價格表取價時，不乘與ima44的轉換率
# Modify.........: No.TQC-980045 09/08/18 By lilingyu 過單用，未修改4gl
# Modify.........: No:MOD-C20193 12/02/23 By suncx 取分量計價資料的SQL有問題
# Modify.........: No:TQC-C30091 12/03/05 By suncx MOD-C20193改錯
# Modify.........: No:MOD-C30874 12/05/09 By Vampire 乘算單位轉換率之後應該再依照含稅未稅否回推
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type)  #MOD-730044 mark
#FUNCTION s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit)  #MOD-730044 #No.FUN-810016 --mark--
#FUNCTION s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell) #No.FUN-810016 
FUNCTION s_defprice(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment)   #No.FUN-930148
DEFINE p_part     LIKE pmh_file.pmh01,
       p_part1    LIKE pmh_file.pmh01,          #No.FUN-810016
       p_vender   LIKE pmh_file.pmh02,
       p_curr     LIKE pmh_file.pmh13,
       p_date     LIKE type_file.dat,          #No.FUN-680147 DATE
       p_qty      LIKE pmn_file.pmn20,         #NO:7178
       p_unit     LIKE pmn_file.pmn86,         #MOD-730044
       p_task     LIKE pmj_file.pmj10,         #NO:7178
       p_type     LIKE pmh_file.pmh22,         #No.FUN-670099
       l_price    LIKE ima_file.ima53,
       #No.FUN-610018 --start--
       p_tax      LIKE gec_file.gec01,
       p_rate     LIKE gec_file.gec04,
       lt_price   LIKE pmh_file.pmh19,
       #No.FUN-610018 --end--
       p_term     LIKE pof_file.pof01,        #No.FUN-930148
       p_payment  LIKE pof_file.pof05         #No.FUN-930148
DEFINE p_cell     LIKE pmj_file.pmj13         #No.FUN-810016
DEFINE l_imx      RECORD LIKE imx_file.*      #No.FUN-810016
DEFINE l_count    LIKE type_file.num5         #No.FUN-810016
DEFINE l_i        LIKE type_file.num5         #No.TQC-920099
 
   
   #No.TQC-920099  --Begin
   # No.FUN-810016--begin--
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
                WHEN 3 LET p_part1=l_imx.imx00,g_sma.sma46,l_imx.imx01,
                                               g_sma.sma46,l_imx.imx02,
                                               g_sma.sma46,l_imx.imx03
                WHEN 2 LET p_part1=l_imx.imx00,g_sma.sma46,l_imx.imx01,
                                               g_sma.sma46,l_imx.imx02
                WHEN 1 LET p_part1=l_imx.imx00,g_sma.sma46,l_imx.imx01
                WHEN 0 LET p_part1=l_imx.imx00
                OTHERWISE LET p_part1=p_part
             END CASE
             CALL s_defprice_1(p_part1,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment)  #No.FUN-930148 add p_term,p_payment
                  RETURNING l_price,lt_price
             IF l_price <> 0 AND lt_price <>0 THEN
                EXIT FOR
             END IF
         END FOR 
      ELSE 
         CALL s_defprice_1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment)   #No.FUN-840178   #No.FUN-930148 add p_term,p_payment
              RETURNING l_price,lt_price           
      END IF
   ELSE 
      CALL s_defprice_1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment)   #No.FUN-930148 add p_term,p_payment
           RETURNING l_price,lt_price  
   END IF
   RETURN l_price,lt_price
   # No.FUN-810016--end--
   #No.TQC-920099  --End
  
END FUNCTION
 
#No.FUN-620035 --start--
#稅率是否改變,只有稅率改變時才以未稅價推含稅價 
FUNCTION s_defprice_rate(p_rate,p_rate1,p_tax,p_vender,p_price,pt_price)
   DEFINE l_flag     LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) #Y:稅率改變 N:稅率未改變
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
#No.FUN-620035 --end--
 
#No.FUN-7B0014 --Begin
#DESCRIPTION	廠商料件單價邏輯字串解析
#PARAMETERS	p_formular      邏輯公式
#RETURNING      l_operator1,l_operand,l_operator2->運算元1,運算子,運算元2
FUNCTION s_defprice_icd(p_formular)
DEFINE p_formular   LIKE ich_file.ich02,
       l_operator1  LIKE ich_file.ich02,
       l_operator2  LIKE ich_file.ich02,
       l_operand    LIKE type_file.chr1,
       l_i          LIKE type_file.num5
 
    LET l_operator1 = NULL
    LET l_operator2 = NULL
    LET l_operand   = NULL
 
    IF NOT cl_null(p_formular) THEN   #要非NULL
       IF p_formular[1,1] = '(' AND   #要有()包住
          p_formular[LENGTH(p_formular),LENGTH(p_formular)] = ')' THEN
          FOR l_i = 2 TO LENGTH(p_formular) - 1
              IF p_formular[l_i,l_i] = '+' OR p_formular[l_i,l_i] = '-' OR
                 p_formular[l_i,l_i] = '*' OR p_formular[l_i,l_i] = '\/' THEN
                 LET l_operand = p_formular[l_i,l_i]
                 IF l_i > 2 THEN LET l_operator1 = p_formular[2,l_i - 1] END IF
                 IF l_i < LENGTH(p_formular) THEN
                    LET l_operator2 = p_formular[l_i + 1,LENGTH(p_formular)-1]
                 END IF
                 EXIT FOR
              END IF
          END FOR
       END IF
    END IF
 RETURN l_operator1,l_operand,l_operator2
END FUNCTION
#No.FUN-7B0014 --End
 
#No.FUN-810016--begin--
#FUNCTION s_defprice_1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_cell)
FUNCTION s_defprice_1(p_part,p_vender,p_curr,p_date,p_qty,p_task,p_tax,p_rate,p_type,p_unit,p_cell,p_term,p_payment)    #No.FUN-930148
DEFINE p_part     LIKE pmh_file.pmh01,
       p_vender   LIKE pmh_file.pmh02,
       p_curr     LIKE pmh_file.pmh13,
       p_date     LIKE type_file.dat,          #No.FUN-680147 DATE
       p_qty      LIKE pmn_file.pmn20,  #NO:7178
       p_unit     LIKE pmn_file.pmn86,  #MOD-730044
       p_task     LIKE pmj_file.pmj10,  #NO:7178
       p_type     LIKE pmh_file.pmh22,  #No.FUN-670099
       l_unitrate LIKE pmn_file.pmn121, #MOD-730044
       l_sw       LIKE type_file.num10, #MOD-730044
       l_ima44    LIKE ima_file.ima44,  #MOD-730044 
       l_ima908   LIKE ima_file.ima908, #MOD-730044 
       l_ima53    LIKE ima_file.ima53,
       l_ima531   LIKE ima_file.ima531,
       l_pmh12    LIKE pmh_file.pmh12,
       l_pmj02    LIKE pmj_file.pmj02, 
       l_pmj07    LIKE pmj_file.pmj07, 
       l_pmj09    LIKE pmj_file.pmj09, 
       l_price    LIKE ima_file.ima53,
       #No.FUN-610018 --start--
       p_tax      LIKE gec_file.gec01,
       p_rate     LIKE gec_file.gec04,
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
       #No.FUN-610018 --end--
       last_price LIKE pmh_file.pmh12,
       l_pmi01    LIKE pmi_file.pmi01,
       l_pmi05    LIKE pmi_file.pmi05,
       l_pmi08    LIKE pmi_file.pmi08,  #TQC-620035 稅別
       l_pmi081   LIKE pmi_file.pmi081, #TQC-620035 稅率
       l_j07r05   LIKE pmj_file.pmj07,  #若分量計價pmi05='Y',l_j07r05=pmr05
                                        #若分量計價pmi05='N',l_j07r05=pmj07
       p_term     LIKE pof_file.pof01,        #No.FUN-930148
       p_payment  LIKE pof_file.pof05,        #No.FUN-930148                                 
       l_sql      STRING      #No.FUN-680147 VARCHAR(3000)
DEFINE l_rate        LIKE azj_file.azj03
DEFINE l_flag        LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01) #FUN-610018
DEFINE p_cell        LIKE pmj_file.pmj13         #No.FUN-810016
DEFINE l_imx         RECORD LIKE imx_file.*      #No.FUN-810016
DEFINE l_count       LIKE type_file.num5         #No.FUN-810016
DEFINE l_count1      LIKE type_file.num5         #No.FUN-810016
DEFINE l_count2      LIKE type_file.num5         #No.FUN-810016
DEFINE l_max_pmj09   LIKE pmj_file.pmj09         #No.TQC-920099
DEFINE l_sql1        STRING                      #No.TQC-920099
DEFINE l_pnz03       LIKE pnz_file.pnz03         #No.FUN-930148
 
    LET l_pmh12=null LET l_pmj07=null LET l_pmj09=null
    LET l_pmh19=null LET l_pmj07t=null   #No.FUN-610018
    LET l_flag = 'N'                     #No.FUN-610018 Default 初值
 
   #-------No.MOD-680090 add
    SELECT azi03 INTO t_azi03 
      FROM azi_file
     WHERE azi01 = p_curr     #幣別
    IF cl_null(t_azi03) THEN
       LET t_azi03 = g_azi03
    END IF
   #-------No.MOD-680090 end
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
   #No.TQC-920099  --Begin
   IF cl_null(p_cell) THEN
      LET p_cell = ' '
   END IF
    
   #料件供應商
   SELECT pmh12,pmh17,pmh18,pmh19 
     INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19 
     FROM pmh_file                   #料件供應商
    WHERE pmh01 = p_part
      AND pmh02 = p_vender
      AND pmh13 = p_curr             #幣別
      AND pmh21 = p_task             #No.FUN-670099
      AND pmh22 = p_type             #No.FUN-670099
      AND pmh23 = p_cell             #No.FUN-810016
      AND pmhacti = 'Y'              #CHI-910021
   IF cl_null(l_pmh19) AND NOT cl_null(l_pmh12) THEN
      IF NOT cl_null(l_pmh18) THEN
         LET l_pmh19 = l_pmh12 * (1 + l_pmh18/100)   #No.TQC-620035 
         LET l_pmh19 = cl_digcut(l_pmh19,g_azi03)
      END IF
   END IF
 
   #核價單 -最近一筆的核價資料，若同一日期有兩筆，則找出單號最大的一筆核價資料
   LET l_sql = " SELECT MAX(pmj09) FROM pmj_file,pmi_file ",
               "  WHERE pmi01=pmj01 ",
               "    AND pmi03= '",p_vender,"'",
               "    AND pmj03= '",p_part,"'",
               "    AND pmj05= '",p_curr,"'",
               "    AND pmj12= '",p_type,"'",  #No.FUN-670099
               "    AND pmiconf='Y' ",
               "    AND pmiacti='Y' ",
               "    AND pmj09 <= '",p_date,"'"
   IF NOT cl_null(p_task) THEN
      LET l_sql = l_sql CLIPPED," AND pmj10= '",p_task,"'"
   ELSE
      LET l_sql = l_sql CLIPPED," AND (pmj10 =' ' OR pmj10 = '' OR pmj10 IS NULL) "
   END IF
   IF NOT cl_null(p_cell) THEN 
      LET l_sql = l_sql CLIPPED," AND pmj13 = '",p_cell,"'"
   ELSE
      LET l_sql = l_sql CLIPPED," AND (pmj13 =' ' OR pmj13 = '' OR pmj13 IS NULL) "
   END IF
   PREPARE pmj_p1 FROM l_sql
   EXECUTE pmj_p1 INTO l_max_pmj09
   #若不賦值，后面會當出
   IF cl_null(l_max_pmj09) THEN LET l_max_pmj09 = g_today END IF  
 
   LET l_sql1 = " SELECT pmi01,pmi05,pmi08,pmi081,pmj02,pmj07,pmj07t,pmj09 ",
                "   FROM pmj_file,pmi_file ",
                "  WHERE pmi01 = pmj01",     #核價單號
                "    AND pmj03 = '",p_part,"'",
                "    AND pmj05 = '",p_curr,"'",
                "    AND pmj09<= '",p_date,"'",
                "    AND pmj12 = '",p_type,"'",  #No.FUN-670099
                "    AND pmiconf='Y' ",
                "    AND pmiacti='Y' ",
                "    AND pmi03 = '",p_vender,"'"
   IF NOT cl_null(p_task) THEN
      LET l_sql1 = l_sql1 CLIPPED," AND pmj10 = '",p_task,"'"  #作業編號
   ELSE
      LET l_sql1 = l_sql1 CLIPPED," AND (pmj10 =' ' OR pmj10 = '' OR pmj10 IS NULL) "
   END IF
   IF NOT cl_null(p_cell) THEN 
      LET l_sql1 = l_sql1 CLIPPED," AND pmj13 = '",p_cell,"'"
   ELSE
      LET l_sql1 = l_sql1 CLIPPED," AND (pmj13 = ' ' OR  pmj13 IS NULL)"
   END IF
   LET l_sql1 = l_sql1 CLIPPED, " AND pmj09 = '",l_max_pmj09,"'",
                " ORDER BY pmj09 DESC,pmi01 DESC "     #No.TQC-7B0011
 
   PREPARE pmj_pre FROM l_sql1
   DECLARE pmj_cur CURSOR FOR pmj_pre
   OPEN pmj_cur
   FETCH pmj_cur INTO l_pmi01,l_pmi05,l_pmi08,l_pmi081,           #No.TQC-620035
                      l_pmj02,l_j07r05,lt_j07r05,l_pmj09 #NO:7178 #No.FUN-610018
   CLOSE pmj_cur
   #No.TQC-920099  --End
 
    #NO:7178
    IF l_pmi05 = 'Y' THEN          #分量計價
       DECLARE pmr05_cur CURSOR FOR
        SELECT pmr05,pmr05t #分量計價的單價  #No.FUN-610018
          FROM pmr_file
         WHERE pmr01 = l_pmi01
           AND pmr02 = l_pmj02
          #AND p_qty BETWEEN pmr03 AND pmr04       #MOD-C20193 mark
          #AND gr_par.qty BETWEEN pmr03 AND pmr04  #MOD-C20193 add   #TQC-C30091 mark
           AND p_qty BETWEEN pmr03 AND pmr04       #TQC-C30091 add 
           ORDER BY pmr05
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
      #LET l_rate = s_curr3(p_curr,g_today,'S')
       LET l_rate = s_curr3(p_curr,g_today,g_sma.sma904)  #TQC-7C0096 Mod
    ELSE
       LET l_rate=1
    END IF
    #No.B471 END
    #No.TQC-620035 --start--
    SELECT ima53,ima531,ima44,ima908                       #MOD-730044 modify
      INTO l_ima53,l_ima531,l_ima44,l_ima908    #料件單價  #MOD-730044 modify
      FROM ima_file 
     WHERE ima01 = p_part
    #No.FUN-610018 --start--
    IF cl_null(l_ima53) THEN LET l_ima53 = 0 END IF
    IF cl_null(l_ima531) THEN LET l_ima531 = 0 END IF
    #No.FUN-610018 --end--
    #No.TQC-620035 --end--
    SELECT pnz03 INTO l_pnz03  FROM pnz_file WHERE pnz01 = p_term   #NO.FUN-930148
    CASE 
  #   WHEN g_sma.sma841 = '1'   #1.[料件/供應商]採購單價 2.料件主檔[採購單價]  #No.FUN-930148
      WHEN l_pnz03 = '1'        #1.[料件/供應商]採購單價 2.料件主檔[採購單價]  #No.FUN-930148
          LET l_price = l_pmh12 
          #No.TQC-620035
          LET lt_price = s_defprice_rate(p_rate,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
          IF cl_null(l_pmh12) OR l_pmh12 <= 0 THEN 
             #No.B471
             #LET l_price = l_ima53
             LET l_price = l_ima53/l_rate   
             #No.TQC-620035
             LET lt_price = s_defprice_rate(p_rate,'',p_tax,p_vender,l_price,'')
          END IF
  #   WHEN g_sma.sma841 = '2'   #1.[料件/供應商]採購單價 2.料件主檔[市價]   #No.FUN-930148
      WHEN l_pnz03 = '2'         #1.[料件/供應商]採購單價 2.料件主檔[市價]   #No.FUN-930148
          LET l_price = l_pmh12
          #No.TQC-620035
          LET lt_price = s_defprice_rate(p_rate,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
          IF cl_null(l_pmh12) OR l_pmh12 <= 0 THEN 
             #LET l_price = l_ima531
             LET l_price = l_ima531 / l_rate
             #No.TQC-620035
             LET lt_price = s_defprice_rate(p_rate,'',p_tax,p_vender,l_price,'')
          END IF
 #   WHEN g_sma.sma841 = '3'      #料件主檔[最近採購單價]          #No.FUN-930148
     WHEN l_pnz03 = '3'      #料件主檔[最近採購單價]                 #No.FUN-930148
          #LET l_price = l_ima53
          LET l_price = l_ima53 / l_rate
          #No.TQC-620035
          LET lt_price = s_defprice_rate(p_rate,'',p_tax,p_vender,l_price,'')
 #    WHEN g_sma.sma841 = '4'      #料件主檔[市價]               #No.FUN-930148
     WHEN l_pnz03 = '4'      #料件主檔[市價]                      #No.FUN-930148
          #LET l_price = l_ima531
          LET l_price = l_ima531 / l_rate
          #No.TQC-620035
          LET lt_price = s_defprice_rate(p_rate,'',p_tax,p_vender,l_price,'')
     #------------ 00/01/21 sma841新增 '6' --------------
  #   WHEN g_sma.sma841 = '5'        #依核價單價                  #No.FUN-930148
     WHEN l_pnz03 = '5'        #依核價單價                         #No.FUN-930148
          LET l_price = l_j07r05
          #No.TQC-620035
          LET lt_price = s_defprice_rate(p_rate,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)
          IF cl_null(l_price) OR l_price <= 0 THEN
             LET l_price = l_ima53 / l_rate
             #No.TQC-620035
             LET lt_price = s_defprice_rate(p_rate,'',p_tax,p_vender,l_price,'')
          END IF 
  #  WHEN g_sma.sma841 = '6'      #依核價檔與料件供應商取低者     #No.FUN-930148
     WHEN l_pnz03 = '6'      #依核價檔與料件供應商取低者            #No.FUN-930148
          #NO:7178------
          IF cl_null(l_pmh12) OR l_pmh12  <=0 THEN 
             LET l_pmh12  = 0 
             LET l_pmh19  = 0    #No.FUN-610018
          END IF
          IF l_flag != 'Y' THEN #MOD-5B0262 add IF
             IF l_j07r05 < l_pmh12 THEN
                LET l_price = l_j07r05
                #No.TQC-620035
                LET lt_price = s_defprice_rate(p_rate,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)
                LET l_tax = l_pmi08          #No.TQC-620035
             ELSE
                LET l_price = l_pmh12
                #No.TQC-620035
                LET lt_price = s_defprice_rate(p_rate,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
                LET l_tax = l_pmh17          #No.TQC-620035
             END IF
          ELSE
             LET l_price = l_pmh12
             #No.TQC-620035
             LET lt_price = s_defprice_rate(p_rate,l_pmh18,p_tax,p_vender,l_price,l_pmh19)
             LET l_tax = l_pmh17          #No.TQC-620035
          END IF
          CASE WHEN g_sma.sma83='1'            
                  LET last_price=l_j07r05   #無條件更新,(以核價檔單價)
                  #No.TQC-620035
                  LET lastt_price = s_defprice_rate(p_rate,l_pmi081,p_tax,p_vender,last_price,lt_j07r05)
                  LET l_tax = l_pmi08          #No.TQC-620035
               WHEN g_sma.sma83='2' 
                  LET last_price=l_price   #較低時更新
                  LET lastt_price=lt_price #FUN-610018
               WHEN g_sma.sma83='3' 
                  LET last_price=l_pmh12   #不更新
                  #No.TQC-620035
                  #No.TQC-620035
                  LET lastt_price = s_defprice_rate(p_rate,l_pmh18,p_tax,p_vender,last_price,l_pmh19)
                  LET l_tax = l_pmh17          #No.TQC-620035
               OTHERWISE EXIT CASE
          END CASE
          #MOD-490265加上last_price大於0時才update pmh_file          
          IF last_price > 0 THEN
             SELECT azi03 INTO t_azi03 
               FROM azi_file
              WHERE azi01 = p_curr     #幣別
             IF cl_null(t_azi03) THEN
                LET t_azi03 = g_azi03
             END IF
             LET lastt_price = cl_digcut(lastt_price,t_azi03)
             #No.TQC-620035 取得廠商料件稅種
             IF cl_null(p_tax) THEN 
                IF cl_null(l_tax) THEN
                   SELECT pmc47 INTO p_tax
                     FROM pmc_file
                    WHERE pmc01 = p_vender
                ELSE
                   LET p_tax = l_tax
                END IF
             END IF
             #No.TQC-520035 --end
             UPDATE pmh_file 
                SET pmh12 = last_price,
                    pmh17 = p_tax,        #No.FUN-610018
                    pmh18 = p_rate,       #No.FUN-610018
                    pmh19 = lastt_price,  #No.FUN-610018
                    pmhdate = g_today     #FUN-C40009 add
              WHERE pmh01 = p_part 
                AND pmh02 = p_vender
                AND pmh13 = p_curr
                AND pmh21 = p_task  #No.FUN-670099
                AND pmh22 = p_type  #No.FUN-670099
                AND pmh23 = p_cell  #No.TQC-920099
              IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN #MOD-4B0099將此判斷挪到IF...END IF 內
                 LET g_errno='mfg3442'
             END IF
          END IF
          #MOD-490265  
          #NO:7178------
          #原程式
         # 
         #IF cl_null(l_pmj07) THEN LET l_pmj07 = 0 END IF
         #IF l_pmj07!=0 AND l_pmj07 < l_pmh12 OR l_pmh12 <=0 THEN   #No.+223 010
         #   LET l_price=l_pmj07
         #ELSE
         #   LET l_price=l_pmh12
         #END IF
         #IF cl_null(l_price) OR l_price =0 THEN
         #    LET l_price=l_pmh12
         #END IF
         #IF cl_null(l_price) OR l_price =0 THEN
         #    LET l_price=l_pmh12
         #END IF
         #CASE WHEN g_sma.sma83='1' LET last_price=l_pmj07
         #     WHEN g_sma.sma83='2' LET last_price=l_price
         #     WHEN g_sma.sma83='3' LET last_price=l_pmh12
         #     OTHERWISE EXIT CASE
         #END CASE
         #UPDATE pmh_file SET pmh12 = last_price
         # WHERE pmh01 = p_part AND pmh02 = p_vender
         #   AND pmh13 = p_curr
         #IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
         #   LET g_errno='mfg3442'
         #END IF
         # 
 #    WHEN g_sma.sma841 = '7'      #依核價檔取價                #No.FUN-930148
     WHEN l_pnz03 = '7'      #依核價檔取價                       #No.FUN-930148
          #NO:7178------
          LET l_price = l_j07r05
          #No.TQC-620035
          LET lt_price = s_defprice_rate(p_rate,l_pmi081,p_tax,p_vender,l_price,lt_j07r05)
          IF cl_null(l_price) OR l_price <=0 THEN 
             LET l_price = 0 
             LET lt_price = 0     #No.FUN-610018
          END IF
     #No.FUN-7B0014  --Begin
  #   WHEN g_sma.sma841 = '8'      #依BODY取價                  #No.FUN-930148
     WHEN l_pnz03 = '8'      #依BODY取價                         #No.FUN-930148
          IF cl_null(p_task) THEN #FUN-810038 非委外採購時無作業編號,則取第一筆
             LET l_sql="SELECT icg05 FROM icg_file ",
                       " WHERE icg01 = '", p_part,"' ",
                       "   AND icg03 = '", p_vender,"' ",
                       " ORDER BY icg02"
          ELSE
             LET l_sql="SELECT icg05 FROM icg_file ",
                       " WHERE icg01 = '", p_part,"' ",
                       "   AND icg02 = '", p_task,"' ",
                       "   AND icg03 = '", p_vender,"' " 
          END IF
          DECLARE icg05_cs CURSOR FROM l_sql
          FOREACH icg05_cs INTO l_price
             IF SQLCA.sqlcode THEN LET g_errno = SQLCA.sqlcode END IF
             EXIT FOREACH
          END FOREACH 
          LET lt_price = s_defprice_rate(p_rate,l_pmi081,p_tax,
                                       p_vender,l_price,l_pmh19)
          IF cl_null(l_price) OR l_price < 0 THEN
             LET l_price = 0
             LET lt_price = 0
          END IF
     #No.FUN-7B0014  --End
     #NO.FUN-930148 --begin--
     WHEN l_pnz03 = '9'
       CALL s_price_by_term(p_part,p_vender,p_curr,p_date,p_qty,p_unit,p_term,p_payment)
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
    #MOD-730044-begin-add
     #No.FUN-940139  --Begin
     IF l_pnz03 <> '9' THEN
        IF cl_null(p_unit) THEN LET p_unit=l_ima44 END IF 
        IF g_sma.sma116 MATCHES '[13]' THEN   
           LET l_ima44 = l_ima908
        END IF 
        IF NOT cl_null(p_unit) AND p_unit <> l_ima44 THEN
           LET l_unitrate = 1 
           CALL s_umfchk(p_part,p_unit,l_ima44)
           RETURNING l_sw,l_unitrate
           IF l_sw THEN
              #單位換算率抓不到 ---#
              LET g_errno='abm-731'
              RETURN 0,0
           END IF
           LET l_price=l_price*l_unitrate
           #LET lt_price=lt_price*l_unitrate #MOD-C30874 mark
           LET lt_price = s_defprice_rate(p_rate,'',p_tax,p_vender,l_price,'') #MOD-C30874 add
        END IF
       #MOD-730044-end-add
     END IF
     #No.FUN-940139  --Begin
     LET l_price = cl_digcut(l_price,t_azi03)
     LET lt_price = cl_digcut(lt_price,t_azi03)
     RETURN l_price,lt_price #No.FUN-610018 
END FUNCTION
#No.FUN-810016--end--
#No.FUN-930148--begin--
FUNCTION s_price_by_term(p_part,p_vender,p_curr,p_date,p_qty,p_unit,p_term,p_payment)
DEFINE l_price     LIKE ima_file.ima53,
       lt_price    LIKE ima_file.ima53,
       l_rate      LIKE azj_file.azj03,
       l_rate1     LIKE azj_file.azj03,
       p_part      LIKE pmh_file.pmh01,       
       p_vender    LIKE pmh_file.pmh02,
       p_curr      LIKE pmh_file.pmh13,
       p_date      LIKE type_file.dat,          
       p_qty       LIKE pmn_file.pmn20,         
       p_unit      LIKE pmn_file.pmn86,
       p_term      LIKE pof_file.pof01,       
       p_payment   LIKE pof_file.pof05,
       lt_rate     LIKE pof_file.pof09 
DEFINE l_poj05     LIKE poj_file.poj05    #No.TQC-940165
DEFINE l_pog03     LIKE pog_file.pog03    #No.TQC-940165
 
    LET l_price = 0
    LET lt_price = 0   
    LET l_rate = 0
    LET l_rate1 = 0  
    DECLARE price_by_term1 SCROLL CURSOR  FOR   
     SELECT pog08,pog08t,pog09,pof09,pog03     #No.TQC-940165
      FROM pof_file,pog_file
      WHERE pof01 =pog01 AND pof02 = pog02 AND pof03 = pog03
        AND pof04 = pog04 AND pof05 = pog05    
        AND pog06 = p_part AND pof01 = p_term AND pof02 = p_curr 
        AND pof04 = p_vender AND pof05 = p_payment
        AND pog07 = p_unit
        AND pof03 <=p_date AND pof06 >= p_date 
        ORDER BY pof03 DESC
    IF STATUS THEN 
       CALL cl_err('byterm1_curs',STATUS,1) RETURN 0
    END IF 
    
    OPEN price_by_term1
    FETCH FIRST price_by_term1 INTO l_price,lt_price,l_rate,lt_rate,l_pog03  #No.TQC-940165
    CLOSE  price_by_term1   
    
     SELECT MIN(poh09) INTO l_rate1 
      FROM pof_file,poh_file
      WHERE pof01 =poh01 AND pof02 = poh02 AND pof03 = poh03
        AND pof04 = poh04 AND pof05 = poh05    
        AND poh06 = p_part AND poh01 = p_term AND poh02 = p_curr 
        AND poh04 = p_vender AND poh05 = p_payment
        AND poh07 = p_unit
#       AND pof03 <=p_date AND pof06 >= p_date   #No.TQC-940165
        AND poh03 = l_pog03                      #No.TQC-940165
        AND poh08 <= p_qty
    IF STATUS THEN 
       CALL cl_err('byterm_curs2',STATUS,1) RETURN 0
    END IF 
     
    IF l_rate1<>100 THEN 
       LET l_rate = l_rate1
    END IF  
       
    LET l_price = l_price * l_rate/100
    LET lt_price = lt_price * l_rate/100
    
    IF l_price = 0 OR cl_null(l_price) THEN 
      DECLARE price_by_term3 SCROLL CURSOR  FOR   
       SELECT poj06,poj06t,poj07,poi05,poj05   #No.TQC-940165 
        FROM poj_file,poi_file
        WHERE poj01 =poi01 AND poj02 = poi02    
          AND poj03 = p_part AND poj01 = p_term AND poj02 = p_curr 
          AND poj04 = p_unit
          AND poj05 <= p_date 
          ORDER BY poj05 DESC
      IF STATUS THEN 
         CALL cl_err('byterm_curs3',STATUS,1) RETURN 0
      END IF 
    
      OPEN price_by_term3
      FETCH FIRST price_by_term3 INTO l_price,lt_price,l_rate,lt_rate,l_poj05  #No.TQC-940165
      CLOSE  price_by_term3     #No.TQC-940165
 
       SELECT MIN(pok07) INTO l_rate1 
        FROM poi_file,pok_file
        WHERE poi01 =pok01 AND poi02 = pok02   
          AND pok03 = p_part AND pok01 = p_term AND pok02 = p_curr 
          AND pok04 = p_unit
#          AND pok05 <= p_date   #No.TQC-940165
          AND pok05 = l_poj05    #No.TQC-940165
          AND pok06 <= p_qty
      IF STATUS THEN 
         CALL cl_err('byterm2_curs4',STATUS,1) RETURN 0
      END IF 
     
      IF l_rate1 <> 100 THEN   #TQC-980045
         LET l_rate = l_rate1
      END IF  
    
      LET l_price = l_price * l_rate/100
      LET lt_price = lt_price * l_rate/100
    END IF  
    
    RETURN l_price,lt_price,lt_rate
 
END FUNCTION     
    
#No.FUN-930148 --end--
