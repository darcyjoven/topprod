# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##SYNTAX	CALL s_chkaql(p_type,g_qcx.qcx021,g_qcx.qcx03,p_qcs22)
##                   RETURNING ma_num1,ma_num2,mi_num1,mi_num2
##DESCRIPTION   找出MA及MI的AC,RE
# Modify.........:No.FUN-680104   06/09/04 By Czl  類型轉換
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_chkaql(p_type,p_qcs021,p_qcs03,p_qcs22,p_curr)
    DEFINE p_type          LIKE aba_file.aba18,                         #No.FUN-680104  VARCHAR(02)
           p_qcs021        LIKE qcs_file.qcs021,
           p_qcs03         LIKE qcs_file.qcs03,
           p_qcs22         LIKE qcs_file.qcs22,
           p_curr          LIKE pmm_file.pmm22,
           ma_num1,ma_num2,mi_num1,mi_num2  LIKE type_file.num10        #No.FUN-680104 INTEGER
    DEFINE l_pmh09     LIKE pmh_file.pmh09,
           l_pmh15     LIKE pmh_file.pmh15,
           l_qcd02     LIKE qcd_file.qcd02,
           l_qcd03     LIKE qcd_file.qcd03,
           l_qca03     LIKE qca_file.qca03,
           l_qca04     LIKE qca_file.qca04,
           l_qca05     LIKE qca_file.qca05,
           l_qca06     LIKE qca_file.qca06,
           l_ima109    LIKE ima_file.ima109,
           l_qcb05     LIKE qcb_file.qcb05,
           l_qcb06     LIKE qcb_file.qcb06
 
    SELECT ima109 INTO l_ima109 FROM ima_file WHERE ima01=p_qcs021
 
    SELECT pmh09,pmh15 INTO l_pmh09,l_pmh15 FROM pmh_file 
       WHERE pmh01=p_qcs021 AND pmh02=p_qcs03 AND pmh13=p_curr
         AND pmh21 = " "                                             #CHI-860042                                                    
         AND pmh22 = '1'                                             #CHI-860042
         AND pmh23 = ' '                                             #No.CHI-960033
         AND pmhacti = 'Y'                                           #CHI-910021
    IF STATUS THEN
       SELECT pmc906,pmc905 INTO l_pmh09,l_pmh15 FROM pmc_file
          WHERE pmc01=p_qcs03
       IF STATUS THEN LET l_pmh09='' LET l_pmh15='' RETURN 0 END IF
    END IF
    IF l_pmh09 IS NOT NULl AND l_pmh15 IS NOT NULL THEN
       SELECT qcd02,qcd03 INTO l_qcd02,l_qcd03 FROM qcd_file
          WHERE qcd01=l_ima109
       IF STATUS THEN 
          LET l_qcd02='' LET l_qcd03='' RETURN 0,0,0,0    
       ELSE
          IF l_pmh15='1' THEN
             SELECT qca03,qca04,qca05,qca06 
               INTO l_qca03,l_qca04,l_qca05,l_qca06
               FROM qca_file
              WHERE p_qcs22 BETWEEN qca01 AND qca02
             IF STATUS THEN RETURN 0,0,0,0 END IF
          END IF
          IF l_pmh15='2' THEN
             SELECT qch03,qch04,qch05,qch06 
               INTO l_qca03,l_qca04,l_qca05,l_qca06
               FROM qch_file
              WHERE p_qcs22 BETWEEN qch01 AND qch02
             IF STATUS THEN RETURN 0,0,0,0 END IF
          END IF
       END IF
       CASE p_type
            WHEN 'MA'
                 SELECT qcb05,qcb06 INTO l_qcb05,l_qcb06 
                   FROM qcb_file
                  WHERE qcb01=l_pmh09 
                    AND qcb02=l_qcd02
                    AND qcb03=l_qca03
                 IF STATUS THEN
                    RETURN 0,0,0,0     
                 ELSE
                    RETURN l_qcb05,l_qcb06,0,0
                 END IF 
            WHEN 'MI'
                 SELECT qcb05,qcb06 INTO l_qcb05,l_qcb06 
                   FROM qcb_file
                  WHERE qcb01=l_pmh09 
                    AND qcb02=l_qcd03
                    AND qcb03=l_qca03
                 IF STATUS THEN
                    RETURN 0,0,0,0     
                 ELSE
                    RETURN 0,0,l_qcb05,l_qcb06
                 END IF 
       END CASE
    ELSE
       RETURN 0,0,0,0     
    END IF
END FUNCTION
