# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr203.4gl
# Descriptions...: 劳动合同续签统计表
# Date & Author..: 15/01/21   by pan

DATABASE ds
 
GLOBALS "../../config/top.global" 
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            l_date DATE
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
DEFINE      years  string
DEFINE      months   string


 
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
              "hrao02.hrao_file.hrao02,",
              "hras04.hras_file.hras04,",
              "hrbf08.hrbf_file.hrbf08,",
              "hrbf10.hrbf_file.hrbf10,",
              "hrbf09.hrbf_file.hrbf09,",              
              "hraf02.hraf_file.hraf02," ,
             "hraoud02.hrao_file.hraoud02"            
              
   LET l_table = cl_prt_temptable('ghrr203',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr201_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr201()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr201_tm(p_row,p_col)
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
  OPEN WINDOW ghrr201_w AT p_row,p_col WITH FORM "ghr/42f/ghrr203"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hrat04,hraoud02
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
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
    DISPLAY BY NAME tm.l_date                 
    INPUT BY NAME tm.l_date WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
          
       AFTER FIELD l_date
       IF NOT cl_null(tm.l_date) THEN
       LET years=year(tm.l_date)#,"-",month(tm.l_date)
       LET months=month(tm.l_date)+1
           IF months>12 THEN
               LET years=year(tm.l_date)+1
               LET months=1
            END if
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
 
    CALL cl_wait()
    CALL ghrr201()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr201_w
END FUNCTION
 
FUNCTION ghrr201()
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
                     hrao02 LIKE hrao_file.hrao02,
                     hras04 LIKE hras_file.hras04,
                     hrbf08 LIKE hrbf_file.hrbf08,
                     hrbf10 LIKE hrbf_file.hrbf10,
                     hrbf09 LIKE hrbf_file.hrbf09,              
                     hraf02 LIKE hraf_file.hraf02,
                     hraoud02 LIKE hrao_file.hraoud02
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_n   LIKE type_file.num5

   DEFINE l_tmp  STRING  

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
      
   #------------------------------ CR (2) ------------------------------#
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')

  # #合同到期=A,开始日期=A+1天，合同结束日期=（（A+1）天+5年）当月的最后一天。
   LET l_sql = "select hrat01,hrat02,hrao02,hras04, hrbf09+1 as hrbf08 ,to_char(last_day(add_months(hrbf09+1,5*12)),'yyyy/mm/dd')hrbf10, hrbf09,hraf02,jidi from (SELECT hrat01,hrat02,hrao02,hras04,file1.hrbf08,file1.hrbf10,file1.hrbf09,hraf02,case hraoud02 when '001' then '萧山基地' when '002' then '海宁基地' when '003' then '非基地' end jidi ",
               " FROM hrat_file left join hrad_file on hrad02=hrat19 left join hrao_file on hrao01=hrat04 ",
               " left join hras_file on hrat05=hras01 ",
               " inner join hraf_file on hrat40=hraf01  ",
               " left join (SELECT hrbf02,max(hrbf08) as hrbf08,max(hrbf10) as hrbf10 ,MAX(hrbf09) hrbf09 FROM hrbf_file ",
               " GROUP BY hrbf02) file1 on hratid = file1.hrbf02 ",
               " left join hrbf_file bf on file1.hrbf02=bf.hrbf02 and file1.hrbf09=bf.hrbf09 ",      
               " left join hraa_file on bf.hrbf11=hraa01 ",
               " WHERE (hrat20<>'001' and hrat20<>'007') and hratconf = 'Y'  AND hratacti = 'Y' AND hrad01<>'003' and to_char(file1.hrbf09,'yyyy') = ",years," and to_char(file1.hrbf09,'mm') = ",months," and  ",tm.wc,
               " ORDER BY hrat01) t " 

                   
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr201_p:',SQLCA.sqlcode,1)
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

    LET l_rep_name="ghr/ghrr203.cpt&p1=",years,"&p2=",months
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
