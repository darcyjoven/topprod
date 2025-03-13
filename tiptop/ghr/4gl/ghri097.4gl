# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri097
# Descriptions...: 薪酬期末关帐作业
# Date & Author..: 13/08/06 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrdxa          DYNAMIC ARRAY OF RECORD
            hrdx04        LIKE hrdx_file.hrdx04,
            hrct07        LIKE hrct_file.hrct07,
            hrct08        LIKE hrct_file.hrct08,
            suma          LIKE type_file.num5,
            hrdx14        LIKE hrdx_file.hrdx14
                        END RECORD,
       g_hrdxb          DYNAMIC ARRAY OF RECORD
            hrat01a       LIKE hrat_file.hrat01,
            hrat02a       LIKE hrat_file.hrat02,
            hrat04a       LIKE hrat_file.hrat04,
            hrat05a       LIKE hrat_file.hrat05,
            hrat25a       LIKE hrat_file.hrat25,
            hrdl02a       LIKE hrdl_file.hrdl02
                        END RECORD,
       g_hrdxc          DYNAMIC ARRAY OF RECORD
            hrat01b       LIKE hrat_file.hrat01,
            hrat02b       LIKE hrat_file.hrat02,
            hrat04b       LIKE hrat_file.hrat04,
            hrat05b       LIKE hrat_file.hrat05,
            hrat25b       LIKE hrat_file.hrat25,
            hrat77b       LIKE hrat_file.hrat77,
            hrdl02b       LIKE hrdl_file.hrdl02
                        END RECORD
DEFINE g_hrct01         LIKE hrct_file.hrct01
DEFINE g_hrct11         LIKE hrct_file.hrct11
DEFINE g_hrct03         LIKE hrct_file.hrct03
DEFINE g_num1           LIKE type_file.num5
DEFINE g_num2           LIKE type_file.num5
DEFINE g_num3           LIKE type_file.num5
DEFINE g_num4           LIKE type_file.num5
DEFINE g_flag_b         LIKE type_file.chr1
DEFINE g_flag_1         LIKE type_file.chr1
DEFINE g_flag_2         LIKE type_file.chr1
DEFINE g_flag_3         LIKE type_file.chr1
DEFINE g_cnt            LIKE type_file.num5
DEFINE g_rec_b1         LIKE type_file.num5
DEFINE g_rec_b2         LIKE type_file.num5
DEFINE g_rec_b3         LIKE type_file.num5
DEFINE g_sql            STRING

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                      #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW i097_w WITH FORM "ghr/42f/ghri097"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL i097_menu()

   CLOSE WINDOW i097_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i097_cs()
DEFINE l_hrct03   LIKE hrct_file.hrct03
DEFINE l_hrct07   LIKE hrct_file.hrct07
DEFINE l_hrct08   LIKE hrct_file.hrct08
DEFINE l_hraa12   LIKE hraa_file.hraa12

    INPUT g_hrct03,g_hrct01,g_hrct11 WITHOUT DEFAULTS FROM hrct03,hrct01,hrct11
       #BEFORE INPUT
       #   SELECT to_char(YEAR(g_today)) INTO g_hrct01 FROM dual
       #   DISPLAY g_hrct01 TO hrct01

      AFTER FIELD hrct03
         IF NOT cl_null(g_hrct03) THEN
            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = g_hrct03
            DISPLAY l_hraa12 TO hrct03_name
            SELECT hrct01,hrct11 INTO g_hrct01,g_hrct11 FROM (SELECT * FROM hrct_file WHERE hrct03=g_hrct03 AND hrct06='N' ORDER BY hrct07) t WHERE rownum=1
            IF cl_null(g_hrct01) THEN
               CALL cl_err('该公司没有建立薪资月或不存在没有关帐的薪资月','!',1)
               NEXT FIELD hrct03
            ELSE
               DISPLAY g_hrct01 TO hrct01
               DISPLAY g_hrct11 TO hrct11
            END IF
         END IF

       AFTER FIELD hrct01
          IF cl_null(g_hrct01) THEN NEXT FIELD hrct01 END IF

       AFTER FIELD hrct11
          IF cl_null(g_hrct11) THEN NEXT FIELD hrct11 END IF
          select hrct07 into l_hrct07 from hrct_file where hrct11=g_hrct11
          select hrct08 into l_hrct08 from hrct_file where hrct11=g_hrct11
          SELECT hrct03 INTO l_hrct03 FROM hrct_file WHERE hrct11=g_hrct11
          #应计算人数
#          SELECT count(*) INTO g_num1 FROM hrat_file
#          LEFT JOIN hrbh_file on hrbh01=hratid
#           WHERE hrat03=l_hrct03
#             AND hrat25 <= (select hrct08 from hrct_file where hrct11=g_hrct11)
#             AND nvl(hrat77,to_date('20991231','yyyymmdd'))>=(select hrct07 from hrct_file where hrct11=g_hrct11)
#             AND (hrbh09 <> 'Y' OR hrbh09 IS NULL)
         SELECT count(*) INTO g_num1  FROM hrat_file
         LEFT JOIN hrdo_file ON hrdo02=hratid
         LEFT JOIN hrct_file a ON a.hrct11=hrdo04
         LEFT JOIN hrct_file b ON b.hrct11=hrdo05
         WHERE HRATCONF='Y' AND hrat03=l_hrct03
         AND hrat25 <= l_hrct08
         AND nvl(hrat77,to_date('20991231','yyyymmdd'))>=l_hrct07
         AND ((a.hrct07 > l_hrct07 OR b.hrct07<l_hrct07) OR hrdo02 is null);

          IF cl_null(g_num1) THEN LET g_num1=0 END IF
          DISPLAY g_num1 TO num1
          #已计算人数
          SELECT count(*) INTO g_num2 FROM hrdx_file,hrdxa_file
           WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hrdx01=g_hrct11
             AND hrdx14 IN ('003','004')
          IF cl_null(g_num2) THEN LET g_num2=0 END IF
          DISPLAY g_num2 TO num2
          #多计算人数
         SELECT count(*) INTO g_num3 FROM hrdx_file,hrdxa_file
           WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hrdx01=g_hrct11
             AND hrdx14 IN ('003','004') and not exists(
                  SELECT 1  FROM hrat_file
                  LEFT JOIN hrdo_file ON hrdo02=hratid
                  LEFT JOIN hrct_file a ON a.hrct11=hrdo04
                  LEFT JOIN hrct_file b ON b.hrct11=hrdo05
                  WHERE HRATCONF='Y' AND hrat03=l_hrct03
                  AND hrat25 <= l_hrct08
                  AND nvl(hrat77,to_date('20991231','yyyymmdd'))>=l_hrct07
                  AND ((a.hrct07 > l_hrct07 OR b.hrct07<l_hrct07) OR hrdo02 is null)
                  and hratid=hrdxa02);
          #SELECT count(*) INTO g_num3 from hrbh_file
          #LEFT JOIN hrat_file on hrbh01=hratid
          #where hrat03=l_hrct03 AND hrbh09 <> 'Y'
          IF cl_null(g_num3) THEN LET g_num3=0 END IF
          DISPLAY g_num3 TO num3
          #未处理人数
         SELECT count(*) INTO g_num4  FROM hrat_file t
         LEFT JOIN hrdo_file ON hrdo02=t.hratid
         LEFT JOIN hrct_file a ON a.hrct11=hrdo04
         LEFT JOIN hrct_file b ON b.hrct11=hrdo05
         WHERE t.HRATCONF='Y' AND t.hrat03=l_hrct03
         AND t.hrat25 <= l_hrct08
         AND nvl(t.hrat77,to_date('20991231','yyyymmdd'))>=l_hrct07
         AND ((a.hrct07 > l_hrct07 OR b.hrct07<l_hrct07) OR hrdo02 is null)
         and not exists(
         SELECT 1 FROM hrdx_file,hrdxa_file WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hrdx01=g_hrct11 AND hrdx14 IN ('003','004') and hrdxa02=t.hratid);
         
         IF cl_null(g_num4) THEN LET g_num4=0 END IF
          #LET g_num4=g_num1-g_num2
         DISPLAY g_num4 TO num4
         IF g_num1 <> (g_num2-g_num3+g_num4) THEN 
            CALL cl_err('相关取数不正确，不能解析原因，请联系供应商','!',1)
            NEXT FIELD hrct03
         END IF

       ON ACTION controlp
          CASE
            WHEN INFIELD(hrct03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              CALL cl_create_qry() RETURNING g_hrct03
              DISPLAY g_hrct03 TO hrct03
              NEXT FIELD hrct03

            WHEN INFIELD(hrct01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrac01"
              CALL cl_create_qry() RETURNING g_hrct01
              DISPLAY g_hrct01 TO hrct01
              NEXT FIELD hrct01

            WHEN INFIELD(hrct11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.where = " hrct01='",g_hrct01,"' AND hrct06<>'Y'"
              CALL cl_create_qry() RETURNING g_hrct11
              DISPLAY g_hrct11 TO hrct11
              NEXT FIELD hrct11
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()
    END INPUT
END FUNCTION

FUNCTION i097_q()

    CLEAR FORM
    LET g_hrct01=''
    LET g_hrct11=''
    CALL g_hrdxa.clear()
    CALL g_hrdxb.clear()
    CALL g_hrdxc.clear()

    CALL i097_cs()

    IF INT_FLAG THEN
       CLEAR FORM
       LET g_hrct01=''
       LET g_hrct11=''
       LET INT_FLAG = 0
       RETURN
    END IF

    LET g_flag_1='Y'
    LET g_flag_2='Y'
    LET g_flag_3='Y'

    CALL i097_b_fill1()
    CALL i097_b_fill2()
    CALL i097_b_fill3()
END FUNCTION

FUNCTION i097_menu()

   WHILE TRUE
      CASE g_flag_b
         WHEN '2'
           CALL i097_bp2()
         WHEN '3'
           CALL i097_bp3()
         OTHERWISE
           CALL i097_bp1()
      END CASE
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i097_q()
            END IF
         WHEN "guanzhang"
            IF cl_chk_act_auth() THEN
               CALL i097_guanzhang()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i097_bp1()

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdxa TO s_hrdxa.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting(1,1)
         IF g_flag_1='N' THEN
            CALL cl_err( '', 9035, 0 )
         END IF

      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION page2
         LET g_flag_b='2'
         EXIT DISPLAY

      ON ACTION page3
         LET g_flag_b='3'
         EXIT DISPLAY

      ON ACTION guanzhang
         LET g_action_choice="guanzhang"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i097_bp2()

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdxb TO s_hrdxb.* ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting(1,1)

      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_flag_2='N' THEN
            CALL cl_err( '', 9035, 0 )
         END IF

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION page1
         LET g_flag_b='1'
         EXIT DISPLAY

      ON ACTION page3
         LET g_flag_b='3'
         EXIT DISPLAY

      ON ACTION guanzhang
         LET g_action_choice="guanzhang"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i097_bp3()

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdxc TO s_hrdxc.* ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting(1,1)
         IF g_flag_3='N' THEN
            CALL cl_err( '', 9035, 0 )
         END IF

      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION page1
         LET g_flag_b='1'
         EXIT DISPLAY

      ON ACTION page2
         LET g_flag_b='2'
         EXIT DISPLAY

      ON ACTION guanzhang
         LET g_action_choice="guanzhang"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i097_b_fill1()
   LET g_sql = "SELECT hrdx04,hrct07,hrct08,'',hrdx14",
               "  FROM hrdx_file,hrct_file",
               " WHERE hrdx01='",g_hrct11,"'",
               "   AND hrct11='",g_hrct11,"'",
               "   AND hrdx14 IN('003','004')"
   PREPARE i097_pb1 FROM g_sql
   DECLARE i097_hrdxa CURSOR FOR i097_pb1
   CALL g_hrdxa.clear()
   LET g_cnt = 1

   FOREACH i097_hrdxa INTO g_hrdxa[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT count(*) INTO g_hrdxa[g_cnt].suma FROM hrdxa_file
        WHERE hrdxa22=g_hrdxa[g_cnt].hrdx04
          AND hrdxa01=g_hrct11

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          LET g_flag_1='N'
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b1=g_cnt-1
END FUNCTION

FUNCTION i097_b_fill2()
DEFINE l_hrdm03  LIKE hrdm_file.hrdm03
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrct03  LIKE hrct_file.hrct03
DEFINE l_hrct07  LIKE hrct_file.hrct07
DEFINE l_hrct08  LIKE hrct_file.hrct08

   SELECT hrct03,hrct07,hrct08 INTO l_hrct03,l_hrct07,l_hrct08 FROM hrct_file WHERE hrct11=g_hrct11
#   LET g_sql = "SELECT hratid,hrat01,hrat02,hrat04,hrat05,hrat25",
#               "  FROM hrat_file",
#               " WHERE hrat19 NOT IN (SELECT hrad02 FROM hrad_file WHERE hrad01='003')",
#               "   AND hrat03 = '",l_hrct03,"'",
#               "   AND hrat25 <= (select hrct08 from hrct_file where hrct11=''",g_hrct11,"')",
#               "   AND hratid NOT IN (SELECT hrdxa02 FROM hrdxa_file,hrdx_file",
#               " WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hrdx01='",g_hrct11,"'",
#               "   AND hrdx14 IN ('003','004'))"
#    LET g_sql = " SELECT hratid,hrat01,hrat02,hrat04,hrat05,hrat25  FROM hrat_file",
#"  LEFT JOIN hrbh_file ON hrbh01=hratid",
#"  LEFT JOIN hrdo_file ON hrdo02=hratid",
#"  LEFT JOIN hrct_file a ON a.hrct11=hrdo04",
#"  LEFT JOIN hrct_file b ON b.hrct11=hrdo05",
#"  WHERE HRATCONF='Y' AND hrat03='",l_hrct03,"'",
#"  AND hrat25 <= '",l_hrct08,"'",
#"  AND nvl(hrat77,to_date('20991231','yyyymmdd'))>='",l_hrct07,"'",
#"  AND (hrbh09 <> 'Y' OR hrbh09 IS NULL)",
#"  AND (a.hrct07 >= '",l_hrct07,"' OR b.hrct07<=to_date('",l_hrct07,"','yyyymmdd') OR hrdo02 is null)",
#"  AND not exists(SELECT 1 FROM hrdx_file,hrdxa_file ",
#"                 WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hrdx01='",g_hrct11,"' AND hratid = hrdxa02",
#"                       AND hrdx14 IN ('003','004'))"

      LET g_sql = "
         SELECT hratid,hrat01,hrat02,hrat04,hrat05,hrat25  FROM hrat_file t
         LEFT JOIN hrdo_file ON hrdo02=t.hratid
         LEFT JOIN hrct_file a ON a.hrct11=hrdo04
         LEFT JOIN hrct_file b ON b.hrct11=hrdo05
         WHERE t.HRATCONF='Y' AND t.hrat03='",l_hrct03,"'
         AND t.hrat25 <= '",l_hrct08,"'
         AND nvl(t.hrat77,to_date('20991231','yyyymmdd'))>='",l_hrct07,"'
         AND ((a.hrct07 > '",l_hrct07,"' OR b.hrct07<'",l_hrct07,"') OR hrdo02 is null)
         and not exists(
         SELECT 1 FROM hrdx_file,hrdxa_file WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hrdx01='",g_hrct11,"' AND hrdx14 IN ('003','004') and hrdxa02=t.hratid)"
         
         
   PREPARE i097_pb2 FROM g_sql
   DECLARE i097_hrdxb CURSOR FOR i097_pb2
   CALL g_hrdxb.clear()
   LET g_cnt = 1

   FOREACH i097_hrdxb INTO l_hratid,g_hrdxb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT hrdm03 INTO l_hrdm03 FROM hrdm_file WHERE hrdm02=l_hratid
       SELECT hrdl02 INTO g_hrdxb[g_cnt].hrdl02a FROM hrdl_file WHERE hrdl01=l_hrdm03

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          LET g_flag_2='N'
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b2=g_cnt-1
END FUNCTION

FUNCTION i097_b_fill3()
DEFINE l_hrdm03  LIKE hrdm_file.hrdm03
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrct03  LIKE hrct_file.hrct03
DEFINE l_hrct07  LIKE hrct_file.hrct07
DEFINE l_hrct08  LIKE hrct_file.hrct08

   SELECT hrct03,hrct07,hrct08 INTO l_hrct03,l_hrct07,l_hrct08 FROM hrct_file WHERE hrct11=g_hrct11
#   LET g_sql = "SELECT hratid,hrat01,hrat02,hrat04,hrat05,hrbh04",
#               "  FROM hrat_file LEFT OUTER JOIn hrbh_file ON hratid=hrbh01",
#               " WHERE hrat03 = '",l_hrct03,"'",
#               "   AND AND hrbh09 <> 'Y'"
    LET g_sql = " SELECT hratid,hrat01,hrat02,hrat04,hrat05,hrbh04 from hrbh_file",
        "  LEFT JOIN hrat_file on hrbh01=hratid",
        "  where hrat03='",l_hrct03,"'",
        "  AND hrbh09 <> 'Y'"
      LET g_sql = "
         SELECT hratid,hrat01,hrat02,hrat04,hrat05,hrat25,hrat77 FROM hrdx_file,hrdxa_file,hrat_file
           WHERE hrdxa01=hrdx01 AND hrdx04=hrdxa22 AND hratid=hrdxa02 AND hrdx01='",g_hrct11,"'
             AND hrdx14 IN ('003','004') and not exists(
                  SELECT 1  FROM hrat_file t
                  LEFT JOIN hrdo_file ON hrdo02=t.hratid
                  LEFT JOIN hrct_file a ON a.hrct11=hrdo04
                  LEFT JOIN hrct_file b ON b.hrct11=hrdo05
                  WHERE t.HRATCONF='Y' AND t.hrat03='",l_hrct03,"'
                  AND t.hrat25 <= '",l_hrct08,"'
                  AND nvl(t.hrat77,to_date('20991231','yyyymmdd'))>='",l_hrct07,"'
                  AND ((a.hrct07 > '",l_hrct07,"' OR b.hrct07<'",l_hrct07,"') OR hrdo02 is null)
                  and t.hratid=hrdxa02)"
        
        
        
   PREPARE i097_pb3 FROM g_sql
   DECLARE i097_hrdxc CURSOR FOR i097_pb3
   CALL g_hrdxc.clear()
   LET g_cnt = 1

   FOREACH i097_hrdxc INTO l_hratid,g_hrdxc[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT hrdm03 INTO l_hrdm03 FROM hrdm_file WHERE hrdm02=l_hratid
       SELECT hrdl02 INTO g_hrdxc[g_cnt].hrdl02b FROM hrdl_file WHERE hrdl01=l_hrdm03

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          LET g_flag_3='N'
          EXIT FOREACH
       END IF
   END FOREACH
   LET g_rec_b3=g_cnt-1
END FUNCTION

FUNCTION i097_guanzhang()
DEFINE l_hrct01  LIKE type_file.num5
DEFINE l_hrct02  LIKE type_file.num5
DEFINE l_hrct03  LIKE hrct_file.hrct03
DEFINE l_hrct06  LIKE hrct_file.hrct06
DEFINE l_hran03  LIKE type_file.num5
DEFINE l_hran04  LIKE type_file.num5
DEFINE l_a       LIKE type_file.num5
DEFINE l_flag    LIKE type_file.chr1
#add by zhuzw 20150430 start
DEFINE l_sql  STRING
DEFINE l_hrct07,l_hrct08 LIKE hrct_file.hrct08
DEFINE l_hraz03  LIKE hraz_file.hraz03
DEFINE l_hraz12  LIKE hraz_file.hraz12
#add by zhuzw 20150430 end 
    LET l_flag='Y'

    IF cl_null(g_hrct11) THEN
       CALL i097_cs()
       IF INT_FLAG THEN
          LET g_hrct01=''
          LET g_hrct11=''
          CLEAR FORM
          LET INT_FLAG=0
          RETURN
       END IF
       LET l_flag='N'
    END IF

    #判断之前是否存在未关帐
    SELECT to_number(hrct01),to_number(hrct02),hrct03,hrct06
      INTO l_hrct01,l_hrct02,l_hrct03,l_hrct06
      FROM hrct_file
     WHERE hrct11=g_hrct11

    IF l_hrct06='Y' THEN
       IF l_flag='N' THEN
          LET g_hrct01=''
          LET g_hrct11=''
          CLEAR FORM
       END IF
       CALL cl_err('','ghr-161',1)
       RETURN
    END IF

    SELECT to_number(hran03),to_number(hran04)
      INTO l_hran03,l_hran04
      FROM hran_file
     WHERE hran01=l_hrct03

    SELECT count(*) INTO l_a FROM hrct_file
     WHERE to_number(hrct01)*12 + to_number(hrct02)<l_hrct01*12+l_hrct02
       AND to_number(hrct01)*12 + to_number(hrct02)>=l_hran03*12+l_hran04
       AND hrct03=l_hrct03
       AND hrct06<>'Y'
    IF l_a>0 THEN
       IF l_flag='N' THEN
          LET g_hrct01=''
          LET g_hrct11=''
          CLEAR FORM
       END IF
       CALL cl_err('','ghr-157',1)
       RETURN
    END IF
    #存在未处理人员
    IF g_num4+g_num3<>0 THEN
       IF l_flag='N' THEN
          LET g_hrct01=''
          LET g_hrct11=''
          CLEAR FORM
       END IF
       CALL cl_err('','ghr-158',1)
       RETURN
    END IF
    #关帐
    BEGIN WORK
    UPDATE hrct_file SET hrct06='Y' WHERE hrct11=g_hrct11

    IF sqlca.sqlcode THEN
       ROLLBACK WORK
       IF l_flag='N' THEN
          LET g_hrct01=''
          LET g_hrct11=''
          CLEAR FORM
       END IF
       CALL cl_err('','ghr-159',1)
    ELSE
       COMMIT WORK
       IF l_flag='N' THEN
          LET g_hrct01=''
          LET g_hrct11=''
          CLEAR FORM
       END IF
       CALL cl_err('','ghr-160',1)
       #add by zhuzw 20150430 start
       SELECT hrct07,hrct08 INTO l_hrct07,l_hrct08 FROM hrct_file 
        WHERE hrct11= g_hrct11
       LET l_sql = " select hraz03,hraz12 from hraz_file where hraz05 bewteen '",l_hrct07,"' and '",l_hrct08,"' " 
       PREPARE i097_q1 FROM l_sql
       DECLARE i097_s1 CURSOR FOR i097_q1
       FOREACH i097_s1 INTO l_hraz03,l_hraz12
          UPDATE hrat_file 
             SET hrat42 = l_hraz12
           WHERE hratid = l_hraz03 
       END FOREACH 
       #add by zhuzw 20150430 end 
    END IF
END FUNCTION
