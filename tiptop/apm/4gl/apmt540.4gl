# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmt540.4gl
# Descriptions...: 採購單單頭資料維護作業(簡易輸入)
# Date & Author..: 92/11/17 By Apple
# Modify.........: No.FUN-4C0074 04/12/14 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.FUN-640184 06/04/19 By Echo 自動執行確認功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.CHI-740014 07/04/16 By kim 行業別架構
# Modify.........: No.FUN-810016 08/02/28 By ve007 行業別修改
# Modify.........: No.FUN-7C0017 08/03/07 By bnlent apmt540.4gl-> apmt540.src.4gl 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE 
    g_argv1           LIKE pmm_file.pmm01,      #採購單號
    g_argv2           LIKE type_file.chr1,      #狀況碼 	#No.FUN-680136 VARCHAR(1)
    g_argv3           LIKE pmm_file.pmm02,      #採購單性質 
    g_argv4           LIKE sfb_file.sfb01,      #工單單號
    g_argv5           LIKE sfb_file.sfb05,      # part no
    g_argv6           LIKE sfb_file.sfb15,      #  finishdate
    g_argv7           LIKE sfb_file.sfb08,      #qty
    g_argv8           LIKE type_file.num5,      #本次作業序號 	#No.FUN-680136 SMALLINT
    g_argv9           LIKE type_file.num5,      #下次作業序號 	#No.FUN-680136 SMALLINT
    g_argv10          LIKE sfb_file.sfb08,      #轉入下一作業數量
    g_argv12          STRING                    #No.FUN-630010 執行功能

MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS
          INPUT NO WRAP,
          FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #CHI-740014
      DEFER INTERRUPT
   END IF
 
   #No.FUN-630010 --start-- 移位
   LET g_argv1 = ARG_VAL(1)           #參數-1(採購單號)
   LET g_argv12 = ARG_VAL(2)          #No.FUN-630010 執行功能
   LET g_argv2 = "0"                  #參數-2(狀況碼)(已核准)
   LET g_argv3 = ARG_VAL(3)           #參數-3(性質)
   LET g_argv4 = ARG_VAL(4)           #參數-4(工單單號)
   LET g_argv5 = ARG_VAL(5)           #參數-5 Parts No     
   LET g_argv6 = ARG_VAL(6)           #參數-6 Finish date  
   LET g_argv7 = ARG_VAL(7)           #     7 qty      
   LET g_argv8 = ARG_VAL(8)           #參數-8(本次作業序號)
   LET g_argv9 = ARG_VAL(9)           #參數-9(下次作業序號)
   LET g_argv10= ARG_VAL(10)           #轉入下一作業數量
   #No.FUN-630010 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL t540(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,g_argv6,g_argv7,
              g_argv8,g_argv9,g_argv10,g_argv12)    #No.FUN-630010

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-960130 
