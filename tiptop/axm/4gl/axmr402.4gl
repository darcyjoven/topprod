# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axmr402.4gl
# Descriptions...: 合約未轉訂單明細表
# Date & Author..: 10/08/03 By wujie FUN-A80024
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-A80024
DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,       
            a       LIKE type_file.chr1,  
            oeb32   LIKE oeb_file.oeb32,        
            more    LIKE type_file.chr1         
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20,         
       g_po_no,g_ctn_no1,g_ctn_no2      LIKE type_file.chr20         
DEFINE g_cnt       LIKE type_file.num10     
DEFINE g_i         LIKE type_file.num5      
DEFINE g_msg       LIKE type_file.chr1000   
DEFINE g_show_msg  DYNAMIC ARRAY OF RECORD  
          oea01     LIKE oea_file.oea01,
          oea03     LIKE oea_file.oea03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD 
DEFINE l_table     STRING                            
DEFINE g_sql       STRING               
DEFINE g_str       STRING               
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   #str TQC-740271 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oea01.oea_file.oea01  ,oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04  ,oeb06.oeb_file.oeb06,",
               "ima021.ima_file.ima021  ,oeb32.oeb_file.oeb32,",
               "oeb05.oeb_file.oeb05  ,oeb12.oeb_file.oeb12,",
               "oeb24.oeb_file.oeb24  ,qty.oeb_file.oeb12"

   LET l_table = cl_prt_temptable('axmr402',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 

   LET g_pdate  = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)                          
   LET tm.a     = ARG_VAL(8)                          
   LET g_rep_user = ARG_VAL(10)                      
   LET g_rep_clas = ARG_VAL(11)                      
   LET g_template = ARG_VAL(12)                      
   LET g_xml.subject = ARG_VAL(13)
   LET g_xml.body = ARG_VAL(14)
   LET g_xml.recipient = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  

   IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN  # If background   
      CALL axmr402_tm(0,0)             # Input print condition
   ELSE 
      CALL axmr402()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION axmr402_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col    LIKE type_file.num5,      
          l_cmd        LIKE type_file.chr1000     
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr402_w AT p_row,p_col WITH FORM "axm/42f/axmr402"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'       
   LET g_copies = '1'
   LET tm.a ='N'
   LET tm.oeb32 =g_today

 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oeb04
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION locale
         CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION controlp
         CASE
            WHEN INFIELD(oea01) #查詢單据
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oea11"   
                    LET g_qryparam.where = " oea00 = '0' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
            WHEN INFIELD(oeb04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oeb04
               NEXT FIELD oeb04
         END CASE
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr402_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF

   INPUT BY NAME tm.a,tm.oeb32,tm.more WITHOUT DEFAULTS 

      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      BEFORE FIELD a
         CALL cl_set_comp_entry('oeb32',TRUE)
         
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD n
         END IF
         IF tm.a ='N' THEN
            LET tm.oeb32 = NULL 
            CALL cl_set_comp_entry('oeb32',FALSE)
         END IF 
         
      AFTER FIELD oeb32
         IF tm.a ='Y' AND cl_null(tm.oeb32) THEN 
            NEXT FIELD oeb32
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr402_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr402'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr402','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.oeb32 CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'"           
         CALL cl_cmdat('axmr402',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr402_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr402()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr402_w
END FUNCTION
 
FUNCTION axmr402()
  DEFINE l_cmd           LIKE type_file.chr1000 
  DEFINE l_cnt           LIKE   type_file.num5    #SMALLINT
  DEFINE l_wc            STRING
  DEFINE ls_context      STRING  
  DEFINE ls_temp_path    STRING 
  DEFINE ls_context_file STRING
  DEFINE l_oea01_t       LIKE oea_file.oea01
 
  DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #
          l_sql     LIKE type_file.chr1000,      
          l_za05    LIKE type_file.chr1000,      
          sr        RECORD
                    oea01     LIKE oea_file.oea01,
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    oeb06     LIKE oeb_file.oeb06,   
                    ima021    LIKE ima_file.ima021,
                    oeb32     LIKE oeb_file.oeb32,
                    oeb05     LIKE oeb_file.oeb05,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb24     LIKE oeb_file.oeb24,
                    qty       LIKE oeb_file.oeb12
                    END RECORD
   DEFINE l_i,l_j     LIKE type_file.num5  
   DEFINE l_oea23   LIKE oea_file.oea23  

 

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF

 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
 
   LET l_sql="SELECT oea01,oeb03,oeb04,oeb06,ima021,oeb32,oeb05,oeb12,oeb24,(oeb12-oeb24),oea23",  
             "  FROM oea_file,oeb_file LEFT OUTER JOIN ima_file ON oeb04 = ima01 ", 
             " WHERE oea01=oeb01 ", 
             "   AND oeaconf != 'X' ",
             "   AND oea00 = '0' ",
             "   AND oeb12-oeb24 >0",
             "   AND ",tm.wc CLIPPED
             
   IF tm.a ='Y' THEN 
      LET l_sql = l_sql," AND oeb32 <='",tm.oeb32,"'"," ORDER BY oea01,oeb03,oeb04 "
   ELSE 
      LET l_sql = l_sql," ORDER BY oea01,oeb03,oeb04 "
   END IF 
   PREPARE axmr402_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE axmr402_curs1 CURSOR FOR axmr402_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
 
   FOREACH axmr402_curs1 INTO sr.*,l_oea23
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 

      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file WHERE azi01=l_oea23
      IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
      IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
      IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF

 
      EXECUTE insert_prep USING 
         sr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   LET g_str = tm.a,";",tm.oeb32
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'oea01,oea02,oeb04')  
            RETURNING tm.wc                     
   ELSE
      LET tm.wc = ''
   END IF
    LET g_str = g_str ,";",tm.wc               
   CALL cl_prt_cs3('axmr402','axmr402',g_sql,g_str)
END FUNCTION
