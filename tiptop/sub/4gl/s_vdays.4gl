# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_vdays.4gl
# Descriptions...: 庫存明細有效天數計算
# Date & Author..: 92/06/20 By Wu 
# Usage..........: CALL s_vdays(p_part,p_ware,p_loc,p_lot) RETURNING l_days
# Input Parameter: p_part   料號
#                  p_ware   倉庫別
#                  p_loc    存放位置
#                  p_lot    批號
# Return code....: l_days   有效天數
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_vdays(p_part,p_ware,p_location,p_lots)
   DEFINE  p_part          LIKE img_file.img01,
           p_ware          LIKE img_file.img02,
           p_location      LIKE img_file.img03,
           p_lots          LIKE img_file.img04,
           l_img18         LIKE img_file.img18,
           l_days          LIKE type_file.num10  	#No.FUN-680147 INTEGER
 
   SELECT img18 INTO l_img18 FROM img_file 
               WHERE img01 = p_part  AND img02 = p_ware AND
                     img03 = p_location AND img04 = p_lots
   LET l_days = g_today - l_img18
   RETURN l_days 
END FUNCTION
