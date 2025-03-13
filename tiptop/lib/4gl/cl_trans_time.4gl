# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: cl_trans_time.4gl
# Descriptions...: 轉換時間
# Date & Author..: 07/11/26 by alex   #FUN-7B0125
# Input Parameter: l_date   - 待轉換時間 (date) 
#                  lc_azp01 - 待變換的目標營運中心
# Memo...........: 時間傳入時通常是沒有 time (date only),此時應該如何轉換?
#                  有以下2法
#                  1.取現在時間, 若執行此動作時是上午八點 (不管原單據時間,
#                    因為不可考) 若拋入 -8小時時差地區, 
#                    則才發生 l_date=l_date-1
#                  2.就當作是 0:00:00.00 一日之始來進行轉換, 則時差格林數
#                    (now-target) 為正值時, l_date=l_date-1
#                  TIPTOP採用方法 1
# RETURN Code....: l_date
 
DATABASE ds
GLOBALS "../../config/top.global"
 
FUNCTION cl_trans_time(l_date,lc_azp01)   #FUN-7B0125
 
   DEFINE l_date      LIKE type_file.dat
   DEFINE lc_azp01    LIKE azp_file.azp01
   DEFINE lc_azp01n   LIKE azp_file.azp01
   DEFINE lc_azp052   LIKE azp_file.azp052
   DEFINE lc_azp03    LIKE azp_file.azp03
   DEFINE lc_azz05    LIKE azz_file.azz05
   DEFINE li_tz_now,li_tz_target LIKE type_file.num20_6
   DEFINE li_timediff LIKE type_file.num20_6
   DEFINE li_hour     LIKE type_file.num5
   DEFINE ls_tmp1     STRING
   DEFINE ls_tmp2     STRING
 
   #檢查整體系統參數
#  SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01='0'
 
   IF lc_azz05 = 'N' THEN
      RETURN l_date
   END IF
 
   #Now
   SELECT azp01,azp052 INTO lc_azp01n,lc_azp052 FROM azp_file
    WHERE azp03 = g_dbs
   IF SQLCA.SQLCODE THEN
      CALL cl_err_msg(g_dbs,"lib-364","---|---",10)
      RETURN l_date
   END IF
   LET ls_tmp1 = lc_azp052 CLIPPED
   IF NOT ls_tmp1.getIndexOf("GMT",1) THEN
      LET ls_tmp2=g_dbs,"|",lc_azp052
      CALL cl_err_msg(lc_azp01n,"lib-364",ls_tmp2,10)
      RETURN l_date
   ELSE
      IF lc_azp052="GMT" OR lc_azp052="GMT-0" OR lc_azp052="GMT+0" THEN
         LET li_tz_now = 0
      END IF
      LET ls_tmp1=ls_tmp1.subString(4,ls_tmp1.getLength())
      LET li_tz_now = ls_tmp1.trim()
   END IF
 
   #Target
   SELECT azp03,azp052 INTO lc_azp03,lc_azp052 FROM azp_file
    WHERE azp01=lc_azp01
   IF SQLCA.SQLCODE THEN
      CALL cl_err_msg(lc_azp01,"lib-364","---|---",10)
      RETURN l_date
   END IF
   
   LET ls_tmp1 = lc_azp052 CLIPPED
   IF NOT ls_tmp1.getIndexOf("GMT",1) THEN
      LET ls_tmp2=lc_azp03,"|",lc_azp052
      CALL cl_err_msg(lc_azp01,"lib-364",ls_tmp2,10)
      RETURN l_date
   ELSE
      IF lc_azp052="GMT" OR lc_azp052="GMT-0" OR lc_azp052="GMT+0" THEN
         LET li_tz_target = 0
      END IF
      LET ls_tmp1=ls_tmp1.subString(4,ls_tmp1.getLength())
      LET li_tz_target = ls_tmp1.trim()
   END IF
 
   LET li_timediff = li_tz_now - li_tz_target
   IF TRUE THEN    #TRUE=Method1, FALSE=Method2
      LET ls_tmp1 = TIME(CURRENT)
      LET li_hour = ls_tmp1.subString(1,ls_tmp1.getIndexOf(":",1)-1)
      CASE
         WHEN li_hour - li_timediff < 0 
            RETURN l_date - 1
         WHEN li_hour - li_timediff > 24
            RETURN l_date + 1
         OTHERWISE
            RETURN l_date
      END CASE
   ELSE
      IF li_timediff > 0 THEN
         RETURN l_date - 1
      ELSE
         RETURN l_date 
      END IF
   END IF
 
END FUNCTION
 
