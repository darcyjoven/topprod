# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asft623.4gl
# Descriptions...: Run Card 完工入庫維護作業        
# Date & Author..: 00/05/06 By Apple 
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.2021111901 21/11/19 By jc 增加自动审核扣账
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0090
    DEFINE g_cmd   	LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(10)
    DEFINE g_argv1 	LIKE sfu_file.sfu01  #No.FUN-630010
    DEFINE g_argv2      STRING               #No.FUN-630010
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680121 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)     #No.FUN-630010
   LET g_argv2 = ARG_VAL(2)     #No.FUN-630010
   LET g_bgjob = ARG_VAL(3)    #2021111901 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #str-----add by guanyao160928
   IF g_sma.smaud03 ='Y' THEN #盘点中
      #參數設定不使用申請作業,所以無法執行此支程式!
      CALL cl_err('','csf-087',1)
      EXIT PROGRAM
   END IF
   #end-----add by guanyao160928
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
   IF cl_null(g_bgjob) OR g_bgjob <> 'Y' THEN     #2021111901 add
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW t623_w AT p_row,p_col WITH FORM "asf/42f/asft623"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
   END IF     #2021111901 add
 
   CALL sasft623('1',g_argv1,g_argv2)  #No.FUN-630010
 
   IF cl_null(g_bgjob) OR g_bgjob <> 'Y' THEN     #2021111901 add
   CLOSE WINDOW t623_w                 #結束畫面
   END IF      #2021111901 add
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
