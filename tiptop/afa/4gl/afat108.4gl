# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: afat108.4gl
# Descriptions...: 資產報廢作業
# Date & Author..: 96/05/28 By Melody 
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.FUN-640243 06/05/15 By Echo 自動執行確認功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#    DEFINE l_time	LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
    DEFINE g_cmd 	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
    DEFINE g_argv2      LIKE type_file.chr20            #No.FUN-630010       #No.FUN-680070 VARCHAR(16)
    DEFINE g_argv3      STRING             #No.FUN-630010
    DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    #FUN-640243
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
    END IF
    #END FUN-640243
 
    DEFER INTERRUPT
 
    LET g_argv2 = ARG_VAL(1)               #No.FUN-630010
    LET g_argv3 = ARG_VAL(2)               #No.FUN-630010
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_cmd='afat108'
    CALL cl_used(g_cmd,g_time,1) RETURNING g_time  #NO.FUN-6A0069
 
    #FUN-640243
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       LET p_row = 3 LET p_col = 15
       OPEN WINDOW t108_w AT p_row,p_col WITH FORM "afa/42f/afat108"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       
       CALL cl_ui_init()
    END IF
    #END FUN-640243
 
    CALL t108('1',g_argv2,g_argv3)              #1.資產報廢 2.資產出售 No.FUN-630010執行功能
    CLOSE WINDOW t108_w                 #結束畫面
    CALL cl_used(g_cmd,g_time,2) RETURNING g_time                  #NO.FUN-6A0069
END MAIN
