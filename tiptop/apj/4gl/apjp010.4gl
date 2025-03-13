# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apjp010.4gl
# Descriptions...: WBS累計預計需求資源推算作業
# Date & Author..: No.FUN-790025 08/03/14 By douzh
# Modify.........: No.TQC-840043 08/04/18 By douzh pjt12 -->pjs12 調整
# Modify.........: No.MOD-950077 09/05/10 By Dido 檢核 cursor 是否有值
# Modify.........: No.TQC-950120 09/05/19 By Dido 調整檢核邏輯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_pja01         LIKE pja_file.pja01 
DEFINE  g_pja01_t       LIKE pja_file.pja01 
DEFINE  g_pja05         LIKE pja_file.pja05 
DEFINE  g_pja05_t       LIKE pja_file.pja05 
DEFINE  g_pja08         LIKE pja_file.pja08 
DEFINE  g_pja08_t       LIKE pja_file.pja08 
DEFINE  tm              RECORD 
         yy             LIKE pjt_file.pjt01,
         mm             LIKE pjt_file.pjt02
                        END RECORD
DEFINE  ls_date         STRING,             
        l_flag          LIKE type_file.chr1,
        g_change_lang   LIKE type_file.chr1
 
DEFINE  gv_time         LIKE type_file.chr8 
DEFINE  g_wc            STRING
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_wc    = ARG_VAL(1)
   LET g_bgjob  = ARG_VAL(2)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL apjp010(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL p010_process()
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW apjp010_w
              EXIT WHILE
           END IF
         ELSE
           CONTINUE WHILE
         END IF
     ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p010_process()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
     END  IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION apjp010(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5
    DEFINE  lc_cmd         STRING
    DEFINE  l_cnt          LIKE type_file.num5
    DEFINE  l_zz08         LIKE zz_file.zz08
 
   OPEN WINDOW apjp010_w WITH FORM "apj/42f/apjp010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      LET g_bgjob = 'N'
 
      CONSTRUCT BY NAME g_wc ON pja01
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pja01) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pja"
               LET g_qryparam.default1 = g_pja01
               CALL cl_create_qry() RETURNING g_pja01
               DISPLAY g_pja01 TO pja01
               NEXT FIELD pja01
            OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
        CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about     
         CALL cl_about()   
 
      ON ACTION help        
         CALL cl_show_help() 
 
      ON ACTION exit     
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup') #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW apjp010_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   
   SELECT ccz01,ccz02 INTO g_ccz.ccz01,g_ccz.ccz02
     FROM ccz_file WHERE ccz00 = '0'
   LET tm.yy = g_ccz.ccz01
   LET tm.mm = g_ccz.ccz02
   LET g_bgjob = 'N' 
 
   INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS
 
   AFTER INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0            
         CLOSE WINDOW p010_w          
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM               
      END IF
 
   AFTER FIELD mm 
      IF tm.mm IS NOT NULL THEN
          IF g_azm.azm02 = '2' THEN 
             IF tm.mm <1 OR tm.mm >13 THEN
                CALL cl_err(tm.mm,'agl-013',0)
                LET tm.mm = NULL
                NEXT FIELD mm
             END IF
          ELSE
             IF tm.mm <1 OR tm.mm >12 THEN
                CALL cl_err(tm.mm,'agl-317',0)
                NEXT FIELD mm
             END IF
          END IF
      END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask()  
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION locale            
         LET g_change_lang = TRUE  
         EXIT INPUT                 
 
   END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
  IF g_bgjob = "Y" THEN
     LET lc_cmd = NULL
     SELECT zz08 INTO l_zz08 FROM zz_file
      WHERE zz01 = "apjp010"
     IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
        CALL cl_err('apjp010','9031',1)  
     ELSE
        LET lc_cmd = l_zz08 CLIPPED,
                     " ''",
                     " '",g_wc CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.mm CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('apjp010',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW apjp010_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
   END IF
   EXIT WHILE
 
   ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION p010_process()
DEFINE l_sql    STRING
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5
DEFINE l_pjb02  LIKE pjb_file.pjb02
DEFINE l_pjfa05 LIKE pjfa_file.pjfa05
DEFINE l_pjfb06 LIKE pjfb_file.pjfb06
DEFINE l_pja01  LIKE pja_file.pja01
DEFINE l_pja31  LIKE pja_file.pja31
DEFINE l_pja32  LIKE pja_file.pja32
DEFINE l_pja33  LIKE pja_file.pja33
DEFINE l_pja34  LIKE pja_file.pja34
DEFINE l_pjs    RECORD LIKE pjs_file.* 
DEFINE l_pjt    RECORD LIKE pjt_file.*
DEFINE l_amt1   LIKE pjs_file.pjs10
DEFINE l_amt2   LIKE pjs_file.pjs11
DEFINE l_amt3   LIKE pjs_file.pjs12
DEFINE l_pjt11  LIKE pjt_file.pjt11
DEFINE l_pjt19  LIKE pjt_file.pjt19
DEFINE l_pjt20  LIKE pjt_file.pjt20
DEFINE l_pjt21  LIKE pjt_file.pjt21
DEFINE l_sum1   LIKE pjt_file.pjt11
DEFINE l_sum2   LIKE pjs_file.pjs12
DEFINE l_sum3   LIKE pjt_file.pjt11
DEFINE l_sum4   LIKE pjt_file.pjt14
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  IF g_success = 'Y' THEN
     LET l_sql= "DELETE FROM pjt_file WHERE pjt01 = '",tm.yy,"'",
                " AND pjt02 ='",tm.mm,"' ",
                " AND pjt03 IN (SELECT pja01 FROM pja_file WHERE ",g_wc CLIPPED,")"
     PREPARE pjt_r FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('pjt_r',SQLCA.sqlcode,1)
     END IF
     EXECUTE pjt_r  
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err('pjt_r',SQLCA.sqlcode,1)
        RETURN
     END IF
     LET l_sql= "DELETE FROM pjs_file WHERE pjs01 = '",tm.yy,"'",
                " AND pjs02 ='",tm.mm,"' ",
                " AND pjs03 IN (SELECT pja01 FROM pja_file WHERE ",g_wc CLIPPED,")"
     PREPARE pjs_r FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('pjt_r',SQLCA.sqlcode,1)
     END IF
     EXECUTE pjs_r  
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err('pjs_r',SQLCA.sqlcode,1)
        RETURN
     END IF
  END IF
 
 
  LET l_sql="SELECT pja01,pja31,pja32,pja33,pja34 FROM pja_file ",
            " WHERE ",g_wc CLIPPED   
  PREPARE p010_pb FROM l_sql
  DECLARE p010_cur CURSOR FOR p010_pb
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p010_cur INTO l_pja01,l_pja31,l_pja32,l_pja33,l_pja34
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p010_cur',STATUS,1)
        EXIT FOREACH
     END IF
     LET l_pjs.pjs01 = tm.yy
     LET l_pjs.pjs02 = tm.mm
     LET l_pjs.pjs03 = l_pja01
     LET l_cnt = 0                   #TQC-950120
    #-MOD-950077-add
    #DECLARE p010_cs_1 CURSOR FOR
    #SELECT pjb02,pjda02 FROM pjb_file,pjda_file 
    #  WHERE pjb02 = pjda01 AND pjb01 = l_pja01
     LET l_sql="SELECT pjb02,pjda02 FROM pjb_file,pjda_file ",
               " WHERE pjb02 = pjda01 AND pjb01 = '",l_pja01,"'"   
     PREPARE p010_ps_1 FROM l_sql
     DECLARE p010_cs_1 CURSOR FOR p010_ps_1
    #-MOD-950077-end
     FOREACH p010_cs_1 INTO l_pjs.pjs04,l_pjs.pjs05
         IF STATUS THEN
            LET g_success='N'
            CALL cl_err('foreach p010_cs_1',STATUS,1)
            EXIT FOREACH
         END IF 
         LET l_pjs.pjs10 = 0                  #預算邏輯未加
         LET l_pjs.pjs11 = 0    
         LET l_pjs.pjs12 = 0
         LET l_pjs.pjsuser = g_user
         LET l_pjs.pjsdate = g_today
         LET l_pjs.pjstime = TIME
         LET l_pjs.pjsoriu = g_user      #No.FUN-980030 10/01/04
         LET l_pjs.pjsorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO pjs_file VALUES(l_pjs.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("ins","pjs_file","","",SQLCA.sqlcode,"","",1)
            LET g_success='N' 
            EXIT FOREACH                                                                                                            
         END IF
         LET l_cnt = l_cnt + 1               #TQC-950120
     END FOREACH
    #-TQC-950120-add
     IF l_cnt = 0 THEN
        LET g_success='N'
        CONTINUE FOREACH 
     END IF
    #-TQC-950120-end
     IF g_success='Y' THEN
        LET l_pjt.pjt01 = tm.yy
        LET l_pjt.pjt02 = tm.mm
        LET l_pjt.pjt03 = l_pja01
        LET l_pjt.pjt10 = 0
        SELECT SUM(ccc62) INTO l_pjt.pjt11 FROM ccc_file WHERE ccc02 =tm.yy
           AND ccc03 = tm.mm AND ccc07 ='4'#AND ccc08 = l_pjt.pjt03
        IF cl_null(l_pjt.pjt11) THEN LET l_pjt.pjt11 = 0 END IF
        LET l_pjt.pjt12 = 0
        LET l_pjt.pjt13 = 0
        LET l_pjt.pjt14 = 0
        LET l_pjt.pjt15 = 0
        LET l_pjt.pjt16 = 0
        LET l_pjt.pjt17 = 0
        LET l_pjt.pjt18 = 0
        SELECT COUNT(*) INTO l_n FROM afb_file
         WHERE afb00 = g_aaz.aaz64 AND afb03 = l_pjt.pjt02 
           AND afb04 IN (SELECT pjb02 FROM pjb_file,pjda_file
             WHERE pjb01= l_pjt.pjt03 AND pjb03 = pjda01)
           AND afb041 = l_pjt.pjt03
           AND afbacti = 'Y'                       #FUN-D70090
        IF l_n >0 THEN
           LET l_pjt.pjt19 = 1                  #預算邏輯未加
           LET l_pjt.pjt20 = 1                  #預算邏輯未加
           LET l_pjt.pjt21 = 1                  #預算邏輯未加
        ELSE
           LET l_pjt.pjt19 = l_pja32
           LET l_pjt.pjt20 = l_pja33
           LET l_pjt.pjt21 = l_pja34
        END IF
        LET l_pjt.pjtuser = g_user
        LET l_pjt.pjtdate = g_today
        LET l_pjt.pjttime = TIME
        LET l_pjt.pjtoriu = g_user      #No.FUN-980030 10/01/04
        LET l_pjt.pjtorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO pjt_file VALUES(l_pjt.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("ins","pjt_file","","",SQLCA.sqlcode,"","",1)
           LET g_success='N' 
           EXIT FOREACH                                                                                                            
        END IF
        SELECT SUM(pjs10),SUM(pjs11),SUM(pjs12) INTO l_amt1,l_amt2,l_amt3 
          FROM pjs_file WHERE pjs01 = tm.yy AND pjs02 = tm.mm
           AND pjs03 = l_pja01
        IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
        IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
        SELECT pjt11,pjt19,pjt20,pjt21 INTO l_pjt11,l_pjt19,l_pjt20,l_pjt21
          FROM pjt_file 
         WHERE pjt01=tm.yy AND pjt02=tm.mm AND pjt03=l_pja01
        CASE 
           WHEN l_pja31 = '1'
                LET l_pjs.pjs11 = l_pjt21 * (l_pjt11/l_pjt20) - l_amt1
                LET l_pjs.pjs12 = l_amt1+l_pjs.pjs11
                UPDATE pjs_file SET pjs11 = l_pjs.pjs11,
                                    pjs12 = l_pjs.pjs12
                              WHERE pjs01 = tm.yy
                                AND pjs02 = tm.mm
                                AND pjs03 = l_pja01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   LET g_success='N' 
                   CALL cl_err3("upd","pjs_file","","",SQLCA.sqlcode,"","",1)    
                   EXIT FOREACH                                                                                                            
                END IF
                LET l_pjt.pjt12 =l_amt1
                LET l_pjt.pjt13 =l_amt2
                LET l_pjt.pjt14 =0
                LET l_pjt.pjt16 =l_pjt.pjt19*(l_pjt.pjt11/l_pjt.pjt20)
                LET l_pjt.pjt17 =l_pjt.pjt11
                LET l_pjt.pjt18 =l_amt3
                UPDATE pjt_file SET pjt12 = l_pjt.pjt12,
                                    pjt13 = l_pjt.pjt13,
                                    pjt14 = l_pjt.pjt14,
                                    pjt16 = l_pjt.pjt16,
                                    pjt17 = l_pjt.pjt17,
                                    pjt18 = l_pjt.pjt18 
                              WHERE pjt01 = tm.yy
                                AND pjt02 = tm.mm
                                AND pjt03 = l_pja01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   LET g_success='N' 
                   CALL cl_err3("upd","pjt_file","","",SQLCA.sqlcode,"","",1)    
                   EXIT FOREACH                                                                                                            
                END IF                                
           WHEN l_pja31 = '2' OR l_pja31 = '3'
#TQC-840043--begin
                #到本期為止的SUM(pjt11)=>
                SELECT SUM(pjt11) INTO l_sum1 FROM pjt_file,pjs_file 
                 WHERE pjt01<= tm.yy AND pjt02<= tm.mm AND pjt03=l_pja01
                #前期的SUM(pjs12)=>  *當azm02=1時，pjs02需介于1~12，當azm02=2時，pjs02需介于1~13
                IF tm.mm =1 THEN
                   IF g_azm.azm02='1' THEN
                      SELECT SUM(pjs12) INTO l_sum2 FROM pjs_file 
                       WHERE pjs01=tm.yy-1 AND pjs02=12 AND pjs03=l_pja01
                   ELSE
                      SELECT SUM(pjs12)  INTO l_sum2 FROM pjs_file 
                       WHERE pjs01=tm.yy-1 AND pjs02=13 AND pjs03=l_pja01
                   END IF
                ELSE
                   SELECT SUM(pjs12) INTO l_sum2 FROM pjs_file
                    WHERE pjs01= tm.yy AND pjs02= tm.mm-1 AND pjs03=l_pja01
                END IF 
                IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
                IF cl_null(l_sum2) THEN LET l_sum2=0 END IF
#TQC-840043--end
                LET l_pjs.pjs11 = l_pjt21*(l_sum1/l_pjt20)-l_sum2-l_amt1
                LET l_pjs.pjs12 = l_amt1+l_pjs.pjs11
                UPDATE pjs_file SET pjs11 = l_pjs.pjs11,
                                    pjs12 = l_pjs.pjs12
                              WHERE pjs01 = tm.yy
                                AND pjs02 = tm.mm
                                AND pjs03 = l_pja01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   LET g_success='N' 
                   CALL cl_err3("upd","pjs_file","","",SQLCA.sqlcode,"","",1)    
                   EXIT FOREACH                                                                                                            
                END IF                
                #到本期為止的SUM(pjt11)=>
                SELECT SUM(pjt11) INTO l_sum3 FROM pjt_file
                 WHERE pjt01<= tm.yy AND pjt02<= tm.mm AND pjt03=l_pja01
                #前期的pjt14 =>     #當azm02=1時，pjt02需介于1~12，當azm02=2時，pjt02需介于1~13  
                IF tm.mm =1 THEN
                   IF g_azm.azm02='1' THEN
                      SELECT pjt14 INTO l_sum4 FROM pjt_file 
                       WHERE pjt01=tm.yy-1 AND pjt02=12 AND pjt03=l_pja01
                   ELSE
                      SELECT pjt14  INTO l_sum4 FROM pjt_file 
                       WHERE pjt01=tm.yy-1 AND pjt02=13 AND pjt03=l_pja01
                   END IF
                ELSE
                   SELECT pjt14 INTO l_sum4 FROM pjt_file
                    WHERE pjt01= tm.yy AND pjt02= tm.mm-1 AND pjt03=l_pja01
                END IF 
                IF cl_null(l_sum3) THEN LET l_sum3=0 END IF
                IF cl_null(l_sum4) THEN LET l_sum4=0 END IF
                LET l_pjt.pjt12 =l_amt1
                LET l_pjt.pjt13 =l_amt2
                LET l_pjt.pjt14 =l_pjt19*(l_sum3/l_pjt20)-l_sum4 
                LET l_pjt.pjt16 =l_pjt.pjt14
                LET l_pjt.pjt17 =l_pjt.pjt11
                LET l_pjt.pjt18 =l_amt3
                UPDATE pjt_file SET pjt12 = l_pjt.pjt12,
                                    pjt13 = l_pjt.pjt13,
                                    pjt14 = l_pjt.pjt14,
                                    pjt16 = l_pjt.pjt16,
                                    pjt17 = l_pjt.pjt17,
                                    pjt18 = l_pjt.pjt18 
                              WHERE pjt01 = tm.yy
                                AND pjt02 = tm.mm
                                AND pjt03 = l_pja01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   LET g_success='N' 
                   CALL cl_err3("upd","pjt_file","","",SQLCA.sqlcode,"","",1)    
                   EXIT FOREACH                                                                                                            
                END IF
        END CASE
     END IF
  END FOREACH
END FUNCTION
#No.FUN-790025
