# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_mothck.4gl
# Descriptions...: 讀取該日期所在的月份之第一天及最後一天
# Date & Author..: 92/09/29 By Lin
# Usage..........: CALL s_mothck(p_date) RETURNING l_bdate,l_edate
# Input Parameter: p_date    日期
# Return code....: l_bdate   該月之第一天
#                  l_edate   該月之最後一天
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_mothck(p_date)
    DEFINE  p_date     LIKE type_file.dat,           #No.FUN-680147 DATE
            p_bdate    LIKE type_file.dat,           #No.FUN-680147 DATE
            p_edate    LIKE type_file.dat,           #No.FUN-680147 DATE
            l_date     LIKE type_file.dat,           #No.FUN-680147 DATE
            b_date     LIKE smh_file.smh01,          #No.FUN-680147 VARCHAR(8)
            l_tmp      LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
    IF p_date IS NULL OR p_date=' ' THEN
       RETURN '',''
    END IF
    LET b_date=p_date USING "yyyymmdd"
    IF b_date[7,8]<>'01' THEN
       LET b_date=b_date[1,4],b_date[5,6],b_date[7,8]*0+1 USING '&&'
    END IF
    LET p_bdate = MDY(b_date[5,6],b_date[7,8],b_date[1,4])    #該月第一天
    #將月份加一, 再將日期減一, 即可得到上月的最後一天
    LET b_date=b_date[1,4],b_date[5,6]+1 USING '&&',b_date[7,8]
    IF b_date[5,6]='13' THEN
       LET b_date=b_date[1,4]+1 USING '&&&&',b_date[5,6]*0+1
                   USING '&&',b_date[7,8]
    END IF
    LET l_date = MDY(b_date[5,6],b_date[7,8],b_date[1,4]) #該月之最後一天
    LET p_edate=l_date-1
    RETURN p_bdate,p_edate
END FUNCTION
