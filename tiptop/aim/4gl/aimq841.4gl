# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimq841.4gl
# Descriptions...: 料件供需明細查詢
# Date & Author..: 94/09/25 By Nick
#                  By Melody    修改查詢時 display 之內容及計算方式
# Modify.........: No.MOD-5B0174 05/11/24 By Sarah g_argv2(料號)應放大到40碼 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40137 10/04/28 By jan 重新过单
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_argv1     LIKE type_file.chr1,  # 1.依料號 2.依工單 3.依訂單  #No.FUN-690026 VARCHAR(1)
         g_argv2     LIKE ima_file.ima01   #     料號 /   工單 /   訂單   #MOD-5B0174 #No.FUN-690026 VARCHAR(40)     
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL aimq841(g_argv1,g_argv2)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#TQC-A40137
