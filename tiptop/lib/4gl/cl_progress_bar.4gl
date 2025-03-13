# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_progress_bar.4gl
# Descriptions...: 顯示作業處理進度.
# Date & Author..: 03/07/03 by Hiko
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE mi_total_count  LIKE type_file.num10            #No.FUN-690005 INTEGER
DEFINE mi_current      LIKE type_file.num10            #No.FUN-690005  INTEGER
 
 
##################################################
# Descriptions...: 開啟作業處理進度畫面.
# Date & Author..: 2003/07/03 by Hiko
# Input Parameter: pi_total_count INTEGER 處理作業的總次數
# Return code....: void
##################################################
 
FUNCTION cl_progress_bar(pi_total_count)
  DEFINE pi_total_count  LIKE type_file.num10            #No.FUN-690005  INTEGER
 
 
  LET mi_total_count = pi_total_count
  LET mi_current = 0
 
  OPEN WINDOW w_progbar WITH FORM "lib/42f/cl_progress_bar"
                        ATTRIBUTE(STYLE="progress_bar", TEXT="PROGRESSING")
END FUNCTION
 
##################################################
# Descriptions...: 顯現目前處理進度.
# Date & Author..: 2003/07/03 by Hiko
# Input Parameter: ps_log STRING 正在處理的作業說明
# Return code....: void
##################################################
 
FUNCTION cl_progressing(ps_log)
  DEFINE ps_log STRING
  DEFINE li_progbar,li_percent   LIKE type_file.num10            #No.FUN-690005  INTEGER 
 
  LET mi_current = mi_current + 1
  LET li_percent = mi_current * 100 / mi_total_count
  LET li_progbar = li_percent
 
  DISPLAY ps_log,li_progbar,mi_current,mi_total_count,li_percent
       TO proc,progbar,curr,total,p
 
  CALL ui.Interface.refresh()
 
  IF (mi_current = mi_total_count) THEN
     CALL cl_close_progress_bar()
  END IF
END FUNCTION
 
##################################################
# Descriptions...: 令 ProgressBar 指標 +1
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_increase_progress_counter()
   LET mi_current = mi_current + 1
END FUNCTION
 
##################################################
# Descriptions...: 關閉 ProgressBar 視窗 
# Date & Author..: 
# Input Parameter: none
# Return code....: 
##################################################
 
FUNCTION cl_close_progress_bar()
   CLOSE WINDOW w_progbar
END FUNCTION


#darcy:2024/07/04 add s---
function cl_safe_close_progress_bar()
   if mi_current < mi_total_count then
      CLOSE WINDOW w_progbar
   end if
end function
#darcy:2024/07/04 add e---
