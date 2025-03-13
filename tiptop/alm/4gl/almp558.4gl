# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: almp558.4gl
# Descriptions...: 積分清零作業
# Date & Author..: NO.FUN-960134 09/07/23 By shiwuying
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A40015 10/04/06 By shiwuying 程序寫法更改
# Modify.........: No:FUN-C30042 12/03/21 By pauline lph09調整 0.無效期限制  1.指定日期  2.指定長度  
# Modify.........: No:FUN-C30176 12/06/13 By pauline 將畫面上的日期欄位隱藏
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
DATABASE ds
 
GLOBALS "../../config/top.global"
	
DEFINE g_lph           RECORD
       lph01           LIKE lph_file.lph01,
       lph11           LIKE lph_file.lph11,
       lph13           LIKE lph_file.lph13,
       lph14           LIKE lph_file.lph14,
       lph15           LIKE lph_file.lph15,
       lph16           LIKE lph_file.lph16
                       END RECORD
DEFINE g_lpj           RECORD
       lpj03           LIKE lpj_file.lpj03,
       lpj05           LIKE lpj_file.lpj05,
       lpj14           LIKE lpj_file.lpj14,
       lpj15           LIKE lpj_file.lpj15,
       lpj07           LIKE lpj_file.lpj07
                       END RECORD
DEFINE g_wc            STRING
DEFINE g_sql           STRING
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_argv1         LIKE type_file.chr1     #由P_CRON呼叫
 
MAIN  
 DEFINE l_flag        LIKE type_file.chr1
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
         CALL p558_process()
         EXIT WHILE
      END IF

      LET g_success = 'Y'
      CALL p558()
      IF g_success = 'N' THEN
         EXIT WHILE
      END IF
      BEGIN WORK

      CALL s_showmsg_init()
      CALL p558_process()
      CALL s_showmsg() 
      IF g_success = 'Y' THEN 
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      IF cl_confirm('lib-005') THEN
         CONTINUE WHILE
      ELSE
         CLOSE WINDOW p558_w
         EXIT WHILE
      END IF
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p558()
DEFINE    l_n        LIKE type_file.num5 

   WHILE TRUE
      LET g_action_choice = ""
 
      OPEN WINDOW p558_w WITH FORM "alm/42f/almp557"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_init()

      CALL cl_set_comp_visible("date",FALSE)    #FUN-C30176 add
 
      CLEAR FORM
      
      CLEAR FORM
      INITIALIZE g_lph.* TO NULL
      CONSTRUCT BY NAME g_wc ON lph01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
    
         ON ACTION controlp
            CASE
               WHEN INFIELD(lph01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lph3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lph01
                  NEXT FIELD lph01
               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

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
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p558_w        
         LET g_success = 'N'
      END IF  
   EXIT WHILE       
  END WHILE  
END FUNCTION
 
FUNCTION p558_process() 

   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF

   LET g_sql="SELECT lph01,lph11,lph13,lph14,lph15,lph16 FROM lph_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND lph24 = 'Y' AND lph12 = 'Y' ",
            #"   AND lph09 = '1' AND lph11 IS NOT NULL",  #FUN-C30042 mark
             "   AND lph09 = '2' AND lph11 IS NOT NULL",  #FUN-C30042 add             
             " ORDER BY lph01 "
   PREPARE p558_prepare FROM g_sql
   DECLARE p558_cs CURSOR FOR p558_prepare

   FOREACH p558_cs INTO g_lph.*
      IF STATUS THEN 
         CALL cl_err('FOREACH:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      CALL p558_card()

   END FOREACH
END FUNCTION

FUNCTION p558_card()
 DEFINE l_addmonths     LIKE type_file.dat

  #No.FUN-A40015 -BEGIN-----
  #DROP TABLE p558_tmp1
  #DELETE FROM p558_tmp1
  #LET g_sql = " SELECT lpj03,lpj05,lpj14,lpj15,lpj07 FROM lpj_file ",
  #            "  WHERE lpj02 = '",g_lph.lph01,"' ",
  #            "    AND lpj09 = '2' AND lpj05 IS NOT NULL",
  #            "    AND lpj05 < '",g_today,"' ",
  #            "   INTO TEMP p558_tmp1 "
  #PREPARE p558_reg_p1 FROM g_sql
  #EXECUTE p558_reg_p1
  #IF SQLCA.sqlcode THEN
  #   LET g_success = 'N'
  #   CALL s_errmsg('','','insert p558_tmp1',SQLCA.sqlcode,1)
  #   RETURN
  #END IF
  #CREATE UNIQUE INDEX p558_tmp1_01 ON p558_tmp1(lpj03);

  #DECLARE p558_lpj_cs CURSOR FOR
  # SELECT * FROM p558_tmp1
   DECLARE p558_lpj_cs CURSOR FOR
    SELECT lpj03,lpj05,lpj14,lpj15,lpj07 FROM lpj_file
     WHERE lpj02 = g_lph.lph01
       AND lpj09 = '2' AND lpj05 IS NOT NULL
       AND lpj05 < g_today
  #No.FUN-A40015 -END-------
   FOREACH p558_lpj_cs INTO g_lpj.*
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

   #  SELECT add_months(g_lpj.lpj05,g_lph.lph11) INTO l_addmonths FROM dual
      CALL p558_add_month(g_lpj.lpj05,g_lph.lph11) RETURNING l_addmonths

      IF g_lph.lph13 = '0' THEN
         IF cl_null(g_lph.lph14) THEN
            LET g_lph.lph14 = 0
         END IF
         IF g_lpj.lpj14 >= g_lph.lph14 THEN
            CALL p558_add(l_addmonths)
         END IF
      END IF

      IF g_lph.lph13 = '1' THEN
         IF cl_null(g_lph.lph15) THEN
            LET g_lph.lph15 = 0
         END IF
         IF g_lpj.lpj15 >= g_lph.lph15 THEN
            CALL p558_add(l_addmonths)
         END IF
      END IF

      IF g_lph.lph13 = '2' THEN
         IF cl_null(g_lph.lph16) THEN
            LET g_lph.lph16 = 0
         END IF
         IF g_lpj.lpj07 >= g_lph.lph16 THEN
            CALL p558_add(l_addmonths)
         END IF 
      END IF
   END FOREACH
END FUNCTION

FUNCTION p558_add(p_addmonths)
 DEFINE p_addmonths     LIKE type_file.dat
 DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add
 DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpj.lpj03
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END 


  #LET g_sql = " UPDATE lpj_file SET lpj05 = ? WHERE lpj03 = ? "  #FUN-D30007 mark 
   LET g_sql = " UPDATE lpj_file SET lpj05 = ? ,lpjpos = ? WHERE lpj03 = ? "  #FUN-D30007 add 
   PREPARE p558_reg_p2 FROM g_sql
  #EXECUTE p558_reg_p2 USING p_addmonths,g_lpj.lpj03   #FUN-D30007 mark 
   EXECUTE p558_reg_p2 USING p_addmonths, l_lpjpos, g_lpj.lpj03   #FUN-D30007 add 
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','upd lpj_file',SQLCA.sqlcode,1)
      RETURN           
   END IF
END FUNCTION

FUNCTION p558_add_month(p_date,p_mm)
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
