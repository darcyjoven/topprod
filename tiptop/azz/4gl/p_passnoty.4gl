# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: p_passnoty.4gl
# Descriptions...: 以Mail批次通知個人更換密碼
# Date & Author..: 09/09/07 by alex
# Memo...........: 此程式為背景執行, 執行時需要讀取 zx_file,gbt_file並對TEMPDIR有讀/寫權限
# Modify.........: No.FUN-990001 09/09/07 By alex 新增本作業
# Modify.........: No.FUN-990019 12/01/12 By alex 資安寄件人調整為bcc
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
                  
DEFINE g_gbt         RECORD LIKE gbt_file.*    #FUN-990001
DEFINE g_zx          RECORD LIKE zx_file.*
DEFINE g_mlj         RECORD LIKE mlj_file.*
DEFINE g_temp_path   STRING
 
MAIN
   LET g_bgjob = 'Y'
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CONTINUE
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_gbt.* FROM gbt_file WHERE gbt00 = "0"
 
   #若無開啟 p_passpriv 密碼變更控管則不需再執行
   IF g_gbt.gbt01 IS NULL OR (g_gbt.gbt01 <> "1" AND g_gbt.gbt01 <> "2" ) THEN
      EXIT PROGRAM
   END IF
 
   #若設定為 "不通知" 則一樣直接離開不需再執行
   IF g_gbt.gbt04 = "0" THEN
      EXIT PROGRAM
   END IF
 
   CALL p_passnoty_mail()
 
END MAIN
 
 
 
FUNCTION p_passnoty_mail()
 
   DEFINE ls_sql       STRING
   DEFINE ls_expired   STRING
 
   LET g_temp_path = FGL_GETENV("TEMPDIR")
 
   CASE    #判斷抓取目標，以避免 zx_file 資料量過大
      WHEN g_gbt.gbt01 = "1"    #zx16日期
         LET ls_sql = "SELECT * FROM zx_file WHERE zx16 IS NOT NULL "
      WHEN g_gbt.gbt01 = "2"    #zx17次數
         LET ls_sql = "SELECT * FROM zx_file WHERE zx17 IS NOT NULL "
      OTHERWISE 
         RETURN
   END CASE
 
   PREPARE p_passnoty_pre FROM ls_sql
   DECLARE p_passnoty_cs CURSOR FOR p_passnoty_pre
   FOREACH p_passnoty_cs INTO g_zx.*
      IF (SQLCA.SQLCODE) THEN
         EXIT FOREACH
      END IF
 
      CASE    #相同條件同時記載於 weblogin.4gl
         WHEN g_gbt.gbt01 = "1"    #zx16日期
            IF TODAY >= g_zx.zx16 + g_gbt.gbt02 - g_gbt.gbt04 AND TODAY < g_zx.zx16 + g_gbt.gbt02 THEN
               LET ls_expired = ((g_zx.zx16 + g_gbt.gbt02) - TODAY) UNITS DAY 
               CALL p_passnoty_process(ls_expired)
            END IF
         WHEN g_gbt.gbt01 = "2"    #zx17次數
            IF g_zx.zx17 >= g_gbt.gbt03 - g_gbt.gbt04 AND g_zx.zx17 < g_gbt.gbt03 THEN
               LET ls_expired = (g_gbt.gbt03 - g_zx.zx17) USING "<<<<<"
               CALL p_passnoty_process(ls_expired)
            END IF
      END CASE
   END FOREACH
 
END FUNCTION
 
 
FUNCTION p_passnoty_process(ls_expired)
 
   DEFINE lc_gbt01          LIKE gbt_file.gbt01
   DEFINE ls_expired        STRING
   DEFINE ls_context        STRING
   DEFINE ls_context_file   STRING
   DEFINE lc_channel        base.Channel
 
   INITIALIZE g_xml TO NULL
 
   LET lc_gbt01 = g_gbt.gbt01
 
   IF (cl_null(g_bgjob) OR g_bgjob != 'Y') THEN
      CALL cl_progress_bar(3)
      CALL cl_progressing("Prepare mail info")
   END IF
 
  #FUN-990019
  #LET g_xml.subject = "TIPTOP ERP Login Pasword Will Be Expired Next "
   LET g_xml.subject = cl_getmsg('azz-921',g_lang)
 
   CASE lc_gbt01
      WHEN "1" 
         LET g_xml.subject = g_xml.subject, ls_expired.trim(), " Day(s)."
      WHEN "2" 
         LET g_xml.subject = g_xml.subject, ls_expired.trim(), " Time(s)."
   END CASE
 
   LET ls_context = "Dear " ,g_zx.zx02 CLIPPED , ",<br>\n<br>\n " ,  
                    "  " ,g_xml.subject CLIPPED , "<br>\n" ,
                   #"  We Recommand you can Update Password Through 'webpasswd' (connect from udm_tree).<br>\n ",
                    "  ",cl_getmsg('azz-922',g_lang) CLIPPED,".<br>\n ",

                   #"  Or System Will Disable This Account When Password Expired.<br>\n<br>\n ",
                    "  ",cl_getmsg('azz-923',g_lang) CLIPPED,"<br>\n<br>\n ",

                   #"  If You Have No Any TIPTOP ERP Account,<br>\n ",
                    "  ",cl_getmsg('azz-924',g_lang) CLIPPED,",<br>\n ",

                   #"  Please Notice System Admin For Clean These Settings.<br>\n<br>\n ",
                    "  ",cl_getmsg('azz-925',g_lang) CLIPPED,".<br>\n<br>\n ",

                    "Best Regards,<br>\n ",
                    "TIPTOP ERP System Adminstrators<br>"
 
   LET ls_context_file = os.Path.join(g_temp_path,"flow_context_" || FGL_GETPID() || ".htm")
 
   # 輸出檔案
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile( ls_context_file CLIPPED, "a" )
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write(ls_context) 
   CALL lc_channel.close()
 
   LET g_xml.body = ls_context_file    
  #LET g_xml.recipient = g_zx.zx09 CLIPPED
   LET g_xml.bcc = g_zx.zx09 CLIPPED   #FUN-990019
   LET g_xml.sender = g_zx.zx09 CLIPPED,":TIPTOP ERP Admin"
 
   IF (cl_null(g_bgjob) OR g_bgjob != 'Y') THEN
      CALL cl_progressing("Prepare to send mail")
   END IF
 
   IF NOT cl_null(g_zx.zx09) THEN
      CALL cl_jmail()
   END IF
 
   IF (cl_null(g_bgjob) OR g_bgjob != 'Y') THEN
      CALL cl_progressing("Finish")
   END IF
 
   IF os.Path.delete(ls_context_file) THEN
   END IF
 
END FUNCTION
