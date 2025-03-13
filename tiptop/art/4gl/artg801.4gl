# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artg801.4gl
# Descriptions...: 專櫃對帳單-依抽成代碼
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B50153 11/05/30 by huangtao
# Modify.........: No.FUN-B60054 11/06/09 By huangtao 傳入的資料狀態為空時，可以打印全部資料
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-C40071 11/04/23 By huangtao CR報表轉GR
#                                         By yangtt CR報表轉GR修改

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           wc        STRING,                #Where condition 
           yy        LIKE type_file.num5,
           mm        LIKE type_file.num5,
           type1     LIKE type_file.chr1, 
           cb        LIKE type_file.chr1, 
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD

DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE l_table1       STRING
  




###GENGRE###START
TYPE sr1_t RECORD
    rch01 LIKE rch_file.rch01,
    rch05 LIKE rch_file.rch05,
    azw08 LIKE azw_file.azw08,
    rch071 LIKE rch_file.rch071,
    rci04 LIKE rci_file.rci04,
    tqa02 LIKE tqa_file.tqa02,
    rci05 LIKE rci_file.rci05,
    rci06 LIKE rci_file.rci06,
    rci07 LIKE rci_file.rci07,
    rci08 LIKE rci_file.rci08,
    rci09 LIKE rci_file.rci09,
    occ18 LIKE occ_file.occ18,
    occ11 LIKE occ_file.occ11,
    occ231 LIKE occ_file.occ231,
    feiys LIKE rci_file.rci11,
    azi04 LIKE azi_file.azi04,
    chouc LIKE rci_file.rci08,    #FUN-C40071
    yings LIKE rci_file.rci09     #FUN-C40071
END RECORD

TYPE sr2_t RECORD
    rch01 LIKE rch_file.rch01,
    rci10 LIKE rci_file.rci10,
    oaj02 LIKE oaj_file.oaj02,
    feiy LIKE rci_file.rci11
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy  = ARG_VAL(8) 
   LET tm.mm   = ARG_VAL(9)
   LET tm.type1  = ARG_VAL(10)
   LET tm.cb  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "rch01.rch_file.rch01,",
               "rch05.rch_file.rch05,",
               "azw08.azw_file.azw08,",
               "rch071.rch_file.rch071,",
               "rci04.rci_file.rci04,",
               "tqa02.tqa_file.tqa02,",
               "rci05.rci_file.rci05,",
               "rci06.rci_file.rci06,",
               "rci07.rci_file.rci07,",
               "rci08.rci_file.rci08,",
               "rci09.rci_file.rci09,",
               "occ18.occ_file.occ18,",
               "occ11.occ_file.occ11,",
               "occ231.occ_file.occ231,",
               "feiys.rci_file.rci11,",
               "azi04.azi_file.azi04,",
               "chouc.rci_file.rci08,",     #FUN-C40071
               "yings.rci_file.rci09"       #FUN-C40071
           
    LET l_table = cl_prt_temptable('artg801',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "rch01.rch_file.rch01,",
                "rci10.rci_file.rci10,",
                "oaj02.oaj_file.oaj02,",
                "feiy.rci_file.rci11"
    LET l_table1 = cl_prt_temptable('artg8011',g_sql) CLIPPED
    IF l_table1=-1 THEN EXIT PROGRAM END IF  
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artg801_tm()        # Input print condition
    ELSE 
       CALL artg801() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
    CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-C40071 
END MAIN

FUNCTION artg801_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artg801_w AT p_row,p_col WITH FORM "art/42f/artg801" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
   LET tm.type1 = 'Y'  
   LET tm.cb = 'N'  
   IF MONTH(g_today) > 1 THEN
      LET tm.yy = YEAR(g_today)
      LET tm.mm = MONTH(g_today)-1
   ELSE
      LET tm.yy = YEAR(g_today)-1
      LET tm.mm = 12
   END IF

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rch01,rch05
        BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(rch01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rch01_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rch01
                  NEXT FIELD rch01
               WHEN INFIELD(rch05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw01_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rch05
                  NEXT FIELD rch05
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
      
      IF cl_null(tm.wc) THEN
         LET tm.wc = " 1=1"
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg801_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-C40071 
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.yy,tm.mm,tm.type1,tm.cb,tm.more
      INPUT BY NAME tm.yy,tm.mm,tm.type1,tm.cb,tm.more WITHOUT DEFAULTS  
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
             
          AFTER FIELD mm
              IF NOT cl_null(tm.mm) THEN
                 IF tm.mm <1 OR tm.mm>12 THEN
                    CALL cl_err('','aom-580',0)
                 END IF
              END IF
              
          AFTER FIELD MORE
             IF tm.more = 'Y' THEN
                CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         LET INT_FLAG = 0 CLOSE WINDOW artg801_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-C40071 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg801'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artg801','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd1 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",tm.yy CLIPPED,"'" ,
                       " '",tm.mm CLIPPED,"'" ,
                       " '",tm.type1 CLIPPED,"'" ,
                       " '",tm.cb CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg801',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg801_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-C40071 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg801()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg801_w

END FUNCTION

FUNCTION artg801()
DEFINE    l_sql     STRING ,                    
          l_chr     LIKE type_file.chr1,       
          sr        RECORD 
                    rch01  LIKE rch_file.rch01,
                    rch05  LIKE rch_file.rch05,
                    rch06  LIKE rch_file.rch06,
                    rch071 LIKE rch_file.rch071,
                    rci04  LIKE rci_file.rci04,
                    rci05  LIKE rci_file.rci05,
                    rci06  LIKE rci_file.rci06,
                    rci07  LIKE rci_file.rci08,
                    rci08  LIKE rci_file.rci08,
                    rci09  LIKE rci_file.rci09
                    END RECORD

DEFINE  l_flag   LIKE type_file.chr1
DEFINE  l_str    STRING
DEFINE  l_azw08  LIKE azw_file.azw08
DEFINE  l_azi04  LIKE azi_file.azi04
DEFINE  l_tqa02   LIKE tqa_file.tqa02
DEFINE  l_feiy    LIKE rci_file.rci11
DEFINE  l_feiys    LIKE rci_file.rci11
DEFINE  l_rci10  LIKE rci_file.rci10
DEFINE  l_oaj02  LIKE oaj_file.oaj02
DEFINE  l_rci11  LIKE rci_file.rci11
DEFINE  l_rci12  LIKE rci_file.rci12
DEFINE  l_occ18  LIKE occ_file.occ18
DEFINE  l_occ11  LIKE occ_file.occ18
DEFINE  l_occ231 LIKE occ_file.occ18
DEFINE  l_chouc  LIKE rci_file.rci08
DEFINE  l_yings  LIKE rci_file.rci09


    CREATE TEMP TABLE artg801_tmp(
                    rch01 LIKE rch_file.rch01,
                    rci10 LIKE rci_file.rci10,
                    feiy  LIKE rci_file.rci11)
    DELETE FROM artg801_tmp
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-C40071 
       EXIT PROGRAM
    END IF    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?)" 
            
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep1:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-C40071 
       EXIT PROGRAM
    END IF
    SELECT azi04 INTO l_azi04 FROM azi_file
     WHERE azi01 = g_aza.aza17
    LET l_sql = " SELECT rch01,rch05,rch06,rch071,rci04,rci05,rci06,rci07,rci08,rci09 FROM rch_file,rci_file ",
                " WHERE rch01 = rci01 ",
                " AND rci02 = '1'",
                " AND rch03 = '",tm.yy,"'",
                " AND rch04 = '",tm.mm,"'",
                " AND ",tm.wc,
                " AND rch05 IN ",g_auth
    IF tm.type1 = 'N' THEN
       LET l_sql = l_sql," AND rchconf = 'N'"
#FUN-B60054 ---------------STA
    ELSE
    END IF
    IF tm.type1 = 'Y' THEN
#FUN-B60054 ---------------END 
       LET l_sql = l_sql," AND rchconf = 'Y'"
    END IF
    PREPARE artg801_prepare1 FROM l_sql 
    DECLARE artg801_curs1 CURSOR FOR artg801_prepare1

   #FUN-C40071----end---str---
    IF tm.cb = 'Y' THEN 
    LET l_sql = " SELECT rci10,rci11,rci12 FROM rci_file ",
                " WHERE rci01 = ?",
                " AND rci02 = '2'"
    END IF 
    PREPARE artg801_prepare2 FROM l_sql 
    DECLARE artg801_curs2 CURSOR FOR artg801_prepare2
   #FUN-C40071----end---end---

    FOREACH artg801_curs1 INTO sr.* 
      
       SELECT azw08 INTO l_azw08 FROM azw_file
        WHERE azw01 = sr.rch05
       SELECT tqa02 INTO l_tqa02 FROM tqa_file
        WHERE tqa01 = sr.rci04
          AND tqa03 = '29'

       IF tm.cb = 'Y' THEN
         #FUN-C40071----mark--str---
         #LET l_sql = " SELECT rci10,rci11,rci12 FROM rci_file ",
         #            " WHERE rci01 = '",sr.rch01,"'",
         #            " AND rci02 = '2'"
         #PREPARE artg801_prepare2 FROM l_sql 
         #DECLARE artg801_curs2 CURSOR FOR artg801_prepare2
         #FUN-C40071----mark--end---
          DELETE FROM artg801_tmp
          FOREACH artg801_curs2 USING sr.rch01 INTO l_rci10,l_rci11,l_rci12   #FUN-C40071 add USING sr.rch01
             IF sr.rci06 = 'N' THEN
                LET l_feiy = l_rci11
             ELSE
                LET l_feiy = l_rci12
             END IF
             SELECT oaj02 INTO l_oaj02
               FROM oaj_file WHERE oaj01 = l_rci10 AND oajacti = 'Y'
             IF cl_null(l_oaj02) OR STATUS THEN
                LET l_oaj02 = ' '
             END IF
             EXECUTE insert_prep1 USING sr.rch01,l_rci10,l_oaj02,l_feiy
             INSERT INTO artg801_tmp VALUES(sr.rch01,l_rci10,l_feiy)
          END FOREACH  
          SELECT SUM(feiy) INTO l_feiys FROM  artg801_tmp
       END IF 
      
       SELECT occ18,occ11,occ231 INTO l_occ18,l_occ11,l_occ231 FROM occ_file 
        WHERE occ01 = sr.rch06
          AND occacti = 'Y'
#FUN-C40071 ----------------STA
           IF cl_null(sr.rci07) THEN
              LET sr.rci07 = 0
           END IF
           IF cl_null(sr.rci08) THEN
               LET sr.rci08 = 0
           END IF
           IF cl_null(sr.rci09) THEN
              LET sr.rci09 = 0
           END IF
           IF sr.rci06 = 'N' THEN
              LET l_chouc = sr.rci08
           ELSE
              LET l_chouc = sr.rci09
           END IF
           LET l_yings = sr.rci07- l_chouc

#FUN-C40071 ----------------END     
       EXECUTE insert_prep USING sr.rch01,sr.rch05,l_azw08,sr.rch071,sr.rci04,
                               l_tqa02,sr.rci05,sr.rci06,sr.rci07,sr.rci08,
                               sr.rci09, l_occ18,l_occ11,l_occ231,l_feiys,l_azi04,l_chouc,l_yings   #FUN-C40071 add 
         
       
    END FOREACH    
   

   LET g_str = ''  
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###               "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
               
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ruh01,rch05')
             RETURNING tm.wc
        LET g_str = tm.wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
###GENGRE###   LET g_str = g_str,";",tm.yy,";",tm.mm,';',tm.type1,";",tm.cb,";"
   
###GENGRE###   CALL cl_prt_cs3('artg801','artg801',l_sql,g_str)  
    CALL artg801_grdata()    ###GENGRE###
 

   
END FUNCTION
#FUN-B50153


   


###GENGRE###START
FUNCTION artg801_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg801")
        IF handler IS NOT NULL THEN
            START REPORT artg801_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE artg801_datacur1 CURSOR FROM l_sql
            FOREACH artg801_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg801_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg801_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg801_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
#FUN-C40071 ------------STA    
    DEFINE l_sum_yings LIKE rci_file.rci09     
    DEFINE l_sql   STRING      
    DEFINE l_money1    LIKE rci_file.rci09
    DEFINE l_money2    LIKE rci_file.rci09
    DEFINE l_money3    LIKE rci_file.rci09
    DEFINE l_money4    LIKE rci_file.rci09
    DEFINE l_money5    LIKE rci_file.rci09
    DEFINE l_money6    LIKE rci_file.rci09                    
    DEFINE l_fmt       STRING
    DEFINE l_fmt1      STRING
#FUN-C40071 ------------END
   
    ORDER EXTERNAL BY sr1.rch01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-C40071
            PRINTX tm.*
           
        BEFORE GROUP OF sr1.rch01
            LET l_lineno = 0
            LET l_sum_yings = 0   #FUN-C40071 add

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_fmt1 = cl_gr_numfmt('rci_file','rci07',sr1.azi04)
            PRINTX l_fmt1

            PRINTX sr1.*

        AFTER GROUP OF sr1.rch01
#FUN-C40071 ----------------STA
            LET l_sum_yings = GROUP SUM(sr1.yings)
            PRINTX l_sum_yings
            IF tm.cb = 'Y' THEN
               LET l_money1 = l_sum_yings - sr1.feiys
            ELSE
               LET l_money1 = l_sum_yings
            END IF  
            LET l_money2 = l_money1/(1+sr1.rch071/100)
            LET l_money3 = l_money1*(sr1.rch071/100) 
            IF sr1.rci06 = 'Y' THEN 
               LET l_money4 = l_money1
            ELSE
               LET l_money4 = l_money1 + l_money3
            END IF
            IF sr1.rci06 = 'Y' THEN
               LET l_money5 = l_money2
            ELSE
               LET l_money5 = l_money1
            END IF
            IF sr1.rci06 = 'Y' THEN
               LET l_money6 = l_money4 - l_money5 
            ELSE
               LET l_money6 = l_money3
            END IF
            PRINTX l_money4,l_money5,l_money6

            LET l_fmt = cl_gr_numfmt('rci_file','rci09',sr1.azi04)
            PRINTX l_fmt

            LET l_sql = "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE rch01 = '",sr1.rch01,"'"
            START REPORT artg801_subrep01
            DECLARE artg801_repcur1 CURSOR FROM l_sql
            FOREACH artg801_repcur1 INTO sr2.*
                OUTPUT TO REPORT artg801_subrep01(sr1.*,sr2.*)
            END FOREACH
            FINISH REPORT artg801_subrep01

#FUN-C40071 ----------------END 
        
        ON LAST ROW

END REPORT



REPORT artg801_subrep01(sr1,sr2)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_feiy_fmt   STRING    

    FORMAT
        ON EVERY ROW
           LET l_feiy_fmt = cl_gr_numfmt('rci_file','rci11',sr1.azi04)
           PRINTX sr2.*,l_feiy_fmt
            
END REPORT
###GENGRE###END
