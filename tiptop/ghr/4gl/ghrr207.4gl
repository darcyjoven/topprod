# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr207.4gl
# Descriptions...: 员工进出/变动统计表
# Date & Author..: 15/02/05   by shenran
#xie150418
DATABASE ds
 
GLOBALS "../../config/top.global" 
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            l_year LIKE type_file.num5,
            l_month LIKE type_file.num5,
            l_last_year LIKE type_file.num5,
            l_last_month LIKE type_file.num5,            
            s_year STRING,
            s_month STRING,
            s_last_year STRING,
            s_last_month STRING,
            s_hr_month LIKE hrbl_file.hrbl03, 
            l_day date,  
            l_last_day date, 
            l_hrbl02 LIKE hrbl_file.hrbl02
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
 
   LET g_pdate = ARG_VAL(1)       # Get arguments from command line
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
 
   LET g_sql ="hrao02.hrao_file.hrao02,",
              "hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,",
              "hrat17.hrat_file.hrat17,",
              "hrat18.hrat_file.hrat18,",
              "hraf02.hraf_file.hraf02,",
              "hrat25.hrat_file.hrat25,",
              "chg_status.type_file.chr20,",
              "chg_date.type_file.dat,",              
              "salary.type_file.chr50,",
              "hrag07_1.hrag_file.hrag07,",
              "hrag07_2.hrag_file.hrag07," ,
              "hrap06.hrap_file.hrap06"        

   LET l_table = cl_prt_temptable('ghrr207',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr207_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr207()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr207_tm(p_row,p_col)
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
  OPEN WINDOW ghrr207_w AT p_row,p_col WITH FORM "ghr/42f/ghrr207"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat01,hrat04,hraoud02

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
       AFTER FIELD hrat01
       AFTER FIELD hrat04
          	
       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"    
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.arg1 = "%"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
            
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"                     
            	 LET g_qryparam.form = "q_hrat01_3"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
                 
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
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
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr207'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr207','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\" ")
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
      CALL cl_cmdat('ghrr207',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr207_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr207()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr207_w
END FUNCTION
 
FUNCTION ghrr207()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 addn
          l_rep_name STRING ,
          l_du_year LIKE type_file.num5,
          l_du_month LIKE type_file.num5,
          l_i LIKE type_file.num5,
          l_tmp_str string,
          sr        RECORD
                     hrao02 LIKE hrao_file.hrao02,
                     hratid LIKE hrat_file.hratid,
                     hrat02 LIKE hrat_file.hrat02,
                     hrat17 LIKE hrat_file.hrat17,
                     hrat18 LIKE hrat_file.hrat18,
                     hraf02 LIKE hraf_file.hraf02,
                     hrat25 LIKE hrat_file.hrat25,
                     chg_status  LIKE type_file.chr20,
                     chg_date  LIKE type_file.dat,
                     salary  LIKE type_file.chr50,
                     hrag07_1 LIKE hrag_file.hrag07,
                     hrag07_2 LIKE hrag_file.hrag07,
                     hrap06 LIKE hrap_file.hrap06
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_hraa12  LIKE hraa_file.hraa12
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE            l_img_blob     LIKE type_file.blob
   DEFINE l_tmp  STRING  
   DEFINE l_hrbh_n LIKE type_file.num5
   DEFINE l_hraz_n LIKE type_file.chr50


   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   LET tm.wc = cl_replace_str(tm.wc,"byear","hrct01")
   LET tm.wc = cl_replace_str(tm.wc,"bmonth","hrct02")

   SELECT hrbl03,hrbl04,hrbl05,hrbl06,hrbl07 INTO 
    tm.s_hr_month,tm.l_year,tm.l_month,tm.l_last_day,tm.l_day
    FROM hrbl_file WHERE hrbl02=tm.l_hrbl02 

   --IF tm.l_month=1 THEN
      --LET tm.l_last_year=tm.l_year-1
      --LET tm.l_last_month=12      
   --ELSE
      --LET tm.l_last_year=tm.l_year
      --LET tm.l_last_month=tm.l_month-1  
   --END IF    
--
   LET tm.s_year=tm.l_year
   LET tm.s_year=tm.s_year.trim()
   LET tm.s_month=tm.l_month
   LET tm.s_month=tm.s_month.trim()
   --LET tm.s_last_year=tm.l_last_year
   --LET tm.s_last_year=tm.s_year.trim()
   --LET tm.s_last_month=tm.l_last_month
   --LET tm.s_last_month=tm.s_last_month.trim()
   --
   --LET tm.l_day=tm.s_year,'/',tm.s_month,'/28'
   --LET tm.l_last_day=tm.s_last_year,'/',tm.s_last_month,'/28'   
   --LET tm.s_hr_month=tm.s_year,'-',tm.s_month,'(集团公司)'
   

   LET l_sql = " select hrao02,hrat01,hrat02,hrat17,hrat18,hraf02,hrat25,",  #xie150418
               " case when (hrat25>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrat25<=to_date('",tm.l_day,"','YYYY/MM/DD')) then '新进' else '' end|| ",
               " case when (hrat26>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrat26<=to_date('",tm.l_day,"','YYYY/MM/DD')) then '转正' else '' end|| ",
               " case when not hraz04 is null and hraz05>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hraz05<=to_date('",tm.l_day,"','YYYY/MM/DD') then '调职' else '' end|| ",
               " case when not hrbh04 is null and hrbh04>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrbh04<=to_date('",tm.l_day,"','YYYY/MM/DD') then '离职' else '' end,",
               
               " case when not hrbh04 is null and hrbh04>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrbh04<=to_date('",tm.l_day,"','YYYY/MM/DD') then hrbh04 ",   
               " when not hraz04 is null and hraz05>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hraz05<=to_date('",tm.l_day,"','YYYY/MM/DD') then hraz05 ",
               " when (hrat26>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrat26<=to_date('",tm.l_day,"','YYYY/MM/DD')) then hrat26 ", 
               " when (hrat25>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrat25<=to_date('",tm.l_day,"','YYYY/MM/DD')) then hrat25 ",   
               "     else null end,'',a1.hrag07,a2.hrag07 ,hrap06 ", 
               " from hrat_file ",
               " left join hrap_file on hrat05=hrap05 and hrat04=hrap01 ",  --职位 
               " left join hrao_file on hrat04=hrao01 left join hraf_file on hrat40=hraf01 ",
               " left join hrag_file a1 on hrat22=a1.hrag06 and a1.hrag01='317' ",
               " left join hrag_file a2 on hrat79=a2.hrag07 and a2.hrag01='206' ",
               " left join hraz_file on hratid=hraz03 ", 
               " left join hrbh_file on hratid=hrbh01 ",
               " where ( ",
               " (hraz05>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hraz05<=to_date('",tm.l_day,"','YYYY/MM/DD')) or ", 
               " (hrat25>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrat25<=to_date('",tm.l_day,"','YYYY/MM/DD')) or ",
               " (hrbh04>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrbh04<=to_date('",tm.l_day,"','YYYY/MM/DD')) or ",
               " (hrat26>=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrat26<=to_date('",tm.l_day,"','YYYY/MM/DD'))  ",
               " ) "

                   
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr207_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

          select hrdeud02 INTO sr.salary from hrdp_file,hrde_file where hrdpud02=hrde03 
            and hrdpud03=hrde05  AND hrdp04=sr.hratid AND hrdpud13<=tm.l_day
            ORDER BY hrdpud13
                
           EXECUTE insert_prep USING sr.*
      END FOREACH

    LET l_rep_name="ghr/ghrr207.cpt&p2=",tm.s_year,"&p3=",tm.s_month  
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
