# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: s_tag.4gl
# Descriptions...: 結轉時取得對應年度的帳套及科目編號
# Date & Author..: No.MOD-740358 07/04/24 By Carrier
# Usage..........: CALL s_tag(p_year,p_aag00,p_aag01) RETURNING l_aag00,l_aag01
# Input Parameter: p_year		會計年度
#                  p_aag00      舊帳套
#                  p_aag01      舊科目
# Return Code....: l_aag00      新帳套
#                  l_aag01      新科目
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-C10223 12/02/03 By Polly 增加地區別判斷，大陸地區才需做轉換
# Modify.........: No.CHI-C20023 12/03/12 By Lori 增加tag06(使用時點)的判斷
 
DATABASE ds        #No.MOD-740358
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_tag(p_year,p_aag00,p_aag01)
   DEFINE  
           p_year     LIKE type_file.num5,   	
           p_aag00    LIKE aag_file.aag00,
           p_aag01    LIKE aag_file.aag01,
           l_aag00    LIKE aag_file.aag00,
           l_aag01    LIKE aag_file.aag01
 
  WHENEVER ERROR CALL cl_err_msg_log

  IF g_aza.aza26 = '2' THEN                       #MOD-C10223 add 
     SELECT tag04,tag05 INTO l_aag00,l_aag01
       FROM tag_file
      WHERE tag01 = p_year
        AND tag02 = p_aag00
        AND tag03 = p_aag01
        AND tag06 = '2'          #CHI-C20023
     IF cl_null(l_aag00) THEN LET l_aag00 = p_aag00 END IF
     IF cl_null(l_aag01) THEN LET l_aag01 = p_aag01 END IF
     RETURN l_aag00,l_aag01
  ELSE                                        #MOD-C10223 add
     RETURN p_aag00,p_aag01                   #MOD-C10223 add
  END IF                                      #MOD-C10223 add
 
END FUNCTION
