# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: cl_on_idle.4gl
# Descriptions...: 在 ON IDLE 時的處理.
# Date & Author..: 03/11/20 by Hiko
# Usage..........: CALL cl_on_idle()
# Modify.........: No.FUN-580074 05/08/15 alex 
# Modify.........: No.FUN-5B0054 05/11/08 By saki 修改閒置處理方式，第二選項出現訊息後等待使用者回覆，不回覆就關閉
# Modify.........: No.FUN-660149 06/06/23 By alexstar 針對weblogin時，在未輸入帳號密碼，無法取得所屬class時，也需做idle控管
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.CHI-6B0048 06/11/20 By kim 類型定義錯誤
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No:CHI-9A0024 09/10/19 By saki udm7 選工廠時，IDLE時間後離開不可再帶起udm_tree
# Modify.........: No:MOD-9C0117 09/12/11 By Dido 離開時應紀錄時間
# Modify.........: No:FUN-B10051 11/01/25 By tsai_yen p_zz若設定閒是出現警告訊息,則警告訊息停留秒數參考aoos010
 
DATABASE ds    #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_on_idle()
   DEFINE   lc_zz28       LIKE zz_file.zz28           #No.FUN-690005  VARCHAR(1)
   DEFINE   lc_zw04       LIKE zw_file.zw04           #No.FUN-690005  VARCHAR(1) #CHI-6B0048
   DEFINE   lc_process    LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   l_time        LIKE type_file.chr8     #FUN-580074        #No.FUN-690005 VARCHAR(8)
   DEFINE   li_result     LIKE type_file.num5        #No.FUN-5B0054        #No.FUN-690005 SMALLINT
   DEFINE   ls_msg        STRING        #No.FUN-5B0054
 
 
   # 2004/05/03 by saki : idle處理優先順序參照程式名稱, 權限, 系統設定
   SELECT zz28,zz29 INTO lc_zz28,lc_process FROM zz_file WHERE zz01 = g_prog
   CASE lc_zz28
      WHEN '1'
         RETURN
      WHEN '2'
         IF cl_null(lc_process) THEN
            LET lc_process = '1'
         END IF
         ###FUN-B10051 mark START ###
         SELECT aza37 INTO g_aza.aza37 FROM aza_file WHERE aza01 = '0'
         IF (SQLCA.SQLCODE) THEN
            IF g_prog = 'weblogin' THEN
               LET g_aza.aza37 = 10
            END IF
         END IF
         ###FUN-B10051 mark END ###   
               
         ###FUN-B10051 mark START ###
         #IF g_prog = 'weblogin' THEN #FUN-660149
         #   SELECT aza37 INTO g_aza.aza37 FROM aza_file WHERE aza01 = '0'
         #   IF (SQLCA.SQLCODE) THEN     
         #      LET g_aza.aza37='10'
         #   END IF
         #END IF
         ###FUN-B10051 mark END ###
      WHEN '3'
         SELECT zw04,zw05 INTO lc_zw04,lc_process FROM zw_file WHERE zw01 = g_clas
         IF cl_null(lc_zw04) AND g_prog = 'weblogin' THEN          #FUN-660149
            SELECT aza35,aza36,aza37 INTO g_aza.aza35,g_aza.aza36,g_aza.aza37
              FROM aza_file WHERE aza01 = '0'
            IF (SQLCA.SQLCODE) THEN     
               LET g_aza.aza35='Y'  
               LET g_aza.aza36='2'
               LET g_aza.aza37='10'
            END IF
            LET lc_zw04 = '3'
         END IF
         CASE lc_zw04
            WHEN '1'
               RETURN
            WHEN '2'
               IF cl_null(lc_process) THEN
                  LET lc_process = '1'
               END IF
            WHEN '3'
               IF g_aza.aza35 = 'Y' THEN
                  LET lc_process = g_aza.aza36
               END IF
            OTHERWISE
               RETURN
         END CASE
   END CASE
 
   CASE lc_process
      WHEN '1'
         CALL cl_err_msg("Warning","1000",NULL,g_aza.aza37)
         RETURN
      WHEN '2'
#        CALL cl_err_msg("Warning","1000",NULL,g_aza.aza37)
         #No.FUN-5B0054 --start--
         IF (cl_null(g_aza.aza37)) THEN
            LET g_aza.aza37 = 0
         END IF

         IF g_aza.aza37 = 0 THEN                                 #FUN-B10051
            LET ls_msg = cl_getmsg("1000",g_lang)                #FUN-B10051
         ELSE                                                    #FUN-B10051
            LET ls_msg = cl_getmsg("lib-305",g_lang) CLIPPED,g_aza.aza37,cl_getmsg("lib-306",g_lang) CLIPPED
         END IF                                                  #FUN-B10051
         
         CALL cl_on_idle_confirm(ls_msg) RETURNING li_result
         IF li_result THEN
            RETURN
         ELSE
           #CALL cl_used(g_prog,"",2) RETURNING l_time  #MOD-580088        #MOD-9C0117 mark 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #MOD-580088    #MOD-9C0117
            #No:CHI-9A0024 --start--
            IF g_prog = "aoos901" THEN
               EXIT PROGRAM (1)
            ELSE
               EXIT PROGRAM
            END IF   #No:CHI-9A0024
         END IF
         #No.FUN-5B0054 ---end---
      WHEN '3'
        #CALL cl_used(g_prog,"",2) RETURNING l_time  #MOD-580074           #MOD-9C0117 mark
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #MOD-580074       #MOD-9C0117
         #No:CHI-9A0024 --start--
         IF g_prog = "aoos901" THEN
            EXIT PROGRAM (1)
         ELSE
         #No:CHI-9A0024 ---end---
            EXIT PROGRAM
         END IF   #No:CHI-9A0024
      OTHERWISE
         RETURN
   END CASE
END FUNCTION
 
##################################################
# Descriptions...: 
# Date & Author..: 
# Input Parameter: ps_msg
# Return code....: 
##################################################
 
#No.FUN-5B0054 --start--
FUNCTION cl_on_idle_confirm(ps_msg)
   DEFINE   ps_msg          STRING
   DEFINE   lc_msg          LIKE ze_file.ze03
   DEFINE   li_result       LIKE type_file.num5          #No.FUN-690005  SMALLINT
   DEFINE   lc_title        LIKE ze_file.ze03            #No.FUN-690005  VARCHAR(50)
 
 
   IF (cl_null(g_lang)) THEN
      LET g_lang = "1"
   END IF
   IF (cl_null(ps_msg)) THEN
      LET ps_msg = ""
   END IF
 
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF
 
   LET li_result = FALSE
 
   LET lc_title=lc_title CLIPPED
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ps_msg.trim(), IMAGE="question")
      ON ACTION accept
         LET li_result = TRUE
         EXIT MENU
      ON ACTION cancel
         EXIT MENU
      ON IDLE g_aza.aza37
         EXIT MENU
      #No.TQC-860016 --start--
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
   END MENU
 
   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      LET li_result = FALSE
   END IF
 
   RETURN li_result
END FUNCTION
#No.FUN-5B0054 ---end---
