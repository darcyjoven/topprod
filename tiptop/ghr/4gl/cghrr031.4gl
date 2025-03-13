# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: cghrr031.4gl
# Descriptions...: 济南薪资
# Date & Author..: 14/01/21   by shenran

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
 
   LET g_sql ="hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,",
              "hrat04.hrat_file.hrat04,",
              "bm1_hrao02.hrao_file.hrao02,",
              "bm1_hraoud02.type_file.chr20,",
              "bm02_hrao02.type_file.chr20,",
              "bm03_hrao02.type_file.chr20,",
              "bm04_hrao02.type_file.chr20,",              
              "hras04.hras_file.hras04,",
              "hrat58.type_file.chr20,",
              "hrad03.hrad_file.hrad03,",
              "hrat06.hrat_file.hrat02,",
              "hrat18.hrat_file.hrat18,",
              "hrat22.hrag_file.hrag07,",
              "hrat13.hrat_file.hrat13,",
              "hrat25.hrat_file.hrat25,",
              "hrat49.hrat_file.hrat49,",
              "hrat72.hrat_file.hrat72,",
              "hrat80.hrat_file.hrat80,",
              "hrat81.hrat_file.hrat81,",
              "hrat82.hrat_file.hrat82,",
              "hrat85.hrat_file.hrat85,",
              "hrai02.hrai_file.hrai02,",
              "hray24.hray_file.hray24,",
              "hray02.hray_file.hray02,",
              "hr_status.type_file.chr30,",
              "az1_hraz05.hraz_file.hraz05,",
              "az1_hrazud01.hraz_file.hrazud01,",
              "hrasud01.hras_file.hrasud01,",              
              "bm2_hrao02.hrao_file.hrao02,",
              "bm3_hrao02.hrao_file.hrao02,",
              "hrbh04.hrbh_file.hrbh04,",
              "hrbh02.type_file.chr20,",
              "hrbh05.hrag_file.hrag07,",
              "az2_hraz05.hraz_file.hraz05,",
              "az2_hraz09.hras_file.hras04,",
              "n1.type_file.num5,",
              "hrbf08.hrbf_file.hrbf08,",
              "hrbf09.hrbf_file.hrbf09,",
              "hrbf11.hraa_file.hraa12,",
              "n2.type_file.num5,",
              "du1_hrdu04.hrdu_file.hrdu04,",
              "du1_hrdt04.hrdt_file.hrdt04,",
              "dw1_hrdw04.hrdw_file.hrdw04,",
              "dw1_hrdw05.hrdw_file.hrdw04,", 
              "du1_hrdu04_1.hrdu_file.hrdu04,",              
              "du2_hrdu04.hrdu_file.hrdu04,",
              "dw2_hrdw04.hrdw_file.hrdw05,",
              "dw2_hrdw05.hrdw_file.hrdw05,",
              "du2_hrdu04_1.hrdu_file.hrdu04"

   LET l_table = cl_prt_temptable('cghrr031',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL cghrr031_tm(0,0)        # Input print condition
   ELSE
      CALL cghrr031()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION cghrr031_tm(p_row,p_col)
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
  OPEN WINDOW cghrr031_w AT p_row,p_col WITH FORM "ghr/42f/cghrr031"
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
                 NEXT FIELD hrao01
            
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
              WHERE zz01='cghrr031'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('cghrr031','9031',1)  
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
      CALL cl_cmdat('cghrr031',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW cghrr031_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL cghrr031()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW cghrr031_w
END FUNCTION
 
FUNCTION cghrr031()
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
                     hrat01 LIKE hrat_file.hrat01,
                     hrat02 LIKE hrat_file.hrat02,
                     hrat04 LIKE hrat_file.hrat04,
                     bm1_hrao02 LIKE hrao_file.hrao02,
                     bm1_hraoud02 LIKE type_file.chr20,
                     bm02_hrao02 LIKE type_file.chr20,
                     bm03_hrao02 LIKE type_file.chr20,
                     bm04_hrao02 LIKE type_file.chr20,                     
                     hras04 LIKE hras_file.hras04,
                     hrat58 LIKE type_file.chr20,
                     hrad03 LIKE hrad_file.hrad03,
                     hrat06 LIKE hrat_file.hrat02,
                     hrat18 LIKE hrat_file.hrat18,
                     hrat22 LIKE hrag_file.hrag07,
                     hrat13 LIKE hrat_file.hrat13,
                     hrat25 LIKE hrat_file.hrat25,
                     hrat49 LIKE hrat_file.hrat49,
                     hrat72 LIKE hrat_file.hrat72,
                     hrat80 LIKE hrat_file.hrat80,
                     hrat81 LIKE hrat_file.hrat81,
                     hrat82 LIKE hrat_file.hrat82,
                     hrat85 LIKE hrat_file.hrat85,
                     hrai02 LIKE hrai_file.hrai02,
                     hray24 LIKE hray_file.hray24,
                     hray02 LIKE hray_file.hray02,
                     hr_status LIKE type_file.chr30,
                     az1_hraz05 LIKE hraz_file.hraz05,
                     az1_hrazud01 LIKE hraz_file.hrazud01,
                     hrasud01 LIKE hras_file.hrasud01,
                     bm2_hrao02 LIKE hrao_file.hrao02,
                     bm3_hrao02 LIKE hrao_file.hrao02,
                     hrbh04 LIKE hrbh_file.hrbh04,
                     hrbh02 LIKE type_file.chr20,
                     hrbh05 LIKE hrag_file.hrag07,
                     az2_hraz05 LIKE hraz_file.hraz05,
                     az2_hraz09 LIKE hras_file.hras04,
                     n1 LIKE type_file.num5,                     
                     hrbf08 LIKE hrbf_file.hrbf08,
                     hrbf09 LIKE hrbf_file.hrbf09,
                     hrbf11 LIKE hraa_file.hraa12,
                     n2 LIKE type_file.num5,
                     du1_hrdu04 LIKE hrdu_file.hrdu04,
                     du1_hrdt04 LIKE hrdt_file.hrdt04,
                     dw1_hrdw04 LIKE hrdw_file.hrdw04,
                     dw1_hrdw05 LIKE hrdw_file.hrdw05, 
                     du1_hrdu04_1 LIKE hrdu_file.hrdu04,                     
                     du2_hrdu04 LIKE hrdu_file.hrdu04,
                     dw2_hrdu04 LIKE hrdw_file.hrdw04,
                     dw2_hrdu05 LIKE hrdw_file.hrdw05,
                     du2_hrdu04_1 LIKE hrdu_file.hrdu04
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_hraa12  LIKE hraa_file.hraa12
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE            l_img_blob     LIKE type_file.blob
   DEFINE l_tmp  STRING  


   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?",
              " ,?,?,?,?,? ,?,?,?,?,?, ?,?,?,?,? ,?,? ,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
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
   --LET tm.s_year=tm.l_year
   --LET tm.s_year=tm.s_year.trim()
   --LET tm.s_month=tm.l_month
   --LET tm.s_month=tm.s_month.trim()
   --LET tm.s_last_year=tm.l_last_year
   --LET tm.s_last_year=tm.s_year.trim()
   --LET tm.s_last_month=tm.l_last_month
   --LET tm.s_last_month=tm.s_last_month.trim()
   --
   --LET tm.l_day=tm.s_year,'/',tm.s_month,'/28'
   --LET tm.l_last_day=tm.s_last_year,'/',tm.s_last_month,'/28'   
   --LET tm.s_hr_month=tm.s_year,'-',tm.s_month,'(集团公司)'
  
   LET l_sql = "select a.hrat01,a.hrat02,a.hrat04,bm1.hrao02,a.hraoud02,bm02.hrao02,bm03.hrao02,bm04.hrao02,as1.hras04,",
               "a.hrat58,hrad03,b.hrat02,a.hrat18,ag1.hrag07,a.hrat13,a.hrat25,a.hrat49,a.hrat72,",
               "a.hrat80,a.hrat81,a.hrat82,a.hrat85,hrai02,",
               " hray24,hray02,'',az1.hraz05,az1.hrazud01,a.hrat83,bm2.hrao02,bm3.hrao02,hrbh04,hrbh02,",
               " ag2.hrag07,az2.hraz05,as2.hras04,az3.n1,bf1.hrbf08,bf1.hrbf09,hraa12,bf2.n2,",
               " case when du1.hrdu03='001' then du1.du04 else '' end ,du1.hrdt04,dw1.dw04,dw1.dw05,",
               " case when du1.hrdu03='002' then du1.du04 else '' end ,case when du2.hrdu03='001' then du2.du04 else '' end ,",
               " dw2.dw04,dw2.dw05,case when du2.hrdu03='002' then du2.du04 else '' end ",
               "  from (select hrat_file.*,hraoud02 from hrat_file,hrao_file where hrat04=hrao01 and ",tm.wc,") a left join hrao_file bm1 on hrat04=bm1.hrao01 ",
               " left join hrao_file bm02 on bm02.hrao01=bm1.hrao06 ",
               " left join hrao_file bm03 on bm03.hrao01=bm02.hrao06 ",
               " left join hrao_file bm04 on bm04.hrao01=bm03.hrao06 ",               
               " left join hrat_file b on a.hrat06=b.hrat01 ",
               " left join hrad_file on a.hrat19=hrad02 ",
               " left join hras_file as1 on a.hrat05=as1.hras01 ",
               " left join hrai_file on a.hrat42=hrai03 ",
               " left join hrag_file ag1 on a.hrat22=ag1.hrag06 and ag1.hrag01='317' ",
               " left join hray_file on a.hratid=hray01 and hray02 <=to_date('",tm.l_day,"','YYYY/MM/DD')",
               " left join hrbh_file on hrbh01=a.hratid and  hrbh04 <=to_date('",tm.l_day,"','YYYY/MM/DD')",
               " left join hrag_file ag2 on hrbh05=ag2.hrag06 and ag2.hrag01='310' ",                              
               " left join (select hraz03,max(hraz01) as hraz01,count(*) as n1 from hraz_file where hraz04<>'001' and ",
               " hraz05 <=to_date('",tm.l_day,"','YYYY/MM/DD') group by hraz03) az3 on az3.hraz03=a.hratid ",
               " left join (select hraz03,max(hraz01) as hraz01,count(*) as n1 from hraz_file where hraz04='001' and ",
               " hraz05<=to_date('",tm.l_day,"','YYYY/MM/DD') group by hraz03) az4 on az4.hraz03=a.hratid ",
               " left join hraz_file az1 on az3.hraz03=az1.hraz03 and az1.hraz01=az1.hraz01 ",
               " left join hraz_file az2 on az4.hraz03=az2.hraz03 and az4.hraz01=az2.hraz01 ",
               " left join hras_file as2 on az2.hraz09=as2.hras01 ",               
               " left join hrao_file bm2 on az1.hraz08=bm2.hrao01 ",
               " left join hrao_file bm3 on az1.hraz07=bm3.hrao01 ",
               " left join (select hrbf02,max(hrbf08) as hrbf08,max(hrbf09) as hrbf09 from hrbf_file group by hrbf02)bf1 on a.hratid=bf1.hrbf02 ",
               " left join hrbf_file bf3 on bf3.hrbf02=bf1.hrbf02 and bf3.hrbf08=bf1.hrbf08 ", 
               " left join hraa_file on bf3.hrbf11=hraa01 ",
               " left join (select hrbf02,count(*) as n2 from hrbf_file group by hrbf02) bf2 on a.hratid=bf2.hrbf02 ",
               " left join  (select hrdu01,hrdt04,min(hrdu04) as du04,hrdu03 from hrdu_file, ",
               " hrdt_file where hrdu02=hrdt01 and hrdu05<>'007' group by hrdu01,hrdt04,hrdu03) du1 on du1.hrdu01=a.hratid ",
               " left join  (select hrdu01,hrdt04,min(hrdu04) as du04,hrdu03 from hrdu_file, ",
               " hrdt_file where hrdu02=hrdt01 and hrdu05='007' group by hrdu01,hrdt04,hrdu03) du2 on du2.hrdu01=a.hratid ",               
               " left join (select hrdw01,sum(hrdw04+hrdw06) as dw04,sum(hrdw05+hrdw07) as dw05 from hrdw_file ",
               " where hrdw03='",tm.s_hr_month,"' and hrdw02<>'007' group by hrdw01) dw1 on dw1.hrdw01=a.hratid ",
               " left join (select hrdw01,sum(hrdw04+hrdw06) as dw04, sum(hrdw05+hrdw07) as dw05 from hrdw_file ", 
               " where hrdw03='",tm.s_hr_month,"' and hrdw02='007' group by hrdw01) dw2 on dw2.hrdw01=a.hratid ",
               " where (a.hrat19='1001' or a.hrat19='2001'  or a.hrat19='006' or ",
               " (hrbh04 between to_date('",tm.l_last_day,"','YYYY/MM/DD') and to_date('",tm.l_day,"','YYYY/MM/DD') )) ",
               " order by hrat01 "

                   
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('cghrr031_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

           IF cl_null(sr.bm02_hrao02) THEN
              LET sr.bm02_hrao02=sr.bm1_hrao02 
           END IF 

           IF cl_null(sr.bm03_hrao02) THEN
              LET sr.bm03_hrao02=sr.bm02_hrao02 
           END IF 

           IF cl_null(sr.bm04_hrao02) THEN
              LET sr.bm04_hrao02=sr.bm03_hrao02 
           END IF 

           
           LET sr.hr_status=''
           IF (year(sr.hrat25)=tm.l_year AND month(sr.hrat25)=tm.l_month) THEN
              LET sr.hr_status=sr.hr_status,'新进'  
           END IF  

           IF (year(sr.hray02)=tm.l_year AND month(sr.hray02)=tm.l_month) THEN
              LET sr.hr_status=sr.hr_status,'转正'  
           END IF  
           
           IF (year(sr.hrbh04)=tm.l_year AND month(sr.hrbh04)=tm.l_month) THEN
              LET sr.hr_status=sr.hr_status,'离职'  
           END IF  

           IF (year(sr.AZ1_HRAZ05)=tm.l_year AND month(sr.AZ1_HRAZ05)=tm.l_month) THEN
              LET sr.hr_status=sr.hr_status,'调动'  
           END IF  

           IF (year(sr.AZ2_HRAZ05)=tm.l_year AND month(sr.AZ2_HRAZ05)=tm.l_month) THEN
              LET sr.hr_status=sr.hr_status,'晋升'  
           END IF  
           
           
           CASE sr.bm1_hraoud02
           WHEN '001'
                LET sr.bm1_hraoud02='萧山基地'
           WHEN '002'
                LET sr.bm1_hraoud02='海宁基地'
           OTHERWISE
                LET sr.bm1_hraoud02='非基地'
           END CASE 

           CASE sr.hrat58 
            WHEN '1'
                LET sr.hrat58='合同工'
            WHEN '2'
                LET sr.hrat58='临时工'
            WHEN '3'
                LET sr.hrat58='派遣工'
            WHEN '4'
                LET sr.hrat58='协议工'
            otherwise
                LET sr.hrat58='其他'
            END CASE     

           CASE sr.hrbh02
             WHEN '1'
                LET sr.hrbh02='主动离职'
             WHEN '2'
                LET sr.hrbh02='退休'
             WHEN '3'
                LET sr.hrbh02='被动离职'
             WHEN '4'
                LET sr.hrbh02='自离'
            END CASE

          LET l_tmp_str=cl_replace_str(sr.du1_hrdu04,'(集团公司)','')
          LET l_du_year =l_tmp_str.subString(1,4)
          LET l_du_month = l_tmp_str.subString(6,l_tmp_str.getLength())
          LET l_i= l_tmp_str.getLength()
          IF l_du_year>tm.l_year OR l_du_month>tm.l_month THEN
             LET sr.du1_hrdu04='' 
          END IF 

          LET l_tmp_str=cl_replace_str(sr.du1_hrdu04_1,'(集团公司)','')
          LET l_du_year =l_tmp_str.subString(1,4)
          LET l_du_month = l_tmp_str.subString(6,l_tmp_str.getLength())

          IF l_du_year>tm.l_year OR l_du_month>tm.l_month THEN
             LET sr.du1_hrdu04_1='' 
          END IF       

          LET l_tmp_str=cl_replace_str(sr.du2_hrdu04,'(集团公司)','')
          LET l_du_year =l_tmp_str.subString(1,4)
          LET l_du_month = l_tmp_str.subString(6,l_tmp_str.getLength())

          IF l_du_year>tm.l_year OR l_du_month>tm.l_month THEN
             LET sr.du2_hrdu04='' 
          END IF   

          LET l_tmp_str=cl_replace_str(sr.du2_hrdu04_1,'(集团公司)','')
          LET l_du_year =l_tmp_str.subString(1,4)
          LET l_du_month = l_tmp_str.subString(6,l_tmp_str.getLength())

          IF l_du_year>tm.l_year OR l_du_month>tm.l_month THEN
             LET sr.du2_hrdu04_1='' 
          END IF  

 
          EXECUTE insert_prep USING sr.*
      END FOREACH

    LET l_rep_name="ghr/cghrr031.cpt&p2=",tm.s_year,"&p3=",tm.s_month  
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
