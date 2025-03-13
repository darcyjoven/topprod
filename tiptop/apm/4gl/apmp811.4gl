# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmp811.4gl
# Descriptions...: 三角貿易採購單拋轉還原作業
# Date & Author..: 01/11/08 By Tommy
# Modify.........: No.8083 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.若逆拋最終供應商的採購單性質為'REG'
# Modify.........: No.FUN-570252 05/12/27 By Sarah 拋轉還原需將特別說明與備註刪除
# Modify.........: No.FUN-620028 06/02/11 By Carrier 將apmp811拆開成apmp811及sapmp811
# Modify.........: No.FUN-630040 06/03/22 By Nicola 多接收及回傳一個參數
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-620028  --Begin
DEFINE g_argv1         LIKE pmm_file.pmm01
DEFINE l_success       LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
 
MAIN
   DEFINE l_time       LIKE type_file.chr8        #計算被使用時間  #No.FUN-680136 VARCHAR(8)
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
   LET g_argv1 = ARG_VAL(1)
   CALL p811(g_argv1,'') RETURNING l_success  #No.FUN-630040
   CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
#No.FUN-620028  --End
