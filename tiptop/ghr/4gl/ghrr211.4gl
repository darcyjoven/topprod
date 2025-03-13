# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr211.4gl
# Descriptions...: 薪资对账
# Date & Author..: 15/03/12   by shenran
#xie150411
#xie150413
#xie150414
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
            l_hrbl02 LIKE hrbl_file.hrbl02,
            l_hrbl03 LIKE hrbl_file.hrbl03
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
 
   LET g_sql ="hratid.hrat_file.hratid,",
              "hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,",
              "hrat04.hrat_file.hrat04,",
              "hrao02.hrao_file.hrao02,",
              "hr_status.type_file.chr30,",
              "hrag07.hrag_file.hrag07,",  
              "hrat25.hrat_file.hrat25,",
              "hray02.hray_file.hray02,",
              "hraz05.hraz_file.hraz05,",
              "hrbh04.hrbh_file.hrbh04,",
              "hrcp04.hrcp_file.hrcp04,",
              "hrbo03.hrbo_file.hrbo03,",
              "hrbn02.hrbn_file.hrbn02,",
              "hrdl02.hrdl_file.hrdl02,",              
              "hrdh06.hrdh_file.hrdh06,",
              "hrdeud02.hrde_file.hrdeud02,",
              "hrdpb03.hrdpb_file.hrdpb03,",
              "hrdpb04.hrdpb_file.hrdpb04,",
              "hrdpb05.hrdpb_file.hrdpb05,",
              "hrdt02.hrdt_file.hrdt02,",
              "hrdu04_1.hrdu_file.hrdu04,",
              "hrdu04_2.hrdu_file.hrduud01,",
              "hrdu07.hrdu_file.hrdu07,",
              "hrdu09.hrdu_file.hrdu09,",
              "hrcb02.hrcb_file.hrcb02,",
              "hratg05.hratg_file.hratg05"
              

   LET l_table = cl_prt_temptable('ghrr211',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr200_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr200()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr200_tm(p_row,p_col)
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
  OPEN WINDOW ghrr200_w AT p_row,p_col WITH FORM "ghr/42f/ghrr200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat01,hrat04,hraoud02,hrat20

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
              WHERE zz01='ghrr200'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr200','9031',1)  
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
      CALL cl_cmdat('ghrr200',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr200_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr200()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr200_w
END FUNCTION
 
FUNCTION ghrr200()
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
                     hratid LIKE hrat_file.hratid, 
                     hrat01 LIKE hrat_file.hrat01,
                     hrat02 LIKE hrat_file.hrat02,
                     hrat04 LIKE hrat_file.hrat04,
                     hrao02 LIKE hrao_file.hrao02,
                     hr_status LIKE type_file.chr30,
                     hrag07 LIKE hrag_file.hrag07,
                     hrat25 LIKE hrat_file.hrat25,
                     hray02 LIKE hray_file.hray02,
                     hraz05 LIKE hraz_file.hraz05,
                     hrbh04 LIKE hrbh_file.hrbh04,
                     hrcp04 like hrcp_file.hrcp04, #xie150411
                     hrbo03 LIKE hrbo_file.hrbo03,
                     hrbn02 LIKE hrbn_file.hrbn02,
                     hrdl02 LIKE hrdl_file.hrdl02,
                     hrdh06 LIKE hrdh_file.hrdh06,
                     hrdeud02 LIKE hrde_file.hrdeud02,
                     hrdpb03 LIKE hrdpb_file.hrdpb03,                     
                     hrdpb04 LIKE hrdpb_file.hrdpb04,
                     hrdpb05 LIKE hrdpb_file.hrdpb05,
                     hrdt02 LIKE hrdt_file.hrdt02,
                     hrdu04_1 LIKE hrdu_file.hrdu04,
                     hrdu04_2 LIKE hrdu_file.hrduud01,
                     hrdu07 LIKE hrdu_file.hrdu07,
                     hrdu09 LIKE hrdu_file.hrdu09,
                     hrcb02 LIKE hrcb_file.hrcb02, #xie150411
                     hratg05 LIKE hratg_file.hratg05
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
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,? ,?,?) "
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

    select hrbl03 INTO tm.l_hrbl03 from hrbl_file where hrbl02=tm.l_hrbl02  
   LET tm.s_year=tm.l_year
   LET tm.s_year=tm.s_year.trim()
   LET tm.s_month=tm.l_month
   LET tm.s_month=tm.s_month.trim()

  
   LET l_sql = " select distinct a.hratid,a.hrat01,a.hrat02,a.hrat04,hrao02,'',hrag07,hrat25,hray02,az1.hraz05,hrbh04,",
               " x1.hrcp04,x.hrbo03,hrbn02,hrdl02,hrdh06,b.hrdeud02,dpb.hrdpb03,dpb.hrdpb04,dpb.hrdpb05,",
               " case when du.hrdu03='001' then du.hrdt02 when duu.hrdu03='002' then duu.hrdt02 end,hrdu04,hrduud01,",
               " case when du.hrdu03='001' then du.du04 when duu.hrdu03='002' then duu.duu04 end ,case  when du.hrdu03= '001' then du.du05 when duu.hrdu03='002' then duu.duu05 end,hrcb02,hratg05 ",
               " from (select hrat_file.*,hraoud02 from hrat_file,hrao_file where hrat04=hrao01 and ",tm.wc,") a ", 
               " left join hrao_file on hrat04=hrao01  left join hrad_file on a.hrat19=hrad02 ", 
               " left join hray_file on a.hratid=hray01 and hray02 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and  hray02 <=to_date('",tm.l_day,"','YYYY/MM/DD') ",
               " left join hrbh_file on hrbh01=a.hratid and hrbh04 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrbh04 <=to_date('",tm.l_day,"','YYYY/MM/DD') ",
               " left join (select hraz03,max(hraz01) as hraz01,count(*) as n1 from hraz_file where ", 
               " hraz05 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hraz05 <=to_date('",tm.l_day,"','YYYY/MM/DD') ",
               " group by hraz03) az3 on az3.hraz03=a.hratid ", 
               " left join hraz_file az1 on az3.hraz03=az1.hraz03 and az3.hraz01=az1.hraz01 ", 
               " left join (select hrdu01,hrdu03,hrdt02,hrdu04,sum(hrdu09*hrdu10) as du04,sum(hrdu07*hrdu08) as du05 from hrdu_file,hrdt_file where hrdu02=hrdt01 and hrdu04='",tm.l_hrbl03,"' and hrdu03='001' group by hrdu01,hrdu04,hrdu03,hrdt02) du on du.hrdu01=a.hratid ",-- #xie150414 参保日期，个人缴纳，公司缴纳   
               " left join  (select hrdu01,hrdu03,hrdt02,hrduud01,sum(hrdu07*hrdu08) as duu04,sum(hrdu09*hrdu10) as duu05 from hrdu_file,hrdt_file where hrdu02=hrdt01 and hrduud01='",tm.l_hrbl03,"' and hrdu03='002' group by hrdu01,hrduud01,hrdu03,hrdt02 ) duu on duu.hrdu01=a.hratid ",               
               #" left join  (select hrdu01,hrdt02,min(hrdu04) as du04,hrdu03 from hrdu_file, hrdt_file where hrdu02=hrdt01 and hrdu04='",tm.l_hrbl03,"' group by hrdu01,hrdt02,hrdu03) du1 on du1.hrdu01=a.hratid ",
              # " left join (select hrdu01,hrdu04,sum(hrdu09*hrdu10) as dw04,sum(hrdu07*hrdu08) as dw05 from hrdu_file where hrdu04='",tm.l_hrbl03,"' group by hrdu01,hrdu04) dw on dw.hrdu01=a.hratid ",     
               " left join hrag_file on hrat68=hrag06 and hrag01='340' ",
               " left join (select xyl.hrcp02,xyl.hrbo03,xyl.hrcp03 from (select hrcp02,hrbo03,max(hrcp03) as hrcp03 from hrcp_file,hrat_file,hrbo_file where hratid=hrcp02 and hrcp04=hrbo02 and not hrbo03 like '%休息%' and  hrcp03 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrcp03<to_date('",tm.l_day,"','YYYY/MM/DD') group by hrcp02,hrbo03) xyl ", 
" inner join (select hrcp02 ,max(hrcp03) as hrcp03 from hrcp_file,hrat_file,hrbo_file where hratid=hrcp02 and hrcp04=hrbo02 and not hrbo03 like '%休息%' and  hrcp03 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrcp03<to_date('",tm.l_day,"','YYYY/MM/DD') group by hrcp02 ) yyy on xyl.hrcp02=yyy.hrcp02 and xyl.hrcp03=yyy.hrcp03   ) x  ", #xie150414
               " on x.hrcp02=a.hratid  ",
               " left join hrcp_file x1 on x.hrcp02=x1.hrcp02 and x.hrcp03=x1.hrcp03 ",  
               " left join (select aaa.hrcb05,aaa.hrcb02, aaa.hrcbdate from (select  hrcb05,hrcb02, max(hrcbdate) hrcbdate from hrcb_file   group by hrcb02,hrcb05) aaa ",
" inner join (select  hrcb05,max(hrcbdate) hrcbdate from hrcb_file group by hrcb05) bbb ",
" on aaa.hrcb05=bbb.hrcb05 and aaa.hrcbdate=bbb.hrcbdate) hrcb on a.hratid=hrcb.hrcb05 ", #xie150411 考勤群组
               " left join hratg_file on a.hratid=hratg01 ",
               " left join hrbn_file on hratid=hrbn01 and hrbn05>=to_date('",tm.l_day,"','YYYY/MM/DD') ", 
               " left join hrdm_file on hratid=hrdm02 left join hrdl_file on hrdm03=hrdl01 ",
               " left join (select distinct hrdp04,hrdeud02 from hrdp_file,hrde_file where hrde03=hrdpud02 ", 
               " and hrde05=hrdpud03 and hrdpud13 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') ",  
               " and hrdpud13 <=to_date('",tm.l_day,"','YYYY/MM/DD')) b on a.hratid=b.hrdp04 ",  
               " left join hrdp_file d on d.hrdp04=a.hratid ", #xie150413             
               " left join (select hrdpb01,hrdpb02,hrdpb03,hrdpb04,hrdpb05 from hrdpb_file where not hrdpb02 is null and ",
               " hrdpb04 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and hrdpb04 <=to_date('",tm.l_day,"','YYYY/MM/DD') ",
               ") dpb on d.hrdp01=dpb.hrdpb01 ",  #xie150413
               " left join hrdh_file on dpb.hrdpb02=hrdh01 ",
               " where not (hray02 is null and hrbh04 is null and az1.hraz05 is null ) ",
               " or (a.hrat25 >=to_date('",tm.l_last_day,"','YYYY/MM/DD') and a.hrat25 <=to_date('",tm.l_day,"','YYYY/MM/DD')) ",
               " order by hrat01 " 

                        
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr200_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

           IF sr.hrbn02='001' THEN LET sr.hrbn02='不考勤' END IF 
           IF sr.hrbn02='002' THEN LET sr.hrbn02='手工考勤' END IF 
           IF sr.hrbn02='003' THEN LET sr.hrbn02='机器考勤' END IF            

            
           LET sr.hr_status=''
           IF (NOT cl_null(sr.hrat25)) AND sr.hrat25>=tm.l_last_day AND sr.hrat25<=tm.l_day THEN
              IF NOT cl_null(sr.hr_status) THEN
                LET sr.hr_status=sr.hr_status,'|'  
              END IF 
              LET sr.hr_status=sr.hr_status,'新进'  
           END IF  

           IF (NOT cl_null(sr.hray02)) AND sr.hray02>=tm.l_last_day AND sr.hray02<=tm.l_day THEN
              IF NOT cl_null(sr.hr_status) THEN
                LET sr.hr_status=sr.hr_status,'|'  
              END IF 
              LET sr.hrat25=sr.hray02  
              LET sr.hr_status=sr.hr_status,'转正'  
           END IF  
           
           IF (NOT cl_null(sr.hrbh04)) AND sr.hrbh04>=tm.l_last_day AND sr.hrbh04<=tm.l_day THEN
              IF NOT cl_null(sr.hr_status) THEN
                LET sr.hr_status=sr.hr_status,'|'  
              END IF 

              LET sr.hrat25=sr.hrbh04  
              LET sr.hr_status=sr.hr_status,'离职'  
           END IF  

           IF (NOT cl_null(sr.hraz05))  AND sr.hraz05>=tm.l_last_day AND sr.hraz05<=tm.l_day  THEN
              IF NOT cl_null(sr.hr_status) THEN
                LET sr.hr_status=sr.hr_status,'|'  
              END IF 

              LET sr.hrat25=sr.hraz05  
              LET sr.hr_status=sr.hr_status,'调动'  
           END IF  

            EXECUTE insert_prep USING sr.*
      END FOREACH

    LET l_rep_name="ghr/ghrr211.cpt&p1=",tm.s_year,"&p2=",tm.s_month  
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
