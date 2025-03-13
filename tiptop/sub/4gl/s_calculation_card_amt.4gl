# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_calculation_card_amt.4gl
# Descriptions...: 计算储值卡充值金额
# Date & Author..: No:FUN-CA0090 12/10/22 By shiwuying
# Usage..........: CALL s_calculation_card_amt(p_cardno,p_amt,p_plant)
# Input PARAMETER: p_cardno    #储值卡号
#                  p_amt       #需充值金额
#                  p_plant     #營運中心
# RETURN Code....: l_amt       #实际充值金额(根据储值卡充值折扣和加值规则算出)
#                  l_dis_amt   #折扣金额
#                  l_add_amt   #加值金额

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_calculation_card_amt(p_cardno,p_amt,p_date,p_plant)
 DEFINE p_cardno      LIKE lpj_file.lpj03
 DEFINE p_amt         LIKE lpj_file.lpj06
 DEFINE p_plant       LIKE azw_file.azw01
 DEFINE p_date        LIKE type_file.dat
 DEFINE l_amt         LIKE lpj_file.lpj06
 DEFINE l_dis_amt     LIKE lpj_file.lpj06
 DEFINE l_add_amt     LIKE lpj_file.lpj06
 DEFINE l_sql         STRING
 DEFINE l_lpj02       LIKE lpj_file.lpj02  #卡种编号
 DEFINE l_lpj11       LIKE lpj_file.lpj11  #储值折扣
 DEFINE l_lph05       LIKE lph_file.lph05  #儲值折扣否
 DEFINE l_lph40       LIKE lph_file.lph40  #儲值加值否
 DEFINE l_lph41       LIKE lph_file.lph41  #預設儲值金額基準
 DEFINE l_lph42       LIKE lph_file.lph42  #預設加值金額
 DEFINE l_lph43       LIKE lph_file.lph43  #每次儲值金額上限
 DEFINE l_lph44       LIKE lph_file.lph44  #儲值卡儲值總金額上限
 DEFINE l_lrp02       LIKE lrp_file.lrp02  #規則方式
 DEFINE l_lrp06       LIKE lrp_file.lrp06  #制订营运中心
 DEFINE l_lrp07       LIKE lrp_file.lrp07  #规则单号
 DEFINE l_lpk10       LIKE lpk_file.lpk10  #会员等级
 DEFINE l_lpk13       LIKE lpk_file.lpk13  #会员类型
 DEFINE l_lrq02       LIKE lrq_file.lrq02  #编号
 DEFINE l_lrq06       LIKE lrq_file.lrq06  #充值基准
 DEFINE l_lrq07       LIKE lrq_file.lrq07  #优惠加值
 DEFINE l_lrq08       LIKE lrq_file.lrq08  #优惠加值%
 DEFINE l_lrq09       LIKE lrq_file.lrq09  #整倍否
 DEFINE l_multiple    LIKE lpu_file.lpu05  #
 DEFINE l_multiple_1  LIKE type_file.num5  #
 DEFINE l_value       LIKE lpu_file.lpu05  #

   #卡种编号,储值折扣,儲值加值否,預設儲值金額基準,預設加值金額
   LET l_sql = "SELECT lpj02,lpj11,lph05,lph40,lph41,lph42",
               "  FROM ",cl_get_target_table(p_plant,"lpj_file"),",",
                         cl_get_target_table(p_plant,"lph_file"),
               " WHERE lpj02 = lph01 ",
               "   AND lpj03 = '",p_cardno,"'"
   PREPARE s_calculation_card_amt_p1 FROM l_sql
   EXECUTE s_calculation_card_amt_p1 INTO l_lpj02,l_lpj11,l_lph05,l_lph40,l_lph41,l_lph42
   #如果有设置储值加值,储值加值与储值折扣，不可以同时设置
   IF l_lph40='Y' THEN
      LET l_sql = "SELECT lrp02,lrp06,lrp07", #規則方式(1:会员等级/2:会员类型),制订营运中心,规则单号
                  "  FROM ",cl_get_target_table(p_plant,"lrp_file"),
                  " WHERE lrp00 = '3' ",
                  "   AND lrp01 = '",l_lpj02,"'",
                  "   AND '",p_date,"' BETWEEN lrp04 AND lrp05 ",
                  "   AND lrp09 = 'Y'",
                  "   AND lrpplant = '",p_plant,"'",
                  "   AND lrpacti = 'Y'"
      PREPARE s_calculation_card_amt_p2 FROM l_sql
      EXECUTE s_calculation_card_amt_p2 INTO l_lrp02,l_lrp06,l_lrp07
      #先看下有没有设置充值加值方案almi558，如果有抓方案中的设置规则，否则取卡种的规则
      IF NOT cl_null(l_lrp02) THEN
         LET l_sql = "SELECT lpk10,lpk13 ",  #会员等级,会员类型
                     "  FROM ",cl_get_target_table(p_plant,"lpk_file")," INNER JOIN ",
                               cl_get_target_table(p_plant,"lpj_file")," ON lpk01=lpj01",
                     " WHERE lpj03 = '",p_cardno,"' "
         PREPARE s_calculation_card_amt_p3 FROM l_sql
         EXECUTE s_calculation_card_amt_p3 INTO l_lpk10,l_lpk13
         IF l_lrp02 = '1' THEN
            LET l_lrq02=l_lpk10
         END IF
         IF l_lrp02 = '2' THEN
            LET l_lrq02=l_lpk13
         END IF
         #根据充值金额抓取充值基准，再根据充值基准抓对应的那笔充值规则
         #因为同一个编号lrq02有不同的基准，对应不同的规则
         LET l_sql = "SELECT MAX(lrq06) FROM ",cl_get_target_table(p_plant,"lrq_file"),
                     " WHERE lrq00 = '3'",
                     "   AND lrq01 = '",l_lpj02,"'",
                     "   AND lrq02 = '",l_lrq02,"'",
                     "   AND (lrq10 <= '",p_date,"' AND ",
                     "        lrq11  >= '",p_date,"')",
                     "   AND lrqacti = 'Y'",
                     "   AND lrq12 = '",l_lrp06,"'",
                     "   AND lrq13 = '",l_lrp07,"'",
                     "   AND lrq06 <= ",p_amt,
                     "   AND lrqplant = '",p_plant,"'"
         PREPARE s_calculation_card_amt_p4 FROM l_sql
         EXECUTE s_calculation_card_amt_p4 INTO l_lrq06
          
         #充值基准,优惠加值,优惠加值%,整倍否
         IF NOT cl_null(l_lrq06) THEN
            LET l_sql = "SELECT lrq06,lrq07,lrq08,lrq09 FROM ",cl_get_target_table(p_plant,"lrq_file"),
                        " WHERE lrq00 = '3'",
                        "   AND lrq01 = '",l_lpj02,"'",
                        "   AND lrq02 = '",l_lrq02,"'",
                        "   AND (lrq10 <= '",p_date,"' AND ",
                        "        lrq11  >= '",p_date,"')",
                        "   AND lrqacti = 'Y'",
                        "   AND lrq12 = '",l_lrp06,"'",
                        "   AND lrq13 = '",l_lrp07,"'",
                        "   AND lrq06 <= ",p_amt,
                        "   AND lrq06 = ",l_lrq06,
                        "   AND lrqplant = '",p_plant,"'"
            PREPARE s_calculation_card_amt_p5 FROM l_sql
            EXECUTE s_calculation_card_amt_p5 INTO l_lrq06,l_lrq07,l_lrq08,l_lrq09
         ELSE
            LET l_lrq06 = l_lph41
            LET l_lrq07 = l_lph42
            LET l_lrq08 = 100
            LET l_lrq09 = 'N'
         END IF
      ELSE
         #否则取卡种里面的设置
         LET l_lrq06 = l_lph41
         LET l_lrq07 = l_lph42
         LET l_lrq08 = 100
         LET l_lrq09 = 'N'
      END IF
      IF p_amt >= l_lrq06 THEN        #如果有设置加值，加值基准大于充值金额
         LET l_multiple = p_amt / l_lrq06
         IF l_lrq09 = 'Y' THEN
            LET l_multiple_1 = l_multiple
            LET l_multiple = l_multiple_1
         END IF
         LET l_value = l_multiple * l_lrq07
         LET l_add_amt = l_value * (l_lrq08 / 100) #加值金额lpu15
         LET l_amt = p_amt + l_add_amt             #实付金额lpu06 = 充值金额 + 折扣金额
         RETURN l_amt,0,l_add_amt
      ELSE
         RETURN p_amt,0,0
      END IF
   ELSE  #没有设置储值加值lph40 = 'N'
      IF l_lph05 = 'Y' AND NOT cl_null(l_lpj11) THEN
         LET l_dis_amt = p_amt * (100-l_lpj11)/100
         LET l_amt = p_amt/(l_lpj11/100)
         RETURN l_amt,l_dis_amt,0
      ELSE
         RETURN p_amt,0,0
      END IF
   END IF
   RETURN p_amt,0,0
END FUNCTION
#FUN-CA0090
