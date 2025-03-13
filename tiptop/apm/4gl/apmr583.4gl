# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmr583.4gl
# Descriptions...: 料件無交期性採購未轉明細表
# Date & Author..: 01/04/03 By Mandy
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/08 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-750112 07/05/28 By Jackho CR報表修改
# Modify.........: No.TQC-960388 09/06/26 By lilingyu 當未轉數量為0,即已經全部轉出時,不應該列印出該筆資料 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.FUN-A80001 10/08/02 By destiny 列印增加截止日期
# Modify.........: No.TQC-B30074 11/03/07 By lilingyu 料件編號開窗後,選擇全部資料,然後確定,程序報錯:找到一個未成對的引號
 
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
 
  DEFINE tm  RECORD				# Print condition RECORD
#        	wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)       # Where condition     #TQC-B30074 
         	wc  	STRING,                                                                         #TQC-B30074 
  		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)	       # Input more condition(Y/N)
             END RECORD
 
  DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
  DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680136 INTEGER
  DEFINE   g_sma115     LIKE sma_file.sma115
  DEFINE   g_sma116     LIKE sma_file.sma116
  DEFINE   l_table      STRING                  ### FUN-750112 ###
  DEFINE   g_str        STRING                  ### FUN-750112 ###
  DEFINE   g_sql        STRING                  ### FUN-750112 ###
#No.FUN-580004 --end--
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
 
#--------FUN-750112--begin--CR(1)-----------#
    LET g_sql = " pon04.pon_file.pon04,",
                " pon041.pon_file.pon041,", 
                " ima021.ima_file.ima021,", 
                " pon01.pon_file.pon01,", 
                " pon02.pon_file.pon02,",
                " pom04.pom_file.pom04,",
                " pom09.pom_file.pom09,",
                " pmc03.pmc_file.pmc03,",
                " pon20.pon_file.pon20,",
                " pon21.pon_file.pon21,",
                " pmn20.pmn_file.pmn20,",
                " chr1000.type_file.chr1000,",
                " pon07.pon_file.pon07,",
                " pon19.pon_file.pon19"   #NO.FUN-A80001
 
    LET l_table = cl_prt_temptable('apmr583',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ",
                "        ?,?,?,?)"  #NO.FUN-A80001
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#-------------------No.FUN-750112--end--CR(1)---------------#
 
#----------------No.TQC-610085 modify
#  INITIALIZE tm.* TO NULL            # Default condition
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#----------------No.TQC-610085 end
   IF tm.wc IS NULL OR tm.wc=' '
      THEN CALL r583_tm(0,0)	
      ELSE CALL apmr583()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r583_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW r583_w AT p_row,p_col WITH FORM "apm/42f/apmr583"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pon04,pom01,pom04,pom12,pom09
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
      LET INT_FLAG = 0 CLOSE WINDOW r583_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME  tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r583_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr583'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr583','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,"'","\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr583',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r583_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr583()
   ERROR ""
END WHILE
   CLOSE WINDOW r583_w
END FUNCTION
 
FUNCTION apmr583()
   DEFINE l_name	LIKE type_file.chr20, 	            # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,   		    # Used time for running the job  #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,		    # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)   #TQC-B30074
          l_sql 	STRING,                                                                                             #TQC-B30074
          l_za05	LIKE type_file.chr1000,             # No.FUN-680136 VARCHAR(40)
          sr            RECORD
                            pon04    LIKE pon_file.pon04,   #料號
                            pon041   LIKE pon_file.pon041,  #品名規格
                            pon01    LIKE pon_file.pon01,   #採購單號
                            pon02    LIKE pon_file.pon02,   #項次
                            pom04    LIKE pom_file.pom04,   #採購日期
                            pom09    LIKE pom_file.pom09,   #廠商編號
                            pmc03    LIKE pmc_file.pmc03,   #廠商簡稱
                            pon20    LIKE pon_file.pon20,   #申請數量
                            pon21    LIKE pon_file.pon21,   #已轉數量
                           #No.FUN-750112--begin
#                            rest     LIKE pon_file.pon21,   #未轉數量
                            pmn20    LIKE pmn_file.pmn20,   #用來保存申請數量-已轉數量
                           #No.FUN-750112--end
                            pon07    LIKE pon_file.pon07,   #單位
#No.FUN-580004 --start--
                            pon80    LIKE pon_file.pon80,
                            pon82    LIKE pon_file.pon82,
                            pon83    LIKE pon_file.pon83,
                            pon85    LIKE pon_file.pon85,
                            pon19    LIKE pon_file.pon19  #NO.FUN-A80001
                        END RECORD
     DEFINE l_i,l_cnt       LIKE type_file.num5             #No.FUN-680136 SMALLINT
     DEFINE l_zaa02         LIKE zaa_file.zaa02
     DEFINE i               LIKE type_file.num5             #No.FUN-680136 SMALLINT
#No.FUN-580004 --end--
   DEFINE l_ima906       LIKE ima_file.ima906              #No.FUN-750112  
   DEFINE l_ima021       LIKE ima_file.ima021              #No.FUN-750112  
   DEFINE l_str2         LIKE type_file.chr1000            #No.FUN-750112  
   DEFINE l_pon85        STRING                            #No.FUN-750112  
   DEFINE l_pon82        STRING                            #No.FUN-750112  
 
 #No.FUN-750112--begin--CR(2) 
     CALL cl_del_data(l_table)
 #No.FUN-750112--end--CR(2)
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
 
     #--------------
     LET l_sql =
                "SELECT pon04,pon041,pon01,pon02,",
                "       pom04,pom09,pmc03,pon20,pon21,",
                "       pon20-pon21,pon07,pon80,pon82,pon83,pon85,pon19",#No.FUN-580004  #NO.FUN-A80001 add pon19
                " FROM  pon_file, pom_file ",
                " LEFT OUTER JOIN pmc_file ON pmc01 = pom09",
                " WHERE ",tm.wc CLIPPED,
                "   AND pom01 = pon01 "
     #--------------
     PREPARE r583_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
     END IF
     DECLARE r583_cs  CURSOR FOR r583_prepare
#No.FUN-750112--begin------------------------------------------# 
#     CALL cl_outnam('apmr583') RETURNING l_name
#No.FUN-580004  --start
#     IF g_sma115 = "Y" THEN
#            LET g_zaa[43].zaa06 = "N"
#     ELSE
#            LET g_zaa[43].zaa06 = "Y"
#     END IF
#     CALL cl_prt_pos_len()
#No.FUN-580004 --end--
#     START REPORT r583_rep TO l_name
#     LET g_pageno = 0
#No.FUN-750112--end--------------------------------------------# 
     FOREACH r583_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#TQC-960388 --begin--
       IF sr.pmn20 = 0 THEN 
          CONTINUE FOREACH
       END IF  
#TQC-960388 --end--        
       IF cl_null(sr.pon041) THEN
           SELECT ima02
               INTO sr.pon041
               FROM ima_file
               WHERE  ima01 = sr.pon04
       END IF
#No.FUN-750112--begin------------------------------------------------------------#
#       OUTPUT TO REPORT r583_rep(sr.*)
## Crystal Reports insert temp table --CR(3) ##
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pon04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
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
        END IF 
        EXECUTE insert_prep USING 
                sr.pon04,sr.pon041,l_ima021,sr.pon01,sr.pon02,                                                                                 
                sr.pom04,sr.pom09,sr.pmc03,sr.pon20,sr.pon21,                                                                            
                sr.pmn20,l_str2,sr.pon07,sr.pon19 #NO.FUN-A80001 add pon19
#insert temp table--end--CR(3) 
     END FOREACH
 
#     FINISH REPORT r583_rep
#     ERROR ' '
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
## ****  Crystal Reports <<<< CALL cs3() >>>>--CR(4) ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
#    LET g_str = g_sma115
    IF g_sma115 = "Y" THEN
       CALL cl_prt_cs3('apmr583','apmr583',l_sql,'')             
    ELSE
       CALL cl_prt_cs3('apmr583','apmr583_1',l_sql,'')             
    END IF
#    CALL cl_prt_cs3('apmr583','apmr583',l_sql,g_str)             
## ****  Crystal Reports <<<< CALL cs3() >>>>--CR(4) ##
#No.FUN-750112--end------------------------------------------------------------#
END FUNCTION
 
#No.FUN-750112--begin
#REPORT r583_rep(sr)
#   DEFINE l_ima021     LIKE ima_file.ima021  #FUN-4C0095
#   DEFINE l_last_sw	LIKE type_file.chr1,                #No.FUN-680136 VARCHAR(1)
#          CR報表修改        LIKE type_file.chr1000,             #No.FUN-680136 VARCHAR(1000)
#          sr            RECORD
#                            pon04    LIKE pon_file.pon04,   #料號
#                            pon041   LIKE pon_file.pon041,  #品名規格
#                            pon01    LIKE pon_file.pon01,   #採購單號
#                            pon02    LIKE pon_file.pon02,   #項次
#                            pom04    LIKE pom_file.pom04,   #採購日期
#                            pom09    LIKE pom_file.pom09,   #廠商編號
#                            pmc03    LIKE pmc_file.pmc03,   #廠商簡稱
#                            pon20    LIKE pon_file.pon20,   #申請數量
#                            pon21    LIKE pon_file.pon21,   #已轉數量
#                            rest     LIKE pon_file.pon21,   #未轉數量
#                            pon07    LIKE pon_file.pon07,   #單位
##No.FUN-580004 --start--
#                            pon80    LIKE pon_file.pon80,
#                            pon82    LIKE pon_file.pon81,
#                            pon83    LIKE pon_file.pon83,
#                            pon85    LIKE pon_file.pon85
#                        END RECORD
#  DEFINE l_ima906       LIKE ima_file.ima906
#  DEFINE l_str2         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(100)
#  DEFINE l_pon85        STRING
#  DEFINE l_pon82        STRING
##No.FUN-580004 --end--
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pon04,sr.pon01,sr.pon02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[43],g_x[42]   #No.FUN-580004
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.pon04
#      SELECT ima021
#        INTO l_ima021
#        FROM ima_file
#       WHERE ima01=sr.pon04
#      IF SQLCA.sqlcode THEN
#          LET l_ima021 = NULL
#      END IF
#      PRINT COLUMN g_c[31],sr.pon04 CLIPPED,  #FUN-5B0014 [1,20],
#            COLUMN g_c[32],sr.pon041,
#            COLUMN g_c[33],l_ima021;
#
#   ON EVERY ROW
##No.FUN-580004 --start--
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01=sr.pon04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
#                LET l_str2 = l_pon85 , sr.pon83 CLIPPED
#                IF cl_null(sr.pon85) OR sr.pon85 = 0 THEN
#                    CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
#                    LET l_str2 = l_pon82, sr.pon80 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.pon82) AND sr.pon82 > 0 THEN
#                      CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
#                      LET l_str2 = l_str2 CLIPPED,',',l_pon82, sr.pon80 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.pon85) AND sr.pon85 > 0 THEN
#                    CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
#                    LET l_str2 = l_pon85 , sr.pon83 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      PRINT COLUMN g_c[34],sr.pon01,
#            COLUMN g_c[35],sr.pon02 USING "########",
#            COLUMN g_c[36],sr.pom04,
#            COLUMN g_c[37],sr.pom09,
#            COLUMN g_c[38],sr.pmc03,
#            COLUMN g_c[39],cl_numfor(sr.pon20,39,3),
#            COLUMN g_c[40],cl_numfor(sr.pon21,40,3),
#            COLUMN g_c[41],cl_numfor(sr.rest,41,3),
#            COLUMN g_c[43],l_str2 CLIPPED,   #No.FUN-580004
#            COLUMN g_c[42],sr.pon07
##No.FUN-580004  --end--
#   AFTER GROUP OF sr.pon04
##       PRINT g_dash1
#       PRINT COLUMN g_c[38],g_x[21] CLIPPED,
#             COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pon20),39,3),
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.pon21),40,3),
#             COLUMN g_c[41],cl_numfor(GROUP SUM(sr.rest),41,3)
#   ON LAST ROW
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-750112--end
