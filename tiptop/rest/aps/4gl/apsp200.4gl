# Prog. Version..: '5.10.05-08.12.18(00001)'     #
# Pattern name...: apsp200.4gl
# Descriptions...: Tiptop 基礎資料匯出至APS
# Date & Author..: 07/04/21 By jacklai
# Modify.........: No.FUN-740087 07/04/21 By jacklai 呼叫ETL與APS背景作業

DATABASE ds

GLOBALS "../../config/top.global"
    
#No.FUN-740087 --start
MAIN
    DEFINE l_time           LIKE type_file.chr8
    DEFINE p_row,p_col      LIKE type_file.num5
    DEFINE l_success        LIKE type_file.num5
    
    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST-1,
        PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT
    
    INITIALIZE g_bgjob_msgfile TO NULL
    
    LET g_bgjob = ARG_VAL(1)
    IF cl_null(g_bgjob) THEN
        LET g_bgjob = "N"
    END IF
    
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("APS")) THEN
        EXIT PROGRAM
    END IF
    
    CALL cl_used(g_prog,l_time,1) RETURNING l_time
    
    LET l_success = FALSE
    LET g_success = "N"

    IF g_bgjob = "Y" THEN
        #呼叫 EAI 將TIPTOP DB 匯入APS DB
        CALL aws_etlcli() RETURNING l_success
        #DISPLAY l_returnCode

        #匯入作業成功呼叫APS啟動運算作業
        IF l_success == TRUE THEN
            CALL p200_java_apsCli()
            LET g_success = "Y"
        ELSE
            LET g_success = "N"
        END IF
        CALL cl_batch_bg_javamail(g_success)
    END IF
    
    CALL cl_used(g_prog,l_time,2) RETURNING l_time
END MAIN

FUNCTION p200_java_apsCli()
    DEFINE l_saz10      LIKE aps_saz.saz10   #APS Server IP
    DEFINE l_saz11      LIKE aps_saz.saz11   #APS Server Port
    DEFINE l_saz12      LIKE aps_saz.saz12   #APS From
    DEFINE l_saz13      LIKE aps_saz.saz13   #APS Charset
    DEFINE l_saz14      LIKE aps_saz.saz14   #APS Step Start
    DEFINE l_saz15      LIKE aps_saz.saz15   #APS Step Finish
    DEFINE l_saz16      LIKE aps_saz.saz16   #APS MethodParams
    DEFINE l_cmd        STRING
    DEFINE l_jarfile    STRING
    
    #設定jar檔案路徑
    LET l_jarfile       = "$DS4GL/bin/javaaps/jar/APSService.jar"
    
    #從aps_saz讀取參數
    SELECT saz10,saz11,saz12,saz13,saz14,saz15,saz16
    INTO l_saz10,l_saz11,l_saz12,l_saz13,l_saz14,l_saz15,l_saz16
    FROM aps_saz WHERE saz00='0'
    IF SQLCA.SQLCODE THEN
        CALL cl_err3("sel","aps_saz","0","",SQLCA.SQLCODE,"","sel aps:",1)
        RETURN
    END IF
    
    LET l_saz10 = l_saz10 CLIPPED
    LET l_saz12 = l_saz12 CLIPPED
    LET l_saz13 = l_saz13 CLIPPED
    LET l_saz14 = l_saz14 CLIPPED
    LET l_saz15 = l_saz15 CLIPPED
    LET l_saz16 = l_saz16 CLIPPED
    
    #組呼叫aps java client命令
    LET l_cmd = "java -jar"
    LET l_cmd = l_cmd," -Daps.ServerIp=",l_saz10
    LET l_cmd = l_cmd," -Daps.ServerPort="||l_saz11
    LET l_cmd = l_cmd," -Daps.From=",l_saz12
    LET l_cmd = l_cmd," -Daps.Charset=",l_saz13
    LET l_cmd = l_cmd," -Daps.StepStart=\"",l_saz14,"\""
    LET l_cmd = l_cmd," -Daps.StepFinish=\"",l_saz15,"\""
    LET l_cmd = l_cmd," -Daps.MethodParams=\"",l_saz16,"\""
    LET l_cmd = l_cmd," ",l_jarfile
    
    #DISPLAY "[l_cmd]: ",l_cmd
    RUN l_cmd
END FUNCTION
#No.FUN-740087 --end--
