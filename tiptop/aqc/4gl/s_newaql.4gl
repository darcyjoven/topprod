# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
##SYNTAX	CALL s_newaql(g_qcs.qcs021,g_qcs.qcs03,qcd04,p_qcs22)
##                   RETURNING ac_num,re_num
# Modify.........: No.FUN-680104 06/08/31 By Czl  類型轉換
# Modify.........: No.MOD-840147 08/04/19 By Pengu 送驗量為0時ac與re數量無法正確帶出
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-890223 08/09/23 By claire 調整CHI-860042區分委外及一般
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-930144 09/03/12 By shiwuying 判斷g_pmh21是否為NULL若是則default ' '
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.MOD-9A0026 09/10/13 By Pengu 當送驗量為小數，則Ac/Re會抓不到值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUNCTION s_newaql(p_qcs021,p_qcs03,p_qcd04,p_qcs22)          
FUNCTION s_newaql(p_qcs021,p_qcs03,p_qcd04,p_qcs22,p_pmh21,p_pmh22)    #MOD-890223      
    DEFINE p_type          LIKE qcd_file.qcd02,        #No.FUN-680104  VARCHAR(02)
           p_qcs021        LIKE qcs_file.qcs021,
           p_qcs03         LIKE qcs_file.qcs03,
           p_qcd04         LIKE qcd_file.qcd04,
           p_qcs22         LIKE qcs_file.qcs22,
           p_pmh21         LIKE pmh_file.pmh21,        #MOD-890223 add
           p_pmh22         LIKE pmh_file.pmh22,        #MOD-890223 add
           p_qty           LIKE type_file.num10,       #No.MOD-9A0026 add
           ac_num,re_num   LIKE type_file.num10        #No.FUN-680104  INTEGER
    DEFINE l_pmh09     LIKE pmh_file.pmh09,
           l_pmh15     LIKE pmh_file.pmh15,
           l_pmh16     LIKE pmh_file.pmh16,
           l_qca03     LIKE qca_file.qca03,
           l_qca04     LIKE qca_file.qca04,
           l_qca05     LIKE qca_file.qca05,
           l_qca06     LIKE qca_file.qca06,
           l_ima109    LIKE ima_file.ima109,
           l_qcb05     LIKE qcb_file.qcb05,
           l_qcb06     LIKE qcb_file.qcb06
 
    #----------No.MOD-9A0026 add
     LET p_qty = p_qcs22
     LET p_qcs22 = p_qty
    #----------No.MOD-9A0026 end
 
    #----------No.MOD-840147 add
     IF p_qcs22 = 1 THEN 
        RETURN 0,1
     END IF
    #----------No.MOD-840147 end
    SELECT ima109 INTO l_ima109 FROM ima_file WHERE ima01=p_qcs021
 
    IF cl_null(p_pmh21) THEN LET p_pmh21 = ' ' END IF #No.MOD-930144 add
 
    IF p_qcs03 IS NULL OR p_qcs03=' ' THEN
       SELECT ima100,ima101,ima102 INTO l_pmh09,l_pmh15,l_pmh16 FROM ima_file 
          WHERE ima01=p_qcs021 
       IF STATUS THEN
          LET l_pmh09='' LET l_pmh15='' LET l_pmh16='' RETURN 0,0 
       END IF
    ELSE
       DECLARE pmh_cur9 CURSOR FOR
       SELECT pmh09,pmh15,pmh16 FROM pmh_file 
          WHERE pmh01=p_qcs021 AND pmh02=p_qcs03
            AND pmh21 = p_pmh21                                          #MOD-890223                                             
            AND pmh22 = p_pmh22                                          #MOD-890223
            AND pmh23 = ' '                                              #No.CHI-960033
            AND pmhacti = 'Y'                                            #CHI-910021
            #AND pmh21 = " "                                             #CHI-860042                                                   
            #AND pmh22 = '1'                                             #CHI-860042 
       OPEN pmh_cur9
       FETCH pmh_cur9 INTO l_pmh09,l_pmh15,l_pmh16 
       IF STATUS THEN 
          SELECT pmc906,pmc905,pmc907 INTO l_pmh09,l_pmh15,l_pmh16 FROM pmc_file
             WHERE pmc01=p_qcs03
          IF STATUS THEN
             LET l_pmh09='' LET l_pmh15='' LET l_pmh16='' RETURN 0,0 
          END IF
       END IF
    END IF
    IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0,0 END IF
    IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0,0 END IF
    IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0,0 END IF
 
    IF l_pmh15='1' THEN
       SELECT qca03,qca04,qca05,qca06 
         INTO l_qca03,l_qca04,l_qca05,l_qca06
         FROM qca_file
        WHERE p_qcs22 BETWEEN qca01 AND qca02
          AND qca07=l_pmh16
       IF STATUS THEN RETURN 0,0 END IF
    END IF
    IF l_pmh15='2' THEN
       SELECT qch03,qch04,qch05,qch06 
         INTO l_qca03,l_qca04,l_qca05,l_qca06
         FROM qch_file
        WHERE p_qcs22 BETWEEN qch01 AND qch02
          AND qch07=l_pmh16
       IF STATUS THEN RETURN 0,0 END IF
    END IF
    SELECT qcb05,qcb06 INTO l_qcb05,l_qcb06 
      FROM qcb_file
     WHERE qcb01=l_pmh09 
       AND qcb02=p_qcd04 
       AND qcb03=l_qca03
    IF STATUS THEN
       RETURN 0,0     
    ELSE
       RETURN l_qcb05,l_qcb06
    END IF 
END FUNCTION
