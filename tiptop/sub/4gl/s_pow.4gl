# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_pow.4gl
# Descriptions...: 取得多角貿易轉撥單價
# Date & Author..: 03/08/28 By Kammy
# Usage..........: CALL s_pow(p_flow,p_part,p_plant,p_date)
#                             RETURNING l_sta,l_slip
# Input Parameter: p_flow  流程代碼
#                  p_part  料號
#                  p_plant 工廠別
#                  p_date  單據日期
# Return code....: l_sta   結果碼 0:OK, 1:FAIL
#                  l_slip  單號
# Modify.........: No.MOD-490433 04/09/24 ching MATCHES LIKE 修改
# Modify.........: No.MOD-570201 05/07/14 By Nicola SQL語法修改
# Modify.........: No.MOD-570267 05/07/29 By Nicola 改變寫法
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-880148 08/08/21 By claire 調整規格,以生效日為優先, 再考慮最近似的料號
#                                                   如 1/1 VV01  10
#                                                      1/1 VV*   20
#                                                      1/1 V*    30
#                                                   若為VV01 取價10 , 若為VV02 取價20  若為 VX01取價30
# Modify.........: No.MOD-8B0096 08/11/10 By Sarah 當ima_pre1抓到的筆數為0時,改為CONTINUE FOREACH
# Modify.........: No.MOD-930010 09/03/02 By Pengu 調整pow_cur CURSOR的語法
 
DATABASE ds   #FUN-7C0053
 
FUNCTION s_pow(p_flow,p_part,p_plant,p_date)
  DEFINE l_db_type    LIKE type_file.chr3          #No.FUN-680147 VARCHAR(3)
  DEFINE l_sql        LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
  DEFINE p_part  LIKE oeb_file.oeb04,
         p_date  LIKE oeb_file.oeb15, 
         p_plant LIKE poy_file.poy04, 
         p_flow  LIKE pow_file.pow01,              #No.FUN-680147 VARCHAR(8)
         l_pow02 LIKE pow_file.pow02,
         l_pow05 LIKE pow_file.pow05,
         l_pow05_o LIKE pow_file.pow05,            #MOD-880148 
         l_pow06 LIKE pow_file.pow06,
         l_ima01 LIKE ima_file.ima01,
         l_price LIKE pow_file.pow06,
         l_cnt   LIKE type_file.num10,             #No.FUN-680147 INTEGER
         l_ok   LIKE type_file.chr1                #No.FUN-680147 VARCHAR(1)
 
   LET l_db_type=cl_db_get_database_type()
 
   #讀取合乎條件之價格
   LET l_ok='N'
   LET l_price=0
 
#MOD-880148-begin-mark
#   SELECT pow02,pow05,pow06 INTO l_pow02,l_pow05,l_pow06
#     FROM pow_file,ima_file
#    WHERE pow01 = p_flow          #流程代碼
#      #-----No.MOD-570201-----
#     #AND pow02 <= p_date          #預交日
#      AND pow02 = (SELECT MAX(pow02) FROM pow_file
#                    WHERE pow01 = p_flow
#                      AND pow02<=p_date
#                      AND pow03=p_plant
#                      AND pow05=p_part)
#      #-----No.MOD-570201 END-----
#       AND pow03 = p_plant
#      AND ima01 = pow05
#      AND ima01 = p_part
#   IF SQLCA.SQLCODE=0 THEN
#      LET l_price = l_pow06
#      LET l_ok = 'Y'
#      DISPLAY "l_ok",l_ok
#      DISPLAY "l_pow06",l_pow06
#   ELSE
#      LET l_cnt=0
#      SELECT COUNT(*) INTO l_cnt
#        FROM ima_file
#       WHERE ima01 = p_part
#      IF cl_null(l_cnt) OR l_cnt = 0 THEN
#         RETURN
#      END IF
#MOD-880148-end-mark
      DECLARE pow_cur CURSOR FOR SELECT pow02,pow05,pow06
                                   FROM pow_file
                                  WHERE pow01 = p_flow          #流程代碼
                                    AND pow02 <= p_date          #預交日
                                    AND pow03 = p_plant
                                 #-------------No.MOD-930010 modify
                                 #ORDER BY pow02,pow05 DESC     #MOD-880148
                                  ORDER BY pow02 DESC,pow05 DESC   
                                 #-------------No.MOD-930010 end
                                 #ORDER BY pow02 DESC           #MOD-880148 mark
 
      FOREACH pow_cur INTO l_pow02,l_pow05,l_pow06
  
         #MOD-880148-begin-add
         LET l_cnt=0
         IF l_db_type='ORA' THEN
           LET l_pow05_o=cl_replace_str(l_pow05, "*", "%")
         ELSE
           LET l_pow05_o=cl_replace_str(l_pow05, "%", "*")
         END IF 
         LET l_sql = "SELECT COUNT(*) FROM ima_file ",     
                     " WHERE ima01 LIKE '",p_part,"' ",
                     "   AND ima01 LIKE '",l_pow05_o,"' "
         PREPARE ima_pre1 FROM l_sql                                                                                         
         EXECUTE ima_pre1 INTO l_cnt                                                                                         
 
         IF cl_null(l_cnt) OR l_cnt = 0 THEN
           #RETURN             #MOD-8B0096 mark
            CONTINUE FOREACH   #MOD-8B0096
         END IF
         #MOD-880148-end-add
 
         IF p_part MATCHES l_pow05 THEN
            LET l_price = l_pow06
            LET l_ok = 'Y'
            EXIT FOREACH
         END IF
      END FOREACH
#   END IF        #MOD-880148 mark
 
   RETURN l_ok,l_price
 
END FUNCTION
 
