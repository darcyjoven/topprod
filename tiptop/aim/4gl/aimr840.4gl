# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr840.4gl
# Descriptions...: 料件需求供給查詢
# Return code....:
# Date & Author..: 94/7/8 By Nick
# Modify.........: No.FUN-510017 05/01/27 By Mandy 報表轉XML
# Modify.........: No.MOD-550084 05/06/27 By Elva 打印類別時iqc fqc狀態類型顯示不正確
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-640470 06/04/12 By Sarah 供需數量欄位應加回驗退量(pmn55)
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/03/16 By TSD.Jin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-8A0045 08/10/05 By Jan 打印時加入請購資料
# Modify.........: No.MOD-8B0104 08/11/11 By Sarah 抓取"採購供給"的SQL條件應該與aimq841抓取"採購量"的SQL條件一樣
# Modify.........: No.MOD-8B0117 08/11/12 By Sarah 抓取"採購供給"的SQL日期應抓pmn35
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.CHI-A40038 10/04/20 By houlia 追單MOD-9B0053
# Modify.........: No.CHI-A40038 10/04/20 By houlia 追單MOD-9B0125
# Modify.........: No:MOD-A70127 10/07/16 By Sarah 增加委外IQC在驗量,用來顯示委外工單的QC量
# Modify.........: NO:MOD-AA0069 10/10/13 BY sabrina FQC在驗量先排除拆件式工單(sfb02<>'11')
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD                              # Print condition RECORD
                wc      STRING,                     # Where Condition  #TQC-630166
                j       LIKE type_file.chr1,        # 不同料號是否跳頁  #No.FUN-690026 VARCHAR(1)
                more    LIKE type_file.chr1         #  #No.FUN-690026 VARCHAR(1)
                END RECORD,
       l_flag   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_n      LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
DEFINE g_i      LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#MOD-720046 By TSD.Jin--end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " ds_fg.type_file.num5,  ",
               " class.type_file.num5,  ",
               " ima01.rpc_file.rpc01,  ",
               " ds_date.rpc_file.rpc12,",
               " rpc02.rpc_file.rpc02,  ",
               " cust.pmm_file.pmm09,   ",
               " qty.rpc_file.rpc13,    ",
               " pmc01.pmc_file.pmc01,  ", 
               " t1.ima_file.ima01,     ", 
               " t2.ima_file.ima02,     ", 
               " t3.ima_file.ima25,     ", 
#              " t4.ima_file.ima26,     ",        #FUN-A20044
               " t4.type_file.num15_3,  ",        #FUN-A20044 
               " t5.ima_file.ima021,    ",
               " azi03.azi_file.azi03,  ",
               " azi04.azi_file.azi04,  ",
               " azi05.azi_file.azi05   " 
 
   LET l_table = cl_prt_temptable('aimr840',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?) "
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #MOD-720046 By TSD.Jin--end
 
   LET g_pdate 	= ARG_VAL(1)		# Get arguments from command line
   LET g_towhom	= ARG_VAL(2)
   LET g_rlang 	= ARG_VAL(3)
   LET g_bgjob 	= ARG_VAL(4)
   LET g_prtway	= ARG_VAL(5)
   LET g_copies	= ARG_VAL(6)
   LET tm.wc	= ARG_VAL(7)
   LET tm.j	= ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r840_tm()	        	# Input print condition
      ELSE CALL aimr840()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r840_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 30
   ELSE
       LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW r840_w AT p_row,p_col
        WITH FORM "aim/42f/aimr840"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.j		=	'N'				
   LET tm.more	=	'N'
   LET g_pdate 	= g_today
   LET g_rlang 	= g_lang
   LET g_bgjob 	= 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.j,
				 tm.more WITHOUT DEFAULTS
 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD j
         IF cl_null(tm.j) OR tm.j NOT MATCHES "[YN]"
            THEN NEXT FIELD j
         END IF
 
      AFTER FIELD more
         IF cl_null(tm.more) OR tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
	AFTER INPUT
 
	IF INT_FLAG THEN EXIT INPUT END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW r840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr840'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('aimr840','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.j CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr840',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r840_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr840()
   ERROR ""
END WHILE
   CLOSE WINDOW r840_w
END FUNCTION
 
FUNCTION aimr840()
   DEFINE l_name     LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05     LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_ds_flag  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_class    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr         RECORD
                     ds_fg     LIKE type_file.num5,     # 1:需求 2:供給  #No.FUN-690026 SMALLINT
                     class     LIKE type_file.num5,     #類別  #No.FUN-690026 SMALLINT
                     ima01     LIKE rpc_file.rpc01,     #異動料件編號
                     ds_date   LIKE rpc_file.rpc12,     #需求/供給日期
                     rpc02     LIKE rpc_file.rpc02,     #單號
                     cust      LIKE pmm_file.pmm09,     #FUN-660078
                     qty       LIKE rpc_file.rpc13,
                     pmc01     LIKE pmc_file.pmc01      #客戶/供應商NO #FUN-510017
                     END RECORD
 
   #MOD-720046 By TSD.Jin--start
   DEFINE l_t1       LIKE ima_file.ima01,
          l_t2       LIKE ima_file.ima02,
          l_t3       LIKE ima_file.ima25,
#         l_t4       LIKE ima_file.ima26,   #FUN-A20044
          l_t4       LIKE type_file.num15_3,#FUN-A20044  
          l_t5       LIKE ima_file.ima021 
         ,l_avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
          l_unavl_stk      LIKE type_file.num15_3,   #FUN-A20044
          l_avl_stk        LIKE type_file.num15_3    #FUN-A20044 

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #MOD-720046 By TSD.Jin--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
#選出所有符合之料號供REPORT HEADER 列印
     LET l_sql = "SELECT '','',ima01,'','','','' ",
                 " FROM ima_file ",
#                " WHERE ima26 >0 AND ",tm.wc CLIPPED    #FUN-A20044
                 " WHERE ",tm.wc CLIPPED                 #FUN-A20044
     PREPARE r840_prepare6 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_ima:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_curs6 CURSOR FOR r840_prepare6
#---------CHI-A40038----mark
#獨立需求
#    LET l_sql = "SELECT '','',ima01,rpc12,rpc02,'',rpc13-rpc131 ",
#                " FROM rpc_file,ima_file ",
#                " WHERE rpc01 = ima01 AND (rpc13-rpc131) > 0",
#                " AND ",tm.wc CLIPPED
#    PREPARE r840_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare_ima2:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#       EXIT PROGRAM
#          
#    END IF
#    DECLARE r840_curs1 CURSOR FOR r840_prepare1
#--------CHI-A40038------end
#銷單需求
#    LET l_sql= "SELECT '','',ima01,oeb16,oeb01,oeb05_fac,",     #CHI-A40038
#               " oeb12-oeb24+oeb25-oeb26",                      #CHI-A40038
     LET l_sql= "SELECT '','',ima01,oeb16,oeb01,oea03,", #CHI-A40038
                " (oeb12-oeb24+oeb25-oeb26)*oeb05_fac",  #CHI-A40038
                " FROM oeb_file,oea_file,ima_file ",
                " WHERE oeb01=oea01",
                "   AND oeaconf='Y'",
        #-----CHI-A40038 add
                "   AND oea00 <> '0' ",
                "   AND oeb70 = 'N' ",
        #-----CHI-A40038 end
                "   AND ima01=oeb04",
                "   AND (oeb12-oeb24+oeb25-oeb26)>0",
                "   AND ",tm.wc CLIPPED
     PREPARE r840_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_eob:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_curs2 CURSOR FOR r840_prepare2
 
    #-->IQC 在驗量
   #LET l_sql=" SELECT '','',rvb05,rva06,rva01,pmc03,(rvb07-rvb29-rvb30)*pmn09,rva05 ", #FUN-510017 add rva05  #MOD-A70127 mark
    LET l_sql=" SELECT '','',rvb05,rva06,rva01,pmc03,rvb31*pmn09,rva05 ", #FUN-510017 add rva05                #MOD-A70127
              "   FROM rvb_file, rva_file, ima_file, OUTER pmc_file, pmn_file",
              "  WHERE rvb05 = ima01 AND rvb01 = rva01 AND rva_file.rva05 = pmc_file.pmc01",
              "    AND rvb04 = pmn01 AND rvb03 = pmn02",
             #"    AND rvb07 > (rvb29+rvb30) AND rvaconf='Y'",  #MOD-A70127 mark
              "    AND rvb31 > 0 AND rvaconf='Y'",              #MOD-A70127 
              "    AND rva10 != 'SUB'",                         #MOD-A70127 add
              "    AND ",tm.wc CLIPPED
     PREPARE r840_preparex1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_iqc:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_cursx1 CURSOR FOR r840_preparex1
 
    #-->FQC 在驗量
    LET l_sql=" SELECT '','',sfb05,sfb81,sfb01,gem02,sfb11,sfb82 ", #FUN-510017 add sfb82
              "   FROM sfb_file, ima_file, OUTER gem_file ",
              "  WHERE sfb05 = ima01",
              "    AND sfb02 <> '7' AND sfb02 <> '8' AND sfb87!='X' ",  #MOD-A70127 add sfb02<>'8'
              "    AND sfb02 <> '11' ",    #MOD-AA0069 add
              "    AND sfb04 <'8' AND sfb_file.sfb82=gem_file.gem01",
              "    AND sfb11 > 0 ",                 #CHI-A40038   add
              "    AND ",tm.wc CLIPPED
     PREPARE r840_preparex2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_fqc:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_cursx2 CURSOR FOR r840_preparex2
 
    #str MOD-A70127 add
     #-->委外IQC在製量
     LET l_sql=" SELECT '','',rvb05,rva06,rva01,pmc03,rvb31*pmn09,rva05 ",
               "   FROM rvb_file, rva_file, ima_file, OUTER pmc_file, pmn_file",
               "  WHERE rvb05 = ima01 AND rvb01 = rva01 AND rva05 = pmc_file.pmc01",
               "    AND rvb04 = pmn01 AND rvb03 = pmn02",
               "    AND rvb31 > 0 AND rvaconf='Y'",
               "    AND rva10 = 'SUB'",
               "    AND pmn43 = 0",
               "    AND ",tm.wc CLIPPED 
     PREPARE r840_preparex3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_sub_iqc:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r840_cursx3 CURSOR FOR r840_preparex3
    #end MOD-A70127 add

#備料需求
#    LET l_sql= "SELECT '','',ima01,sfb13,sfa01,'',sfa05-sfa06-sfa065-sfa061 ",                 #CHI-A40038
     LET l_sql= "SELECT '','',ima01,sfb13,sfa01,'',(sfa05-sfa06-sfa065+sfa063-sfa062)*sfa13 ",  #CHI-A40038
                " FROM sfa_file,sfb_file,ima_file ",
              # " WHERE sfa01 = sfb01 AND sfb04 NOT MATCHES '678' ",
              #No.B645 010713 by linda mod
   #--------CHI-A40038   modify
           #    " WHERE sfa01 = sfb01 AND sfb04 NOT IN ('6','7','8') ",
           #    " AND ima01 = sfa03 AND (sfa05-sfa06-sfa061-sfa065)>0 ",
                " WHERE sfa01 = sfb01 AND sfb04 !='8' ",
                " AND ima01 = sfa03 ",
                " AND sfa05 > 0 ",
                " AND sfa05 > (sfa06+sfa065) ",	
   #--------CHI-A40038   end
                " AND sfb87 !='X' AND ",tm.wc CLIPPED
     PREPARE r840_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare_sfb:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_curs3 CURSOR FOR r840_prepare3
#工單生產供給
 #   LET l_sql= "SELECT '','',ima01,sfb15,sfb01,'',sfb08-sfb09 ",                              #CHI-A40038
     LET l_sql= "SELECT '','',ima01,sfb15,sfb01,'',(sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac ",#CHI-A40038
                " FROM sfb_file,ima_file ",
              # " WHERE sfb04 NOT MATCHES '678' ",
              #No.B645 010713 by linda mod
#-----------CHI-A40038   modify
             #  " WHERE sfb04 NOT IN ('6','7','8') AND sfb87!='X' ",
             #  " AND ima01 = sfb05 AND (sfb08-sfb09)>0 ",
                " WHERE sfb04 != '8' AND sfb87!='X' ",   
                " AND ima01 = sfb05 AND (sfb08-sfb09-sfb10-sfb11-sfb12)>0 ",  
                " AND (sfb02 != '11' AND sfb02 != '15') ",
#-----------CHI-A40038    end
#               " AND sfb01 NOT IN ",                               #CHI-A40038 ---mark
#               "(SELECT pmm01 FROM pmm_file WHERE pmm01=sfb01",    #CHI-A40038  ---mark
#               " AND pmm18 !='X') ",    #CHI-A40038   ---mark
                " AND ",tm.wc CLIPPED
     PREPARE r840_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_curs4 CURSOR FOR r840_prepare4
#採購供給
   # LET l_sql=  "SELECT '','',ima01,pmn33,pmn01,pmm09,pmn20-pmn50-pmn58 ",
    #LET l_sql=  "SELECT '','',ima01,pmn33,pmn01,pmc03,pmn20-pmn50,pmm09 ", #NO.+032 #FUN-510017 add pmc03         #MOD-640470 mark
    #LET l_sql=  "SELECT '','',ima01,pmn33,pmn01,pmc03,pmn20-pmn50+pmn55,pmm09 ", #NO.+032 #FUN-510017 add pmc03   #MOD-640470   #MOD-8B0117 mark
    #LET l_sql=  "SELECT '','',ima01,pmn35,pmn01,pmc03,pmn20-pmn50+pmn55,pmm09 ", #NO.+032 #FUN-510017 add pmc03   #MOD-640470   #MOD-8B0117  #FUN-940083 MARK
#-------------------CHI-A40038  modify
    # LET l_sql=  "SELECT '','',ima01,pmn35,pmn01,pmc03,pmn20-pmn50+pmn55+pmn58,pmm09 ", #FUN-940083 ADD 
     LET l_sql=  "SELECT '','',ima01,pmn35,pmn01,pmc03,(pmn20-pmn50+pmn55)*pmn09,pmm09 ", 
#-------------------CHI-A40038  end
                 " FROM pmn_file,pmm_file,ima_file ",
                 " ,OUTER pmc_file ", #FUn-510017
                 " WHERE pmn01=pmm01 ",
                #" AND pmn16 MATCHES '[12]' ",   #MOD-8B0104 mark
               # " AND ima01 = pmn04 AND (pmn20-pmn50-pmn58)>0 ",
                #" AND ima01 = pmn04 AND (pmn20-pmn50)>0 ", #No.+032   #MOD-640470 mark
                #" AND ima01 = pmn04 AND (pmn20-pmn50+pmn55)>0 ",      #MOD-640470  #FUN-940083 MARK
                 " AND ima01 = pmn04 AND (pmn20-pmn50+pmn55+pmn58)>0 ", #FUN-940083 ADD   
                 " AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W') ",  #MOD-8B0104 add
                 " AND pmn011 !='SUB' AND pmm18 != 'X'",                         #MOD-8B0104 add
                 " AND ",tm.wc CLIPPED,
                 " AND pmm_file.pmm09=pmc_file.pmc01 " #FUN-510017
     PREPARE r840_prepare5 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r840_curs5 CURSOR FOR r840_prepare5
 
    #FUN-8A0045--BEGIN-- 
    #-->請購量
    LET l_sql=" SELECT '','',pml04,pml35,pml01,pmc03,(pml20-pml21)*pml09,pmk09 ", 
              "   FROM pml_file, pmk_file,ima_file, OUTER pmc_file ",
              "  WHERE pml04 = ima01 AND pml01=pmk01 AND pmk_file.pmk09 = pmc_file.pmc01", 
              "    AND pml20 > pml21 AND (pml16<= '2'OR pml16= 'S' OR pml16='R' OR pml16='W') ",
              "    AND pml011 != 'SUB' AND pmk18 != 'X'",
              "    AND ",tm.wc CLIPPED
     PREPARE r840_prepare7 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare7:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
 
     END IF
     DECLARE r840_curs7 CURSOR FOR r840_prepare7 
    #FUN-8A0045--END--
    #MOD-720046 By TSD.Jin--start mark
    #CALL cl_outnam('aimr840') RETURNING l_name
    #START REPORT r840_rep TO l_name
    #MOD-720046 By TSD.Jin--end mark
 
     LET g_pageno = 0
     FOREACH r840_curs6 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-A20044 --start---
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
       IF l_avl_stk_mpsmrp <= 0 THEN 
          CONTINUE FOREACH
       END IF 
#No.FUN-A20044 --end ---
       LET sr.class = 0
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
#      SELECT ima01,ima02,ima25,ima26,ima021               #FUN-A20044 
       SELECT ima01,ima02,ima25,' ',ima021                 #FUN-A20044
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
#------CHI-A40038------add
       IF cl_null(l_t1) THEN LET l_t1 = 0 END IF
       IF cl_null(l_t2) THEN LET l_t2 = 0 END IF
       IF cl_null(l_t3) THEN LET l_t3 = 0 END IF
       IF cl_null(l_t4) THEN LET l_t4 = 0 END IF
       IF cl_null(l_t5) THEN LET l_t5 = 0 END IF
#------CHI-A40038------end
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044 
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end
     END FOREACH
#-------CHI-A40038-------mark
#    FOREACH r840_curs1 INTO sr.*
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#      END IF
#      LET sr.ds_fg=1
#      LET sr.class=1
#     #MOD-720046 By TSD.Jin--start
#     #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
#      LET l_t1 = NULL
#      LET l_t2 = NULL
#      LET l_t3 = NULL
#      LET l_t4 = NULL
#      LET l_t5 = NULL
#      LET sr.qty = -sr.qty
##     SELECT ima01,ima02,ima25,ima26,ima021      #FUN-A20044
#      SELECT ima01,ima02,ima25,' ',ima021        #FUN-A20044     
#        INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
#        FROM ima_file
#       WHERE ima_file.ima01 = sr.ima01
#      CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
#      LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044

 
#      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
#      EXECUTE insert_prep USING
#         sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
#         sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
#         l_t3,l_t4,l_t5,g_azi03,g_azi04,
#         g_azi05 
#     #MOD-720046 By TSD.Jin--end
#    END FOREACH
#-------CHI-A40038-------end
     FOREACH r840_curs2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
		LET sr.ds_fg=1
		LET sr.class=2
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
       LET sr.qty = -sr.qty
#      SELECT ima01,ima02,ima25,ima26,ima021            #FUN-A20044
       SELECT ima01,ima02,ima25,' ',ima021              #FUN-A20044
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
      CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
      LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044

 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end 
     END FOREACH
     FOREACH r840_cursx1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
		LET sr.ds_fg=0
		LET sr.class=6
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
#      SELECT ima01,ima02,ima25,ima26,ima021               #FUN-A20044
       SELECT ima01,ima02,ima25,' ',ima021                 #FUN-A20044 
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end
     END FOREACH
     FOREACH r840_cursx2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
		LET sr.ds_fg=0
		LET sr.class=7
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
 #     SELECT ima01,ima02,ima25,ima26,ima021             #FUN-A20044
       SELECT ima01,ima02,ima25,' ',ima021               #FUN-A20044
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044

 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end
     END FOREACH
    #str MOD-A70127 add
     FOREACH r840_cursx3 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        LET sr.ds_fg=0
        LET sr.class=9
        LET l_t1 = NULL
        LET l_t2 = NULL
        LET l_t3 = NULL
        LET l_t4 = NULL
        LET l_t5 = NULL
        SELECT ima01,ima02,ima25,ima26,ima021
          INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
          FROM ima_file
         WHERE ima_file.ima01 = sr.ima01

        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
        EXECUTE insert_prep USING
           sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
           sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
           l_t3,l_t4,l_t5,g_azi03,g_azi04,
           g_azi05 
     END FOREACH
    #end MOD-A70127 add
     FOREACH r840_curs3 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.ds_fg=1
       LET sr.class=3
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
       LET sr.qty = -sr.qty
 #     SELECT ima01,ima02,ima25,ima26,ima021            #FUN-A20044
       SELECT ima01,ima02,ima25,' ',ima021              #FUN-A20044 
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044

 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end
     END FOREACH
     FOREACH r840_curs4 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.ds_fg=0
       LET sr.class=4
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
#      SELECT ima01,ima02,ima25,ima26,ima021               #FUN-A20044
       SELECT ima01,ima02,ima25,' ',ima021                 #FUN-A20044
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
        CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044

 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end
     END FOREACH
     FOREACH r840_curs5 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.ds_fg=0
       LET sr.class=5
      #MOD-720046 By TSD.Jin--start
      #OUTPUT TO REPORT r840_rep(sr.*) #MOD-720046 By TSD.Jin mark
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
#      SELECT ima01,ima02,ima25,ima26,ima021         #FUN-A20044
       SELECT ima01,ima02,ima25,' ',ima021        #FUN-A20044
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044 

       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02,
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2, 
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05 
      #MOD-720046 By TSD.Jin--end
     END FOREACH
 
    #FUN-8A0045--BEGIN-- 
     FOREACH r840_curs7 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET sr.ds_fg=0
       LET sr.class=8
       LET l_t1 = NULL
       LET l_t2 = NULL
       LET l_t3 = NULL
       LET l_t4 = NULL
       LET l_t5 = NULL
#      SELECT ima01,ima02,ima25,ima26,ima021    #FUN-A20044
       SELECT ima01,ima02,ima25, ' ',ima021     #FUN-A20044
         INTO l_t1,l_t2,l_t3,l_t4,l_t5    #t1=料號,t2=品名,t3=單位,t4=庫存
         FROM ima_file
        WHERE ima_file.ima01 = sr.ima01
       CALL s_getstock(sr.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       LET l_t4 = l_avl_stk_mpsmrp           #FUN-A20044
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.ds_fg,sr.class,sr.ima01,sr.ds_date,sr.rpc02, 
          sr.cust,sr.qty,sr.pmc01,l_t1,l_t2,
          l_t3,l_t4,l_t5,g_azi03,g_azi04,
          g_azi05
     END FOREACH
     #FUN-8A0045--END--
    #MOD-720046 By TSD.Jin--start
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
 
     LET g_str = g_str,";",tm.j
 
     CALL cl_prt_cs3('aimr840','aimr840',l_sql,g_str)   #FUN-710080 modify
 
    #FINISH REPORT r840_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #MOD-720046 By TSD.Jin--end  
END FUNCTION
 
#MOD-720046 By TSD.Jin--start mark
#REPORT r840_rep(sr)
#DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_buf       LIKE zaa_file.zaa08,    #No.FUN-690026 VARCHAR(10)
#       sr          RECORD
#                   ds_fg    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#                   class    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#                   ima01    LIKE rpc_file.rpc01,     
#                   ds_date  LIKE rpc_file.rpc12,    #
#                   rpc02    LIKE rpc_file.rpc02,    #異動料件編號
#                   cust     LIKE pmm_file.pmm09,     
#                   qty      LIKE rpc_file.rpc13,
#                   pmc01    LIKE pmc_file.pmc01     #客戶/供應商NO #FUN-510017
#                   END RECORD ,
#      t1           LIKE ima_file.ima01,
#      t2           LIKE ima_file.ima02,
#      t3           LIKE ima_file.ima25,
#      t4           LIKE ima_file.ima26,
#      t5           LIKE ima_file.ima021,
#      l_col        LIKE type_file.num5    #No.FUN-690026 SMALLINT
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# 
#  ORDER BY sr.ima01,sr.ds_date
# 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32]
#      PRINTX name=H2 g_x[33],g_x[34],g_x[35]
#      PRINTX name=H3 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.ima01
#       IF tm.j='Y' THEN
#           SKIP TO TOP OF PAGE
#       END IF
#       SELECT ima01,ima02,ima25,ima26,ima021
#         INTO t1,t2,t3,t4,t5              #t1=料號,t2=品名,t3=單位,t4=庫存
#         FROM ima_file
#        WHERE ima_file.ima01 = sr.ima01
#      #NEED 2 LINES
#       PRINTX name = D1 COLUMN g_c[31],t1,
#                        COLUMN g_c[32],t2
#       PRINTX name = D2 COLUMN g_c[33],cl_numfor(t4,33,3),
#                        COLUMN g_c[34],t3,
#                        COLUMN g_c[35],t5
#   BEFORE GROUP OF sr.ds_date
#       IF sr.class != 0 THEN
#          PRINTX name=D3 COLUMN g_c[36],' ',
#                         COLUMN g_c[37],sr.ds_date;
#       END IF
#   ON EVERY ROW
#        IF sr.class != 0 THEN 	#本 IF 在避免類別0之料件在ON EVERY ROW被印出,因
#        		       #類別0 僅供列印HEAD中的料件資料,裡面並無供需資料
#           IF sr.ds_fg = 1 THEN LET sr.qty = -sr.qty  END IF
#           LET t4 = t4 + sr.qty
#           CASE
#                 when sr.class =1 LET l_buf = g_x[17]
#                 when sr.class =2 LET l_buf = g_x[18]
#                 when sr.class =3 LET l_buf = g_x[19]
#                 when sr.class =4 LET l_buf = g_x[20]
#                 when sr.class =5 LET l_buf = g_x[21]
#                  #MOD-550084  --begin
#                 when sr.class =6 LET l_buf = g_x[22]
#                 when sr.class =7 LET l_buf = g_x[23]
#                  #MOD-550084  --end
#           END CASE
#           PRINTX name=D3 COLUMN g_c[38],l_buf CLIPPED,
#                          COLUMN g_c[39],sr.rpc02,
#                          COLUMN g_c[40],sr.pmc01,
#                          COLUMN g_c[41],sr.cust,
#                          COLUMN g_c[42],cl_numfor(sr.qty,42,3),
#                          COLUMN g_c[43],cl_numfor(t4,43,3)
#        END IF						# class IF END
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'ima01')
#              RETURNING tm.wc
#         LET tm.wc= tm.wc CLIPPED
#         PRINT g_dash
##TQC-630166
##        IF tm.wc[001,66] > ' ' THEN            # for 132
##               PRINT g_x[8] CLIPPED,tm.wc[001,132] CLIPPED END IF
##        IF tm.wc[066,132] > ' ' THEN            # for 132
##        PRINT g_x[8] CLIPPED,tm.wc[066,132] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINES
#      END IF
#END REPORT
#MOD-720046 By TSD.Jin--end mark
