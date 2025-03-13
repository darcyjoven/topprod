# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asft620.4gl
# Descriptions...: 工單完工入庫維護作業        
# Date & Author..: 97/06/13 By Sophia
# Modify.........: copy from aimt370                               
# Modify.........: 97/07/16 modify                                 
# Modify.........: No:6963 BY Nicola 傳入參數sfu01                 
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-730075 07/04/02 By kim 行業別架構
# Modify.........: No.FUN-810038 08/03/07 By kim GP5.1 ICD
# Modify.........: No.FUN-840012 08/10/06 By kim 提供自動確認的功能
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BC0104 12/01/11 By xujing 增加對sfv46,qcl02,sfv47欄位有條件隱藏
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasft620.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0090
    DEFINE g_cmd   	LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(10)
    DEFINE g_argv1 	LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    DEFINE g_argv2 	LIKE sfu_file.sfu01
    DEFINE g_argv3      STRING             #No.FUN-630010 執行功能
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    END IF
    DEFER INTERRUPT
 
   #No.FUN-630010 --start--
   LET g_argv2 = ARG_VAL(1)        #bugno:6963
   LET g_argv3 = ARG_VAL(2)
   #No.FUN-630010 ---end---
 
 
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
 
   LET p_row = 3 LET p_col = 2
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
       OPEN WINDOW t620_w AT p_row,p_col WITH FORM "asf/42f/asft620"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       
       CALL cl_ui_init()
       CALL t620_set_comp_visible() #FUN-BC0104  
   END IF
 
   CALL sasft620('1',g_argv2,g_argv3)      #bugno:6963   No.FUN-630010
   IF FGL_GETENV("FGLGUI")<> "0" THEN #FUN-840012
      CLOSE WINDOW t620_w                 #結束畫面
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN

#FUN-BC0104---add---str
FUNCTION t620_set_comp_visible()
DEFINE l_qcz14 LIKE qcz_file.qcz14

   SELECT qcz14 INTO l_qcz14 FROM qcz_file
      WHERE qcz00 = '0'
   IF l_qcz14 = 'N' THEN
      CALL cl_set_comp_visible('sfv46,qcl02,sfv47',FALSE)
      CALL cl_set_act_visible("qc_determine_storage",FALSE)
   END IF
END FUNCTION
#FUN-BC0104---add---end

