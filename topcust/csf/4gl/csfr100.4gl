# Prog. Version..: '5.30.06-13.03.19(00006)'     #
#
# Pattern name...: csfr100.4gl
# Desc/riptions...: 請購清單
# Input parameter:
# Return code....:
# Date & Author..: 91/09/19 By MAY 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD				#Print condition RECORD
	     	wc  	STRING,	         	#TQC-630166             # Where condition
                bdate   LIKE type_file.chr20,   #No.FUN-680136 VARCHAR(13)
   		s    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)  # Order by sequence
   		t    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)  # Eject sw
                u       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                b       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  # print gkf_file detail(Y/N)
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)	# Input more condition(Y/N)
              END RECORD,
          g_aza17       LIKE aza_file.aza17,    # 本國幣別
          g_dates       LIKE aab_file.aab02,    #No.FUN-680136 VARCHAR(6)
          g_datee       LIKE aab_file.aab02,    #No.FUN-680136 VARCHAR(6)
          l_bdates      LIKE type_file.dat,     #No.FUN-680136 DATE
          l_bdatee      LIKE type_file.dat,     #No.FUN-680136 DATE
          pmk12_tm      LIKE pmk_file.pmk12,
#         g_pmk01       VARCHAR(10),
          g_pmk01       LIKE pmk_file.pmk01,    #No.FUN-680136 VARCHAR(16)
          g_total       LIKE tlf_file.tlf18,    #No.FUN-680136 DECIMAL(13,3) 
          swth          LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE    g_orderA ARRAY[3] OF LIKE zaa_file.zaa08    #No.FUN-680136 VARCHAR(40)  #排列順序項目的中文說明
DEFINE   g_i             LIKE type_file.num5          #No.FUN-680136 SMALLINT  #count/index for any purpose    
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
#No.FUN-7C0054---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING      
DEFINE g_check        LIKE type_file.chr1                                            
                                                 
#No.FUN-7C0054---End 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-7C0054---Begin                                                          
   LET g_sql = "tc_shb02.tc_shb_file.tc_shb02,",
               "bdate.pmm_file.pmm04,",
               "tc_shb03.tc_shb_file.tc_shb03,",
               "gem02.gem_file.gem02,",
               "bmb01_f.bmb_file.bmb01,",
               "tc_shb07.tc_shb_file.tc_shb07,",
               "tc_shb06.tc_shb_file.tc_shb06,",
               "tc_shb08.tc_shb_file.tc_shb08,",
               "ecb17.ecb_file.ecb17,",
               "imaud10.ima_file.imaud10,",
               "pnl.type_file.num15_3,",
               "tc_shb121.tc_shb_file.tc_shb121,",
               "bmb03.bmb_file.bmb03,",
               "bmb10.bmb_file.bmb10,",
               "bmb06.bmb_file.bmb06,",
               "fcnt.type_file.num20_6,",
               "ima53.ima_file.ima53,",
               "famt.type_file.num20_6,",
               "bmbud02.bmb_file.bmbud02"

   LET l_table = cl_prt_temptable('csfr100',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF    
   LET tm.wc = " bom_ver='",ARG_VAL(1),"'" 
   LET g_bgjob = ARG_VAL(2)
   IF cl_null(ARG_VAL(3)) THEN 
      LET g_check = 'N'
   ELSE 
      LET g_check = ARG_VAL(3)
   END IF   
  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r100_tm(0,0)		# Input print condition
      ELSE CALL csfr100()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW r100_w AT p_row,p_col WITH FORM "csf/42f/csfr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.wc = ''
 
WHILE TRUE 
   INPUT tm.wc FROM bom_ver
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP INFIELD  bom_ver 
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO bom_ver
            NEXT FIELD bom_ver 
            
 
      ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END INPUT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF 
   IF cl_null(tm.wc) THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   ELSE 
      LET tm.wc = " bom_ver = '",tm.wc,"' "
   END IF  
   CALL cl_wait()
   CALL csfr100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION csfr100()
   DEFINE l_name	LIKE type_file.chr20, 	      
          l_time	LIKE type_file.chr8,  	      
          l_sql 	LIKE type_file.chr1000,	      
          l_chr		LIKE type_file.chr1,       
          l_za05	LIKE za_file.za05,            
          l_gen02       LIKE gen_file.gen02,                           
          l_pmc02       LIKE pmc_file.pmc02,                   
          l_pmc03       LIKE pmc_file.pmc03,                   
          l_ima021      LIKE ima_file.ima021,                             
          l_ima08       LIKE ima_file.ima08,                                                
          l_ima37       LIKE ima_file.ima08,    
          l_pml09       LIKE type_file.chr10,   
          l_order	ARRAY[6] OF LIKE pml_file.pml04,     
          i             LIKE type_file.num5 
   DEFINE l_i,l_cnt          LIKE type_file.num5     
   DEFINE l_zaa02            LIKE zaa_file.zaa02
   DEFINE l_ima906           LIKE ima_file.ima906    
   DEFINE l_str4             LIKE type_file.chr1000  
   DEFINE l_pml85            STRING                  
   DEFINE l_pml82            STRING     
   DEFINE sr RECORD
         tc_shb02            LIKE tc_shb_file.tc_shb02,
         bdate               LIKE pmm_file.pmm04,
         tc_shb03            LIKE tc_shb_file.tc_shb03,
         gem02               LIKE gem_file.gem02,
         bmb01_f             LIKE bmb_file.bmb01,
         tc_shb07            LIKE tc_shb_file.tc_shb07,
         tc_shb06            LIKE tc_shb_file.tc_shb06,
         tc_shb08            LIKE tc_shb_file.tc_shb08,
         ecb17               LIKE ecb_file.ecb17,
         imaud10             LIKE ima_file.imaud10,
         pnl                 LIKE type_file.num15_3,
         tc_shb121           LIKE tc_shb_file.tc_shb121,
         bmb03               LIKE bmb_file.bmb03,
         bmb10               LIKE bmb_file.bmb10,
         bmb06               LIKE bmb_file.bmb06,
         fcnt                LIKE type_file.num20_6,
         ima53               LIKE ima_file.ima53,
         famt                LIKE type_file.num20_6,
         bmbud02             LIKE bmb_file.bmbud02
            END RECORD

   CALL cl_del_data(l_table)                                    
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang


   LET l_sql =  " SELECT tc_shb02,bdate,tc_shb03,gem02,bmb01_f,tc_shb07,tc_shb06,tc_shb08,",
                " ecb17,ima_file.imaud10, (case ima_file.imaud10 when 0 then 0 ELSE tc_shb121/ima_file.imaud10 end)",
                " pnl,tc_shb121,bmb03,bmb10,bmb06,fcnt,tc_bom_file.ima53,famt,bmbud02  FROM tc_bom_file ",
                " LEFT JOIN (SELECT gen01,gem02 FROM gen_file,gem_file WHERE gem01 = gen03 ) ON gen01 = tc_shb11 ",
                " LEFT JOIN ima_file ON ima01 = bmb01_f ", 
                " WHERE ",tm.wc," AND bomkey=1 "

   PREPARE r100_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   DECLARE r100_cs1 CURSOR FOR r100_prepare1

   FOREACH r100_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF 
      EXECUTE insert_prep  USING  sr.* 
   END FOREACH  

   LET l_sql = " UPDATE ", g_cr_db_str CLIPPED, l_table CLIPPED,
               "    SET pnl=0,tc_shb121=0  WHERE bmbud10 <>='#1' "

   PREPARE p_upd_table FROM l_sql 
   EXECUTE p_upd_table
   
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('p_upd_table:',SQLCA.sqlcode,1)  
      RETURN  
   END IF 

   LET g_str=tm.wc                                                    
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY bdate,to_number(substr(bmbud02,2,length(bmbud02)-1))"
   IF g_check = 'Y' THEN
      CALL cl_prt_cs3('csfr100','csfr100_1',l_sql,g_str)
   ELSE 
      CALL cl_prt_cs3('csfr100','csfr100',l_sql,g_str)
   END IF
    
END FUNCTION 
