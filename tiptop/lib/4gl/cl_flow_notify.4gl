# Prog. Version..: '5.30.06-13.03.12(00003)'     #
 
# Program name...: cl_flow_notify.4gl
# Descriptions...: 工作流程的通知.
# Date & Author..: 2003/07/07 by Hiko
# Usage..........: CALL cl_flow_notify(g_oea.oea01, 'I')
# Modify.........: 04/09/16 by alex 使用 g_sys時後方需加上 CLIPPED or .trim()
# Modify.........: No.MOD-540118 05/04/18 by saki 修改夾檔路徑
# Modify.........: No.FUN-4A0081 05/07/14 by saki By條件寄送信件,新增建議執行程式之功能
# Modify.........: No.FUN-690005 06/09/04 By cheunl 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6B0036 07/03/21 by Brendan 代辦事項與鼎新 Product Portal 整合
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-870112 08/07/10 By Sarah gag_file串gaf_file,判斷gafacti='Y'才可進入
# Modify.........: No.FUN-8C0029 08/12/04 By alex 調整 mail 格式
# Modify.........: No:FUN-A40045 10/05/21 By Jay 將事件觸發人員也寄送一份mail副本
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
GLOBALS "../../aws/4gl/aws_ppgw.inc"   #FUN-6B0036  Include Product Portal 整合變數檔
 
##################################################
# Descriptions...: 工作流程的通知.
# Date & Author..: 2003/07/07 by Hiko
# Input Parameter: ps_doc_no STRING 單據編號
#                  pc_state VARCHAR(1) 功能類別(I.新增 U.更改 D.刪除 Y.確認 S.過帳 V.作廢)
# Return code....: void
##################################################
 
FUNCTION cl_flow_notify(ps_doc_no, pc_state)
   DEFINE   ps_doc_no      STRING,
            pc_state       LIKE gag_file.gag04    #No.FUN-690005  VARCHAR(1)
   DEFINE   lr_gag         RECORD LIKE gag_file.*
   DEFINE   lr_gah         RECORD LIKE gah_file.*
   DEFINE   lr_mail_info   RECORD LIKE gai_file.*
   DEFINE   ls_doc         STRING                 #No.FUN-4A0081
   DEFINE   ls_sql         STRING                 #No.FUN-4A0081
   DEFINE   ls_send_flag   LIKE type_file.num5    #No.FUN-690005  SMALLINT    #No.FUN-4A0081
   DEFINE   lst_doc_names  base.StringTokenizer   #No.FUN-4A0081
   DEFINE   ls_doc_name    STRING                 #No.FUN-4A0081
 
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   #No.FUN-4A0081 --start--
   LET ls_doc = s_get_doc_no(ps_doc_no)
 
   LET ls_sql = "SELECT * FROM gag_file",
                " WHERE gag03='",g_prog,"' AND gag04='",pc_state,"'",
                "   AND gag01 IN (SELECT gaf01 FROM gaf_file WHERE gafacti='Y')"   #MOD-870112 add
   PREPARE gag_pre FROM ls_sql
   DECLARE gag_curs CURSOR FOR gag_pre
 
   FOREACH gag_curs INTO lr_gag.*
      IF (SQLCA.SQLCODE) THEN
        #IF (g_trace = 'Y') THEN
        #   DISPLAY "cl_flow_notify : Select no data from gag_file where gag03=" || g_prog || " and gag04=" || pc_state
        #END IF
 
         RETURN
      END IF
 
      IF lr_gag.gag14 = "2" THEN                       # By單別
         LET ls_send_flag = FALSE
         LET lst_doc_names = base.StringTokenizer.create(lr_gag.gag17,"|")
         WHILE lst_doc_names.hasMoreTokens()
            LET ls_doc_name = lst_doc_names.nextToken()
            LET ls_doc_name = ls_doc_name.trim()
            IF ls_doc.equals(ls_doc_name) THEN
               LET ls_send_flag = TRUE
               EXIT WHILE
            END IF
         END WHILE
      ELSE
         LET ls_send_flag = TRUE
      END IF
 
      IF (NOT ls_send_flag) THEN
         CONTINUE FOREACH
      END IF
 
      LET lr_gah.gah01 = cl_get_msg_no(ps_doc_no)      # 訊息編號($模組別_單據編號_三位流水號)
      LET lr_gah.gah02 = lr_gag.gag11                  # 指定處理人員
      LET lr_gah.gah03 = CURRENT YEAR TO SECOND        # 產生日期(Year to Second)
      LET lr_gah.gah04 = lr_gag.gag10                  # 等級(A.緊急 B.重要 C.一般 D.通知 E.紀錄)
      LET lr_gah.gah05 = ps_doc_no                     # 單據編號
      LET lr_gah.gah06 = lr_gag.gag08                  # 訊息內容(應該要包含程式代號與功能類別)
      LET lr_gah.gah07 = lr_gag.gag09                  # 建議執行程式代號
      LET lr_gah.gah08 = cl_get_deadline(lr_gag.gag12) # 處理期限(NULL為無限期完成)
      LET lr_gah.gah09 = NULL                          # 處理完成日期(NULL為未完成)
      LET lr_gah.gah10 = lr_gag.gag13                  # 逾期處理時的Mail通知清單
      LET lr_gah.gah11 = lr_gag.gag15
 
      INSERT INTO gah_file VALUES(lr_gah.*)
 
      LET lr_mail_info.gai01 = lr_gah.gah01
      LET lr_mail_info.gai02 = lr_gah.gah04
      LET lr_mail_info.gai03 = lr_gah.gah06
      LET lr_mail_info.gai04 = lr_gah.gah07
      LET lr_mail_info.gai05 = lr_gag.gag06
      LET lr_mail_info.gai06 = lr_gag.gag07
 
      CASE lr_gag.gag05
         WHEN '1'
            IF (g_trace = 'Y') THEN
               DISPLAY "cl_flow_notify : Send mail right now."
            END IF
            
            CALL cl_flow_mail("Work flow notify", lr_mail_info.*)
         WHEN '2'
            INSERT INTO gai_file VALUES(lr_mail_info.*) 
      END CASE
 
      CALL cl_ppcli_createToDoList(lr_gah.*)   #FUN-6B0036 代辦事項拋轉至 Product Portal
   END FOREACH
END FUNCTION
 
##################################################
# Descriptions...: 回傳流程通知的訊息代號.
# Date & Author..: 2003/07/07 by Hiko
# Input Parameter: ps_doc_no STRING 單據編號
# Return code....: void
# Memo...........: 訊息號碼($模組別_單據編號_三位流水號)
##################################################
 
FUNCTION cl_get_msg_no(ps_doc_no)
   DEFINE   ps_doc_no          STRING
   DEFINE   ls_sql             STRING
   DEFINE   lc_max_msg_no      LIKE gah_file.gah01,
            ls_max_msg_no      STRING,
            li_max_msg_order   LIKE type_file.num5      #No.FUN-690005  SMALLINT
 
 
   LET ps_doc_no = ps_doc_no.trim()
   LET ls_sql = "SELECT gah01 FROM gah_file" ||
                " WHERE gah01 LIKE '" || g_sys CLIPPED || "_" || ps_doc_no || "_%'" ||
#                 " AND gah02 LIKE '%" || g_user || "%'" ||
#                 " AND gah02='" || g_user || "'" ||
                " ORDER BY gah01 DESC"
 
   IF (g_trace = 'Y') THEN
      DISPLAY "cl_flow_notify : SQL with message no = " || ls_sql
   END IF
 
   DECLARE lcurs_gah SCROLL CURSOR FROM ls_sql
   OPEN lcurs_gah
   FETCH FIRST lcurs_gah INTO lc_max_msg_no
   IF (NOT SQLCA.SQLCODE) THEN
      # 2003/05/29 為了要拆解訊息編號的字串,所以要將CHAR轉成STRING.
      LET ls_max_msg_no = lc_max_msg_no
      LET ls_max_msg_no = ls_max_msg_no.trim()
      # 2003/12/22 by Hiko : 第一,二個'1'為'_'的長度;第三個'1'為索引值加1.
      LET li_max_msg_order = ls_max_msg_no.subString(LENGTH(g_sys CLIPPED)+1+ps_doc_no.getLength()+1+1, ls_max_msg_no.getLength())
   END IF
   CLOSE lcurs_gah
 
   RETURN g_sys CLIPPED || "_" || ps_doc_no || "_" || (li_max_msg_order+1 USING "&&&")
END FUNCTION
 
##################################################
# Descriptions...: 回傳最後期限.
# Date & Author..: 2003/12/23 by Hiko
# Input Parameter: pi_proc_days SMALLINT 處理天數
# Return code....: void
##################################################
 
FUNCTION cl_get_deadline(pi_proc_days)
   DEFINE   pi_proc_days    LIKE type_file.num5      #No.FUN-690005  SMALLINT
   DEFINE   lday_deadline   LIKE type_file.dat       #No.FUN-690005  DATE
   
 
   # 2003/12/23 by Hiko : 處理天數為0,表示沒有處理期限,所以回傳NULL.
   IF (pi_proc_days = 0) THEN
      LET lday_deadline = NULL
   ELSE
      LET lday_deadline = TODAY + pi_proc_days
   END IF
   
   RETURN lday_deadline
END FUNCTION
 
##################################################
# Descriptions...: 透過JavaMail傳送工作流程通知.
# Date & Author..: 2003/07/07 by Hiko
# Input Parameter: ps_pre_subject STRING Mail通知的前段主旨
#                  pr_mail_info RECORD Mail通知的相關資料
# Return code....: void
# Memo...........: 此段程式也要給批次Mail通知的背景執行程式呼叫.
##################################################
 
FUNCTION cl_flow_mail(ps_pre_subject, pr_mail_info)
   DEFINE   ps_pre_subject    STRING,
            pr_mail_info      RECORD LIKE gai_file.*
   DEFINE   ls_context        STRING,
            ls_context_file   STRING,
            ls_unix_cmd       STRING
   DEFINE   ls_temp_path      STRING
   DEFINE   l_gai06           LIKE gai_file.gai06,    #No.FUN-A40045
            l_user_mail       STRING,                 #No.FUN-A40045
            l_cc_mail         STRING,                 #No.FUN-A40045
            l_recipient       STRING,                 #No.FUN-A40045
            l_mail_user       STRING                  #No.FUN-A40045
 
   LET l_mail_user = 'Y'                              #No.FUN-A40045
   IF (cl_null(g_bgjob) OR g_bgjob != 'Y') THEN
      CALL cl_progress_bar(3)
      CALL cl_progressing("Prepare mail info")
   END IF
 
   INITIALIZE g_xml TO NULL
   LET g_xml.subject = ps_pre_subject || " : " || pr_mail_info.gai01 CLIPPED
   # 2003/05/30 By Hiko : 將內文存成檔案,以符合JavaMail的傳送格式.
    # No.MOD-540118 --start--
   LET ls_context = "Grade   : " ,pr_mail_info.gai02 , "<br>\n" ,   #FUN-8C0029
                    "Message : " ,pr_mail_info.gai03 CLIPPED , "<br>\n" ,
                    "Program : " ,pr_mail_info.gai04 CLIPPED
   LET ls_temp_path = FGL_GETENV("TEMPDIR")
   LET ls_context_file = ls_temp_path,"/flow_context_" || FGL_GETPID() || ".txt"
    # No.MOD-540118 ---end---
   LET ls_unix_cmd = "echo '" || ls_context || "' > " || ls_context_file
   RUN ls_unix_cmd WITHOUT WAITING
   #CKP 2003/12/18 by Hiko : 因為mlj_file沒有資料,所以先設定.
#  LET g_xml.mailserver = "10.40.40.99"
#  LET g_xml.serverport = "25"
#  LET g_xml.user = "topftp"
#  LET g_xml.passwd = "demo@erp:demo"
   LET g_xml.file = "flownotify_" || FGL_GETPID() || ".xml"
   ##
   LET g_xml.body = ls_context_file    
   LET g_xml.recipient = pr_mail_info.gai05 CLIPPED
   
   #----------FUN-A40045 modify start------------------------
   IF l_mail_user = 'Y' THEN
      CALL cl_flow_zx09(g_user) RETURNING l_gai06                            
      IF NOT cl_null(l_gai06) THEN
         LET l_recipient = pr_mail_info.gai05 CLIPPED
         LET l_cc_mail = pr_mail_info.gai06 CLIPPED
         LET l_user_mail = l_gai06 CLIPPED
         LET l_user_mail = l_user_mail.substring(1, l_user_mail.getindexof(":",1) - 1)
         IF l_cc_mail.getindexof(l_user_mail, 1) = 0 AND 
            l_recipient.getindexof(l_user_mail, 1) = 0 THEN
            LET pr_mail_info.gai06 = l_gai06, ";", pr_mail_info.gai06 CLIPPED   
         END IF
      END IF 
   END IF                                                                
   #----------FUN-A40045 modify end--------------------------
   
   LET g_xml.cc = pr_mail_info.gai06 CLIPPED
 
   IF (cl_null(g_bgjob) OR g_bgjob != 'Y') THEN
      CALL cl_progressing("Prepare to send mail")
   END IF
 
   CALL cl_jmail()
 
   IF (cl_null(g_bgjob) OR g_bgjob != 'Y') THEN
      CALL cl_progressing("Finish")
   END IF
 
   RUN "rm -f " || ls_context_file
   RUN "rm -f " || g_xml.file
END FUNCTION

#----------FUN-A40045 modify start------------------------
FUNCTION cl_flow_zx09(l_user)
   DEFINE   l_user      LIKE zx_file.zx01
   DEFINE   l_zx02      LIKE zx_file.zx02,
            l_zx09      LIKE zx_file.zx09
   DEFINE   l_gai06     LIKE gai_file.gai06
   DEFINE   ls_mail     STRING

   LET ls_mail = ""

   SELECT zx02, zx09 INTO l_zx02, l_zx09 FROM zx_file WHERE zx01 = l_user
   IF SQLCA.SQLCODE OR cl_null(l_zx09) THEN
      LET l_zx02 = ""
      LET l_zx09 = ""
      IF NOT cl_null(ls_mail) THEN
         LET ls_mail = ls_mail
      END IF
   ELSE
      IF NOT cl_null(ls_mail) THEN
         LET ls_mail = ls_mail,";"
      END IF
      IF cl_null(l_zx02) THEN
         LET ls_mail = ls_mail,l_zx09,":",l_user
      ELSE
         LET ls_mail = ls_mail,l_zx09,":",l_zx02
      END IF
   END IF

   LET ls_mail = ls_mail.trim()
   LET l_gai06 = ls_mail

   RETURN l_gai06
END FUNCTION
#----------FUN-A40045 modify end--------------------------
