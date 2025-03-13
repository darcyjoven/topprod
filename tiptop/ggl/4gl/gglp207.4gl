# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: gglp207.4gl
# Descriptions...: 投资收益自动抵消作业
# Date & Author..: 2011/06/13 By lutingting
# Modify.........: No.FUN-B60134 11/06/27 By xjll 新增程式
# Modify.........: No.FUN-B80135 11/08/22 By lujh 相關日期欄位不可小於關帳日期 
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: NO.TQC-D40119 13/07/17 By yangtt 在取合并帐套时，用的是aaz641，应改为大陆版的参数asz01

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE tm  RECORD                              #FUN-BB0036
              y       LIKE atd_file.atd03, 
              m       LIKE atd_file.atd04,
              c       LIKE asa_file.asa01, 
              a       LIKE aag_file.aag01,
              b       LIKE aag_file.aag01,
              d       LIKE aac_file.aac01
           END RECORD
DEFINE tm1 RECORD
              wc      LIKE type_file.chr1000
           END RECORD
DEFINE g_dept         DYNAMIC ARRAY OF RECORD
                      asb04      LIKE asb_file.asb04,
                      asb05      LIKE asb_File.asb05,
                      asg08      LIKE asg_file.asg08   #关系人编号
                      END RECORD
DEFINE    g_before_input_done  LIKE type_file.num5 
DEFINE    g_asj                RECORD LIKE asj_file.*
DEFINE    g_ask                RECORD LIKE ask_file.* 
DEFINE    g_success            LIKE type_file.chr1 
DEFINE    l_flag               LIKE type_file.chr1
DEFINE    g_aaa07              LIKE aaa_file.aaa07          #No.FUN-B80135
DEFINE    g_year               LIKE type_file.chr4          #No.FUN-B80135
DEFINE    g_month              LIKE type_file.chr2          #No.FUN-B80135
DEFINE    g_asz01              LIKE asz_file.asz01          #TQC-D40119
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end

   #抓取账套
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'    #TQC-D40119   

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
   DEFINE l_asa02        LIKE asa_file.asa02
   DEFINE l_asa03        LIKE asa_file.asa03

   CALL s_dsmark(tm.c) 
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW p018_w1 AT p_row,p_col
     WITH FORM "ggl/42f/gglp207"  ATTRIBUTE (STYLE = g_win_style CLIPPED)                                     
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

         #No.FUN-B80135--mark--str--
         #AFTER FIELD y
         #   IF NOT cl_null(tm.y) THEN
         #      IF tm.y = 0 THEN
         #         NEXT FIELD y
         #      END IF
         #   END IF
         #No.FUN-B80135--mark--end
            
         #No.FUN-B80135--add--str--
         AFTER FIELD y
         IF NOT cl_null(tm.y) THEN
            IF tm.y < 0 THEN
              CALL cl_err(tm.y,'apj-035',0)
              NEXT FIELD y
            END IF
            IF tm.y<g_year THEN
               CALL cl_err(tm.y,'atp-164',0)
               NEXT FIELD y
            ELSE 
               IF tm.y=g_year AND tm.m<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD m 
               END IF
            END IF 
         END IF
         #No.FUN-B80135--add--end
         
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
               #FUN-B80135--add--str--
               IF NOT cl_null(tm.y) AND tm.y=g_year 
               AND tm.m<=g_month THEN
                   CALL cl_err('','atp-164',0)
                   NEXT FIELD m
               END IF 
               #FUN-B80135--add--end
            END IF
 
         AFTER FIELD c
            IF NOT cl_null(tm.c) THEN
               SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = tm.c 
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
 
         #ON ACTION CONTROLZ    #TQC-C40010   mark
          ON ACTION CONTROLR    #TQC-C40010   add
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
                  LET g_qryparam.form ="q_asa1"
                  LET g_qryparam.default1 = tm.c
                  CALL cl_create_qry() RETURNING tm.c
                  DISPLAY tm.c TO c
                  NEXT FIELD c
               WHEN INFIELD(a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag08"
                 #LET g_qryparam.arg1 = g_aaz.aaz641     #TQC-D40119
                  LET g_qryparam.arg1 = g_asz01          #TQC-D40119
                  LET g_qryparam.default1 = tm.a
                  CALL cl_create_qry() RETURNING tm.a
                  DISPLAY tm.a TO a
                  NEXT FIELD a
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag08"
                 #LET g_qryparam.arg1 = g_aaz.aaz641    #TQC-D40119
                  LET g_qryparam.arg1 = g_asz01         #TQC-D40119
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(d)
                  CALL q_aac(FALSE,TRUE,tm.d,'A','','','GGL') RETURNING tm.d
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

      CONSTRUCT BY NAME tm1.wc ON asa02

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE
            WHEN INFIELD(asa02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_asa3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asa02
               NEXT FIELD asa02   
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
           CLOSE WINDOW gglp207_w
           EXIT WHILE
        END IF
     END IF
   END WHILE
   CLOSE WINDOW p018_w1
END FUNCTION

FUNCTION p018()
DEFINE l_sql STRING
DEFINE l_asa02 LIKE asa_file.asa02
DEFINE i       LIKE type_file.num5
DEFINE l_amt1  LIKE asr_file.asr08
DEFINE l_amt2  LIKE asr_file.asr08
DEFINE l_sum   LIKE asr_file.asr08
DEFINE g_no    LIKE type_file.num5
DEFINE l_asg04 LIKE asg_file.asg04
DEFINE l_aag01 LIKE aag_file.aag01
DEFINE l_asj11 LIKE asj_file.asj11
DEFINE l_asj12 LIKE asj_file.asj12
   ####step1 
   CALL p018_del()

   ####step2   
   CALL p018_ins_asj()   

   ###step3 INSERT INTO ask   
   LET l_sql = "SELECT asa02 FROM asa_file ",
               " WHERE asa01 = '",tm.c,"'",
               "   AND ",tm1.wc CLIPPED
   PREPARE sel_asa02_pre FROM l_sql
   DECLARE sel_asa02_cur CURSOR FOR sel_asa02_pre
   FOREACH sel_asa02_cur INTO l_asa02   
      LET g_no = 1
      CALL g_dept.clear()
      LET l_sql = "SELECT asb04,asb05,asg08 FROM asb_file,asg_file ",
                  " WHERE asb01 = '",tm.c,"'",
                  "   AND asb02 = '",l_asa02,"'",
                  "   AND asg01 = asb04"  
      PREPARE sel_asb04_pre FROM l_sql                  
      DECLARE sel_asb04_cur CURSOR FOR sel_asb04_pre       
      FOREACH sel_asb04_cur INTO g_dept[g_no].*
          LET g_no=g_no+1      
      END FOREACH
      LET g_no = g_no-1      
      FOR i = 1 TO g_no 
          LET l_sum = 0      
         #LET g_ask.ask00 = g_aaz.aaz641      #TQC-D40119
          LET g_ask.ask00 = g_asz01           #TQC-D40119
          LET g_ask.ask01 = g_asj.asj01      
          LET g_ask.ask04 = ' '
          SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01 = g_dept[i].asb04      
          LET l_sql = "SELECT aag01 FROM aag_file ",
                     #" WHERE aag00 = '",g_aaz.aaz641,"' AND aag19 = '46'",      #TQC-D40119
                      " WHERE aag00 = '",g_asz01,"' AND aag19 = '46'",           #TQC-D40119
                      "   AND aag07 <>'1'"       
          PREPARE sel_aag01_pre FROM l_sql
          DECLARE sel_aag01_cur CURSOR FOR sel_aag01_pre
          FOREACH sel_aag01_cur INTO l_aag01
              LET g_ask.ask03 = l_aag01
                IF l_aag01<>g_aaz.aaz114 AND l_aag01 <>'4103' THEN 
                    SELECT SUM(asr08) INTO l_amt1 FROM asr_file 
                    #WHERE asr00=g_aaz.aaz641 AND asr01=tm.c       #TQC-D40119
                     WHERE asr00=g_asz01      AND asr01=tm.c       #TQC-D40119 
                       AND asr04=g_dept[i].asb04 AND asr05=l_aag01
	               AND asr06=tm.y AND asr07=tm.m
                       AND asr02 = l_asa02                       
                    IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                        
	                SELECT SUM(asr08) INTO l_amt2 FROM asr_file
                    #WHERE asr00=g_aaz.aaz641 AND asr01=tm.c       #TQC-D40119
                     WHERE asr00=g_asz01      AND asr01=tm.c       #TQC-D40119 
                       AND asr04=g_dept[i].asb04 AND asr05=l_aag01
	               AND asr06=tm.y-1 AND asr07=12
                       AND asr02 = l_asa02                       
                    IF cl_null(l_amt2) THEN LET l_amt2 =0 END IF 
                    SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file
                     WHERE ask00 = g_ask.ask00 AND ask01 = g_ask.ask01
                    IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF
                    LET g_ask.ask07 = l_amt1-l_amt2                    
                    LET g_ask.ask05 = ' '
                    LET g_ask.ask06 = '2'
                    LET g_ask.asklegal=g_legal #添加所属法人   FUN-B60134     
                    IF g_ask.ask07<>0 THEN
                       INSERT INTO ask_file VALUES(g_ask.*)
                       IF SQLCA.sqlcode THEN
                          CALL s_errmsg('ask_file','insert',g_asj.asj01,SQLCA.sqlcode,1)
                          LET g_success = 'N'
                       END IF
                    END IF
                ELSE
                    SELECT SUM(asr09-asr08) INTO l_amt1 FROM asr_file
                    #WHERE asr00=g_aaz.aaz641 AND asr01=tm.c         #TQC-D40119
                     WHERE asr00=g_asz01      AND asr01=tm.c         #TQC-D40119 
                       AND asr04=g_dept[i].asb04 AND asr05=l_aag01
	               AND asr06=tm.y and asr07=tm.m
                       AND asr02 = l_asa02                       
                    IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                        
                    SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file
                     WHERE ask00 = g_ask.ask00 AND ask01 = g_ask.ask01
                    IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF
                    LET g_ask.ask07 = l_amt1
                    LET g_ask.ask06 = '2'
                    LET g_ask.ask05 = ' '
                    LET g_ask.ask04 = '期末'
                    IF g_ask.ask07<>0 THEN
                       INSERT INTO ask_file VALUES(g_ask.*)
                       IF SQLCA.sqlcode THEN
                           CALL s_errmsg('ask_file','insert',g_asj.asj01,SQLCA.sqlcode,1)
                           LET g_success = 'N'
                       END IF
                    END IF 
	            SELECT SUM(asr09-asr08) INTO l_amt2 FROM asr_file  
                    #WHERE asr00=g_aaz.aaz641 AND asr01=tm.c         #TQC-D40119
                     WHERE asr00=g_asz01      AND asr01=tm.c         #TQC-D40119 
                       AND asr04=g_dept[i].asb04 AND asr05=l_aag01
	               AND asr06=tm.y-1 AND asr07=12
                       AND asr02 = l_asa02
                    IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF                        
                    SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file
                     WHERE ask00 = g_ask.ask00 AND ask01 = g_ask.ask01
                    IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF
                    LET g_ask.ask07 = l_amt2
                    LET g_ask.ask06 = '1'
                    LET g_ask.ask05 = ' '
                    LET g_ask.ask04 = '期初'
                    IF g_ask.ask07<>0 THEN
                       INSERT INTO ask_file VALUES(g_ask.*)
                       IF SQLCA.sqlcode THEN
                           CALL s_errmsg('ask_file','insert',g_asj.asj01,SQLCA.sqlcode,1)
                           LET g_success = 'N'
                       END IF
                    END IF 
                 END IF               
              LET l_sum = l_sum+l_amt1-l_amt2
          END FOREACH
          ####tm.a,tm.b          
          SELECT SUM(ass11-ass10) INTO l_amt1 
            FROM ass_file WHERE ass05=tm.a AND ass06='99' 
             AND ass07=g_dept[i].asg08 AND ass02 =g_asj.asj06
             AND ass01 = tm.c AND ass04 = l_asa02
             AND ass08 = tm.y AND ass09 = tm.m                 
            #AND ass00 = g_aaz.aaz641              #TQC-D40119
             AND ass00 = g_asz01                   #TQC-D40119                
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                 
          LET g_ask.ask04 = ' '
          LET g_ask.ask07 = l_amt1
          SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file WHERE ask00 = g_ask.ask00 
             AND ask01 = g_ask.ask01          
          IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF              
          LET g_ask.ask03 = tm.a
          LET g_ask.ask05 = g_dept[i].asg08
          LET g_ask.ask06 = '1'          
          IF g_ask.ask07 <>0 THEN
             INSERT INTO ask_file VALUES(g_ask.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('ask_file','insert',g_asj.asj01,SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
          END IF 
###tm.b
          LET g_ask.ask07 = l_sum-g_ask.ask07          
          SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file WHERE ask00 = g_ask.ask00 
             AND ask01 = g_ask.ask01          
          IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF          
          LET g_ask.ask03 = tm.b
          LET g_ask.ask05 = ' '
          IF g_ask.ask07<>0 THEN
             INSERT INTO ask_file VALUES(g_ask.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('ask_file','insert',g_asj.asj01,SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF          
          END IF 
      END FOR
   END FOREACH  
   ####step 4 UPDATE 单头
   #UPDATE asj_file 借方总金额 贷方总金额
   LET l_asj11 = 0 LET l_asj12 = 0
   SELECT SUM(ask07) INTO l_asj11 FROM ask_file WHERE ask00 = g_asj.asj00
      AND ask01 = g_asj.asj01 AND ask06 = '1'   #借方
   SELECT SUM(ask07) INTO l_asj12 FROM ask_file WHERE ask00 = g_asj.asj00
      AND ask01 = g_asj.asj01 AND ask06 = '2'   #贷方
   IF cl_null(l_asj11) THEN LET l_asj11 = 0 END IF
   IF cl_null(l_asj12) THEN LET l_asj12 = 0 END IF
   UPDATE asj_file SET asj11 = l_asj11,
                       asj12 = l_asj12
    WHERE asj00 = g_asj.asj00
      AND asj01 = g_asj.asj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asj_file','update',g_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

END FUNCTION

FUNCTION p018_del()
DEFINE l_cnt   LIKE type_file.num5
DEFINE g_asj01 LIKE asj_file.asj01


   ######INSERT 前先删除
   ######指定[年度],[期别],[族群]只对应一笔调整分录
   SELECT COUNT(*) INTO l_cnt FROM asj_file
   #WHERE asj00 = g_aaz.aaz641 AND asj03 = tm.y AND asj04 = tm.m    #TQC-D40119
    WHERE asj00 = g_asz01      AND asj03 = tm.y AND asj04 = tm.m    #TQC-D40119
      AND asj05 = tm.c
      AND asj08  = '2'  AND asj081 = '6'
   IF l_cnt > 0 THEN
      SELECT asj01 INTO g_asj01 FROM asj_file 
      #WHERE asj00 = g_aaz.aaz641 AND asj03 = tm.y AND asj04 = tm.m  #TQC-D40119
       WHERE asj00 = g_asz01      AND asj03 = tm.y AND asj04 = tm.m  #TQC-D40119
         AND asj05 = tm.c
         AND asj08  = '2'  AND asj081 = '6'
      IF NOT s_ask_entry(g_asj01) THEN RETURN END IF #Genero
   END IF
  #DELETE FROM asj_file WHERE asj00 = g_aaz.aaz641 AND asj01 = g_asj01   #TQC-D40119
  #DELETE FROM ask_file WHERE ask00 = g_aaz.aaz641 AND ask01 = g_asj01   #TQC-D40119
   DELETE FROM asj_file WHERE asj00 = g_asz01 AND asj01 = g_asj01   #TQC-D40119
   DELETE FROM ask_file WHERE ask00 = g_asz01 AND ask01 = g_asj01   #TQC-D40119
END FUNCTION

FUNCTION p018_ins_asj()
DEFINE li_result LIKE type_file.num5

    INITIALIZE g_asj.* TO NULL
   #LET g_asj.asj00 = g_aaz.aaz641     #TQC-D40119
    LET g_asj.asj00 = g_asz01     #TQC-D40119
      #CALL s_auto_assign_no("GGL",tm.d,g_today,"","asj_file","asj01",g_plant,2,g_asj.asj00) #FUN-B60134  #carrier 20111024
       CALL s_auto_assign_no("AGL",tm.d,g_today,"","asj_file","asj01",g_plant,2,g_asj.asj00) #FUN-B60134  #carrier 20111024
               RETURNING li_result,g_asj.asj01

    IF (NOT li_result) THEN
       CALL s_errmsg('asj_file','asj01',g_asj.asj01,'abm-621',1)
       LET g_success = 'N'
    END IF
    LET g_asj.asj02 = g_today
    LET g_asj.asj03 = tm.y
    LET g_asj.asj04 = tm.m
    LET g_asj.asj05 = tm.c
    SELECT asa02 INTO g_asj.asj06 FROM asa_file
     WHERE asa01 = g_asj.asj05 AND asa04 = 'Y'
    SELECT asg05 INTO g_asj.asj07 FROM asg_file
     WHERE asg01 = g_asj.asj06
    LET g_asj.asj08  = '2' 
    LET g_asj.asj081 = '6'   
    LET g_asj.asj09 = 'N'
    LET g_asj.asj10 = '自动抵消投资收益'
    LET g_asj.asj11 = 0  #单身产生后回写
    LET g_asj.asj12 = 0  #单身产生后回写
    LET g_asj.asj13 = ' '
    LET g_asj.asj14 = ' '
    LET g_asj.asj15 = ' '
    LET g_asj.asj16 = ' '
    LET g_asj.asj17 = ' '
    LET g_asj.asj18 = ' '
    LET g_asj.asj19 = ' '
    LET g_asj.asj20 = ' '
    LET g_asj.asjconf = 'Y'
    LET g_asj.asjuser = g_user
    LET g_asj.asjgrup = g_grup
    LET g_asj.asjmodu =  g_user
    LET g_asj.asjdate = g_today
    LET g_asj.asj21 = '00'
    LET g_asj.asjlegal=g_legal     #添加所属法人  FUN-B60134

    #FUN-B80135--add--str--
      IF tm.y <g_year OR (tm.y=g_year AND tm.m<=g_month) THEN 
         LET g_showmsg=tm.y,"/",tm.m
         CALL s_errmsg('y,m',g_showmsg,'','atp-164',1)
      END IF 
    #FUN-B80135--add--end
    
    INSERT INTO asj_file VALUES(g_asj.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL s_errmsg('asj_file','insert',g_asj.asj01,SQLCA.sqlcode,1)
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
    #FROM aag_file WHERE aag00 = g_aaz.aaz641 AND aag01 = p_aag01    #TQC-D40119
     FROM aag_file WHERE aag00 = g_asz01      AND aag01 = p_aag01    #TQC-D40119

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-021'
         WHEN l_aagacti = 'N'      LET g_errno = 'mfg1004'
         WHEN l_aag07 = '1'        LET g_errno = 'agl-134'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
# FUN-B60134
