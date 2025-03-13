# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_discount_amt
# Descriptions...: 折扣金額的計算
# Date & Author..: FUN-960134 09/10/27 By shiwuying
# Modify.........: FUN-A30058 10/03/17 By Carrier 从ALM/4GL搬家到SUB/4GL
# Modify.........: MOD-B20078 11/02/18 By shenyang 會員卡折扣率調整
# Modify.........: FUN-BC0079 12/02/06 By yangxf 會員折扣取價調整
# Modify.........: FUN-C40094 12/05/02 By pauline 新增會員紀念日前後區間設定
# Modify.........: FUN-C40109 12/05/08 By baogc 排除明細單身添加生效日期(lrr03)和失效日期(lrr04)字段
# Modify.........: FUN-C60099 12/06/26 By pauline 卡折扣優化處理
DATABASE ds       #No.FUN-A30058

GLOBALS "../../config/top.global"

DEFINE g_item2             RECORD
          ima01            LIKE ima_file.ima01,     #商品編號
          ima131           LIKE ima_file.ima131,    #商品分類
          ima1005          LIKE ima_file.ima1005,   #商品對應品牌
          amt              LIKE type_file.num26_10, #交易金額
          lrq05            LIKE lrq_file.lrq05      #折扣率
                           END RECORD
DEFINE g_sql               STRING
DEFINE g_point             LIKE lrq_file.lrq04
DEFINE g_amt               LIKE type_file.num26_10
DEFINE g_lrq05             LIKE lrq_file.lrq05       #MOD-B20078
DEFINE g_lph06             LIKE lph_file.lph06
DEFINE g_lph36             LIKE lph_file.lph36
DEFINE g_lph30             LIKE lph_file.lph30
DEFINE g_lpk10             LIKE lpk_file.lpk10
DEFINE g_lrp02_2           LIKE lrp_file.lrp02
DEFINE g_lrp03_2           LIKE lrp_file.lrp03
DEFINE g_errnos            LIKE type_file.chr10
DEFINE g_lrp06             LIKE lrp_file.lrp06        #FUN-C60099 add  #制定營運中心
DEFINE g_lrp07             LIKE lrp_file.lrp07        #FUN-C60099 add  #規則單號
DEFINE g_lrp11             LIKE lrp_file.lrp11        #FUN-C60099 add  #折扣方式

#FUN-C40109 Mark Begin ---
#折價中使用s_discount_amt1,該函數已不使用,避免造成混亂故Mark
#FUNCTION s_discount_amt(p_card_no,p_item,p_amt)
#                                                    #RETURN 積分,折扣金額
# DEFINE p_type              LIKE type_file.chr1     #計算類型
# DEFINE p_card_no           LIKE lpj_file.lpj03     #會員卡號
# DEFINE p_item              LIKE ima_file.ima01     #商品編號
# DEFINE p_amt               LIKE type_file.num26_10 #交易金額
# DEFINE l_lpj01             LIKE lpj_file.lpj01
# DEFINE l_lpj02             LIKE lpj_file.lpj02
# DEFINE l_i                 LIKE type_file.num5
# DEFINE l_j                 LIKE type_file.num5
# DEFINE l_ima131            LIKE ima_file.ima131
# DEFINE l_ima1005           LIKE ima_file.ima1005
# DEFINE l_lpkacti           LIKE lpk_file.lpkacti   #FUN-BC0079 add 
#   LET g_errnos = ''
#
#   #將商品編號,商品分類,品牌,交易金額放到g_itm2中
#   #g_item2用於折扣計算
#   #g_item2只有參加折扣的商品
#   SELECT ima131,ima1005 INTO l_ima131,l_ima1005
#     FROM ima_file
#    WHERE ima01 = p_item
#   LET g_item2.ima01 = p_item
#   LET g_item2.ima131 = l_ima131
#   LET g_item2.ima1005 = l_ima1005
#   LET g_item2.amt = p_amt
#
#   SELECT lpj01,lpj02 INTO l_lpj01,l_lpj02
#     FROM lpj_file
#    WHERE lpj03 = p_card_no
#   IF cl_null(l_lpj01) THEN  #非會員下的卡不參加積分，折扣計算
#      LET g_errnos = 'alm-695'
#   #FUN-BC0079 add begin ---
#   ELSE 
#      SELECT lpkacti INTO l_lpkacti
#        FROM lpk_file 
#       WHERE lpk01 = l_lpj01
#      IF l_lpkacti = 'N' THEN
#         LET g_errnos = 'alm-631'
#      END IF 
#   #FUN-BC0079 add end -----
#   END IF
#
#   SELECT lph36,lph30
#     INTO g_lph36,g_lph30
#     FROM lph_file
#    WHERE lph01 = l_lpj02
#   IF g_lph36 = 'N' THEN    #判斷卡種是否可消費折扣
#      LET g_errnos = 'alm-696'
#   END IF
#
#   #折扣計算對應的規則方式和排除方式
#   SELECT lrp02,lrp03 INTO g_lrp02_2,g_lrp03_2
#     FROM lrp_file
#    WHERE lrp01 = l_lpj02
#      AND lrp00 = '2'
#
#   #卡所對應的會員等級
#   SELECT lpk10 INTO g_lpk10 FROM lpk_file
#    WHERE lpk01 = l_lpj01
#
#   IF cl_null(g_errnos) THEN
#      CALL s_other(l_lpj02)  #排除明細
#      IF cl_null(g_errnos) THEN
#         CALL s_amt(l_lpj02)    #折扣金額計算
#      END IF
#   END IF
#
#   IF NOT cl_null(g_errnos) THEN
#      CALL cl_err('',g_errnos,1)
#      RETURN FALSE,g_amt
#   ELSE
#      RETURN TRUE,g_amt
#   END IF
#END FUNCTION
#FUN-C40109 Mark End -----

#MOD-B20078---add--begin
FUNCTION s_discount_amt1(p_card_no,p_item,p_date)   #FUN-BC0079  add p_date
                                                    #RETURN 積分,折扣金額
 DEFINE p_type              LIKE type_file.chr1     #計算類型
 DEFINE p_card_no           LIKE lpj_file.lpj03     #會員卡號
 DEFINE p_item              LIKE ima_file.ima01     #商品編號
 DEFINE l_lpj01             LIKE lpj_file.lpj01
 DEFINE l_lpj02             LIKE lpj_file.lpj02
 DEFINE l_i                 LIKE type_file.num5
 DEFINE l_j                 LIKE type_file.num5
 DEFINE l_ima131            LIKE ima_file.ima131
 DEFINE l_ima1005           LIKE ima_file.ima1005
 DEFINE l_lpkacti           LIKE lpk_file.lpkacti   #FUN-BC0079  add
 DEFINE p_date              LIKE type_file.dat      #FUN-BC0079  add
   LET g_errnos = ''

   #將商品編號,商品分類,品牌,交易金額放到g_itm2中
   #g_item2用於折扣計算
   #g_item2只有參加折扣的商品
   SELECT ima131,ima1005 INTO l_ima131,l_ima1005
     FROM ima_file
    WHERE ima01 = p_item
   LET g_item2.ima01 = p_item
   LET g_item2.ima131 = l_ima131
   LET g_item2.ima1005 = l_ima1005

   SELECT lpj01,lpj02 INTO l_lpj01,l_lpj02
     FROM lpj_file
    WHERE lpj03 = p_card_no
   IF cl_null(l_lpj01) THEN  #非會員下的卡不參加積分，折扣計算
      LET g_errnos = 'alm-695'
   #FUN-BC0079 add begin ---
   ELSE 
      SELECT lpkacti INTO l_lpkacti
        FROM lpk_file
       WHERE lpk01 = l_lpj01
      IF l_lpkacti = 'N' THEN
         LET g_errnos = 'alm-631'
      END IF 
   #FUN-BC0079 add end -----
   END IF

   SELECT lph36,lph30
     INTO g_lph36,g_lph30
     FROM lph_file
    WHERE lph01 = l_lpj02
   IF g_lph36 = 'N' THEN    #判斷卡種是否可消費折扣
      LET g_errnos = 'alm-696'
   END IF

   #折扣計算對應的規則方式和排除方式
   SELECT lrp02,lrp03,lrp06,lrp07,lrp11                  #FUN-C60099 add lrp06,lrp07,lrp11
    INTO g_lrp02_2,g_lrp03_2,g_lrp06,g_lrp07,g_lrp11     #FUN-C60099 add lrp06,lrp07,lrp11
     FROM lrp_file
    WHERE lrp01 = l_lpj02
      AND lrp00 = '2'
      AND lrp04 <= p_date       #FUN-BC0079 add
      AND lrp05 >= p_date       #FUN-BC0079 add
      AND lrpacti = 'Y'         #FUN-C60099 add
      AND lrpconf = 'Y'         #FUN-C60099 add
      AND lrp09 = 'Y'           #FUN-C60099 add
      AND lrpplant = g_plant    #FUN-C60099 add 

  #FUN-C60099 add START
  #未有設定時直接return 回傳卡種的預設折扣率
   IF cl_null(g_lrp07) THEN
      IF cl_null(g_lph30) THEN 
         LET g_lph30 = 100
      END IF
      RETURN g_lph30 
   END IF 
  #FUN-C60099 add END

   #卡所對應的會員等級
   SELECT lpk10 INTO g_lpk10 FROM lpk_file
    WHERE lpk01 = l_lpj01

   IF cl_null(g_errnos) THEN
     #CALL s_other(l_lpj02)  #排除明細         #FUN-C40109 Mark
      CALL s_other(l_lpj02,p_date)  #排除明細  #FUN-C40109 Add
      IF cl_null(g_errnos) THEN
        #CALL s_amt(l_lpj02)    #折扣金額計算        #FUN-C40109 Mark
         CALL s_amt(l_lpj02,p_date,l_lpj01)    #折扣金額計算 #FUN-C40109 Add  #FUN-C60099 add lpj01
      END IF
     #FUN-C60099 mark START
     #必須先符合於lrq_file才可享有進階的折扣設定
     ##FUN-BC0079 add begin ---
     #IF cl_null(g_errnos) THEN
     #   CALL s_member_date_discount(l_lpj02,p_date,l_lpj01)    #折扣金額計算
     #END IF
     ##FUN-BC0079 add end   ---
     #FUN-C60099 mark END
   END IF
   IF cl_null(g_lrq05) THEN LET g_lrq05 = 100 END IF #MOD-B20078 Add By shi
   IF NOT cl_null(g_errnos) THEN
      LET  g_lrq05 = 100
      RETURN g_lrq05
   ELSE
      RETURN g_lrq05
   END IF
END FUNCTION
#MOD-B20078---add--end

#根據排除方式設置,如果商品編號或商品分類存在于排除方式中,則不參加折扣計算
#FUNCTION s_other(p_lpj02)        #FUN-C40109 Mark
FUNCTION s_other(p_lpj02,p_date)  #FUN-C40109 Add
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE l_cnt             LIKE type_file.num5
 DEFINE p_date            LIKE type_file.dat  #FUN-C40109 Add

   IF g_lrp03_2 <> '1' AND g_lph36 = 'Y' THEN
      IF g_lrp03_2 = '2' THEN       #依產品排除
         SELECT COUNT(*) INTO l_cnt FROM lrr_file
          WHERE lrr00 = '2'
            AND lrr01 = p_lpj02
            AND lrr02 = g_item2.ima01
            AND lrr03 <= p_date       #FUN-C40109 Add
            AND lrr04 >= p_date       #FUN-C40109 Add
            AND lrracti = 'Y'         #FUN-C40109 Add
            AND lrr05 = g_lrp06       #FUN-C60099 add
            AND lrr06 = g_lrp07       #FUN-C60099 add 
            AND lrrplant = g_plant    #FUN-C60099 add
         IF l_cnt > 0 THEN 
            LET g_errnos = 'alm-697'
         END IF
      END IF

      IF g_lrp03_2 = '3' THEN       #依分類排除
         SELECT COUNT(*) INTO l_cnt FROM lrr_file
          WHERE lrr00 = '2'
            AND lrr01 = p_lpj02
            AND lrr02 = g_item2.ima131
            AND lrr03 <= p_date       #FUN-C40109 Add
            AND lrr04 >= p_date       #FUN-C40109 Add
            AND lrracti = 'Y'         #FUN-C40109 Add
            AND lrr05 = g_lrp06       #FUN-C60099 add
            AND lrr06 = g_lrp07       #FUN-C60099 add
            AND lrrplant = g_plant    #FUN-C60099 add
         IF l_cnt > 0 THEN
            LET g_errnos = 'alm-697'
         END IF
      END IF
   END IF
END FUNCTION

#折扣金額計算,根據規則方式到lrq_file找對應的 折扣率,算出總的折扣金額
#FUNCTION s_amt(p_lpj02)         #FUN-C40109 Mark
FUNCTION s_amt(p_lpj02,p_date,p_lpj01)   #FUN-C40109 Add   #FUN-C60099 add lpj01
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE l_lrq05           LIKE lrq_file.lrq05
 DEFINE p_lpj01           LIKE lpj_file.lpj01 #FUN-C60099 add  
 DEFINE p_date            LIKE type_file.dat  #FUN-C40109 Add

   LET g_amt = 0
   IF g_lph36 = 'N' THEN RETURN END IF

   CASE g_lrp02_2
      WHEN '1'     #會員等級
        #CALL s_lrq(g_lpk10,p_lpj02) RETURNING l_lrq05        #FUN-C40109 Mark
         CALL s_lrq(g_lpk10,p_lpj02,p_date,p_lpj01) RETURNING l_lrq05 #FUN-C40109 Add            #FUN-C60099 add lpj01
      WHEN '2'     #產品分類
        #CALL s_lrq(g_item2.ima131,p_lpj02) RETURNING l_lrq05        #FUN-C40109 Mark
         CALL s_lrq(g_item2.ima131,p_lpj02,p_date,p_lpj01) RETURNING l_lrq05 #FUN-C40109 Add     #FUN-C60099 add lpj01
      WHEN '3'     #品牌
        #CALL s_lrq(g_item2.ima1005,p_lpj02) RETURNING l_lrq05        #FUN-C40109 Mark
         CALL s_lrq(g_item2.ima1005,p_lpj02,p_date,p_lpj01) RETURNING l_lrq05 #FUN-C40109 Add    #FUN-C60099 add lpj01
      WHEN '4'     #商品
        #CALL s_lrq(g_item2.ima01,p_lpj02) RETURNING l_lrq05        #FUN-C40109 Mark
         CALL s_lrq(g_item2.ima01,p_lpj02,p_date,p_lpj01) RETURNING l_lrq05 #FUN-C40109 Add      #FUN-C60099 add lpj01 
      OTHERWISE LET l_lrq05 = g_lph30 #MOD-B20078 Add By shi
   END CASE
   LET g_item2.lrq05 = l_lrq05
   LET g_amt = g_amt + g_item2.amt * (1-g_item2.lrq05/100)
   LET l_lrq05 = l_lrq05 * 100   #FUN-C60099 add  #因為計算折扣時都是以比率計算,所以這邊要乘100 RETURN 回去的值才不會有問題
   LET g_lrq05 = l_lrq05               #MOD-B20078 
END FUNCTION

#查詢折扣率
#如果不存在于lrq_file中,則找卡種中的默認值
#FUNCTION s_lrq(p_lrq01,p_lpj02)        #FUN-C40109 Mark
FUNCTION s_lrq(p_lrq01,p_lpj02,p_date,p_lpj01)  #FUN-C40109 Add  #FUN-C60099 add lpj01
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE p_lrq01           LIKE lrq_file.lrq01
 DEFINE p_lpj01           LIKE lpj_file.lpj01 #FUN-C60099 add
 DEFINE l_lrq05           LIKE lrq_file.lrq05
 DEFINE p_date            LIKE type_file.dat  #FUN-C40109 Add
 DEFINE l_lth10           LIKE lth_file.lth10  #FUN-C60099 add

   SELECT lrq05 INTO l_lrq05
     FROM lrq_file
    WHERE lrq00 = '2'
      AND lrq01 = p_lpj02
      AND lrq02 = p_lrq01
     #AND lrq10 <= p_date #FUN-C40109 Add  #FUN-C60099 mark
     #AND lrq11 >= p_date #FUN-C40109 Add  #FUN-C60099 mark
      AND lrqacti = 'Y'   #FUN-C40109 Add
      AND lrq12 = g_lrp06      #FUN-C60099 add
      AND lrq13 = g_lrp07      #FUN-C60099 add
      AND lrqplant = g_plant   #FUN-C60099 add  
   IF STATUS = 100 THEN
      RETURN g_lph30
   ELSE
     #FUN-C60099 add START
     #必須先符合於lrq_file才可享有進階的折扣設定
      IF cl_null(g_errnos) THEN
         CALL s_member_date_discount(p_lpj02,p_date,p_lpj01) RETURNING l_lth10    #折扣金額計算
      END IF
      IF g_lrp11 = '1' THEN
         IF l_lrq05/100 > l_lth10 THEN
            LET l_lrq05 = l_lth10 
         END IF 
      ELSE
         LET l_lrq05 = l_lrq05/100 * l_lth10 
      END IF
     #FUN-C60099 add END
      RETURN l_lrq05 
   END IF
END FUNCTION

#FUN-BC0079 add begin ---
FUNCTION s_member_date_discount(p_lpj02,p_date,p_lpj01)   #會員紀念日折扣金額計算
   DEFINE p_lpj02      LIKE lpj_file.lpj02
   DEFINE p_lpj01      LIKE lpj_file.lpj01
   DEFINE p_date       LIKE type_file.dat
   DEFINE l_lpa03      LIKE lpa_file.lpa03
   DEFINE l_lth05      LIKE lth_file.lth05
   DEFINE l_lth06      LIKE lth_file.lth06
   DEFINE l_lth10      LIKE lth_file.lth10
   DEFINE l_lth11      LIKE lth_file.lth11     #FUN-C40094 add #紀念日前
   DEFINE l_lth12      LIKE lth_file.lth12     #FUN-C40094 add #紀念日後
   DEFINE l_date1      LIKE type_file.dat      #FUN-C40094 add #折扣開始日期 
   DEFINE l_date2      LIKE type_file.dat      #FUN-C40094 add #折扣結束日期
   DEFINE l_lth15      LIKE lth_file.lth15     #FUN-C60099 add #時段開始日期
   DEFINE l_lth16      LIKE lth_file.lth16     #FUN-C60099 add #時段結束日期
   DEFINE l_lth17      LIKE lth_file.lth17     #FUN-C60099 add #每日時段開始時間
   DEFINE l_lth18      LIKE lth_file.lth18     #FUN-C60099 add #每日時段結束時間
   DEFINE l_lth19      LIKE lth_file.lth19     #FUN-C60099 add #固定日期
   DEFINE l_lth20      LIKE lth_file.lth20     #FUN-C60099 add #固定星期
   DEFINE l_time       LIKE type_file.chr8     #FUN-C60099 add #現在時間
   DEFINE l_lth10_1    LIKE lth_file.lth10     #FUN-C60099 add 
   DEFINE l_lpc05      LIKE lpc_file.lpc05     #FUN-C60099 add   #會員紀念日否
 
   LET l_lth10_1 = 1
   LET l_time = TIME   #FUN-C60099 add
  #IF g_amt = 0 THEN RETURN END IF     #如會員促銷方式已無成立，則不再往下抓取紀念日促銷  #FUN-C60099 mark
   IF g_lph36 = 'N' THEN RETURN END IF
   #抓取會員紀念日的折扣設定
   LET g_sql = "SELECT lth05,lth06,lth10,lth11,lth12, ", #紀念日代碼，折扣條件，折扣率  #FUN-C40094 add lth11,lth12 
               "       lth15,lth16,lth17,lth18,lth19,lth20 ",      #FUN-C60099 add
               "  FROM lth_file",
               " WHERE lth01 = '2'",    #折扣
               "   AND lth02 = '",p_lpj02,"'",
              #"   AND lth03<= '",p_date,"'",           #FUN-C60099 mark
              #"   AND lth04>= '",p_date,"'",           #FUN-C60099 mark
               "   AND lth13 = '",g_lrp06,"' ",         #FUN-C60099 add
               "   AND lth14 = '",g_lrp07,"' ",         #FUN-C60099 add
               "   AND lthplant = '",g_plant,"' ",      #FUN-C60099 add
               "   AND lthacti = 'Y' "  #FUN-C40109 Add
   PREPARE sel_lth_pre FROM g_sql
   DECLARE sel_lth_cs CURSOR FOR sel_lth_pre 
   FOREACH sel_lth_cs INTO l_lth05,l_lth06,l_lth10,l_lth11, l_lth12,   #紀念日代碼，折扣條件，折扣率  #FUN-C40094 add lth11, lth12
                           l_lth15,l_lth16,l_lth17,l_lth18,l_lth19,l_lth20   #FUN-C60099 add
      #FUN-C60099 add START
       SELECT lpc05 INTO l_lpc05 FROM lpc_file 
        WHERE lpc01 = l_lth05 AND lpcacti = 'Y'
          AND lpc00 = '8'
       IF l_lpc05 = 'Y' THEN  #如果是會員紀念日,依照舊邏輯
      #FUN-C60099 add END
      #依紀念日代碼，抓取會員紀念日日期
          SELECT lpa03 INTO l_lpa03 
            FROM lpa_file
           WHERE lpa01 = p_lpj01
             AND lpa02 = l_lth05
             AND lpaacti = 'Y'
          IF SQLCA.SQLCODE = 100 THEN 
             CONTINUE FOREACH  
          END IF
      #FUN-C60099 add START
       END IF
      #不是會員紀念日則取當日日期
       IF l_lpc05 = 'N' THEN 
          LET l_lpa03 = p_date 
       END IF
      #FUN-C60099 add END
       CASE l_lth06	
          WHEN "1"  #同一天 	
                IF l_lpa03 = p_date THEN	
	           IF MONTH(l_lpa03) = MONTH(p_date) AND DAY(l_lpa03) = DAY(p_date) THEN
                     #LET g_lrq05 = g_lrq05 * l_lth10 / 100     #FUN-C60099 mark 
                     #FUN-C60099 add START
                      IF g_lrp11 = '1' THEN
                         IF l_lth10_1 > (l_lth10/100) THEN
                            LET l_lth10_1 = l_lth10/100
                         END IF
                      ELSE
                         LET l_lth10_1 = l_lth10_1 * (l_lth10/100) 
                      END IF
                     #FUN-C60099 add END
                   END IF
                END IF 	
          WHEN "2"  #同一個月	
                IF MONTH(l_lpa03) = MONTH(p_date) THEN
                    #LET g_lrq05 = g_lrq05 * l_lth10 / 100      #FUN-C60099 mark
                    #FUN-C60099 add START
                     IF g_lrp11 = '1' THEN
                        IF l_lth10_1 > (l_lth10/100) THEN
                           LET l_lth10_1 = l_lth10/100
                        END IF
                     ELSE
                        LET l_lth10_1 = l_lth10_1 * (l_lth10/100)
                     END IF
                    #FUN-C60099 add END
                END IF   
         #FUN-C40094 add START
          WHEN "3"  #會員日季念日前後
                LET l_date1 = MDY(MONTH(l_lpa03),DAY(l_lpa03),YEAR(p_date)) - l_lth11 
                LET l_date2 = MDY(MONTH(l_lpa03),DAY(l_lpa03),YEAR(p_date)) + l_lth12   
                IF p_date = l_date1 OR p_date = l_date2 
                   OR ( p_date > l_date1 AND p_date < l_date2 ) THEN
                  #LET g_lrq05 = g_lrq05 * l_lth10 / 100        #FUN-C60099 mark
                  #FUN-C60099 add START
                   IF g_lrp11 = '1' THEN
                      IF l_lth10_1 > (l_lth10/100) THEN
                         LET l_lth10_1 = l_lth10/100
                      END IF
                   ELSE
                      LET l_lth10_1 = l_lth10_1 * (l_lth10/100)
                   END IF
                  #FUN-C60099 add END
                END IF  
         #FUN-C40094 add END	
         #FUN-C60099 add START
          WHEN "4"  #指定時段
                IF p_date = l_lth15 OR p_date = l_lth16          
                  OR (p_date > l_lth15 AND p_date < l_lth16) THEN
                   IF l_time = l_lth17 OR l_time = l_lth18
                    OR (l_time > l_lth17 AND l_time < l_lth18) THEN
                      IF NOT cl_null(l_lth19) THEN   #有設定固定日期
                         IF l_lth19 = DAY(p_date) THEN     #符合固定日期
                            IF NOT cl_null(l_lth20) THEN   #有設定固定星期
                               IF (l_lth20+7) MOD 7  =  WEEKDAY(p_date) THEN    #符合固定星期 
                                  IF g_lrp11 = '1' THEN   #取最低折扣率
                                     IF l_lth10_1 > (l_lth10/100) THEN
                                        LET l_lth10_1 = l_lth10/100
                                     END IF
                                  ELSE                    #折上折
                                     LET l_lth10_1 = l_lth10_1 * (l_lth10/100)
                                  END IF
                               END IF
                            ELSE   
                               IF g_lrp11 = '1' THEN
                                  IF l_lth10_1 > (l_lth10/100) THEN
                                     LET l_lth10_1 = l_lth10/100
                                  END IF
                               ELSE
                                  LET l_lth10_1 = l_lth10_1 * (l_lth10/100)
                               END IF   
                            END IF
                         END IF         
                      ELSE   #未設定 固定日期
                         IF NOT cl_null(l_lth20) THEN   #有設定固定星期
                            IF (l_lth20+7) MOD 7  =  WEEKDAY(p_date) THEN
                               IF g_lrp11 = '1' THEN
                                  IF l_lth10_1 > (l_lth10/100) THEN
                                     LET l_lth10_1 = l_lth10/100
                                  END IF
                               ELSE
                                  LET l_lth10_1 = l_lth10_1 * (l_lth10/100)
                               END IF
                            END IF
                         ELSE   #未設定固定星期
                            IF g_lrp11 = '1' THEN
                               IF l_lth10_1 > (l_lth10/100) THEN
                                  LET l_lth10_1 = l_lth10/100
                               END IF
                            ELSE
                               LET l_lth10_1 = l_lth10_1 * (l_lth10/100)
                            END IF
                         END IF
                      END IF       
                   END IF             
                END IF
         #FUN-C60099 add END
       END CASE	
   END FOREACH
   RETURN l_lth10_1   #FUN-C60099 add
END FUNCTION 
#FUN-BC0079 add end -----
#FUN-960134
