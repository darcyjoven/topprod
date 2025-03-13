# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# 
# Library name...: cl_detail_input_auth.4gl
# Descriptions...: 檢查是否允許在單身中有insert或delete的權限
# Memo...........: 
# Date & Author..: 03/10/01 by Hiko
# Modify.........: 03/11/25 Hiko 為了p_act_def而改變程式架構
#                                增加 FUNCTION cl_set_detail_auth_string.
# Modify.........: No.FUN-4C0104 05/01/05 alex 修改 4js bug 定義超長 
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明 
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0045
 
DEFINE   mc_detail_auth   LIKE zz_file.zz32
DEFINE   ms_detail_auth   STRING
 
##########################################################################
# Descriptions...: 設定檢查detail之insert/delete的權限字串.
# Memo...........: 
# Input parameter: ps_detail_auth   STRING   要檢查的字串
# Return code....: void
# Usage..........: CALL cl_set_detail_auth_string("insert")
# Date & Author..: 2003/10/01 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_set_detail_auth_string(ps_detail_auth)
   DEFINE   ps_detail_auth   STRING
 
 
   LET ms_detail_auth = ps_detail_auth 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 檢查是否允許在單身中有insert或delete的權限
# Memo...........: 
# Input parameter: ps_act_type   STRING   insert/delete
# Return code....: TRUE/FALSE
# Usage..........: IF cl_detail_input_auth_new("insert") THEN
# Date & Author..: 2004/06/16 by hjwang
# Modify.........: 
##########################################################################
FUNCTION cl_detail_input_auth_new(ps_act_type)
   DEFINE   ps_act_type      STRING
   DEFINE   li_act_allow     LIKE type_file.num5         #No.FUN-690005 SMALLINT
 
   IF (cl_null(mc_detail_auth)) THEN
      LET mc_detail_auth = g_priv5 CLIPPED
   END IF
 
   CASE ps_act_type.trim()
      WHEN "insert"
         IF g_priv5="0" OR g_priv5="1" THEN
            LET li_act_allow=TRUE
         ELSE
            LET li_act_allow=FALSE
         END IF
      WHEN "delete"
         IF g_priv5="0" OR g_priv5="2" THEN
            LET li_act_allow=TRUE
         ELSE
            LET li_act_allow=FALSE
         END IF
      OTHERWISE
         LET li_act_allow=FALSE
   END CASE
 
   RETURN li_act_allow
 
END FUNCTION
 
##########################################################################
# Descriptions...: 檢查是否允許在單身中有insert或delete的權限
# Memo...........: 
# Input parameter: ps_act_type   STRING   insert/delete
# Return code....: TRUE/FALSE
# Usage..........: IF cl_detail_input_auth("insert") THEN
# Date & Author..: 2004/06/16 by hjwang
# Modify.........: 
##########################################################################
FUNCTION cl_detail_input_auth(ps_act_type)
   DEFINE   ps_act_type               STRING
   DEFINE   lst_act_list              base.StringTokenizer,
            ls_act                    STRING,
            li_left_square_bracket    LIKE type_file.num5,     #No.FUN-690005 SMALLINT
            li_right_square_bracket   LIKE type_file.num5,     #No.FUN-690005 SMALLINT
            ls_detail_act_setting     STRING,
            li_act_allow              LIKE type_file.num5      #No.FUN-690005 SMALLINT
 
CALL cl_detail_input_auth_new(ps_act_type) RETURNING li_act_allow
 
# Save Your Life Function
# Starting
# RETURN TRUE
# Ending
 
RETURN li_act_allow
 
   IF (cl_null(ms_detail_auth)) THEN
      LET ms_detail_auth = g_priv1 CLIPPED
   END IF
 
   LET lst_act_list = base.StringTokenizer.create(ms_detail_auth, ",")
   WHILE lst_act_list.hasMoreTokens()
      LET ls_act = lst_act_list.nextToken()
      LET ls_act = ls_act.trim()
      IF (ls_act.getIndexOf("detail", 1) > 0) THEN
         # 2003/11/24 by Hiko : 暫時不判斷.
#        IF (cl_chk_base_act("detail")) THEN
            # 2003/10/07 by Hiko : 因為"detail"的長度為6,因此從第7個位置開始找尋左右中括號([,]).
            LET li_left_square_bracket = ls_act.getIndexOf("[", 7)
            IF (li_left_square_bracket > 0) THEN
               LET li_right_square_bracket = ls_act.getIndexOf("]", 7)
               IF (li_right_square_bracket > 0) THEN
                  LET ls_detail_act_setting = ls_act.subString(li_left_square_bracket+1, li_right_square_bracket-1)
                  IF (ls_detail_act_setting.getLength() = 2) THEN
                     CASE ps_act_type
                        WHEN "insert"
                           IF (ls_detail_act_setting.getCharAt(1) = 'y') THEN
                              LET li_act_allow = TRUE
                           END IF  
                        WHEN "delete"
                           IF (ls_detail_act_setting.getCharAt(2) = 'y') THEN
                              LET li_act_allow = TRUE
                           END IF  
                     END CASE
                  END IF
               END IF
            END IF
           
            EXIT WHILE
#        END IF
      END IF
   END WHILE
 
   RETURN li_act_allow
END FUNCTION
 
##########################################################################
# Descriptions...: 判斷所執行的權限是否存在於程式基本執行功能清單內.
# Memo...........: 
# Input parameter: ps_act   STRING   所要檢查的Action
# Return code....: TRUE/FALSE   是否存在於程式基本執行功能清單內
# Usage..........: IF cl_chk_base_act("modify") THEN
# Date & Author..: 2003/10/07 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_chk_base_act(ps_act)
   DEFINE   ps_act         STRING
   DEFINE   lc_zz04        LIKE zz_file.zz04,
            lst_act_list   base.StringTokenizer,
            ls_act         STRING
   DEFINE   li_exist       LIKE type_file.num5         #No.FUN-690005 SMALLINT
 
 
   SELECT zz04 INTO lc_zz04 FROM zz_file WHERE zz01=g_prog
   IF (SQLCA.SQLCODE) THEN
      #錯誤訊息.dbo.Action不在zz_file.zz04內.
   ELSE
      LET lst_act_list = base.StringTokenizer.create(lc_zz04 CLIPPED, ",")
      WHILE lst_act_list.hasMoreTokens()
         LET ls_act = lst_act_list.nextToken()
         LET ls_act = ls_act.trim()
         IF (ps_act.equals(ls_act)) THEN
            LET li_exist = TRUE
            EXIT WHILE
         END IF
      END WHILE
   END IF
 
   RETURN li_exist
END FUNCTION
