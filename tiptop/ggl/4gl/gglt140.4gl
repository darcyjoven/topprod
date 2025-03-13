# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gglt140.4gl
# Descriptions...: 審計調整單維護作業
# Date & Author..: 05/07/29 by elva
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
 
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_bookno   LIKE aba_file.aba00      # ARG_1 帳別 傳票單的種類:
                                              # 1 一般傳票 2 轉回傳票
                                              # 3 應計傳票 7 歷史傳票查詢
                                              # 4 審計傳票
#     DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0097
   DEFINE g_argv2    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)                   
 
MAIN
    OPTIONS
 
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
   LET g_bookno = ARG_VAL(1)              #參數-1(帳別)
   LET g_argv2 = "4"                      #參數-2 '4' 審計傳票
 
   CALL t110(g_bookno,g_argv2)
 
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
