# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_discount_amt
# Descriptions...: 折扣金額的計算
# Date & Author..: FUN-960134 09/10/27 By shiwuying

DATABASE ds

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
DEFINE g_lph06             LIKE lph_file.lph06
DEFINE g_lph36             LIKE lph_file.lph36
DEFINE g_lph30             LIKE lph_file.lph30
DEFINE g_lpk10             LIKE lpk_file.lpk10
DEFINE g_lrp02_2           LIKE lrp_file.lrp02
DEFINE g_lrp03_2           LIKE lrp_file.lrp03
DEFINE g_errnos            LIKE type_file.chr10

FUNCTION s_discount_amt(p_card_no,p_item,p_amt)
                                                    #RETURN 積分,折扣金額
 DEFINE p_type              LIKE type_file.chr1     #計算類型
 DEFINE p_card_no           LIKE lpj_file.lpj03     #會員卡號
 DEFINE p_item              LIKE ima_file.ima01     #商品編號
 DEFINE p_amt               LIKE type_file.num26_10 #交易金額
 DEFINE l_lpj01             LIKE lpj_file.lpj01
 DEFINE l_lpj02             LIKE lpj_file.lpj02
 DEFINE l_i                 LIKE type_file.num5
 DEFINE l_j                 LIKE type_file.num5
 DEFINE l_ima131            LIKE ima_file.ima131
 DEFINE l_ima1005           LIKE ima_file.ima1005

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
   LET g_item2.amt = p_amt

   SELECT lpj01,lpj02 INTO l_lpj01,l_lpj02
     FROM lpj_file
    WHERE lpj03 = p_card_no
   IF cl_null(l_lpj01) THEN  #非會員下的卡不參加積分，折扣計算
      LET g_errnos = 'alm-695'
   END IF

   SELECT lph36,lph30
     INTO g_lph36,g_lph30
     FROM lph_file
    WHERE lph01 = l_lpj02
   IF g_lph36 = 'N' THEN    #判斷卡種是否可消費折扣
      LET g_errnos = 'alm-696'
   END IF

   #折扣計算對應的規則方式和排除方式
   SELECT lrp02,lrp03 INTO g_lrp02_2,g_lrp03_2
     FROM lrp_file
    WHERE lrp01 = l_lpj02
      AND lrp00 = '2'

   #卡所對應的會員等級
   SELECT lpk10 INTO g_lpk10 FROM lpk_file
    WHERE lpk01 = l_lpj01

   IF cl_null(g_errnos) THEN
      CALL s_other(l_lpj02)  #排除明細
      IF cl_null(g_errnos) THEN
         CALL s_amt(l_lpj02)    #折扣金額計算
      END IF
   END IF

   IF NOT cl_null(g_errnos) THEN
      CALL cl_err('',g_errnos,1)
      RETURN FALSE,g_amt
   ELSE
      RETURN TRUE,g_amt
   END IF
END FUNCTION

#根據排除方式設置,如果商品編號或商品分類存在于排除方式中,則不參加折扣計算
FUNCTION s_other(p_lpj02)
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE l_cnt             LIKE type_file.num5

   IF g_lrp03_2 <> '1' AND g_lph36 = 'Y' THEN
      IF g_lrp03_2 = '2' THEN
         SELECT COUNT(*) INTO l_cnt FROM lrr_file
          WHERE lrr00 = '2'
            AND lrr01 = p_lpj02
            AND lrr02 = g_item2.ima01
         IF l_cnt > 0 THEN 
            LET g_errnos = 'alm-697'
         END IF
      END IF

      IF g_lrp03_2 = '3' THEN
         SELECT COUNT(*) INTO l_cnt FROM lrr_file
          WHERE lrr00 = '2'
            AND lrr01 = p_lpj02
            AND lrr02 = g_item2.ima131
         IF l_cnt > 0 THEN
            LET g_errnos = 'alm-697'
         END IF
      END IF
   END IF
END FUNCTION

#折扣金額計算,根據規則方式到lrq_file找對應的 折扣率,算出總的折扣金額
FUNCTION s_amt(p_lpj02)
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE l_lrq05           LIKE lrq_file.lrq05

   LET g_amt = 0
   IF g_lph36 = 'N' THEN RETURN END IF

   CASE g_lrp02_2
      WHEN '1'     #會員等級
         CALL s_lrq(g_lpk10,p_lpj02) RETURNING l_lrq05
      WHEN '2'     #產品分類
         CALL s_lrq(g_item2.ima131,p_lpj02) RETURNING l_lrq05
      WHEN '3'     #品牌
         CALL s_lrq(g_item2.ima1005,p_lpj02) RETURNING l_lrq05
      WHEN '4'     #商品
         CALL s_lrq(g_item2.ima01,p_lpj02) RETURNING l_lrq05
   END CASE
   LET g_item2.lrq05 = l_lrq05
   LET g_amt = g_amt + g_item2.amt * (1-g_item2.lrq05/100)
END FUNCTION

#查詢折扣率
#如果不存在于lrq_file中,則找卡種中的默認值
FUNCTION s_lrq(p_lrq01,p_lpj02)
 DEFINE p_lpj02           LIKE lpj_file.lpj02
 DEFINE p_lrq01           LIKE lrq_file.lrq01
 DEFINE l_lrq05           LIKE lrq_file.lrq05

   SELECT lrq05 INTO l_lrq05
     FROM lrq_file
    WHERE lrq00 = '2'
      AND lrq01 = p_lpj02
      AND lrq02 = p_lrq01
   IF STATUS = 100 THEN
      RETURN g_lph30
   ELSE
      RETURN l_lrq05
   END IF
END FUNCTION
#FUN-960134
