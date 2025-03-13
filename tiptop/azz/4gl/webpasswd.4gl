# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: webpasswd.4gl
# Descriptions...: WEB 使用者密碼變更作業
# Date & Author..: 03/12/16 By Brendan
# Modify.........: No.MOD-420715 04/12/10 By Ken 自動判斷user是採用 Telnet (VTCP) login or WEB Login
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-570135 08/01/03 By alex 更新修改日期
# Modify.........: No.FUN-830011 08/03/20 By alex 更新密碼修改機制
# Modify.........: No.FUN-840220 08/04/30 By alex 增加IDLE控管
# Modify.........: No.FUN-850055 08/05/12 By alex 更新密碼修改機制(加強度控制)
# Modify.........: No.FUN-910094 09/01/20 By alex 增加密碼編碼機制
# Modify.........: No.FUN-920182 09/02/25 By alex 限制密碼長度不可超過 20
# Modify.........: No.MOD-930066 09/03/06 By alex 檢查是否變為空白
# Modify.........: No.FUN-930042 09/03/09 By alex 新增原始密碼是否為空值的檢查
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-930120 09/03/09 By alex 修正密碼後應一併清空zx19
# Modify.........: No:TQC-B90016 12/05/17 By Echo 解決營運中心異常問題，加上 cl_used()
# Modify.........: No:MOD-C40161 12/05/18 By madey 新增zx_file lock機制
# Modify.........: No:FUN-C50055 12/05/18 By madey 調整密碼強度M規則:不可全部輸入數字

 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_zx01       LIKE zx_file.zx01,
       g_zx10_old   LIKE zx_file.zx10,
#      g_zx10_old_t LIKE zx_file.zx10,   #FUN-910094
       g_zx10_new   LIKE zx_file.zx10,
       g_zx10_ver   LIKE zx_file.zx10
#DEFINE ch base.Channel
 
MAIN
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CONTINUE    #Any Error Keep Continue
 
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #No:TQC-B90016

    #MOD-420715
    IF g_gui_type MATCHES "[23]" THEN
    #  CALL cl_err("","azz-895",1)
       CALL webpasswd()
    ELSE
    #  IF cl_confirm("azz-893") THEN 
    #     CALL webpasswd()
    #  END IF
    #  CALL cl_err("","azz-894",1)
       RUN "dspasswd"
    END IF
    #--

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No:TQC-B90016
 
END MAIN
 
FUNCTION webpasswd()
 
    DEFINE ls_tmp      STRING                 #FUN-920182
    DEFINE lc_gbt08    LIKE gbt_file.gbt08    #FUN-930042
    DEFINE lc_zx10_old LIKE zx_file.zx10      #FUN-930042
    DEFINE ls_zx_sql   STRING                 #MOD-C40161
 
    OPEN WINDOW webpasswd_w WITH FORM "azz/42f/webpasswd"
       ATTRIBUTE(STYLE = "login" CLIPPED)
    CALL cl_ui_init()
 
#   SELECT zx10 INTO g_zx10_old_t FROM zx_file WHERE zx01 = g_user 
#   SELECT zx10 INTO lc_zx10_old FROM zx_file WHERE zx01 = g_user #FUN-30042 #MOD-C40161 mark
 
    #MOD-C40161 --start--
    LET ls_zx_sql= "SELECT zx10 FROM zx_file WHERE zx01 =? FOR UPDATE"
    LET ls_zx_sql= cl_forupd_sql(ls_zx_sql)
    DISPLAY "ls_zx_sql: ",ls_zx_sql

    DECLARE zx_u_curl CURSOR FROM ls_zx_sql

    BEGIN WORK

    OPEN zx_u_curl USING g_user
    IF SQLCA.sqlcode THEN
       CALL cl_err("OPEN zx_file",SQLCA.sqlcode,1)
       ROLLBACK WORK
       RETURN
    END IF

    FETCH zx_u_curl INTO lc_zx10_old               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err('FETCH zx_file',SQLCA.sqlcode,1)
       CLOSE zx_u_curl
       ROLLBACK WORK
       RETURN
    END IF
    #MOD-C40161 --end--

    INPUT g_zx10_old, g_zx10_new, g_zx10_ver WITHOUT DEFAULTS
          FROM FORMONLY.zx10_old, FORMONLY.zx10_new, FORMONLY.zx10_ver
 
        BEFORE INPUT
            DISPLAY g_user TO FORMONLY.zx01
 
        AFTER INPUT
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF
 
#           #檢核原始密碼  FUN-910094
#           IF g_zx10_old_t <> g_zx10_old THEN
            IF NOT cl_null(lc_zx10_old) THEN         #FUN-930042
               IF NOT cl_webuser_validate(g_user,g_zx10_old) THEN
                  CALL cl_err('Old password is incorrect.', '!', 1)
                  NEXT FIELD zx10_old
               END IF
            END IF
 
            #新密碼兩次驗證
            IF g_zx10_new <> g_zx10_ver THEN
               CALL cl_err('New password verify failed.', '!', 1)
               NEXT FIELD zx10_new
            END IF
 
            #新密碼長度限制 <= 20
            LET ls_tmp = g_zx10_new           #FUN-920182
            IF ls_tmp.getLength() > 20 THEN 
               CALL cl_err('New password Exceed Maximum Length(20 symbols).', '!', 1)
               NEXT FIELD zx10_new
            END IF
 
            #判斷密碼強度
            CASE ver_passwd()      #FUN-830011 FUN-850055
               WHEN "1"
                  CALL cl_err('New password too short to use.', '!', 1)
                  NEXT FIELD zx10_new
               WHEN "2"
                  CALL cl_err('New password cannot include account.', '!', 1)
                  NEXT FIELD zx10_new
               WHEN "3"
                  CALL cl_err('New password should include numerical.', '!', 1)
                  NEXT FIELD zx10_new
               WHEN "4"
                  CALL cl_err('New password should include symbol.', '!', 1)
                  NEXT FIELD zx10_new
               #FUN-C50055 --start--
               WHEN "5"
                  CALL cl_err('New password should not include all numerical.', '!', 1)
                  NEXT FIELD zx10_new
               #FUN-C50055 --end--
            END CASE
 
            #新密碼是否有和舊密碼相同
            IF g_zx10_old = g_zx10_new THEN
               SELECT gbt08 INTO lc_gbt08 FROM gbt_file WHERE gbt00 = "0"
               IF STATUS OR lc_gbt08 IS NULL THEN LET lc_gbt08 = "Y" END IF
               IF lc_gbt08 = "N" THEN
                  CALL cl_err('New password should be different with old one.', '!', 1)
                  NEXT FIELD zx10_new
               END IF
            END IF
 
        ON IDLE g_idle_seconds     #FUN-840220
           CALL cl_err_msg(NULL,"!","Exceed Than System Allowed Idle Time.\n Fail in Updating Password.\n Do it One More Time.",20)
           CLOSE zx_u_curl         #MOD-C40161
           ROLLBACK WORK           #MOD-C40161
           EXIT PROGRAM            #CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
       CLOSE zx_u_curl         #MOD-C40161
       ROLLBACK WORK           #MOD-C40161
       EXIT PROGRAM
    END IF
 
    LET g_zx10_new = cl_user_encode(g_zx10_new)  #FUN-910094
    IF cl_null(g_zx10_new) THEN                  #MOD-930066
       CALL cl_err('Password encode error.', '!', 1)
    ELSE   
       UPDATE zx_file SET zx10 = g_zx10_new,
                          zx16 = TODAY,         #FUN-570135
                          zx17 = 0,             #FUN-830011
			  zx19 = 'N'            #TQC-930120
        WHERE zx01 = g_user
 
       CALL cl_err('Password update successfully.', '!', 1)
    END IF


    COMMIT WORK             #MOD-C40161
    CLOSE zx_u_curl         #MOD-C40161
 
    CLOSE WINDOW webpasswd_w
END FUNCTION
 
FUNCTION ver_passwd()
 
   DEFINE l_gbt   RECORD LIKE gbt_file.*
   DEFINE li_cnt  LIKE type_file.num5
   DEFINE li_ord  LIKE type_file.num5
   DEFINE ls_tmp  STRING
   DEFINE li_num_cnt  LIKE type_file.num5 #FUN-C50055
 
   LET ls_tmp = g_zx10_new CLIPPED
   SELECT * INTO l_gbt.* FROM gbt_file WHERE gbt00="0"
 
   IF l_gbt.gbt05 > 0 THEN
      IF ls_tmp.getLength() < l_gbt.gbt05 THEN RETURN "1" END IF
   END IF
 
   #FUN-850055  Weak Control
   IF l_gbt.gbt06 = "Y" OR l_gbt.gbt06 = "M" OR l_gbt.gbt06 = "S" THEN
      IF ls_tmp.getIndexOf(g_user,1) THEN RETURN "2" END IF
   END IF
 
   #FUN-850055  Middle Control
   IF l_gbt.gbt06 = "M" OR l_gbt.gbt06 = "S" THEN
      WHILE TRUE
         FOR li_cnt=1 TO ls_tmp.getLength()
            LET li_ord = ORD(ls_tmp.subString(li_cnt,li_cnt)) 
            IF li_ord >= 48 AND li_ord <= 57 THEN
               EXIT WHILE
            END IF
         END FOR 
         RETURN "3"
      END WHILE	

      #不可全部輸入數字 #FUN-C50055 --start--
      LET li_num_cnt = 0
      FOR li_cnt=1 TO ls_tmp.getLength()
         LET li_ord = ORD(ls_tmp.subString(li_cnt,li_cnt))
         IF li_ord >= 48 AND li_ord <= 57 THEN
            LET li_num_cnt = li_num_cnt + 1
         END IF
      END FOR
      IF li_num_cnt = ls_tmp.getLength() THEN RETURN "5" END IF
      #不可全部輸入數字 #FUN-C50055 --end--

   END IF
 
   #FUN-850055  Strong Control
   IF l_gbt.gbt06 = "S" THEN
      WHILE TRUE
         FOR li_cnt=1 TO ls_tmp.getLength()
            LET li_ord = ORD(ls_tmp.subString(li_cnt,li_cnt)) 
            IF li_ord < 48 OR
              (li_ord > 57 AND li_ord < 65) OR 
              (li_ord > 90 AND li_ord < 97) OR li_ord > 122 THEN
               EXIT WHILE
            END IF
         END FOR 
         RETURN "4"
      END WHILE
   END IF
 
   RETURN "0"
END FUNCTION
 
 
