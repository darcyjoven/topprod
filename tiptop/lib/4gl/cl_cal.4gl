# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# 
# Library name...: cl_cal
# Date & Author..: 93/01/08 By alexlin
# Modify.........: No.MOD-570185 05/08/08 By Rosayu  處理當p_day<0 時的做法
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.MOD-890195 08/09/19 By wujie 跨年時沒有重新計算是否是閏年
# Modify.........: No.MOD-8A0191 08/10/22 By wujie 跨2年以上時有錯誤
# Modify.........: No.MOD-8C0069 08/12/09 By Sarah 跨年時沒有重新判斷是否為閏年
# Modify.........: No:MOD-9C0044 09/12/03 By Dido 若為12月時,計算月份有誤 
# Modify.........: No:FUN-A80003 10/08/10 By tommas 月份參數使用負數
# Modify.........: No:FUN-C80048 12/08/18 By madey 將DISPLAY p_date註解掉
 
DATABASE ds
 
DEFINE
	l_year  LIKE abk_file.abk03,         #No.FUN-690005 SMALLINT
	l_year1 LIKE abk_file.abk03,         #No.FUN-690005 SMALLINT
	l_month LIKE type_file.num5,         #No.FUN-690005 SMALLINT
	l_last  LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1)
	l_day   LIKE type_file.num5,         #No.FUN-690005 SMALLINT
	l_day1  LIKE type_file.num5,         #No.FUN-690005 SMALLINT
	l_date  LIKE type_file.dat,          #No.FUN-690005 DATE
	l_ryear LIKE type_file.chr1          #No.FUN-690005 VARCHAR(1)
DEFINE  l_mm    LIKE type_file.num5          #No.FUN-690005 SMALLINT


# Descriptions...: 傳入目前日期,月份及天數參數取得正確日期
# Input parameter: p_date  日期
#                  p_month 月份
#                  p_day   日
# Return code....: l_year,l_month,l_day
# Usage .........: LET l_date=cl_cal(p_date,p_mm,p_dd)

FUNCTION cl_cal(p_date,p_month,p_day)
DEFINE
        p_date  LIKE type_file.dat,          #No.FUN-690005 DATE
	p_month LIKE type_file.num5,         #No.FUN-690005 SMALLINT
	p_day   LIKE type_file.num5,         #No.FUN-690005 SMALLINT
	i,j	LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
	WHENEVER ERROR CONTINUE
        
	#大小月口訣如下:
	#一月大, 二月小, 三月大, 四月小, 五月大 , 六月小, 七月大,
	#八月大, 九月小, 十月大, 十一月小, 十二月大
       #DISPLAY p_date                       #FUN-C80048 marked
        LET l_year  = YEAR(p_date)
        LET l_month = MONTH(p_date)
        LET l_day   = DAY(p_date)
 
        CALL rdate_chk()       #閏年檢查
        #LET l_month = l_month + p_month
        CALL lastday_chk()     #每月最後一天檢查
        LET l_month = l_month + p_month
 
        IF l_month > 12 THEN
           LET l_year1 = l_month / 12   # USING '&'           
           LET l_year  = l_year + l_year1
           LET l_month = l_month - 12 * l_year1
          #-MOD-9C0044-add-
           IF l_month = 0 THEN 
              LET l_year = l_year - 1
              LET l_month = 12
           END IF
          #-MOD-9C0044-end-
           CALL rdate_chk()       #閏年檢查          #MOD-8C0069 add
           CALL lastday_chk()     #每月最後一天檢查  #MOD-8C0069 add
        END IF
        
        #No.FUN-A80003 start

        IF l_month <= 0 THEN
           LET l_year1 = l_month / 12 -1
           LET l_year  = l_year + l_year1
           LET l_month = l_month - 12 * l_year1
           IF l_month = 0 THEN 
              LET l_year = l_year - 1
              LET l_month = 12
           END IF
           CALL rdate_chk()       #閏年檢查      
           CALL lastday_chk()     #每月最後一天檢查 
        END IF

        #No.FUN-A80003 end
 
      WHILE TRUE
 
	#大月有三十一天
        CASE
          #WHEN (l_month=1 OR l_month=3 OR l_month=5
	  #   OR l_month=7 OR l_month=8 OR l_month=10 OR l_month=12)
          # yuening
           when ((l_month mod 12)=1 or 
                 (l_month mod 12)=3 or 
                 (l_month mod 12)=5 or 
                 (l_month mod 12)=7 or 
                 (l_month mod 12)=8 or 
                 (l_month mod 12)=10 or 
                 (l_month mod 12)=0 )
		LET l_day1=31
                IF l_day > l_day1 AND l_last ='N'  THEN
                   LET l_day = l_day - l_day1
                   LET l_month = l_month + 1
                END IF
                IF l_day < l_day1 and l_last = 'Y'  THEN
                    LET l_day = l_day1
                    IF p_day > 0 THEN
                       LET l_month = l_month + 1
                       LET l_day = p_day
                       LET p_day = 0   
                       
                    END IF 
                END IF
                EXIT CASE
 
	#小月有三十天
          #WHEN (l_month=4 OR l_month=6 OR l_month=9 OR l_month=11)
          #yuening
           when ((l_month mod 12)=4 or 
                 (l_month mod 12)=6 or 
                 (l_month mod 12)=9 or 
                 (l_month mod 12)=11 ) 
 
		LET l_day1=30
                IF l_day > l_day1 AND l_last = 'N' THEN
                   LET l_day = l_day - l_day1
                   LET l_month = l_month + 1
                END IF
                IF l_day <> l_day1 and l_last = 'Y'  THEN
                    LET l_day = l_day1
                    IF p_day > 0 THEN
                       LET l_month = l_month + 1
                       LET l_day = p_day
                       LET p_day = 0   
                       
                    END IF 
                END IF
                EXIT CASE
 
	#二月雖然是小月, 但要判斷是否潤年
          #WHEN l_month=2 #THEN
           when (l_month mod 12)=2  #yuening
              LET l_day1=28
              LET l_ryear = 'N'
           #--- 潤年可 與 100 及 4 整除
              IF ( l_year >1582 AND (l_year mod 4 = 0)  AND 
                  ((l_year mod 100 != 0) OR (l_year mod 400 = 0))) 
                   OR (l_year <=1582 AND l_year mod 4 = 0 )
                   THEN
                 LET l_day1=29
                 LET l_ryear = 'Y'
              END IF
                IF l_day > l_day1  AND l_last = 'N' THEN
                   LET l_day = l_day - l_day1
                   LET l_month = l_month + 1
                END IF
                IF l_day <> l_day1 and l_last = 'Y'  THEN
                    LET l_day = l_day1
                    IF p_day > 0 THEN
                       LET l_month = l_month + 1
                       LET l_day = p_day
                       LET p_day = 0   
                    END IF 
                END IF
                EXIT CASE
           OTHERWISE
            EXIT CASE  
         END CASE 
        #CALL rdate_chk()
        LET l_last = 'N'
        IF l_last = 'N' AND p_day > 0 THEN
           LET l_day = l_day + p_day
            LET p_day = 0 #MOD-570185 add 
        END IF
        # LET p_day = 0 #MOD-570185 MARK
       #IF ((l_month=1 OR l_month=3 OR l_month=5
#      OR l_month=7 OR l_month=8 OR l_month=10 OR l_month=12)
#             AND l_day > 31) 
#          OR ((l_month=4 OR l_month=6 OR l_month=9 OR l_month=11)
#              AND l_day > 30)
#          OR (l_ryear ='Y' AND l_month=2 AND l_day > 29 )
#          OR (l_ryear ='N' AND l_month=2 AND l_day > 28 )
#          THEN CONTINUE WHILE
#          ELSE EXIT WHILE
#       END IF
#yuening ------------
#No.MOD-890195 --begin                                                          
#       if l_month>12 then let l_mm=l_month mod 12 else let l_mm=l_month end if 
        IF l_month>12 THEN                                                      
           LET l_mm=l_month mod 12                                              
           IF l_mm=1 THEN                                                       
              LET l_year =l_year+1          
              LET l_month =l_month -12     #No.MOD-8A0191                                    
              IF ( l_year >1582 AND (l_year mod 4 = 0)  AND                     
                  ((l_year mod 100 != 0) OR (l_year mod 400 = 0)))              
                   OR (l_year <=1582 AND l_year mod 4 = 0 )                     
                   THEN                                                         
                 LET l_ryear = 'Y'                                              
              ELSE                                                              
                 LET l_ryear = 'N'                                              
              END IF                                                            
           END IF                                                               
         ELSE                                                                   
           LET l_mm=l_month                                                     
         END IF                                                                 
#No.MOD-890195 --end 
        IF ((l_mm=1 OR l_mm=3 OR l_mm=5
	      OR l_mm=7 OR l_mm=8 OR l_mm=10 OR l_mm=12)
              AND l_day > 31) 
           OR ((l_mm=4 OR l_mm=6 OR l_mm=9 OR l_mm=11)
               AND l_day > 30)
           OR (l_ryear ='Y' AND l_mm=2 AND l_day > 29 )
           OR (l_ryear ='N' AND l_mm=2 AND l_day > 28 )
           THEN CONTINUE WHILE
           ELSE EXIT WHILE
        END IF
#----------------------
	#RETURN l_days
      END WHILE
        IF l_month > 12 THEN
           LET l_year1 = l_month / 12   # USING '&'           
#          LET l_year  = l_year + l_year1    #No.MOD-890195
           LET l_month = l_month - 12 * l_year1
        END IF
      #DISPLAY l_year,l_month,l_day
 
     #RETURN l_year,l_month,l_day
       IF p_day < 0 THEN                             #MOD-570185 add
           RETURN MDY(l_month,l_day,l_year) + p_day  #MOD-570185 add
      ELSE
          RETURN MDY(l_month,l_day,l_year) #yuening
      END IF
END FUNCTION
 
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 檢查是否為最後一天
# Memo...........:
# Input parameter: none
# Return code....: none
# Usage..........: CALL lastday_chk()
# Date & Author..: 93/01/08 By alexlin
# Modify.........: No.FUN-7C0045
##########################################################################
PRIVATE FUNCTION lastday_chk()
 
    CASE   
        WHEN ((l_month=1 OR l_month=3 OR l_month=5
	      OR l_month=7 OR l_month=8 OR l_month=10 OR l_month=12)
              AND l_day = 31)
              LET l_last = 'Y'
        WHEN ((l_month=4 OR l_month=6 OR l_month=9 OR l_month=11)
               AND l_day >= 30)
              LET l_last = 'Y'
        WHEN (l_ryear ='Y' AND l_month=2 AND l_day >= 29 )
              LET l_last = 'Y'
        WHEN (l_ryear ='N' AND l_month=2 AND l_day >= 28 )
              LET l_last = 'Y'
        OTHERWISE 
              LET l_last = 'N'
   END CASE
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 檢查是否為閏年
# Memo...........:
# Input parameter: none
# Return code....: none
# Usage..........: CALL rdate_chk()
# Date & Author..: 93/01/08 By alexlin
# Modify.........: 
##########################################################################
PRIVATE FUNCTION rdate_chk()
 
           #IF  l_month=2 THEN
              LET l_day1=28
              LET l_ryear = 'N'
           #--- 潤年
              IF ( l_year >1582 AND (l_year mod 4 = 0)  AND 
                  ((l_year mod 100 != 0) OR (l_year mod 400 = 0))) 
                   OR (l_year <=1582 AND l_year mod 4 = 0 )
                   THEN
                 LET l_ryear = 'Y'
                 LET l_day1=29
                 #IF l_month = 2 THEN
                  #  LET l_day1=29
                 #END IF
              END IF
          #END IF
 
 
END FUNCTION
 
##########################################################################
# Descriptions...: 計算指定日期 A 當月的第 B個星期C (星期天=0 ..星期六=6)
# Input parameter: date A , smallint B, smallint C
# Return code....: when Error Return NULL / Normal Return Date
# Usage..........: CALL rdate_chk()
# Date & Author..: 10/03/16 By alex
##########################################################################
FUNCTION cl_cal_assigned_weekday(ld_given, li_th, li_weekday)

   DEFINE ld_given      DATE
   DEFINE ld_assign     DATE
   DEFINE li_th         LIKE type_file.num5
   DEFINE li_weekday    LIKE type_file.num5
   DEFINE li_magicnum   LIKE type_file.num5

   #排除不合理條件
   IF cl_null(ld_given) OR li_th <=0 OR li_th > 5 OR li_weekday <= 0 OR li_weekday > 6 THEN
      RETURN NULL
   END IF 

   LET ld_given = MDY( MONTH(ld_given), 1, YEAR(ld_given))

   LET li_magicnum = (li_th-1) * 7 + 1 + li_weekday - WEEKDAY(ld_given)

   LET ld_assign = MDY( MONTH(ld_given), li_magicnum, YEAR(ld_given))

   RETURN ld_assign
END FUNCTION


