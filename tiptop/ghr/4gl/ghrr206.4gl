# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr206.4gl
# Descriptions...: 离职率统计表
# Date & Author..: 15/01/21  by pan

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
 
   LET g_sql ="yy.type_file.num5,",
              "c1.type_file.num15_3,",
              "d1.type_file.num15_3,",
              "c2.type_file.num15_3,",
              "d2.type_file.num15_3,",              
              "c3.type_file.num15_3,",              
              "d3.type_file.num15_3,",
              "c4.type_file.num15_3,",
              "d4.type_file.num15_3,",
              "c5.type_file.num15_3,",
              "d5.type_file.num15_3,",              
              "c6.type_file.num15_3,",              
              "d6.type_file.num15_3,",                                        
              "c7.type_file.num15_3,",
              "d7.type_file.num15_3,",
              "c8.type_file.num15_3,",
              "d8.type_file.num15_3,",              
              "c9.type_file.num15_3,",              
              "d9.type_file.num15_3,",
              "c10.type_file.num15_3,",
              "d10.type_file.num15_3,",
              "c11.type_file.num15_3,",
              "d11.type_file.num15_3,",              
              "c12.type_file.num15_3,",              
              "d12.type_file.num15_3"                                        
              
              
   LET l_table = cl_prt_temptable('ghrr206',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr206_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr206()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr206_tm(p_row,p_col)
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
  OPEN WINDOW ghrr206_w AT p_row,p_col WITH FORM "ghr/42f/ghrr206"
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
    DISPLAY BY NAME tm.l_year                 
    INPUT BY NAME tm.l_year,tm.l_month WITHOUT DEFAULTS  
       
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
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    CALL cl_wait()
    CALL ghrr206()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr206_w
END FUNCTION
 
FUNCTION ghrr206()
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
          l_year_1  LIKE type_file.num5,
          sr        RECORD
                     yy LIKE type_file.num5,
                     c1 LIKE type_file.num15_3,
                     d1 LIKE type_file.num15_3,
                     c2 LIKE type_file.num15_3,
                     d2 LIKE type_file.num15_3,              
                     c3 LIKE type_file.num15_3,              
                     d3 LIKE type_file.num15_3,
                     c4 LIKE type_file.num15_3,
                     d4 LIKE type_file.num15_3,
                     c5 LIKE type_file.num15_3,
                     d5 LIKE type_file.num15_3,              
                     c6 LIKE type_file.num15_3,              
                     d6 LIKE type_file.num15_3,                                        
                     c7 LIKE type_file.num15_3,
                     d7 LIKE type_file.num15_3,
                     c8 LIKE type_file.num15_3,
                     d8 LIKE type_file.num15_3,              
                     c9 LIKE type_file.num15_3,              
                     d9 LIKE type_file.num15_3,
                     c10 LIKE type_file.num15_3,
                     d10 LIKE type_file.num15_3,
                     c11 LIKE type_file.num15_3,
                     d11 LIKE type_file.num15_3,              
                     c12 LIKE type_file.num15_3,              
                     d12 LIKE type_file.num15_3                       
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_n   LIKE type_file.num5

   DEFINE l_tmp  STRING  

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?  ,?,?,?,?,? ,?,?,?,?,?  ,?,?,?,?,? ) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
      
   #------------------------------ CR (2) ------------------------------#
--
   LET tm.s_year=tm.l_year
   LET l_year_1 =tm.l_year-1
   LET tm.s_year=tm.s_year.trim()
   LET tm.s_month=tm.l_month
   LET tm.s_month=tm.s_month.trim()
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
  
   LET l_sql = "select x1.yy,x1.c1,x2.d1,x1.c2,x2.d2,x1.c3,x2.d3,x1.c4,x2.d4,x1.c5,x2.d5,x1.c6,x2.d6,",
               " x1.c7,x2.d7,x1.c8,x2.d8,x1.c9,x2.d9,x1.c10,x2.d11,x1.c11,x2.d11,x1.c12,x2.d12 from (",
               " select a.yy,sum(a.c1) as c1,sum(a.c2) as c2,sum(a.c3) as c3,sum(a.c4) as c4,sum(a.c5) as c5,",
               " sum(a.c6) as c6,sum(a.c7) as c7,sum(a.c8) as c8,sum(a.c9) as c9,sum(a.c10) as c10,sum(a.c11) as c11,",
               " sum(a.c12) as c12 from (",
               " select year(hrbh04) as yy,",
               " case when month(hrbh04)=1 then 1 else 0 end c1,", 
               " case when month(hrbh04)=2 then 1 else 0 end c2,",
               " case when month(hrbh04)=3 then 1 else 0 end c3,",
               " case when month(hrbh04)=4 then 1 else 0 end c4,",
               " case when month(hrbh04)=5 then 1 else 0 end c5,",
               " case when month(hrbh04)=6 then 1 else 0 end c6,",
               " case when month(hrbh04)=7 then 1 else 0 end c7,",
               " case when month(hrbh04)=8 then 1 else 0 end c8,",
               " case when month(hrbh04)=9 then 1 else 0 end c9,",             
               " case when month(hrbh04)=10 then 1 else 0 end c10,",
               " case when month(hrbh04)=11 then 1 else 0 end c11,",
               " case when month(hrbh04)=12 then 1 else 0 end c12 ",       
               " from hrbh_file,hrat_file,hrao_file where (year(hrbh04)=",tm.s_year,"  or  year(hrbh04)=",l_year_1,") and hrat04=hrao01 and hratid=hrbh01  and ",tm.wc," ) a ", 
               " group by a.yy ) x1 left join ",
               " (select a.tc_hrat01,",
               " sum(a.c1) as d1,sum(a.c2) as d2,sum(a.c3) as d3,sum(a.c4) as d4,sum(a.c5) as d5,sum(a.c6) as d6,",
               " sum(a.c7) as d7,sum(a.c8) as d8,sum(a.c9) as d9,sum(a.c10) as d10,sum(a.c11) as d11,sum(a.c12) as d12 ",    
               " from ( ",
               " select tc_hrat01,",
               " case when tc_hrat02=1 then count(*) else 0 end  as c1,",
               " case when tc_hrat02=2 then count(*) else 0 end  as c2,",
               " case when tc_hrat02=3 then count(*) else 0 end  as c3,",
               " case when tc_hrat02=4 then count(*) else 0 end  as c4,",
               " case when tc_hrat02=5 then count(*) else 0 end  as c5,",
               " case when tc_hrat02=6 then count(*) else 0 end  as c6,",
               " case when tc_hrat02=7 then count(*) else 0 end  as c7,",
               " case when tc_hrat02=8 then count(*) else 0 end  as c8,",
               " case when tc_hrat02=9 then count(*) else 0 end  as c9, ",
               " case when tc_hrat02=10 then count(*) else 0 end  as c10, ",     
               " case when tc_hrat02=11 then count(*) else 0 end  as c11,",
               " case when tc_hrat02=12 then count(*) else 0 end  as c12 ",   
               " from tc_hrat_file,hrao_file where hrat19 in ('006','1001','2001') and hrat04=hrao01 and ",tm.wc,
               " group by  tc_hrat01,tc_hrat02) a ",
               " group by tc_hrat01) x2 on x1.yy=x2.tc_hrat01 ",
               " order by x1.yy "
               
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr206_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

           IF sr.d1<>0 THEN
            LET sr.d1=cl_digcut(sr.c1/sr.d1,4)
           END IF

          IF sr.d2<>0 THEN
            LET sr.d2=cl_digcut(sr.c2/sr.d2,4)
           END if 
 
          IF sr.d3<>0 THEN
            LET sr.d3=cl_digcut(sr.c3/sr.d3,4)
           END IF 

          IF sr.d4<>0 THEN
            LET sr.d4=cl_digcut(sr.c4/sr.d4,4)
           END IF 

          IF sr.d5<>0 THEN
            LET sr.d5=cl_digcut(sr.c5/sr.d5,4)
           END IF 

          IF sr.d6<>0 THEN
            LET sr.d6=cl_digcut(sr.c6/sr.d6,4)
           END IF 

          IF sr.d7<>0 THEN
            LET sr.d7=cl_digcut(sr.c7/sr.d7,4)
           END IF 

          IF sr.d8<>0 THEN
            LET sr.d8=cl_digcut(sr.c8/sr.d8,4)
           END IF 

          IF sr.d9<>0 THEN
            LET sr.d9=cl_digcut(sr.c9/sr.d9,4)
           END IF 

          IF sr.d10<>0 THEN
            LET sr.d10=cl_digcut(sr.c10/sr.d10,4)
           END IF 

          IF sr.d11<>0 THEN
            LET sr.d11=cl_digcut(sr.c11/sr.d11,4)
           END IF 

          IF sr.d12<>0 THEN
            LET sr.d12=cl_digcut(sr.c12/sr.d12,4)
           END IF 
           
          EXECUTE insert_prep USING sr.*
      END FOREACH

    LET l_rep_name="ghr/ghrr206.cpt&p2=",tm.s_year,"&p3=",tm.s_month  
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
