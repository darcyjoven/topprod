# Prog. Version..: '5.30.06-13.03.12(00002)'     #

#
# Pattern name...: apjp600.4gl
# Descriptions...: WBS累計預計需求資源推算作業
# Date & Author..: No.FUN-790025 08/01/21 By douzh
# MODIFY.........: No.MOD-930119 09/03/11 By rainy apjp503輸入完工進度%，apjp600後完工進度%都被清空
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B30125 11/03/11 By sabrina p600_cur5_1的CURSOR有誤 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_pjb01         LIKE pjb_file.pjb01 
DEFINE  g_pjb01_t       LIKE pjb_file.pjb01 
DEFINE  g_pjb02         LIKE pjb_file.pjb02 
DEFINE  g_pjb02_t       LIKE pjb_file.pjb02 
DEFINE  ls_date         STRING,             
        l_flag          LIKE type_file.chr1,
        g_change_lang   LIKE type_file.chr1
 
DEFINE  gv_time         LIKE type_file.chr8 
DEFINE  g_wc            STRING
DEFINE  g_wc2           STRING
DEFINE  buf             base.StringBuffer
 
MAIN
    DEFINE l_time       LIKE type_file.chr8
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_wc    = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
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
        CALL apjp600(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL p600_process()
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
              CLOSE WINDOW apjp600_w
              EXIT WHILE
           END IF
         ELSE
           CONTINUE WHILE
         END IF
     ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p600_process()
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
 
FUNCTION apjp600(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5
    DEFINE  lc_cmd         STRING
    DEFINE  l_cnt          LIKE type_file.num5
    DEFINE  l_zz08         LIKE zz_file.zz08
 
   OPEN WINDOW apjp600_w WITH FORM "apj/42f/apjp600" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      LET g_bgjob = 'N'
 
      CONSTRUCT BY NAME g_wc ON pjb01,pjb02
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()  
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjb01) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pjb01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb01
               NEXT FIELD pjb01
            WHEN INFIELD(pjb02) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pjb6"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb02
               NEXT FIELD pjb02
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjbuser', 'pjbgrup') #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW apjp600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_bgjob = 'N' 
 
   INPUT BY NAME g_bgjob WITHOUT DEFAULTS
 
   AFTER INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0            
         CLOSE WINDOW p600_w          
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM               
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
         CLOSE WINDOW p600_w
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
       WHERE zz01 = "apjp600"
      IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
         CALL cl_err('apjp600','9031',1)  
      ELSE
         LET lc_cmd = l_zz08 CLIPPED,
                      " ''",
                      " '",g_wc CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apjp600',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW apjp600_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
 
   ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION p600_process()
DEFINE l_sql      STRING
DEFINE ls_result  STRING
DEFINE ls_result2 STRING
DEFINE l_cnt    LIKE type_file.num5
DEFINE sr       RECORD LIKE pjb_file.*
DEFINE l_pjb    RECORD LIKE pjb_file.*
DEFINE l_pjk    RECORD LIKE pjk_file.*
DEFINE l_pjfa05 LIKE pjfa_file.pjfa05
DEFINE l_pjfb06 LIKE pjfb_file.pjfb06
DEFINE l_pjb14  LIKE pjb_file.pjb14
DEFINE l_rate   LIKE type_file.num20_6
DEFINE l_sum    LIKE type_file.num20_6
DEFINE l_sum2   LIKE type_file.num20_6
DEFINE l_sum3   LIKE type_file.num20_6
DEFINE l_i      LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5
DEFINE l_n2     LIKE type_file.num5
DEFINE l_pja19  LIKE pja_file.pja19
DEFINE s_pjb    RECORD LIKE pjb_file.* 
 
  DROP TABLE x 
#相對權重*活動完工率檔
  CREATE TEMP TABLE x(
    x1 LIKE pjb_file.pjb01,
    x2 LIKE pjb_file.pjb02,
    x3 LIKE pjb_file.pjb14);
 
  DROP TABLE y 
#預估成本總和(同tree下的)
  CREATE TEMP TABLE y(
    y1 LIKE pjb_file.pjb01,
    y2 LIKE pjb_file.pjb02,
    y3 LIKE pjfb_file.pjfb05);
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  LET l_sql="SELECT * FROM pjb_file",
            " WHERE ",g_wc CLIPPED, 
            "   AND pjb09 = 'Y' ",
            "   AND pjb25 = 'Y' "
 
  DECLARE p600_cur CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p600_cur INTO l_pjb.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p600_cur',STATUS,1)
        EXIT FOREACH
     END IF
     SELECT pja19 INTO l_pja19 FROM pja_file 
      WHERE pja01 = l_pjb.pjb01
      
     SELECT COUNT(*) INTO l_n FROM pjj_file,pjk_file
        WHERE pjj01 = pjk01 AND pjk11= l_pjb.pjb02
          AND pjj04 = l_pjb.pjb01 AND pjk18 IS NULL 
     IF l_n > 0 THEN
        LET sr.pjb19 = NULL
     ELSE
     	  SELECT MIN(pjk18) INTO sr.pjb19 FROM pjj_file,pjk_file 
     	         WHERE pjj01 = pjk01 AND pjk11= l_pjb.pjb02
                 AND pjj04 = l_pjb.pjb01  
     END IF
     SELECT COUNT(*) INTO l_n FROM pjj_file,pjk_file
        WHERE pjj01 = pjk01 AND pjk11= l_pjb.pjb02
          AND pjj04 = l_pjb.pjb01 AND pjk19 IS NULL
     IF l_n > 0 THEN
        LET sr.pjb20 = NULL
     ELSE
     	  SELECT MAX(pjk19) INTO sr.pjb20 FROM pjj_file,pjk_file 
     	         WHERE pjj01 = pjk01 AND pjk11= l_pjb.pjb02
                 AND pjj04 = l_pjb.pjb01  
     END IF
 
     IF l_pja19 = '1' THEN
        SELECT MIN(pjk20) INTO sr.pjb17 FROM pjk_file,pjj_file,pjb_file  
         WHERE pjk01 = pjj01 AND pjk11 = l_pjb.pjb02
           AND pjj04 = l_pjb.pjb01
        SELECT MAX(pjk21) INTO sr.pjb18 FROM pjk_file,pjj_file,pjb_file  
         WHERE pjk01 = pjj01 AND pjk11 = l_pjb.pjb02
           AND pjj04 = l_pjb.pjb01
     ELSE
        SELECT MIN(pjk22) INTO sr.pjb17 FROM pjk_file,pjj_file,pjb_file  
         WHERE pjk01 = pjj01 AND pjk11 = l_pjb.pjb02
           AND pjj04 = l_pjb.pjb01
        SELECT MAX(pjk23) INTO sr.pjb18 FROM pjk_file,pjj_file,pjb_file  
         WHERE pjk01 = pjj01 AND pjk11 = l_pjb.pjb02
           AND pjj04 = l_pjb.pjb01
     END IF
 
     LET l_sql="SELECT pjb_file.*,pjk_file.* FROM pjb_file,pjj_file,pjk_file",
#              " WHERE ",g_wc CLIPPED, 
               " WHERE pjb01 = '",l_pjb.pjb01,"'", 
               "   AND pjb02 = '",l_pjb.pjb02,"'", 
               "   AND pjb01 = pjj04",
               "   AND pjj01 = pjk01",
               "   AND pjb02 = pjk11",
               "   AND pjb09 = 'Y' ",
               "   AND pjb25 = 'Y' "
 
     DECLARE p600_cur4 CURSOR FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     FOREACH p600_cur4 INTO l_pjb.*,l_pjk.*
       IF STATUS THEN
          LET g_success='N'
          CALL cl_err('foreach p600_cur4',STATUS,1)
          EXIT FOREACH
       END IF
       SELECT SUM(pjk12) INTO l_sum 
         FROM pjk_file WHERE pjk01 = l_pjk.pjk01
          AND pjk02 = l_pjk.pjk02 AND pjk11 = l_pjk.pjk11
       LET l_rate = l_pjk.pjk12/l_sum
       LET l_pjb14 = l_rate *l_pjk.pjk08 
       INSERT INTO x VALUES(l_pjb.pjb01,l_pjb.pjb02,l_pjb14)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
          LET g_success='N' 
          EXIT FOREACH                                                                                                            
       END IF
     END FOREACH
     
     IF g_success='Y' THEN
       SELECT SUM(x3) INTO sr.pjb14 FROM x WHERE x1 = l_pjb.pjb01
          AND x2 = l_pjb.pjb02
       LET sr.pjb24 = g_today
       UPDATE pjb_file SET #pjb14 = sr.pjb14,  #MOD-930119 pjb14不可update
                           pjb17 = sr.pjb17,
                           pjb18 = sr.pjb18,
                           #pjb19 = sr.pjb19,  #MOD-930119 pjb19不可update
                           #pjb20 = sr.pjb20,  #MOD-930119 pjb20不可update
                           pjb24 = sr.pjb24
              WHERE pjb01 = l_pjb.pjb01
                AND pjb02 = l_pjb.pjb02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","pjb_file","","",SQLCA.sqlcode,"","",1)
           LET g_success='N' 
           EXIT FOREACH                                                                                                            
        END IF
     END IF   
      
  END FOREACH
  
  LET l_sql="SELECT * FROM pjb_file",
            " WHERE ",g_wc CLIPPED, 
            "   AND pjb09 = 'N' ",
            "   ORDER BY pjb04 DESC"
 
  DECLARE p600_cur2 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p600_cur2 INTO l_pjb.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p600_cur2',STATUS,1)
        EXIT FOREACH
     END IF
     SELECT COUNT(*) INTO l_n FROM pjb_file 
      WHERE pjb06 = l_pjb.pjb02
        AND pjb01 = l_pjb.pjb01
        AND pjb04 > l_pjb.pjb04
        AND pjb19 IS NULL
     IF l_n > 0 THEN
        LET sr.pjb19 = NULL
     ELSE
       SELECT MIN(pjb19) INTO sr.pjb19 FROM pjb_file
        WHERE pjb06 = l_pjb.pjb02
          AND pjb01 = l_pjb.pjb01
          AND pjb04 > l_pjb.pjb04
     END IF
     SELECT COUNT(*) INTO l_n FROM pjb_file 
      WHERE pjb06 = l_pjb.pjb02
        AND pjb01 = l_pjb.pjb01
        AND pjb04 > l_pjb.pjb04
        AND pjb20 IS NULL
     IF l_n > 0 THEN
        LET sr.pjb20 = NULL
     ELSE
        SELECT MIN(pjb20) INTO sr.pjb20 FROM pjb_file
        WHERE pjb06 = l_pjb.pjb02
          AND pjb01 = l_pjb.pjb01
          AND pjb04 > l_pjb.pjb04
     END IF
     SELECT MIN(pjb17) INTO sr.pjb17 FROM pjb_file
      WHERE pjb06 = l_pjb.pjb02
        AND pjb01 = l_pjb.pjb01
        AND pjb04 > l_pjb.pjb04
     SELECT MAX(pjb18) INTO sr.pjb18 FROM pjb_file
      WHERE pjb06 = l_pjb.pjb02
        AND pjb01 = l_pjb.pjb01
        AND pjb04 > l_pjb.pjb04
 
     IF g_success='Y' THEN
       LET sr.pjb24 = g_today
       UPDATE pjb_file SET #pjb14 = sr.pjb14,    #MOD-930119 pjb14不可update
                           pjb17 = sr.pjb17,
                           pjb18 = sr.pjb18,
                           #pjb19 = sr.pjb19,   #MOD-930119 pjb19不可update
                           #pjb20 = sr.pjb20,   #MOD-930119 pjb20不可update
                           pjb24 = sr.pjb24
              WHERE pjb01 = l_pjb.pjb01
                AND pjb02 = l_pjb.pjb02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","pjb_file","","",SQLCA.sqlcode,"","",1)
           LET g_success='N' 
           EXIT FOREACH                                                                                                            
        END IF
     END IF 
  END FOREACH
 
  LET l_sql="SELECT * FROM pjb_file",
            " WHERE ",g_wc CLIPPED, 
            "   AND pjb09 = 'Y' ",
            "   AND pjb25 = 'N' "
 
  DECLARE p600_cur3 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p600_cur3 INTO l_pjb.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p600_cur3',STATUS,1)
        EXIT FOREACH
     END IF
     LET sr.pjb17 = l_pjb.pjb15
     LET sr.pjb18 = l_pjb.pjb16
     IF g_success='Y' THEN
       LET sr.pjb24 = g_today
       UPDATE pjb_file SET #pjb14 = sr.pjb14, #MOD-930119 pjb14不可pdate
                           pjb17 = sr.pjb17,
                           pjb18 = sr.pjb18,
                           #pjb19 = sr.pjb19, #MOD-930119 pjb19不可update
                           #pjb20 = sr.pjb20, #MOD-930119 pjb20不可update
                           pjb24 = sr.pjb24
              WHERE pjb01 = l_pjb.pjb01
                AND pjb02 = l_pjb.pjb02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","pjb_file","","",SQLCA.sqlcode,"","",1)
           LET g_success='N' 
           EXIT FOREACH                                                                                                            
        END IF
     END IF 
  END FOREACH
 
#滾算預估成本
  LET l_sql="SELECT * FROM pjb_file",
            " WHERE ",g_wc CLIPPED, 
            "   AND pjb09 = 'N' ",
            " ORDER BY pjb04 DESC"
 
  DECLARE p600_cur5 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p600_cur5 INTO l_pjb.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p600_cur5',STATUS,1)
        EXIT FOREACH
     END IF
    #DECLARE p600_cur5_1 CURSOR FROM l_sql      #MOD-B30125 mark
     DECLARE p600_cur5_1 CURSOR FOR             #MOD-B30125 add 
       SELECT pjb02,pjb04 FROM pjb_file  
        WHERE pjb01 = l_pjb.pjb01
          AND pjb06 = l_pjb.pjb02
        ORDER BY pjb04 DESC 
     FOREACH p600_cur5_1 INTO s_pjb.pjb02,s_pjb.pjb04
       IF STATUS THEN
          LET g_success='N'
          CALL cl_err('foreach p600_cur5',STATUS,1)
          EXIT FOREACH
       END IF
       SELECT SUM(pjda05) INTO l_sum2 FROM pjda_file
        WHERE pjda01 = s_pjb.pjb02
       SELECT count(*) INTO l_i FROM y 
        WHERE y1=l_pjb.pjb01 AND y2 = l_pjb.pjb02
       IF l_i =0 THEN
          INSERT INTO y VALUES(l_pjb.pjb01,l_pjb.pjb02,l_sum2)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("ins","y","","",SQLCA.sqlcode,"","",1)
             LET g_success='N' 
             EXIT FOREACH                                                                                                            
          END IF
       ELSE
          SELECT SUM(y3) INTO l_sum3 FROM y
           WHERE y1=l_pjb.pjb01 AND y2 = l_pjb.pjb02
          LET l_sum2 = l_sum3+l_sum2
          UPDATE y SET y3 = l_sum2
           WHERE y1=l_pjb.pjb01 AND y2 = l_pjb.pjb02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","y","","",SQLCA.sqlcode,"","",1)
             LET g_success='N' 
             EXIT FOREACH                                                                                                            
          END IF
       END IF
     END FOREACH
 
     IF g_success='Y' THEN
       LET sr.pjb24 = g_today
       UPDATE pjb_file SET #pjb14 = sr.pjb14,   #MOD-930119 pjb14不可update
                           pjb17 = sr.pjb17,
                           pjb18 = sr.pjb18,
                           #pjb19 = sr.pjb19,   #MOD-930119 pjb19不可update
                           #pjb20 = sr.pjb20,   #MOD-930119 pjb20不可update
                           pjb24 = sr.pjb24
              WHERE pjb01 = l_pjb.pjb01
                AND pjb02 = l_pjb.pjb02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","pjb_file","","",SQLCA.sqlcode,"","",1)
           LET g_success='N' 
           EXIT FOREACH                                                                                                            
        END IF
     END IF 
  END FOREACH
 
END FUNCTION
#No.FUN-790025
