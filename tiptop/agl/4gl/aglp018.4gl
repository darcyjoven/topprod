# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aglp018.4gl
# Descriptions...: 投资收益自动抵消作业
# Date & Author..: 2011/06/13 By lutingting
# Modify.........: No.FUN-B60134 11/06/27 By xjll 新增程式
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No.MOD-D30135 13/03/13 By fengmy 修改aag19取值

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm  RECORD
              y       LIKE aep_file.aep03, 
              m       LIKE aep_file.aep04,
              c       LIKE axa_file.axa01, 
              a       LIKE aag_file.aag01,
              b       LIKE aag_file.aag01,
              d       LIKE aac_file.aac01
           END RECORD
DEFINE tm1 RECORD
              wc      LIKE type_file.chr1000
           END RECORD
DEFINE g_dept         DYNAMIC ARRAY OF RECORD
                      axb04      LIKE axb_file.axb04,
                      axb05      LIKE axb_File.axb05,
                      axz08      LIKE axz_file.axz08   #关系人编号
                      END RECORD
DEFINE    g_before_input_done  LIKE type_file.num5 
DEFINE    g_axi                RECORD LIKE axi_file.*
DEFINE    g_axj                RECORD LIKE axj_file.* 
DEFINE    g_success            LIKE type_file.chr1 
DEFINE    l_flag               LIKE type_file.chr1
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

   CALL p018_tm()           

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p018_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000  
   DEFINE l_n            LIKE type_file.num5
   DEFINE l_axa02        LIKE axa_file.axa02
   DEFINE l_axa03        LIKE axa_file.axa03

   CALL s_dsmark(tm.c) 
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW p018_w1 AT p_row,p_col
     WITH FORM "agl/42f/aglp018"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                     
   CALL cl_ui_init()
   #使用預設帳別之幣別
   INITIALIZE tm.* TO NULL                                                    

   WHILE TRUE

      INPUT BY NAME tm.y,tm.m,tm.c,tm.a,tm.b,tm.d WITHOUT DEFAULTS
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()              
 
         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD y
            IF NOT cl_null(tm.y) THEN
               IF tm.y = 0 THEN
                  NEXT FIELD y
               END IF
            END IF
            
         AFTER FIELD m
            IF NOT cl_null(tm.m) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.y
               IF g_azm.azm02 = '1' THEN
                  IF tm.m > 12 OR tm.m < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m
                  END IF
               ELSE
                  IF tm.m > 13 OR tm.m < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD m
                  END IF
               END IF
            END IF
 
         AFTER FIELD c
            IF NOT cl_null(tm.c) THEN
               SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = tm.c 
               IF l_n = 0 THEN
                  CALL cl_err(tm.a,100,0)
                  NEXT FIELD c
               END IF
            ELSE
               NEXT FIELD c
            END IF
 
        AFTER FIELD a
           IF NOT cl_null(tm.a) THEN
              CALL p018_a(tm.a)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('a',g_errno,0)
                 NEXT FIELD a
              END IF
           ELSE
              NEXT FIELD a
           END IF 

        AFTER FIELD b
           IF NOT cl_null(tm.b) THEN
              CALL p018_a(tm.b)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('b',g_errno,0)
                 NEXT FIELD b
              END IF
           ELSE
              NEXT FIELD b
           END IF

        AFTER FIELD d
           IF NOT cl_null(tm.d) THEN
              CALL p018_d(tm.d)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('d',g_errno,0)
                 NEXT FIELD d
              END IF
           ELSE
              NEXT FIELD d 
           END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         
             CALL cl_about()     
 
          ON ACTION help        
             CALL cl_show_help()
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(c)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axa1"
                  LET g_qryparam.default1 = tm.c
                  CALL cl_create_qry() RETURNING tm.c
                  DISPLAY tm.c TO c
                  NEXT FIELD c
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag08"
                  LET g_qryparam.arg1 = g_aaz.aaz641
                  LET g_qryparam.default1 = tm.a
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY tm.a TO a
                  NEXT FIELD a
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag08"
                  LET g_qryparam.arg1 = g_aaz.aaz641
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(d)
                  CALL q_aac(FALSE,TRUE,tm.d,'A','','','AGL') RETURNING tm.d
                  DISPLAY tm.d TO d
                  NEXT FIELD d
            END CASE
         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p018_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME tm1.wc ON axa02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE
            WHEN INFIELD(axa02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_axa3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axa02
               NEXT FIELD axa02   
         END CASE


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION qbe_select
         CALL cl_qbe_select()

     END CONSTRUCT
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p018_w1
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     IF cl_sure(21,21) THEN
        CALL cl_wait()
        LET g_success = 'Y'
        BEGIN WORK
        CALL s_showmsg_init()
        CALL p018()
        CALL s_showmsg()
        IF g_success='Y' THEN
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag
        END IF
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           CLOSE WINDOW aglp018_w
           EXIT WHILE
        END IF
     END IF
   END WHILE
   CLOSE WINDOW p018_w1
END FUNCTION

FUNCTION p018()
DEFINE l_sql STRING
DEFINE l_axa02 LIKE axa_file.axa02
DEFINE i       LIKE type_file.num5
DEFINE l_amt1  LIKE axg_file.axg08
DEFINE l_amt2  LIKE axg_file.axg08
DEFINE l_sum   LIKE axg_file.axg08
DEFINE g_no    LIKE type_file.num5
DEFINE l_axz04 LIKE axz_file.axz04
DEFINE l_aag01 LIKE aag_file.aag01
DEFINE l_axi11 LIKE axi_file.axi11
DEFINE l_axi12 LIKE axi_file.axi12
   ####step1 
   CALL p018_del()

   ####step2   
   CALL p018_ins_axi()   

   ###step3 INSERT INTO axj   
   LET l_sql = "SELECT axa02 FROM axa_file ",
               " WHERE axa01 = '",tm.c,"'",
               "   AND ",tm1.wc CLIPPED
   PREPARE sel_axa02_pre FROM l_sql
   DECLARE sel_axa02_cur CURSOR FOR sel_axa02_pre
   FOREACH sel_axa02_cur INTO l_axa02   
      LET g_no = 1
      CALL g_dept.clear()
      LET l_sql = "SELECT axb04,axb05,axz08 FROM axb_file,axz_file ",
                  " WHERE axb01 = '",tm.c,"'",
                  "   AND axb02 = '",l_axa02,"'",
                  "   AND axz01 = axb04"  
      PREPARE sel_axb04_pre FROM l_sql                  
      DECLARE sel_axb04_cur CURSOR FOR sel_axb04_pre       
      FOREACH sel_axb04_cur INTO g_dept[g_no].*
          LET g_no=g_no+1      
      END FOREACH
      LET g_no = g_no-1      
      FOR i = 1 TO g_no 
          LET l_sum = 0      
          LET g_axj.axj00 = g_aaz.aaz641
          LET g_axj.axj01 = g_axi.axi01      
          LET g_axj.axj04 = ' '
          SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01 = g_dept[i].axb04      
          LET l_sql = "SELECT aag01 FROM aag_file ",
                     #" WHERE aag00 = '",g_aaz.aaz641,"' AND aag19 = '46'",         #MOD-D30135 mark
                      " WHERE aag00 = '",g_aaz.aaz641,"' AND aag19 in ('21','22')", #MOD-D30135 
                      "   AND aag07 <>'1'"       
          PREPARE sel_aag01_pre FROM l_sql
          DECLARE sel_aag01_cur CURSOR FOR sel_aag01_pre
          FOREACH sel_aag01_cur INTO l_aag01
              LET g_axj.axj03 = l_aag01
                IF l_aag01<>g_aaz.aaz114 AND l_aag01 <>'4103' THEN 
                    SELECT SUM(axg08) INTO l_amt1 FROM axg_file 
                     WHERE axg00=g_aaz.aaz641 AND axg01=tm.c 
                       AND axg04=g_dept[i].axb04 AND axg05=l_aag01
	               AND axg06=tm.y AND axg07=tm.m
                       AND axg02 = l_axa02                       
                    IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                        
	                SELECT SUM(axg08) INTO l_amt2 FROM axg_file
                     WHERE axg00=g_aaz.aaz641 AND axg01=tm.c 
                       AND axg04=g_dept[i].axb04 AND axg05=l_aag01
	               AND axg06=tm.y-1 AND axg07=12
                       AND axg02 = l_axa02                       
                    IF cl_null(l_amt2) THEN LET l_amt2 =0 END IF 
                    SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file
                     WHERE axj00 = g_axj.axj00 AND axj01 = g_axj.axj01
                    IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
                    LET g_axj.axj07 = l_amt1-l_amt2                    
                    LET g_axj.axj05 = ' '
                    LET g_axj.axj06 = '2'
                    LET g_axj.axjlegal=g_legal #添加所属法人   FUN-B60134     
                    IF g_axj.axj07<>0 THEN
                       INSERT INTO axj_file VALUES(g_axj.*)
                       IF SQLCA.sqlcode THEN
                          CALL s_errmsg('axj_file','insert',g_axi.axi01,SQLCA.sqlcode,1)
                          LET g_success = 'N'
                       END IF
                    END IF
                ELSE
                    SELECT SUM(axg09-axg08) INTO l_amt1 FROM axg_file
                     WHERE axg00=g_aaz.aaz641 AND axg01=tm.c 
                       AND axg04=g_dept[i].axb04 AND axg05=l_aag01
	               AND axg06=tm.y and axg07=tm.m
                       AND axg02 = l_axa02                       
                    IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                        
                    SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file
                     WHERE axj00 = g_axj.axj00 AND axj01 = g_axj.axj01
                    IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
                    LET g_axj.axj07 = l_amt1
                    LET g_axj.axj06 = '2'
                    LET g_axj.axj05 = ' '
                    LET g_axj.axj04 = '期末'
                    IF g_axj.axj07<>0 THEN
                       INSERT INTO axj_file VALUES(g_axj.*)
                       IF SQLCA.sqlcode THEN
                           CALL s_errmsg('axj_file','insert',g_axi.axi01,SQLCA.sqlcode,1)
                           LET g_success = 'N'
                       END IF
                    END IF 
	            SELECT SUM(axg09-axg08) INTO l_amt2 FROM axg_file  
                     WHERE axg00=g_aaz.aaz641 AND axg01=tm.c 
                       AND axg04=g_dept[i].axb04 AND axg05=l_aag01
	               AND axg06=tm.y-1 AND axg07=12
                       AND axg02 = l_axa02
                    IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF                        
                    SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file
                     WHERE axj00 = g_axj.axj00 AND axj01 = g_axj.axj01
                    IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF
                    LET g_axj.axj07 = l_amt2
                    LET g_axj.axj06 = '1'
                    LET g_axj.axj05 = ' '
                    LET g_axj.axj04 = '期初'
                    IF g_axj.axj07<>0 THEN
                       INSERT INTO axj_file VALUES(g_axj.*)
                       IF SQLCA.sqlcode THEN
                           CALL s_errmsg('axj_file','insert',g_axi.axi01,SQLCA.sqlcode,1)
                           LET g_success = 'N'
                       END IF
                    END IF 
                 END IF               
              LET l_sum = l_sum+l_amt1-l_amt2
          END FOREACH
          ####tm.a,tm.b          
          SELECT SUM(axk11-axk10) INTO l_amt1 
            FROM axk_file WHERE axk05=tm.a AND axk06='99' 
             AND axk07=g_dept[i].axz08 AND axk02 =g_axi.axi06
             AND axk01 = tm.c AND axk04 = l_axa02
             AND axk08 = tm.y AND axk09 = tm.m                 
             AND axk00 = g_aaz.aaz641                
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                 
          LET g_axj.axj04 = ' '
          LET g_axj.axj07 = l_amt1
          SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file WHERE axj00 = g_axj.axj00 
             AND axj01 = g_axj.axj01          
          IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF              
          LET g_axj.axj03 = tm.a
          LET g_axj.axj05 = g_dept[i].axz08
          LET g_axj.axj06 = '1'          
          IF g_axj.axj07 <>0 THEN
             INSERT INTO axj_file VALUES(g_axj.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('axj_file','insert',g_axi.axi01,SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
          END IF 
###tm.b
          LET g_axj.axj07 = l_sum-g_axj.axj07          
          SELECT MAX(axj02)+1 INTO g_axj.axj02 FROM axj_file WHERE axj00 = g_axj.axj00 
             AND axj01 = g_axj.axj01          
          IF cl_null(g_axj.axj02) THEN LET g_axj.axj02 = 1 END IF          
          LET g_axj.axj03 = tm.b
          LET g_axj.axj05 = ' '
          IF g_axj.axj07<>0 THEN
             INSERT INTO axj_file VALUES(g_axj.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('axj_file','insert',g_axi.axi01,SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF          
          END IF 
      END FOR
   END FOREACH  
   ####step 4 UPDATE 单头
   #UPDATE axi_file 借方总金额 贷方总金额
   LET l_axi11 = 0 LET l_axi12 = 0
   SELECT SUM(axj07) INTO l_axi11 FROM axj_file WHERE axj00 = g_axi.axi00
      AND axj01 = g_axi.axi01 AND axj06 = '1'   #借方
   SELECT SUM(axj07) INTO l_axi12 FROM axj_file WHERE axj00 = g_axi.axi00
      AND axj01 = g_axi.axi01 AND axj06 = '2'   #贷方
   IF cl_null(l_axi11) THEN LET l_axi11 = 0 END IF
   IF cl_null(l_axi12) THEN LET l_axi12 = 0 END IF
   UPDATE axi_file SET axi11 = l_axi11,
                       axi12 = l_axi12
    WHERE axi00 = g_axi.axi00
      AND axi01 = g_axi.axi01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('axi_file','update',g_axi.axi01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

END FUNCTION

FUNCTION p018_del()
DEFINE l_cnt   LIKE type_file.num5
DEFINE g_axi01 LIKE axi_file.axi01


   ######INSERT 前先删除
   ######指定[年度],[期别],[族群]只对应一笔调整分录
   SELECT COUNT(*) INTO l_cnt FROM axi_file
    WHERE axi00 = g_aaz.aaz641 AND axi03 = tm.y AND axi04 = tm.m
      AND axi05 = tm.c
      AND axi08  = '2'  AND axi081 = '6'
      AND axiconf <> 'X'  #CHI-C80041
   IF l_cnt > 0 THEN
      SELECT axi01 INTO g_axi01 FROM axi_file 
       WHERE axi00 = g_aaz.aaz641 AND axi03 = tm.y AND axi04 = tm.m
         AND axi05 = tm.c
         AND axi08  = '2'  AND axi081 = '6'
      IF NOT s_ask_entry(g_axi01) THEN RETURN END IF #Genero
   END IF
   DELETE FROM axi_file WHERE axi00 = g_aaz.aaz641 AND axi01 = g_axi01
   DELETE FROM axj_file WHERE axj00 = g_aaz.aaz641 AND axj01 = g_axi01
END FUNCTION

FUNCTION p018_ins_axi()
DEFINE li_result LIKE type_file.num5

    INITIALIZE g_axi.* TO NULL
    LET g_axi.axi00 = g_aaz.aaz641
       CALL s_auto_assign_no("AGL",tm.d,g_today,"","axi_file","axi01",g_plant,2,g_axi.axi00) #FUN-B60134
               RETURNING li_result,g_axi.axi01

    IF (NOT li_result) THEN
       CALL s_errmsg('axi_file','axi01',g_axi.axi01,'abm-621',1)
       LET g_success = 'N'
    END IF
    LET g_axi.axi02 = g_today
    LET g_axi.axi03 = tm.y
    LET g_axi.axi04 = tm.m
    LET g_axi.axi05 = tm.c
    SELECT axa02 INTO g_axi.axi06 FROM axa_file
     WHERE axa01 = g_axi.axi05 AND axa04 = 'Y'
    SELECT axz05 INTO g_axi.axi07 FROM axz_file
     WHERE axz01 = g_axi.axi06
    LET g_axi.axi08  = '2' 
    LET g_axi.axi081 = '6'   
    LET g_axi.axi09 = 'N'
    LET g_axi.axi10 = '自动抵消投资收益'
    LET g_axi.axi11 = 0  #单身产生后回写
    LET g_axi.axi12 = 0  #单身产生后回写
    LET g_axi.axi13 = ' '
    LET g_axi.axi14 = ' '
    LET g_axi.axi15 = ' '
    LET g_axi.axi16 = ' '
    LET g_axi.axi17 = ' '
    LET g_axi.axi18 = ' '
    LET g_axi.axi19 = ' '
    LET g_axi.axi20 = ' '
    LET g_axi.axiconf = 'Y'
    LET g_axi.axiuser = g_user
    LET g_axi.axigrup = g_grup
    LET g_axi.aximodu =  g_user
    LET g_axi.axidate = g_today
    LET g_axi.axi21 = '00'
    LET g_axi.axilegal=g_legal     #添加所属法人  FUN-B60134

    INSERT INTO axi_file VALUES(g_axi.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL s_errmsg('axi_file','insert',g_axi.axi01,SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF   
        
END FUNCTION

FUNCTION p018_d(p_t1)
   DEFINE l_aacacti   LIKE aac_file.aacacti
   DEFINE l_aac11     LIKE aac_file.aac11
   DEFINE p_t1        LIKE aac_file.aac01

   LET g_errno = ' '
   SELECT aacacti INTO l_aacacti FROM aac_file
    WHERE aac01 = p_t1

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-035'
         WHEN l_aacacti = 'N'      LET g_errno = 'agl-321'
         WHEN l_aac11<>'Y'         LET g_errno = 'agl-322'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION p018_a(p_aag01)
DEFINE p_aag01 LIKE aag_file.aag01
DEFINE l_aag04 LIKE aag_file.aag04
DEFINE l_aag07 LIKE aag_file.aag07
DEFINE l_aagacti LIKE aag_file.aagacti

   LET g_errno = ' '
   SELECT aag04,aag07,aagacti INTO l_aag04,l_aag07,l_aagacti
     FROM aag_file WHERE aag00 = g_aaz.aaz641 AND aag01 = p_aag01

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-021'
         WHEN l_aagacti = 'N'      LET g_errno = 'mfg1004'
         WHEN l_aag07 = '1'        LET g_errno = 'agl-134'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
# FUN-B60134
