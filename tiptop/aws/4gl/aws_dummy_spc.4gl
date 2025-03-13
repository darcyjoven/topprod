# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#Link用
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定

IMPORT com   #FUN-720042
IMPORT os   #No.FUN-9C0009  
DATABASE ds
#FUN-720042
 
GLOBALS "../4gl/aws_efgw.inc"
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_efgpgw.inc"         #No.FUN-710010
GLOBALS "../4gl/aws_crossgw.inc"        #No:FUN-B20029
DEFINE g_efsoap      STRING
DEFINE g_wse         RECORD LIKE wse_file.*
DEFINE g_wsf         RECORD LIKE wsf_file.*
DEFINE g_wsi         RECORD LIKE wsi_file.*
DEFINE g_wap         RECORD LIKE wap_file.*
DEFINE g_wse03       LIKE wse_file.wse03
DEFINE g_wse04       LIKE wse_file.wse04
DEFINE g_wse05       LIKE wse_file.wse05
DEFINE g_wse06       LIKE wse_file.wse06
DEFINE g_wse07       LIKE wse_file.wse07

FUNCTION aws_spccli_cf(p_filed,p_key1,p_key2,p_key3,p_key4,p_key5)
DEFINE p_filed     STRING
DEFINE p_key1      STRING
DEFINE p_key2      STRING
DEFINE p_key3      STRING
DEFINE p_key4      STRING
DEFINE p_key5      STRING
 
  RETURN ''
END FUNCTION
