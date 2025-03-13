# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_delsfa.4gl
# Descriptions...: 取消備料資料
# Date & Author..: 
# Usage..........: CALL s_delsfa(p_sfb01)
# Input Parameter: p_sfb01    工單編號
# Return code....: NONE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0018 08/03/18 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-A50066 10/06/09 s_del_sfai()加傳參數
# Modify.........: No:FUN-A60027 10/06/12 by sunchenxu 製造功能優化-平行制程（批量修改）
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_delsfa(p_sfb01)
DEFINE
    p_sfb01 LIKE sfb_file.sfb01,
    l_sfa RECORD
        sfa01  LIKE sfa_file.sfa01,    #工單編號  FUN-A60027
        sfa03  LIKE sfa_file.sfa03,    #料件
        sfa05  LIKE sfa_file.sfa05,    #應發
        sfa08  LIKE sfa_file.sfa08,    #作業編號  FUN-A60027
        sfa12  LIKE sfa_file.sfa12,    #發料單位  FUN-A60027
        sfa13  LIKE sfa_file.sfa13,    #換算率
        sfa25  LIKE sfa_file.sfa25,    #未備
        sfa27  LIKE sfa_file.sfa27,    #被替代料號 FUN-A60027
        sfa012 LIKE sfa_file.sfa012,   #製程段號   FUN-A60027
        sfa013 LIKE sfa_file.sfa013    #製程序     FUN-A60027
    END RECORD
DEFINE  l_flag LIKE type_file.chr1 
 
    WHENEVER ERROR CALL cl_err_msg_log
    DECLARE dsfa_cur
        CURSOR FOR
        SELECT sfa01,sfa03,sfa05,sfa08,sfa12,sfa13,sfa25,sfa27,sfa012,sfa013  #FUN-A60027 add sfa01,sfa08,sfa12,sfa27,sfa012,sfa013
        FROM sfa_file
        WHERE sfa01=p_sfb01 AND sfaacti='Y'
 
    #更新備料量
    FOREACH dsfa_cur INTO l_sfa.*
       IF SQLCA.SQLCODE THEN RETURN END IF
       LET l_sfa.sfa05=(l_sfa.sfa05-l_sfa.sfa25)*l_sfa.sfa13
       LET l_sfa.sfa25=l_sfa.sfa25 *l_sfa.sfa13
    END FOREACH
 
    #刪除備料資料
    DELETE FROM sfa_file WHERE sfa01=p_sfb01
    #NO.FUN-7B0018 08/03/18 add --begin
    IF NOT s_industry('std') THEN
       #LET l_flag = s_del_sfai(p_sfb01,'','','','','','','') #CHI-7B0034  #FUN-A50066
       LET l_flag = s_del_sfai(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,l_sfa.sfa12,l_sfa.sfa27, ' ',l_sfa.sfa012,l_sfa.sfa013)
    END IF
    #NO.FUN-7B0018 08/03/18 add --end
END FUNCTION
