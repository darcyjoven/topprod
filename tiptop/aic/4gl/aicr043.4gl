# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aicr043.4gl
# Descriptions...: 外包月結對帳單
# Date & Author..: 2007/12/18  By ChenMoyan No.FUN-7B0027
# Modify.........: No.FUN-830065 2008/03/21  By ChenMoyan 
# Modify FUN-7B0027
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No.FUN-C30285 12/03/27 By bart 增加批號作業編號for ICD
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
   DEFINE tm  RECORD
             
              wc      STRING,  
              s       LIKE type_file.chr3,
              sub     LIKE type_file.chr1,
              b       LIKE type_file.chr1,
	      s_date  DATE,
              d_date  DATE,
              more    LIKE type_file.chr1
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5 
DEFINE   l_table         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                                                                    
      CALL cl_err('','aic-999',1) EXIT PROGRAM                                                                                      
   END IF  

      LET g_sql = "rva05.rva_file.rva05,",
                  "rva01.rva_file.rva01,",
                  "rvb02.rvb_file.rvb02,",
                  "rva06.rva_file.rva06,",
                  "rvb04.rvb_file.rvb04,",
                  "rvb03.rvb_file.rvb03,",
                  "rvb05.rvb_file.rvb05,",
                  "imaicd06.imaicd_file.imaicd06,",
                  "rvb38.rvb_file.rvb38,",
                  "rvb30.rvb_file.rvb30,",
                  "rvb10.rvb_file.rvb10,",
                  "amt1.rvb_file.rvb10,",
                  "amt2.rvb_file.rvb10,",
                  "amt3.type_file.num20,",
                  "rvb22.rvb_file.rvb22,",
                  "sum.type_file.num20,",
                  "rvbiicd03.rvbi_file.rvbiicd03"  #FUN-C30285

   LET l_table = cl_prt_temptable('aicr043',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s_date  = ARG_VAL(8)
   LET tm.d_date  = ARG_VAL(9)
   LET tm.s     = ARG_VAL(8)
   LET tm.sub   = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
 
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r043_tm(0,0)
      ELSE CALL r043()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION r043_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW r043_w AT p_row,p_col WITH FORM "aic/42f/aicr043"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
 
   LET tm.s      = '234'
   LET tm.sub    = '3'
   LET tm.b      = '1'
 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s_date = g_today		
   LET tm.d_date = g_today
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
 
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rva01,rva05,rva06,rvb04,rvb05
 
       
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
    
 
   ON ACTION CONTROLP
     CASE WHEN INFIELD(rva05)    
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rva05
               NEXT FIELD rva05
          WHEN INFIELD(rvb04)   
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_pmm602"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb04
               NEXT FIELD rvb04
          WHEN INFIELD(rvb05)  
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ima1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb05
               NEXT FIELD rvb05
     OTHERWISE EXIT CASE
     END CASE
 
     ON ACTION locale
 
          CALL cl_show_fld_cont()         
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
         CLOSE WINDOW r043_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
 
   INPUT BY NAME tm.s_date,tm.d_date,tm.sub,tm.b,tm2.s1,tm2.s2,tm2.s3,tm.more
            WITHOUT DEFAULTS
        
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
       
 
      AFTER FIELD s_date
           IF cl_null(tm.s_date) THEN
              NEXT FIELD s_date
           ELSE
              IF cl_null(tm.d_date) THEN
                 LET tm.d_date=tm.s_date
                 DISPLAY tm.d_date TO d_date
              END IF
           END IF
        AFTER FIELD d_date
           IF cl_null(tm.d_date) THEN
              NEXT FIELD d_date
           ELSE
              IF tm.d_date < tm.s_date THEN
                 CALL cl_err(tm.d_date,'mfg6164',0)
                 NEXT FIELD d_date
              END IF
           END IF
           IF tm.d_date - tm.s_date > 500 THEN
              CALL cl_err('','mfg0155',1)
              NEXT FIELD d_date
           END IF
 
 
      AFTER FIELD sub
         IF tm.sub NOT MATCHES '[123]' THEN NEXT FIELD sub END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[123]' OR cl_null(tm.b) THEN
            NEXT FIELD b
         END IF
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
      CLOSE WINDOW r043_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
 
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aicr043'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr043','9031',1)
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
                         " '",tm.s     CLIPPED,"'",
                         " '",tm.sub    CLIPPED,"'",
                         " '",tm.b    CLIPPED,"'",
			 " '",tm.s_date CLIPPED,"'",         
                         " '",tm.d_date CLIPPED,"'", 
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('aicr043',g_time,l_cmd)
      END IF
      CLOSE WINDOW r043_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r043()
   ERROR ""
END WHILE
   CLOSE WINDOW r043_w
END FUNCTION
 
FUNCTION r043()
   DEFINE l_name    LIKE type_file.chr20,      
          l_time    LIKE type_file.chr8,        
       
          l_sql     STRING,          
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE type_file.chr50,
          l_order   ARRAY[5] OF LIKE type_file.chr50, 
          l_amt1    LIKE type_file.num20,
          l_amt2    LIKE type_file.num20,
          l_amt3    LIKE type_file.num20,
          l_amt4    LIKE type_file.num20,
          l_sum     LIKE type_file.num20,
          l_imaicd06 LIKE imaicd_file.imaicd06,
          sr              RECORD order1 LIKE type_file.chr50, 
                                 order2 LIKE type_file.chr50, 
                                 order3 LIKE type_file.chr50,
                                 rva01 LIKE rva_file.rva01,  
                                 rva05 LIKE rva_file.rva05,  
                                 rva06 LIKE rva_file.rva06,  
                                 rvb02 LIKE rvb_file.rvb02, 
                                 rvb03 LIKE rvb_file.rvb03,
                                 rvb04 LIKE rvb_file.rvb04,
                                 rvb05 LIKE rvb_file.rvb05,
                                 rvb07 LIKE rvb_file.rvb07, 
                                 rvb08 LIKE rvb_file.rvb08, 
                                 rvb19 LIKE rvb_file.rvb19,  
                                 rvb22 LIKE rvb_file.rvb22, 
                                 rvb30 LIKE rvb_file.rvb30,  
                                 rvb29 LIKE rvb_file.rvb29,  
                                 rvb31 LIKE rvb_file.rvb31,  
                                 pmn041 LIKE pmn_file.pmn041,
                                 rvb34 LIKE rvb_file.rvb34,
                                 pmn07 LIKE pmn_file.pmn07,  
                                 rvb10 LIKE rvb_file.rvb10,  
                                 pmc03 LIKE pmc_file.pmc03,  
                                 pmm22 LIKE pmm_file.pmm22,  
                                 pmm42 LIKE pmm_file.pmm42,
                                 azi03 LIKE azi_file.azi03,
                                 azi04 LIKE azi_file.azi04,
                                 azi05 LIKE azi_file.azi05,
				                 rvb38 LIKE rvb_file.rvb38,
				                 rvb88 LIKE rvb_file.rvb88,	
				                 rvb88t LIKE rvb_file.rvb88t	
                                 END RECORD
   DEFINE l_rvbiicd03  LIKE rvbi_file.rvbiicd03 #FUN-C30285
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time   #FUN-B90044  MARK
     CALL cl_del_data(l_table)

        LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                    " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   #FUN-C30285

     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
         EXIT PROGRAM
     END IF
              
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aicr043'
     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
                              FROM azi_file
                             WHERE azi01 = g_aza.aza17
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           
     #     END IF
     #     IF g_priv3='4' THEN                           
     #         LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN   
     #         LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('user', 'grup')
     #End:FUN-980030

        LET l_sql = "SELECT '','','',",
                    " rva01, rva05, rva06, rvb02, rvb03, rvb04, rvb05, ",
                    " rvb07, rvb08, rvb19, rvb22, rvb30, rvb29, rvb31, ",
                    " pmn041,rvb34, pmn07, rvb10, pmc03,",
                    " pmm22,pmm42,azi03,azi04,azi05, ",
		            " rvb38,rvb88,rvb88t,rvbiicd03",     #FUN-C30285
                    #FUN-C30285----begin
                    #" FROM rva_file, rvb_file, pmm_file, pmn_file,",
                    #" OUTER pmc_file,OUTER azi_file ",
                    #" WHERE rva01 = rvb01 ",
                    #" AND rvb04 = pmm01 ",
                    #" AND pmn01 = pmm01 ",
                    #" AND pmn02 = rvb03 ",
                    #" AND pmc_file.pmc01 = rva_file.rva05 ",
                    #" AND pmm_file.pmm22 = azi_file.azi01 ",
                    #" AND pmm18 !='X' ",
                    " FROM rva_file ",
                    " INNER JOIN rvb_file ON rva_file.rva01 = rvb_file.rvb01 ",
                    " INNER JOIN pmm_file ON rvb_file.rvb04 = pmm_file.pmm01 ",
                    " INNER JOIN pmn_file ON pmn_file.pmn01 = pmm_file.pmm01 ",
                    " AND pmn_file.pmn02 = rvb_file.rvb03 ",
                    " INNER JOIN rvbi_file ON (rvb_file.rvb01 = rvbi_file.rvbi01 AND rvb_file.rvb02 = rvbi_file.rvbi02)",  #FUN-C30285
                    " LEFT OUTER JOIN pmc_file ON pmc_file.pmc01 = rva_file.rva05 ",
                    " LEFT OUTER JOIN azi_file ON pmm_file.pmm22 = azi_file.azi01 ",
                    " WHERE pmm18 !='X' ",
                    #FUN-C30285----end
                    " AND rvaconf !='X' ",
		            " AND pmn011 = 'SUB' ",
		            " and rvb30>0 ",		 
                    " AND ", tm.wc CLIPPED

     IF tm.s_date IS NOT NULL THEN
        LET l_sql=l_sql clipped, " AND rva06 >='",tm.s_date,"'"
     END IF
 
     IF tm.d_date IS NOT NULL THEN
        LET l_sql=l_sql clipped, " AND rva06 <='",tm.d_date,"'"
     END IF
     
     IF tm.b='1' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='Y' "
     END IF
     IF tm.b='2' THEN
        LET l_sql = l_sql CLIPPED," AND rvaconf='N' "
     END IF
     PREPARE r043_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     DECLARE r043_curs1 CURSOR FOR r043_prepare1
     FOREACH r043_curs1 INTO sr.*,l_rvbiicd03   #FUN-C30285
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF tm.sub = '1' THEN
             IF sr.rvb19 ='2' THEN CONTINUE FOREACH END IF
          END IF
          IF tm.sub = '2' THEN
             IF sr.rvb19 ='1' THEN CONTINUE FOREACH END IF
          END IF
          SELECT imaicd06 INTO l_imaicd06 
            FROM imaicd_file  
#               WHERE imaicd01=sr.rvb05              #No.FUN-830065
                WHERE imaicd00=sr.rvb05              #No.FUN-830065
          LET l_amt1 = sr.rvb30 * sr.rvb10
          LET l_amt2 = sr.rvb88t - sr.rvb88
          LET l_amt3 = l_amt1 + l_amt2
          LET l_sum = sr.rvb30*sr.rvb10*sr.pmm42

             EXECUTE insert_prep USING
                    sr.rva05,sr.rva01,sr.rvb02,sr.rva06,sr.rvb04,sr.rvb03,sr.rvb05,
                    l_imaicd06,sr.rvb38,sr.rvb30,sr.rvb10,l_amt1,l_amt2,l_amt3,
                    sr.rvb22,l_sum,l_rvbiicd03   #FUN-C30285

       END FOREACH
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       
       IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'rva01,rva05,rva06,rvb04,rvb05')
                 RETURNING tm.wc
       END IF
       LET g_str = tm.wc,";",tm.s_date,";",tm.d_date,";",tm.s[1,1],";",tm.s[2],
                   ";",tm.s[3]

       CALL cl_prt_cs3('aicr043','aicr043',g_sql,g_str)

       #CALL cl_used(g_prog,l_time,2) RETURNING l_time     #FUN-B90044
END FUNCTION
# Modify FUN-7B0027 
