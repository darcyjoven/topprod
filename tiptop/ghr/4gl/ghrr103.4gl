# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr103.4gl
# Descriptions...: 社保付款通知书
# Date & Author..: 14/01/21   by shenran

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            more   LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #MOD-530401
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING                                                 
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*   
DEFINE g_byear        LIKE type_file.chr100
DEFINE g_bmonth       LIKE type_file.chr100
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
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
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
 
   LET g_sql ="hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,",
              "hrao02.hrao_file.hrao02,",
              "hras04.hras_file.hras04,",
              "hrat13.hrat_file.hrat13,",
              "cr01.type_file.num26_10,",
              "cr02.type_file.num26_10,",
              "cr03.type_file.num26_10,",
              "cr04.type_file.num26_10,",
              "cr05.type_file.num26_10,",
              "cr06.type_file.num26_10,",
              "cr07.type_file.num26_10,",
              "cr08.type_file.num26_10,",
              "cr09.type_file.num26_10,",
              "cr10.type_file.num26_10,",
              "cr11.type_file.num26_10,",
              "cr12.type_file.num26_10,",
              "cr13.type_file.num26_10,",
              "cr14.type_file.num26_10,",
              "cr15.type_file.num26_10,",
              "cr16.type_file.num26_10,",
              "cr17.type_file.num26_10,",
              "cr18.type_file.num26_10,",
              "cr19.type_file.num26_10,",
              "CR20.type_file.num26_10,",
              "CR21.type_file.num26_10,",
              "CR22.type_file.num26_10,",
              "CR23.type_file.num26_10,",
              "CR24.type_file.num26_10,",
              "CR021.type_file.num26_10,",
              "CR031.type_file.num26_10,",
              "CR041.type_file.num26_10,",
              "CR051.type_file.num26_10,",
              "CR061.type_file.num26_10,",
              "CR071.type_file.num26_10,",
              "CR081.type_file.num26_10,",
              "CR091.type_file.num26_10,",
              "CR101.type_file.num26_10,",
              "CR111.type_file.num26_10,",
              "CR121.type_file.num26_10,",
              "CR131.type_file.num26_10,",
              "CR201.type_file.num26_10,",
              "CR211.type_file.num26_10,",
              "CR221.type_file.num26_10,",
              "CR231.type_file.num26_10,",
              "CR241.type_file.num26_10,",
              "hrdt02.hrdt_file.hrdt02,",
              "set1.type_file.num26_10,",
              "set2.type_file.num26_10,",
              "set3.type_file.num26_10,",
              "set4.type_file.num26_10,",
              "set5.type_file.num26_10,",
              "set6.type_file.num26_10,",
              "set7.type_file.num26_10,",
              "set8.type_file.num26_10,",
              "set9.type_file.num26_10,",
              "set10.type_file.num26_10,",
              "set11.type_file.num26_10,",
              "set12.type_file.num26_10,",
              "set13.type_file.num26_10,",
              "set14.type_file.num26_10,",
              "set15.type_file.num26_10,",
              "byear.type_file.chr100,",
              "bmonth.type_file.chr100,"

   LET l_table = cl_prt_temptable('ghrr103',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr103_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr103()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION i091_get_hrdt02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrdt01 LIKE hrdt_file.hrdt01
DEFINE l_hrdt02 LIKE hrdt_file.hrdt02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrdt01,hrdt02 FROM hrdt_file ORDER BY hrdt01"
       PREPARE i091_get_hrdt02_pre FROM l_sql
       DECLARE i091_get_hrdt02 CURSOR FOR i091_get_hrdt02_pre
       FOREACH i091_get_hrdt02 INTO l_hrdt01,l_hrdt02
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrdt01
            LET p_items=l_hrdt02
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrdt01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrdt02 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION

FUNCTION ghrr103_tm(p_row,p_col)
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hrat01       LIKE hrat_file.hrat01
      ,l_hrao01       LIKE hrao_file.hrao01
      ,l_byear        LIKE type_file.chr100
      ,l_bmonth       LIKE type_file.chr100
      ,l_hrat02       LIKE hrat_file.hrat02
      ,l_hrao02       LIKE hrao_file.hrao02
      ,l_hrdt01       LIKE hrdt_file.hrdt01  
      ,l_hrdt02       LIKE hrdt_file.hrdt02  
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr103_w AT p_row,p_col WITH FORM "ghr/42f/ghrr103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON byear,bmonth,hrdt01,hrao01,hrat01

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          #统筹区域
         #CALL cl_set_combo_items("hrdt01",NULL,NULL)
         #CALL i091_get_hrdt02() RETURNING l_name,l_items
         #CALL cl_set_combo_items("hrdt01",l_name,l_items)
       AFTER FIELD hrat01
          LET l_hrat01 = GET_FLDBUF(hrat01)
          IF NOT cl_null(l_hrat01) THEN 
          	 SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01 = l_hrat01
          	 DISPLAY l_hrat02 TO FORMONLY.hrat01_name
          END IF 
       AFTER FIELD hrao01
          LET l_hrao01 = GET_FLDBUF(hrao01)
          IF NOT cl_null(l_hrao01) THEN 
          	 SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = l_hrao01
          	 DISPLAY l_hrao02 TO FORMONLY.hrao01_name
          END IF 
       AFTER FIELD byear
          LET g_byear = GET_FLDBUF(byear)
          IF cl_null(g_byear) THEN 
          	 NEXT FIELD byear
          END IF 
          	
       AFTER FIELD bmonth
          LET g_bmonth = GET_FLDBUF(bmonth)
          IF cl_null(g_bmonth) THEN 
          	 NEXT FIELD bmonth
          END IF
          
          	
       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hrao01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01_1"
                 #LET g_qryparam.arg1 = "30"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao01
                 NEXT FIELD hrao01
            
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 IF NOT cl_null(l_hrao01) THEN
                   LET g_qryparam.form = "q_hrat01_2" 
                   LET g_qryparam.arg1 = l_hrao01
                 ELSE
              	   LET g_qryparam.form = "q_hrat01_3"  
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
           WHEN INFIELD(hrdt01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrdt01"
                  LET g_qryparam.state = "c"
#                 LET g_qryparam.arg1 = "30"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdt01
                 LET l_hrdt01 = GET_FLDBUF(hrdt01)
                 SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file WHERE hrdt01=l_hrdt01 
                 DISPLAY l_hrdt02 TO hrdt02
                 NEXT FIELD hrdt01
             
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
 
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
    DISPLAY BY NAME tm.more                  
    INPUT BY NAME tm.more WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
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
 
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr103'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr103','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\" ") #"
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
      CALL cl_cmdat('ghrr103',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr103_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr103()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr103_w
END FUNCTION
 
FUNCTION ghrr103()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrat01       LIKE hrat_file.hrat01,
                     hrat02       LIKE hrat_file.hrat02,
                     hrao02       LIKE hrao_file.hrao02,
                     hras04       LIKE hras_file.hras04,
                     hrat13       LIKE hrat_file.hrat13,
                     cr01         LIKE type_file.num26_10,
                     cr02         LIKE type_file.num26_10,
                     cr03         LIKE type_file.num26_10,
                     cr04         LIKE type_file.num26_10,
                     cr05         LIKE type_file.num26_10,
                     cr06         LIKE type_file.num26_10,
                     cr07         LIKE type_file.num26_10, 
                     cr08         LIKE type_file.num26_10,
                     cr09         LIKE type_file.num26_10,
                     cr10         LIKE type_file.num26_10,
                     cr11         LIKE type_file.num26_10,
                     cr12         LIKE type_file.num26_10,
                     cr13         LIKE type_file.num26_10,
                     cr14         LIKE type_file.num26_10,
                     cr15         LIKE type_file.num26_10,
                     cr16         LIKE type_file.num26_10,
                     cr17         LIKE type_file.num26_10,
                     cr18         LIKE type_file.num26_10,
                     cr19         LIKE type_file.num26_10,
                     CR20	       LIKE type_file.num26_10,
                     CR21	       LIKE type_file.num26_10,
                     CR22	       LIKE type_file.num26_10,
                     CR23	       LIKE type_file.num26_10,
                     CR24	       LIKE type_file.num26_10,
                     CR021	       LIKE type_file.num26_10,
                     CR031	       LIKE type_file.num26_10,
                     CR041	       LIKE type_file.num26_10,
                     CR051	       LIKE type_file.num26_10,
                     CR061	       LIKE type_file.num26_10,
                     CR071	       LIKE type_file.num26_10,
                     CR081	       LIKE type_file.num26_10,
                     CR091	       LIKE type_file.num26_10,
                     CR101	       LIKE type_file.num26_10,
                     CR111	       LIKE type_file.num26_10,
                     CR121	       LIKE type_file.num26_10,
                     CR131	       LIKE type_file.num26_10,
                     CR201	       LIKE type_file.num26_10,
                     CR211	       LIKE type_file.num26_10,
                     CR221	       LIKE type_file.num26_10,
                     CR231	       LIKE type_file.num26_10,
                     CR241	       LIKE type_file.num26_10,
                     hrdt02				LIKE hrdt_file.hrdt02,
                     set1         LIKE type_file.num26_10, 
                     set2         LIKE type_file.num26_10, 
                     set3         LIKE type_file.num26_10, 
                     set4         LIKE type_file.num26_10, 
                     set5         LIKE type_file.num26_10, 
                     set6         LIKE type_file.num26_10, 
                     set7         LIKE type_file.num26_10, 
                     set8         LIKE type_file.num26_10, 
                     set9         LIKE type_file.num26_10, 
                     set10         LIKE type_file.num26_10, 
                     set11         LIKE type_file.num26_10, 
                     set12         LIKE type_file.num26_10, 
                     set13         LIKE type_file.num26_10, 
                     set14         LIKE type_file.num26_10, 
                     set15         LIKE type_file.num26_10
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_hraa12  LIKE hraa_file.hraa12
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE            l_img_blob     LIKE type_file.blob



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?,?,?,
                        ?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------##

   #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')##
   LET tm.wc = cl_replace_str(tm.wc,"byear","hrct01")
   LET tm.wc = cl_replace_str(tm.wc,"bmonth","hrct02")
  
   LET l_sql = " SELECT HRAT01,HRAT02,HRAO02,HRAS04,HRAT13,
                       CR01,CR02,CR03,CR04,CR05,CR06,CR07,CR08,CR09,CR10,CR11,CR12,CR13,CR14,CR15,CR16,CR17,CR18,CR19,CR20,CR21,CR22,CR23,CR24,
                       CR021,CR031,CR041,CR051,CR061,CR071,CR081,CR091,CR101,CR111,CR121,CR131,CR201,CR211,CR221,CR231,CR241,
                       HRDT02,
                       SET1,SET2,SET3,SET4,SET5,SET6,SET7,SET8,SET9,SET10,SET11,SET12,SET13,CR10 + CR11 AS SET14,SET15
                 FROM (SELECT HRDW01,HRCT01,HRCT02,
              SUM(CASE  WHEN HRDW02 = '002' THEN  HRDW04  ELSE  0  END) CR05,/*个人养老*/
              SUM(CASE  WHEN HRDW02 = '002' THEN  HRDW06  ELSE  0  END) CR051,/*个人养老 补缴*/
              SUM(CASE  WHEN HRDW02 = '002' THEN  HRDW07  ELSE  0  END) CR041,/*公司养老 补缴*/
              SUM(CASE  WHEN HRDW02 = '002' THEN  HRDW05  ELSE  0  END) CR04,/*公司养老*/
              SUM(CASE  WHEN HRDW02 = '001' THEN  HRDW04  ELSE  0  END) CR03,/*个人医疗*/
              SUM(CASE  WHEN HRDW02 = '001' THEN  HRDW06  ELSE  0  END) CR031,/*个人医疗 补缴*/
              SUM(CASE  WHEN HRDW02 = '001' THEN  HRDW07  ELSE  0  END) CR021,/*公司医疗 补缴*/
              SUM(CASE  WHEN HRDW02 = '001' THEN  HRDW05  ELSE  0  END) CR02,/*公司医疗*/
              SUM(CASE  WHEN HRDW02 = '005' THEN  HRDW04  ELSE  0  END) CR07,/*个人失业*/
              SUM(CASE  WHEN HRDW02 = '005' THEN  HRDW06  ELSE  0  END) CR071,/*个人失业 补缴*/
              SUM(CASE  WHEN HRDW02 = '005' THEN  HRDW07  ELSE  0  END) CR061,/*公司失业 补缴*/
              SUM(CASE  WHEN HRDW02 = '005' THEN  HRDW05  ELSE  0  END) CR06,/*公司失业*/
              SUM(CASE  WHEN HRDW02 = '003' THEN  HRDW05  ELSE  0  END) CR08,/*公司工伤*/
              SUM(CASE  WHEN HRDW02 = '003' THEN  HRDW07  ELSE  0  END) CR081,/*公司工伤 补缴*/
              SUM(CASE  WHEN HRDW02 = '004' THEN  HRDW07  ELSE  0  END) CR091,/*公司生育 补缴*/
              SUM(CASE  WHEN HRDW02 = '004' THEN  HRDW05  ELSE  0  END) CR09,/*公司生育*/
              SUM(CASE  WHEN HRDW02 = '006' THEN  HRDW04  ELSE  0  END) CR11,/*个人大病*/
              SUM(CASE  WHEN HRDW02 = '006' THEN  HRDW06  ELSE  0  END) CR111,/*个人大病 补缴*/
              SUM(CASE  WHEN HRDW02 = '006' THEN  HRDW07  ELSE  0  END) CR101,/*公司大病 补缴*/
              SUM(CASE  WHEN HRDW02 = '006' THEN  HRDW05  ELSE  0  END) CR10,/*公司大病*/
              SUM(HRDW04) CR13,/*个人社保*/
              SUM(HRDW06) CR131,/*个人社保 补缴*/
              SUM(HRDW07) CR121,/*公司社保 补缴*/
              SUM(HRDW05) CR12,/*公司社保*/
                             SUM(CASE  WHEN HRDW02 < '007' THEN  HRDW04  ELSE  0  END) + SUM(CASE  WHEN HRDW02 < '007' THEN  HRDW05  ELSE  0  END) CR14,/*社保小计*/
                             SUM(CASE  WHEN HRDW02 = '007' THEN  HRDW04  ELSE  0  END) CR17,/*公积金个人*/
                             SUM(CASE  WHEN HRDW02 = '007' THEN  HRDW05  ELSE  0  END) CR16,/*公积金公司*/
                             SUM(CASE  WHEN HRDW02 = '007' THEN  HRDW04  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '007' THEN  HRDW05  ELSE  0  END) CR18,/*公积金小计*/
                             SUM(HRDW04) + SUM(HRDW05) CR19,/*合计*/
                             SUM(CASE  WHEN HRDW02 = '008' THEN  HRDW05  ELSE  0  END) CR20,/*公司残疾人保障金*/
                             SUM(CASE  WHEN HRDW02 = '008' THEN  HRDW07  ELSE  0  END) CR201,/*公司残疾人保障金 补缴*/
                             SUM(CASE  WHEN HRDW02 = '009' THEN  HRDW07  ELSE  0  END) CR211,/*公司取暖费 补缴*/
                             SUM(CASE  WHEN HRDW02 = '009' THEN  HRDW05  ELSE  0  END) CR21,/*公司取暖费*/
                             SUM(CASE  WHEN HRDW02 = '010' THEN  HRDW05  ELSE  0  END) CR22,/*公司外服服务费*/
                             SUM(CASE  WHEN HRDW02 = '010' THEN  HRDW07  ELSE  0  END) CR221,/*公司外服服务费 补缴*/
              SUM(CASE  WHEN HRDW02 = '011' THEN  HRDW07  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '012' THEN  HRDW07  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '013' THEN  HRDW07  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '006' THEN  HRDW07  ELSE  0  END) CR231,/*公司补充医疗 补缴*/
              SUM(CASE  WHEN HRDW02 = '011' THEN  HRDW05  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '012' THEN  HRDW05  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '013' THEN  HRDW05  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '006' THEN  HRDW05  ELSE  0  END) CR23,/*公司补充医疗*/
              SUM(CASE  WHEN HRDW02 = '011' THEN  HRDW06  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '012' THEN  HRDW06  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '013' THEN  HRDW06  ELSE  0  END) CR241,/*个人补充医疗 补缴*/
              SUM(CASE  WHEN HRDW02 = '011' THEN  HRDW04  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '012' THEN  HRDW04  ELSE  0  END) + SUM(CASE  WHEN HRDW02 = '013' THEN  HRDW04  ELSE  0  END) CR24/*个人补充医疗*/
                         FROM HRDW_FILE
                         LEFT JOIN HRCT_FILE ON HRDW03 = HRCT11 GROUP BY HRDW01, HRCT01, HRCT02) A
                 LEFT JOIN (SELECT HRDU01,  HRDU02,
                             MAX(CASE  WHEN HRDU05 = '001' THEN  HRDU07  ELSE  0  END) CR01,/*社保基数*/
                             MAX(CASE  WHEN HRDU05 = '007' THEN  HRDU07  ELSE  0  END) CR15/*公积金基数*/
                            FROM HRDU_FILE
                            WHERE HRDU03 = '001'
                            GROUP BY HRDU01, HRDU02) C
                   ON A.HRDW01 = C.HRDU01
                 LEFT JOIN HRDT_FILE ON HRDT01 = C.HRDU02
                 LEFT JOIN (SELECT HRDTA01,
                             SUM(CASE  WHEN HRDTA02 = '001' THEN  HRDTA08  ELSE  0  END) SET3,
                             SUM(CASE  WHEN HRDTA02 = '001' THEN  HRDTA09  ELSE  0  END) SET4,
                             SUM(CASE  WHEN HRDTA02 = '002' THEN  HRDTA08  ELSE  0  END) SET1,
                             SUM(CASE  WHEN HRDTA02 = '002' THEN  HRDTA09  ELSE  0  END) SET2,
                             SUM(CASE  WHEN HRDTA02 = '003' THEN  HRDTA08  ELSE  0  END) SET5,
                             SUM(CASE  WHEN HRDTA02 = '003' THEN  HRDTA09  ELSE  0  END) SET6,
                             SUM(CASE  WHEN HRDTA02 = '004' THEN  HRDTA08  ELSE  0  END) SET7,
                             SUM(CASE  WHEN HRDTA02 = '005' THEN  HRDTA08  ELSE  0  END) SET8,
                             SUM(CASE  WHEN HRDTA02 = '007' THEN  HRDTA08  ELSE  0  END) SET9,
                             SUM(CASE  WHEN HRDTA02 = '007' THEN  HRDTA09  ELSE  0  END) SET10,
                             SUM(CASE  WHEN HRDTA02 < '006' THEN  HRDTA08  ELSE  0  END) SET11,
                             SUM(CASE  WHEN HRDTA02 < '006' THEN  HRDTA09  ELSE  0  END) SET12,
                             SUM(CASE  WHEN HRDTA02 < '006' THEN  HRDTA08  ELSE  0  END) + SUM(CASE  WHEN HRDTA02 < '006' THEN  HRDTA09  ELSE  0  END) SET13,
                             SUM(CASE  WHEN HRDTA02 = '007' THEN  HRDTA08  ELSE  0  END) + SUM(CASE  WHEN HRDTA02 = '007' THEN  HRDTA09  ELSE  0  END) SET15
                            FROM HRDTA_FILE
                            GROUP BY HRDTA01) B
                   ON B.HRDTA01 = HRDT01
                 LEFT JOIN HRAT_FILE ON A.HRDW01 = HRATID
                 LEFT JOIN HRAO_FILE ON HRAO01 = HRAT04
                 LEFT JOIN HRAS_FILE ON HRAS01 = HRAT05
                  WHERE ",tm.wc CLIPPED
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr103_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
       
          EXECUTE insert_prep USING sr.*,g_byear,g_bmonth
       
                 
      END FOREACH

 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('ghrr103','ghrr103',l_sql,g_str)
   
END FUNCTION      
