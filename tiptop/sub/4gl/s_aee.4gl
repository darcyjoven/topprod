# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_aee.4gl
# Descriptions...: 系統傳票拋轉新增或刪除aee_file中資料
# Date & Author..: No.FUN-D40038 13/04/10 By yinhy 

DATABASE ds                                     
                                                
GLOBALS "../../config/top.global"

FUNCTION s_ins_aee(p_key,p_key1,p_bookno,p_accoutno,p_gaq01,p_glno)
   DEFINE  p_key         LIKE aee_file.aee03	# 異動碼  #
   DEFINE  p_key1        LIKE aee_file.aee02
   DEFINE  p_bookno      LIKE aee_file.aee00  # 賬別
   DEFINE  p_accoutno    LIKE aee_file.aee01  # 科目編號
   DEFINE  l_flag        LIKE type_file.chr1
   DEFINE  p_gaq01       LIKE gaq_file.gaq01  # 異動碼欄位
   DEFINE  l_ahe01       LIKE ahe_file.ahe01  # 異動碼型號代碼
   DEFINE  l_aee04       LIKE aee_file.aee04  # 異動碼說明
   DEFINE  l_cnt         LIKE type_file.num10
   DEFINE  p_glno        LIKE aee_file.aee05
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM aee_file
    WHERE aee01 = p_accoutno
      AND aee00 = p_bookno
      AND aee02 = p_key1
      AND aee03 = p_key
      IF l_cnt = 0 THEN      	 
         LET l_flag = 1
      ELSE
         LET l_flag = 0
      END IF           
      IF  l_flag = 1 THEN
          CALL s_get_ahe02(p_bookno,p_accoutno,p_key,p_gaq01) RETURNING l_ahe01,l_aee04
          INSERT INTO aee_file(aee00,aee01,aee02,aee03,aee04,aee05,aee06,aee021,
                         aeeacti,aeeuser,aeegrup,aeemodu,aeedate,aeeoriu,aeeorig)
          VALUES(p_bookno,p_accoutno,p_key1,p_key,l_aee04,p_glno,g_today,l_ahe01,
                  'Y',g_user,g_grup,'',g_today,g_user, g_grup)
      END IF
END FUNCTION

FUNCTION s_get_ahe02(p_bookno,p_aag01_str,p_aed02,p_gaq01)
	DEFINE p_bookno      LIKE aee_file.aee00  # 賬別
  DEFINE p_aag01_str     LIKE type_file.chr50
  DEFINE p_aed02         LIKE aed_file.aed02
  DEFINE p_gaq01         LIKE gaq_file.gaq01
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE l_sql1          STRING  
  DEFINE l_ahe02_d       LIKE ze_file.ze03
 
     #查找核算項值
     LET l_sql1 = " SELECT ",p_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",p_bookno,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",p_gaq01 CLIPPED," IS NOT NULL"
     PREPARE s_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE s_gaq01_cs SCROLL CURSOR FOR s_gaq01_p  #只能取第一個
 
     #取核算項名稱
     LET l_ahe01 = ' '  #No.yinhy130508
     OPEN s_gaq01_cs USING p_aag01_str
     FETCH FIRST s_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE s_gaq01_cs
        RETURN l_ahe01,' '
     END IF       
     CLOSE s_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
        SELECT ahe04,ahe05,ahe07 INTO l_ahe04,l_ahe05,l_ahe07
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
           NOT cl_null(l_ahe07) THEN
           LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                        "  FROM ",l_ahe04 CLIPPED,
                        " WHERE ",l_ahe05 CLIPPED," = '",p_aed02,"'"
           PREPARE ahe_p1 FROM l_sql1
           EXECUTE ahe_p1 INTO l_ahe02_d
        END IF
     END IF 
     IF cl_null(l_ahe01) THEN LET l_ahe01 = ' ' END IF        #No.yinhy130508
     IF cl_null(l_ahe02_d) THEN LET l_ahe02_d = ' ' END IF    #No.yinhy130508
     RETURN l_ahe01,l_ahe02_d
END FUNCTION 

FUNCTION s_del_aee(p_bookno,p_accoutno)
   DEFINE l_sql     STRING
   DEFINE l_abb     RECORD  LIKE abb_file.*
   DEFINE l_cnt             LIKE    type_file.num5
   DEFINE p_bookno          LIKE    abb_file.abb00
   DEFINE p_accoutno       LIKE    aee_file.aee05  # 传票编号 

                 
   LET l_sql = "SELECT * FROM abb_file",
               " WHERE abb01 = '",p_accoutno,"'",  #传票编号 
               "   AND abb00 = '",p_bookno,"'"
   PREPARE s_del_aee_p FROM l_sql
   IF STATUS THEN CALL cl_err('s_del_aee',STATUS,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE s_del_aee_c CURSOR FOR s_del_aee_p
    
   FOREACH s_del_aee_c INTO l_abb.*
      IF NOT cl_null(l_abb.abb11) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb11='",l_abb.abb11,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         PREPARE aee_p_abb11 FROM l_sql
         EXECUTE aee_p_abb11 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '1' AND aee03 = l_abb.abb11
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb12) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb12='",l_abb.abb12,"'",
                     "   AND abb01 <>'",p_accoutno,"'"
         
         PREPARE aee_p_abb12 FROM l_sql
         EXECUTE aee_p_abb12 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '2' AND aee03 = l_abb.abb12
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb13) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb13='",l_abb.abb13,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         PREPARE aee_p_abb13 FROM l_sql
         EXECUTE aee_p_abb13 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '3' AND aee03 = l_abb.abb13
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb14) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb14='",l_abb.abb14,"'",
                     "   AND abb01 <>'",p_accoutno,"'"
         PREPARE aee_p_abb14 FROM l_sql
         EXECUTE aee_p_abb14 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '4' AND aee03 = l_abb.abb14
               AND aee00 = p_bookno
         END IF
      END IF   
      IF NOT cl_null(l_abb.abb31) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb31='",l_abb.abb31,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         PREPARE aee_p_abb31 FROM l_sql
         EXECUTE aee_p_abb31 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '5' AND aee03 = l_abb.abb31
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb32) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb32='",l_abb.abb32,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         PREPARE aee_p_abb32 FROM l_sql
         EXECUTE aee_p_abb32 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '6' AND aee03 = l_abb.abb32
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb33) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb33='",l_abb.abb33,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         PREPARE aee_p_abb33 FROM l_sql
         EXECUTE aee_p_abb33 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '7' AND aee03 = l_abb.abb33
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb34) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb34='",l_abb.abb34,"'",
                     "   AND abb01 <>'",p_accoutno,"'"
         PREPARE aee_p_abb34 FROM l_sql
         EXECUTE aee_p_abb34 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '8' AND aee03 = l_abb.abb34
               AND aee00 = p_bookno
         END IF
      END IF 
      
      IF NOT cl_null(l_abb.abb35) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb35='",l_abb.abb35,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         LET l_cnt = 0
         PREPARE aee_p_abb35 FROM l_sql
         EXECUTE aee_p_abb35 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '9' AND aee03 = l_abb.abb35
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb36) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb36='",l_abb.abb36,"'",
                     "   AND abb01 <> '",p_accoutno,"'"
         PREPARE aee_p_abb36 FROM l_sql
         EXECUTE aee_p_abb36 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '10' AND aee03 = l_abb.abb36
               AND aee00 = p_bookno
         END IF
      END IF
      IF NOT cl_null(l_abb.abb37) THEN
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM abb_file",
                     "   WHERE abb03 ='",l_abb.abb03,"'",
                     "   AND abb00 ='",p_bookno,"'",  
                     "   AND abb37='",l_abb.abb37,"'",
                     "   AND abb01 <> '",p_accoutno,"'"          
         PREPARE aee_p_abb37 FROM l_sql
         EXECUTE aee_p_abb37 INTO l_cnt
         IF l_cnt = 0 THEN
            DELETE FROM aee_file WHERE aee01 = l_abb.abb03
               AND aee02 = '99' AND aee03 = l_abb.abb37
               AND aee00 = p_bookno
         END IF
      END IF              
   END FOREACH
END FUNCTION    
