# Prog. Version..: '5.10.05-08.12.18(00001)'     #
# Pattern name...: apsp300.4gl
# Descriptions...: Tiptop 基礎資料匯出至APS
# Date & Author..: 07/04/21 By jacklai
# Modify.........: No.FUN-750086 07/04/21 By jacklai 呼叫ETL與APS背景作業

DATABASE ds

GLOBALS "../../config/top.global"
    
#No.FUN-750086 --start--
MAIN
    DEFINE l_time           LIKE type_file.chr8
    DEFINE p_row,p_col      LIKE type_file.num5
    DEFINE l_success        LIKE type_file.num5
    
    DEFER INTERRUPT
    WHENEVER ERROR CALL cl_err_msg_log
    
    LET g_bgjob = ARG_VAL(1)
    IF cl_null(g_bgjob) THEN
        LET g_bgjob = "N"
    END IF
    
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
    
    IF (NOT cl_setup("APS")) THEN
        EXIT PROGRAM
    END IF
    
    CALL cl_used(g_prog,l_time,1) RETURNING l_time
    
    LET l_success = FALSE
    LET g_success = "N"

    IF g_bgjob = "Y" THEN
        #呼叫 EAI 將TIPTOP DB 匯入APS DB
        CALL aws_etlcli_aps2tt() RETURNING l_success
        #DISPLAY l_returnCode
        
        #匯入作業成功呼叫APS啟動運算作業
        IF l_success == TRUE THEN
            LET g_success = "Y"
        ELSE
            LET g_success = "N"
        END IF
        CALL cl_batch_bg_javamail(g_success)
    END IF
    
    CALL cl_used(g_prog,l_time,2) RETURNING l_time
END MAIN
#No.FUN-750086 --end--
