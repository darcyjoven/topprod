# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aglt110.4gl
# Descriptions...: 一般傳票單維護作業
# Date & Author..: 92/03/26 BY MAY
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-640244 06/05/02 By Echo 自動執行確認功能
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/25 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-7A0043 07/10/09 By Smapmin 錯誤訊息的匯整是做在確認/取消確認段,故不可寫在此處
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AC0022 10/12/02 By Dido 參數二接收帳別(udm_tree傳遞用) 
# Modify.........: No:FUN-BB0123 12/01/10 By Lori 修改拋轉帳別方式
# Modify.........: No.CHI-C30051 12/06/04 By wangrr 新增aglt110_1畫面欄位順序按照p_per順序

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#  DEFINE g_bookno   LIKE aba_file.aba01      # NO.3421 by plum 010824
   DEFINE g_bookno   LIKE aba_file.aba00      # ARG_1 帳別 傳票單的種類:
                                              # 1 一般傳票 2 轉回傳票
                                              # 3 應計傳票 7 歷史傳票查詢
#     DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0073
   DEFINE g_argv2    LIKE type_file.chr1      #No.FUN-680098    VARCHAR(1)                  
   DEFINE g_argv3    LIKE bxi_file.bxi01      #No.FUN-630010 #No.FUN-680098  VARCHAR(16)
   DEFINE g_argv4    STRING                   #No.FUN-630010
 
MAIN
    #FUN-640244
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS
          INPUT NO WRAP
         ,FIELD ORDER FORM    #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序) #CHI-C30051 add
    END IF
    #END FUN-640244
 
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-630010 --start-- 移動參數位置
  #LET g_bookno = ARG_VAL(1)              #參數-1(帳別)  #FUN-810046
 
#  LET g_argv3 = ARG_VAL(1)
#  LET g_argv4 = ARG_VAL(2)
   LET g_bookno = ARG_VAL(2)              #參數-2(帳別)  MOD-AC0022
#  LET g_bookno = ARG_VAL(3)
   #No.FUN-630010 ---end---
   LET g_argv2 = "1"                      #參數-2 '1' 一般傳票
   #CALL s_showmsg_init()                  #NO.FUN-710023   #MOD-7A0043
   CALL t110(g_bookno,g_argv2)
   #CALL s_showmsg()                       #NO.FUN-710023   #MOD-7A0043 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
#NO.FUN-BB0123
