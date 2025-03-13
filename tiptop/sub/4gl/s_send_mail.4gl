# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_send_mail.4gl
# Descriptions...: 发送邮件
# Date & Author..: #FUN-D10060 13/01/15 By xumm
# Input Parameter: p_prog,p_no
# Return code....: none
# Memo           : p_prog:程序名称
# Memo           : p_no:單號

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_ttsrv2_global.4gl"

FUNCTION s_send_mail(p_prog,p_no)
DEFINE p_no           VARCHAR(40)
DEFINE p_prog         VARCHAR(40)
DEFINE l_sql          STRING
DEFINE l_str          STRING
DEFINE l_str1         LIKE gaq_file.gaq03
DEFINE l_cnt          INTEGER
DEFINE l_cnt1         INTEGER
DEFINE l_mlk03        VARCHAR(01),
       l_mlk04        VARCHAR(40),
       l_mlk05        VARCHAR(20)
DEFINE lc_channel     base.Channel
DEFINE l_tempdir      LIKE type_file.chr20
DEFINE l_cmd          LIKE type_file.chr1000
DEFINE l_ze01         LIKE ze_file.ze01
DEFINE l_code         STRING
DEFINE g_ryl          DYNAMIC ARRAY OF RECORD
                      ryl01    LIKE ryl_file.ryl01,
                      ryl02    LIKE ryl_file.ryl02,
                      ryl03    LIKE ryl_file.ryl03,
                      ryl04    LIKE ryl_file.ryl04,
                      ryl05    LIKE ryl_file.ryl05,
                      ryl06    LIKE ryl_file.ryl06,
                      ryl07    LIKE ryl_file.ryl07,
                      ryl10    LIKE ryl_file.ryl10,
                      ryl11    LIKE ryl_file.ryl11,
                      ryl12    LIKE ryl_file.ryl12,
                      ryl13    LIKE ryl_file.ryl13
                      END RECORD
 
   # 處理recipient,cc,bcc
   LET l_sql = "SELECT mlk03,mlk04,mlk05 FROM mlk_file WHERE mlk01 = '",p_prog,"'"
   PREPARE mlk_pre FROM l_sql
   DECLARE mlk_curs CURSOR FOR mlk_pre
   LET l_cnt = 1
   LET g_xml.recipient = NULL
   LET g_xml.cc = NULL
   LET g_xml.bcc = NULL
   FOREACH mlk_curs INTO l_mlk03,l_mlk04,l_mlk05
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      CASE l_mlk03
         WHEN "1"
            IF NOT cl_null(l_mlk04) THEN
               LET l_mlk04 = l_mlk04 CLIPPED,":"
            END IF
            IF g_bgjob = "Y" THEN
               IF NOT cl_null(l_mlk05) THEN
                  LET l_mlk05 = l_mlk05 CLIPPED,"\\\;"
               END IF
            ELSE
               IF NOT cl_null(l_mlk05) THEN
                  LET l_mlk05 = l_mlk05 CLIPPED,";"
               END IF
            END IF
            LET g_xml.recipient = g_xml.recipient CLIPPED, l_mlk04 CLIPPED, l_mlk05 CLIPPED
         WHEN "2"
            IF NOT cl_null(l_mlk04) THEN
               LET l_mlk04 = l_mlk04 CLIPPED,":"
            END IF
            IF g_bgjob = "Y" THEN
               IF NOT cl_null(l_mlk05) THEN
                  LET l_mlk05 = l_mlk05 CLIPPED,"\\\;"
               END IF
            ELSE
               IF NOT cl_null(l_mlk05) THEN
                  LET l_mlk05 = l_mlk05 CLIPPED,";"
               END IF
            END IF
            LET g_xml.cc = g_xml.cc CLIPPED, l_mlk04 CLIPPED, l_mlk05 CLIPPED
         WHEN "3"
            IF NOT cl_null(l_mlk04) THEN
               LET l_mlk04 = l_mlk04 CLIPPED,":"
            END IF
            IF g_bgjob = "Y" THEN
               IF NOT cl_null(l_mlk05) THEN
                  LET l_mlk05 = l_mlk05 CLIPPED,"\\\;"
               END IF
            ELSE
               IF NOT cl_null(l_mlk05) THEN
                  LET l_mlk05 = l_mlk05 CLIPPED,";"
               END IF
            END IF
            LET g_xml.bcc = g_xml.bcc CLIPPED, l_mlk04 CLIPPED, l_mlk05 CLIPPED
      END CASE
      LET l_cnt = l_cnt + 1
   END FOREACH

   IF cl_null(g_xml.recipient) THEN
      RETURN
   END IF
 
   # 處理subject
   CASE p_prog
      WHEN "apcp100"
         LET g_xml.subject = cl_getmsg('sub-538',g_lang)
      WHEN "apcp101"
         LET g_xml.subject = cl_getmsg('sub-539',g_lang)
      WHEN "apcp200"
         LET g_xml.subject = cl_getmsg('sub-540',g_lang)
      OTHERWISE 
         LET g_xml.subject = cl_getmsg('sub-541',g_lang),"(",p_prog CLIPPED,")"
   END CASE

   # 產生xml文本檔
   LET l_tempdir = FGL_GETENV("TEMPDIR")
   LET l_cmd = p_prog CLIPPED,'.htm'
   LET l_cmd = os.Path.join(l_tempdir CLIPPED,l_cmd CLIPPED)
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(l_cmd,"w")
   CALL lc_channel.setDelimiter("")

   LET l_str = "<html>"
   CALL lc_channel.write(l_str)
   LET l_str = "<head>"
   CALL lc_channel.write(l_str)

   LET l_str = "<title>",g_xml.subject CLIPPED,"</title>"
   CALL lc_channel.write(l_str)
   LET l_str = "</head>"
   CALL lc_channel.write(l_str)
   LET l_str = "<body>"
   CALL lc_channel.write(l_str)

   #本文
   IF p_prog = 'apcp100' OR p_prog = 'apcp101' THEN
      LET l_str = 'Dear ALL:',"<br>"
      CALL lc_channel.write(l_str)
      LET l_str = ' ',"<br>"
      CALL lc_channel.write(l_str)
      LET l_cnt1 = 1
      LET l_sql = "SELECT ryl01,ryl02,'','',ryl05,ryl06,ryl07,ryl10,ryl11,ryl12,ryl13 FROM ryl_file",
                  " WHERE ryl01 = '",p_no,"'"
      PREPARE ryl_pre FROM l_sql
      DECLARE ryl_curs CURSOR FOR ryl_pre
      FOREACH ryl_curs INTO g_ryl[l_cnt1].*
         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl01' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl01
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl02' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl02
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl05' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl05
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl06' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl06
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl07' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl07
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl10' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl10," ",g_ryl[l_cnt1].ryl11
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl12' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl12
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl13' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl13
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)
         LET l_cnt1 = l_cnt1 + 1
         LET l_str = ' ',"<br>"
         CALL lc_channel.write(l_str)
      END FOREACH
   END IF
   IF p_prog = 'apcp200' THEN
      LET l_str = 'Dear ALL:',"<br>"
      CALL lc_channel.write(l_str)
      LET l_str = ' ',"<br>"
      CALL lc_channel.write(l_str)
      LET l_cnt1 = 1
      LET l_sql = "SELECT ryl01,ryl02,ryl03,ryl04,ryl05,ryl06,ryl07,ryl10,ryl11,ryl12,ryl13 FROM ryl_file",
                  " WHERE ryl01 = '",p_no,"'"
      PREPARE ryl_pre1 FROM l_sql
      DECLARE ryl_curs1 CURSOR FOR ryl_pre1
      FOREACH ryl_curs1 INTO g_ryl[l_cnt1].*
         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl01' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl01
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl02' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl02
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl03' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl03
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl04' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl04
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl05' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl05
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl06' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl06
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl07' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl07
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl10' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl10," ",g_ryl[l_cnt1].ryl11
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl12' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl12
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)

         SELECT gaq03 INTO l_str1 FROM gaq_file WHERE gaq01 = 'ryl13' AND gaq02 = g_lang
         LET l_str = l_str1 CLIPPED,":",g_ryl[l_cnt1].ryl13
         LET l_str = l_str CLIPPED,"<br>"
         CALL lc_channel.write(l_str)
         LET l_cnt1 = l_cnt1 + 1
         LET l_str = ' ',"<br>"
         CALL lc_channel.write(l_str)
      END FOREACH
   END IF
   LET l_str = "</body>"
   CALL lc_channel.write(l_str)
   LET l_str = "</html>"
   CALL lc_channel.write(l_str)
   CALL lc_channel.close()
   IF os.Path.chrwx(l_cmd CLIPPED,511) THEN END IF
   LET g_xml.body = l_cmd 
   CALL cl_jmail()
END FUNCTION
#FUN-D10060
