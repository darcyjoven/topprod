# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_selact.4gl
# Descriptions...: 輸入所要處理的帳別
# Date & Author..: 2003/03/26 BY MAY
# Usage..........: CALL s_selact(p_row,p_col,p_lang) RETURNING l_book
# Input Parameter: p_row   視窗左上角x坐標
#                  p_col   視窗左上角y坐標
# Return code....: l_book  帳別
# Modify.........: No.MOD-4B0256 04/12/29 By alex 新增帳別開窗查詢
# Modify.........: No.MOD-510025 05/01/07 By kitty 輸入不對的帳別按取消還是show不對的帳別
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-C50210 12/05/25 By lujh 點擊【切換帳套】進入切換帳套編號的界面，隨便輸入不符合條件的資料，系統無報錯信息提示未非有效帳套。
#                                                 若帳套是00，目前帳套是01，點擊【切換帳套】後又退出不輸入帳套編號，會又重新將帳套至為主帳套00，不合理。
 
DATABASE ds        #FUN-6C0017  #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION s_selact(p_row,p_col,p_lang)
   
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-680147 SMALLINT  #No.FUN-670003
   DEFINE p_argv1  LIKE aaa_file.aaa01,  #FUN-670003
          p_row    LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_col    LIKE type_file.num5,          #No.FUN-680147 SMALLINT
          p_lang   LIKE type_file.chr1           #No.FUN-680147 VARCHAR(01)
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET p_row = 20 LET p_col = 32
   OPEN WINDOW s_sel_w AT p_row,p_col WITH FORM "sub/42f/s_selact" 
   ATTRIBUTE(STYLE='popup')
 
   CALL cl_ui_locale("s_selact")
 
   INPUT p_argv1 FROM aaa01
 
      AFTER FIELD aaa01 
           #No.FUN-670003--begin
             CALL s_check_bookno(p_argv1,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD aaa01
             END IF 
             #No.FUN-670003--end  
          SELECT * FROM aaa_file
           WHERE aaa01 = p_argv1
          IF SQLCA.sqlcode THEN
             CALL cl_err('','agl-449',0)    #TQC-C50210  add
             NEXT FIELD aaa01
          END IF
 
      ON ACTION CONTROLP
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_aaa"
         LET g_qryparam.construct ="n"
         LET g_qryparam.default1 = p_argv1
         CALL cl_create_qry() RETURNING p_argv1
	 DISPLAY p_argv1 TO aaa01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0  
        #No.MOD-510025
       #SELECT aaz64 INTO p_argv1 FROM aaz_file  #Mark by Nicola   #TQC-C50210  mark
       LET p_argv1 = ''      #TQC-C5021   add
       DISPLAY p_argv1 TO aaa01
    END IF
 
    CLOSE WINDOW s_sel_w
 
    CALL s_shwact(0,0,p_argv1)
 
    RETURN p_argv1
 
END FUNCTION
