# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt730.4gl
# Descriptions...: 委外入庫資料維護作業
# Date & Author..: 97/05/13 By Kitty
# Modify.........: #No:7516 03/07/16 By Mandy
#                  apmt730'1.轉報工單' 時, 
#                  IF  RUN CARD委外 THEN
#                      串asft730(Run Card 生產日報)
#                  ELSE
#                      串asft700(生產日報)
#                  END IF
# Modify.........: No.FUN-630010 06/03/09 By saki 流程訊息通知功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.FUN-810038 08/02/15 By kim GP5.1 ICD
# Modify.........: No.MOD-840218 08/04/20 By claire 重新過單
# Modify.........: No.FUN-840012 08/10/07 By kim mBarcode整合
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60009 11/03/07 By Lilan EF整合功能(EasyFlow) 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt720.global"
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730068
      DEFER INTERRUPT
   END IF

  #FUN-A60009 add str -----
   LET g_argv5 = ARG_VAL(1)           #異動單號(rvu01)
   LET g_argv4 = ARG_VAL(2)           #執行功能(Action ID)
   LET g_argv2 = ARG_VAL(3)           #驗收單號(rvu02)
   LET g_argv1 = ARG_VAL(4)           #異動狀態[狀況碼]
   LET g_argv3 = ARG_VAL(5)           #採購性質
  #FUN-A60009 add end -----
  #LET g_argv2 = ARG_VAL(1)           #驗收單號          #FUN-A60009 mark
  #LET g_argv4 = ARG_VAL(2)           #執行功能          #FUN-A60009 mark
  #LET g_argv1 = ARG_VAL(3)           #參數-1(異動狀況)  #FUN-A60009 mark
   IF cl_null(g_argv1) THEN LET g_argv1 = '1'    END IF 
  #LET g_argv3 = ARG_VAL(4)           #參數-3(採購性質)      
   IF cl_null(g_argv3) THEN LET g_argv3 = 'SUB'  END IF  #FUN-A60009 mark
 
 
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

