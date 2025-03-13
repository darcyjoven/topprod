# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Pattern name...: almg301.4gl
# Descriptions...: 簽約商戶查詢
# Date & Author..: No:FUN-C60062 12/06/25 By fanbj
# Modify.........: No.FUN-C60062 12/07/12 By yangxf

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_sql      STRING
DEFINE g_table    STRING
DEFINE g_azp01    LIKE azw_file.azw01
DEFINE g_lnt17    LIKE lnt_file.lnt17
DEFINE g_lnt18    LIKE lnt_file.lnt18
DEFINE g_wc       STRING
DEFINE g_wc2      STRING
DEFINE g_chk_auth STRING

###GENGRE###START
TYPE sr1_t        RECORD
        lnt04        LIKE lnt_file.lnt04,
        lne05        LIKE lne_file.lne05,
        lne07        LIKE lne_file.lne07,
        lne62        LIKE lne_file.lne62,
        oca02        LIKE oca_file.oca02,
        lne14        LIKE lne_file.lne14,
        lne15        LIKE lne_file.lne15,
        lne28        LIKE lne_file.lne28,
        lntplant     LIKE lnt_file.lntplant,
        lnt01        LIKE lnt_file.lnt01
                  END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   LET g_chk_auth = ARG_VAL(1)
   LET g_wc = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_pdate = ARG_VAL(4)
   LET g_lnt17 = ARG_VAL(5)
   LET g_lnt18 = ARG_VAL(6)
   LET g_wc2 = g_wc
   
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL almg301_grdata()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION almg301_grdata()
   DEFINE p_chk_auth STRING
   DEFINE handler    om.SaxDocumentHandler
   DEFINE sr1        sr1_t
   DEFINE l_table    STRING   
   DEFINE l_where    STRING   

   SELECT zo02 INTO g_company
     FROM zo_file
    WHERE zo01 = g_rlang

   LET g_sql = " SELECT DISTINCT azp01 FROM azp_file,azw_file ",
               "  WHERE azw01 = azp01 ",
               "    AND azp01 IN ",g_chk_auth,
               "  ORDER BY azp01"
   WHILE TRUE                 
      CALL cl_gre_init_pageheader()   
      LET handler = cl_gre_outnam("almg301")
      IF handler IS NOT NULL THEN
         START REPORT almg301_rep TO XML HANDLER handler
         PREPARE g301_pb FROM g_sql
         DECLARE g301_bc CURSOR FOR g301_pb
         FOREACH g301_bc INTO g_azp01
            IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            
            LET g_sql = "SELECT DISTINCT lnt04,lne05,lne07,lne62,'',lne14,",
                        "       lne15,lne28,lntplant,lnt01 "
            LET l_table = "  FROM ",cl_get_target_table(g_azp01,'lnt_file'),",",
                                    cl_get_target_table(g_azp01,'lne_file')
            LET l_where = " WHERE lnt04 = lne01 ",
                          "   AND lnt26 = 'Y' ",
                          "   AND lne36 = 'Y' ", 
                          "   AND lntplant = '",g_azp01,"'"
            
            LET g_sql = g_sql,l_table,l_where," AND ",g_wc CLIPPED
         
            SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
            IF g_zz05 = 'Y' THEN
#              CALL cl_wcchp(g_wc,'lntplant,lnt08,lnt09,lnt60,lnt04,lne62,lne67,lne08,lnt17,lnt18')       #FUN-C60062 mark
               CALL cl_wcchp(g_wc2,'lntplant,lnt08,lnt09,lnt60,lnt04,lne62,lne67,lne08,lnt17,lnt18')      #FUN-C60062 add
                             RETURNING g_wc2
               IF g_wc2.getLength() > 1000 THEN
#                  LET g_wc2 = g_wc.subString(1,600)   #FUN-C60062 mark
#                  LET g_wc2 = g_wc,"..."              #FUN-C60062 mark
                   LET g_wc2 = g_wc2.subString(1,600)  #FUN-C60062 add
                   LET g_wc2 = g_wc2,"..."             #FUN-C60062 add 
               END IF
            END IF

            IF NOT cl_null(g_lnt17) THEN
               LET g_sql = g_sql ," AND lnt17 >= '",g_lnt17,"' "
#              LET g_wc2 = g_wc2,";lnt17>= ",g_lnt17       #FUN-C60062 mark
               LET g_wc = g_wc,";lnt17>= ",g_lnt17         #FUN-C60062 add
            END IF 

            IF NOT cl_null(g_lnt18) THEN
               LET g_sql = g_sql ," AND lnt18 <= '",g_lnt18,"' "
#              LET g_wc2 = g_wc2,";lnt18 <= ",g_lnt18      #FUN-C60062 mark
               LET g_wc = g_wc,";lnt18 <= ",g_lnt18      #FUN-C60062 add
            END IF 
            LET g_template = 'almg301'
            
            PREPARE g301_pb1 FROM g_sql
            DECLARE g301_cs1 CURSOR FOR g301_pb1
            FOREACH g301_cs1 INTO sr1.*
               IF STATUS THEN
                  CALL cl_err('foreach:',STATUS,1)
                  EXIT FOREACH
               END IF

               LET g_sql = " SELECT oca02 ",
                           "   FROM ",cl_get_target_table(g_azp01,'oca_file'),
                           "  WHERE oca01 = '",sr1.lne62,"'"
               PREPARE oca_cs FROM g_sql
               EXECUTE oca_cs INTO sr1.oca02
                
               OUTPUT TO REPORT almg301_rep(sr1.*)
            END FOREACH
         END FOREACH
         FINISH REPORT almg301_rep
      END IF
      IF INT_FLAG = TRUE THEN
          LET INT_FLAG = FALSE
          EXIT WHILE
      END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT almg301_rep(sr1)
   DEFINE sr1 sr1_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_lne07  STRING
   DEFINE l_lne28  STRING

   FORMAT
      FIRST PAGE HEADER
          PRINTX g_grPageHeader.*
          PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime
          PRINTX g_wc
          PRINTX g_wc2

      ON EVERY ROW
          LET l_lineno = l_lineno + 1
          PRINTX l_lineno
          LET l_lne07 = cl_gr_getmsg('gre-289',g_lang,sr1.lne07)
          LET l_lne07 = sr1.lne07,":",l_lne07
          PRINTX l_lne07
          LET l_lne28 = cl_gr_getmsg('gre-290',g_lang,sr1.lne28)
          LET l_lne28 = sr1.lne28,":",l_lne28
          PRINTX l_lne28
          PRINTX sr1.*

      ON LAST ROW
END REPORT
###GENGRE###END
#FUN-C60062---------------------- 
