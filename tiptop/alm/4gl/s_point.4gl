# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: s_point
# Descriptions...: 會員卡積分計算
# Date & Author..: FUN-960134 09/10/27 By shiwuying
# Modify.........: No:TQC-B10186 11/01/19 By shiwuying 传参修改
# Modify.........: No:MOD-B10164 11/01/25 By shiwuying Bug修改
# Modify.........: No:FUN-C30192 12/03/15 By yangxf 計算給予積分時, 沒有計算到會員紀念日的積分優惠.
# Modify.........: No:MOD-C30216 12/03/16 By yangxf 过单
# Modify.........: No.FUN-C40094 12/05/02 By pauline 新增會員紀念日前後區間設定
# Modify.........: No.FUN-C40109 12/05/08 By baogc 排除明細單身添加生效日期(lrr03)和失效日期(lrr04)字段
# Modify.........: No.FUN-C60099 12/06/26 By pauline 卡折扣優化處理
# Modify.........: No.FUN-C80005 12/08/01 By pauline 積分點數計算改為無條件捨去法
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_item1             DYNAMIC ARRAY OF RECORD
          ima01            LIKE ima_file.ima01,     #商品編號
          ima131           LIKE ima_file.ima131,    #商品分類
          ima1005          LIKE ima_file.ima1005,   #商品對應品牌
          amt              LIKE type_file.num26_10, #交易金額
          lrq03            LIKE lrq_file.lrq03,     #積分基準
          lrq04            LIKE lrq_file.lrq04      #單位積分
                           END RECORD
DEFINE g_sql               STRING
DEFINE g_point             LIKE lrq_file.lrq04
DEFINE g_amt               LIKE type_file.num26_10
DEFINE g_lph06             LIKE lph_file.lph06
DEFINE g_lph28             LIKE lph_file.lph28
DEFINE g_lph29             LIKE lph_file.lph29
DEFINE g_lpk10             LIKE lpk_file.lpk10
DEFINE g_lrp02_1           LIKE lrp_file.lrp02
DEFINE g_lrp03_1           LIKE lrp_file.lrp03
DEFINE g_errnos            LIKE type_file.chr10
DEFINE g_lrp06             LIKE lrp_file.lrp06        #FUN-C60099 add  #制定營運中心
DEFINE g_lrp07             LIKE lrp_file.lrp07        #FUN-C60099 add  #規則單號

FUNCTION s_point(p_card_no,p_item,p_date)           #FUN-C30192 add p_date
                                                    #RETURN 積分
 DEFINE p_card_no           LIKE lpj_file.lpj03     #會員卡號
 DEFINE p_item              DYNAMIC ARRAY OF RECORD
          #TQC-B10186 Begin---
          #itm2             LIKE ima_file.ima01,    #商品編號
          #itm3             LIKE type_file.num26_10 #交易金額
           ogb04            LIKE ima_file.ima01,    #商品編號
           ogb14t           LIKE ogb_file.ogb14t    #交易金額
          #TQC-B10186 End-----
                            END RECORD
 DEFINE l_lpj01             LIKE lpj_file.lpj01
 DEFINE l_lpj02             LIKE lpj_file.lpj02
 DEFINE l_i                 LIKE type_file.num5
 DEFINE l_j                 LIKE type_file.num5
 DEFINE l_ima131            LIKE ima_file.ima131
 DEFINE l_ima1005           LIKE ima_file.ima1005
 DEFINE p_date              LIKE type_file.dat      #FUN-C30192 add

   LET g_errnos = ''
   CALL g_item1.clear()                             #FUN-C30192 add  #MOD-C30216 
   #將商品編號,商品分類,品牌,交易金額放到g_item1中
   #g_item1用於積分計算
   #g_item1只有參加積分的商品
   FOR l_i = 1 TO p_item.getLength()#LENGTH(p_item)
      SELECT ima131,ima1005 INTO l_ima131,l_ima1005
        FROM ima_file
     #TQC-B10186 Begin---
     # WHERE ima01 = p_item[l_i].itm2
     #LET g_item1[l_i].ima01 = p_item[l_i].itm2
     #LET g_item1[l_i].ima131 = l_ima131
     #LET g_item1[l_i].ima1005 = l_ima1005
     #LET g_item1[l_i].amt = p_item[l_i].itm3
       WHERE ima01 = p_item[l_i].ogb04
      LET g_item1[l_i].ima01 = p_item[l_i].ogb04
      LET g_item1[l_i].ima131 = l_ima131
      LET g_item1[l_i].ima1005 = l_ima1005
      LET g_item1[l_i].amt = p_item[l_i].ogb14t
     #TQC-B10186 End-----
   END FOR

   SELECT lpj01,lpj02 INTO l_lpj01,l_lpj02
     FROM lpj_file
    WHERE lpj03 = p_card_no
   IF cl_null(l_lpj01) THEN  #非會員下的卡不參加積分，折扣計算
      LET g_errnos = 'alm-695'
   END IF

   SELECT lph06,lph28,lph29
     INTO g_lph06,g_lph28,g_lph29
     FROM lph_file
    WHERE lph01 = l_lpj02

   IF g_lph06 = 'N' THEN    #判斷卡種是否可積分
      LET g_errnos = 'alm-628'
   END IF

   #積分計算對應的規則方式和排除方式
   SELECT lrp02,lrp03,lrp06,lrp07                   #FUN-C60099 add lrp06,lrp07,lrp11
     INTO g_lrp02_1,g_lrp03_1,g_lrp06,g_lrp07       #FUN-C60099 add lrp06,lrp07,lrp11
     FROM lrp_file
    WHERE lrp01 = l_lpj02
      AND lrp00 = '1'
      AND lrp04 <= p_date       #FUN-C30192 add
      AND lrp05 >= p_date       #FUN-C30192 add
      AND lrpacti = 'Y'         #FUN-C60099 add
      AND lrpconf = 'Y'         #FUN-C60099 add
      AND lrp09 = 'Y'           #FUN-C60099 add
      AND lrpplant = g_plant    #FUN-C60099 add

   #卡所對應的會員等級
   SELECT lpk10 INTO g_lpk10 FROM lpk_file
    WHERE lpk01 = l_lpj01

   IF cl_null(g_errnos) THEN
     #CALL s_other1(l_lpj02)  #排除明細         #FUN-C40109 Mark
      CALL s_other1(l_lpj02,p_date)  #排除明細  #FUN-C40109 Add
      CALL s_point1(l_lpj01,l_lpj02,p_date)  #積分計算      #FUN-C30192 add  l_lpj01,p_date
   END IF

   IF NOT cl_null(g_errnos) THEN
      CALL cl_err('',g_errnos,1)
      RETURN FALSE,g_point
   ELSE
      RETURN TRUE,g_point
   END IF
END FUNCTION

#根據排除方式設置,如果商品編號或商品分類存在于排除方式中,則不參加積分折扣計算
#刪除g_item1中對應的那筆數據,剩下的都是參加積分折扣計算的商品
#FUNCTION s_other1(p_lpj02)        #FUN-C40109 Mark
FUNCTION s_other1(p_lpj02,p_date)  #FUN-C40109 Add
 DEFINE l_length          LIKE type_file.num5
 DEFINE l_length1         LIKE type_file.num5
 DEFINE l_i               LIKE type_file.num5
 DEFINE l_cnt             LIKE type_file.num5
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE p_date            LIKE type_file.dat  #FUN-C40109 Add

   LET l_length = g_item1.getLength()
   LET l_length1 = l_length
   IF g_lrp03_1 <> '1' AND g_lph06 = 'Y' THEN
      FOR l_i = 1 TO l_length
         IF l_i > l_length1 THEN EXIT FOR END IF

         IF g_lrp03_1 = '2' THEN    #依產品排除
            SELECT COUNT(*) INTO l_cnt FROM lrr_file
             WHERE lrr00 = '1'
               AND lrr01 = p_lpj02
               AND lrr02 = g_item1[l_i].ima01
               AND lrr03 <= p_date       #FUN-C40109 Add
               AND lrr04 >= p_date       #FUN-C40109 Add
               AND lrracti = 'Y'         #FUN-C40109 Add
               AND lrr05 = g_lrp06       #FUN-C60099 add
               AND lrr06 = g_lrp07       #FUN-C60099 add
               AND lrrplant = g_plant    #FUN-C60099 add
            IF l_cnt > 0 THEN
               CALL g_item1.deleteElement(l_i)
               LET l_length1 = l_length1 - 1
            END IF
         END IF
   
         IF g_lrp03_1 = '3' THEN    #依分類排除
            SELECT COUNT(*) INTO l_cnt FROM lrr_file
             WHERE lrr00 = '1'
               AND lrr01 = p_lpj02
               AND lrr02 = g_item1[l_i].ima131
               AND lrr03 <= p_date       #FUN-C40109 Add
               AND lrr04 >= p_date       #FUN-C40109 Add
               AND lrracti = 'Y'         #FUN-C40109 Add
               AND lrr05 = g_lrp06       #FUN-C60099 add
               AND lrr06 = g_lrp07       #FUN-C60099 add
               AND lrrplant = g_plant    #FUN-C60099 add
            IF l_cnt > 0 THEN 
               CALL g_item1.deleteElement(l_i)
               LET l_length1 = l_length1 - 1
            END IF
         END IF
      END FOR
   END IF
END FUNCTION

#積分計算，根據規則方式到相應的lrq_file中找對應的 積分基準和單位積分,
#然後算出總的積分
FUNCTION s_point1(p_lpj01,p_lpj02,p_date)        #FUN-C30192 add p_lpj01,p_date
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE l_i               LIKE type_file.num5
 DEFINE l_lrq03           LIKE lrq_file.lrq03
 DEFINE l_lrq04           LIKE lrq_file.lrq04
 DEFINE l_lrq05           LIKE lrq_file.lrq05
 DEFINE l_point           LIKE lrq_file.lrq04    #FUN-C30192 add
 DEFINE p_lpj01           LIKE lpj_file.lpj01    #FUN-C30192 add
 DEFINE l_lth06           LIKE lth_file.lth06    #FUN-C30192 add
 DEFINE l_lth07           LIKE lth_file.lth07    #FUN-C30192 add
 DEFINE l_lth08           LIKE lth_file.lth08    #FUN-C30192 add
 DEFINE l_lth09           LIKE lth_file.lth09    #FUN-C30192 add
 DEFINE l_lpa02           LIKE lpa_file.lpa02    #FUN-C30192 add
 DEFINE l_lpa03           LIKE lpa_file.lpa03    #FUN-C30192 add
 DEFINE p_oga02           LIKE oga_file.oga02    #FUN-C30192 add
 DEFINE p_date            LIKE type_file.dat     #FUN-C30192 add
 DEFINE l_lth11           LIKE lth_file.lth11    #FUN-C40094 add #紀念日前
 DEFINE l_lth12           LIKE lth_file.lth12    #FUN-C40094 add #紀念日後
 DEFINE l_date1           LIKE type_file.dat     #FUN-C40094 add #折扣開始日期
 DEFINE l_date2           LIKE type_file.dat     #FUN-C40094 add #折扣結束日期
 DEFINE l_lth15           LIKE lth_file.lth15    #FUN-C60099 add #時段開始日期
 DEFINE l_lth05           LIKE lth_file.lth05    #FUN-C60099 add 
 DEFINE l_lth16           LIKE lth_file.lth16    #FUN-C60099 add #時段結束日期
 DEFINE l_lth17           LIKE lth_file.lth17    #FUN-C60099 add #每日時段開始時間
 DEFINE l_lth18           LIKE lth_file.lth18    #FUN-C60099 add #每日時段結束時間
 DEFINE l_lth19           LIKE lth_file.lth19    #FUN-C60099 add #固定日期
 DEFINE l_lth20           LIKE lth_file.lth20    #FUN-C60099 add #固定星期
 DEFINE l_time            LIKE type_file.chr8    #FUN-C60099 add #現在時間
 DEFINE l_lpc05           LIKE lpc_file.lpc05     #FUN-C60099 add   #會員紀念日否
 DEFINE l_point2          LIKE type_file.num20_6  #FUN-C80005 add

   LET l_time = TIME   #FUN-C60099 add                                                     
   LET g_point = 0                              
   IF g_lph06 = 'N' THEN RETURN END IF
   FOR l_i = 1 TO g_item1.getLength()
      IF cl_null(g_item1[l_i].ima01) THEN CONTINUE FOR END IF   #FUN-C60099 add
      CASE g_lrp02_1
         WHEN '1'     #會員等級
            CALL s_lrq1(p_lpj02,g_lpk10,p_date) RETURNING l_lrq03,l_lrq04               #FUN-C30192 add p_date
         WHEN '2'     #產品分類
            CALL s_lrq1(p_lpj02,g_item1[l_i].ima131,p_date) RETURNING l_lrq03,l_lrq04   #FUN-C30192 add p_date
         WHEN '3'     #品牌
            CALL s_lrq1(p_lpj02,g_item1[l_i].ima1005,p_date) RETURNING l_lrq03,l_lrq04  #FUN-C30192 add p_date
         WHEN '4'     #商品
            CALL s_lrq1(p_lpj02,g_item1[l_i].ima01,p_date) RETURNING l_lrq03,l_lrq04    #FUN-C30192 add p_date
        #MOD-B10164 Begin---
         OTHERWISE
            LET l_lrq03 = g_lph28
            LET l_lrq04 = g_lph29
        #MOD-B10164 End-----
      END CASE
      LET g_item1[l_i].lrq03 = l_lrq03
      LET g_item1[l_i].lrq04 = l_lrq04
      IF cl_null(g_item1[l_i].amt) THEN LET g_item1[l_i].amt = 0 END IF   #FUN-C60099 add
     #LET g_point = g_point + g_item1[l_i].amt * g_item1[l_i].lrq04 / g_item1[l_i].lrq03   #FUN-C80005 mark
      LET l_point2 = g_item1[l_i].amt * g_item1[l_i].lrq04 / g_item1[l_i].lrq03   #FUN-C80005 add
      LET l_point2 = s_trunc(l_point2,0)   #FUN-C80005 add
      LET g_point = g_point + l_point2  #FUN-C80005 add

   END FOR
   #FUN-C30192 add begin ---
   #計算會員紀念日優惠積分
   LET l_point = 0
  #FUN-C60099 mark START
  #LET g_sql = "SELECT lpa02,lpa03 FROM lpa_file WHERE lpa01 = '",p_lpj01,"'"
  #PREPARE lpa_pre FROM g_sql
  #DECLARE sel_lpa CURSOR FOR lpa_pre 
  #FOREACH sel_lpa INTO l_lpa02,l_lpa03
  #FUN-C60099 mark END
     #FUN-C40094 add START
      #放入變數時先將變數清空,避免錯誤
       LET l_lth06 = ''
       LET l_lth07 = ''
       LET l_lth08 = ''
       LET l_lth09 = ''
       LET l_lth11 = ''
       LET l_lth12 = ''
     #FUN-C40094 add END
     #FUN-C60099 add START
       LET l_lth05 = ''
       LET l_lth15 = NULL 
       LET l_lth16 = NULL 
       LET l_lth17 = ''
       LET l_lth18 = ''
       LET l_lth19 = ''
       LET l_lth20 = ''
     #FUN-C60099 add END
  #FUN-C60099 mark START
  #   SELECT lth06,lth07,lth08,lth09,lth11,lth12,               #FUN-C40094 add lth11,lth12
  #     INTO l_lth06,l_lth07,l_lth08,l_lth09,l_lth11,l_lth12,   #FUN-C40094 add lth11,lth12
  #     FROM lth_file 
  #    WHERE lth01 = '1'
  #      AND lth02 = p_lpj02
  #      AND lth03 <= p_date  
  #      AND lth04 >= p_date  
  #      AND lth05 = l_lpa02
  #      AND lthacti = 'Y'  #FUN-C40109 Add
  #FUN-C60099 mark END
  #FUN-C60099 add START
   #抓取會員紀念日的折扣設定
   LET g_sql = "SELECT lth05,lth06,lth07,lth08,lth09,lth11,lth12, ", 
               "       lth15,lth16,lth17,lth18,lth19,lth20 ",  
               "  FROM lth_file",
               " WHERE lth01 = '1'",    
               "   AND lth02 = '",p_lpj02,"'",
               "   AND lth13 = '",g_lrp06,"' ",         
               "   AND lth14 = '",g_lrp07,"' ",         
               "   AND lthplant = '",g_plant,"' ",      
               "   AND lthacti = 'Y' "  #FUN-C40109 Add
   PREPARE sel_lth_pre FROM g_sql
   DECLARE sel_lth_cs CURSOR FOR sel_lth_pre
   FOREACH sel_lth_cs INTO l_lth05,l_lth06,l_lth07,l_lth08,l_lth09,l_lth11,l_lth12,   
                           l_lth15,l_lth16,l_lth17,l_lth18,l_lth19,l_lth20   
       SELECT lpc05 INTO l_lpc05 FROM lpc_file
        WHERE lpc01 = l_lth05 AND lpcacti = 'Y'
          AND lpc00 = '8'
       LET l_lpa03 = NULL
       IF l_lpc05 = 'Y' THEN  #如果是會員紀念日,依照舊邏輯
      #依紀念日代碼，抓取會員紀念日日期
          SELECT lpa03 INTO l_lpa03
            FROM lpa_file
           WHERE lpa01 = p_lpj01
             AND lpa02 = l_lth05
             AND lpaacti = 'Y'
          IF SQLCA.SQLCODE = 100 THEN
             CONTINUE FOREACH
          END IF
       END IF
      #不是會員紀念日則取當日日期
       IF l_lpc05 = 'N' THEN 
          LET l_lpa03 = p_date
       END IF
  #FUN-C60099 add END
      IF l_lth06 = '1' THEN  #同一天
        #IF DAY(l_lpa03) = DAY(p_date) THEN
         IF MONTH(l_lpa03) = MONTH(p_date) AND DAY(l_lpa03) = DAY(p_date) THEN   #FUN-C60099 add
           #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09   #FUN-C80005 mark
            LET l_point2 = (g_point / l_lth07) * l_lth08     #FUN-C80005 add 
            LET l_point2 = s_trunc(l_point2,0)             #FUN-C80005 add
            LET l_point = l_point + l_point2 + l_lth09       #FUN-C80005 add
         END IF 
      END IF 
      IF l_lth06 = '2' THEN  #同一個月
         IF MONTH(l_lpa03) = MONTH(p_date) THEN
           #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09    #FUN-C80005 mark
            LET l_point2 = (g_point / l_lth07) * l_lth08    #FUN-C80005 add
            LET l_point2 = s_trunc(l_point2,0)            #FUN-C80005 add
            LET l_point = l_point + l_point2 + l_lth09    #FUN-C80005 add
         END IF
      END IF  
     #FUN-C40094 add START
      IF l_lth06 = '3' THEN  #會員日季念日前後
         LET l_date1 = MDY(MONTH(l_lpa03),DAY(l_lpa03),YEAR(p_date)) - l_lth11
         LET l_date2 = MDY(MONTH(l_lpa03),DAY(l_lpa03),YEAR(p_date)) + l_lth12
         IF p_date = l_date1 OR p_date = l_date2
            OR ( p_date > l_date1 AND p_date < l_date2 ) THEN
           #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09    #FUN-C80005 mark
            LET l_point2 = (g_point / l_lth07) * l_lth08   #FUN-C80005 add
            LET l_point2 = s_trunc(l_point2,0)           #FUN-C80005 add
            LET l_point = l_point + l_point2 + l_lth09    #FUN-C80005 add
         END IF
      END IF
     #FUN-C40094 add END
     #FUN-C60099 add START
      IF l_lth06 = '4' THEN #指定時段
         IF p_date = l_lth15 OR p_date = l_lth16
           OR (p_date > l_lth15 AND p_date < l_lth16) THEN
            IF l_time = l_lth17 OR l_time = l_lth18
             OR (l_time > l_lth17 AND l_time < l_lth18) THEN
               IF NOT cl_null(l_lth19) THEN   #有設定固定日期
                  IF l_lth19 = DAY(p_date) THEN     #符合固定日期
                     IF NOT cl_null(l_lth20) THEN   #有設定固定星期
                        IF (l_lth20+7) MOD 7  =  WEEKDAY(p_date) THEN    #符合固定星期
                          #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09     #FUN-C80005 mark
                           LET l_point2 = (g_point / l_lth07) * l_lth08   #FUN-C80005 add
                           LET l_point2 = s_trunc(l_point2,0)   #FUN-C80005 add
                           LET l_point = l_point + l_point2 + l_lth09     #FUN-C80005 add
                        END IF
                     ELSE
                       #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09    #FUN-C80005 mark
                        LET l_point2 = (g_point / l_lth07) * l_lth08    #FUN-C80005 add
                        LET l_point2 = s_trunc(l_point2,0)   #FUN-C80005 add
                        LET l_point = l_point + l_point2 + l_lth09    #FUN-C80005 add
                     END IF
                  END IF
               ELSE   #未設定固定日期
                  IF NOT cl_null(l_lth20) THEN   #有設定固定星期
                     IF (l_lth20+7) MOD 7  =  WEEKDAY(p_date) THEN
                       #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09     #FUN-C80005 mark
                        LET l_point2 = (g_point / l_lth07) * l_lth08    #FUN-C80005 add
                        LET l_point2 = s_trunc(l_point2,0)   #FUN-C80005 add  
                        LET l_point = l_point + l_point2 + l_lth09     #FUN-C80005 add
                     END IF
                  ELSE   #未設定固定星期
                    #LET l_point = l_point + (g_point / l_lth07) * l_lth08 + l_lth09    #FUN-C80005 mark
                     LET l_point2 = (g_point / l_lth07) * l_lth08   #FUN-C80005 add
                     LET l_point2 = s_trunc(l_point2,0)   #FUN-C80005 add
                     LET l_point = l_point + l_point2 + l_lth09    #FUN-C80005 add
                  END IF
               END IF
            END IF
         END IF
      END IF
     #FUN-C60099 add END
   END FOREACH
   LET g_point = g_point + l_point
   #FUN-C30192 add end -----
END FUNCTION

#查詢積分基準,單位積分
#如果不存在于lrq_file中,則找卡種中的默認值
FUNCTION s_lrq1(p_lpj02,p_lrq01,p_date)                    #FUN-C30192 add p_date
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE p_lrq01           LIKE lrq_file.lrq01
 DEFINE l_lrq03           LIKE lrq_file.lrq03
 DEFINE l_lrq04           LIKE lrq_file.lrq04
 DEFINE p_date            LIKE type_file.dat               #FUN-C30192 add 

   SELECT lrq03,lrq04 INTO l_lrq03,l_lrq04
     FROM lrq_file
    WHERE lrq00 = '1'
      AND lrq01 = p_lpj02
      AND lrq02 = p_lrq01
     #AND lrq10 <= p_date                                  #FUN-C30192 add  #FUN-C60099 mark 
     #AND lrq11 >= p_date                                  #FUN-C30192 add  #FUN-C60099 mark
      AND lrqacti = 'Y'   #FUN-C40109 Add
      AND lrq12 = g_lrp06      #FUN-C60099 add
      AND lrq13 = g_lrp07      #FUN-C60099 add
      AND lrqplant = g_plant   #FUN-C60099 add
   IF STATUS = 100 THEN
      RETURN g_lph28,g_lph29
   ELSE
      RETURN l_lrq03,l_lrq04
   END IF
END FUNCTION
#No.FUN-960134
