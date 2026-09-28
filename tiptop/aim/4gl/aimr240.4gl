# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr240.4gl
# Descriptions...: 批序號庫存異動明細表
# Date & Author..: 11/09/02 FUN-B80142 By Sakura

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm            RECORD                       # Print condition RECORD
                     wc       STRING,             # Where Condition
                     wc2      STRING,             # Where Condition
                     tlfs02   LIKE tlfs_file.tlfs02,
                     tlfs03   LIKE tlfs_file.tlfs03,
                     tlfs04   LIKE tlfs_file.tlfs04,
                     tlfs111_b  LIKE tlfs_file.tlfs111,
                     tlfs111_e  LIKE tlfs_file.tlfs111,
                     tlfs12_b  LIKE tlfs_file.tlfs12,
                     tlfs12_e  LIKE tlfs_file.tlfs12,
                     a        LIKE type_file.chr1,    #print date
                     s        LIKE type_file.chr3,    #Order by sequence
                     t        LIKE type_file.chr3,    #Eject sw
                     u        LIKE type_file.chr3,    #Group total sw
                     more     LIKE type_file.chr1     #special condition
                     END RECORD,
       g_code        LIKE type_file.num5,  #SMALLINT
       g_program     LIKE zz_file.zz01,
       g_str         LIKE ze_file.ze03,
       g_str1,g_str2 LIKE ze_file.ze03,
       g_str3,g_str4 LIKE ze_file.ze03,
       g_order       LIKE ima_file.ima01,
       g_amt         LIKE zaa_file.zaa08,
       g_date        LIKE zaa_file.zaa08
DEFINE g_gettlfs      DYNAMIC ARRAY OF RECORD
                     bdate    LIKE type_file.dat,    #Transaction begin date
                     edate    LIKE type_file.dat,    #Transaction end   date
                     p_no     LIKE type_file.num10   #Transaction count
                     END RECORD
DEFINE g_i           LIKE type_file.num5             #count/index for any purpose
DEFINE g_sql         STRING
DEFINE l_str         STRING
DEFINE l_table       STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				        # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql="tlfs10.tlfs_file.tlfs10,",
             "tlfs111.tlfs_file.tlfs111,",
             "tlfs01.tlfs_file.tlfs01,", 
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",                   
             "tlfs02.tlfs_file.tlfs02,",
             "tlfs03.tlfs_file.tlfs03,",
             "tlfs04.tlfs_file.tlfs04,",
             "tlfs06.tlfs_file.tlfs06,",
             "tlfs05.tlfs_file.tlfs05,",
             "tlfs07.tlfs_file.tlfs07,",
             "tlfs08.tlfs_file.tlfs08,",             
             "tlfs13.tlfs_file.tlfs13,",
             "chr1.type_file.chr1"
   LET l_table = cl_prt_temptable('aimr240',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       

   LET g_pdate  = ARG_VAL(1)       		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.wc2   = ARG_VAL(8)
   LET tm.tlfs02 = ARG_VAL(9)
   LET tm.tlfs03  = ARG_VAL(10)
   LET tm.tlfs04   = ARG_VAL(11)
   LET tm.tlfs111_b = ARG_VAL(12)
   LET tm.tlfs111_e = ARG_VAL(13)
   LET tm.tlfs12_b = ARG_VAL(14)
   LET tm.tlfs12_e = ARG_VAL(15)
   LET tm.a     = ARG_VAL(16)
   LET tm.s     = ARG_VAL(17)
   LET tm.t     = ARG_VAL(18)
   LET tm.u     = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r240_tm(0,0)	        	# Input print condition
      ELSE CALL r240()			            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r240_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_j,l_n       LIKE type_file.num5,
          l_cmd		LIKE type_file.chr1000

   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17 
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF

   OPEN WINDOW r240_w AT p_row,p_col
        WITH FORM "aim/42f/aimr240" 

       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a  ='1'
   LET tm.s  = '123'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   CALL s_refer(g_code) RETURNING g_str1,g_str2,g_str3,g_str4
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT tm.wc ON tlfs08,tlfs01,tlfs06,tlfs05
                FROM tlfs08,tlfs01,tlfs06,tlfs05
      ON ACTION CONTROLP
         CASE WHEN INFIELD(tlfs01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlfs01
              NEXT FIELD tlfs01
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
   END CONSTRUCT
   
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN 
      LET INT_FLAG = 0 CLOSE WINDOW r240_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM          
   END IF
   
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF

   INPUT BY NAME tm.tlfs02,tm.tlfs03,tm.tlfs04,
                 tm.tlfs111_b,tm.tlfs111_e,tm.tlfs12_b,tm.tlfs12_e,
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                  tm.a,tm.more
                 WITHOUT DEFAULTS 

      AFTER FIELD tlfs111_e
         IF tm.tlfs111_b IS NOT NULL AND tm.tlfs111_e IS NOT NULL 
         THEN IF tm.tlfs111_e < tm.tlfs111_b THEN 
                 NEXT FIELD tlfs111_b
              END IF  
         END IF
      AFTER FIELD tlfs12_e
         IF tm.tlfs12_b IS NOT NULL AND tm.tlfs12_e IS NOT NULL 
         THEN IF tm.tlfs12_e < tm.tlfs12_b THEN 
                 NEXT FIELD tlfs12_b
              END IF
         END IF  
      AFTER FIELD a       #print date condition
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[12]'
            THEN NEXT FIELD a
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
       AFTER INPUT
          IF tm.tlfs111_b > tm.tlfs111_e THEN NEXT FIELD tlfs111_b END IF
          IF tm.tlfs12_b > tm.tlfs12_e THEN NEXT FIELD tlfs12_b END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution

      ON ACTION data_source 
         CALL s_gettlf(0,0)

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
   END INPUT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r240_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr240'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr240','9031',1)
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
                         " '",tm.wc2 CLIPPED,"'",
                         " '",tm.tlfs02   CLIPPED,"'",
                         " '",tm.tlfs03    CLIPPED,"'",
                         " '",tm.tlfs04     CLIPPED,"'",
                         " '",tm.tlfs111_b CLIPPED,"'",
                         " '",tm.tlfs111_e CLIPPED,"'",
                         " '",tm.tlfs12_b CLIPPED,"'",
                         " '",tm.tlfs12_e CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'"
         CALL cl_cmdat('aimr240',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r240_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r240()
   ERROR ""
END WHILE
   CLOSE WINDOW r240_w
END FUNCTION

FUNCTION r240()
   DEFINE l_sql      STRING,
          sr         RECORD        
                      tlfs    RECORD LIKE tlfs_file.*,     
                      ima02  LIKE ima_file.ima02,
                      ima021 LIKE ima_file.ima021
                     END RECORD,          
          sr2         RECORD
                      tlfs10   LIKE tlfs_file.tlfs10,   #單據編號
                      tlsdate  LIKE tlfs_file.tlfs111,  #日期
                      tlfs01   LIKE tlfs_file.tlfs01,   #料件編號
                      ima02    LIKE ima_file.ima02,     #品名
                      ima021   LIKE ima_file.ima021,    #規格
                      tlfs02   LIKE tlfs_file.tlfs02,   #倉庫
                      tlfs03   LIKE tlfs_file.tlfs03,   #儲位
                      tlfs04   LIKE tlfs_file.tlfs04,   #批號
                      tlfs06   LIKE tlfs_file.tlfs06,   #製造批號
                      tlfs05   LIKE tlfs_file.tlfs05,   #序號
                      tlfs07   LIKE tlfs_file.tlfs07,   #單位
                      tlfs08   LIKE tlfs_file.tlfs08,   #異動單據
                      tlfs13   LIKE tlfs_file.tlfs13,   #出入庫數量
                      status   LIKE type_file.chr1      #異動別
                     END RECORD,
                      g_sheet   LIKE smy_file.smyslip

    CALL cl_del_data(l_table)

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     #====>資料權限的檢查
     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND fbouser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND fbogrup MATCHES '",g_grup CLIPPED,"*'"
     END IF
     IF g_priv3 MATCHES "[5678]" THEN    #群組權限
         LET tm.wc = tm.wc clipped," AND fbogrup IN ",cl_chk_tgrup_list()
     END IF

     IF NOT cl_null(tm.tlfs111_b) THEN
        LET tm.wc = tm.wc clipped," AND tlfs111 >=","'",tm.tlfs111_b,"'"
     END IF
     IF NOT cl_null(tm.tlfs111_e) THEN 
        LET tm.wc = tm.wc clipped," AND tlfs111 <=","'",tm.tlfs111_e,"'"
     END IF
     IF NOT cl_null(tm.tlfs12_b) THEN 
        LET tm.wc = tm.wc clipped," AND tlfs12 >=","'",tm.tlfs12_b,"'"
     END IF
     IF NOT cl_null(tm.tlfs12_e) THEN 
        LET tm.wc = tm.wc clipped," AND tlfs12 <=","'",tm.tlfs12_e,"'"
     END IF

     LET l_sql="SELECT tlfs_file.*,ima02,ima021 ",
               "  FROM tlfs_file,ima_file ",
               " WHERE tlfs01=ima01 ",
               " AND tlfs09 <> 0 ",
               " AND ",tm.wc CLIPPED

        IF NOT cl_null(tm.tlfs02) AND tm.tlfs02 != ' ' THEN  
            LET l_sql=l_sql CLIPPED," AND tlfs02 ='",tm.tlfs02,"'"
        END IF
        IF NOT cl_null(tm.tlfs03) AND tm.tlfs03 != ' ' THEN  
            LET l_sql=l_sql CLIPPED," AND tlfs03 ='",tm.tlfs03,"'"
        END IF
        IF NOT cl_null(tm.tlfs04) AND tm.tlfs04 != ' ' THEN  
            LET l_sql=l_sql CLIPPED," AND tlfs04 ='",tm.tlfs04,"'"
        END IF
                     
      PREPARE r240_prepare FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r240_cs CURSOR FOR r240_prepare

      FOREACH r240_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       LET sr2.tlfs10 = sr.tlfs.tlfs10   #單據編號
       LET sr2.tlfs01 = sr.tlfs.tlfs01   #料件編號
       LET sr2.ima02 = sr.ima02          #品名規格
       LET sr2.ima021= sr.ima021         #品名規格
       LET sr2.tlfs02 = sr.tlfs.tlfs02   #倉庫
       LET sr2.tlfs03 = sr.tlfs.tlfs03   #儲位
       LET sr2.tlfs04 = sr.tlfs.tlfs04   #批號
       LET sr2.tlfs06 = sr.tlfs.tlfs06   #製造批號
       LET sr2.tlfs05 = sr.tlfs.tlfs05   #序號
       LET sr2.tlfs07 = sr.tlfs.tlfs07   #單位

       IF tm.a = '1' THEN 
            LET sr2.tlsdate = sr.tlfs.tlfs111   #單據日期
       ELSE 
            LET sr2.tlsdate = sr.tlfs.tlfs12    #異動日期
       END IF

      CALL s_get_doc_no(sr.tlfs.tlfs10) RETURNING g_sheet

      SELECT smydesc INTO sr2.tlfs08
        FROM smy_file 
       WHERE smyslip = g_sheet

      IF sr.tlfs.tlfs09 = -1 THEN
         LET sr2.tlfs13 = sr.tlfs.tlfs13 * (-1)
         LET sr2.status = '1'   #出庫
      ELSE
         LET sr2.tlfs13 = sr.tlfs.tlfs13
         LET sr2.status = '2'   #入庫 
      END IF    
       
         EXECUTE insert_prep USING sr2.tlfs10,sr2.tlsdate,sr2.tlfs01,sr2.ima02,
                                   sr2.ima021,sr2.tlfs02,sr2.tlfs03,sr2.tlfs04,
                                   sr2.tlfs06,sr2.tlfs05,sr2.tlfs07,sr2.tlfs08,
                                   sr2.tlfs13,sr2.status
      END FOREACH               
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                    
    IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'tlfs08,tlfs01,tlfs06,tlfs05,tlfs02,tlfs03,tlfs04,tlfs111,tlfs111,tlfs12,tlfs12')
           RETURNING tm.wc                                                      
      LET l_str = tm.wc                                                         
    END IF                                                                      
    LET l_str = l_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",  
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",        
                tm.u[2,2],";",tm.u[3,3]                               
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    CALL cl_prt_cs3('aimr240','aimr240',l_sql,l_str)                            
END FUNCTION
#FUN-B80142
