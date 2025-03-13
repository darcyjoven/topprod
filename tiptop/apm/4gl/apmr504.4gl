# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmr504.4gl
# Descriptions...: 料件採購明細查詢
# Input parameter:
# Date & Author..: 91/11/04 By May
# Modify.........: 99/04/16 By Carol:modify s_pmmsta()
# Modify.........: No.FUN-4C0095 05/01/04 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/04 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0105 05/11/11 By Mandy 報表的單號/料號/品名/規各對齊調整
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-830100 08/04/09 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30076 11/03/07 By lilingyu 料件編號開窗後,選擇全部資料,然後確定,程序報錯:找到一個未成對的引號
# Modify.........: No.MOD-C40002 12/04/02 By Vampire 判斷tm.y !='4'時才加pmm18 !='X'的條件
 
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
 
   DEFINE tm  RECORD			        # Print condition RECORD
        #	wc   VARCHAR(500),		# Where condition
        	wc  	STRING,	                #TQC-630166    # Where condition
                y       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   	        more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_azm03        LIKE type_file.num5,   #No.FUN-680136 SMALLINT  # 季別
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total        LIKE tlf_file.tlf18,   #No.FUN-680136 DECIMAL(13,3)
          g_pmn01        LIKE pmn_file.pmn01
 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
DEFINE   l_table         STRING                 #No.FUN-830100                                                                      
DEFINE   g_sql           STRING                 #No.FUN-830100                                                                      
DEFINE   g_str           STRING                 #No.FUN-830100   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-830100  --BEGIN                                                                                                             
   LET g_sql = "pmn01.pmn_file.pmn01,",                                                                                             
               "pmn02.pmn_file.pmn02,",                                                                                             
               "pmn04.pmn_file.pmn04,",                                                                                             
               "pmn041.pmn_file.pmn041,",                                                                                           
               "pmn07.pmn_file.pmn07,",                                                                                             
               "pmn08.pmn_file.pmn08,",                                                                                             
               "pmn16.pmn_file.pmn16,",                                                                                             
               "pmn20.pmn_file.pmn20,",                                                                                             
               "pmn24.pmn_file.pmn24,",                                                                                             
               "pmn44.pmn_file.pmn44,",                                                                                             
               "pmn50.pmn_file.pmn50,",                                                                                             
               "pmn51.pmn_file.pmn51,",                                                                                             
               "pmn53.pmn_file.pmn53,",                                                                                             
               "pmn55.pmn_file.pmn55,",                                                                                             
               "pmm01.pmm_file.pmm01,",                                                                                             
               "pmm04.pmm_file.pmm04,",                                                                                             
               "pmm09.pmm_file.pmm09,",                                                                                             
               "pmm12.pmm_file.pmm12,",                                                                                             
               "pmm13.pmm_file.pmm13,",                                                                                             
               "pmm22.pmm_file.pmm22,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ima05.ima_file.ima05,",                                                                                             
               "ima08.ima_file.ima08,",        
               "ima25.ima_file.ima25,",                                                                                             
               "ima44.ima_file.ima44,",                                                                                             
               "pmc03.pmc_file.pmc03,",                                                                                             
               "gem02.gem_file.gem02,",                                                                                             
               "gen02.gen_file.gen02,",                                                                                             
               "pmm18.pmm_file.pmm18,",                                                                                             
               "pmmmksg.pmm_file.pmmmksg,",                                                                                         
               "pmn80.pmn_file.pmn80,",                                                                                             
               "pmn82.pmn_file.pmn82,",                                                                                             
               "pmn83.pmn_file.pmn83,",                                                                                             
               "pmn85.pmn_file.pmn85,",                                                                                             
               "l_pmn16.type_file.chr10,",                                                                                          
               "l_str2.type_file.chr1000"                                                                                           
   LET l_table = cl_prt_temptable("apmr504",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                               
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? ) "                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830100  --end                            
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r504_tm(0,0)		        # Input print condition
      ELSE CALL r504()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r504_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r504_w AT p_row,p_col WITH FORM "apm/42f/apmr504"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET tm.y    = '5'
   LET g_pdate = g_today
   LET g_rlang = g_lang
 # LET g_prtway= "Q"
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmn04,pmm01,pmm04,pmm09,pmm12,pmn24
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
#No.FUN-570243 --start--
     ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#No.FUN-570243 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW r504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more,tm.y 		# Condition
   INPUT BY NAME  tm.y,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD y
         IF cl_null(tm.y) OR tm.y NOT MATCHES '[12345]' THEN
            NEXT FIELD y
         END IF
 
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more  NOT MATCHES '[YN]'  OR tm.more IS NULL THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW r504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr504'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr504','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                     #----------------No.TQC-610085 modify
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.y  CLIPPED,"'",
                     #----------------No.TQC-610085 end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr504',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r504_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r504()
   ERROR ""
END WHILE
   CLOSE WINDOW r504_w
END FUNCTION
 
FUNCTION r504()
   DEFINE l_name	LIKE type_file.chr20, 	   # External(Disk) file name      #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	   # Used time for running the job #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,	   # RDSQL STATEMENT               #No.FUN-680136 VARCHAR(1000)    #TQC-B30076 
          l_sql 	STRING,                                                                                    #TQC-B30076 
          l_za05	LIKE type_file.chr1000,    # No.FUN-680136 VARCHAR(40)
          i             LIKE type_file.num5,       # No.FUN-580004 #No.FUN-680136 SMALLINT
          sr              RECORD
                                  pmn01  LIKE pmn_file.pmn01,
                                  pmn02  LIKE pmn_file.pmn02,
                                  pmn04  LIKE pmn_file.pmn04,
                                  pmn041 LIKE pmn_file.pmn041,
                                  pmn07  LIKE pmn_file.pmn07,
                                  pmn08  LIKE pmn_file.pmn08,
                                  pmn16  LIKE pmn_file.pmn16,
                                  pmn20  LIKE pmn_file.pmn20,
                                  pmn24  LIKE pmn_file.pmn24,
                                  pmn44  LIKE pmn_file.pmn44,
                                  pmn50  LIKE pmn_file.pmn50,
                                  pmn51  LIKE pmn_file.pmn51,
                                  pmn53  LIKE pmn_file.pmn53,
                                  pmn55  LIKE pmn_file.pmn55,
                                  pmm01  LIKE pmm_file.pmm01,
                                  pmm04  LIKE pmm_file.pmm04,
                                  pmm09  LIKE pmm_file.pmm09,
                                  pmm12  LIKE pmm_file.pmm12,
                                  pmm13  LIKE pmm_file.pmm13,
                                  pmm22  LIKE pmm_file.pmm22,
                                  ima021  LIKE ima_file.ima021, #FUN-4C0095
                                  ima05  LIKE ima_file.ima05,
                                  ima08  LIKE ima_file.ima08,
                                  ima25  LIKE ima_file.ima25,
                                  ima44  LIKE ima_file.ima44,
                                  pmc03  LIKE pmc_file.pmc03,
                                  gem02  LIKE gem_file.gem02,
                                  gen02  LIKE gen_file.gen02,
                                  pmm18  LIKE pmm_file.pmm18,
                                  pmmmksg  LIKE pmm_file.pmmmksg,
#No.FUN-580004 --start--
                                  pmn80 LIKE pmn_file.pmn80,
                                  pmn82 LIKE pmn_file.pmn82,
                                  pmn83 LIKE pmn_file.pmn83,
                                  pmn85 LIKE pmn_file.pmn85
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
#No.FUN-580004 --end--
#No.FUN-830100  --BEGIN                                                                                                             
     DEFINE l_pmn16            LIKE type_file.chr10                                                                                 
     DEFINE l_str2             LIKE type_file.chr1000                                                                               
     DEFINE l_ima906           LIKE ima_file.ima906                                                                                 
     DEFINE l_pmn82            STRING                                                                                               
     DEFINE l_pmn85            STRING                                                                                               
#No.FUN-830100--END                                                                                                                 
                                                                                                                                    
     CALL cl_del_data(l_table)      #No.FUN-830100    
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004----------Begin--------------
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#       FROM azi_file                 #幣別檔小數位數讀取
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004----------End-----------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT ",
                 " pmn01,pmn02,pmn04,pmn041,pmn07,",
                 " pmn08,pmn16,pmn20,",
                 " pmn24,pmn44,pmn50,pmn51,pmn53,pmn55,",
                 " pmm01,pmm04,pmm09,pmm12,pmm13,pmm22,",
                 " ima021,ima05,ima08,ima25,ima44,'','','',pmm18,pmmmksg, ", #FUN-4C0095 add ima021
                 " pmn80,pmn82,pmn83,pmn85 ",  #No.FUN-580004
                 " FROM pmn_file,pmm_file,OUTER ima_file",
                 #" WHERE pmn01 = pmm01 AND pmm18 !='X' ", #MOD-C40002 mark
                 " WHERE pmn01 = pmm01 ",                  #MOD-C40002 add
                 "  AND pmn_file.pmn04 = ima_file.ima01 ",
                 "  AND ",tm.wc CLIPPED
     CASE tm.y
        WHEN '1'  LET l_sql = l_sql CLIPPED,
               " AND (pmn16 = '1' OR (pmmmksg = 'N' AND pmn16 = '0' )) "
        WHEN '2' LET l_sql = l_sql CLIPPED," AND  pmn16 = '2' "
        #WHEN '3' LET l_sql = l_sql CLIPPED," AND ( pmn16 matches'[678]') " #MOD-C40002 mark
        WHEN '3' LET l_sql = l_sql CLIPPED," AND ( pmn16 IN ('6','7','8')) "  #MOD-C40002 add
        WHEN '4' LET l_sql = l_sql CLIPPED," AND  pmn16 = '9' "
        OTHERWISE EXIT CASE
     END CASE
     #MOD-C40002 add start -----
     IF tm.y != '4' THEN
        LET l_sql = l_sql CLIPPED," AND pmm18 !='X' "
     END IF
     #MOD-C40002 add end  -----
     LET l_sql = l_sql CLIPPED, ' ORDER BY pmn01,pmn02'
     PREPARE r504_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r504_curs  CURSOR FOR r504_prepare
#No.FUN-830100  --BEGIN                                                                                                             
{        
     CALL cl_outnam('apmr504') RETURNING l_name
#No.FUN-580004  --start
     IF g_sma115 = "Y" THEN
            LET g_zaa[42].zaa06 = "N"
     ELSE
            LET g_zaa[42].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580004 --end--
     START REPORT r504_rep TO l_name
}
     IF g_sma115 = "Y" THEN                                                                                                         
        LET l_name = 'apmr504'                                                                                                      
     ELSE                                                                                                                           
        LET l_name = 'apmr504_1'                                                                                                    
     END IF                                                                                                                         
#No.FUN-830100  --END          
     FOREACH r504_curs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.pmn04 IS NULL THEN LET sr.pmn04 = ' ' END IF
       IF sr.pmn01 IS NULL THEN LET sr.pmn01 = ' ' END IF
       SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.pmm13
       IF SQLCA.sqlcode THEN LET sr.gem02 = NULL END IF
       SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01 = sr.pmm12
       IF SQLCA.sqlcode THEN LET sr.gen02 = NULL END IF
       SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01 = sr.pmm09
       IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
#No.FUN-830100  --begin 
       #OUTPUT TO REPORT r504_rep(sr.*)
       IF NOT cl_null(sr.pmn16) THEN                                                                                                
          CALL s_pmmsta('pmm',sr.pmn16,sr.pmm18,sr.pmmmksg) RETURNING l_pmn16                                                       
       END IF                                                                                                                       
       SELECT ima906 INTO l_ima906 FROM ima_file                                                                                    
        WHERE ima01=sr.pmn04                                                                                                        
       LET l_str2 = ""                                                                                                              
       IF g_sma115 = "Y" THEN                                                                                                       
          CASE l_ima906                                                                                                             
             WHEN "2"                                                                                                               
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                                                                     
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                                                                             
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN                                                                           
                   CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82                                                                  
                   LET l_str2 = l_pmn82, sr.pmn80 CLIPPED                                                                           
                ELSE                                                                                                                
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN                                                                   
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82                                                               
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED                                                     
                   END IF                                                                                                           
                END IF                                                                                                              
             WHEN "3"                                                                                                               
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN                                                                      
                   CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                                                                  
                   LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED 
                END IF                                                                                                              
          END CASE                                                                                                                  
       END IF                                                                                                                       
       EXECUTE insert_prep USING sr.pmn01, sr.pmn02,sr.pmn04,sr.pmn041,sr.pmn07,                                                    
                                 sr.pmn08, sr.pmn16,sr.pmn20,sr.pmn24, sr.pmn44,                                                    
                                 sr.pmn50, sr.pmn51,sr.pmn53,sr.pmn55, sr.pmm01,                                                    
                                 sr.pmm04, sr.pmm09,sr.pmm12,sr.pmm13, sr.pmm22,                                                    
                                 sr.ima021,sr.ima05,sr.ima08,sr.ima25, sr.ima44,                                                    
                                 sr.pmc03, sr.gem02,sr.gen02,sr.pmm18, sr.pmmmksg,                                                  
                                 sr.pmn80, sr.pmn82,sr.pmn83,sr.pmn85, l_pmn16,                                                     
                                 l_str2                                                                                             
#No.FUN-830100  --end                                       
     END FOREACH
#No.FUN-830100  --begin 
     #FINISH REPORT r504_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'pmn04,pmm01,pmm04,pmm09,pmm12,pmn24')                                                                  
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str=g_str CLIPPED                                                                                                        
     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('apmr504',l_name,g_sql,g_str)                                                                                  
#No.FUN-830100  --end                             
 
END FUNCTION
 
#No.FUN-830100  --begin                                                                                                             
{                
REPORT r504_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_str         LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(30)
          l_sw          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_swth        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_pmn16       LIKE type_file.chr10,   #No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
          sr              RECORD
                                  pmn01  LIKE pmn_file.pmn01,
                                  pmn02  LIKE pmn_file.pmn02,
                                  pmn04  LIKE pmn_file.pmn04,
                                  pmn041 LIKE pmn_file.pmn041,
                                  pmn07  LIKE pmn_file.pmn07,
                                  pmn08  LIKE pmn_file.pmn08,
                                  pmn16  LIKE pmn_file.pmn16,
                                  pmn20  LIKE pmn_file.pmn20,
                                  pmn24  LIKE pmn_file.pmn24,
                                  pmn44  LIKE pmn_file.pmn44,
                                  pmn50  LIKE pmn_file.pmn50,
                                  pmn51  LIKE pmn_file.pmn51,
                                  pmn53  LIKE pmn_file.pmn53,
                                  pmn55  LIKE pmn_file.pmn55,
                                  pmm01  LIKE pmm_file.pmm01,
                                  pmm04  LIKE pmm_file.pmm04,
                                  pmm09  LIKE pmm_file.pmm09,
                                  pmm12  LIKE pmm_file.pmm12,
                                  pmm13  LIKE pmm_file.pmm13,
                                  pmm22  LIKE pmm_file.pmm22,
                                  ima021  LIKE ima_file.ima021, #FUN-4C0095
                                  ima05  LIKE ima_file.ima05,
                                  ima08  LIKE ima_file.ima08,
                                  ima25  LIKE ima_file.ima25,
                                  ima44  LIKE ima_file.ima44,
                                  pmc03  LIKE pmc_file.pmc03,
                                  gem02  LIKE gem_file.gem02,
                                  gen02  LIKE gen_file.gen02,
                                  pmm18  LIKE pmm_file.pmm18,
                                  pmmmksg  LIKE pmm_file.pmmmksg,
#No.FUN-580004 --start--
                                  pmn80 LIKE pmn_file.pmn80,
                                  pmn82 LIKE pmn_file.pmn82,
                                  pmn83 LIKE pmn_file.pmn83,
                                  pmn85 LIKE pmn_file.pmn85
                        END RECORD
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_str2         LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(100)
  DEFINE l_pmn85        STRING
  DEFINE l_pmn82        STRING
#No.FUN-580004 --end--
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmn04,sr.pmn041,sr.pmn01,sr.pmn02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT ' '
      PRINT g_dash
      PRINT COLUMN  01,g_x[11] CLIPPED,sr.pmn04 CLIPPED, #FUN-5B0014 [1,20],  12->1
            COLUMN  88,g_x[12] CLIPPED,sr.ima05,  #TQC-5B0105 &051112
            COLUMN 110,g_x[13] CLIPPED,sr.ima08   #TQC-5B0105 &051112
      PRINT COLUMN  01,g_x[14] CLIPPED,sr.pmn041, #FUN-5B0014 12->01
            COLUMN  88,g_x[15] CLIPPED,sr.ima25,  #TQC-5B0105 &051112
            COLUMN 110,g_x[16] CLIPPED,sr.ima44   #TQC-5B0105 &051112
      PRINT COLUMN  01,g_x[17] CLIPPED,sr.ima021  #FUN-5B0014 12->01
      PRINT ' '
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]  #No.FUN-580004
      PRINT g_dash1
      LET l_last_sw = 'n'
 
BEFORE GROUP  OF sr.pmn01
#判斷單號是否相同若不同才列印單號
      IF g_pmn01 IS NULL OR g_pmn01 != sr.pmn01 THEN
         LET l_sw = 'Y'
      ELSE LET l_sw = 'N'
      END IF
      PRINT COLUMN g_c[31],sr.pmn01;
 
ON EVERY ROW
      IF NOT cl_null(sr.pmn16) THEN
          CALL s_pmmsta('pmm',sr.pmn16,sr.pmm18,sr.pmmmksg) RETURNING l_pmn16
      END IF
#No.FUN-580004 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pmn04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
 
            PRINT COLUMN g_c[32],sr.pmn02 USING '########',
                  COLUMN g_c[33],sr.pmm09,#廠商編號
                  COLUMN g_c[34],sr.pmc03,
                  COLUMN g_c[35],sr.pmm13,#採購部門編號
                  COLUMN g_c[36],sr.gem02,
                  COLUMN g_c[37],sr.pmm12,#採購員編號
                  COLUMN g_c[38],sr.gen02,
                  COLUMN g_c[39],l_pmn16,
                  COLUMN g_c[40],sr.pmn08,
                  COLUMN g_c[41],sr.pmn07,
                  COLUMN g_c[42],l_str2 CLIPPED,  #No.FUN-580004
                  COLUMN g_c[43],cl_numfor(sr.pmn20,43,3) CLIPPED,
                  COLUMN g_c[44],cl_numfor(sr.pmn50,44,3) CLIPPED,
                  COLUMN g_c[45],cl_numfor(sr.pmn51,45,3) CLIPPED,
                  COLUMN g_c[46],cl_numfor(sr.pmn55,46,3) CLIPPED,
                  COLUMN g_c[47],cl_numfor(sr.pmn53,47,3) CLIPPED
#No.FUN-580004 --end--
      LET g_pmn01 = sr.pmn01
 
BEFORE GROUP  OF sr.pmn04
      SKIP TO TOP OF PAGE
 
AFTER GROUP OF sr.pmn01
      LET g_pmn01 = NULL
 
ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'pmn04,pmm01,pmm04,pmm09,pmm12,pmn24')
              RETURNING tm.wc
             PRINT g_dash
           #  IF tm.wc[001,70] > ' ' THEN			# for 80
           #     PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
           #  IF tm.wc[071,140] > ' ' THEN
           #     PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
           #  IF tm.wc[141,210] > ' ' THEN
  	   #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
           #  IF tm.wc[211,280] > ' ' THEN
  	   #     PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	    #TQC-630166
	     CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-830100  --end
#Patch....NO.TQC-610036 <001> #
