# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimt370.4gl
# Descriptions...: 庫存雜項發料/收料/報廢作業
# Date & Author..: 95/03/20 By Roger
# Modify.........: No.FUN-630046 06/03/14 By Alexstar 新增「申請人」欄位
# Modify.........: No.FUN-640245 06/04/28 By Echo 自動執行確認功能
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-720049 07/03/01 By kim 行業別架構變更
# Modify.........: No.FUN-730061 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-830056 08/03/17 By bnlent ICD庫存過帳修改  aimt370.4gl -> aimt370.src.4gl
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(2)
# Modify.........: No.FUN-B60118 11/06/23 By yangxf 隱藏pos
# Modify.........: No.FUN-c20101 12/02/20 By qiaozy 增加服饰二维结构
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saimt370.global"   #FUN-720049
 
MAIN
    DEFINE g_cmd   	LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
    #FUN-640245
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
           
#           FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)#FUN-C20101---MARK----
       DEFER INTERRUPT
    END IF
    #END FUN-640245
 
    LET g_argv1 = ARG_VAL(1)
    LET g_bgjob = ARG_VAL(5)    #20220422 add
    #No.FUN-830056  ...begin
    #No.FUN-830056  ...end
    CASE WHEN g_argv1 = '1' LET g_cmd ='aimt301'
         WHEN g_argv1 = '2' LET g_cmd ='aimt311'
         WHEN g_argv1 = '3' LET g_cmd ='aimt302'
         WHEN g_argv1 = '4' LET g_cmd ='aimt312'
         WHEN g_argv1 = '5' LET g_cmd ='aimt303'
         WHEN g_argv1 = '6' LET g_cmd ='aimt313'
         OTHERWISE 
              PROMPT "This program must follow 1/2/3/4/5/6 parameter:"
                 FOR CHAR g_argv1 #EXIT PROGRAM
    END CASE
 
    CASE WHEN g_argv1 = '1' LET g_prog='aimt301'
         WHEN g_argv1 = '2' LET g_prog='aimt311'
         WHEN g_argv1 = '3' LET g_prog='aimt302'
         WHEN g_argv1 = '4' LET g_prog='aimt312'
         WHEN g_argv1 = '5' LET g_prog='aimt303'
         WHEN g_argv1 = '6' LET g_prog='aimt313'
    END CASE
#FUN-C20101----add----BEGIN---
#FUN-C20101-----ADD---END--------

 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0074

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN   
#       OPEN WINDOW t370_w WITH FORM "aim/42f/aimt370" #FUN-c20101---MARK----
#          ATTRIBUTE (STYLE = g_win_style CLIPPED) #FUN-c20101----MARK-----
#       CALL cl_set_locale_frm_name("aimt370") #FUN-c20101----MARK-------
#FUN-C20101---ADD---BEGIN----
       OPEN WINDOW t370_w WITH FORM "aim/42f/aimt370"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_set_locale_frm_name("aimt370")
#FUN-C20101---ADD----END-------      
       CALL cl_ui_init()
   END IF
 
   CALL cl_set_comp_visible("inapos",FALSE)  #FUN-B60118 
   CALL t370(g_argv1)
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      CLOSE WINDOW t370_w                 #結束畫面
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0074
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN

