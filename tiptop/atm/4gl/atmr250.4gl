# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: atmr250.4gl
# Descriptions...: 訂單預估毛利明細表
# Date & Author..: 06/04/04 By yoyo
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: TQC-6A0079 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: NO:           07/05/07 BY TSD.c123k 改為crystal report
# Modify.........: No.FUN-810080 08/01/30 By zhoufeng錯誤訊息匯總及CR修改
# Modify.........: No.FUN-8A0086 08/10/17 By lutingting 1.如果是沒有LET g_success = 'Y' 就寫給g_success 賦初始值，
#                                                        不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,#CHAR(500),
           s       LIKE type_file.chr4,             #No.FUN-680120 VARCHAR(03)
           t       LIKE type_file.chr4,             #No.FUN-680120 VARCHAR(03)
           u       LIKE type_file.chr4,             #No.FUN-680120 VARCHAR(03)
           a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
           b       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
           more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(01)
           END RECORD,
           g_orderA ARRAY[3] OF LIKE zaa_file.zaa08,           #No.FUN-680120 VARCHAR(10) # TQC-6A0079
           exT      LIKE type_file.chr1             #No.FUN-680120 VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_t1,l_t2       LIKE ogb_file.ogb12
DEFINE   l_s1,l_s2,l_s3,l_s4 LIKE ohb_file.ohb14
DEFINE   l_table    STRING                  # FUN-740081
DEFINE   g_sql      STRING                  # FUN-740081
DEFINE   g_str      STRING                  # FUN-740081
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
#FUN-740081 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740081 *** ##
   LET g_sql = "tqx01.tqx_file.tqx01,",
               "tqx02.tqx_file.tqx02,",
               "tqx05.tqx_file.tqx05,",
               "tqx09.tqx_file.tqx09,",
               "tsa02.tsa_file.tsa02,",	
               "tqy03.tqy_file.tqy03,",
               "tqy36.tqy_file.tqy36,",
               "tsa03.tsa_file.tsa03,",
               "tqz03.tqz_file.tqz03,",
               "tqz031.tqz_file.tqz031,",
               "tqz08.tqz_file.tqz08,",
               "tsa04.tsa_file.tsa04,",
               "ogb12.ogb_file.ogb12,", 
               "l_rate1.ogb_file.ogb12,", 
               "tsa05.tsa_file.tsa05,",
               "ogb14.ogb_file.ogb14,",
               "l_rate2.ogb_file.ogb12,", 
               "tsa08.tsa_file.tsa08,",
               "ogb14t.ogb_file.ogb14t,",
               "l_rate3.ogb_file.ogb12,",
               "l_occ02.occ_file.occ02,",
               "l_ima021.ima_file.ima021,",
               "t_azi03.azi_file.azi03,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('atmr250',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
#FUN-740081 - END
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
#No.FUN-810080 --mark-- 小計由CR 處理
## No.FUN-680120-BEGIN
#   CREATE TEMP TABLE curr_tmp(
#     curr    LIKE ade_file.ade04,
#     amt1    LIKE type_file.num20_6,
#     amt2    LIKE type_file.num20_6,
#     amt1t   LIKE type_file.num20_6,
#     amt2t   LIKE type_file.num20_6,
#     tqx01   LIKE bnb_file.bnb06,
#     tsa02   LIKE type_file.num5,  
#     tsa03   LIKE type_file.num5);
## No.FUN-680120-END    
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' OR g_bgjob is NULL
      THEN   CALL r250_tm(0,0)
#             DROP TABLE curr_tmp                          #FUN-810080---mark--
      ELSE CALL r250()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r250_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW r250_w AT p_row,p_col WITH FORM "atm/42f/atmr250"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more  = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tqx01,tqx02,tqx03,tqx04,tqx12,tqx13
 
        
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
       
        ON ACTION CONTROLP    
           IF INFIELD(tqx01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqx"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqx01  
              NEXT FIELD tqx01  
           END IF
           IF INFIELD(tqx03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqx03
              NEXT FIELD tqx03
           END IF
           IF INFIELD(tqx04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa6"
              LET g_qryparam.state = "c"
              LET g_qryparam.state = "c"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqx04
              NEXT FIELD tqx04
           END IF
           IF INFIELD(tqx12) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqb1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqx12
              NEXT FIELD tqx12
           END IF
           IF INFIELD(tqx13) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa04"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqx13
              NEXT FIELD tqx13
           END IF
 
       ON ACTION locale
          CALL cl_show_fld_cont()                   #
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r250_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.more  WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r250_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='atmr250'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr250','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('atmr250',g_time,l_cmd)
      END IF
      CLOSE WINDOW r250_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r250()
   ERROR ""
END WHILE
#   DROP TABLE curr_tmp                       #NO.FUN-810080----MARK----
   CLOSE WINDOW r250_w
END FUNCTION
 
FUNCTION r250()
DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time       LIKE type_file.chr8        #No.FUN-6B0014
       l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680120 VARCHAR(1000)
       l_za05    LIKE ima_file.ima01,         #No.FUN-680120 VARCHAR(40)
       l_order   ARRAY[5] OF LIKE bnb_file.bnb06,   #No.FUN-680120 VARCHAR(20)
       sr        RECORD 
                        tqx01     LIKE tqx_file.tqx01,
                        tqx02     LIKE tqx_file.tqx02,
                        tqx05     LIKE tqx_file.tqx05,
                        tqx09     LIKE tqx_file.tqx09,
                        tsa02     LIKE tsa_file.tsa02,	
                        tqy03     LIKE tqy_file.tqy03,	
                        tqy36     LIKE tqy_file.tqy36,
                        tsa03     LIKE tsa_file.tsa03,	
                        tqz03     LIKE tqz_file.tqz03,
                        tqz031    LIKE tqz_file.tqz031,
                        tqz08     LIKE tqz_file.tqz08,
                        tsa04     LIKE tsa_file.tsa04,
                        ogb12     LIKE ogb_file.ogb12, 
                        l_rate1   LIKE ogb_file.ogb12, 
                        tsa05     LIKE tsa_file.tsa05,
                        ogb14     LIKE ogb_file.ogb14,
                        l_rate2   LIKE ogb_file.ogb12, 
                        tsa08     LIKE tsa_file.tsa08,
                        ogb14t    LIKE ogb_file.ogb14t,
                        l_rate3   LIKE ogb_file.ogb12
                        END RECORD,
       sr1       RECORD
                        curr      LIKE azi_file.azi01,             #No.FUN-680120 VARCHAR(4)
                        amt1      LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                        amt2      LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                        amt1t     LIKE type_file.num20_6,          #No.FUN-680120 DECIMAL(20,6)
                        amt2t     LIKE type_file.num20_6           #No.FUN-680120 DECIMAL(20,6)
                 END RECORD, 
             l_curr     LIKE azk_file.azk03,
             l_occ02    LIKE occ_file.occ02, #TSD.c123k add
             #l_azp03    LIKE azp_file.azp03, #TSD.c123k add        #FUN-A50102
             l_ima021   LIKE ima_file.ima021 #TSD.c123k add
 
#FUN-740081 - add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740081 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
#FUN-740081 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#      FROM azi_file
#     WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
#No.FUN-810080 --mark--    
#     DELETE FROM curr_tmp;
#
#     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt1t),SUM(amt2t) ",
#               "   FROM curr_tmp ",
#               "  WHERE tqx01=? ",
#               "  GROUP BY curr"
#     PREPARE tmp1_pre FROM l_sql
#     IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
#     DECLARE tmp1_cs CURSOR FOR tmp1_pre
# 
#     LET l_sql=" SELECT curr, SUM(amt1),SUM(amt2),SUM(amt1t),SUM(amt2t) ",
#               "   FROM curr_tmp ",
#               "  WHERE tqx01=? ",
#               "    AND tsa02=? ",
#               "  GROUP BY curr  "
#     PREPARE tmp2_pre FROM l_sql
#     IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
#     DECLARE tmp2_cs CURSOR FOR tmp2_pre
#
#     LET l_sql=" SELECT curr, SUM(amt1),SUM(amt2),SUM(amt1t),SUM(amt2t) ",
#               "   FROM curr_tmp ",
#               "  WHERE tqx01=? ",
#               "    AND tsa02=? ",
#               "    AND tsa03=? ",
#               "  GROUP BY curr  "
#     PREPARE tmp3_pre FROM l_sql
#     IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
#     DECLARE tmp3_cs CURSOR FOR tmp3_pre
#
#     LET l_sql=" SELECT curr, SUM(amt1),SUM(amt2),SUM(amt1t),SUM(amt2t) ",
#               "   FROM curr_tmp ",
#               "  GROUP BY curr  "
#     PREPARE tmp4_pre FROM l_sql
#     IF SQLCA.sqlcode THEN CALL cl_err('pre_4:',SQLCA.sqlcode,1) RETURN END IF
#     DECLARE tmp4_cs CURSOR FOR tmp4_pre
#No.FUN-810080 --end--    
     LET l_sql = "SELECT ",
                 "  tqx01,tqx02,tqx05,tqx09,tsa02,tqy03,tqy36,tsa03,tqz03, ",
                 "  tqz031,tqz08,tsa04,0,0,tsa05,0,0,tsa08,0,0 ",
                 " FROM tqx_file,tsa_file,tqy_file,tqz_file ",
                 " WHERE tqx01=tsa01 ",
                 "   AND tqx01 = tqy_file.tqy01 ",
                 "   AND tqx01 = tqz_file.tqz01 ",
                 "   AND tsa02 = tqy_file.tqy02 ",
                 "   AND tsa03 = tqz_file.tqz02 ",
                 "   AND (tqx07='3' OR tqx07='5') ", 
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY tqx01" 
     PREPARE r250_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE r250_curs1 CURSOR FOR r250_prepare1
    #CALL cl_outnam('atmr250') RETURNING l_name  #TSD.c123k mark
    #START REPORT r250_rep TO l_name             #TSD.c123k mark
#     LET g_pageno = 0                           #NO.FUN-810080
     LET g_success = 'Y'                         #No.FUN-8A0086
     CALL s_showmsg_init()                       #No.FUN-810080  
     FOREACH r250_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          #No.FUN-810080 --add--                                                   
          IF g_success='N' THEN                                                    
             LET g_totsuccess='N'                                                  
             LET g_success='Y'                                                     
          END IF                                                                   
          #No.FUN-810080 --end--
          IF cl_null(sr.tsa04) THEN LET sr.tsa04=0 END IF
          IF cl_null(sr.tsa05) THEN LET sr.tsa05=0 END IF
          IF cl_null(sr.tsa08) THEN LET sr.tsa08=0 END IF
          SELECT SUM(ogb12) INTO l_t1 
            FROM ogb_file,oga_file           
           WHERE oga01=ogb01    AND oga03=sr.tqy03
             AND ogb04=sr.tqz03 AND ogb1005='1'
             AND ogb1012!='Y'   AND ogb1004=sr.tqx01
             AND ogaconf='Y'    AND ogapost='Y'
          IF cl_null(l_t1) THEN LET l_t1=0 END IF
 
          SELECT SUM(ogb14) INTO l_s1
            FROM ogb_file,oga_file      
           WHERE oga01=ogb01    AND oga03=sr.tqy03
             AND ogb04=sr.tqz03 AND ogb1005='1'
             AND ogb1012!='Y'   AND ogb1004=sr.tqx01
             AND ogaconf='Y'    AND ogapost='Y'
          IF cl_null(l_s1) THEN LET l_s1=0 END IF
 
          SELECT sum(ohb12) INTO l_t2
            FROM oha_file,ohb_file             
           WHERE oha01=ohb01      AND  oha03=sr.tqy03
             AND ohb04=sr.tqz03   AND  ohb1004!='Y' 
             AND ohb1002=sr.tqx01 AND  ohaconf='Y'
             AND ohapost='Y'
          IF cl_null(l_t2) THEN LET l_t2=0 END IF
          LET sr.ogb12=l_t1-l_t2
          IF sr.tsa04!=0 then
             LET sr.l_rate1=sr.ogb12/sr.tsa04*100
          ELSE
             LET sr.l_rate1=sr.ogb12/1*100
          END IF 
 
          SELECT SUM(ohb14) INTO l_s2
            FROM oha_file,ohb_file            
           WHERE oha01=ohb01      AND oha03=sr.tqy03
             AND ohb04=sr.tqz03   AND ohb1004!='Y' 
             AND ohb1002=sr.tqx01 AND ohaconf='Y'
             AND ohapost='Y'
          IF cl_null(l_s2) THEN LET l_s2=0 END IF
 
          LET sr.ogb14=l_s1-l_s2
          IF sr.tsa05!=0 then
             LET sr.l_rate2=sr.ogb14/sr.tsa05*100
          ELSE 
             LET sr.l_rate2=sr.ogb14/1*100
          END IF 
 
          SELECT SUM(ogb14t) INTO l_s3 
            FROM ogb_file,oga_file      
           WHERE oga01=ogb01    AND oga03=sr.tqy03
             AND ogb04=sr.tqz03 AND ogb1005='1'
             AND ogb1012!='Y'   AND ogb1004=sr.tqx01
             AND ogaconf='Y'    AND ogapost='Y'
          IF cl_null(l_s3) THEN LET l_s3=0 END IF
   
          SELECT SUM(ohb14t) INTO l_s4 
            FROM oha_file,ohb_file             
           WHERE oha01=ohb01      AND oha03=sr.tqy03
             AND ohb04=sr.tqz03   AND ohb1004!='Y' 
             AND ohb1002=sr.tqx01 AND ohaconf='Y' 
             AND ohapost='Y'
          IF cl_null(l_s4) THEN LET l_s4=0 END IF
          LET sr.ogb14t=l_s3-l_s4
          IF sr.tsa08!=0 THEN
             LET sr.l_rate3=sr.ogb14t/sr.tsa08*100
          ELSE
             LET sr.l_rate3=sr.ogb14t/1*100
          END IF
 
         #OUTPUT TO REPORT r250_rep(sr.*)  # TSD.c123k mark
      
          #TSD.c123k add --------------------------
          #LET l_azp03 = ''                           #FUN-A50102
          #SELECT azp03 INTO l_azp03 FROM azp_file    #FUN-A50102
          # WHERE azp01=sr.tqy36                      #FUN-A50102
 
          LET l_occ02 = '' 
          #LET l_sql = "SELECT occ02 FROM ",s_dbstring(l_azp03 CLIPPED),"occ_file ",   #FUN-A50102
          LET l_sql = "SELECT occ02 FROM ",cl_get_target_table( sr.tqy36, 'occ_file' ),#FUN-A50102
                      " WHERE occ01 = '",sr.tqy03,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
          CALL cl_parse_qry_sql(l_sql,sr.tqy03) RETURNING l_sql     #FUN-A50102	
          PREPARE p_occ FROM l_sql
          DECLARE p_occ02 CURSOR FOR p_occ
          OPEN p_occ02
          FETCH p_occ02 INTO l_occ02
#          IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,1) END IF #NO.FUN-810080
          #No.FUN-810080 --add--
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('occ02',l_occ02,'',SQLCA.sqlcode,1)
             LET g_success='N'
          END IF
          #No.FUN-810080 --end--
          LET l_ima021 = ''
          SELECT ima021 INTO l_ima021 FROM ima_file
           WHERE ima01 = sr.tqz03
 
          IF cl_null(sr.tqx05) THEN LET sr.tqx05 = ' ' END IF
 
          SELECT azi03,azi04,azi05
            INTO t_azi03,t_azi04,t_azi05  
            FROM azi_file
           WHERE azi01 = sr.tqx09
          #TSD.c123k end --------------------------
 
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740081 *
          EXECUTE insert_prep USING
             sr.tqx01,  sr.tqx02,  sr.tqx05,  sr.tqx09,  sr.tsa02,  sr.tqy03,
             sr.tqy36,  sr.tsa03,  sr.tqz03,  sr.tqz031, sr.tqz08,  sr.tsa04,  
             sr.ogb12,  sr.l_rate1,sr.tsa05,  sr.ogb14,  sr.l_rate2,sr.tsa08,
             sr.ogb14t, sr.l_rate3,l_occ02,   l_ima021,  t_azi03,   t_azi04, 
             t_azi05
          #------------------------------ CR (3) -----------------------------
     END FOREACH
     #No.FUN-810080 --add--   
     CALL s_showmsg()                                                  
     IF g_totsuccess="N" THEN                                                   
        LET g_success="N"                                                       
     END IF                                                                     
     #No.FUN-810080 --end--
    #FINISH REPORT r250_rep   #TSD.c123k mark
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #TSD.c123k mark
 
    # FUN-740081 START
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'tqx01,tqx02,tqx03,tqx04,tqx12,tqx13')
             RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,';',tm.a
 
    CALL cl_prt_cs3('atmr250','atmr250',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    # FUN-740081 end
 
END FUNCTION
 
