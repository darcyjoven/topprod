# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcp323.4gl
# Descriptions...: 盤盈虧分录底稿整批生成作业
# Date & Author..: 10/07/08 By xiaofeizhu #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 分錄底稿根據幣種取位
# Modify.........: No:FUN-BB0038 11/11/08 By elva 成本改善
# Modify.........: No:FUN-C90002 12/09/04 By minpp 成本类型给默认值ccz28
# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位
# Modify.........: No.MOD-D40219 13/04/27 By wujie tlf增加抓取tlf13=artt215
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12
# Modify.........: No.MOD-DB0128 13/11/19 By suncx 存在已審核cdk_file資料，提示已審核，不可重新產生

DATABASE ds   

GLOBALS "../../config/top.global"

#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE g_cdk               RECORD LIKE cdk_file.*
DEFINE g_wc                STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE tm                  RECORD 
                           tlfctype    LIKE tlfc_file.tlfctype,
                           yy          LIKE type_file.num5,
                           mm          LIKE type_file.num5,
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
         CALL p323_tm()
         IF cl_sure(18,20) THEN 
            CALL p323_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p323_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p323_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p323_w
      ELSE
         CALL p323_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p323_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p323_w AT p_row,p_col WITH FORM "axc/42f/axcp323" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR '' 
   DISPLAY BY NAME tm.tlfctype,tm.yy,tm.mm,tm.b
   SELECT sma51,sma52 INTO tm.yy,tm.mm FROM sma_file    
   LET g_bgjob = 'N'   
   INPUT BY NAME
      tm.tlfctype,tm.yy,tm.mm,tm.b      
      WITHOUT DEFAULTS 
 
      BEFORE INPUT                        #FUN-C90002
         LET tm.tlfctype = g_ccz.ccz28    #FUN-C90002
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         END IF

      AFTER FIELD tlfctype
         IF tm.tlfctype NOT MATCHES '[12345]' THEN 
            LET tm.tlfctype =NULL 
            NEXT FIELD tlfctype
         END IF  
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p323_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
         IF cl_null(tm.tlfctype)THEN 
         NEXT FIELD tlfctype 
         END IF  
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy 
         END IF  
         IF cl_null(tm.mm) THEN
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
      CLOSE WINDOW p323_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION p323_p()
   
   BEGIN WORK 
   CALL p323_chk()
   IF g_flag ='N' THEN ROLLBACK WORK RETURN END IF 
   CALL p323_ins_cdk()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p323_gl(tm.*)
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
END FUNCTION 

FUNCTION p323_ins_cdk()

DEFINE l_sql      STRING 
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_cdklegal LIKE cdk_file.cdklegal
DEFINE l_cdk06    LIKE cdk_file.cdk06
DEFINE l_cdk02    LIKE cdk_file.cdk02
DEFINE l_cdk03    LIKE cdk_file.cdk03
DEFINE l_cdk04    LIKE cdk_file.cdk04
DEFINE l_cdk05    LIKE cdk_file.cdk05
DEFINE l_cdk08    LIKE cdk_file.cdk08
DEFINE l_cdk09    LIKE cdk_file.cdk09
DEFINE l_cdk11    LIKE cdk_file.cdk11
DEFINE l_ccz07    LIKE ccz_file.ccz07
DEFINE l_ccz24    LIKE ccz_file.ccz24
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07
 

   #FUN-BB0038 --begin
   LET l_sql ="SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf930,SUM(tlfc907*tlf10),SUM(tlfc907*tlfc21)",  
              "  FROM tlfc_file,tlf_file ",
              " WHERE tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02", 
              "   AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903", 
              "   AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906",
              "   AND YEAR(tlf06)='",tm.yy,"' ",
              "   AND MONTH(tlf06)='",tm.mm,"' ",
              "   AND tlfctype='",tm.tlfctype,"' ", 
#              "   AND tlf13='aimp880'"  ,
              "   AND (tlf13='aimp880' OR tlf13='artt215')",   #No.MOD-D40219
              " GROUP BY tlfclegal,tlfctype,tlfccost,tlf01,tlf930 "  
   #FUN-BB0038 --end
                 
   PREPARE p323_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p323_c1 CURSOR FOR p323_p1
   FOREACH p323_c1 INTO l_cdklegal,l_cdk04,l_cdk05,l_cdk06,l_cdk11,l_cdk08,l_cdk09
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdk.* TO NULL
      LET g_cdk.cdk01 = tm.b
      LET g_cdk.cdk02 = tm.yy
      LET g_cdk.cdk03 = tm.mm
      LET g_cdk.cdk04 = l_cdk04
      LET g_cdk.cdk05 = l_cdk05
      LET g_cdk.cdk06 = l_cdk06
      LET g_cdk.cdk08 = l_cdk08
      LET g_cdk.cdk09 = l_cdk09
      LET g_cdk.cdk09 = cl_digcut(g_cdk.cdk09,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      #FUN-BB0038 --begin
      IF NOT cl_null(l_cdk11) THEN
         LET g_cdk.cdk11 = l_cdk11
      ELSE
         LET g_cdk.cdk11 = ' '
      END IF
      #FUN-BB0038 --end
      
      #FUN-BB0038 --begin
     #SELECT ccz24 INTO l_ccz24 
     #  FROM ccz_file 
     #LET g_cdk.cdk13=l_ccz24
      #FUN-BB0038 --end

      SELECT ccz07,ccz12 INTO l_ccz07,l_ccz12 FROM ccz_file 
      IF g_cdk.cdk01 = l_ccz12 THEN 
         IF l_ccz07 = '2' THEN 
               SELECT imz39 INTO g_cdk.cdk07
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdk.cdk06
                 #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima39 INTO g_cdk.cdk07
                 FROM ima_file
                WHERE ima01 = g_cdk.cdk06
         END IF  
      ELSE
         IF l_ccz07 = '2' THEN 
               SELECT imz391 INTO g_cdk.cdk07
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdk.cdk06
                 #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima391 INTO g_cdk.cdk07
                 FROM ima_file
                WHERE ima01 = g_cdk.cdk06
         END IF  
      END IF
      SELECT aag03,aag07 INTO l_aag03,l_aag07 FROM aag_file WHERE aag00 = g_cdk.cdk01 AND aag01 = g_cdk.cdk07   
      IF l_aag07 NOT MATCHES '[23]' THEN LET g_cdk.cdk07 = NULL  END IF 
      IF l_aag03 <> '2' THEN LET g_cdk.cdk07 = NULL END IF
      LET g_cdk.cdklegal = l_cdklegal       
#      LET g_cdk.cdkplant = l_cccplant
#      LET g_cdk.cdkorig  = g_grup
#      LET g_cdk.cdkoriu  = g_user 
      LET g_cdk.cdkconf ='N'
      INSERT INTO cdk_file VALUES(g_cdk.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdk',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF 
      IF g_success ='N' THEN 
         RETURN 
      END IF       
   END FOREACH 

END FUNCTION 

FUNCTION p323_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdkconf   LIKE cdk_file.cdkconf  #MOD-DB0128
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cdk_file ",
               " WHERE cdk01 ='",tm.b CLIPPED,"'",
               "   AND cdk02 = '",tm.yy CLIPPED,"'",
               "   AND cdk03 = '",tm.mm CLIPPED,"'", 
               "   AND cdk04 = '",tm.tlfctype CLIPPED,"'"

   PREPARE p323_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p323_c6 CURSOR FOR p323_p6
#MOD-DB0128 add begin-------------------------
   LET l_sql = "SELECT UNIQUE cdkconf ",
               "  FROM cdk_file ",
               " WHERE cdk01 ='",tm.b CLIPPED,"'",
               "   AND cdk02 = '",tm.yy CLIPPED,"'",
               "   AND cdk03 = '",tm.mm CLIPPED,"'",
               "   AND cdk04 = '",tm.tlfctype CLIPPED,"'"

   PREPARE p323_p9 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
#MOD-DB0128 add end---------------------------
   LET l_sql = "DELETE ",
               "  FROM cdk_file ",
               " WHERE cdk01 ='",tm.b CLIPPED,"'",
               "   AND cdk02 = '",tm.yy CLIPPED,"'",
               "   AND cdk03 = '",tm.mm CLIPPED,"'", 
               "   AND cdk04 = '",tm.tlfctype CLIPPED,"'"


   PREPARE p323_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   OPEN p323_c6 
   FETCH p323_c6 INTO l_cnt
   IF l_cnt >0 THEN 
     #MOD-DB0128 add sta---------------
      EXECUTE p323_p9 INTO l_cdkconf
      IF l_cdkconf='Y' THEN
         CALL cl_err('','afa-364',1)
         LET g_flag='N'
      ELSE
     #MOD-DB0128 add end---------------
         IF cl_confirm('mfg8002') THEN 
            LET g_flag ='Y'
         ELSE 
            LET g_flag ='N'
         END IF 
      END IF   #MOD-DB0128 add
   ELSE 
         LET g_flag ='Y'
   END IF 
   IF g_flag ='Y' THEN 
      EXECUTE p323_p7    
   END IF 
   CLOSE p323_c6
END FUNCTION 
