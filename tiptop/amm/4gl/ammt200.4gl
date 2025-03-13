# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: ammt200.4gl
# Descriptions...: 需求單維護作業
# Date & Author..: 00/12/18 By PLUM
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70109 10/07/14 By Carrier argv2/argv3 的长度修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv1	LIKE oea_file.oea01        #No.FUN-680100 VARCHAR(16)#No.FUN-630010 長度改變
#No.MOD-A70109  --Begin                                                         
#DEFINE g_argv2 LIKE ton_file.ton01
#DEFINE g_argv3 LIKE ton_file.ton01
DEFINE g_argv2  LIKE mmg_file.mmg01
DEFINE g_argv3  LIKE mmg_file.mmg02
#No.MOD-A70109  --End   
DEFINE g_argv4  STRING                     #No.FUN-630010 執行功能
DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-680100 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0076
    OPTIONS                                #改變一些系統預設值
 
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #No.FUN-630010 --start--
   LET g_argv1=ARG_VAL(1)
#  LET g_argv2=ARG_VAL(2)
#  LET g_argv3=ARG_VAL(3)
   LET g_argv4=ARG_VAL(2)
   LET g_argv2=ARG_VAL(3)
   LET g_argv3=ARG_VAL(4)
   #No.FUN-630010 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 1 LET p_col = 3
   ELSE LET p_row = 3 LET p_col = 2 
   END IF
   OPEN WINDOW t200_w AT p_row,p_col WITH FORM "amm/42f/ammt200"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
 
   CALL t200(g_argv1,g_argv2,g_argv3,g_argv4)  #No.FUN-630010
   CLOSE WINDOW t200_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
