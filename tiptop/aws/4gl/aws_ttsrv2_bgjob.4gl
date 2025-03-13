# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: aws_ttsrv2_bgjob.4gl
# Descriptions...: TIPTOP Services 處理完成後，接續背景處理的服務動作
# Date & Author..: 2011/05/31 by Echo
# Modify.........: 新建立 FUN-B20029
 
IMPORT com
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../4gl/awsef.4gl"                 #FUN-960057 
GLOBALS
DEFINE g_form   RECORD
                       PlantID            LIKE azp_file.azp01,   #No.FUN-680130 VARCHAR(10)
                       ProgramID          LIKE wse_file.wse01,   #No.FUN-680130 VARCHAR(10)
                       SourceFormID       LIKE oay_file.oayslip, #No.FUN-680130 VARCHAR(5)     #MOD-590183
                       SourceFormNum      LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(100)
                       Date               STRING,
                       Time               STRING,
                       Status             STRING,
                       FormCreatorID      STRING,
                       FormOwnerID        STRING,
                       TargetFormID       STRING,
                       TargetSheetNo      STRING,
                       Description        STRING,
                       SenderIP           STRING  #No.FUN-680130  VARCHAR(10)      #FUN-560076  #FUN-710063
                END RECORD
END GLOBALS

#FUN-B20029 
#[
# Description....: 背景執行的服務功能
# Date & Author..: 2011/05/31 by Echo
# Parameter......: p_service   -  STRING  -    服務名稱
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_ttsrv2_bgjob(p_service)
DEFINE p_service        STRING

    #------------------------------------------------------------------------------------------------------#
    # 此處定義的服務名稱所需背景執行的功能                                                                 #
    # p_service:服務名稱                                                                                   #
    # CASE p_service                                                                                       #
    #  WHEN "SetStatus"                                                                                    #
    #       CALL aws_efstat2_approveLog(g_form.SourceFormNum)                                              #
    #                                                                                                      #
    #------------------------------------------------------------------------------------------------------#
      display "Service:",p_service
      CASE p_service
         WHEN "SetStatus" 
                 SELECT aza72 INTO g_aza.aza72 FROM aza_file WHERE aza01='0' 
                 DISPLAY "aza72: ", g_aza.aza72 
                 LET g_progID = g_form.ProgramID   #FUN-960057
                 SLEEP 5                           #CHI-A50019 add
                 CALL aws_efstat2_approveLog(g_form.SourceFormNum)

      END CASE
END FUNCTION
