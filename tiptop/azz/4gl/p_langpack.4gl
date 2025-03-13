# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_langpack.4gl
# Descriptions...: 語言套件安裝作業 
# Date & Author..: 08/04/09 By alex    #MOD-850307
# Modify.........: No.FUN-860078 08/06/23 By alex 調整打包/解包功能
# Modify.........: No.FUN-880019 08/09/18 By alex 取消本支作業
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds 
GLOBALS "../../config/top.global"
 
MAIN
 
 OPTIONS
     INPUT NO WRAP
  DEFER INTERRUPT
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (NOT cl_setup("AZZ")) THEN
     EXIT PROGRAM
  END IF
 
  CALL cl_used(g_prog,g_time,1) RETURNING g_time
  CALL cl_err("The program is disabled!","!",1)   #FUN-880019
  CALL cl_used(g_prog,g_time,1) RETURNING g_time
END MAIN
