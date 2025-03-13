# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmt111.4gl
# Descriptions...: JIT收貨作業
# Date & Author..: 09/05/21 By douzh
# Modify.........: No.FUN-940083 09/05/21 By douzh 新增VIM管理功能-新增傳入參數收貨類別:2.無采購單收貨
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0080 09/11/12 By douzh apmt111正式區資料丟失，補過
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt110.global"
 
MAIN
   DEFINE l_time       LIKE type_file.chr8        
 
   IF FGL_GETENV("FGLGUI") <> "0" THEN 
      OPTIONS
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-810038
   END IF
 
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)           #參數-1(收貨單號)
   LET g_argv2 = ' '                  #參數-2(採購類別)      
   LET g_argv3 = ' '                  #參數-3(L/C收貨)
   LET g_argv4 = ARG_VAL(2)           #執行功能
   LET g_argv5 = ARG_VAL(3)           #1:執行確認
   IF cl_null(g_argv5) THEN LET g_argv5=' ' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) 
     RETURNING l_time
   CALL t110(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,'2') 
   CALL cl_used(g_prog,l_time,2)       #計算使用時間 (進入時間) 
     RETURNING l_time
END MAIN
#FUN-9B0080
