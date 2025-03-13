# Prog. Version..: '5.30.06-13.03.12(00001)'     #
##DESCRIPTION 求得年初投资比例以及本期投资比例	
#DAte & Author..: 11/03/07 By lutingting
# Modify........: NO.FUN-B40104 11/05/05 By jll
DATABASE ds

GLOBALS "../../config/top.global"


FUNCTION s_get_aeo14_1(p_aen03,p_aen05,p_aeo06,p_aen01,p_aen02)   #p_aen03:族群编号   
                                                  #p_aen05:上层公司编号  #p_aeo06 下层公司编号
                                                  #p_aen01:年度          #p_aen02  月份
                                                  #RETURNING  ps_aeo14_1  年初投资比率
DEFINE p_aen03 LIKE aen_file.aen03
DEFINE p_aen05 LIKE aen_file.aen05
DEFINE p_aeo06 LIKE aeo_file.aeo06
DEFINE p_aen01 LIKE aen_file.aen01
DEFINE p_aen02 LIKE aen_file.aen02
DEFINE l_axz05 LIKE axz_file.axz05   #帐别
DEFINE ps_aeo14_1 LIKE aeo_file.aeo14
DEFINE l_axd00 LIKE axd_file.axd00
DEFINE l_min_axd00 LIKE axd_file.axd00

    WHENEVER ERROR CONTINUE
    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_aen05
    SELECT MAX(axd00) INTO l_axd00 FROM axd_file,axc_file
     WHERE axc06 = axd00 AND axc01 = axd01
       AND axc02 = axd02 AND axc03 = axd03
       AND axd01 = p_aen03 AND axd02 = p_aen05
       AND axd03 = l_axz05
       AND axd04a = p_aeo06
       AND YEAR(axd00)<= p_aen01-1
       AND axcconf = 'Y'
    IF NOT cl_null(l_axd00) THEN   #有调整
       SELECT axd07a INTO ps_aeo14_1 FROM axd_file,axc_file   #调整后
        WHERE axc06 = axd00 AND axc01 = axd01
          AND axc02 = axd02 AND axc03 = axd03
          AND axd01 = p_aen03 AND axd02 = p_aen05
          AND axd03 = l_axz05 AND axd00 = l_axd00
          AND axd04a = p_aeo06
          AND axcconf = 'Y'
    ELSE
       ####本次调整年度前没有做调整,则抓取本年最早一次调整前的比率
       SELECT MIN(axd00) INTO l_min_axd00 FROM axd_file,axc_file
        WHERE axc06 = axd00 AND axc01 = axd01
          AND axc02 = axd02 AND axc03 = axd03
          AND axd01 = p_aen03 AND axd02 = p_aen05
          AND axd03 = l_axz05
          AND axd04b = p_aeo06
          AND YEAR(axd00)= p_aen01
          AND axcconf = 'Y'
       IF NOT cl_null(l_min_axd00) THEN   #本年有调整
          SELECT axd07b INTO ps_aeo14_1 FROM axd_file,axc_file   #调整前
           WHERE axc06 = axd00 AND axc01 = axd01
             AND axc02 = axd02 AND axc03 = axd03
             AND axd01 = p_aen03 AND axd02 = p_aen05
             AND axd03 = l_axz05 AND axd00 = l_min_axd00
             AND axd04b = p_aeo06
             AND axcconf = 'Y' 
       ELSE    ###本年之前或者本年都没有做过调整
          SELECT axb07 INTO ps_aeo14_1 FROM axb_file
           WHERE axb01 = p_aen03 AND axb02 = p_aen05 AND axb04 = p_aeo06
       END IF 
    END IF 
    RETURN ps_aeo14_1
END FUNCTION
FUNCTION s_get_aeo14(p_aen03,p_aen05,p_aeo06,p_aen01,p_aen02)   #p_aen03:族群编号
                                                  #p_aen05:上层公司编号  #p_aeo06 下层公司编号
                                                  #p_aen01:年度          #p_aen02  月份
                                                  #RETURNING  ps_aeo14  年初投资比率
DEFINE p_aen03 LIKE aen_file.aen03
DEFINE p_aen05 LIKE aen_file.aen05
DEFINE p_aeo06 LIKE aeo_file.aeo06
DEFINE p_aen01 LIKE aen_file.aen01
DEFINE p_aen02 LIKE aen_file.aen02
DEFINE l_axz05 LIKE axz_file.axz05   #帐别
DEFINE ps_aeo14 LIKE aeo_file.aeo14
DEFINE l_axd00 LIKE axd_file.axd00

    WHENEVER ERROR CONTINUE
    SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01 = p_aen05
    SELECT MAX(axd00) INTO l_axd00 FROM axd_file,axc_file
     WHERE axc06 = axd00 AND axc01 = axd01
       AND axc02 = axd02 AND axc03 = axd03
       AND axd01 = p_aen03 AND axd02 = p_aen05
       AND axd03 = l_axz05
       AND axd04a = p_aeo06
       AND YEAR(axd00)<= p_aen01
       AND MONTH(axd00)<=p_aen02
       AND axcconf = 'Y'
    IF STATUS = 100 OR cl_null(l_axd00) THEN
       SELECT axb07 INTO ps_aeo14 FROM axb_file
        WHERE axb01 = p_aen03 AND axb02 = p_aen05 AND axb04 = p_aeo06
    ELSE
       SELECT axd07a INTO ps_aeo14 FROM axd_file,axc_file
        WHERE axc06 = axd00 AND axc01 = axd01
          AND axc02 = axd02 AND axc03 = axd03
          AND axd01 = p_aen03 AND axd02 = p_aen05
          AND axd03 = l_axz05 AND axd00 = l_axd00
          AND axd04a = p_aeo06
          AND axcconf = 'Y'
    END IF
    RETURN ps_aeo14
END FUNCTION
#NO.FUN-B40104
