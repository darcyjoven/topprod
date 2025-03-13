# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_userdefined_field.4gl
# Descriptions...: 自訂欄位設定 (不使用)
# Date & Author..: 2006/01/16 by saki
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0059 07/12/19 By saki 調整備註事項
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No.CHI-A40067 10/05/18 By saki formname抓取修正
 
DATABASE ds
GLOBALS "../../config/top.global"
 
##################################################
# Private Func...: TRUE
# Descriptions...: 檢查自訂欄位值
# Date & Author..: 2006/01/16 by saki
# Input Parameter: pc_fldname   STRING     自訂欄位名稱
#                  ps_value     STRING     自訂欄位值
# Return code....: li_result    TRUE/FALSE
# Modify.........: No.FUN-7C0059 07/12/19 by saki
##################################################
FUNCTION cl_userdefined_field_check(pc_fldname,ps_value)
   DEFINE   pc_fldname   LIKE gbr_file.gbr02
   DEFINE   ps_value     STRING
   DEFINE   lw_window    ui.Window
   DEFINE   lf_form      ui.Form
   DEFINE   lnode_frm    om.DomNode
   DEFINE   ls_formname  STRING
   DEFINE   li_cnt       LIKE type_file.num5        #No.FUN-690005 SMALLINT
   DEFINE   lc_cust      LIKE type_file.chr1        #No.FUN-690005 VARCHAR(1)
   DEFINE   lc_gbr01     LIKE gbr_file.gbr01
   DEFINE   pc_char01    LIKE type_file.chr1000     #No.FUN-690005 VARCHAR(255)
   DEFINE   pc_char02    LIKE type_file.chr1000     #No.FUN-690005 VARCHAR(40)
   DEFINE   pi_int01     LIKE aqc_file.aqc05        #No.FUN-690005 DEC(15,3)
   DEFINE   pi_int02     LIKE type_file.num10       #No.FUN-690005 INTEGER
   DEFINE   pd_date      LIKE type_file.dat         #No.FUN-690005 DATE
   DEFINE   lr_gbr       RECORD LIKE gbr_file.*
   DEFINE   ls_tabname   STRING
   DEFINE   ls_fldname   STRING
   DEFINE   ls_str       STRING
   DEFINE   ls_sql       STRING
 
 
   IF cl_null(pc_fldname) THEN
      RETURN FALSE
   END IF
   IF cl_null(ps_value) THEN
      RETURN TRUE
   END IF
 
   LET lw_window = ui.Window.getCurrent()
   LET lf_form = lw_window.getForm()
   IF lf_form IS NULL THEN
      RETURN FALSE
   END IF
   LET lnode_frm = lf_form.getNode()
   LET ls_formname = lnode_frm.getAttribute("name")
#  IF ls_formname.getLength() = ".tmp" THEN         #FUN-A10029
   IF ls_formname.subString(ls_formname.getLength()-3,ls_formname.getLength()) = ".tmp" THEN   #No:CHI-A40067
      LET ls_formname = ls_formname.subString(1,ls_formname.getLength()-4)
   END IF
#  IF ls_formname.getLength() = "T" THEN
   IF ls_formname.subString(ls_formname.getLength(),ls_formname.getLength()) = "T" THEN   #No:CHI-A40067
      LET ls_formname = ls_formname.subString(1,ls_formname.getLength()-1)
   END IF

   LET lc_gbr01 = ls_formname
 
   SELECT COUNT(*) INTO li_cnt FROM gbr_file
    WHERE gbr01 = lc_gbr01 AND gbr03 = 'Y'
   IF li_cnt > 0 THEN
      LET lc_cust = "Y"
   ELSE
      LET lc_cust = "N"
   END IF
 
   SELECT * INTO lr_gbr.* FROM gbr_file
    WHERE gbr01=lc_gbr01 AND gbr02=pc_fldname AND gbr03=lc_cust
 
   CASE
      WHEN (pc_fldname MATCHES "???ud01") OR (pc_fldname MATCHES "????ud01")
         LET pc_char01 = ps_value
         IF NOT cl_null(lr_gbr.gbr04) THEN
            LET ls_str = lr_gbr.gbr04
            LET ls_tabname = ls_str.subString(1,ls_str.getIndexOf(".",1) - 1)
            LET ls_fldname = ls_str.subString(ls_str.getIndexOf(".",1) + 1,ls_str.getLength())
            LET ls_sql = "SELECT COUNT(*) FROM ",ls_tabname,
                         " WHERE ",ls_fldname," = '",pc_char01,"'"
            PREPARE char01_pre FROM ls_sql
            EXECUTE char01_pre INTO li_cnt
            IF li_cnt <= 0 THEN
               RETURN FALSE
            END IF
         END IF
      WHEN (pc_fldname MATCHES "???ud0[2-6]") OR (pc_fldname MATCHES "????ud0[2-6]")
         LET pc_char02 = ps_value
         IF NOT cl_null(lr_gbr.gbr04) THEN
            LET ls_str = lr_gbr.gbr04
            LET ls_tabname = ls_str.subString(1,ls_str.getIndexOf(".",1) - 1)
            LET ls_fldname = ls_str.subString(ls_str.getIndexOf(".",1) + 1,ls_str.getLength())
            LET ls_sql = "SELECT COUNT(*) FROM ",ls_tabname,
                         " WHERE ",ls_fldname," = '",pc_char02,"'"
            PREPARE char02_pre FROM ls_sql
            EXECUTE char02_pre INTO li_cnt
            IF li_cnt <= 0 THEN
               RETURN FALSE
            END IF
         END IF
      WHEN (pc_fldname MATCHES "???ud0[7-9]") OR (pc_fldname MATCHES "????ud0[7-9]")
         LET pi_int01 = ps_value
         IF NOT cl_null(lr_gbr.gbr04) THEN
            LET ls_str = lr_gbr.gbr04
            LET ls_tabname = ls_str.subString(1,ls_str.getIndexOf(".",1) - 1)
            LET ls_fldname = ls_str.subString(ls_str.getIndexOf(".",1) + 1,ls_str.getLength())
            LET ls_sql = "SELECT COUNT(*) FROM ",ls_tabname,
                         " WHERE ",ls_fldname," = '",pi_int01,"'"
            PREPARE int01_pre FROM ls_sql
            EXECUTE int01_pre INTO li_cnt
            IF li_cnt <= 0 THEN
               RETURN FALSE
            END IF
         END IF
         IF lr_gbr.gbr05 = "Y" THEN
            IF NOT cl_null(lr_gbr.gbr06) THEN
               IF pi_int01 < lr_gbr.gbr06 THEN
                  RETURN FALSE
               END IF
            END IF
            IF NOT cl_null(lr_gbr.gbr07) THEN
               IF pi_int01 > lr_gbr.gbr07 THEN
                  RETURN FALSE
               END IF
            END IF
         END IF
      WHEN (pc_fldname MATCHES "???ud1[0-2]") OR (pc_fldname MATCHES "????ud1[0-2]")
         LET pi_int02 = ps_value
         IF NOT cl_null(lr_gbr.gbr04) THEN
            LET ls_str = lr_gbr.gbr04
            LET ls_tabname = ls_str.subString(1,ls_str.getIndexOf(".",1) - 1)
            LET ls_fldname = ls_str.subString(ls_str.getIndexOf(".",1) + 1,ls_str.getLength())
            LET ls_sql = "SELECT COUNT(*) FROM ",ls_tabname,
                         " WHERE ",ls_fldname," = '",pi_int02,"'"
            PREPARE int02_pre FROM ls_sql
            EXECUTE int02_pre INTO li_cnt
            IF li_cnt <= 0 THEN
               RETURN FALSE
            END IF
         END IF
         IF lr_gbr.gbr05 = "Y" THEN
            IF NOT cl_null(lr_gbr.gbr06) THEN
               IF pi_int02 < lr_gbr.gbr06 THEN
                  RETURN FALSE
               END IF
            END IF
            IF NOT cl_null(lr_gbr.gbr07) THEN
               IF pi_int02 > lr_gbr.gbr07 THEN
                  RETURN FALSE
               END IF
            END IF
         END IF
      WHEN (pc_fldname MATCHES "???ud1[3-5]") OR (pc_fldname MATCHES "????ud1[3-5]")
         LET pd_date = ps_value
         IF NOT cl_null(lr_gbr.gbr04) THEN
            LET ls_str = lr_gbr.gbr04
            LET ls_tabname = ls_str.subString(1,ls_str.getIndexOf(".",1) - 1)
            LET ls_fldname = ls_str.subString(ls_str.getIndexOf(".",1) + 1,ls_str.getLength())
            LET ls_sql = "SELECT COUNT(*) FROM ",ls_tabname,
                         " WHERE ",ls_fldname," = '",pd_date,"'"
            PREPARE date_pre FROM ls_sql
            EXECUTE date_pre INTO li_cnt
            IF li_cnt <= 0 THEN
               RETURN FALSE
            END IF
         END IF
         IF lr_gbr.gbr05 = "Y" THEN
            IF NOT cl_null(lr_gbr.gbr06) THEN
               IF pd_date < lr_gbr.gbr06 THEN
                  RETURN FALSE
               END IF
            END IF
            IF NOT cl_null(lr_gbr.gbr07) THEN
               IF pd_date > lr_gbr.gbr07 THEN
                  RETURN FALSE
               END IF
            END IF
         END IF
      OTHERWISE
         RETURN FALSE
   END CASE
 
   RETURN TRUE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 自訂欄位開窗
# Date & Author..: 2006/01/16 by saki
# Input Parameter: pi_construct   SMALLINT     自訂欄位名稱
# Return code....: lc_result      VARCHAR(255)    開窗值回傳
##################################################
FUNCTION cl_userdefined_field_query(pc_fldname,pi_construct)
   DEFINE   pc_fldname   LIKE gbr_file.gbr02
   DEFINE   pi_construct LIKE type_file.num5        #No.FUN-690005 SMALLINT
   DEFINE   lw_window    ui.Window
   DEFINE   lf_form      ui.Form
   DEFINE   lnode_frm    om.DomNode
   DEFINE   ls_formname  STRING
   DEFINE   li_cnt       LIKE type_file.num5        #No.FUN-690005 SMALLINT
   DEFINE   lc_cust      LIKE type_file.chr1        #No.FUN-690005 VARCHAR(1)
   DEFINE   lc_gbr01     LIKE gbr_file.gbr01
   DEFINE   lr_gbr       RECORD LIKE gbr_file.*
   DEFINE   lc_result    LIKE type_file.chr1000     #No.FUN-690005 VARCHAR(255)
 
 
   LET lw_window = ui.Window.getCurrent()
   LET lf_form = lw_window.getForm()
   IF lf_form IS NULL THEN
      RETURN FALSE
   END IF
   LET lnode_frm = lf_form.getNode()
   LET ls_formname = lnode_frm.getAttribute("name")
   #No:CHI-A40067 --start--
   IF ls_formname.subString(ls_formname.getLength()-3,ls_formname.getLength()) = ".tmp" THEN
      LET ls_formname = ls_formname.subString(1, ls_formname.getIndexOf(".tmp",1)-4)
   END IF
   IF ls_formname.subString(ls_formname.getLength(),ls_formname.getLength()) = "T" THEN
      LET ls_formname = ls_formname.subString(1,ls_formname.getLength()-1)
   END IF
#  LET ls_formname = ls_formname.subString(1,ls_formname.getIndexOf("T",1) - 1)
   #No:CHI-A40067 ---end---
   LET lc_gbr01 = ls_formname
 
   SELECT COUNT(*) INTO li_cnt FROM gbr_file
    WHERE gbr01 = lc_gbr01 AND gbr03 = 'Y'
   IF li_cnt > 0 THEN
      LET lc_cust = "Y"
   ELSE
      LET lc_cust = "N"
   END IF
 
   SELECT * INTO lr_gbr.* FROM gbr_file
    WHERE gbr01=lc_gbr01 AND gbr02=pc_fldname AND gbr03=lc_cust
 
   IF NOT cl_null(lr_gbr.gbr08) THEN
      CALL cl_init_qry_var()
      LET g_qryparam.form  = lr_gbr.gbr08 CLIPPED
      IF pi_construct THEN
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         RETURN g_qryparam.multiret
      ELSE
         CALL cl_create_qry() RETURNING lc_result
         RETURN lc_result CLIPPED
      END IF
   ELSE
      RETURN NULL
   END IF
END FUNCTION
