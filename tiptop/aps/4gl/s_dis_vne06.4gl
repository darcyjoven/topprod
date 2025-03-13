# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_dis_vne06.4gl
# Descriptions...: 重新分配vne06的值
# Date & Author..: 2009/10/05 By Mandy #FUN-990094
# Usage..........: CALL s_dis_vne06(p_vne01,p_vne02,p_vne03,p_vne04,p_qty) 
# Modify.........: No.FUN-B50050 11/05/13 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

# Input Parameter: p_vne01     製令編號
# Input Parameter: p_vne02     途程編號
# Input Parameter: p_vne03     加工序號
# Input Parameter: p_vne04     作業編號
# Input Parameter: p_qty       數量
#--------------------------------------------------------------
# 邏輯範例       :
# 生產數量       :100
#     機台  原未完成量    報工 分配報工量 報工後未完成量
#     A     20                 7          13
#     B     20                 6          14
#     C     20                 6          14
#     D     20                 6          14
#     E     20            45   20         0
#超報量為45-20 = 25
#超報量/未分配機台 = 25/4 = 6.25,所以第一台分配7,其餘分配6
#若分配後,該機台還是會有超報量,則將超報量一一累計.
#累計後,再次CALL s_dis_vne06()重新計算.
#--------------------------------------------------------------


DATABASE ds        

GLOBALS "../../config/top.global"   

FUNCTION s_dis_vne06(p_vne01,p_vne02,p_vne03,p_vne04,p_qty)  #FUN-990094
DEFINE p_vne01             LIKE vne_file.vne01
DEFINE p_vne02             LIKE vne_file.vne02
DEFINE p_vne03             LIKE vne_file.vne03
DEFINE p_vne04             LIKE vne_file.vne04
DEFINE p_qty               LIKE sfb_file.sfb08
DEFINE l_cnt               LIKE type_file.num5
DEFINE l_first             LIKE type_file.chr1
DEFINE l_vne06             LIKE vne_file.vne06
DEFINE l_vne06_upd         LIKE type_file.num20
DEFINE l_re_dis_vne06      LIKE type_file.num20
DEFINE l_all_re_dis_vne06  LIKE type_file.num20
DEFINE l_vne06_first       LIKE type_file.num20
DEFINE l_vne06_other       LIKE type_file.num20
DEFINE l_vne    RECORD     LIKE vne_file.*

  DECLARE s_dis_vne06 CURSOR FOR
   SELECT *  
    FROM vne_file
   WHERE vne01 = p_vne01
     AND vne02 = p_vne02
     AND vne03 = p_vne03
     AND vne04 = p_vne04
     AND vne06 > 0
   ORDER BY vne05

  SELECT COUNT(*) INTO l_cnt FROM vne_file
   WHERE vne01 = p_vne01
     AND vne02 = p_vne02
     AND vne03 = p_vne03
     AND vne04 = p_vne04
     AND vne06 > 0

  IF l_cnt > 0 THEN
      LET l_vne06 = p_qty/l_cnt
      LET l_vne06_other = s_trunc(l_vne06,0) #僅取整數,小數點後位數無條件捨去
      LET l_vne06_first = l_vne06_other + (p_qty - (l_vne06_other*l_cnt))
 
      LET l_first = 'Y'
      LET l_all_re_dis_vne06 = 0
      FOREACH s_dis_vne06 INTO l_vne.*
          IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:s_dis_vne06',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
          IF l_first = 'Y' THEN
              LET l_vne06_upd = l_vne.vne06 - l_vne06_first
          ELSE
              LET l_vne06_upd = l_vne.vne06 - l_vne06_other
          END IF
          IF l_vne06_upd < 0 THEN
              LET l_re_dis_vne06 = l_vne06_upd * (-1)
              LET l_all_re_dis_vne06 = l_all_re_dis_vne06 + l_re_dis_vne06 
              LET l_vne06_upd = 0
          END IF
          UPDATE vne_file
             SET vne06 = l_vne06_upd
           WHERE vne01 = l_vne.vne01
             AND vne02 = l_vne.vne02
             AND vne03 = l_vne.vne03
             AND vne04 = l_vne.vne04
             AND vne05 = l_vne.vne05
          LET l_first = 'N'
      END FOREACH
  END IF
  IF l_all_re_dis_vne06 >=1 THEN
      CALL s_dis_vne06(p_vne01,p_vne02,p_vne03,p_vne04,l_all_re_dis_vne06) 
  END IF
END FUNCTION
#FUN-B50050
