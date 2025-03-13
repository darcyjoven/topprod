# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: ggli930.4gl   #agli930.4gl
# Date & Author..: 01/02/01 By Wiky
# Modify.........: No.FUN-BC0110 11/12/28 By SunLM    agl--->ggl

DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
MAIN
      DEFINE
       p_row,p_col   LIKE type_file.num5       
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN   #FUN-BC0110
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL i930('1')
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
