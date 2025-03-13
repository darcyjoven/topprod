# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_control.4gl
# Descriptions...: 計算某個區間的工作日天數
# Date & Author..: 08/04/27 By Arman
# Usage..........: CALL s_control(p_bmb03,p_bmb01,p_bma06) RETURNING l_flag
# Input Parameter: p_bmb01  主件料號
# Input Parameter: p_bmb03  元件料號
# Input Parameter: p_bma06  特性代碼
# Return Code....: l_flag   1:正確 0:錯誤
# Modify.........: No.TQC-8A0063 08/10/22 By claire 重新過單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
   
 
DATABASE ds        
 
GLOBALS "../../config/top.global"   
 
FUNCTION s_control(p_bmb01,p_bmb03,p_bma06)
   DEFINE  p_bmb01     LIKE bmb_file.bmb01,
           p_bmb03     LIKE bmb_file.bmb03,
           p_bma06     LIKE bma_file.bma06,
           l_flag      LIKE type_file.num5   , 	
           l_n         LIKE type_file.num5   ,
           l_m         LIKE type_file.num5   ,
           i           LIKE type_file.num5   ,
           l_agb03     DYNAMIC ARRAY OF LIKE agb_file.agb03   
    DEFINE #g_sql       LIKE type_file.chr1000
           g_sql          STRING      #NO.FUN-910082
           
 
     LET l_n  = 0
     LET l_m  = 0
     LET i = 1
     LET l_flag  = 1
     LET g_sql = " SELECT agb03 FROM agb_file,ima_file ",
                 " WHERE agb01 = imaag AND ima01 = '",p_bmb03,"'" 
      PREPARE p_prepare FROM g_sql                               
       DECLARE p_curs                                 
         CURSOR WITH HOLD FOR p_prepare 
          FOREACH p_curs INTO l_agb03[i]                        
            IF SQLCA.sqlcode THEN                                  
               CALL s_errmsg('','','p_curs',SQLCA.sqlcode,1)
               CONTINUE FOREACH                                    
            END IF                   
            IF p_bma06 IS NULL THEN
            SELECT COUNT(*) INTO l_n FROM bmv_file WHERE bmv01 = p_bmb01 AND bmv02 = p_bmb03
                                                     AND bmv03 = ' '  AND bmv04 = l_agb03[i]
            ELSE
            SELECT COUNT(*) INTO l_n FROM bmv_file WHERE bmv01 = p_bmb01 AND bmv02 = p_bmb03
                                                     AND bmv03 = p_bma06 AND bmv04 = l_agb03[i]
            END IF
            
                       
           SELECT COUNT(*) INTO l_m FROM boc_file WHERE boc01 = p_bmb01 AND boc02 = p_bmb03
                                                    AND boc04 = l_agb03[i]
          
          IF l_m <=0 AND l_n <=0 THEN
             LET l_flag = 0 
          END IF 
          LET i = i+1
          END FOREACH
     RETURN l_flag
END FUNCTION
#TQC-8A0063
