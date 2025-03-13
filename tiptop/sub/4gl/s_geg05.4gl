# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_geg05.4gl
# Descriptions...: 檢查並組出後段的編碼                                            
# Date & Author..: 03/09/29 By Danny
# Usage..........: CALL s_geg05(p_no,p_key,p_j,p_k)
# Input Parameter: p_no    編號
# Return code....: p_no    編號
# Modify.........: FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-840294 08/04/20 By Nicola 增加編碼型態
# Modify.........: No.MOD-870191 08/07/15 By Nicola 不處理批/序號編碼的部份
                                                                                
DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"  #FUN-7C0053
 
FUNCTION s_geg05(p_no,p_key,p_j,p_k,p_flag)
DEFINE p_no             LIKE geg_file.geg05
DEFINE p_flag           LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
DEFINE p_j,p_k          LIKE type_file.num5          #No.FUN-680147 SMALLINT
DEFINE p_key            LIKE gef_file.gef01 
DEFINE l_geg05          LIKE geg_file.geg05
DEFINE l_i,l_j,l_cnt    LIKE type_file.num5          #No.FUN-680147 SMALLINT
DEFINE l_gel            RECORD LIKE gel_file.*
DEFINE l_gel02          LIKE gel_file.gel02
DEFINE l_flag,l_flag2   LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
 
   LET l_flag = 'N'
   LET l_flag2= 'N'
 
   #判斷是否為第一個獨立段
   SELECT COUNT(*),MIN(gel02) INTO l_cnt,l_gel02
     FROM gel_file
    WHERE gel01 = p_key AND gel04 = '2'
   IF l_cnt > 0 AND l_gel02 = p_j THEN
      LET l_flag2 = 'Y'
   END IF
  
   IF p_j > 1 AND p_flag = '1' THEN
      #判斷兩個獨立段之間是否有單身的段次
      FOR l_i = p_j -1 TO 1 STEP -1
          SELECT * INTO l_gel.* FROM gel_file
           WHERE gel01 = p_key AND gel02 = l_i
          IF cl_null(l_gel.gel04) THEN LET l_flag = 'Y' EXIT FOR END IF 
          IF l_gel.gel04 = '2' THEN EXIT FOR END IF 
      END FOR
      IF l_flag = 'N' AND l_flag2 = 'N' THEN
         RETURN p_no
      END IF
   END IF
 
   LET l_geg05 = p_no
   #判斷下段是否為固定值或獨立段或流水號
   FOR l_i = p_j TO p_k  
       SELECT * INTO l_gel.* FROM gel_file
        WHERE gel01 = p_key AND gel02 = l_i 
       IF STATUS THEN CALL cl_err(l_i,'aoo-137',0) EXIT FOR END IF
       CASE
         WHEN l_gel.gel04 = '1'    #固定值
              LET l_geg05 = l_geg05 CLIPPED,l_gel.gel05
         WHEN l_gel.gel04 = '2'    #獨立段
              FOR l_j=1 TO l_gel.gel03
                  LET l_geg05 = l_geg05 CLIPPED,"%"
              END FOR
         WHEN l_gel.gel04 = '3'    #流水號
              FOR l_j=1 TO l_gel.gel03
                  LET l_geg05 = l_geg05 CLIPPED,"*"
              END FOR
        ##-----No.MOD-870191 Mark-----
        ##-----No.MOD-840294-----
        #WHEN l_gel.gel04 = '5'         #年   
        #   FOR l_j=1 TO l_gel.gel03
        #      LET l_geg05 = l_geg05 CLIPPED,"Y"
        #   END FOR
        #WHEN l_gel.gel04 = '6'         #季   
        #   FOR l_j=1 TO l_gel.gel03
        #      LET l_geg05 = l_geg05 CLIPPED,"S"
        #   END FOR
        #WHEN l_gel.gel04 = '7'         #月   
        #   FOR l_j=1 TO l_gel.gel03
        #      LET l_geg05 = l_geg05 CLIPPED,"M"
        #   END FOR
        #WHEN l_gel.gel04 = '8'         #週   
        #   FOR l_j=1 TO l_gel.gel03
        #      LET l_geg05 = l_geg05 CLIPPED,"W"
        #   END FOR
        #WHEN l_gel.gel04 = '9'         #日   
        #   FOR l_j=1 TO l_gel.gel03
        #      LET l_geg05 = l_geg05 CLIPPED,"D"
        #   END FOR
        ##-----No.MOD-840294 END-----
        ##-----No.MOD-870191 Mark END-----
         OTHERWISE EXIT FOR 
       END CASE
   END FOR
   RETURN l_geg05
END FUNCTION       
