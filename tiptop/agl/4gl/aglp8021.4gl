# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aglp8021.4gl
# Descriptions...: 
# Date & Author..: No.FUN-CB0111 12/11/23 By Belle
# Modify.........: NO.FUN-CC0071 13/01/04 by Belle 因某些客戶並無購買IFRS接軌包，aam_file不可存在 

DATABASE ds
#FUN-CB0111

GLOBALS "../../config/top.global"

DEFINE g_year     LIKE type_file.chr4
DEFINE g_book1    LIKE aah_file.aah00   #FUN-CC0071 add
DEFINE g_book2    LIKE aah_file.aah00   #FUN-CC0071 add
DEFINE g_sql      STRING
DEFINE g_errmsg   STRING
DEFINE g_cnt      LIKE type_file.num10
DEFINE l_flag     LIKE type_file.chr1
#---FUN-CC0071 mark start--
#DEFINE g_aam      RECORD LIKE aam_file.*
#DEFINE g_aam02    LIKE aam_file.aam02
#DEFINE g_aam12    LIKE aam_file.aam12
#DEFINE g_aam13    LIKE aam_file.aam13
#--FUN-CC0071 mark end----
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   WHILE TRUE
      CALL p8021_tm(0,0)
      IF cl_sure(21,21) THEN
         CALL s_showmsg_init()
         LET g_success = 'Y'
#--FUN-CC0071 mark start--
#         SELECT * INTO g_aam.* FROM aam_file WHERE aam00 = '0'
#         IF g_aam.aam01 = 'N' OR cl_null(g_aam.aam02) THEN
#            CALL cl_err('','agl1036',1)
#            LET g_success = 'N'
#         END IF
#--FUN-CC0071 mark end---
         IF g_success = 'Y' THEN
            BEGIN WORK
            CALL p8021()
         END IF
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
            CLOSE WINDOW aglp8021_w
            EXIT WHILE
         END IF
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p8021_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000
DEFINE li_chk_bookno  LIKE type_file.num5     #FUN-CC0071 add

   LET p_row = 5 
   LET p_col = 10
   OPEN WINDOW aglp8021_w AT p_row,p_col
        WITH FORM "agl/42f/aglp8021"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
#--FUN-CC0071 mark start--
#   SELECT aam02,aam12,aam13
#     INTO g_aam02,g_aam12,g_aam13
#     FROM aam_file WHERE aam00 = '0'
#--FUN-CC0071 mark end----

   #INPUT g_year                         #FUN-CC0071 mark
   # WITHOUT DEFAULTS FROM yy            #FUN-CC0071 mark 
   INPUT g_book1,g_book2,g_year          #FUN-CC0071 mod
    WITHOUT DEFAULTS FROM book1,book2,yy #FUN-CC0071 mod

      BEFORE INPUT
#--FUN-CC0071 mark start--         
#         LET g_year = YEAR(g_aam02)
#         DISPLAY g_year  TO FORMONLY.yy
#         DISPLAY g_aam12,g_aam13 TO aam12,aam13
#--FUN-CC0071 mark end----

#--FUN-CC0071 start------
      AFTER FIELD book1
         IF cl_null(g_book1) THEN
            NEXT FIELD CURRENT
         ELSE
            CALL s_check_bookno(g_book1,g_user,g_plant)
               RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD CURRENT
            END IF
            SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=g_book1
            IF g_cnt =0 THEN
               CALL cl_err('','anm-062',0)
               NEXT FIELD CURRENT
            END IF
         END IF

      AFTER FIELD book2
         IF cl_null(g_book2) OR g_book1=g_book2 THEN
            CALL cl_err('','agl-515',0)
            NEXT FIELD CURRENT
         END IF

         IF NOT cl_null(g_book2) THEN
            LET g_cnt = 0	
            SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=g_book2
            IF g_cnt =0 THEN
               CALL cl_err('','anm-062',0)
               NEXT FIELD CURRENT
            END IF
            LET g_cnt = 0	    
            SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01 = g_book2 AND aaa13 = 'Y'
            IF g_cnt = 0 THEN
               CALL cl_err('','agl1026',0)
               NEXT FIELD CURRENT
            END IF   
         END IF   

         CALL s_check_bookno(g_book2,g_user,g_plant)
              RETURNING li_chk_bookno
         IF (NOT li_chk_bookno) THEN
             NEXT FIELD CURRENT
         END IF
#----FUN-CC0071 end------------
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT INPUT
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
 
      ON ACTION about
         CALL cl_about()
   
      ON ACTION help
         CALL cl_show_help()
   
      ON ACTION controlg
         CALL cl_cmdask()
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_select
         CALL cl_qbe_select()

      #--FUN-CC0071 start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(book1)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_book1
               DISPLAY g_book1 TO book1
               NEXT FIELD book1
            WHEN INFIELD(book2)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_book2
               DISPLAY g_book2 TO book2
               NEXT FIELD book2
         END CASE
     #--FUN-CC0071 end----------

   END INPUT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW aglp8021_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   ERROR ""
END FUNCTION
FUNCTION p8021()
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_aag01     LIKE aag_file.aag01
DEFINE l_aag222      LIKE aag_file.aag222
DEFINE l_tag05     LIKE tag_file.tag05
  
   LET g_sql = "SELECT tag05 FROM tag_file "
              ," WHERE tag01 = ? AND tag02 = ?"
              ,"   AND tag03 = ? AND tag04 = ?"
              ,"   AND tag06 = '1'   AND tagacti = 'Y'"
   PREPARE p8021_p1 FROM g_sql
   DECLARE p8021_c1 CURSOR FOR p8021_p1
   LET g_sql = "SELECT COUNT(*) FROM tag_file"
              ," WHERE tag01 = ? AND tag02 = ?"
              ,"   AND tag03 = ? AND tag04 = ?"
              ,"   AND tagacti = 'Y' AND tag06 = '1'"
   PREPARE p8021_p2 FROM g_sql
   DECLARE p8021_c2 CURSOR FOR p8021_p2
   
   LET g_sql = "UPDATE aag_file  SET aag20 = 'Y',aag222 = ? "
              ," WHERE aag00 = ? AND aag01 = ? AND aagacti = 'Y'"
   PREPARE p8021_p3 FROM g_sql
   
   LET g_sql = " SELECT aag01 FROM aag_file "
              #,"  WHERE aag00 = '",g_aam12,"' AND aagacti = 'Y' AND aag20 = 'Y'"   #FUN-CC0071 mark
              ,"  WHERE aag00 = '",g_book1,"' AND aagacti = 'Y' AND aag20 = 'Y'"    #FUN-CC0071 mod
   PREPARE p8021_p4 FROM g_sql
   DECLARE p8021_c4 CURSOR FOR p8021_p4
   FOREACH p8021_c4 INTO l_aag01
      IF cl_null(l_aag01) THEN CONTINUE FOREACH END IF
      LET l_cnt = 0
      #OPEN  p8021_c2 USING g_year,g_aam12,l_aag01,g_aam13   #FUN-CC0071 mark
      OPEN  p8021_c2 USING g_year,g_book1,l_aag01,g_book2    #FUN-CC0071 mod
      FETCH p8021_c2 INTO l_cnt
      CASE l_cnt
           WHEN "0"
              #LET g_errmsg=g_aam12 CLIPPED,"/",l_aag01 CLIPPED    #FUN-CC0071 mark
              LET g_errmsg=g_book1 CLIPPED,"/",l_aag01 CLIPPED     #FUN-CC0071 mod
              CALL s_errmsg('tag02,tag03',g_errmsg,l_aag01 CLIPPED,'agl1038','1')
              CONTINUE FOREACH
           WHEN "1"
              #OPEN  p8021_c1 USING g_year,g_aam12,l_aag01,g_aam13     #FUN-CC0071 mark
              OPEN  p8021_c1 USING g_year,g_book1,l_aag01,g_book2      #FUN-CC0071 mod
              FETCH p8021_c1 INTO l_tag05
              IF cl_null(l_tag05) THEN CONTINUE FOREACH END IF
              LET l_aag222 = ""
              SELECT aag222 INTO l_aag222 FROM aag_file
               #WHERE aag00 = g_aam12 AND aag01 = l_aag01             #FUN-CC0071 mark
               WHERE aag00 = g_book1 AND aag01 = l_aag01              #FUN-CC0071 mod
              IF cl_null(l_aag222) THEN
                 #LET g_errmsg=g_aam12 CLIPPED,"/",l_aag01 CLIPPED    #FUN-CC0071 mark
                 LET g_errmsg=g_book1 CLIPPED,"/",l_aag01 CLIPPED     #FUN-CC0071 mod
                 CALL s_errmsg('tag02,tag03',g_errmsg,l_aag01 CLIPPED,'agl1055','1')
                 CONTINUE FOREACH
              END IF
              #EXECUTE p8021_p3 USING l_aag222,g_aam13,l_tag05        #FUN-CC0071 MARK
              EXECUTE p8021_p3 USING l_aag222,g_book2,l_tag05         #FUN-CC0071 mod
           OTHERWISE
              #LET g_errmsg=g_aam12 CLIPPED,"/",l_aag01 CLIPPED  #FUN-CC0071 mark
              LET g_errmsg=g_book1 CLIPPED,"/",l_aag01 CLIPPED   #FUN-CC0071 mod
              CALL s_errmsg('tag02,tag03',g_errmsg,l_aag01 CLIPPED,'agl1044','1')
              CONTINUE FOREACH
      END CASE
   END FOREACH
   CLOSE p8021_c1
   CLOSE p8021_c2
   FREE  p8021_p3
END FUNCTION
