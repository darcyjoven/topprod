# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artr140.4gl
# Descriptions...: 條碼列印作業
# Date & Author..: FUN-A80100 10/06/27 By shenyang
# # Modify.........: No.FUN-AA0042 10/10/21 By shenyang
# Modity.........: No.TQC-B70035 11/07/05 By guoch 将l_sql,wc改成STRING類型
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm        RECORD			               # Print condition RECORD
             #       wc     LIKE type_file.chr1000, #TQC-B70035 mark
                    wc     STRING,     #TQC-B70035 add
                     a     LIKE type_file.chr20, 
                    more   LIKE type_file.chr1 
                 END RECORD,                #  FUN-A80100
	   l_flag 		LIKE type_file.num5,    #SMALLINT,
	   l_n	        LIKE type_file.num5,    #SMALLINT,
	   l_no	        LIKE type_file.num5,    
	   g_end		LIKE type_file.num5,    #SMALLINT,
	   g_level_end ARRAY[20] OF LIKE type_file.num5
DEFINE g_oba01      LIKE oba_file.oba01  
DEFINE g_oba02      LIKE oba_file.oba02       
DEFINE g_cnt     LIKE type_file.num10 
DEFINE g_type    LIKE type_file.chr1 
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg     LIKE type_file.chr1000        
DEFINE l_table   STRING    
DEFINE g_sql     STRING
DEFINE g_str     STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "g_oba01.oba_file.oba01,",
                "g_oba02.oba_file.oba02,",
                "oba01.oba_file.oba01,",
                "oba02.oba_file.oba02,",
                "oba11.oba_file.oba11,",
                "oba12.oba_file.oba12,",
                "oba14.oba_file.oba14,",
                "oba13.oba_file.oba13,",
                "l_no.type_file.num5,",  
                "obaacti.oba_file.obaacti,",
                "p_level.type_file.num5"
                
    LET l_table = cl_prt_temptable('artr110',g_sql) CLIPPED 
    
    IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?)"                                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                                                                        
       EXIT PROGRAM                                                                                                                 
    END IF
   
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)   
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B80085--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r110_tm(0,0)        # Input print condition
      ELSE CALL r110()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--

END MAIN  

FUNCTION r110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE l_cmd		LIKE type_file.chr1000,       
          p_row         LIKE type_file.num5,          
          p_col         LIKE type_file.num5           
 
   LET p_row = 6 LET p_col = 17
 
   OPEN WINDOW r110_w AT p_row,p_col WITH FORM "art/42f/artr110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
       CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a = '10'
 

WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oba01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
       

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
       ON ACTION controlp
            IF INFIELD(oba01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oba01
               NEXT FIELD oba01
            END IF 
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
# LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')     
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.more
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
      BEFORE INPUT
      CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a <0  then   NEXT FIELD a   END IF

     AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     IF INT_FLAG THEN EXIT INPUT END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='artr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artr110','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                       # " '",g_lang CLIPPED,"'", 
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",                
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('artr110',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r110()
   ERROR ""
END WHILE
   CLOSE WINDOW r110_w
END FUNCTION

FUNCTION r110()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        
      #    l_sql 	LIKE type_file.chr1000,	  #TQC-B70035  mark
          l_time    LIKE type_file.chr8,         
          l_za05    LIKE type_file.chr1000,
          l_chr	     LIKE type_file.chr1,
          p_level	 LIKE type_file.num5,
          l_oba13    LIKE oba_file.oba13,
          l_azp02    LIKE oba_file.oba13
   DEFINE  l_str      STRING,
          sr            RECORD
                       oba01    LIKE oba_file.oba01,
                       oba02    LIKE oba_file.oba02,
                       oba11    LIKE oba_file.oba11,
                       oba12    LIKE oba_file.oba12,
                       oba14    LIKE oba_file.oba14,
                       oba13    LIKE oba_file.oba13,
                       obaacti  LIKE oba_file.obaacti
                        END RECORD ,
          sr_null     RECORD
                       oba01    LIKE oba_file.oba01,
                       oba02    LIKE oba_file.oba02,
                       oba11    LIKE oba_file.oba11,
                       oba12    LIKE oba_file.oba12,
                       oba14    LIKE oba_file.oba14,
                       oba13    LIKE oba_file.oba13,
                       obaacti  LIKE oba_file.obaacti
                      END RECORD
    DEFINE  l_sql    STRING           #TQC-B70035

     CALL cl_del_data(l_table)   
     
     # FUN-B80085--start mark-----------------------
     #CALL cl_used(g_prog,g_time,1) RETURNING g_time
     # FUN-B80085--end mark-----------------------
      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'artr110'
     IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 160 END IF
  #   FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '-' END FOR
     FOR  g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cccuser', 'cccgrup')
     
 #    LET l_sql="SELECT oba13 ",
 #              "FROM  oba_file ",
 #              " WHERE   ",tm.wc CLIPPED  
 #        PREPARE sel_oba13_pre FROM l_sql
 #       EXECUTE sel_oba13_pre INTO l_oba13

    
  #  IF cl_null(l_oba13) OR  l_oba13 = '' THEN  
  #      LET l_sql = "SELECT unique oba01,oba02,oba11,oba14,obaacti ",
  #                  " FROM oba_file ",
  #                  " WHERE  ((oba13 IS NULL) OR (oba13='')) AND ",tm.wc CLIPPED
  #    ELSE
  #      LET l_sql = "SELECT unique oba01,oba02,oba11,oba14,obaacti ",
  #                   " FROM oba_file ",
  #                   " WHERE  ",tm.wc CLIPPED,
  #                   "  AND  oba13 NOT IN (SELECT oba01 FROM oba_file WHERE ",tm.wc CLIPPED," )"
  #   END IF   
 
 
    LET l_sql = "SELECT unique oba01,oba02,oba11,oba14,obaacti ",
                     "FROM oba_file ",
                     " WHERE  ",tm.wc CLIPPED,
                     "  AND  (oba13 NOT IN (SELECT oba01 FROM oba_file WHERE ",tm.wc CLIPPED," ) OR oba13 IS NULL)"


    PREPARE r110_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
 #      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE r110_curs1 CURSOR FOR r110_prepare1
    INITIALIZE sr_null.* TO NULL  

   LET g_pageno = 1
   LET p_level = 0 
   LET l_no = 0  
   FOREACH r110_curs1 INTO sr.oba01,sr.oba02,sr.oba11,sr.oba14,sr.obaacti
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

       LET g_oba01=sr.oba01
       LET g_oba02=sr.oba02
       LET g_pageno = 0
       LET g_end = 0
       EXECUTE  insert_prep  USING                                 # FUN-AA0042 
      g_oba01,g_oba02,sr.oba01,sr.oba02,sr.oba11,
      sr.oba12,sr.oba14,sr.oba13,l_no,sr.obaacti,p_level
       CALL r110_bom(0,sr.oba01)
       LET g_end = 1
     
   END FOREACH

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.wc,";",tm.a
   CALL cl_prt_cs3('artr110','artr110',l_sql,g_str) 

   # FUN-B80085--start mark-----------------------
   # CALL cl_used(g_prog,g_time,2) RETURNING g_time
   # FUN-B80085--end mark----------------------- 
END FUNCTION

FUNCTION r110_bom(p_level,p_key)
        DEFINE l_plant   LIKE  azp_file.azp01
        DEFINE  p_level LIKE type_file.num5,       
                p_key   LIKE oba_file.oba13,
                i,j         LIKE type_file.num5, 
                l_oba01     LIKE oba_file.oba01,
                l_oba02     LIKE oba_file.oba02,
                l_oba13     LIKE oba_file.oba13,
                l_time      LIKE type_file.num5,      
                l_count     LIKE type_file.num5,       
              #  l_sql       LIKE type_file.chr1000,    #TQC-B70035  mark
                sr DYNAMIC ARRAY OF RECORD
                       oba01    LIKE oba_file.oba01,
                       oba02    LIKE oba_file.oba02,
                       oba11    LIKE oba_file.oba11,
                       oba12    LIKE oba_file.oba12,
                       oba14    LIKE oba_file.oba14,
                       oba13    LIKE oba_file.oba13,
                       obaacti  LIKE oba_file.obaacti
                        END RECORD
        DEFINE  l_sql    STRING    #TQC-B70035
      INITIALIZE  sr[100].*   TO NULL 
      LET l_sql =  "SELECT   oba01,oba02,oba11,'',oba14,'',obaacti ",
                   "FROM oba_file ",
                   " WHERE oba13 = '",p_key ,"' ",
                   " ORDER BY oba13 "

       PREPARE bom_prepare FROM l_sql
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--
          EXIT PROGRAM
        END IF
        DECLARE bom_cs CURSOR FOR bom_prepare
        LET p_level = p_level + 1
        IF p_level > 20  THEN RETURN END IF
        LET l_count = 1
        FOREACH bom_cs INTO sr[l_count].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('bom_cs',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           LET  l_count = l_count + 1
        END FOREACH
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
        FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF  
          LET l_no = l_no + 1 
    EXECUTE insert_prep USING 
         g_oba01,g_oba02,sr[i].oba01,sr[i].oba02,sr[i].oba11,
         sr[i].oba12,sr[i].oba14,sr[i].oba13,l_no,sr[i].obaacti,p_level           
     SELECT oba01 FROM oba_file
                       WHERE oba13 = sr[i].oba01
                       AND oba01 != sr[i].oba01
          
                       
          IF status != NOTFOUND AND p_level < tm.a  THEN 
            CALL r110_bom(p_level,sr[i].oba01)
          END IF
        END FOR
END FUNCTION
          
