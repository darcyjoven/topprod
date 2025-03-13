# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_du_umfchk.4gl
# Descriptions...: 兩單位間之轉換率計算與檢查(Just For 雙單位)
# Date & Author..: 05/03/16 By Carrier FUN-540022
# Usage..........: CALL s_du_umfchk(p_item,p_ware,p_lot,p_loc,p_img09,p_unit,p_n)
#                  RETURNING l_fac
# Input Parameter: p_item  料件
#                  p_ware  倉庫
#                  p_lot   儲位
#                  p_loc   批號
#                  p_img09 目的單位
#                  p_unit  來源單位
#                  p_n     1.子單位(第一單位)  2.母單位  3.參考單位
# Return code....: l_errno errno
#                  l_fac   轉換率
# Memo...........: ex. s_du_umfchk('C001','','','','PCS','DOT','1')  #只傳單位
#                  ex. s_du_umfchk('C001','1001','','','','DOT','2') #用倉儲批來select img09
#                  p_n 1.子單位一定要與img09有換算率
#                      2.母單位一定要與img09有換算率
#                      3.參考單位不一定要與img09有換算率
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-920081 09/02/06 By chenyu l_factor欄位放大
# Modify.........: No:MOD-970011 09/11/27 By sabrina 調整l_factor變數資料型態
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_du_umfchk(p_item,p_ware,p_lot,p_loc,p_img09,p_unit,p_n)
    DEFINE  p_item     LIKE img_file.img01, #No.MOD-490217
           p_ware     LIKE img_file.img02,
           p_lot      LIKE img_file.img03,
           p_loc      LIKE img_file.img04,
           p_img09    LIKE img_file.img09,
           p_unit     LIKE img_file.img09,
           p_n        LIKE type_file.chr1,           #No.FUN-680147 VARCHAR(01)
           l_errno    LIKE cre_file.cre08,           #No.FUN-680147 VARCHAR(10)
           l_flag     LIKE type_file.num5,           #No.FUN-680147 SMALLINT
          #l_factor   LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(16,8)
          #l_factor   LIKE ima_file.ima31_fac,       #No.MOD-920081 add     #MOD-970011 mark
           l_factor   LIKE type_file.num26_10,       #No.MOD-970011 add
           l_su       LIKE oeb_file.oeb12,           #No.FUN-680147 DECIMAL(16,8)  #來源單位兌換數量
           l_tu       LIKE oeb_file.oeb12            #No.FUN-680147 DECIMAL(16,8)  #目的單位兌換數量
 
     LET l_errno = ''
     #....加入MISC的判斷
     IF p_item[1,4]='MISC' THEN RETURN l_errno,1.0 END IF
     #無料號
     IF cl_null(p_item) THEN LET l_errno = 'aim-701' RETURN l_errno,0 END IF
     #倉庫與目的單位均為空
     IF cl_null(p_ware) AND cl_null(p_img09) THEN
        LET l_errno = 'aim-702'
        RETURN l_errno,0
     END IF
     #沒有傳來源單位
     IF cl_null(p_unit) THEN LET l_errno = 'aim-705' RETURN l_errno,0 END IF
 
     #倉庫確定的單位是不正確的
     IF cl_null(p_img09) THEN
        SELECT img09 INTO p_img09 FROM img_file
         WHERE img01 = p_item
           AND img02 = p_ware
           AND img03 = p_lot
           AND img04 = p_loc
        IF SQLCA.sqlcode THEN
           LET l_errno = 'aim-703'
           RETURN l_errno,0
        END IF
     END IF
     #目的單位不正確
     SELECT * FROM gfe_file WHERE gfe01 = p_img09 AND gfeacti ='Y'
     IF SQLCA.sqlcode THEN
        LET l_errno = 'aim-704'
        RETURN l_errno,0
     END IF
     #來源單位不正確
     SELECT * FROM gfe_file WHERE gfe01 = p_unit  AND gfeacti ='Y'
     IF SQLCA.sqlcode THEN
        LET l_errno = 'aim-705'
        RETURN l_errno,0
     END IF
 
     IF p_img09 = p_unit THEN RETURN l_errno,1 END IF
     CALL s_umfchk(p_item,p_unit,p_img09)
          RETURNING l_flag,l_factor
 
     IF p_n = '1' OR p_n = '2' THEN   #子單位/母單位
        IF l_flag = 1 THEN
           IF g_prog MATCHES 'aim*' THEN
              LET l_errno = 'mfg3075'
           END IF
           IF g_prog MATCHES 'axm*' THEN
              LET l_errno = 'amr-074'
           END IF
           IF g_prog MATCHES 'apm*' THEN
              LET l_errno = 'apm-288'
           END IF
           RETURN l_errno,0
        ELSE
           RETURN l_errno,l_factor
        END IF
     ELSE                             #參考單位
        IF cl_null(l_factor) THEN
           LET l_factor = 1
        END IF
        RETURN l_errno,l_factor
     END IF
END FUNCTION
