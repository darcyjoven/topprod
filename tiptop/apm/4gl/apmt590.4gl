# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt590.4gl
# Descriptions...: 委外採購單單頭資料維護作業(簡易輸入)
# Date & Author..: 97/05/05 By Kitty
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-640184 06/04/19 By Echo 自動執行確認功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.FUN-810016 08/02/28 By ve007 行業別修改
# Modify.........: No.FUN-7C0017 08/03/07 By bnlent apmt590.4gl-> apmt590.src.4gl 
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0283 10/12/18 By lixh1 整個畫面欄位輸入會依照4gl所寫的順序(忽略p_per所設定的順序)
# Modify.........: No:TQC-C30114 12/03/07 By lixiang 服飾流通委外採購單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt540.global"
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
         #INPUT NO WRAP,                     #TQC-AC0283
          INPUT NO WRAP                      #TQC-AC0283 
         #FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730068     #TQC-AC0283
      DEFER INTERRUPT
   END IF
 
   LET g_argv1 = ARG_VAL(1)           #參數-1(採購單號)
   LET g_argv12 = ARG_VAL(2)          #No.FUN-630010 執行功能
   LET g_argv2 = "0"                  #參數-2(狀況碼)(已核准)
   LET g_argv3 = 'SUB'                #參數-3(性質)
   LET g_argv4 = ARG_VAL(4)           #參數-4(工單單號)
   LET g_argv5 = ARG_VAL(5)           #參數-5 Parts No     
   LET g_argv6 = ARG_VAL(6)           #參數-6 Finish date  
   LET g_argv7 = ARG_VAL(7)           #     7 qty      
   LET g_argv8 = ARG_VAL(8)           #參數-8(本次作業序號)
   LET g_argv9 = ARG_VAL(9)           #參數-9(下次作業序號)
   LET g_argv10= ARG_VAL(10)           #轉入下一作業數量
   #No.FUN-630010 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL t540(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,g_argv6,g_argv7,
              g_argv8,g_argv9,g_argv10,g_argv12)    #No.FUN-630010

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
#TQC-C30114
