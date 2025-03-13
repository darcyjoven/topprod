# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_getbug.4gl
# Descriptions...: 輸入帳別、預算編號、科目編號、年度、期別
# Date & Author..: 92/07/27 BY MAY
# Usage..........: CALL s_getbug(p_afb00,p_afb01,p_afb02,p_afb03,p_afc05,p_afb04,p_afb15,p_afb041,p_afb042)
#                               RETURNING l_flag,p_afb07,p_amt
# Input Parameter: p_afb00   預算帳別
#                  p_afb01   預算編號
#                  p_afb02   科目編號
#                  p_afb03   會計年度
#                  p_afc05   期別    
#                  p_afb04   WBS編號
#                  p_afb15   預算種類
#                  p_afb041  預算部門
#                  p_afb042  專案代號
# Return code....: l_flag    成功否
#                  p_afb07   超限控制方式 
#                  p_amt     金額
# Memo...........: 1.科目為統制科目則取其下所有明細科目的預算合計
#                  2.若預算可遞延則需加上第一期到上一期的(預算-巳消耗)合計，
#                    再加上本期的預算金額，不然抓取本期的預算金額為傳遞回去的值
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810069 08/03/04 By lynn 新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.TQC-840009 08/04/08 By douzh  FUN-830161
# Modify.........: No.MOD-960043 09/06/04 By Sarah 修正FUN-810069錯誤
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053  FUN-830161
 
#FUNCTION s_getbug(p_afb00,p_afb01,p_afb02,p_afb03,p_afc05,p_afb04,p_afb15)                    #FUN-810069
FUNCTION s_getbug(p_afb00,p_afb01,p_afb02,p_afb03,p_afc05,p_afb04,p_afb15,p_afb041,p_afb042)   #FUN-810069
DEFINE p_afb00  LIKE afb_file.afb00,
       p_afb01  LIKE afb_file.afb01,
       p_afb02  LIKE afb_file.afb02,
       p_afb03  LIKE afb_file.afb03,
       p_afc05  LIKE afc_file.afc05,
       p_afb04  LIKE afb_file.afb04,
       p_afb15  LIKE afb_file.afb15,
       p_afb041 LIKE afb_file.afb041,       #FUN-810069
       p_afb042 LIKE afb_file.afb042,       #FUN-810069
       p_afb07  LIKE afb_file.afb07,
       p_amt    LIKE afc_file.afc06,
       l_afb02  LIKE afb_file.afb02,
       l_amt    LIKE afc_file.afc06,
       l_afc06  LIKE afc_file.afc06,
       l_aag07  LIKE aag_file.aag07,
       l_afb09  LIKE afb_file.afb09
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF p_afb00 IS NULL OR p_afb00 = ' ' OR 
      p_afb01 IS NULL OR p_afb01 = ' ' OR
      p_afb02 IS NULL OR p_afb02 = ' ' OR
      p_afb03 IS NULL OR p_afb03 = ' ' OR
      p_afc05 IS NULL OR p_afc05 = ' ' THEN
      RETURN 1,' ',0
   END IF
 
  #str MOD-960043 add
   IF cl_null(p_afb00)  THEN LET p_afb00  = ' ' END IF
   IF cl_null(p_afb01)  THEN LET p_afb01  = ' ' END IF
   IF cl_null(p_afb02)  THEN LET p_afb02  = ' ' END IF
   IF cl_null(p_afb03)  THEN LET p_afb03  = ' ' END IF
   IF cl_null(p_afc05)  THEN LET p_afc05  = ' ' END IF
   IF cl_null(p_afb04)  THEN LET p_afb04  = ' ' END IF
   IF cl_null(p_afb15)  THEN LET p_afb15  = ' ' END IF
   IF cl_null(p_afb041) THEN LET p_afb041 = ' ' END IF
   IF cl_null(p_afb042) THEN LET p_afb042 = ' ' END IF
  #end MOD-960043 add
 
   SELECT aag07 INTO l_aag07 FROM aag_file
    WHERE aag01 = p_afb02
      AND aag00 = p_afb00  #No.FUN-730020
   IF SQLCA.sqlcode OR l_aag07 NOT MATCHES '[123]' THEN 
      CALL cl_err('','agl-001',0)
      RETURN 1,' ',0
   END IF
   IF l_aag07 != '1' THEN  #不為統制帳戶才需抓取afb_file,若為統制帳戶則
                           #抓明細的超限控制方式和遞延否
      #超限控制方式 可否遞延
      SELECT afb07,afb09 INTO p_afb07,l_afb09
        FROM afb_file
       WHERE afb00 = p_afb00  AND afb01 = p_afb01
         AND afb02 = p_afb02  AND afb03 = p_afb03
         AND afb04 = p_afb04 
     #   AND afb15 = p_afb15   #MOD-960043 mark
         AND afb041= p_afb041 AND afb042=p_afb042   #FUN-810069
         AND afbacti = 'Y'                          #FUN-D70090
      IF SQLCA.sqlcode THEN
         RETURN 1,' ',0  #有ERROR!
      END IF
      IF p_afb07 = '1' THEN #不做超限控制,故不需做金額的計算
         RETURN 0,p_afb07,0
      END IF
   END IF
   IF l_aag07 != '1' THEN  #不為統制帳戶
      IF l_afb09 MATCHES '[Yy]' THEN #可遞延抓取前期的預算餘額
         #抓取本期前的預算金額
         SELECT SUM(afc06-afc07) INTO p_amt FROM afc_file
          WHERE afc00 = p_afb00  AND afc01 = p_afb01
            AND afc02 = p_afb02  AND afc03 = p_afb03
            AND afc05 < p_afc05  AND afc04 = p_afb04
            AND afc041= p_afb041 AND afc042= p_afb042  #FUN-810069  #MOD-960043 mod
         IF SQLCA.sqlcode OR p_amt IS NULL THEN LET p_amt = 0 END IF
         #抓取本期的預算金額
         SELECT afc06 INTO l_afc06 FROM afc_file 
          WHERE afc00 = p_afb00  AND afc01 = p_afb01
            AND afc02 = p_afb02  AND afc03 = p_afb03
            AND afc05 = p_afc05  AND afc04 = p_afb04
            AND afc041= p_afb041 AND afc042= p_afb042  #FUN-810069  #MOD-960043 mod
         IF SQLCA.sqlcode OR l_afc06 IS NULL THEN LET l_afc06 = 0 END IF
         LET p_amt = p_amt + l_afc06
      ELSE #不遞延抓取當月的預算金額
         SELECT afc06 INTO p_amt FROM afc_file 
          WHERE afc00 = p_afb00  AND afc01 = p_afb01
            AND afc02 = p_afb02  AND afc03 = p_afb03
            AND afc05 = p_afc05  AND afc04 = p_afb04
            AND afc041= p_afb041 AND afc042= p_afb042  #FUN-810069  #MOD-960043 mod
         IF SQLCA.sqlcode OR p_amt IS NULL THEN LET p_amt = 0 END IF
      END IF
   ELSE  #為統制帳戶
      LET p_amt = 0
      LET l_afc06 = 0
      DECLARE s_get_cs CURSOR FOR 
         SELECT aag01,afb09 FROM aag_file,afb_file
          WHERE aag08 = p_afb02  AND afb00 = p_afb00
            AND afb01 = p_afb01  AND afb02 = aag01
            AND afb03 = p_afb03  AND afb04 = p_afb04
        #   AND afb15 = p_afb15   #MOD-960043 mark
            AND afb041= p_afb041 AND afb042=p_afb042   #FUN-810069
            AND afb00 = aag00  #No.FUN-730020
            AND afbacti = 'Y'                          #FUN-D70090
          ORDER BY 1
      #由統制帳戶抓明細帳戶再由明細帳戶抓可否遞延的欄位
      FOREACH s_get_cs INTO l_afb02,l_afb09
         IF SQLCA.sqlcode THEN EXIT FOREACH END IF
         IF l_afb09 MATCHES '[Yy]' THEN #可遞延
            SELECT SUM(afc06-afc07) INTO l_amt FROM afc_file
             WHERE afc00 = p_afb00  AND afc01 = p_afb01
               AND afc02 = l_afb02  AND afc03 = p_afb03
               AND afc05 < p_afc05  AND afc04 = p_afb04
               AND afc041= p_afb041 AND afc042= p_afb042  #FUN-810069  #MOD-960043 mod
            IF SQLCA.sqlcode OR l_amt IS NULL THEN LET l_amt = 0 END IF
            #抓取本期的預算金額
            SELECT afc06 INTO l_afc06 FROM afc_file 
             WHERE afc00 = p_afb00  AND afc01 = p_afb01
               AND afc02 = l_afb02  AND afc03 = p_afb03   #MOD-960043 mod
               AND afc05 = p_afc05  AND afc04 = p_afb04
               AND afc041= p_afb041 AND afc042= p_afb042  #FUN-810069  #MOD-960043 mod
            IF SQLCA.sqlcode OR l_afc06 IS NULL THEN LET l_afc06 = 0 END IF
            LET l_amt = l_amt + l_afc06
         ELSE #不遞延抓取當月的預算金額
            SELECT afc06 INTO l_amt FROM afc_file 
             WHERE afc00 = p_afb00  AND afc01 = p_afb01
               AND afc02 = l_afb02  AND afc03 = p_afb03
               AND afc05 = p_afc05  AND afc04 = p_afb04
               AND afc041= p_afb041 AND afc042= p_afb042  #FUN-810069  #MOD-960043 mod
            IF SQLCA.sqlcode OR l_amt IS NULL THEN LET l_amt = 0 END IF
         END IF
         LET p_amt = l_amt + p_amt
      END FOREACH 
   END IF
   RETURN 0,p_afb07,p_amt
END FUNCTION
#No.TQC-840009
