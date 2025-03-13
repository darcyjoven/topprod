# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_ar_oox03.4gl
# Descriptions...: AR重評量計算
# Date & Author..: 05/12/19 By Carrier
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7B0055 07/11/14 By Carrier 新增s_ar_oox03_1,加入分期項次
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-950088 09/05/11 By xiaofeizhu 修改l_net的值
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_ar_oox03(p_oox03)
DEFINE p_oox03   LIKE oox_file.oox03
DEFINE l_net     LIKE oox_file.oox10
DEFINE l_oma00   LIKE oma_file.oma00
 
    LET l_net = 0
    IF g_ooz.ooz07 = 'Y' THEN                                                    
       SELECT SUM(oox10) INTO l_net FROM oox_file                                
        WHERE oox00 = 'AR' AND oox03 = p_oox03
       IF cl_null(l_net) THEN                                                    
          LET l_net = 0                                                          
       END IF 
    END IF
    SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01=p_oox03
#   IF l_oma00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF      #MOD-950088 Mark                                             
    IF l_oma00 MATCHES '2*' THEN LET l_net = l_net * ( -1) END IF      #MOD-950088
 
    RETURN l_net
END FUNCTION
 
#No.FUN-7B0055  --Begin
#加入分期項次
FUNCTION s_ar_oox03_1(p_oox03,p_oox041)
DEFINE p_oox03   LIKE oox_file.oox03
DEFINE p_oox041  LIKE oox_file.oox041
DEFINE l_net     LIKE oox_file.oox10
DEFINE l_oma00   LIKE oma_file.oma00
 
    LET l_net = 0
    IF g_ooz.ooz07 = 'Y' THEN                                                    
       SELECT SUM(oox10) INTO l_net FROM oox_file                                
        WHERE oox00 = 'AR' AND oox03 = p_oox03
          AND oox041 = p_oox041
       IF cl_null(l_net) THEN                                                    
          LET l_net = 0                                                          
       END IF 
    END IF
    SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01=p_oox03
    IF l_oma00 MATCHES '2*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
#No.FUN-7B0055  --End  
