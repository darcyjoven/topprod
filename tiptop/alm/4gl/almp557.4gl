# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almp557.4gl
# Descriptions...: 積分清零作業
# Date & Author..: NO.FUN-960134 09/07/23 By shiwuying
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A40015 10/04/06 By shiwuying 程序寫法更改
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsm07交易門店字段
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-BA0067 12/01/11 By pauline 刪除lsm07欄位,增加lsm08,lsmplant
# Modify.........: No:FUN-C50027 12/05/08 By pauline 卡清零積分調整改善 
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C90102 12/11/02 By pauline 將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
# Modify.........: No:FUN-CB0098 12/11/23 By Sakura 增加卡種生效範圍判斷
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
DATABASE ds
 
GLOBALS "../../config/top.global"
	
DEFINE g_lph           RECORD
       lph01           LIKE lph_file.lph01,
       lph17           LIKE lph_file.lph17,
       lph18           LIKE lph_file.lph18,
       lph19           LIKE lph_file.lph19,
       lph20           LIKE lph_file.lph20,
       lph31           LIKE lph_file.lph31,
       lph311          LIKE lph_file.lph31
                       END RECORD
DEFINE g_lpj           RECORD
       lpj03           LIKE lpj_file.lpj03,
       lpj04           LIKE lpj_file.lpj04,
       lpj12           LIKE lpj_file.lpj12,
       lpj25           LIKE lpj_file.lpj25
                       END RECORD
DEFINE g_wc            STRING
DEFINE g_sql           STRING
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_argv1         LIKE type_file.chr1     #由P_CRON呼叫
DEFINE g_cleandate     LIKE type_file.dat      #FUN-C50027 add 清零日期
 
MAIN  
 DEFINE l_date        LIKE type_file.dat
 DEFINE l_yy          LIKE type_file.chr4
 DEFINE l_mm          LIKE type_file.chr2
 DEFINE l_flag        LIKE type_file.chr1  #FUN-C50027 add 

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1=ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   WHILE TRUE
      IF NOT cl_null(g_argv1) THEN
         LET g_wc = " 1=1"
         CALL p557_process()
         EXIT WHILE
      END IF

      CALL p557()
      LET g_success = 'Y'
      BEGIN WORK

      CALL s_showmsg_init()
      CALL p557_process()
      CALL s_showmsg() 
      IF g_success = 'Y' THEN 
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
     #FUN-C50027 mark START
     #IF cl_confirm('lib-005') THEN
     #   CONTINUE WHILE
     #ELSE
     #   CLOSE WINDOW p557_w
     #   EXIT WHILE
     #END IF
     #FUN-C50027 mark END
     #FUN-C50027 add START
      IF g_success ='Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF NOT l_flag THEN
         CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF 
     #FUN-C50027 add END
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p557()
DEFINE    l_n        LIKE type_file.num5 
DEFINE    l_date2    LIKE type_file.dat   #FUN-C50027 add 
   WHILE TRUE
      LET g_action_choice = ""
 
      OPEN WINDOW p557_w WITH FORM "alm/42f/almp557"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_init()
 
      CLEAR FORM
      
      CLEAR FORM
      INITIALIZE g_lph.* TO NULL
      LET l_date2 = g_today      #FUN-C50027 add
      DISPLAY l_date2 TO date    #FUN-C50027 add
      DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-C50027 add

      CONSTRUCT BY NAME g_wc ON lph01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(lph01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lph2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lph01
                  NEXT FIELD lph01
               OTHERWISE EXIT CASE
            END CASE
      #FUN-C50027 add START
       END CONSTRUCT  

       INPUT l_date2 FROM date

         BEFORE INPUT
    
         AFTER FIELD date 
            IF NOT cl_null(date) THEN
               LET l_date2 = GET_FLDBUF(date)
               IF l_date2 > g_today AND l_date2 <> g_today THEN  
                  CALL cl_err('','agl-920',0)
                  NEXT FIELD date
               END IF
            END IF   
       END INPUT

      #FUN-C50027 add END
      BEFORE DIALOG                 #FUN-C50027 add
         LET l_date2 = g_today      #FUN-C50027 add
         DISPLAY l_date2 TO date    #FUN-C50027 add

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
           #CONTINUE CONSTRUCT
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

       #FUN-C50027 add START
         ON ACTION ACCEPT
            ACCEPT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT DIALOG
       #FUN-C50027 add END
     #END CONSTRUCT  #FUN-C50027 mark
      END DIALOG     #FUN-C50027 add
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
      LET g_cleandate = l_date2   #FUN-C50027 add   
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p557_w        
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF  
   EXIT WHILE       
  END WHILE  
END FUNCTION
 
FUNCTION p557_process() 

   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF

   LET g_sql="SELECT lph01,lph17,lph18,lph19,lph20,lph31,lph311 FROM lph_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND lph24 = 'Y' AND lph17 != '0' ",
             " ORDER BY lph01 "
   PREPARE p557_prepare FROM g_sql
   DECLARE p557_cs CURSOR FOR p557_prepare

   FOREACH p557_cs INTO g_lph.*
      IF STATUS THEN 
         CALL cl_err('FOREACH:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      CALL p557_card()

   END FOREACH
END FUNCTION

FUNCTION p557_card()
 DEFINE l_date     LIKE type_file.dat
 DEFINE l_lph19    LIKE lph_file.lph19
 DEFINE l_sql      STRING                   #FUN-C50027 add
 DEFINE l_sum      LIKE lqz_file.lqz03      #FUN-C50027 add  #上期剩餘
 DEFINE l_sum2     LIKE lqz_file.lqz04      #FUN-C50027 add  #本期使用
 DEFINE l_sum3     LIKE lqz_file.lqz06      #FUN-C50027 add  #本期增加
 DEFINE l_lqz05    LIKE lqz_file.lqz05      #FUN-C50027 add  #本次清零積分 
 DEFINE l_n        LIKE type_file.num5      #FUN-C50027 add

  #No.FUN-A40015 -BEGIN-----
  #DROP TABLE p557_tmp1
  #DELETE FROM p557_tmp1
  #LET g_sql = " SELECT lpj03,lpj04,lpj12,lpj25 FROM lpj_file ",
  #            "  WHERE lpj02 = '",g_lph.lph01,"' ",
  #            "    AND lpj09 = '2' OR lpj09 = '5' ",
  #            "    AND lpj12 > 0 AND lpj12 IS NOT NULL ",
  #            "   INTO TEMP p557_tmp1 "
  #PREPARE p557_reg_p1 FROM g_sql
  #EXECUTE p557_reg_p1
  #IF SQLCA.sqlcode THEN
  #   LET g_success = 'N'
  #   CALL s_errmsg('','','insert p557_tmp1',SQLCA.sqlcode,1)
  #   RETURN
  #END IF
  #CREATE UNIQUE INDEX p557_tmp1_01 ON p557_tmp1(lpj03);

  #DECLARE p557_lpj_cs CURSOR FOR
  # SELECT * FROM p557_tmp1
   DECLARE p557_lpj_cs CURSOR FOR
    SELECT lpj03,lpj04,lpj12,lpj25 FROM lpj_file
     WHERE lpj02 = g_lph.lph01
      #AND lpj09 = '2' OR lpj09 = '5'     #FUN-C50027 mark
       AND (lpj09 = '2' OR lpj09 = '5')   #FUN-C50027 add
       AND lpj12 > 0 AND lpj12 IS NOT NULL
  #No.FUN-A40015 -END-------


   FOREACH p557_lpj_cs INTO g_lpj.*
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
#FUN-CB0098---add---START
      IF NOT s_chk_lni('0',g_lph.lph01,g_plant,'') THEN
         CALL s_errmsg('lph01',g_lph.lph01,'','alm-694',1)
         LET g_success = 'N'
         EXIT FOREACH         
      END IF 
#FUN-CB0098---add-----END
     #FUN-C50027 add START
      LET l_n = 0 
      SELECT COUNT(*) INTO l_n FROM lqz_file
        WHERE lqz01 = g_lpj.lpj03 AND lqz02 = g_cleandate
      IF l_n > 0 OR cl_null(l_n) THEN
         CONTINUE FOREACH
      END IF
      IF g_lpj.lpj04 > g_cleandate THEN  #當發卡日期大於清零日期時,不執行清零
         CONTINUE FOREACH
      END IF
     #FUN-C50027 add END

      IF cl_null(g_lpj.lpj12) THEN LET g_lpj.lpj12 = 0 END IF
      IF g_lpj.lpj12 = 0 THEN CONTINUE FOREACH END IF

      IF g_lph.lph17 = '1' THEN
        #FUN-C50027 add START
         SELECT SUM(lsm04) INTO l_sum FROM lsm_file           #上期剩餘
              WHERE lsm01 = g_lpj.lpj03 AND (lsm05 <  g_cleandate  OR lsm05 = g_cleandate)
         IF cl_null(l_sum) THEN LET l_sum = 0 END IF
         LET l_sum2 = 0
         LET l_sum3 = 0
        #FUN-C50027 add END
         IF NOT cl_null(g_lpj.lpj25) THEN
        #   SELECT add_months(g_lpj.lpj25,g_lph.lph18) INTO l_date FROM dual
            CALL p557_add_month(g_lpj.lpj25,g_lph.lph18) RETURNING l_date
         ELSE
        #   SELECT add_months(g_lpj.lpj04,g_lph.lph18) INTO l_date FROM dual
            CALL p557_add_month(g_lpj.lpj04,g_lph.lph18) RETURNING l_date
         END IF
        #IF l_date = g_today THEN  #FUN-C50027 mark
         IF l_date = g_cleandate THEN  #FUN-C50027 add
           #CALL p557_clear()   #FUN-C50027 markd
            CALL p557_clear(l_sum)   #FUN-C50027 add
            CALL p557_ins_lqz(l_sum,l_sum2,l_sum3)   #新增積分清零記錄檔  #FUN-C50027 add
         END IF
      END IF

      IF g_lph.lph17 = '2' THEN
        #FUN-C50027 add START
         SELECT SUM(lsm04) INTO l_sum FROM lsm_file           #上期剩餘
              WHERE lsm01 = g_lpj.lpj03 AND (lsm05 <  g_cleandate  OR lsm05 = g_cleandate)
         IF cl_null(l_sum) THEN LET l_sum = 0 END IF
         LET l_sum2 = 0
         LET l_sum3 = 0
        #FUN-C50027 add END
         IF NOT cl_null(g_lpj.lpj25) THEN
           #LET l_lph19 = g_today - g_lpj.lpj25       #FUN-C50027 mark
            LET l_lph19 = g_cleandate - g_lpj.lpj25   #FUN-C50027 add
         ELSE
           #LET l_lph19 = g_today - g_lpj.lpj04       #FUN-C50027 mark
            LET l_lph19 = g_cleandate - g_lpj.lpj04   #FUN-C50027 add
         END IF
         IF g_lph.lph19 = l_lph19 THEN
           #CALL p557_clear()   #FUN-C50027 mark
            CALL p557_clear(l_sum)   #FUN-C50027 add
            CALL p557_ins_lqz(l_sum,l_sum2,l_sum3)   #新增積分清零記錄檔  #FUN-C50027 add
         END IF
      END IF

      IF g_lph.lph17 = '3' THEN
         IF cl_null(g_lph.lph20) THEN LET g_lph.lph20 = 0 END IF
        #FUN-C50027 mark START
        #IF g_today-g_lpj.lpj04 > g_lph.lph20 AND
        #   MONTH(g_today) = g_lph.lph31 AND DAY(g_today) = g_lph.lph311 THEN
        #   CALL p557_clear()
        #END IF 
        #FUN-C50027 mark START
        #FUN-C50027 add START
         IF MONTH(g_cleandate) <> g_lph.lph31 AND DAY(g_cleandate) <> g_lph.lph311 THEN CONTINUE FOREACH END IF
         IF g_lph.lph20 = 0 THEN
            LET l_date = g_cleandate 
         ELSE
            LET l_date  = MDY(MONTH(g_cleandate),DAY(g_cleandate),YEAR(g_cleandate))- g_lph.lph20 + 1    #本期區間開始日期    #當日不算
         END IF
         SELECT SUM(lsm04) INTO l_sum FROM lsm_file           #上期剩餘 
              WHERE lsm01 = g_lpj.lpj03 AND  (lsm05 < l_date OR lsm05 = l_date  )
         SELECT SUM(lsm04) INTO l_sum2 FROM lsm_file          #本期使用
              WHERE lsm01 = g_lpj.lpj03 AND lsm04 < 0      
                AND (lsm05 = l_date OR lsm05= g_cleandate OR (lsm05 > l_date AND lsm05 < g_cleandate))
         SELECT SUM(lsm04) INTO l_sum3 FROM lsm_file          #本期增加 
              WHERE lsm01 = g_lpj.lpj03 AND lsm04 > 0         
                AND (lsm05 = l_date OR lsm05= g_cleandate OR (lsm05 > l_date AND lsm05 < g_cleandate))     
         IF l_sum < 0 OR cl_null(l_sum) THEN LET l_sum = 0 END IF
         IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
         IF cl_null(l_sum3) THEN LET l_sum3 = 0 END IF
         LET l_lqz05 = l_sum + l_sum2     #清零積分等於上期剩於+本期使用(負數)
         IF l_lqz05 < 0 THEN LET l_lqz05 = 0 END IF
         CALL p557_clear(l_lqz05)
         IF g_lph.lph20 = 0 THEN
            LET l_sum2 = 0
            LET l_sum3 = 0
         END IF
         CALL p557_ins_lqz(l_sum,l_sum2,l_sum3)   #新增積分清零記錄檔
        #FUN-C50027 add END
      END IF

   END FOREACH

END FUNCTION

FUNCTION p557_clear(p_lqz05)   #FUN-C50027 add p_lqz05
 DEFINE p_lqz05     LIKE lqz_file.lqz05   #FUN-C50027 add
 DEFINE l_lpj12     LIKE lpj_file.lpj12   #FUN-C50027 add
 DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add 
 DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add
  
  #FUN-C50027 add START 
   IF p_lqz05 < 0   THEN      #若小於0代表為 月後清零/日後清零
      LET p_lqz05 = g_lpj.lpj12 
   END IF 
   LET l_lpj12 = g_lpj.lpj12 - p_lqz05              
   IF l_lpj12< 0 THEN LET l_lpj12 = 0 END IF        
  ##FUN-C50027 add END

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpj.lpj03   
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2' 
   ELSE
      LET l_lpjpos = '1' 
   END IF
  #FUN-D30007 add END

  #LET g_sql = " UPDATE lpj_file SET lpj12 = 0,lpj25 = ?  WHERE lpj03 = ? "    #FUN-C50027 mark
  #LET g_sql = " UPDATE lpj_file SET lpj12 = ?,lpj25 = ?  WHERE lpj03 = ? "    #FUN-C50027add  #FUN-D30007 mark 
   LET g_sql = " UPDATE lpj_file SET lpj12 = ?,lpj25 = ?,lpjpos = ?  WHERE lpj03 = ? "    #FUN-D30007 add
   PREPARE p557_reg_p2 FROM g_sql
  #EXECUTE p557_reg_p2 USING g_today,g_lpj.lpj03                #FUN-C50027 mark
  #EXECUTE p557_reg_p2 USING l_lpj12, g_cleandate, g_lpj.lpj03  #FUN-C50027 add  #FUN-D30007 mark 
   EXECUTE p557_reg_p2 USING l_lpj12, g_cleandate,l_lpjpos, g_lpj.lpj03  #FUN-D30007 add
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','upd lpj_file',SQLCA.sqlcode,1)
      RETURN           
   END IF

  #LET g_sql = " INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm07) ", #No.FUN-A70118  #FUN-BA0067 mark
  #            "  VALUES(?,'6',' ',?,?,'',?)"  #No.FUN-A70118                                        #FUN-BA0067 mark
  #LET g_sql = " INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmplant,lsmlegal,lsm15)",   #FUN-BA0067 add   #FUN-C70045 add lsm15  #FUN-C90102 mark
   LET g_sql = " INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15)",   #FUN-C90102 add
#              "   VALUES(?,'6',' ',?,?,'',0,'",g_plant,"','",g_legal,"')"                             #FUN-BA0067 add  #FUN-C70045 mark
               "   VALUES(?,'3',' ',?,?,'',0,'",g_plant,"','",g_legal,"','1')"                         #FUN-C70045 add
   PREPARE p557_reg_p3 FROM g_sql
   LET p_lqz05 = p_lqz05 * (-1)
  #EXECUTE p557_reg_p3 USING g_lpj.lpj03,g_lpj.lpj12,g_today,g_plant #No.FUN-A70118      #FUN-BA0067 mark
  #EXECUTE p557_reg_p3 USING g_lpj.lpj03,g_lpj.lpj12,g_today                             #FUN-BA0067 add  #FUN-C50027 mark
   EXECUTE p557_reg_p3 USING g_lpj.lpj03,p_lqz05,g_cleandate                             #FUN-C50027 add 
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','ins lsm_file',SQLCA.sqlcode,1)
      RETURN
   END IF
END FUNCTION

FUNCTION p557_add_month(p_date,p_mm)
 DEFINE p_mm          LIKE type_file.num5
 DEFINE p_date        LIKE type_file.dat
 DEFINE l_yy          LIKE type_file.num5 #No.FUN-9B0136
 DEFINE l_mm          LIKE type_file.num5 #No.FUN-9B0136

   LET l_mm = MONTH(p_date)
   LET l_yy = YEAR(p_date)
   IF p_mm > 12 THEN
      LET l_yy = l_yy + p_mm/12
      LET l_mm = l_mm + (p_mm MOD 12)
   ELSE
      LET l_mm = l_mm + p_mm
   END IF 
   IF l_mm > 12 THEN
      LET l_yy = l_yy + 1
      LET l_mm = l_mm - 12
   END IF
   LET p_date = MDY(l_mm,DAY(p_date),l_yy)
   RETURN p_date
END FUNCTION
#No.FUN-960134 
#FUN-C50027 add START
FUNCTION p557_ins_lqz(p_sum,p_sum2,p_sum3)
 DEFINE p_sum      LIKE lqz_file.lqz03      #FUN-C50027 add  #上期剩餘
 DEFINE p_sum2     LIKE lqz_file.lqz04      #FUN-C50027 add  #本期使用
 DEFINE p_sum3     LIKE lqz_file.lqz06      #FUN-C50027 add  #本期增加
 DEFINE l_lqz      RECORD LIKE lqz_file.*   #FUN-C50027 add

   LET l_lqz.lqz01 = g_lpj.lpj03
   LET l_lqz.lqz02 = g_cleandate
   LET l_lqz.lqz03 = p_sum 
   LET l_lqz.lqz04 = p_sum2  *(-1)
   LET l_lqz.lqz05 = p_sum + p_sum2
   IF p_sum < 0 THEN    #上期剩於小於0時,不清零
      LET p_sum = 0
      LET l_lqz.lqz05 = 0
   END IF
   IF l_lqz.lqz05 < 0 THEN  #上期剩於扣除本期使用後小於0,不清零
      LET l_lqz.lqz05 = 0
   END IF
   LET l_lqz.lqz06 = p_sum3
   LET l_lqz.lqz07 = l_lqz.lqz03 -l_lqz.lqz04 - l_lqz.lqz05 + l_lqz.lqz06 
   LET l_lqz.lqzdate = g_today
   LET l_lqz.lqzgrup = g_grup
   LET l_lqz.lqzmodu = g_user
   LET l_lqz.lqzuser = g_user
   LET l_lqz.lqzorig = g_grup
   LET l_lqz.lqzoriu = g_user


    INSERT INTO lqz_file VALUES(l_lqz.*)
    IF SQLCA.sqlcode THEN
       CALL s_errmsg('','',l_lqz.lqz01,SQLCA.sqlcode,1)
       LET g_success="N"
    END IF   

END FUNCTION
#FUN-C50027 add END
