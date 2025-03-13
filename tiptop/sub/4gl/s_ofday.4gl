# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_ofday.4gl
# Descriptions...: 計算兩日期間之工作日數
# Date & Author..: 
# Usage..........: CALL s_ofday(p_strtdate,p_duedate) RETURNING l_days
# Input Parameter: p_date     起始日期
#                  p_offset   推算期間
# Return code....: l_day      工作日數
# Memo...........: 在計算之前請先CALL s_filldate()
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_ofday(p_strtdate,p_duedate)
DEFINE
    p_strtdate LIKE type_file.dat,          #No.FUN-680147 DATE
    p_duedate  LIKE type_file.dat,          #No.FUN-680147 DATE
    l_i        LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_between  LIKE type_file.num10,        #No.FUN-680147 INTEGER
    l_offset1  LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_offset2  LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    IF p_strtdate < g_mind OR p_strtdate > g_maxd
        OR p_duedate < g_mind OR p_duedate> g_maxd THEN #out of range
        LET l_between=p_duedate-p_strtdate
    ELSE
        LET l_offset1=p_strtdate-g_mind
        FOR l_i=l_offset1 TO 1 STEP -1 #get start date in array
            IF p_strtdate=g_work[l_i] THEN
                EXIT FOR
            END IF
			IF l_i>1 THEN
            	IF p_strtdate<g_work[l_i]
					AND p_strtdate>g_work[l_i-1] THEN
                	EXIT FOR
            	END IF
			ELSE
				LET l_i=1
				EXIT FOR
			END IF
        END FOR
        IF (l_i<=1 AND p_strtdate != g_mind) THEN #can't find
            LET l_between=p_duedate-p_strtdate
        ELSE
            LET l_offset1=l_i
            LET l_offset2=p_duedate-g_mind
            FOR l_i=l_offset2 TO 1 STEP -1 #get start date in array
                IF p_duedate = g_work[l_i] THEN
                    LET l_i=l_i+1
                    EXIT FOR
                END IF
                CASE
                  WHEN l_i>1 
                       IF p_duedate<g_work[l_i] 
                          AND p_duedate>g_work[l_i-1] THEN
                          EXIT FOR
                       END IF
                  WHEN l_i=1 
                       IF p_duedate<g_work[l_i] THEN
                          EXIT FOR
                       END IF
                END CASE
            END FOR
            IF (l_i<=1 AND p_duedate != g_mind) THEN #can't find
                LET l_between=p_duedate-p_strtdate
            ELSE
                LET l_between=l_i-l_offset1
            END IF
        END IF
    END IF
    RETURN l_between
END FUNCTION
