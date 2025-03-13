# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_bkprice.4gl
# DESCRIPTIONS...: 若走 Blanket PO 流程，則單價認定依參數設定(sma113)
# Date & Author..: 03/05/21 By Kammy
# Usage..........: LET l_price,lt_price=s_bkprice(p_price1,p_price1t,p_price2,p_price2t)
# Input PARAMETER: p_price1        採購單價       (由s_defprice取出)
#                  p_price1t       採購含稅單價   (由s_defprice取出)
#                  p_price2        Blanket PO 單價(由 apmt580  取出)
#                  p_price2t       Blanket PO 含稅單價(由 apmt580  取出)
# RETURN Code....: l_price,lt_price 未稅單價,含稅單價 
# Modify.........: No.FUN-610018 06/01/06 By ice 傳入值增加兩個,回傳值增加含稅單價
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_bkprice(p_price1,p_price1t,p_price2,p_price2t)  #No.FUN-610018
DEFINE p_price1  LIKE pmn_file.pmn31
DEFINE p_price1t LIKE pmn_file.pmn31t   #No.FUN-610018
DEFINE p_price2  LIKE pon_file.pon31
DEFINE p_price2t LIKE pon_file.pon31t   #No.FUN-610018
DEFINE l_price   LIKE pon_file.pon31
DEFINE lt_price  LIKE pon_file.pon31t   #No.FUN-610018
 
   CASE g_sma.sma113
     WHEN '1' LET l_price = p_price2               #使用 Blank PO 單價
              LET lt_price= p_price2t              #No.FUN-610018
     WHEN '2' LET l_price = p_price1               #使用 PO 單價
              LET lt_price= p_price1t              #No.FUN-610018
     WHEN '3' IF p_price2 > p_price1 THEN          #取低者
                 LET l_price = p_price1
                 LET lt_price= p_price1t           #No.FUN-610018
              ELSE
                 LET l_price = p_price2
                 LET lt_price= p_price2t           #No.FUN-610018
              END IF
   END CASE
   RETURN l_price,lt_price                         #No.FUN-610018
END FUNCTION
