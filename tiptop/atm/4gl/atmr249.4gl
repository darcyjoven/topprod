# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: atmr249.4gl
# Descriptions...: 訂單預估毛利明細表
# Date & Author..: 06/04/03 By yoyo
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.FUN-740081 07/04/24 BY TSD.c123k 改為crystal report
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D10034 13/01/08 By xuxz oea01添加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,#CHAR(500),
           s       LIKE type_file.chr3,       #TQC-840066
           t       LIKE type_file.chr3,       #TQC-840066
           u       LIKE type_file.chr3,       #TQC-840066
           a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
           b       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
           more    LIKE type_file.chr1              #No.FUN-680120 VARCHAR(01)
           END RECORD,
           g_orderA ARRAY[3] OF LIKE oea_file.oea01,#No.FUN-680120 VARCHAR(10)  
           exT      LIKE type_file.chr1             #No.FUN-680120 VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_head1         STRING
#FUN-740081 TSD.c123k add ----------------
DEFINE   l_table    STRING
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
#FUN-740081 TSD.c123k end ----------------
 
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
 
#FUN-740081 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740081 *** ##
   LET g_sql = "oea01.oea_file.oea01,",
               "oea02.oea_file.oea02,",
               "oea03.oea_file.oea03,",
               "oea032.oea_file.oea032,",		
               "oea04.oea_file.oea04,",
               "occ02.occ_file.occ02,",	
               "gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",
               "oea23.oea_file.oea23,",
               "oea21.oea_file.oea21,",
               "oea211.oea_file.oea211,",
               "oea213.oea_file.oea213,",
               "oea24.oea_file.oea24,",
               "oea31.oea_file.oea31,",
               "oea32.oea_file.oea32,",
               "oea12.oea_file.oea12,",
               "oeahold.oea_file.oeahold,",
               "oeaconf.oea_file.oeaconf,",
               "oea14.oea_file.oea14,",    
               "oea15.oea_file.oea15,",    
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
               "oeb092.oeb_file.oeb092,",
               "oeb06.oeb_file.oeb06,",
               "oeb12a.oeb_file.oeb12,",
               "oeb917.oeb_file.oeb917,",
               "oeb13.oeb_file.oeb13,",
               "oeb14.oeb_file.oeb14,",  
               "oeb14a.oeb_file.oeb14,",    
               "oeb14b.oeb_file.oeb14,",  
               "oeb14c.oeb_file.oeb14,",    
               "oeb12.oeb_file.oeb12,",
               "oef05.oef_file.oef05,",
               "oea08.oea_file.oea08,",
               "ima021.ima_file.ima021,",
               "tot1.oeb_file.oeb14,",   
               "tot2.oeb_file.oeb14,",   
               "t_azi03.azi_file.azi03,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('atmr249',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
#FUN-740081 end
 
 
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
   IF cl_null(g_bgjob) OR g_bgjob = 'N' OR g_bgjob is NULL
      THEN CALL r249_tm(0,0)
      ELSE CALL r249()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r249_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW r249_w AT p_row,p_col WITH FORM "atm/42f/atmr249"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
   LET tm2.u1   = 'N'
   LET tm2.u2   = 'N'
   LET tm2.u3   = 'N'
   LET tm2.t1   = 'N'
   LET tm2.t2   = 'N'
   LET tm2.t3   = 'N'
   LET tm.a     = '3'
   LET tm.b     = '3'
   LET tm.more  = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold
 
        
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
       
        ON ACTION CONTROLP    
          #TQC-D10034--str--add--訂單單號欄位開窗
           IF INFIELD(oea01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea01_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea01
              NEXT FIELD oea01
           END IF
          #TQC-D10034--end--add
           IF INFIELD(oea03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           END IF
           IF INFIELD(oea04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea04
              NEXT FIELD oea04
           END IF
           IF INFIELD(oea14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea14
              NEXT FIELD oea14
           END IF
           IF INFIELD(oea15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea15
              NEXT FIELD oea15
           END IF
           IF INFIELD(oea12) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nnp"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea12
              NEXT FIELD oea12
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
      CLOSE WINDOW r249_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.a,tm.b,tm.more  WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' THEN NEXT FIELD b END IF
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      CLOSE WINDOW r249_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='atmr249'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr249','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('atmr249',g_time,l_cmd)
      END IF
      CLOSE WINDOW r249_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r249()
   ERROR ""
END WHILE
   CLOSE WINDOW r249_w
END FUNCTION
 
FUNCTION r249()
DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time       LIKE type_file.chr8        #No.FUN-6B0014
       l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680120 VARCHAR(10000)
       l_za05    LIKE ima_file.ima01,         #No.FUN-680120 VARCHAR(40)
       l_order   ARRAY[5] OF      LIKE gem_file.gem02,  #No.FUN-680120 VARCHAR(20) 
       sr        RECORD
                        order1    LIKE gem_file.gem02,  #No.FUN-680120 VARCHAR(20)
                        order2    LIKE gem_file.gem02,  #No.FUN-680120 VARCHAR(20)
                        order3    LIKE gem_file.gem02,  #No.FUN-680120 VARCHAR(20)
                        oea01     LIKE oea_file.oea01,
                        oea02     LIKE oea_file.oea02,
                        oea03     LIKE oea_file.oea03,
                        oea032    LIKE oea_file.oea032,		
                        oea04     LIKE oea_file.oea04,
                        occ02     LIKE occ_file.occ02,	
                        gen02     LIKE gen_file.gen02,
                        gem02     LIKE gem_file.gem02,
                        oea23     LIKE oea_file.oea23,
                        oea21     LIKE oea_file.oea21,
                        oea211    LIKE oea_file.oea211,
                        oea213    LIKE oea_file.oea213,
                        oea24     LIKE oea_file.oea24,
                        oea31     LIKE oea_file.oea31,
                        oea32     LIKE oea_file.oea32,
                        oea12     LIKE oea_file.oea12,
                        oeahold   LIKE oea_file.oeahold,
                        oeaconf   LIKE oea_file.oeaconf,
                        oea14     LIKE oea_file.oea14,    
                        oea15     LIKE oea_file.oea15,    
                        oeb03     LIKE oeb_file.oeb03,
                        oeb1003   LIKE oeb_file.oeb1003,
                        oeb1012   LIKE oeb_file.oeb1012,
                        oeb04     LIKE oeb_file.oeb04,
                        oeb092    LIKE oeb_file.oeb092,
                        oeb06     LIKE oeb_file.oeb06,
                        oeb12a    LIKE oeb_file.oeb12,
                        oeb917    LIKE oeb_file.oeb917,
                        oeb13     LIKE oeb_file.oeb13,
                        oeb14     LIKE oeb_file.oeb14,    
                        oeb14a    LIKE oeb_file.oeb14,    
                        oeb14b    LIKE oeb_file.oeb14,    
                        oeb14c    LIKE oeb_file.oeb14,   
                        oeb12     LIKE oeb_file.oeb12,
                        oef05     LIKE oef_file.oef05,
                        oea08     LIKE oea_file.oea08,
                        tot1      LIKE oeb_file.oeb14,    
                        tot2      LIKE oeb_file.oeb14 
                        END RECORD,
             l_curr     LIKE azk_file.azk03 
#FUN-740081 add
DEFINE l_ima021 LIKE ima_file.ima021 
#FUN-740081 end  
 
#FUN-740081 - add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740077 *** ##
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
 
     LET l_sql = "SELECT '','','',",
                 "  oea01,oea02,oea03,oea032,oea04,'','','',",
                 "  oea23,oea21,oea211,oea213,oea24,oea31,oea32,oea12,oeahold,oeaconf,oea14,oea15,",
                 "  oeb03,oeb1003,oeb1012,oeb04,oeb092,oeb06,oeb12,oeb917,oeb13,oeb14,0,0,0,(oeb12*ima125),", 
                 "  '',oea08,0,0",
                 "  FROM oea_file,oeb_file,ima_file",
                 " WHERE oea01=oeb01 ",
                 "   AND ima01=oeb04 ",
                 "   AND (oea00<>'0' AND oea00<>'2') ", 
                 "   AND oeaconf!='X' ",      
                 "   AND ", tm.wc CLIPPED,
                 " UNION ",
                 "SELECT '','','',",                                            
                 "  oea01,oea02,oea03,oea032,oea04,'','','',", 
                 "  oea23,oea21,oea211,oea213,oea24,oea31,oea32,oea12,oeahold,oeaconf,oea14,oea15,",
                 "  oeb03,oeb1003,oeb1012,oeb04,oeb092,oeb06,oeb12,oeb917,oeb13,oeb14,0,0,0,0,",
                 "  '',oea08,0,0",                                           
                 "  FROM oea_file,oeb_file",           
                 " WHERE oea01=oeb01 ",                                         
                 "   AND oeb1003='2' ",                                         
                 "   AND (oea00<>'0' AND oea00<>'2') ",                         
                 "   AND oeaconf!='X' ",                                        
                 "   AND ", tm.wc CLIPPED,                                      
                 " ORDER BY oea01"  
     PREPARE r249_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE r249_curs1 CURSOR FOR r249_prepare1
   # CALL cl_outnam('atmr249') RETURNING l_name #FUN-740081 TSD.c123k mark
   # START REPORT r249_rep TO l_name            #FUN-740081 TSD.c123k mark
     LET g_pageno = 0
 
 
     FOREACH r249_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
 
          SELECT occ02 INTO sr.occ02 FROM occ_file WHERE occ01=sr.oea04
          SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01=sr.oea14
          SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.oea15
          SELECT SUM(oef05) INTO sr.oef05 FROM oef_file WHERE oef01=sr.oea01
                                                          AND oef03=sr.oeb03
            
          IF tm.a = '1' AND sr.oeaconf = 'N' THEN CONTINUE FOREACH END IF
          IF tm.a = '2' AND sr.oeaconf = 'Y' THEN CONTINUE FOREACH END IF
          IF tm.b = '1' AND cl_null(sr.oeahold) THEN CONTINUE FOREACH END IF
	  IF tm.b = '2' AND NOT cl_null(sr.oeahold) THEN CONTINUE FOREACH END IF
          IF sr.oea08='1' THEN
             LET exT=g_oaz.oaz52
          ELSE
             LET exT=g_oaz.oaz70
          END IF
          CALL s_curr3(sr.oea23,sr.oea02,exT) RETURNING l_curr
          LET sr.oeb14=sr.oeb14*sr.oea24
          IF cl_null(sr.oeb14) THEN LET sr.oeb14=0 END IF
          IF sr.oeb1003='2' THEN
             LET sr.oeb14a=0
             LET sr.oeb14b=0
             LET sr.oeb14c=sr.oeb14
             LET sr.oeb12=0
             LET sr.oef05=0
             LET sr.tot1=sr.oeb14a-sr.oeb14b-sr.oeb14c-sr.oeb12-sr.oef05
             LET sr.tot2=0
          ELSE
             IF sr.oeb1012='Y' THEN
                LET sr.oeb14a=0
                IF  NOT CL_NULL(sr.oeb917) THEN
                    IF  sr.oea213='Y' THEN
                        LET sr.oeb14b=sr.oeb917*sr.oeb13/(1+sr.oea211/100)
                    ELSE 
                        LET sr.oeb14b=sr.oeb917*sr.oeb13
                    END IF 
                ELSE 
                    IF  sr.oea213='Y' THEN
                        LET sr.oeb14b=sr.oeb12a*sr.oeb13/(1+sr.oea211/100)
                    ELSE 
                        LET sr.oeb14b=sr.oeb12a*sr.oeb13
                    END IF 
                END IF 
                IF CL_NULL(sr.oeb14b) THEN
                   LET sr.oeb14b=0
                END IF 
                LET sr.oeb14c=0
                LET sr.oeb12=0
                LET sr.oef05=0
                LET sr.tot1=sr.oeb14a-sr.oeb14b-sr.oeb14c-sr.oeb12-sr.oef05
                LET sr.tot2=0
             ELSE
                LET sr.oeb14a=sr.oeb14
                LET sr.oeb14b=0
                LET sr.oeb14c=0
                IF cl_null(sr.oeb12) THEN LET sr.oeb12=0 END IF
                IF cl_null(sr.oef05) THEN LET sr.oef05=0 END IF
                LET sr.tot1=sr.oeb14a-sr.oeb14b-sr.oeb14c-sr.oeb12-sr.oef05
                IF sr.tot1 = 0 THEN 
                   LET sr.tot2=sr.tot1/1
                ELSE
                 IF sr.oeb14a=0 THEN
                   LET sr.tot2=0
                 ELSE
                   LET sr.tot2=(sr.tot1/sr.oeb14a)*100
                 END IF
                END IF
             END IF
          END IF
 
          FOR g_i = 1 TO 3
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea01
                                            LET g_orderA[g_i]= g_x[18]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea02 USING 'yyyymmdd'
                                            LET g_orderA[g_i]= g_x[19]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea03
                                            LET g_orderA[g_i]= g_x[20]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea04
                                            LET g_orderA[g_i]= g_x[21]
                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.gen02
                                            LET g_orderA[g_i]= g_x[22]
                   WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.gem02
                                            LET g_orderA[g_i]= g_x[23]
                   WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
                                            LET g_orderA[g_i]= g_x[24]
                   WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oea12
                                            LET g_orderA[g_i]= g_x[25]
                   WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oeahold
                                            LET g_orderA[g_i]= g_x[26]
                   OTHERWISE LET l_order[g_i]  = '-'
                             LET g_orderA[g_i] = ' '          #清為空白
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
        # OUTPUT TO REPORT r249_rep(sr.*)  # FUN-740081 TSD.c123k mark
 
          # FUN-740081 TSD.c123k add ------------------------------------------
 
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  
            FROM azi_file
           WHERE azi01=sr.oea23
 
          IF sr.oeb04[1,4] !='MISC' THEN
             SELECT ima021 INTO l_ima021 FROM ima_file
              WHERE ima01 = sr.oeb04
          ELSE
             LET l_ima021 = ''
          END IF
 
          IF cl_null(sr.oeahold) THEN LET sr.oeahold = ' ' END IF
          IF cl_null(sr.oeb092) THEN LET sr.oeb092 = ' ' END IF
 
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
          EXECUTE insert_prep USING
             sr.oea01,   sr.oea02,   sr.oea03,    sr.oea032,   sr.oea04,
             sr.occ02,   sr.gen02,   sr.gem02,    sr.oea23,    sr.oea21,
             sr.oea211,  sr.oea213,  sr.oea24,    sr.oea31,    sr.oea32,
             sr.oea12,   sr.oeahold, sr.oeaconf,  sr.oea14,    sr.oea15,
             sr.oeb03,   sr.oeb04,   sr.oeb092,   sr.oeb06,    sr.oeb12a,
             sr.oeb917,  sr.oeb13,   sr.oeb14,    sr.oeb14a,   sr.oeb14b,
             sr.oeb14c,  sr.oeb12,   sr.oef05,    sr.oea08,    l_ima021,
             sr.tot1,    sr.tot2,    t_azi03,     t_azi04,     t_azi05
          #------------------------------ CR (3) ------------------------------#
          # FUN-740081 TSD.c123k end ---------------------------
 
     END FOREACH
 
    #FUN-740081 TSD.c123k mark ------------------
    #FINISH REPORT r249_rep
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #FUN-740081 TSD.c123k end -------------------
 
    # FUN-740081 add
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s,";",tm.t,";",tm.u,";",tm.a,";",tm.b
 
    CALL cl_prt_cs3('atmr249','atmr249',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    # FUN-740081 end
 
END FUNCTION
 
