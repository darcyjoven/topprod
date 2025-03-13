# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Library name...: cl_cmdask
# Descriptions...: 詢問使用者欲執行程式, 並執行之
# Input parameter: none
# Return code....: none
# Usage..........: CALL cl_cmdask()
# Date & Author..: 91/05/30 LYS
# Modify.........: No.MOD-540071 05/04/12 alex 取消 Version 欄位
# Modify.........: No.MOD-540150 05/04/20 alex 刪除 cl_about()
# Modify.........: No.MOD-570209 05/07/22 By saki 執行sh與controlg時的控制
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-960005 09/06/02 By alex 禁止在 ctrl-g 內開啟aoos901/udm_tree
# Modify.........: No.MOD-980061 09/08/11 By alex 調整上單加入CLOSE WINDOW
# Modify.........: No:CHI-C90012 12/12/21 By amdo 權限增加參考zxw_file
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION cl_cmdask()
 
    DEFINE p_cmd 	 LIKE type_file.chr1000       #No.FUN-690005  VARCHAR(500)
    DEFINE li_cnt        LIKE type_file.num5          #No.FUN-690005  SMALLINT
    DEFINE lc_cmd        LIKE zz_file.zz08            #No.MOD-570209
    DEFINE l_status      LIKE zz_file.zz08            #No.FUN-690005  SMALLINT
    DEFINE li_count1     LIKE type_file.num5          #CHI-C90012
    DEFINE li_count2     LIKE type_file.num5          #CHI-C90012
    DEFINE li_count3     LIKE type_file.num5          #CHI-C90012
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  # SELECT COUNT(*) INTO li_cnt FROM zy_file    #mark CHI-C90012
  #  WHERE zy01 = g_clas AND zy02 = "cl_cmdask"    #mark CHI-C90012
    SELECT COUNT(*) INTO li_count1 FROM zy_file #CHI-C90012
    WHERE zy01 = g_clas AND zy02 = "cl_cmdask"
  #No:CHI-C90012 --start--
      SELECT COUNT(*) INTO li_count2 FROM zxw_file, zy_file
      WHERE zxw01 = g_user
      AND zxw_file.zxw04 = zy_file.zy01 AND zy_file.zy02 = 'cl_cmdask'

      SELECT COUNT(*) INTO li_count3 FROM zxw_file
      WHERE zxw01 = g_user AND zxw04 = 'cl_cmdask'

      LET li_cnt = li_count1 + li_count2 +  li_count3
   #No:CHI-C90012 --END--

   IF li_cnt <= 0 THEN
      CALL cl_err_msg("", "lib-214",g_user || "|" || g_clas || "|cl_cmdask(controlg)|" || g_clas,  3)
      RETURN
   END IF
 
   OPEN WINDOW cl_cmdask_w WITH FORM "lib/42f/cl_cmdask"
        ATTRIBUTE (STYLE="lib")
 
   CALL cl_ui_locale("cl_cmdask")
 
   INPUT p_cmd WITHOUT DEFAULTS FROM cmd ATTRIBUTE(UNBUFFERED)
 
      BEFORE INPUT
         CALL DIALOG.setActionHidden("softscore", TRUE)
         IF cl_softscore_check() THEN
            CALL DIALOG.setActionHidden("softscore", FALSE)
         END IF
 
      ON ACTION controlp
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_gaz"
         LET g_qryparam.default1= p_cmd
         LET g_qryparam.arg1= g_lang
         CALL cl_create_qry() RETURNING p_cmd
         DISPLAY p_cmd TO FORMONLY.cmd
    
      ON ACTION softscore
         IF NOT cl_softscore() THEN
            CALL cl_err(NULL, "lib-047", 1)
         END IF
 
 #     #MOD-540150 特別刪除
#     ON ACTION about
#        CALL cl_about()
#
#     ON ACTION help
#        CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
   ELSE
      IF p_cmd IS NOT NULL THEN
          #No.MOD-570209 --start--
         IF p_cmd = "aoos901" OR p_cmd = "udm_tree" THEN   #FUN-960005
            CALL cl_err(NULL,"lib-510",1)
            CLOSE WINDOW cl_cmdask_w    #MOD-980061
            RETURN
         END IF
         IF (p_cmd = "sh") THEN
            SELECT COUNT(*) INTO li_cnt FROM zy_file
             WHERE zy01 = g_clas AND zy02 = "sh"
            IF li_cnt > 0  AND (g_gui_type = 0 OR g_gui_type = 1) THEN
               SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "sh"
               RUN lc_cmd RETURNING l_status
               IF (l_status > 0) THEN
                  EXIT PROGRAM (1)
               END IF
            ELSE
               CALL cl_err_msg("", "lib-214",g_user || "|" || g_clas || "|sh|" || g_clas,  3)
            END IF
         ELSE
            CALL cl_cmdrun(p_cmd)
         END IF
          #No.MOD-570209 ---end---
      END IF
   END IF
 
   CLOSE WINDOW cl_cmdask_w
   MESSAGE ''
END FUNCTION
 
 
##########################################################################
# Private Func...: TRUE
##########################################################################
#FUNCTION cl_cmdzy()
#   DEFINE l_zz04 VARCHAR(20)
#   DEFINE i,j		LIKE type_file.num5          #No.FUN-690005
#   DEFINE g_zy   ARRAY[100] of RECORD
#                    zy01	 VARCHAR(10),
#                    zy03	 VARCHAR(20),
#                    zy04	 VARCHAR(01),
#                    zy05	 VARCHAR(01),
#                    zy06	 VARCHAR(01)
#                    END RECORD
#   OPEN WINDOW cl_cmdzy_w AT 13,3 WITH FORM "lib/42f/cl_cmdzy"
#                   ATTRIBUTE(STYLE="lib")
#   SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = g_prog
#   DISPLAY BY NAME g_prog,l_zz04
#   DECLARE cl_cmdzy_c CURSOR FOR
#        SELECT zy01,zy03,zy04,zy05,zy06 FROM zy_file WHERE zy02 = g_prog
#   LET i = 1
#   FOREACH cl_cmdzy_c INTO g_zy[i].*
#      IF STATUS THEN CALL cl_err('cl_cmdzy(foreach):',STATUS,1)
#                     CLOSE WINDOW cl_cmdzy_w RETURN
#      END IF
#      LET i = i + 1
#      IF i > 100 THEN EXIT FOREACH END IF
#   END FOREACH
#   CALL SET_COUNT(i-1)
#   INPUT ARRAY g_zy WITHOUT DEFAULTS FROM s_cmdzy.*
#                    ATTRIBUTE (YELLOW) HELP 1
#         BEFORE ROW
#            LET i = ARR_CURR()
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#   
#   END INPUT
#   CLOSE WINDOW cl_cmdzy_w
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#   LET j = ARR_COUNT()
#   WHILE TRUE
#      DELETE FROM zy_file WHERE zy02 = g_prog
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('cl_cmdzy(ckp#1):',SQLCA.sqlcode,1)
#         EXIT WHILE
#      END IF
#      FOR i = 1 TO j
#         IF g_zy[i].zy01 IS NULL THEN CONTINUE FOR END IF
#         INSERT INTO zy_file (zy01,zy02,zy03,zy04,zy05,zy06)
#                VALUES(g_zy[i].zy01, g_prog,
#                       g_zy[i].zy03, g_zy[i].zy04,
#                       g_zy[i].zy05, g_zy[i].zy06)
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('t110_m(ckp#2):',SQLCA.sqlcode,1)
#         END IF
#      END FOR
#      EXIT WHILE
#   END WHILE
#END FUNCTION
 
