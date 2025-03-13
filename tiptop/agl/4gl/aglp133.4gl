# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglp133.4gl
# Descriptions...: 暫估月度統計作业
# Date & Author..: No.FUN-CB0124 12/11/27 By wangrr 
# Modify.........: No.fengmy131101 13/11/01 By fengmy 空值插入错误
DATABASE ds   
GLOBALS "../../config/top.global"

DEFINE tm       RECORD
       ape02    LIKE ape_file.ape02,
       ape03    LIKE ape_file.ape03
                END RECORD,
       g_wc     STRING,
       g_sql    STRING,
       g_flag   LIKE type_file.chr1
DEFINE g_change_lang   LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.ape02= ARG_VAL(1)
   LET tm.ape03= ARG_VAL(2)
   LET g_wc    = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   LET g_time = TIME 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p133_tm()
         IF cl_sure(18,20) THEN
            CALL p133()
             IF g_success ='Y' THEN
                CALL cl_end2(1) RETURNING g_flag
                IF g_flag THEN 
                   CONTINUE WHILE
                ELSE
                   CLOSE WINDOW p133_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING g_flag
                IF g_flag THEN 
                   CONTINUE WHILE 
                ELSE
                   CLOSE WINDOW p133_w
                   EXIT WHILE
                END IF

             END IF 
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p133_w
      ELSE
         CALL p133()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p133_tm()
   DEFINE p_row,p_col    LIKE type_file.num5 
   DEFINE lc_cmd         LIKE type_file.chr1000
   
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p133_w AT p_row,p_col WITH FORM "agl/42f/aglp133"
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('q')

   CLEAR FORM
   LET tm.ape02=YEAR(g_today)
   LET tm.ape03=MONTH(g_today)
   DISPLAY BY NAME tm.ape02,tm.ape03
   WHILE TRUE
      INPUT BY NAME tm.ape02,tm.ape03
         WITHOUT DEFAULTS 
         AFTER FIELD ape03
            IF NOT cl_null(tm.ape03) THEN
               IF tm.ape03<1 OR tm.ape03>12 THEN
                  CALL cl_err('','ask-004',0)
                  NEXT FIELD ape03
               END IF
            END IF

         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CLOSE WINDOW p133_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
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
         
         ON ACTION EXIT 
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
         ON ACTION locale
            LET g_change_lang = TRUE 
            EXIT INPUT
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p133_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      CONSTRUCT BY NAME g_wc ON ape01,ape04
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
         ON ACTION CONTROLZ
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
     
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT CONSTRUCT
      
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
            
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(ape01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc01"
                  LET g_qryparam.state = "c" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret  
                  DISPLAY g_qryparam.multiret TO ape01           
                  NEXT FIELD ape01
               WHEN INFIELD(ape04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.state = "c"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret               
                  DISPLAY g_qryparam.multiret TO ape04                             
                  NEXT FIELD ape04
            END CASE
      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CLOSE WINDOW p133_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF cl_null(g_wc) THEN
         LET g_wc = ' 1=1' 
      END IF 
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p133()
   DEFINE l_ape        RECORD LIKE ape_file.*
   DEFINE l_str        STRING
   DEFINE l_yy         LIKE type_file.num5,
          l_mm         LIKE type_file.num5,
          l_cnt        LIKE type_file.num5
   DEFINE l_wc         string    #luttb

   DISPLAY g_time
   CALL s_showmsg_init()
   BEGIN WORK
   #判斷資料是否已存在，如果存在則刪除重新產生
   LET g_sql="SELECT COUNT(*) FROM ape_file ",
             " WHERE ape02=",tm.ape02," AND ape03=",tm.ape03," AND ",g_wc 
   PREPARE sel_cnt_pr FROM g_sql
   EXECUTE sel_cnt_pr INTO l_cnt
   IF l_cnt>0 THEN
      LET g_sql="DELETE FROM ape_file ",
                " WHERE ape02=",tm.ape02," AND ape03=",tm.ape03," AND ",g_wc 
      PREPARE del_pr FROM g_sql
      EXECUTE del_pr 
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('del ape:',STATUS,1)
         ROLLBACK WORK
         RETURN
       END IF
   END IF
   IF tm.ape03=1 THEN
      LET l_yy=tm.ape02-1
      LET l_mm=12
   ELSE
      LET l_yy=tm.ape02
      LET l_mm=tm.ape03-1
   END IF

   LET l_wc= cl_replace_str(g_wc,'ape01','apa05')   #luttb
   LET l_wc= cl_replace_str(l_wc,'ape04','apb12')   #luttb

   LET g_sql="SELECT DISTINCT ape01,ape04 FROM (",
             " SELECT DISTINCT ape01,ape04 FROM ape_file ",
             "  WHERE ape02 = ",l_yy," AND ape03 = ",l_mm,
             "    AND (ape19<> 0 or ape20<>0 or ape21 <> 0 or ape22 <> 0 )",
             "    AND ", g_wc,
             "  UNION ALL ",
             " SELECT DISTINCT apa05 ape01,apb12 ape04 ",
             "   FROM apa_file LEFT OUTER JOIN apb_file ON (apa01 = apb01) ",
             "  WHERE apa00 IN ('16','26') ",
             "    AND YEAR(apa02) =", tm.ape02," AND MONTH(apa02) =", tm.ape03,
            #"    AND apa41='Y' AND ", g_wc  #luttb mark
             "    AND apa41='Y' AND ", l_wc  #luttb add
            ," )"
   PREPARE p133_sel_pr FROM g_sql
   DECLARE p133_sel_cr CURSOR FOR p133_sel_pr
   
   FOREACH p133_sel_cr INTO l_ape.ape01,l_ape.ape04
      IF STATUS THEN
         CALL s_errmsg('','','FOREACH p133_cr:',STATUS,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF cl_null(l_ape.ape04) THEN
         LET l_ape.ape04=' '
      END IF
      LET l_ape.ape02=tm.ape02
      LET l_ape.ape03=tm.ape03
      #期初
      LET l_ape.ape05=0
      LET l_ape.ape06=0
      LET l_ape.ape07=0
      LET l_ape.ape08=0
      SELECT ape19,ape20,ape21,ape22 
        INTO l_ape.ape05,l_ape.ape06,l_ape.ape07,l_ape.ape08
        FROM ape_file
       WHERE ape02=l_yy AND ape03=l_mm 
         AND ape01=l_ape.ape01 AND ape04=l_ape.ape04
      IF cl_null(l_ape.ape05) THEN LET l_ape.ape05=0 END IF
      IF cl_null(l_ape.ape06) THEN LET l_ape.ape06=0 END IF
      IF cl_null(l_ape.ape07) THEN LET l_ape.ape07=0 END IF
      IF cl_null(l_ape.ape08) THEN LET l_ape.ape08=0 END IF
    
      
      IF NOT cl_null(l_ape.ape04) AND l_ape.ape04<>' ' THEN
         #入庫暫估(+)
         SELECT SUM(apb09),SUM(apb10) INTO l_ape.ape09,l_ape.ape11 
           FROM apa_file,apb_file
          WHERE apa01=apb01 AND apa00='16' AND apa41='Y' AND apa42='N'
            AND MONTH(apa02)=tm.ape03 AND YEAR(apa02)=tm.ape02 
            AND apa05=l_ape.ape01 AND apb12=l_ape.ape04
         #倉退暫估(-)
         SELECT -1*SUM(apb09),-1*SUM(apb10) INTO l_ape.ape10,l_ape.ape12 
           FROM apa_file,apb_file
          WHERE apa01=apb01 AND apa00='26' AND apa41='Y' AND apa42='N'
            AND MONTH(apa02)=tm.ape03 AND YEAR(apa02)=tm.ape02
            AND apa05=l_ape.ape01 AND apb12=l_ape.ape04
         #入庫暫估沖抵和差異(-)
          LET g_sql="SELECT -1*SUM(amt1),-1*SUM(amt2),SUM(amt2-amt3) FROM(",
                    " SELECT SUM(apb09) amt1,0 amt2,SUM(apb10) amt3",
                    "   FROM apa_file,apb_file", 
                    "  WHERE apa01 = apb01 AND apa00 = '11' ",
                    "    AND YEAR(apa02) =",tm.ape02," AND MONTH(apa02) =",tm.ape03,
                    "    AND apa05 ='",l_ape.ape01,"'  AND apb12 ='",l_ape.ape04,"'",
                    "    AND apa41 = 'Y' AND apa42='N' AND apb29 = '1' AND apb34 = 'Y'",
                    "  UNION ALL ",
                    " SELECT 0 amt1,SUM(api05) amt2,0 amt3 FROM api_file ",
                    "  WHERE api01||api03 IN (",
                    " SELECT DISTINCT apa01||apb02 FROM apa_file,apb_file", 
                    "  WHERE apa01 = apb01 AND apa00 = '11' ",
                    "    AND YEAR(apa02) =",tm.ape02," AND MONTH(apa02) =",tm.ape03,
                    "    AND apa05 = '",l_ape.ape01,"' AND apb12 ='",l_ape.ape04,"'",
                    "    AND apa41 = 'Y' AND apa42='N' AND apb29 = '1' AND apb34 = 'Y')",
                    "    AND api02 = '2' AND api26 <> 'DIFF'",
                    ")"	
         PREPARE sel_pr1 FROM g_sql
         EXECUTE sel_pr1 INTO l_ape.ape13,l_ape.ape15,l_ape.ape17
         #倉退暫估沖抵和差異(+)
         LET g_sql="SELECT SUM(amt1),SUM(amt2),SUM(amt2-amt3) FROM(",
                   " SELECT SUM((case when apb09<0 then -1*apb09  else apb09 end)) amt1,",
                   "        0 amt2,SUM((case when apb10<0 then -1*apb10  else apb10 end)) amt3",
                   "   FROM apa_file,apb_file", 
                   "  WHERE apa01 = apb01 AND (apa00 = '21' OR apa00 = '11')",
                   "    AND YEAR(apa02) =",tm.ape02," AND MONTH(apa02) =",tm.ape03,
                   "    AND apa05 ='",l_ape.ape01,"'  AND apb12 ='",l_ape.ape04,"'",
                   "    AND apa41 = 'Y' AND apa42='N' AND apb29 = '3' AND apb34 = 'Y'",
                   "  UNION ALL ",
                   " SELECT 0 amt1,SUM((case when api05<0 then -1*api05  else api05 end)) amt2,",
                   "        0 amt3 FROM api_file ",
                   "  WHERE api01||api03 IN (",
                   " SELECT DISTINCT apa01||apb02 FROM apa_file,apb_file", 
                   "  WHERE apa01 = apb01 AND (apa00 = '21' OR apa00 = '11') ",
                   "    AND YEAR(apa02) =",tm.ape02," AND MONTH(apa02) =",tm.ape03,
                   "    AND apa05 ='",l_ape.ape01,"'  AND apb12 ='",l_ape.ape04,"'",
                   "    AND apa41 = 'Y' AND apa42='N' AND apb29 = '3' AND apb34 = 'Y')",
                   "    AND api02 = '2' AND api26 <> 'DIFF'",
                   ")"	
         PREPARE sel_pr2 FROM g_sql
         EXECUTE sel_pr2 INTO l_ape.ape14,l_ape.ape16,l_ape.ape18
      ELSE
         #入庫暫估(+)
         LET l_ape.ape09=0
         SELECT SUM(apa31) INTO l_ape.ape11
           FROM apa_file LEFT OUTER JOIN apb_file ON apa01=apb01
          WHERE apa00='16' AND apa41='Y' AND apa42='N'
            AND MONTH(apa02)=tm.ape03 AND YEAR(apa02)=tm.ape02 
            AND apa05=l_ape.ape01 AND apb12 IS NULL
         #倉退暫估(-)   
         LET l_ape.ape10=0
         SELECT -1*SUM(apa31) INTO l_ape.ape12 
           FROM apa_file LEFT OUTER JOIN  apb_file ON apa01=apb01 
          WHERE apa00='26' AND apa41='Y' AND apa42='N'
            AND MONTH(apa02)=tm.ape03 AND YEAR(apa02)=tm.ape02
            AND apa05=l_ape.ape01 AND apb12 IS NULL
         #入庫暫估沖抵和差異(-)
          LET g_sql=" SELECT -1*SUM(api05) amt2 FROM api_file ",
                    "  WHERE api01 IN (",
                    " SELECT DISTINCT apa01 ",
                    "   FROM apa_file LEFT OUTER JOIN apb_file ON apa01=apb01", 
                    "  WHERE  apa00 = '11' ",
                    "    AND YEAR(apa02) =",tm.ape02," AND MONTH(apa02) =",tm.ape03,
                    "    AND apa05 = '",l_ape.ape01,"' AND apb12 IS NULL",
                    "    AND apa41 = 'Y' AND apa42='N' )",
                    "    AND api02 = '2' "
         PREPARE sel_pr3 FROM g_sql
         EXECUTE sel_pr3 INTO l_ape.ape15
         LET l_ape.ape13=0
         LET l_ape.ape17=0
         #倉退暫估沖抵和差異(+)
         LET g_sql=" SELECT SUM((case when api05<0 then -1*api05  else api05 end)) amt2",
                   "   FROM api_file ",
                   "  WHERE api01 IN (",
                   " SELECT DISTINCT apa01 ",
                   "   FROM apa_file LEFT OUTER JOIN apb_file ON apa01=apb01 ", 
                   "  WHERE (apa00 = '21' OR apa00 = '11') ",
                   "    AND YEAR(apa02) =",tm.ape02," AND MONTH(apa02) =",tm.ape03,
                   "    AND apa05 ='",l_ape.ape01,"'  AND apb12 IS NULL ",
                   "    AND apa41 = 'Y' AND apa42='N' )",
                   "    AND api02 = '2' '"
         PREPARE sel_pr4 FROM g_sql
         EXECUTE sel_pr4 INTO l_ape.ape16
         LET l_ape.ape14=0
         LET l_ape.ape18=0
      END IF
      IF cl_null(l_ape.ape09) THEN LET l_ape.ape09=0 END IF
      IF cl_null(l_ape.ape11) THEN LET l_ape.ape11=0 END IF
      IF cl_null(l_ape.ape10) THEN LET l_ape.ape10=0 END IF
      IF cl_null(l_ape.ape12) THEN LET l_ape.ape12=0 END IF  
      IF cl_null(l_ape.ape13) THEN LET l_ape.ape13=0 END IF
      IF cl_null(l_ape.ape15) THEN LET l_ape.ape15=0 END IF 
      IF cl_null(l_ape.ape17) THEN LET l_ape.ape17=0 END IF   
      IF cl_null(l_ape.ape14) THEN LET l_ape.ape14=0 END IF
      IF cl_null(l_ape.ape16) THEN LET l_ape.ape16=0 END IF 
      IF cl_null(l_ape.ape18) THEN LET l_ape.ape18=0 END IF 
      #期末
      LET l_ape.ape19=l_ape.ape05+l_ape.ape09+l_ape.ape13
      LET l_ape.ape20=l_ape.ape06+l_ape.ape10+l_ape.ape14
      LET l_ape.ape21=l_ape.ape07+l_ape.ape11+l_ape.ape15
      LET l_ape.ape22=l_ape.ape08+l_ape.ape12+l_ape.ape16
      LET l_ape.ape29=g_today   
      LET l_ape.ape23=0
      LET l_ape.ape24=0
      LET l_ape.ape25=0
      LET l_ape.ape26=0   
     #INSERT INTO ape_file VALUES l_ape.*    #fengmy131101 mark
     #fengmy131101--begin-------
      INSERT INTO ape_file (ape01,ape02,ape03,ape04,ape05,
                            ape06,ape07,ape08,ape09,ape10,
                            ape11,ape12,ape13,ape14,ape15,
                            ape16,ape17,ape18,ape19,ape20,
                            ape21,ape22,ape23,ape24,ape25,
                            ape26,ape27,ape28,ape29)
      VALUES (l_ape.ape01,l_ape.ape02,l_ape.ape03,l_ape.ape04,l_ape.ape05, 
              l_ape.ape06,l_ape.ape07,l_ape.ape08,l_ape.ape09,l_ape.ape10,
              l_ape.ape11,l_ape.ape12,l_ape.ape13,l_ape.ape14,l_ape.ape15,
              l_ape.ape16,l_ape.ape17,l_ape.ape18,l_ape.ape19,l_ape.ape20,
              l_ape.ape21,l_ape.ape22,l_ape.ape23,l_ape.ape24,l_ape.ape25,
              l_ape.ape26,l_ape.ape27,l_ape.ape28,l_ape.ape29)  
     #fengmy131101--end    
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg=l_ape.ape01,'/',l_ape.ape04
         CALL s_errmsg('ape01,ape04',g_showmsg,'ins ape:',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END FOREACH
   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   DISPLAY g_time
END FUNCTION
#No.FUN-CB0124---end
