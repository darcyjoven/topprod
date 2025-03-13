# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_log.4gl
# Descriptions...: 程式資料log檔
# Date & Author..: 05/01/25 by saki
# Modify.........: No.TQC-5A0014 05/10/07 By saki 將$TOP/log/system權限放大成777
# Modify.........: No.TQC-5B0003 05/11/01 By saki 調整檔案權限只限第一次建立時
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-750079 07/05/21 By alex 新增MSV判斷條件
# Modify.........: No.TQC-780076 07/08/22 By alex 修改 os.Path.exist用法
# Modify.........: No.TQC-780090 07/08/30 By saki 所有mkdir system的地方後面都要做chmod 777
# Modify.........: No.TQC-790023 07/09/04 By saki 修改改語法後的問題
# Modify.........: No.FUN-7B0081 08/01/10 By alex gae05移至gbs06並處理gae12問題
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.FUN-BA0055 11/11/14 By jrg542 cl_log現僅使用檔案進行 log 的紀錄，調整可使用table進行log的紀錄，並且依照重要性區分log等級   
# Modify.........: No.FUN-BC0054 11/12/30 By jrg542 開發 log 抓取及清除機制及修改將系統日誌寫入外部日誌設備 
# Modify.........: No.FUN-C40105 12/05/08 By madey 新增依azz_file.azz19判斷是否啟用外部日誌  
# Modify.........: No:DEV-C50001 12/05/17 By joyce 1.syslog新增三個欄位(gdp09、gdp10、gdp11)
#                                                  2.調整傳入外部log機的訊息
# Modify.........: No:DEV-C60002 12/06/29 By joyce 個資傳到外部log機的資訊格式應依個資小組定義的格式
# Modify.........: No:FUN-CA0016 12/12/28 By joyce 1.若g_user或g_prog為空，需重新給值，以避免寫入syslog時發生錯誤
#                                                  2.取得serverip時，仿照cl_get_tpserver_ip的寫法，但改為直接抓取$FGLASIP的值再去解析

IMPORT os   #FUN-750079 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   lr_log            DYNAMIC ARRAY OF RECORD
            change_time    STRING,
            action         STRING,
            change_value   STRING,
            old_value      STRING
                           END RECORD
 
# Descriptions...: 紀錄程式資料變更
# Date & Author..: 05/01/25 by saki
# Input Parameter: ps_prog    STRING   維護程式代號
#                  ps_type    STRING   維護動作,i新增,u修改,d刪除,r回復update
#                  ps_str_o   STRING   新增值、刪除值、修改舊值
#                  ps_str_n   STRING   修改新值
# Return code....: void
# Usage..........: CALL cl_log("p_feldname")
# Modify.........: No.FUN-750079 07/05/21 by alex 新增MSV判斷條件
 
FUNCTION cl_log(ps_prog,ps_type,ps_str_n,ps_str_o)
 
   DEFINE   ps_prog      STRING
   DEFINE   ps_type      STRING
   DEFINE   ps_str_o     STRING
   DEFINE   ps_str_n     STRING
   DEFINE   ls_logdir   STRING
   DEFINE   ls_str      STRING
   DEFINE   ls_cmd      STRING
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   lc_channel  base.Channel
 
   DEFINE   ls_module   STRING                #No.FUN-BA0055  #模組
   DEFINE   lc_type     LIKE  type_file.chr1  #No.FUN-BA0055  #類別
   DEFINE   lc_class    LIKE  type_file.chr1  #No.FUN-BA0055  #等級
   DEFINE   ls_prog     STRING                #No.FUN-BA0055  #程式

   IF (ps_prog IS NULL) OR (ps_type IS NULL) THEN
      RETURN
   END IF
   LET ps_type = ps_type.toLowerCase()
   IF (ps_type = "u") AND (ps_str_o IS NULL) THEN  #u(修改) ps_str_o(新增值、刪除值、修改舊值)  
      RETURN
   END IF
     
#  FUN-750079 head
#  LET ls_logdir = FGL_GETENV("TOP"),"/log/system"
   LET ls_logdir = FGL_GETENV("TOP")
   LET ls_logdir = os.Path.join(ls_logdir.trim(),"log")
   LET ls_logdir = os.Path.join(ls_logdir.trim(),"system")
 
#  LET ls_cmd = "test -s ",ls_logdir
#  RUN ls_cmd RETURNING li_result
#  IF li_result THEN
   IF NOT os.Path.exists(ls_logdir.trim()) THEN   #TQC-780076
 
#     LET ls_cmd = "mkdir -p ",ls_logdir
#     RUN ls_cmd
      IF os.Path.mkdir(ls_logdir.trim()) THEN
      END IF
 
      #No.TQC-5A0014 --start-- No.TQC-5B0003 ---移
#     LET ls_cmd = "chmod -R 777 ",ls_logdir
#     RUN ls_cmd
      IF os.Path.separator() = "/" THEN
         IF os.Path.chrwx(ls_logdir.trim(),511) THEN #chmod 777 => 7*8^2 +7*8^1 +7*8^
         END IF
      END IF
 
      #No.TQC-5A0014 ---end--- No.TQC-5B0003 ---
   END IF
 
   LET lc_channel = base.Channel.create()
#  LET ls_str = ls_logdir,"/",ps_prog,".log"
   LET ls_str = os.Path.join(ls_logdir,ps_prog.trim()||".log")
 
#  LET ls_cmd = "test -s ",ls_logdir,"/",ps_prog,".log"
#  RUN ls_cmd RETURNING li_result
 
#  IF li_result THEN
   IF NOT os.Path.exists(ls_str.trim()) THEN     #TQC-780076 
      LET li_result = TRUE                       #No.TQC-790023
      CALL lc_channel.openFile(ls_str,"w")
   ELSE
      CALL lc_channel.openFile(ls_str,"a")
   END IF
 
   CALL lc_channel.setDelimiter("")
   CASE ps_type
      WHEN "i"    #新增
         LET ls_str = TODAY," ",TIME," INSERT"
      WHEN "u"    #u修改
         LET ls_str = TODAY," ",TIME," UPDATE"
      WHEN "d"    #d刪除
         LET ls_str = TODAY," ",TIME," DELETE"
      WHEN "r"    #r回復updater
         LET ls_str = TODAY," ",TIME," UPDATE ALL"
      WHEN "h"
         LET ls_str = TODAY," ",TIME," UPDATE Header"
      WHEN "b"
         LET ls_str = TODAY," ",TIME," UPDATE Detail"
   END CASE
 
   CALL lc_channel.write(ls_str)
   IF ps_type != "r" THEN
      CALL cl_replace_str(ps_str_n,"\n","\r") RETURNING ps_str_n
      CALL lc_channel.write(ps_str_n)
   END IF
   IF (ps_type = "u") OR (ps_type = "h") OR (ps_type = "b") THEN
      CALL cl_replace_str(ps_str_o,"\n","\r") RETURNING ps_str_o
      CALL lc_channel.write(ps_str_o)
   END IF
   LET ls_str = "==========================================================================="
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()
 
   IF li_result THEN
 
#     LET ls_cmd = "chmod 777 ",ls_logdir,"/",ps_prog,".log"
#     RUN ls_cmd
      IF os.Path.separator() = "/" THEN
         LET ls_str = os.Path.join(ls_logdir,ps_prog||".log")
         IF os.Path.chrwx(ls_str.trim(),511) THEN #chmod 777 => 7*8^2 +7*8^1 +7*8^
         END IF
      END IF
 
   END IF

   #No.FUN-BA0055 insert DB gdp_file(log 歷史資料儲存) start
   LET ls_prog = DOWNSHIFT(g_prog)

   IF ls_prog.subString(1,2) OR ls_prog.getIndexOf(1,"aoo")
      OR ls_prog.getIndexOf(1,"azz") THEN
      LET lc_type = 'S'   #類別 S 系統
      LET lc_class = 'A'  #等級 A 允許
   ELSE
      LET lc_type = 'G'   #類別 G 一般
      LET lc_class = 'A'  #等級 A 允許 
   END IF
   IF cl_syslog(lc_class,lc_type,ps_str_n) THEN END IF

END FUNCTION


# Descriptions...: 系統操作紀錄
# Date & Author..: 11/12/28 by alex
# Input Parameter: lc_type    CHAR(1)  種類 "W" Warning/"E" Error/"A" Allowed
#                  lc_layer   CHAR(1)  層級 "S" System/"G" General/"D" Detail(可off)
#                  ls_msg     STRING   寫入syslog的訊息
# Usage..........: CALL cl_syslog("W","S","User want to download data about:"||l_sql)
# Memo...........: 傳入後，系統會自動抓取g_user/g_today/g_time/g_plant/g_dbs
# Return code....: status     TRUE/FALSE
 
FUNCTION cl_syslog(lc_type,lc_layer,ls_msg)

   #insert DB gdp_file(log 歷史資料儲存) start #No.FUN-BA0055
   DEFINE lc_gdp         RECORD LIKE gdp_file.*  #No.FUN-BA0055 
   DEFINE ls_msg         STRING                  #No.FUN-BA0055  #訊息
   DEFINE lc_type        LIKE type_file.chr1     #No.FUN-BA0055  #類別
   DEFINE lc_layer       LIKE type_file.chr1     #No.FUN-BA0055  #等級
   DEFINE lc_azz_azz19   LIKE azz_file.azz19     #FUN-C40105
   DEFINE ls_gae02       LIKE gae_file.gae02     #No:DEV-C60002
   DEFINE ls_gdp03_name  LIKE zx_file.zx02       #No:DEV-C60002
   DEFINE ls_gdp04_name  LIKE gaz_file.gaz03     #No:DEV-C60002
   DEFINE ls_gdp05_name  LIKE gae_file.gae04     #No:DEV-C60002
   DEFINE ls_gdp06_name  LIKE gae_file.gae04     #No:DEV-C60002
   DEFINE ls_serverip    STRING                  #No:FUN-CA0016

   # No:FUN-CA0016 ---start---
   # 若是g_user或是g_prog為空，需重新給值，以避免寫入syslog發生錯誤
   IF cl_null(g_user) THEN
      CALL cl_get_user()
   END IF

   IF cl_null(g_prog) THEN
      LET g_prog = ui.Interface.getName()
   END IF
   # No:FUN-CA0016 --- end ---

   LET lc_gdp.gdp01 = TODAY                               #日期
#  LET lc_gdp.gdp02 = TIME(CURRENT)                       #時間
   LET lc_gdp.gdp02 = CURRENT HOUR TO FRACTION(3)         #時間     # No:DEV-C50001 記錄到毫秒
   LET lc_gdp.gdp03 = g_user                              #使用者
   LET lc_gdp.gdp04 = g_prog                              #程式來源
   LET lc_gdp.gdp05 = lc_layer                            #類別  S(系統)/G(一般)/D(細節)
   LET lc_gdp.gdp06 = lc_type                             #等級  W(警告)/E(錯誤)/A(允許)
   LET lc_gdp.gdp07 = g_plant,"/",g_dbs                   #營運中心編號/db name
   LET lc_gdp.gdp08 = ls_msg                              #說明內容


   # No:DEV-C50001 ---start---

   # No:FUN-CA0016 --- modify start---
   # 因為cl_get_tpserver_ip()是去抓取aza58的值，
   # 若是該欄位為空，或是帶的不是客戶真正的主機IP，就會有疑慮，
   # 因此仿照cl_get_tpserver_ip()的寫法，但改為直接抓取$FGLASIP的值再去解析

#  LET lc_gdp.gdp09 = cl_get_tpserver_ip()                #Server IP
   LET ls_serverip = FGL_GETENV("FGLASIP")

   IF ls_serverip IS NULL OR ls_serverip = " " THEN
      LET ls_serverip = "127.0.0.1"
   ELSE
      IF ls_serverip.getIndexOf("http://",1) THEN
         LET ls_serverip = ls_serverip.subString(ls_serverip.getIndexOf("http://",1)+7,ls_serverip.getLength())
      END IF
      IF ls_serverip.getIndexOf("/",1) THEN
         LET ls_serverip = ls_serverip.subString(1,ls_serverip.getIndexOf("/",1)-1)
      END IF

      #FUN-8A0138 去除冒號以後的字串
      IF ls_serverip.getIndexOf(":",1) THEN
         LET ls_serverip = ls_serverip.subString(1,ls_serverip.getIndexOf(":",1)-1)
      END IF

      IF ls_serverip.getLength() < 7 THEN
         LET ls_serverip = "127.0.0.1"
      END IF
   END IF

   LET lc_gdp.gdp09 = ls_serverip.trim()                  #Server IP
   # No:FUN-CA0016 -- modify end ---

   LET lc_gdp.gdp10 = cl_getClientIP()                    #Client IP
   # 因為WEB登入的話有可能會取不到Client IP，決議若是取不到則塞空白資料
   IF cl_null(lc_gdp.gdp10) THEN
      LET lc_gdp.gdp10 = " "
   END IF
   LET lc_gdp.gdp11 = FGL_GETPID() USING '<<<<<<<<<<'     #Process ID
   # No:DEV-C50001 --- end ---

   INSERT INTO gdp_file VALUES (lc_gdp.*)
   IF SQLCA.SQLCODE THEN
      RETURN FALSE
   ELSE
      #CALL cl_syslog_export_log4j(lc_type,ls_msg)  #No.FUN-BC0054 #FUN-C40105 mark

      #FUN-C40105 --start--
      SELECT azz19 INTO lc_azz_azz19 FROM azz_file WHERE azz01='0'
      IF lc_azz_azz19 = 'Y' THEN

         # No:DEV-C60002 ----start---
         SELECT zx02 INTO ls_gdp03_name FROM zx_file
          WHERE zx01 = lc_gdp.gdp03

         SELECT gaz03 INTO ls_gdp04_name FROM gaz_file
          WHERE gaz01 = lc_gdp.gdp04
            AND gaz02 = g_lang
            AND gaz05 = 'Y'
         IF cl_null(ls_gdp04_name) THEN
            SELECT gaz03 INTO ls_gdp04_name FROM gaz_file
             WHERE gaz01 = lc_gdp.gdp04
               AND gaz02 = g_lang
               AND gaz05 = 'N'
         END IF

         LET ls_gae02 = 'gdp05_',lc_layer CLIPPED
         SELECT gae04 INTO ls_gdp05_name FROM gae_file
          WHERE gae01 = 'p_syslog' AND gae02 = ls_gae02
            AND gae03 = g_lang

         LET ls_gae02 = 'gdp06_',lc_type CLIPPED
         SELECT gae04 INTO ls_gdp06_name FROM gae_file
          WHERE gae01 = 'p_syslog' AND gae02 = ls_gae02
            AND gae03 = g_lang
         # No:DEV-C60002 --- end ---

         # No:DEV-C50001 ---start---
         # 調整傳到外部log機的訊息
      #  LET ls_msg = lc_gdp.gdp01 CLIPPED,"--",lc_gdp.gdp02 CLIPPED,"--",lc_gdp.gdp03 CLIPPED,"--",
      #               lc_gdp.gdp04 CLIPPED,"--",lc_gdp.gdp05 CLIPPED,"--",lc_gdp.gdp06 CLIPPED,"--",
      #               lc_gdp.gdp07 CLIPPED,"--",lc_gdp.gdp09 CLIPPED,"--",lc_gdp.gdp10 CLIPPED,"--",
      #               lc_gdp.gdp11 CLIPPED,"--",lc_gdp.gdp08 CLIPPED
         # No:DEV-C60002 --- start---
         # 傳到外部log機的格式應與個資小組定義的一致
         # 第一個欄位須為產品名稱，欄位須加上欄位名稱，欄位間以TAB鍵當間隔
         LET ls_msg = "ProductName:TIPTOP	",
                      "Date:",lc_gdp.gdp01 CLIPPED,"	",
                      "Time:",lc_gdp.gdp02 CLIPPED,"	",
                      "UserID:",lc_gdp.gdp03 CLIPPED,"	",
                      "UserName:",ls_gdp03_name CLIPPED,"	",
                      "Program:",lc_gdp.gdp04 CLIPPED,"	",
                      "ProgramName:",ls_gdp04_name CLIPPED,"	",
                      "Level:",lc_gdp.gdp05 CLIPPED,"	",
                      "LevelName:",ls_gdp05_name CLIPPED,"	",
                      "Type:",lc_gdp.gdp06 CLIPPED,"	",
                      "TypeName:",ls_gdp06_name CLIPPED,"	",
                      "Plant:",lc_gdp.gdp07 CLIPPED,"	",
                      "ServerIP:",lc_gdp.gdp09 CLIPPED,"	",
                      "ClientIP:",lc_gdp.gdp10 CLIPPED,"	",
                      "ProcessID:",lc_gdp.gdp11 CLIPPED,"	",
                      "Description:",lc_gdp.gdp08 CLIPPED
         # No:DEV-C60002 --- end ---
         # No:DEV-C50001 --- end ---

         CALL cl_syslog_export_log4j(lc_type,ls_msg)  #No.FUN-BC0054
      END IF
      #FUN-C40105 --end--
      RETURN TRUE
   END IF
   #No.FUN-BA0055  end --
END FUNCTION


##################################################
# Descriptions...: export log4j
# Date & Author..: 11/12/31 by Jrg542
# Input Parameter: lc_type    CHAR(1)  種類 "W" Warning/"E" Error/"A" Allowed
#                  lc_layer   CHAR(1)  層級 "S" System/"G" General/"D" Detail(可off)
#                  ls_msg     STRING   寫入syslog的訊息
# Return code....: void

################################################## 

FUNCTION cl_syslog_export_log4j(lc_type,ls_msg)
   DEFINE ls_msg       STRING                  #No.FUN-BA0055  #訊息
   DEFINE lc_type      LIKE type_file.chr1     #No.FUN-BA0055  #類別
   DEFINE l_cmd STRING
   DEFINE l_out STRING
   DEFINE l_ch  base.Channel
   DEFINE l_buf STRING
   DEFINE l_pos LIKE type_file.num10
   DEFINE l_num STRING
   DEFINE l_msg STRING
   DEFINE l_len STRING
   DEFINE l_msg_temp STRING

   LET l_msg_temp = cl_replace_str(ls_msg,'"',"\\\"")
   #呼叫Java程式, 執行結果會輸出在stdout
   LET l_ch = base.Channel.create()
   CALL l_ch.setDelimiter("")
   LET l_cmd = "java -jar ",FGL_GETENV("DS4GL"),"/bin/TTExportLog/TTExportLog.jar ",
       "\"",lc_type,"\"" , " \"", l_msg_temp ," \""   
   LET l_cmd = l_cmd CLIPPED
   CALL l_ch.openPipe(l_cmd,"r")
   IF STATUS == 0 THEN
      WHILE TRUE
         CALL l_ch.readLine() RETURNING l_buf
         IF l_buf IS NULL THEN
            EXIT WHILE
         END IF
         LET l_out = l_out,l_buf
      END WHILE
   END IF
   CALL l_ch.close()
   #根據stdout訊息取得下載檔名
   LET l_pos = l_out.getIndexOf(" ",1)
   LET l_len = l_out.getLength()
   LET l_num = l_out.subString(1,l_pos - 1)
   LET l_msg = l_out.subString(l_pos + 1,l_len)
END FUNCTION 

# Descriptions...: 顯示程式資料變更
# Date & Author..: 2005/02/01 by saki
# Input Parameter: ps_prog    STRING   維護程式代號
# Return code....: void
 
FUNCTION cl_show_log(ps_prog)
 
   DEFINE   ps_prog           STRING
   DEFINE   lc_channel        base.Channel
   DEFINE   ls_str            STRING
   DEFINE   ls_cmd            STRING
   DEFINE   li_result         LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   ls_logdir         STRING
   DEFINE   ls_result         STRING
   DEFINE   li_cnt            LIKE type_file.num10         #No.FUN-690005 INTEGER
   DEFINE   li_inx_e          LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_end_flag       LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_new_str_flag   LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   l_ac              LIKE type_file.num10         #No.FUN-690005 INTEGER
 
#  LET ls_logdir = FGL_GETENV("TOP"),"/log/system"
   LET ls_logdir = FGL_GETENV("TOP")
   LET ls_logdir = os.Path.join(ls_logdir.trim(),"log")
   LET ls_logdir = os.Path.join(ls_logdir.trim(),"system")
 
#  LET ls_cmd = "test -s ",ls_logdir
#  RUN ls_cmd RETURNING li_result
#  IF li_result THEN
   IF NOT os.Path.exists(ls_logdir.trim()) THEN    #TQC-780076
#     LET ls_cmd = "mkdir -p ",ls_logdir
#     RUN ls_cmd
      IF os.Path.mkdir(ls_logdir.trim()) THEN
      END IF
 
      #No.TQC-780090 --start--
      IF os.Path.separator() = "/" THEN
         IF os.Path.chrwx(ls_logdir.trim(),511) THEN #chmod 777 => 7*8^2 +7*8^1 +7*8^
         END IF
      END IF
      #No.TQC-780090 ---end---
   END IF
 
#  LET ls_cmd = ls_logdir,"/",ps_prog,".log"
#  LET ls_str = ls_logdir,"/",ps_prog,".log"
   LET ls_str = os.Path.join(ls_logdir.trim(),ps_prog.trim()||".log")
 
#  LET ls_cmd = "test -s ",ls_logdir,"/",ps_prog,".log"
#  RUN ls_cmd RETURNING li_result
#  IF li_result THEN
   IF NOT os.Path.exists(ls_str.trim()) THEN   #TQC-780076
      RETURN
   END IF
 
   OPEN WINDOW log_w AT 7,7 WITH FORM "lib/42f/cl_show_log"
      ATTRIBUTE(STYLE="dialog")
 
   CALL cl_ui_locale("cl_show_log")
 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ls_str,"r")
   LET li_cnt = 1
   LET li_end_flag = TRUE
   LET li_new_str_flag = FALSE
   CALL lc_channel.setDelimiter("")
   WHILE (lc_channel.read(ls_result))
      IF ls_result.getIndexOf("========================================",1) THEN
         LET li_end_flag = TRUE
         LET li_new_str_flag = FALSE
         LET li_cnt = li_cnt + 1
         #No.TQC-630109 --start--
         IF li_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT WHILE
         END IF
         #No.TQC-630109 ---end---
         CONTINUE WHILE
      END IF
 
      IF li_end_flag THEN
         CASE
            WHEN ls_result.getIndexOf("UPDATE",1)
               LET li_inx_e = ls_result.getIndexOf("UPDATE",1)
            WHEN ls_result.getIndexOf("INSERT",1)
               LET li_inx_e = ls_result.getIndexOf("INSERT",1)
            WHEN ls_result.getIndexOf("DELETE",1)
               LET li_inx_e = ls_result.getIndexOf("DELETE",1)
         END CASE
         LET lr_log[li_cnt].change_time = ls_result.subString(1,li_inx_e - 2)
         LET lr_log[li_cnt].action = ls_result.subString(li_inx_e,ls_result.getLength())
         LET li_end_flag = FALSE
         CONTINUE WHILE
      END IF
 
      IF (NOT li_end_flag) AND (NOT li_new_str_flag) THEN
         LET lr_log[li_cnt].change_value = ls_result
         LET li_new_str_flag = TRUE
         CONTINUE WHILE
      END IF
 
      IF (NOT li_end_flag) AND (li_new_str_flag) THEN
         LET lr_log[li_cnt].old_value = ls_result
         LET li_new_str_flag = FALSE
         CONTINUE WHILE
      END IF
   END WHILE
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY lr_log TO s_log.* ATTRIBUTE(COUNT=li_cnt - 1,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION update_rollback
         CALL cl_log_rollback(ps_prog)
 
      ON ACTION exit
         EXIT DISPLAY
 
      #No.TQC-860016 --start--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
   CLOSE WINDOW log_w
END FUNCTION
 
# Descriptions...: 資料回寫
# Date & Author..: 2005/02/02 by saki
# Input Parameter: ps_prog    STRING   維護程式代號
# Return code....: void
# Memo...........: 將資料回復成最後更動資料
 
FUNCTION cl_log_rollback(ps_prog)
   DEFINE   ps_prog          STRING
   DEFINE   lst_feld_value   base.StringTokenizer
   DEFINE   li_cnt           LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   li_i             LIKE type_file.num10         #No.FUN-690005 INTEGER
   DEFINE   l_gaq            RECORD LIKE gaq_file.*
   DEFINE   l_gat            RECORD LIKE gat_file.*
   DEFINE   l_gav            RECORD LIKE gav_file.*
   DEFINE   l_gae            RECORD LIKE gae_file.*
   DEFINE   l_gbs            RECORD LIKE gbs_file.*       #FUN-7B0081
   DEFINE   l_gab            RECORD LIKE gab_file.*
   DEFINE   l_gac            RECORD LIKE gac_file.*
 
   CASE ps_prog
      WHEN "p_feldname"
         FOR li_i = 1 TO lr_log.getLength()
            INITIALIZE l_gaq.* TO NULL
            CASE lr_log[li_i].action
               WHEN "UPDATE"
                  IF (lr_log[li_i].change_value IS NULL) OR (lr_log[li_i].old_value IS NULL) THEN
                     EXIT CASE
                  ELSE
                     CALL cl_replace_str(lr_log[li_i].change_value,"\r","\n") RETURNING lr_log[li_i].change_value
                  END IF
                  LET lst_feld_value = base.StringTokenizer.createExt(lr_log[li_i].change_value,"","",TRUE)
                  LET li_cnt = 1
                  WHILE lst_feld_value.hasMoreTokens()
                     CASE li_cnt
                        WHEN 1
                           LET l_gaq.gaq01 = lst_feld_value.nextToken()
                        WHEN 2
                           LET l_gaq.gaq02 = lst_feld_value.nextToken()
                        WHEN 3
                           LET l_gaq.gaq03 = lst_feld_value.nextToken()
                        WHEN 4
                           LET l_gaq.gaq04 = lst_feld_value.nextToken()
                        WHEN 5
                           LET l_gaq.gaq05 = lst_feld_value.nextToken()
                     END CASE
                     LET li_cnt = li_cnt + 1
                  END WHILE
 
                  IF (l_gaq.gaq01 IS NOT NULL) AND (l_gaq.gaq02 IS NOT NULL) THEN
                     UPDATE gaq_file SET gaq01 = l_gaq.gaq01,gaq02 = l_gaq.gaq02,
                                         gaq03 = l_gaq.gaq03,gaq04 = l_gaq.gaq04,
                                         gaq05 = l_gaq.gaq05
                      WHERE gaq01 = l_gaq.gaq01 AND gaq02 = l_gaq.gaq02
                     IF SQLCA.sqlcode THEN
                        DISPLAY "UPDATE ",l_gaq.gaq01," ",l_gaq.gaq02," ERROR"
                     END IF
                  ELSE
                     MESSAGE "Key value is missing"
                  END IF
            END CASE
         END FOR
         CALL cl_log("p_feldname","R","","")
      WHEN "p_tabname"
         FOR li_i = 1 TO lr_log.getLength()
            INITIALIZE l_gat.* TO NULL
            CASE lr_log[li_i].action
               WHEN "UPDATE"
                  IF (lr_log[li_i].change_value IS NULL) OR (lr_log[li_i].old_value IS NULL) THEN
                     EXIT CASE
                  ELSE
                     CALL cl_replace_str(lr_log[li_i].change_value,"\r","\n") RETURNING lr_log[li_i].change_value
                  END IF
                  LET lst_feld_value = base.StringTokenizer.createExt(lr_log[li_i].change_value,"","",TRUE)
                  LET li_cnt = 1
                  WHILE lst_feld_value.hasMoreTokens()
                     CASE li_cnt
                        WHEN 1
                           LET l_gat.gat01 = lst_feld_value.nextToken()
                        WHEN 2
                           LET l_gat.gat02 = lst_feld_value.nextToken()
                        WHEN 3
                           LET l_gat.gat03 = lst_feld_value.nextToken()
                        WHEN 4
                           LET l_gat.gat04 = lst_feld_value.nextToken()
                        WHEN 5
                           LET l_gat.gat05 = lst_feld_value.nextToken()
                     END CASE
                     LET li_cnt = li_cnt + 1
                  END WHILE
 
                  IF (l_gat.gat01 IS NOT NULL) AND (l_gat.gat02 IS NOT NULL) THEN
                     UPDATE gat_file SET gat01 = l_gat.gat01,gat02 = l_gat.gat02,
                                         gat03 = l_gat.gat03,gat04 = l_gat.gat04,
                                         gat05 = l_gat.gat05
                      WHERE gat01 = l_gat.gat01 AND gat02 = l_gat.gat02
                     IF SQLCA.sqlcode THEN
                        DISPLAY "UPDATE ",l_gat.gat01," ",l_gat.gat02," ERROR"
                     END IF
                  ELSE
                     MESSAGE "Key value is missing"
                  END IF
            END CASE
         END FOR
         CALL cl_log("p_tabname","R","","")
      WHEN "p_per"
         FOR li_i = 1 TO lr_log.getLength()
            INITIALIZE l_gav.* TO NULL
            CASE lr_log[li_i].action
               WHEN "UPDATE"
                  IF (lr_log[li_i].change_value IS NULL) OR (lr_log[li_i].old_value IS NULL) THEN
                     EXIT CASE
                  ELSE
                     CALL cl_replace_str(lr_log[li_i].change_value,"\r","\n") RETURNING lr_log[li_i].change_value
                  END IF
                  LET lst_feld_value = base.StringTokenizer.createExt(lr_log[li_i].change_value,"","",TRUE)
                  LET li_cnt = 1
                  WHILE lst_feld_value.hasMoreTokens()
                     CASE li_cnt
                        WHEN 1
                           LET l_gav.gav01 = lst_feld_value.nextToken()
                        WHEN 2
                           LET l_gav.gav02 = lst_feld_value.nextToken()
                        WHEN 3
                           LET l_gav.gav03 = lst_feld_value.nextToken()
                        WHEN 4
                           LET l_gav.gav04 = lst_feld_value.nextToken()
                        WHEN 5
                           LET l_gav.gav06 = lst_feld_value.nextToken()
                        WHEN 6
                           LET l_gav.gav07 = lst_feld_value.nextToken()
                        WHEN 7
                           LET l_gav.gav08 = lst_feld_value.nextToken()
                        WHEN 8
                           LET l_gav.gav09 = lst_feld_value.nextToken()
                        WHEN 9
                           LET l_gav.gav10 = lst_feld_value.nextToken()
                     END CASE
                     LET li_cnt = li_cnt + 1
                  END WHILE
 
                  IF (l_gav.gav01 IS NOT NULL) AND (l_gav.gav02 IS NOT NULL) AND
                     (l_gav.gav08 IS NOT NULL) THEN
                     UPDATE gav_file SET gav01 = l_gav.gav01,gav02 = l_gav.gav02,
                                         gav03 = l_gav.gav03,gav04 = l_gav.gav04,
                                         gav06 = l_gav.gav06,gav07 = l_gav.gav07,
                                         gav08 = l_gav.gav08,gav09 = l_gav.gav09,
                                         gav10 = l_gav.gav10
                      WHERE gav01 = l_gav.gav01 AND gav02 = l_gav.gav02 AND
                            gav08 = l_gav.gav08
                     IF SQLCA.sqlcode THEN
                        DISPLAY "UPDATE ",l_gav.gav01," ",l_gav.gav02," ",l_gav.gav08," ERROR"
                     END IF
                  ELSE
                     MESSAGE "Key value is missing"
                  END IF
            END CASE
         END FOR
         CALL cl_log("p_per","R","","")
      WHEN "p_perlang"
         FOR li_i = 1 TO lr_log.getLength()
            INITIALIZE l_gae.* TO NULL
            CASE lr_log[li_i].action
               WHEN "UPDATE"
                  IF (lr_log[li_i].change_value IS NULL) OR (lr_log[li_i].old_value IS NULL) THEN
                     EXIT CASE
                  ELSE
                     CALL cl_replace_str(lr_log[li_i].change_value,"\r","\n") RETURNING lr_log[li_i].change_value
                  END IF
                  LET lst_feld_value = base.StringTokenizer.createExt(lr_log[li_i].change_value,"","",TRUE)
                  LET li_cnt = 1
                  WHILE lst_feld_value.hasMoreTokens()
                     CASE li_cnt
                        WHEN 1
                           LET l_gae.gae01 = lst_feld_value.nextToken()
                        WHEN 2
                           LET l_gae.gae02 = lst_feld_value.nextToken()
                        WHEN 3
                           LET l_gae.gae03 = lst_feld_value.nextToken()
                        WHEN 4
                           LET l_gae.gae04 = lst_feld_value.nextToken()
                        WHEN 5               #FUN-7B0081
                           LET l_gbs.gbs06 = lst_feld_value.nextToken()
                        WHEN 6
                           LET l_gae.gae10 = lst_feld_value.nextToken()
                        WHEN 7
                           LET l_gae.gae11 = lst_feld_value.nextToken()
                        WHEN 8
                           LET l_gae.gae12 = lst_feld_value.nextToken()
                     END CASE
                     LET li_cnt = li_cnt + 1
                  END WHILE
 
                  IF (l_gae.gae01 IS NOT NULL) AND (l_gae.gae02 IS NOT NULL) AND
                     (l_gae.gae03 IS NOT NULL) AND (l_gae.gae11 IS NOT NULL) THEN
                     UPDATE gae_file SET gae04 = l_gae.gae04,
                                       # gae05 = l_gae.gae05,    #FUN-7B0081
                                         gae10 = l_gae.gae10
                      WHERE gae01 = l_gae.gae01 AND gae02 = l_gae.gae02
                        AND gae03 = l_gae.gae03 AND gae11 = l_gae.gae11
                        AND gae12 = l_gae.gae12
                     IF SQLCA.sqlcode THEN
                        DISPLAY "UPDATE ",l_gae.gae01," ",l_gae.gae02," ",l_gae.gae03," ",l_gae.gae11," ERROR"
                     ELSE    #FUN-7B0081
                        IF NOT cl_null(l_gbs.gbs06) THEN
                           UPDATE gbs_file SET gbs06 = l_gbs.gbs06
                            WHERE gbs01 = l_gae.gae01 AND gbs02 = l_gae.gae02
                              AND gbs03 = l_gae.gae03 AND gbs04 = l_gae.gae11
                              AND gbs05 = l_gae.gae12
                        END IF
                     END IF
                  ELSE
                     MESSAGE "Key value is missing"
                  END IF
            END CASE
         END FOR
         CALL cl_log("p_perlang","R","","")
      WHEN "p_qry"
         FOR li_i = 1 TO lr_log.getLength()
            CASE lr_log[li_i].action
               WHEN "UPDATE Header"
                  INITIALIZE l_gab.* TO NULL
                  IF (lr_log[li_i].change_value IS NULL) OR (lr_log[li_i].old_value IS NULL) THEN
                     EXIT CASE
                  ELSE
                     CALL cl_replace_str(lr_log[li_i].change_value,"\r","\n") RETURNING lr_log[li_i].change_value
                  END IF
                  LET lst_feld_value = base.StringTokenizer.createExt(lr_log[li_i].change_value,"","",TRUE)
                  LET li_cnt = 1
                  WHILE lst_feld_value.hasMoreTokens()
                     CASE li_cnt
                        WHEN 1
                           LET l_gab.gab01 = lst_feld_value.nextToken()
                        WHEN 2
                           LET l_gab.gab02 = lst_feld_value.nextToken()
                        WHEN 3
                           LET l_gab.gab03 = lst_feld_value.nextToken()
                        WHEN 4
                           LET l_gab.gab04 = lst_feld_value.nextToken()
                        WHEN 5
                           LET l_gab.gab05 = lst_feld_value.nextToken()
                        WHEN 6
                           LET l_gab.gab06 = lst_feld_value.nextToken()
                        WHEN 7
                           LET l_gab.gab07 = lst_feld_value.nextToken()
                        WHEN 8
                           LET l_gab.gab08 = lst_feld_value.nextToken()
                        WHEN 9
                           LET l_gab.gab09 = lst_feld_value.nextToken()
                        WHEN 10
                           LET l_gab.gab10 = lst_feld_value.nextToken()
                        WHEN 11
                           LET l_gab.gab11 = lst_feld_value.nextToken()
                     END CASE
                     LET li_cnt = li_cnt + 1
                  END WHILE
 
                  IF (l_gab.gab01 IS NOT NULL) AND (l_gab.gab11 IS NOT NULL) THEN
                     UPDATE gab_file SET gab01 = l_gab.gab01,gab02 = l_gab.gab02,
                                         gab03 = l_gab.gab03,gab04 = l_gab.gab04,
                                         gab05 = l_gab.gab05,gab06 = l_gab.gab06,
                                         gab07 = l_gab.gab07,gab08 = l_gab.gab08,
                                         gab09 = g_user,gab10 = l_gab.gab10,
                                         gab11 = l_gab.gab11
                      WHERE gab01 = l_gab.gab01 AND gab11 = l_gab.gab11
                     IF SQLCA.sqlcode THEN
                        DISPLAY "UPDATE ",l_gab.gab01," ",l_gab.gab11," ERROR"
                     END IF
                  ELSE
                     MESSAGE "Key value is missing"
                  END IF
               WHEN "UPDATE Detail"
                  INITIALIZE l_gac.* TO NULL
                  IF (lr_log[li_i].change_value IS NULL) OR (lr_log[li_i].old_value IS NULL) THEN
                     EXIT CASE
                  ELSE
                     CALL cl_replace_str(lr_log[li_i].change_value,"\r","\n") RETURNING lr_log[li_i].change_value
                  END IF
                  LET lst_feld_value = base.StringTokenizer.createExt(lr_log[li_i].change_value,"","",TRUE)
                  LET li_cnt = 1
                  WHILE lst_feld_value.hasMoreTokens()
                     CASE li_cnt
                        WHEN 1
                           LET l_gac.gac01 = lst_feld_value.nextToken()
                        WHEN 2
                           LET l_gac.gac02 = lst_feld_value.nextToken()
                        WHEN 3
                           LET l_gac.gac03 = lst_feld_value.nextToken()
                        WHEN 4
                           LET l_gac.gac04 = lst_feld_value.nextToken()
                        WHEN 5
                           LET l_gac.gac05 = lst_feld_value.nextToken()
                        WHEN 6
                           LET l_gac.gac06 = lst_feld_value.nextToken()
                        WHEN 7
                           LET l_gac.gac07 = lst_feld_value.nextToken()
                        WHEN 8
                           LET l_gac.gac08 = lst_feld_value.nextToken()
                        WHEN 9
                           LET l_gac.gac09 = lst_feld_value.nextToken()
                        WHEN 10
                           LET l_gac.gac10 = lst_feld_value.nextToken()
                        WHEN 11
                           LET l_gac.gac11 = lst_feld_value.nextToken()
                        WHEN 12
                           LET l_gac.gac12 = lst_feld_value.nextToken()
                     END CASE
                     LET li_cnt = li_cnt + 1
                  END WHILE
 
                  IF (l_gac.gac01 IS NOT NULL) AND (l_gac.gac02 IS NOT NULL) AND
                     (l_gac.gac03 IS NOT NULL) AND (l_gac.gac12 IS NOT NULL) THEN
                     UPDATE gac_file SET gac01 = l_gac.gac01,gac02 = l_gac.gac02,
                                         gac03 = l_gac.gac03,gac04 = l_gac.gac04,
                                         gac05 = l_gac.gac05,gac06 = l_gac.gac06,
                                         gac07 = l_gac.gac07,gac08 = g_user,
                                         gac09 = l_gac.gac09,gac10 = l_gac.gac10,
                                         gac11 = l_gac.gac11
                      WHERE gac01 = l_gac.gac01 AND gac02 = l_gac.gac02 AND
                            gac03 = l_gac.gac03 AND gac11 = l_gac.gac11
                     IF SQLCA.sqlcode THEN
                        DISPLAY "UPDATE ",l_gac.gac01," ",l_gac.gac02," ",l_gac.gac03," ",l_gac.gac11," ERROR"
                     END IF
                  ELSE
                     MESSAGE "Key value is missing"
                  END IF
            END CASE
         END FOR
         CALL cl_log("p_qry","R","","")
   END CASE
END FUNCTION

# 将日志记录为文件内容
# 文件名称为 g_prog + 日期
function cl_log_string(p_str)
    define p_str string

    define l_cmd string
    
    let l_cmd = "echo '",p_str,"' >> ",cl_log_filename()
    run l_cmd
end function

function cl_log_filename()
   define l_str varchar(10000)
   let l_str = FGL_GETENV("TEMPDIR")
   let l_str = l_str,"/"
   let l_str = l_str,g_prog,"-",year(g_today) using "<<<<",month(g_today) using "<<",day(g_today) using "<<",".log"
   
   return l_str
end function
