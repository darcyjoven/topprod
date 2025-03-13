# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_pox.4gl
# Descriptions...: 取得多角貿易計價方式
# Date & Author..: 03/08/28 By Kammy
# Usage..........: CALL s_pox(p_flow,p_i,p_date) RETURNING l_sta,l_slip
# Input Parameter: p_flow  流程代碼
#                  p_i     站別
#                  p_date  單據日期
# Return code....: l_sta   結果碼 0:OK, 1:FAIL
#                  l_slip  單號
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-710046 07/01/18 By Carrier 錯誤訊息匯整
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-710046  #FUN-7C0053
 
FUNCTION s_pox(p_flow,p_i,p_date)
  DEFINE p_i      LIKE type_file.num5,          #No.FUN-680147 SMALLINT
         p_flow   LIKE pox_file.pox01,          #No.FUN-680147 VARCHAR(8)
         p_date   LIKE type_file.dat,           #No.FUN-680147 DATE
         p_pox03  LIKE pox_file.pox03,
         p_pox05  LIKE pox_file.pox05,
         p_pox06  LIKE pox_file.pox06,
         l_cnt    LIKE type_file.num5,          #No.FUN-680147 SMALLINT
         l_pox    RECORD LIKE pox_file.*,
         l_sql1   LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(800)
     #判斷料號之計價方式(依流程代碼+預定交貨日)
     #讀取最近一筆之生效日期
     DECLARE pox_p1 CURSOR FOR
       SELECT * INTO l_pox.*
         FROM pox_file
        WHERE pox01 =  p_flow        #流程代碼
          AND pox02 <= p_date        #預定交貨日
          AND pox04 =  p_i           #站別
         ORDER BY pox02 DESC
     LET l_cnt = 0 
     FOREACH pox_p1 INTO l_pox.*
       LET l_cnt = l_cnt + 1
       IF SQLCA.SQLCODE <> 0 THEN 
          #No.FUN-710046  --Begin
          IF g_bgerr THEN
             LET g_showmsg=p_flow,"/",p_i
             CALL s_errmsg("pox01,pox04",g_showmsg,"sel pox:",SQLCA.sqlcode,0)
          ELSE
             CALL cl_err('sel pox:',STATUS,1) 
          END IF
          #No.FUN-710046  --End  
          EXIT FOREACH
       END IF
       LET p_pox03 = l_pox.pox03    #計價基準
       LET p_pox05 = l_pox.pox05    #計價方式
       LET p_pox06 = l_pox.pox06    #計價比率
       EXIT FOREACH
     END FOREACH
     RETURN p_pox03,p_pox05,p_pox06,l_cnt
END FUNCTION
