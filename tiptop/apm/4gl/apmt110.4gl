# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt110.4gl
# Descriptions...: 採購收貨作業
# Date & Author..: 97/05/19 By Kitty
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-810038 08/01/25 By kim GP5.1 ICD
# Modify.........: No.FUN-7C0017 08/03/05 By bnlent apmt110.4gl-> apmt110.src.4gl 
# Modify.........: No.FUN-840012 08/10/07 By kim 提供自動確認的功能
# Modify.........: No.FUN-940083 09/05/21 By douzh 新增VIM管理功能-新增傳入參數收貨類別:1.一般收貨
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-AB0376 10/12/01 By lixh1  整個畫面欄位輸入依照4gl的順序，忽略p_per所設定的順序
# Modify.........: No:TQC-AC0355 10/12/27 By lilingyu 若為ICD行業時,給g_argv2賦一個初值
# Modify.........: No:TQC-B10220 11/01/21 By lilingyu 還原TQC-AC0355修改內容
# Modify.........: No:FUN-B90101 11/10/26 By lixiang 增加服飾行業別下的g_prog
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt110.global"
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-840012
      OPTIONS
        # INPUT NO WRAP,    #TQC-AB0376
          INPUT NO WRAP     #TQC-AB0376
        # FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-810038  #TQC-AB0376
      DEFER INTERRUPT
   END IF
 
   LET g_argv1 = ARG_VAL(1)           #參數-1(收貨單號)
   LET g_argv2 = ' '                  #參數-2(採購類別)      
   LET g_argv3 = ' '                  #參數-3(L/C收貨)
   LET g_argv4 = ARG_VAL(2)           #No.FUN-630010 執行功能
   LET g_argv5 = ARG_VAL(3)           #FUN-840012  1:執行確認
   IF cl_null(g_argv5) THEN LET g_argv5=' ' END IF #FUN-840012

#FUN-B90101--add--begin
#FUN-B90101--add--end-- 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL t110(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,'1')   #No.FUN-630010 #FUN-840012 #FUN-940083

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-960130
