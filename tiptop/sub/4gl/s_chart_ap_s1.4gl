# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_ap_s1.4gl
# Descriptions...: 各賬款類別應付帳款比例
# Date & Author..: No.FUN-BA0095 2011/11/19 By qiaozy
# Input Parameter: p_ym       年月
#                  p_deptno   部門編號
#                  p_empno    請款人員
#                  p_payment  付款方式
#                  p_vendno   付款廠商            
#                  p_loc      圖表位置
# Usage..........: CALL s_chart_ap_s1(p_ym,p_deptno,p_empno,p_payment,p_vendno,p_loc)
# Modify.........: 

DATABASE ds
GLOBALS "../../config/top.global"

FUNCTION s_chart_ap_s1(p_ym,p_deptno,p_empno,p_payment,p_vendno,p_loc)
DEFINE p_ym             LIKE type_file.chr6 
DEFINE p_deptno         LIKE apa_file.apa22
DEFINE p_empno          LIKE apa_file.apa21
DEFINE p_payment        LIKE pma_file.pma11
DEFINE p_vendno         LIKE apa_file.apa06
DEFINE p_loc            LIKE type_file.chr10
DEFINE l_sql            STRING
DEFINE l_apa36          LIKE apa_file.apa36 #賬款類別
DEFINE l_apa34          LIKE apa_file.apa34
DEFINE l_apr02          LIKE apr_file.apr02 #類別說明
DEFINE l_apa_str        STRING
DEFINE l_substr         STRING
DEFINE l_gem02          LIKE gem_file.gem02 #部門名稱
DEFINE l_gen02          LIKE gen_file.gen02 #人員名稱
DEFINE l_pma02          LIKE pma_file.pma02 #付款方式說明
DEFINE l_pmc03          LIKE pmc_file.pmc03 #付款廠商說明
DEFINE l_chk_auth        STRING


    WHENEVER ERROR CONTINUE
    CALL cl_chart_init(p_loc)

    IF NOT s_chart_auth("s_chart_ap_s1",g_user) THEN
       LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
       CALL cl_chart_set_empty(p_loc, l_chk_auth)
       RETURN
    END IF


    #
    LET l_apa34=0
    INITIALIZE l_apa36 TO NULL
    
    LET l_sql=" SELECT apa36,SUM(apa34-apa35) ",
              "   FROM apa_file",
              "   LEFT OUTER JOIN pma_file ON pma01 = apa11",
              "  WHERE apa34 > apa35",
              "    AND apa41 = 'Y'",
              "    AND ",cl_tp_tochar('apa02','YYYYMM')," ='",p_ym,"'"
    IF NOT cl_null(p_deptno) THEN LET l_sql=l_sql CLIPPED," AND apa22 = '",p_deptno,"' " END IF
    IF NOT cl_null(p_empno)  THEN LET l_sql=l_sql CLIPPED," AND apa21 = '",p_empno,"' " END IF
    IF NOT cl_null(p_payment) THEN LET l_sql=l_sql CLIPPED," AND pma11 = '",p_payment,"' " END IF
    IF NOT cl_null(p_vendno) THEN LET l_sql=l_sql CLIPPED," AND apa06 = '",p_vendno,"' " END IF
    LET l_sql=l_sql CLIPPED," GROUP BY apa36"
    PREPARE amount_money_pre FROM l_sql
    DECLARE amount_money_cs CURSOR FOR amount_money_pre
    FOREACH amount_money_cs INTO l_apa36,l_apa34
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       INITIALIZE l_apr02,l_apa_str TO NULL
       SELECT apr02 INTO l_apr02 FROM apr_file WHERE apr01=l_apa36
       IF NOT cl_null(l_apr02) THEN
          LET l_apa_str=l_apa36 CLIPPED,"(",l_apr02 CLIPPED,")"
       ELSE
          LET l_apa_str=l_apa36 CLIPPED
       END IF
       CALL cl_chart_array_data(p_loc,"dataset",l_apa_str,l_apa34)
       INITIALIZE l_apa36 TO NULL
       LET l_apa34=0
    END FOREACH
    INITIALIZE l_substr TO NULL
    LET l_substr = cl_getmsg('azz1133',g_lang),":",p_ym  #年月
    IF NOT cl_null(p_deptno) THEN
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=p_deptno
       LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1134',g_lang),":",p_deptno CLIPPED,"(",l_gem02,")"  #部門名稱
    END IF
    IF NOT cl_null( p_empno ) THEN 
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = p_empno
       LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1128',g_lang),":",p_empno CLIPPED,"(",l_gen02,")" #請款人員
    END IF
    IF NOT cl_null( p_payment ) THEN 
       SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01=p_payment
       LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1129',g_lang),":",p_payment CLIPPED,"(",l_pma02,")"  #付款方式
    END IF
    IF NOT cl_null( p_vendno ) THEN 
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=p_vendno
       LET l_substr = l_substr CLIPPED," / ",cl_getmsg('azz1130',g_lang),":",p_vendno CLIPPED,"(",l_pmc03,")"  #付款廠商
    END IF
    IF NOT cl_null(l_substr) THEN
       CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
    END IF
    CALL cl_chart_create(p_loc,"s_chart_ap_s1") 
    CALL cl_chart_clear(p_loc)   

    
    
END FUNCTION

#FUN-BA0095
