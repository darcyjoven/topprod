# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_months.4gl
# Descriptions...: 取得該月份的天數
# Date & Author..: 
# Usage..........: LET l_days=s_months(p_date)
# Input Parameter: p_date  日期
# Return code....: l_date  天數
# Memo...........: 計算該月份的天數, 潤年的計算方式:
#                  被4 除盡, 若能被100 除盡, 則還要被400 除盡
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds      #No.FUN-680147    #FUN-7C0053
 
FUNCTION s_months(p_date)
DEFINE
    p_date LIKE type_file.dat,           #No.FUN-680147 DATE
    l_year LIKE type_file.num10,         #No.FUN-680147 INTEGER
    l_month LIKE type_file.num10         #No.FUN-680147 INTEGER  #月份
 
    IF p_date IS NULL THEN RETURN 0 END IF
    LET l_month=MONTH(p_date) 
    IF l_month=1 OR l_month=3 OR l_month=5 OR
       l_month=7 OR l_month=8 OR l_month=10 OR
       l_month=12 THEN
        RETURN 31
    END IF
    IF l_month=4 OR l_month=6 OR l_month=9 OR
       l_month=11 THEN
        RETURN 30
    END IF
    LET l_year=YEAR(p_date) #計算是否為潤年
    LET l_month=l_year MOD 4
    IF l_month=0 THEN #被4除盡
        LET l_month=l_year MOD 100
        IF l_month=0 THEN #被100除盡
            LET l_month=l_year MOD 400
            IF l_month=0 THEN #被400除盡
                RETURN 29 #被4及100及400除盡
            ELSE
                RETURN 28
            END IF
        ELSE
            RETURN 29 #被4除盡但不能被100除盡
        END IF
    ELSE #不能被4除盡
        RETURN 28
    END IF
END FUNCTION
