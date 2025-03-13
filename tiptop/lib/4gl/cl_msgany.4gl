# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: cl_msgany
# Descriptions...: 顯示訊息，然後按任何鍵繼續
# Input parameter: p_row  訊息視窗將開啟於第幾行
#                  p_col  訊息視窗將開啟於第幾列
#                  p_msg  欲顯示的訊息
# Return code....: none
# Usage..........: CALL cl_msgany(p_row,p_col,p_msg)
# Date & Author..: 89/10/17 By LYS
# Revise record..:
# Modify.........: 04/02/17 By saki
# Modify.........: No.MOD-490196 04/09/09 echo 可依照訊息代碼將資料顯現在畫面
# Modify.........: No.FUN-580143 05/08/29 alex add default title
# Modify.........: No.FUN-640184 06/04/12 Echo 自動執行確認功能
# Modify.........: No.FUN-640240 06/05/17 Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only 
# Modify.........: No.FUN-7C0085 07/12/25 By joyce 修改lib說明，以符合p_findfunc抓取的規格
# Modify.........: No.MOD-860093 08/06/10 By Smapmin 將SQLCA.SQLCODE歸零,以避免呼叫完錯誤訊息後SQLCA.SQLCODE判斷錯誤
# Modify.........: No.FUN-9C0036 10/02/23 By Echo 新增 cl_msg_error() ，讓 SQL 發生錯誤時能有更詳細的說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
# No.FUN-7C0085
# Descriptions...: 顯示訊息，然後按任何鍵繼續
# Input parameter: p_row  訊息視窗將開啟於第幾行
#                  p_col  訊息視窗將開啟於第幾列
#                  p_msg  欲顯示的訊息
# Return code....: none
# Usage..........: CALL cl_msgany(p_row,p_col,p_msg)
 
FUNCTION cl_msgany(p_row,p_col,p_msg)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-690005 SMALLINT
	    p_msg         STRING
    DEFINE   ls_msg       LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(100)                # MOD-490196 
   DEFINE   li_result     LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   lc_title      LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(50)
    DEFINE   lc_msg        LIKE ze_file.ze03        # MOD-490196
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #FUN-640240
   #IF g_bgjob = 'Y' THEN
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
 
      RETURN
   END IF
   #END FUN-640240
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(p_msg)) THEN
      LET p_msg = ""
   END IF
 
#  #FUN-580143
#  SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-041' AND ze02 = g_lang
   LET lc_title = cl_getmsg("lib-041",g_lang) CLIPPED
   IF cl_null(lc_title) THEN
      LET lc_title="Information"
   END IF
 
##### MOD-490196 #####
   LET ls_msg = p_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
      LET p_msg = lc_msg CLIPPED
   ELSE   #MOD-860093
      LET SQLCA.SQLCODE=0   #MOD-860093
   END IF
 
###### END MOD-490196 #####
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=p_msg.trim() CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
   
   END MENU
 
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
END FUNCTION
 
 
#FUN-640184
# No.FUN-7C0085
# Descriptions...: 顯示訊息
# Input parameter: p_msg    欲顯示的訊息
# Return code....: none
# Usage..........: CALL cl_msg(p_msg)
 
FUNCTION cl_msg(p_msg)
DEFINE   p_msg         STRING
DEFINE   ls_msg        LIKE ze_file.ze03        #No.FUN-690005 VARCHAR(100)                 
DEFINE   lc_msg        LIKE ze_file.ze03      
 
   #IF g_bgjob = 'Y' THEN
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
      RETURN
   END IF
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(p_msg)) THEN
      LET p_msg = ""
   END IF
 
   LET ls_msg = p_msg.trim()
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
   IF NOT SQLCA.SQLCODE THEN
      LET p_msg = lc_msg CLIPPED
   ELSE   #MOD-860093
      LET SQLCA.SQLCODE=0   #MOD-860093
   END IF
 
   MESSAGE p_msg
 
END FUNCTION 
#END FUN-640184



#FUN-9C0036 -- start --
# No.FUN-7C0085
# Descriptions...: 顯示錯誤訊息, 若沒有主要訊息時，則以第二訊息為主
# Input parameter: p_str    固定顯示的訊息
#                : p_error  主要錯誤代號, 如 SQLCA.SQLCODE
#                : p_error2 次要錯誤代號, 如 SQLCA.SQLERRD[2]
# Return code....: none
# Usage..........: CALL cl_msg_error("", SQLCA.SQLCODE, SQLCA.SQLERRD[2])
FUNCTION cl_msg_error(p_str,p_error,p_error2)      
DEFINE p_str       STRING
DEFINE p_error     LIKE ze_file.ze01
DEFINE p_error2    LIKE ze_file.ze01
DEFINE l_cnt       LIKE type_file.num5

    IF cl_db_get_database_type() = "ORA" AND (p_error = '-3106' OR p_error2 = '-3106')
    THEN 
       CALL  cl_msgany(0,0,'-3106')
       RETURN
    END IF 

    SELECT COUNT(*) INTO l_cnt FROM ze_file WHERE ze01= p_error  AND ze02=g_lang
    IF l_cnt > 0 THEN
       CALL cl_err(p_str,p_error,1)
    ELSE
       CALL cl_err(p_str,p_error2,1)
    END IF

END FUNCTION
#FUN-9C0036 -- end --
