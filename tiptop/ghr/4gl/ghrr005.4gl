# Prog. Version..: '5.30.03-12.09.18(00009)'     #
#
# Pattern name...: ghrr005.4gl
# Descriptions...: 员工履历表
# Date & Author..: 13/08/13   by wangxh

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                
            wc     STRING,                
            qj   LIKE type_file.chr1     
           END RECORD               
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING       
DEFINE l_table1    STRING 
DEFINE l_table2    STRING   
DEFINE l_table3    STRING
DEFINE l_table4    STRING 
DEFINE l_table5    STRING 
DEFINE l_table6    STRING                                               
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT               
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
 
   LET g_sql =" hrat01.hrat_file.hrat01,     hrat02.hrat_file.hrat02,     ",
              " hrat17_name.type_file.chr50, hrat15.hrat_file.hrat15,     ",
              " hrat04_name.type_file.chr50, hrat05_name.type_file.chr50, ",
              " hraqa04.hraqa_file.hraqa04,  hrat18.hrat_file.hrat18,     ",
              " hrat22_name.type_file.chr50, hrat23.hrat_file.hrat23,     ",      
              " hrat34_name.type_file.chr50, hrat29_name.type_file.chr50, ",
              " hrat13.hrat_file.hrat13,     hrat24_name.type_file.chr50, ",    
              " hrat49.hrat_file.hrat49,     hrat47.hrat_file.hrat47,     ",
              " hrat46.hrat_file.hrat46,     hrat30.hrat_file.hrat30,     ",
              " hrat32.hrat_file.hrat32 "
   LET l_table = cl_prt_temptable('ghrr005',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
 
   LET g_sql =" hrat01.hrat_file.hrat01,     hrata04.hrata_file.hrata04,  ",
              " hrata05_name.type_file.chr50,hrata02.hrata_file.hrata02,  ",
              " hrata03.hrata_file.hrata03,  hrata06_name.type_file.chr50,",
              " hrata08_name.type_file.chr50 "

   LET l_table1 = cl_prt_temptable('ghrr005_a',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   	
  
   LET g_sql =" hrat01.hrat_file.hrat01,     hratc04.hratc_file.hratc04,  ",
              " hratc05_name.type_file.chr50,hratc06.hratc_file.hratc06,  ",
              " hratc02.hratc_file.hratc02,  hratc03.hratc_file.hratc03,  ",
              " hratc07_name.type_file.chr50,hratc10.hratc_file.hratc10,  ",
              " hratc13.hratc_file.hratc13 "

   LET l_table2 = cl_prt_temptable('ghrr005_b',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   	
   LET g_sql =" hrat01.hrat_file.hrat01,      hratd02.hratd_file.hratd02, ",
              " hratd03_name.type_file.chr50, hratd05.hratd_file.hratd05, ",
              " hratd04.hratd_file.hratd04,   hratd07.hratd_file.hratd07, ",
              " hratd08.hratd_file.hratd08,   hratd09.hratd_file.hratd09  "

   LET l_table3 = cl_prt_temptable('ghrr005_c',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql =" hrat01.hrat_file.hrat01,      hratb04.hratb_file.hratb04, ",
              " hratb05.hratb_file.hratb05,   hratb02.hratb_file.hratb02, ",
              " hratb03.hratb_file.hratb03,   hratb06.hratb_file.hratb06, ",
              " hratb08.hratb_file.hratb08  "

   LET l_table4 = cl_prt_temptable('ghrr005_d',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql =" hrat01.hrat_file.hrat01,      hrath02.hrath_file.hrath02, ",
              " hrath03_name.type_file.chr50, hrath04.hrath_file.hrath04, ",
              " hrath05.hrath_file.hrath05,   hrath06.hrath_file.hrath06, ",
              " hrath08.hrath_file.hrath08,   hrath07.hrath_file.hrath07,  ",
              " hrath09.hrath_file.hrath09 "

   LET l_table5 = cl_prt_temptable('ghrr005_e',g_sql) CLIPPED
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
   
    LET g_sql =" hrat01.hrat_file.hrat01,     hratg02.hratg_file.hratg02,   ",
              "  hratg03.hratg_file.hratg03,  hratg04_name.type_file.chr50, ",
              "  hratg05.hratg_file.hratg05,  hratg06.hratg_file.hratg06    "

   LET l_table6 = cl_prt_temptable('ghrr005_f',g_sql) CLIPPED
   IF l_table6 = -1 THEN EXIT PROGRAM END IF

   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr005_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr005()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr005_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_dir          LIKE type_file.chr1,        
       l_cmd          LIKE type_file.chr1000,      
       l_hrat03       LIKE hrat_file.hrat03,
       l_hrat04       LIKE hrat_file.hrat04
 
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr005_w AT p_row,p_col WITH FORM "ghr/42f/ghrr005"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

#  LET tm.qj = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,hrat01,hrat02,hrar02,hras03,hras06,hras01,hrat19,hrat17

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN
                 NEXT FIELD hrat03
          END IF
       AFTER FIELD hrat04
          LET l_hrat04 = GET_FLDBUF(hrat04)
       ON ACTION controlp
          CASE
   #       	  WHEN INFIELD(hrat03)
   #              CALL cl_init_qry_var()
   #              LET g_qryparam.form = "q_hraa01"
   #              LET g_qryparam.state = "c"
   #              CALL cl_create_qry() RETURNING g_qryparam.multiret
   #              DISPLAY g_qryparam.multiret TO hrat03
   #              NEXT FIELD hrat03
             WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 =l_hrat03
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING l_hrat03
              DISPLAY l_hrat03 TO hrat03
              NEXT FIELD hrat03
             
              WHEN INFIELD(hrat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.arg1 = l_hrat03
               CALL cl_create_qry() RETURNING l_hrat04
               DISPLAY l_hrat04 TO hrat04
               NEXT FIELD hrat04
               
               WHEN INFIELD(hrat01)
               CALL cl_init_qry_var()
               IF NOT cl_null(l_hrat04) AND NOT cl_null(l_hrat03) THEN 
                  LET g_qryparam.form  = "q_hrat01_4"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = l_hrat03
                  LET g_qryparam.arg2 = l_hrat04
               END IF 
               IF NOT cl_null(l_hrat03) AND cl_null(l_hrat04) THEN 
                  LET g_qryparam.form  = "q_hrat01_5"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = l_hrat03
               END IF 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat01
               NEXT FIELD hrat01
               
          	  WHEN INFIELD(hrar02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = '203'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrar02
               NEXT FIELD hrar02
               
               WHEN INFIELD(hras03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrar03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras03
                 NEXT FIELD hras03
                 
               WHEN INFIELD(hras06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '205'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras06
                 NEXT FIELD hras06
               
              WHEN INFIELD(hras01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hras01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras01
                 NEXT FIELD hras01
                 
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat19
                 NEXT FIELD hrat19
                 
               WHEN INFIELD(hrat17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat17
                 NEXT FIELD hrat17                                                              

              OTHERWISE
                 EXIT CASE
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
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.qj                  
    INPUT BY NAME tm.qj WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD qj
          IF tm.qj = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
          
       ON ACTION qbe_save
          CALL cl_qbe_save()

 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr005'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr005','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'",               #FUN-750047 add
                       #   " '",g_argv1 CLIPPED,"'",
                       #   " '",g_argv2 CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('ghrr005',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr005_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr005()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr005_w
END FUNCTION
 
FUNCTION ghrr005()
   DEFINE l_name    LIKE type_file.chr20,             
          l_sql     STRING,                          
          l_chr     LIKE type_file.chr1,              
          l_za05    LIKE type_file.chr1000,          
          l_sfb02doc LIKE type_file.chr30,           

          sr        RECORD
          hrat01        LIKE   hrat_file.hrat01,     
          hrat02        LIKE   hrat_file.hrat02,    
          hrat17_name   LIKE   type_file.chr50, 
          hrat15        LIKE   hrat_file.hrat15,     
          hrat04_name   LIKE   type_file.chr50, 
          hrat05_name   LIKE   type_file.chr50, 
          hraqa04       LIKE   hraqa_file.hraqa04,  
          hrat18        LIKE   hrat_file.hrat18,    
          hrat22_name   LIKE   type_file.chr50, 
          hrat23        LIKE   hrat_file.hrat23,           
          hrat34_name   LIKE   type_file.chr50, 
          hrat29_name   LIKE   type_file.chr50, 
          hrat13        LIKE   hrat_file.hrat13,    
          hrat24_name   LIKE   type_file.chr50,     
          hrat49        LIKE   hrat_file.hrat49,    
          hrat47        LIKE   hrat_file.hrat47,     
          hrat46        LIKE   hrat_file.hrat46,    
          hrat30        LIKE   hrat_file.hrat30,
          hrat32        LIKE   hrat_file.hrat32           
                    END RECORD


DEFINE    sr1       RECORD
          hrat01        LIKE   hrat_file.hrat01,    
          hrata04       LIKE   hrata_file.hrata04,  
          hrata05_name  LIKE   type_file.chr50,
          hrata02       LIKE   hrata_file.hrata02,  
          hrata03       LIKE   hrata_file.hrata03,  
          hrata06_name  LIKE   type_file.chr50,
          hrata08_name  LIKE   type_file.chr50        
                    END RECORD
                    
 DEFINE   sr2       RECORD
          hrat01        LIKE   hrat_file.hrat01,     
          hratc04       LIKE   hratc_file.hratc04,  
          hratc05_name  LIKE   type_file.chr50,
          hratc06       LIKE   hratc_file.hratc06,  
          hratc02       LIKE   hratc_file.hratc02,  
          hratc03       LIKE   hratc_file.hratc03,  
          hratc07_name  LIKE   type_file.chr50,
          hratc10       LIKE   hratc_file.hratc10,  
          hratc13       LIKE   hratc_file.hratc13         
                    END RECORD
                    
  DEFINE  sr3       RECORD 
          hrat01        LIKE   hrat_file.hrat01,     
          hratd02       LIKE   hratd_file.hratd02,
          hratd03       LIKE   hratd_file.hratd03, 
          hratd03_name  LIKE   type_file.chr50, 
          hratd05       LIKE   hratd_file.hratd05, 
          hratd04       LIKE   hratd_file.hratd04,   
          hratd07       LIKE   hratd_file.hratd07, 
          hratd08       LIKE   hratd_file.hratd08,   
          hratd09       LIKE   hratd_file.hratd09         
                    END RECORD
                    
  DEFINE  sr4       RECORD 
          hrat01         LIKE   hrat_file.hrat01,      
          hratb04        LIKE   hratb_file.hratb04, 
          hratb05        LIKE   hratb_file.hratb05,   
          hratb02        LIKE   hratb_file.hratb02, 
          hratb03        LIKE   hratb_file.hratb03,   
          hratb06        LIKE   hratb_file.hratb06, 
          hratb08        LIKE   hratb_file.hratb08          
                    END RECORD
                    
  DEFINE  sr5      RECORD 
          hrat01         LIKE   hrat_file.hrat01,     
          hrath02        LIKE   hrath_file.hrath02,
          hrath03        LIKE   hrath_file.hrath03,  
          hrath03_name   LIKE   type_file.chr50, 
          hrath04        LIKE   hrath_file.hrath04,
          hrath05        LIKE   hrath_file.hrath05,   
          hrath06        LIKE   hrath_file.hrath06,
          hrath08        LIKE   hrath_file.hrath08,   
          hrath07        LIKE   hrath_file.hrath07, 
          hrath09        LIKE   hrath_file.hrath09         
                    END RECORD
                    
  DEFINE  sr6       RECORD 
          hrat01        LIKE   hrat_file.hrat01,      
          hratg02       LIKE   hratg_file.hratg02,
          hratg03       LIKE   hratg_file.hratg03, 
          hratg04       LIKE   hratg_file.hratg04, 
          hratg04_name  LIKE   type_file.chr50, 
          hratg05       LIKE   hratg_file.hratg05, 
          hratg06       LIKE   hratg_file.hratg06  
               
                    END RECORD
                
          
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_dept    LIKE pmc_file.pmc03,          #No.MOD-580275
          l_occ02   LIKE occ_file.occ02,
          l_eca04   LIKE eca_file.eca04,
          l_eca04d  LIKE eca_file.eca04,          #TQC-740275 add
          l_sum1,l_sum2,l_sum3    LIKE smh_file.smh103,        #No.FUN-680121 DEC(13,5)
          l_cnt     LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE l_oea01   LIKE oea_file.oea01
   DEFINE l_ofb01   LIKE ofb_file.ofb01
   DEFINE l_oea04   LIKE oea_file.oea04
   DEFINE l_oea44   LIKE oea_file.oea44
   DEFINE l_sfw02   LIKE sfw_file.sfw02
   DEFINE l_sfw03   LIKE sfw_file.sfw03
   DEFINE l_hrar04  LIKE hrar_file.hrar04
   DEFINE l_hrat17  LIKE hrat_file.hrat17,
          l_hrat04  LIKE hrat_file.hrat04,
          l_hrat05  LIKE hrat_file.hrat05,
          l_hrat22  LIKE hrat_file.hrat22,
          l_hrat34  LIKE hrat_file.hrat34,
          l_hrat29  LIKE hrat_file.hrat29,
          l_hrat24  LIKE hrat_file.hrat24
          
   DEFINE l_hrata05 LIKE hrata_file.hrata05,
          l_hrata06 LIKE hrata_file.hrata06,
          l_hrata08 LIKE hrata_file.hrata08
   DEFINE l_hratd03 LIKE hratd_file.hratd03
   DEFINE l_hrath03 LIKE hrath_file.hrath03
   DEFINE l_hratg04 LIKE hratg_file.hratg04
   DEFINE l_hratc05 LIKE hratc_file.hratc05,
          l_hratc07 LIKE hratc_file.hratc07


   DEFINE l_short_qty   LIKE sfa_file.sfa07   #FUN-940008 add
   DEFINE l_sfa  RECORD LIKE sfa_file.*       #FUN-940008 add

   DEFINE            l_img_blob     LIKE type_file.blob
   DEFINE l_hratid  LIKE  hrat_file.hratid



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   CALL cl_del_data(l_table4)
   CALL cl_del_data(l_table5)
   CALL cl_del_data(l_table6)
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ) " 
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,  ?,?)" 
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) EXIT PROGRAM
   END IF 
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)" 
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)" 
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep3:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)" 
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep4:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)" 
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep5:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?,?,?,?, ?)" 
   PREPARE insert_prep6 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep6:",STATUS,1) EXIT PROGRAM
   END IF
     
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#



   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hrasuser', 'hrasgrup')
 
   
   LET l_sql = " SELECT hrat01,hrat02,'',hrat15,'','',hrat67,hrat18,'',hrat23, ",
               " '','',hrat13,'',hrat49,hrat47,hrat46,hrat30,hrat32            ",
               " FROM hrat_file,hras_file,hrar_file                            ",  
               " WHERE hrat05=hras01 AND hrar03=hras03                         ",         
               " AND hrasacti='Y' AND ",tm.wc CLIPPED
 
   LET l_sql=l_sql CLIPPED,"  ORDER BY hrat01 "   
   PREPARE ghrr005_p FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('ghrr005_p:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE ghrr005_curs CURSOR FOR ghrr005_p
  
      LET l_sql = " SELECT hrata01,hrata04,'',hrata02,hrata03,'','' ",
                  " FROM hrata_file    ", 
                  " WHERE hrata01 = ?  ",  
                  " ORDER BY hrata04   "
      PREPARE ghrr005_p1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr005_p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE ghrr005_curs1 CURSOR FOR ghrr005_p1 
   
    LET l_sql = " SELECT hratc01,hratc04,'',hratc06,hratc02,hratc03,'',hratc10,hratc13 ",
                " FROM hratc_file    ",
                " WHERE hratc01 = ?  "

      PREPARE ghrr005_p2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr005_p2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE ghrr005_curs2 CURSOR FOR ghrr005_p2

    LET l_sql ="  SELECT hratd01,hratd02,hratd03,'',hratd05,hratd04,hratd07,hratd08,hratd09 ",
               "  FROM hratd_file   ",
               "  WHERE hratd01 = ? ", 
               "  ORDER BY hratd02  "
      PREPARE ghrr005_p3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr005_p3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE ghrr005_curs3 CURSOR FOR ghrr005_p3
      
     LET l_sql=" SELECT hratb01,hratb04,hratb05,hratb02,hratb03,hratb06,hratb08 ",
               " FROM hratb_file    ",
               " WHERE hratb01 = ?  ", 
               " ORDER BY hratb04   "
      PREPARE ghrr005_p4 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr005_p4:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE ghrr005_curs4 CURSOR FOR ghrr005_p4
      
     LET l_sql=" SELECT hrath01,hrath02,hrath03,'',hrath04,hrath05,hrath06,hrath08,hrath07,hrath09 ",
               " FROM hrath_file    ",
               " WHERE hrath01 = ?  ", 
               " ORDER BY hrath02   "
      PREPARE ghrr005_p5 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr005_p5:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE ghrr005_curs5 CURSOR FOR ghrr005_p5
      
     LET l_sql=" SELECT hratg01,hratg02,hratg03,hratg04,'',hratg05,hratg06 ",
               " FROM hratg_file ",
               " WHERE hratg01 = ?  ", 
               " ORDER BY hratg02   "
      PREPARE ghrr005_p6 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr005_p6:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE ghrr005_curs6 CURSOR FOR ghrr005_p6
   INITIALIZE sr.* TO NULL
   FOREACH ghrr005_curs INTO sr.*
   select hratid into l_hratid from hrat_file where hrat01=sr.hrat01
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF cl_null(sr.hrat01) THEN
        CONTINUE FOREACH
     END IF
        
     IF NOT cl_null(sr.hrat01) THEN   
       SELECT hrat17,hrat04,hrat05,hrat22,hrat34,hrat29,hrat24 
       INTO l_hrat17,l_hrat04,l_hrat05,l_hrat22,l_hrat34,l_hrat29,l_hrat24 
       FROM hrat_file WHERE hrat01=sr.hrat01
       IF NOT cl_null(l_hrat17) THEN  
          CALL s_code('333',l_hrat17) RETURNING g_hrag.*
          LET sr.hrat17_name=g_hrag.hrag07
       END IF
       IF NOT cl_null(l_hrat04) THEN
          SELECT hrao02 INTO sr.hrat04_name FROM hrao_file WHERE hrao01=l_hrat04
       END IF
       IF NOT cl_null(l_hrat05) THEN
          SELECT hras04 INTO sr.hrat05_name FROM hras_file WHERE hras01=l_hrat05
       END IF
       IF NOT cl_null(l_hrat22) THEN
          CALL s_code('317',l_hrat22) RETURNING g_hrag.*
          LET sr.hrat22_name=g_hrag.hrag07 
       END IF
       IF NOT cl_null(l_hrat34) THEN
          CALL s_code('320',l_hrat34) RETURNING g_hrag.*
          LET sr.hrat34_name=g_hrag.hrag07 
       END IF
       IF NOT cl_null(l_hrat29) THEN
          CALL s_code('301',l_hrat29) RETURNING g_hrag.*
          LET sr.hrat29_name=g_hrag.hrag07 
       END IF
       IF NOT cl_null(l_hrat24) THEN
          CALL s_code('334',l_hrat24) RETURNING g_hrag.*
          LET sr.hrat24_name=g_hrag.hrag07 
       END IF    
     END IF 
     INITIALIZE sr1.* TO NULL  		
     FOREACH ghrr005_curs1 USING l_hratid INTO sr1.*
             IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
             END IF
             SELECT hrata05,hrata06,hrata08 INTO l_hrata05,l_hrata06,l_hrata08
             FROM hrata_file 
             WHERE hrata02=sr1.hrata02 AND hrata03=sr1.hrata03
             IF NOT cl_null(l_hrata05) THEN
                CALL s_code('308',l_hrata05) 
                RETURNING g_hrag.*
                LET sr1.hrata05_name=g_hrag.hrag07 
             END IF
             IF NOT cl_null(l_hrata06) THEN
                CALL s_code('203',l_hrata06) 
                RETURNING g_hrag.*
                LET sr1.hrata06_name=g_hrag.hrag07 
             END IF
             IF NOT cl_null(l_hrata08) THEN
                CALL s_code('309',l_hrata08) 
                RETURNING g_hrag.*
                LET sr1.hrata08_name=g_hrag.hrag07 
             END IF
             select hrat01 into sr1.hrat01 from hrat_file where hratid=sr1.hrat01
             EXECUTE  insert_prep1 USING sr1.*                        
     END FOREACH
     INITIALIZE sr2.* TO NULL
     FOREACH ghrr005_curs2 USING l_hratid INTO sr2.*
             IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
             END IF
             SELECT hratc05,hratc07 INTO l_hratc05,l_hratc07
             FROM hratc_file  
             WHERE hratc02=sr2.hratc02 AND hratc03=sr2.hratc03
            IF NOT cl_null(l_hratc05) THEN
                CALL s_code('307',l_hratc05) 
                RETURNING g_hrag.*
                LET sr2.hratc05_name=g_hrag.hrag07 
             END IF
             IF NOT cl_null(l_hratc07) THEN
                CALL s_code('315',l_hratc07) 
                RETURNING g_hrag.*
                LET sr2.hratc07_name=g_hrag.hrag07 
             END IF 
             select hrat01 into sr2.hrat01 from hrat_file where hratid=sr2.hrat01
              EXECUTE  insert_prep2 USING sr2.*    
     END FOREACH 
     INITIALIZE sr3.* TO NULL
     FOREACH ghrr005_curs3 USING l_hratid INTO sr3.*
         IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
         END IF
         SELECT hratd03 INTO l_hratd03 FROM hratd_file 
         WHERE  hratd02=sr3.hratd02
          IF NOT cl_null(l_hratd03) THEN
                CALL s_code('323',l_hratd03) 
                RETURNING g_hrag.*
                LET sr3.hratd03_name=g_hrag.hrag07 
          END IF
          select hrat01 into sr3.hrat01 from hrat_file where hratid=sr3.hrat01
          EXECUTE insert_prep3 USING sr3.hrat01,sr3.hratd02,sr3.hratd03_name,sr3.hratd05,
                                     sr3.hratd04,sr3.hratd07,sr3.hratd08,sr3.hratd09 
     END FOREACH
     INITIALIZE sr4.* TO NULL
     FOREACH ghrr005_curs4 USING l_hratid INTO sr4.*
         IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
         END IF
         select hrat01 into sr4.hrat01 from hrat_file where hratid=sr4.hrat01
         EXECUTE insert_prep4 USING sr4.*
     END FOREACH 
     INITIALIZE sr5.* TO NULL
     FOREACH ghrr005_curs5 USING l_hratid INTO sr5.*
         IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
         END IF
         SELECT hrath03 INTO l_hrath03 FROM hrath_file
         WHERE hrath02=sr5.hrath02
         IF NOT cl_null(l_hrath03) THEN
                CALL s_code('323',l_hrath03) 
                RETURNING g_hrag.*
                LET sr5.hrath03_name=g_hrag.hrag07 
         END IF
         select hrat01 into sr5.hrat01 from hrat_file where hratid=sr5.hrat01
         EXECUTE insert_prep5 USING sr5.hrat01,sr5.hrath02,sr5.hrath03_name,sr5.hrath04,
                                    sr5.hrath05,sr5.hrath06,sr5.hrath08,sr5.hrath07,sr5.hrath09
     END FOREACH 
     INITIALIZE sr6.* TO NULL
     FOREACH ghrr005_curs6 USING l_hratid INTO sr6.*
         IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
         END IF
         SELECT hraa02 INTO sr6.hratg04_name FROM hraa_file
         WHERE  hraa01=sr6.hratg04
         select hrat01 into sr6.hrat01 from hrat_file where hratid=sr6.hrat01
         EXECUTE insert_prep6 USING sr6.hrat01,sr6.hratg02,sr6.hratg03,sr6.hratg04_name,sr6.hratg05,sr6.hratg06
     END FOREACH 
         EXECUTE insert_prep USING sr.*
         
   END FOREACH   
             
    LET g_str=''
   LET l_sql= " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED
   CALL cl_prt_cs3('ghrr005','ghrr005',l_sql,g_str)
   
END FUNCTION      
