# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Library name...: aws_eflog
# Descriptions...: EasyFlow 送簽的 message log
# Input parameter: p_XMLString
# Return code....: none
# Usage .........: call aws_eflog(p_XMLString)
# Date & Author..: 92/02/25 By Brendan
 # Modify.........: No.MOD-530792 05/03/28 by Echo VARCHAR->CHAR
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
#
# Modify.........: No.FUN-980009 09/08/21 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960057 10/05/13 By Jay 增加 azg09 記錄程式代號
 
DATABASE ds
 
GLOBALS "../../config/top.global" #No.FUN-980009
 
FUNCTION aws_eflog(p_XMLString)
    DEFINE p_XMLString	STRING,
           l_azg        RECORD LIKE azg_file.*,
           l_str        LIKE azg_file.azg07    #No.FUN-680130 VARCHAR(256)
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET l_azg.azg01 = aws_xml_getTag(p_XMLString, "SourceFormNum")   #單號
    LET l_azg.azg02 = aws_xml_getTag(p_XMLString, "Date")            #日期
    LET l_azg.azg03 = aws_xml_getTag(p_XMLString, "Time")            #時間
    LET l_azg.azg04 = aws_xml_getTag(p_XMLString, "Status")          #簽核狀態
#    LET l_azg.azg05 = aws_xml_getTag(p_XMLString, "FormCreatorID")  
    LET l_azg.azg05 = aws_xml_getTag(p_XMLString, "EFLogonID")       #簽核人員
    LET l_azg.azg06 = aws_xml_getTag(p_XMLString, "TargetSheetNo")   #EF 單號
    LET l_str = aws_xml_getTag(p_XMLString, "Description")           #簽核意見
    LET l_azg.azgplant = g_plant # No.FUN-980009
    LET l_azg.azglegal = g_legal # No.FUN-980009
    IF l_str CLIPPED = '' OR l_str IS NULL THEN
       LET l_azg.azg07 = aws_xml_getTag(p_XMLString, "ActionDescribe")
    ELSE
       LET l_azg.azg07 = l_str
    END IF
    LET l_azg.azg08 = aws_xml_getTag(p_XMLString, "TargetFormID")    #EF 單別
    LET l_azg.azg09 = aws_xml_getTag(p_XMLString, "ProgramID")       #程式代號 #FUN-960057
 
    INSERT INTO azg_file VALUES(l_azg.*)
    IF SQLCA.SQLCODE THEN 
#     CALL cl_err("insert azg: ", SQLCA.SQLCODE, 1)    #No.FUN-660155
      CALL cl_err3("ins","azg_file",l_azg.azg01,"",SQLCA.sqlcode,"","insert azg:", 1)    #No.FUN-660155)   #No.FUN-660155
     END IF
    IF SQLCA.SQLCODE THEN 
       DISPLAY "Insert azg: ", SQLCA.SQLCODE
    END IF
END FUNCTION
