# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# 
# Program name...: cl_license.4gl
# Descriptions...: 檢查 DEMO License 有效時間, 若少于或者等于 7 天, 則警示
# Date & Author..: 2007/10/16 by Brendan
# Usage..........: CALL cl_license()
# Modify.........: No.FUN-7A0033 07/10/16 by Brendan 新增
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-8C0297 08/12/31 By shengbb for l_days 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#-- FUN-7A0033 BEGIN ---
CONSTANT g_days INTEGER = 7  #定義警示天數為到期前七天內
 
FUNCTION cl_license()
   DEFINE sh_pipe    base.channel,
          l_str      STRING,
          l_substr   STRING,   # Modify: No.MOD-8C0297 08/12/31 add
          l_days     INTEGER,
          l_index    INTEGER   # Modify: No.MOD-8C0297 08/12/31 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET sh_pipe = base.channel.create()
   CALL sh_pipe.openPipe("fglWrt -a info 2>&1 | grep 'The evaluation'", "r")
 
   LET l_str = sh_pipe.readLine()
   IF l_str.getLength() = 0 THEN
      RETURN
   ELSE
      # Modify: No.MOD-8C0297 08/12/31 begin add
      LET l_substr = "day"
      LET l_index = l_str.getIndexOf(l_substr,1)
      IF l_index>56 THEN
         LET l_index=l_index-2
      ELSE
         LET l_index=55
      END IF
      # Modify: No.MOD-8C0297 08/12/31 end add
      LET l_days = l_str.subString(55,l_index)      # Modify: No.MOD-8C0297 08/12/31 add
      
      IF l_days <= g_days THEN
         CALL cl_err_msg('', 'azz-274', l_days, 1)
      END IF
   END IF
 
   CALL sh_pipe.close()
END FUNCTION
#-- FUN-7A0033 END ---
#-- MOD-8C0297 END ---
