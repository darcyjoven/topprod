# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: p_setpara
# Descriptions...: Backgroud Job自動參數設置作業
# Date & Author..: 06/11/02 By yoyo
# Memo...........: 動態設定參數，根據傳入的參數，按照一定的規格返回出正確的參數
#                  Input: 預留了十五個參數,para1-para15
#                  RETURN: newpara1-newpara15
# Modify ........: No.FUN-690055 06/06/22 By yoyo 增加動態參數的功能
# Modify ........: No.FUN-7B0104 07/12/04 By David Fluid 動態參數指定部分新增設定執行日當天日期或執行日當天日期的前后幾天
# Modify ........: No.MOD-8A0042 08/10/06 By alexstar patch補過單:FUN-7B0104
# Modify ........: FUN-940053 2009/04/10 by David Lee 離開設定畫面立即回寫crotnab並提示操作成功與否,然後自動關閉本作業,並新>增解析報表作業QBE條件中的動態參數 格式${#} ${}表示動態參數 #表示動態參數類型,#為時間類型動態參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds     #FUN-690055 
 
GLOBALS "../../config/top.global" 
 
MAIN
   DEFINE l_i       LIKE type_file.num5,
          l_str     STRING
 
   WHENEVER ERROR CALL cl_err_msg_log  
  
   LET l_str = explainPara(ARG_VAL(1))
   FOR l_i = 2 TO 20
       LET l_str = l_str,"",explainPara(ARG_VAL(l_i)) 
   END FOR 
   DISPLAY l_str          
END MAIN
 
FUNCTION explainPara(p_para)
DEFINE p_para       STRING,
       l_para       STRING,
       l_newpara    STRING,
       l_time       base.StringTokenizer,
       l_str1       STRING,
       l_char       STRING,
       l_i          LIKE type_file.num10,
       l_newyear    LIKE type_file.num10,
       l_newmonth   LIKE type_file.num10,
       l_newday     LIKE type_file.num10,
       l_year       LIKE type_file.num10,
       l_des        STRING,
       l_month      STRING,
       l_week       STRING, 
       l_weekday    STRING, 
       l_day        STRING,   
       l_nday       STRING,    #Added by David Fluid  FUN-7B0104
       l_recycle    STRING,    #Added by David Fluid  FUN-7B0104
       l_today      DATE       #Added by David Fluid  FUN-7B0104 
       #Added David Lee FUN-940053
       ,l_s         SMALLINT
       ,l_j         SMALLINT
       ,l_k         SMALLINT
       ,l_l         SMALLINT
       ,l_ret       STRING
       #FUN-940053<-End
   #如果參數是時間性的動態參數,形式為:TIME(M,+1,3)(W按照月，日設置,+1,3後一個月的３號)或者為TIME(W,-1,3)(W按照週，禮拜設置，-1,3前一週的禮拜三)
   #TIME(D,+1)(D按日設置，+/-１代表執行當時日期的前或后一天) Added by David Fluid for FUN-7B0104 
   #如果為一般的靜態的參數,形式為:PARA(-d)
   #如果有額外的動態參數的需求,請自己設定相應的關鍵字形式
   IF NOT cl_null(p_para) THEN
      #對一般參數的處理
      LET l_para = p_para
      IF l_para.getIndexOf("PARA(",1) THEN
         LET l_newpara = l_para.subString(6,l_para.getLength()-1)
         LET l_ret = l_newpara clipped   #Added by David Lee #FUN-940053
      END IF
      #Added David Lee FUN-940053 Begin->
      LET l_s=p_para.getIndexOf("TIME(",1)
      LET l_j=p_para.getIndexOf(")",l_s)
      IF (l_s < l_j) THEN 
        LET l_s=1
        LET l_j=1
        LET l_k=1
        LET l_l=1
        WHILE TRUE 
          LET l_j=p_para.getIndexOf("TIME(",l_s)
          LET l_k=p_para.getIndexOf(")",l_j)
          IF(0==l_s OR-1==l_s OR 0==l_j OR -1==l_j OR 0==l_k OR -1==l_k OR 0==l_l OR -1==l_l ) THEN
            EXIT WHILE
          ELSE 
            LET l_ret=l_ret.append(p_para.subString(l_s,l_j-1))
            LET l_para=p_para.subString(l_j,l_k)
 
            #對動態時間參數處理
            IF l_para.getIndexOf("TIME(",1) THEN
              LET l_para = l_para.subString(6,l_para.getLength()-1)
              LET l_time = base.StringTokenizer.create(l_para,",")
              LET l_str1 = l_time.nextToken()
              #按照月,日來設定日期
              IF l_str1 = "M" THEN
                LET l_char = NULL
                LET l_i = 2
                WHILE l_time.hasMoreTokens()
                  CASE l_i
                    WHEN '2'
                      LET l_char = l_time.nextToken()
                      LET l_des = l_char.subString(1,1)
                      IF l_des = "+" OR l_des = "-" THEN
                        LET l_month = l_char.subString(2,l_char.getLength())
                      ELSE
                        LET l_month = l_char.subString(1,l_char.getLength())
                      END IF
                    WHEN '3'
                      LET l_day = l_time.nextToken()
                  END CASE
                  LET l_i = l_i+1
                END WHILE
                IF l_des = "+" OR l_des = "0" THEN
                  LET l_month = MONTH(TODAY) + l_month
                  LET l_newmonth = l_month MOD 12 
                  IF l_newmonth = 0 THEN
                    LET l_newmonth = 12
                  END IF
                  LET l_year = (l_month-1)/ 12
                  LET l_newyear = YEAR(TODAY) + l_year
                  IF l_day.getLength() > 2 THEN
                    LET l_day = getMonthEnd(l_newyear,l_newmonth)
                  END IF 
                  LET l_newpara = MDY(l_newmonth,l_day,l_newyear)
                END IF
                IF l_des = "-" THEN
                  IF l_month >= MONTH(TODAY) THEN 
                    LET l_newmonth = 12 - (l_month-MONTH(TODAY)) MOD 12
                    LET l_year = (l_month-MONTH(TODAY)+1)/12
                    LET l_newyear = YEAR(TODAY)-1-l_year
                    IF l_day.getLength() > 2 THEN
                      LET l_day = getMonthEnd(l_newyear,l_newmonth)
                    END IF 
                    LET l_newpara = MDY(l_newmonth,l_day,l_newyear)
                  ELSE
                    LET l_newmonth = MONTH(TODAY)-l_month
                    IF l_day.getLength() > 2 THEN
                      LET l_day = getMonthEnd(YEAR(TODAY),l_newmonth)
                    END IF 
                    LET l_newpara = MDY(l_newmonth,l_day,YEAR(TODAY))
                  END IF
                END IF
              END IF
              #按照週,禮拜來設置
              IF l_str1 = "W" THEN
                LET l_char = NULL
                LET l_i = 2
                WHILE l_time.hasMoreTokens()
                  CASE l_i
                    WHEN '2'
                      LET l_char = l_time.nextToken()
                      LET l_des = l_char.subString(1,1)
                      IF l_des = "+" OR l_des = "-" THEN
                        LET l_week = l_char.subString(2,l_char.getLength())
                      ELSE
                        LET l_week = l_char.subString(1,l_char.getLength())
                      END IF
                    WHEN '3'
                      LET l_weekday = l_time.nextToken()
                  END CASE
                  LET l_i = l_i+1
                END WHILE
                IF l_des = "+" OR l_des = "0" THEN 
                  #基準日為禮拜日時 
                  IF l_week > 0 AND WEEKDAY(TODAY) = 0 THEN
                    LET l_newday = 7*(l_week-1)+l_weekday
                    LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)+l_newday)
                  END IF
                  IF l_week = 0 AND WEEKDAY(TODAY) = 0 THEN
                    LET l_newday = 7-l_weekday
                    LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)-l_newday)
                  END IF
                  #基準日不為禮拜日時
                  IF l_week > 0 AND WEEKDAY(TODAY) != 0 THEN
                    LET l_newday = 7*l_week+l_weekday
                    LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)+l_newday)
                  END IF
                  IF l_week = 0 AND WEEKDAY(TODAY) != 0 THEN
                    LET l_newday = l_weekday
                    LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)+l_newday)
                  END IF               
                END IF
                IF l_des = "-" THEN 
                  #基準日為禮拜日時 
                  IF l_week > 0 AND WEEKDAY(TODAY) = 0 THEN
                    LET l_newday = 7*(l_week+1)-l_weekday
                    LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)-l_newday)
                  END IF
                  #基準日不為禮拜日時
                  IF l_week > 0 AND WEEKDAY(TODAY) != 0 THEN
                    LET l_newday = 7*l_week-l_weekday
                    LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)-l_newday)
                  END IF               
                END IF                   
              END IF
              #Added by David Fluid for FUN-7B0104 Begin->
              #按照日來設定日期
              IF l_str1 = "D" THEN
                LET l_char = NULL
                LET l_i = 2
                WHILE l_time.hasMoreTokens()
                  CASE l_i
                    WHEN '2'
                      LET l_char = l_time.nextToken()
                      LET l_des = l_char.subString(1,1)
                      IF l_des = "+" OR l_des = "-" THEN                          
                        LET l_nday = l_char.subString(2,l_char.getLength())      
                      ELSE                                                        
                        LET l_nday = l_char.subString(1,l_char.getLength())      
                      END IF                
                    OTHERWISE 
                      LET l_recycle= l_time.nextToken()
                  END CASE
                  LET l_i = l_i+1
                END WHILE
                LET l_today=TODAY
                IF l_des = "+" OR l_des = "0" THEN                                  
                 LET l_newpara=cal(l_today,0,l_nday)
                END IF                                       
                IF l_des = "-" THEN 
                  LET l_nday="-",l_nday
                  LET l_newpara=cal(l_today,0,l_nday)
                END IF            
              END IF
            END IF
            
            LET l_ret=l_ret.append(l_newpara clipped) 
            
            LET l_l=p_para.getIndexOf("TIME(",l_k)
            IF (0==l_l OR -1==l_l ) THEN
              LET l_l=p_para.getLength()+1
            END IF
            LET l_s=l_l
            LET l_ret=l_ret.append(p_para.subString(l_k+1,l_l-1))
          END IF
        END WHILE
      END IF
      #FUN-940053 <-End
   END IF 
   #Modified by David Lee #FUN-940053 Begin->
   LET l_ret = "'",l_ret clipped,"'"   
   RETURN l_ret
   #FUN-940053<-End
END FUNCTION
 
FUNCTION IsLeapYear(p_year)
DEFINE p_year   LIKE type_file.num5
  IF (p_year mod 4 = 0) AND (p_year mod 100 <> 0) THEN
     RETURN 1
  END IF
  IF p_year mod 400 = 0 THEN
     RETURN 1
  END IF
  RETURN 0
END FUNCTION
 
FUNCTION getMonthEnd(p_year,p_month)
DEFINE p_year   LIKE type_file.num5,
       p_month  LIKE type_file.num5
 
   CASE p_month
     WHEN 1 RETURN 31
     WHEN 2
       IF IsLeapYear(p_year) THEN
          RETURN 29
       ELSE
          RETURN 28
       END IF
     WHEN 3 RETURN 31
     WHEN 4 RETURN 30
     WHEN 5 RETURN 31
     WHEN 6 RETURN 30
     WHEN 7 RETURN 31
     WHEN 8 RETURN 31
     WHEN 9 RETURN 30
     WHEN 10 RETURN 31
     WHEN 11 RETURN 30
     WHEN 12 RETURN 31
     OTHERWISE RETURN -1
   END CASE
END FUNCTION
#Added by David Fluid for FUN-7B0104 Begin->
FUNCTION cal(p_date,p_month,p_day)
DEFINE
        p_date  LIKE type_file.dat,         
	      p_month LIKE type_file.num5,         
	      p_day   LIKE type_file.num5,        
	      i,j	LIKE type_file.num5,
	      l_year  LIKE abk_file.abk03,        
	      l_year1 LIKE abk_file.abk03,        
	      l_month LIKE type_file.num5,        
	      l_last  LIKE type_file.chr1,        
	      l_day   LIKE type_file.num5,         
	      l_day1  LIKE type_file.num5,        
	      l_date  LIKE type_file.dat,          
	      l_ryear LIKE type_file.chr1,          
              l_mm    LIKE type_file.num5              
 
	WHENEVER ERROR CONTINUE
        
        LET l_year  = YEAR(p_date)
        LET l_month = MONTH(p_date)
        LET l_day   = DAY(p_date)
 
        LET l_day1=28
        LET l_ryear = 'N'
        IF ( l_year >1582 AND (l_year mod 4 = 0)  AND 
           ((l_year mod 100 != 0) OR (l_year mod 400 = 0))) 
           OR (l_year <=1582 AND l_year mod 4 = 0 )
        THEN
           LET l_ryear = 'Y'
           LET l_day1=29
        END IF
      
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
   
        LET l_month = l_month + p_month
 
        IF l_month > 12 THEN
           LET l_year1 = l_month / 12  
           LET l_year  = l_year + l_year1
           LET l_month = l_month - 12 * l_year1
        END IF
 
   WHILE TRUE
 
        CASE
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
 
          WHEN   ((l_month mod 12)=4 or 
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
 
           WHEN (l_month mod 12)=2  
              LET l_day1=28
              LET l_ryear = 'N'
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
        LET l_last = 'N'
        IF l_last = 'N' AND p_day > 0 THEN
           LET l_day = l_day + p_day
            LET p_day = 0 
        END IF
        if l_month>12 then let l_mm=l_month mod 12 else let l_mm=l_month end if
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
 
      END WHILE
        IF l_month > 12 THEN
           LET l_year1 = l_month / 12  
           LET l_year  = l_year + l_year1
           LET l_month = l_month - 12 * l_year1
        END IF
       IF p_day < 0 THEN                             
           RETURN MDY(l_month,l_day,l_year) + p_day  
      ELSE
          RETURN MDY(l_month,l_day,l_year) 
      END IF
END FUNCTION
#FUN-7B0104 <-End
#MOD-8A0042 patch補過單:FUN-7B0104
