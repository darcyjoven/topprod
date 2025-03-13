# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr104.4gl
# Descriptions...: 工资条
# Date & Author..: 15/05/05   by xieyonglu
#xie150423
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            l_year LIKE type_file.num5,
            l_month LIKE type_file.num5,  
            hrdxa01 LIKE hrdxa_file.hrdxa01,
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
DEFINE g_hraoud04       LIKE hrao_file.hraoud04 
#DEFINE g_text  STRING
 
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
 
   LET g_sql =               
      "col01.type_file.chr50,",
      "col02.hrao_file.hrao02,",
      "col03.hrat_file.hrat02,",
      "col04.type_file.chr50,",
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
      "col23.type_file.num15_3,",
      "col24.type_file.num15_3,",
      "col25.type_file.chr50"
      
      
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
  OPEN WINDOW ghrr100_w AT p_row,p_col WITH FORM "ghr/42f/ghrr104"
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
    CONSTRUCT BY NAME tm.wc ON hraoud04,hrat21,hraoud02,hrat20

      BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
        
            
       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hraoud04)
                 CALL cl_init_qry_var()
                # LET g_qryparam.state = "c"    
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.arg1 = "658"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraoud04
                 NEXT FIELD hraoud04
            


              WHEN INFIELD(hrat21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '337'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat21
                 NEXT FIELD hrat21                 
                 
              WHEN INFIELD(hraoud02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"      
                 LET g_qryparam.arg1='202'    
            	 LET g_qryparam.form = "q_hrag06"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraoud02
                 NEXT FIELD hraoud02   

            WHEN INFIELD(hrat20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat20
                 NEXT FIELD hrat20
                 
             
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
 
  # DISPLAY BY NAME tm.l_year                 
    INPUT BY NAME tm.hrdxa01 WITHOUT DEFAULTS  
       
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
 
      # No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
      # No.FUN-580031 ---end---}

       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hrdxa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"    
                 LET g_qryparam.form = "q_hrbl02"
                 CALL cl_create_qry() RETURNING tm.hrdxa01
                 DISPLAY BY NAME tm.hrdxa01
                 NEXT FIELD hrdxa01
             
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
          col01 LIKE type_file.chr50,
          col02 LIKE hrao_file.hrao02,
          col03 LIKE hrat_file.hrat02,
          col04 LIKE type_file.chr50,
          col05 LIKE type_file.num15_3,
          col06 LIKE type_file.num15_3,
          col07 LIKE type_file.num15_3,
          col08 LIKE type_file.num15_3,
          col09 LIKE type_file.num15_3,
          col10 LIKE type_file.num15_3,
          col11 LIKE type_file.num15_3,
          col12 LIKE type_file.num15_3,
          col13 LIKE type_file.num15_3,
          col14 LIKE type_file.num15_3,
          col15 LIKE type_file.num15_3,
          col16 LIKE type_file.num15_3,
          col17 LIKE type_file.num15_3,
          col18 LIKE type_file.num15_3,
          col19 LIKE type_file.num15_3,
          col20 LIKE type_file.num15_3,
          col21 LIKE type_file.num15_3,
          col22 LIKE type_file.num15_3,
          col23 LIKE type_file.num15_3,
          col24 LIKE type_file.num15_3,
          col25 LIKE type_file.chr50
                    
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_hraa12  LIKE hraa_file.hraa12
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5
   DEFINE            l_img_blob     LIKE type_file.blob
   DEFINE l_text  STRING

    
  IF tm.wc.subString(1,8)='hraoud04' AND tm.wc.subString(11,13)='001' THEN 
         LET l_text='001'
        { LET l_text='施敏敏， 电话：0571-81102907 ，内线：82907'}
  END if
  IF tm.wc.subString(1,8)='hraoud04' AND tm.wc.subString(11,13)='002' THEN   
         { LET l_text='章 敏， 电话：0571-81102907 ，内线：82907'}
         LET l_text='002'
  END IF 
  IF tm.wc.subString(1,8)='hraoud04' AND tm.wc.subString(11,13)='003' THEN    
          {LET l_text='肖 媚， 电话：0571-82608857 ，内线：86885'}
          LET l_text='003'
  END IF 
 IF tm.wc.subString(1,8)='hraoud04' AND tm.wc.subString(11,13)='004' THEN  
          #LET l_text='谢莹莹， 电话：0573-87801002 ，内线：85002'}
          LET l_text='004'
 END IF
 

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "
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
    FROM hrbl_file WHERE hrbl03=tm.hrdxa01  

   IF cl_null(tm.wc) THEN
       LET tm.wc=" 1=1 " 
    END IF 
  #xie150423
   LET l_sql = " select to_char(to_date(substr(hrdxa01,1,instr(hrdxa01,'(')-1),'yyyy-MM'),'yyyy-MM') AS  月份,",
" b.hrai04 as 部门,c.hrat02 as 姓名,c.hrat72 as 组别,a.hrdxa08 as 应发工资,a.hrdxa12 as 个税,a.hrdxa14 as 实发工资,",
" max(case hrdxb03 when '148' then hrdxb05  end)基本工资, ",
" max(case hrdxb03 when '18' then hrdxb05  end)加班工资及补贴, ",
" max(case hrdxb03 when '51' then hrdxb05  end)保密费,", 
" max(case hrdxb03 when '19' then hrdxb05  end)全勤奖, ",
" max(case hrdxb03 when '21' then hrdxb05  end)职称,", 
" max(case hrdxb03 when '137' then hrdxb05  end)工龄, ",
" max(case hrdxb03 when '23' then hrdxb05  end)补贴小计, ",
" max(case hrdxb03 when '144' then hrdxb05  end)缺勤扣款, ",
" max(case hrdxb03 when '26' then hrdxb05  end)其他收入小计, ",
" max(case hrdxb03 when '34' then hrdxb05  end)个缴社保, ",
" max(case hrdxb03 when '35' then hrdxb05  end)个缴公积金, ",
" max(case hrdxb03 when '138' then hrdxb05  end)餐补, ",
" max(case hrdxb03 when '139' then hrdxb05  end)交通补贴, ",
" max(case hrdxb03 when '141' then hrdxb05  end)通讯补贴,", 
" max(case hrdxb03 when '142' then hrdxb05  end)缺勤补贴扣款,", 
" max(case hrdxb03 when '67' then hrdxb05  end)水电, ",
" max(case hrdxb03 when '42' then hrdxb05  end)代扣小计,",
" ''",
" from hrdxa_file a ",
" inner join hrat_file c on a.hrdxa02=c.hratid",
" inner join hrai_file b on a.hrdxa04=b.hrai03",
" inner join hrdxb_file d on a.hrdxa01=d.hrdxb01 and a.hrdxa02=d.hrdxb02",
" inner join hrao_file e on e.hrat04=e.hrao01"
" where ",tm.wc CLIPPED," and hrdxa01=","'",tm.hrdxa01 CLIPPED,"'",
" group by a.hrdxa01,b.hrao02,c.hrat02,c.hrat72,a.hrdxa08,a.hrdxa12,a.hrdxa14,c.hrat01 order by b.hrai04"

                   
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

    LET l_rep_name="ghr/ghrr104.cpt&p2=",tm.l_year,"&p3=",tm.l_month,"&p4=",l_text     
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_fine(l_rep_name,l_sql,l_table)       
   
END FUNCTION      
