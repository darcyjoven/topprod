# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_get_grup_str.4gl
# Descriptions...: 取得部門群組字串
# Date & Author..: 05/08/09 sarah
# Memo...........: p_grup 部門 ,  l_str('A01','A02','A03') 
# Usage..........: CALL cl_get_grup_str(p_grup)
# Modify.........: No.MOD-5A0401 05/10/26 alex 修正錯誤段落
# Modify.........: No.TQC-5C0134 06/03/02 alex 併入cl_chk_act_auth為cl_chk_tgrup_list
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
#DATABASE ds    #FUN-7C0053
#
#GLOBALS "../../config/top.global"
#
#FUNCTION cl_get_grup_str(lc_grup)
#
#    DEFINE lc_grup        LIKE zz_file.zzgrup
#    DEFINE lc_zyw03       LIKE zyw_file.zyw03
#    DEFINE ls_str         STRING
#    DEFINE li_i           INTEGER
#
#    WHENEVER ERROR CALL cl_err_msg_log
#
#    IF NOT (g_priv3 MATCHES '[567]') THEN
#       RETURN "("||g_grup CLIPPED||")"
#    END IF 
#
#    SELECT count(*) INTO li_i FROM zyw_file WHERE zyw03=lc_grup
#    IF STATUS OR li_i <= 0 THEN
#       RETURN "("||g_grup CLIPPED||")"
#    END IF 
#
#    LET ls_str = ""
#    DECLARE cl_get_zyw03_cs CURSOR FOR
#     SELECT zyw03 FROM zyw_file
#      WHERE zyw01 IN (SELECT UNIQUE zyw01 FROM zyw_file WHERE zyw03=p_grup)
#      GROUP BY zyw03
#    FOREACH cl_get_zyw03_cs INTO lc_zyw03
#       IF NOT cl_null(lc_zyw03) THEN
#          IF cl_null(ls_str) THEN
#             LET ls_str="'",lc_zyw03 CLIPPED,"'"
#          ELSE
#             LET ls_str=ls_str.trim(),",'",lc_zyw03 CLIPPED,"'"
#          END IF
#       END IF
#    END FOREACH
#
#    IF NOT ls_str.getIndexOf(g_grup,1) THEN
#       LET ls_str=ls_str.trim(),",'",g_grup CLIPPED,"'"
#    END IF
#
#    RETURN "("||ls_str.trim()||")"
#END FUNCTION
 
