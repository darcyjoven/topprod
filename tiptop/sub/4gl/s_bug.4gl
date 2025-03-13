# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_bug.4gl
# DESCRIPTIONS...: 輸入帳別、預算編號、科目編號(明細)、統制明細別、年度、期別
# Date & Author..: 92/08/11 BY MAY
# Usage..........: CALL s_bug(p_afc00,p_afc01,p_afc02,p_afc07,p_afc03,p_afc05)
#                       RETURNING l_status,p_afc06,p_afc07,p_amt
# Input PARAMETER: p_afc00   預算帳別
#                  p_afc01   預算編號
#                  p_afc02   科目編號
#                  p_aag07   統制明細別
#                  p_afc03   會計年度
#                  p_afc05   期別    
# RETURN Code....: l_status  成功否
#                  p_afc06   本期預算金額
#                  p_afc07   本期預算巳消耗金額
#                  p_amt     前期金額若為可遞延則抓取零期到上期預算-巳消耗金額
#                            若不為可遞延則傳回 0)
# Memo...........: 1.科目為統制科目則取其下所有明細科目的預算合計
#                  2.若預算可遞延則需加上第一期到上一期的(預算-巳消耗)合計，
#                    再加上本期的預算金額，不然抓取本期的預算金額為傳遞回去的值
#                  3.需注意傳遞的統制科目若和明細科目相同則為獨立帳戶
# Modify.........: 96.01.25 by Grace 增加判斷 afc04='@' afb04='@'
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_bug(p_afc00,p_afc01,p_afc02,p_aag07,p_afc03,p_afc05)
DEFINE  
         p_afc00  LIKE afc_file.afc00,
         p_afc01  LIKE afc_file.afc01,
         p_afc02  LIKE afc_file.afc02,
         p_aag07  LIKE aag_file.aag07,
         p_afc03  LIKE afc_file.afc03,
         p_afc05  LIKE afc_file.afc05,
         p_amt    LIKE afc_file.afc06,
         l_amt    LIKE afc_file.afc06,
         l_afc06  LIKE afc_file.afc06,
         l_afc07  LIKE afc_file.afc07,
         p_afc07  LIKE afc_file.afc07,
         p_afc06  LIKE afc_file.afc06,
         l_afb02  LIKE afb_file.afb02,
         l_afb09  LIKE afb_file.afb09
 
  WHENEVER ERROR CALL cl_err_msg_log
     IF p_afc00 IS NULL OR p_afc00 = ' ' OR 
        p_afc01 IS NULL OR p_afc01 = ' ' OR
        p_afc02 IS NULL OR p_afc02 = ' ' OR
        p_aag07 IS NULL OR p_aag07 = ' ' OR
        p_afc03 IS NULL OR p_afc03 = ' ' OR
        p_afc05 IS NULL OR p_afc05 = ' ' THEN
        RETURN 1,0,0,0
     END IF
 
     IF p_aag07 NOT MATCHES '[123]' THEN 
        CALL cl_err('','agl-001',0)
        RETURN 1,0,0,0
     END IF
     IF p_aag07 != '1' THEN  #不為統制帳戶
        SELECT afb09 INTO l_afb09 FROM afb_file 
                     WHERE afb00 = p_afc00 AND afb01 = p_afc01 AND
                           afb02 = p_afc02 AND afb03 = p_afc03 AND
                           afb04= '@' 
        IF SQLCA.sqlcode OR l_afb09 IS NULL OR l_afb09 = ' ' THEN
           LET l_afb09 = 'N'
           RETURN 1,0,0,0
        END IF
        IF l_afb09 MATCHES '[Yy]' THEN #可遞延抓取前期的預算餘額
           SELECT SUM(afc06-afc07) INTO p_amt FROM afc_file#不為統制帳戶且需遞延
                  WHERE afc00 = p_afc00 AND afc01 = p_afc01 AND
                        afc02 = p_afc02 AND afc03 = p_afc03 AND
                        afc05 < p_afc05 AND afc04 = '@'
           IF SQLCA.sqlcode OR p_amt IS NULL THEN LET p_amt = 0 END IF
        ELSE 
           LET p_amt = 0
        END IF
        #抓取本期的預算金額、巳消耗金額
        SELECT afc06,afc07 INTO p_afc06,p_afc07 FROM afc_file 
               WHERE afc00 = p_afc00 AND afc01 = p_afc01 AND
                     afc02 = p_afc02 AND afc03 = p_afc03 AND
                     afc05 = p_afc05 AND afc04= '@'
        IF SQLCA.sqlcode OR p_afc06 IS NULL or p_afc07 IS NULL THEN
            LET p_afc06 = 0 
            LET p_afc07 = 0 
        END IF
     ELSE  #為統制帳戶
        LET p_amt = 0
        LET p_afc06 = 0
        LET p_afc07 = 0
        DECLARE s_get_cs CURSOR FOR 
           SELECT aag01,afb09 FROM aag_file,afb_file
                  WHERE aag08 = p_afc02 AND afb00 = p_afc00 AND 
                        afb01 = p_afc01 AND afb02 = aag01 AND
                        afb03 = p_afc03 AND afb04 = '@'
                    AND afb00 = aag00 #No.FUN-730020
                  ORDER BY 1
        FOREACH s_get_cs INTO l_afb02,l_afb09#由統制帳戶抓明細帳戶再由明細帳戶抓
                                             #可否遞延的欄位
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        IF l_afb09 MATCHES '[Yy]' THEN #可遞延
           SELECT SUM(afc06-afc07) INTO l_amt FROM afc_file
                  WHERE afc00 = p_afc00 AND afc01 = p_afc01 AND
                        afc02 = l_afb02 AND afc03 = p_afc03 AND
                        afc05 < p_afc05 AND afc04 = '@'
           IF SQLCA.sqlcode OR l_amt IS NULL THEN LET l_amt = 0 END IF
        ELSE LET l_amt = 0  #若其明細科目為不可遞延
        END IF
        #抓取本期的預算金額
        SELECT afc06,afc07 INTO l_afc06,l_afc07 FROM afc_file 
               WHERE afc00 = p_afc00 AND afc01 = p_afc01 AND
                     afc02 = l_afb02 AND afc03 = p_afc03 AND
                     afc05 = p_afc05 AND afc04 = '@'
        IF SQLCA.sqlcode OR l_afc06 IS NULL OR l_afc07 IS NULL THEN 
           LET l_afc06 = 0 
           LET l_afc07 = 0 
        END IF
       LET p_amt = l_amt + p_amt
       LET p_afc06 = l_afc06 + p_afc06
       LET p_afc07 = l_afc07 + p_afc07
       END FOREACH 
    END IF
    RETURN 0,p_amt,p_afc06,p_afc07
END FUNCTION
