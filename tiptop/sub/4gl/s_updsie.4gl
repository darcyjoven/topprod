# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_updsie.4gl
# Descriptions...: 更新備置明細檔
# Date & Author..: 11/04/28 by jan (FUN-AC0074)
# Modify.........: No.TQC-C30104 12/03/27 By Carrier 备置订单条件下，出货单过帐还原时，订单的oeb905备置量会出现错误

DATABASE ds

GLOBALS "../../config/top.global"  

FUNCTION s_updsie_sie(p_sfs01,p_sfs02,l_issue_flag)
DEFINE p_sfs01       LIKE sfs_file.sfs01
DEFINE p_sfs02       LIKE sfs_file.sfs02
DEFINE l_issue_flag  LIKE type_file.chr1
DEFINE l_sfs04       LIKE sfs_file.sfs04
DEFINE l_sfs07       LIKE sfs_file.sfs07
DEFINE l_sfs08       LIKE sfs_file.sfs08
DEFINE l_sfs09       LIKE sfs_file.sfs09
DEFINE l_sfs03       LIKE sfs_file.sfs03
DEFINE l_sfs10       LIKE sfs_file.sfs10
DEFINE l_sfs06       LIKE sfs_file.sfs06
DEFINE l_sfs27       LIKE sfs_file.sfs27
DEFINE l_sfs012      LIKE sfs_file.sfs012
DEFINE l_sfs013      LIKE sfs_file.sfs013
DEFINE l_sfs05       LIKE sfs_file.sfs05
DEFINE l_sic15       LIKE sic_file.sic15
DEFINE l_sif13       LIKE sif_file.sif13
DEFINE l_sia04       LIKE sia_file.sia04
DEFINE l_qty         LIKE sfs_file.sfs05
DEFINE l_sie11       LIKE sie_file.sie11
DEFINE l_sql,l_sql1,l_sql2        STRING
DEFINE l_count1,l_count2,l_count3 LIKE type_file.num5
DEFINE l_sum1,l_sum2,l_sum3       LIKE sie_file.sie11

       WHENEVER ERROR CALL cl_err_msg_log

       IF l_issue_flag = '1' THEN #發料單
          SELECT sfs04,sfs07,sfs08,sfs09,sfs03,sfs10,sfs06,sfs27,sfs012,sfs013,0,sfs05
            INTO l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,l_sfs012,l_sfs013,l_sic15,l_sfs05
            FROM sfs_file
           WHERE sfs01=p_sfs01 AND sfs02=p_sfs02
       END IF

       IF l_issue_flag = '2' THEN #出貨單
          SELECT ogb04,ogb09,ogb091,ogb092,ogb31,' ',ogb05,ogb04,' ',0,ogb32,ogb12
            INTO l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,l_sfs012,l_sfs013,l_sic15,l_sfs05
            FROM ogb_file
           WHERE ogb01=p_sfs01 AND ogb03=p_sfs02
       END IF

       IF l_issue_flag = '3' THEN  #雜發單
          SELECT inb04,inb05,inb06,inb07,inb01,' ',inb08,inb04,' ',0,inb03,inb09
            INTO l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,l_sfs012,l_sfs013,l_sic15,l_sfs05
            FROM inb_file
           WHERE inb01=p_sfs01 AND inb03=p_sfs02
       END IF

      IF l_issue_flag = '4' THEN  #調撥單
         SELECT imn03,imn04,imn05,imn06,imn01,' ',imn09,imn03,' ',0,imn02,imn10
           INTO l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,l_sfs012,l_sfs013,l_sic15,l_sfs05
           FROM imn_file
          WHERE imn01=p_sfs01 AND imn02=p_sfs02
      END IF

       LET l_count1 = 0 LET l_count2 = 0 LET l_count3 = 0
       IF l_issue_flag = '1' THEN
          LET l_sql=" SELECT COUNT(*),SUM(sie11)  FROM sie_file ",
                    " WHERE sie05= '",l_sfs03,"'",
                    "   AND sie01= '",l_sfs04,"'",
                    "   AND sie06= '",l_sfs10,"'",
                    "   AND sie07= '",l_sfs06,"'",
                    "   AND sie08= '",l_sfs27,"'",
                    "   AND sie012='",l_sfs012,"'", 
                    "   AND sie013='",l_sfs013,"'",
                    "   AND sie15 = ",l_sic15 ,  #單據項次(工單=0)
                    "   AND sie11 > 0 "
       END IF
       IF l_issue_flag MATCHES '[234]' THEN  #出貨單
          LET l_sql=" SELECT COUNT(*),SUM(sie11)  FROM sie_file ",
                    " WHERE sie05= '",l_sfs03,"'",
                    "   AND sie15= ",l_sic15 ,
                    "   AND sie01= '",l_sfs04,"'",
                    "   AND sie11 > 0 "
       END IF
       PREPARE s_updsie_sie_p1 FROM l_sql
       DECLARE s_updsie_sie_c1 CURSOR FOR s_updsie_sie_p1
       OPEN s_updsie_sie_c1
       FETCH s_updsie_sie_c1 INTO l_count1,l_sum1
       IF l_count1 = 0 THEN RETURN END IF
       IF l_count1 > 0 THEN
          LET l_sql1 = l_sql CLIPPED," AND sie02 = '",l_sfs07,"'",
                                     " AND sie03 = '",l_sfs08,"'",
                                     " AND sie04 = '",l_sfs09,"'"
          PREPARE s_updsie_sie_p2 FROM l_sql1
          DECLARE s_updsie_sie_c2 CURSOR FOR s_updsie_sie_p2
          OPEN s_updsie_sie_c2
          FETCH s_updsie_sie_c2 INTO l_count2,l_sum2
          LET l_sql2 = l_sql CLIPPED," AND sie02 = ' ' ",
                                     " AND sie03 = '",l_sfs08,"'",
                                     " AND sie04 = '",l_sfs09,"'"
          PREPARE s_updsie_sie_p3 FROM l_sql2
          DECLARE s_updsie_sie_c3 CURSOR FOR s_updsie_sie_p3
          OPEN s_updsie_sie_c3
          FETCH s_updsie_sie_c3 INTO l_count3,l_sum3
          IF l_count2>0 AND l_count3=0 THEN
             IF l_sum2 <= l_sfs05 THEN
               #LET l_sie11=0
                LET l_sif13=l_sum2 LET l_sia04='1'
             ELSE
               #LET l_sie11=l_sum2-l_sfs05
                LET l_sif13=l_sfs05 LET l_sia04='1'
             END IF 
             CALL s_updsie_upd_sie(l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                  l_sfs012,l_sfs013,l_sif13,p_sfs01,p_sfs02,l_sic15) 
             IF g_success = 'Y' THEN
                CALL s_updsie_upd_sig(l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sif13)
                IF g_success = 'Y' THEN
                   CALL s_updsie_ins_sif(l_sia04,l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                      p_sfs01,p_sfs02,l_sif13,l_sic15,l_sfs012,l_sfs013)
                END IF
             END IF            
          END IF
          IF l_count2=0 AND l_count3 > 0 THEN 
             IF l_sum3 <= l_sfs05 THEN
               #LET l_sie11=0
                LET l_sif13=l_sum3 LET l_sia04='1'
             ELSE
               #LET l_sie11=l_sum3-l_sfs05
                LET l_sif13=l_sfs05 LET l_sia04='1'
             END IF
             CALL s_updsie_upd_sie(l_sfs04,' ',l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                  l_sfs012,l_sfs013,l_sif13,p_sfs01,p_sfs02,l_sic15)
             IF g_success = 'Y' THEN
                CALL s_updsie_upd_sig(l_sfs04,' ',l_sfs08,l_sfs09,l_sif13)
                IF g_success = 'Y' THEN
                   CALL s_updsie_ins_sif(l_sia04,l_sfs04,' ',l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27, 
                                      p_sfs01,p_sfs02,l_sif13,l_sic15,l_sfs012,l_sfs013)
                END IF
             END IF 
          END IF
          IF l_count2>0 AND l_count3>0 THEN
             IF l_sum2 >= l_sfs05 THEN
               #LET l_sie11=l_sum2 - l_sfs05
                LET l_sif13=l_sfs05  LET l_sia04='1'
                CALL s_updsie_upd_sie(l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27, 
                                  l_sfs012,l_sfs013,l_sif13,p_sfs01,p_sfs02,l_sic15)
                IF g_success = 'Y' THEN
                   CALL s_updsie_upd_sig(l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sif13)
                   IF g_success = 'Y' THEN
                      CALL s_updsie_ins_sif(l_sia04,l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                      p_sfs01,p_sfs02,l_sif13,l_sic15,l_sfs012,l_sfs013)
                   END IF
                END IF                 
             ELSE
                LET l_sif13=l_sum2  LET l_sia04='1'
                CALL s_updsie_upd_sie(l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                  l_sfs012,l_sfs013,l_sif13,p_sfs01,p_sfs02,l_sic15)
                IF g_success = 'Y' THEN
                   CALL s_updsie_upd_sig(l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sif13)
                   IF g_success = 'Y' THEN
                      CALL s_updsie_ins_sif(l_sia04,l_sfs04,l_sfs07,l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                        p_sfs01,p_sfs02,l_sif13,l_sic15,l_sfs012,l_sfs013)
                   END IF
                END IF
                LET l_qty=l_sfs05 - l_sum2
                IF l_sum3 < l_qty THEN
                  #LET l_sie11 = 0
                   LET l_sif13 = l_sum3 LET l_sia04='1'
                ELSE 
                  #LET l_sie11 = l_sum3 - l_qty
                   LET l_sif13 = l_qty  LET l_sia04='2'
                END IF
                CALL s_updsie_upd_sie(l_sfs04,' ',l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                      l_sfs012,l_sfs013,l_sif13,p_sfs01,p_sfs02,l_sic15)
                IF g_success = 'Y' THEN
                   CALL s_updsie_upd_sig(l_sfs04,' ',l_sfs08,l_sfs09,l_sif13)
                   IF g_success = 'Y' THEN
                      CALL s_updsie_ins_sif(l_sia04,l_sfs04,' ',l_sfs08,l_sfs09,l_sfs03,l_sfs10,l_sfs06,l_sfs27,
                                      p_sfs01,p_sfs02,l_sif13,l_sic15,l_sfs012,l_sfs013)
                   END IF
                END IF
             END IF
          END IF        
          IF g_success = 'Y' AND l_issue_flag = '2' AND NOT cl_null(l_sfs03) THEN
             SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sfs03 AND sie15=l_sic15
             IF cl_null(l_sie11) THEN LET l_sie11=0 END IF
             UPDATE oeb_file SET oeb905=l_sie11 WHERE oeb01=l_sfs03 AND oeb03=l_sic15
          END IF
       END IF 
END FUNCTION
  
FUNCTION s_updsie_upd_sie(p_sie01,p_sie02,p_sie03,p_sie04,p_sie05,p_sie06,p_sie07,
                         p_sie08,p_sie012,p_sie013,p_sif13,p_sie13,p_sie14,p_sie15)
DEFINE p_sie01    LIKE sie_file.sie01
DEFINE p_sie02    LIKE sie_file.sie02
DEFINE p_sie03    LIKE sie_file.sie03
DEFINE p_sie04    LIKE sie_file.sie04
DEFINE p_sie05    LIKE sie_file.sie05
DEFINE p_sie06    LIKE sie_file.sie06
DEFINE p_sie07    LIKE sie_file.sie07
DEFINE p_sie08    LIKE sie_file.sie08
DEFINE p_sie012   LIKE sie_file.sie012
DEFINE p_sie013   LIKE sie_file.sie013
DEFINE p_sif13    LIKE sif_file.sif13
DEFINE p_sie13    LIKE sie_file.sie13
DEFINE p_sie14    LIKE sie_file.sie14
DEFINE p_sie15    LIKE sie_file.sie15

   UPDATE sie_file SET sie11=sie11 - p_sif13,sie12 = g_today, 
                       sie13 = p_sie13,sie14 =p_sie14 
    WHERE sie01 = p_sie01 
      AND sie02 = p_sie02
      AND sie03 = p_sie03
      AND sie04 = p_sie04 
      AND sie05 = p_sie05
      AND sie06 = p_sie06
      AND sie07 = p_sie07  
      AND sie08 = p_sie08
      AND sie15 = p_sie15
      AND sie012= p_sie012 
      AND sie013= p_sie013
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","sie_file",p_sie01,p_sie02,SQLCA.sqlcode,"","up sie11",1)
      LET g_success = 'N'             
   END IF  
END FUNCTION

FUNCTION s_updsie_upd_sig(p_sig01,p_sig02,p_sig03,p_sig04,p_sif13)
DEFINE p_sig01        LIKE sig_file.sig01
DEFINE p_sig02        LIKE sig_file.sig02
DEFINE p_sig03        LIKE sig_file.sig03
DEFINE p_sig04        LIKE sig_file.sig04
DEFINE p_sif13        LIKE sif_file.sif13
DEFINE l_sig05        LIKE sig_file.sig05
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_sum1         LIKE sig_file.sig05
 
    LET l_cnt = 0 
    SELECT COUNT(*),SUM(sig05) INTO l_cnt,l_sum1 
      FROM sig_file 
     WHERE sig01 = p_sig01 AND sig02 = p_sig02
       AND sig03 = p_sig03 AND sig04 = p_sig04
       AND sig05 > 0 
    IF l_cnt > 0 THEN 
       IF l_sum1 >= p_sif13 THEN 
          LET l_sig05=l_sum1 - p_sif13
       ELSE
          LET l_sig05=0
       END IF
       UPDATE sig_file SET sig05 =l_sig05,sig07 = g_today
        WHERE sig01 = p_sig01 AND sig02 = p_sig02
          AND sig03 = p_sig03 AND sig04 = p_sig04
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","sig_file",p_sig01,p_sig02,SQLCA.sqlcode,"","up sig05",1)
          LET g_success = 'N'             
       END IF
    END IF
 
END FUNCTION
  
#FUN-A20048 --begin 
FUNCTION s_updsie_ins_sif(p_sia04,p_sif01,p_sif02,p_sif03,p_sif04,p_sif05,p_sif06,p_sif07,p_sif08,
                         p_sif11,p_sif12,p_sif13,p_sif15,p_sif012,p_sif013)
 DEFINE p_sia04      LIKE sia_file.sia04
 DEFINE l_sif        RECORD LIKE sif_file.*
 DEFINE p_sif01      LIKE sif_file.sif01
 DEFINE p_sif02      LIKE sif_file.sif02
 DEFINE p_sif03      LIKE sif_file.sif03
 DEFINE p_sif04      LIKE sif_file.sif04
 DEFINE p_sif05      LIKE sif_file.sif05
 DEFINE p_sif06      LIKE sif_file.sif06
 DEFINE p_sif07      LIKE sif_file.sif07
 DEFINE p_sif08      LIKE sif_file.sif08
 DEFINE p_sif11      LIKE sif_file.sif11
 DEFINE p_sif12      LIKE sif_file.sif12
 DEFINE p_sif13      LIKE sif_file.sif13
 DEFINE p_sif15      LIKE sif_file.sif15
 DEFINE p_sif012     LIKE sif_file.sif012
 DEFINE p_sif013     LIKE sif_file.sif013

 INITIALIZE l_sif.* TO NULL
      CASE p_sia04
  WHEN '1'  #備置
     LET l_sif.sif09=1
  WHEN '2'  #退備置
     LET l_sif.sif09=-1
      END CASE 
  LET l_sif.sif01 = p_sif01
  LET l_sif.sif02 = p_sif02
  LET l_sif.sif03 = p_sif03
  LET l_sif.sif04 = p_sif04
  LET l_sif.sif05 = p_sif05
  LET l_sif.sif06 = p_sif06
  LET l_sif.sif07 = p_sif07
  LET l_sif.sif08 = p_sif08
  LET l_sif.sif10 = g_today
  LET l_sif.sif11 = p_sif11
  LET l_sif.sif12 = p_sif12
  LET l_sif.siflegal = g_legal
  LET l_sif.sifplant = g_plant
  LET l_sif.sif13 = p_sif13  
  LET l_sif.sif012 = p_sif012
  LET l_sif.sif013 = p_sif013
  LET l_sif.sif15  = p_sif15
  IF cl_null(l_sif.sif012) THEN
     LET l_sif.sif012 = ' '
  END IF
  IF cl_null(l_sif.sif013) THEN
     LET l_sif.sif013 = 0 
  END IF

  INSERT INTO sif_file VALUES(l_sif.*)
  IF STATUS THEN
     CALL cl_err3("ins","sif_file",l_sif.sif11,l_sif.sif12,STATUS,"","ins sif",1) 
     LET g_success='N' 
     RETURN
  END IF
END FUNCTION  
  
FUNCTION s_updsie_unsie(p_sfs01,p_sfs02,p_issue_flag)
DEFINE p_sfs01     LIKE sfs_file.sfs01
DEFINE p_sfs02     LIKE sfs_file.sfs02
DEFINE l_sql       STRING
DEFINE l_sif       RECORD LIKE sif_file.*
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_sie11     LIKE sie_file.sie11
DEFINE p_issue_flag LIKE type_file.chr1

   LET l_sql = " SELECT * FROM sif_file ",
               "  WHERE sif11 = '",p_sfs01,"'",
               "    AND sif12 = '",p_sfs02,"'"
   PREPARE s_updsie_sif_p1 FROM l_sql
   DECLARE s_updsie_sif_c1 CURSOR FOR s_updsie_sif_p1
   FOREACH s_updsie_sif_c1 INTO l_sif.* 
      UPDATE sie_file SET sie11=sie11+l_sif.sif13,sie12 = g_today,
                          sie13=p_sfs01,sie14=p_sfs02 
       WHERE sie01=l_sif.sif01 AND sie02=l_sif.sif02
         AND sie03=l_sif.sif03 AND sie04=l_sif.sif04
         AND sie05=l_sif.sif05 AND sie06=l_sif.sif06
         AND sie07=l_sif.sif07 AND sie08=l_sif.sif08
         AND sie012=l_sif.sif012 AND sie013=l_sif.sif013
         AND sie15=l_sif.sif15
      IF SQLCA.sqlcode THEN
         LET g_success='N' 
         CALL cl_err3("upd","sie_file",p_sfs01,p_sfs02,SQLCA.sqlcode,"","upd sie11",1)
         RETURN
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM sie_file
       WHERE sie01=l_sif.sif01 AND sie02=l_sif.sif02
         AND sie03=l_sif.sif03 AND sie04=l_sif.sif04
         AND sie05=l_sif.sif05 AND sie06=l_sif.sif06
         AND sie07=l_sif.sif07 AND sie08=l_sif.sif08
         AND sie15=l_sif.sif15 AND sie11 > sie09
         AND sie012=l_sif.sif012 AND sie013=l_sif.sif013
      IF l_cnt > 0 THEN 
         CALL cl_err('','',1)
         LET g_success = 'N'
         RETURN 
      END IF
         
      UPDATE sig_file SET sig05=sig05+l_sif.sif13,sig07=g_today
       WHERE sig01=l_sif.sif01 AND sig02=l_sif.sif02
         AND sig03=l_sif.sif03 AND sig04=l_sif.sif04
      IF SQLCA.sqlcode THEN
         LET g_success='N' 
         CALL cl_err3("upd","sig_file",l_sif.sif01,l_sif.sif02,SQLCA.sqlcode,"","upd sig05",1)
         RETURN
      END IF
      DELETE FROM sif_file WHERE sif01=l_sif.sif01
                             AND sif02=l_sif.sif02
                             AND sif03=l_sif.sif03
                             AND sif04=l_sif.sif04
                             AND sif05=l_sif.sif05
                             AND sif06=l_sif.sif06
                             AND sif07=l_sif.sif07
                             AND sif08=l_sif.sif08
                             AND sif11=p_sfs01
                             AND sif12=p_sfs02
                             AND sif15=l_sif.sif15
                             AND sif012=l_sif.sif012 
                             AND sif013=l_sif.sif013
      IF SQLCA.sqlcode THEN
         LET g_success='N' 
         CALL cl_err3("del","sif_file",l_sif.sif01,l_sif.sif02,SQLCA.sqlcode,"","del sif",1)
         RETURN
      END IF
      IF p_issue_flag = '2' THEN
         #No.TQC-C30104  --Begin
         #SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sfs03 AND sie15=l_sic15
         SELECT SUM(sie11) INTO l_sie11 FROM sie_file WHERE sie05=l_sif.sif05 AND sie15=l_sif.sif15
         IF cl_null(l_sie11) THEN LET l_sie11=0 END IF
         #UPDATE oeb_file SET oeb905=l_sie11 WHERE oeb01=l_sfs03 AND oeb03=l_sic15
         UPDATE oeb_file SET oeb905=l_sie11 WHERE oeb01=l_sif.sif05 AND oeb03=l_sif.sif15
         #No.TQC-C30104  --End  
      END IF
   END FOREACH
END FUNCTION
#FUN-AC0074
