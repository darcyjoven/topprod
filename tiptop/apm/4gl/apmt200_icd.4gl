# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmt200.4gl
# Descriptions...: 委外採購收貨作業
# Date & Author..: 97/05/19 By Kitty
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-730068 07/03/29 By kim 行業別架構
# Modify.........: No.FUN-7C0017 08/03/05 By bnlent apmt200.4gl-> apmt200.src.4gl 
# Modify.........: No.FUN-840012 08/10/07 By kim 提供自動確認的功能
# Modify.........: No.FUN-940083 09/05/21 By douzh 新增VIM管理功能-新增傳入參數收貨類別:1.一般收貨
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt110.global"
 
MAIN
   DEFINE l_time       LIKE type_file.chr8          #No.FUN-680136 VARCHAR(8)
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730068
   END IF
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)           #參數-1(收貨單號)
   LET g_argv2 = 'SUB'                #參數-2(採購類別)      
   LET g_argv3 = ' '                  #參數-3(L/C收貨)
   LET g_argv4 = ARG_VAL(2)           #No.FUN-630010 執行功能
   LET g_argv5 = ARG_VAL(3)           #FUN-840012  1:執行確認
   IF cl_null(g_argv5) THEN LET g_argv5=' ' END IF #FUN-840012
   LET g_prog = 'apmt200_icd'         #No.FUN-7C0017
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
      RETURNING l_time
   CALL t110(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,'1')   #No.FUN-630010 #FUN-840012 #FUN-940083
   CALL cl_used(g_prog,l_time,2)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
      RETURNING l_time
END MAIN
