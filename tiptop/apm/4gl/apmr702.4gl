# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmr702.4gl
# Descriptions...: 料件收貨狀況查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/11/07 By MAY
# Modify.........: 93/11/05 By Apple
# Modify.........: No.FUN-4C0095 04/12/28 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 單頭料件品名規格修改定位點
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 結束位置調整
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-6B0089 06/12/14 By pengu 當勾選tm.a,tm.b都=N時,報表會印不出
# Modify.........: No.FUN-840054 08/04/15 By mike 報表輸出方式轉為 Crystal Reports  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B10261 11/03/03 By lilingyu  去掉畫面"按料件編號跳頁"選項
# Modify.........: No.FUN-BA0053 11/10/31 By Sakura 加入取jit收貨資料
# Modify.........: No.TQC-C60091 12/06/11 By yangtt 查詢條件後需再重新給予 INPUT 欄位變數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
	       #wc   VARCHAR(500),   #TQC-630166 mark
		wc  	STRING,      #TQC-630166
                b_date  LIKE type_file.dat,         #No.FUN-680136 DATE
                e_date  LIKE type_file.dat,         #No.FUN-680136 DATE
                a       LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
                b       LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1) 
                sub     LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1) 
                t       LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1) 
                more	LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1) 
              END RECORD,
          g_aza17        LIKE aza_file.aza17,       # 本國幣別
          g_total        LIKE tlf_file.tlf18        #No.FUN-680136 DECIMAL(13,3)
   DEFINE g_i            LIKE type_file.num5        #count/index for any purpose    #No.FUN-680136 SMALLINT
   DEFINE   l_table         STRING     #No.FUN-840054                                                                               
   DEFINE   g_sql           STRING     #No.FUN-840054                                                                               
   DEFINE   g_str           STRING     #No.FUN-840054  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
#No.FUN-840054  --BEGIN                                                                                                             
  LET g_sql = "tlf01.tlf_file.tlf01,",      #料件編號                 
               "tlf02.tlf_file.tlf02,",   #來源狀況                                                                                 
               "tlf03.tlf_file.tlf03,",   #目的狀況                                                                                 
               "tlf06.tlf_file.tlf06,",   #單據日期                                                                                 
               "tlf10.tlf_file.tlf10,",   #異動數量                                                                                 
               "tlf11.tlf_file.tlf11,",   #異動單位                                                                                 
               "tlf13.tlf_file.tlf13,",   #異動命令代號                                                                             
               "tlf026.tlf_file.tlf026,", #來源單號                                                                                 
               "tlf027.tlf_file.tlf027,", #來源項次                                                                                 
               "tlf036.tlf_file.tlf036,", #目的單號                                                                                 
               "tlf037.tlf_file.tlf037,", #目的項次                                                                                 
               "pmm09.pmm_file.pmm09,",   #廠商編號                                                                                 
               "pmc03.pmc_file.pmc03,",    #廠商簡稱                                                                                
               "l_ima02.ima_file.ima02,",                                                                                           
               "l_ima021.ima_file.ima021,",                                                                                         
               "l_ima05.ima_file.ima05,",                                                                                           
               "l_ima08.ima_file.ima08,",                                                                                           
               "l_ima25.ima_file.ima25,",                                                                                           
               "l_print31.type_file.chr1,",                                                                                         
               "l_print33.tlf_file.tlf10,",                                                                                         
               "l_print34.tlf_file.tlf10,",                                                                                         
               "l_print35.tlf_file.tlf10"                                                                                           
   LET l_table = cl_prt_temptable("apmr702",g_sql) CLIPPED     
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                               
               "       ?,?)"                                                                                                        
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-840054 --END               
   LET g_pdate = ARG_VAL(1)	
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b_date = ARG_VAL(8)
   LET tm.e_date = ARG_VAL(9)
   LET tm.a   = ARG_VAL(10)
   LET tm.b   = ARG_VAL(11)
#------------------No.TQC-610085 modify
   LET tm.sub = ARG_VAL(12)
   LET tm.t   = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
#------------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	
      THEN CALL r702_tm(0,0)		
      ELSE CALL apmr702()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r702_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r702_w AT p_row,p_col WITH FORM "apm/42f/apmr702"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			
   LET tm.e_date = g_today
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.sub  = '3'
   LET tm.t    = 'Y'        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tlf01
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(tlf01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf01
               NEXT FIELD tlf01
            END IF
#No.FUN-570243 --end--
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.b_date,tm.e_date,tm.sub,  
#                tm.t,          #TQC-B10261
                 tm.a,tm.b,tm.more
               WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
            #TQC-C60091---str---
             LET tm.b_date = GET_FLDBUF(b_date)
             LET tm.e_date = GET_FLDBUF(e_date)
             LET tm.sub = GET_FLDBUF(sub)
             LET tm.a = GET_FLDBUF(a)
             LET tm.b = GET_FLDBUF(b)
            #TQC-C60091---end---
         #No.FUN-580031 ---end---
 
      AFTER FIELD e_date
         IF tm.e_date < tm.b_date
         THEN NEXT FIELD e_date
         END IF
      AFTER FIELD a
         IF tm.a    NOT MATCHES "[YN]"  OR tm.a IS NULL THEN
                NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b    NOT MATCHES "[YN]" OR tm.b IS NULL  THEN
                NEXT FIELD b
         END IF
      AFTER FIELD sub
         IF tm.sub  NOT MATCHES "[123]" OR tm.sub IS NULL  THEN
             NEXT FIELD sub
         END IF
         
#TQC-B10261 --begin--         
#      AFTER FIELD t
#         IF tm.t    NOT MATCHES "[YN]" OR tm.t IS NULL  THEN
#             NEXT FIELD t
#         END IF
#TQC-B10261 --end--
         
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL  THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r702_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr702'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr702','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.b_date CLIPPED,"'",        #No.TQC-610085 add
                         " '",tm.e_date CLIPPED,"'",        #No.TQC-610085 add
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.sub   CLIPPED,"'",
                         " '",tm.t     CLIPPED,"'",            
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr702',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r702_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr702()
   ERROR ""
END WHILE
   CLOSE WINDOW r702_w
END FUNCTION
 
FUNCTION apmr702()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name               #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job          #No.FUN-680136 VARCHAR(8)
          l_sw          LIKE type_file.chr1,            # No.FUN-680136 VARCHAR(1) 	         # Used time for running the job
         #l_sql  	LIKE type_file.chr1000,		# RDSQL STATEMENT    #TQC-630166 mark    #No.FUN-680136 VARCHAR(1000)
          l_sql  	STRING,		                # RDSQL STATEMENT    #TQC-630166
         #l_wc   	LIKE type_file.chr1000,		# RDSQL STATEMENT    #TQC-630166 mark    #No.FUN-680136 VARCHAR(1000)
          l_wc   	STRING,		                # RDSQL STATEMENT    #TQC-630166
          l_za05	LIKE type_file.chr1000,         # No.FUN-680136 VARCHAR(40)
          sr               RECORD
                           tlf01 LIKE tlf_file.tlf01,      #料件編號   
                           tlf02 LIKE tlf_file.tlf02,   #來源狀況	
                           tlf03 LIKE tlf_file.tlf03,   #目的狀況	
                           tlf06 LIKE tlf_file.tlf06,   #單據日期
                           tlf10 LIKE tlf_file.tlf10,   #異動數量
                           tlf11 LIKE tlf_file.tlf11,   #異動單位
                           tlf13 LIKE tlf_file.tlf13,   #異動命令代號
                           tlf026 LIKE tlf_file.tlf026, #來源單號
                           tlf027 LIKE tlf_file.tlf027, #來源項次
                           tlf036 LIKE tlf_file.tlf036, #目的單號
                           tlf037 LIKE tlf_file.tlf037, #目的項次
                           pmm09  LIKE pmm_file.pmm09,  #廠商編號
                           pmc03  LIKE pmc_file.pmc03   #廠商簡稱
                        END RECORD
     #No.FUN-840054  --BEGIN                                                                                                        
     DEFINE l_ima02   LIKE ima_file.ima02                                                                                           
     DEFINE l_ima021  LIKE ima_file.ima021                                                                                          
     DEFINE l_ima05   LIKE ima_file.ima05                                                                                           
     DEFINE l_ima08   LIKE ima_file.ima08                                                                                           
     DEFINE l_ima25   LIKE ima_file.ima25                                                                                           
     DEFINE l_print31 LIKE type_file.chr1                                                                                           
     DEFINE l_print33 LIKE tlf_file.tlf10                                                                                           
     DEFINE l_print34 LIKE tlf_file.tlf10                                                                                           
     DEFINE l_print35 LIKE tlf_file.tlf10                              
                                                                                                                                         
     CALL cl_del_data(l_table)                                                                                                      
     #No.FUN-840054  --END          
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004--------Begin---------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-------End------------
     LET l_wc = ' '
     IF tm.a  = 'N' THEN  #採購收貨
       #------------No.MOD-6B0089 modify
       #LET l_wc = l_wc clipped, " tlf03 != 50"
        LET l_wc = l_wc clipped, " AND tlf03 != 50"
       #------------No.MOD-6B0089 end
     END IF
     IF tm.b = 'N' THEN  #退貨是否列印
       #------------No.MOD-6B0089 modify
       #LET l_wc = l_wc clipped, " (tlf03 NOT BETWEEN 30 AND 32 ) "
        LET l_wc = l_wc clipped, " AND (tlf03 NOT BETWEEN 30 AND 32 ) "
       #------------No.MOD-6B0089 end
     END IF
    #-------No.MOD-6B0089 modify
    #IF l_wc = ' ' THEN LET l_wc =" 1=1 " END IF
     IF l_wc = ' ' THEN LET l_wc =" AND 1=1 " END IF
    #-------No.MOD-6B0089 end
     LET l_sql = " SELECT  ",
                 " tlf01,",
                 " tlf02,tlf03,tlf06,tlf10,tlf11,tlf13,",
                #" tlf026,tlf027,tlf036,tlf037,pmm09,pmc03", #No.FUN-BA0053 mark 
				 " tlf026,tlf027,tlf036,tlf037,'',''", #No.FUN-BA0053 add 
                 "  FROM tlf_file ",
                #"  LEFT OUTER JOIN pmm_file ON pmm01 = tlf026 ,pmc_file ", #No.FUN-BA0053 mark
                 "  WHERE  ",
                #"  pmc_file.pmc01 = pmm09  AND ", #No.FUN-BA0053 mark
                 " (tlf02 BETWEEN  10 AND  20 ) AND ",
                #------------No.MOD-6B0089 modify
                #" (tlf03 BETWEEN  10 AND  57 ) AND ", l_wc clipped,
                 " (tlf03 BETWEEN  10 AND  57 ) ", l_wc clipped,
                #------------No.MOD-6B0089 end
                 "  AND ",tm.wc CLIPPED
 
     IF tm.b_date IS NOT NULL AND tm.b_date != ' '
     THEN LET l_sql = l_sql clipped," AND tlf06 >= '",tm.b_date,"'"
     END IF
     IF tm.e_date IS NOT NULL AND tm.e_date != ' '
     THEN LET l_sql = l_sql clipped," AND tlf06 <= '",tm.e_date,"'"
     END IF
     #--->一般料件
     IF tm.sub = '1'
     THEN LET l_sql = l_sql clipped," AND tlf02 !=18"
     END IF
     #--->代買料件
     IF tm.sub = '2'
     THEN LET l_sql = l_sql clipped," AND tlf02 =18"
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY 7 "
     PREPARE r702_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r702_cs1 CURSOR FOR r702_prepare1
 
     #LET l_name = 'apmr702.out'                  #No.FUN-840054   
     #CALL cl_outnam('apmr702') RETURNING l_name  #No.FUN-840054   
     #START REPORT r702_rep TO l_name             #No.FUN-840054   
  
     
     FOREACH r702_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF 
              
       #No.FUN-840054 --begin 
       #OUTPUT TO REPORT r702_rep(sr.*)
       SELECT ima02,ima021,ima05,ima08,ima25                                                                                        
         INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima25                                                                              
        FROM ima_file                                                                                                               
       WHERE ima01 = sr.tlf01                                                                                                       
       IF sr.tlf02 = 18 THEN                                                                                                        
          LET l_print31 = '*'                                                                                                       
       ELSE                                                                                                                         
          LET l_print31 = ' '                                                                                                       
       END IF                                                                                                                       
       CASE                                                                                                                         
          WHEN sr.tlf03 = 20                                                                                                        
                 LET l_print33 = sr.tlf10                                                                                           
                 LET l_print34 = NULL                                                                                               
                 LET l_print35 = NULL                                                                                               
          #No.FUN-BA0053---Begin---add
               SELECT rva05,pmc03 INTO sr.pmm09,sr.pmc03
                FROM rva_file,pmc_file
               WHERE rva01=sr.tlf036 AND pmc01=rva05
          #No.FUN-BA0053---End-----add                 
          WHEN sr.tlf03 = 30 OR sr.tlf03 = 31 OR sr.tlf03 = 32                                                                      
                 LET l_print33 = NULL                                                                                               
                 LET l_print34 = sr.tlf10                                                                                           
                 LET l_print35 = NULL                                                                                               
          #No.FUN-BA0053---Begin---add
               SELECT rvu04,pmc03 INTO sr.pmm09,sr.pmc03
                FROM rvu_file,pmc_file
               WHERE rvu01=sr.tlf036 AND pmc01=rvu04
          #No.FUN-BA0053---End-----add                 
          WHEN sr.tlf03 = 50 OR sr.tlf03 = 55 OR sr.tlf03 = 56                                                                      
                 LET l_print33 = NULL                                                                                               
                 LET l_print34 = NULL                                                                                               
                 LET l_print35 = sr.tlf10           
          #No.FUN-BA0053---Begin---add
               SELECT rvu04,pmc03 INTO sr.pmm09,sr.pmc03
                FROM rvu_file,pmc_file
               WHERE rvu01=sr.tlf036 AND pmc01=rvu04
          #No.FUN-BA0053---End-----add                 
          OTHERWISE EXIT CASE                                                                                                       
       END CASE                                                                                                                     
       IF sr.tlf13 = 'apmt150' OR sr.tlf13 = 'apmt230' THEN                                                                         
          SELECT rvb04,rvb03 INTO g_tlf.tlf036,g_tlf.tlf037                                                                         
           FROM rvb_file where rvb01 = g_tlf.tlf026 AND                                                                             
                               rvb02 = g_tlf.tlf027                                                                                 
       END IF                            
                                                     
       EXECUTE insert_prep USING sr.tlf01,sr.tlf02,sr.tlf03,sr.tlf06,sr.tlf10,                                                      
                                 sr.tlf11,sr.tlf13,sr.tlf026,sr.tlf027,sr.tlf036,                                                   
                                 sr.tlf037,sr.pmm09,sr.pmc03,l_ima02,l_ima021,                                                      
                                 l_ima05,l_ima08,l_ima25,l_print31,l_print33,                                                       
                                 l_print34,l_print35                                                                                
       #No.FUN-840054 --END                              
              
     END FOREACH
     #No.FUN-840054 --BEGIN   
     #FINISH REPORT r702_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'tlf01')                                                                                                
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str=g_str CLIPPED,';',tm.t                                                                                               
     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('apmr702','apmr702',g_sql,g_str)                                                                               
     #No.FUN-840054  --end                     
END FUNCTION
 
#No.FUN-840054 --BEGIN                                                                                                              
{                     
REPORT r702_rep(sr)
   DEFINE l_ima021      LIKE ima_file.ima021          #FUN-4C0095
   DEFINE l_print31	LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1) #FUN-4C0095
   DEFINE l_print33	LIKE tlf_file.tlf10           #FUN-4C0095
   DEFINE l_print34	LIKE tlf_file.tlf10           #FUN-4C0095
   DEFINE l_print35	LIKE tlf_file.tlf10           #FUN-4C0095
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1) 
          l_tlf13       LIKE apo_file.apo02,          #No.FUN-680136 VARCHAR(4)
          l_swth        LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1) 
          l_ima02 LIKE ima_file.ima02,   #品名規格
          l_ima05 LIKE ima_file.ima05,   #版本
          l_ima08 LIKE ima_file.ima08,   #來源
          l_ima25 LIKE ima_file.ima25,   #庫存單位
          sr               RECORD
                           tlf01 LIKE tlf_file.tlf01,   #料件編號
                           tlf02 LIKE tlf_file.tlf02,   #來源狀況	
                           tlf03 LIKE tlf_file.tlf03,   #目地狀況	
                           tlf06 LIKE tlf_file.tlf06,   #單據日期
                           tlf10 LIKE tlf_file.tlf10,   #異動數量
                           tlf11 LIKE tlf_file.tlf11,   #異動單位
                           tlf13 LIKE tlf_file.tlf13,   #異動命令代號
                           tlf026 LIKE tlf_file.tlf026, #來源單號
                           tlf027 LIKE tlf_file.tlf027, #來源項次
                           tlf036 LIKE tlf_file.tlf036, #目的單號
                           tlf037 LIKE tlf_file.tlf037, #目的項次
                           pmm09  LIKE pmm_file.pmm09,  #廠商編號
                           pmc03  LIKE pmc_file.pmc03   #廠商簡稱
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.tlf01,sr.tlf06
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
     PRINT g_dash
     SELECT ima02,ima021,ima05,ima08,ima25
       INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima25
       FROM ima_file
      WHERE ima01 = sr.tlf01
     PRINT COLUMN 01, g_x[11] CLIPPED, sr.tlf01,
           #COLUMN 31, g_x[12] CLIPPED, l_ima02,#TQC-5B0037 mark
           COLUMN 51, g_x[13] CLIPPED, l_ima05, #TQC-5B0037 71->51
           COLUMN 63, g_x[14] CLIPPED, l_ima08, #TQC-5B0037 83->63
           COLUMN 70, g_x[15] CLIPPED, l_ima25  #TQC-5B0037 90->70
     PRINT COLUMN 01, g_x[12] CLIPPED, l_ima02 #TQC-5B0037 add
     PRINT COLUMN 01, g_x[16] CLIPPED, l_ima021
     PRINT ' '
     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
           g_x[41],g_x[42],g_x[43]
     PRINT g_dash1
     LET l_last_sw = 'n'
 
BEFORE GROUP  OF sr.tlf01
     IF tm.t = 'Y' THEN
        SKIP TO TOP OF PAGE
     END IF
 
    ON EVERY ROW
     IF sr.tlf02 = 18 THEN
        LET l_print31 = '*'
     ELSE
        LET l_print31 = ' '
     END IF
     CASE
         WHEN sr.tlf03 = 20
                 LET l_print33 = sr.tlf10
                 LET l_print34 = NULL
                 LET l_print35 = NULL
         WHEN sr.tlf03 = 30 OR sr.tlf03 = 31 OR sr.tlf03 = 32
                 LET l_print33 = NULL
                 LET l_print34 = sr.tlf10
                 LET l_print35 = NULL
         WHEN sr.tlf03 = 50 OR sr.tlf03 = 55 OR sr.tlf03 = 56
                 LET l_print33 = NULL
                 LET l_print34 = NULL
                 LET l_print35 = sr.tlf10
         OTHERWISE EXIT CASE
     END CASE
     IF sr.tlf13 = 'apmt150' OR sr.tlf13 = 'apmt230' THEN
        SELECT rvb04,rvb03 INTO g_tlf.tlf036,g_tlf.tlf037
         FROM rvb_file where rvb01 = g_tlf.tlf026 AND
                             rvb02 = g_tlf.tlf027
     END IF
     PRINT  COLUMN g_c[31],l_print31,
            COLUMN g_c[32],sr.tlf06,
            COLUMN g_c[33],cl_numfor(l_print33,33,3),
            COLUMN g_c[34],cl_numfor(l_print34,34,3),
            COLUMN g_c[35],cl_numfor(l_print35,35,3),
            COLUMN g_c[36],sr.tlf11,
            COLUMN g_c[37],sr.tlf13,
            COLUMN g_c[38],sr.tlf036,
            COLUMN g_c[39],sr.tlf037 USING '#######&', #No.TQC-5B0212
            COLUMN g_c[40],sr.tlf026,
            COLUMN g_c[41],sr.tlf027 USING '#######&', #No.TQC-5B0212
            COLUMN g_c[42],sr.pmm09,
            COLUMN g_c[43],sr.pmc03
    ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash
             #TQC-630166
             #IF tm.wc[001,120] > ' ' THEN			# for 132
 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
             #IF tm.wc[121,240] > ' ' THEN
 	     #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
             #IF tm.wc[241,300] > ' ' THEN
 	     #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
      END IF
       PRINT g_dash
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #No.TQC-5B0212
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5B0212
        ELSE SKIP 2 LINES
     END IF
END REPORT
}
#No.FUN-840054  --end    
#Patch....NO.TQC-610036 <001> #
