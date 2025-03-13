# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmp501.4gl
# Descriptions...: 標準BOM批次設定作業
# Date & Author..: No.FUN-A60008 10/06/02 By destiny
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B10018 11/01/20 By vealxu 修改標準bom的產生方式
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting 離開時未加cl_used(2)

DATABASE ds
#No.FUN-A60008--begin 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bra01     LIKE bra_file.bra01,                # 主件料件編號
    g_bra011    LIKE bra_file.bra011,                # 主件料件編號 
    g_wc        STRING, 
    g_wc1       STRING,      
    g_wc2       STRING,
    g_sql       STRING,
    l_table     STRING,
    g_max      LIKE type_file.num5,                # 用來記錄目前ARRAY己使用筆數 
    g_tot      LIKE type_file.num10,              
    g_err      LIKE type_file.num5,                # 用來記錄發生錯誤的次數 
    g_acode    LIKE bma_file.bma06,               
    l_flag     LIKE type_file.chr1,
    g_type     LIKE type_file.chr1      
DEFINE  g_pr   RECORD 
               bra01  LIKE bra_file.bra01,
               bra011 LIKE bra_file.bra011,
               type   LIKE type_file.chr100
               END RECORD             
DEFINE tm      RECORD                              #FUN-B10018
               type      LIKE type_file.chr1,         #FUN-B10018
               y         LIKE type_file.chr1          #FUN-B10018
               END RECORD                         #FUN-B10018  
DEFINE g_i     LIKE type_file.num5                 # count/index for any purpose   
DEFINE g_msg   LIKE type_file.chr100 
DEFINE g_cnt   LIKE type_file.num5
DEFINE g_t     LIKE type_file.num5
DEFINE g_str        LIKE type_file.chr100   #FUN-B10018
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bra01 = ARG_VAL(1)
   LET g_bra011= ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   CALL p501_out_1() 
   LET g_type='N' 
   IF NOT cl_null(g_bra01) THEN 
      LET g_type='Y'
   ELSE 
   	  IF NOT cl_null(g_bra011) THEN 
   	     LET g_type='Y'
   	  END IF 
   END IF 
   WHILE TRUE
     IF g_type='Y' THEN 
        CALL p501(g_bra01,g_bra011)
     ELSE 
     	  CALL p501_tm(0,0)
        IF cl_sure(18,20) THEN   #確定執行本作業
           CALL cl_wait()
           LET g_success = 'Y'
           CALL p501(g_bra01,g_bra011)
           IF g_cnt>0 THEN 
              LET g_t=1
           ELSE 
           	  LET g_t=2
           END IF 
           IF cl_null(g_t) THEN 
              LET g_t=1
           END IF 
           CALL cl_end2(g_t) RETURNING l_flag   
           IF l_flag THEN
              CLOSE WINDOW p501_w
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p501_w
              EXIT WHILE
           END IF  
        ELSE
           CLOSE WINDOW p501_w
           EXIT WHILE            
        END IF    
     END IF 
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION p501_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    
          l_cmd         LIKE type_file.chr1000, 
          l_ima02       LIKE ima_file.ima02,
          l_bra01        LIKE bma_file.bma01,    #資料筆數
          lc_cmd        LIKE type_file.chr1000  
   DEFINE l_a          LIKE type_file.num5
   DEFINE l_b          LIKE type_file.num5
   DEFINE l_c          LIKE type_file.num5
   DEFINE l_t          LIKE type_file.num5
   OPEN WINDOW p501_w WITH FORM "abm/42f/abmp501"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    IF g_sma.sma542='N' THEN 
       CALL cl_err('','abm-213',1)
       CLOSE WINDOW p501_w             
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time           
    END IF     
   CALL cl_opmsg('p')
WHILE TRUE                 
   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON ima01,bra011 
  
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	
 
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  let g_qryparam.form = "q_ima"
            #  LET g_qryparam.state = "c"
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret   
#FUN-AA0059 --End--
              DISPLAY g_qryparam.multiret TO ima01
              NEXT FIELD ima01
           WHEN INFIELD(bra011)
              CALL cl_init_qry_var()
            # LET g_qryparam.form = "q_ecu_1"   #FUN-B10018 mark
              LET g_qryparam.form = "q_ecu_a"   #FUN-B10018 
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bra011
              NEXT FIELD bra011              
        END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE construct
 
      ON ACTION about       
         CALL cl_about()    
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          CONTINUE construct

      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT construct

   END CONSTRUCT 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF

  #FUN-B10018 -------------add start---------------
   LET tm.type = 'c'
   LET tm.y = 'Y' 
   DISPLAY BY NAME tm.type,tm.y
   INPUT BY NAME tm.type,tm.y  WITHOUT DEFAULTS 
      BEFORE INPUT
         CALL cl_qbe_init()

      AFTER FIELD type 
        IF tm.type IS NULL OR tm.type NOT MATCHES '[abc]' THEN
           NEXT FIELD type 
        END IF
     
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE INPUT 

      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT

   END INPUT   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p501_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  #FUN-B10018 -------------add end------------------ 
   LET l_a=g_wc.getindexOf('ima01',1)
   LET l_b=g_wc.getindexOf('bra011',1)
   LET l_c=g_wc.getindexOf('and',1)
   IF l_a>0 THEN 
      IF l_b>0 THEN 
         LET g_wc1=g_wc.substring(1,l_c-1)
         LET g_wc2=g_wc.substring(l_c+3,g_wc.getLength())
      ELSE 
         LET g_wc1=g_wc
         LET g_wc2=NULL
      END IF 
   ELSE 
   	  IF l_b>0 THEN 
   	     LET g_wc1=NULL 
   	     LET g_wc2=g_wc
   	  END IF 
   END IF 
   LET g_wc1=cl_replace_str(g_wc1,"ima01","bra01")
   CALL cl_wait()
   CALL p501(g_wc1,g_wc2)
   IF g_cnt>0 THEN 
      LET l_t=1
   ELSE 
   	  LET l_t=2
   END IF 
   CALL cl_end2(l_t) RETURNING l_flag        #批次作業正確結束
   IF l_flag THEN
      CLEAR FORM
      ERROR ""
      LET g_bra01=''
      LET g_bra011=''
      LET g_i=0
      CONTINUE WHILE
   ELSE
      EXIT WHILE
   END IF
END WHILE
   CLOSE WINDOW p501_w
END FUNCTION
 
FUNCTION p501(p_bra01,p_bra011)
    #DEFINE p_bra011       LIKE bra_file.bra011   
    #DEFINE p_bra01	LIKE bra_file.bra01,  
    DEFINE p_bra011      STRING
    DEFINE p_bra01	     STRING,
          l_sql1         STRING,
          l_sql          STRING,
          l_n           LIKE type_file.num5,
          l_name	      LIKE type_file.chr20, 
          l_str         LIKE type_file.chr100,
          l_bra01       LIKE bra_file.bra01,    #主件料件
          l_bra011      LIKE bra_file.bra011
    DEFINE l_ima94      LIKE ima_file.ima94     #FUN-B10018
    DEFINE l_bra06      LIKE bra_file.bra06     #FUN-B10018
            
     DROP TABLE abmp501_tmp
     SELECT bra01,bra011,chr100 FROM bra_file,type_file WHERE 1=0 INTO TEMP abmp501_tmp 
     IF g_wc=" 1=1" THEN 
        LET g_wc1=g_wc
     END IF 
     IF NOT cl_null(g_bra01) THEN 
        LET g_wc1=" bra01='",g_bra01,"' "
     END IF 
     IF NOT cl_null(g_bra011) THEN 
        LET g_wc2=" bra011='",g_bra011,"' "
     END IF 
     IF cl_null(g_wc1) THEN 
        LET g_wc1=" 1=1"
     END IF 
     IF cl_null(g_wc2) THEN 
        LET g_wc2=" 1=1"
     END IF 
   # LET l_sql=" SELECT DISTINCT bra01 FROM bra_file WHERE ",g_wc1 CLIPPED          #FUN-B10018 mark
     LET l_sql=" SELECT DISTINCT bra01,bra06 FROM bra_file  WHERE braacti='Y' AND ",g_wc1 CLIPPED   #FUN-B10018
     PREPARE p501_sel FROM l_sql      
     IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)           
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE p501_cs CURSOR FOR p501_sel
     
    #LET l_sql1= " SELECT DISTINCT bra011 FROM bra_file WHERE bra01= ? AND ",g_wc2 CLIPPED                  #FUN-B10018 mark
    #FUN-B10018 -------add start------------------
     LET l_sql1= " SELECT DISTINCT bra011 FROM bra_file WHERE bra01= ? AND bra06  = ? AND bra014 = 'N' AND braacti='Y' AND ",g_wc2 CLIPPED," ORDER BY bra011 "
    #FUN-B10018 -------add end-----------------------
     PREPARE p501_sel1 FROM l_sql1      
     IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)           
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF   
     DECLARE p501_cs1 CURSOR FOR p501_sel1  
     LET g_cnt=0
     BEGIN WORK          #FUN-B10018 
     LET g_success = 'Y' #FUN-B10018
     FOREACH p501_cs INTO l_bra01,l_bra06   #FUN-B10018 add bra06
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
     # SELECT COUNT(bra011) INTO l_n FROM bra_file WHERE bra01=l_bra01                                   #FUN-B10018 mark
       SELECT COUNT(DISTINCT(bra011)) INTO l_n FROM bra_file WHERE bra01 = l_bra01 AND bra06 = l_bra06 AND braacti='Y'  #FUN-B10018 
       IF tm.type = 'c' THEN  #FUN-B10018
          FOREACH p501_cs1 USING l_bra01,l_bra06 INTO l_bra011
            #FUN-B10018 -----------------mark start-----------
            #IF l_n>1 THEN 
            #   CALL cl_getmsg('abm-224',g_lang) RETURNING g_msg
            #   LET l_str=l_bra01,g_msg
            #   INSERT INTO abmp501_tmp VALUES(l_bra01,l_bra011,l_str) 
            #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
            #      LET g_success='N' 
            #      EXIT FOREACH 
            #   END IF              
            #ELSE
            #	 UPDATE bra_file SET bra014='Y' 
            #	           WHERE bra01=l_bra01
            #	             AND bra011=l_bra011 
            #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
            #      LET g_success='N' 
            #      EXIT FOREACH 
            #   ELSE 
            #   	  LET g_cnt=g_cnt+1
            #   END IF                 	             
            #END IF 
            #FUN-B10018 ----------------mark end-----------------------
            #FUN-B10018 ----------------add  start--------------------
            UPDATE bra_file SET bra014='Y'
             WHERE bra01 = l_bra01
               AND bra06 = l_bra06
               AND bra011 = l_bra011
            IF SQLCA.sqlcode THEN
               CALL cl_getmsg('9050',g_lang) RETURNING g_msg
               LET g_str=l_bra01,g_msg
               LET g_success='N'
            ELSE
               CALL p501_reproduce(l_bra01,l_bra06,l_bra011)
               IF g_success = 'Y' THEN
                  LET g_cnt = g_cnt + 1
                  CALL cl_getmsg('abm-232',g_lang) RETURNING g_msg
                  LET g_str=g_msg
               END IF
            END IF
            EXIT FOREACH
          END FOREACH
          IF cl_null(l_bra011) THEN LET l_bra011=' ' CALL cl_getmsg('abm-233',g_lang) RETURNING g_str END IF
          INSERT INTO abmp501_tmp VALUES(l_bra01,l_bra011,g_str)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             LET g_success='N'
          END IF
       ELSE
          IF tm.type = 'a'  THEN
             LET l_bra011=''
             SELECT ima94 INTO l_bra011 FROM ima_file 
              WHERE ima01 = l_bra01 
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM bra_file
              WHERE bra01=l_bra01 AND bra06=l_bra06 AND bra011=l_bra011 AND bra014='N' AND braacti='Y'
             IF l_n > 0 THEN
                UPDATE bra_file SET bra014 = 'Y' 
                 WHERE bra01 = l_bra01
                   AND bra06 = l_bra06
                   AND bra011 = l_bra011 
                IF SQLCA.sqlcode THEN
                   CALL cl_getmsg('9050',g_lang) RETURNING g_msg
                   LET g_str=l_bra01,g_msg
                   LET g_success='N'
                ELSE
                   CALL p501_reproduce(l_bra01,l_bra06,l_bra011)
                   IF g_success = 'Y' THEN
                      LET g_cnt = g_cnt + 1
                      CALL cl_getmsg('abm-232',g_lang) RETURNING g_msg
                      LET g_str=g_msg
                   END IF
                END IF
             ELSE
               CALL cl_getmsg('abm-233',g_lang) RETURNING g_str
             END IF 
          END IF 
          IF tm.type = 'b' THEN
              IF l_n > 1 THEN
                 CALL cl_getmsg('abm-224',g_lang) RETURNING g_msg
                 LET g_str=l_bra01,g_msg
              ELSE
                 LET l_bra011=''
                 SELECT DISTINCT(bra011) INTO l_bra011 FROM bra_file WHERE bra01 = l_bra01 AND bra06 = l_bra06 AND braacti='Y'
                 IF NOT cl_null(l_bra011) THEN
                    UPDATE bra_file SET bra014='Y'
                     WHERE bra01 = l_bra01
                       AND bra06 = l_bra06
                       AND bra011 = l_bra011
                    IF SQLCA.sqlcode THEN
                       CALL cl_getmsg('9050',g_lang) RETURNING g_msg
                       LET g_str=l_bra01,g_msg
                       LET g_success='N'
                    ELSE
                       CALL p501_reproduce(l_bra01,l_bra06,l_bra011)
                       IF g_success = 'Y' THEN
                          LET g_cnt = g_cnt + 1
                          CALL cl_getmsg('abm-232',g_lang) RETURNING g_msg
                          LET g_str=g_msg
                       END IF
                    END IF   
                 END IF
              END IF
          END IF
          IF l_bra011 IS NULL THEN LET l_bra011=' ' END IF
          INSERT INTO abmp501_tmp VALUES(l_bra01,l_bra011,g_str)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             LET g_success='N'
             EXIT FOREACH
          END IF
       END IF 
       #FUN-B10018 ----------------add end-----------------------
       IF g_success='N' THEN 
          EXIT FOREACH 
       END IF 
     END FOREACH
     #FUN-B10018 ----------add start------
     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     #FUN-B10018 ----------add end-----------
     CALL p501_out_2() 
#     IF g_bgjob = 'N' THEN  
#        ERROR ""
#     END IF
#     IF g_err>0 THEN
#         IF g_bgjob='N' THEN
#             CALL cl_getmsg('mfg2642',g_lang) RETURNING g_msg
#             LET INT_FLAG = 0  
#             PROMPT g_err USING '&&&& ', g_msg CLIPPED  FOR g_chr
#         END IF
#         CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#          LET g_prog=p_prog 
#     END IF
#     RETURN g_err
END FUNCTION


#FUN-B10018 -------------add start---------------
FUNCTION p501_reproduce(p_bra01,p_bra06,p_bra011)
   DEFINE p_bra01   LIKE bra_file.bra01,
          p_bra011  LIKE bra_file.bra011,
          p_bra06   LIKE bra_file.bra06
   DEFINE l_bra     RECORD   LIKE bra_file.*,
          l_brb     RECORD   LIKE brb_file.*,
          l_bmb     RECORD   LIKE bmb_file.* 
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_m       LIKE type_file.num5
   

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM bra_file 
    WHERE bra01 = p_bra01    AND bra10 = '2' AND bra014='Y'
      AND bra011 != p_bra011 AND bra06 = p_bra06
   IF l_n > 0 AND tm.y = 'Y' THEN 
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM bma_file 
       WHERE bma01 = p_bra01 AND bma06=p_bra06
      IF l_n > 0 THEN  #存在已發放且产品bom否為’Y’的資料，則刪掉 
         DELETE FROM bma_file WHERE bma01 = p_bra01 AND bma06 = p_bra06 
         DELETE FROM bmb_file WHERE bmb01 = p_bra01 AND bmb29 = p_bra06
      END IF
   END IF
   UPDATE bra_file SET bra014 = 'N'
    WHERE bra01 = p_bra01
      AND bra06 = p_bra06
      AND bra011 != p_bra011
   IF SQLCA.sqlcode THEN
      CALL cl_getmsg('9050',g_lang) RETURNING g_msg
      LET g_str=p_bra01,g_msg
      LET g_success = 'N'
      RETURN
   END IF
   
   IF tm.y = 'N' THEN RETURN END IF
   SELECT COUNT(*)  INTO l_n FROM bra_file
    WHERE bra01 = p_bra01 
      AND bra06 = p_bra06
      AND bra10 = '2'
      AND bra011 = p_bra011  
   IF g_success = 'Y' AND l_n > 0 THEN    #重新產生標準bom資料                                     
      DELETE FROM bma_file WHERE bma01 = p_bra01 AND bma06 = p_bra06
      DELETE FROM bmb_file WHERE bmb01 = p_bra01 AND bmb29 = p_bra06
      DECLARE p501_bra CURSOR FOR SELECT *  FROM bra_file 
        WHERE bra01 = p_bra01
          AND bra06 = p_bra06
          AND bra10 = '2'
          AND bra011 = p_bra011
      FOREACH p501_bra INTO l_bra.*
        EXIT FOREACH
      END FOREACH
      INSERT INTO bma_file(bma01,bma02,bma03,bma04,bma05,bma06,bma07,bma08,bma09,bma10,
                           bmaacti,bmagrup,bmamodu,bmadate,bmauser,bmaorig,bmaoriu)
                   VALUES(l_bra.bra01,l_bra.bra02,l_bra.bra03,l_bra.bra04,l_bra.bra05,l_bra.bra06,l_bra.bra07,l_bra.bra08,
                          l_bra.bra09,l_bra.bra10,l_bra.braacti,l_bra.bragrup,l_bra.bramodu,l_bra.bradate,l_bra.brauser,
                          l_bra.braorig,l_bra.braoriu)                   
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_getmsg('9050',g_lang) RETURNING g_msg
         LET g_str=p_bra01,g_msg
         LET g_success='N'
         RETURN 
      END IF
      DECLARE p501_brb1 CURSOR FOR 
       SELECT brb_file.* FROM brb_file,bra_file
        WHERE brb01 = bra01    AND brb011 = bra011   AND brb012 = bra012  AND brb013 = bra013  AND brb29 = bra06
          AND brb01 = p_bra01  AND bra06 = p_bra06   AND brb011 = p_bra011  AND bra10='2'
          AND (brb04 <=g_today OR brb04 IS NULL )
          AND (brb05 > g_today OR brb05 IS NULL )
     
      LET l_m = 0 
      LET l_n = 0
      INITIALIZE l_brb.* TO NULL
      FOREACH p501_brb1 INTO l_brb.*
         SELECT ecb06 INTO l_brb.brb09 FROM ecb_file
             WHERE ecb01 = l_brb.brb01
               AND ecb02 = l_brb.brb011
               AND ecb03 = l_brb.brb013
               AND ecb012 = l_brb.brb012
         #主件料号+作业编号的相同元件的组成用量汇总
         SELECT COUNT(*) INTO l_n FROM bmb_file
          WHERE bmb01 = l_brb.brb01  AND bmb09 = l_brb.brb09 
            AND bmb03 = l_brb.brb03  AND bmb29 = l_brb.brb29 
         IF l_n > 0 THEN 
            DECLARE p501_bmb CURSOR FOR SELECT bmb02,bmb04,bmb06 FROM bmb_file 
              WHERE bmb01 = l_brb.brb01  AND bmb09 = l_brb.brb09 AND bmb03 = l_brb.brb03 AND bmb29=l_brb.brb29
            FOREACH p501_bmb INTO l_bmb.bmb02,l_bmb.bmb04,l_bmb.bmb06
               EXIT FOREACH
            END FOREACH     
            LET l_bmb.bmb06 = l_bmb.bmb06 + l_brb.brb06
            UPDATE bmb_file SET bmb06 = l_bmb.bmb06 
             WHERE bmb01 = l_brb.brb01
               AND bmb02 = l_bmb.bmb02
               AND bmb03 = l_brb.brb03
               AND bmb04 = l_bmb.bmb04
               AND bmb29 = l_brb.brb29
            IF SQLCA.sqlcode THEN
               CALL cl_getmsg('9050',g_lang) RETURNING g_msg
               LET g_str=p_bra01,g_msg
               LET g_success='N'
               RETURN
            END IF  
         #新增一笔 
         ELSE
            LET l_bmb.bmb03=l_brb.brb03
            LET l_bmb.bmb06=l_brb.brb06
            LET l_bmb.bmb01=l_brb.brb01
            LET l_bmb.bmb04=l_brb.brb04
            LET l_bmb.bmb05=l_brb.brb05
            LET l_bmb.bmb07=l_brb.brb07
            LET l_bmb.bmb08=l_brb.brb08
            LET l_bmb.bmb081=l_brb.brb081
            LET l_bmb.bmb082=l_brb.brb082
            LET l_bmb.bmb10=l_brb.brb10
            LET l_bmb.bmb10_fac=l_brb.brb10_fac
            LET l_bmb.bmb10_fac2=l_brb.brb10_fac2
            LET l_bmb.bmb11=l_brb.brb11
            LET l_bmb.bmb13=l_brb.brb13
            LET l_bmb.bmb14=l_brb.brb14
            LET l_bmb.bmb15=l_brb.brb15
            LET l_bmb.bmb16=l_brb.brb16
            LET l_bmb.bmb17=l_brb.brb17
            LET l_bmb.bmb18=l_brb.brb18
            LET l_bmb.bmb19=l_brb.brb19
            LET l_bmb.bmb20=l_brb.brb20
            LET l_bmb.bmb21=l_brb.brb21
            LET l_bmb.bmb22=l_brb.brb22
            LET l_bmb.bmb23=l_brb.brb23
            LET l_bmb.bmb24=l_brb.brb24
            LET l_bmb.bmb25=l_brb.brb25
            LET l_bmb.bmb26=l_brb.brb26
            LET l_bmb.bmb27=l_brb.brb27
            LET l_bmb.bmb28=l_brb.brb28
            LET l_bmb.bmb29=l_brb.brb29
            LET l_bmb.bmb30=l_brb.brb30
            LET l_bmb.bmb31=l_brb.brb31
            LET l_bmb.bmb33=l_brb.brb33
            LET l_bmb.bmbmodu=l_brb.brbmodu
            LET l_bmb.bmbdate=l_brb.brbdate
            LET l_bmb.bmbcomm=l_brb.brbcomm 
            LET l_bmb.bmb09=l_brb.brb09
            SELECT MAX(bmb02) INTO l_bmb.bmb02 FROM bmb_file 
             WHERE bmb01 = l_brb.brb01
               AND bmb29 = l_brb.brb29    
            IF cl_null(l_bmb.bmb02) THEN
               LET l_bmb.bmb02 = 0 
            END IF
            LET l_bmb.bmb02 = l_bmb.bmb02 + g_sma.sma19
            INSERT INTO bmb_file VALUES(l_bmb.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_getmsg('9050',g_lang) RETURNING g_msg
               LET g_str=p_bra01,g_msg
               LET g_success='N'
               EXIT FOREACH 
            END IF
        END IF 
      END FOREACH 
   END IF  
END FUNCTION
#FUN-B10018 -------------add end--------------
FUNCTION p501_out_1()

   LET g_prog = 'abmp501'
   LET g_sql = "bra01.bra_file.bra01,",
               "bra011.bra_file.bra011,",
               "type.type_file.chr100,"
 
   LET l_table = cl_prt_temptable('abmp501',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION p501_out_2()
 
   LET g_prog = 'abmp501'
   CALL cl_del_data(l_table)
 
   DECLARE cr_curs CURSOR FOR
    SELECT * FROM abmp501_tmp
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('abmp501','abmp501',g_sql,'')
END FUNCTION 
#No.FUN-A60008--end
