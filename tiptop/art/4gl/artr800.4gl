# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: artr800.4gl
# Descriptions...: 專櫃對帳單-依日期與抽成代碼
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B50152 11/05/25 by huangtao
# Modify.........: No.FUN-B60054 11/06/09 By huangtao 傳入的資料狀態為空時，可以打印全部資料
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)


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
               "rci04_5.type_file.chr20,",
               "rci06.rci_file.rci06,",
               "rcd02.rcd_file.rcd02,",
               "rce06.rce_file.rce06,",
               "chouc.rce_file.rce06,",
               "yings.rce_file.rce06,",
               "occ18.occ_file.occ18,",
               "occ11.occ_file.occ11,",
               "occ231.occ_file.occ231,",
               "feiys.rci_file.rci11,",
               "num.type_file.num5,",
               "azi04.azi_file.azi04"
           
    LET l_table = cl_prt_temptable('artr800',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "rch01.rch_file.rch01,",
                "rci10.rci_file.rci10,",
                "oaj02.oaj_file.oaj02,",
                "feiy.rci_file.rci11"
    LET l_table1 = cl_prt_temptable('artr8001',g_sql) CLIPPED
    IF l_table1=-1 THEN EXIT PROGRAM END IF  
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artr800_tm()        # Input print condition
    ELSE 
       CALL artr800() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artr800_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artr800_w AT p_row,p_col WITH FORM "art/42f/artr800" 
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
         LET INT_FLAG = 0 CLOSE WINDOW artr800_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
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
         LET INT_FLAG = 0 CLOSE WINDOW artr800_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr800'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artr800','9031',1)
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
            CALL cl_cmdat('artr800',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr800()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr800_w

END FUNCTION

FUNCTION artr800()
DEFINE    l_sql     STRING ,                    
          l_chr     LIKE type_file.chr1,       
          sr        RECORD 
                    rch01  LIKE rch_file.rch01,
                    rch05  LIKE rch_file.rch05,
                    rch06  LIKE rch_file.rch06,
                    rch071 LIKE rch_file.rch071,
                    rci04  LIKE rci_file.rci04,
                    rci05  LIKE rci_file.rci05,
                    rci06  LIKE rci_file.rci06
                    END RECORD,
          sr1       RECORD 
                    rcd02  LIKE rcd_file.rcd02,
                    rce06  LIKE rce_file.rce06
                    END RECORD
DEFINE  l_flag   LIKE type_file.chr1
DEFINE  l_str    STRING
DEFINE  l_azw08  LIKE azw_file.azw08
DEFINE  l_days   LIKE type_file.num5
DEFINE  l_bdate  LIKE type_file.dat 
DEFINE  l_edate  LIKE type_file.dat 
DEFINE  l_rcb02  LIKE rcb_file.rcb02
DEFINE  l_rcb03  LIKE rcb_file.rcb03
DEFINE  l_chouc  LIKE rce_file.rce06
DEFINE  l_yings  LIKE rce_file.rce06
DEFINE  l_azi04  LIKE azi_file.azi04
DEFINE  l_rci04_5 LIKE type_file.chr20
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
DEFINE  l_num   LIKE type_file.num5
DEFINE  l_num1   LIKE type_file.num5
DEFINE  l_num2   LIKE type_file.num5

    CREATE TEMP TABLE artr800_tmp(
                    rch01 LIKE rch_file.rch01,
                    rci10 LIKE rci_file.rci10,
                    feiy  LIKE rci_file.rci11)
    DELETE FROM artr800_tmp
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--
       EXIT PROGRAM
    END IF    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?)" 
            
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep1:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--
       EXIT PROGRAM
    END IF
    SELECT azi04 INTO l_azi04 FROM azi_file
     WHERE azi01 = g_aza.aza17
    LET l_sql = " SELECT rch01,rch05,rch06,rch071,rci04,rci05,rci06 FROM rch_file,rci_file ",
                " WHERE rch01 = rci01 ",
                " AND rci02 = '1'",
                " AND rch03 = '",tm.yy,"'",
                " AND rch04 = '",tm.mm,"'",
                " AND ",tm.wc,
                " AND rch05 IN ",g_auth
    IF tm.type1 = 'N' THEN
       LET l_sql = l_sql," AND rchconf = 'N'"
#FUN-B60054 ------------STA
#   ELSE                 
    END IF               
    IF tm.type1 = 'Y' THEN
#FUN-B60054 -------------END 
       LET l_sql = l_sql," AND rchconf = 'Y'"
    END IF
    PREPARE artr800_prepare1 FROM l_sql 
    DECLARE artr800_curs1 CURSOR FOR artr800_prepare1
    FOREACH artr800_curs1 INTO sr.* 
      
       SELECT azw08 INTO l_azw08 FROM azw_file
        WHERE azw01 = sr.rch05
       LET l_str = sr.rci05
       LET l_rci04_5 = sr.rci04,"(",l_str.trim(),")"
       SELECT tqa02 INTO l_tqa02 FROM tqa_file
        WHERE tqa01 = sr.rci04
          AND tqa03 = '29'
       SELECT COUNT(*) INTO l_num1 FROM rci_file
        WHERE rci01 = sr.rch01
          AND rci02 = '1'
       SELECT COUNT(*) INTO l_num2 FROM rci_file
        WHERE rci01 = sr.rch01
          AND rci02 = '2'
         IF  l_num1 > l_num2 THEN
            LET l_num = l_num1 
         ELSE
            LET l_num = l_num2
         END IF
       IF tm.cb = 'Y' THEN
          LET l_sql = " SELECT rci10,rci11,rci12 FROM rci_file ",
                      " WHERE rci01 = '",sr.rch01,"'",
                      " AND rci02 = '2'"
          PREPARE artr800_prepare2 FROM l_sql 
          DECLARE artr800_curs2 CURSOR FOR artr800_prepare2
          DELETE FROM artr800_tmp
          FOREACH artr800_curs2 INTO l_rci10,l_rci11,l_rci12 
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
             INSERT INTO artr800_tmp VALUES(sr.rch01,l_rci10,l_feiy)
          END FOREACH  
          SELECT SUM(feiy) INTO l_feiys FROM  artr800_tmp
       END IF 
       LET l_days = cl_days(tm.yy,tm.mm)  
       LET l_bdate = MDY(tm.mm,1,tm.yy)
       LET l_edate = MDY(tm.mm,l_days,tm.yy)
       LET l_sql = "SELECT rcb02,rcb03 ",
                   "  FROM ",cl_get_target_table(sr.rch05,'rcb_file'),
                   " WHERE rcb01 = '",sr.rch05,"' ",
                   "   AND rcb05 = '",sr.rci04,"' ",
                   "   AND rcb08 = '",sr.rci05,"' "
       PREPARE sel_rcb_pre FROM l_sql
       DECLARE sel_rcb_cs CURSOR FOR sel_rcb_pre
       FOREACH sel_rcb_cs INTO l_rcb02,l_rcb03
          LET l_sql = "SELECT rcd02,rce06 ",
                      "  FROM ",cl_get_target_table(sr.rch05,'rcd_file'),",",
                                cl_get_target_table(sr.rch05,'rce_file'),
                      " WHERE rce01 IN (SELECT rcd01 FROM ",cl_get_target_table(sr.rch05,'rcd_file'),
                      "                  WHERE (rcd02 BETWEEN '",l_rcb02,"' ",
                      "                    AND '",l_rcb03,"') ",
                      "                    AND (rcd02 BETWEEN '",l_bdate,"' ",
                      "                    AND '",l_edate,"') ",
                      "                    AND rcdconf = 'Y'",
                      "                    AND rcd04 = '",sr.rci06,"') ",
                      "   AND rcd01 = rce01 ",
                      "   AND rce03 = '",sr.rci04,"'"
          PREPARE sel_rce_pre FROM l_sql
          DECLARE sel_rce_cs CURSOR FOR sel_rce_pre
          FOREACH sel_rce_cs INTO sr1.*
             LET l_chouc = sr1.rce06*sr.rci05/100 
             CALL cl_digcut(l_chouc,l_azi04) RETURNING l_chouc    
             LET l_yings = sr1.rce06 - l_chouc
             SELECT occ18,occ11,occ231 INTO l_occ18,l_occ11,l_occ231 FROM occ_file 
              WHERE occ01 = sr.rch06
                AND occacti = 'Y'

             EXECUTE insert_prep USING sr.rch01,sr.rch05,l_azw08,sr.rch071,
                                sr.rci04,l_tqa02,sr.rci05,l_rci04_5,sr.rci06,sr1.rcd02,
                                sr1.rce06,l_chouc,l_yings,l_occ18,l_occ11,l_occ231,l_feiys,l_num,l_azi04
             
          END FOREACH
       END FOREACH
    END FOREACH    
   

   LET g_str = ''  
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
               
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
   LET g_str = g_str,";",tm.yy,";",tm.mm,';',tm.type1,";",tm.cb,";"
   
   CALL cl_prt_cs3('artr800','artr800',l_sql,g_str)  
 

   
END FUNCTION
#FUN-B50152


   
