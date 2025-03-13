# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt722.4gl
# Descriptions...: 驗退資料維護作業
# Date & Author..: 97/05/24 By Kitty
# Modify.........: No.FUN-630010 06/03/09 By saki 流程訊息通知功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.FUN-810038 08/02/15 By kim GP5.1 ICD
# Modify.........: No.FUN-840012 08/10/07 By kim mBarcode整合
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B10203 11/01/21 By lilingyu 調整作業運行時欄位的輸入順序
# Modify.........: No.FUN-A60009 11/03/07 By Lilan EF整合功能(EasyFlow) 
# Modify.........: No.FUN-B90104 11/11/22 By huangrh GP5.3服飾版本開發
# Modify.........: No.MOD-C80005 12/08/08 By SunLM 還原TQC-B10203 mark

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt720.global"
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP   ,                 #TQC-B10203 
         FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730068   #TQC-B10203 #TQC-B10203 #MOD-C80005
      DEFER INTERRUPT
   END IF
 
  #FUN-A60009 add str -----
   LET g_argv5 = ARG_VAL(1)           #異動單號(rvu01)
   LET g_argv4 = ARG_VAL(2)           #執行功能(Action ID)
   LET g_argv2 = ARG_VAL(3)           #驗收單號(rvu02)
  #FUN-A60009 add end -----
   LET g_argv1 = '3'                  #參數-1(異動狀況)
  #LET g_argv2 = ARG_VAL(1)           #驗收單號    #FUN-A60009 mark
   LET g_argv3 = ' '                  #參數-3(性質)      
  #LET g_argv4 = ARG_VAL(2)           #執行功能    #FUN-A60009 mark
 
  LET g_prog='apmt722_icd'
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL t720(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5)  #No.FUN-630010  #FUN-A60009 mod:增加g_argv5

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-810038
