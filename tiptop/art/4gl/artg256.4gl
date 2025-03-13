# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artg256.4gl
# Descriptions...: 營運中心調撥單列印作業
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B60153 11/06/29 by huangtao
# Date & Author..: No.FUN-C40071 12/04/25 by lixh1


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           wc        STRING,
           type1     LIKE type_file.chr1,
           cb1       LIKE type_file.chr1,
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD
DEFINE g_wc          STRING 
DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING



###GENGRE###START
TYPE sr1_t RECORD
    ruo01 LIKE ruo_file.ruo01,
    ruo011 LIKE ruo_file.ruo011,
    ruo07 LIKE ruo_file.ruo07,
    ruo08 LIKE ruo_file.ruo08,
    gen02 LIKE gen_file.gen02,
    ruo04 LIKE ruo_file.ruo04,
    azw081 LIKE azw_file.azw08,
    ruo05 LIKE ruo_file.ruo05,
    azw082 LIKE azw_file.azw08,
    ruo10 LIKE ruo_file.ruo10,
    ruo12 LIKE ruo_file.ruo12,
    ruo02 LIKE ruo_file.ruo02,
    ruo03 LIKE ruo_file.ruo03,
    ruoconf LIKE ruo_file.ruoconf,
    ruo901 LIKE ruo_file.ruo901,
    ruo09 LIKE ruo_file.ruo09,
    rup02 LIKE rup_file.rup02,
    rup03 LIKE rup_file.rup03,
    ima02 LIKE ima_file.ima02,
    rup07 LIKE rup_file.rup07,
    rup19 LIKE rup_file.rup19,
    rup12 LIKE rup_file.rup12,
    rup09 LIKE rup_file.rup09,
    rup10 LIKE rup_file.rup10,
#   rup11 LIKE rup_file.rup12,   #FUN-C40071 mark
    rup11 LIKE rup_file.rup11,   #FUN-C40071 add 
    rup16 LIKE rup_file.rup16,
    rup13 LIKE rup_file.rup13,
    rup14 LIKE rup_file.rup14,
    rup15 LIKE rup_file.rup15
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
   LET tm.type1 = ARG_VAL(8)
   LET tm.cb1  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "ruo01.ruo_file.ruo01,",
               "ruo011.ruo_file.ruo011,",
               "ruo07.ruo_file.ruo07,",
               "ruo08.ruo_file.ruo08,",
               "gen02.gen_file.gen02,",
               
               "ruo04.ruo_file.ruo04,",
               "azw081.azw_file.azw08,",
               "ruo05.ruo_file.ruo05,",
               "azw082.azw_file.azw08,",
               "ruo10.ruo_file.ruo10,",
               
               "ruo12.ruo_file.ruo12,",
               "ruo02.ruo_file.ruo02,",
               "ruo03.ruo_file.ruo03,",
               "ruoconf.ruo_file.ruoconf,",
               "ruo901.ruo_file.ruo901,",
               
               "ruo09.ruo_file.ruo09,",
               "rup02.rup_file.rup02,",
               "rup03.rup_file.rup03,",
               "ima02.ima_file.ima02,",
               "rup07.rup_file.rup07,",
               
               "rup19.rup_file.rup19,",
               "rup12.rup_file.rup12,",
               "rup09.rup_file.rup09,",
               "rup10.rup_file.rup10,",
             # "rup11.rup_file.rup12,",    #FUN-C40071 mark
               "rup11.rup_file.rup11,",    #FUN-C40071
               
               "rup16.rup_file.rup16,",
               "rup13.rup_file.rup13,",
               "rup14.rup_file.rup14,",
               "rup15.rup_file.rup15"
     
    LET l_table = cl_prt_temptable('artg256',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,",
                       "?,?,?,?,?,?,?,?,?,?,",
                       "?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artg256_tm()        # Input print condition
    ELSE 
       CALL artg256() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
    CALL cl_gre_drop_temptable(l_table)       #FUN-C40071
END MAIN

FUNCTION artg256_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          STRING,   
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE  l_n1           LIKE type_file.num5
DEFINE l_sql          STRING


   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artg256_w AT p_row,p_col WITH FORM "art/42f/artg256" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type1 = '5'
   LET tm.cb1 = 'N' 
   
   WHILE TRUE

      CONSTRUCT BY NAME tm.wc ON ruo01,ruo011,ruo07

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale 
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION controlp  
           CASE 
             WHEN INFIELD(ruo01)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ruo01"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruo01
               NEXT FIELD ruo01 
             WHEN INFIELD(ruo011)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ruo011"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruo011
               NEXT FIELD ruo011 
          END CASE
              
                   
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
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg256_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)       #FUN-C40071
         EXIT PROGRAM
      END IF 
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      INPUT BY NAME  tm.type1,tm.cb1,tm.more WITHOUT DEFAULTS 
         BEFORE INPUT 
           CALL cl_qbe_display_condition(lc_qbe_sn)
            
         ON ACTION CONTROLR
             CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

#FUN-B50163 -------------STA
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT INPUT
#FUN-B50163 -------------END         
         ON ACTION about        
            CALL cl_about()     
 
         ON ACTION help         
            CALL cl_show_help()  
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg256_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)       #FUN-C40071
         EXIT PROGRAM
      END IF 

#FUN-B50163 -------------STA
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#FUN-B50163 -------------END
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg256'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artg256','9031',1)
         ELSE
            LET l_cmd = l_cmd1 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'",
                       " '",tm.type1 CLIPPED,"'" ,
                       " '",tm.cb1 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg256',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg256_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)       #FUN-C40071
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg256()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg256_w
    
END FUNCTION


FUNCTION artg256() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD 
                  ruo01 LIKE ruo_file.ruo01,
                  ruo011 LIKE ruo_file.ruo011,
                  ruo07 LIKE ruo_file.ruo07,
                  ruo08 LIKE ruo_file.ruo08,
                  ruo04 LIKE ruo_file.ruo04,
                  ruo05 LIKE ruo_file.ruo05,
                  ruo10 LIKE ruo_file.ruo10,
                  ruo12 LIKE ruo_file.ruo12,
                  ruo02 LIKE ruo_file.ruo02,
                  ruo03 LIKE ruo_file.ruo03,
                  ruoconf LIKE ruo_file.ruoconf,
                  ruo901 LIKE ruo_file.ruo901,
                  ruo09 LIKE ruo_file.ruo09,
                  rup02 LIKE rup_file.rup02,
                  rup03 LIKE rup_file.rup03,
                  rup07 LIKE rup_file.rup07,
                  rup19 LIKE rup_file.rup19,
                  rup12 LIKE rup_file.rup12,
                  rup09 LIKE rup_file.rup09,
                  rup10 LIKE rup_file.rup10,
                  rup11 LIKE rup_file.rup12,
                  rup16 LIKE rup_file.rup16,
                  rup13 LIKE rup_file.rup13,
                  rup14 LIKE rup_file.rup14,
                  rup15 LIKE rup_file.rup15
                    END RECORD
       
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE l_azw081     LIKE azw_file.azw08
DEFINE l_azw082     LIKE azw_file.azw08
DEFINE l_ima02      LIKE ima_file.ima02

    INITIALIZE sr.* TO NULL
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    LET l_sql = " SELECT ruo01,ruo011,ruo07,ruo08,ruo04,ruo05,ruo10,ruo12,ruo02,",
                " ruo03,ruoconf,ruo901,ruo09,rup02,rup03,rup07,rup19,rup12,rup09,",
                " rup10,rup11,rup16,rup13,rup14,rup15 ",
                " FROM ruo_file LEFT JOIN rup_file ON ruo01 = rup01 AND ruoplant = rupplant",
                " WHERE  ruoplant = '",g_plant,"'",
                " AND ",tm.wc
    CASE tm.type1
      WHEN '0' LET l_sql = l_sql," AND ruoconf = '0'"
      WHEN '1' LET l_sql = l_sql," AND ruoconf = '1'"
      WHEN '2' LET l_sql = l_sql," AND ruoconf = '2'"
      WHEN '3' LET l_sql = l_sql," AND ruoconf = '3'"
      WHEN '4' LET l_sql = l_sql," AND ruoconf = '4'"
      OTHERWISE LET l_sql = l_sql
    END CASE
    IF tm.cb1 = 'Y' THEN
       LET  l_sql = l_sql," AND ruo15  = 'Y' "
    ELSE
       LET  l_sql = l_sql," AND ruo15  = 'N' "
    END IF
    PREPARE pre_ruo FROM l_sql
    DECLARE sel_ruo CURSOR FOR pre_ruo
    FOREACH sel_ruo INTO sr.*
        IF NOT cl_null(sr.ruo08) THEN
           SELECT gen02 INTO l_gen02 FROM gen_file
            WHERE gen01 = sr.ruo08
        ELSE
           LET l_gen02 = ' '
        END IF
        SELECT azw08 INTO l_azw081 FROM azw_file
         WHERE azw01 = sr.ruo04 AND azwacti = 'Y'
        SELECT azw08 INTO l_azw082 FROM azw_file
         WHERE azw01 = sr.ruo05 AND azwacti = 'Y'
        SELECT ima02 INTO l_ima02 FROM ima_file
        WHERE ima01 = sr.rup03
        IF cl_null(l_ima02) OR STATUS THEN 
           LET l_ima02 = ' '
        END IF        
 
        EXECUTE insert_prep USING sr.ruo01,sr.ruo011,sr.ruo07,sr.ruo08,l_gen02,
                                  sr.ruo04,l_azw081,sr.ruo05,l_azw082,sr.ruo10,
                                  sr.ruo12,sr.ruo02,sr.ruo03,sr.ruoconf,sr.ruo901,
                                  sr.ruo09,sr.rup02,sr.rup03,l_ima02,sr.rup07,
                                  sr.rup19,sr.rup12,sr.rup09,sr.rup10,sr.rup11,
                                  sr.rup16,sr.rup13,sr.rup14,sr.rup15
                                  
    END FOREACH

    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY ruo01,rup02 "
    LET g_str = ''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ruo01,ruo011,ruo07')
             RETURNING tm.wc
        LET g_str = tm.wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
   LET g_str = g_str,";",tm.type1,";",tm.cb1
#  CALL cl_prt_cs1('artg256','artg256',l_sql,g_str)  #FUN-C40071 mark  
   CALL artg256_grdata()                             #FUN-C40071
END FUNCTION
#No.FUN-B60153

###GENGRE###START
FUNCTION artg256_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg256")
        IF handler IS NOT NULL THEN
            START REPORT artg256_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ruo01,rup02 "     #FUN-C40071      
          
            DECLARE artg256_datacur1 CURSOR FROM l_sql
            FOREACH artg256_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg256_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg256_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg256_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno   LIKE type_file.num5
    DEFINE l_ruo02    STRING   #FUN-C40071
    DEFINE l_ruoconf  STRING   #FUN-C40071

    
    ORDER EXTERNAL BY sr1.ruo01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ruo01
            LET l_lineno = 0
        #FUN-C40071 ------------Begin-------------
            LET l_ruo02 = cl_gr_getmsg("gre-266",g_lang,sr1.ruo02)
            PRINTX l_ruo02
            LET l_ruoconf = cl_gr_getmsg("gre-267",g_lang,sr1.ruoconf)
            PRINTX l_ruoconf 
        #FUN-C40071 ------------End---------------   
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.ruo01

        
        ON LAST ROW

END REPORT
###GENGRE###END
