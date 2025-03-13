# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: ggli920.4gl   #agli920.4gl
# Descriptions...: 現金流量表揭露事項維護作業
# Date & Author..: 00/07/14  By Hamilton
# Modify.........: No.FUN-BC0110 11/12/28 By SunLM  agl---->ggl
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gim00   LIKE gim_file.gim00
   
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
     
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN       #FUN-BC0110
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 3
   LET p_col = 18
   LET g_gim00 = "N"
   OPEN WINDOW i920_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli920"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL i920(g_gim00)

   CLOSE WINDOW i920_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
