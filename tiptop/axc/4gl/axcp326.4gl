# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcp326.4gl
# Descriptions...: 入库成本调整分录底稿整批生成作业
# Date & Author..: 11/11/10 By elva #No.FUN-BB0038
# Modify.........: No.FUN-C60003 12/06/01 By elva
# Modify.........: No.FUN-C90002 12/09/03 BY minpp 1.增加cdm00字段，以及分录底稿参数的传入cdm00
#..................................................2.成本类型给默认值ccz28
# Modify.........: No.FUN-C90126 12/10/16 By xuxz ccb23 = 1
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12

DATABASE ds   

GLOBALS "../../config/top.global"

#No.FUN-BB0038
#模組變數(Module Variables)
DEFINE g_cdm               RECORD LIKE cdm_file.*
DEFINE g_wc                STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE tm                  RECORD 
                           ccb06       LIKE ccb_file.ccb06,
                           ccb02       LIKE ccb_file.ccb02,
                           ccb03       LIKE ccb_file.ccb03,
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
         CALL p326_tm()
         IF cl_sure(18,20) THEN 
            CALL p326_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p326_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p326_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p326_w
      ELSE
         CALL p326_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p326_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p326_w AT p_row,p_col WITH FORM "axc/42f/axcp323" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR '' 
 # DISPLAY BY NAME tm.ccb06,tm.ccb02,tm.ccb03,tm.b
   SELECT sma51,sma52 INTO tm.ccb02,tm.ccb03 FROM sma_file    
   LET g_bgjob = 'N'   
   INPUT tm.ccb06,tm.ccb02,tm.ccb03,tm.b      
    #WITHOUT DEFAULTS FROM tlfctype,yy,mm,b 
     FROM tlfctype,yy,mm,b 

      BEFORE INPUT                        #FUN-C90002
         LET tm.ccb06 = g_ccz.ccz28       #FUN-C90002
#No.MOD-CB0110 --begin
         LET tm.b = g_ccz.ccz12  
         LET tm.ccb02 = g_ccz.ccz01
         LET tm.ccb03 = g_ccz.ccz02       
         DISPLAY tm.ccb02 TO yy
         DISPLAY tm.ccb03 TO mm  
         DISPLAY tm.ccb06 TO tlfctype            
         DISPLAY tm.b     TO b
#No.MOD-CB0110 --end
 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         END IF

      AFTER FIELD tlfctype
         IF tm.ccb06 NOT MATCHES '[12345]' THEN 
            LET tm.ccb06 =NULL 
            NEXT FIELD tlfctype
         END IF  
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p326_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
         IF cl_null(tm.ccb06)THEN 
            NEXT FIELD tlfctype
         END IF  
         IF cl_null(tm.ccb02) THEN
            NEXT FIELD yy 
         END IF  
         IF cl_null(tm.ccb03) THEN
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
      CLOSE WINDOW p326_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION p326_p()
   
   BEGIN WORK 
   CALL p326_chk()
   IF g_flag ='N' THEN 
      LET g_success = 'N'
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p326_ins_cdm()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
  #CALL p326_gl(tm.*)          #FUN-C90002
   CALL p326_gl(tm.*,'1')      #FUN-C90002
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
END FUNCTION 

FUNCTION p326_ins_cdm()

DEFINE l_sql      STRING 
DEFINE l_ccz12    LIKE ccz_file.ccz12
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
DEFINE l_ccz24    LIKE ccz_file.ccz24
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07

   LET l_sql ="SELECT ccb01,ccb02,ccb03,ccb22,ccb06,ccb07,ccblegal,ccb04", 
              "  FROM ccb_file,ima_file ",
              " WHERE ccb02=",tm.ccb02,
              "   AND ccb03=",tm.ccb03, 
#             "   AND ccb23<>'1' ", #FUN-C60003#FUN-C90126 2--->1
              "   AND ccb23='1' ", #FUN-C60003#FUN-C90126 2--->1  #wujie 130615
            # "   AND ccb01=ima01 AND ima12 is not null "  #FUN-C60003
              "   AND ccb01=ima01 "  #FUN-C60003
                 
   PREPARE p326_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p326_c1 CURSOR FOR p326_p1
   FOREACH p326_c1 INTO l_cdm06,l_cdm02,l_cdm03,l_cdm09,l_cdm04,l_cdm05,l_cdmlegal,l_cdm11
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdm.* TO NULL
      LET g_cdm.cdm01 = tm.b
      LET g_cdm.cdm02 = l_cdm02
      LET g_cdm.cdm03 = l_cdm03
      LET g_cdm.cdm04 = l_cdm04
      LET g_cdm.cdm05 = l_cdm05
      LET g_cdm.cdm06 = l_cdm06
      LET g_cdm.cdm09 = l_cdm09
      LET g_cdm.cdm11 = l_cdm11
           
      SELECT ccz07,ccz12 INTO l_ccz07,l_ccz12 FROM ccz_file 
      IF g_cdm.cdm01 = l_ccz12 THEN 
         IF l_ccz07 = '2' THEN 
               SELECT imz39 INTO g_cdm.cdm07
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdm.cdm06
                 #AND ima12 = imz01  #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima39 INTO g_cdm.cdm07
                 FROM ima_file
                WHERE ima01=g_cdm.cdm06       
         END IF  
      ELSE
         IF l_ccz07 = '2' THEN 
               SELECT imz391 INTO g_cdm.cdm07
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdm.cdm06
                 #AND ima12 = imz01  #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima391 INTO g_cdm.cdm07
                 FROM ima_file
                WHERE ima01 = g_cdm.cdm06
         END IF  
      END IF
      SELECT aag03,aag07 INTO l_aag03,l_aag07 FROM aag_file WHERE aag00 = g_cdm.cdm01 AND aag01 = g_cdm.cdm07   
      IF l_aag07 NOT MATCHES '[23]' THEN LET g_cdm.cdm07 = NULL  END IF 
      IF l_aag03 <> '2' THEN LET g_cdm.cdm07 = NULL END IF
      IF cl_null(g_cdm.cdm07) THEN LET g_cdm.cdm07 = NULL END IF
      LET g_cdm.cdmlegal = l_cdmlegal       
 
      LET g_cdm.cdmconf ='N'
      LET g_cdm.cdm00 = '1'             #FUN-C90002
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

FUNCTION p326_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdmconf   LIKE cdm_file.cdmconf
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cdm_file ",
               " WHERE cdm00 = '1'",                   #FUN-C90002
               "   AND cdm01 ='",tm.b CLIPPED,"'",
               "   AND cdm02 =",tm.ccb02 CLIPPED,
               "   AND cdm03 =",tm.ccb03 CLIPPED,
               "   AND cdm04 = '",tm.ccb06 CLIPPED,"'"

   PREPARE p326_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p326_c6 CURSOR FOR p326_p6
   LET l_sql = "DELETE ",
               "  FROM cdm_file ",
               " WHERE cdm00 = '1'",                   #FUN-C90002
               "   AND cdm01 ='",tm.b CLIPPED,"'",
               "   AND cdm02 =",tm.ccb02 CLIPPED,
               "   AND cdm03 =",tm.ccb03 CLIPPED,
               "   AND cdm04 = '",tm.ccb06 CLIPPED,"'"


   PREPARE p326_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   OPEN p326_c6 
   FETCH p326_c6 INTO l_cnt
   IF l_cnt >0 THEN 
      SELECT UNIQUE cdmconf INTO l_cdmconf FROM cdm_file
       WHERE cdm00='1'                                        #FUN-C90002
         AND cdm01=tm.b 
         AND cdm02=tm.ccb02
         AND cdm03=tm.ccb03
         AND cdm04=tm.ccb06 
      IF l_cdmconf='Y' THEN
         CALL cl_err('','afa-364',1)
         LET g_flag='N'
      ELSE
         IF cl_confirm('mfg8002') THEN 
            LET g_flag ='Y'
            EXECUTE p326_p7    
         ELSE 
            LET g_flag ='N'
         END IF 
      END IF
   ELSE 
      LET g_flag ='Y'
   END IF 
   CLOSE p326_c6
END FUNCTION 
