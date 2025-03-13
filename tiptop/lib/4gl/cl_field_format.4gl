# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_field_format.4gl
# Descriptions...: 根據幣別代碼設定欄位的format(金額,日期)
# Date & Author..: 04/01/05 by saki
# Memo...........: 可以設定format的元件有EDIT,BUTTONEDIT,LABEL.
# Usage..........: CALL cl_field_format(g_aza.aza17,)
# Modify.........: No.FUN-540019 05/04/26 by saki 特殊格式設定rate(),show_fd_desc
# Modify.........: No.FUN-540051 05/04/22 by saki 自由格式設定新增amt 金額欄位, 依照aoos010決定是否要逗號
# Modify.........: No.FUN-560065 05/06/14 by saki 特殊格式設定show_itme
# Modify.........: No.FUN-560192 05/06/22 by saki 特殊格式設定multi_unit多單位
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION cl_field_format(ps_currency,pc_frm_name)
   DEFINE   ps_currency   LIKE fan_file.fan02,  #No.FUN-690005 VARCHAR(04),
            pc_frm_name   LIKE gav_file.gav01   #No.FUN-690005 VARCHAR(10)
   DEFINE   lc_gav02      LIKE gav_file.gav02,
            lc_gav06      LIKE gav_file.gav06
   DEFINE   ls_count      LIKE type_file.num10  #No.FUN-690005 INTEGER
   DEFINE   lc_cust_flag  LIKE gav_file.gav08
   DEFINE   li_gav_count  LIKE type_file.num5   #No.FUN-690005 SMALLINT
   DEFINE   lst_format    base.StringTokenizer
   DEFINE   ls_format     STRING
   DEFINE   ls_gav06      STRING
   DEFINE   li_inx_s      LIKE type_file.num5   #No.FUN-690005 SMALLINT
 
 
   # 2004/04/12 by saki : 2004/04/12 by saki : 把本幣金額設定拿掉
   SELECT COUNT(*) INTO ls_count FROM gav_file WHERE gav01 = pc_frm_name AND gav06 IS NOT NULL
   IF ls_count <=0 THEN
      RETURN
   END IF
 
    # MOD-4A0324 by saki : 若有客製碼為Y的資料則優先抓取
   SELECT COUNT(*) INTO li_gav_count FROM gav_file
    WHERE gav01 = pc_frm_name AND gav08 = 'Y'
   IF li_gav_count > 0 THEN
      LET lc_cust_flag = "Y"
   ELSE
      LET lc_cust_flag = "N"
   END IF
   
   #2004/04/21 by saki : 只轉換自由格式設定內有值的欄位
   DECLARE ui_init_hc CURSOR FOR
      SELECT gav02,gav06 FROM gav_file
       WHERE gav06 IS NOT NULL AND gav01 = pc_frm_name AND gav08 = lc_cust_flag
   FOREACH ui_init_hc INTO lc_gav02,lc_gav06
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      # FUN-510003
      LET lst_format = base.StringTokenizer.create(lc_gav06 CLIPPED,"|")
      WHILE lst_format.hasMoreTokens()
         LET ls_gav06 = lst_format.nextToken()
         LET ls_gav06 = ls_gav06.trim()
         LET ls_gav06 = ls_gav06.toLowerCase()
 
         #No.FUN-540019 --start-- 將特殊設定(rate,show_fd_desc)與自由格式設定分開
         #No.FUN-540051 增加特殊格式(amt)
         LET li_inx_s = ls_gav06.getIndexOf("rate(",1)
         IF li_inx_s > 0 THEN
            CONTINUE WHILE
         END IF
 
         LET li_inx_s = ls_gav06.getIndexOf("show_fd_desc",1)
         IF li_inx_s > 0 THEN
            CONTINUE WHILE
         END IF
 
         LET li_inx_s = ls_gav06.getIndexOf("amt",1)
         IF li_inx_s > 0 THEN
            IF g_aza.aza43 = "Y" THEN
               CALL cl_set_field_format(lc_gav02 CLIPPED,"##,###,###,###,###.######")
               CALL cl_chg_comp_att(lc_gav02 CLIPPED,"WIDTH|SCROLL",30 || "|" || 1)
            END IF
            CONTINUE WHILE
         END IF
 
         #No.FUN-560065 --start--
         LET li_inx_s = ls_gav06.getIndexOf("show_itme(",1)
         IF li_inx_s > 0 THEN
            CONTINUE WHILE
         END IF
         #No.FUN-560065 ---end---
 
         #No.FUN-560192 --start--
         LET li_inx_s = ls_gav06.getIndexOf("multi_unit(",1)
         IF li_inx_s > 0 THEN
            CONTINUE WHILE
         END IF
         #No.FUN-560192 ---end---
 
         LET ls_format = ls_gav06
         CALL cl_set_field_format(lc_gav02 CLIPPED,ls_format)
         #No.FUN-540019 ---end---
      END WHILE
   END FOREACH
END FUNCTION
