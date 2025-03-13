# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr100.4gl
# Descriptions...: 济南薪资
# Date & Author..: 14/01/21   by shenran
#xie150423
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            l_year LIKE type_file.num5,
            l_month LIKE type_file.num5,  
            l_hrbl02 LIKE hrbl_file.hrbl02,
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
              "hrdl02.hrdl_file.hrdl02,",
              "hrap02.hrap_file.hrap02,",
              "hrat72.hrat_file.hrat72,",
              "ISteamleader.type_file.chr1,",
              "sex.type_file.chr10,",
              "edu.type_file.chr20,",
              "hraf02.hraf_file.hraf02,",
              "hrat25.hrat_file.hrat25,",
              "hrat26.hrat_file.hrat26,",
              "hrbh04.hrbh_file.hrbh04,",
              "hrdeud02.hrde_file.hrdeud02,",
              "hrdpud13.hrdp_file.hrdpud13,",                  
      "col01.type_file.num15_3,",
      "col02.type_file.num15_3,",
      "col03.type_file.num15_3,",
      "col04.type_file.num15_3,",
      "col05.type_file.num15_3,",
      "col06.type_file.num15_3,",
      "col07.type_file.num15_3,",
      "col08.type_file.num15_3,",
      "col09.type_file.num15_3,",
      "col10.type_file.num15_3,",
      "col11.type_file.num15_3,",
      "col12.type_file.num15_3,",
      "col13.type_file.num15_3,",
      "col14.type_file.num15_3,",
      "col15.type_file.num15_3,",
      "col16.type_file.num15_3,",
      "col17.type_file.num15_3,",
      "col18.type_file.num15_3,",
      "col19.type_file.num15_3,",
      "col20.type_file.num15_3,",
      "col21.type_file.num15_3,",
      "col22.type_file.num15_3,",
      "col221.type_file.num15_3,",
      "col23.type_file.num15_3,",
      "col24.type_file.num15_3,",
      "col25.type_file.num15_3,",
      "col26.type_file.num15_3,",
      "col27.type_file.num15_3,",
      "col28.type_file.num15_3,",
      "col29.type_file.num15_3,",
      "col291.type_file.num15_3,",      
      "col30.type_file.num15_3,",
      "col31.type_file.num15_3,",
      "col32.type_file.num15_3,",
      "col33.type_file.num15_3,",
      "col34.type_file.num15_3,",
      "col35.type_file.num15_3,",
      "col36.type_file.num15_3,",
      "col37.type_file.num15_3,",
      "col38.type_file.num15_3,",
      "col39.type_file.num15_3,",
      "col40.type_file.num15_3,",
      "col41.type_file.num15_3,",
      "col42.type_file.num15_3,",
      "col43.type_file.num15_3,",
      "col44.type_file.num15_3,",
      "col45.type_file.num15_3,",
      "col46.type_file.num15_3,",
      "col47.type_file.num15_3,",
      "col48.type_file.num15_3,",
      "col49.type_file.num15_3,",
      "col50.type_file.num15_3,",
      "col51.type_file.num15_3,",
      "col52.type_file.num15_3,",
      "col53.type_file.num15_3,",
      "col54.type_file.num15_3,",
      "col55.type_file.num15_3,",
      "col56.type_file.num15_3,",
      "col57.type_file.num15_3,",
      "col58.type_file.num15_3,",
      "col59.type_file.num15_3,",
      "col60.type_file.num15_3,",
      "col61.type_file.num15_3,",
      "col62.type_file.num15_3,",
      "col63.type_file.num15_3,",
      "col64.type_file.num15_3,",
      "col65.type_file.num15_3,",
      "col66.type_file.num15_3,",
      "col67.type_file.num15_3,",
      "col68.type_file.num15_3,",
      "col69.type_file.num15_3,",
      "col70.type_file.num15_3,",
      "col71.type_file.num15_3,",
      "col72.type_file.num15_3,",
      "col73.type_file.num15_3,",
      "col74.type_file.num15_3,",
      "col75.type_file.num15_3,",
      "col76.type_file.num15_3,",
      "col77.type_file.num15_3,",
      "col78.type_file.num15_3,",
      "col79.type_file.num15_3"
      
   LET l_table = cl_prt_temptable('ghrr100',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr100_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr100_tm(p_row,p_col)
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
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr100_w AT p_row,p_col WITH FORM "ghr/42f/ghrr100"
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
    CONSTRUCT BY NAME tm.wc ON hrat01,hrat42,hrat20,hraoud02

      BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
       AFTER FIELD hrat01
       AFTER FIELD hrat42
          	
       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hrat42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"    
                 LET g_qryparam.form = "q_hrai031"
                # LET g_qryparam.arg1 = "%"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat42
                 NEXT FIELD hrat42
            
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"                     
            	 LET g_qryparam.form = "q_hrat01_3"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01

              WHEN INFIELD(hrat20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat20
                 NEXT FIELD hrat20                 
                 
              WHEN INFIELD(hraoud02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"      
                 LET g_qryparam.arg1='202'    
            	 LET g_qryparam.form = "q_hrag06"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraoud02
                 NEXT FIELD hraoud02   

            
             
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
 
   DISPLAY BY NAME tm.l_year                 
    INPUT BY NAME tm.l_hrbl02 WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 

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

       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(l_hrbl02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"    
                 LET g_qryparam.form = "q_hrbl01"
                 CALL cl_create_qry() RETURNING tm.l_hrbl02
                 DISPLAY BY NAME tm.l_hrbl02
                 NEXT FIELD l_hrbl02
             
              OTHERWISE
                 EXIT CASE
           END CASE       
 
    END INPUT
 
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
              WHERE zz01='ghrr100'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr100','9031',1)  
       ELSE
         # LET tm.wc=cl_replace_str(tm.wc, "'", "\" ")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                        #  " '",tm.wc CLIPPED,"'",               #FUN-750047 add
                       #   " '",g_argv1 CLIPPED,"'",
                       #   " '",g_argv2 CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
      CALL cl_cmdat('ghrr100',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr100_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr100()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr100_w
END FUNCTION
 
FUNCTION ghrr100()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 addn
          l_rep_name STRING ,
          sr        RECORD
                     hrat01       LIKE hrat_file.hrat01,
                     hrat02       LIKE hrat_file.hrat02,
                     hrao02       LIKE hrao_file.hrao02,
                     hrdl02       LIKE hrdl_file.hrdl02,
                    hrap02      LIKE hrap_file.hrap02,
                    hrat72      LIKE hrat_file.hrat72,
                    ISteamleader LIKE type_file.chr1,
                    sex         LIKE type_file.chr10,
                    edu         LIKE type_file.chr20,
                    hraf02      LIKE hraf_file.hraf02,
                    hrat25      LIKE hrat_file.hrat25,
                    hrat26      LIKE hrat_file.hrat26,
                    hrbh04      LIKE hrbh_file.hrbh04,      
                    hrdeud02    LIKE hrde_file.hrdeud02,
                    hrdpud13    LIKE hrdp_file.hrdpud13,             
                    col01       LIKE type_file.num15_3,
                    col02       LIKE type_file.num15_3,
                    col03       LIKE type_file.num15_3,
                    col04       LIKE type_file.num15_3,
                    col05       LIKE type_file.num15_3,
                    col06       LIKE type_file.num15_3,
                    col07       LIKE type_file.num15_3,
                    col08       LIKE type_file.num15_3,
                    col09       LIKE type_file.num15_3,
                    col10       LIKE type_file.num15_3,
                    col11       LIKE type_file.num15_3,
                    col12       LIKE type_file.num15_3,
                    col13       LIKE type_file.num15_3,
                    col14       LIKE type_file.num15_3,
                    col15       LIKE type_file.num15_3,
                    col16       LIKE type_file.num15_3,
                    col17       LIKE type_file.num15_3,
                    col18       LIKE type_file.num15_3,
                    col19       LIKE type_file.num15_3,
                    col20       LIKE type_file.num15_3,
                    col21       LIKE type_file.num15_3,
                    col22       LIKE type_file.num15_3,
                    col221       LIKE type_file.num15_3,
                    col23       LIKE type_file.num15_3,
                    col24       LIKE type_file.num15_3,
                    col25       LIKE type_file.num15_3,
                    col26       LIKE type_file.num15_3,
                    col27       LIKE type_file.num15_3,
                    col28       LIKE type_file.num15_3,
                    col29       LIKE type_file.num15_3,
                    col291      LIKE type_file.num15_3,                    
                    col30       LIKE type_file.num15_3,
                    col31       LIKE type_file.num15_3,
                    col32       LIKE type_file.num15_3,
                    col33       LIKE type_file.num15_3,
                    col34       LIKE type_file.num15_3,
                    col35       LIKE type_file.num15_3,
                    col36       LIKE type_file.num15_3,
                    col37       LIKE type_file.num15_3,
                    col38       LIKE type_file.num15_3,
                    col39       LIKE type_file.num15_3,
                    col40       LIKE type_file.num15_3,
                    col41       LIKE type_file.num15_3,
                    col42       LIKE type_file.num15_3,
                    col43       LIKE type_file.num15_3,
                    col44       LIKE type_file.num15_3,
                    col45       LIKE type_file.num15_3,
                    col46       LIKE type_file.num15_3,
                    col47       LIKE type_file.num15_3,
                    col48       LIKE type_file.num15_3,
                    col49       LIKE type_file.num15_3,
                    col50       LIKE type_file.num15_3,
                    col51       LIKE type_file.num15_3,
                    col52       LIKE type_file.num15_3,
                    col53       LIKE type_file.num15_3,
                    col54       LIKE type_file.num15_3,
                    col55       LIKE type_file.num15_3,
                    col56       LIKE type_file.num15_3,
                    col57       LIKE type_file.num15_3,
                    col58       LIKE type_file.num15_3,
                    col59       LIKE type_file.num15_3,
                    col60       LIKE type_file.num15_3,
                    col61       LIKE type_file.num15_3,
                    col62       LIKE type_file.num15_3,
                    col63       LIKE type_file.num15_3,
                    col64       LIKE type_file.num15_3,
                    col65       LIKE type_file.num15_3,
                    col66       LIKE type_file.num15_3,
                    col67       LIKE type_file.num15_3,
                    col68       LIKE type_file.num15_3,
                    col69       LIKE type_file.num15_3,
                    col70       LIKE type_file.num15_3,
                    col71       LIKE type_file.num15_3,
                    col72       LIKE type_file.num15_3,
                    col73       LIKE type_file.num15_3,
                    col74       LIKE type_file.num15_3,
                    col75       LIKE type_file.num15_3,
                    col76       LIKE type_file.num15_3,
                    col77       LIKE type_file.num15_3,
                    col78       LIKE type_file.num15_3,
                    col79       LIKE type_file.num15_3                   
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
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                      " ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                      " ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?, ?,?,?,?,?  ,?,?,?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
  # LET tm.wc = cl_replace_str(tm.wc,"byear","hrct01")
   #LET tm.wc = cl_replace_str(tm.wc,"bmonth","hrct02")

   SELECT hrbl04,hrbl05 INTO tm.l_year,tm.l_month
    FROM hrbl_file WHERE hrbl02=tm.l_hrbl02  

   IF cl_null(tm.wc) THEN
       LET tm.wc=" 1=1 " 
    END IF 
  #xie150423
   LET l_sql = "SELECT HRat01,hrat02,hrao02,hrdl02,hras04,hrat72,",
"       case when hrat05='705' then '1' else '' end, ",
"       case when hrat17='001' then '男' when hrat17='002' then '女' else '' end ,",
"       hrag07,hraf02,hrat25,hrat26,hrbh04,hrdeud02,hrdpud13,",
"       MAX(CASE WHEN hrdxb03=2   THEN hrdxb05  END) col1,",#*转正月份*
"       MAX(CASE WHEN hrdxb03=52 or hrdxb03=158  THEN hrdxb05  END) col2,",#*全勤奖基准
"       MAX(CASE WHEN (hrdxb03=6 or hrdxb03=76)  THEN hrdxb05  END) col3,",#*应出勤天数*
"       MAX(CASE WHEN (hrdxb03=7 or hrdxb03=77)  THEN hrdxb05  END) col4,",#*实际出勤天数*
"       MAX(CASE WHEN (hrdxb03=43 or hrdxb03=78) THEN hrdxb05  END) col5,",#*事假*
"       MAX(CASE WHEN (hrdxb03=27 or hrdxb03=79) THEN hrdxb05  END) col6,",#*异常考勤*
"       MAX(CASE WHEN (hrdxb03=44 or hrdxb03=20 or hrdxb03=80) THEN hrdxb05  END) col7,",#*病假其他假*
"       MAX(CASE WHEN (hrdxb03=45 or hrdxb03=81) THEN hrdxb05  END) col8,",#*年假*
"       MAX(CASE WHEN (hrdxb03=46 or hrdxb03=82）THEN hrdxb05  END) col9,",#*哺乳假*
"       MAX(CASE WHEN (hrdxb03=47 or hrdxb03=83) THEN hrdxb05  END) col10,",#*工伤假*
"       0 as col11,",#其他假（取消）
"       MAX(CASE WHEN (hrdxb03=8 or hrdxb03=85)  THEN hrdxb05  END) col12,",#*加班时间(时)*
"       MAX(CASE WHEN hrdxb03=133 or hrdxb03=154  THEN hrdxb05  END) col13,",#*职级补贴*
"       MAX(CASE WHEN hrdxb03=17 or hrdxb03=105  THEN hrdxb05  END) col14,",#*基本工资*
"       MAX(CASE WHEN (hrdxb03=149 or hrdxb03=153)THEN hrdxb05  END) col15,",#*是否影响全勤奖*
"       MAX(CASE WHEN (hrdxb03=53 or hrdxb03=87) THEN hrdxb05  END) col16,",#*管理津贴*
"       MAX(CASE WHEN hrdxb03=51  THEN hrdxb05  END) col17,",#*保密费*
"       MAX(CASE WHEN hrdxb03=54 or hrdxb03=155  THEN hrdxb05  END) col18,",#*加班费*
"       MAX(CASE WHEN hrdxb03=55 or hrdxb03=156  THEN hrdxb05  END) col19,",#*行为规范奖基准值*
"       MAX(CASE WHEN hrdxb03=147 or hrdxb03=157 THEN to_number(hrdxb05)  END) col20,",#*当月行为规范扣款*
"       MAX(CASE WHEN (hrdxb03=13 or hrdxb03=88) THEN hrdxb05  END) col21,",#*行为规范奖*
"       MAX(CASE WHEN hrdxb03=15 THEN round(hrdxb05/3 ,0 ) WHEN hrdxb03=159  THEN round(hrdxb05 ,0 )  END ) col22,",#季绩效奖金基准
"       MAX(CASE WHEN hrdxb03=150 THEN hrdxb05  END ) col221,",#参与考核月数
"       MAX(CASE WHEN hrdxb03=111 or hrdxb03=161 THEN to_number(hrdxb05)  END) col23,",#*绩效奖金系数*
"       MAX(CASE WHEN (hrdxb03=56 or hrdxb03=89) THEN hrdxb05  END) col24,",#*实际绩效奖金*
"       MAX(CASE WHEN (hrdxb03=16 or hrdxb03=112) THEN hrdxb05  END) col25,",#*提成总额*
"       MAX(CASE WHEN (hrdxb03=57 or hrdxb03=113) THEN hrdxb05  END) col26,",#*安全奖*
"       MAX(CASE WHEN (hrdxb03=49 or hrdxb03=90) THEN hrdxb05  END) col27,",#*技能*
"       MAX(CASE WHEN (hrdxb03=50 or hrdxb03=91) THEN hrdxb05  END) col28,",#*特殊岗位津贴*
"       MAX(CASE WHEN (hrdxb03=58 or hrdxb03=110) THEN hrdxb05  END) col29,",#*驻外
"       MAX(CASE WHEN (hrdxb03=61 or hrdxb03=95) THEN hrdxb05  END) col291,",#*(新)带薪假期补贴(一线)
"       MAX(CASE WHEN (hrdxb03=148 or hrdxb03=162) THEN hrdxb05  END) col30,",#*基本工资(工资条)*
"       MAX(CASE WHEN (hrdxb03=18 or hrdxb03=106) THEN hrdxb05  END) col31,",#*加班工资及补贴(工资条)*
"       MAX(CASE WHEN hrdxb03=51  THEN hrdxb05  END) col32,",#*保密费(工资条)*
"       MAX(CASE WHEN (hrdxb03=19 or hrdxb03=92) THEN hrdxb05  END) col33,",#*全勤奖(工资条)*
"       MAX(CASE WHEN hrdxb03=21 or hrdxb03=164  THEN hrdxb05  END) col34,",#*职称*
"       MAX(CASE WHEN (hrdxb03=137 or hrdxb03=93) THEN hrdxb05  END) col35,",#*工龄*
"       MAX(CASE WHEN (hrdxb03=23 or hrdxb03=107) THEN hrdxb05  END) col36,",#*补贴小计*
"       MAX(CASE WHEN hrdxb03=24 or hrdxb03=165 THEN hrdxb05  END) col37,",#*采编津贴*
"       MAX(CASE WHEN hrdxb03=25 or hrdxb03=166  THEN hrdxb05  END) col38,",#*讲师津贴*
"       MAX(CASE WHEN hrdxb03=59 or hrdxb03=167  THEN hrdxb05  END) col39,",#*工伤补助*
"       MAX(CASE WHEN (hrdxb03=94)  THEN hrdxb05  END) col40,",#*病假补助(计件直接)*
"       MAX(CASE WHEN (hrdxb03=61)  THEN hrdxb05  END) col41,",#*带薪假期补贴*
"       MAX(CASE WHEN hrdxb03=62 or hrdxb03=168 THEN hrdxb05  END) col42,",#*春节加班补贴*
"       MAX(CASE WHEN hrdxb03=63 or hrdxb03=169  THEN hrdxb05  END) col43,",#*其他加项*
"       MAX(hrdxa18)+MAX(CASE WHEN hrdxb03=64 or hrdxb03=170  THEN hrdxb05  END) col44,",#*调整上月加项*
"       MAX(CASE WHEN (hrdxb03=26 or hrdxb03=109) THEN hrdxb05  END) col45,",#*其他收入小计*
"       MAX(CASE WHEN (hrdxb03=144 or hrdxb03=96) THEN hrdxb05  END) col46,",#*缺勤扣款*
"       MAX(CASE WHEN hrdxb03=65 or hrdxb03=171  THEN hrdxb05  END) col47,",#*其他应收款项*
"       MAX(hrdxa08) col48,",#*应付工资*
"       MAX(CASE WHEN hrdxc03=5   THEN to_number(hrdxc05)  END) col49,",#*养老*
"       MAX(CASE WHEN hrdxc03=1   THEN to_number(hrdxc05)  END) col50,",#*医疗*
"       MAX(CASE WHEN hrdxc03=21  THEN to_number(hrdxc05)  END) col51,",#*大病*
"       MAX(CASE WHEN hrdxc03=45  THEN to_number(hrdxc05)  END) +",#
"       MAX(CASE WHEN hrdxc03=49  THEN to_number(hrdxc05)  END) col52,",#*补充医疗*
"       MAX(CASE WHEN hrdxc03=17  THEN to_number(hrdxc05)  END) col53,",#*失业*
"       MAX(CASE WHEN hrdxc03=7   THEN to_number(hrdxc05)  END) + MAX(CASE WHEN hrdxc03=3 THEN to_number(hrdxc05)  END) + MAX(CASE WHEN hrdxc03=47 THEN to_number(hrdxc05)  END)",#
"       + MAX(CASE WHEN hrdxc03=51 THEN to_number(hrdxc05)  END) + MAX(CASE WHEN hrdxc03=19 THEN to_number(hrdxc05)  END) col54,",#*社保补缴*
"       MAX(CASE WHEN (hrdxb03=97) THEN to_number(hrdxc05)  END) col55,",#*社保调整*
"       MAX(CASE WHEN hrdxb03=34  THEN hrdxb05  END) col56,",#*个缴社保*
"       MAX(CASE WHEN hrdxc03=25  THEN to_number(hrdxc05)  END) col57,",#*公积金*
"       MAX(CASE WHEN hrdxc03=27  THEN to_number(hrdxc05)  END) col58,",#*公积金补缴*
"       MAX(CASE WHEN (hrdxb03=98) THEN to_number(hrdxc05)  END) col59,",#*公积金调整*
"       MAX(CASE WHEN hrdxb03=35  THEN hrdxb05  END) col60,",#*个缴公积金*
"       MAX(hrdxa12) col61,",#*个税*
"       MAX(CASE WHEN (hrdxb03=138 or hrdxb03=99) THEN hrdxb05  END) col62,",#*午餐补贴*
"       MAX(CASE WHEN (hrdxb03=139 or hrdxb03=100) THEN hrdxb05  END) col63,",#*交通补贴*
"       MAX(CASE WHEN (hrdxb03=141 or hrdxb03=101) THEN hrdxb05  END) col64,",#*通讯补贴*
"       MAX(CASE WHEN hrdxb03=66  THEN hrdxb05  END) col65,",#*高温补贴*
"       MAX(CASE WHEN (hrdxb03=142 or hrdxb03=102) THEN hrdxb05  END) col66,",#*缺勤补贴扣款*
"       MAX(CASE WHEN hrdxb03=67  THEN hrdxb05  END) col67,",#*水电*
"       MAX(CASE WHEN hrdxc03=151 THEN to_number(hrdxc05)  END) col68,",#*稽核扣款天数*
"       MAX(CASE WHEN (hrdxb03=68 or hrdxb03=103) THEN hrdxb05  END) col69,",#*稽核扣款(天数折算金额）*
"       MAX(CASE WHEN hrdxb03=69 THEN hrdxb05  END) col70,",#*稽核扣款(金额）*
"       MAX(CASE WHEN hrdxb03=70  THEN hrdxb05  END) col71,",#*品质部扣款*
"       MAX(CASE WHEN hrdxb03=71  THEN hrdxb05  END) col72,",#*6S扣款*
"       MAX(CASE WHEN hrdxb03=72  THEN hrdxb05  END) col73,",#*档案费*
"       MAX(CASE WHEN hrdxb03=73  THEN hrdxb05  END) col74,",#*其他减项*
"       MAX(CASE WHEN (hrdxb03=42 or hrdxb03=108) THEN hrdxb05  END) col75,",#*代扣小计*
"       MAX(hrdxa14) col76 ,",#*月实发金额*
"       MAX(CASE WHEN (hrdxb03=143) THEN hrdxb05  END) col77,",#*(新)离职扣款*
"       MAX(CASE WHEN (hrdxb03=104) THEN hrdxb05  END) col78, ",#*调整上月减项*
"       MAX(CASE WHEN (hrdxb03=160 or hrdxb03=152) THEN hrdxb05  END) col79 ",#*考核分值*
"  FROM HRDXA_FILE",
"  LEFT JOIN HRCT_FILE ON HRCT11 = HRDXA01",
"  inner JOIN HRDXB_FILE ON HRDXB02 = HRDXA02 AND HRDXB01 = HRDXA01",
"  LEFT JOIN hrdxc_file ON hrdxc02=HRDXB02 and hrdxc01=HRDXB01 and hrdxc03=HRDXB03 ",
"  left join hrat_file on HRDXA02=hratid",
"  left join hrdm_file on hratid=hrdm02 ",
"  left join hrdl_file on hrdm03=hrdl01 ",
"  left join hras_file on hrat05=hras01 ",
"  left join hrag_file on hrat22=hrag06 and hrag01='317' ",
"  left join hraf_file on hrat40=hraf01 ", 
"  left join hrai_file on hrat42=hrai03 ",
"  left join hrao_file on hrao01=hrat04 ",
"  left join (select t2.hrdpud13,t2.hrdp04,t1.hrdp09,t1.hrdpud02,t1.hrdpud03 from hrdp_file t1 inner join  (select max(hrdpud13) hrdpud13,hrdp04 from hrdp_file ",
"  group by hrdp04) t2 on t1.hrdp04=t2.hrdp04 and t1.hrdpud13=t2.hrdpud13) t3 on hrdp04=hratid and hrdp09='003' ",
"  left join hrde_file on hrde01='001' and hrde03=hrdpud02 and hrde05=hrdpud03 ",
"  left join hrbh_file on hratid=hrbh01 ",
" WHERE hrct01=",tm.l_year," and hrct02=",tm.l_month," and ",tm.wc CLIPPED," GROUP BY hrat01,hrat02,hrao02,hrdl02,hras04,hrat72,hrat05,hrat17,hrag07,hraf02,hrat25,hrat26,hrbh04,hrdeud02,hrdpud13 "

                   
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr100_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
       
          EXECUTE insert_prep USING sr.*
      END FOREACH

    LET l_rep_name="ghr/ghrr100.cpt&p2=",tm.l_year,"&p3=",tm.l_month     
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
