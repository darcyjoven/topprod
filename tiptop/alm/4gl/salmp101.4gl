# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: salmp101.4gl
# Descriptions...: 更新比例费用金额账单和日核算
# Date & Author..: No:FUN-C20078 12/02/14 By shiwuying
# Modify.........: No:FUN-CA0081 12/10/09 By shiwuying 比例方案增加分段区间

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE gs_sql           STRING
DEFINE g_cnt            LIKE type_file.num5

#p_type='1':almp101调用
#p_type='2':almi400合同终审时调用
#p_type='3':almp100合同终止时调用
FUNCTION p101_upd_ratio_bill(p_liw01,p_date,p_wc,p_plant,p_type)
 DEFINE p_liw01            LIKE liw_file.liw01
 DEFINE l_liw01            LIKE liw_file.liw01
 DEFINE l_liw03            LIKE liw_file.liw03
 DEFINE p_date             LIKE type_file.dat
 DEFINE p_wc               STRING
 DEFINE p_plant            LIKE liw_file.liwplant
 DEFINE p_type             LIKE type_file.chr1

   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF
   IF cl_null(p_date) OR cl_null(p_type) THEN
      RETURN
   END IF
   IF cl_null(p_wc) THEN LET p_wc = ' 1=1' END IF
   LET gs_sql = "SELECT DISTINCT liw01,liw03 ",
                "  FROM ",cl_get_target_table(p_plant,'liw_file'),",",
                          cl_get_target_table(p_plant,'lnt_file'),",",
                          cl_get_target_table(p_plant,'liv_file'),",",
                          cl_get_target_table(p_plant,'lil_file'),
                " WHERE liw01 = lnt01 ",
                "   AND liw01 = liv01 ",
                "   AND liw02 = liv02 ",
                "   AND liw04 = liv05 ",
                "   AND liv04 BETWEEN liw07 AND liw08 ",
                "   AND liv07 = lil01 ",
                "   AND lil11 = '5' ",
                "   AND lnt26 = 'Y'",
                "   AND ",p_wc CLIPPED,
                "   AND liw16 IS NULL ",
                "   AND liw17 = 'N' "
   IF p_type = '1' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND liw08 = '",p_date-1,"' "
   END IF
   IF p_type = '2' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND liw08 <  '",p_date,"' "
   END IF
   IF p_type = '3' THEN
     #LET gs_sql = gs_sql CLIPPED,"   AND (liw08 <  '",p_date,"' OR ('",p_date,"' BETWEEN liw07 AND liw08))",
     #                            "   AND liw09 = 0 "
      LET gs_sql = gs_sql CLIPPED,"   AND ('",p_date,"' BETWEEN liw07 AND liw08)"
   END IF
   IF NOT cl_null(p_liw01) THEN
      LET gs_sql = gs_sql CLIPPED,"   AND liw01 = '",p_liw01,"' "
   END IF
  #LET gs_sql = gs_sql CLIPPED," ORDER BY liw01,liw03"
   LET gs_sql = gs_sql CLIPPED,
                " UNION ",
                "SELECT DISTINCT liw01,liw03 ",
                "  FROM ",cl_get_target_table(p_plant,'liw_file'),",",
                          cl_get_target_table(p_plant,'lnt_file'),",",
                          cl_get_target_table(p_plant,'liv_file'),",",
                          cl_get_target_table(p_plant,'lip_file'),
                " WHERE liw01 = lnt01 ",
                "   AND liw01 = liv01 ",
                "   AND liw02 = liv02 ",
                "   AND liw04 = liv05 ",
                "   AND liv04 BETWEEN liw07 AND liw08 ",
                "   AND liv07 = lip01 ",
                "   AND lip13 = '5' ",
                "   AND lnt26 = 'Y'",
                "   AND ",p_wc CLIPPED,
                "   AND liw16 IS NULL ",
                "   AND liw17 = 'N' "
   IF p_type = '1' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND liw08 = '",p_date-1,"' "
   END IF
   IF p_type = '2' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND liw08 < '",p_date,"' "
   END IF
   IF p_type = '3' THEN
     #LET gs_sql = gs_sql CLIPPED,"   AND (liw08 <  '",p_date,"' OR ('",p_date,"' BETWEEN liw07 AND liw08))",
     #                            "   AND liw09 = 0 "
      LET gs_sql = gs_sql CLIPPED,"   AND ('",p_date,"' BETWEEN liw07 AND liw08)"
   END IF
   IF NOT cl_null(p_liw01) THEN
      LET gs_sql = gs_sql CLIPPED,"   AND liw01 = '",p_liw01,"' "
   END IF
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE p100_upd_bill_p0 FROM gs_sql
   DECLARE p100_upd_bill_cs0 CURSOR FOR p100_upd_bill_p0
   FOREACH p100_upd_bill_cs0 INTO l_liw01,l_liw03
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p100_upd_bill_cs0',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      CALL p101_p(l_liw01,l_liw03,p_date,p_plant,p_type)
   END FOREACH
END FUNCTION

FUNCTION p101_p(p_liw01,p_liw03,p_date,p_plant,p_type)
 DEFINE p_liw01            LIKE liw_file.liw01
 DEFINE p_liw03            LIKE liw_file.liw03
 DEFINE p_plant            LIKE liw_file.liwplant
 DEFINE p_date             LIKE type_file.dat
 DEFINE p_type             LIKE type_file.chr1
 DEFINE l_liw              RECORD LIKE liw_file.*
 DEFINE l_liv              RECORD LIKE liv_file.*
 DEFINE l_lim03            LIKE lim_file.lim03
 DEFINE l_lim04            LIKE lim_file.lim04
 DEFINE l_lim06            LIKE lim_file.lim06
 DEFINE l_lim061           LIKE lim_file.lim061
 DEFINE l_lim062           LIKE lim_file.lim062
 DEFINE l_lim071           LIKE lim_file.lim071   #FUN-CA0081
 DEFINE l_lim072           LIKE lim_file.lim072   #FUN-CA0081
 DEFINE l_lla01            LIKE lla_file.lla01
 DEFINE l_lla04            LIKE lla_file.lla04
 DEFINE l_day_amt          LIKE liw_file.liw09
 DEFINE l_diff_amt         LIKE liw_file.liw09
 DEFINE l_oga23            LIKE oga_file.oga23
 DEFINE l_ogb14t           LIKE ogb_file.ogb14t
 DEFINE l_ohb14t           LIKE ohb_file.ohb14t
 DEFINE l_amt              LIKE ogb_file.ogb14t
 DEFINE l_liw12            LIKE liw_file.liw12
 DEFINE l_liv07            LIKE liv_file.liv07
 DEFINE l_type             LIKE type_file.chr1
 DEFINE l_bdate            LIKE type_file.dat
 DEFINE l_edate            LIKE type_file.dat
 DEFINE l_date             LIKE type_file.dat
 DEFINE l_date1            LIKE type_file.dat
 DEFINE l_lnt64            LIKE lnt_file.lnt64
 DEFINE l_lnt66            LIKE lnt_file.lnt66
 DEFINE l_oaj05            LIKE oaj_file.oaj05
 DEFINE l_flg              LIKE type_file.chr1
 DEFINE l_lim072_max       LIKE lim_file.lim072 #FUN-CA0081

   WHENEVER ERROR CALL cl_err_msg_log
   LET l_flg = 'N'
   LET gs_sql = "SELECT * FROM  ",cl_get_target_table(p_plant,'liw_file'),
                " WHERE liw01 = '",p_liw01,"'",
                "   AND liw03 = '",p_liw03,"'"
   PREPARE p100_upd_bill_p1 FROM gs_sql
   EXECUTE p100_upd_bill_p1 INTO l_liw.*

   IF p_type = '3' AND p_date < l_liw.liw08 THEN
      LET l_liw.liw08 = p_date
   END IF

   LET gs_sql = "SELECT azi04 FROM ",cl_get_target_table(p_plant,'azi_file'),",",
                                     cl_get_target_table(p_plant,'aza_file'),
                " WHERE azi01 =  aza17 AND aza01= '0'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE p100_upd_bill_p2 FROM gs_sql
   EXECUTE p100_upd_bill_p2 INTO g_azi04

   LET gs_sql = "SELECT lla01,lla04 FROM ",cl_get_target_table(p_plant,'lla_file'),
                " WHERE llastore = '",p_plant,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE p100_upd_bill_p3 FROM gs_sql
   EXECUTE p100_upd_bill_p3 INTO l_lla01,l_lla04

   LET gs_sql = "SELECT DISTINCT '1',liv07 ",
                "  FROM ",cl_get_target_table(p_plant,'liw_file'),",",
                          cl_get_target_table(p_plant,'liv_file'),
                " WHERE liw01 = liv01 ",
                "   AND liw02 = liv02 ",
                "   AND liw04 = liv05 ",
                "   AND liv04 BETWEEN liw07 AND liw08 ",
                "   AND liv08 = '1' ",
                "   AND liw16 IS NULL ",
                "   AND liw17 = 'N' ",
                "   AND EXISTS (SELECT 1 FROM ",cl_get_target_table(p_plant,'lil_file'),
                "                WHERE lil01 = liv07 ",
                "                  AND lil11 = '5')",
                "   AND liw01 = '",p_liw01,"'",
                "   AND liw03 = '",p_liw03,"'",
                " UNION ",
                "SELECT DISTINCT '2',liv07 ",
                "  FROM ",cl_get_target_table(p_plant,'liw_file'),",",
                          cl_get_target_table(p_plant,'liv_file'),
                " WHERE liw01 = liv01 ",
                "   AND liw02 = liv02 ",
                "   AND liw04 = liv05 ",
                "   AND liv04 BETWEEN liw07 AND liw08 ",
                "   AND liv08 = '1' ",
                "   AND liw16 IS NULL ",
                "   AND liw17 = 'N' ",
                "   AND EXISTS (SELECT 1 FROM ",cl_get_target_table(p_plant,'lip_file'),
                "                WHERE lip01 = liv07 ",
                "                  AND lip13 = '5')",
                "   AND liw01 = '",p_liw01,"'",
                "   AND liw03 = '",p_liw03,"'"
   PREPARE p100_upd_bill_p4 FROM gs_sql
   DECLARE p100_upd_bill_cs4 CURSOR FOR p100_upd_bill_p4
   FOREACH p100_upd_bill_cs4 INTO l_type,l_liv07
      IF STATUS THEN
         CALL s_errmsg('','','p100_upd_bill_cs4',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF

      IF l_type = '1' THEN
        #LET gs_sql = "SELECT lim03,lim04,lim06,lim061,lim062 ",               #FUN-CA0081
         LET gs_sql = "SELECT lim03,lim04,lim06,lim061,lim062,lim071,lim072 ", #FUN-CA0081
                      "  FROM ",cl_get_target_table(p_plant,'lim_file'),
                      " WHERE lim01 = '",l_liv07,"'",
                      " ORDER BY lim03"
      ELSE
        #LET gs_sql = "SELECT liq04,liq05,liq07,liq073,liq074",                #FUN-CA0081
         LET gs_sql = "SELECT liq04,liq05,liq07,liq073,liq074,liq081,liq082 ", #FUN-CA0081
                      "  FROM ",cl_get_target_table(p_plant,'liq_file'),",",
                                cl_get_target_table(p_plant,'lnt_file'),
                      " WHERE liq01 = '",l_liv07,"'",
                      "   AND liq03 = lnt06 ",
                      "   AND lnt01 = '",p_liw01,"'",
                      " ORDER BY liq04"
      END IF
      PREPARE p100_upd_bill_p5 FROM gs_sql
      DECLARE p100_upd_bill_cs5 CURSOR FOR p100_upd_bill_p5
     #FOREACH p100_upd_bill_cs5 INTO l_lim03,l_lim04,l_lim06,l_lim061,l_lim062                   #FUN-CA0081
      FOREACH p100_upd_bill_cs5 INTO l_lim03,l_lim04,l_lim06,l_lim061,l_lim062,l_lim071,l_lim072 #FUN-CA0081
         IF STATUS THEN
            CALL s_errmsg('','','p100_upd_bill_cs5',STATUS,1)
            LET g_success = 'N'
            RETURN
         END IF
      
         IF cl_null(l_lim061) OR l_lim061 = 0 THEN
            CONTINUE FOREACH
         END IF

         IF l_type = '1' THEN
            LET gs_sql = "SELECT MAX(lim04) ",
                         "  FROM ",cl_get_target_table(p_plant,'lim_file'),
                         " WHERE lim01 = '",l_liv07,"'"
         ELSE
            LET gs_sql = "SELECT MAX(liq05) ",
                         "  FROM ",cl_get_target_table(p_plant,'liq_file'),",",
                                   cl_get_target_table(p_plant,'lnt_file'),
                         " WHERE liq01 = '",l_liv07,"'",
                         "   AND liq03 = lnt06 ",
                         "   AND lnt01 = '",p_liw01,"'"
         END IF
         PREPARE p100_upd_bill_p6 FROM gs_sql
         EXECUTE p100_upd_bill_p6 INTO l_date
         IF l_date < l_liw.liw07 THEN #表示延用
           #FUN-CA0081 Begin---
           #IF l_type = '1' THEN
           #   LET gs_sql = "SELECT lim03,lim04,lim06,lim061,lim062 ",
           #                "  FROM ",cl_get_target_table(p_plant,'lim_file'),
           #                " WHERE lim01 = '",l_liv07,"'",
           #                "   AND lim04 = '",l_date,"'"
           #ELSE
           #   LET gs_sql = "SELECT liq04,liq05,liq07,liq073,liq074",
           #                "  FROM ",cl_get_target_table(p_plant,'liq_file'),",",
           #                          cl_get_target_table(p_plant,'lnt_file'),
           #                " WHERE liq01 = '",l_liv07,"'",
           #                "   AND liq03 = lnt06 ",
           #                "   AND lnt01 = '",p_liw01,"'",
           #                "   AND liq05 = '",l_date,"'"
           #END IF
           #PREPARE p100_upd_bill_p7 FROM gs_sql
           #EXECUTE p100_upd_bill_p7 INTO l_lim03,l_lim04,l_lim06,l_lim061,l_lim062
           #FUN-CA0081 End-----
            LET l_bdate = l_liw.liw07
            LET l_edate = l_liw.liw08
         ELSE
            IF l_liw.liw07 > l_lim04 OR l_liw.liw08 < l_lim03 THEN
               CONTINUE FOREACH
            END IF
            IF l_liw.liw07 >= l_lim03 THEN
               LET l_bdate = l_liw.liw07
            ELSE
               LET l_bdate = l_lim03
            END IF
            IF l_liw.liw08 <= l_lim04 THEN
               LET l_edate = l_liw.liw08
            ELSE
               LET l_edate = l_lim04
            END IF
         END IF

        #计算基数为1:销售金额
        #IF l_lim06 = '1' THEN
            LET l_ogb14t = 0
            LET gs_sql = "SELECT SUM(lix19) FROM ",cl_get_target_table(p_plant,'lix_file'),",",
                                                   cl_get_target_table(p_plant,'lnt_file'),
                         " WHERE lix01 = lnt06 ",
                         "   AND lix14 = lnt04 ",
                         "   AND ((lnt01 = lix12 AND lix11 = '1') OR",
                         "        (lnt70 = lix12 AND lix11 = '2')) ",
                         "   AND lnt01 = '",p_liw01,"'",
                         "   AND lix02 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
            PREPARE p100_upd_bill_p8 FROM gs_sql
            EXECUTE p100_upd_bill_p8 INTO l_ogb14t
            IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
           #FUN-CA0081 Begin---
           #抓lim03~lim04范围内最大的上限，如果销售额大于这个上限，用这个上限的比例和保底金额
            IF l_type = '1' THEN
               LET gs_sql = "SELECT MAX(lim072) ",
                            "  FROM ",cl_get_target_table(p_plant,'lim_file'),
                            " WHERE lim01 = '",l_liv07,"'"
                           #"   AND lim03 = '",l_lim03,"'",
                           #"   AND lim04 = '",l_lim04,"'"
               IF l_date < l_liw.liw07 THEN #表示延用
                  LET gs_sql = gs_sql CLIPPED," AND lim04 = '",l_date,"' "
               ELSE
                  LET gs_sql = gs_sql CLIPPED," AND lim03 = '",l_lim03,"' ",
                                              " AND lim04 = '",l_lim04,"' "
               END IF
            ELSE            
               LET gs_sql = "SELECT MAX(liq082) ",
                            "  FROM ",cl_get_target_table(p_plant,'liq_file'),",",
                                      cl_get_target_table(p_plant,'lnt_file'),
                            " WHERE liq01 = '",l_liv07,"'",
                            "   AND liq03 = lnt06 ",
                            "   AND lnt01 = '",p_liw01,"'"
                           #"   AND liq04 = '",l_lim03,"'",
                           #"   AND liq05 = '",l_lim04,"'"
               IF l_date < l_liw.liw07 THEN #表示延用
                  LET gs_sql = gs_sql CLIPPED," AND liq05 = '",l_date,"' "
               ELSE
                  LET gs_sql = gs_sql CLIPPED," AND liq04 = '",l_lim03,"' ",
                                              " AND liq05 = '",l_lim04,"' "
               END IF
            END IF
            PREPARE p100_sel_maxlim072_p FROM gs_sql
            EXECUTE p100_sel_maxlim072_p INTO l_lim072_max
            IF cl_null(l_lim072_max) THEN LET l_lim072_max = 0 END IF
           #放在后面，如果延期根据销售额和日期抓对应哪一个分段的比例和保底金额
            IF l_date < l_liw.liw07 THEN
               IF l_type = '1' THEN
                  LET gs_sql = "SELECT lim03,lim04,lim06,lim061,lim062,lim071,lim072 ",
                               "  FROM ",cl_get_target_table(p_plant,'lim_file'),
                               " WHERE lim01 = '",l_liv07,"'",
                               "   AND lim04 = '",l_date,"'",
                               "   AND ((lim071 <= '",l_ogb14t,"' AND lim072 >= '",l_ogb14t,"') OR ", #有设置上下限，满足区间
                               "        (lim071 IS NULL AND lim072 IS NULL) OR ",                     #没有设置上下限
                               "        (lim072 = '",l_lim072_max,"' AND lim072 < '",l_ogb14t,"'))"   #有设置上下限，超过了最大上限
               ELSE
                  LET gs_sql = "SELECT liq04,liq05,liq07,liq073,liq074,liq081,liq082 ",
                               "  FROM ",cl_get_target_table(p_plant,'liq_file'),",",
                                         cl_get_target_table(p_plant,'lnt_file'),
                               " WHERE liq01 = '",l_liv07,"'",
                               "   AND liq03 = lnt06 ",
                               "   AND lnt01 = '",p_liw01,"'",
                               "   AND liq05 = '",l_date,"'",
                               "   AND ((liq081 <= '",l_ogb14t,"' AND liq082 >= '",l_ogb14t,"') OR ",
                               "        (liq081 IS NULL AND liq082 IS NULL) OR ",
                               "        (liq082 = '",l_lim072_max,"' AND liq082 < '",l_ogb14t,"'))"
               END IF
               PREPARE p100_upd_bill_p7 FROM gs_sql
               EXECUTE p100_upd_bill_p7 INTO l_lim03,l_lim04,l_lim06,l_lim061,l_lim062,l_lim071,l_lim072
               IF SQLCA.sqlcode = 100 THEN CONTINUE FOREACH END IF
            END IF

           #如果有维护上下限且销售额不在上下限范围内,CONTINUE FOREACH
            IF NOT cl_null(l_lim071) AND NOT cl_null(l_lim072) THEN
              #IF l_ogb14t < l_lim071 OR l_ogb14t > l_lim072 THEN
               IF (l_lim071 <= l_ogb14t AND l_ogb14t <= l_lim072) OR
                  (l_lim072_max = l_lim072 AND l_ogb14t > l_lim072) THEN
               ELSE
                  CONTINUE FOREACH
               END IF
            END IF
           #FUN-CA0081 End-----
            LET l_ogb14t = l_ogb14t * l_lim061/100
        #END IF
         IF l_ogb14t < l_lim062 THEN
            LET l_ogb14t = l_lim062
         END IF
         LET l_day_amt = l_ogb14t/(l_edate-l_bdate+1)
         LET l_day_amt = cl_digcut(l_day_amt,l_lla04)
         LET l_diff_amt = l_ogb14t - l_day_amt*(l_edate-l_bdate+1)
         LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liv_file'),
                      "   SET liv06 = ",l_day_amt," ",
                      " WHERE liv01 = '",l_liw.liw01,"'",
                      "   AND liv02 = '",l_liw.liw02,"'",
                      "   AND liv05 = '",l_liw.liw04,"'",
                      "   AND liv07 = '",l_liv07,"'",
                      "   AND liv04 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                      "   AND liv08 = '1'"
         PREPARE p100_upd_bill_p9 FROM gs_sql
         EXECUTE p100_upd_bill_p9
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('liv01',l_liw.liw01,'upd liv',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
        #更新差异
         IF l_lla01 = '1' THEN
            LET l_date1 = l_bdate
         ELSE
            LET l_date1 = l_edate
         END IF
         LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liv_file'),
                      "   SET liv06 = liv06 + ",l_diff_amt," ",
                      " WHERE liv01 = '",l_liw.liw01,"'",
                      "   AND liv02 = '",l_liw.liw02,"'",
                      "   AND liv05 = '",l_liw.liw04,"'",
                      "   AND liv07 = '",l_liv07,"'",
                      "   AND liv04 = '",l_date1,"' ",
                      "   AND liv08 = '1'"
         PREPARE p100_upd_bill_p10 FROM gs_sql
         EXECUTE p100_upd_bill_p10
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('liv01',l_liw.liw01,'upd liv',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF

         LET l_flg = 'Y'
         IF l_date < l_liw.liw07 THEN EXIT FOREACH END IF
      END FOREACH
      IF l_flg = 'Y' THEN
        #更新合同单身标准费用
         LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'lnv_file'),
                      "   SET lnv07 =(SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                      "                WHERE liv01 = '",l_liw.liw01,"'",
                      "                  AND liv02 = '",l_liw.liw02,"'",
                     #"                  AND liv04 BETWEEN '",l_liw.liw07,"' AND '",l_liw.liw08,"'",
                      "                  AND liv05 = '",l_liw.liw04,"'",
                      "                  AND liv07 = '",l_liv07,"'",
                      "                  AND liv08 = '1')",
                      " WHERE lnv01 = '",l_liw.liw01,"'",
                      "   AND lnv02 = ",l_liw.liw02,
                      "   AND lnv04 = '",l_liw.liw04,"'",
                      "   AND lnv18 = '",l_liv07,"'"
         PREPARE p100_upd_bill_p17 FROM gs_sql
         EXECUTE p100_upd_bill_p17
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('lnv01',l_liw.liw01,'upd lnv_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
   END FOREACH

   IF l_flg = 'Y' THEN
      LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                   " WHERE liv01 = '",l_liw.liw01,"'",
                   "   AND liv02 = '",l_liw.liw02,"'",
                   "   AND liv05 = '",l_liw.liw04,"'",
                   "   AND liv04 BETWEEN '",l_liw.liw07,"' AND '",l_liw.liw08,"'",
                   "   AND liv08 = '1'"
      PREPARE p100_upd_bill_p11 FROM gs_sql
      EXECUTE p100_upd_bill_p11 INTO l_liw.liw09
      IF cl_null(l_liw.liw09) THEN LET l_liw.liw09 = 0 END IF
      LET l_liw.liw13 = l_liw.liw09+l_liw.liw10+l_liw.liw11
      LET l_liw12 = cl_digcut(l_liw.liw13,g_azi04) - l_liw.liw13
      LET l_liw.liw13 = cl_digcut(l_liw.liw13,g_azi04)
      LET l_liw.liw12 = l_liw12

     #由于抓销售额都转换为本币金额，这一段产生抹零金额的日核算可能用不到
      IF l_liw12 <> '0' THEN
         LET gs_sql = "DELETE FROM ",cl_get_target_table(p_plant,'liv_file'),
                      " WHERE liv01 = '",l_liw.liw01,"'",
                      "   AND liv02 = '",l_liw.liw02,"' ",
                      "   AND liv04 = '",l_liw.liw08,"' ",
                      "   AND liv05 = '",l_liw.liw04,"' ",
                      "   AND liv08 = '4'"
         PREPARE p100_upd_bill_p18 FROM gs_sql
         EXECUTE p100_upd_bill_p18
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('liv01',l_liw.liw01,'del liv',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
         LET gs_sql = "SELECT MAX(liv03)+1",
                      "  FROM ",cl_get_target_table(p_plant,'liv_file'),
                      " WHERE liv01 = '",l_liw.liw01,"'"
         PREPARE p100_upd_bill_p12 FROM gs_sql
         EXECUTE p100_upd_bill_p12 INTO l_liv.liv03
         IF cl_null(l_liv.liv03) THEN
            LET l_liv.liv03 = 1
         END IF 
         LET l_liv.liv01 = l_liw.liw01
         LET l_liv.liv02 = l_liw.liw02
         LET l_liv.liv03 = l_liv.liv03
         LET l_liv.liv04 = l_liw.liw08
         LET l_liv.liv05 = l_liw.liw04
         LET l_liv.liv06 = l_liw12
         LET l_liv.liv07 = ''
         LET l_liv.liv071= ''
         LET l_liv.liv08 = '4'
         LET l_liv.liv09 = '0'
         LET l_liv.livlegal = l_liw.liwlegal
         LET l_liv.livplant = l_liw.liwplant
         #费用+账款日期+抹零类型 存在否
         LET g_cnt = 0
         LET gs_sql = "SELECT COUNT(*) ",
                      "  FROM ",cl_get_target_table(p_plant,'liv_file'),
                      " WHERE liv01 = '",l_liw.liw01,"'",
                      "   AND liv02 = '",l_liw.liw02,"'",
                      "   AND liv05 = '",l_liw.liw04,"'",
                      "   AND liv04 = '",l_liw.liw08,"'",
                      "   AND liv08='4' "
         PREPARE p100_upd_bill_p13 FROM gs_sql
         EXECUTE p100_upd_bill_p13 INTO g_cnt
         IF g_cnt = 0 THEN
            LET gs_sql = "INSERT INTO ",cl_get_target_table(p_plant,'liv_file'),
                         "       (liv01,liv02,liv03,liv04,liv05,liv06,liv07,liv071,liv08,liv09,livlegal,livplant)",
                         " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"
            PREPARE p100_upd_bill_p14 FROM gs_sql
            EXECUTE p100_upd_bill_p14 USING l_liv.liv01,l_liv.liv02,l_liv.liv03, l_liv.liv04,l_liv.liv05,
                                               l_liv.liv06,l_liv.liv07,l_liv.liv071,l_liv.liv08,l_liv.liv09,
                                               l_liv.livlegal,l_liv.livplant
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('liv01',l_liv.liv01,'ins liv_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
         ELSE
            LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liv_file'),
                         "   SET liv06 = liv06 + ",l_liw12,
                         " WHERE liv01 = '",l_liw.liw01,"'",
                         "   AND liv05 = '",l_liw.liw04,"'",
                         "   AND liv04 = '",l_liw.liw08,"'",
                         "   AND liv08 = '4' "
            PREPARE p100_upd_bill_p15 FROM gs_sql
            EXECUTE p100_upd_bill_p15
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('liv01',l_liv.liv01,'upd liv_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
         END IF
      END IF
      
     #更新账单/合同单头金额
      LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liw_file'),
                   "   SET liw09 = ",l_liw.liw09,",",
                   "       liw12 = ",l_liw.liw12,",",
                   "       liw13 = ",l_liw.liw13," ",
                   " WHERE liw01 = '",l_liw.liw01,"'",
                   "   AND liw03 = '",l_liw.liw03,"'"
      PREPARE p100_upd_bill_p16 FROM gs_sql
      EXECUTE p100_upd_bill_p16
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('liw01',l_liw.liw01,'upd liw',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      
      CALL p101_upd_lnt(l_liw.liw01,p_plant)
   END IF
END FUNCTION

FUNCTION p101_upd_lnt(p_lnt01,p_plant)
 DEFINE p_lnt01          LIKE lnt_file.lnt01
 DEFINE p_plant          LIKE lnt_file.lntplant
 DEFINE l_liv06_sum1     LIKE liv_file.liv06
 DEFINE l_liv06_sum2     LIKE liv_file.liv06
 DEFINE l_liv06_sum3     LIKE liv_file.liv06
 DEFINE l_liv06_sum4     LIKE liv_file.liv06
 DEFINE l_liv06_sum5     LIKE liv_file.liv06
   
   #抓取标准费用金额总和
   LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                " WHERE liv01 = '",p_lnt01,"'",
                "   AND liv08 = '1' "
   PREPARE p101_upd_lnt_p1 FROM gs_sql
   EXECUTE p101_upd_lnt_p1 INTO l_liv06_sum1
   IF cl_null(l_liv06_sum1) THEN LET l_liv06_sum1 = 0 END IF
   
   #抓取优惠费用金额总和
   LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                " WHERE liv01 = '",p_lnt01,"'",
                "   AND liv08 = '2' "
   PREPARE p101_upd_lnt_p2 FROM gs_sql
   EXECUTE p101_upd_lnt_p2 INTO l_liv06_sum2
   IF cl_null(l_liv06_sum2) THEN LET l_liv06_sum2 = 0 END IF
   
   #抓取终止费用金额总和
   LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                " WHERE liv01 = '",p_lnt01,"'",
                "   AND liv08 = '3' "
   PREPARE p101_upd_lnt_p3 FROM gs_sql
   EXECUTE p101_upd_lnt_p3 INTO l_liv06_sum3
   IF cl_null(l_liv06_sum3) THEN LET l_liv06_sum3 = 0 END IF
   
   #抓取抹零费用金额总和
   LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                " WHERE liv01 = '",p_lnt01,"'",
                "   AND liv08 = '4' "
   PREPARE p101_upd_lnt_p4 FROM gs_sql
   EXECUTE p101_upd_lnt_p4 INTO l_liv06_sum4
   IF cl_null(l_liv06_sum4) THEN LET l_liv06_sum4 = 0 END IF
   
   #抓取质保金费用总和
   LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                " WHERE liv01 = '",p_lnt01,"'",
                "   AND liv05 IN (SELECT liu04 FROM ",cl_get_target_table(p_plant,'liu_file'),",",
                                                      cl_get_target_table(p_plant,'oaj_file'),
                "                  WHERE liu01 = '",p_lnt01,"'",
                "                    AND liu04 = oaj01 ",
                "                    AND oaj05 = '01')",
                "   AND liv08 = '1' "
   PREPARE p101_upd_lnt_p5 FROM gs_sql
   EXECUTE p101_upd_lnt_p5 INTO l_liv06_sum5
   IF cl_null(l_liv06_sum5) THEN LET l_liv06_sum5 = 0 END IF
   
   LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'lnt_file'),
                "   SET lnt64 = ",l_liv06_sum1-l_liv06_sum5,",",
                "       lnt65 = ",l_liv06_sum2,",",
                "       lnt66 = ",l_liv06_sum5,",",
                "       lnt67 = ",l_liv06_sum3,",",
                "       lnt68 = ",l_liv06_sum4,",",
                "       lnt69 = ",l_liv06_sum1+l_liv06_sum2+l_liv06_sum3+l_liv06_sum4,
                " WHERE lnt01 = '",p_lnt01,"'"
   PREPARE p101_upd_lnt_p6 FROM gs_sql
   EXECUTE p101_upd_lnt_p6
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lnt01',p_lnt01,'upd lnt_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION
#FUN-C20078
