# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt580.4gl
# Descriptions...: 無交期性採購單資料維護作業
# Date & Author..: 01/03/23 By Kammy
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-730068 07/03/30 By kim 行業別架構
# Modify.........: No.FUN-810017 08/02/21 By jan 新增服飾作業 
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt580.global"
 
  #FUN-730068........begin
  #DEFINE 
  #  g_argv1           LIKE pom_file.pom01,      #採購單號
  #  g_argv2           LIKE type_file.chr1,      #狀況碼 	#No.FUN-680136 VARCHAR(1)
  #  g_argv3           LIKE pom_file.pom02,      #採購單性質 
  #  g_argv4           LIKE sfb_file.sfb01,      #工單單號
  #  g_argv5           LIKE sfb_file.sfb05,      # part no
  #  g_argv6           LIKE sfb_file.sfb15,      #  finishdate
  #  g_argv7           LIKE sfb_file.sfb08,      #qty
  #  g_argv8           LIKE type_file.num5,      #本次作業序號 	#No.FUN-680136 SMALLINT
  #  g_argv9           LIKE type_file.num5,      #下次作業序號 	#No.FUN-680136 SMALLINT
  #  g_argv10          LIKE sfb_file.sfb08,      #轉入下一作業數量
  #  g_argv11          STRING                    #No.FUN-630010 執行功能
  #FUN-730068........end
 
MAIN
   DEFINE l_time      LIKE type_file.chr8       #No.FUN-680136 VARCHAR(8)
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730068
 
   DEFER INTERRUPT
 
   #No.FUN-630010 --start--
   LET g_argv1 = ARG_VAL(1)           #參數-1(採購單號)
   LET g_argv2 = "0"                  #參數-2(狀況碼)(已核准)
   LET g_argv3 = ARG_VAL(3)           #參數-3(性質)
   LET g_argv11 = ARG_VAL(2)
   #No.FUN-630010 ---end---
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
   CALL t580(g_argv1,g_argv2,g_argv3,g_argv11)      #No.FUN-630010
     CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
END MAIN
