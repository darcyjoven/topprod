# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_batch_bg_process.4gl
# Descriptions...: 批次背景執行相關作業
# Date & Author..: 05/07/04 by saki
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.TQC-780076 07/08/23 By alex 檔案處理部份改為使用API
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
IMPORT os          #TQC-780076
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
##########################################################################
# Descriptions...: 轉換標準日期
# Usage..........: LET l_date = cl_batch_bg_date_convert(g_date)
# Input parameter: ps_date    日期保留字串
# Return code....: ld_date    正確執行日期
# Memo...........: 日期保留字為$TODAY，當批次每日執行時，$TODAY應被換成正確的日期
# Date & Author..: 05/06/30 by saki
##########################################################################
 
FUNCTION cl_batch_bg_date_convert(ps_date)
   DEFINE   ps_date   STRING
   DEFINE   ld_date   LIKE type_file.dat           #No.FUN-690005 DATE
   DEFINE   li_inx_s  LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_add    LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
 
   IF ps_date.getIndexOf("$TODAY",1) >= 1 THEN
      LET ld_date = TODAY
      IF (ps_date.getLength() > 6) AND (ps_date.getIndexOf("+",1)) THEN
         LET li_inx_s = ps_date.getIndexOf("+",1)
         LET li_add = ps_date.subString(li_inx_s + 1,ps_date.getLength())
         LET ld_date = ld_date + li_add
      END IF
   ELSE
      LET ld_date = ps_date
   END IF
 
   RETURN ld_date
END FUNCTION
 
##########################################################################
# Descriptions...: 製造批次背景執行時的訊息紀錄檔名
# Input parameter: none
# Return code....: ls_path    訊息檔名
# Usage..........: LET ls_name = cl_batch_bg_msg_filename()
# Date & Author..: 05/06/30 by saki
##########################################################################
 
FUNCTION cl_batch_bg_msg_filename()
   DEFINE   ls_result    STRING
   DEFINE   ls_tempdir   STRING
   DEFINE   ls_path      STRING
 
#  LET ls_tempdir = FGL_GETENV("TEMPDIR")              #TQC-780076
#  LET ls_path = ls_tempdir,"/bg_",g_prog CLIPPED,"_",
#                cl_replace_str(TODAY,"/",""),cl_replace_str(TIME,":",""),".txt"
 
   LET ls_tempdir = "bg_",g_prog CLIPPED,"_",cl_replace_str(TODAY,"/",""),
                                             cl_replace_str(TIME,":",""),".txt"
   LET ls_path = os.Path.join(FGL_GETENV("TEMPDIR"),ls_tempdir.trim())
 
   RETURN ls_path
END FUNCTION
 
##########################################################################
# Descriptions...: 批次背景執行時，錯誤訊息寫入紀錄檔
# Memo...........: 在主程式call cl_err時，判斷若為背景執行就不顯示訊息，
#                : 將訊息寫入txt檔中
# Input parameter: ps_msg        訊息內容
# Return code....: none
# Usage..........: CALL cl_batch_bg_msg_log("Error!")
# Date & Author..: 05/07/01 by saki
##########################################################################
 
FUNCTION cl_batch_bg_msg_log(ps_msg)
   DEFINE   ps_msg       STRING
   DEFINE   lc_channel   base.Channel
 
 
   IF cl_null(g_bgjob_msgfile) THEN
      LET g_bgjob_msgfile = cl_batch_bg_msg_filename()
   END IF
 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_bgjob_msgfile,"a")
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write(ps_msg)
   CALL lc_channel.close()
 
END FUNCTION
 
##########################################################################
# Descriptions...: 批次背景執行結果以javamail傳送
# Memo...........: 
# Input parameter: pc_result  結果 Y = success , N = fail
# Return code....: ls_path    訊息檔名
# Usage..........: CALL cl_batch_bg_javamail(g_success)
# Date & Author..: 05/07/01 by saki
##########################################################################
 
FUNCTION cl_batch_bg_javamail(pc_result)
   DEFINE   pc_result          LIKE type_file.chr1          #No.FUN-690005 VARCHAR(1)
   DEFINE   ls_tempdir         STRING
   DEFINE   ls_content         STRING
   DEFINE   ls_content_file    STRING
   DEFINE   ls_cmd             STRING
   DEFINE   li_result          LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
 
   IF g_bgjob = "N" THEN
      RETURN
   END IF
 
   LET ls_tempdir = FGL_GETENV("TEMPDIR")
 
   INITIALIZE g_xml TO NULL
   LET g_xml.recipient = FGL_GETENV("MAIL_TO")
   LET g_xml.cc = FGL_GETENV("MAIL_CC")
   LET g_xml.bcc = FGL_GETENV("MAIL_BCC")
 
   IF (NOT cl_null(g_xml.recipient)) OR (NOT cl_null(g_xml.cc)) OR
      (NOT cl_null(g_xml.bcc)) THEN
      LET g_xml.subject = "批次背景執行作業結果 The Result of Batch Job that Execute Automatically (",g_prog,")"
 
      LET ls_content = "Program : ",cl_get_progname(g_prog,g_lang)," (",g_prog,")\n",
                       "Execute Time : ",TODAY, " ",TIME,"\n"
      IF (NOT cl_null(g_bgjob_msgfile)) THEN
         LET ls_content = ls_content,
                          "The Result : Fail"
      ELSE
         CASE
            WHEN pc_result = "Y"
               LET ls_content = ls_content,
                                "The Result : Success"
            WHEN pc_result = "N"
               LET ls_content = ls_content,
                                "The Result : Fail"
            OTHERWISE
               LET ls_content = ls_content,
                                "The Result : ?"
         END CASE
      END IF
 
#     #TQC-780076
#     LET ls_content_file = ls_tempdir,"/batch_bg_content_" || FGL_GETPID() || ".txt"
      LET ls_content_file = "batch_bg_content_" || FGL_GETPID() || ".txt"
      LET ls_content_file = os.Path.join(ls_tempdir.trim(),ls_content_file.trim())
 
      LET ls_cmd = "echo '" || ls_content || "' > " || ls_content_file
      RUN ls_cmd WITHOUT WAITING
      LET g_xml.body = ls_content_file
 
      IF (NOT cl_null(g_bgjob_msgfile)) THEN
#        LET ls_cmd = "test -s ",g_bgjob_msgfile
#        RUN ls_cmd RETURNING li_result
#        IF NOT li_result THEN
         IF os.Path.exists(g_bgjob_msgfile) THEN   #TQC-780076
            LET ls_cmd = FGL_GETENV("DS4GL"),"/bin/addcr ",g_bgjob_msgfile
            RUN ls_cmd
            LET g_xml.attach = g_bgjob_msgfile
         END IF
      END IF
 
      CALL cl_jmail()
 
#     RUN "rm -f " || ls_content_file    #TQC-780076
      IF os.Path.delete(ls_content_file.trim()) THEN
      END IF
 
   END IF
END FUNCTION
