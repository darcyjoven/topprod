# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: cl_addcr.4gl
# Descriptions...: 增加換行符號
# Memo...........:
# Usage .........: CALL cl_addcr(file)
# Input parameter: ps_source 檔案名稱 
# Return code....: none
# Date & Author..: 2008/03/21 By TSC.Jiunn
# Modify.........: No.CHI-850019 08/05/13 By Sarah 增加cl_addcr
# Modify.........: No.MOD-860107 08/06/11 By Sarah 取消LET s = s CLIPPED,ascii(13)中的CLIPPED
# Modify.........: No.FUN-980097 09/08/21 By alex 改寫unix指令為Genero API
 
IMPORT os     #FUN-980097
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_addcr(ps_source)
  DEFINE ps_source           STRING,
         ps_target           STRING
  DEFINE tmp_file            STRING,
         s,l_cmd             STRING,
         l_channel           base.Channel,
         l_channel1          base.Channel
 
  IF cl_null(ps_source) THEN RETURN END IF
 
  LET tmp_file = ps_source CLIPPED,".tmp"
  ##加跳行符號
  LET l_channel = base.Channel.create()
  LET l_channel1 = base.Channel.create()
  CALL l_channel.openFile(tmp_file,"a" )
  CALL l_channel1.openFile(ps_source,"r" )
  CALL l_channel.setDelimiter("")
  CALL l_channel1.setDelimiter("")
 
  LET s=l_channel1.readLine()
  WHILE s IS NOT NULL 
    #LET s = s CLIPPED,ascii(13)   #MOD-860107 mark
     LET s = s ,ascii(13)          #MOD-860107
     CALL l_channel.write(s)
#    DISPLAY s
     LET s=l_channel1.readLine()
  END WHILE
  CALL l_channel.close()
  CALL l_channel1.close()
 
# LET l_cmd="rm ",ps_source CLIPPED
# RUN l_cmd
  IF os.Path.delete(ps_source CLIPPED) THEN    #FUN-980097
  END IF
 
# LET l_cmd="cp ",tmp_file CLIPPED," ",ps_source CLIPPED
# RUN l_cmd
  IF os.Path.copy(tmp_file CLIPPED,ps_source CLIPPED) THEN
  END IF
 
# LET l_cmd="rm ",tmp_file CLIPPED
# RUN l_cmd   #CHI-850019
  IF os.Path.delete(tmp_file CLIPPED) THEN
  END IF
 
END FUNCTION
