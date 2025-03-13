# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almp642.4gl
# Descriptions...: 積分月結計算作業 
# Date & Author..: No.FUN-CB0027 12/10/31 By pauline
# Modify.........: No.FUN-CC0023 12/12/06 By pauline 修改背景作業

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
	   year        LIKE type_file.chr4,
	   mon         LIKE type_file.chr2 
	  #more        LIKE type_file.chr1  # Input more condition(Y/N)  #FUN-CC0023 mark 
	   END RECORD
DEFINE   g_sql           STRING
DEFINE   g_str           STRING

MAIN


   OPTIONS
      INPUT NO WRAP          #输入的方式：不打转
   DEFER INTERRUPT           #撷取中断键

   LET tm.year = ARG_VAL(1)
   LET tm.mon = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL p642_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE
      CALL p642()                             #按傳入條件背景列印報表
      IF g_success = 'N' THEN
         ROLLBACK WORK
      ELSE
         COMMIT WORK
      END IF
   END IF

   DROP TABLE p642_temp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN


FUNCTION p642_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_date1        LIKE type_file.dat
   DEFINE l_date2        LIKE type_file.dat
   DEFINE l_j            LIKE type_file.num5
   DEFINE l_flag         LIKE type_file.chr1

   OPEN WINDOW p642_w AT p_row,p_col WITH FORM "alm/42f/almp642"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition

   LET tm.year = YEAR(g_today)
   LET tm.mon  = MONTH(g_today)

  #LET tm.more = 'N'   #FUN-CC0023 mark 
   WHILE TRUE

      DIALOG ATTRIBUTE(UNBUFFERED)

	 INPUT BY NAME tm.year, tm.mon ATTRIBUTE(WITHOUT DEFAULTS)
       
	    AFTER FIELD year
	       IF NOT cl_null(tm.year) THEN
		  IF length(tm.year) <> 4 THEN
		     CALL cl_err('','alm-h79',0)
		     NEXT FIELD year
		  END IF
		  FOR l_j = 1 TO 4
		      IF tm.year[l_j,l_j] NOT MATCHES '[0-9]' THEN
			 CALL cl_err('','alm-h80',0)
			 NEXT FIELD year
		      END IF
		  END FOR
	       END IF
       
	    AFTER FIELD mon
	       IF NOT cl_null(tm.mon) THEN
		  IF length(tm.mon) <> 2 THEN
		     CALL cl_err('','alm-h81',0)
		     NEXT FIELD mon
		  END IF
		  IF tm.mon[1,1] NOT MATCHES '[01]' THEN
		     CALL cl_err('','alm-h82',0)
		     NEXT FIELD mon
		  END IF
                  IF tm.mon[1,1] = '1' THEN
                     IF tm.mon[2,2] NOT MATCHES '[012]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon
                     END IF
                  ELSE
                     IF tm.mon[2,2] NOT MATCHES '[1-9]' THEN
                        CALL cl_err('','alm-h82',0)
                        NEXT FIELD mon
                     END IF
                  END IF
	       END IF
       
	 END INPUT

	#INPUT BY NAME tm.more ATTRIBUTE(WITHOUT DEFAULTS)   #FUN-CC0023 mark 
         INPUT BY NAME g_bgjob ATTRIBUTE(WITHOUT DEFAULTS)    #FUN-CC0023 add

	 END INPUT

	 ON ACTION locale
	    CALL cl_show_fld_cont()
	    LET g_action_choice = "locale"
	    EXIT DIALOG

	 ON ACTION CONTROLG
	    CALL cl_cmdask()

	 ON IDLE g_idle_seconds
	    CALL cl_on_idle()
	    CONTINUE DIALOG

	 ON ACTION about
	    CALL cl_about()

	 ON ACTION HELP
	    CALL cl_show_help()

	 ON ACTION EXIT
	    LET INT_FLAG = 1
	    EXIT DIALOG

	 ON ACTION ACCEPT
        #FUN-CC0023 mark START
	#   IF tm.more = 'Y' THEN
	#      CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
	#       	     g_bgjob,g_time,g_prtway,g_copies)
	#          RETURNING g_pdate,g_towhom,g_rlang,
	#       	     g_bgjob,g_time,g_prtway,g_copies
	#   END IF
        #FUN-CC0023 mark END
	    EXIT DIALOG

	 ON ACTION CANCEL
	    LET INT_FLAG=1
	    EXIT DIALOG


      END DIALOG

      IF INT_FLAG THEN
	 LET INT_FLAG = 0 CLOSE WINDOW p640_w
	 CALL cl_used(g_prog,g_time,2) RETURNING g_time
	 EXIT PROGRAM
      END IF

      IF g_action_choice = "locale" THEN
	 LET g_action_choice = ""
	 CALL cl_dynamic_locale()
	 CONTINUE WHILE
      END IF

      IF g_bgjob = 'Y' THEN
	 SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
	  WHERE zz01='almp642'
	 IF SQLCA.sqlcode OR l_cmd IS NULL THEN
	    CALL cl_err('almp642','9031',1)
	 ELSE
	    LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
		       " '",tm.year CLIPPED,"'" ,
		       " '",tm.mon CLIPPED,"'" ,
                       " '",g_bgjob CLIPPED,"'" 
	    CALL cl_cmdat('almp642',g_time,l_cmd)    # Execute cmd at later time
	 END IF
	 CLOSE WINDOW p640_w
	 CALL cl_used(g_prog,g_time,2) RETURNING g_time
	 EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL p642()
      CALL s_showmsg()
      IF g_success = 'N' THEN
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
      ELSE
         COMMIT WORK
         CALL cl_end2(1) RETURNING l_flag 
      END IF
      ERROR ""
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF

   END WHILE

   CLOSE WINDOW p640_w

END FUNCTION

FUNCTION p642()
   DEFINE l_sql       STRING
   DEFINE l_legal     LIKE azw_file.azw02 
   DEFINE l_plant     LIKE azw_file.azw01
   DEFINE l_ltv       RECORD LIKE ltv_file.*
   DEFINE l_ltw       RECORD LIKE ltw_file.*
   DEFINE l_year      LIKE type_file.chr4 
   DEFINE l_mon       LIKE type_file.chr2
   DEFINE l_aaa07     LIKE aaa_file.aaa07
   DEFINE l_lpj02     LIKE lpj_file.lpj02
   DEFINE l_lpj03     LIKE lpj_file.lpj03
   DEFINE l_flag      LIKE type_file.chr1   
   DEFINE l_lsm       RECORD LIKE lsm_file.*  
   DEFINE l_point     LIKE lsm_file.lsm04
   DEFINE l_point2    LIKE lsm_file.lsm04
   DEFINE l_i         LIKE type_file.num5

   LET g_success = 'Y' 
   LET l_flag = 'N'
   LET l_ltv.ltv01 = tm.year
   LET l_ltv.ltv02 = tm.mon
   LET l_ltw.ltw01 = tm.year
   LET l_ltw.ltw02 = tm.mon
  #關帳日期(含當月)之前不可做月結動作
   SELECT aaa07 INTO l_aaa07 FROM aaa_file 
      WHERE aaa01 = g_aza.aza81
   IF YEAR(l_aaa07) > tm.year THEN
      CALL cl_err('','alm-h84',1) 
      LET g_success = 'N'
      RETURN
   END IF 
   IF YEAR(l_aaa07) = tm.year THEN
      IF MONTH(l_aaa07) > tm.mon OR 
	 MONTH(l_aaa07) = tm.mon THEN
	 CALL cl_err('','alm-h84',1) 
         LET g_success = 'N'
	 RETURN
      END IF
   END IF  
   
  #判斷是否上月已做月結動作
   SELECT MAX(ltw01) INTO l_year FROM ltw_file 
   IF cl_null(l_year) THEN LET l_flag = 'Y' END IF  #利用l_flag判斷是否第一次做月結動作
   LET l_year = l_year USING "&&&&"
   IF NOT cl_null(l_year) THEN
      SELECT MAX(ltw02) INTO l_mon FROM ltw_file
          WHERE ltw01 = l_year
      LET l_mon = l_mon USING "&&"
     #輸入年份比上期年份小
      IF l_year > tm.year THEN
         LET g_errno = 'alm-h86'
      END IF
     #同年,只比較月
      IF l_year = tm.year THEN
         IF l_mon > tm.mon THEN
            LET g_errno = 'alm-h86'
         END IF
         IF l_mon = tm.mon THEN
            IF NOT cl_confirm('alm-h85') THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         IF l_mon + 1 < tm.mon THEN
            LET g_errno = 'alm-h83'
         END IF
      END IF
     #輸入年份比上期年份大
      IF l_year < tm.year THEN
         IF l_year + 1 = tm.year THEN
            IF tm.mon = '01' THEN
               IF l_mon <> '12' THEN
                  LET g_errno = 'alm-h83'
               END IF
            ELSE
               LET g_errno = 'alm-h83'
            END IF
         ELSE
            LET g_errno = 'alm-h83'
         END IF
      END IF

   END IF  
    
   IF NOT cl_null(g_errno)  THEN
      CALL cl_err('',g_errno,1)
      LET g_success = 'N'
      RETURN
   END IF

   DROP TABLE p642_temp
   CREATE TEMP TABLE p642_temp( 
      ltw01      LIKE ltw_file.ltw01,   #年度
      ltw02      LIKE ltw_file.ltw02,   #月份
      ltw03      LIKE ltw_file.ltw03,   #卡號
      ltw04      LIKE ltw_file.ltw04,   #分配營運中心
      ltw05      LIKE ltw_file.ltw05,   #期末積分
      legal      LIKE azw_file.azw02 )  #legal code
  
   DELETE FROM p642_temp 
   
   BEGIN WORK
   CALL s_showmsg_init()    
   #先清空本期的資料,確保資料正確 
   DELETE FROM ltv_file WHERE ltv01 = tm.year AND ltv02 = tm.mon
   DELETE FROM ltw_file WHERE ltv01 = tm.year AND ltv02 = tm.mon

   #抓取要做月結的卡號,卡種
   LET l_sql = " SELECT DISTINCT lpj03,lpj02 ",
	       "   FROM lpj_file WHERE lpj09 IN('2','5') ",
	       "                    OR (lpj09 = '4' AND YEAR(lpj21) = '",tm.year,"' ", 
	       "                         AND MONTH(lpj21) = '",tm.mon,"' )"
   PREPARE p642_pre FROM l_sql
   DECLARE p642_cur CURSOR FOR p642_pre 
   FOREACH p642_cur INTO l_lpj03, l_lpj02
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
      END IF
      DELETE FROM p642_temp 
      IF cl_null(l_lpj03) OR cl_null(l_lpj02) THEN
         CONTINUE FOREACH
      END IF  
      LET l_sql = " SELECT * FROM lsm_file ",
                  "   WHERE lsm01 = '",l_lpj03,"' "
      IF l_flag = 'N' THEN   #取上期期末當本期期初
         LET l_sql = l_sql," AND YEAR(lsm05)= '",tm.year,"' AND MONTH(lsm05) = '",tm.mon,"' "
      ELSE
         IF tm.year = '01' THEN
            LET l_sql = l_sql," AND ( YEAR(lsm05) < '",tm.year,"') " 
         ELSE
            LET l_sql = l_sql," AND ( YEAR(lsm05) < '",tm.year,"' ", 
                              "      OR (YEAR(lsm05) = '",tm.year,"' AND ( MONTH(lsm05) < '",tm.mon,"' OR MONTH(lsm05) = '",tm.mon,"') ))"
         END IF
      END IF
      LET l_sql = l_sql ," ORDER BY lsm05 "
      PREPARE p642_pre1 FROM l_sql
      DECLARE p642_cur1 CURSOR FOR p642_pre1
      LET l_ltv.ltv03 = l_lpj03   
      LET l_ltw.ltw03 = l_lpj03
      CALL p642_ins_temp(l_year,l_mon,l_lpj03,l_lpj02)
      FOREACH p642_cur1 INTO l_lsm.*
         IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN 
         END IF
         SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = l_lsm.lsmstore 
         #增加積分,不計算積分歸屬
         IF l_lsm.lsm04 > 0 OR l_lsm.lsm04 = 0 THEN
            LET l_ltv.ltv04 = '1'    #1.新增,2:兌換,3.失效 
            LET l_ltv.ltv05 = 1
            LET l_ltv.ltv06 = l_lsm.lsmstore
            LET l_ltv.ltv07 = l_lsm.lsmstore
            LET l_ltv.ltv08 = l_lsm.lsm04
            INSERT INTO ltv_file VALUES (l_ltv.*)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','ins ltv_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF  
            UPDATE p642_temp
               SET ltw05 = ltw05 + l_lsm.lsm04
                 WHERE ltw04 = l_lsm.lsmstore
            IF SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('lsm01',l_lsm.lsm01,'alm-h91','alm-h91',1) 
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         IF l_lsm.lsm04 < 0 THEN
            LET l_i = 1 
            WHILE TRUE
               CALL p642_temp_upd(l_lsm.lsm04,l_lsm.lsmstore,l_legal)
                    RETURNING l_plant,l_point2,l_lsm.lsm04
              #代表根本沒有資料可以異動
               IF l_point2 = 0 THEN
                  CALL s_errmsg('lsm01',l_lsm.lsm01,'alm-h91','alm-h91',1)   
                  LET g_success = 'N'
                  RETURN
               END IF
              #如果是積分清零/換卡的舊卡(會將舊卡積分轉移到新卡內,所以舊卡會有一筆資料是換卡但是積分是<0),則異動類別就為'3.兌換'
               IF l_lsm.lsm02 = '3' OR l_lsm.lsm02 = '4' THEN
                  LET l_ltv.ltv04 = '3'    #1.新增,2:兌換,3.失效
               ELSE
                  LET l_ltv.ltv04 = '2'    #1.新增,2:兌換,3.失效
               END IF
               LET l_ltv.ltv05 = l_i 
               LET l_ltv.ltv06 = l_lsm.lsmstore
               LET l_ltv.ltv07 = l_plant 
               LET l_ltv.ltv08 = l_point2
               INSERT INTO ltv_file VALUES (l_ltv.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins ltv_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_i = l_i + 1 
               IF l_lsm.lsm04 = 0 THEN EXIT WHILE END IF
            END WHILE
         END IF
      END FOREACH
      INSERT INTO ltw_file(ltw01,ltw02,ltw03,ltw04,ltw05)
        SELECT ltw01,ltw02,ltw03,ltw04,ltw05 FROM p642_temp
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','ins ltw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      DELETE FROM p642_temp 
   END FOREACH
END FUNCTION
  
#取得卡的期初餘額
FUNCTION p642_ins_temp(p_year,p_mon,p_lpj03,p_lpj02)
   DEFINE l_sql          STRING
   DEFINE l_flag         LIKE type_file.chr1   #是否第一次做月結動作
   DEFINE p_year         LIKE type_file.chr4
   DEFINE p_mon          LIKE type_file.chr2
   DEFINE p_lpj03        LIKE lpj_file.lpj03 
   DEFINE p_lpj02        LIKE lpj_file.lpj02
   DEFINE l_lnk03        LIKE lnk_file.lnk03
   DEFINE l_legal        LIKE azw_file.azw02
   DEFINE l_n            LIKE type_file.num5

   IF g_success = 'N' THEN RETURN END IF

   DELETE FROM p642_temp;
   IF cl_null(p_year) OR cl_null(p_mon) THEN
      IF tm.mon = '01' THEN
         LET p_mon = '12'
         LET p_year = tm.year - 1 
      ELSE
         LET p_mon = tm.mon - 1 
         LET p_year = tm.year 
      END IF
   END IF
   IF cl_null(p_lpj03) OR cl_null(p_lpj02) THEN
      RETURN
   END IF
   LET l_flag = 'N'
   #判斷會員卡是否存在之前的結餘檔,若存在直接拿取上月期末當本期期初
   SELECT COUNT(*) INTO l_n FROM ltw_file WHERE ltw03 = p_lpj03
   IF cl_null(l_n) OR l_n = 0  THEN
      LET l_flag = 'Y'
   ELSE 
      LET l_flag = 'N'
   END IF


   IF l_flag = 'N' THEN
      INSERT INTO p642_temp
          SELECT ltw01,ltw02,ltw03,ltw04,ltw05,azw02 FROM ltw_file,azw_file
            WHERE azw01 = ltw04 
              AND ltw01 = p_year AND ltw02 = p_mon AND ltw03 = p_lpj03
      UPDATE p642_temp SET ltw01 = tm.year,
                           ltw02 = tm.mon
   END IF
   IF l_flag = 'Y' THEN
      LET l_sql = " SELECT lnk03 FROM lnk_file ",
                  "   WHERE lnk01 = '",p_lpj02,"' AND lnk02 = '1'"
      PREPARE p642_pre2 FROM l_sql
      DECLARE p642_cur2 CURSOR FOR p642_pre2
      FOREACH p642_cur2 INTO l_lnk03
         IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN 
         END IF
         SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = l_lnk03
         INSERT INTO p642_temp VALUES (tm.year,tm.mon,p_lpj03,l_lnk03,0,l_legal)
      END FOREACH
   END IF    

END FUNCTION

FUNCTION p642_temp_upd(p_lsm04,p_lsmstore,p_legal)
   DEFINE p_lsm04         LIKE lsm_file.lsm04
   DEFINE p_lsmstore      LIKE lsm_file.lsmstore
   DEFINE p_legal         LIKE azw_file.azw02
   DEFINE l_point         LIKE lsm_file.lsm04
   DEFINE l_plant         LIKE azw_file.azw01
   DEFINE l_legal         LIKE azw_file.azw02


   IF cl_null(p_lsm04) OR p_lsm04 = 0 THEN
      RETURN p_lsmstore, 0 ,p_lsm04
   END IF 

   #取當前營運中心的積分扣除兌換積分
   SELECT ltw05 INTO l_point FROM p642_temp 
     WHERE ltw04 = p_lsmstore
   IF l_point > 0 THEN
      LET l_plant = p_lsmstore
      LET l_legal = p_legal 
      IF (p_lsm04 + l_point > 0) OR (p_lsm04 + l_point = 0 ) THEN 
         UPDATE p642_temp
            SET ltw05 = l_point + p_lsm04 
              WHERE ltw04 = l_plant
                AND legal = l_legal 
         RETURN l_plant, p_lsm04 , 0
      END IF
      IF p_lsm04 + l_point < 0 THEN
         UPDATE p642_temp
            SET ltw05 = 0 
              WHERE ltw04 = l_plant 
                AND legal = l_legal 
         RETURN l_plant, l_point*(-1)  , p_lsm04 + l_point 
      END IF
   END IF
  #取與當前營運中心同法人下的最高積分的營運中心扣除兌換積分
   SELECT MAX(ltw05) INTO l_point FROM p642_temp WHERE legal = p_legal 
   SELECT MAX(ltw04) INTO l_plant FROM p642_temp 
     WHERE ltw04 = l_point AND legal = p_legal
   IF l_point > 0 AND NOT cl_null(l_plant) THEN
      LET l_legal = p_legal 
      IF (p_lsm04 + l_point > 0) OR (p_lsm04 + l_point = 0 ) THEN 
         UPDATE p642_temp
            SET ltw05 = l_point +  p_lsm04
              WHERE ltw04 = l_plant
                AND legal = l_legal 
         RETURN l_plant, p_lsm04 , 0
      END IF
      IF p_lsm04 + l_point < 0 THEN
         UPDATE p642_temp
            SET ltw05 = 0
              WHERE ltw04 = l_plant
                AND legal = l_legal 
         RETURN l_plant, l_point*(-1)  , p_lsm04 + l_point
      END IF
   END IF

  #取得與當前營運中心不同法人下最高積分的plant扣除兌換積分 
   SELECT MAX(ltw05) INTO l_point FROM p642_temp  
   SELECT MAX(ltw04) INTO l_plant FROM p642_temp WHERE ltw05 = l_point
   IF l_point > 0 AND NOT cl_null(l_plant) THEN
      SELECT azw02 INTO l_legal FROM azw_file WHERE azw01 = l_plant
      IF (p_lsm04 + l_point > 0) OR (p_lsm04 + l_point = 0 ) THEN 
         UPDATE p642_temp
            SET ltw05 = l_point + p_lsm04
              WHERE ltw04 = l_plant
                AND legal = l_legal 
         RETURN l_plant, p_lsm04 , 0
      END IF
      IF p_lsm04 + l_point < 0 THEN
         UPDATE p642_temp
            SET ltw05 = 0
              WHERE ltw04 = l_plant
                AND legal = l_legal 
         RETURN l_plant, l_point*(-1)  , p_lsm04 + l_point
      END IF
   END IF
   RETURN '', 0, p_lsm04

END FUNCTION

#FUN-CB0027 
