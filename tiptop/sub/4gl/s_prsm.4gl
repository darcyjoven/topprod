# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_prsm.4gl
# Descriptions...: 『TOPICS/MFG』系統開啟 Put Restart 
# Date & Author..: 93/08/27 By Apple
# Input Parameter: 
# Return code....: 
# Modify.........: NO.FUN-670091 06/08/02 By rainy cl_err->cl_err3
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_prsm()
 
   WHENEVER ERROR CALL cl_err_msg_log
    UPDATE sma_file SET sma01 ='Y' 
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
    THEN #CALL cl_err(sqlca.sqlcode,'mfg9230',1) #FUN-670091
         CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #FUN-670091
    END IF
 
    DELETE FROM smi_file 
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
    THEN #CALL cl_err(sqlca.sqlcode,'mfg9230',1)  #FUN-670091
          CALL cl_err3("del","smi_file","","",SQLCA.sqlcode,"","",0)  #FUN-670091
    END IF
END FUNCTION
