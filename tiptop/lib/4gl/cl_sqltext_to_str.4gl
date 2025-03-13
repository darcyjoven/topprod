# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_sqltext_to_str
# Descriptions...: 將欄位型態為[TEXT]的欄位內容轉換為STRING型態
# Input parameter: p_table - STRING - 處理的Table名稱
#                : p_textfield - STRING - 處理的TEXT欄位名稱 
#                : p_pkwhere - STRING - SQL Where條件(PK值)
# Return code....: l_textstr - STRING - TEXT欄位轉成STRING的結果 
# Usage..........: call cl_sqltext_to_str(p_table,p_textfield,p_pkwhere)  
#                       RETURNING l_textstr
#                : call cl_sqltext_to_str("wcf_file","wcf10","AND wcf01 ='114-20120425001'")
#                :      RETURNING l_textstr 
# Date & Author..: 12/04/25 By Lilan
# Modify.........: 新建立 FUN-D10093
#


DATABASE ds    

GLOBALS "../../config/top.global"     
 
#FUN-D10093
FUNCTION cl_sqltext_to_str(p_table,p_textfield,p_pkwhere)
   DEFINE p_table        LIKE ztb_file.ztb01     #Table名稱
   DEFINE p_textfield    LIKE ztb_file.ztb03     #欄位名稱
   DEFINE p_pkwhere      STRING                  #SQL Where條件(PK值)
   DEFINE l_textstr      STRING                  #回傳值
   DEFINE l_sql          STRING
   DEFINE l_tempstr      VARCHAR(2000)
   DEFINE l_i            LIKE type_file.num5
   DEFINE l_cntmod       LIKE type_file.num5
   DEFINE l_cnt          LIKE type_file.num10
   DEFINE l_cntstr       LIKE type_file.num10
   DEFINE l_cntend       LIKE type_file.num10
   DEFINE l_textlengh    LIKE type_file.num10


     LET g_success = 'Y'
     LET l_cnt = 0

     LET l_sql =  "SELECT Length(",p_textfield,")",
                  "  FROM ",p_table,
                  " WHERE 1=1 ",p_pkwhere
     PREPARE aws_texttostr_pre FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare aws_texttostr_pre:',STATUS,1)
        LET g_success = 'N'
        RETURN ''
     END IF

     DECLARE aws_texttostr_curs CURSOR FOR aws_texttostr_pre
     IF STATUS THEN
        CALL cl_err('declare aws_texttostr_curs:',STATUS,1)
        LET g_success = 'N'
        RETURN ''
     END IF

     FOREACH aws_texttostr_curs INTO l_textlengh    #因傳入的Where條件為PK,故原則上只有一筆
        LET l_cnt = l_textlengh/2000                #取商數 (每2000個字元處理一次)
        LET l_cntmod = l_textlengh MOD 2000         #取餘數
        IF l_cntmod > 0 THEN
           LET l_cnt = l_cnt + 1                    #有餘數則多跑一次迴圈
        END IF

        IF l_cnt > 0 THEN
           LET l_cntstr = 1
           LET l_cntend = 2000
           LET l_textstr = ''

          #CALL 依據迴圈次數,透過SQL拆解TEXT欄位內容
           FOR l_i = 1 TO l_cnt
               LET l_sql = "SELECT cast(SUBSTR(",p_textfield,",",l_cntstr,",",l_cntend,") as VARCHAR(2000))",
                           "  FROM ",p_table,
                           " WHERE 1=1 ",p_pkwhere

               PREPARE aws_texttostr2_pre FROM l_sql
               IF STATUS THEN
                  CALL cl_err('prepare aws_texttostr2_pre:',STATUS,1)
                  LET g_success = 'N'
                  EXIT FOR
               END IF

               DECLARE aws_texttostr2_curs CURSOR FOR aws_texttostr2_pre
               IF STATUS THEN
                  CALL cl_err('declare aws_texttostr2_curs:',STATUS,1)
                  LET g_success = 'N'
                  EXIT FOR
               END IF

               FOREACH aws_texttostr2_curs INTO l_tempstr     #原則上只會執行一次
                  LET l_textstr = l_textstr,l_tempstr         #逐步還原TEXT欄位值為STRING型態
               END FOREACH

               LET l_cntstr = l_cntstr + 2000
               LET l_cntend = l_cntend + 2000
           END FOR
       END IF
     END FOREACH

     IF g_success = 'N' THEN
        RETURN ''
     ELSE
        RETURN l_textstr
     END IF
END FUNCTION
