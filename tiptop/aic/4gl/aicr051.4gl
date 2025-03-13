# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aicr051.4gl
# Descriptions...: ICD
# FUN-A20012 ---By chenls
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正 

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5
END GLOBALS

   DEFINE tm  RECORD
        wc      STRING,                      # Where condition
#        s       LIKE type_file.chr3,         # Order by sequence
#        t       LIKE type_file.chr3,         # Eject sw
#        u       LIKE type_file.chr3,         # Group total sw
#        exm     LIKE type_file.chr1,
#        d       LIKE type_file.chr1,
        more    LIKE type_file.chr1          # Input more condition(Y/N)
      END RECORD,
          l_pmh08        LIKE pmh_file.pmh08,
          g_orderA       ARRAY[3] OF LIKE type_file.chr50
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sql           STRING
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_date1         LIKE idd_file.idd08
DEFINE   g_date2         LIKE idd_file.idd08
DEFINE   g_t             LIKE type_file.chr1
MAIN
   OPTIONS
#       FORM LINE     FIRST + 2,
#       MESSAGE LINE  LAST,
#       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF

   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql = #"order1.type_file.chr50,",
               #"order2.type_file.chr50,",
               #"order3.type_file.chr50,",
#               "order.type_file.chr50,",
               "idd01.idd_file.idd01,",
               "idd05.idd_file.idd05,",
               "idd06.idd_file.idd06,",
               "idd10.idd_file.idd10,",
               "idd11.idd_file.idd11,",
               "idd19.idd_file.idd19,",
               "ima02.ima_file.ima02,",
	       "ima021.ima_file.ima021"	
   LET l_table = cl_prt_temptable('aicr051',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#   LET tm.s  = ARG_VAL(8)
#   LET tm.t  = ARG_VAL(9)
#   LET tm.u  = ARG_VAL(10)
#   LET tm.exm= ARG_VAL(11)
#   LET tm.d  = ARG_VAL(12)
   LET g_t = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No:FUN-7C0078
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r051_tm(0,0)                        # Input print condition
   ELSE 
      CALL aicr051()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN

FUNCTION r051_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 15

   OPEN WINDOW r051_w AT p_row,p_col WITH FORM "aic/42f/aicr051"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
#FUN-A20012
#   LET tm.s    = '123'
#   LET tm.t    = 'NNN'
#   LET tm.u    = 'NNN'
#   LET tm.exm  = '1'
#   LET tm.d    = '1'
   LET g_t = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

#   LET tm2.s1   = tm.s[1,1]
#   LET tm2.s2   = tm.s[2,2]
#   LET tm2.s3   = tm.s[3,3]
#   LET tm2.t1   = tm.t[1,1]
#   LET tm2.t2   = tm.t[2,2]
#   LET tm2.t3   = tm.t[3,3]
#   LET tm2.u1   = tm.u[1,1]
#   LET tm2.u2   = tm.u[2,2]
#   LET tm2.u3   = tm.u[3,3]
#   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
#   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
#   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
#   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
#   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
#   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
#   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
#   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
#   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF

WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON idd01,idd02,idd03,idd04,
                              idd05,idd06,idd07,idd15,idd16,idd17 
      BEFORE CONSTRUCT
             CALL cl_qbe_init()

      ON ACTION CONTROLP
#            IF INFIELD(idd01) THEN
         CASE
            WHEN INFIELD(idd01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_idd"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO idd01
               NEXT FIELD idd01 
#            END IF

            WHEN INFIELD(idd02)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_imd1"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO idd02                             
               NEXT FIELD idd02

            WHEN INFIELD(idd03)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ime4_1"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO idd03                             
               NEXT FIELD idd03

            WHEN INFIELD(idd15)                                                 
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_imaicd1"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO idd15                             
               NEXT FIELD idd15
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
      CLOSE WINDOW r051_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#   INPUT BY NAME
   INPUT g_date1,g_date2,g_t,tm.more FROM FORMONLY.date1,FORMONLY.date2,FORMONLY.t,FORMONLY.more
#         ,tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
#         tm2.u1,tm2.u2,tm2.u3,tm.more
#         tm.exm,tm.d,tm.more
#         WITHOUT DEFAULTS
         ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
      BEFORE INPUT
             LET g_date1 = g_today
             LET g_date2 = g_today
             DISPLAY g_date1,g_date2 TO FORMONLY.date1,FORMONLY.date2
             CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      AFTER INPUT
#         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
#         LET tm.t = tm2.t1,tm2.t2,tm2.t3
#         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      CLOSE WINDOW r051_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aicr051'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr051','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No:FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_t CLIPPED,"'",
#                         " '",tm.s CLIPPED,"'",
#                         " '",tm.t CLIPPED,"'",
#                         " '",tm.u CLIPPED,"'",
#                         " '",tm.exm CLIPPED,"'",
#                         " '",tm.d  CLIPPED,"'"   ,
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('aicr051',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r051_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr051()
   ERROR ""
END WHILE
   CLOSE WINDOW r051_w
END FUNCTION
 
FUNCTION aicr051()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
          l_time    LIKE type_file.chr8,        # Used time for running the job
          l_sql     STRING,                     # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE type_file.chr50,
          l_pmm22   LIKE pmm_file.pmm22,
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_order    ARRAY[6] OF LIKE type_file.chr50,
          sr               RECORD #order1 LIKE type_file.chr50,
                                  #order2 LIKE type_file.chr50,
                                  #order3 LIKE type_file.chr50,
#                                  order  LIKE type_file.chr50,
                                  idd01  LIKE idd_file.idd01,
                                  idd05  LIKE idd_file.idd05,
                                  idd06  LIKE idd_file.idd06,
                                  idd10  LIKE idd_file.idd10,
                                  idd11  LIKE idd_file.idd11,
                                  idd19  LIKE idd_file.idd19, 
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5
     DEFINE i                  LIKE type_file.num5
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE l_bmb03            LIKE bmb_file.bmb03
     DEFINE l_sfa02            LIKE sfa_file.sfa02
     DEFINE l_pkg              LIKE type_file.chr50
     DEFINE l_type             LIKE type_file.chr12
     DEFINE l_date             STRING

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?, ?, ?, ?, ? ,? ,? ,? )"                                                          
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time     #FUN-B90044   MARK
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115 INTO g_sma115 FROM sma_file
     SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05
       FROM azi_file
      WHERE azi01=g_aza.aza17

#    IF g_priv2='4' THEN
#       LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
#    END IF
#    IF g_priv3='4' THEN
#        LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
#    END IF

#    IF g_priv3 MATCHES "[5678]" THEN
#        LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
#    END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')

     CASE
        WHEN NOT cl_null(g_date1) AND NOT cl_null(g_date2)
             LET l_date = "idd08 BETWEEN '",g_date1,"' AND '",g_date2,"'"
        WHEN cl_null(g_date1) AND NOT cl_null(g_date2)
             LET l_date = "idd08 <= '",g_date2,"'"
        WHEN NOT cl_null(g_date1) AND cl_null(g_date2)
             LET l_date = "idd08 >= '",g_date1,"'"
     END CASE
     LET l_sql = "SELECT idd01,idd05,idd06,idd10,idd11,idd19,'','' ",
                 " FROM idd_file",
                 " WHERE idd12 = '1' ",
                 "   AND ",l_date,
                 "   AND ",tm.wc CLIPPED

     PREPARE r051_prepare1 FROM l_sql
     IF STATUS != 0 THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     DECLARE r051_cs1 CURSOR FOR r051_prepare1
     IF STATUS != 0 THEN
        CALL cl_err('declare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     
     FOREACH r051_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.idd01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.idd02
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.idd03
#	       WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.idd04
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       IF g_t = 'Y' THEN
#          LET sr.order = sr.idd01
#       ELSE
#          LET sr.order = '-'
#       END IF
       SELECT ima02,ima021 INTO l_ima02,l_ima021 
                           FROM ima_file WHERE ima01=sr.idd01
       IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
       END IF
       
       EXECUTE insert_prep USING
#                   sr.order,sr.idd01,sr.idd05,
                   sr.idd01,sr.idd05,
                   sr.idd06,sr.idd10,sr.idd11,sr.idd19,l_ima02,l_ima021
     END FOREACH
     LET l_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str= ''
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
     IF g_zz05 = 'Y' THEN                                                                                                          
       CALL cl_wcchp(tm.wc,'idd01,idd02,idd03,idd04,idd05,
                           idd06,idd07,idd15,idd16,idd17')                                                                                               
            RETURNING tm.wc 
       LET g_str = tm.wc
     END IF
#     LET g_str =g_str,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
     LET g_str = g_str,";",g_t
     CALL cl_prt_cs3('aicr051','aicr051',l_sql,g_str)
END FUNCTION
