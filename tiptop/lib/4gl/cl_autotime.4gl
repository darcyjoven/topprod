# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_autotime
# Descriptions...: 自動累加時間,累加級數為1
# Memo...........:
# Input parameter: time1  - 累加起始時間
#                  sw     - 累加類型 H:小時 M:分鐘 S:秒鐘
#                  lay    - 累加級數 Default = 1
# Return code....: time
# Usage..........: call cl_autotime(time1,sw,lay)
#                  call cl_autotime('09:30','H',1)
#                  call cl_autotime('09:40','M',1)
#                  call cl_autotime('09:40','S',1)
# Date & Author..: 2004/02/12 By Leagh
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
#
 
DATABASE ds
GLOBALS
   DEFINE g_user	LIKE cre_file.cre08
END GLOBALS
 
FUNCTION cl_autotime(time1,sw,lay)
   DEFINE time1		LIKE type_file.chr8,         #No.FUN-690005 VARCHAR(8)
          sw		LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1)
          lay   	LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          l_lay   	LIKE type_file.num5,         #No.FUN-690005 SMALLINT
          l_autotime	LIKE type_file.chr8,         #No.FUN-690005 VARCHAR(8)
          l_hour    	LIKE type_file.chr8,         #No.FUN-690005 VARCHAR(8)
          l_minute  	LIKE type_file.chr8,         #No.FUN-690005 VARCHAR(8)
          l_second  	LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
   WHENEVER ERROR CONTINUE
 
   IF cl_null(time1) OR cl_null(sw) THEN RETURN END IF
   IF cl_null(lay) THEN LET l_lay = 1 ELSE LET l_lay = lay END IF
 
   LET l_autotime = time1
   LET l_hour   = NULL
   LET l_minute = NULL
   LET l_second = NULL
   LET l_hour   = l_autotime[1,2]
   LET l_minute = l_autotime[4,5]
   LET l_second = l_autotime[7,8]
   
   CASE WHEN sw = 'H' LET l_hour   = l_hour + l_lay
        WHEN sw = 'M' LET l_minute = l_minute + l_lay
        WHEN sw = 'S' LET l_second = l_second + l_lay
   END CASE
 
   WHILE l_second >= 60 
      LET l_second = l_second - 60
      LET l_minute = l_minute + 1
   END WHILE
   WHILE l_minute >= 60 
      LET l_minute = l_minute - 60
      LET l_hour = l_hour + 1 
   END WHILE
   WHILE l_hour >=24
      LET l_hour = l_hour - 24
   END WHILE
   LET l_hour   = l_hour   USING '&&'
   LET l_minute = l_minute USING '&&'
   LET l_second = l_second USING '&&'
   LET l_autotime = l_hour CLIPPED,':',l_minute  CLIPPED,':', l_second CLIPPED
       
   RETURN l_autotime
END FUNCTION
