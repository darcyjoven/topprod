# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apjr502.4gl
# Descriptions...: 專案材料進度追蹤表
# Date & Author..: 2008/03/27 By shiwuying
# Modify.........: No.FUN-830102 2008/03/27 By shiwuying 因規格改動較大，故重寫此程序
# Modify.........: No.CHI-8C0040 09/02/01 by jan 語法修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-930112 09/03/11 By rainy 未轉請購量都沒有印出，請購數量及未轉採購量錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80031 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
             wc    STRING,
              s    LIKE type_file.chr3,    #LIKE cqo_file.cqo01,   #TQC-B90211
              t    LIKE type_file.chr3,    #LIKE cqo_file.cqo01,   #TQC-B90211
              n    LIKE type_file.chr1,
              more LIKE type_file.chr1
              END RECORD
 DEFINE   g_i             LIKE type_file.num5
 DEFINE   g_sma115        LIKE sma_file.sma115
 DEFINE   g_sql           STRING
 DEFINE   g_str           STRING
 DEFINE   l_table         STRING
 DEFINE   l_table1        STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql="pjb01.pjb_file.pjb01,",
             "gem02.gem_file.gem02,",
             "gen02.gen_file.gen02,",
             "pjb02.pjb_file.pjb02,",
             "pjf02.pjf_file.pjf02,",
             "pjf03.pjf_file.pjf03,",
             "pjf04.pjf_file.pjf04,",
             "ima25.ima_file.ima25,",
             "pjf06.pjf_file.pjf06,",
             "pjf05.pjf_file.pjf05,",
             "un_amt.pjf_file.pjf05,",
             "pmk01.pmk_file.pmk01,",
             "pml02.pml_file.pml02,",
             "pmk02.pmk_file.pmk02,",
             "pmk04.pmk_file.pmk04,",   #MOD-930112 add
             "pml20.pml_file.pml20,",
             "pml21.pml_file.pml21"
   LET l_table=cl_prt_temptable('apjr502',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET g_sql="pmn24.pmn_file.pmn24,",
             "pmn25.pmn_file.pmn25,",
             "pmn01.pmn_file.pmn01,",
             "pmn02.pmn_file.pmn02,",
             "pmn07.pmn_file.pmn07,",
             "pmm09.pmm_file.pmm09,",
             "pmc03.pmc_file.pmc03,",
             "pmn20.pmn_file.pmn20,",
             "pmn33.pmn_file.pmn33,",
             "rvb01.rvb_file.rvb01,",
             "rvb02.rvb_file.rvb02,",
             "rva06.rva_file.rva06,",
             "rvb08.rvb_file.rvb08"
   LET l_table1 = cl_prt_temptable('apjr5021',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
 
   LET tm.n     = ARG_VAL(10)
 
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r502_tm(0,0)
      ELSE CALL r502()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r502_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd		LIKE type_file.chr1000
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 18
   ELSE
      LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r502_w AT p_row,p_col
        WITH FORM "apj/42f/apjr502"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '123'
   LET tm2.s1    = '1'
   LET tm2.s2    = '2'
   LET tm2.s3    = '3'
   LET tm2.t1    = 'N'
   LET tm2.t2    = 'N'
   LET tm2.t3    = 'N'
   LET tm.n	 = '2'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   WHILE TRUE
      CONSTRUCT BY NAME  tm.wc ON pjb01,pjb02,pjf03,pjf06
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pjb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjb01
                  NEXT FIELD pjb01
 
               WHEN INFIELD(pjb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pjb"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjb02
                  NEXT FIELD pjb02
                  
               WHEN INFIELD(pjf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjf03
                  NEXT FIELD pjf03
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
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
      
      DISPLAY BY NAME tm.s,tm.more
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r502_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM 
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                    tm2.t1,tm2.t2,tm2.t3,
                    tm.n,tm.more
                    WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD n
            IF tm.n NOT MATCHES'[12]' THEN
               NEXT FIELD n
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         ON ACTION CONTROLR
           CALL cl_show_req_fields()
           
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            
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
         LET INT_FLAG = 0 CLOSE WINDOW r502_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apjr502'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apjr502','9031',1)
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
                         " '",tm.s,"'",
                         " '",tm.t,"'" ,
                         " '",tm.n,"'" , 
                         " '",g_rep_user CLIPPED,"'", 
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"  
            CALL cl_cmdat('apjr502',g_time,l_cmd)
         END IF
         CLOSE WINDOW r502_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r502()
      ERROR ""
   END WHILE
   CLOSE WINDOW r502_w
END FUNCTION
 
FUNCTION r502()
  DEFINE  l_name     LIKE type_file.chr20,
          l_i        LIKE type_file.num5,
          l_sql1,l_sql2,l_sql3,l_sql4     STRING,         #NO.FUN-910082
          #l_sql1     LIKE type_file.chr1000,
          #l_sql2     LIKE type_file.chr1000,
          #l_sql3     LIKE type_file.chr1000,
         #l_sql4     LIKE type_file.chr1000,
          l_za05     LIKE type_file.chr1000,
          l_a1       LIKE type_file.chr1,
          l_a2       LIKE type_file.chr1,
          sr1        RECORD
                     order1    LIKE type_file.chr1000,
                     order2    LIKE type_file.chr1000,
                     order3    LIKE type_file.chr1000,
                     pjb01     LIKE    pjb_file.pjb01,   #專案代號
                     gem02     LIKE    gem_file.gem02,   #提出部門
                     gen02     LIKE    gen_file.gen02,   #提出人員
                     pjb02     LIKE    pjb_file.pjb02,   #WBS編碼
                     pjf02     LIKE    pjf_file.pjf02,   #項次
                     pjf03     LIKE    pjf_file.pjf03,   #料號
                     pjf04     LIKE    pjf_file.pjf04,   #品名
                     ima25     LIKE    ima_file.ima25,   #單位
                     pjf06     LIKE    pjf_file.pjf06,   #需求日期
                     pjf05     LIKE    pjf_file.pjf05,   #需求數量
                     un_amt    LIKE    pjf_file.pjf05,   #未轉請購
                     pmk01     LIKE    pmk_file.pmk01,   #請購單號
                     pml02     LIKE    pml_file.pml02,   #項次(請購)
                     pmk02     LIKE    pmk_file.pmk02,   #請購日期
                     pmk04     LIKE    pmk_file.pmk04,   #請購日期  #MOD-930112 pmk04才是請購日期
                     pml20     LIKE    pml_file.pml20,   #請購數量
                     pml21     LIKE    pml_file.pml21    #未轉採購
                     END RECORD,
          sr2        RECORD
                     pmn24     LIKE    pmn_file.pmn24,   #項目編號
                     pmn25     LIKE    pmn_file.pmn25,   #WBS編碼
                     pmn01     LIKE    pmn_file.pmn01,   #採購單號
                     pmn02     LIKE    pmn_file.pmn02,   #項次(採購)
                     pmn07     LIKE    pmn_file.pmn07,   #單位
                     pmm09     LIKE    pmm_file.pmm09,   #供應廠商
                     pmc03     LIKE    pmc_file.pmc03,   #廠商簡稱
                     pmn20     LIKE    pmn_file.pmn20,   #採購數量
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日
                     rvb01     LIKE    rvb_file.rvb01,   #驗收單號
                     rvb02     LIKE    rvb_file.rvb02,   #項次(驗收)
                     rva06     LIKE    rva_file.rva06,   #收貨日
                     rvb08     LIKE    rvb_file.rvb08    #數量
                     END RECORD
 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"   #MOD-930112 add 1?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B80031--add--
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
     PREPARE insert_prep1 FROM g_sql                                              
     IF STATUS THEN                                                         
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B80031--add--      
        EXIT PROGRAM
     END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='apjr502'
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
     #End:FUN-980030
 
     LET l_sql1 = " SELECT DISTINCT '','','',",
                  " pjb01,gem02,gen02,pjb02,pjf02,pjf03,pjf04,ima25,",
                  " pjf06,pjf05,'',  '','','','','',''  ",    #MOD-930112
                  " FROM pjb_file,pjf_file LEFT OUTER JOIN ima_file ON pjf03=ima_file.ima01,pja_file LEFT OUTER JOIN gem_file ON pja09=gem_file.gem01 LEFT OUTER JOIN gen_file ON pja08=gen_file.gen01 ",
                 #"      gem_file,gen_file,ima_file",                    #CHI-8C0040
                 #" WHERE pjb02 = pjf01 AND pjf_file.pjf03 = ima_file.ima01",  #CHI-8C0040
                  " WHERE pjb02 = pjf01 ",              #CHI-8C0040
                 #" AND pjb01 = pja01 AND pja_file.pja09 = gem_file.gem01 AND pja_file.pja08 = gen_file.gen01", #CHI-8C0040
                  " AND pjb01 = pja01 ", #CHI-8C0040
                  " AND pjb09 = 'Y' ",   #MOD-930112 只抓尾階的資料印出
                  " AND pjaclose = 'N' AND ",tm.wc CLIPPED
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET l_sql1=l_sql1 clipped," AND pjfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET l_sql1=l_sql1 clipped," AND pjfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET l_sql1=l_sql1 clipped," AND pjfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    #End:FUN-980030
 
    LET l_sql1=l_sql1 CLIPPED," ORDER BY pjb01,pjb02,pjf02"
 
    LET l_sql3 = " SELECT pmk01,pml02,pmk02,pmk04,pml20,pml21 FROM pmk_file,pml_file",  #MOD-930112 add pmk04
                 " WHERE pml12= ? AND pml121=? AND pml04=? AND pml01 = pmk01",
                 " ORDER BY pmk01,pml02"
 
    LET l_sql2  = " SELECT pmn24,pmn25,pmn01,pmn02,pmn07,pmm09,pmc03,pmn20,pmn33, ",
                  " '','','','' FROM pmn_file LEFT OUTER JOIN pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc01 ON pmn01 = pmm01 ",
                  " WHERE pmn24 = ? AND pmn25 = ? AND pmn16 !='9' ",
                  " ORDER BY pmn01,pmn02"
 
    LET l_sql4  = " SELECT rvb01,rvb02,rva06,rvb08 FROM rvb_file,rva_file ",
                  " WHERE rvb04 = ? AND rvb03 = ? ",
                  " AND rvb01 = rva01 AND rvaconf <> 'X'",
                  " ORDER BY rvb01,rvb02"
 
 
     PREPARE r502_p1 FROM l_sql1
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
              
        END IF
     DECLARE r502_c1 CURSOR FOR r502_p1
 
     PREPARE r502_p2 FROM l_sql2
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
              
        END IF
     DECLARE r502_c2 CURSOR FOR r502_p2
 
     PREPARE r502_p3 FROM l_sql3
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
              
        END IF
     DECLARE r502_c3 CURSOR FOR r502_p3
 
     PREPARE r502_p4 FROM l_sql4
        IF SQLCA.sqlcode THEN
           CALL cl_err('prepare4:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM
              
        END IF
     DECLARE r502_c4 CURSOR FOR r502_p4
 
     LET l_a1='Y'
     LET l_a2='Y'
     FOREACH r502_c1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_a1='Y'
     #MOD-930112 begin
       #IF tm.n='2' THEN
       #   SELECT SUM(pml20*pml09) INTO sr1.un_amt
       #     FROM pjf_file,pjb_file,pml_file
       #    WHERE pml12= sr1.pjb01 AND pml121=sr1.pjb02 AND pml04=sr1.pjf03
       #      AND pjf02 = sr1.pjf02
       #   LET sr1.un_amt = sr1.pjf05 - sr1.un_amt
       #   IF sr1.un_amt <=0 THEN
       #      CONTINUE FOREACH
       #   END IF
       #END IF
       SELECT SUM(pml20*pml09) INTO sr1.un_amt
         FROM pml_file
        WHERE pml12= sr1.pjb01 AND pml121=sr1.pjb02 AND pml04=sr1.pjf03
       IF cl_null(sr1.un_amt) THEN LET sr1.un_amt = 0 END IF
       LET sr1.un_amt = sr1.pjf05 - sr1.un_amt
       IF tm.n='2' AND sr1.un_amt <=0 THEN
          CONTINUE FOREACH
       END IF
     #MOD-930112 end
       FOREACH r502_c3 USING sr1.pjb01,sr1.pjb02,sr1.pjf03
        INTO sr1.pmk01,sr1.pml02,sr1.pmk02,sr1.pmk04,sr1.pml20,sr1.pml21   #MOD-930112 add pmk04
         IF STATUS THEN
            CALL cl_err('foreach3:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
         LET l_a1='N'
 
         LET sr1.pml21 = sr1.pml20-sr1.pml21  #MOD-930112
         
         FOREACH r502_c2 USING sr1.pmk01,sr1.pml02 INTO sr2.*
           IF STATUS THEN
              CALL cl_err('foreach2:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET l_a2='Y'
      
           FOREACH r502_c4
           USING sr2.pmn01,sr2.pmn02
           INTO sr2.rvb01,sr2.rvb02,sr2.rva06,sr2.rvb08
              IF STATUS THEN
                 CALL cl_err('foreach4:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
 
              EXECUTE insert_prep1  USING  sr2.pmn24,sr2.pmn25,
                      sr2.pmn01,sr2.pmn02,sr2.pmn07,sr2.pmm09,sr2.pmc03,        
                      sr2.pmn20,sr2.pmn33,
                      sr2.rvb01,sr2.rvb02,sr2.rva06,sr2.rvb08
               LET l_a2='N'
               LET l_a1='N'
           END FOREACH  
           IF l_a2='Y' THEN
              LET sr2.rvb01=''
              LET sr2.rvb02=''
              LET sr2.rva06=''
              LET sr2.rvb08=''
              EXECUTE insert_prep1  USING sr2.pmn24,sr2.pmn25,
                     sr2.pmn01,sr2.pmn02,sr2.pmn07,sr2.pmm09,sr2.pmc03,
                     sr2.pmn20,sr2.pmn33,
                     sr2.rvb01,sr2.rvb02,sr2.rva06,sr2.rvb08
               LET l_a1='N'
            END IF
        END FOREACH
        EXECUTE insert_prep  USING                                               
                     sr1.pjb01,sr1.gem02,sr1.gen02,sr1.pjb02,sr1.pjf02,        
                     sr1.pjf03,sr1.pjf04,sr1.ima25,sr1.pjf06,                  
                     sr1.pjf05,sr1.un_amt,                                     
                     sr1.pmk01,sr1.pml02,sr1.pmk02,sr1.pmk04,sr1.pml20,sr1.pml21    #MOD-930112 add pmk04
     
       END FOREACH
       IF l_a1='Y' THEN
          INITIALIZE sr2.* TO NULL
       EXECUTE insert_prep  USING  
                     sr1.pjb01,sr1.gem02,sr1.gen02,sr1.pjb02,sr1.pjf02,
                     sr1.pjf03,sr1.pjf04,sr1.ima25,sr1.pjf06,
                     sr1.pjf05,sr1.un_amt,
                     sr1.pmk01,sr1.pml02,sr1.pmk02,sr1.pmk04,sr1.pml20,sr1.pml21  #MOD-930112 add pmk04
        END IF     
     END FOREACH
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     LET g_str=''
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'pjb01,pjb02,pjf03,pjf06')
        RETURNING tm.wc
        LET g_str=tm.wc
     END IF
     LET g_str=g_str CLIPPED,';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',tm.t
     CALL cl_prt_cs3('apjr502','apjr502',g_sql,g_str)
 
END FUNCTION
#No.FUN-830102
