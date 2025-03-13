# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: s_fetch_price.4gl
# Descriptions...: 取定價檔單價
# Date & Author..: 2006/01/12 By yoyo
# Input Parameter: p_cust  客戶編號   
#                  p_item  產品編號   
#                  p_unit  單位       
#                  p_date  日期       
#                  p_coin  幣別       
#                  p_type  類型       
# Return Code....: l_price   單價
#                  l_no      定價編號
#                  l_success 執行成功否
# Modify.........: No.TQC-640171 06/04/26 By Rayven  當為多屬性子料件時抓不到訂價編號不報錯
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-720003 07/02/05 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-7B0118 07/11/21 By wujie   atmi227的狀態碼取消“申請”狀態，相應作調整 
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_fetch_price(p_cust,p_item,p_unit,p_date,p_coin,p_type)
          #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價
DEFINE p_cust       LIKE tqo_file.tqo01,        #No.FUN-680147 VARCHAR(10)
       p_item       LIKE tqn_file.tqn03,        #No.FUN-680147 VARCHAR(40)
       p_unit       LIKE tqn_file.tqn04,        #No.FUN-680147 VARCHAR(4)
       p_coin       LIKE tqn_file.tqn04,        #No.FUN-680147 VARCHAR(4)
       p_date       LIKE type_file.dat,         #No.FUN-680147 DATE
       p_type       LIKE type_file.chr1000,     #No.FUN-680147 VARCHAR(100)
       l_sql        LIKE type_file.chr1000,     #No.FUN-680147 VARCHAR(4000)
       l_price      LIKE tqn_file.tqn05,
       l_no         LIKE tqn_file.tqn01,
       l_tqo03      LIKE tqo_file.tqo03,
       l_success    LIKE type_file.chr1,        #No.FUN-680147 VARCHAR(1)
       l_occ37      LIKE occ_file.occ37
   
DEFINE l_result     LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
       SELECT occ37 INTO l_occ37 FROM occ_file
              WHERE occ01 = p_cust 
 
     LET l_success='Y'
                  
     LET l_sql="SELECT tqo03,tqn01,tqn05",
               "  FROM tqn_file,tqo_file,tqm_file",
               "  WHERE tqo01 = '", p_cust CLIPPED,"'",
               "    AND tqo02 = tqn01",
               "    AND tqm01 = tqn01",
               "    AND tqn03 = '",p_item CLIPPED,"'",
               "    AND tqn04 = '",p_unit CLIPPED,"'",
               "    AND tqn06<= '",p_date,"'",
               "    AND tqm05 = '",p_coin,"'",
               "    AND (tqn07 is null OR tqn07>= '",p_date,"')",
               "    AND tqoacti = 'Y'",
#              "    AND tqm04 ='2'"     
               "    AND tqm04 ='1'"     #No.TQC-7B0118
     
     IF l_occ37 = 'Y' THEN
        LET l_sql=l_sql CLIPPED," AND tqm06 ='4' ORDER By tqo03"
     ELSE
     	LET l_sql=l_sql CLIPPED," AND (tqm06 ='1' or tqm06='5') ORDER By tqo03"
     END IF
 
        PREPARE tqn_pl  FROM l_sql
        DECLARE tqn_cur SCROLL CURSOR FOR tqn_pl
        OPEN tqn_cur
        FETCH FIRST tqn_cur INTO l_tqo03,l_no,l_price
           IF SQLCA.sqlcode THEN
              #No.TQC-640171  --start--
              CALL cl_is_multi_feature_manage(p_item) RETURNING l_result
              IF l_result = 1 THEN
              #No.TQC-640171  --end-- 
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    CALL s_errmsg('','','','atm-257',0)
                 ELSE
                    CALL cl_err('','atm-257',0)
                 END IF
#NO.FUN-720003-------end
              END IF  #No.TQC-640171
              LET l_success='N'
           ELSE
              LET l_success='Y' 
           END IF
        CLOSE tqn_cur
        
        IF cl_null(l_no) THEN 
           #No.TQC-640171  --start--
           CALL cl_is_multi_feature_manage(p_item) RETURNING l_result
           IF l_result = 1 THEN
           #No.TQC-640171  --end-- 
#NO.FUN-720003------begin
           IF g_bgerr THEN
              CALL s_errmsg('','','','atm-257',0)
           ELSE
              CALL cl_err('','atm-257',0)
           END IF
#NO.FUN-720003-------end
           END IF  #No.TQC-640171
           LET l_success='N'
        END IF
        IF cl_null(l_price) THEN LET l_price=0  END IF
        RETURN l_no,l_price,l_success
 
END FUNCTION
