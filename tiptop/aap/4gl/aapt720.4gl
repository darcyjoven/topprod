# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aapt720.4gl
# Descriptions...: 預付購料申請作業(採購部門)
# Date & Author..: 95/12/28 By Roger
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_argv1  LIKE ala_file.ala01       #No.FUN-4A0081
DEFINE g_argv2	 STRING                    #No.TQC-630070
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0055
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)               #No.FUN-4A0081
   LET g_argv2 = ARG_VAL(2)               #No.TQC-630070
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   LET p_row = 2 LET p_col = 4
   OPEN WINDOW t720_w AT p_row,p_col
     WITH FORM "aap/42f/aapt720"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL t710('2',g_argv1,g_argv2)      # 2.會計作業 #TQC-630070
   CLOSE WINDOW t720_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
