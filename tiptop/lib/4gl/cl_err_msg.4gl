# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Library name...: cl_err_msg.4gl
# Descriptions...: 顯示錯誤訊息.
# Memo...........: 
# Usage..........: 若需要替換錯誤訊息內的變數(%1,%2...),則第三個參數要以'|'當作分隔字串.
#                  1.不需替換參數:CALL cl_err_msg(NULL, "asf001", NULL, 5)
#                  2.需替換參數  :CALL cl_err_msg(NULL, "asf001", g_user || "|" || "oea01", 10)
# Date & Author..: 2003/08/28 by Hiko
# Modify.........: No.MOD-4B0127 saki detail的錯誤訊息改為使用finderr功能, 將傳入的msg字串前後空白刪除 
# Modify.........: No.MOD-530883 05/04/01 By alex 在傳訊息處均加上 CLIPPED or .trim()
# Modify.........: No.MOD-540081 05/04/12 By Brendan
# Modify.........: No.MOD-540096 05/04/19 By alex 排除 error code=0情況
# Modify.........: No.MOD-540178 05/04/26 by saki 無權限製造log檔顯示訊息提示
# Modify.........: No.MOD-550067 05/05/09 by saki 修改判斷錯誤訊息檔是否成功開啟
# Modify.........: No.MOD-5A0046 05/10/04 by saki ON IDLE秒數控制調整
# Modify.........: No.FUN-610104 06/01/25 by saki 批次程式背景執行錯誤訊息紀錄
# Modify.........: No.TQC-630101 06/03/29 by Echo 背景執行記錄log資料後，即return，不需繼續往下執行
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.FUN-640199 06/04/27 By saki 因為增加cl_err3，將此module變數變成global變數
# Modify.........: No.FUN-680011 06/08/22 by Echo SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690005 06/09/18 By chen 類型轉換
# Modify.........: No.TQC-6B0123 07/04/01 by claire 修改當 GUI 模式時, always 顯示錯誤訊息(無論 g_bgjob 是否設為 'Y')
# Modify.........: No.TQC-710024 07/04/01 by claire 修改當 GUI 模式時, always 顯示錯誤訊息(無論 g_bgjob 是否設為 'Y') 為TQC-630101再補充
# Modify.........: No.FUN-730016 07/03/29 By Echo  oerr ora 改抓取 ps_err_code
# Modify.........: No.FUN-620004 07/06/08 by Echo 新增 g_err_code,g_err_msg 記錄錯誤代碼及訊息 for e-B Online
# Modify.........: No.FUN-790033 07/09/14 by Brendan 新增 cl_sql_dup_value() 可供判斷 INSERT SQL 執行後判斷是否為 KEY value 重複錯誤
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.TQC-860036 08/06/23 by Echo 將RUN l_cmd WITHOUT WAITING的WITHOUT WAITING會掉.
# Modify.........: No.FUN-840004 08/07/07 by Echo TIPTOP GateWay 自動執行確認功能
# Modify.........: No.FUN-8B0028 08/11/07 by alex 調整使用Genero API取代UNX CMD
# Modify.........: No.FUN-8B0090 08/11/27 By Echo 整合:調整背景執行cmdrun時也要再指定為背景執行(WSBGJOB 判斷是否為整合背景程式)
# Modify.........: No.FUN-850099 08/12/16 by alex 錯誤訊息記錄檔中顯示STACK
# Modify.........: No.CHI-910009 09/01/08 By saki 當遇到-1109的錯誤訊息時，cl_err_msg_log將訊息顯示在console上並離開程式
# Modify.........: NO.FUN-980097 09/08/21 By alex 合併wos至單一4gl
# Modify.........: NO.FUN-CC0119 12/12/26 By madey cl_err_msg與cl_err3閒置處理規則統一納入aoos010控管;cl_err_msg取消controlg action
# Modify.........: NO.WEB-D20006 13/02/06 By LeoChang 修正WEB區程式沒權限應顯示錯誤訊息的問題
 
IMPORT os    #FUN-8B0028
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS                                      #No.FUN-640199
DEFINE gi_logExist   LIKE type_file.num10          #No.FUN-690005 INTEGER
DEFINE gc_cron_job   STRING
DEFINE gi_no_auth    LIKE type_file.num5           #No.FUN-690005 SMALLINT               #No.MOD-540178
 
#FUN-620004
DEFINE gi_err_code   STRING
DEFINE gi_err_msg    STRING
#END FUN-620004
 
END GLOBALS                                  #No.FUN-640199
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 判斷是否需要紀錄錯誤訊息.
# Memo...........: 
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_chk_err_setting()
# Date & Author..: 2003/08/28 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_chk_err_setting()
   DEFINE   ls_err_log_cmd    STRING,
            ls_err_log_name   STRING
   DEFINE   li_result         STRING
   DEFINE   lc_prog_name      LIKE gaz_file.gaz03
 
 
   WHENEVER ERROR CONTINUE
 
   LET gi_logExist = FALSE
   LET gc_cron_job = 'N'
   IF FGL_GETENV("BGJOB") = '1' THEN
      LET gc_cron_job = 'Y'
   END IF
 
   IF ( g_need_err_log = 'Y' ) OR ( g_bgjob = 'Y' ) OR ( gc_cron_job = 'Y' ) THEN
      LET ls_err_log_name = cl_get_err_log_name()
      CALL STARTLOG(ls_err_log_name)
      LET gi_logExist = TRUE
       #No.MOD-550067 --start--
 
     #FUN-8B0028
     #RUN "ls " || ls_err_log_name || " >/dev/null 2>&1" RETURNING li_result
     #IF li_result > 0 THEN
      IF NOT os.Path.exists(ls_err_log_name) THEN
         LET gi_no_auth = TRUE
         CALL cl_get_progname("p_zz",g_lang) RETURNING lc_prog_name
#        CALL cl_err_msg("","lib-234",lc_prog_name CLIPPED || "|" || "p_zz",1)  #No.CHI-910009 mark
      ELSE
         LET gi_no_auth = FALSE
        #LET ls_err_log_cmd = "chmod 777 ", ls_err_log_name
        #RUN ls_err_log_cmd
         IF os.Path.separator() = "/" THEN                   #FUN-980097
            IF os.Path.chrwx(ls_err_log_name CLIPPED,511) THEN
            END IF
         END IF
      END IF
       #No.MOD-550067 ---end---
   END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 設定錯誤訊息名稱.
# Memo...........: 
# Input parameter: none
# Return code....: STRING 錯誤訊息名稱
# Usage..........: CALL log_name = cl_get_err_log_name()
# Date & Author..: 2003/08/28 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_get_err_log_name()
   DEFINE   ls_err_log_dir    STRING,
            ls_err_log_cmd    STRING,
            ls_today          STRING,
            ls_err_log_name   STRING
 
  #FUN-8B0028
  #LET ls_err_log_dir = FGL_GETENV("TOP") || "/log"
   LET ls_err_log_dir = os.Path.join(FGL_GETENV("TOP"),"log")
 
   # 04/07/26 by saki:請於安裝時確認,一般user在程式裡面修改目錄權限困難
   # MOD-470532
#  LET ls_err_log_cmd = "mkdir -p " || ls_err_log_dir
#  RUN ls_err_log_cmd
 
#  LET ls_err_log_cmd = "chmod 777 ", ls_err_log_dir
#  RUN ls_err_log_cmd
   
   LET ls_today = cl_replace_str(TODAY, "/", "")
 
  #FUN-8B0028
  #LET ls_err_log_name = ls_err_log_dir CLIPPED || "/" || ls_today CLIPPED ||
  #                    "_" || g_user CLIPPED || "_" || g_prog CLIPPED || ".log"
   LET ls_err_log_name = ls_today.trim(),"_",g_user CLIPPED,"_",g_prog CLIPPED,".log"
   LET ls_err_log_name = os.Path.join(ls_err_log_dir.trim(),ls_err_log_name.trim())
 
  #LET ls_err_log_cmd = "del "|| ls_err_log_name
  #RUN ls_err_log_cmd
   IF os.Path.delete(ls_err_log_name) THEN    #FUN-980097
   END IF
 
  #IF (g_trace = 'Y') THEN
  #   DISPLAY "cl_err_msg : Log file name = ", ls_err_log_name
  #END IF
 
   RETURN ls_err_log_name
END FUNCTION
 
##########################################################################
# Descriptions...: 紀錄錯誤訊息.
# Input parameter: none
# Return code....: void
# Usage..........: WHENEVER ERROR CALL cl_err_msg_log
# Date & Author..: 03/08/28 by Hiko
##########################################################################
FUNCTION cl_err_msg_log()
   DEFINE   ls_msg_code       STRING        #No.CHI-910009
 
   #No.CHI-910009 --start--
   IF STATUS=-1109 THEN   
      LET ls_msg_code = STATUS
      CALL ERR_QUIT(ls_msg_code)
   END IF
   #No.CHI-910009 ---end---
 
   IF ( g_need_err_log = 'Y' ) OR ( g_bgjob = 'Y' ) OR ( gc_cron_job = 'Y' ) THEN
      IF NOT gi_logExist THEN
         CALL cl_chk_err_setting()
      END IF
      IF (NOT gi_no_auth) THEN      #MOD-540178
         CALL ERRORLOG(NULL)
         CALL ERRORLOG(base.Application.getStackTrace())    #FUN-850099
      END IF
   END IF
END FUNCTION
 
##########################################################################
# Descriptions...: 顯現錯誤訊息.
# Memo...........: 
# Input parameter: ps_title         STRING     錯誤訊息視窗的Title
#                  ps_err_code      STRING     錯誤訊息代碼
#                  ps_replace_arg   STRING     欲替換的訊息字串(以'|'分隔字串)
#                  pi_idle_sec      SMALLINT   IDLE秒數
# Return code....: void
# Usage..........: CALL cl_err_msg(NULL, "asf-001", g_user || "|" || "oea01", 10)
# Date & Author..: 2003/08/28 by Hiko
# Modify.........: 05/04/19 MOD-540096 alex 排除 error code=0情況
##########################################################################
FUNCTION cl_err_msg(ps_title, ps_err_code, ps_replace_arg, pi_idle_sec)
   DEFINE   ps_title         STRING,
            ps_err_code      STRING,
            ps_replace_arg   STRING,
            pi_idle_sec      LIKE type_file.num5           #No.FUN-690005 SMALLINT
   DEFINE   lw_curr          ui.Window
   DEFINE   ls_err_sql       STRING
   DEFINE   li_sql_err       LIKE type_file.num5,          #No.FUN-690005 SMALLINT
            lc_err_msg       LIKE ze_file.ze03,
            ls_ze05          LIKE ze_file.ze05,
            lch_err          base.Channel
   DEFINE   li_i             LIKE type_file.num5,           #No.FUN-690005 SMALLINT
            li_have_detail   LIKE type_file.num5,           #No.FUN-690005 SMALLINT
            ls_err_sign      LIKE type_file.chr1,           #No.FUN-690005 VARCHAR(1)
            lch_detail       base.Channel,
            ls_detail_cmd    STRING,
            ls_detail_msg    STRING,
            lsb_detail_msg   base.StringBuffer 
   DEFINE   lc_msg_erln      STRING,
            l_i              LIKE type_file.num10          #No.FUN-690005 INTEGER
   DEFINE   ls_title         STRING
   DEFINE   ls_server        STRING             #FUN-640184            
   DEFINE   ls_context       STRING             #FUN-640184
   DEFINE   ls_temp_path     STRING             #FUN-640184
   DEFINE   ls_context_file  STRING             #FUN-640184
   DEFINE   l_cmd            STRING             #FUN-640184
   DEFINE   l_filename       STRING             #FUN-840004
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (SQLCA.SQLERRD[2]) THEN
      LET li_have_detail = TRUE
   END IF
 
    IF cl_null(ps_err_code) OR ps_err_code="0" THEN        # MOD-540096
      RETURN
   END IF
 
    LET ps_err_code = ps_err_code.trim()                   # MOD-4B0127
 
   IF cl_null(g_lang) THEN
      LET g_lang = 1
   END IF
 
   LET ls_err_sql = "SELECT ze03,ze05 FROM ze_file WHERE ze01='" || ps_err_code || "' AND ze02='" || g_lang || "'"
   DECLARE lcurs_err CURSOR FROM ls_err_sql
   OPEN lcurs_err
   FETCH lcurs_err INTO lc_err_msg,ls_ze05
   IF (SQLCA.SQLCODE) THEN
      CASE SQLCA.SQLCODE
         WHEN 100 #在ze_file內找不到錯誤代碼所對應的錯誤訊息.
            LET li_sql_err = TRUE
            LET lc_err_msg = "Error code : " || ps_err_code || " not found in ze_file."
         WHEN -400 #找不到ze_file.
            LET li_sql_err = TRUE
            LET lc_err_msg = "Error code : ze_file not found."
      END CASE
      # 2004/04/07 by saki : 如果是在table找不到的訊息，此類顯示應該放在ze03裡面
       # MOD-4B0127 刪除對msg code加上+號的
#     IF (ps_err_code.getIndexOf("-", 1) = 0) THEN
#        LET ls_err_sign = "+"
#     END IF
#     # 2003/08/28 by Hiko : finderr如果是正號就必須加上"+".  
#     LET ps_err_code = ls_err_sign,ps_err_code   
 
      LET lch_detail = base.Channel.create()
      CASE cl_db_get_database_type()
         WHEN "IFX"
            LET ls_detail_cmd = "finderr " || ps_err_code 
         WHEN "ORA"
             # MOD-4B0127 
            LET ls_detail_cmd = "finderr " || ps_err_code || " " || g_lang
#           IF NOT (ps_err_code.getIndexOf("-",1) = 0) THEN
#              LET ps_err_code = ps_err_code.subString(2,ps_err_code.getLength())
#           END IF
#           LET ls_detail_cmd = "oerr ora ", ps_err_code
      END CASE
      LET lsb_detail_msg = base.StringBuffer.create()
      CALL lch_detail.openPipe(ls_detail_cmd, "r")
      WHILE lch_detail.read(ls_detail_msg)
         CALL lsb_detail_msg.append(ls_detail_msg || "\n")
      END WHILE
      CALL lch_detail.close()
 
      LET ls_detail_msg = lsb_detail_msg.toString()
      LET lc_err_msg = ls_detail_msg
   END IF
   CLOSE lcurs_err      
 
   IF cl_null(ls_ze05) THEN
      LET ls_ze05 = 'N'
   END IF
 
   IF (ps_replace_arg IS NOT NULL) THEN
      IF (NOT li_sql_err) THEN
         LET lc_err_msg = cl_replace_err_msg(lc_err_msg, ps_replace_arg)
      END IF
   END IF
 
   #FUN-8B0090
   #將錯誤訊息記錄至 run log
   IF (fgl_getenv("EASYFLOW") = "1" OR fgl_getenv("SPC") = "1"     #FUN-680011
    OR fgl_getenv("TPGateWayErr") = "1" OR fgl_getenv("WSBGJOB"))  #FUN-840004 
      AND g_gui_type = 0 
   THEN  
      display "prog:",g_prog
      display "error:", ps_title.trim()," ", ps_err_code CLIPPED , " " , lc_err_msg CLIPPED
   END IF
   #END FUN-8B0090
 
   #FUN-640184
   display "g_gui_type:",g_gui_type
   IF (fgl_getenv("EASYFLOW") = "1" OR fgl_getenv("SPC") = "1"    #FUN-680011
    OR fgl_getenv("TPGateWayErr") = "1")                          #FUN-840004
      AND g_gui_type = 0
   THEN
 
      LET ls_server = fgl_getenv("FGLAPPSERVER")
      IF cl_null(ls_server) THEN
         LET ls_server = fgl_getenv("FGLSERVER")
      END IF
      LET ls_temp_path = FGL_GETENV("TEMPDIR")
      #FUN-680011
      #display "error:", ps_err_code CLIPPED , " " , lc_err_msg CLIPPED
      #END FUN-680011
      #FUN-840004
      #IF fgl_getenv("EASYFLOW") = "1" THEN
      #   LET ls_context_file = ls_temp_path,"/aws_efsrv2_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_prog CLIPPED || ".txt"
      #   LET ls_context = ps_err_code CLIPPED , " " , lc_err_msg CLIPPED
      #ELSE
      #   LET ls_context_file = ls_temp_path,"/aws_spcsrv_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_prog CLIPPED || ".txt"
      #   LET ls_context = ps_title.trim(), " ", ps_err_code CLIPPED , " " , lc_err_msg CLIPPED
      #END IF
      CASE  
        WHEN fgl_getenv("EASYFLOW") = "1" 
          LET l_filename = "aws_efsrv2"
        WHEN fgl_getenv("SPC") = "1" 
          LET l_filename = "aws_spcsrv"
        WHEN fgl_getenv("TPGateWayErr") = "1" 
          LET l_filename = "aws_ttsrv2"
      END CASE
 
     #FUN-8B0028
     #LET ls_context_file = ls_temp_path,"/",l_filename,"_" || ls_server CLIPPED || "_" || g_user CLIPPED || "_" || g_prog CLIPPED || ".txt"
      LET ls_context_file = l_filename,"_",ls_server CLIPPED,"_",g_user CLIPPED,"_",g_prog CLIPPED,".txt"
      LET ls_context_file = os.Path.join(ls_temp_path,ls_context_file)
 
      LET ls_context = ps_title.trim(), " ", ps_err_code CLIPPED , " " , lc_err_msg CLIPPED
      #END FUN-840004
      LET l_cmd = "echo '" || ls_context || "' > " || ls_context_file
     #RUN l_cmd WITHOUT WAITING
      RUN l_cmd                                        #TQC-860036
 
     #LET l_cmd = "chmod 777 ",ls_context_file CLIPPED
     #RUN l_cmd
      IF os.Path.separator() = "/" THEN                   #FUN-980097
         IF os.Path.chrwx(ls_context_file CLIPPED,511) THEN
         END IF
      END IF
 
   END IF
   #END FUN-640184
 
   IF ( g_need_err_log = 'Y' ) OR ( g_bgjob = 'Y' ) OR ( gc_cron_job = 'Y' ) THEN
    #----------
     # MOD-540081
    #----------
      IF NOT gi_logExist THEN
         CALL cl_chk_err_setting()
      END IF
    #----------
       IF (NOT gi_no_auth) THEN      #No.MOD-540178
         CALL ERRORLOG("TIPTOP error message :\n" || lc_err_msg CLIPPED || "\n")
      END IF
      IF ( g_bgjob = 'Y' ) OR ( gc_cron_job = 'Y' ) THEN    #FUN-640184  #TQC-710024 mark  #20220502 unmark
      #IF (( g_bgjob = 'Y' ) OR ( gc_cron_job = 'Y')) #TQC-710024 modfiy    #20220502 mark
      #   AND g_gui_type NOT MATCHES "[13]"  THEN   #TQC-710024 add    #20220502 mark
         #FUN-620004
         LET gi_err_code = ps_err_code
         LET gi_err_msg  = lc_err_msg
         #END FUN-620004
         RETURN           #TQC-630101
      END IF
   END IF
 
   # 2004/03/25 by saki : title與message結合 之後要重整message資料時要刪除
   LET lc_err_msg = ps_title.trim() , " " , lc_err_msg CLIPPED
 
   # 2004/03/25 by saki : 修改不管是否要pop視窗都要在MESSAGE LINE出現
   # 2004/04/07 by saki : 如果是有分行的，在ERROR LINE裡面只能出現一行
   LET lc_msg_erln = lc_err_msg CLIPPED
   LET l_i = lc_msg_erln.getIndexOf('\n',1)
   IF l_i THEN
      LET lc_msg_erln = lc_msg_erln.subString(1,l_i -1)
      ERROR "(" ,ps_err_code CLIPPED,")",lc_msg_erln
   ELSE
      ERROR "(" ,ps_err_code CLIPPED,")",lc_err_msg
   END IF

   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN    #WEB-D20006
      LET g_err = g_err CLIPPED,lc_msg_erln      #WEB-D20006
   END IF                                        #WEB-D20006
 
   # 2004/03/25 by saki : idle_sec為0 表示不開視窗但不管p_n傳入值, 若ze05 = Y 都必須彈出視窗
   IF pi_idle_sec = 0 AND ls_ze05 = 'N' THEN
      RETURN
   END IF
   # 2003/09/18 by Hiko : 只有背景執行的程式才不需顯現錯誤訊息.
   IF ( ( cl_null(g_bgjob) ) OR ( g_bgjob != 'Y' ) ) AND ( gc_cron_job != 'Y' ) 
      OR g_gui_type MATCHES "[13]"  THEN   #TQC-6B0123
      IF pi_idle_sec = 0 THEN
         LET pi_idle_sec = g_aza.aza37
      END IF
 
      IF (ps_title IS NULL) THEN
         LET ps_title = "ERROR"
      END IF
 
      OPEN WINDOW w_err WITH FORM "lib/42f/cl_err_msg"
                        ATTRIBUTE(STYLE="show_log", TEXT="Warning")
      LET lw_curr = ui.Window.getCurrent()
      LET ls_title = "Warning (" || ps_err_code CLIPPED || ")"
      CALL lw_curr.setText(ls_title)
# 2004/03/25 by saki: 目前err的呈現方式先這樣，title傳進來的是以前的第一個參數
#                     與message combine起來顯示
#                       ATTRIBUTE(STYLE="show_log", TEXT=ps_title)
 
#     LET lw_curr = ui.Window.getCurrent()
#     CALL lw_curr.setText(ps_title)
 
      DISPLAY lc_err_msg CLIPPED TO ze03

      # FUN-CC0119 --start--
      #有啟動閒置處理時,選1不自動關閉,選2/3等警告訊息停留秒數到期後自動關閉
      #無啟動閒置處理時,視前端參數決定,傳1不自動關閉,傳2以上等秒數到期後自動關閉
      CASE g_aza.aza36
         WHEN '1'
             LET pi_idle_sec= -1
         WHEN '2'
             LET pi_idle_sec=g_aza.aza37
         WHEN '3'
             LET pi_idle_sec=g_aza.aza37
         OTHERWISE
             IF pi_idle_sec = 1 THEN LET pi_idle_sec= -1 END IF
      END CASE
      # FUN-CC0119 -- end --
 
      MENU "" 
         BEFORE MENU
            HIDE OPTION "detail"
            CALL cl_set_comp_visible("group02", FALSE)               
 
#           IF (NOT li_sql_err) THEN       # 04/04/07 by saki detail跟err code找不到沒關係
               IF (li_have_detail) THEN
                  LET ps_err_code = ps_err_code.trim()
                  FOR li_i = 1 TO ps_err_code.getLength()
                     IF (ps_err_code.getCharAt(li_i) NOT MATCHES "[-0123456789]") THEN
                        LET li_have_detail = FALSE
                        EXIT FOR
                     END IF
                  END FOR
   
                  IF (li_have_detail) THEN
                     SHOW OPTION "detail"
 
                     IF (ps_err_code.getIndexOf("-", 1) = 0) THEN
                        LET ls_err_sign = "+"
                     END IF
                     # 2003/08/28 by Hiko : finderr如果是正號就必須加上"+".  
                     LET ps_err_code = ls_err_sign,ps_err_code   
 
                     LET lch_detail = base.Channel.create()
                     CASE cl_db_get_database_type()
                        WHEN "IFX"
                           LET ls_detail_cmd = "finderr " || ps_err_code 
                        WHEN "ORA"
                          #FUN-730016
                          #LET ls_detail_cmd = "oerr ora ", SQLCA.SQLERRD[2]
                           IF (ps_err_code.getIndexOf("-", 1) > 0) THEN
                              LET ps_err_code = ps_err_code.subString(ps_err_code.getIndexOf("-", 1)+1,ps_err_code.getLength())
                           END IF
                           LET ls_detail_cmd = "oerr ora ", ps_err_code  
                          #END FUN-730016
                     END CASE
                     LET lsb_detail_msg = base.StringBuffer.create()
                     CALL lch_detail.openPipe(ls_detail_cmd, "r")
                     WHILE lch_detail.read(ls_detail_msg)
                        CALL lsb_detail_msg.append(ls_detail_msg || "\n")
                     END WHILE
                     CALL lch_detail.close()
 
                     LET ls_detail_msg = lsb_detail_msg.toString()
                  END IF
               END IF
#           END IF
         ON IDLE pi_idle_sec
            EXIT MENU  #FUN-CC0119
           #marked by FUN-CC0119 --start--
           #IF pi_idle_sec > 1 THEN                            #No.MOD-5A0046
           #   EXIT MENU                                       #No.MOD-5A0046
           #ELSE
           #  CASE
           #     WHEN g_aza.aza36='1'
           #          CONTINUE MENU
           #     WHEN g_aza.aza36='2'
           #          EXIT MENU
           #  END CASE
           #END IF
           #marked by FUN-CC0119 --end--
         ON ACTION ok
            EXIT MENU
         ON ACTION detail
            IF (li_have_detail) THEN
               CALL cl_set_comp_visible("group02", TRUE)               
               DISPLAY ls_detail_msg TO FORMONLY.system_err
               LET li_have_detail = FALSE
            ELSE
               CALL cl_set_comp_visible("group02", FALSE)
               LET li_have_detail = TRUE               
            END IF
         #No.TQC-860016 --start--
        #marked by FUN-CC0119 --start--
        #ON ACTION controlg
        #   CALL cl_cmdask()
        #marked by FUN-CC0119 --end--
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
         #No.TQC-860016 ---end---
      END MENU
 
      CLOSE WINDOW w_err
   #No.FUN-610104 --start--
   ELSE
      IF (g_bgjob = "Y") THEN
         CALL cl_batch_bg_msg_log(lc_err_msg)
      END IF
   #No.FUN-610104 ---end---
   END IF
END FUNCTION
 
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 替換錯誤訊息.
# Memo...........: 
# Input parameter: ps_err_msg       STRING   錯誤訊息來源
#                  ps_replace_arg   STRING   欲替換的訊息字串(以'|'分隔字串)
# Return code....: STRING   替換後的錯誤訊息
# Usage..........: LET lc_err_msg = cl_replace_err_msg(lc_err_msg, ps_replace_arg)
# Date & Author..: 2003/08/28 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_replace_err_msg(ps_err_msg, ps_replace_arg)
   DEFINE   ps_err_msg         STRING
   DEFINE   ps_replace_arg     STRING
   DEFINE   lst_replace_arg    base.StringTokenizer
   DEFINE   ls_arg             STRING
   DEFINE   li_index           LIKE type_file.num5           #No.FUN-690005 SMALLINT
   DEFINE   li_replace_index   LIKE type_file.num5           #No.FUN-690005 SMALLINT
 
   
   LET ps_err_msg = ps_err_msg.trim()
   LET lst_replace_arg = base.StringTokenizer.create(ps_replace_arg, "|")
   WHILE lst_replace_arg.hasMoreTokens()
      LET ls_arg = lst_replace_arg.nextToken()
      LET li_replace_index = ps_err_msg.getIndexOf("%" || li_index+1, 1)
      IF (li_replace_index > 0) THEN
         LET ps_err_msg = cl_replace_str_by_index(ps_err_msg, li_replace_index, li_replace_index+1, ls_arg)
      END IF
      LET li_index = li_index + 1   
   END WHILE
 
   RETURN ps_err_msg
END FUNCTION
 
#-- No.FUN-790033 BEGIN --------------------------------------------------------
##########################################################################
# Descriptions...: INSERT SQL 語句執行後判斷是否為 KEY value 重複錯誤
# Memo...........: 
# Input parameter: ps_sqlcode  INTEGER
# Return code....: TRUE(KEY 值重複錯誤) / FALSE(非 KEY 值重複錯誤)
# Usage..........: CALL cl_sql_dup_value(SQLCA.SQLCODE)
# Date & Author..: 2007/09/14 by Brendan
##########################################################################
FUNCTION cl_sql_dup_value(ps_sqlcode)
   DEFINE ps_sqlcode   INTEGER
 
   IF ps_sqlcode = -239 OR ps_sqlcode = -268 THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION
#-- No.FUN-790033 END ----------------------------------------------------------
