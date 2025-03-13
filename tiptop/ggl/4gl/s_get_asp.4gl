# Prog. Version..: '5.30.06-13.03.12(00001)'     #
##DESCRIPTION 求得年初投资比例以及本期投资比例	
#DAte & Author..: 11/03/07 By lutingting
# Modify........: NO.FUN-B40104 11/05/05 By jll
# Modify........: NO.TQC-BC0046 11/12/08 By lilingyu 重新過單
# Modify........: NO.FUN-BB0036 12/02/10 By lilingyu 重新過單

DATABASE ds

GLOBALS "../../config/top.global"          #TQC-BC0046   #FUN-BB0036


FUNCTION s_get_asp14_1(p_aso03,p_aso05,p_asp06,p_aso01,p_aso02)   #p_aso03:族群编号   
                                                  #p_aso05:上层公司编号  #p_asp06 下层公司编号
                                                  #p_aso01:年度          #p_aso02  月份
                                                  #RETURNING  ps_asp14_1  年初投资比率
DEFINE p_aso03 LIKE aso_file.aso03
DEFINE p_aso05 LIKE aso_file.aso05
DEFINE p_asp06 LIKE asp_file.asp06
DEFINE p_aso01 LIKE aso_file.aso01
DEFINE p_aso02 LIKE aso_file.aso02
DEFINE l_asg05 LIKE asg_file.asg05   #帐别
DEFINE ps_asp14_1 LIKE asp_file.asp14
DEFINE l_asd00 LIKE asd_file.asd00
DEFINE l_min_asd00 LIKE asd_file.asd00

    WHENEVER ERROR CONTINUE
    SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01 = p_aso05
    SELECT MAX(asd00) INTO l_asd00 FROM asd_file,asc_file
     WHERE asc06 = asd00 AND asc01 = asd01
       AND asc02 = asd02 AND asc03 = asd03
       AND asd01 = p_aso03 AND asd02 = p_aso05
       AND asd03 = l_asg05
       AND asd04a = p_asp06
       AND YEAR(asd00)<= p_aso01-1
       AND ascconf = 'Y'
    IF NOT cl_null(l_asd00) THEN   #有调整
       SELECT asd07a INTO ps_asp14_1 FROM asd_file,asc_file   #调整后
        WHERE asc06 = asd00 AND asc01 = asd01
          AND asc02 = asd02 AND asc03 = asd03
          AND asd01 = p_aso03 AND asd02 = p_aso05
          AND asd03 = l_asg05 AND asd00 = l_asd00
          AND asd04a = p_asp06
          AND ascconf = 'Y'
    ELSE
       ####本次调整年度前没有做调整,则抓取本年最早一次调整前的比率
       SELECT MIN(asd00) INTO l_min_asd00 FROM asd_file,asc_file
        WHERE asc06 = asd00 AND asc01 = asd01
          AND asc02 = asd02 AND asc03 = asd03
          AND asd01 = p_aso03 AND asd02 = p_aso05
          AND asd03 = l_asg05
          AND asd04b = p_asp06
          AND YEAR(asd00)= p_aso01
          AND ascconf = 'Y'
       IF NOT cl_null(l_min_asd00) THEN   #本年有调整
          SELECT asd07b INTO ps_asp14_1 FROM asd_file,asc_file   #调整前
           WHERE asc06 = asd00 AND asc01 = asd01
             AND asc02 = asd02 AND asc03 = asd03
             AND asd01 = p_aso03 AND asd02 = p_aso05
             AND asd03 = l_asg05 AND asd00 = l_min_asd00
             AND asd04b = p_asp06
             AND ascconf = 'Y' 
       ELSE    ###本年之前或者本年都没有做过调整
          SELECT asb07 INTO ps_asp14_1 FROM asb_file
           WHERE asb01 = p_aso03 AND asb02 = p_aso05 AND asb04 = p_asp06
       END IF 
    END IF 
    RETURN ps_asp14_1
END FUNCTION
FUNCTION s_get_asp14(p_aso03,p_aso05,p_asp06,p_aso01,p_aso02)   #p_aso03:族群编号
                                                  #p_aso05:上层公司编号  #p_asp06 下层公司编号
                                                  #p_aso01:年度          #p_aso02  月份
                                                  #RETURNING  ps_asp14  年初投资比率
DEFINE p_aso03 LIKE aso_file.aso03
DEFINE p_aso05 LIKE aso_file.aso05
DEFINE p_asp06 LIKE asp_file.asp06
DEFINE p_aso01 LIKE aso_file.aso01
DEFINE p_aso02 LIKE aso_file.aso02
DEFINE l_asg05 LIKE asg_file.asg05   #帐别
DEFINE ps_asp14 LIKE asp_file.asp14
DEFINE l_asd00 LIKE asd_file.asd00

    WHENEVER ERROR CONTINUE
    SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01 = p_aso05
    SELECT MAX(asd00) INTO l_asd00 FROM asd_file,asc_file
     WHERE asc06 = asd00 AND asc01 = asd01
       AND asc02 = asd02 AND asc03 = asd03
       AND asd01 = p_aso03 AND asd02 = p_aso05
       AND asd03 = l_asg05
       AND asd04a = p_asp06
       AND YEAR(asd00)<= p_aso01
       AND MONTH(asd00)<=p_aso02
       AND ascconf = 'Y'
    IF STATUS = 100 OR cl_null(l_asd00) THEN
       SELECT asb07 INTO ps_asp14 FROM asb_file
        WHERE asb01 = p_aso03 AND asb02 = p_aso05 AND asb04 = p_asp06
    ELSE
       SELECT asd07a INTO ps_asp14 FROM asd_file,asc_file
        WHERE asc06 = asd00 AND asc01 = asd01
          AND asc02 = asd02 AND asc03 = asd03
          AND asd01 = p_aso03 AND asd02 = p_aso05
          AND asd03 = l_asg05 AND asd00 = l_asd00
          AND asd04a = p_asp06
          AND ascconf = 'Y'
    END IF
    RETURN ps_asp14
END FUNCTION
#NO.FUN-B40104
