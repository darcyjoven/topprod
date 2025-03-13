# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_ar_oox04.4gl
# Descriptions...: AR重評量計算
# Date & Author..: 05/12/19 By Carrier
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
 
DATABASE ds
GLOBALS "../../config/top.global"
 
FUNCTION s_ar_oox04(p_oox03,p_oox04)
DEFINE p_oox03   LIKE oox_file.oox03
DEFINE p_oox04   LIKE oox_file.oox04
DEFINE l_net     LIKE oox_file.oox10
DEFINE l_oma00   LIKE oma_file.oma00
 
    LET l_net = 0
    IF g_ooz.ooz07 = 'Y' THEN                                                    
       SELECT SUM(oox10) INTO l_net FROM oox_file                                
        WHERE oox00 = 'AR' AND oox03 = p_oox03 AND oox04 = p_oox04
       IF cl_null(l_net) THEN                                                    
          LET l_net = 0                                                          
       END IF 
    END IF
    SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01=p_oox03
    IF l_oma00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
