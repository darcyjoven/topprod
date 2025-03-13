# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglq134.4gl
# Descriptions...: 暫估明細查詢作業
# Date & Author..: No.FUN-CB0124 12/11/29 By wangrr

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE tm         RECORD 
       bm         LIKE apa_file.apa02,
       em         LIKE apa_file.apa02,
       t          LIKE type_file.chr1
       END RECORD,
       g_apa05    LIKE apa_file.apa05,
       g_apb12    LIKE apb_file.apb12
DEFINE g_apa      DYNAMIC ARRAY OF RECORD
       apa05      LIKE apa_file.apa05,
       pmc03      LIKE pmc_file.pmc03,
       apb12      LIKE apb_file.apb12,
       ima02      LIKE ima_file.ima02,
       ima021     LIKE ima_file.ima021,
       apa02      LIKE apa_file.apa02,
       apa00      LIKE apa_file.apa00,
       apb21      LIKE apb_file.apb21,
       apb22      LIKE apb_file.apb22,
       apb01_unap LIKE apb_file.apb01,
       apb02_unap LIKE apb_file.apb02,
       rvv87      LIKE rvv_file.rvv87,
       rvv39      LIKE rvv_file.rvv39,
       num1       LIKE apb_file.apb09,
       amt1       LIKE apb_file.apb10,
       num2       LIKE apb_file.apb09,
       amt2       LIKE apb_file.apb10,
       apb09      LIKE apb_file.apb09,
       apb10      LIKE apb_file.apb10,
       diff       LIKE apb_file.apb10,
       num3       LIKE apb_file.apb09,
       amt3       LIKE apb_file.apb10
       END RECORD
DEFINE g_wc,g_sql       STRING,
       l_ac             LIKE type_file.num5,
       g_rec_b          LIKE type_file.num5
DEFINE g_cnt            LIKE type_file.num10 
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10 
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE mi_no_ask        LIKE type_file.num5

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time       #計算使用時間 (進入時間) 
   LET g_wc=ARG_VAL(1)
   LET tm.bm=ARG_VAL(2)
   LET tm.em=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   CALL q134_table()        #臨時表 
   LET p_row = 2 LET p_col = 10
   OPEN WINDOW q134_w AT p_row,p_col WITH FORM "agl/42f/aglq134"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL q134_tm()
   ELSE
      CALL q134()
   END IF
   CALL q134_menu()
   DROP TABLE q134_tmp;
   DROP TABLE q134_tmp2;
   CLOSE WINDOW q134_w             #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time       #計算使用時間 (退出使間)
END MAIN

#中文的MENU
FUNCTION q134_menu()
   
   WHILE TRUE
      CALL q134_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q134_tm()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apa),'','')
             END IF
      END CASE
   END WHILE
END FUNCTION
 
#QBE 查詢資料
FUNCTION q134_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01 
   CLEAR FORM #清除畫面
   CALL g_apa.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL
   CALL cl_set_head_visible("","YES")
   CALL q134_getday()
   LET tm.t='1'
   DISPLAY tm.bm,tm.em,tm.t TO bm,em,t
   WHILE TRUE
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.bm,tm.em,tm.t ATTRIBUTE(WITHOUT DEFAULTS)
            BEFORE INPUT
               CALL cl_qbe_display_condition(lc_qbe_sn)
           
            AFTER FIELD bm
               IF NOT cl_null(tm.bm) THEN
                  IF NOT cl_null(tm.bm) AND tm.bm>tm.em THEN
                     CALL cl_err('','mfg9234',0)
                     NEXT FIELD bm
                  END IF
               END IF
    
            AFTER FIELD em
               IF cl_null(tm.em) THEN
                  LET tm.em =g_lastdat
               ELSE
                  IF YEAR(tm.em) <> YEAR(tm.em) THEN NEXT FIELD em END IF
                  IF NOT cl_null(tm.bm) AND tm.em < tm.bm THEN
                     CALL cl_err(' ','agl-031',0)
                     NEXT FIELD em
                  END IF
               END IF
   
            ON ACTION locale
               CALL cl_show_fld_cont() 
               LET g_action_choice = "locale"
               EXIT DIALOG    
    
            ON ACTION CONTROLZ
               CALL cl_show_req_fields()

            ON ACTION CONTROLG
               CALL cl_cmdask()

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG

           ON ACTION about  
               CALL cl_about()

            ON ACTION help   
               CALL cl_show_help()
  
            ON ACTION exit
               LET INT_FLAG = 1
               EXIT DIALOG        
               
         END INPUT
         CONSTRUCT g_wc ON apa05,apb12,apb21,apb22
                      FROM s_apa[1].apa05,s_apa[1].apb12,
                           s_apa[1].apb21,s_apa[1].apb22
          BEFORE CONSTRUCT
               CALL cl_qbe_init()

            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(apa05) #供應商
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_apa05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apa05
                     NEXT FIELD apa05
                  WHEN INFIELD(apb12) #料號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_ima"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apb12
                     NEXT FIELD apb12
                  WHEN INFIELD(apb21)
                     CALL q_rvv2(TRUE,TRUE,g_apa[1].apa05,
                                       g_apa[1].apb21,g_apa[1].apb22,NULL,g_plant)
                           RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO apb21
                     NEXT FIELD apb21
               END CASE

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE DIALOG

            ON ACTION about 
               CALL cl_about()

            ON ACTION help
               CALL cl_show_help()

            ON ACTION controlg 
               CALL cl_cmdask()  

            ON ACTION qbe_select
               CALL cl_qbe_select()

            ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT 
         ON ACTION ACCEPT
            EXIT DIALOG  
          
         ON ACTION CANCEL
            LET INT_FLAG=1
            EXIT DIALOG  
      END DIALOG 
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
      END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         RETURN
      END IF 
      IF cl_null(g_wc) THEN LET g_wc=" 1=1 " END IF
      EXIT WHILE
   END WHILE
   CALL q134()

END FUNCTION
 
FUNCTION q134()
   DEFINE l_apa05     LIKE apa_file.apa05,
          l_apb12     LIKE apb_file.apb12,
          l_num1      LIKE apb_file.apb09,
          l_amt1      LIKE apb_file.apb10,
          l_num2      LIKE apb_file.apb09,
          l_amt2      LIKE apb_file.apb10,
          l_num3      LIKE apb_file.apb09,
          l_amt3      LIKE apb_file.apb10,
          l_date      LIKE apa_file.apa02,
          l_apb09     LIKE apb_file.apb09,
          l_apb10     LIKE apb_file.apb10
   DEFINE l_sql       STRING
   
   DELETE FROM q134_tmp;
   DELETE FROM q134_tmp2;

   LET g_sql=" SELECT DISTINCT apa05,apb12 FROM (",
             " SELECT DISTINCT apa05,apb12 FROM apa_file,apb_file",
             "  WHERE apa01=apb01 AND apa00 IN ('16','26')",
             "    AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
             "    AND apa41='Y' AND apa42='N' AND ",g_wc CLIPPED,
             "  UNION ALL ",
             " SELECT DISTINCT apa05,apb12 FROM apa_file,apb_file",
             "  WHERE apa01=apb01 AND apa00 IN ('11','21')",
             "    AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
             "    AND apa41='Y' AND apa42='N' AND apb34='Y' AND ",g_wc CLIPPED,
             "  ORDER BY apa05,apb12 )"
   PREPARE q134_prepare FROM g_sql
   DECLARE q134_cs CURSOR FOR q134_prepare
   
   LET g_sql = "INSERT INTO q134_tmp ",
               " VALUES( ?,?,?,?,?,  ?,?,?,?,?, ",
               "         ?,?,?,?,?,  ?,?,?,?   ) "
   PREPARE insert_prep FROM g_sql
   
   FOREACH q134_cs INTO l_apa05,l_apb12
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH q134_cs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #期初
      LET l_num3=0  LET l_amt3=0
      SELECT ape05+ape06,ape07+ape08 INTO l_num3,l_amt3 FROM ape_file
       WHERE ape02=YEAR(tm.bm) AND ape03=MONTH(tm.bm) 
         AND ape01=l_apa05 AND ape04=l_apb12 
      IF cl_null(l_num3) THEN LET l_num3=0 END IF
      IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
      IF DAY(tm.bm)-1>0 THEN
         LET l_sql= YEAR(tm.bm),'/',MONTH(tm.bm),'/01'
         LET l_date=l_sql
         #入庫暫估+倉退暫估(-)
         LET g_sql="SELECT SUM(amt1),SUM(amt2) FROM(",
                   " SELECT SUM(apb09) amt1,SUM(apb10) amt2 ",   #入庫暫估(+)
                   "   FROM apa_file,apb_file",
                   "  WHERE apa01=apb01 AND apa00='16' AND apa41='Y'",
                   "    AND apa02 BETWEEN '",l_date,"' AND '",tm.bm-1,"'",
                   "    AND apa05='",l_apa05,"' AND apb12='",l_apa05,"'",
                   "  UNION ALL ",
                   " SELECT -1*SUM(apb09) amt1,-1*SUM(apb10) amt2 ",  #倉退暫估(-)
                   "   FROM apa_file,apb_file ",
                   "  WHERE apa01=apb01 AND apa00='26' AND apa41='Y'",
                   "    AND apa02 BETWEEN '",l_date,"' AND '",tm.bm-1,"'",
                   "    AND apa05='",l_apa05,"' AND apb12='",l_apa05,"'",
                   "  UNION ALL ",
                   " SELECT -1*SUM(apb09) amt1,0 amt2",     #入庫暫估沖抵(-)
                   "   FROM apa_file,apb_file", 
                   "  WHERE apa01 = apb01 AND apa00 = '11' ",
                   "    AND apa02 BETWEEN '",l_date,"' AND '",tm.bm-1,"'",
                   "    AND apa05='",l_apa05,"' AND apb12='",l_apa05,"'",
                   "    AND apa41 = 'Y' AND apb29 = '1' AND apb34 = 'Y'",
                   "  UNION ALL ",
                   " SELECT 0 amt1,-1*SUM(api05) amt2 FROM api_file ",
                   "  WHERE api01||api03 IN (",
                   " SELECT DISTINCT apa01||apb02 FROM apa_file,apb_file", 
                   "  WHERE apa01 = apb01 AND apa00 = '11' ",
                   "    AND apa02 BETWEEN '",l_date,"' AND '",tm.bm-1,"'",
                   "    AND apa05='",l_apa05,"' AND apb12='",l_apa05,"'",
                   "    AND apa41 = 'Y' AND apb29 = '1' AND apb34 = 'Y')",
                   "    AND api02 = '2' AND api26 <> 'DIFF'",
                   "  UNION ALL ",
                   " SELECT SUM((case when apb09<0 then -1*apb09  else apb09 end)) amt1,0 amt2 ",  #倉退暫估沖抵(+)
                   "   FROM apa_file,apb_file", 
                   "  WHERE apa01 = apb01 AND (apa00 = '21' OR apa00 = '11')",
                   "    AND apa02 BETWEEN '",l_date,"' AND '",tm.bm-1,"'",
                   "    AND apa05='",l_apa05,"' AND apb12='",l_apa05,"'",
                   "    AND apa41 = 'Y' AND apb29 = '3' AND apb34 = 'Y'",
                   "  UNION ALL ",
                   " SELECT 0 amt1,SUM((case when api05<0 then -1*api05  else api05 end)) amt2 FROM api_file ",
                   "  WHERE api01||api03 IN (",
                   " SELECT DISTINCT apa01||apb02 FROM apa_file,apb_file", 
                   "  WHERE apa01 = apb01 AND (apa00 = '21' OR apa00 = '11') ",
                   "    AND apa02 BETWEEN '",l_date,"' AND '",tm.bm-1,"'",
                   "    AND apa05='",l_apa05,"' AND apb12='",l_apa05,"'",
                   "    AND apa41 = 'Y' AND apb29 = '3' AND apb34 = 'Y')",
                   "    AND api02 = '2' AND api26 <> 'DIFF'",
                   ")"
         PREPARE sel_pr1 FROM g_sql
         EXECUTE sel_pr1 INTO l_num1,l_amt1
         IF cl_null(l_num1) THEN LET l_num1=0 END IF
         IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
         LET l_num3=l_num3+l_num1
         LET l_amt3=l_amt3+l_amt1
      END IF
      EXECUTE insert_prep USING l_apa05,l_apb12,'','00','','','','','','',
                                '','','','','0','0','0',l_num3,l_amt3
   END FOREACH

   LET g_sql="SELECT apa05,pmc03,apb12,ima02,ima021,apa02,apa00,apb21,apb22,",  #apa00='11'入庫暫估沖抵(-)
             "       apb01 apb01_unap,apb02 apb02_unap,rvv87,rvv39,0 num1,0 amt1,",
             "       0 num2,0 amt2,-1*apb09 apb09,-1*api05 apb10,api05-apb10 diff,",
             "       0 num3,0 amt3 ",   
             "  FROM apa_file LEFT OUTER JOIN pmc_file ON (apa05=pmc01),",
             "       apb_file LEFT OUTER JOIN rvv_file ON (apb21=rvv01 AND apb22=rvv02) ",
             "                LEFT OUTER JOIN api_file ON (apb01=api01 AND apb02=api03) ",
             "                LEFT OUTER JOIN ima_file ON (apb12=ima01) ",
             " WHERE apa01 = apb01 AND apa00 ='11'",
             "   AND apa41 = 'Y' AND apa42='N' AND apb34='Y' AND apb29='1'",
             "   AND api02='2' AND api26<>'DIFF'",
             "   AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
             "   AND ",g_wc CLIPPED,
             " UNION ALL ",
             "SELECT apa05,pmc03,apb12,ima02,ima021,apa02,'12' apa00,apb21,apb22,",#apa00='21'倉退暫估沖抵,為方便後面排序apa00='12',排序后更新為'21'(+)
             "       apb01 apb01_unap,apb02 apb02_unap,-1*rvv87 rvv87,-1*rvv39 rvv39,",
             "       0 num1,0 amt1,0 num2,0 amt2,",
             "       (case when apb09<0 then -1*apb09 else apb09 end) apb09,",
             "       (case when api05<0 then -1*api05 else api05 end) apb10,",
             "       ((case when api05<0 then -1*api05 else api05 end)-(case when apb10<0 then -1*apb10 else apb10 end)) diff, ",
             "       0 num3,0 amt3",
             " FROM apa_file LEFT OUTER JOIN pmc_file ON (apa05=pmc01),",
             "      apb_file LEFT OUTER JOIN rvv_file ON (apb21=rvv01 AND apb22=rvv02)",
             "               LEFT OUTER JOIN api_file ON (apb01=api01 AND apb02=api03)",
             "               LEFT OUTER JOIN ima_file ON (apb12=ima01) ",
             " WHERE apa01=apb01 AND (apa00 ='21' OR apa00='11')",
             "   AND apa41='Y' AND apa42='N' AND apb34='Y' AND apb29='3'",
             "   AND api02='2' AND api26<>'DIFF'",
             "   AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
             "   AND ",g_wc CLIPPED,
             " UNION ALL ",
             " SELECT apa05,pmc03,apb12,ima02,ima021,apa02,apa00,apb21,apb22,", #apa00='16'暫估立帳(+)
             "        apb01 apb01_unap,apb02 apb02_unap,rvv87,rvv39,apb09 num1,",
             "        apb10 amt1,0 num2,0 amt2,apb09,apb10,0 diff,0 num3,0 amt3 ",     
             " FROM apa_file LEFT OUTER JOIN pmc_file ON (apa05=pmc01),",
             "      apb_file LEFT OUTER JOIN rvv_file ON (apb21=rvv01 AND apb22=rvv02)",
             "               LEFT OUTER JOIN ima_file ON (apb12=ima01) ",
             " WHERE apa01 = apb01 AND apa00 = '16' AND apa41 = 'Y'",
             "   AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'", 
             "   AND ",g_wc CLIPPED,
             " UNION ALL ",
             " SELECT apa05,pmc03,apb12,ima02,ima021,apa02,apa00,apb21,apb22,", #apa00='26'暫估立帳(-)
             "        apb01 apb01_unap,apb02 apb02_unap,-1*rvv87 rvv87,-1*rvv39 rvv39,-1*apb09 num1,",
             "        -1*apb10 amt1,0 num2,0 amt2,-1*apb09 apb09,-1*apb10 apb10,0 diff,0 num3,0 amt3 ",
             " FROM apa_file LEFT OUTER JOIN pmc_file ON (apa05=pmc01),",
             "      apb_file LEFT OUTER JOIN rvv_file ON (apb21=rvv01 AND apb22=rvv02)",
             "               LEFT OUTER JOIN ima_file ON (apb12=ima01) ",
             " WHERE apa01 = apb01 AND apa00 ='26'  AND apa41 = 'Y'",
             "   AND apa02 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
             "   AND ",g_wc CLIPPED,
             " UNION ALL ",
             " SELECT apa05,pmc03,apb12,ima02,ima021,apa02,apa00,apb21,apb22,apb01_unap,apb02_unap,", #期初
             "        rvv87,rvv39,num1,amt1,num2,amt2,apb09,apb10,diff,num3,amt3 ",
             "  FROM q134_tmp LEFT OUTER JOIN pmc_file ON (apa05=pmc01) ",
             "                LEFT OUTER JOIN ima_file ON (apb12=ima01) "
   #插入臨時表并排序
   LET g_sql = " INSERT INTO q134_tmp2 ",
               "   SELECT x.*,ROWNUM ",
               "     FROM (",g_sql CLIPPED," order by apa05,apb12,apa00,apa02 ASC ) x "
   PREPARE q134_ins FROM g_sql
   EXECUTE q134_ins

   UPDATE q134_tmp2 SET apa00='21' WHERE apa00='12' #更新'12'回'21'
   #暫估單號和項次
   LET g_sql = " MERGE INTO q134_tmp2 o ",
               "      USING (SELECT apb01,apb02,apb21,apb22 ",
               "               FROM apa_file,apb_file ",
               "              WHERE apa01=apb01 AND apa00 IN ('16','26') ",
               "                AND apa41 = 'Y' AND apa42='N' ",
               "              ) n ",
               "         ON (o.apb21 = n.apb21 AND o.apb22 = n.apb22) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.apb01_unap = n.apb01, o.apb02_unap = n.apb02"
   PREPARE q134_pr2 FROM g_sql
   EXECUTE q134_pr2
   
   #入庫/倉退數量和金額為空時更新為0
   UPDATE q134_tmp2 SET rvv87=0 WHERE (rvv87 IS NULL OR rvv87='') AND apa00 <>'00'
   UPDATE q134_tmp2 SET rvv39=0 WHERE (rvv39 IS NULL OR rvv39='') AND apa00 <>'00'

   
   #結餘計算：結餘=期初+累計異動(包括當前筆）
   LET g_sql = " MERGE INTO q134_tmp2 o ",
               "      USING (SELECT apa05,apb12,num3,amt3 ",
               "               FROM q134_tmp2 ",
               "              WHERE apa00='00' ",
               "              ) n ",
               "         ON (o.apa05 = n.apa05 AND o.apb12 = n.apb12)",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.num3=n.num3,o.amt3=n.amt3 ",
               "     WHERE o.apa00 IN ('11','21','16','26')"
   PREPARE q134_pr3 FROM g_sql
   EXECUTE q134_pr3
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
   END IF
   
   #結餘數量
   LET g_sql="UPDATE q134_tmp2 o",
             "   SET o.num3=o.num3+(SELECT SUM(a.apb09) FROM q134_tmp2 a",
             "       WHERE a.apa05=o.apa05  AND a.apb12=o.apb12",
             "         AND a.apa00<>'00' ",
             "         AND a.rowno<=o.rowno)",
             " WHERE o.apa00 IN ('11','21','16','26')"
    PREPARE q134_pr4 FROM g_sql
    EXECUTE q134_pr4 
    IF STATUS THEN
       CALL cl_err('',STATUS,0)
    END IF
    
    #結餘金額
    LET g_sql="UPDATE q134_tmp2 o",
             "   SET o.amt3=o.amt3+(SELECT SUM(a.apb10) FROM q134_tmp2 a",
             "       WHERE a.apa05=o.apa05  AND a.apb12=o.apb12",
             "         AND a.apa00<>'00' ",
             "         AND a.rowno<=o.rowno)",
             " WHERE o.apa00 IN ('11','21','16','26')"
    PREPARE q134_pr5 FROM g_sql
    EXECUTE q134_pr5 
    IF STATUS THEN
       CALL cl_err('',STATUS,0)
    END IF
    
   #已沖暫估金額和數量apa00='11','21'(結餘-期初)
   LET g_sql = " MERGE INTO q134_tmp2 o ",
               "      USING (SELECT apa05,apb12,num3,amt3 ",
               "               FROM q134_tmp2 ",
               "              WHERE apa00='00' ",
               "              ) n ",
               "         ON (o.apa05 = n.apa05 AND o.apb12 = n.apb12)",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.num2=o.num3-n.num3,o.amt2=o.amt3-n.amt3",
               "     WHERE o.apa00 IN ('11','21','16','26')"
   PREPARE q134_pr6 FROM g_sql
   EXECUTE q134_pr6
   IF STATUS THEN
       CALL cl_err('',STATUS,0)
    END IF
    
   #apa00='16','26'已沖暫估金額和數量(結餘-期初-累計當期異動(包括本幣在內的前幾筆總和))
   #已沖暫估數量
   LET g_sql="UPDATE q134_tmp2 o",
             "   SET o.num2=o.num2-(SELECT SUM(a.apb09) FROM q134_tmp2 a",
             "       WHERE a.apa05=o.apa05  AND a.apb12=o.apb12",
             "         AND a.apa00 IN ('16','26') ",
             "         AND a.rowno<=o.rowno)",
             " WHERE o.apa00 IN ('16','26')"
    PREPARE q134_pr7 FROM g_sql
    EXECUTE q134_pr7 
    IF STATUS THEN
       CALL cl_err('',STATUS,0)
    END IF
    
    #已沖暫估金額
   LET g_sql="UPDATE q134_tmp2 o",
             "   SET o.amt2=o.amt2-(SELECT SUM(a.apb10) FROM q134_tmp2 a",
             "       WHERE a.apa05=o.apa05  AND a.apb12=o.apb12",
             "         AND a.apa00 IN ('16','26') ",
             "         AND a.rowno<=o.rowno)",
             " WHERE o.apa00 IN ('16','26')"
    PREPARE q134_pr8 FROM g_sql
    EXECUTE q134_pr8 
    IF STATUS THEN
       CALL cl_err('',STATUS,0)
    END IF
    
    LET g_sql="SELECT apa05,pmc03,apb12,ima02,ima021,apa02,apa00,apb21,apb22,",
             "       apb01_unap,apb02_unap,rvv87,rvv39,num1,amt1,num2,amt2,",
             "       apb09,apb10,diff,num3,amt3 ",
             "  FROM q134_tmp2 "
   CASE 
      WHEN tm.t='1' LET g_sql=g_sql," WHERE apa00 IN ('16','26') "
      WHEN tm.t='2' LET g_sql=g_sql," WHERE apa00 IN ('11','21') "
   END CASE     
   LET g_sql=g_sql," ORDER BY rowno"
   PREPARE q134_bpr FROM g_sql
   DECLARE q134_bcs CURSOR FOR q134_bpr
   CALL g_apa.clear()
   LET g_cnt = 1
   FOREACH q134_bcs INTO g_apa[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH q134_bcs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN  
         CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
   END FOREACH
   CALL g_apa.deleteElement(g_cnt) 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q134_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE DISPLAY    
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                                                                         	
         CALL cl_set_head_visible("","AUTO")   
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q134_getday()
   DEFINE l_year     LIKE  type_file.num5
   DEFINE l_month    LIKE  type_file.num5
   DEFINE l_bdate    LIKE type_file.chr20
   DEFINE l_edate    LIKE type_file.chr20
   LET l_year = YEAR(g_today)
   LET l_month = MONTH(g_today)
   LET l_bdate = l_year,'/',l_month ,'/01'
   CASE 
      WHEN (l_month = '1' OR l_month = '3' OR l_month = '5' OR l_month = '7' OR 
           l_month = '8' OR l_month = '10' OR l_month = '12' )
         LET l_edate  = l_year,'/',l_month ,'/31'
      WHEN (l_month = '4' OR l_month = '6' OR l_month = '9' OR l_month = '11')
         LET l_edate  = l_year,'/',l_month,'/30'                 
      WHEN  (l_month = '2')  
         IF (l_year MOD 4 = 0 AND l_year MOD 100 !=0) OR (l_year MOD 400 = 0) THEN
            LET l_edate  = l_year,'/0',l_month,'/29'
         ELSE
            LET l_edate  = l_year,'/0',l_month,'/28'
         END IF
   END CASE   
   LET tm.bm = l_bdate
   LET tm.em = l_edate  
END FUNCTION 

FUNCTION q134_table()
   DROP TABLE q134_tmp;
   CREATE TEMP TABLE q134_tmp(
       apa05      LIKE apa_file.apa05,
       apb12      LIKE apb_file.apb12,
       apa02      LIKE apa_file.apa02,
       apa00      LIKE apa_file.apa00,
       apb21      LIKE apb_file.apb21,
       apb22      LIKE apb_file.apb22,
       apb01_unap LIKE apb_file.apb01,
       apb02_unap LIKE apb_file.apb02,
       rvv87      LIKE rvv_file.rvv87,
       rvv39      LIKE rvv_file.rvv39,
       num1       LIKE apb_file.apb09,
       amt1       LIKE apb_file.apb10,
       num2       LIKE apb_file.apb09,
       amt2       LIKE apb_file.apb10,
       apb09      LIKE apb_file.apb09,
       apb10      LIKE apb_file.apb10,
       diff       LIKE apb_file.apb10,
       num3       LIKE apb_file.apb09,
       amt3       LIKE apb_file.apb10);
   DROP TABLE q134_tmp2;
   CREATE TEMP TABLE q134_tmp2(
       apa05      LIKE apa_file.apa05,
       pmc03      LIKE pmc_file.pmc03,
       apb12      LIKE apb_file.apb12,
       ima02      LIKE ima_file.ima02,
       ima021     LIKE ima_file.ima021,
       apa02      LIKE apa_file.apa02,
       apa00      LIKE apa_file.apa00,
       apb21      LIKE apb_file.apb21,
       apb22      LIKE apb_file.apb22,
       apb01_unap LIKE apb_file.apb01,
       apb02_unap LIKE apb_file.apb02,
       rvv87      LIKE rvv_file.rvv87,
       rvv39      LIKE rvv_file.rvv39,
       num1       LIKE apb_file.apb09,
       amt1       LIKE apb_file.apb10,
       num2       LIKE apb_file.apb09,
       amt2       LIKE apb_file.apb10,
       apb09      LIKE apb_file.apb09,
       apb10      LIKE apb_file.apb10,
       diff       LIKE apb_file.apb10,
       num3       LIKE apb_file.apb09,
       amt3       LIKE apb_file.apb10,
       rowno      LIKE type_file.num10);
END FUNCTION 
#No.FUN-CB0124---end
