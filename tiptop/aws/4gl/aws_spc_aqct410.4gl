# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: aws_spccli_cf()
# Descriptions...: 
# Input parameter:
#                   
# Return code....: 
# Usage .........: call aws_spc_cf(p_field,p_key1,p_key2,p_key3,p_key4,p_key5)
# Date & Author..: 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
FUNCTION aws_spccli_cf(p_filed,p_key1,p_key2,p_key3,p_key4,p_key5)
DEFINE p_filed     LIKE wcc_file.wcc02
DEFINE p_key1      LIKE wcb_file.wcb03
DEFINE p_key2      LIKE wcb_file.wcb04
DEFINE p_key3      LIKE wcb_file.wcb05
DEFINE p_key4      LIKE wcb_file.wcb06
DEFINE p_key5      LIKE wcb_file.wcb07
DEFINE l_str       STRING
DEFINE l_sfb22     LIKE sfb_file.sfb22,
       l_sfb82     LIKE sfb_file.sfb82,
       l_occ01     LIKE occ_file.occ01,
       l_qcf02     LIKE qcf_file.qcf02
      LET l_str = ""
 
      SELECT qcf02 INTO l_qcf02 FROM qcf_file where qcf01=p_key1
      CASE p_filed
           WHEN 'occ01' 
              SELECT sfb22 INTO l_sfb22 FROM sfb_file WHERE sfb01 = l_qcf02
              SELECT oea04 INTO l_occ01 FROM oea_file WHERE oea01 = l_sfb22
              LET l_str = l_occ01
           WHEN 'sfb82'
              SELECT sfb82 INTO l_sfb82 FROM sfb_file WHERE sfb01 = l_qcf02
              LET l_str = l_sfb82
      END CASE
 
      RETURN l_str
END FUNCTION
