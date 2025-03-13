# Prog. Version..: '5.30.09-13.09.06(00001)'     #
#
# Pattern name...: gglr702.4gl
# Descriptions...: 核算項明細帳
# Input parameter:
# Return code....:
# Date & Author..: 08/06/11 By Carrier  #No.FUN-D80121
 
DATABASE ds
 
GLOBALS "../../config/top.global"  #No.FUN-850030
 
   DEFINE tm      RECORD
                  wc1      STRING,
                  wc2      STRING,
                  a        LIKE type_file.chr2,
                  b        LIKE type_file.chr2,
                  e        LIKE azi_file.azi01, 
                  f        LIKE type_file.chr2, 
                  m        LIKE type_file.chr2, 
                  i        LIKE type_file.chr1, 
                  t        LIKE type_file.chr1,
                  more     LIKE type_file.chr1
                  END RECORD,
          yy,mm            LIKE type_file.num10,
          mm1,nn1          LIKE type_file.num10,
          bdate,edate      LIKE type_file.dat,
          l_flag           LIKE type_file.chr1,
          bookno           LIKE aaa_file.aaa01,
          g_cnnt           LIKE type_file.num5
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING
 
DEFINE   g_field    LIKE gaq_file.gaq01
DEFINE   g_gaq01    LIKE gaq_file.gaq01
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_aag01    LIKE ted_file.ted01
DEFINE   g_aag02    LIKE aag_file.aag02
DEFINE   g_ted02    LIKE ted_file.ted02
DEFINE   g_ted02_d  LIKE ze_file.ze03
DEFINE   g_ted09    LIKE ted_file.ted09 
DEFINE   g_aba04    LIKE aba_file.aba04
DEFINE   g_abb      DYNAMIC ARRAY OF RECORD
                    aag01      LIKE aag_file.aag01,    #FUN-C80102  add
                    aag02      LIKE aag_file.aag02,    #FUN-C80102  add
                    ted02      LIKE ted_file.ted02,    #FUN-C80102  add
                    ted02_d    LIKE ze_file.ze03,      #FUN-C80102  add
                    aba02      LIKE aba_file.aba02,
                    aba01      LIKE aba_file.aba01,
                    abb04      LIKE abb_file.abb04,
                    abb24      LIKE abb_file.abb24,
                    df         LIKE abb_file.abb07,
                    abb25_d    LIKE abb_file.abb25,
                    d          LIKE abb_file.abb07,
                    cf         LIKE abb_file.abb07,
                    abb25_c    LIKE abb_file.abb25,
                    c          LIKE abb_file.abb07,
                    dc         LIKE type_file.chr10,
                    balf       LIKE abb_file.abb07,
                    abb25_bal  LIKE abb_file.abb25,
                    bal        LIKE abb_file.abb07
                    END RECORD
DEFINE   g_pr       RECORD
                    aag01      LIKE aag_file.aag01,
                    aag02      LIKE type_file.chr1000,
                    ted02      LIKE ted_file.ted02,
                    ted02_d    LIKE ze_file.ze03,
                    aba04      LIKE aba_file.aba04,
                    type       LIKE type_file.chr1,
                    aba02      LIKE aba_file.aba02,
                    aba01      LIKE aba_file.aba01,
                    abb04      LIKE abb_file.abb04,
                    abb24      LIKE abb_file.abb24,
                    abb06      LIKE abb_file.abb06,
                    abb07      LIKE abb_file.abb07,
                    abb07f     LIKE abb_file.abb07f,
                    d          LIKE abb_file.abb07,
                    df         LIKE abb_file.abb07,
                    abb25_d    LIKE abb_file.abb25,
                    c          LIKE abb_file.abb07,
                    cf         LIKE abb_file.abb07,
                    abb25_c    LIKE abb_file.abb25,
                    dc         LIKE type_file.chr10,
                    bal        LIKE abb_file.abb07,
                    balf       LIKE abb_file.abb07,
                    abb25_bal  LIKE abb_file.abb25,
                    pagenum    LIKE type_file.num5,
                    azi04      LIKE azi_file.azi04,
                    azi05      LIKE azi_file.azi05,
                    azi07      LIKE azi_file.azi07
                    END RECORD
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   l_ac           LIKE type_file.num5
DEFINE   g_aee02        LIKE aee_file.aee02   
DEFINE   g_comb         ui.ComboBox           
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET bookno     = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc1     = ARG_VAL(8)
   LET tm.wc1    = cl_replace_str(tm.wc1, "\\\"", "'")  
   LET tm.wc2     = ARG_VAL(9)
   LET tm.wc2    = cl_replace_str(tm.wc2, "\\\"", "'")  
   LET bdate      = ARG_VAL(10)
   LET edate      = ARG_VAL(11)
   LET tm.a       = ARG_VAL(12)
   LET tm.b       = ARG_VAL(13)
   LET tm.f       = ARG_VAL(14)     
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)
   LET tm.e       = ARG_VAL(19)    
   LET tm.m       = ARG_VAL(20)    
   LET tm.i       = ARG_VAL(21)    
   LET tm.t       = ARG_VAL(22)
 
   CALL r702_out_1()
   IF bookno IS NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
 
   OPEN WINDOW r702_w AT 5,10
        WITH FORM "ggl/42f/gglr702" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL gglr702_tm()
   ELSE   
      CALL gglr702()
   END IF
 
   DROP TABLE gglr702_tmp;
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION gglr702_tm()
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01  
   DEFINE p_row,p_col     LIKE type_file.num5,
          l_i             LIKE type_file.num5,
          l_cmd           LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5    

   CLEAR FORM #清除畫面   
   CALL g_abb.clear()   
 
   CALL s_dsmark(bookno)

   CALL cl_set_comp_entry('e',FALSE) 

   CALL s_shwact(0,0,bookno)
   CALL cl_opmsg('p')
   CALL r702_getday()   
   INITIALIZE tm.* TO NULL   
   LET tm.a    = '1'
   LET tm.b    = 'N'
   LET tm.e    = ''  
   LET tm.f    = '1' 
   LET tm.m    = 'N' 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.i ='N'   
   LET tm.t ='N'  
   WHILE TRUE    
     DIALOG ATTRIBUTES(UNBUFFERED)
     INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)   
        
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

        AFTER FIELD bookno
            IF cl_null(bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF
             
     END INPUT    
     CONSTRUCT BY NAME tm.wc1 ON aag01
     END CONSTRUCT

     INPUT BY NAME tm.a ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

        AFTER FIELD a
           IF tm.a NOT MATCHES "[123456789]" AND tm.a <> "10"
              AND tm.a <> "99" THEN 
              NEXT FIELD a
           END IF

     END INPUT
     
     CONSTRUCT BY NAME tm.wc2 ON ted02
     END CONSTRUCT
     
     INPUT BY NAME bdate,edate,tm.f,tm.t,tm.b,tm.e,tm.i,tm.m,tm.more ATTRIBUTE(WITHOUT DEFAULTS=TRUE)  
        
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        AFTER FIELD bdate
           IF cl_null(bdate) THEN
              NEXT FIELD bdate
           END IF
 
        AFTER FIELD edate
           IF cl_null(edate) THEN
              LET edate =g_lastdat
           ELSE
              IF s_get_aznn(g_plant,bookno,bdate,1) <> s_get_aznn(g_plant,bookno,edate,1) THEN   
                 CALL cl_err('','gxr-001',0)
                 NEXT FIELD bdate
              END IF
           END IF
           IF edate < bdate THEN
              CALL cl_err(' ','agl-031',0)
              NEXT FIELD edate
           END IF
 
       ON CHANGE m
           IF tm.m NOT MATCHES "[YyNn]" THEN NEXT FIELD m END IF

        AFTER FIELD b
           IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
           IF tm.b='Y' THEN 
              CALL cl_set_comp_entry('e',TRUE)     
           ELSE
              CALL cl_set_comp_entry('e',FALSE)
              LET tm.e=''
              DISPLAY tm.e TO e
           END IF
             
        ON CHANGE b
           IF tm.b='Y' THEN 
              CALL cl_set_comp_entry('e',TRUE)
           ELSE      
           	  CALL cl_set_comp_entry('e',FALSE)
           	  LET tm.e=''
           	  DISPLAY tm.e TO e 
           END IF
             
        AFTER FIELD e
           IF NOT cl_null(tm.e) THEN 
              SELECT azi01 FROM azi_file WHERE azi01 = tm.e
              IF SQLCA.sqlcode THEN
                 CALL cl_err(tm.e,'agl-109',0)   
                 NEXT FIELD e
              END IF
           END IF

        ON CHANGE f
           IF tm.f NOT MATCHES "[YN]" THEN NEXT FIELD f END IF

        ON CHANGE i
           IF tm.i NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD i
           END IF

        AFTER FIELD t
           IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF

        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
                        g_bgjob,g_time,g_prtway,g_copies
           END IF
                  
     END INPUT 
     
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(bookno)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.default1 =bookno
              CALL cl_create_qry() RETURNING bookno
              DISPLAY BY NAME bookno
              NEXT FIELD bookno
           WHEN INFIELD(aag01)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = 'q_aag12_1'              
              LET g_qryparam.state= 'c'
              LET g_qryparam.where = " ted00 = '",bookno CLIPPED,"'"  
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aag01
              NEXT FIELD aag01  
           WHEN INFIELD(e)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 =tm.e
              CALL cl_create_qry() RETURNING tm.e
              DISPLAY BY NAME tm.e
              NEXT FIELD e
           WHEN INFIELD(ted02)                                                
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aee1'        
              LET g_qryparam.state= 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ted02
              NEXT FIELD ted02  
        END CASE

     ON ACTION locale
        CALL cl_show_fld_cont()
        LET g_action_choice = "locale"
        EXIT DIALOG
     ON ACTION CONTROLR
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

     ON ACTION accept
        EXIT DIALOG        
       
     ON ACTION cancel
        LET INT_FLAG=1
        EXIT DIALOG       
    END DIALOG  
     
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW gglr702_w1
        RETURN
     END IF          
     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3)
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
         WHERE zz01='gglr702'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglr702','9031',1)
        ELSE
           LET tm.wc1=cl_wcsub(tm.wc1)
           LET l_cmd = l_cmd CLIPPED,
                      " '",bookno CLIPPED,"'",
                      " '",g_pdate CLIPPED,"'",
                      " '",g_towhom CLIPPED,"'",
                      " '",g_rlang CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",g_prtway CLIPPED,"'",
                      " '",g_copies CLIPPED,"'",
                      " '",tm.wc1 CLIPPED,"'",
                      " '",tm.wc2 CLIPPED,"'",
                      " '",bdate CLIPPED,"'",
                      " '",edate CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",tm.b CLIPPED,"'",
                      " '",tm.f CLIPPED,"'",     
                      " '",tm.m CLIPPED,"'",     
                      " '",tm.i CLIPPED,"'",  
                      " '",tm.t CLIPPED,"'",     
                      " '",g_rep_user CLIPPED,"'",
                      " '",g_rep_clas CLIPPED,"'",
                      " '",g_template CLIPPED,"'",
                      " '",g_rpt_name CLIPPED,"'",
                      " '",tm.e       CLIPPED,"'"    
           CALL cl_cmdat('gglr702',g_time,l_cmd)
        END IF
        CLOSE WINDOW gglr702_w1   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL gglr702()
     ERROR ""
   END WHILE
   CLOSE WINDOW gglr702_w1   
 
END FUNCTION
 
FUNCTION r702_out_1()
 
   LET g_prog = 'gglr702'
   LET g_sql = " aag01.aag_file.aag01,",
               " aag02.aag_file.aag02,",
               " ted02.ted_file.ted02,",
               " ted02_d.ze_file.ze03,",
               " aba04.aba_file.aba04,",
               " type.type_file.chr1,",
               " aba02.aba_file.aba02,",
               " aba01.aba_file.aba01,",
               " abb04.abb_file.abb04,",
               " abb24.abb_file.abb24,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " d.abb_file.abb07,",
               " df.abb_file.abb07,",
               " abb25_d.abb_file.abb25,",
               " c.abb_file.abb07,",
               " cf.abb_file.abb07,",
               " abb25_c.abb_file.abb25,",
               " dc.type_file.chr10,",
               " bal.abb_file.abb07,",
               " balf.abb_file.abb07,",
               " abb25_bal.abb_file.abb25,",
               " pagenum.type_file.num5,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07 "
 
   LET l_table = cl_prt_temptable('gglr702',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?)          "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION r702_out_2()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_aag01            LIKE aag_file.aag01
   DEFINE l_ted02            LIKE ted_file.ted02
   DEFINE l_prog             LIKE gae_file.gae01 
 
   LET l_prog = g_prog
   LET g_prog = 'gglq702'
 
   CALL cl_del_data(l_table)
 
   LET l_aag01 = NULL
   LET l_ted02 = NULL
   DECLARE gglr702_tmp_curs CURSOR FOR
    SELECT * FROM gglr702_tmp
     ORDER BY aag01,ted02,aba04,aba02,aba01
   FOREACH gglr702_tmp_curs INTO g_pr.*
      #查詢和打印時不太一樣，打印時,僅打印一個期初余額
      IF l_aag01 <> g_pr.aag01 OR l_ted02 <> g_pr.ted02 THEN
         LET l_aag01 = NULL
         LET l_ted02 = NULL
      END IF
      IF g_pr.type = '1' THEN
         IF l_aag01 IS NULL AND l_ted02 IS NULL THEN
            LET l_aag01 = g_pr.aag01
            LET l_ted02 = g_pr.ted02
         ELSE
            CONTINUE FOREACH
         END IF
      END IF
      EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
 
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",g_azi04,";",tm.a
 
   IF tm.b = 'N' THEN
       LET l_name = 'gglq702'
   ELSE
      LET l_name = 'gglq702_1'
   END IF
   CALL cl_prt_cs3('gglq702',l_name,g_sql,g_str)
   LET g_prog = l_prog
 
END FUNCTION
 
FUNCTION gglr702_table()
     DROP TABLE gglr702_ted_tmp;
     CREATE TEMP TABLE gglr702_ted_tmp(
                    aag01       LIKE aag_file.aag01,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    ted02       LIKE ted_file.ted02,
                    ted02_d     LIKE ze_file.ze03,
                    ted09       LIKE ted_file.ted09); #TQC-930163
 
     DROP TABLE gglr702_tmp;
     CREATE TEMP TABLE gglr702_tmp(
                    aag01       LIKE aag_file.aag01,
                    aag02       LIKE type_file.chr1000,      #No.MOD-940388
                    ted02       LIKE ted_file.ted02,
                    ted02_d     LIKE ze_file.ze03,  
                    aba04       LIKE aba_file.aba04,
                    type        LIKE type_file.chr1,
                    aba02       LIKE aba_file.aba02,
                    aba01       LIKE aba_file.aba01,
                    abb04       LIKE abb_file.abb04,
                    abb24       LIKE abb_file.abb24,
                    abb06       LIKE abb_file.abb06,
                    abb07       LIKE abb_file.abb07,
                    abb07f      LIKE abb_file.abb07f,
                    d           LIKE abb_file.abb07,
                    df          LIKE abb_file.abb07,
                    abb25_d     LIKE abb_file.abb25,
                    c           LIKE abb_file.abb07,
                    cf          LIKE abb_file.abb07,
                    abb25_c     LIKE abb_file.abb25,
                    dc          LIKE type_file.chr10,
                    bal         LIKE abb_file.abb07,
                    balf        LIKE abb_file.abb07,
                    abb25_bal   LIKE abb_file.abb25,
                    pagenum     LIKE type_file.num5,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi05,
                    azi07       LIKE azi_file.azi07,  
                    odr         LIKE type_file.chr1);   #CHI-D60013 add odr
                   #azi07       LIKE azi_file.azi07);   #CHI-D60013 mark
END FUNCTION
 
FUNCTION gglr702_get_ahe02(p_aag01_str,p_ted02,p_gaq01) #TQC-930163
  DEFINE p_aag01_str     LIKE type_file.chr50
  DEFINE p_ted02         LIKE ted_file.ted02
  DEFINE p_gaq01         LIKE gaq_file.gaq01  #TQC-930163
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE #l_sql1          LIKE type_file.chr1000
         l_sql1          STRING      #NO.FUN-910082
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE l_ahe03         LIKE ahe_file.ahe03  #No.TQC-C50211
 
     #查找核算項值
     LET l_sql1 = " SELECT ",p_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",bookno,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",p_gaq01 CLIPPED," IS NOT NULL"
     PREPARE gglr702_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_gaq01_cs SCROLL CURSOR FOR gglr702_gaq01_p  #只能取第一個
     #取核算項名稱
     LET l_ahe01 = NULL
     OPEN gglr702_gaq01_cs USING p_aag01_str
     IF SQLCA.sqlcode THEN
        CLOSE gglr702_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST gglr702_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE gglr702_gaq01_cs
        RETURN NULL
     END IF
     CLOSE gglr702_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
#No.TQC-C50211 --begin
        LET l_ahe03 = ''
        LET l_ahe04 = ''
        LET l_ahe05 = ''
        LET l_ahe07 = ''
#No.TQC-C50211 --end
        SELECT ahe03,ahe04,ahe05,ahe07 INTO l_ahe03,l_ahe04,l_ahe05,l_ahe07  #No.TQC-C50211 add ahe03
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
          #NOT cl_null(l_ahe07) THEN                       #No.TQC-C50211 mark
           NOT cl_null(l_ahe07) AND l_ahe03 = '1' THEN     #No.TQC-C50211
           LET l_ahe02_d = ''                              #No.TQC-C50211
           LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                        "  FROM ",l_ahe04 CLIPPED,
                        " WHERE ",l_ahe05 CLIPPED," = '",p_ted02,"'"
           PREPARE ahe_p1 FROM l_sql1
           EXECUTE ahe_p1 INTO l_ahe02_d
        END IF
#No.TQC-C50211 --begin
        IF l_ahe03 = '2' THEN
           LET l_ahe02_d = ''
           SELECT aee04 INTO l_ahe02_d
             FROM aee_file
            WHERE aee00 = bookno
              AND aee01 = p_aag01_str
              AND aee02 = g_aee02
              AND aee03 = p_ted02
        END IF
#No.TQC-C50211 --end
     END IF
 
     RETURN l_ahe02_d
END FUNCTION
 
FUNCTION r702_drill_down()  
   DEFINE 
          l_wc         STRING       #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
 
   IF cl_null(g_aag01) THEN RETURN END IF
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_abb[l_ac].aba01) THEN RETURN END IF
   LET g_msg = "aglt110 '",g_abb[l_ac].aba01,"'"
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
FUNCTION gglr702_curs()
  DEFINE #l_sql   LIKE type_file.chr1000
         l_sql   STRING      #NO.FUN-910082
  DEFINE #l_sql1  LIKE type_file.chr1000
         l_sql1   STRING      #NO.FUN-910082
  DEFINE 
         l_wc2         STRING       #NO.FUN-910082

     LET mm1 = s_get_aznn(g_plant,g_aza.aza81,bdate,3)
     LET nn1 = s_get_aznn(g_plant,g_aza.aza81,edate,3)
     SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
     CASE tm.a
          WHEN '1'   LET g_field = 'abb11'
                     LET g_gaq01 = 'aag15'
                     LET g_aee02 ='1'        #No.TQC-C50211
          WHEN '2'   LET g_field = 'abb12'
                     LET g_gaq01 = 'aag16'
                     LET g_aee02 ='2'        #No.TQC-C50211
          WHEN '3'   LET g_field = 'abb13'
                     LET g_gaq01 = 'aag17'
                     LET g_aee02 ='3'        #No.TQC-C50211
          WHEN '4'   LET g_field = 'abb14'
                     LET g_gaq01 = 'aag18'
                     LET g_aee02 ='4'        #No.TQC-C50211
          WHEN '5'   LET g_field = 'abb31'
                     LET g_gaq01 = 'aag31'
                     LET g_aee02 ='5'        #No.TQC-C50211
          WHEN '6'   LET g_field = 'abb32'
                     LET g_gaq01 = 'aag32'
                     LET g_aee02 ='6'        #No.TQC-C50211
          WHEN '7'   LET g_field = 'abb33'
                     LET g_gaq01 = 'aag33'
                     LET g_aee02 ='7'        #No.TQC-C50211
          WHEN '8'   LET g_field = 'abb34'
                     LET g_gaq01 = 'aag34'
                     LET g_aee02 ='8'        #No.TQC-C50211
          WHEN '9'   LET g_field = 'abb35'
                     LET g_gaq01 = 'aag35'
                     LET g_aee02 ='9'        #No.TQC-C50211
          WHEN '10'  LET g_field = 'abb36'
                     LET g_gaq01 = 'aag36'
                     LET g_aee02 ='10'        #No.TQC-C50211
          WHEN '99'  LET g_field = 'abb37'  #No.FUN-9A0052
                     LET g_gaq01 = 'aag37'
                     LET g_aee02 ='99'        #No.TQC-C50211
     END CASE
     IF cl_null(g_field) THEN 
        LET g_field = 'abb11'
     END IF
     IF cl_null(g_gaq01) THEN
        LET g_gaq01 = 'aag15'
     END IF
 
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')  #No.TQC-A50151
 
     #查找科目
     LET l_sql1= "SELECT aag01,aag02 FROM aag_file ",
                 " WHERE aag03 ='2' ",
                 "   AND aag00 = '",bookno,"' ",
#                "   AND aag24 <> 1 ",           #一級統治不要出來,BY蔡曉峰規定  #No.FUN-A40020
                 "   AND NOT (aag24 = 1 AND aag07 = '1') ", #No.FUN-A40020 
                 "   AND ",tm.wc1 CLIPPED
     PREPARE gglr702_aag01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     DECLARE gglr702_aag01_cs CURSOR FOR gglr702_aag01_p
 
     #查找核算項
     LET l_sql1 = "SELECT UNIQUE ted02 FROM ted_file ",
                  " WHERE ted00 = '",bookno,"'",
                  "   AND ted01 LIKE ? ",           #account
                  "   AND ted011 = '",tm.a,"'",
                  "   AND ",tm.wc2 CLIPPED
     LET l_sql1 = cl_replace_str(l_sql1,"ted","aed")        #MOD-A80039 Add             
     PREPARE gglr702_ted02_p1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_ted02_cs1 CURSOR FOR gglr702_ted02_p1
 
     LET l_wc2 = tm.wc2
     LET l_wc2 = cl_replace_str(l_wc2,"ted02",g_field)

     #FUN-C80102--add--str--
     LET l_sql1 = " SELECT ",g_field CLIPPED," FROM aba_file,abb_file",
                     "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                     "    AND aba00 = '",bookno,"'",
                     "    AND abb03 LIKE ? ",       #account
                     "    AND ",g_field CLIPPED," IS NOT NULL",
                     "    AND ",l_wc2
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql1 = l_sql1,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql1 = l_sql1,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql1 = l_sql1," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql1 = l_sql1," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglr702_ted02_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_ted02_cs2 CURSOR FOR gglr702_ted02_p2
 
     #期初余額
     #1~mm-1
#    LET l_sql = "SELECT SUM(ted05),SUM(ted06),SUM(ted10),SUM(ted11) FROM ted_file", #MOD-A80039 Mark
     LET l_sql = "SELECT SUM(ted05),SUM(ted06),0,0 FROM ted_file",                   #MOD-A80039 Add     
                 " WHERE ted00 = '",bookno,"'",
                 "   AND ted01 LIKE ? ",                  #科目
                 "   AND ted02 = ? ",                     #核算項
                 "   AND ted011 = '",tm.a,"'",
                 "   AND ted03 = ",yy,
                 "   AND ted04 < ",mm                     #期初
     LET l_sql = cl_replace_str(l_sql,"ted","aed")        #MOD-A80039 Add
     PREPARE gglr702_qc1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_qc1_cs CURSOR FOR gglr702_qc1_p
     #mm(1~bdate-1)

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND abb06 = ? ",
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND aba02 < '",bdate,"'"
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglr702_qc2_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_qc2_cs CURSOR FOR gglr702_qc2_p
 
     #FUN-C80102--add--end--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND ",g_field CLIPPED," = ? ",      #核算項值
                    "    AND abb06 = ? ",
                    "    AND aba03 = ",yy,
                    "    AND aba04 < ",mm
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglr702_qc3_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_qc3_cs CURSOR FOR gglr702_qc3_p

     #FUN-C80102--add--str--
     LET l_sql = " SELECT SUM(abb07),SUM(abb07f) FROM aba_file,abb_file ",
                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                 "    AND aba00 = '",bookno,"'",
                 "    AND abb03 LIKE ?   ",               #科目
                 "    AND ",g_field CLIPPED," = ? ",      #核算項值
                 "    AND aba03 = ",yy,
                 "    AND aba04 = ",mm,
                 "    AND abb06 = ? ",
                 "    AND aba02 < '",bdate,"'" 

     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql,"  AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
        ELSE
           LET l_sql = l_sql,"  AND aba19 = 'N'"
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 ='Y' and abapost = 'N') "
        ELSE
           LET l_sql = l_sql," AND  aba19 = 1 "
        END IF
     END IF
     #FUN-C80102--add--end--
      
     PREPARE gglr702_qc4_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_qc4_cs CURSOR FOR gglr702_qc4_p
 
     #當期異動
     #FUN-C80102--add--str--
     #IF tm.m = 'Y' THEN    #FUN-C80102 mark
        LET l_sql = " SELECT '','','','',0,aba02,aba01,abb04,",
                    "        abb06,abb07,abb07f,abb24,abb25, ",
                    "        0,0,0,0,0,0,0,0,0,0             ",
                    "   FROM aba_file a,abb_file ",
                    "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                    "    AND aba00 = '",bookno,"'",
                    "    AND abb03 LIKE ?   ",               #科目
                    "    AND ",g_field CLIPPED," = ? ",      #核算項值
                    "    AND aba03 = ",yy,
                    #"    AND (aba06!='CE' OR (aba06='CA' AND  aba07 NOT IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL)))",  #CHI-C70031  #FUN-D40044 mark
                    "    AND aba02 BETWEEN '",bdate,"' AND '",edate,"'",
                    "    AND aba04 = ? "
     #END IF  #FUN-C80102 mark

     #FUN-D40044--add--str--
     IF tm.i = 'N' THEN 
        LET l_sql = l_sql CLIPPED," AND NOT EXISTS (",
            " SELECT 1 FROM aba_file b WHERE b.aba01 = a.aba01 ",
            "    AND (aba06='CE' OR (aba06='CA' AND aba07 IN (SELECT cdb13 FROM cdb_file WHERE cdb13 IS NOT NULL))))"
     END IF
     #FUN-D40044--add--end--

     #FUN-C80102--add--str--
     IF tm.m ='Y' THEN 
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND (aba19 = 'N' or aba19 ='Y')",
                           " ORDER BY aba02,aba01,abb02 "   
        ELSE
           LET l_sql = l_sql," AND (aba19 = 'N' or (aba19 ='Y' AND abapost = 'Y'))",
                            " ORDER BY aba02,aba01,abb02 "   
        END IF
     END IF
     IF tm.m ='N' THEN
        IF tm.f = '1' THEN
           LET l_sql = l_sql," AND  aba19 ='Y'",
                          " ORDER BY aba02,aba01,abb02 "   
        ELSE
           LET l_sql = l_sql," AND aba19 ='Y' AND abapost = 'Y'",
                          " ORDER BY aba02,aba01,abb02 "   
        END IF
     END IF
     #FUN-C80102--add--end--
     
     PREPARE gglr702_qj1_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglr702_qj1_cs CURSOR FOR gglr702_qj1_p
 
END FUNCTION
 
FUNCTION gglr702()
   DEFINE l_name               LIKE type_file.chr20,
          l_sql,l_sql1          STRING,      #NO.FUN-910082
          l_date,l_date1       LIKE aba_file.aba02,
          l_i                  LIKE type_file.num5,
          qc_ted05             LIKE ted_file.ted05,
          qc_ted06             LIKE ted_file.ted06,
          qc_ted10             LIKE ted_file.ted10,
          qc_ted11             LIKE ted_file.ted11,
          qc1_ted05            LIKE ted_file.ted05,
          qc1_ted06            LIKE ted_file.ted06,
          qc1_ted10            LIKE ted_file.ted10,
          qc1_ted11            LIKE ted_file.ted11,
          qc2_ted05            LIKE ted_file.ted05,
          qc2_ted06            LIKE ted_file.ted06,
          qc2_ted10            LIKE ted_file.ted10,
          qc2_ted11            LIKE ted_file.ted11,
          qc3_ted05            LIKE ted_file.ted05,
          qc3_ted06            LIKE ted_file.ted06,
          qc3_ted10            LIKE ted_file.ted10,
          qc3_ted11            LIKE ted_file.ted11,
          qc4_ted05            LIKE ted_file.ted05,
          qc4_ted06            LIKE ted_file.ted06,
          qc4_ted10            LIKE ted_file.ted10,
          qc4_ted11            LIKE ted_file.ted11,
          l_qcye               LIKE abb_file.abb07,
          l_qcyef              LIKE abb_file.abb07,
          t_qcye               LIKE abb_file.abb07,
          t_qcyef              LIKE abb_file.abb07,
          l_ted02              LIKE ted_file.ted02,
          l_ted02_d            LIKE ze_file.ze03,
          l_aag01_str          LIKE type_file.chr50,
          t_bal,t_balf                 LIKE abb_file.abb07,
          t_debit,t_debitf             LIKE abb_file.abb07,
          t_credit,t_creditf           LIKE abb_file.abb07,
          l_d,l_df,l_c,l_cf            LIKE abb_file.abb07,
          n_bal,n_balf                 LIKE abb_file.abb07,
          l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25,
          t_date2                      LIKE type_file.dat,
          t_date1                      LIKE type_file.dat,
          l_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10,          
          l_flag3                      LIKE type_file.chr1,          #TQC-970049
          l_flag4                      LIKE type_file.chr1,          #TQC-970310
          sr1                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02
                               END RECORD,
          sr2                  RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               ted02    LIKE ted_file.ted02,
                               ted02_d  LIKE ze_file.ze03
                               END RECORD,
          sr                   RECORD
                               aag01    LIKE aag_file.aag01,
                               aag02    LIKE aag_file.aag02,
                               ted02    LIKE ted_file.ted02,
                               ted02_d  LIKE ze_file.ze03,
                               aba04    LIKE aba_file.aba04,
                               aba02    LIKE aba_file.aba02,
                               aba01    LIKE aba_file.aba01,
                               abb04    LIKE abb_file.abb04,
                               abb06    LIKE abb_file.abb06,
                               abb07    LIKE abb_file.abb07,
                               abb07f   LIKE abb_file.abb07f,
                               abb24    LIKE abb_file.abb24,
                               abb25    LIKE abb_file.abb25,
                               qcye     LIKE abb_file.abb07,
                               qcyef    LIKE abb_file.abb07,
                               qc_md    LIKE abb_file.abb07,
                               qc_mdf   LIKE abb_file.abb07,
                               qc_mc    LIKE abb_file.abb07,
                               qc_mcf   LIKE abb_file.abb07,
                               qc_yd    LIKE abb_file.abb07,
                               qc_ydf   LIKE abb_file.abb07,
                               qc_yc    LIKE abb_file.abb07,
                               qc_ycf   LIKE abb_file.abb07
                               END RECORD
DEFINE l_chr                   LIKE type_file.chr1    #FUN-A40011 
 
     CALL gglr702_table()
     LET l_flag3 = 'N'                  
 
     CALL gglr702_curs()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     FOREACH gglr702_aag01_cs INTO sr1.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach gglr702_aag01_cs',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr1.aag01 CLIPPED,'\%'    #No.MOD-940388
        FOREACH gglr702_ted02_cs1 USING l_aag01_str
                                  INTO l_ted02
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglr702_ted02_cs1',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
           CALL gglr702_get_ahe02(sr1.aag01,l_ted02,g_gaq01) 
                RETURNING l_ted02_d
           INSERT INTO gglr702_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,'') 
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
              CALL cl_err3('ins','gglr702_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
 
        FOREACH gglr702_ted02_cs2 USING l_aag01_str
                                  INTO l_ted02
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach gglr702_ted02_cs2',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #get dimension description
           CALL gglr702_get_ahe02(sr1.aag01,l_ted02,g_gaq01) 
                RETURNING l_ted02_d
           INSERT INTO gglr702_ted_tmp VALUES(sr1.aag01,sr1.aag02,l_ted02,l_ted02_d,'') 
           IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN 
              CALL cl_err3('ins','gglr702_ted_tmp',sr1.aag01,l_ted02,SQLCA.sqlcode,'','',1)
              EXIT FOREACH
           END IF
        END FOREACH
     END FOREACH
 
     LET g_prog = 'gglr301'
     LET g_pageno = 0
 
     DECLARE gglr702_cs1 CURSOR FOR
      SELECT UNIQUE aag01,aag02,ted02,ted02_d FROM gglr702_ted_tmp
       ORDER BY aag01,ted02
 
     FOREACH gglr702_cs1 INTO sr2.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach gglr702_cs1',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF cl_null(sr2.aag01) THEN CONTINUE FOREACH END IF
        LET l_aag01_str = sr2.aag01 CLIPPED,'\%'    
 
        #期初
        LET qc1_ted05 = 0  LET qc1_ted06 = 0
        LET qc1_ted10 = 0  LET qc1_ted11 = 0
        LET qc2_ted05 = 0  LET qc2_ted06 = 0
        LET qc2_ted10 = 0  LET qc2_ted11 = 0
        LET qc3_ted05 = 0  LET qc3_ted06 = 0
        LET qc3_ted10 = 0  LET qc3_ted11 = 0
        LET qc4_ted05 = 0  LET qc4_ted06 = 0
        LET qc4_ted10 = 0  LET qc4_ted11 = 0
        #1~mm-1
        OPEN gglr702_qc1_cs USING l_aag01_str,sr2.ted02
        FETCH gglr702_qc1_cs INTO qc1_ted05,qc1_ted06,qc1_ted10,qc1_ted11
        CLOSE gglr702_qc1_cs
        IF cl_null(qc1_ted05) THEN LET qc1_ted05 = 0 END IF
        IF cl_null(qc1_ted06) THEN LET qc1_ted06 = 0 END IF
        IF cl_null(qc1_ted10) THEN LET qc1_ted10 = 0 END IF
        IF cl_null(qc1_ted11) THEN LET qc1_ted11 = 0 END IF
        #mm(day 1~<bdate)
        OPEN gglr702_qc2_cs USING l_aag01_str,sr2.ted02,'1'
        FETCH gglr702_qc2_cs INTO qc2_ted05,qc2_ted10
        CLOSE gglr702_qc2_cs
        OPEN gglr702_qc2_cs USING l_aag01_str,sr2.ted02,'2'
        FETCH gglr702_qc2_cs INTO qc2_ted06,qc2_ted11
        CLOSE gglr702_qc2_cs
        IF cl_null(qc2_ted05) THEN LET qc2_ted05 = 0 END IF
        IF cl_null(qc2_ted06) THEN LET qc2_ted06 = 0 END IF
        IF cl_null(qc2_ted10) THEN LET qc2_ted10 = 0 END IF
        IF cl_null(qc2_ted11) THEN LET qc2_ted11 = 0 END IF
 
        #IF tm.c = 'Y' THEN   #FUN-C80102  mark
           #1~mm-1
           OPEN gglr702_qc3_cs USING l_aag01_str,sr2.ted02,'1'
           FETCH gglr702_qc3_cs INTO qc3_ted05,qc3_ted10
           CLOSE gglr702_qc3_cs
           OPEN gglr702_qc3_cs USING l_aag01_str,sr2.ted02,'2'
           FETCH gglr702_qc3_cs INTO qc3_ted06,qc3_ted11
           CLOSE gglr702_qc3_cs
           IF cl_null(qc3_ted05) THEN LET qc3_ted05 = 0 END IF
           IF cl_null(qc3_ted06) THEN LET qc3_ted06 = 0 END IF
           IF cl_null(qc3_ted10) THEN LET qc3_ted10 = 0 END IF
           IF cl_null(qc3_ted11) THEN LET qc3_ted11 = 0 END IF
           #mm(1~bdate-1)
           OPEN gglr702_qc4_cs USING l_aag01_str,sr2.ted02,'1'
           FETCH gglr702_qc4_cs INTO qc4_ted05,qc4_ted10
           CLOSE gglr702_qc4_cs
           OPEN gglr702_qc4_cs USING l_aag01_str,sr2.ted02,'2'
           FETCH gglr702_qc4_cs INTO qc4_ted06,qc4_ted11
           CLOSE gglr702_qc4_cs
           IF cl_null(qc4_ted05) THEN LET qc4_ted05 = 0 END IF
           IF cl_null(qc4_ted06) THEN LET qc4_ted06 = 0 END IF
           IF cl_null(qc4_ted10) THEN LET qc4_ted10 = 0 END IF
           IF cl_null(qc4_ted11) THEN LET qc4_ted11 = 0 END IF
        #END IF   #FUN-C80102  mark
        LET qc_ted05 = qc1_ted05 + qc2_ted05 + qc3_ted05 + qc4_ted05
        LET qc_ted06 = qc1_ted06 + qc2_ted06 + qc3_ted06 + qc4_ted06
        LET qc_ted10 = qc1_ted10 + qc2_ted10 + qc3_ted10 + qc4_ted10
        LET qc_ted11 = qc1_ted11 + qc2_ted11 + qc3_ted11 + qc4_ted11
 
        LET l_qcye  = qc_ted05 - qc_ted06
        LET l_qcyef = qc_ted10 - qc_ted11
        #若t_qcye = 0 & 異間異動為零，則不打印
        LET t_qcye  = l_qcye
        LET t_qcyef = l_qcyef
        LET l_flag4 = 'N'                
        
        LET l_chr = 'Y'        #FUN-A40011 
        FOR l_i = mm1 TO nn1
            LET l_flag='N'
            FOREACH gglr702_qj1_cs USING l_aag01_str,sr2.ted02,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               LET l_flag='Y'
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.ted02   = sr2.ted02
               LET sr.ted02_d = sr2.ted02_d
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
 
               LET sr.qc_md   = qc2_ted05 + qc4_ted05
               LET sr.qc_mdf  = qc2_ted10 + qc4_ted10
               LET sr.qc_mc   = qc2_ted06 + qc4_ted06
               LET sr.qc_mcf  = qc2_ted11 + qc4_ted11
 
               LET sr.qc_yd   = qc1_ted05 + qc3_ted05
               LET sr.qc_ydf  = qc1_ted10 + qc3_ted10
               LET sr.qc_yc   = qc1_ted06 + qc3_ted06
               LET sr.qc_ycf  = qc1_ted11 + qc3_ted11
 
               IF sr.abb06 = '1' THEN
                  LET t_qcye  = t_qcye + sr.abb07
                  LET t_qcyef = t_qcyef+ sr.abb07
               ELSE
                  LET t_qcye  = t_qcye - sr.abb07
                  LET t_qcyef = t_qcyef- sr.abb07
               END IF
 
      IF l_flag3 = 'N' THEN
        IF l_flag4 = 'N' THEN                                     
          LET t_bal     = sr.qcye
          LET t_balf    = sr.qcyef
          LET t_debit   = sr.qc_md
          LET t_debitf  = sr.qc_mdf
          LET t_credit  = sr.qc_mc
          LET t_creditf = sr.qc_mcf 

          LET l_flag4 = 'Y'                                       
        END IF                                           
      IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN   
         LET t_date2 = bdate
      ELSE
         LET t_date2 = MDY(sr.aba04,1,yy)
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
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
 
      CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
      LET l_abb25_bal = n_bal / n_balf   
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF l_chr = 'Y' THEN   #FUN-A40011       
        INSERT INTO gglr702_tmp
        VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1',
             t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'1')   
      END IF   
      LET l_chr = 'N'               
      LET l_flag3 = 'Y'
      END IF
 
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
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
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglr702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
               #l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)      
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'2')  
      END IF      
            END FOREACH
            IF l_flag = "N" THEN 
               IF tm.t = 'N' THEN 
                  IF t_qcye = 0 THEN 
                     CONTINUE FOR
                  END IF
               END IF
               INITIALIZE sr.* TO NULL
               LET sr.aag01   = sr2.aag01
               LET sr.aag02   = sr2.aag02
               LET sr.ted02   = sr2.ted02
               LET sr.ted02_d = sr2.ted02_d
               LET sr.aba04   = l_i
               LET sr.qcye    = l_qcye
               LET sr.qcyef   = l_qcyef
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET sr.aba02   = l_date1
               LET sr.aba01   = NULL
               LET sr.abb04   = NULL
               LET sr.abb06   = NULL
               LET sr.abb07   = 0
               LET sr.abb07f  = 0
               LET sr.abb24   = NULL
               LET sr.abb25   = 0
 
               LET sr.qc_md   = qc2_ted05 + qc4_ted05
               LET sr.qc_mdf  = qc2_ted10 + qc4_ted10
               LET sr.qc_mc   = qc2_ted06 + qc4_ted06
               LET sr.qc_mcf  = qc2_ted11 + qc4_ted11
 
               LET sr.qc_yd   = qc1_ted05 + qc3_ted05
               LET sr.qc_ydf  = qc1_ted10 + qc3_ted10
               LET sr.qc_yc   = qc1_ted06 + qc3_ted06
               LET sr.qc_ycf  = qc1_ted11 + qc3_ted11
 
      IF l_flag3 = 'N' THEN
        IF l_flag4 = 'N' THEN                                     
          LET t_bal     = sr.qcye
          LET t_balf    = sr.qcyef
          LET t_debit   = sr.qc_md
          LET t_debitf  = sr.qc_mdf
          LET t_credit  = sr.qc_mc
          LET t_creditf = sr.qc_mcf 
          LET l_flag4 = 'Y'                                      
        END IF                                                            
      IF sr.aba04 = s_get_aznn(g_plant,g_aza.aza81,bdate,3) THEN    
         LET t_date2 = bdate
      ELSE
         LET t_date2 = MDY(sr.aba04,1,yy)
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
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
 
      CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
      LET l_abb25_bal = n_bal / n_balf   
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF l_chr = 'Y' THEN    #FUN-A40011      
        INSERT INTO gglr702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'1',
              t_date2,'',g_msg,sr.abb24,'',0,0,0,0,0,0,0,0,
              l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF     
      LET l_chr = 'N'                   
      LET l_flag3 = 'Y'
      END IF
 
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07)  THEN LET sr.abb07  = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET t_bal   = t_bal   + sr.abb07
            LET t_balf  = t_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET t_bal    = t_bal    - sr.abb07
            LET t_balf   = t_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
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
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF
 
 
         LET l_abb25_d = l_d / l_df
         LET l_abb25_c = l_c / l_cf
         LET l_abb25_bal = n_bal / n_balf
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglr702_tmp
         VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'2',
                sr.aba02,sr.aba01,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF      
            END IF
 
      CALL s_yp(edate) RETURNING l_year,l_month
      IF sr.aba04 = l_month THEN
         LET t_date2  = edate
      ELSE
         CALL s_azn01(yy,sr.aba04) RETURNING t_date1,t_date2
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
 
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
 
      
      SELECT SUM(abb07) INTO l_d
        FROM gglr702_tmp 
       WHERE abb06 = '1'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02 
         AND aag01 = sr.aag01                                              
      SELECT SUM(abb07f) INTO l_df
        FROM gglr702_tmp 
       WHERE abb06 = '1'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02 
         AND aag01 = sr.aag01                                              
      SELECT SUM(abb07) INTO l_c
        FROM gglr702_tmp 
       WHERE abb06 = '2'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02 
         AND aag01 = sr.aag01                                              
      SELECT SUM(abb07f) INTO l_cf
        FROM gglr702_tmp 
       WHERE abb06 = '2'      AND abb07 IS NOT NULL 
         AND aba04 = sr.aba04 AND ted02 = sr.ted02  
         AND aag01 = sr.aag01                                              
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      IF sr.aba04 = mm1 THEN
         LET l_d  = l_d  + sr.qc_md
         LET l_df = l_df + sr.qc_mdf
         LET l_c  = l_c  + sr.qc_mc
         LET l_cf = l_cf + sr.qc_mcf
      END IF
      CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
      LET l_abb25_d = l_d / l_df
      LET l_abb25_c = l_c / l_cf
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d)   THEN LET l_abb25_d   = 0 END IF
      IF cl_null(l_abb25_c)   THEN LET l_abb25_c   = 0 END IF
      INSERT INTO gglr702_tmp
      VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'3',
             t_date2,'',g_msg,sr.abb24,'',0,0,
             l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,     
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'3')   
 
 
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
      LET l_abb25_d = t_debit / t_debitf
      LET l_abb25_c = t_credit / t_creditf
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
      IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
      INSERT INTO gglr702_tmp
      VALUES(sr.aag01,sr.aag02,sr.ted02,sr.ted02_d,sr.aba04,'4',
             t_date2,'',g_msg,sr.abb24,'',0,0,
             t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,       
             l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07,'3')   
      LET l_flag3 = 'N'                    
        END FOR
     END FOREACH
     
     CALL r702_out_2()

END FUNCTION

#獲取當期的第一天和最後一天
FUNCTION r702_getday()
   DEFINE l_year     LIKE  type_file.num5
   DEFINE l_month    LIKE  type_file.num5
   DEFINE l_firstday   STRING 
   DEFINE l_lastday    STRING
   LET l_year = year(g_today)
   LET l_month = month(g_today)
   CASE 
      WHEN  (l_month = '1' OR l_month = '3' OR l_month = '5' OR l_month = '7' OR 
            l_month = '8' OR l_month = '10' OR l_month = '12' )
             IF l_month = '10' OR l_month = '12' THEN 
                LET l_firstday = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/31'
             ELSE
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/31'
             END IF 
      WHEN  (l_month = '4' OR l_month = '6' OR l_month = '9' OR l_month = '11')
             IF l_month = '11' THEN 
                LET l_firstday = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/',l_month USING '<<<<<<','/30'
             ELSE
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/30'
             END IF 
                 
      WHEN   (l_month = '2')  
             IF (l_year MOD 4 = 0 AND l_year MOD 100 !=0) OR (l_year MOD 400 = 0) THEN
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/29'
             ELSE
                LET l_firstday = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/01'
                LET l_lastday  = l_year USING '<<<<<<','/0',l_month USING '<<<<<<','/28'
             END IF
   END CASE   
   LET l_firstday = l_firstday.substring(3,l_firstday.getLength())
   LET l_lastday = l_lastday.substring(3,l_lastday.getLength())
   LET bdate = l_firstday
   LET edate = l_lastday  
   
END FUNCTION 
#FUN-D80121 
