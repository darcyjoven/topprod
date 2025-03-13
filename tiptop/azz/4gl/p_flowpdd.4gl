# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: p_behind_time_notify.4gl
# Descriptions...: 逾期處理工作的通知.
# Date & Author..: 03/12/23 by Hiko
# Sample.........: CALL p_behind_time_notify()
# Memo...........: 此程式為背景執行.
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
                  
MAIN
   DEFINE   lr_gah         RECORD LIKE gah_file.*
   DEFINE   lr_mail_info   RECORD LIKE gai_file.*
 
   WHENEVER ERROR CONTINUE
 
   #CKP
   LET g_bgjob = 'Y'
   ##
   DECLARE lcurs_gah CURSOR FOR
                     SELECT * FROM gah_file WHERE gah10 IS NOT NULL AND #存在"逾期處理時的Mail通知清單"
                                                  gah08 IS NOT NULL AND #存在"處理期限"(NULL為無限期完成)
                                                  gah09 IS NULL         #不存在"處理完成日期"(NULL為未完成)
   FOREACH lcurs_gah INTO lr_gah.*
      IF (SQLCA.SQLCODE) THEN
         EXIT FOREACH
      END IF
 
      IF (lr_gah.gah08 <= TODAY) THEN
         LET lr_mail_info.gai01 = lr_gah.gah01
         LET lr_mail_info.gai02 = lr_gah.gah04
         LET lr_mail_info.gai03 = lr_gah.gah06
         LET lr_mail_info.gai04 = lr_gah.gah07
         LET lr_mail_info.gai05 = lr_gah.gah10
         LET lr_mail_info.gai06 = NULL
 
         CALL cl_flow_mail("Work behind time notify", lr_mail_info.*)
      END IF
   END FOREACH
END MAIN
 
#[
# Description  	: 結束程式
# Date & Author	: 2004/01/17 by Hiko
# Parameter   	: none
# Return   	: void
# Memo        	: 在結束udm_tree前,要先結束此程式.
# Modify   	:
#]
FUNCTION exit_behind_time_notify()
   EXIT PROGRAM
END FUNCTION
