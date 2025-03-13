# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt732.4gl
# Descriptions...: 驗退資料維護作業
# Date & Author..: 97/05/24 By Kitty
# Modify.........: No.FUN-630010 06/03/09 By saki 流程訊息通知功能
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.TQC-6C0022 06/12/05 By Sarah 保留程式,目前沒有release
# Modify.........: No.FUN-810038 08/02/15 By kim GP5.1 ICD
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-C10067 12/02/03 By Abby 增加傳入sapmt720的參數
# Modify.........: No.FUN-BA0013 12/02/15 By pauline 增加apmt732委外倉退維護作業1.退貨方式只能選"3.價格折讓"
#                                                                               2.只能選取採購性質"SUB.委外"的資料 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapmt720.global" #FUN-BA0013 add

 #FUN-BA0013 makr START   
 #DEFINE 
 #       g_argv1           LIKE rvu_file.rvu00,      #異動類別
 #       g_argv2           LIKE rvu_file.rvu02,      #驗收單號
 #       g_argv3           LIKE rvu_file.rvu08,      #採購性質 
 #       g_argv4           STRING                    #No.FUN-630010 執行功能
 #DEFINE g_argv5           LIKE rvu_file.rvu01       #FUN-C10067
 #FUN-BA0013 mark END
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
  #FUN-C10067 mod str---
#  LET g_argv2 = ARG_VAL(1)           #驗收單號
   LET g_argv5 = ARG_VAL(1)           #異動單號(rvu01)
   LET g_argv2 = ARG_VAL(3)           #驗收單號(rvu02)
  #FUN-C10067 mod end---
   LET g_argv4 = ARG_VAL(2)           #執行功能
   LET g_argv1 = '3'                  #參數-1(異動狀況)
   LET g_argv3 = 'SUB'                #參數-3(採購性質)      
 
   LET g_prog='apmt732_icd'
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   CALL t720(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5)  #No.FUN-630010  #FUN-C10067 add g_argv5

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#FUN-810038
