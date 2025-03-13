# Prog. Version..: '5.30.06-13.04.02(00000)'     #
# Pattern name...: s_chk_barcode_confirm.4gl
# Descriptions...: 若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，
#                  控卡不可直接確認or過帳
# Date & Author..: No:DEV-D40015 13/04/18 By Nina
# Usage..........: CALL s_chk_barcode_confirm(p_type,p_sql)
# Input Parameter: p_type:類別(確認:'confirm',過帳:'post')
#                  p_file:掃描紀錄檔('tlfb','ibj')
#                  p_no  :單號
#                  p2   :項次(IQC用)
#                  p3   :序號(IQC用)
# Return Code....: TRUE/FALSE

DATABASE ds
GLOBALS "../../config/top.global"

FUNCTION s_chk_barcode_confirm(p_type,p_file,p_no,p2,p3)
   DEFINE p_type     LIKE    type_file.chr20
   DEFINE p_file     LIKE    type_file.chr20
   DEFINE p_no       LIKE    type_file.chr30
   DEFINE p2         LIKE    qcs_file.qcs02
   DEFINE p3         LIKE    qcs_file.qcs05
   DEFINE l_cnt      LIKE    type_file.num5

  #確認是否已有掃描紀錄
   LET l_cnt = 0
   CASE p_file
      WHEN 'tlfb'
         SELECT COUNT(*) INTO l_cnt
           FROM tlfb_file
          WHERE tlfb07 = p_no           

      WHEN 'ibj' 
         SELECT COUNT(*) INTO l_cnt
           FROM ibj_file
          WHERE ibj06 = p_no
            AND (ibj07 = p2 OR p2 IS NULL)  #FOR IQC用，故若有值才成立此條件
            AND (ibj17 = p3 OR p3 IS NULL)  #FOR IQC用，故若有值才成立此條件
       
   END CASE

   IF l_cnt = 0 THEN  #無掃描紀錄
      CASE p_type
         WHEN 'confirm'  #確認
            CALL cl_err('','aba-218',1)    #單據中含有條碼料件，需透過掃描，不可直接確認
         WHEN 'post'     #過帳
            CALL cl_err('','aba-217',1)    #單據中含有條碼料件，需透過掃描，不可直接過帳
      END CASE
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
#DEV-D40015 add
