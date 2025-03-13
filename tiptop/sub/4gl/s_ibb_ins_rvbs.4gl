# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: s_ibb_ins_rvbs.4gl
# Descriptions...: 將產生的條碼資料回寫ERP批序號欄位
# Date & Author..: No:DEV-D40017 13/04/16 By Nina
# Usage..........: CALL s_ibb_ins_rvbs(p_prog,p_no,p_ima01)
# Input Parameter: p_prog      :程式代號
#                  p_no        :單據單號
#                  p_ima01     :料件編號
# Return Code....:
# Modify.........: No:DEV-D40015 13/04/19 By Nina 新增s_ibb_del_rvbs提供刪除rvbs_file

DATABASE ds
GLOBALS "../../config/top.global"

FUNCTION s_ibb_ins_rvbs(p_prog,p_no,p_ima01)
 DEFINE p_prog     LIKE type_file.chr20       #程式代號
 DEFINE p_no       LIKE type_file.chr20       #單據編號
 DEFINE p_ima01    LIKE ima_file.ima01        #料
 DEFINE l_rvbs     RECORD LIKE rvbs_file.*
 DEFINE l_ibb      RECORD
         ibb01    LIKE ibb_file.ibb01,
         ibb02    LIKE ibb_file.ibb02,
         ibb03    LIKE ibb_file.ibb03,
         ibb04    LIKE ibb_file.ibb04,
         ibb06    LIKE ibb_file.ibb06,
         ibb13    LIKE ibb_file.ibb13,
         ibb07    LIKE ibb_file.ibb07,
         iba02    LIKE iba_file.iba02
       END RECORD
 DEFINE l_sql      STRING
 DEFINE l_cnt      LIKE type_file.num10

   WHENEVER ERROR CALL cl_err_msg_log

   IF p_prog IS NULL OR p_no IS NULL THEN
      RETURN
   END IF

  #取得製造批號、序號條碼的掃描資訊
   LET l_sql = "  SELECT  a.ibb01,a.ibb02,a.ibb03,a.ibb04, ",
               "          a.ibb06,a.ibb13,a.ibb07,b.iba02  ",
               "    FROM ibb_file a",
               "   INNER JOIN iba_file b ON a.ibb01 = b.iba01 ",
               "   WHERE a.ibb03 = '",p_no,"'",                       #條碼產生單號
               "     AND a.ibb06 = '",p_ima01,"'",                    #料號
               "     AND a.ibb11 ='Y'     ",                          #條碼使用否
               "     AND b.iba02 in('5','6','F','G','X','Y','Z') "    #條碼類型

   PREPARE ibbinsrvbs_pre FROM l_sql
   DECLARE ibbinsrvbs_cur CURSOR FOR ibbinsrvbs_pre

  #寫入批序號明細變數
   FOREACH  ibbinsrvbs_cur INTO l_ibb.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach ibbinsrvbs_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      INITIALIZE l_rvbs.* TO NULL

      CASE
         WHEN l_ibb.iba02= 'Z'                 #製造批號+製造序號
            LET l_rvbs.rvbs03 = ' '
            LET l_rvbs.rvbs04 = ' '
            LET l_rvbs.rvbs06 = l_ibb.ibb07    #數量=條碼總數量  #序號唯一，故數量=1
            SELECT iba03,iba04
              INTO l_rvbs.rvbs04,l_rvbs.rvbs03
              FROM iba_file
             WHERE iba01 = l_ibb.ibb01

         WHEN l_ibb.iba02 MATCHES '[5FGX]'     #製造批號
            LET l_rvbs.rvbs03 = ' '
            LET l_rvbs.rvbs04 = l_ibb.ibb01
            LET l_rvbs.rvbs06 = l_ibb.ibb07    #數量=條碼數量

         WHEN l_ibb.iba02 MATCHES '[6Y]'       #製造序號
            LET l_rvbs.rvbs04 = ' '
            LET l_rvbs.rvbs03 = l_ibb.ibb01
            LET l_rvbs.rvbs06 = l_ibb.ibb07    #數量=條碼總數量  #序號唯一，故數量=1
      END CASE

      CASE g_prog
         WHEN 'apmt110'   #採購收貨單
            LET l_rvbs.rvbs05 = ' '
         WHEN 'aqct110'   #IQC
            LET l_rvbs.rvbs05 = ' '
         WHEN 'apmt720'   #採購入庫單
            LET l_rvbs.rvbs05 = g_today
         WHEN 'aqct410'   #FQC
            LET l_rvbs.rvbs05 = ' '
      END CASE

      LET l_rvbs.rvbs00  = p_prog
      LET l_rvbs.rvbs01  = p_no           #本次作業單據編號
      LET l_rvbs.rvbs02  = l_ibb.ibb04
      LET l_rvbs.rvbs021 = l_ibb.ibb06
      LET l_rvbs.rvbs08  = ' '            #一格空白
      LET l_rvbs.rvbs09  = 1
      LET l_rvbs.rvbs10  = 0
      LET l_rvbs.rvbs11  = 0
      LET l_rvbs.rvbs12  = 0
      LET l_rvbs.rvbs13  = l_ibb.ibb13
      LET l_rvbs.rvbsplant = g_plant
      LET l_rvbs.rvbslegal = g_legal


      LET l_cnt = 1
      SELECT MAX(rvbs022)+1 INTO l_cnt
        FROM rvbs_file
       WHERE rvbs00 = l_rvbs.rvbs00
         AND rvbs01 = l_rvbs.rvbs01
         AND rvbs02 = l_rvbs.rvbs02
         AND rvbs09 = l_rvbs.rvbs09
         AND rvbs13 = l_rvbs.rvbs13
      IF cl_null(l_cnt) THEN LET l_cnt = 1 END IF
      LET l_rvbs.rvbs022 =  l_cnt

      INSERT INTO rvbs_file VALUES(l_rvbs.*)
      IF SQLCA.sqlcode THEN
          LET g_showmsg = l_rvbs.rvbs01,'/',l_rvbs.rvbs02,'/',l_rvbs.rvbs022,'/',l_rvbs.rvbs09,'/',l_rvbs.rvbs13
          CALL s_errmsg('rvbs01,rvbs02,rvbs022,rvbs09,rvbs13',g_showmsg,
                        'ins rvbs_file',SQLCA.sqlcode,1)
          LET g_success = "N"
          CONTINUE FOREACH
      END IF
  END FOREACH

END FUNCTION
#DEV-D40017 add

#DEV-D40015--add--begin
FUNCTION s_ibb_del_rvbs(p_prog,p_no,p_ima01)
 DEFINE p_prog     LIKE type_file.chr20       #程式代號
 DEFINE p_no       LIKE type_file.chr20       #單據編號
 DEFINE p_sourceno LIKE type_file.chr20       #單據編號
 DEFINE p_ima01    LIKE ima_file.ima01        #料
 DEFINE l_rvbs    RECORD LIKE rvbs_file.*
 DEFINE l_ibb      RECORD
         ibb01    LIKE ibb_file.ibb01,
         ibb02    LIKE ibb_file.ibb02,
         ibb03    LIKE ibb_file.ibb03,
         ibb04    LIKE ibb_file.ibb04,
         ibb06    LIKE ibb_file.ibb06,
         ibb13    LIKE ibb_file.ibb13,
         ibb07    LIKE ibb_file.ibb07,
         iba02    LIKE iba_file.iba02
       END RECORD
 DEFINE l_sql      STRING
 DEFINE l_cnt      LIKE type_file.num10

   WHENEVER ERROR CALL cl_err_msg_log

   IF p_prog IS NULL OR p_no IS NULL THEN
      RETURN
   END IF

  #取得製造批號、序號條碼的掃描資訊
   LET l_sql = "  SELECT  a.ibb01,a.ibb02,a.ibb03,a.ibb04, ",
               "          a.ibb06,a.ibb13,a.ibb07,b.iba02  ",
               "    FROM ibb_file a",
               "   INNER JOIN iba_file b ON a.ibb01 = b.iba01 ",
               "   WHERE a.ibb03 = '",p_no,"'",
               "     AND a.ibb06 = '",p_ima01,"'",                    #料號
               "     AND a.ibb11 ='Y'     ",                          #條碼使用否
               "     AND b.iba02 in('5','6','F','G','X','Y','Z') "    #條碼類型

   PREPARE ibbdelrvbs_pre FROM l_sql
   DECLARE ibbdelrvbs_cur CURSOR FOR ibbdelrvbs_pre

  #寫入批序號明細變數
   FOREACH  ibbdelrvbs_cur INTO l_ibb.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach ibbdelrvbs_cur:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      INITIALIZE l_rvbs.* TO NULL
      LET l_rvbs.rvbs00  = p_prog
      LET l_rvbs.rvbs01  = p_no
      LET l_rvbs.rvbs02  = l_ibb.ibb04
      LET l_rvbs.rvbs09  = 1
      LET l_rvbs.rvbs13  = l_ibb.ibb13

      DELETE FROM rvbs_file
       WHERE rvbs00 = l_rvbs.rvbs00
         AND rvbs01 = l_rvbs.rvbs01
         AND rvbs02 = l_rvbs.rvbs02
         AND rvbs09 = l_rvbs.rvbs09
         AND rvbs13 = l_rvbs.rvbs13
      IF SQLCA.sqlcode THEN
          LET g_showmsg = l_rvbs.rvbs01,'/',l_rvbs.rvbs02,'/',l_rvbs.rvbs022,'/',l_rvbs.rvbs09,'/',l_rvbs.rvbs13
          CALL s_errmsg('rvbs01,rvbs02,rvbs022,rvbs09,rvbs13',g_showmsg,
                        'del rvbs_file',SQLCA.sqlcode,1)
          LET g_success = "N"
          CONTINUE FOREACH
      END IF
  END FOREACH

END FUNCTION
#DEV-D40015--add--end
