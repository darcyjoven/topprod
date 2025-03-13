# Prog. Version..: '5.30.07-13.05.16(00000)'     #
##□ s_post
##SYNTAX        CALL gglq307_aee04(p_bookno,p_accno,p_seq,p_aee03)
##DESCRIPTION        輸入帳別,科目,核算項次,核算項值
##PARAMETERS       p_bookno    帳別
##                 p_accno     科目編號
##                 p_seq       核算項次序
##                 p_aee03     核算項值
##No.FUN-9A0052
# Modify.........: No.FUN-A40020 10/04/13 By Carrier 加入出错方式处理
# Modify.........: No.FUN-D50053 13/05/16 By lujh   統制科目的核算項名稱沒有顯示出來

DATABASE ds

GLOBALS "../../config/top.global"  #No.FUN-9A0052

FUNCTION gglq307_aee04(p_bookno,p_accno,p_seq,p_aee03)
   DEFINE p_bookno     LIKE aaa_file.aaa01
   DEFINE p_accno      LIKE aag_file.aag01
   DEFINE p_seq        LIKE type_file.chr2
   DEFINE p_aee03      LIKE aee_file.aee03
   DEFINE p_aee04      LIKE aee_file.aee04
   DEFINE l_ahe        RECORD LIKE ahe_file.*
   DEFINE l_ahe01      LIKE ahe_file.ahe01
   DEFINE l_sql        STRING
   DEFINE l_aeh01_str  LIKE type_file.chr50    #FUN-D50053 add
   DEFINE l_aag01      LIKE aag_file.aag01     #FUN-D50053 add     

   WHENEVER ERROR CALL cl_err_msg_log  #No.FUN-A40020

   IF p_bookno IS NULL OR p_accno IS NULL OR p_seq IS NULL OR p_aee03 IS NULL THEN
      RETURN NULL
   END IF

   LET p_aee04=' '
   LET l_aeh01_str = p_accno CLIPPED,'\%'   #FUN-D50053 add
   CASE p_seq
       #FUN-D50053--mark-str--
       #WHEN '1'
       #     SELECT aag15 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno   
       #WHEN '2'
       #     SELECT aag16 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '3'
       #     SELECT aag17 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '4'
       #     SELECT aag18 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '5'
       #     SELECT aag31 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno
       #WHEN '6'
       #     SELECT aag32 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno
       #WHEN '7'
       #     SELECT aag33 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '8'
       #     SELECT aag34 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '9'
       #     SELECT aag35 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '10'
       #     SELECT aag36 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #WHEN '99'
       #     SELECT aag37 INTO l_ahe01 FROM aag_file WHERE aag00=p_bookno AND aag01 LIKE p_accno 
       #FUN-D50053--mark-end--

       #FUN-D50053--add-str--
       WHEN '1'
             LET l_sql = "SELECT aag01,aag15  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '2'
             LET l_sql = "SELECT aag01,aag16  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '3'
             LET l_sql = "SELECT aag01,aag17  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '4'
             LET l_sql = "SELECT aag01,aag18  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '5'
             LET l_sql = "SELECT aag01,aag31  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '6'
             LET l_sql = "SELECT aag01,aag32  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '7'
             LET l_sql = "SELECT aag01,aag33  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '8'
             LET l_sql = "SELECT aag01,aag34  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '9'
             LET l_sql = "SELECT aag01,aag35  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '10'
             LET l_sql = "SELECT aag01,aag36  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
        WHEN '99'
             LET l_sql = "SELECT aag01,aag37  FROM aag_file WHERE aag00= '", p_bookno,"'",
                         " AND aag01 LIKE  '",l_aeh01_str,"'",
                         " AND aag07 IN ('2','3')"
       #FUN-D50053--add-end--
   END CASE
   #FUN-D50053--add--str--
   PREPARE gglq307_aee04_prepare FROM l_sql
   DECLARE gglq307_aee04_cs CURSOR FOR  gglq307_aee04_prepare
   FOREACH gglq307_aee04_cs INTO l_aag01,l_ahe01
   #FUN-D50053--add--end--
      SELECT * INTO l_ahe.* FROM ahe_file WHERE ahe01=l_ahe01
      IF l_ahe.ahe03='2' THEN
         SELECT aee04 INTO p_aee04 FROM aee_file
          WHERE aee01=l_aag01 AND aee02=p_seq AND aee03=p_aee03 AND aee00=p_bookno
      END IF
      IF l_ahe.ahe03='1' THEN
         IF cl_null(l_ahe.ahe07) OR cl_null(l_ahe.ahe04) OR cl_null(l_ahe.ahe05) OR cl_null(p_aee03) THEN
            #RETURN NULL
            CONTINUE FOREACH  #FUN-D50053 add
         END IF
         LET l_sql = " SELECT UNIQUE ", l_ahe.ahe07," FROM ",l_ahe.ahe04,  #No.FUN-A40020
                     "  WHERE ", l_ahe.ahe05," = '",p_aee03,"'"
         PREPARE aee_pre FROM l_sql
         DECLARE aee_curs SCROLL CURSOR FOR aee_pre                        #No.FUN-A40020
         OPEN aee_curs
         FETCH FIRST aee_curs INTO p_aee04                                 #No.FUN-A40020 
         CLOSE aee_curs
      END IF
   #FUN-D50053--add--str--
      IF NOT cl_null(p_aee04) THEN     
         EXIT FOREACH                  
         RETURN p_aee04
      END IF  
   END FOREACH
   #FUN-D50053--add--end--
   RETURN p_aee04
END FUNCTION
