# Prog. Version..: '5.30.03-12.09.18(00007)'     #
#
# Pattern name...: ghrp084.4gl
# Descriptions...: 排班批处理作业
# Date & Author..: 13/08/27 By jiangxt

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE l_bdate  LIKE type_file.dat
DEFINE l_edate  LIKE type_file.dat
DEFINE g_bgjob  LIKE type_file.chr1
DEFINE l_hrca14  LIKE hrca_file.hrca14

MAIN
   OPTIONS
       INPUT NO WRAP 
   DEFER INTERRUPT	       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_bgjob = ARG_VAL(1)
   LET l_bdate = ARG_VAL(2)
   LET l_edate = ARG_VAL(3)
   LET l_hrca14 = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN 
      SELECT MAX(hrdq05)+1 INTO l_bdate FROM hrdq_file
      LET l_edate=g_today+45
   END IF 
   IF g_bgjob = 'G' THEN
      LET l_bdate = g_today
      LET l_edate = g_today + 100
   END IF
   CALL p084()
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p084()
DEFINE l_hrca     RECORD LIKE hrca_file.*
DEFINE l_sql      STRING 
DEFINE l_hrcb05   LIKE hrcb_file.hrcb05
DEFINE l_num      LIKE type_file.num10
DEFINE l_hrdq01   LIKE hrdq_file.hrdq01
DEFINE l_hrdq06   LIKE hrdq_file.hrdq06
DEFINE l_hrdq     RECORD LIKE hrdq_file.*
DEFINE l_flag     LIKE type_file.chr1

#      DELETE FROM hrdq_file WHERE hrdq05>=l_bdate  #删除旧记录
      
#      LET l_sql="SELECT * FROM hrca_file ",
#                " WHERE hrca12>='",l_bdate,"'",
#                "   AND hrca11<='",l_edate,"'",
#                " ORDER BY hrca01"

#add by yinbq 20140923
      LET l_sql="SELECT * FROM hrca_file ",
                " WHERE hrca12>='",l_bdate,"'",
                "   AND hrca11<='",l_edate,"'"
      IF NOT cl_null(l_hrca14) THEN 
         LET l_sql = l_sql," AND hrca14 = '",l_hrca14,"'"
      END IF 
      LET l_sql = l_sql," ORDER BY hrca01"
#add by yinbq 20140923

      PREPARE ins_hrca_p FROM l_sql
      DECLARE ins_hrca_c CURSOR FOR ins_hrca_p
      FOREACH ins_hrca_c INTO l_hrca.*
         FOR l_num=l_bdate TO l_edate 
            LET l_flag='Y'
            LET l_hrdq01=''
            LET l_hrdq.hrdq05=l_num
            IF l_hrdq.hrdq05<l_hrca.hrca11 THEN 
               CONTINUE FOR 
            END IF 
            IF l_hrdq.hrdq05>l_hrca.hrca12 THEN 
               CONTINUE FOR 
            END IF 
         SELECT hrdq01,hrdq06 INTO l_hrdq01,l_hrdq06 FROM hrdq_file WHERE hrdq02=l_hrca.hrca02 AND hrdq03=l_hrca.hrca14 AND hrdq05=l_hrdq.hrdq05
         IF cl_null(l_hrdq01) THEN 
            LET l_flag='N'
            SELECT MAX(hrdq01)+1 INTO l_hrdq01 FROM hrdq_file
            IF cl_null(l_hrdq01) THEN LET l_hrdq01=1 END IF 
            LET l_hrdq.hrdq01=l_hrdq01 USING '&&&&&&&&&&'
         END IF 
            LET l_hrdq.hrdq02=l_hrca.hrca02
            LET l_hrdq.hrdq03=l_hrca.hrca14
            LET l_hrdq.hrdq04=l_hrca.hrca15
#add by yinbq 20141225 for 调整逻辑使班次展开的参照日历不根据公司编号去取，而是根据每个排班规则上设置的行事例编号去取
#            CASE l_hrca.hrca02
#              WHEN '1' SELECT hrat03 INTO l_hrdq.hrdq11 FROM hrat_file WHERE hratid=l_hrdq.hrdq03
#              WHEN '2' SELECT hrao00 INTO l_hrdq.hrdq11 FROM hrao_file WHERE hrao01=l_hrdq.hrdq03
#               WHEN '3' LET l_hrdq.hrdq11=l_hrdq.hrdq03
#              WHEN '4' SELECT hrcb05 INTO l_hrcb05 FROM hrcb_file
#                        WHERE hrcb01=l_hrdq.hrdq03 AND hrcb06<=l_hrdq.hrdq05
#                          AND hrcb07>=l_hrdq.hrdq05 AND rownum=1
#                       SELECT hrat03 INTO l_hrdq.hrdq11 FROM hrat_file WHERE hratid=l_hrcb05
#            END CASE
             LET l_hrdq.hrdq11=l_hrca.hrcaud02 
#add by yinbq 20141225 for 调整逻辑使班次展开的参照日历不根据公司编号去取，而是根据每个排班规则上设置的行事例编号去取
            IF cl_null(l_hrdq.hrdq11) THEN 
               LET l_hrdq.hrdq11='0000'
            END IF            
            SELECT hrbk05,hrbk04 INTO l_hrdq.hrdq12,l_hrdq.hrdq13 FROM hrbk_file
             WHERE hrbk01=l_hrdq.hrdq11 AND hrbk03=l_hrdq.hrdq05
             
            IF l_hrca.hrca03='1' THEN 
               IF (l_hrdq.hrdq12='002' AND l_hrca.hrca08='Y')
               OR (l_hrdq.hrdq12='003' AND l_hrca.hrca09='Y') THEN 
                  LET l_hrdq.hrdq06=l_hrca.hrca10
               ELSE 
                  LET l_hrdq.hrdq06=l_hrca.hrca04
               END IF 
               LET l_hrdq.hrdq08='N'
               LET l_hrdq.hrdq09=''
               LET l_hrdq.hrdq10=''
            ELSE
               CALL p084_get_hrdq(l_hrca.hrca05,l_hrca.hrca06,l_hrca.hrca07,l_hrca.hrca08,l_hrca.hrca09,l_hrca.hrca10,
                                  l_hrca.hrca11,l_hrdq.hrdq03,l_hrdq.hrdq05,l_hrdq.hrdq12) 
                 RETURNING l_hrdq.hrdq08,l_hrdq.hrdq09,l_hrdq.hrdq10,l_hrdq.hrdq06
            END IF 
            SELECT hrbo03 INTO l_hrdq.hrdq07 FROM hrbo_file WHERE hrbo02=l_hrdq.hrdq06
            IF l_flag = 'N' THEN 
               INSERT INTO hrdq_file VALUES (l_hrdq.*)
            ELSE 
               UPDATE hrdq_file SET 
                  hrdq02=l_hrdq.hrdq02,
                  hrdq03=l_hrdq.hrdq03, 
                  hrdq04=l_hrdq.hrdq04, 
                  hrdq05=l_hrdq.hrdq05, 
                  hrdq06=l_hrdq.hrdq06, 
                  hrdq07=l_hrdq.hrdq07, 
                  hrdq08=l_hrdq.hrdq08, 
                  hrdq09=l_hrdq.hrdq09, 
                  hrdq10=l_hrdq.hrdq10, 
                  hrdq11=l_hrdq.hrdq11, 
                  hrdq12=l_hrdq.hrdq12, 
                  hrdq13=l_hrdq.hrdq13 
               WHERE hrdq01=l_hrdq01
               IF l_hrdq06 != l_hrdq.hrdq06 THEN
                  IF l_hrdq.hrdq02 = '4' THEN  
                     UPDATE  hrcp_file SET hrcp35 = 'N'  WHERE EXISTS (SELECT 1 FROM hrcb_file WHERE hrcb05=hrcp02 AND hrcp03 BETWEEN hrcb06 AND hrcb07 AND hrcb01=l_hrdq.hrdq03) AND hrcp03=l_hrdq.hrdq05
                  END IF 
                  IF l_hrdq.hrdq02 = '1' THEN
                      UPDATE  hrcp_file SET hrcp35 = 'N'  WHERE hrcp02 = l_hrdq.hrdq03 AND hrcp03 = l_hrdq.hrdq05
                  END IF 
                  IF l_hrdq.hrdq02 = '2' THEN 
                     UPDATE hrcp_file SET hrcp35 = 'N'  WHERE EXISTS (SELECT 1 FROM hrat_file WHERE hratid=hrcp02 AND hrat04=l_hrdq.hrdq03) AND hrcp03=l_hrdq.hrdq05
                  END IF 
                  IF  l_hrdq.hrdq02 = '3' THEN 
                     UPDATE hrcp_file SET hrcp35 = 'N'  WHERE EXISTS (SELECT 1 FROM hrat_file WHERE hratid=hrcp02 AND hrat03=l_hrdq.hrdq03) AND hrcp03=l_hrdq.hrdq05
                  END IF 
               END IF 
            END IF 
         END FOR 
      END FOREACH
            INSERT INTO HRCP_FILE
        (HRCP01, HRCP02, HRCP03, HRCP04, HRCP05,HRCP35,HRCPACTI)
        SELECT NVL((SELECT MAX(HRCP01) FROM HRCP_FILE),0) + ROWNUM COL1, HRATID, HRBK03, ' ' HRCP04, ' ' HRCP05,'N','Y'
          FROM HRAT_FILE
          LEFT JOIN HRBK_FILE ON HRBK01 = HRAT03
       #    LEFT JOIN HRBK_FILE ON HRBK01 = '0000'
         WHERE HRBK03 BETWEEN HRAT25 AND NVL(HRAT77, TRUNC(SYSDATE))
           AND NOT EXISTS (SELECT 1 FROM HRCP_FILE WHERE HRCP02 = HRATID AND HRCP03 = HRBK03)
           AND HRBK03 BETWEEN TRUNC(SYSDATE) - 30 AND TRUNC(SYSDATE) + 1 
END FUNCTION 

FUNCTION p084_get_hrdq(p_hrca05,p_hrca06,p_hrca07,p_hrca08,p_hrca09,p_hrca10,p_hrca11,p_hrdq03,p_hrdq05,p_hrdq12)
DEFINE p_hrdq03  LIKE hrdq_file.hrdq03
DEFINE p_hrdq05  LIKE hrdq_file.hrdq05
DEFINE p_hrdq12  LIKE hrdq_file.hrdq12
DEFINE p_hrca05  LIKE hrca_file.hrca05
DEFINE p_hrca06  LIKE hrca_file.hrca06
DEFINE p_hrca07  LIKE hrca_file.hrca07
DEFINE p_hrca08  LIKE hrca_file.hrca08
DEFINE p_hrca09  LIKE hrca_file.hrca09
DEFINE p_hrca10  LIKE hrca_file.hrca10
DEFINE p_hrca11  LIKE hrca_file.hrca11
DEFINE l_hrbp05  LIKE hrbp_file.hrbp05
DEFINE p_hrdq06  LIKE hrdq_file.hrdq06
DEFINE p_hrdq08  LIKE hrdq_file.hrdq08
DEFINE p_hrdq09  LIKE hrdq_file.hrdq09
DEFINE p_hrdq10  LIKE hrdq_file.hrdq10
DEFINE l_hrbpa01 LIKE hrbpa_file.hrbpa01
DEFINE l_minus   LIKE type_file.num5
DEFINE l_count   LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_p       LIKE type_file.num5
DEFINE l_q       LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5

    SELECT hrbp05 INTO l_hrbp05 FROM hrbp_file WHERE hrbp02=p_hrca05
    IF l_hrbp05='1' THEN 
       IF (p_hrdq12='002' AND p_hrca08='Y') OR (p_hrdq12='003' AND p_hrca09='Y') THEN 
          LET p_hrdq06=p_hrca10
       ELSE 
          SELECT count(*) INTO l_count FROM hrbpa_file WHERE hrbpa05=p_hrca05
          LET l_hrbpa01 = p_hrca06   #SELECT hrbpa01 INTO l_hrbpa01 FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa02=p_hrca06
          LET l_minus=p_hrdq05-p_hrca11
          SELECT MOD(l_minus,l_count) INTO l_i FROM dual
          IF p_hrca07='2' THEN
             IF p_hrca08='Y' THEN 
                SELECT count(*) INTO l_p FROM hrdq_file WHERE hrdq12='002' AND hrdq03=p_hrdq03 AND hrdq05>=p_hrca11 AND hrdq05<p_hrdq05 
             ELSE LET l_p=0
             END IF 
             IF p_hrca09='Y' THEN 
                SELECT count(*) INTO l_q FROM hrdq_file WHERE hrdq12='003' AND hrdq03=p_hrdq03 AND hrdq05>=p_hrca11 AND hrdq05<p_hrdq05
             ELSE LET l_q=0 
             END IF 
             LET l_n=l_p+l_q
             SELECT MOD(l_n,l_count) INTO l_n FROM dual
             LET l_n=l_count-l_n
          ELSE LET l_n=0
          END IF 
          LET l_hrbpa01=l_hrbpa01+l_i+l_n
          SELECT MOD(l_hrbpa01,l_count) INTO l_i FROM dual
          IF l_i=0 THEN 
             LET l_i=l_count
          END IF
          SELECT hrbpa02 INTO p_hrdq06 FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa01=l_i
       END IF
       LET p_hrdq08='N'
       LET p_hrdq09=''
       LET p_hrdq10=''
    ELSE
       LET p_hrdq08='Y'
       IF (p_hrdq12='002' AND p_hrca08='Y') OR (p_hrdq12='003' AND p_hrca09='Y') THEN 
          LET p_hrdq06='2'
          LET p_hrdq09=''
          LET p_hrdq10=''
       ELSE 
          SELECT count(*) INTO l_count FROM hrbpa_file WHERE hrbpa05=p_hrca05
          SELECT hrbpa01 INTO l_hrbpa01 FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa02=p_hrca06
          LET l_minus=p_hrdq05-p_hrca11
          SELECT MOD(l_minus,l_count) INTO l_i FROM dual
          IF p_hrca07='2' THEN
             IF p_hrca08='Y' THEN 
                SELECT count(*) INTO l_p FROM hrdq_file WHERE hrdq12='002' AND hrdq03=p_hrdq03 AND hrdq05>=p_hrca11 AND hrdq05<p_hrdq05
             ELSE LET l_p=0
             END IF 
             IF p_hrca09='Y' THEN 
                SELECT count(*) INTO l_q FROM hrdq_file WHERE hrdq12='003' AND hrdq03=p_hrdq03 AND hrdq05>=p_hrca11 AND hrdq05<p_hrdq05
             ELSE LET l_q=0 
             END IF 
             LET l_n=l_p+l_q
             SELECT MOD(l_n,l_count) INTO l_n FROM dual
             LET l_n=l_count-l_n
          ELSE LET l_n=0
          END IF 
          LET l_hrbpa01=l_hrbpa01+l_i+l_n
          SELECT MOD(l_hrbpa01,l_count) INTO l_i FROM dual
          IF l_i=0 THEN 
             LET l_i=l_count
          END IF
          SELECT hrbpa02,hrbpa03 INTO p_hrdq09,p_hrdq10
            FROM hrbpa_file WHERE hrbpa05=p_hrca05 AND hrbpa01=l_i
          SELECT hrbza02 INTO p_hrdq06 FROM hrbza_file 
           WHERE hrbza05=p_hrdq09 AND hrbza01=1
       END IF 
    END IF 

    RETURN p_hrdq08,p_hrdq09,p_hrdq10,p_hrdq06
END FUNCTION 
