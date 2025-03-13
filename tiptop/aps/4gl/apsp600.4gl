# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsp600.4gl
# Descriptions...: 透過 Web Services 將 TIPTOP 與 APS 整合
# Input parameter:
# Return code....:  
#                  
# Usage .........: call apsp600()
# Date & Author..: 97/04/24 By kevin #FUN-840179
# Modify.........: No.MOD-8B0184 08/11/19 By kevin 回傳連線失敗
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10142 2010/02/01 By Mandy 多傳參數
# Modify.........: No:CHI-A70049 10/07/28 By Pengu 將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B50020 11/05/10 By Lilan GP5.1追版至GP5.25(上方zl單號為GP5.1用)
# Modify.........: No:FUN-CC0150 13/01/09 By Mandy 傳給APS時增加傳<code9> 此碼傳legal code(法人)

 
DATABASE ds
#FUN-840179
GLOBALS "../../config/top.global"
DEFINE   g_argv1        String,
         g_argv2        String,
         g_argv3        String,
         g_argv4        String,
         g_argv5        String,
         g_argv6        String, 
         g_argv7        String,
         g_argv8        String, #FUN-A10142 add
         g_argv9        String, #FUN-A10142 add
         g_argv10       String  #FUN-CC0150 add
         
#主程式開始
MAIN
#  DEFINE l_time       VARCHAR(8)                #計算被使用時間 #No.FUN-6A0096
   DEFINE p_row,p_col  LIKE type_file.num5                    #FUN-680135
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1) CLIPPED     
   LET g_argv2 = ARG_VAL(2) CLIPPED     
   LET g_argv3 = ARG_VAL(3) CLIPPED     
   LET g_argv4 = ARG_VAL(4) CLIPPED     
   LET g_argv5 = ARG_VAL(5) CLIPPED     
   LET g_argv6 = ARG_VAL(6) CLIPPED     
   LET g_argv7 = ARG_VAL(7) CLIPPED
   LET g_argv8 = ARG_VAL(8) CLIPPED    #FUN-A10142 add
   LET g_argv9 = ARG_VAL(9) CLIPPED    #FUN-A10142 add     
   LET g_argv10= ARG_VAL(10) CLIPPED   #FUN-CC0150 add
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   #FUN-A10142--add---str---
   IF cl_null(g_argv8) THEN
       LET g_argv8 = ''
   END IF
   IF cl_null(g_argv9) THEN
       LET g_argv9 = ''
   END IF
   #FUN-A10142--add---end---
   #FUN-CC0150--add---str---
   IF cl_null(g_argv10) THEN
       LET g_argv10 = g_legal
   END IF
   #FUN-CC0150--add---end---
   
   #MOD-8B0184 start
  #IF aws_insert_command(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,g_argv6,g_argv7,'','') THEN        #FUN-A10142 mark
  #IF aws_insert_command(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,g_argv6,g_argv7,g_argv8,'') THEN   #FUN-A10142 add  #FUN-CC0150 mark	  
   IF aws_insert_command(g_argv1,g_argv2,g_argv3,g_argv4,g_argv5,g_argv6,g_argv7,g_argv8,'',g_argv10) THEN           #FUN-CC0150 add g_argv10
   ELSE
       #CHI-A70049 mod---str--
       #DISPLAY "Call web service failed"
        CALL cl_err('','aps-600',1) #呼叫Web Service 錯誤!
       #CHI-A70049 mod---end--
   END IF
   #MOD-8B0184 end
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN

#FUN-B50020
