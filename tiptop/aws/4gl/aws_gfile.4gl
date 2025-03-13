# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Modify.........:  s   FUN-8A0122 by binbin
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正

DATABASE ds
GLOBALS "../../config/top.global" 
Main
  DEFINE g_argv1 STRING
  DEFINE g_argv2 STRING

  CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80064   ADD 
  LET g_argv1 =	ARG_VAL(1)
  LET g_argv2 = ARG_VAL(2)
  
  CALL fgl_getfile(g_argv1,g_argv2)
  CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80064   ADD
END Main
#No.FUN-8A0122
