# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almp102.4gl
# Descriptions...: 招商費用單產生作業
# Date & Author..: No.FUN-BA0118 11/11/07 By baogc

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
              wc    STRING,
              wc2   STRING,
              date  DATE,
              bgjob LIKE type_file.chr1
          END RECORD
DEFINE g_sql           STRING
DEFINE g_cnt           LIKE type_file.num5
DEFINE g_change_lang   LIKE type_file.chr1

MAIN
DEFINE l_flag LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE tm.* TO NULL
   LET tm.wc    = ARG_VAL(1)
   LET tm.wc2   = ARG_VAL(2)
   LET tm.date  = ARG_VAL(3)
   LET tm.bgjob = ARG_VAL(4)
   IF cl_null(tm.bgjob) THEN
      LET tm.bgjob = "N"
   END IF
   
   IF NOT cl_user() THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF NOT cl_setup("ALM") THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   ERROR ""
   LET g_success = 'Y'
   WHILE TRUE
      IF tm.bgjob = "N" THEN
         CALL p102_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            CALL s_showmsg_init()
            LET g_success = 'Y'
            CALL almp102()
            CALL s_showmsg()
            IF g_success = 'Y' THEN 
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF 
            IF l_flag THEN
               CONTINUE WHILE 
            ELSE
               CLOSE WINDOW p102_w
               EXIT WHILE 
            END IF 
         ELSE
            CONTINUE WHILE 
         END IF
      ELSE
         BEGIN WORK
         CALL s_showmsg_init()
         LET g_success = 'Y'
         IF cl_null(tm.date) THEN
            LET tm.date = g_today
         END IF
         CALL almp102()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK 
         ELSE
            ROLLBACK WORK 
         END IF 
         EXIT WHILE 
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p102_tm()
DEFINE lc_cmd  STRING
DEFINE l_zz08  LIKE zz_file.zz08

   IF s_shut(0) THEN RETURN END IF

   OPEN WINDOW p102_w WITH FORM "alm/42f/almp102"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_opmsg('z')

   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL
      LET tm.bgjob = 'N'
      LET tm.date  = TODAY
      DIALOG
         CONSTRUCT BY NAME tm.wc ON rtz01
            BEFORE CONSTRUCT 
               CALL cl_qbe_init()
               
            ON ACTION controlp
               CASE
                  WHEN INFIELD(rtz01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rtz1"
                     LET g_qryparam.where = " rtz28 = 'Y' AND rtz01 IN ",g_auth CLIPPED
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rtz01
                     NEXT FIELD rtz01

                  OTHERWISE 
                     EXIT CASE 
               END CASE 
         END CONSTRUCT

         CONSTRUCT BY NAME tm.wc2 ON lnt01,lmf01,lne01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION controlp
               CASE
                  WHEN INFIELD(lnt01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lnt01"
                     LET g_qryparam.where = " lnt26 = 'Y' AND lntplant IN ",g_auth CLIPPED
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lnt01
                     NEXT FIELD lnt01
                  WHEN INFIELD(lmf01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lmf01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lmf01
                     NEXT FIELD lmf01
                  WHEN INFIELD(lne01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_lne"
                     LET g_qryparam.where = " lne61 IN ",g_auth CLIPPED
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lne01
                     NEXT FIELD lne01
                  OTHERWISE
                     EXIT CASE
               END CASE
         END CONSTRUCT

         INPUT tm.date,tm.bgjob FROM date,bgjob ATTRIBUTE(WITHOUT DEFAULTS)

            AFTER FIELD bgjob
               IF tm.bgjob NOT MATCHES "[YN]" OR cl_null(tm.bgjob) THEN 
                  NEXT FIELD bgjob            
               END IF
         END INPUT 

         ON ACTION accept
            ACCEPT DIALOG

         ON ACTION cancel
            LET INT_FLAG = 1
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

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT DIALOG
      END DIALOG
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF 

      IF tm.wc = ' 1=1' AND tm.wc2 = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF

      IF tm.bgjob = "Y" THEN
         SELECT zz08 INTO l_zz08 FROM zz_file
          WHERE zz01 = "almp102"
         IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
            CALL cl_err('almp102','9031',1)
         ELSE
            LET tm.wc  = cl_replace_str(tm.wc,"'","\"")
            LET tm.wc2 = cl_replace_str(tm.wc2,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.wc CLIPPED,"' ",
                         " '",tm.wc2 CLIPPED,"' ",
                         " '",tm.date CLIPPED,"' ",
                         " '",tm.bgjob CLIPPED,"' "
            CALL cl_cmdat('almp102',g_time,lc_cmd CLIPPED)
         END IF 
         CLOSE WINDOW p102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
      EXIT WHILE 
   END WHILE 
END FUNCTION 

FUNCTION almp102()
DEFINE l_sql   STRING
DEFINE l_rtz01 LIKE rtz_file.rtz01
DEFINE l_liw01 LIKE liw_file.liw01
DEFINE l_liw03 LIKE liw_file.liw03
DEFINE l_liw05 LIKE liw_file.liw05
DEFINE l_liw06 LIKE liw_file.liw06
DEFINE l_lua01 LIKE lua_file.lua01

   LET g_cnt = 0
   LET l_sql = "SELECT rtz01 FROM rtz_file WHERE ",tm.wc CLIPPED
   PREPARE sel_rtz_pre FROM l_sql
   DECLARE sel_rtz_cs CURSOR FOR sel_rtz_pre
   FOREACH sel_rtz_cs INTO l_rtz01
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF 
      LET l_sql = "SELECT DISTINCT liw01,liw05,liw06 ",
                  "  FROM ",cl_get_target_table(l_rtz01,'liw_file'),
                            cl_get_target_table(l_rtz01,'lnt_file'),
                  " WHERE liw01 = lnt01 ",
                  "   AND lnt01 IN (SELECT lnt01 ",
                  "                   FROM ",cl_get_target_table(l_rtz01,'lnt_file'),
                  "                  WHERE lnt26 = 'Y' AND lnt48 = '2' AND ",tm.wc2 CLIPPED,") ",
                  "   AND liw06 = '",g_today,"' "
     #20111129 By shi Begin---
      LET l_sql = "SELECT DISTINCT liw01,liw05,liw06 ",
                  "  FROM ",cl_get_target_table(l_rtz01,'liw_file'),",",
                            cl_get_target_table(l_rtz01,'lnt_file'),
                  " WHERE liw01 = lnt01 ",
                  "   AND lnt26 = 'Y'",
                  "   AND ",tm.wc2 CLIPPED,
                  "   AND liw16 IS NULL ",
                  "   AND liw17 = 'N' ",
                  "   AND liw06 = '",tm.date,"' ",
                  " ORDER BY liw01,liw05,liw06 "
      
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_rtz01) RETURNING l_sql
     #20111129 By shi End-----
      PREPARE sel_liw_pre FROM l_sql
      DECLARE sel_liw_cs CURSOR FOR sel_liw_pre
      FOREACH sel_liw_cs INTO l_liw01,l_liw05,l_liw06
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         #調用產生費用單的邏輯
        #20111129 By shi Begin---
        ##回寫費用單號至帳單上
        #LET l_sql = "UPDATE ",cl_get_target_table(l_rtz01,'liw_file'),
        #            "   SET liw16 = '",l_lua01,"' ",
        #            " WHERE liw01 = '",l_liw01,"' ",
        #            "   AND liw03 = '",l_liw03,"' "
        #PREPARE upd_liw_pre FROM l_sql
        #EXECUTE upd_liw_pre
        #IF SQLCA.sqlcode THEN
        #   CALL s_errmsg('','','upd liw',SQLCA.sqlcode,1)
        #   LET g_success = 'N'
        #END IF
         CALL i400sub_gen_expense_bill(l_liw01,l_liw05,l_liw06,l_rtz01) 
        #20111129 By shi End-----
      END FOREACH
   END FOREACH
END FUNCTION 

#FUN-BA0118
