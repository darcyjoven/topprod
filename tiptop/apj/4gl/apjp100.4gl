# Prog. Version..: '5.30.06-13.03.18(00008)'     #
#
# Pattern name...: apjp100.4gl
# Descriptions...: WBS累計預計需求資源推算作業
# Date & Author..: No.FUN-790025 07/12/05 By douzh
# Modify.........: No.TQC-840009 08/04/09 By douzh 費用金額已科目區分
# Modify.........: No.MOD-840470 08/04/22 By douzh 重算(滾算)WBS耗用資源(包括WBS下階所有WBS和活動的消耗)
# Modify.........: No.MOD-930104 09/03/10 By rainy MISC料件無轉出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A70128 10/12/23 By lixia dateadd相關修改
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-B70166 11/07/21 By lixia 增加開窗查詢
# Modify.........: No.TQC-B80007 11/08/01 By lixia 執行完成后右下方信息清空
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.MOD-B80214 12/01/16 By Vampire 截止月份小於起始月份會呈現負數，以致於後續迴圈無法執行
# Modify.........: No:CHI-CA0064 13/02/23 By Elise TQC-B90211 mark處改抓apji020

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_pja01         LIKE pja_file.pja01 
DEFINE  g_pja01_t       LIKE pja_file.pja01 
DEFINE  g_pja05         LIKE pja_file.pja05 
DEFINE  g_pja05_t       LIKE pja_file.pja05 
DEFINE  g_pja08         LIKE pja_file.pja08 
DEFINE  g_pja08_t       LIKE pja_file.pja08 
DEFINE  tm              RECORD 
         a              LIKE bgq_file.bgq01
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
        CALL apjp100(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL p100_process()
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
              CLOSE WINDOW apjp100_w
              EXIT WHILE
           END IF
         ELSE
           CONTINUE WHILE
         END IF
     ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p100_process()
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
 
FUNCTION apjp100(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5
    DEFINE  lc_cmd         STRING
    DEFINE  l_cnt          LIKE type_file.num5
    DEFINE  l_zz08         LIKE zz_file.zz08
 
   OPEN WINDOW apjp100_w WITH FORM "apj/42f/apjp100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      ERROR ""         #TQC-B80007
      LET g_bgjob = 'N'
 
      CONSTRUCT BY NAME g_wc ON pja01,pja05,pja08
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pja01) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pja"
               LET g_qryparam.default1 = g_pja01
               CALL cl_create_qry() RETURNING g_pja01
               DISPLAY g_pja01 TO pja01
               NEXT FIELD pja01
            #TQC-B70166--add--str--
            WHEN INFIELD(pja08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_pja08
               DISPLAY g_pja08 TO pja08
               NEXT FIELD pja08
            #TQC-B70166--add--end--
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
      CLOSE WINDOW apjp100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_bgjob = 'N' 
 
   INPUT BY NAME tm.a,g_bgjob WITHOUT DEFAULTS
 
   AFTER INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0            
         CLOSE WINDOW p100_w          
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
         CLOSE WINDOW p100_w
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
      WHERE zz01 = "apjp100"
     IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
        CALL cl_err('apjp100','9031',1)  
     ELSE
        LET lc_cmd = l_zz08 CLIPPED,
                     " ''",
                     " '",g_wc CLIPPED,"'",
                     " '",tm.a CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('apjp100',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW apjp100_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
   END IF
   EXIT WHILE
 
   ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION p100_process()
DEFINE l_sql      STRING
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_pjb02    LIKE pjb_file.pjb02
DEFINE l_pjb04    LIKE pjb_file.pjb04
DEFINE l_pjb09    LIKE pjb_file.pjb09
DEFINE l_pjb25    LIKE pjb_file.pjb25
DEFINE l_pjfa05   LIKE pjfa_file.pjfa05
DEFINE l_pjfb06   LIKE pjfb_file.pjfb06
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  LET l_sql="SELECT UNIQUE(pjb02),pjb04,pjb09,pjb25 FROM pja_file,pjb_file ",
            " WHERE pja01=pjb01 AND pjaconf='Y' AND pjaclose='N'",
            " AND ",g_wc CLIPPED,
            " ORDER BY pjb04 DESC"   
 
  PREPARE p100_pb FROM l_sql
  DECLARE p100_cur CURSOR FOR p100_pb
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p100_cur INTO l_pjb02,l_pjb04,l_pjb09,l_pjb25
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cur',STATUS,1)
        EXIT FOREACH
     END IF
     DELETE FROM pjf_file WHERE pjf01= l_pjb02
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err('',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     DELETE FROM pjh_file WHERE pjh01= l_pjb02
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err('',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     DELETE FROM pjm_file WHERE pjm01= l_pjb02
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err('',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     DELETE FROM pjd_file WHERE pjd01= l_pjb02
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err('',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
#No.MOD-840470--begin  
        IF g_success = 'Y' THEN
           CALL p100_p1(l_pjb02,l_pjb09,l_pjb25)
        END IF
        IF g_success = 'Y' THEN
           CALL p100_p2(l_pjb02,l_pjb09,l_pjb25)
        END IF
        IF g_success = 'Y' THEN
           CALL p100_p3(l_pjb02,l_pjb09,l_pjb25)
        END IF
        IF g_success = 'Y' THEN
           CALL p100_p4(l_pjb02,l_pjb09,l_pjb25)
        END IF
#No.MOD-840470--end
  END FOREACH
  IF g_success='Y' THEN 
     CALL p100_ys()
  END IF
END FUNCTION
 
FUNCTION p100_p1(p_pjb02,p_pjb09,p_pjb25)    #累計材料需求  #No.MOD-840470 
DEFINE p_pjb02   LIKE  pjb_file.pjb02
DEFINE p_pjb09   LIKE  pjb_file.pjb09    #No.MOD-840470
DEFINE p_pjb25   LIKE  pjb_file.pjb25    #No.MOD-840470
DEFINE l_sql     STRING
DEFINE l_pjfa03  LIKE pjfa_file.pjfa03
DEFINE l_pjfa04  LIKE pjfa_file.pjfa04
DEFINE l_pjfa05  LIKE pjfa_file.pjfa05
DEFINE l_pjfa06  LIKE pjfa_file.pjfa06
DEFINE l_pjfb04  LIKE pjfb_file.pjfb04
DEFINE l_pjfb05  LIKE pjfb_file.pjfb05
DEFINE l_pjfb06  LIKE pjfb_file.pjfb06
DEFINE l_pjfb07  LIKE pjfb_file.pjfb07
DEFINE l_pjf02   LIKE pjf_file.pjf02
DEFINE l_pjb02_2 LIKE pjb_file.pjb02     #No.MOD-840470
DEFINE l_pjf     RECORD LIKE pjf_file.*  #No.MOD-840470
DEFINE l_n       LIKE type_file.num5     #No.MOD-840470
DEFINE l_sum     LIKE pjf_file.pjf05     #No.MOD-840470
 
  #計算當前WBS下材料需求
  LET l_sql="SELECT pjfa03,pjfa04,SUM(COALESCE(pjfa05,0)),pjfa06 FROM pjfa_file,ima_file ",
            " WHERE pjfa01 = '",p_pjb02,"' ",
            " AND pjfa03 = ima01 ",
            #" AND ima08 !='Z' ",      #MOD-930104 remark
            " GROUP BY pjfa03,pjfa04,pjfa06"
 
  PREPARE p100_pb1 FROM l_sql
  DECLARE p100_cs1_a CURSOR FOR p100_pb1
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p100_cs1_a INTO l_pjfa03,l_pjfa04,l_pjfa05,l_pjfa06
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cs1_a',STATUS,1)
        EXIT FOREACH
     END IF
     SELECT max(pjf02)+1 INTO l_pjf02 FROM pjf_file WHERE pjf01 = p_pjb02
     IF l_pjf02 IS NULL THEN LET l_pjf02 = 1 END IF
     INSERT INTO pjf_file(pjf01,pjf02,pjf03,pjf04,pjf05,pjf06,pjf07)
         VALUES(p_pjb02,l_pjf02,l_pjfa03,l_pjfa04,l_pjfa05,l_pjfa06,'0')
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("ins","pjf_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
        EXIT FOREACH
     END IF
  END FOREACH
 
  #計算WBS下活動材料需求
  IF p_pjb25='Y' THEN    #帶活動
     LET l_sql="SELECT pjfb04,pjfb05,SUM(COALESCE(pjfb06,0)),pjfb07 FROM pjfb_file,pjk_file,ima_file ",
               " WHERE pjfb01 = pjk01 ",
               " AND pjfb02 = pjk02 ",
               " AND pjk11 = '",p_pjb02,"' ",
               " AND pjfb04 = ima01 ",
              # " AND ima08 !='Z' ",     #MOD-930104 remark
               " GROUP BY pjfb04,pjfb05,pjfb07"
 
     DECLARE p100_cs1_b CURSOR FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     FOREACH p100_cs1_b INTO l_pjfb04,l_pjfb05,l_pjfb06,l_pjfb07
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs1_b',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT max(pjf02)+1 INTO l_pjf02 FROM pjf_file WHERE pjf01 = p_pjb02
        IF l_pjf02 IS NULL THEN LET l_pjf02 = 1 END IF
        INSERT INTO pjf_file(pjf01,pjf02,pjf03,pjf04,pjf05,pjf06,pjf07)
             VALUES(p_pjb02,l_pjf02,l_pjfb04,l_pjfb05,l_pjfb06,l_pjfb07,'0')
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           CALL cl_err3("ins","pjf_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
           EXIT FOREACH
        END IF
     END FOREACH
  END IF
 
#No.MOD-840470--begin
  IF p_pjb09 ='N' THEN       #WBS為非尾階WBS編碼,則找下階WBS材料需求
     LET l_sql="SELECT pjb02 FROM pjb_file ",
            " WHERE pjb06 = '",p_pjb02,"' " 
 
     PREPARE p100_pb1_c FROM l_sql
     DECLARE p100_cs1_c CURSOR FOR p100_pb1_c
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs1_c INTO l_pjb02_2
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs1_c',STATUS,1)
           EXIT FOREACH
        END IF
        #下階WBS的材料需求
        LET l_sql ="SELECT * FROM pjf_file",
            " WHERE pjf01 = '",l_pjb02_2,"' " 
        PREPARE p100_pb1_c_1 FROM l_sql
        DECLARE p100_cs1_c_1 CURSOR FOR p100_pb1_c_1
        FOREACH p100_cs1_c_1 INTO l_pjf.*
           IF STATUS THEN
              LET g_success='N'
              CALL cl_err('foreach p100_cs1_c_1',STATUS,1)
              EXIT FOREACH
           END IF
           SELECT COUNT(*) INTO l_n FROM pjf_file
            WHERE pjf01=p_pjb02 AND pjf02=l_pjf.pjf02
              AND pjf03=l_pjf.pjf03 AND pjf04=l_pjf.pjf04
              AND pjf06=l_pjf.pjf06 
           IF l_n=0 THEN
              SELECT max(pjf02)+1 INTO l_pjf.pjf02 FROM pjf_file WHERE pjf01 = p_pjb02
              IF l_pjf.pjf02 IS NULL THEN LET l_pjf.pjf02 = 1 END IF
              INSERT INTO pjf_file(pjf01,pjf02,pjf03,pjf04,pjf05,pjf06,pjf07)
                   VALUES(p_pjb02,l_pjf.pjf02,l_pjf.pjf03,l_pjf.pjf04,l_pjf.pjf05,
                          l_pjf.pjf06,l_pjf.pjf07)
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("ins","pjf_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           ELSE
              SELECT SUM(pjf05) INTO l_sum FROM pjf_file
               WHERE pjf01=p_pjb02 AND pjf02=l_pjf.pjf02
                 AND pjf03=l_pjf.pjf03 AND pjf04=l_pjf.pjf04
                 AND pjf06=l_pjf.pjf06 
              LET l_pjf.pjf05 = l_pjf.pjf05+l_sum
              UPDATE pjf_file SET pjf05 = l_pjf.pjf05
               WHERE pjf01=p_pjb02 AND pjf02=l_pjf.pjf02
                 AND pjf03=l_pjf.pjf03 AND pjf04=l_pjf.pjf04
                 AND pjf06=l_pjf.pjf06 
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("upd","pjf_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           END IF
        END FOREACH
     END FOREACH
  END IF
#No.MOD-840470--end
 
END FUNCTION
 
FUNCTION p100_p2(p_pjb02,p_pjb09,p_pjb25)    #累計人力需求
DEFINE p_pjb02   LIKE  pjb_file.pjb02
DEFINE p_pjb09   LIKE  pjb_file.pjb09    #No.MOD-840470
DEFINE p_pjb25   LIKE  pjb_file.pjb25    #No.MOD-840470
DEFINE l_sql     STRING
DEFINE l_pjha03  LIKE  pjha_file.pjha03
DEFINE l_pjha04  LIKE  pjha_file.pjha04
DEFINE l_pjhb04  LIKE  pjhb_file.pjhb04
DEFINE l_pjhb05  LIKE  pjhb_file.pjhb05
DEFINE l_pjb02_2 LIKE pjb_file.pjb02     #No.MOD-840470
DEFINE l_pjh     RECORD LIKE pjh_file.*  #No.MOD-840470
DEFINE l_n       LIKE type_file.num5     #No.MOD-840470
DEFINE l_sum     LIKE pjh_file.pjh03     #No.MOD-840470
 
  LET l_sql="SELECT pjha03,SUM(COALESCE(pjha04,0)) FROM pjha_file ",
            " WHERE pjha01 = '",p_pjb02,"' ",
            " GROUP BY pjha01,pjha03"
 
  PREPARE p100_pb2 FROM l_sql
  DECLARE p100_cs2_a CURSOR FOR p100_pb2
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
  
  FOREACH p100_cs2_a INTO l_pjha03,l_pjha04
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cs2_a',STATUS,1)
        EXIT FOREACH
     END IF
     INSERT INTO pjh_file(pjh01,pjh02,pjh03)
          VALUES(p_pjb02,l_pjha03,l_pjha04)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("ins","pjh_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
        EXIT FOREACH
     END IF
  END FOREACH
 
  IF p_pjb25 = 'Y' THEN
     LET l_sql="SELECT pjhb04,SUM(COALESCE(pjhb05,0)) FROM pjhb_file,pjk_file ",
               " WHERE pjhb01 = pjk01 ",
               " AND pjhb02 = pjk02 ",
               " AND pjk11 = '",p_pjb02,"' ",
               " GROUP BY pjhb01,pjhb04"
 
     DECLARE p100_cs2_b CURSOR FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs2_b INTO l_pjhb04,l_pjhb05
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs2_b',STATUS,1)
           EXIT FOREACH
        END IF
        INSERT INTO pjh_file(pjh01,pjh02,pjh03)
             VALUES(p_pjb02,l_pjhb04,l_pjhb05)
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           CALL cl_err3("ins","pjh_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
           EXIT FOREACH
        END IF
     END FOREACH
  END IF
 
#No.MOD-840470--begin
  IF p_pjb09 ='N' THEN       #WBS為非尾階WBS編碼,則找下階WBS材料需求
     LET l_sql="SELECT pjb02 FROM pjb_file ",
            " WHERE pjb06 = '",p_pjb02,"' " 
 
     PREPARE p100_pb2_c FROM l_sql
     DECLARE p100_cs2_c CURSOR FOR p100_pb2_c
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs2_c INTO l_pjb02_2
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs2_c',STATUS,1)
           EXIT FOREACH
        END IF
        #下階WBS的材料需求
        LET l_sql ="SELECT * FROM pjh_file",
            " WHERE pjh01 = '",l_pjb02_2,"' " 
        PREPARE p100_pb2_c_1 FROM l_sql
        DECLARE p100_cs2_c_1 CURSOR FOR p100_pb2_c_1
        FOREACH p100_cs2_c_1 INTO l_pjh.*
           IF STATUS THEN
              LET g_success='N'
              CALL cl_err('foreach p100_cs2_c_1',STATUS,1)
              EXIT FOREACH
           END IF
           SELECT COUNT(*) INTO l_n FROM pjh_file 
            WHERE pjh01=p_pjb02 AND pjh02 = l_pjh.pjh02
           IF l_n =0 THEN
              INSERT INTO pjh_file(pjh01,pjh02,pjh03)
                   VALUES(p_pjb02,l_pjh.pjh02,l_pjh.pjh03)
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("ins","pjh_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           ELSE
              SELECT SUM(pjh03) INTO l_sum FROM pjh_file
               WHERE pjh01=p_pjb02 AND pjh02 = l_pjh.pjh02
              LET l_pjh.pjh03 = l_pjh.pjh03 + l_sum
              UPDATE pjh_file SET pjh03 = l_pjh.pjh03
               WHERE pjh01 = p_pjb02
                 AND pjh02 = l_pjh.pjh02
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("upd","pjh_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           END IF
        END FOREACH
     END FOREACH
  END IF
#No.MOD-840470--end
 
END FUNCTION
 
FUNCTION p100_p3(p_pjb02,p_pjb09,p_pjb25)    #累計設備需求
DEFINE p_pjb02   LIKE  pjb_file.pjb02
DEFINE p_pjb09   LIKE  pjb_file.pjb09    #No.MOD-840470
DEFINE p_pjb25   LIKE  pjb_file.pjb25    #No.MOD-840470
DEFINE l_sql     STRING
DEFINE l_pjma03  LIKE  pjma_file.pjma03
DEFINE l_pjma04  LIKE  pjma_file.pjma04
DEFINE l_pjma05  LIKE  pjma_file.pjma05
DEFINE l_pjmb04  LIKE  pjmb_file.pjmb04
DEFINE l_pjmb05  LIKE  pjmb_file.pjmb05
DEFINE l_pjmb06  LIKE  pjmb_file.pjmb06
DEFINE l_pjb02_2 LIKE pjb_file.pjb02     #No.MOD-840470
DEFINE l_pjm     RECORD LIKE pjm_file.*  #No.MOD-840470
DEFINE l_n       LIKE type_file.num5     #No.MOD-840470
DEFINE l_sum1    LIKE pjm_file.pjm03     #No.MOD-840470
DEFINE l_sum2    LIKE pjm_file.pjm04     #No.MOD-840470
 
  LET l_sql="SELECT pjma03,SUM(COALESCE(pjma04,0)),SUM(COALESCE(pjma05,0)) FROM pjma_file ",
            " WHERE pjma01 = '",p_pjb02,"' ",
            " GROUP BY pjma01,pjma03"
            
  PREPARE p100_pb3 FROM l_sql
  DECLARE p100_cs3_a CURSOR FOR p100_pb3
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
  
  FOREACH p100_cs3_a INTO l_pjma03,l_pjma04,l_pjma05
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cs3_a',STATUS,1)
        EXIT FOREACH
     END IF
     
     INSERT INTO pjm_file(pjm01,pjm02,pjm03,pjm04)
          VALUES(p_pjb02,l_pjma03,l_pjma04,l_pjma05)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("ins","pjm_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
        EXIT FOREACH
     END IF
  END FOREACH
  
  IF p_pjb25='Y' THEN
     LET l_sql="SELECT pjmb04,SUM(COALESCE(pjmb05,0)),SUM(COALESCE(pjmb06,0)) FROM pjmb_file,pjk_file ",
               " WHERE pjmb01 = pjk01 ",
               "  AND pjmb02 = pjk02 ",
               "  AND pjk11 = '",p_pjb02,"' ",
               " GROUP BY pjmb01,pjmb04"
 
     DECLARE p100_cs3_b CURSOR FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs3_b INTO l_pjmb04,l_pjmb05,l_pjmb06
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs3_b',STATUS,1)
           EXIT FOREACH
        END IF
        INSERT INTO pjm_file(pjm01,pjm02,pjm03,pjm04)
             VALUES(p_pjb02,l_pjmb04,l_pjmb05,l_pjmb06)
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           CALL cl_err3("ins","pjm_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
           EXIT FOREACH
        END IF
     END FOREACH
  END IF
 
#No.MOD-840470--begin
  IF p_pjb09 ='N' THEN       #WBS為非尾階WBS編碼,則找下階WBS材料需求
     LET l_sql="SELECT pjb02 FROM pjb_file ",
            " WHERE pjb06 = '",p_pjb02,"' " 
 
     PREPARE p100_pb3_c FROM l_sql
     DECLARE p100_cs3_c CURSOR FOR p100_pb3_c
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs3_c INTO l_pjb02_2
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs3_c',STATUS,1)
           EXIT FOREACH
        END IF
        #下階WBS的材料需求
        LET l_sql ="SELECT * FROM pjm_file",
            " WHERE pjm01 = '",l_pjb02_2,"' " 
        PREPARE p100_pb3_c_1 FROM l_sql
        DECLARE p100_cs3_c_1 CURSOR FOR p100_pb3_c_1
        FOREACH p100_cs3_c_1 INTO l_pjm.*
           IF STATUS THEN
              LET g_success='N'
              CALL cl_err('foreach p100_cs3_c_1',STATUS,1)
              EXIT FOREACH
           END IF
           SELECT COUNT(*) INTO l_n FROM pjm_file 
            WHERE pjm01=p_pjb02 AND pjm02 = l_pjm.pjm02
           IF l_n =0 THEN
              INSERT INTO pjm_file(pjm01,pjm02,pjm03,pjm04)
                            VALUES(p_pjb02,l_pjm.pjm02,
                                   l_pjm.pjm03,l_pjm.pjm04)
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("ins","pjm_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           ELSE
              SELECT SUM(pjm03),SUM(pjm04) INTO l_sum1,l_sum2 FROM pjm_file
               WHERE pjm01=p_pjb02 AND pjm02 = l_pjm.pjm02
              LET l_pjm.pjm03 = l_pjm.pjm03 + l_sum1
              LET l_pjm.pjm04 = l_pjm.pjm04 + l_sum2
              UPDATE pjm_file SET pjm03 = l_pjm.pjm03,
                                  pjm04 = l_pjm.pjm04
               WHERE pjm01 = p_pjb02
                 AND pjm02 = l_pjm.pjm02
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("upd","pjm_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           END IF
        END FOREACH
     END FOREACH
  END IF
#No.MOD-840470--end
 
END FUNCTION
 
FUNCTION p100_p4(p_pjb02,p_pjb09,p_pjb25)    #累計預估費用
DEFINE p_pjb02   LIKE  pjb_file.pjb02
DEFINE p_pjb09   LIKE  pjb_file.pjb09    #No.MOD-840470
DEFINE p_pjb25   LIKE  pjb_file.pjb25    #No.MOD-840470
DEFINE l_sql     STRING
DEFINE l_pjda02  LIKE  pjda_file.pjda02
DEFINE l_pjda03  LIKE  pjda_file.pjda03
DEFINE l_pjda04  LIKE  pjda_file.pjda04
DEFINE l_pjda05  LIKE  pjda_file.pjda05
DEFINE l_pjdb03  LIKE  pjdb_file.pjdb03
DEFINE l_pjdb04  LIKE  pjdb_file.pjdb04
DEFINE l_pjdb05  LIKE  pjdb_file.pjdb05
DEFINE l_pjdb06  LIKE  pjdb_file.pjdb06
DEFINE l_pjb02_2 LIKE pjb_file.pjb02     #No.MOD-840470
DEFINE l_pjd     RECORD LIKE pjd_file.*  #No.MOD-840470
DEFINE l_n       LIKE type_file.num5     #No.MOD-840470
DEFINE l_sum     LIKE pjd_file.pjd05     #No.MOD-840470
 
  LET l_sql="SELECT pjda02,pjda03,pjda04,SUM(COALESCE(pjda05,0)) FROM pjda_file ",
            " WHERE pjda01 = '",p_pjb02,"' ",
            " GROUP BY pjda01,pjda02,pjda03,pjda04"
 
  PREPARE p100_pb4 FROM l_sql
  DECLARE p100_cs4_a CURSOR FOR p100_pb4
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
  
  FOREACH p100_cs4_a INTO l_pjda02,l_pjda03,l_pjda04,l_pjda05
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cs4_a',STATUS,1)
        EXIT FOREACH
     END IF
     IF l_pjda04 IS NULL THEN
        LET l_pjda04 = " "
     END IF
     INSERT INTO pjd_file(pjd01,pjd02,pjd03,pjd04,pjd05)
          VALUES(p_pjb02,l_pjda02,l_pjda03,l_pjda04,l_pjda05)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("ins","pjd_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
        EXIT FOREACH
     END IF
  END FOREACH
 
  IF p_pjb25 ='Y' THEN
     LET l_sql="SELECT pjdb03,pjdb04,pjdb05,pjdb06 FROM pjdb_file,pjk_file ",
               " WHERE pjdb01 = pjk01 ",
               "   AND pjdb02 = pjk02 ",
               "  	AND pjk11 = '",p_pjb02,"' ",
               " GROUP BY pjdb01,pjdb02,pjdb03,pjdb04,pjdb05,pjdb06"
 
     DECLARE p100_cs4_b CURSOR FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs4_b INTO l_pjdb03,l_pjdb04,l_pjdb05,l_pjdb06
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs4_b',STATUS,1)
           EXIT FOREACH
        END IF
        IF l_pjdb05 IS NULL THEN
           LET l_pjdb05 = " "
        END IF
        INSERT INTO pjd_file(pjd01,pjd02,pjd03,pjd04,pjd05)
             VALUES(p_pjb02,l_pjdb03,l_pjdb04,l_pjdb05,l_pjdb06)
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           CALL cl_err3("ins","pjd_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
           EXIT FOREACH
        END IF
     END FOREACH
  END IF
 
#No.MOD-840470--begin
  IF p_pjb09 ='N' THEN       #WBS為非尾階WBS編碼,則找下階WBS材料需求
     LET l_sql="SELECT pjb02 FROM pjb_file ",
            " WHERE pjb06 = '",p_pjb02,"' " 
 
     PREPARE p100_pb4_c FROM l_sql
     DECLARE p100_cs4_c CURSOR FOR p100_pb4_c
     IF SQLCA.sqlcode THEN 
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
  
     FOREACH p100_cs4_c INTO l_pjb02_2
        IF STATUS THEN
           LET g_success='N'
           CALL cl_err('foreach p100_cs4_c',STATUS,1)
           EXIT FOREACH
        END IF
        #下階WBS的材料需求
        LET l_sql ="SELECT * FROM pjd_file",
            " WHERE pjd01 = '",l_pjb02_2,"' " 
        PREPARE p100_pb4_c_1 FROM l_sql
        DECLARE p100_cs4_c_1 CURSOR FOR p100_pb4_c_1
        FOREACH p100_cs4_c_1 INTO l_pjd.*
           IF STATUS THEN
              LET g_success='N'
              CALL cl_err('foreach p100_cs4_c_1',STATUS,1)
              EXIT FOREACH
           END IF
           SELECT COUNT(*) INTO l_n FROM pjd_file
            WHERE pjd01=p_pjb02 AND pjd02=l_pjd.pjd02
              AND pjd03=l_pjd.pjd03 AND pjd04=l_pjd.pjd04
           IF l_n=0 THEN
              INSERT INTO pjd_file(pjd01,pjd02,pjd03,pjd04,pjd05)
                   VALUES(p_pjb02,l_pjd.pjd02,l_pjd.pjd03,
                          l_pjd.pjd04,l_pjd.pjd05)
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("ins","pjd_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           ELSE
              SELECT SUM(pjd05) INTO l_sum FROM pjd_file
               WHERE pjd01=p_pjb02 AND pjd02=l_pjd.pjd02
                 AND pjd03=l_pjd.pjd03 AND pjd04=l_pjd.pjd04
              LET l_pjd.pjd05 = l_pjd.pjd05+l_sum
              UPDATE pjd_file SET pjd05 = l_pjd.pjd05
               WHERE pjd01=p_pjb02 AND pjd02=l_pjd.pjd02
                 AND pjd03=l_pjd.pjd03 AND pjd04=l_pjd.pjd04
              IF SQLCA.sqlcode THEN 
                 LET g_success = 'N'
                 CALL cl_err3("upd","pjd_file",p_pjb02,"",SQLCA.sqlcode,"","",1)
                 RETURN
              END IF
           END IF
        END FOREACH
     END FOREACH
  END IF
#No.MOD-840470--end
END FUNCTION
 
FUNCTION p100_ys()    #項目制造生成預算
DEFINE sr RECORD
          temp01  LIKE type_file.num5,
          temp02  LIKE type_file.num5,
          temp03  LIKE aag_file.aag01,
          temp04  LIKE type_file.chr10,
          temp05  LIKE type_file.num20_6,
          temp06  LIKE type_file.chr10,
          temp07  LIKE type_file.chr30,
          temp08  LIKE type_file.chr4  
          END RECORD
DEFINE sr_bgq RECORD
          temp01  LIKE type_file.num5,
          temp02  LIKE type_file.num5,
          temp03  LIKE aag_file.aag01,
          temp04  LIKE type_file.chr10,
          temp05  LIKE type_file.num20_6,
          temp06  LIKE type_file.chr10,
          temp07  LIKE type_file.chr30,
          temp08  LIKE type_file.chr4  
          END RECORD
DEFINE l_pja01    LIKE pja_file.pja01
DEFINE l_pja09    LIKE pja_file.pja09
DEFINE l_pjb02    LIKE pjb_file.pjb02
DEFINE l_pjb15    LIKE pjb_file.pjb15
DEFINE l_pjb16    LIKE pjb_file.pjb16
DEFINE l_pja10    LIKE pja_file.pja10
DEFINE l_pja11    LIKE pja_file.pja11
DEFINE l_pjf      RECORD LIKE pjf_file.*
DEFINE l_pjh      RECORD LIKE pjh_file.*
DEFINE l_pjm      RECORD LIKE pjm_file.*
DEFINE l_pjd      RECORD LIKE pjd_file.*
DEFINE l_bgq      RECORD LIKE bgq_file.*
DEFINE l_ima25    LIKE ima_file.ima25
DEFINE l_ima39    LIKE ima_file.ima39
DEFINE l_ima44    LIKE ima_file.ima44
DEFINE l_ima53    LIKE ima_file.ima53
DEFINE l_sql      STRING
DEFINE l_amt1     LIKE type_file.num20_6
DEFINE l_amt2     LIKE type_file.num20_6
DEFINE l_amt3     LIKE type_file.num20_6
DEFINE l_n,i      LIKE type_file.num5
DEFINE l_dy       LIKE type_file.num5   #MOD-B80214 add
DEFINE l_bm,l_em  LIKE type_file.num5
DEFINE l_i        LIKE type_file.num5
DEFINE l_flag     LIKE type_file.num5
DEFINE l_factor   LIKE ima_file.ima31_fac
DEFINE l_date1    LIKE type_file.dat
DEFINE l_date2    LIKE type_file.dat
DEFINE l_date3    LIKE type_file.dat
 
  DROP TABLE temptable
 
  CREATE TEMP TABLE temptable(
      temp01 LIKE type_file.num5,
      temp02 LIKE type_file.num5,
      temp03 LIKE aag_file.aag01,
      temp04 LIKE type_file.chr10,
      temp05 LIKE type_file.num20_6,
      temp06 LIKE type_file.chr10,
      temp07 LIKE type_file.chr30,
      temp08 LIKE type_file.chr4);
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  LET l_sql="SELECT pja01,pja09,pjb02,pjb15,pjb16,pja10,pja11 FROM pja_file,pjb_file ",
            " WHERE pja01=pjb01 AND pjaconf='Y' AND pjaclose='N'",
            " AND ",g_wc CLIPPED   
 
  DECLARE p100_cys CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p100_cys INTO l_pja01,l_pja09,l_pjb02,l_pjb15,l_pjb16,l_pja10,l_pja11
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cys',STATUS,1)
        EXIT FOREACH
     END IF
     LET l_n = 1
     LET l_dy= 0   #MOD-B80214 add
     IF l_pjb15 IS NOT NULL AND l_pjb16 IS NOT NULL THEN
        LET l_bm=MONTH(l_pjb15)
        LET l_em=MONTH(l_pjb16)
        #MOD-B80214 --- modify --- start ---
        IF YEAR(l_pjb16) > YEAR(l_pjb15) OR MONTH(l_pjb16) > MONTH(l_pjb15) THEN
           IF YEAR(l_pjb16) > YEAR(l_pjb15) THEN
              LET l_dy = YEAR(l_pjb16) - YEAR(l_pjb15)
           END IF
           LET l_em = l_em + (12 * l_dy)
        END IF
        #MOD-B80214 --- modify ---  end  ---
        LET l_n = l_n+l_em-l_bm
     ELSE
        LET l_bm=MONTH(l_pja10)
        LET l_em=MONTH(l_pja11)
        #MOD-B80214 --- modify --- start ---
        IF YEAR(l_pja11) > YEAR(l_pja10) OR MONTH(l_pja11) > MONTH(l_pja10) THEN
           IF YEAR(l_pja11) > YEAR(l_pja10) THEN
              LET l_dy = YEAR(l_pja11) - YEAR(l_pja10)
           END IF
           LET l_em = l_em + (12 * l_dy)
        END IF
        #MOD-B80214 --- modify ---  end  ---
        LET l_n = l_n+l_em-l_bm
     END IF
 
  #材料需求   
     DECLARE p100_cys_1 CURSOR FOR
     SELECT * FROM pjf_file WHERE pjf01 = l_pjb02
     FOREACH p100_cys_1 INTO l_pjf.*
       IF STATUS THEN
          LET g_success='N'
          CALL cl_err('foreach p100_cys_1',STATUS,1)
          EXIT FOREACH
       END IF
       LET sr.temp01= YEAR(l_pjf.pjf06)    
       LET sr.temp02= MONTH(l_pjf.pjf06)    
       SELECT ima25,ima39,ima44,ima53 INTO l_ima25,l_ima39,l_ima44,l_ima53 
         FROM ima_file WHERE ima01 = l_pjf.pjf03
       LET sr.temp03=l_ima39
       LET sr.temp04=l_pja09
       CALL s_umfchk(l_pjf.pjf03,l_ima44,l_ima25) RETURNING l_flag,l_factor
       IF l_flag = '0' THEN
          LET sr.temp05 = l_pjf.pjf05 * l_ima53 * l_factor
       ELSE
          LET sr.temp05 = 0
       END IF
       LET sr.temp06=l_pja01
       LET sr.temp07=l_pjf.pjf01
       SELECT pju01 INTO sr.temp08 FROM pju_file WHERE pju00='0'
       IF sr.temp08 IS NULL THEN LET sr.temp08 = ' ' END IF
       INSERT INTO temptable VALUES(sr.*)
     END FOREACH
 
  #人力需求   
     DECLARE p100_cys_2 CURSOR FOR
     SELECT * FROM pjh_file WHERE pjh01 = l_pjb02
       FOR i =1 TO l_n
         FOREACH p100_cys_2 INTO l_pjh.*
           IF STATUS THEN
             LET g_success='N'
             CALL cl_err('foreach p100_cys_2',STATUS,1)
             EXIT FOREACH
           END IF
           SELECT SUM(pjx03*pjh03) INTO l_amt1 FROM pjh_file,pjx_file
            WHERE pjx01=pjh02 AND pjh01=l_pjb02 AND pjh02 = l_pjh.pjh02
           LET l_i = i-1
           IF l_pjb15 IS NOT NULL THEN
              #LET l_sql = "SELECT dateadd(month,",l_i CLIPPED,",'",l_pjb15 CLIPPED,"')" PREPARE add_mon1 FROM l_sql EXECUTE add_mon1 INTO l_date1
              CALL s_incmonth(l_pjb15,l_i) RETURNING l_date1 #TQC-A70128
           ELSE
              #LET l_sql = "SELECT dateadd(month,",l_i CLIPPED,",'",l_pja10 CLIPPED,"')" PREPARE add_mon11 FROM l_sql EXECUTE add_mon11 INTO l_date1
              CALL s_incmonth(l_pja10,l_i) RETURNING l_date1 #TQC-A70128
           END IF
           LET sr.temp01 = YEAR(l_date1)
           LET sr.temp02 = MONTH(l_date1)
           #-----TQC-B90211---------
           #SELECT czy07 INTO sr.temp03 FROM czy_file,pjx_file
           # WHERE czy01 = l_pja09 AND czy02 =pjx04
           #   AND czy03 = '1' AND czy04 ='1XXXXX'
           #   AND pjx01 = l_pjh.pjh02 
           #-----END TQC-B90211-----
          #CHI-CA0064---add---S
            SELECT pkb02 INTO sr.temp03 FROM pkb_file,pjx_file
             WHERE pkb01 = l_pja09
               AND pjx01 = l_pjh.pjh02
          #CHI-CA0064---add---E
           IF sr.temp03 IS NULL THEN LET sr.temp03 = ' ' END IF
           LET sr.temp04 = l_pja09
           LET sr.temp05 = l_amt1/l_n
           LET sr.temp06 = l_pja01
           LET sr.temp07 = l_pjh.pjh01
           SELECT pju02 INTO sr.temp08 FROM pju_file WHERE pju00='0'
           IF sr.temp08 IS NULL THEN LET sr.temp08 = ' ' END IF
           INSERT INTO temptable VALUES(sr.*)
         END FOREACH
       END FOR
 
  #設備需求   
     DECLARE p100_cys_3 CURSOR FOR
     SELECT * FROM pjm_file WHERE pjm01 = l_pjb02
       FOR i =1 TO l_n
         FOREACH p100_cys_3 INTO l_pjm.*
          IF STATUS THEN
             LET g_success='N'
             CALL cl_err('foreach p100_cys_3',STATUS,1)
             EXIT FOREACH
           END IF
           SELECT SUM(pjy04*pjm04) INTO l_amt2 FROM pjm_file,pjy_file
           WHERE pjy01=pjm02 AND pjm01=l_pjb02 AND pjm02 = l_pjm.pjm02
           LET l_i = i-1
           IF l_pjb15 IS NOT NULL THEN
              #LET l_sql = "SELECT dateadd(month,",l_i CLIPPED,",'",l_pjb15 CLIPPED,"')" PREPARE add_mon2 FROM l_sql EXECUTE add_mon2 INTO l_date2
              CALL s_incmonth(l_pjb15,l_i) RETURNING l_date2 #TQC-A70128
           ELSE
              #LET l_sql = "SELECT dateadd(month,",l_i CLIPPED,",'",l_pja10 CLIPPED,"')" PREPARE add_mon22 FROM l_sql EXECUTE add_mon22 INTO l_date2
              CALL s_incmonth(l_pja10,l_i) RETURNING l_date2 #TQC-A70128
           END IF
           LET sr.temp01 = YEAR(l_date2)
           LET sr.temp02 = MONTH(l_date2)
           LET sr.temp04 = l_pja09
           SELECT fab11 INTO sr.temp03 FROM fab_file,pjy_file
            WHERE fab01 =pjy05 AND pjy01 = l_pjm.pjm02
           LET sr.temp05 = l_amt2/l_n
           LET sr.temp06 = l_pja01
           LET sr.temp07 = l_pjm.pjm01
           SELECT pju03 INTO sr.temp08 FROM pju_file WHERE pju00='0'
           IF sr.temp08 IS NULL THEN LET sr.temp08 = ' ' END IF
           INSERT INTO temptable VALUES(sr.*)
         END FOREACH
       END FOR
 
  #費用需求   
     DECLARE p100_cys_4 CURSOR FOR
     SELECT * FROM pjd_file WHERE pjd01 = l_pjb02
       FOR i =1 TO l_n
         FOREACH p100_cys_4 INTO l_pjd.*
          IF STATUS THEN
             LET g_success='N'
             CALL cl_err('foreach p100_cys_4',STATUS,1)
             EXIT FOREACH
           END IF
           SELECT SUM(pjd05) INTO l_amt3 FROM pjd_file                  #No.TQC-840009
           WHERE pjd01=l_pjb02 AND pjd03 = l_pjd.pjd03                  #No.TQC-840009
           LET l_i = i-1
           IF l_pjb15 IS NOT NULL THEN
              #LET l_sql = "SELECT dateadd(month,",l_i CLIPPED,",'",l_pjb15 CLIPPED,"')" PREPARE add_mon3 FROM l_sql EXECUTE add_mon3 INTO l_date3
              CALL s_incmonth(l_pjb15,l_i) RETURNING l_date3 #TQC-A70128
           ELSE
              #LET l_sql = "SELECT dateadd(month,",l_i CLIPPED,",'",l_pja10 CLIPPED,"')" PREPARE add_mon33 FROM l_sql EXECUTE add_mon33 INTO l_date3
              CALL s_incmonth(l_pja10,l_i) RETURNING l_date3 #TQC-A70128
           END IF
           LET sr.temp01 = YEAR(l_date3)
           LET sr.temp02 = MONTH(l_date3)
           LET sr.temp03 = l_pjd.pjd03
           LET sr.temp04 = l_pja09
           LET sr.temp05 = l_amt3/l_n
           LET sr.temp06 = l_pja01
           LET sr.temp07 = l_pjd.pjd01
           SELECT pju04 INTO sr.temp08 FROM pju_file WHERE pju00='0'
           IF sr.temp08 IS NULL THEN LET sr.temp08 = ' ' END IF
           INSERT INTO temptable VALUES(sr.*)
         END FOREACH
       END FOR
  END FOREACH
 
  LET l_sql = "SELECT temp01,temp02,temp03,temp04,SUM(temp05),temp06,temp07,temp08",
              " FROM temptable",
              " GROUP BY temp01,temp02,temp03,temp04,temp06,temp07,temp08"
             
  DECLARE p100_cs_t CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
  FOREACH p100_cs_t INTO sr_bgq.*
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p100_cs_t',STATUS,1)
        EXIT FOREACH
     END IF
     LET  l_bgq.bgq01  = tm.a
     LET  l_bgq.bgq02  = sr_bgq.temp01
     LET  l_bgq.bgq03  = sr_bgq.temp02
     LET  l_bgq.bgq04  = sr_bgq.temp03
     LET  l_bgq.bgq05  = sr_bgq.temp04
     LET  l_bgq.bgq06  = sr_bgq.temp05
     LET  l_bgq.bgq061 = 0
     LET  l_bgq.bgq07  = sr_bgq.temp05
     LET  l_bgq.bgq08  = 0
     LET  l_bgq.bgq09  = ''
     LET  l_bgq.bgq051 = sr_bgq.temp06
     LET  l_bgq.bgq052 = sr_bgq.temp07
     LET  l_bgq.bgq053 = sr_bgq.temp08
     INSERT INTO bgq_file VALUES(l_bgq.*)
  END FOREACH
  
END FUNCTION
#No.FUN-790025
