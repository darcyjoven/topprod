# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: artg615.4gl
# Descriptions...: 退款单查询报表
# Date & Author..: No:FUN-C60062 12/06/25 By yangxf

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_sql      STRING
DEFINE g_table    STRING
DEFINE g_azw01    LIKE azw_file.azw01
DEFINE g_wc       STRING
DEFINE g_wc1      STRING
DEFINE g_chk_auth STRING
DEFINE g_zz05     LIKE zz_file.zz05
DEFINE g_prog1    LIKE zz_file.zz01

###GENGRE###START
TYPE sr1_t RECORD
        lucplant LIKE luc_file.lucplant,
        rtz13    LIKE rtz_file.rtz13,
        luc03    LIKE luc_file.luc03,
        occ02    LIKE occ_file.occ02,
        luc05    LIKE luc_file.luc05,
        lmf13    LIKE lmf_file.lmf13,
        luc04    LIKE luc_file.luc04,
        luc10    LIKE luc_file.luc10,
        luc11    LIKE luc_file.luc11,
        luc01    LIKE luc_file.luc01,
        lud02    LIKE lud_file.lud02,
        lud05    LIKE lud_file.lud05,
        oaj02    LIKE oaj_file.oaj02,
        luc21    LIKE luc_file.luc21,
        luc25    LIKE luc_file.luc25,
        lud07t   LIKE lud_file.lud07t,
        luc08    LIKE luc_file.luc08
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_chk_auth = ARG_VAL(1)
   LET g_wc1 = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_pdate = ARG_VAL(4)
   LET g_prog1 = ARG_VAL(5)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   IF cl_null(g_chk_auth) OR cl_null(g_wc1) OR cl_null(g_rlang) OR cl_null(g_pdate) THEN
      EXIT PROGRAM
   END IF
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog1
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc1,'lucplant,lmf03,lmf04,lie04,luc03,luc05,lmf13,lud05,lua34,luc27,luc26,luc21') RETURNING g_wc
      IF g_wc.getLength() > 500 THEN
         LET g_wc = g_wc.subString(1,500)
         CALL cl_wcchp(g_wc1,'lucplant,lmf03,lmf04,lie04,luc03,luc05,lmf13,lud05,lua34,luc27,luc26,luc21') RETURNING g_wc
         LET g_wc = g_wc,"..."
      END IF
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL artg615_grdata()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artg615_grdata()
   DEFINE p_chk_auth STRING
   DEFINE handler    om.SaxDocumentHandler
   DEFINE sr1        sr1_t
   DEFINE l_cnt      LIKE type_file.num10
   DEFINE l_msg      STRING
   DEFINE l_sql      STRING
   DEFINE l_table    STRING   
   DEFINE l_where    STRING   
   DEFINE l_lmf13    LIKE lmf_file.lmf13
   DEFINE l_oaj02    LIKE oaj_file.oaj02
   DEFINE l_rtz13    LIKE rtz_file.rtz13
   DEFINE l_occ02    LIKE occ_file.occ02
                              
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET g_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file,luc_file ",
                "  WHERE azw01 = rtz01 AND rtz01 IN ",g_auth,
                "    AND lucplant = azw01",
                "    AND ", g_chk_auth,
                "    AND azwacti = 'Y'",
                "  ORDER BY azw01 "
#  WHILE TRUE       #FUN-C60062 MARK             
        CALL cl_gre_init_pageheader()   
        LET handler = cl_gre_outnam("artg615")
        IF handler IS NOT NULL THEN
           START REPORT artg615_rep TO XML HANDLER handler
           PREPARE q615_pb_3 FROM g_sql
           DECLARE q615_bc3 CURSOR FOR q615_pb_3
           FOREACH q615_bc3 INTO g_azw01
              IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
              END IF
              LET l_sql = "SELECT DISTINCT lucplant,'',luc03,'',luc05,'',luc04,",
                          "       luc10,luc11,luc01,lud02,lud05,'',luc21,luc25,lud07t,luc08 "
              LET l_table = "  FROM ",cl_get_target_table(g_azw01,'luc_file'),",",
                                      cl_get_target_table(g_azw01,'lud_file')
              LET l_where = " WHERE lud01 = luc01 AND luc14 = 'Y' AND lucplant = '",g_azw01,"'"
              IF g_wc1.getIndexOf("lmf",1) THEN
                 LET l_table = l_table,",",cl_get_target_table(g_azw01,'lmf_file')
                 LET l_where = l_where," AND luc05 = lmf01 "
              END IF
              IF g_wc1.getIndexOf("lie",1) THEN
                 LET l_table = l_table,",",cl_get_target_table(g_azw01,'lie_file')
                 LET l_where = l_where," AND lie01 = luc05 "
              END IF
              LET l_sql = l_sql,l_table,l_where," AND ",g_wc1 CLIPPED
              PREPARE q615_pb1 FROM l_sql
              DECLARE lua_cs1 CURSOR FOR q615_pb1
              FOREACH lua_cs1 INTO sr1.*
                  IF STATUS THEN
                     CALL cl_err('foreach:',STATUS,1)
                     EXIT FOREACH
                  END IF
              LET l_sql = " SELECT rtz13 ",
                          "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),
                          "  WHERE rtz01 = '",sr1.lucplant,"'"
              PREPARE rtz_cs FROM l_sql
              EXECUTE rtz_cs INTO l_rtz13
              LET l_sql = " SELECT occ02 ",
                          "   FROM ",cl_get_target_table(g_azw01,'occ_file'),
                          "  WHERE occ01 = '",sr1.luc03,"'"
              PREPARE occ_cs FROM l_sql
              EXECUTE occ_cs INTO l_occ02
              LET l_sql = " SELECT lmf13 ",
                          "   FROM ",cl_get_target_table(g_azw01,'lmf_file'),
                          "  WHERE lmf01 = '",sr1.luc05,"'"
              PREPARE lmf_cs FROM l_sql
              EXECUTE lmf_cs INTO l_lmf13
              LET l_sql = " SELECT oaj02 ",
                          "   FROM ",cl_get_target_table(g_azw01,'oaj_file'),
                          "  WHERE oaj01 = '",sr1.lud05,"'"
              PREPARE oaj_cs FROM l_sql
              EXECUTE oaj_cs INTO l_oaj02
              LET sr1.rtz13 = l_rtz13
              LET sr1.occ02 = l_occ02
              LET sr1.lmf13 = l_lmf13
              LET sr1.oaj02 = l_oaj02
                  OUTPUT TO REPORT artg615_rep(sr1.*)
              END FOREACH
           END FOREACH
           FINISH REPORT artg615_rep
       END IF
#FUN-C60062 MARK BEGIN----
#       IF INT_FLAG = TRUE THEN
#           LET INT_FLAG = FALSE
#           EXIT WHILE
#       END IF
#   END WHILE
#FUN-C60062 MARK END ----
   CALL cl_gre_close_report()
END FUNCTION

REPORT artg615_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lud07t_fmt  STRING
    DEFINE l_luc10       STRING
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime
            SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog1
            PRINTX g_wc

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lud07t_fmt = cl_gr_numfmt('lud_file','lud07t',g_azi04)
            PRINTX l_lud07t_fmt
            LET l_luc10 = cl_gr_getmsg('gre-291',g_lang,sr1.luc10)
            PRINTX l_luc10
            PRINTX sr1.*

        ON LAST ROW
END REPORT
###GENGRE###END
#FUN-C60062 
