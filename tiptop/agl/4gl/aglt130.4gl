# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aglt130.4gl
# Descriptions...: 應計傳票單維護作業
# Date & Author..: 92/03/26 BY MAY
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/25 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60158 10/06/23 By Dido 取消 g_bookno 給予 
# Modify.........: No:MOD-AC0022 10/12/02 By Dido 參數二接收帳別(udm_tree傳遞用)
# Modify.........: No.CHI-C30051 12/06/04 By wangrr 新增aglt130_1畫面欄位順序按照p_per順序
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
   #g_bookno           LIKE aba_file.aba01,      #NO.3421 010824 by plum
    g_bookno           LIKE aba_file.aba00,      #ARG_1 帳別     
    #傳票單的種類:'1' 一般傳票 '3' 應計傳票 7' 歷史傳票查詢
#       l_time    LIKE type_file.chr8                #No.FUN-6A0073
    g_argv2           LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)              
 
MAIN
    OPTIONS
       INPUT NO WRAP
      ,FIELD ORDER FORM    #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序) #CHI-C30051 add
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
  #LET g_bookno = ARG_VAL(1)          #參數-1(帳別)         #MOD-A60158 mark
   LET g_bookno = ARG_VAL(2)          #參數-2(帳別)         #MOD-AC0022
   LET g_argv2 = "3"                  #參數-2 '3' 應計傳票
   CALL s_showmsg_init()              #NO.FUN-710023   
   CALL t110(g_bookno,g_argv2)
   CALL s_showmsg()                  #NO.FUN-710023
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
