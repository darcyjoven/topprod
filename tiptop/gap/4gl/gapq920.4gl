# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: gapq920.4gl
# Descriptions...: 廠商業務明細帳列印
# Date & Author..: No:MOD-990260 09/09/30 By Carrier 將gapq910和axrq710合并

DATABASE ds  #MOD-990260

GLOBALS "../../config/top.global"

DEFINE tm             RECORD               
                      wc 	   STRING,	
		      bdate   LIKE type_file.dat, 
		      edate   LIKE type_file.dat, 
                      o       LIKE aaa_file.aaa01,
                      b       LIKE type_file.chr1,
                      c       LIKE type_file.chr1,
                      d       LIKE type_file.chr1,                
                      e       LIKE type_file.chr1,
		      more    LIKE type_file.chr1  # Input more condition(Y/N)
                      END RECORD
DEFINE g_d            LIKE type_file.chr1
DEFINE g_print        LIKE type_file.num5
DEFINE g_str          STRING
DEFINE l_table        STRING
DEFINE g_sql          STRING
DEFINE g_rec_b        LIKE type_file.num10
DEFINE g_npq03        LIKE npq_file.npq03
DEFINE g_aag02        LIKE aag_file.aag02
DEFINE g_npq21        LIKE npq_file.npq21
DEFINE g_npq22        LIKE npq_file.npq22
DEFINE g_npq24        LIKE npq_file.npq24 
DEFINE g_mm           LIKE type_file.num5
DEFINE mm1,nn1        LIKE type_file.num10
DEFINE yy             LIKE type_file.num10
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_npq          DYNAMIC ARRAY OF RECORD
                      npp02      LIKE npp_file.npp02,
                      npp01      LIKE npp_file.npp01,
                      npp00      LIKE npp_file.npp00,
                      nppsys     LIKE npp_file.nppsys,
                      nppglno    LIKE npp_file.nppglno,
                      npq04      LIKE npq_file.npq04,
                      npq24      LIKE npq_file.npq24,
                      df         LIKE npq_file.npq07,
                      npq25_d    LIKE npq_file.npq25,
                      d          LIKE npq_file.npq07,
                      cf         LIKE npq_file.npq07,
                      npq25_c    LIKE npq_file.npq25,
                      c          LIKE npq_file.npq07,
                      dc         LIKE type_file.chr10,
                      balf       LIKE npq_file.npq07,
                      npq25_bal  LIKE npq_file.npq25,
                      bal        LIKE npq_file.npq07
                      END RECORD
DEFINE g_pr           RECORD
                      npq21      LIKE npq_file.npq21,
                      npq22      LIKE npq_file.npq22,
                      npq03      LIKE npq_file.npq03,
                      aag02      LIKE aag_file.aag02,
                      mm         LIKE type_file.num5,
                      type       LIKE type_file.chr1,
                      npp02      LIKE npp_file.npp02,
                      npp01      LIKE npp_file.npp01,
                      nppglno    LIKE npp_file.nppglno,
                      npq04      LIKE npq_file.npq04,
                      npq24      LIKE npq_file.npq24,
                      npq06      LIKE npq_file.npq06,
                      npq07      LIKE npq_file.npq07,
                      npq07f     LIKE npq_file.npq07f,
                      df         LIKE npq_file.npq07,
                      npq25_d    LIKE npq_file.npq25,
                      d          LIKE npq_file.npq07,
                      cf         LIKE npq_file.npq07,
                      npq25_c    LIKE npq_file.npq25,
                      c          LIKE npq_file.npq07,
                      dc         LIKE type_file.chr10,
                      balf       LIKE npq_file.npq07,
                      npq25_bal  LIKE npq_file.npq25,
                      bal        LIKE npq_file.npq07,
                      pagenum    LIKE type_file.num5,
                      azi04      LIKE azi_file.azi04,
                      azi05      LIKE azi_file.azi05,
                      azi07      LIKE azi_file.azi07
                      END RECORD
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10  
DEFINE g_curs_index   LIKE type_file.num10  
DEFINE g_jump         LIKE type_file.num10  
DEFINE mi_no_ask      LIKE type_file.num5   
DEFINE l_ac           LIKE type_file.num5           #目前處理的ARRAY CNT        

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF

   INITIALIZE tm.* TO NULL                # Default condition

   #-->使用預設帳別之幣別
   #-----TQC-610053---------
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.o     = ARG_VAL(10)
   LET tm.b     = ARG_VAL(11)
   LET tm.c     = ARG_VAL(12)
   LET tm.d     = ARG_VAL(13)
   LET tm.e     = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)
   #-----END TQC-610053----

   CALL q920_out_1()

   OPEN WINDOW q920_w AT 5,10
        WITH FORM "gap/42f/gapq920_1" ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()

   IF cl_null(tm.wc) THEN
      CALL gapq920_tm(0,0)             # Input print condition
   ELSE
      CALL gapq920() 
      CALL gapq920_t()
   END IF

   CALL q920_menu()
   DROP TABLE gapq920_tmp;
   CLOSE WINDOW q920_w
END MAIN

FUNCTION q920_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
 
   WHILE TRUE
      CALL q920_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gapq920_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q920_out_2()
            END IF
         WHEN "query_account"
            IF cl_chk_act_auth() THEN
               CALL q920_q_a()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_npq),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_npq21 IS NOT NULL THEN
                  LET g_doc.column1 = "npq21"
                  LET g_doc.value1 = g_npq21
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION gapq920_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      
DEFINE li_chk_bookno  LIKE type_file.num5      
DEFINE p_row,p_col    LIKE type_file.num5,     
       l_n            LIKE type_file.num5,     
       l_flag         LIKE type_file.num5,     
       l_cmd          LIKE type_file.chr1000   

   LET p_row = 3 LET p_col =20

   OPEN WINDOW gapq920_w AT p_row,p_col WITH FORM "gap/42f/gapq920"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("gapq920")

   CALL cl_opmsg('p')
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.o = g_aza.aza81
   LET tm.b = 'N'
   LET tm.c = 'N'       
   LET tm.d = '1'
   LET tm.e = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   DISPLAY BY NAME tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npq21,npp01,npq03

       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION CONTROLP
          CASE WHEN INFIELD(npq03)     #科目代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= 'c'
                  LET g_qryparam.form = 'q_aag'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO npq03
                  NEXT FIELD npq03
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
       LET INT_FLAG = 0 CLOSE WINDOW gapq920_w EXIT PROGRAM
    END IF
    IF tm.wc = ' 1=1' THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
    INPUT BY NAME tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.e,tm.d,tm.more            
                  WITHOUT DEFAULTS
        
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        
        AFTER FIELD bdate
          IF cl_null(tm.bdate) THEN
             CALL cl_err('','mfg3018',0)
             NEXT FIELD bdate
          END IF

        AFTER FIELD edate
          IF cl_null(tm.edate) THEN
             CALL cl_err('','mfg3018',0)
             NEXT FIELD edate
          END IF
          IF YEAR(tm.bdate) <> YEAR(tm.edate) THEN
             CALL cl_err('','gxr-001',0)
             NEXT FIELD bdate
          END IF
          IF tm.bdate > tm.edate THEN
             CALL cl_err('','aap-100',0)
             NEXT FIELD bdate
          END IF

        AFTER FIELD o
          IF cl_null(tm.o) THEN CALL cl_err('','mfg3018',0) NEXT FIELD o END IF
          CALL s_check_bookno(tm.o,g_user,g_plant) 
               RETURNING li_chk_bookno
          IF (NOT li_chk_bookno) THEN
              NEXT FIELD o
          END IF 
          SELECT * FROM aaa_file WHERE aaa01 = tm.o
          IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0) 
             NEXT FIELD o
          END IF
 
        BEFORE FIELD b
          CALL cl_set_comp_entry('c',TRUE)

        AFTER FIELD b
          LET l_flag = 1
          IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
             NEXT FIELD b
          END IF
          IF tm.b = 'N' THEN
             LET tm.c = 'N'
             DISPLAY BY NAME tm.c
             CALL cl_set_comp_entry('c',FALSE)
          END IF
          
       AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
             NEXT FIELD c
          END IF        
 
        AFTER FIELD d
          IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF

        AFTER FIELD e
          IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
             NEXT FIELD e
          END IF
 
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

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
       LET INT_FLAG = 0 CLOSE WINDOW gapq920_w EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='gapq920'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gapq920','9031',1)
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate   CLIPPED,"'",
                          " '",g_towhom  CLIPPED,"'",
                          " '",g_lang    CLIPPED,"'",
                          " '",g_bgjob   CLIPPED,"'",
                          " '",g_prtway  CLIPPED,"'",
                          " '",g_copies  CLIPPED,"'",
                          " '",tm.wc     CLIPPED,"'",
                          " '",tm.bdate  CLIPPED,"'",
                          " '",tm.edate  CLIPPED,"'",
                          " '",tm.o      CLIPPED,"'",
                          " '",tm.b      CLIPPED,"'",
                          " '",tm.c      CLIPPED,"'",            
                          " '",tm.d      CLIPPED,"'",
                          " '",tm.e      CLIPPED,"'",
                          " '",g_rep_user CLIPPED,"'",           
                          " '",g_rep_clas CLIPPED,"'",           
                          " '",g_template CLIPPED,"'"            
          CALL cl_cmdat('gapq920',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW gapq920_w
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gapq920()
    ERROR ""
    EXIT WHILE   
END WHILE
   CLOSE WINDOW gapq920_w
  
   CALL gapq920_t()
END FUNCTION

FUNCTION gapq920()
   DEFINE l_name    LIKE type_file.chr20,    
          l_sql     STRING,             
          l_sql1    STRING,             
          l_apa09   LIKE apa_file.apa09,
          l_apa08   LIKE apa_file.apa08,
          l_totf    LIKE npr_file.npr06f,     #npr before period
          l_tot     LIKE npr_file.npr06,
          l_npq07f  LIKE npq_file.npq07f,     #npq before period
          l_npq07   LIKE npq_file.npq07f,
          d_npq07f  LIKE npq_file.npq07f,     #debit before period
          d_npq07   LIKE npq_file.npq07f,
          c_npq07f  LIKE npq_file.npq07f,     #credit before period
          c_npq07   LIKE npq_file.npq07f,
          m_npq07   LIKE npq_file.npq07f,     #middle period
          m_npq07f  LIKE npq_file.npq07f,
          l_qcye    LIKE npq_file.npq07,      #total before period
          l_qcyef   LIKE npq_file.npq07,
          t_qcye    LIKE npq_file.npq07,      #total before period
          t_qcyef   LIKE npq_file.npq07,
          l_npp01   LIKE npp_file.npp01,
          l_flag    LIKE type_file.chr1,     
          l_i       LIKE type_file.num5,     
          l_term    LIKE type_file.chr1000,  
          l_npr06f  LIKE npr_file.npr06f,
          l_npr06   LIKE npr_file.npr06f,
          l_npr07f  LIKE npr_file.npr06f,
          l_npr07   LIKE npr_file.npr06f,
          sr1       RECORD
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE npq_file.npq22,
                    npq03    LIKE npq_file.npq03,
                    npq24    LIKE npq_file.npq24 
                    END RECORD,
          sr        RECORD
                    npp01    LIKE npp_file.npp01,
                    npp00    LIKE npp_file.npp00,
                    nppsys   LIKE npp_file.nppsys,
                    npp02    LIKE npp_file.npp02,
                    nppglno  LIKE npp_file.nppglno,
                    npq04    LIKE npq_file.npq04,
                    npq03    LIKE npq_file.npq03,
                    aag02    LIKE aag_file.aag02,
                    mm       LIKE type_file.num5,
                    npq06    LIKE npq_file.npq06,
                    npq07f   LIKE npq_file.npq07f,
                    npq07    LIKE npq_file.npq07,
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE occ_file.occ18,
                    npq24    LIKE npq_file.npq24,
                    apa09    LIKE apa_file.apa09,
                    apa08    LIKE apa_file.apa08,
                    qcyef    LIKE npq_file.npq07,  #qcye
                    qcye     LIKE npq_file.npq07,
                    df_p     LIKE npq_file.npq07,  #debit of current period(day1 ~ bdate-1)
                    d_p      LIKE npq_file.npq07,
                    cf_p     LIKE npq_file.npq07,
                    c_p      LIKE npq_file.npq07,
                    df_y     LIKE npq_file.npq07,  #debit of current year(1~bdate-1)
                    d_y      LIKE npq_file.npq07,
                    cf_y     LIKE npq_file.npq07,
                    c_y      LIKE npq_file.npq07
                    END RECORD
          
    LET g_prog = 'gapr910'
    CALL gapq920_table()
     
    SELECT zo02 INTO g_company FROM zo_file
     WHERE zo01 = g_rlang

     IF tm.d = '1' THEN
        LET g_d = 'Y'
     ELSE
        LET g_d = 'N'
     END IF

     LET mm1 = MONTH(tm.bdate)
     LET nn1 = MONTH(tm.edate)
     LET yy  = YEAR(tm.bdate)

     LET l_term = "  WHERE nppsys = npqsys AND npp00 = npq00 ",
                  "    AND npp01 = npq01   AND npp011 = npq011 ",
                  "    AND npptype = npqtype ",
                  "    AND (nppsys = 'AP' OR nppsys = 'AR') AND npp011 = 1 ",
             #    "    AND npp011 = 1 ",
             #    "    AND npp06 = '",g_plant,"'",
             #    "    AND npp07 = '",tm.o,"'",
                  "    AND ",tm.wc CLIPPED
     IF tm.c = 'Y' THEN                                                    
         LET l_sql = " SELECT UNIQUE npq21,npq22,npq03,npq24 ",            
                     "   FROM npq_file,npp_file ",l_term CLIPPED           
     ELSE                                                                  
         LET l_sql = " SELECT UNIQUE npq21,npq22,npq03,'' ",               
                     "   FROM npq_file,npp_file ",l_term CLIPPED
     END IF                                                                
     PREPARE gapq920_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        EXIT PROGRAM
     END IF
     DECLARE gapq920_curs1 CURSOR FOR gapq920_pr1

     IF tm.c = 'Y' THEN                                                     
        LET l_sql1="SELECT npp01,npp00,nppsys,npp02,nppglno,npq04,npq03,aag02,0,npq06,SUM(npq07f),",
                   "       SUM(npq07),npq21,npq22,npq24,'','',0,0,0,0,0,0,0,0,0,0 ",
                   "  FROM npp_file,npq_file,aag_file ", l_term CLIPPED,
                   "   AND npq03 = aag01 ",
                   "   AND aag00 ='",tm.o,"'",   
                   "   AND npq21 = ? AND npq22 = ? ",
                   "   AND npq03 = ? ",
                   "   AND MONTH(npp02) = ? ",
                   "   AND npq24 = ? ",                                         
                   "   AND npp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   " GROUP BY npp01,npp00,nppsys,npq24,npp02,nppglno,npq04,npq03,aag02,npq06,npq21,npq22 ",
                   " ORDER BY npq21,npq22,nppglno,npq03,npp02,npp01,npq06 "
     ELSE
        LET l_sql1="SELECT npp01,npp00,nppsys,npp02,nppglno,npq04,npq03,aag02,0,npq06,SUM(npq07f),",
                   "       SUM(npq07),npq21,npq22,npq24,'','',0,0,0,0,0,0,0,0,0,0 ",
                   "  FROM npp_file,npq_file,aag_file ", l_term CLIPPED,
                   "   AND npq03 = aag01 ",
                   "   AND aag00 ='",tm.o,"'",   
                   "   AND npq21 = ? AND npq22 = ? ",
                   "   AND npq03 = ? ",
                   "   AND MONTH(npp02) = ? ",
                   "   AND npp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   " GROUP BY npp01,npp00,nppsys,npp02,nppglno,npq04,npq03,aag02,npq06,npq21,npq22,npq24 ",
                   " ORDER BY npq21,npq22,nppglno,npq03,npp02,npp01,npq06 "
     END IF                                                                       
                                        
     PREPARE gapq920_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM
     END IF
     DECLARE gapq920_cursb CURSOR FOR gapq920_prepare1

     IF tm.c = 'Y' THEN 
         LET l_sql1=" SELECT npp01,SUM(npq07f),SUM(npq07) ",
                    "   FROM npq_file,npp_file ",l_term CLIPPED,
                    "    AND npq21 = ? AND npq22 = ? ",
                    "    AND npq03 = ? AND npq06 = ?",
                    "    AND npq24 = ?",                                   
                    "    AND YEAR(npp02) = ",YEAR(tm.bdate),                        
                    "    AND MONTH(npp02)= ",MONTH(tm.bdate),                       
                    "    AND npp02 < '",tm.bdate,"'", 
                    "  GROUP BY npp01 "
     ELSE
         LET l_sql1=" SELECT npp01,SUM(npq07f),SUM(npq07) ",
                    "   FROM npq_file,npp_file ",l_term CLIPPED,
                    "    AND npq21 = ? AND npq22 = ? ",
                    "    AND npq03 = ? AND npq06 = ?",
                    "    AND YEAR(npp02) = ",YEAR(tm.bdate),                        
                    "    AND MONTH(npp02)= ",MONTH(tm.bdate),                       
                    "    AND npp02 < '",tm.bdate,"'", 
                    "  GROUP BY npp01 "
     END IF                                                                       
                         
     PREPARE gapq920_prepare3 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM
     END IF
     DECLARE gapq920_curd CURSOR FOR gapq920_prepare3

     CALL cl_outnam('gapr910') RETURNING l_name
     IF tm.c = 'Y' THEN                          
        START REPORT gapq920_rep1 TO l_name      
     ELSE                                        
        START REPORT gapq920_rep TO l_name
     END IF                                      
     LET g_pageno = 0

     FOREACH gapq920_curs1 INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
        END IF

        #期初余額 & 起始前的借貸合計值
        IF tm.c = 'Y' THEN       
          SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #前幾期的余額
            INTO l_npr06f,l_npr07f,l_npr06,l_npr07 FROM npr_file
           WHERE npr00 = sr1.npq03 
             AND npr01 = sr1.npq21 AND npr02 = sr1.npq22
             AND npr11 = sr1.npq24                              
             AND npr04 = YEAR(tm.bdate)
             AND npr05 < MONTH(tm.bdate)
             AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o   
        ELSE
          SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #前幾期的余額
            INTO l_npr06f,l_npr07f,l_npr06,l_npr07 FROM npr_file
           WHERE npr00 = sr1.npq03 
             AND npr01 = sr1.npq21 AND npr02 = sr1.npq22
             AND npr04 = YEAR(tm.bdate)
             AND npr05 < MONTH(tm.bdate)
             AND (npr08 = g_plant OR npr08 IS NULL OR npr08 =' ') AND npr09 = tm.o   
        END IF                                                                       
           
        IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
        IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
        IF cl_null(l_npr06)  THEN LET l_npr06  = 0 END IF
        IF cl_null(l_npr07)  THEN LET l_npr07  = 0 END IF
        LET l_totf = l_npr06f - l_npr07f
        LET l_tot  = l_npr06  - l_npr07 
        IF cl_null(l_totf) THEN LET l_totf = 0 END IF
        IF cl_null(l_tot) THEN LET l_tot = 0 END IF
        
        LET d_npq07f = 0     LET d_npq07 = 0
        
        IF tm.c = 'Y' THEN                                                       
           FOREACH gapq920_curd USING sr1.npq21,sr1.npq22,sr1.npq03,'1',sr1.npq24 
                                 INTO l_npp01,l_npq07f,l_npq07                    
             IF SQLCA.sqlcode THEN 
                CALL cl_err('foreach:',SQLCA.sqlcode,0)
                EXIT FOREACH
             END IF
             CALL q920_apa(0,l_npp01) RETURNING l_flag,l_apa09,l_apa08
             IF l_flag = 'N' THEN CONTINUE FOREACH END IF
             LET d_npq07  = d_npq07  + l_npq07
             LET d_npq07f = d_npq07f + l_npq07f
           END FOREACH                               
        ELSE
           FOREACH gapq920_curd USING sr1.npq21,sr1.npq22,sr1.npq03,'1'         
                                 INTO l_npp01,l_npq07f,l_npq07 
             IF SQLCA.sqlcode THEN 
                CALL cl_err('foreach:',SQLCA.sqlcode,0)
                EXIT FOREACH
             END IF
             CALL q920_apa(0,l_npp01) RETURNING l_flag,l_apa09,l_apa08
             IF l_flag = 'N' THEN CONTINUE FOREACH END IF
             LET d_npq07  = d_npq07  + l_npq07
             LET d_npq07f = d_npq07f + l_npq07f
           END FOREACH                                     
        END IF                                                                   

        IF cl_null(d_npq07f) THEN LET d_npq07f = 0 END IF
        IF cl_null(d_npq07)  THEN LET d_npq07  = 0 END IF

        LET c_npq07f = 0     LET c_npq07 = 0
        
        IF tm.c = 'Y' THEN                                                       
          FOREACH gapq920_curd USING sr1.npq21,sr1.npq22,sr1.npq03,'2',sr1.npq24 
                                INTO l_npp01,l_npq07f,l_npq07
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            CALL q920_apa(0,l_npp01) RETURNING l_flag,l_apa09,l_apa08
            IF l_flag = 'N' THEN CONTINUE FOREACH END IF
            LET c_npq07  = c_npq07  + l_npq07
            LET c_npq07f = c_npq07f + l_npq07f
          END FOREACH                                                   
        ELSE
          FOREACH gapq920_curd USING sr1.npq21,sr1.npq22,sr1.npq03,'2'         
                                INTO l_npp01,l_npq07f,l_npq07
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            CALL q920_apa(0,l_npp01) RETURNING l_flag,l_apa09,l_apa08
            IF l_flag = 'N' THEN CONTINUE FOREACH END IF
            LET c_npq07  = c_npq07  + l_npq07
            LET c_npq07f = c_npq07f + l_npq07f
          END FOREACH                                      
        END IF                                                                   

        IF cl_null(c_npq07f) THEN LET c_npq07f = 0 END IF
        IF cl_null(c_npq07)  THEN LET c_npq07  = 0 END IF
 
        LET l_qcyef = l_totf + d_npq07f - c_npq07f  #原幣期初余額
        LET l_qcye  = l_tot  + d_npq07  - c_npq07   #本幣期初余額
        LET t_qcye  = l_qcye
     
        IF tm.c = 'Y' THEN 
           SELECT SUM(npq07f),SUM(npq07) INTO m_npq07f,m_npq07  #當期異動
             FROM npp_file,npq_file,aag_file
            WHERE nppsys=npqsys and npp00=npq00
              AND npp01=npq01   AND npp011 = npq011
              AND npptype = npqtype
              AND (nppsys = 'AP' OR nppsys = 'AR') AND npp011 = 1
              AND npq21 = sr1.npq21 AND npq22 = sr1.npq22
              AND npq03 = sr1.npq03
              AND npq24 = sr1.npq24
              AND npp02 BETWEEN tm.bdate AND tm.edate
              AND aag00 = tm.o    AND aag01 = npq03
        ELSE
           SELECT SUM(npq07f),SUM(npq07) INTO m_npq07f,m_npq07  #當期異動
             FROM npp_file,npq_file,aag_file
            WHERE nppsys=npqsys and npp00=npq00
              AND npp01=npq01   AND npp011 = npq011
              AND npptype = npqtype
              AND (nppsys = 'AP' OR nppsys = 'AR') AND npp011 = 1
              AND npq21 = sr1.npq21 AND npq22 = sr1.npq22
              AND npq03 = sr1.npq03
              AND npp02 BETWEEN tm.bdate AND tm.edate
              AND aag00 = tm.o    AND aag01 = npq03               
        END IF                                                                       
        IF cl_null(m_npq07f) THEN LET m_npq07f = 0 END IF
        IF cl_null(m_npq07)  THEN LET m_npq07  = 0 END IF

        IF tm.e = 'N' THEN   #期初為零且無異動不打印
           IF tm.b = 'N' AND l_qcye = 0 AND m_npq07 = 0 THEN  #本幣
              CONTINUE FOREACH
           END IF
           IF tm.b = 'Y' AND l_qcyef  = 0 AND l_qcye  = 0     #外幣
                         AND m_npq07f = 0 AND m_npq07 = 0 THEN
                 CONTINUE FOREACH
           END IF
        END IF

        FOR l_i = mm1 TO nn1
            LET g_print = 0
            IF tm.c = 'Y' THEN                                                        
               FOREACH gapq920_cursb USING sr1.npq21,sr1.npq22,sr1.npq03,l_i,sr1.npq24 
                                     INTO sr.*                                         
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  CALL q920_apa(1,sr.npp01) RETURNING l_flag,l_apa09,l_apa08
                  IF l_flag = 'N' THEN CONTINUE FOREACH END IF
                  LET sr.apa09 = l_apa09
                  LET sr.apa08 = l_apa08
                  LET sr.qcyef = l_qcyef
                  LET sr.qcye  = l_qcye
                  
                  IF sr.npq06 = '1' THEN
                      LET t_qcye = t_qcye + sr.npq07
                  ELSE
                      LET t_qcye = t_qcye - sr.npq07
                  END IF
                  LET sr.mm   = l_i                                                 
                  LET sr.df_p = d_npq07f                                            
                  LET sr.d_p  = d_npq07                                             
                  LET sr.cf_p = c_npq07f                                            
                  LET sr.c_p  = c_npq07                                             
                  LET sr.df_y = l_npr06f + d_npq07f                                 
                  LET sr.d_y  = l_npr06  + d_npq07                                  
                  LET sr.cf_y = l_npr07f + c_npq07f                                 
                  LET sr.c_y  = l_npr07  + c_npq07
                  OUTPUT TO REPORT gapq920_rep1(sr.*)	                
                  LET g_print = g_print + 1
               END FOREACH                                    
            ELSE
               FOREACH gapq920_cursb USING sr1.npq21,sr1.npq22,sr1.npq03,l_i         
                                     INTO sr.*                                          
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('foreach:',SQLCA.sqlcode,0)
                     EXIT FOREACH
                  END IF
                  CALL q920_apa(1,sr.npp01) RETURNING l_flag,l_apa09,l_apa08
                  IF l_flag = 'N' THEN CONTINUE FOREACH END IF
                  LET sr.apa09 = l_apa09
                  LET sr.apa08 = l_apa08
                  LET sr.qcyef = l_qcyef
                  LET sr.qcye  = l_qcye
                  IF sr.npq06 = '1' THEN
                      LET t_qcye = t_qcye + sr.npq07
                  ELSE
                      LET t_qcye = t_qcye - sr.npq07
                  END IF
                  LET sr.mm   = l_i                                                 
                  LET sr.df_p = d_npq07f                                            
                  LET sr.d_p  = d_npq07                                             
                  LET sr.cf_p = c_npq07f                                            
                  LET sr.c_p  = c_npq07                                             
                  LET sr.df_y = l_npr06f + d_npq07f                                 
                  LET sr.d_y  = l_npr06  + d_npq07                                  
                  LET sr.cf_y = l_npr07f + c_npq07f                                 
                  LET sr.c_y  = l_npr07  + c_npq07
                  OUTPUT TO REPORT gapq920_rep(sr.*)                                 
                  LET g_print = g_print + 1
               END FOREACH
            END IF                                                                    
            IF g_print = 0 THEN   #沒有打印過
               IF t_qcye = 0 THEN CONTINUE FOR END IF
               LET sr.npp01 = ''
               LET sr.npp00 = ''
               LET sr.nppsys = ''
               LET sr.npp02 = ''
               LET sr.nppglno = ''
               LET sr.npq04 = ''
               LET sr.npq03 = sr1.npq03
               SELECT aag02 INTO sr.aag02 FROM aag_file
                WHERE aag01 = sr1.npq03
                  AND aag00 = tm.o
               LET sr.npq06 = ''
               LET sr.npq07f =0
               LET sr.npq07 = 0
               LET sr.npq21 = sr1.npq21
               LET sr.npq22 = sr1.npq22
               IF tm.c = 'Y' THEN
                  LET sr.npq24 = sr1.npq24
               ELSE
                  LET sr.npq24 = '' 
               END IF
               LET sr.apa09 =''
               LET sr.apa08 =''
               LET sr.qcye  = l_qcye
               LET sr.qcyef = l_qcyef
               LET sr.mm   = l_i                                                
               LET sr.df_p = d_npq07f                                           
               LET sr.d_p  = d_npq07                                            
               LET sr.cf_p = c_npq07f                                           
               LET sr.c_p  = c_npq07                                            
               LET sr.df_y = l_npr06f + d_npq07f                                 
               LET sr.d_y  = l_npr06  + d_npq07                                  
               LET sr.cf_y = l_npr07f + c_npq07f                                 
               LET sr.c_y  = l_npr07  + c_npq07
               IF tm.c = 'Y' THEN
                  OUTPUT TO REPORT gapq920_rep1(sr.*)
               ELSE
                  OUTPUT TO REPORT gapq920_rep(sr.*)
               END IF	    
            END IF
        END FOR
     END FOREACH
 
     IF tm.c = 'Y' THEN                          
        FINISH REPORT gapq920_rep1               
     ELSE                                        
        FINISH REPORT gapq920_rep
     END IF                                      
     LET g_prog = 'gapq920'

END FUNCTION

REPORT gapq920_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,          
          sr        RECORD
                    npp01    LIKE npp_file.npp01,
                    npp00    LIKE npp_file.npp00,
                    nppsys   LIKE npp_file.nppsys,
                    npp02    LIKE npp_file.npp02,
                    nppglno  LIKE npp_file.nppglno,
                    npq04    LIKE npq_file.npq04,
                    npq03    LIKE npq_file.npq03,
                    aag02    LIKE aag_file.aag02,
                    mm       LIKE type_file.num5,
                    npq06    LIKE npq_file.npq06,
                    npq07f   LIKE npq_file.npq07f,
                    npq07    LIKE npq_file.npq07,
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE occ_file.occ18,
                    npq24    LIKE npq_file.npq24,
                    apa09    LIKE apa_file.apa09,
                    apa08    LIKE apa_file.apa08,
                    qcyef    LIKE npq_file.npq07,  #qcye
                    qcye     LIKE npq_file.npq07,
                    df_p     LIKE npq_file.npq07,  #debit of current period(day1 ~ bdate-1)
                    d_p      LIKE npq_file.npq07,
                    cf_p     LIKE npq_file.npq07,
                    c_p      LIKE npq_file.npq07,
                    df_y     LIKE npq_file.npq07,  #debit of current year(1~bdate-1)
                    d_y      LIKE npq_file.npq07,
                    cf_y     LIKE npq_file.npq07,
                    c_y      LIKE npq_file.npq07
                    END RECORD,
          t_bal,t_balf                 LIKE npq_file.npq07,
          y_debit,y_debitf             LIKE npq_file.npq07,
          y_credit,y_creditf           LIKE npq_file.npq07,
          p_debit,p_debitf             LIKE npq_file.npq07,
          p_credit,p_creditf           LIKE npq_file.npq07,
          l_d,l_df,l_c,l_cf            LIKE npq_file.npq07,
          y_d,y_df,y_c,y_cf            LIKE npq_file.npq07,
	  n_bal,n_balf                 LIKE type_file.num20_6, 
          l_npq25_c,l_npq25_d,l_npq25_bal LIKE npq_file.npq25,
          l_date                       LIKE type_file.dat,     
          l_date1                      LIKE type_file.dat,     
          l_date2                      LIKE type_file.dat,     
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npq21,sr.npq22,sr.npq03,sr.mm,sr.npp02,sr.npp01,sr.npq06
  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1

   BEFORE GROUP OF sr.npq03     
      LET t_bal  = sr.qcye      #期初余額                                       
      LET t_balf = sr.qcyef                                                     
      LET y_df   = sr.df_y                                                      
      LET y_d    = sr.d_y                                                       
      LET y_cf   = sr.cf_y                                                      
      LET y_c    = sr.c_y

   BEFORE GROUP OF sr.mm
      IF sr.mm = MONTH(tm.bdate) THEN
         LET l_date2 = tm.bdate
      ELSE
         LET l_date2 = MDY(sr.mm,1,yy)
      END IF

      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file     
       WHERE azi01 = sr.npq24

      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
   
      #type = '1' 期初結余打印
      CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
      LET l_npq25_bal = n_bal / n_balf   
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      INSERT INTO gapq920_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'1',l_date2,
             '','','',g_msg,'',sr.npq24,'',0,0,0,0,0,0,0,0,l_dc,n_balf,l_npq25_bal,n_bal,
             g_pageno,t_azi04,t_azi05,t_azi07)

   ON EVERY ROW
      IF sr.npq07 <> 0 OR sr.npq07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file    
          WHERE azi01 = sr.npq24
         IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF
         IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF
         IF sr.npq06 = 1 THEN
            LET t_bal   = t_bal   + sr.npq07
            LET t_balf  = t_balf  + sr.npq07f
         ELSE
            LET t_bal   = t_bal   - sr.npq07
            LET t_balf  = t_balf  - sr.npq07f
         END IF

         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         IF sr.npq06 = '1' THEN
            LET l_d  = sr.npq07
            LET l_df = sr.npq07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.npq07
            LET l_cf = sr.npq07f
         END IF

         #type = '2' 期間異動
         LET l_npq25_d = l_d / l_df
         LET l_npq25_c = l_c / l_cf
         LET l_npq25_bal = n_bal / n_balf

         IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
         IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
         IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
         INSERT INTO gapq920_tmp
         VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'2',
                sr.npp02,sr.npp01,sr.npp00,sr.nppsys,sr.nppglno,sr.npq04,
                sr.npq24,sr.npq06,sr.npq07,sr.npq07f,
                l_df,l_npq25_d,l_d,l_cf,l_npq25_c,l_c,
                l_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF

   AFTER GROUP OF sr.mm
      CALL s_yp(tm.edate) RETURNING l_year,l_month
      IF sr.mm = l_month THEN
         LET sr.npp02 = tm.edate
      ELSE
         CALL s_azn01(yy,sr.mm) RETURNING l_date,l_date1
         LET sr.npp02 = l_date1
      END IF
      
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file     
       WHERE azi01 = sr.npq24

      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
   
      #type = '3' 期末結余打印
      LET l_d = GROUP SUM(sr.npq07)  WHERE sr.npq06 = '1' AND sr.npq07 IS NOT NULL
      LET l_df= GROUP SUM(sr.npq07f) WHERE sr.npq06 = '1' AND sr.npq07 IS NOT NULL
      LET l_c = GROUP SUM(sr.npq07)  WHERE sr.npq06 = '2' AND sr.npq07 IS NOT NULL
      LET l_cf= GROUP SUM(sr.npq07f) WHERE sr.npq06 = '2' AND sr.npq07 IS NOT NULL
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      LET l_d  = l_d  + sr.d_p
      LET l_df = l_df + sr.df_p
      LET l_c  = l_c  + sr.c_p
      LET l_cf = l_cf + sr.cf_p
      CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg

      #本期合計
      LET l_npq25_d = l_d / l_df
      LET l_npq25_c = l_c / l_cf
      LET l_npq25_bal = n_bal / n_balf

      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d)   THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c)   THEN LET l_npq25_c = 0 END IF
      INSERT INTO gapq920_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'3',
             sr.npp02,'','','',g_msg,'','',
             '',0,0,l_df,l_npq25_d,l_d,l_cf, l_npq25_c,l_c,
             l_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)

      #type = '4' 期末后的本年結余打印
      LET y_df   = y_df + l_df                                                  
      LET y_d    = y_d  + l_d                                                    
      LET y_cf   = y_cf + l_cf                                                  
      LET y_c    = y_c  + l_c 
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_df) THEN LET y_df = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
      IF cl_null(y_cf) THEN LET y_cf = 0 END IF
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg

      LET l_npq25_d = y_d / y_df 
      LET l_npq25_c = y_c / y_cf
      LET l_npq25_bal = n_bal / n_balf

      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO gapq920_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'4',
              sr.npp02,'','','',g_msg,'','',
             '',0,0,y_df,l_npq25_d,y_d,y_cf, l_npq25_c,y_c,
             l_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)

END REPORT

REPORT gapq920_rep1(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         
          sr        RECORD
                    npp01    LIKE npp_file.npp01,
                    npp00    LIKE npp_file.npp00,
                    nppsys   LIKE npp_file.nppsys,
                    npp02    LIKE npp_file.npp02,
                    nppglno  LIKE npp_file.nppglno,
                    npq04    LIKE npq_file.npq04,
                    npq03    LIKE npq_file.npq03,
                    aag02    LIKE aag_file.aag02,
                    mm       LIKE type_file.num5,
                    npq06    LIKE npq_file.npq06,
                    npq07f   LIKE npq_file.npq07f,
                    npq07    LIKE npq_file.npq07,
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE occ_file.occ18,
                    npq24    LIKE npq_file.npq24,
                    apa09    LIKE apa_file.apa09,
                    apa08    LIKE apa_file.apa08,
                    qcyef    LIKE npq_file.npq07,  #qcye
                    qcye     LIKE npq_file.npq07,
                    df_p     LIKE npq_file.npq07,  #debit of current period(day1 ~ bdate-1)
                    d_p      LIKE npq_file.npq07,
                    cf_p     LIKE npq_file.npq07,
                    c_p      LIKE npq_file.npq07,
                    df_y     LIKE npq_file.npq07,  #debit of current year(1~bdate-1)
                    d_y      LIKE npq_file.npq07,
                    cf_y     LIKE npq_file.npq07,
                    c_y      LIKE npq_file.npq07
                    END RECORD,
          t_bal,t_balf                 LIKE npq_file.npq07,
          y_debit,y_debitf             LIKE npq_file.npq07,
          y_credit,y_creditf           LIKE npq_file.npq07,
          p_debit,p_debitf             LIKE npq_file.npq07,
          p_credit,p_creditf           LIKE npq_file.npq07,
          l_d,l_df,l_c,l_cf            LIKE npq_file.npq07,
          y_d,y_df,y_c,y_cf            LIKE npq_file.npq07,
	  n_bal,n_balf                 LIKE type_file.num20_6, 
          l_npq25_c,l_npq25_d,l_npq25_bal LIKE npq_file.npq25,
          l_date                       LIKE type_file.dat,     
          l_date1                      LIKE type_file.dat,     
          l_date2                      LIKE type_file.dat,     
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10

  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npq21,sr.npq22,sr.npq03,sr.npq24,sr.mm,sr.npp02,sr.npp01,sr.npq06
  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1

   BEFORE GROUP OF sr.npq21
 
   BEFORE GROUP OF sr.npq22
   
   BEFORE GROUP OF sr.npq03

   BEFORE GROUP OF sr.npq24     
      LET t_bal  = sr.qcye      #期初余額                                       
      LET t_balf = sr.qcyef                                                     
      LET y_df   = sr.df_y                                                      
      LET y_d    = sr.d_y                                                       
      LET y_cf   = sr.cf_y                                                      
      LET y_c    = sr.c_y
      PRINT

   BEFORE GROUP OF sr.mm
      IF sr.mm = MONTH(tm.bdate) THEN
         LET l_date2 = tm.bdate
      ELSE
         LET l_date2 = MDY(sr.mm,1,yy)
      END IF

      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file     
       WHERE azi01 = sr.npq24

      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
   
      #type = '1' 期初結余打印
      CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
      LET l_npq25_bal = n_bal / n_balf  
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      INSERT INTO gapq920_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'1',l_date2,
             '','','',g_msg,'',sr.npq24,'',0,0,0,0,0,0,0,0,l_dc,n_balf,l_npq25_bal,n_bal,
             g_pageno,t_azi04,t_azi05,t_azi07)

   ON EVERY ROW
      IF sr.npq07 <> 0 OR sr.npq07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file    
          WHERE azi01 = sr.npq24
         IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF
         IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF
         IF sr.npq06 = 1 THEN
            LET t_bal   = t_bal   + sr.npq07
            LET t_balf  = t_balf  + sr.npq07f
         ELSE
            LET t_bal    = t_bal    - sr.npq07
            LET t_balf   = t_balf   - sr.npq07f
         END IF

         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
         IF sr.npq06 = '1' THEN
            LET l_d  = sr.npq07
            LET l_df = sr.npq07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.npq07
            LET l_cf = sr.npq07f
         END IF

         #type = '1' 期初結余打印
          LET l_npq25_d = l_d / l_df
          LET l_npq25_c = l_c / l_cf
          LET l_npq25_bal = n_bal / n_balf
         IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
         IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
         IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
         INSERT INTO gapq920_tmp
         VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'2',
                sr.npp02,sr.npp01,sr.npp00,sr.nppsys,sr.nppglno,sr.npq04,
                sr.npq24,sr.npq06,sr.npq07,sr.npq07f,
                l_df,l_npq25_d,l_d,l_cf,l_npq25_c,l_c,
                l_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)
         PRINT
      END IF

   AFTER GROUP OF sr.mm
      CALL s_yp(tm.edate) RETURNING l_year,l_month
      IF sr.mm = l_month THEN
         LET sr.npp02 = tm.edate
      ELSE
         CALL s_azn01(yy,sr.mm) RETURNING l_date,l_date1
         LET sr.npp02 = l_date1
      END IF
      
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file     
       WHERE azi01 = sr.npq24

      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
   
      #type = '3' 期末結余打印
      LET l_d = GROUP SUM(sr.npq07)  WHERE sr.npq06 = '1' AND sr.npq07 IS NOT NULL
      LET l_df= GROUP SUM(sr.npq07f) WHERE sr.npq06 = '1' AND sr.npq07 IS NOT NULL
      LET l_c = GROUP SUM(sr.npq07)  WHERE sr.npq06 = '2' AND sr.npq07 IS NOT NULL
      LET l_cf= GROUP SUM(sr.npq07f) WHERE sr.npq06 = '2' AND sr.npq07 IS NOT NULL
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      LET l_d  = l_d  + sr.d_p
      LET l_df = l_df + sr.df_p
      LET l_c  = l_c  + sr.c_p
      LET l_cf = l_cf + sr.cf_p
      CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg

      LET l_npq25_d = l_d / l_df
      LET l_npq25_c = l_c / l_cf
      LET l_npq25_bal = n_bal / n_balf
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO gapq920_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'3',
             sr.npp02,'','','',g_msg,'',sr.npq24,
             '',0,0,l_df,l_npq25_d,l_d,l_cf, l_npq25_c,l_c,
             l_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)        
             

      #type = '4' 期末后的本年結余打印
      LET y_df   = y_df + l_df                                                  
      LET y_d    = y_d + l_d                                                    
      LET y_cf   = y_cf + l_cf                                                  
      LET y_c    = y_c + l_c 
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_df) THEN LET y_df = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
      IF cl_null(y_cf) THEN LET y_cf = 0 END IF
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
      LET l_npq25_d = y_d / y_df 
      LET l_npq25_c = y_c / y_cf
      LET l_npq25_bal = n_bal / n_balf
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO gapq920_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'4',
              sr.npp02,'','','',g_msg,'',sr.npq24,
             '',0,0,y_df,l_npq25_d,y_d,y_cf, l_npq25_c,y_c,
             l_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)

END REPORT


FUNCTION q920_apa(p_i,p_apa01)
  DEFINE  l_apa09   LIKE apa_file.apa09,
          l_apa08   LIKE apa_file.apa08,
          l_apa41   LIKE apa_file.apa41,
          l_apf41   LIKE apf_file.apf41,
          p_apa01   LIKE apa_file.apa01,
          p_i       LIKE type_file.num5,     
          l_oox00   LIKE oox_file.oox00,     
          l_oox01   LIKE oox_file.oox01,     
          l_oox02   LIKE type_file.num5,     
          l_i       LIKE type_file.num5,     
          l_flag    LIKE type_file.chr1      
  DEFINE  l_nppsys  LIKE npp_file.nppsys     

   LET l_flag = 'Y'   #it is valid
  
   LET l_apa09 = NULL
   LET l_apa08 = NULL
   LET l_nppsys= NULL
   SELECT nppsys INTO l_nppsys FROM npp_file WHERE npp01=p_apa01
   IF l_nppsys='AR' THEN 
      SELECT oma09,oma10,omaconf INTO l_apa09,l_apa08,l_apa41
        FROM oma_file
       WHERE oma01 = p_apa01
      IF SQLCA.sqlcode THEN
         SELECT ooaconf INTO l_apf41 FROM ooa_file
          WHERE ooa01 = p_apa01
         IF SQLCA.sqlcode THEN
            LET l_oox00 = p_apa01[1,2]
            LET l_oox01 = p_apa01[3,6] USING "&&&&"
            LET l_oox02 = p_apa01[7,8] USING "&&"
            SELECT COUNT(*) INTO l_i FROM oox_file
             WHERE oox00 = l_oox00
               AND oox01 = l_oox01
               AND oox02 = l_oox02
            IF l_i = 0 OR tm.d = '2' THEN
               LET l_flag = 'N'
            END IF
         ELSE
            IF p_i = 0 THEN           #before period
               IF l_apf41 <> 'Y' THEN
                  LET l_flag = 'N'
               END IF
            ELSE                      #middle period
               IF tm.d <> '3' THEN
                  IF l_apf41 <> g_d THEN
                     LET l_flag = 'N' #it is unvalid
                  END IF
               END IF
            END IF
         END IF
      ELSE
         IF p_i = 0 THEN
            IF l_apa41 <> 'Y' THEN
               LET l_flag = 'N'
            END IF
          ELSE
            IF tm.d <> '3' THEN
               IF l_apa41 <> g_d THEN
                  LET l_flag = 'N'
               END IF
            END IF
         END IF
      END IF
      RETURN l_flag,l_apa09,l_apa08
   END IF 
  
   SELECT apa09,apa08,apa41 INTO l_apa09,l_apa08,l_apa41
     FROM apa_file
    WHERE apa01 = p_apa01
      AND apaacti = 'Y'
   IF SQLCA.sqlcode THEN
      SELECT apf41 INTO l_apf41 FROM apf_file
       WHERE apf01 = p_apa01
         AND apfacti = 'Y'
      IF SQLCA.sqlcode THEN
         LET l_oox00 = p_apa01[1,2]
         LET l_oox01 = p_apa01[3,6] USING "&&&&"
         LET l_oox02 = p_apa01[7,8] USING "&&"
         SELECT COUNT(*) INTO l_i FROM oox_file
          WHERE oox00 = l_oox00
            AND oox01 = l_oox01
            AND oox02 = l_oox02
         IF l_i = 0 OR tm.d = '2' THEN
            LET l_flag = 'N'
         END IF
      ELSE
         IF p_i = 0 THEN           #before period
            IF l_apf41 <> 'Y' THEN
               LET l_flag = 'N'
            END IF
         ELSE                      #middle period
            IF tm.d <> '3' THEN
               IF l_apf41 <> g_d THEN
                  LET l_flag = 'N' #it is unvalid
               END IF
            END IF
         END IF
      END IF
   ELSE
      IF p_i = 0 THEN
         IF l_apa41 <> 'Y' THEN
            LET l_flag = 'N'
         END IF
       ELSE
         IF tm.d <> '3' THEN
            IF l_apa41 <> g_d THEN
               LET l_flag = 'N'
            END IF
         END IF
      END IF
   END IF
   RETURN l_flag,l_apa09,l_apa08
END FUNCTION
#Patch....NO:TQC-610037 <001> #


FUNCTION q920_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION query_account
         LET g_action_choice="query_account"
         EXIT DISPLAY

      ON ACTION first
         CALL gapq920_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL gapq920_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  

      ON ACTION jump
         CALL gapq920_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL gapq920_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  

      ON ACTION last
         CALL gapq920_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



FUNCTION gapq920_cs()
   
   IF tm.c = 'Y' THEN     
     LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm,npq24 FROM gapq920_tmp ",
                 " ORDER BY npq21,npq22,npq03,npq24,mm"
   ELSE
   
     LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm FROM gapq920_tmp ",
                 " ORDER BY npq21,npq22,npq03,mm"   
   END IF	                                               
   
     PREPARE gapq920_ps FROM g_sql
     DECLARE gapq920_curs SCROLL CURSOR WITH HOLD FOR gapq920_ps
     
   
   IF tm.c = 'Y' THEN     
     LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm,npq24 FROM gapq920_tmp ",
                 "  INTO TEMP x "
   ELSE
   
     LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm FROM gapq920_tmp ",
                 "  INTO TEMP x " 
   END IF	                                               

     DROP TABLE x
     PREPARE gapq920_ps1 FROM g_sql
     EXECUTE gapq920_ps1

     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gapq920_ps2 FROM g_sql
     DECLARE gapq920_cnt CURSOR FOR gapq920_ps2

     OPEN gapq920_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gapq920_curs',SQLCA.sqlcode,0)
        EXIT PROGRAM
     ELSE
        OPEN gapq920_cnt 
        FETCH gapq920_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gapq920_fetch('F')
     END IF
END FUNCTION

FUNCTION gapq920_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        
   l_abso          LIKE type_file.num10                 #絕對的筆數      

   
   IF tm.c = 'Y' THEN
   CASE p_flag
      WHEN 'N' FETCH NEXT     gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24  
      WHEN 'P' FETCH PREVIOUS gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24  
      WHEN 'F' FETCH FIRST    gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24  
      WHEN 'L' FETCH LAST     gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24  
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         
                   CALL cl_about()      
 
                ON ACTION help          
                   CALL cl_show_help()  
 
                ON ACTION controlg      
                   CALL cl_cmdask()     
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24  
         LET mi_no_ask = FALSE
   END CASE
   ELSE
   
   CASE p_flag
      WHEN 'N' FETCH NEXT     gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN 'P' FETCH PREVIOUS gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN 'F' FETCH FIRST    gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN 'L' FETCH LAST     gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         
                   CALL cl_about()      
 
                ON ACTION help          
                   CALL cl_show_help()  
 
                ON ACTION controlg      
                   CALL cl_cmdask()     
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump gapq920_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
         LET mi_no_ask = FALSE
   END CASE   
   END IF	                                               
      
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npq21,SQLCA.sqlcode,0)
      INITIALIZE g_npq21 TO NULL
      INITIALIZE g_npq22 TO NULL
      INITIALIZE g_npq03 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_mm    TO NULL
      INITIALIZE g_npq24 TO NULL                  
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump #CKP3
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

   CALL gapq920_show()
END FUNCTION

FUNCTION gapq920_show()
 
   DISPLAY g_npq21 TO npq21
   DISPLAY g_npq22 TO npq22
   DISPLAY g_npq03 TO npq03
   DISPLAY g_aag02 TO aag02
   DISPLAY g_npq24 TO npq24c                           
   DISPLAY yy   TO yy
   DISPLAY g_mm TO mm

   CALL gapq920_b_fill()

   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION gapq920_b_fill()                     #BODY FILL UP
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1

   
   IF tm.c = 'Y' THEN
   LET g_sql = "SELECT npp02,npp01,npp00,nppsys,nppglno,npq04,npq24,df,npq25_d,d,",
               "       cf,npq25_c,c,dc,balf,npq25_bal,bal,",
               "       azi04,azi05,azi07,npq06,type ",
               " FROM gapq920_tmp",
               " WHERE npq21 ='",g_npq21,"'",
               "   AND npq22 ='",g_npq22,"'",
               "   AND npq03 ='",g_npq03,"'",
               "   AND npq24 ='",g_npq24,"'",
               "   AND mm    = ",g_mm,
               " ORDER BY type,npp02,npp01,npq06 "
   ELSE
   
   LET g_sql = "SELECT npp02,npp01,npp00,nppsys,nppglno,npq04,npq24,df,npq25_d,d,",
               "       cf,npq25_c,c,dc,balf,npq25_bal,bal,",
               "       azi04,azi05,azi07,npq06,type ",
               " FROM gapq920_tmp",
               " WHERE npq21 ='",g_npq21,"'",
               "   AND npq22 ='",g_npq22,"'",
               "   AND npq03 ='",g_npq03,"'",               
               "   AND mm    = ",g_mm,
               " ORDER BY type,npp02,npp01,npq06 "   
   END IF	                                               

   PREPARE gapq920_pb FROM g_sql
   DECLARE npq_curs  CURSOR FOR gapq920_pb        #CURSOR

   CALL g_npq.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH npq_curs INTO g_npq[g_cnt].*,t_azi04,t_azi05,t_azi07,l_npq06,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_npq[g_cnt].d   = cl_numfor(g_npq[g_cnt].d,20,g_azi04)
      LET g_npq[g_cnt].c   = cl_numfor(g_npq[g_cnt].c,20,g_azi04)
      LET g_npq[g_cnt].bal = cl_numfor(g_npq[g_cnt].bal,20,g_azi04)
      LET g_npq[g_cnt].df  = cl_numfor(g_npq[g_cnt].df,20,t_azi04)
      LET g_npq[g_cnt].cf  = cl_numfor(g_npq[g_cnt].cf,20,t_azi04)
      LET g_npq[g_cnt].balf= cl_numfor(g_npq[g_cnt].balf,20,t_azi04)
      LET g_npq[g_cnt].npq25_d= cl_numfor(g_npq[g_cnt].npq25_d,20,t_azi07)
      LET g_npq[g_cnt].npq25_c= cl_numfor(g_npq[g_cnt].npq25_c,20,t_azi07)
      LET g_npq[g_cnt].npq25_bal= cl_numfor(g_npq[g_cnt].npq25_bal,20,t_azi07)
      #外幣時,外幣匯總沒有意義
      
      IF tm.c = 'Y' THEN
      IF l_type = '1' THEN
         LET g_npq[g_cnt].d = NULL
         LET g_npq[g_cnt].df= NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].c = NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF
      ELSE
      
      IF l_type = '1' THEN
         LET g_npq[g_cnt].d = NULL
         LET g_npq[g_cnt].df= NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].c = NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].balf= NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npq[g_cnt].df = NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].balf = NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF
      IF l_type = '2' THEN
         LET g_npq[g_cnt].balf= NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF     	
      END IF	                                                 
      IF l_npq06 = '1' THEN
         LET g_npq[g_cnt].c = NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
      END IF
      IF l_npq06 = '2' THEN
         LET g_npq[g_cnt].d = NULL
         LET g_npq[g_cnt].df= NULL
         LET g_npq[g_cnt].npq25_d= NULL
      END IF 

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH

   CALL g_npq.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION gapq920_table()
     DROP TABLE gapq920_tmp;
     CREATE TEMP TABLE gapq920_tmp(
                    npq21       LIKE npq_file.npq21,
                    npq22       LIKE npq_file.npq22,
                    npq03       LIKE npq_file.npq03,
                    aag02       LIKE aag_file.aag02,
                    mm          LIKE type_file.num5,
                    type        LIKE type_file.chr1,
                    npp02       LIKE npp_file.npp02,
                    npp01       LIKE npp_file.npp01,
                    npp00       LIKE npp_file.npp00,
                    nppsys      LIKE npp_file.nppsys,
                    nppglno     LIKE npp_file.nppglno,
                    npq04       LIKE npq_file.npq04,
                    npq24       LIKE npq_file.npq24,
                    npq06       LIKE npq_file.npq06,
                    npq07       LIKE npq_file.npq07,
                    npq07f      LIKE npq_file.npq07f,
                    df          LIKE npq_file.npq07,
                    npq25_d     LIKE npq_file.npq25,
                    d           LIKE npq_file.npq07,
                    cf          LIKE npq_file.npq07,
                    npq25_c     LIKE npq_file.npq25,
                    c           LIKE npq_file.npq07,
                    dc          LIKE type_file.chr10,
                    balf        LIKE npq_file.npq07,
                    npq25_bal   LIKE npq_file.npq25,
                    bal         LIKE npq_file.npq07,
                    pagenum     LIKE type_file.num5,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi04,
                    azi07       LIKE azi_file.azi07);
END FUNCTION

FUNCTION q920_out_1()
   LET g_prog = 'gapq910'
   LET g_sql = "npq21.npq_file.npq21,",
               "npq22.npq_file.npq22,",
               "npq03.npq_file.npq03,",
               "aag02.aag_file.aag02,",
               "mm.type_file.num5,",
               "type.type_file.chr1,",
               "npp02.npp_file.npp02,",
               "npp01.npp_file.npp01,",
               "nppglno.npp_file.nppglno,",
               "npq04.npq_file.npq04,",
               "npq24.npq_file.npq24,",
               "npq06.npq_file.npq06,",
               "npq07.npq_file.npq07,",
               "npq07f.npq_file.npq07f,",
               "df.npq_file.npq07,",
               "npq25_d.npq_file.npq25,",
               "d.npq_file.npq07,",
               "cf.npq_file.npq07,",
               "npq25_c.npq_file.npq25,",
               "c.npq_file.npq07,",
               "dc.type_file.chr10,",
               "balf.npq_file.npq07,",
               "npq25_bal.npq_file.npq25,",
               "bal.npq_file.npq07,",
               "pagenum.type_file.num5,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07 "

   LET l_table = cl_prt_temptable('gapq910',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?)       "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET g_prog = 'gapq920'
END FUNCTION

FUNCTION q920_out_2()
   DEFINE l_name             LIKE type_file.chr20  
 
   CALL cl_del_data(l_table)                       

   DECLARE cr_curs CURSOR FOR 
    SELECT npq21, npq22, npq03, aag02, mm, type, npp02,
           npp01, nppglno, npq04, npq24, npq06, npq07, npq07f,
           df, npq25_d, d, cf, npq25_c, c, dc, balf,
           npq25_bal, bal, pagenum, azi04, azi05, azi07
     FROM gapq920_tmp
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

   IF g_zz05='Y' THEN 
      CALL cl_wcchp(tm.wc,'npq21,npp01,npq03')
           RETURNING g_str 
   END IF
   LET g_str=g_str CLIPPED,";",yy,";",g_azi04
   
   
#  IF tm.b = 'N' THEN 
#     CALL cl_prt_cs3('gapq920','gapq920',g_sql,g_str)
#  ELSE
#     CALL cl_prt_cs3('gapq920','gapq920_1',g_sql,g_str)
#  END IF
   
   
   LET g_prog = 'gapq910'
   
   IF tm.b = 'N' THEN
       LET l_name = 'gapq910'
   ELSE
       IF tm.c = 'Y' THEN           
          LET l_name = 'gapq910_2'  
       ELSE                               
          LET l_name = 'gapq910_1'
       END IF    
   END IF
   CALL cl_prt_cs3('gapq910',l_name,g_sql,g_str)   
   
   LET g_prog = 'gapq920'
   
END FUNCTION


FUNCTION gapq920_t()
   #npp00/nppsys 僅for串查
   CALL cl_set_comp_visible("npp00,nppsys",FALSE)
   IF tm.b = 'Y' THEN
      CALL cl_set_comp_visible("npq24,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("npq25_d,npq25_c,npq25_bal",TRUE)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-205",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-206",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("npq24,npq25,df,cf,balf",FALSE)
      CALL cl_set_comp_visible("npq25_d,npq25_c,npq25_bal",FALSE)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
   
   IF tm.c = 'Y' THEN
      CALL cl_set_comp_visible("npq24c",TRUE)                                                                                       
   ELSE
      CALL cl_set_comp_visible("npq24c",FALSE)
   END IF
   
   LET g_npq03 = NULL
   LET g_aag02 = NULL
   LET g_npq21 = NULL
   LET g_npq22 = NULL
   LET g_npq24 = NULL         
   CLEAR FORM
   CALL g_npq.clear()
   CALL gapq920_cs()
END FUNCTION

FUNCTION q920_q_a()
   DEFINE l_wc      LIKE type_file.chr1000
   DEFINE l_bdate   LIKE type_file.dat
   DEFINE l_edate   LIKE type_file.dat
   DEFINE l_t1      LIKE type_file.chr10
   DEFINE l_apykind LIKE apy_file.apykind
   DEFINE l_prog    LIKE zz_file.zz01

   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_npq[l_ac].npp01) THEN RETURN END IF
   LET g_msg = NULL
   CALL s_get_doc_no(g_npq[l_ac].npp01) RETURNING l_t1
   SELECT apykind INTO l_apykind FROM apy_file
    WHERE apyslip = l_t1
   IF g_npq[l_ac].nppsys = 'AP' AND g_npq[l_ac].npp00 MATCHES '[12]' THEN
      CASE l_apykind
           WHEN '11' LET l_prog = 'aapt110'
           WHEN '12' LET l_prog = 'aapt120'
           WHEN '13' LET l_prog = 'aapt121'
           WHEN '15' LET l_prog = 'aapt150'
           WHEN '16' LET l_prog = 'aapt160'
           WHEN '17' LET l_prog = 'aapt151'
           WHEN '21' LET l_prog = 'aapt210'
           WHEN '22' LET l_prog = 'aapt220'
           WHEN '26' LET l_prog = 'aapt260'
      END CASE
      LET g_msg = l_prog," '",g_npq[l_ac].npp01,"' 'query'"
   END IF
   IF g_npq[l_ac].nppsys = 'AP' AND g_npq[l_ac].npp00 = '3' THEN
      CASE l_apykind
           WHEN '33' LET l_prog = 'aapt330'
           WHEN '34' LET l_prog = 'aapt331'
      END CASE
      LET g_msg = l_prog," '",g_npq[l_ac].npp01,"' 'query'"
   END IF
   IF g_npq[l_ac].nppsys = 'AP' AND g_npq[l_ac].npp00 = '4' THEN
      LET g_msg = "aapt900 '",g_npq[l_ac].npp01,"' 'query'"
   END IF
   IF g_npq[l_ac].nppsys = 'AP' AND g_npq[l_ac].npp00 = '5' THEN
      LET l_wc = 'oox00 = "AP" AND oox01 = ',yy,' AND oox02 = ',g_mm,' AND oox03 = "',g_npq[l_ac].npp01,'"'
      LET g_msg = "gapq600 '",l_wc CLIPPED,"'"
   END IF
   IF g_npq[l_ac].nppsys = 'AR' AND g_npq[l_ac].npp00 MATCHES '[12]' THEN
      LET g_msg = "axrt300 '",g_npq[l_ac].npp01,"'"
   END IF
   IF g_npq[l_ac].nppsys = 'AR' AND g_npq[l_ac].npp00 = '3' THEN
      LET g_msg = "axrt400 '",g_npq[l_ac].npp01,"' 'query'"
   END IF
   IF g_npq[l_ac].nppsys = 'AR' AND g_npq[l_ac].npp00 = '4' THEN
      LET l_wc = 'oox00 = "AR" AND oox01 = ',yy,' AND oox02 = ',g_mm,' AND oox03 = "',g_npq[l_ac].npp01,'"'
      LET g_msg = "gxrq600 '",l_wc CLIPPED,"'"
   END IF

   IF NOT cl_null(g_msg) THEN
      CALL cl_cmdrun(g_msg)
   END IF

END FUNCTION

