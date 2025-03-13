# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_day.4gl
# Descriptions...: 取得每月第??日
# Date & Author..: 93/04/07 By Jones
# Usage..........: LET l_day=s_day(p_date)
# Input Parameter: p_date  日期
# Return code....: l_day   第??日
# Modify.........: No.FUN-680085 06/08/25 By kim 加入相關日期處理的函數
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-A70128 10/12/24 修改s_incmonth
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_day(p_date)
DEFINE
   p_date LIKE type_file.dat,           #No.FUN-680147 DATE
   l_date LIKE smh_file.smh01,          #No.FUN-680147 VARCHAR(08)
   l_day  LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
       LET l_date=p_date USING 'YYYYMMDD'
       LET l_day = l_date[7,8]
   RETURN l_day
END FUNCTION
 
#kim:FUN-680085...............begin
#取得當月第一天
FUNCTION s_getfirstday(p_date)
DEFINE p_date LIKE type_file.dat           #No.FUN-680147 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   ELSE
      RETURN MDY(MONTH(p_date),1,YEAR(p_date))
   END IF
END FUNCTION
 
#取得當月最後一天
FUNCTION s_getlastday(p_date)
DEFINE p_date LIKE type_file.dat           #No.FUN-680147 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION
 
#回傳傳入的天數+p_n個月
FUNCTION s_incmonth(p_date,p_n)
   DEFINE p_date      LIKE type_file.dat           #No.FUN-680147 DATE
   DEFINE p_n,l_m,l_y LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE p_bdate,p_edate,l_base      LIKE type_file.dat
 
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   LET l_m=MONTH(p_date)+p_n
   LET l_y=0
   IF l_m>12 THEN
      LET l_y=l_m/12
      LET l_m=l_m MOD 12
      IF l_m=0 THEN
         LET l_m=12
      END IF
   END IF

   #引用s_mothck_ar來處理小月問題
   IF DAY(p_date) = 31 OR ( l_m = 2 AND DAY(p_date) > 28 ) THEN  #TQC-A70128
      LET l_base = MDY(l_m, 1, YEAR(p_date)+l_y)
      CALL s_mothck_ar(l_base) RETURNING p_bdate,p_edate
      RETURN p_edate
   END IF

   RETURN MDY(l_m,DAY(p_date),YEAR(p_date)+l_y)

END FUNCTION
#FUN-680085...............end
