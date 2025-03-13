# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_upd_vne06.4gl
# Descriptions...: 重新計算vne06的值
# Date & Author..: 2008/10/07 By Mandy #TQC-8A0013
# Usage..........: CALL s_upd_vne06(p_vne01,p_vne02,p_vne03,p_vne04,p_qty) 
# Input Parameter: p_vne01     製令編號
# Input Parameter: p_vne02     途程編號
# Input Parameter: p_vne03     加工序號
# Input Parameter: p_vne04     作業編號
# Input Parameter: p_qty       數量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds        
 
GLOBALS "../../config/top.global"   
 
FUNCTION s_upd_vne06(p_vne01,p_vne02,p_vne03,p_vne04,p_qty) #TQC-8A0013
DEFINE p_vne01         LIKE vne_file.vne01
DEFINE p_vne02         LIKE vne_file.vne02
DEFINE p_vne03         LIKE vne_file.vne03
DEFINE p_vne04         LIKE vne_file.vne04
DEFINE p_qty           LIKE sfb_file.sfb08
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_first         LIKE type_file.chr1
DEFINE l_vne06         LIKE vne_file.vne06
DEFINE l_vne06_upd     LIKE type_file.num20
DEFINE l_vne06_first   LIKE type_file.num20
DEFINE l_vne06_other   LIKE type_file.num20
DEFINE l_vne    RECORD LIKE vne_file.*
 
  DECLARE s_upd_vne06 CURSOR FOR
   SELECT *  
    FROM vne_file
   WHERE vne01 = p_vne01
     AND vne02 = p_vne02
     AND vne03 = p_vne03
     AND vne04 = p_vne04
 
  SELECT COUNT(*) INTO l_cnt FROM vne_file
   WHERE vne01 = p_vne01
     AND vne02 = p_vne02
     AND vne03 = p_vne03
     AND vne04 = p_vne04
  IF l_cnt > 0 THEN
      LET l_vne06 = p_qty/l_cnt
      LET l_vne06_other = s_trunc(l_vne06,0) #僅取整數,小數點後位數無條件捨去
      LET l_vne06_first = l_vne06_other + (p_qty - (l_vne06_other*l_cnt))
 
      LET l_first = 'Y'
      FOREACH s_upd_vne06 INTO l_vne.*
          IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:s_upd_vne06',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
          IF l_first = 'Y' THEN
              LET l_vne06_upd = l_vne06_first
          ELSE
              LET l_vne06_upd = l_vne06_other
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
END FUNCTION
 
