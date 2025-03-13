# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apmp801.4gl
# Descriptions...: 三角貿易採購單拋轉作業
# Date & Author..: 01/11/07 By Tommy
# Modify.........: No.8083 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.若逆拋最終供應商的採購單性質為'REG'
# Modify.........: No.MOD-490455 Kammy 讀取進項稅別時，若只拋二站，會被卡住
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/28 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.FUN-570252 05/12/27 By Sarah 增加拋轉採購單特別說明與備註(當poz10=Y)
# Modify.........: No.FUN-620028 06/02/11 By Carrier 將apmp801拆開成apmp801及sapmp801
# Modify.........: No.FUN-570138 06/03/20 By yiting 批次背景執行
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30056 10/04/13 By Carrier call p801时,给是否IN TRANSACTION标志位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-620028  --Begin
DEFINE g_argv2   LIKE pmm_file.pmm905
DEFINE g_argv1   LIKE oea_file.oea01
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570138    #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    #是否有做語言切換 #No.FUN-680136 VARCHAR(1)
       ls_date         STRING                  #->No.FUN-570138
 
#FUN-570138 --start--
  DEFINE tm         RECORD
             #wc     LIKE type_file.chr1000,    #No.FUN-680136 VARCHAR(300)
             wc             STRING,           #NO.FUN-910082
             pmm905 LIKE pmm_file.pmm905
                    END RECORD
#FUN-570138 ---end---
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
#->No.FUN-570138 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1  = ARG_VAL(1)                       
   LET g_argv2  = ARG_VAL(2)                       
   LET tm.wc    = ARG_VAL(3)                       
   LET g_bgjob  = ARG_VAL(4)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570138 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

#  CALL p801(g_argv1,g_argv2)          #No.FUN-A30056                          
   CALL p801(g_argv1,g_argv2,FALSE)    #No.FUN-A30056

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
#No.FUN-620028  --End  
