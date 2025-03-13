# Prog. Version..: '5.30.06-13.04.24(00004)'     #
# Pattern name...: s_tlfb_ins_rvbs.4gl
# Descriptions...: 將掃描的條碼資料回寫ERP批序號欄位
# Date & Author..: No:DEV-D30043 13/04/02 By TSD.JIE
# Usage..........: CALL s_tlfb_ins_rvbs(p_prog,p_no)
# Input Parameter: p_prog:程式代號
#                  p_no  :單據編號
# Return Code....: 
# Modify.........: No.DEV-D40015 13/04/19 By Lilan SQL增加過濾tlfb19(是否為扣帳資料)
# Modify.........: No.DEV-D40016 13/04/19 By Mandy 筆誤,少了p_prog
# Modify.........: No.DEV-D40019 13/04/24 By Nina  若g_prog = 'aqct110'，則rvsb05,rvbs09塞入預設值

DATABASE ds
GLOBALS "../../config/top.global"


FUNCTION s_tlfb_ins_rvbs(p_prog,p_no,p_tlfb15)
DEFINE p_prog     LIKE type_file.chr20       #程式代號
DEFINE p_no       LIKE type_file.chr20       #單據編號
DEFINE p_tlfb15   LIKE tlfb_file.tlfb15      #時間
DEFINE l_sql      STRING
DEFINE l_cnt      LIKE type_file.num10
DEFINE l_chr      LIKE type_file.chr1
DEFINE l_rvbs     RECORD LIKE rvbs_file.*
DEFINE l_tmp      RECORD
    tlfb08           LIKE tlfb_file.tlfb08,
    ibb01            LIKE ibb_file.ibb01,
    ibb06            LIKE ibb_file.ibb06,
    tlfb02           LIKE tlfb_file.tlfb02,
    tlfb03           LIKE tlfb_file.tlfb03,
    iba02            LIKE iba_file.iba01,
    tlfb05_tot       LIKE type_file.num5
                  END RECORD
DEFINE l_prog     LIKE type_file.chr20

   WHENEVER ERROR CALL cl_err_msg_log

   IF p_prog IS NULL OR p_no IS NULL THEN
      RETURN
   END IF

   LET g_success = "Y"


   IF p_prog = 'apmt110' OR p_prog = 'axmt610' OR p_prog = 'aqct110' THEN
      CASE p_prog  #DEV-D40016 mod
         WHEN 'apmt110' #收貨
            LET l_chr = '1'
         WHEN 'axmt610' #出通
            LET l_chr = '3'
         WHEN 'aqct110' #IQC
            LET l_chr = '4'
      END CASE

      LET l_sql =
          #SELECT 項次,條碼編號,料號,倉庫,儲位,條碼類型,總數量(條碼掃描數量)
         " SELECT aa.ibj07,bb.ibb01,bb.ibb06,aa.ibj03,aa.ibj04, ",
         "        dd.iba02, SUM(aa.ibj05) ibj05_tot ",
         "   FROM ibj_file aa ",
         "  INNER JOIN (SELECT DISTINCT ibb01,ibb06,ibb11 FROM ibb_file ) bb ",
         "              ON aa.ibj02 = bb.ibb01 ",
         "   LEFT JOIN iba_file dd ON bb.ibb01 = dd.iba01 ",
         "  WHERE aa.ibj01 = '",l_chr,"'",                      #1:收貨,*3:出通
         "    AND aa.ibj06 = '",p_no,"'",                       #單號
         "    AND aa.ibj14 = '",g_today,"'",                    #日期
         "    AND aa.ibj15 = '",p_tlfb15,"'",                   #時間
         "    AND bb.ibb11 ='Y' ",                              #條碼使用否
         "    AND dd.iba02 in ( '5','6','F','G','X','Y','Z') ", #條碼類型
         "  GROUP BY aa.ibj07,bb.ibb01,bb.ibb06,aa.ibj03,aa.ibj04,dd.iba02 ",
         "  ORDER BY aa.ibj07,bb.ibb01,bb.ibb06,aa.ibj03,aa.ibj04,dd.iba02 "
   ELSE
      LET l_sql =
          #SELECT 項次,條碼編號,料號,倉庫,儲位,條碼類型,總數量(條碼掃描數量)
         " SELECT aa.tlfb08,bb.ibb01,bb.ibb06,aa.tlfb02,aa.tlfb03, ",
         "        dd.iba02, SUM(aa.tlfb06*aa.tlfb05) tlfb05_tot ",
         "   FROM tlfb_file aa ",
         "  INNER JOIN (SELECT DISTINCT ibb01,ibb06,ibb11 FROM ibb_file ) bb ",
         "              ON aa.tlfb01 = bb.ibb01 ",
         "   LEFT JOIN iba_file dd ON bb.ibb01 = dd.iba01 ",
         "  WHERE aa.tlfb07 = '",p_no,"'",                      #單號
         "    AND aa.tlfb14 = '",g_today,"'",                   #日期
         "    AND aa.tlfb15 = '",p_tlfb15,"'",                  #時間
         "    AND aa.tlfb19 = 'Y' ",                            #只取扣帳資料(避免調撥多筆) #DEV-D40015 add
         "    AND bb.ibb11 ='Y' ",                              #條碼使用否
         "    AND dd.iba02 in ( '5','6','F','G','X','Y','Z') ", #條碼類型
         "  GROUP BY aa.tlfb08,bb.ibb01,bb.ibb06,aa.tlfb02,aa.tlfb03,dd.iba02 ",
         "  ORDER BY aa.tlfb08,bb.ibb01,bb.ibb06,aa.tlfb02,aa.tlfb03,dd.iba02 "
   END IF

   PREPARE tlfsinsrvbs_pre FROM l_sql
   DECLARE tlfsinsrvbs_cur CURSOR FOR tlfsinsrvbs_pre

   FOREACH  tlfsinsrvbs_cur INTO l_tmp.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach s_diy_b_cs:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF

      #出庫需要*-1
      IF p_prog = 'asfi511' OR
         p_prog = 'axmt620' OR
         p_prog = 'axmt650' OR
         p_prog = 'aimt301' OR
         p_prog = 'aimt324_O' OR
         p_prog = 'aimt325'
         THEN
         LET l_tmp.tlfb05_tot = l_tmp.tlfb05_tot * -1
      END IF

      INITIALIZE l_rvbs.* TO NULL

      CASE p_prog
         WHEN 'apmt110'
            LET l_rvbs.rvbs05 = ''
            LET l_rvbs.rvbs09 = 1
         WHEN 'apmt720'
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = 1
         WHEN 'apmt721'
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = -1
         WHEN 'asfi511' 
            LET l_rvbs.rvbs05 = ''
            LET l_rvbs.rvbs09 = -1
         WHEN 'asfi520' 
            LET l_rvbs.rvbs05 = ''
            LET l_rvbs.rvbs09 = 1
         WHEN 'asft620' 
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = 1
         WHEN 'axmt610' 
            LET l_rvbs.rvbs05 = ''
            LET l_rvbs.rvbs09 = -1
         WHEN 'axmt620' 
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = -1
         WHEN 'axmt700' 
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = 1
         WHEN 'aimt302' 
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = 1
         WHEN 'aimt301' 
            LET l_rvbs.rvbs05 = ''
            LET l_rvbs.rvbs09 = -1
         WHEN 'aimt324_O'  #出庫
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = -1
         WHEN 'aimt324_I'  #入庫
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = 1
         WHEN 'aimt325' 
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = -1
         WHEN 'aimt326'
            LET l_rvbs.rvbs05 = g_today
            LET l_rvbs.rvbs09 = 1
        #DEV-D40019 add str------
         WHEN 'aqct110'
            LET l_rvbs.rvbs05 = ''
            LET l_rvbs.rvbs09 = 1
        #DEV-D40019 add end------
      END CASE

      CASE
         WHEN  l_tmp.iba02 = 'Z'             #製造批號+製造序號
            LET l_rvbs.rvbs03 = ' '
            LET l_rvbs.rvbs04 = ' '
            LET l_rvbs.rvbs06 = 1                     #序號唯一，故數量=1
            SELECT iba03,iba04 INTO l_rvbs.rvbs04,l_rvbs.rvbs03
              FROM iba_file
            WHERE iba01 = l_tmp.ibb01

         WHEN l_tmp.iba02 MATCHES '[5FGX]'   #製造批號
            LET l_rvbs.rvbs03 = ' '
            LET l_rvbs.rvbs04 = l_tmp.ibb01
            LET l_rvbs.rvbs06 = l_tmp.tlfb05_tot      #數量=掃描總數量

         WHEN l_tmp.iba02 MATCHES '[6Y]'     #製造序號
            LET l_rvbs.rvbs04 = ' '
            LET l_rvbs.rvbs03 = l_tmp.ibb01
            LET l_rvbs.rvbs06 = 1                     #序號唯一，故數量=1
      END CASE

      IF p_prog = 'aimt324_I' OR
         p_prog = 'aimt324_O' THEN
         LET l_prog = 'aimt324'
      ELSE
         LET l_prog = p_prog
      END IF
      LET l_rvbs.rvbs00 = l_prog
      LET l_rvbs.rvbs01 = p_no
      LET l_rvbs.rvbs02 =  l_tmp.tlfb08
      LET l_rvbs.rvbs021 =  l_tmp.ibb06
      LET l_rvbs.rvbs08 = ' '
      LET l_rvbs.rvbs10 = 0
      LET l_rvbs.rvbs11 = 0
      LET l_rvbs.rvbs12 = 0
      LET l_rvbs.rvbs13 = 0
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
#DEV-D30043
