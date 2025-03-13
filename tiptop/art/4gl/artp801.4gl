# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artp801.4gl 
# Descriptions...: 盤點清單生成盤點單
# Date & Author..: FUN-B50033 11/05/11 By huangtao
# Modify.........: No.TQC-C10114 12/01/30 By pauline 抓取核算單資料時加入判斷核算單確認否欄位(rcdconf)必須為'Y.已確認' 
# Modify.........: No.TQC-C20262 12/02/20 By fanbj 對賬單單號取號時應依據單據日期

DATABASE ds
 
GLOBALS "../../config/top.global"
 

DEFINE g_rch	        RECORD LIKE rch_file.*,
       g_rci	        RECORD LIKE rci_file.*
      

DEFINE g_t1       	    LIKE oay_file.oayslip     
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE g_sql             STRING
DEFINE g_org             STRING
DEFINE g_cb              LIKE type_file.chr1
DEFINE g_bdate           LIKE type_file.dat
DEFINE g_edate           LIKE type_file.dat
DEFINE g_chk_azw01       LIKE type_file.chr1
DEFINE g_chk_auth        STRING  
DEFINE g_azw01           LIKE azw_file.azw01 
  
 
MAIN
   DEFINE l_flag   LIKE type_file.chr1
   DEFINE ls_date  STRING 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
           
   OPEN WINDOW p801_w WITH FORM "art/42f/artp801"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
       LET g_rch.rchplant= g_plant
       LET g_rch.rchlegal= g_legal
       LET g_rch.rchuser = g_user
       LET g_rch.rchgrup = g_grup
       LET g_rch.rchorig = g_grup
       LET g_rch.rchcrat = g_today
       LET g_rch.rchoriu = g_user
       LET g_rch.rchconf = 'N'
       LET g_rch.rchcond = ''
       LET g_rch.rchcont = ''
       LET g_rch.rchmodu = ''
       LET g_rch.rchdate = ''
       LET g_rch.rchacti = 'Y'
       CALL p801_p1()
       IF cl_sure(18,20) THEN
          CALL s_showmsg_init()
          BEGIN WORK
          LET g_success = 'Y'
          CALL p801_p2()
          CALL s_showmsg()
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p801_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
   END WHILE
   CLOSE WINDOW p801_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 

FUNCTION p801_p1()
DEFINE l_n        LIKE type_file.num5
DEFINE l_ck       LIKE type_file.chr50
DEFINE tok        base.StringTokenizer
DEFINE l_flag     LIKE type_file.chr1
DEFINE l_sql      STRING
DEFINE l_days     LIKE type_file.num5
 
  WHILE TRUE
     CLEAR FORM

     INPUT g_org WITHOUT DEFAULTS FROM plant
        BEFORE INPUT
          CALL cl_qbe_init()

        AFTER FIELD plant
            LET g_chk_azw01 = TRUE 
            LET g_chk_auth = '' 
            IF NOT cl_null(g_org) AND g_org<> "*" THEN
               LET g_chk_azw01 = FALSE 
               LET tok = base.StringTokenizer.create(g_org,"|") 
               LET g_azw01 = ""
               WHILE tok.hasMoreTokens() 
                   LET g_azw01 = tok.nextToken()
                   LET l_sql = " SELECT COUNT(*) FROM azw_file",
                               " WHERE azw01 ='",g_azw01,"'",
                               " AND azw01 IN ",g_auth,
                               " AND azwacti = 'Y'"
                  PREPARE sel_num_pre FROM l_sql
                  EXECUTE sel_num_pre INTO l_n 
                      IF l_n > 0 THEN
                          IF g_chk_auth IS NULL THEN
                             LET g_chk_auth = "'",g_azw01,"'"
                          ELSE
                             LET g_chk_auth = g_chk_auth,",'",g_azw01,"'"
                          END IF 
                      ELSE
                         CONTINUE WHILE
                      END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF
            END IF
            IF g_chk_azw01 THEN
               LET g_chk_auth = g_auth
            END IF
        
          
         ON ACTION CONTROLP                  
            CASE
              WHEN INFIELD(plant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw01_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET g_org = g_qryparam.multiret 
                  DISPLAY g_org TO plant
                  NEXT FIELD plant
             END CASE
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
            
          AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF 

     END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

     LET g_rch.rch03 = YEAR(g_today)
     LET g_rch.rch04 = MONTH(g_today)
     LET g_rch.rch02 = g_today
     LET g_cb = 'N'
     LET g_rch.rch01 = ''
     INPUT g_rch.rch03,g_rch.rch04,g_rch.rch01,g_rch.rch02,g_cb WITHOUT DEFAULTS
        FROM rch03,rch04,rch01,rch02,cb
 
         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD rch03
           IF NOT cl_null(g_rch.rch03) THEN
              IF g_rch.rch03 <=0 THEN
                  CALL cl_err('','art-836',0)
                  NEXT FIELD rch03
              END IF
           END IF
           
         AFTER FIELD rch04
           IF NOT cl_null(g_rch.rch04) THEN
              IF g_rch.rch04 <1 OR g_rch.rch04>12 THEN
                 CALL cl_err('','art-837',0)
                 NEXT FIELD rch04
              END IF
              IF NOT cl_null(g_rch.rch03) THEN
                 LET l_days = cl_days(g_rch.rch03,g_rch.rch04)
                 LET g_bdate = MDY(g_rch.rch04,1,g_rch.rch03)
                 LET g_edate = MDY(g_rch.rch04,l_days,g_rch.rch03)
                 DISPLAY g_bdate TO bdate
                 DISPLAY g_edate TO edate
              END IF
           END IF
      
         AFTER FIELD rch01
            IF NOT cl_null(g_rch.rch01) THEN
              SELECT COUNT(*) INTO l_n FROM oay_file
               WHERE oayslip = g_rch.rch01
                 AND oaysys = 'art'
                 AND oaytype = 'G3'
              IF l_n = 0  THEN
                 CALL cl_err('','art-835',0)
                 NEXT FIELD rch01
              END IF  
            END IF
     
         
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
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
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION CONTROLP  
           CASE  
             WHEN INFIELD(rch01)
               CALL q_oay(FALSE,FALSE,g_rch.rch01,'G3','ART') RETURNING g_rch.rch01
               DISPLAY g_rch.rch01 TO rch01
               NEXT FIELD rch01
           END CASE
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      EXIT WHILE
  END WHILE
 
END FUNCTION


FUNCTION p801_p2()
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_count     LIKE type_file.num5
   DEFINE l_ck        LIKE type_file.chr50
   DEFINE tok         base.StringTokenizer
   DEFINE l_plant     LIKE azp_file.azp01
   DEFINE l_rcd02     LIKE rcd_file.rcd02
   DEFINE l_rcd04     LIKE rcd_file.rcd04
   DEFINE l_rce03     LIKE rce_file.rce03
   DEFINE l_rce06     LIKE rce_file.rce06
   DEFINE l_rcb08     LIKE rcb_file.rcb08  
   DEFINE l_sum_rci08 LIKE rch_file.rch08
   DEFINE l_sum_rci09 LIKE rch_file.rch09
   DEFINE l_sum_rci11 LIKE rch_file.rch10
   DEFINE l_sum_rci12 LIKE rch_file.rch11
   DEFINE l_lub03     LIKE lub_file.lub03
   DEFINE l_lub04     LIKE lub_file.lub04
   DEFINE l_lub04t    LIKE lub_file.lub04t
   DEFINE l_rch01     LIKE rch_file.rch01
   DEFINE l_occ42     LIKE occ_file.occ42
   DEFINE l_azi04     LIKE azi_file.azi04
   
   DROP TABLE artp801_tmp
    CREATE TEMP TABLE artp801_tmp(
              rcd02  LIKE rcd_file.rcd02,  #銷售日期
              rcd04  LIKE rcd_file.rcd04,  #核算金額含稅否
              rce03  LIKE rce_file.rce03,  #抽成代碼
              rce06  LIKE rce_file.rce06,  #核算銷售金額
              rcb08  LIKE rcb_file.rcb08)  #抽成率
    DELETE FROM artp801_tmp
   LET g_sql = "SELECT DISTINCT azp01 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 "
   PREPARE sel_azp01_pre FROM g_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre           
   FOREACH sel_azp01_cs INTO l_plant
      SELECT COUNT(*) INTO l_n FROM rch_file
       WHERE rch03 = g_rch.rch03
         AND rch04 = g_rch.rch04
         AND rchconf = 'Y'
         AND rch05 = l_plant
       IF l_n > 0 THEN
         CALL s_errmsg('','',l_plant,'art-838',2)
         CONTINUE FOREACH
       END IF
       SELECT COUNT(*) INTO l_n FROM rch_file
       WHERE rch03 = g_rch.rch03
         AND rch04 = g_rch.rch04
         AND rchconf = 'N'
         AND rch05 = l_plant  
       IF l_n > 0 THEN
          IF g_cb = 'N' THEN
            CALL s_errmsg('','',l_plant,'art-839',1)
            LET g_success = 'N'
            CONTINUE FOREACH
          ELSE
            DECLARE sel_rch01_cs CURSOR FOR 
             SELECT rch01 FROM rch_file
              WHERE rch03 = g_rch.rch03
                AND rch04 = g_rch.rch04
                AND rch05 = l_plant
                AND rchconf = 'N'
            FOREACH sel_rch01_cs INTO l_rch01
                DELETE FROM rch_file WHERE rch01 = l_rch01
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   CALL s_errmsg('','','del rch_file',SQLCA.SQLCODE,1)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF
                DELETE FROM rci_file WHERE rci01 = l_rch01
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   CALL s_errmsg('','','del rci_file',SQLCA.SQLCODE,1)
                   LET g_success = 'N'
                   EXIT FOREACH
                END IF 
             END FOREACH
          END IF
       END IF
      LET g_sql = "SELECT rcd02,rcd04,rce03,rce06 FROM ",cl_get_target_table(l_plant,'rcd_file'),","     
                                                          ,cl_get_target_table(l_plant,'rce_file'), 
                  " WHERE rcd01 = rce01 ",
                  " AND rcdplant = '",l_plant,"'",
                  " AND rcd02 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  " AND rcdconf = 'Y'"  #TQC-C10114 add
                                          
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
      CALL cl_parse_qry_sql(g_sql, l_plant) RETURNING g_sql      
      PREPARE pre_sel_rcde FROM g_sql
      DECLARE cur_rcde CURSOR FOR pre_sel_rcde
      FOREACH cur_rcde INTO l_rcd02,l_rcd04,l_rce03,l_rce06

         LET g_sql = " SELECT rcb08 FROM ",cl_get_target_table(l_plant,'rca_file'),"," 
                                          ,cl_get_target_table(l_plant,'rcb_file'), 
                     " WHERE rca01 = rcb01 AND rca02 = rcb02 AND rca03 = rcb03 ",
                     " AND rca02 <= '",l_rcd02,"'",
                     " AND rca03 >= '",l_rcd02,"'",
                     " AND rcaconf = 'Y' ",
                     " AND rcb05 = '",l_rce03,"'",
                     " AND rca01 = '",l_plant,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE sel_rcb08_pre FROM g_sql 
         EXECUTE sel_rcb08_pre INTO l_rcb08            
         IF cl_null(l_rcb08) OR SQLCA.SQLCODE = 100 THEN
            LET l_rcb08 = 0
         END IF   
         INSERT INTO artp801_tmp VALUES(l_rcd02,l_rcd04,l_rce03,l_rce06,l_rcb08)
      END FOREACH
         #CALL s_auto_assign_no("art",g_rch.rch01,g_today,'G3',"rch_file","rch01",g_plant,"","")  #TQC-C20262  mark
         CALL s_auto_assign_no("art",g_rch.rch01,g_rch.rch02,'G3',"rch_file","rch01",g_plant,"","") #TQC-C20262  add                  
               RETURNING li_result,g_rch.rch01
         IF (NOT li_result) THEN CONTINUE FOREACH END IF
         LET g_rch.rch05 = l_plant
         LET g_sql= "  SELECT rtz29  FROM ",cl_get_target_table(l_plant,'rtz_file'),
                    "  WHERE rtz01 = '",l_plant,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE sel_rch06_pre FROM g_sql 
         EXECUTE sel_rch06_pre INTO g_rch.rch06  
         LET g_sql = " SELECT occ41,occ42 FROM ",cl_get_target_table(l_plant,'occ_file'),
                     " WHERE occ01 = '",g_rch.rch06,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE sel_occ41_pre FROM g_sql 
         EXECUTE sel_occ41_pre INTO g_rch.rch07,l_occ42
          LET g_sql = " SELECT gec04,gec05,gec07 FROM ",cl_get_target_table(l_plant,'gec_file'),
                      " WHERE gec01 = '",g_rch.rch07,"'",
                      " AND gec011 = '2'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE sel_gec_pre FROM g_sql 
         EXECUTE sel_gec_pre INTO g_rch.rch071,g_rch.rch072,g_rch.rch073
         LET g_sql = " SELECT azi04 FROM ",cl_get_target_table(l_plant,'azi_file'),
                     " WHERE azi01 = '",l_occ42,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql         
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
         PREPARE sel_azi_pre FROM g_sql 
         EXECUTE sel_azi_pre INTO l_azi04
         LET g_rch.rch08 = 0
         LET g_rch.rch09 = 0
         LET g_rch.rch10 = 0
         LET g_rch.rch11 = 0
         LET g_sql = "INSERT INTO rch_file VALUES (", 
                     " ?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                     " ?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   
         PREPARE pre_ins_rch FROM g_sql
         EXECUTE pre_ins_rch USING g_rch.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','ins rch_file',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF 
       DECLARE p801_curs CURSOR FOR SELECT rcd04,rce03,SUM(rce06),rcb08 FROM artp801_tmp
                                    GROUP BY rcd04,rce03,rcb08 
       FOREACH p801_curs INTO  l_rcd04,l_rce03,l_rce06,l_rcb08
   
         IF cl_null(l_rce06) THEN
            LET l_rce06 = 0
         END IF
         LET g_rci.rci01 = g_rch.rch01
         LET g_rci.rci02 = '1'
         LET g_sql = " SELECT MAX(rci03)+1 FROM rci_file ",
                     " WHERE rci01 = '",g_rci.rci01,"'",
                     " AND rci02 = '1'"
         PREPARE sel_rci03_pre1 FROM g_sql
         EXECUTE sel_rci03_pre1 INTO  g_rci.rci03 
         IF g_rci.rci03 IS NULL OR g_rci.rci03 = 0 THEN
            LET g_rci.rci03 =1
         END IF
         LET g_rci.rci04 = l_rce03
         LET g_rci.rci05 = l_rcb08
         LET g_rci.rci06 = l_rcd04
         LET g_rci.rci07 = l_rce06
         IF g_rci.rci06 = 'N' THEN
           LET g_rci.rci08 = g_rci.rci07*(g_rci.rci05/100)
           LET g_rci.rci09 = g_rci.rci08*(1+g_rch.rch071/100)
         ELSE
           LET g_rci.rci09 = g_rci.rci07*(g_rci.rci05/100)
           LET g_rci.rci08 = g_rci.rci09/(1+g_rch.rch071/100)
         END IF
         
         LET g_rci.rci08 = cl_digcut(g_rci.rci08,l_azi04)
         LET g_rci.rci09 = cl_digcut(g_rci.rci09,l_azi04)
         LET g_rci.rci11 = 0
         LET g_rci.rci12 = 0
         LET g_rci.rciplant = g_plant
         LET g_rci.rcilegal = g_legal
         LET g_sql = "INSERT INTO rci_file VALUES (", 
                     " ?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   
         PREPARE pre_ins_rci1 FROM g_sql
         EXECUTE pre_ins_rci1 USING g_rci.*
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','ins rci_file',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
       END FOREACH 
       LET g_sql = " SELECT SUM(rci08),SUM(rci09) FROM rci_file ",
                   " WHERE rci01 = '",g_rch.rch01,"'",
                   " AND rci02 = '1'"   
       PREPARE sel_sum1_pre FROM g_sql
       EXECUTE sel_sum1_pre INTO l_sum_rci08,l_sum_rci09
       IF cl_null(l_sum_rci08) THEN
          LET l_sum_rci08 = 0
       END IF
       IF cl_null(l_sum_rci09) THEN
          LET l_sum_rci09 = 0
       END IF
       LET g_sql = " SELECT lub03,SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(l_plant,'lua_file'),",",
                                                                cl_get_target_table(l_plant,'lub_file'), 
                   " WHERE lua01 = lub01 ",
                   " AND lua09 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                   " AND luaplant = '",l_plant,"'",
                   " AND lua15 = 'Y'",
                   " AND lua21 = '",g_rch.rch07,"'",
                   " AND lua06 = '",g_rch.rch06,"'",
                   " AND lua32 = '4' ",
                   " GROUP BY luaplant,lub03 "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
        CALL cl_parse_qry_sql(g_sql, l_plant) RETURNING g_sql      
        PREPARE pre_sel_lub FROM g_sql
        DECLARE cur_sel_lub CURSOR FOR pre_sel_lub 
        FOREACH cur_sel_lub INTO l_lub03,l_lub04,l_lub04t
          LET g_rci.rci01= g_rch.rch01
          LET g_rci.rci02 = '2'
          LET g_sql = " SELECT MAX(rci03)+1 FROM rci_file ",
                      " WHERE rci01 = '",g_rci.rci01,"'",
                      " AND rci02 = '2'"    
          PREPARE sel_rci03_pre2 FROM g_sql
          EXECUTE sel_rci03_pre2 INTO  g_rci.rci03 
          IF cl_null(g_rci.rci03 ) OR g_rci.rci03 = 0 THEN
             LET g_rci.rci03 = 1
          END IF
          LET g_rci.rci08 = 0
          LET g_rci.rci09 = 0
          LET g_rci.rci10 = l_lub03
          LET g_rci.rci11 = l_lub04
          LET g_rci.rci12 = l_lub04t
          LET g_rci.rciplant = g_plant
          LET g_rci.rcilegal = g_legal
          LET g_sql = "INSERT INTO rci_file VALUES (", 
                     " ?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
         CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql     
         PREPARE pre_ins_rci2 FROM g_sql
         EXECUTE pre_ins_rci2 USING g_rci.*
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','ins rci_file',SQLCA.SQLCODE,1)
            LET g_success = 'N'
        END IF
        END FOREACH
        LET g_sql = " SELECT SUM(rci11),SUM(rci12) FROM rci_file ",
                   " WHERE rci01 = '",g_rch.rch01,"'",
                   " AND rci02 = '2'"   
       PREPARE sel_sum2_pre FROM g_sql
       EXECUTE sel_sum2_pre INTO l_sum_rci11,l_sum_rci12  
       IF cl_null(l_sum_rci11) THEN
          LET l_sum_rci11 = 0
       END IF     
       IF cl_null(l_sum_rci12) THEN
          LET l_sum_rci12 = 0
       END IF  
       UPDATE rch_file SET rch08 = l_sum_rci08,
                           rch09 = l_sum_rci09,
                           rch10 = l_sum_rci11,
                           rch11 = l_sum_rci12
       WHERE rch01 = g_rch.rch01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','','upd rch_file',SQLCA.SQLCODE,1)
            LET g_success = 'N'
        END IF
       SELECT COUNT(*) INTO l_n FROM rci_file
       WHERE rci01 = g_rch.rch01
       IF l_n = 0 THEN
          DELETE FROM rch_file WHERE rch01 = g_rch.rch01 
       END IF
       
   END FOREACH
 
END FUNCTION

#NO.FUN-B50033
