# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: anmi013.4gl
# Descriptions...: 
# Date & Author..: No.FUN-B30213 11/03/30 By lixia
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log  

   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   LET g_prog='anmi013'
   
   OPEN WINDOW i011_w WITH FORM "anm/42f/anmi011"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)    
   CALL cl_ui_init()

   CALL i011('3') 
 
   CLOSE WINDOW i011_w                              # 結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  # 計算使用時間 (退出時間)
            
END MAIN
#FUN-B30213--end--
