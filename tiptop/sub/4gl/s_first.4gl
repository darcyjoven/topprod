# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_last.4gl
# Descriptions...: 取得當月第一天, 原理同取得最後一天, 只不過是往前推罷了
# Date & Author..: 90/11/19 By Lee
# Usage..........: LET l_date=s_first(p_date)
# Input Parameter: p_date  日期
# Return code....: l_date  最後一天日期
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #No.FUN-680147   #FUN-7C0053
 
#取得當月第一天, 原理同取得最後一天, 只不過是往前推罷了
FUNCTION s_first(p_date)
DEFINE p_date     LIKE type_file.dat,          #No.FUN-680147 DATE
       p_date2    LIKE type_file.dat,          #No.FUN-680147 DATE
       l_date     LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    LET l_date=DAY(p_date) #取得現在為第幾天
    LET p_date2=DATE(p_date-(l_date-1))
    RETURN p_date2
END FUNCTION
