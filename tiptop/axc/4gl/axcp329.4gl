# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axcp329.4gl
# Descriptions...: 结存调整分录底稿整批生成作业
# Date & Author..: 12/09/04 By minpp #No.FUN-C90002
# Modify.........: No:MOD-CC0072 12/12/10 By wujie ccc92 -->ccc93
# Modify.........: No:MOD-D20067 13/02/07 By Carrier default 帐套=ccz12
# Modify.........: No:MOD-D20036 13/02/07 By Carrier default 年=ccz01 期=ccz02
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12

DATABASE ds   

GLOBALS "../../config/top.global"

#No.FUN-C90002
#模組變數(Module Variables)
DEFINE g_cdm               RECORD LIKE cdm_file.*
DEFINE g_wc                STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE tm                  RECORD 
                           ccc07       LIKE ccc_file.ccc07,
                           ccc02       LIKE ccc_file.ccc02,
                           ccc03       LIKE ccc_file.ccc03,
                           b           LIKE aaa_file.aaa01
                           END RECORD 
#主程式開始
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_flag              LIKE type_file.chr1
DEFINE g_change_lang       LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
    
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME   
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p329_tm()
         IF cl_sure(18,20) THEN 
            CALL p329_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p329_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p329_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p329_w
      ELSE
         CALL p329_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p329_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p329_w AT p_row,p_col WITH FORM "axc/42f/axcp323" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR '' 

   #No.MOD-D20036  --Begin
   #SELECT sma51,sma52 INTO tm.ccc02,tm.ccc03 FROM sma_file    
   LET tm.ccc02 = g_ccz.ccz01
   LET tm.ccc03 = g_ccz.ccz02
   #No.MOD-D20036  --End  
   LET tm.b = g_ccz.ccz12                    #No.MOD-D20067
   LET g_bgjob = 'N'   
   INPUT tm.ccc07,tm.ccc02,tm.ccc03,tm.b      
     WITHOUT DEFAULTS                        #No.MOD-D20067
     FROM tlfctype,yy,mm,b 

      BEFORE INPUT 
         LET tm.ccc07 = g_ccz.ccz28 
 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         END IF

      AFTER FIELD tlfctype
         IF tm.ccc07 NOT MATCHES '[12345]' THEN 
            LET tm.ccc07 =NULL 
            NEXT FIELD tlfctype
         END IF  
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p329_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            EXIT PROGRAM
         END IF
         IF cl_null(tm.ccc07)THEN 
            NEXT FIELD tlfctype
         END IF  
         IF cl_null(tm.ccc02) THEN
            NEXT FIELD yy 
         END IF  
         IF cl_null(tm.ccc03) THEN
            NEXT FIELD mm 
         END IF 
         IF cl_null(tm.b) THEN
            NEXT FIELD b 
         END IF 

 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
      ON ACTION qbe_save
           CALL cl_qbe_save()
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
         END CASE
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p329_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION p329_p()
   
   BEGIN WORK 
   CALL p329_chk()
   IF g_flag ='N' THEN 
      LET g_success = 'N'
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p329_ins_cdm()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p326_gl(tm.*,'2')       
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
END FUNCTION 

FUNCTION p329_ins_cdm()

DEFINE l_sql      STRING 
DEFINE l_ccz22    LIKE ccz_file.ccz22
DEFINE l_cdmlegal LIKE cdm_file.cdmlegal
DEFINE l_cdm06    LIKE cdm_file.cdm06
DEFINE l_cdm02    LIKE cdm_file.cdm02
DEFINE l_cdm03    LIKE cdm_file.cdm03
DEFINE l_cdm04    LIKE cdm_file.cdm04
DEFINE l_cdm05    LIKE cdm_file.cdm05
DEFINE l_cdm11    LIKE cdm_file.cdm11
DEFINE l_cdm09    LIKE cdm_file.cdm09
DEFINE l_cdm07    LIKE cdm_file.cdm07
DEFINE l_ccz07    LIKE ccz_file.ccz07
DEFINE l_ccz12    LIKE ccz_file.ccz12

   LET g_sql = " SELECT ccc01,ccc02,ccc03,ccc93,ccc07,ccc08,ccclegal ",  #No.MOD-CC0072  ccc92-->ccc93
               "   FROM ima_file,ccc_file ",
               "  WHERE ccc07='",tm.ccc07,"'",
               "    AND ccc02='",tm.ccc02,"'",
               "    AND ccc03='",tm.ccc03,"'", 
               "    AND ccc93<>0 ",
               "    AND ccc01=ima01"
                
   PREPARE p329_p1 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p329_c1 CURSOR FOR p329_p1
   FOREACH p329_c1 INTO l_cdm06,l_cdm02,l_cdm03,l_cdm09,l_cdm04,l_cdm05,l_cdmlegal           
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdm.* TO NULL
      LET g_cdm.cdm00 = '2'
      LET g_cdm.cdm01 = tm.b
      LET g_cdm.cdm02 = l_cdm02
      LET g_cdm.cdm03 = l_cdm03
      LET g_cdm.cdm04 = l_cdm04
      LET g_cdm.cdm05 = l_cdm05
      LET g_cdm.cdm06 = l_cdm06
      LET g_cdm.cdm09 = l_cdm09
      LET g_cdm.cdm11 = ' '    #wujie 130615
           
      SELECT ccz07,ccz22,ccz12 INTO l_ccz07,l_ccz22,l_ccz12 FROM ccz_file 
      LET g_cdm.cdm08 = l_ccz22 
      IF g_cdm.cdm01 = l_ccz12 THEN      
         IF l_ccz07='2'  THEN
            SELECT imz39 INTO g_cdm.cdm07 FROM ima_file,imz_file
            #WHERE ima01 = g_cdm.cdm06 AND ima12=imz01 #MOD-D50133 mark
             WHERE ima01 = g_cdm.cdm06 AND ima06=imz01 #MOD-D50133 ima12->ima06
         ELSE
            SELECT ima39 INTO g_cdm.cdm07 FROM ima_file
             WHERE ima01=g_cdm.cdm06
         END IF
      ELSE
         IF l_ccz07 = '2' THEN
            SELECT imz391 INTO g_cdm.cdm07
              FROM ima_file,imz_file
             WHERE ima01 = g_cdm.cdm06
              #AND ima12 = imz01 #MOD-D50133 mark
               AND ima06 = imz01 #MOD-D50133 ima12->ima06
         ELSE
            SELECT ima391 INTO g_cdm.cdm07
              FROM ima_file
             WHERE ima01 = g_cdm.cdm06
         END IF
      END IF 
      LET g_cdm.cdmlegal = l_cdmlegal       
      LET g_cdm.cdmconf ='N'
      
      INSERT INTO cdm_file VALUES(g_cdm.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdm',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF 
      IF g_success ='N' THEN 
         RETURN 
      END IF       
   END FOREACH 
END FUNCTION 

FUNCTION p329_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdmconf   LIKE cdm_file.cdmconf
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cdm_file ",
               " WHERE cdm00 = '2'",                  
               "   AND cdm01 ='",tm.b CLIPPED,"'",
               "   AND cdm02 =",tm.ccc02 CLIPPED,
               "   AND cdm03 =",tm.ccc03 CLIPPED,
               "   AND cdm04 = '",tm.ccc07 CLIPPED,"'"

   PREPARE p329_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p329_c6 CURSOR FOR p329_p6
   LET l_sql = "DELETE ",
               "  FROM cdm_file ",
               " WHERE cdm00 = '2'",                   
                "  AND cdm01 ='",tm.b CLIPPED,"'",
               "   AND cdm02 =",tm.ccc02 CLIPPED,
               "   AND cdm03 =",tm.ccc03 CLIPPED,
               "   AND cdm04 = '",tm.ccc07 CLIPPED,"'"


   PREPARE p329_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   OPEN p329_c6 
   FETCH p329_c6 INTO l_cnt
   IF l_cnt >0 THEN 
      SELECT UNIQUE cdmconf INTO l_cdmconf FROM cdm_file
       WHERE cdm00 = '2'                   
         AND cdm01=tm.b          AND cdm02=tm.ccc02
         AND cdm03=tm.ccc03
         AND cdm04=tm.ccc07 
      IF l_cdmconf='Y' THEN
         CALL cl_err('','afa-364',1)
         LET g_flag='N'
      ELSE
         IF cl_confirm('mfg8002') THEN 
            LET g_flag ='Y'
            EXECUTE p329_p7    
         ELSE 
            LET g_flag ='N'
         END IF 
      END IF
   ELSE 
      LET g_flag ='Y'
   END IF 
   CLOSE p329_c6
END FUNCTION 
