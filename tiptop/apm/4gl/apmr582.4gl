# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmr582.4gl
# Descriptions...: 無交期性採購轉出明細表
# Date & Author..: 01/04/04 By Kammy
# Modify.........: No.FUN-4C0095 05/02/02 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/05 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-620093 06/02/22 By pengu  QBE完後列印,跳出程式
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-840053 08/05/05 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/30 By baofei CR追單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80001 10/08/02 By destiny 列印增加截止日期 
# Modify.........: No.TQC-B40044 11/04/08 By lilingyu l_sql變量定義過短
# Modify.........: No.FUN-B60117 11/06/22 By suncx    wc類型定義錯誤   

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5     #FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD				# Print condition RECORD
               #wc      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500) # Where condition
                wc      STRING,    #FUN-B60117
                a       LIKE type_file.chr1,    # FUN-680136 VARCHAR(1) 
                more    LIKE type_file.chr1     # FUN-680136 VARCHAR(1)
              END RECORD
 
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
   DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE g_sma115      LIKE sma_file.sma115
   DEFINE g_sma116      LIKE sma_file.sma116
#No.FUN-580004 --end--
   DEFINE l_table       STRING                  #No.FUN-840053                                                             
#  DEFINE l_sql         STRING                  #No.FUN-840053       #TQC-B40044
   DEFINE g_sql         STRING                  #No.FUN-840053                                                             
   DEFINE g_str         STRING                  #No.FUN-840053
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-840053---Begin 
   LET g_sql = " pon01.pon_file.pon01,",
               " pon02.pon_file.pon02,",
               " pom04.pom_file.pom04,",
               " pom09.pom_file.pom09,",
               " pon04.pon_file.pon04,",
               " pon041.pon_file.pon041,",
               " pon20.pon_file.pon20,",
               " pon21.pon_file.pon21,",
               " diff.pon_file.pon21,",
               " pon07.pon_file.pon07,",
               " pmn01.pmn_file.pmn01,",
               " pmn02.pmn_file.pmn02,",
               " pmm04.pmm_file.pmm04,",
               " pmm09.pmm_file.pmm09,",
               " pmn04.pmn_file.pmn04,",
               " pmn041.pmn_file.pmn041,",
               " pmn20.pmn_file.pmn20,",
               " pmn07.pmn_file.pmn07,",
               " ima021_pon04.ima_file.ima021,",
               " ima021_pmn04.ima_file.ima021,",
               " pmc03.pmc_file.pmc03,",
               " l_str2.type_file.chr1000,",
               " l_str3.type_file.chr1000, ",
               " pon19.pon_file.pon19"  #NO.FUN-A80001
               
   LET l_table = cl_prt_temptable('apmr582',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,? )"   #NO.FUN-A80001 add ?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-840053---End       
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
#-------------No.TQC-610085 modify
#  INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.a    = 'N'
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)	             # Get arguments from command line
   LET tm.a    = ARG_VAL(8)	             # Get arguments from command line
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#-------------No.TQC-610085 end
   IF tm.wc IS NULL OR tm.wc=' '
      THEN CALL r582_tm(0,0)	
      ELSE CALL apmr582()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r582_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r582_w AT p_row,p_col WITH FORM "apm/42f/apmr582"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pom01,pom04,pom12,pom09,pon04
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
            IF INFIELD(pon04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pon04
               NEXT FIELD pon04
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r582_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more  NOT MATCHES '[YN]' OR tm.more IS NULL  THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW r582_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr582'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr582','9031',1)
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
                         " '",tm.a CLIPPED,"'",             #No.TQC-610085 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr582',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r582_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr582()
   ERROR ""
END WHILE
   CLOSE WINDOW r582_w
END FUNCTION
 
FUNCTION apmr582()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job   #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)     #TQC-B40044
          l_sql 	STRING, 	                                                                                   #TQC-B40044
          l_za05	LIKE type_file.chr1000,   # No.FUN-680136 VARCHAR(40)
          l_pmc03 LIKE pmc_file.pmc03,      #NO.FUN-840053
          i             LIKE type_file.num5,            # No.FUN-580004                   #No.FUN-680136 SMALLINT
          sr            RECORD
                            pon01    LIKE pon_file.pon01,   #採購單號
                            pon02    LIKE pon_file.pon02,   #項次
                            pom04    LIKE pom_file.pom04,   #採購日期
                            pom09    LIKE pom_file.pom09,   #廠商編號
                            pon04    LIKE pon_file.pon04,   #料號
                            pon041   LIKE pon_file.pon041,  #品名規格
                            pon20    LIKE pon_file.pon20,   #申請數量
                            pon21    LIKE pon_file.pon21,   #已轉數量
                            diff     LIKE pon_file.pon21,   #未轉數量
                            pon07    LIKE pon_file.pon07,   #單位
                            pmn01    LIKE pmn_file.pmn01,   #採購單號
                            pmn02    LIKE pmn_file.pmn02,   #項次
                            pmm04    LIKE pmm_file.pmm04,   #採購日期
                            pmm09    LIKE pmm_file.pmm09,   #採購廠商編號
                            pmn04    LIKE pmn_file.pmn04,   #採購料號
                            pmn041   LIKE pmn_file.pmn041,  #採購料號
                            pmn20    LIKE pmn_file.pmn20,   #採購數量
                            pmn07    LIKE pmn_file.pmn07,   #採購單位
                            ima021_pon04 LIKE ima_file.ima021,#FUN-4C0095
                            ima021_pmn04 LIKE ima_file.ima021,#FUN-4C0095
#No.FUN-580004 --start--
                            pon80 LIKE pon_file.pon80,
                            pon82 LIKE pon_file.pon82,
                            pon83 LIKE pon_file.pon83,
                            pon85 LIKE pon_file.pon85,
                            pmn80 LIKE pmn_file.pmn80,
                            pmn82 LIKE pmn_file.pmn82,
                            pmn83 LIKE pmn_file.pmn83,
                            pmn85 LIKE pmn_file.pmn85,
                            pon19 LIKE pon_file.pon19   #NO.FUN-A80001
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02  
#No.FUN-580004 --end--
     DEFINE l_ima906           LIKE ima_file.ima906         #NO.FUN-840053
     DEFINE l_str2             LIKE type_file.chr1000       #NO.FUN-840053
     DEFINE l_str3             LIKE type_file.chr1000       #NO.FUN-840053
     DEFINE l_pmn85            STRING                       #NO.FUN-840053
     DEFINE l_pmn82            STRING                       #NO.FUN-840053
     DEFINE l_pon85            STRING                       #NO.FUN-840053
     DEFINE l_pon82            STRING                       #NO.FUN-840053
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pomuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pomgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pomgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pomuser', 'pomgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT pon01,pon02,pom04,pom09,pon04,pon041,pon20,",
                 "       pon21,pon20-pon21,pon07,pmn01,pmn02,pmm04,",
                 "       pmm09,pmn04,pmn041,pmn20,pmn07,ima021,'', ", #FUN-4C0095 add ima021   #No.TQC-620093 add
                 "       pon80,pon82,pon83,pon85,pmn80,pmn82,pmn83,pmn85,pon19 ", #No.FUN-580004  #NO.FUN-A80001
                " FROM  pon_file, pom_file,pmm_file,pmn_file,OUTER ima_file", ##FUN-4C0095
                " WHERE ",tm.wc CLIPPED,
                "   AND pom01 = pon01 ",
                "   AND pmn68 = pom01 ",
                "   AND pmn69 = pon02 ",
                "   AND pmn01 = pmm01 ",
                "   AND pon_file.pon04 = ima_file.ima01 " #FUN-4C0095
     PREPARE r582_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
     END IF
     DECLARE r582_cs  CURSOR FOR r582_prepare
#    CALL cl_outnam('apmr582') RETURNING l_name    #NO.FUN-840053
#No.FUN-580004  --start
     IF g_sma115 = "Y" THEN
            LET g_zaa[58].zaa06 = "N"
            LET g_zaa[59].zaa06 = "N"
            LET g_zaa[60].zaa06 = "N"
            LET g_zaa[61].zaa06 = "N"
     ELSE
            LET g_zaa[58].zaa06 = "Y"
            LET g_zaa[59].zaa06 = "Y"
            LET g_zaa[60].zaa06 = "Y"
            LET g_zaa[61].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580004 --end--
#    START REPORT r582_rep TO l_name               #NO.FUN-840053
     CALL cl_del_data(l_table)                     #NO.FUN-840053
     LET g_pageno = 0
     FOREACH r582_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#No.FUN-840053---Begin 
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pon04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                IF cl_null(sr.pon85) OR sr.pon85 = 0 THEN
                    CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                    LET l_str2 = l_pon82, sr.pon80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pon82) AND sr.pon82 > 0 THEN
                      CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                      LET l_str2 = l_str2 CLIPPED,',',l_pon82, sr.pon80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pon85) AND sr.pon85 > 0 THEN
                    CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                    LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF      
      
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pmn04
      LET l_str3 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str3 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str3 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str3 = l_str3 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str3 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF          
          EXIT FOREACH
       END IF
       IF tm.a = 'Y' AND sr.diff <= 0 THEN CONTINUE FOREACH END IF
       SELECT ima021 INTO sr.ima021_pmn04
         FROM ima_file
        WHERE ima01=sr.pmn04
        SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.pom09
#      OUTPUT TO REPORT r582_rep(sr.*)
       EXECUTE insert_prep USING  sr.pon01, sr.pon02, sr.pom04, sr.pom09, sr.pon04, sr.pon041,
                                  sr.pon20, sr.pon21, sr.diff,  sr.pon07, sr.pmn01, sr.pmn02, 
                                  sr.pmm04, sr.pmm09, sr.pmn04, sr.pmn041,sr.pmn20, sr.pmn07, 
                                  sr.ima021_pon04,    sr.ima021_pmn04,    l_pmc03,  l_str2,
                                  l_str3 ,sr.pon19 #NO.FUN-A80001
     END FOREACH                    
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'pom01,pom04,pom12,pom09,pon04')         
            RETURNING tm.wc                                                        
    END IF                                                                                                                          
     LET g_str = tm.wc                                                                 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('apmr582','apmr582',l_sql,g_str)
                                       
#    FINISH REPORT r582_rep                      #NO.FUN-840053
#    ERROR ' '                                   #NO.FUN-840053
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) #NO.FUN-840053
#No.FUN-840053---End
END FUNCTION                      
                                  
REPORT r582_rep(sr)               
   DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
#         l_sql         LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(1000)    #TQC-B40044
          l_sql         STRING,                                                      #TQC-B40044
          l_line        LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_pmc03       LIKE pmc_file.pmc03,
          sr            RECORD    
                            pon01    LIKE pon_file.pon01,   #採購單號
                            pon02    LIKE pon_file.pon02,   #項次
                            pom04    LIKE pom_file.pom04,   #採購日期
                            pom09    LIKE pom_file.pom09,   #廠商編號
                            pon04    LIKE pon_file.pon04,   #料號
                            pon041   LIKE pon_file.pon041,  #品名規格
                            pon20    LIKE pon_file.pon20,   #申請數量
                            pon21    LIKE pon_file.pon21,   #已轉數量
                            diff     LIKE pon_file.pon21,   #未轉數量
                            pon07    LIKE pon_file.pon07,   #單位
                            pmn01    LIKE pmn_file.pmn01,   #採購單號
                            pmn02    LIKE pmn_file.pmn02,   #項次
                            pmm04    LIKE pmm_file.pmm04,   #採購日期
                            pmm09    LIKE pmm_file.pmm09,   #採購廠商編號
                            pmn04    LIKE pmn_file.pmn04,   #採購料號
                            pmn041   LIKE pmn_file.pmn041,  #採購料號
                            pmn20    LIKE pmn_file.pmn20,   #採購數量
                            pmn07    LIKE pmn_file.pmn07,   #採購單位
                            ima021_pon04 LIKE ima_file.ima021,#FUN-4C0095
                            ima021_pmn04 LIKE ima_file.ima021,#FUN-4C0095
#No.FUN-580004 --start--
                            pon80 LIKE pon_file.pon80,
                            pon82 LIKE pon_file.pon82,
                            pon83 LIKE pon_file.pon83,
                            pon85 LIKE pon_file.pon85,
                            pmn80 LIKE pmn_file.pmn80,
                            pmn82 LIKE pmn_file.pmn82,
                            pmn83 LIKE pmn_file.pmn83,
                            pmn85 LIKE pmn_file.pmn85
                        END RECORD
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_str2         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(100)
  DEFINE l_str3         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(100)
  DEFINE l_pmn85        STRING
  DEFINE l_pmn82        STRING
  DEFINE l_pon85        STRING
  DEFINE l_pon82        STRING
#No.FUN-580004 --end--
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.pon01,sr.pon02,sr.pmn01,sr.pmn02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
#No.FUN-580004 --start--
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#      PRINTX name=H2 g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[37],g_x[38],g_x[58],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[46],g_x[59],g_x[47]
      PRINTX name=H2 g_x[48],g_x[49],g_x[36],g_x[56],g_x[51],g_x[52],g_x[60],g_x[53],g_x[45]
      PRINTX name=H3 g_x[55],g_x[50],g_x[57],g_x[61],g_x[54]
#No.FUN-580004 --end--
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pon02
#No.FUN-580004 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pon04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                IF cl_null(sr.pon85) OR sr.pon85 = 0 THEN
                    CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                    LET l_str2 = l_pon82, sr.pon80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pon82) AND sr.pon82 > 0 THEN
                      CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                      LET l_str2 = l_str2 CLIPPED,',',l_pon82, sr.pon80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pon85) AND sr.pon85 > 0 THEN
                    CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                    LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
 
 
      LET l_line = 0
      PRINTX name=D1 COLUMN g_c[31],sr.pon01,
                     COLUMN g_c[32],sr.pon02 USING '###&',
                     COLUMN g_c[33],sr.pom04,
                     COLUMN g_c[34],sr.pom09,
                     COLUMN g_c[35],sr.pon04 CLIPPED,  #FUN-5B0014 [1,20],
                     COLUMN g_c[37],cl_numfor(sr.pon20,37,3),
                     COLUMN g_c[38],cl_numfor(sr.pon21,38,3),
                     COLUMN g_c[58],l_str2 CLIPPED, #No.FUN-580004
                     COLUMN g_c[39],sr.pon07;
 
   ON EVERY ROW
      LET l_line = l_line + 1
 
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pmn04
      LET l_str3 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str3 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str3 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str3 = l_str3 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str3 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      PRINTX name=D1 COLUMN g_c[40],sr.pmn01,
                     COLUMN g_c[41],sr.pmn02 USING '###&',
                     COLUMN g_c[42],sr.pmm04,
                     COLUMN g_c[43],sr.pmm09,
                     COLUMN g_c[44],sr.pmn04 CLIPPED, #FUN-5B0014 [1,20],
                     COLUMN g_c[46],cl_numfor(sr.pmn20,46,3),
                     COLUMN g_c[59],l_str3 CLIPPED, #No.FUN-580004
                     COLUMN g_c[47],sr.pmn07
      IF l_line = 1 THEN
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.pom09
         PRINTX name=D2 COLUMN g_c[48],' ',
                        COLUMN g_c[49],l_pmc03,
                        COLUMN g_c[36],sr.pon041,
                        COLUMN g_c[51],cl_numfor(sr.diff,51,3);
      END IF
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.pmm09
      PRINTX name=D2 COLUMN g_c[52],' ',
                     COLUMN g_c[60],' ',
                     COLUMN g_c[53],l_pmc03,
                     COLUMN g_c[45],sr.pmn041
      PRINTX name=D3 COLUMN g_c[55],' ',
                     COLUMN g_x[50],sr.ima021_pon04,
                     COLUMN g_c[57],' ',
                     COLUMN g_c[61],' ',
                     COLUMN g_c[54],sr.ima021_pmn04
#No.FUN-580004 --end--
   AFTER GROUP OF sr.pon01
      PRINT
 
   ON LAST ROW
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
#No.FUN-870144
