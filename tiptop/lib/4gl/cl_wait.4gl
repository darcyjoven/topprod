# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_wait
# Descriptions...: 顯示等待訊息
# Input parameter: none
# Usage .........: call cl_wait()
# Date & Author..: 89/09/20 By LYS
# Modify.........: No.MOD-530208 05/03/22 By Raymon 執行 report 時並未正確顯示 "報表執行中請等待的訊息", 但是在 debug mode v卻可以?
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_wait()
   DEFINE   ls_msg   LIKE ze_file.ze03           #No.FUN-690005 VARCHAR(100)
 
   SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'lib-034' AND ze02 = g_lang
 
  #MESSAGE ls_msg CLIPPED
   CALL cl_msg(ls_msg CLIPPED)    #FUN-640248
    CALL ui.Interface.refresh()   #MOD-530208
#    LET l_i=g_gui_type
#    IF l_i=2 THEN RETURN END IF    ## 2.HTML
 
#    IF g_gui_type=1 THEN # GUI
#    CASE 
#     WHEN g_lang = '0'
#          MESSAGE '                       電 腦 正 在 作 業 中, 請 稍 候 !                       '
#          ATTRIBUTE(REVERSE,BLINK)
#     WHEN g_lang = '2'
#          MESSAGE '                       電 腦 正 在 作 業 中, 請 稍 候 !                       '
#          ATTRIBUTE(REVERSE,BLINK)
#     OTHERWISE
#          MESSAGE '                          Working now, please wait !                          '
#          ATTRIBUTE(REVERSE,BLINK)
#    END CASE
 
#    ELSE
#    CASE 
#     WHEN g_lang = '0'
#          ERROR '                       電 腦 正 在 作 業 中, 請 稍 候 !                       '
#          ATTRIBUTE(REVERSE,BLINK)
#     WHEN g_lang = '2'
#          ERROR '                       電 腦 正 在 作 業 中, 請 稍 候 !                       '
#          ATTRIBUTE(REVERSE,BLINK)
#     OTHERWISE
#          ERROR '                          Working now, please wait !                          '
#          ATTRIBUTE(REVERSE,BLINK)
#    END CASE
#    END IF
END FUNCTION
