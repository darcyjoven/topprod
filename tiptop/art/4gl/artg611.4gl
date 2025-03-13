# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: artg611.4gl
# Descriptions...: 收款单查询报表
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
       luiplant LIKE lui_file.luiplant,
       rtz13    LIKE rtz_file.rtz13,
       lui05    LIKE lui_file.lui05,
       occ02    LIKE occ_file.occ02,
       lui06    LIKE lui_file.lui06,
       lmf13    LIKE lmf_file.lmf13,
       lui07    LIKE lui_file.lui07,
       lui04    LIKE lui_file.lui04,
       lui01    LIKE lui_file.lui01,
       luj02    LIKE luj_file.luj02,
       luj05    LIKE luj_file.luj05,
       oaj02    LIKE oaj_file.oaj02,
       lui03    LIKE lui_file.lui03,
       luj06    LIKE luj_file.luj06,
       lui13    LIKE lui_file.lui13
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
      CALL cl_wcchp(g_wc1,'luiplant,lmf03,lmf04,lie04,lui05,lui07,lmf13,luj05,lua34,lui12,lui11,lui03') RETURNING g_wc
      IF g_wc.getLength() > 500 THEN
         LET g_wc = g_wc.subString(1,500)
         CALL cl_wcchp(g_wc1,'luiplant,lmf03,lmf04,lie04,lui05,lui07,lmf13,luj05,lua34,lui12,lui11,lui03') RETURNING g_wc
         LET g_wc = g_wc,"..."
      END IF
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL artg611_grdata()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artg611_grdata()
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
    LET g_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file,lui_file ",
                "  WHERE azw01 = rtz01 AND rtz01 IN ",g_auth,
                "    AND luiplant = azw01",
                "    AND ", g_chk_auth,
                "    AND azwacti = 'Y'",
                "  ORDER BY azw01 "
   #LET g_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file ",
   #             " WHERE azw01 = rtz01 AND azw01 IN ",g_chk_auth
   #LET g_sql = g_sql," ORDER BY azw01 "
#   WHILE TRUE      #FUN-C60062 MARK           
         CALL cl_gre_init_pageheader()   
         LET handler = cl_gre_outnam("artg611")
         IF handler IS NOT NULL THEN
            START REPORT artg611_rep TO XML HANDLER handler
            PREPARE q611_pb_3 FROM g_sql
            DECLARE q611_bc3 CURSOR FOR q611_pb_3
            FOREACH q611_bc3 INTO g_azw01
               IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH
               END IF
               LET l_sql = "SELECT DISTINCT luiplant,'',lui05,'',lui06,'',lui07,",
                   "       lui04,lui01,luj02,luj05,'',lui03,luj06,lui13 "
               LET l_table = "  FROM ",cl_get_target_table(g_azw01,'lui_file'),",",
                                       cl_get_target_table(g_azw01,'luj_file')
               LET l_where = " WHERE luj01 = lui01 AND luiconf = 'Y' AND luiplant = '",g_azw01,"'"
               IF g_wc1.getIndexOf("lmf",1) THEN
                  LET l_table = l_table,",",cl_get_target_table(g_azw01,'lmf_file')
                  LET l_where = l_where," AND lui06 = lmf01 "
               END IF 
               IF g_wc1.getIndexOf("lie",1) THEN
                  LET l_table = l_table,",",cl_get_target_table(g_azw01,'lie_file')
                  LET l_where = l_where," AND lie01 = lui06 "
               END IF 
               IF g_wc1.getIndexOf("lua",1) THEN
                  LET l_table = l_table,",",cl_get_target_table(g_azw01,'lua_file')
                  LET l_where = l_where," AND lua01 = lui04 "
               END IF
               LET l_sql = l_sql,l_table,l_where," AND ",g_wc1 CLIPPED
               PREPARE q611_pb1 FROM l_sql
               DECLARE lui_cs1 CURSOR FOR q611_pb1
               FOREACH lui_cs1 INTO sr1.*
                   IF STATUS THEN
                      CALL cl_err('foreach:',STATUS,1)
                      EXIT FOREACH
                   END IF
                   LET l_sql = " SELECT rtz13 ",
                               "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),
                               "  WHERE rtz01 = '",sr1.luiplant,"'"
                   PREPARE azp_cs FROM l_sql
                   EXECUTE azp_cs INTO l_rtz13
                   LET l_sql = " SELECT occ02 ",
                               "   FROM ",cl_get_target_table(g_azw01,'occ_file'),
                               "  WHERE occ01 = '",sr1.lui05,"'"
                   PREPARE occ_cs FROM l_sql
                   EXECUTE occ_cs INTO l_occ02
                   LET l_sql = " SELECT lmf13 ",
                               "   FROM ",cl_get_target_table(g_azw01,'lmf_file'),
                               "  WHERE lmf01 = '",sr1.lui06,"'"
                   PREPARE lmf_cs FROM l_sql
                   EXECUTE lmf_cs INTO l_lmf13
                   LET l_sql = " SELECT oaj02 ",
                               "   FROM ",cl_get_target_table(g_azw01,'oaj_file'),
                               "  WHERE oaj01 = '",sr1.luj05,"'"
                   PREPARE oaj_cs FROM l_sql
                   EXECUTE oaj_cs INTO l_oaj02
                   LET sr1.occ02 = l_occ02
                   LET sr1.rtz13 = l_rtz13
                   LET sr1.lmf13 = l_lmf13
                   LET sr1.oaj02 = l_oaj02
                   OUTPUT TO REPORT artg611_rep(sr1.*)
               END FOREACH
            END FOREACH
            FINISH REPORT artg611_rep
        END IF
#FUN-C60062 MARK BEGIN---
#        IF INT_FLAG = TRUE THEN
#            LET INT_FLAG = FALSE
#            EXIT WHILE
#        END IF
#    END WHILE
#FUN-C60062 MARK END ---
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg611_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_luj06_fmt STRING
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime
            PRINTX g_wc

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_luj06_fmt = cl_gr_numfmt('luj_file','luj06',g_azi04)
            PRINTX l_luj06_fmt
            PRINTX sr1.*

        ON LAST ROW
END REPORT
###GENGRE###END
#FUN-C60062 
