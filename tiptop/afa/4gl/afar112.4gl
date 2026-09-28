# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: afar112.4gl
# Desc/riptions..: 固定資產族群編號異動申請單
# Date & Author..: 11/10/03  FUN-B70092 By Sakura
# Modify.........: No:FUN-BB0163 12/01/13 By Sakura l_sql/tm.wc-->STRING,修改l_sql中order by位置


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD				# Print condition RECORD
       #wc     	LIKE type_file.chr1000,		# Where condition #FUN-BB0163 mark
       wc     	STRING, #FUN-BB0163 add       
       a        LIKE type_file.chr1,        
       b      	LIKE type_file.chr1,         
       more     LIKE type_file.chr1         
       END RECORD,
        g_zo       RECORD LIKE zo_file.*
DEFINE  g_i        LIKE type_file.num5     #count/index for any purpose       
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING

MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  

   LET g_sql ="fbo01.fbo_file.fbo01,",
              "fbo02.fbo_file.fbo02,",
              "fbo03.fbo_file.fbo03,",
              "fbo04.fbo_file.fbo04,",
              "fbo05.fbo_file.fbo05,",
              "fbp02.fbp_file.fbp02,",
              "fbp03.fbp_file.fbp03,",
              "fbp031.fbp_file.fbp031,",
              "faj06.faj_file.faj06,",
              "fbp04.fbp_file.fbp04,",
              "fbp05.fbp_file.fbp05,",
              "gen02.gen_file.gen02,",
              "gem02.gem_file.gem02,"
   LET l_table = cl_prt_temptable('afar112',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF


   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r112_tm(0,0)		# Input print condition
      ELSE CALL afar112()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r112_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE   p_row,p_col   LIKE type_file.num5,         
            l_cmd         LIKE type_file.chr1000      

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW r112_w AT p_row,p_col WITH FORM "afa/42f/afar112"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defbllt condition
   LET tm.a    = '2'
   LET tm.b    = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fbo01,fbo02,fbo03,fbo04,fbo05

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

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
         LET INT_FLAG = 0 CLOSE WINDOW r112_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF

      INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)


         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[123]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW r112_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afar112'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar112','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'", 
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'",           
                            " '",g_rpt_name CLIPPED,"'"          
            CALL cl_cmdat('afar112',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r112_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar112()
      ERROR ""
   END WHILE

   CLOSE WINDOW r112_w
END FUNCTION
 
FUNCTION afar112()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name      
          l_gem02       LIKE gem_file.gem02,           #部門名稱     
          l_gen02       LIKE gen_file.gen02,           #申請人名稱    
          #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #FUN-BB0163 mark
          l_sql 	STRING, #FUN-BB0163 add      
          l_chr		LIKE type_file.chr1,         
          l_za05	LIKE type_file.chr1000,
          sr   RECORD
                     fbo01     LIKE fbo_file.fbo01,    #異動單號
                     fbo02     LIKE fbo_file.fbo02,    #日期
                     fbo03     LIKE fbo_file.fbo03,    #申請人
                     fbo04     LIKE fbo_file.fbo04,    #申請部門
                     fbo05     LIKE fbo_file.fbo05,    #申請日期
                     fbp02     LIKE fbp_file.fbp02,    #項次
                     fbp03     LIKE fbp_file.fbp03,    #財產編號
                     fbp031    LIKE fbp_file.fbp031,   #附號
                     faj06     LIKE faj_file.faj06,    #中文名稱
                     fbp04     LIKE fbp_file.fbp04,    #原族群編號
                     fbp05     LIKE fbp_file.fbp05     #變更後族群編號 
        END RECORD

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)

     #====>資料權限的檢查
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')

     LET l_sql = "SELECT fbo01,fbo02,fbo03,fbo04,fbo05,",
                 "       fbp02,fbp03,fbp031,",
                 "       faj06,fbp04,fbp05,",
                 "       '','' ",
                 "  FROM fbo_file,fbp_file, OUTER faj_file  ",
                 " WHERE fbo01 = fbp01 ",
                 "   AND fboconf !='X' ",        
                 "   AND fbp03=faj02 ",
                 "   AND fbp031=faj022 ",
                 "   AND ",tm.wc CLIPPED
                 #" ORDER BY fbp02 " #FUN-BB0163 mark

     IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fboconf='Y' " END IF
     IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fboconf='N' " END IF
     IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND fbopost='Y' " END IF
     IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND fbopost='N' " END IF
     LET l_sql = l_sql CLIPPED," ORDER BY fbp02 " #FUN-BB0163 add
     PREPARE r112_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE r112_cs1 CURSOR FOR r112_prepare1

     FOREACH r112_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

      LET l_gen02=' '
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fbo03
      LET l_gem02=' '
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fbo04
      EXECUTE insert_prep USING sr.*,l_gen02,l_gem02

     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fbo01,fbo02,fbo03,fbo04,fbo05')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05

     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

     CALL cl_prt_cs3('afar112','afar112',l_sql,g_str)

END FUNCTION
#FUN-B70092
