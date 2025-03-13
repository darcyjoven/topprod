# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
##SYNTAX	CALL s_newaql(g_qcs.qcs021,g_qcs.qcs03,qcd04,p_qcs22)
##                   RETURNING ac_num,re_num
# Modify.........: No.TQC-7A0073 07/10/21 By xufeng 類型轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0026 09/10/13 By Pengu 當送驗量為小數，則Ac/Re會抓不到值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_newaql_1(p_qcs021,p_qcs03,p_qcd04,p_qcs22)          
    DEFINE p_type          LIKE qcd_file.qcd02,        #No.FUN-680104  VARCHAR(02)
           p_qcs021        LIKE qcs_file.qcs021,
           p_qcs03         LIKE qcs_file.qcs03,        #No.TQC-7A0073
           p_qcd04         LIKE qcd_file.qcd04,
           p_qcs22         LIKE qcs_file.qcs22,
           p_qty           LIKE type_file.num10,       #No.MOD-9A0026 add
           ac_num,re_num   LIKE type_file.num10        #No.FUN-680104  INTEGER
    DEFINE l_obk12     LIKE obk_file.obk12,
           l_obk13     LIKE obk_file.obk13,
           l_obk14     LIKE obk_file.obk14,
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
    SELECT ima109 INTO l_ima109 FROM ima_file WHERE ima01=p_qcs021
 
    IF p_qcs03 IS NULL OR p_qcs03=' ' THEN
       SELECT ima100,ima101,ima102 INTO l_obk12,l_obk13,l_obk14 FROM ima_file 
          WHERE ima01=p_qcs021 
       IF STATUS THEN
          LET l_obk12='' LET l_obk13='' LET l_obk14='' RETURN 0,0 
       END IF
    ELSE
       DECLARE obk_cur9 CURSOR FOR
       SELECT obk12,obk13,obk14 FROM obk_file 
          WHERE obk01=p_qcs021 AND obk02=p_qcs03
       OPEN obk_cur9
       FETCH obk_cur9 INTO l_obk12,l_obk13,l_obk14 
       IF STATUS THEN 
          LET l_obk12='' LET l_obk13='' LET l_obk14='' RETURN 0,0 
       END IF
    END IF
    IF l_obk12 IS NULL OR l_obk12=' ' THEN RETURN 0,0 END IF
    IF l_obk13 IS NULL OR l_obk13=' ' THEN RETURN 0,0 END IF
    IF l_obk14 IS NULL OR l_obk14=' ' THEN RETURN 0,0 END IF
 
    IF l_obk13='1' THEN
       SELECT qca03,qca04,qca05,qca06 
         INTO l_qca03,l_qca04,l_qca05,l_qca06
         FROM qca_file
        WHERE p_qcs22 BETWEEN qca01 AND qca02
          AND qca07=l_obk14
       IF STATUS THEN RETURN 0,0 END IF
    END IF
    IF l_obk13='2' THEN
       SELECT qch03,qch04,qch05,qch06 
         INTO l_qca03,l_qca04,l_qca05,l_qca06
         FROM qch_file
        WHERE p_qcs22 BETWEEN qch01 AND qch02
          AND qch07=l_obk14
       IF STATUS THEN RETURN 0,0 END IF
    END IF
    SELECT qcb05,qcb06 INTO l_qcb05,l_qcb06 
      FROM qcb_file
     WHERE qcb01=l_obk12 
       AND qcb02=p_qcd04 
       AND qcb03=l_qca03
    IF STATUS THEN
       RETURN 0,0     
    ELSE
       RETURN l_qcb05,l_qcb06
    END IF 
END FUNCTION
