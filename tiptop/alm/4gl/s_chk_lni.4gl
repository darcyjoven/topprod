# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_chk_lni.4gl
# Descriptions...: 生效範圍檢查
# Date & Author..: FUN-A20034 10/02/09 By shiwuying
# Modify.........: No:FUN-A80148 10/09/03 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位 
# Modify.........: No.FUN-C70126 12/07/31 By pauline 調整lni02分類欄位內容
DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chk_lni(p_type,p_no,p_plant,p_stall)
#生效範圍檢查  p_type 類型  0-卡種生效範圍檢查
#                           1-券類型
#                           2-促銷 - 折扣返券
#                           2-促銷 - 直接折扣
#                           2-促銷 - 返券返現
#                           2-促銷 - 贈送贈品
#                           3-積分換券
#                           4-積分換物
#              p_no 單據號
#              p_plant 當前門店
#              p_stall 當前攤位

 DEFINE p_type    LIKE type_file.chr1
 DEFINE p_no      LIKE type_file.chr30
 DEFINE p_plant   LIKE rtz_file.rtz01
 DEFINE p_stall   LIKE lmf_file.lmf01
 DEFINE l_lnk02   LIKE lnk_file.lnk02
 DEFINE l_lqg02   LIKE type_file.chr1
 DEFINE l_sql     LIKE type_file.chr1000
 DEFINE l_cnt     LIKE type_file.num5

   IF p_type = '2' THEN
      SELECT lqg02 INTO l_lqg02 FROM lqg_file
       WHERE lqg01 = p_no
      IF cl_null(l_lqg02) THEN RETURN FALSE END IF
   END IF
   CASE
      WHEN p_type = '0'                   LET l_lnk02 = '1' #卡種
      WHEN p_type = '1'                   LET l_lnk02 = '2' #券類型
      WHEN p_type = '2' AND l_lqg02 = '0' LET l_lnk02 = '3' #折扣返券
      WHEN p_type = '2' AND l_lqg02 = '1' LET l_lnk02 = '4' #直接折扣
      WHEN p_type = '2' AND l_lqg02 = '2' LET l_lnk02 = '5' #返券返現
      WHEN p_type = '2' AND l_lqg02 = '3' LET l_lnk02 = '6' #贈送贈品
     #WHEN p_type = '3'                   LET l_lnk02 = '1' #積分換券    #FUN-C70126 mark
     #WHEN p_type = '4'                   LET l_lnk02 = '2' #積分換物    #FUN-C70126 mark
     #FUN-C70126 add START
      WHEN p_type = '3' AND g_prog = 'almt595' LET l_lnk02 = '1'   #積分換券
      WHEN p_type = '3' AND g_prog = 'almt596' LET l_lnk02 = '2'   #累計消費額換券
      WHEN p_type = '4' AND g_prog = 'almt605' LET l_lnk02 = '3'   #積分換物
      WHEN p_type = '4' AND g_prog = 'almt606' LET l_lnk02 = '4'   #累計消費額換物
     #FUN-C70126 add END
      OTHERWISE RETURN FALSE
   END CASE

   LET l_cnt = 0
   IF p_type MATCHES '[012]' THEN
      LET l_sql = "SELECT COUNT(*) FROM lnk_file",
                  " WHERE lnk01  = '",p_no,"'",
                  "   AND lnk02  = '",l_lnk02,"'",
                  "   AND lnk03  = '",p_plant,"'",
                  "   AND lnk04 != ' ' ",
                  "   AND lnk05  = 'Y' "
      PREPARE sel_lnk_pre01 FROM l_sql
      EXECUTE sel_lnk_pre01 INTO l_cnt
      IF l_cnt > 0 AND NOT cl_null(p_stall) THEN
         LET l_sql = "SELECT COUNT(*) FROM lnk_file",
                     " WHERE lnk01  = '",p_no,"'",
                     "   AND lnk02  = '",l_lnk02,"'",
                     "   AND lnk03  = '",p_plant,"'",
                     "   AND lnk04  = '",p_stall,"'",
                     "   AND lnk05  = 'Y' "
         PREPARE sel_lnk_pre02 FROM l_sql
         EXECUTE sel_lnk_pre02 INTO l_cnt
      ELSE
         LET l_sql = "SELECT COUNT(*) FROM lnk_file",
                     " WHERE lnk01  = '",p_no,"'",
                     "   AND lnk02  = '",l_lnk02,"'",
                     "   AND lnk03  = '",p_plant,"'",
                     "   AND lnk04  = ' ' ",
                     "   AND lnk05  = 'Y' "
         PREPARE sel_lnk_pre03 FROM l_sql
         EXECUTE sel_lnk_pre03 INTO l_cnt
      END IF
   ELSE
      LET l_sql = "SELECT COUNT(*) FROM lni_file",
                  " WHERE lni01  = '",p_no,"'",
                  "   AND lni02  = '",l_lnk02,"'",
                  "   AND lni04  = '",p_plant,"'",
                  "   AND lni08 != ' ' ",
                  "   AND lni13  = 'Y' "
      PREPARE sel_lni_pre01 FROM l_sql
      EXECUTE sel_lni_pre01 INTO l_cnt
      IF l_cnt > 0 AND NOT cl_null(p_stall) THEN
         LET l_sql = "SELECT COUNT(*) FROM lni_file",
                     " WHERE lni01  = '",p_no,"'",
                     "   AND lni02  = '",l_lnk02,"'",
                     "   AND lni04  = '",p_plant,"'",
                     "   AND lni08  = '",p_stall,"'",
                     "   AND lni13  = 'Y' "
         PREPARE sel_lni_pre02 FROM l_sql
         EXECUTE sel_lni_pre02 INTO l_cnt
      ELSE
         LET l_sql = "SELECT COUNT(*) FROM lni_file",
                     " WHERE lni01  = '",p_no,"'",
                     "   AND lni02  = '",l_lnk02,"'",
                     "   AND lni04  = '",p_plant,"'",
                     "   AND lni08  = ' ' ",
                     "   AND lni13  = 'Y' "
         PREPARE sel_lni_pre03 FROM l_sql
         EXECUTE sel_lni_pre03 INTO l_cnt
      END IF
   END IF

   IF l_cnt > 0 THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION
#FUN-A80148
#No.FUN-A20034
