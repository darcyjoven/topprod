# Prog. Version..: '5.30.06-13.03.21(00001)'     #
#
# Program name...: s_tlf920.4gl
# Descriptions...: 配合发出商品,出货/签收/销退/开票单据是否立账标志写入tlf920,以便计算销货收入
# Date & Author..: No.FUN-CC0157 12/12/28 by zm 
# Usage..........: CALL s_tlf920(p_type,p_no) RETURNING l_flag
# Input Parameter: p_type  类型  1.出货  2.销退  3.开票单
#                  p_no    单号
# Return Code....: l_flag  立账否Y/N
#                  l_month 期別
# Memo...........: 出货单 --- 只有签收否为N且oaz92='N',tlf920才为Y,否则为N
#                  销退单/签收单 --- 如果oaz92='N',tlf920为Y,否则为N 
#                  开票单 --- tlf920='Y'
#                  多角贸易单据---tlf920='Y'
 
DATABASE ds 
 
GLOBALS "../../config/top.global"    

FUNCTION s_tlf920(p_type,p_no)     #FUN-CC0157
DEFINE
    p_type                LIKE type_file.chr1,    	
    p_no                  LIKE oga_file.oga01,
    l_flag,l_oga65,l_oga09         LIKE type_file.chr1    
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT oaz92,oaz93 INTO g_oaz.oaz92,g_oaz.oaz93 FROM oaz_file WHERE oaz00='0'
    LET l_oga65=''   LET l_oga09=''
    IF p_type='1' THEN                       #出货单
       SELECT oga09,oga65 INTO l_oga09,l_oga65 FROM oga_file
        WHERE oga01=p_no 
       CASE WHEN l_oga09 MATCHES '[456]'     #多角贸易
                 LET l_flag = 'Y'    
            WHEN l_oga09 MATCHES '[23]'      #一般出货单/无订单出货单
                 IF l_oga65='N' AND g_oaz.oaz92='N' THEN 
                    LET l_flag = 'Y' 
                  ELSE
                    LET l_flag = 'N' 
                 END IF
            WHEN l_oga09 MATCHES '[89]'      #签收
                 IF g_oaz.oaz92='N' THEN 
                    LET l_flag='Y' 
                 ELSE
                    LET l_flag='N' 
                 END IF
       END CASE
    END IF

    IF p_type='2' THEN                       #销退单
       SELECT oha09 INTO l_oga09 FROM oha_file WHERE oha01=p_no 
       IF g_oaz.oaz92='N' THEN 
          LET l_flag='Y' 
       ELSE
          LET l_flag='N' 
       END IF
    END IF 

    IF p_type='3' THEN     #开票单
       LET l_flag='Y' 
    END IF

    RETURN l_flag

END FUNCTION 
