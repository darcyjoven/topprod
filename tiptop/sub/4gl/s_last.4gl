# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_last.4gl
# Descriptions...: 取得該月份最後一天的日期
# Date & Author..: 90/11/19 By Lee
# Usage..........: LET l_date=s_last(p_date)
# Input Parameter: p_date   日期
# Return code....: l_date   最後一天日期
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds      #No.FUN-680147  #FUN-7C0053
 
#取得當月最後一天
FUNCTION s_last(p_date)
DEFINE
    p_date LIKE type_file.dat,              #No.FUN-680147 DATE
    l_day  LIKE type_file.num5,             #No.FUN-680147 SMALLINT
    l_date LIKE type_file.num5,             #No.FUN-680147 SMALLINT
    l_date2  LIKE type_file.dat             #No.FUN-680147 DATE
 
    LET l_day=s_months(p_date) #取得該月份的天數
    LET l_date=DAY(p_date) #取得現在為第幾天
    #以該月份的天數減去現在為第幾天, 例如11月29日, 該月有30天, 則30-29=1
    #表示距月底尚有一天
    LET l_day=l_day-l_date
    #將日期加上該時距, 取得最後一天的日期
    LET l_date2 = DATE(p_date+l_day)
    RETURN  l_date2
END FUNCTION
