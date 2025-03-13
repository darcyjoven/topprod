# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name...: p_flownoty.4gl
# Descriptions...: 以Mail批次通知個人工作
# Date & Author..: 03/12/23 by Hiko
# Sample.........: CALL p_batch_flow_notify()
# Memo...........: 此程式為背景執行.
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-8C0029 08/12/03 By alex 調整為 db scan
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
                  
MAIN
 
   LET g_bgjob = 'Y'
 
   #FUN-8C0029 start
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CONTINUE
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL p_flownoty_scan()
 
END MAIN
 
 
 
FUNCTION p_flownoty_scan()
 
   DEFINE la_azp    DYNAMIC ARRAY OF RECORD
             azp03  LIKE azp_file.azp03
                    END RECORD
   DEFINE li_cnt    LIKE type_file.num5
   DEFINE lc_azp03  LIKE azp_file.azp03
 
   DECLARE p_flownoty_scan_cs CURSOR FOR
   SELECT azp03 FROM azp_file
    WHERE azp03 IS NOT NULL AND azp053 = "Y"
    ORDER BY azp03
 
   CALL la_azp.clear()
   FOREACH p_flownoty_scan_cs INTO lc_azp03
     IF NOT cl_null(lc_azp03) THEN
        LET li_cnt = la_azp.getLength() + 1
        LET la_azp[li_cnt].azp03 = lc_azp03 CLIPPED
     END IF
   END FOREACH
 
   FOR li_cnt = 1 TO la_azp.getLength()
#      CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
      CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
      CLOSE DATABASE 
      DATABASE la_azp[li_cnt].azp03
#      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
      CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
      CALL p_flownoty_mail()
   END FOR
 
END FUNCTION
 
 
 
FUNCTION p_flownoty_mail()
 
   #FUN-8C0029 end
 
   DEFINE   lr_gai   RECORD LIKE gai_file.*
 
   DECLARE lcurs_gai CURSOR FOR SELECT * FROM gai_file
   FOREACH lcurs_gai INTO lr_gai.*
      IF (SQLCA.SQLCODE) THEN
         EXIT FOREACH
      END IF
 
      CALL cl_flow_mail(cl_getmsg("azz-806",g_lang), lr_gai.*)
 
      # 2003/12/23 by Hiko : 在信件寄出後,將此筆資料移除.
      DELETE FROM gai_file WHERE gai01=lr_gai.gai01
   END FOREACH
 
END FUNCTION
 
