# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_part.4gl
# Descriptions...: 部份科目之選擇
# Date & Author..: 92/04/09 By Nora
# Usage .........: call s_part(l_tm) returning l_tm
#                  if s_course(l_tm) then ..  else .. end if
#                     (true : 1 , false : 0)
# Input Parameter: l_tm(科目之五段,是否選擇)
# Return code....: 1   YES
#                  0   NO
# Memo...........: 部份科目選擇, 若按Delete 鍵放棄, 則選擇全部科目
# Modify.........: 92/09/23 Genero 原先g_aaz21-25定義於agl1.4gl現取消而置入原程
#                                  式中  需注意是否會有問題產生 by hjwang
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE
      g_aaz21         ARRAY[30] OF LIKE aaz_file.aaz212,        # Prog. Version..: '5.30.06-13.03.12(06)  #第一段之科目條件
      g_aaz22         ARRAY[30] OF LIKE aaz_file.aaz222,        # Prog. Version..: '5.30.06-13.03.12(06)  #第二段之科目條件
      g_aaz23         ARRAY[30] OF LIKE aaz_file.aaz232,        # Prog. Version..: '5.30.06-13.03.12(06)  #第三段之科目條件
      g_aaz24         ARRAY[30] OF LIKE aaz_file.aaz242,        # Prog. Version..: '5.30.06-13.03.12(06)  #第四段之科目條件
      g_aaz25         ARRAY[30] OF LIKE aaz_file.aaz252         # Prog. Version..: '5.30.06-13.03.12(06)   #第五段之科目條件
 
 
DEFINE   g_arrno         LIKE type_file.num5          #No.FUN-680147 SMALLINT  #科目條件之ARRAY個數
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680147 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(72)
DEFINE   g_scrno         LIKE type_file.num5          #No.FUN-680147 SMALLINT  #科目條件之SCREEN ARRAY個數
FUNCTION s_part(l_tm)
    DEFINE  l_tm     RECORD
				a    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)   #選擇否
				b    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)   #選擇否
				c    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)   #選擇否
				d    LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)   #選擇否
				e    LIKE type_file.chr1           #No.FUN-680147 VARCHAR(1)    #選擇否
				END  RECORD
 
   OPEN WINDOW s_partw1 AT 5,2 WITH FORM "sub/42f/s_part"
   ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_part")
 
   CALL cl_getmsg('agl-051',g_lang) RETURNING g_msg
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET g_msg=''
   ELSE
      DISPLAY g_msg AT 1,2
   END IF
    DISPLAY BY NAME g_aaz.aaz21,g_aaz.aaz211,g_aaz.aaz22,g_aaz.aaz221,
			g_aaz.aaz23,g_aaz.aaz231,g_aaz.aaz24,g_aaz.aaz241,
			g_aaz.aaz25,g_aaz.aaz251,g_aaz.aaz26
	FOR g_i = 1 TO  g_scrno 
	    DISPLAY g_aaz21[g_i] TO s_aaz21[g_i].f 
		DISPLAY g_aaz22[g_i] TO s_aaz22[g_i].g 
		DISPLAY g_aaz23[g_i] TO s_aaz23[g_i].h 
		DISPLAY g_aaz24[g_i] TO s_aaz24[g_i].i 
		DISPLAY g_aaz25[g_i] TO s_aaz25[g_i].j 
	END FOR
    INPUT BY NAME l_tm.a,l_tm.b,l_tm.c,l_tm.d,l_tm.e WITHOUT DEFAULTS
 
	AFTER FIELD a
	   IF l_tm.a IS NULL OR l_tm.a NOT MATCHES'[YN]' THEN
		  NEXT FIELD a
	   END IF
	   IF l_tm.a = 'Y' THEN CALL s_parti1() END IF
 
	AFTER FIELD b
	   IF l_tm.b IS NULL OR l_tm.b NOT MATCHES'[YN]' THEN
		  NEXT FIELD b
	   END IF
	   IF l_tm.b = 'Y' THEN CALL s_parti2() END IF
 
	AFTER FIELD c
	   IF l_tm.c IS NULL OR l_tm.c NOT MATCHES'[YN]' THEN
		  NEXT FIELD c
	   END IF
	   IF l_tm.c = 'Y' THEN CALL s_parti3() END IF
 
	AFTER FIELD d
	   IF l_tm.d IS NULL OR l_tm.d NOT MATCHES'[YN]' THEN
		  NEXT FIELD d
	   END IF
	   IF l_tm.d = 'Y' THEN CALL s_parti4() END IF
 
	AFTER FIELD e
	   IF l_tm.e IS NULL OR l_tm.e NOT MATCHES'[YN]' THEN
		  NEXT FIELD e
	   END IF
	   IF l_tm.e = 'Y' THEN CALL s_parti5() END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT 
	IF INT_FLAG THEN 
	   FOR g_i = 1 TO g_arrno 
		   LET g_aaz21[g_i] = NULL LET g_aaz22[g_i] = NULL
		   LET g_aaz23[g_i] = NULL LET g_aaz24[g_i] = NULL
		   LET g_aaz25[g_i] = NULL
	   END FOR
	END IF
	CLOSE WINDOW s_partw1
	RETURN l_tm.* 
END FUNCTION
 
    
FUNCTION s_parti1()
    DEFINE l_ac,l_sl  LIKE type_file.num5         #No.FUN-680147 SMALLINT
 
    CALL cl_getmsg('agl-052',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
    INPUT ARRAY g_aaz21 WITHOUT DEFAULTS FROM s_aaz21.* 
 
	BEFORE ROW 
	   LET l_ac = ARR_CURR()
	   LET l_sl = SCR_LINE()
 
	AFTER ROW
	   IF INT_FLAG THEN 
	      LET INT_FLAG = 0
	      LET g_aaz21[l_ac] = NULL
	      DISPLAY g_aaz21[l_ac] TO s_aaz21[l_sl].f
	      CALL cl_err('',9001,0)
		  EXIT INPUT
       END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
	CALL cl_getmsg('agl-051',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
END FUNCTION
 
    
FUNCTION s_parti2()
    DEFINE l_ac,l_sl  LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    CALL cl_getmsg('agl-052',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
    INPUT ARRAY g_aaz22 WITHOUT DEFAULTS FROM s_aaz22.* 
 
	BEFORE ROW 
	   LET l_ac = ARR_CURR()
	   LET l_sl = SCR_LINE()
 
	AFTER ROW
	   IF INT_FLAG THEN 
	      LET INT_FLAG = 0
	      LET g_aaz22[l_ac] = NULL
	      DISPLAY g_aaz22[l_ac] TO s_aaz22[l_sl].g
	      CALL cl_err('',9001,0)
		  EXIT INPUT
       END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
	CALL cl_getmsg('agl-051',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
END FUNCTION
 
    
FUNCTION s_parti3()
    DEFINE l_ac,l_sl  LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
    CALL cl_getmsg('agl-052',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
    INPUT ARRAY g_aaz23 WITHOUT DEFAULTS FROM s_aaz23.* 
 
	BEFORE ROW 
	   LET l_ac = ARR_CURR()
	   LET l_sl = SCR_LINE()
 
	AFTER ROW
	   IF INT_FLAG THEN 
	      LET INT_FLAG = 0
	      LET g_aaz21[l_ac] = NULL
	      DISPLAY g_aaz23[l_ac] TO s_aaz23[l_sl].h
	      CALL cl_err('',9001,0)
		  EXIT INPUT
       END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
	CALL cl_getmsg('agl-051',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
END FUNCTION
 
    
FUNCTION s_parti4()
    DEFINE l_ac,l_sl  LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
    CALL cl_getmsg('agl-052',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
    INPUT ARRAY g_aaz24 WITHOUT DEFAULTS FROM s_aaz24.* 
 
	BEFORE ROW 
	   LET l_ac = ARR_CURR()
	   LET l_sl = SCR_LINE()
 
	AFTER ROW
	   IF INT_FLAG THEN 
	      LET INT_FLAG = 0
	      LET g_aaz24[l_ac] = NULL
	      DISPLAY g_aaz24[l_ac] TO s_aaz24[l_sl].i
	      CALL cl_err('',9001,0)
		  EXIT INPUT
       END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
	CALL cl_getmsg('agl-051',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
END FUNCTION
 
    
FUNCTION s_parti5()
    DEFINE l_ac,l_sl  LIKE type_file.num5           #No.FUN-680147 SMALLINT
 
    CALL cl_getmsg('agl-052',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
    INPUT ARRAY g_aaz25 WITHOUT DEFAULTS FROM s_aaz25.* 
 
	BEFORE ROW 
	   LET l_ac = ARR_CURR()
	   LET l_sl = SCR_LINE()
 
	AFTER ROW
	   IF INT_FLAG THEN 
	      LET INT_FLAG = 0
	      LET g_aaz25[l_ac] = NULL
	      DISPLAY g_aaz25[l_ac] TO s_aaz25[l_sl].j
	      CALL cl_err('',9001,0)
		  EXIT INPUT
       END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
	CALL cl_getmsg('agl-051',g_lang) RETURNING g_msg
	DISPLAY g_msg AT 1,2
END FUNCTION
 
   
FUNCTION r100_course(l_tm,l_aah01)
    DEFINE l_tm      RECORD
			 a   LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01) #選擇否
			 b   LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01) #選擇否
			 c   LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01) #選擇否
			 d   LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01) #選擇否
			 e   LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01) #選擇否
		   END RECORD,
		   l_flag     LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
		   l_flag1    LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)
		   l_aah01    LIKE aah_file.aah01,
		   l_sec1,l_sec2,l_sec3,l_sec4  LIKE type_file.num5   #No.FUN-680147 SMALLINT  #各段的結束位置
 
    LET l_sec1 = g_aaz.aaz21
	LET l_sec2 = g_aaz.aaz21 + g_aaz.aaz22
	LET l_sec3 = g_aaz.aaz21 + g_aaz.aaz22 + g_aaz.aaz23
	LET l_sec4 = g_aaz.aaz21 + g_aaz.aaz22 + g_aaz.aaz23 + g_aaz.aaz24
    #科目第一段位的檢查, 若不符合選擇條件, 則傳回0值,並讀下一筆資料
	LET l_flag = '1'
    IF l_tm.a = 'Y' THEN
	   LET l_flag = '0'
	   FOR g_i = 1 TO g_arrno 
		   IF g_aaz21[g_i] IS NOT NULL  AND g_aaz21[g_i] != ' ' THEN
			  IF l_aah01[1,l_sec1] MATCHES g_aaz21[g_i] THEN
				 LET l_flag = '1'
				 EXIT FOR
			  END IF
		   END IF
	   END FOR
	END IF
	IF l_flag = '0' THEN RETURN 0 END IF
    #科目第二段位的檢查, 若不符合選擇條件, 則傳回0值,並讀下一筆資料
    IF l_tm.b = 'Y' THEN
	   LET l_flag = '0'
	   FOR g_i = 1 TO g_arrno 
		   IF g_aaz22[g_i] IS NOT NULL  AND g_aaz22[g_i] != ' ' THEN
			  IF l_aah01[l_sec1+1,l_sec2] MATCHES g_aaz22[g_i] THEN
				 LET l_flag = '1'
				 EXIT FOR
			  END IF
		   END IF
	   END FOR
	END IF
	IF l_flag = '0' THEN RETURN 0 END IF
    #科目第三段位的檢查, 若不符合選擇條件, 則傳回0值,並讀下一筆資料
    IF l_tm.c = 'Y' THEN
	   LET l_flag = '0'
	   FOR g_i = 1 TO g_arrno 
		   IF g_aaz23[g_i] IS NOT NULL AND g_aaz23[g_i] != ' ' THEN
			  IF l_aah01[l_sec2+1,l_sec3] MATCHES g_aaz23[g_i] THEN
				 LET l_flag = '1'
				 EXIT FOR
			  END IF
		   END IF
	   END FOR
	END IF
	IF l_flag = '0' THEN RETURN 0 END IF
    #科目第四段位的檢查, 若不符合選擇條件, 則傳回0值,並讀下一筆資料
    IF l_tm.d = 'Y' THEN
	   LET l_flag = '0'
	   FOR g_i = 1 TO g_arrno 
		   IF g_aaz24[g_i] IS NOT NULL AND g_aaz24[g_i] != ' ' THEN
			  IF l_aah01[l_sec3+1,l_sec4] MATCHES g_aaz24[g_i] THEN
				 LET l_flag = '1'
				 EXIT FOR
			  END IF
		   END IF
	   END FOR
	END IF
	IF l_flag = '0' THEN RETURN 0 END IF
    #科目第五段位的檢查, 若不符合選擇條件, 則傳回0值,並讀下一筆資料
    IF l_tm.e = 'Y' THEN
	   LET l_flag = '0'
	   FOR g_i = 1 TO g_arrno 
		   IF g_aaz25[g_i] IS NOT NULL AND g_aaz25[g_i] != ' ' THEN
			  IF l_aah01[l_sec4+1,24] MATCHES g_aaz25[g_i] THEN
				 LET l_flag = '1'
				 EXIT FOR
			  END IF
		   END IF
	   END FOR
	END IF
	#若皆符合科目之選擇, 則傳回true
	IF l_flag = '1' THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
