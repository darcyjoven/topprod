# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_run_command.4gl
# Descriptions...: 提供使用者遠端呼叫 TIPTOP 執行 r.c2、r.f2、r.l2 服務
# Date & Author..: 2008/11/26 by Vicky
# Memo...........:
# Modify.........: 新建立  #FUN-8B0113
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
#[
# Description....: 提供使用者遠端呼叫 TIPTOP 執行 r.c2、r.f2、r.l2 服務(入口函式)
# Date & Author..: 2008/11/26 by Vicky  #FUN-8B0113
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_run_command()
 
   WHENEVER ERROR CONTINUE
 
   CALL aws_ttsrv_preprocess()  #呼叫服務前置處理程序
 
   #--------------------------------------------------------------------------#
   # 呼叫 TOPTOP 執行 r.c2、r.f2、r.l2                                                       #
   #--------------------------------------------------------------------------#
   IF g_status.code = "0" THEN
      CALL aws_run_command_process()
   END IF
 
   CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
 
END FUNCTION
 
#[
# Description....: 執行 r.c2、r.f2、r.l2
# Date & Author..: 2008/11/26 by Vicky  #FUN-8B0113
# Parameter......: none
# Return.........: none
# Memo...........:
#
#]
FUNCTION aws_run_command_process()
   DEFINE l_command   STRING,
          l_getmsg    STRING,
          l_cmd       STRING,
          l_ch        base.Channel,
          l_str       base.StringBuffer
   DEFINE l_return    RECORD     #回傳的 RECORD 變數
          result      STRING
          END RECORD
 
   #取得參數
   LET l_command = aws_ttsrv_getParameter("command")
   LET l_command = l_command.trim()
 
   #傳入指令若為空，則退回
   IF cl_null(l_command) THEN
      LET g_status.code = "aws-361"
      RETURN
   END IF
 
   #傳入指令不能含有 ";"
   IF l_command.getIndexOf(";",1) <> 0 THEN
      LET g_status.code = "aws-362"
      RETURN
   END IF
 
   #傳入指令必須為 r.c2 或 r.f2 或 r.l2 之一
   LET l_cmd = l_command.subString(1,4)
   IF l_cmd = "r.c2" OR l_cmd =  "r.f2" OR l_cmd = "r.l2" THEN
      LET l_ch = base.Channel.create()
      LET l_str = base.StringBuffer.create()
      CALL l_ch.openPipe(l_command,"r")
      WHILE l_ch.read(l_getmsg)
            CALL l_str.append(l_getmsg || "\n")
      END WHILE
      CALL l_ch.close()
      LET l_return.result = l_str.toString()
   ELSE
      LET g_status.code = "aws-363"
   END IF
 
   IF g_status.code = "0" THEN
      CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))  #回傳執行結果
   END IF
END FUNCTION
 
