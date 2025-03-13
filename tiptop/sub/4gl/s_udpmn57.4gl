# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_udpmn57.4gl
# Descriptions...: 更新超短交數量
# Date & Author..: 93/03/08 By Keith
# Usage..........: CALL s_udpmn57(p_purno,p_puritem)
# Input Parameter: p_purno    欲更新之採購單號
#                  p_puritem  欲更新之採購項次
# Return code....: NONE
# Memo...........: 檢查g_success
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-8A0059 08/10/20 By Smapmin 計算pmn57的公式=pmn50 - pmn20 - pmn55
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_udpmn57(p_purno,p_puritem)
DEFINE
    p_purno    LIKE pmn_file.pmn01,
    p_puritem  LIKE pmn_file.pmn02,
    l_pmn20    LIKE pmn_file.pmn20,
    l_pmn50    LIKE pmn_file.pmn50
 
    WHENEVER ERROR CALL cl_err_msg_log
    SELECT pmn20,pmn50 
        INTO l_pmn20,l_pmn50 FROM pmn_file
                  WHERE pmn01=p_purno AND pmn02 = p_puritem
    IF SQLCA.sqlcode THEN
       LET g_success = "N"
       #CALL cl_err('(s_udpmn57:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
        CALL cl_err3("sel","pmn_file",p_purno,p_puritem,SQLCA.sqlcode,"","",1)   #FUN-670091
       RETURN
    END IF  #選取不成功
 
{ckp#1}  UPDATE pmn_file
            #SET pmn57=pmn50-pmn20    #TQC-8A0059
            SET pmn57=pmn50-pmn20-pmn55    #TQC-8A0059
            WHERE pmn01=p_purno AND
                  pmn02=p_puritem 
         IF SQLCA.sqlcode THEN
            LET g_success='N' 
            #CALL cl_err('(s_udpmn57:ckp#2)',SQLCA.sqlcode,1)  #FUN-670091
             CALL cl_err3("upd","pmn_file",p_purno,p_puritem,SQLCA.sqlcode,"","",1) #FUN-670091
            RETURN 
         END IF
 
END FUNCTION
