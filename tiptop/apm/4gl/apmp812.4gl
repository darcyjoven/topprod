# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmp812.4gl
# Descriptions...: 多角代採買追蹤查詢作業 
# Date & Author..: 06/10/14 BY Yiting
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570138    #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1    #是否有做語言切換 #No.FUN-680136 VARCHAR(1)
 
MAIN
   DEFINE l_time       LIKE type_file.chr8        #計算被使用時間   #No.FUN-680136 VARCHAR(8)
 
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
   CALL p812(1)
   CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
 
 
