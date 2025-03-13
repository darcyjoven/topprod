# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimt840.4gl
# Descriptions...: 初盤維護作業－在製工單
#                : 此程式主要目的為選擇在製工單－初盤維護方式
# Date & Author..: 92/06/14 By Apple
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_cmd       LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
 
MAIN
    OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
    #使用者無使用製程
    IF g_sma.sma54 = 'N' THEN     
       CALL aimt832('1') 
    ELSE 
       CALL aimt8311('1') 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
