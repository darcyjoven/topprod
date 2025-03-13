# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: aeci700_sub.4gl
# Description....: 提供aeci700.4gl使用的sub routine
# Date & Author..: 11/02/23 By liweie (FUN-B10056)
# Modify.........: FUN-B20078 11/03/02 By lixh1 檢查下製程段號存在於aeci700製程段號
# Modify.........: FUN-B30011 11/03/03 By lixh1 修改製程段檢查邏輯

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_flag_i700           LIKE type_file.chr1             
DEFINE g_ecm012_a            ARRAY[1000] OF LIKE ecm_file.ecm012
DEFINE g_max                 LIKE type_file.num5
DEFINE g_cnt_i700            LIKE type_file.num5
DEFINE g_chr_i700            LIKE type_file.chr1

FUNCTION i700sub_chkbom(p_sfb01,p_flag)
   DEFINE p_sfb01      LIKE sfb_file.sfb01
   DEFINE p_flag       LIKE type_file.chr1 
   DEFINE l_sql        STRING
   DEFINE l_cnt        LIKE type_file.num10
   DEFINE l_n          LIKE type_file.num10
   DEFINE l_count      LIKE type_file.num10    
   DEFINE l_ecm012     LIKE ecm_file.ecm012   #FUN-B30011
   DEFINE l_ecm015     LIKE ecm_file.ecm015
   DEFINE m_ecm015     LIKE ecm_file.ecm015   #FUN-B20078
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤

   LET g_success = 'Y'
   LET l_sql = "SELECT DISTINCT ecm012,ecm015 FROM ecm_file WHERE ecm01 = '",p_sfb01,"'"
     
   PREPARE p700_pb FROM l_sql
   DECLARE p700_pb_cs CURSOR FOR p700_pb
   
   LET g_flag_i700 = 'N'
   LET l_count = 0 
#FUN-B20078 ----------------------Begin-------------------------
   DECLARE i700sub_cs CURSOR FOR
      SELECT DISTINCT ecm015 FROM ecm_file
       WHERE ecm01 = p_sfb01
         AND (ecm015 IS NOT NULL OR ecm015 <> ' ')
   FOREACH i700sub_cs INTO m_ecm015
      LET l_n = 0
      IF cl_null(m_ecm015) THEN
          CONTINUE FOREACH
      END IF
      SELECT COUNT(*) INTO l_n FROM ecm_file
       WHERE ecm012 = m_ecm015 
         AND ecm01 = p_sfb01
      IF l_n < 1 THEN
         CALL cl_err(m_ecm015,'aec-066',1)
         LET g_success = 'N'
         RETURN
      END IF       
   END FOREACH
#FUN-B20078 ----------------------End---------------------------
   SELECT COUNT(DISTINCT ecm012) INTO l_count FROM ecm_file
    WHERE ecm01=p_sfb01
      AND (ecm015 IS NOT NULL OR ecm015 <> ' ')
   IF l_count = 0  THEN
      SELECT COUNT(DISTINCT ecm012) INTO l_count FROM ecm_file WHERE ecm01=p_sfb01
      IF l_count > 1 THEN
         CALL cl_err('','aec-045',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   LET l_cnt = 0
   DECLARE i700sub_cs1 CURSOR FOR
    SELECT COUNT(DISTINCT ecm015),ecm012 FROM ecm_file WHERE ecm01=p_sfb01  GROUP BY ecm012
   FOREACH i700sub_cs1 INTO l_cnt,l_ecm012
     IF l_cnt > 1 THEN
        CALL cl_err(l_ecm012,'aec-064',1)
        LET g_success = 'N'
        RETURN
     END IF
   END FOREACH

   INITIALIZE l_ecm012 TO NULL 
   INITIALIZE l_ecm015 TO NULL 
   FOREACH p700_pb_cs INTO l_ecm012,l_ecm015
     LET g_flag_i700='Y'
     IF g_success = 'Y' THEN 
        LET g_max = 1 
        LET g_ecm012_a[1] = l_ecm012 
        CALL i700_bom(0,p_sfb01,l_ecm012,l_ecm015)
     ELSE
        RETURN 
     END IF    
   END FOREACH 
   
   LET l_cnt=0
   SELECT COUNT(DISTINCT ecm012) INTO l_cnt FROM ecm_file 
    WHERE ecm01=p_sfb01 
      AND (ecm015 IS NULL OR ecm015 = ' ')

   IF l_cnt > 1 THEN
      CALL cl_err('','aec-045',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_cnt = 0 THEN
      CALL cl_err('','aec-041',1)
      LET g_success = 'N'
      RETURN   
   END IF

   IF g_flag_i700 = 'N' THEN
      CALL cl_err('','aec-049',1)
      LET g_success  = 'N'
      RETURN
   END IF
   IF g_success = 'Y' THEN
      IF NOT p_flag THEN
         CALL cl_err('','aec-046',1)
      END IF
      RETURN
   END IF
END FUNCTION

FUNCTION i700_bom(p_level,p_sfb01,p_ecm012,p_ecm015)
DEFINE p_level  LIKE type_file.num5
DEFINE p_ecm012 LIKE ecm_file.ecm012
DEFINE p_sfb01  LIKE sfb_file.sfb01
DEFINE p_ecm015 LIKE ecm_file.ecm015
DEFINE l_ac,i   LIKE type_file.num5
DEFINE arrno    LIKE type_file.num5
DEFINE l_sql    STRING
DEFINE sr       DYNAMIC ARRAY OF RECORD
                  ecm012 LIKE ecm_file.ecm012,
                  ecm015 LIKE ecm_file.ecm015
                END RECORD
DEFINE l_tot    LIKE type_file.num5
DEFINE l_times  LIKE type_file.num5

   LET g_chr_i700 = 'Y'

   LET p_level = p_level + 1
   IF p_level=1 THEN
       LET sr[1].ecm015 = p_ecm012
   END IF

   LET arrno = 600

 WHILE TRUE
   LET l_sql="SELECT DISTINCT ecm012,ecm015 FROM ecm_file",
             " WHERE ecm01 = '",p_sfb01,"'",
             "   AND ecm015= '",p_ecm012,"'"

   PREPARE p700_pb_1 FROM l_sql
   DECLARE p700_pb_1_cs CURSOR FOR p700_pb_1
   LET l_times=1
   LET l_ac = 1
   FOREACH p700_pb_1_cs INTO sr[l_ac].*
      LET l_ac = l_ac + 1
      IF l_ac > arrno THEN
         EXIT FOREACH
      END IF
   END FOREACH

   LET l_tot = l_ac - 1
   FOR i = 1 TO l_tot
      FOR g_cnt_i700=1 TO g_max
           IF sr[i].ecm012 = p_ecm015 THEN
              CALL cl_err('','aec-047',1)
              LET g_chr_i700 = 'N'
              LET g_success = 'N'
              EXIT FOR
           END IF
      END FOR
      IF g_chr_i700 = 'N' THEN
         EXIT FOR
      END IF
      IF sr[i].ecm015 IS NOT NULL THEN
         LET g_max = g_max + 1
      END IF
      LET g_ecm012_a[g_max] = sr[i].ecm012
      CALL i700_bom(p_level,p_sfb01,sr[i].ecm012,p_ecm015)
   END FOR

   IF l_tot < arrno OR l_tot=0 THEN
      EXIT WHILE
   END IF

   END WHILE
   LET g_max = g_max - 1
END FUNCTION

FUNCTION i700sub_ecm011(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_sql     STRING
   DEFINE l_cnt     LIKE type_file.num10
   DEFINE l_cnt1    LIKE type_file.num10
   DEFINE l_ecm012  LIKE ecm_file.ecm012
   DEFINE m_ecm012  LIKE ecm_file.ecm012
   DEFINE l_ecm     DYNAMIC  ARRAY OF RECORD
            ecm01   LIKE ecm_file.ecm01,
            ecm03   LIKE ecm_file.ecm03,
            ecm012  LIKE ecm_file.ecm012,
            ecm011  LIKE ecm_file.ecm011,
            ecm015  LIKE ecm_file.ecm015
                    END RECORD
   DEFINE m_ecm     DYNAMIC  ARRAY OF RECORD
            ecm01   LIKE ecm_file.ecm01,
            ecm03   LIKE ecm_file.ecm03,
            ecm012  LIKE ecm_file.ecm012,
            ecm011  LIKE ecm_file.ecm011,
            ecm015  LIKE ecm_file.ecm015
                    END RECORD
   LET l_sql = "SELECT DISTINCT ecm012",
               "  FROM ecm_file ",
               " WHERE ecm01 = '",p_sfb01,"'",
               " ORDER BY ecm012"
   PREPARE i700_chk FROM l_sql
   DECLARE i700_chk_cs CURSOR FOR i700_chk

   LET l_sql = " SELECT ecm012 FROM ecm_file ",
               "  WHERE ecm01 ='",p_sfb01,"'",
               "    AND ecm015 = ? ",
               "  ORDER BY ecm012"
   PREPARE i700_chk_pre FROM l_sql
   DECLARE i700_chk_cs2 CURSOR FOR i700_chk_pre

   FOREACH i700_chk_cs INTO l_ecm012
      IF SQLCA.sqlcode  THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,0)
      END IF
      INITIALIZE m_ecm012 TO NULL 
      FOREACH i700_chk_cs2 USING l_ecm012 INTO m_ecm012
         IF NOT cl_null(m_ecm012) THEN
            EXIT FOREACH
         END IF
      END FOREACH   
      UPDATE ecm_file set ecm011 = m_ecm012
       WHERE ecm01 = p_sfb01 
         AND ecm012 = l_ecm012  
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ecm_file",p_sfb01,"",STATUS,"","",1)
      END IF
      INITIALIZE m_ecm012 TO NULL
   END FOREACH
END FUNCTION
#FUN-B10056
