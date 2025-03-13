# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almg600.4gl
# Descriptions...: 券流轉狀況統計表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B60004 11/06/02 by huangtao
# Modify.........: No.FUN-CA0152 12/11/14 By xumeimei  GR报表修改


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           wc        STRING,                 #Where condition 
           bdate     LIKE type_file.dat,
           edate     LIKE type_file.dat, 
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD

DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING




###GENGRE###START
TYPE sr1_t RECORD
    lqe02 LIKE lqe_file.lqe02,
    lpx02 LIKE lpx_file.lpx02,
    lrz02 LIKE lrz_file.lrz02,
    type0 LIKE type_file.num10,
    type1 LIKE type_file.num10,
    type2 LIKE type_file.num10,
    type3 LIKE type_file.num10,
    type4 LIKE type_file.num10,
    type5 LIKE type_file.num10,     #FUN-CA0152 add
    type6 LIKE type_file.num10,     #FUN-CA0152 add
    t_count LIKE type_file.num10
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
   LET tm.bdate  = ARG_VAL(8) 
   LET tm.edate  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "lqe02.lqe_file.lqe02,",
               "lpx02.lpx_file.lpx02,",
               "lrz02.lrz_file.lrz02,",
               "type0.type_file.num10,",
               "type1.type_file.num10,",
               "type2.type_file.num10,",
               "type3.type_file.num10,",
               "type4.type_file.num10,",
               "type5.type_file.num10,",     #FUN-CA0152 add
               "type6.type_file.num10,",     #FUN-CA0152 add
               "t_count.type_file.num10"
            
    LET l_table = cl_prt_temptable('almg600',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?)" #FUN-CA0152 add 2?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL almg600_tm()        # Input print condition
    ELSE 
       CALL almg600() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION almg600_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW almg600_w AT p_row,p_col WITH FORM "alm/42f/almg600" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
 

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON lqe02
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT 

            
         ON ACTION controlp
            CASE
               WHEN INFIELD(lqe02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lqe_2"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqe02
                  NEXT FIELD lqe02  
            END CASE
            
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
         LET INT_FLAG = 0 CLOSE WINDOW almg600_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      DISPLAY BY NAME tm.bdate,tm.edate,tm.more
      INPUT BY NAME
                tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS  
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
       
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
         LET INT_FLAG = 0 CLOSE WINDOW almg600_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='almg600'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('almg600','9031',1)
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
                       " '",tm.bdate CLIPPED,"'" ,
                       " '",tm.edate CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('almg600',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW almg600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL almg600()
      ERROR ""
   END WHILE
   CLOSE WINDOW almg600_w

END FUNCTION

FUNCTION almg600()
DEFINE    l_name    LIKE type_file.chr20,             
          l_sql     STRING ,                      
          l_chr     LIKE type_file.chr1,       
          sr        RECORD 
                    lqe02 LIKE lqe_file.lqe02,
                    lpx02 LIKE lpx_file.lpx02,
                    lrz02 LIKE lrz_file.lrz02,
                    type0 LIKE type_file.num10,
                    type1 LIKE type_file.num10,
                    type2 LIKE type_file.num10,
                    type3 LIKE type_file.num10,
                    type4 LIKE type_file.num10,
                    type5 LIKE type_file.num10,    #FUN-CA0152 add
                    type6 LIKE type_file.num10,    #FUN-CA0152 add
                    t_count LIKE type_file.num10
                    END RECORD
DEFINE l_plant   LIKE  azp_file.azp01
DEFINE l_azp02   LIKE  azp_file.azp02
DEFINE l_i       LIKE  type_file.num5
DEFINE l_j       LIKE  type_file.num5
DEFINE l_m       LIKE  type_file.num5
DEFINE  l_str    STRING
DEFINE l_azw08   LIKE azw_file.azw08
DEFINE l_oba02   LIKE oba_file.oba02
DEFINE l_rtg05   LIKE  rtg_file.rtg05
DEFINE l_income  LIKE  type_file.num10
DEFINE l_rux03   LIKE rux_file.rux03
DEFINE l_rux04   LIKE rux_file.rux04
DEFINE l_ima131  LIKE ima_file.ima131
DEFINE l_order1  LIKE type_file.num10

  
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    #FUN-CA0152---------mark------str
    #LET l_sql = "SELECT B.lqe02,lpx02,lrz02,B.type0,B.type1,B.type2,B.type3,B.type4,B.t_count FROM ",
    #           "( SELECT lqe02,lqe03,SUM(type0) AS type0,SUM(type1) AS type1,SUM(type2) AS type2,SUM(type3) AS type3",
    #           ",SUM(type4) AS type4,SUM(t_count) AS t_count FROM ", 
    #           "(SELECT lqe02,lqe03,CASE lqe17 WHEN '0' THEN 1 ELSE 0 END AS type0,",
    #           "CASE lqe17 WHEN '1' THEN 1 ELSE 0 END AS type1,",
    #           "CASE lqe17 WHEN '2' THEN 1 ELSE 0 END AS type2,",
    #           "CASE lqe17 WHEN '3' THEN 1 ELSE 0 END AS type3,",
    #           "CASE lqe17 WHEN '4' THEN 1 ELSE 0 END AS type4,",
    #           "1 AS t_count FROM lqe_file ",
    #FUN-CA0152---------mark------end
    #FUN-CA0152---------add-------str
    LET l_sql ="SELECT B.lqe02,lpx02,lrz02,B.type0,B.type1,B.type2,B.type3,B.type4,B.type5,B.type6,B.t_count FROM ",  #FUN-C60038 add type5,type6
               "( SELECT lqe02,lqe03,SUM(type0) AS type0,SUM(type1) AS type1,SUM(type2) AS type2,SUM(type3) AS type3",
               ",SUM(type4) AS type4,SUM(type5) AS type5,SUM(type6) AS type6,SUM(t_count) AS t_count FROM ",  
               "(SELECT lqe02,lqe03,CASE lqe17 WHEN '0' THEN 1 ELSE 0 END AS type0,",
               "CASE lqe17 WHEN '1' THEN 1 ELSE 0 END AS type1,",   #發售
               "CASE lqe17 WHEN '2' THEN 1 ELSE 0 END AS type2,",   #退回
               "CASE lqe17 WHEN '3' THEN 1 ELSE 0 END AS type3,",   #作廢
               "CASE lqe17 WHEN '4' THEN 1 ELSE 0 END AS type5,",   #已用
               "CASE lqe17 WHEN '6' THEN 1 ELSE 0 END AS type6,",   #回收
               "CASE lqe17 WHEN '7' THEN 1 ELSE 0 END AS type4,",   #核銷 
               "1 AS t_count FROM lqe_file ",
    #FUN-CA0152---------add-------end
               " WHERE ",tm.wc,
               " AND ((lqe20 <= '",tm.edate,"' AND lqe21 >= '",tm.bdate,"')", 
               " OR (lqe20 <= '",tm.edate,"' AND lqe21 IS NULL )))",
               " GROUP BY lqe02,lqe03) B ",
               " LEFT JOIN lpx_file ON lqe02 = lpx01 ",
               " LEFT JOIN lrz_file ON lqe03 = lrz01 ",
               " ORDER BY lqe02,lrz02 " 
    PREPARE almg600_pre FROM l_sql
    DECLARE almg600_cs CURSOR FOR almg600_pre          
    FOREACH almg600_cs INTO sr.*
        IF cl_null(sr.lrz02) THEN
           LET sr.lrz02 = 0
        END IF
        EXECUTE insert_prep USING sr.*
    END FOREACH 
   LET g_str = ''  
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'lqe02')
        RETURNING tm.wc
   LET g_str = tm.wc
   IF g_str.getLength() > 1000 THEN
       LET g_str = g_str.subString(1,600)
       LET g_str = g_str,"..."
   END IF
###GENGRE###   LET g_str = g_str,";",tm.bdate,";",tm.edate
###GENGRE###   CALL cl_prt_cs3('almg600','almg600',l_sql,g_str)  
    CALL almg600_grdata()    ###GENGRE###
    

END FUNCTION
#FUN-B60004


   

###GENGRE###START
FUNCTION almg600_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("almg600")
        IF handler IS NOT NULL THEN
            START REPORT almg600_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE almg600_datacur1 CURSOR FROM l_sql
            FOREACH almg600_datacur1 INTO sr1.*
                OUTPUT TO REPORT almg600_rep(sr1.*)
            END FOREACH
            FINISH REPORT almg600_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT almg600_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_amt    LIKE type_file.num20_6

    
    ORDER EXTERNAL BY sr1.lqe02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.lqe02

        
        ON EVERY ROW
            LET l_amt = sr1.lrz02*sr1.t_count
            PRINTX l_amt
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.lqe02

        
        ON LAST ROW

END REPORT
###GENGRE###END
