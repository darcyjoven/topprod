# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name ..:apmr230.4gl
# Descriptions...: 料件�供應商單價查詢列印
# Input parameter:
# Date & Author..: 91/10/29 By May
# MODIFY.........: 92/10/16 By Apple
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號,廠商編號開窗
# Modify.........: No.FUN-550117 05/05/27 By Danny 採購含稅單價
# Modify.........: No.FUN-550060 05/05/31 By yoyo單據編號格式放大
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.MOD-5A0120 05/10/14 By ice 料號/品名/規格欄位放大
# Modify.........: No.FUN-610018 06/01/10 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-670066 06/07/21 By yjkhero 由voucher報表為轉template1型報表
# Modify.........: No.FUN-650191 06/08/14 By rainy pmw03改抓pmx12
# Modify.........: No.FUN-680136 06/09/15 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-7A0041 07/10/09 By claire 同張單據的同料號,第二筆廠商資料沒有印出來
# Modify.........: No.FUN-840021 08/04/08 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8B0018 08/12/08 By xiaofeizhu 新增選項"價格型態(1.一般，2.委外)"
# Modify.........: No.TQC-8C0029 08/12/08 By xiaofeizhu apmr230有勾選"依料號跳頁"，但報表沒有依料號跳頁
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
         # 		wc   VARCHAR(500),		# Where condition
          		wc  	STRING,		#TQC-630166 # Where condition
   	          	a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1) # Input more condition(Y/N)
   	          	type    LIKE type_file.chr2,    #No.CHI-8B0018
        		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)	# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   l_table         STRING,                  ### FUN-840021 ###                                                                  
         g_str           STRING,                  ### FUN-840021 ###
         g_sql           STRING                   ### FUN-840021 ###
 
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
 
### *** FUN-840021 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "pmw01.pmw_file.pmw01,",
                "pmx12.pmx_file.pmx12,",
                "pmc03.pmc_file.pmc03,",
                "pmw04.pmw_file.pmw04,",
                "azi03.azi_file.azi03,",
                "pmw06.pmw_file.pmw06,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "ima05.ima_file.ima05,",
                "ima08.ima_file.ima08,",
                "ima44.ima_file.ima44,",
                "pmx02.pmx_file.pmx02,",
                "pmx03.pmx_file.pmx03,",
                "pmx04.pmx_file.pmx04,",
                "pmx05.pmx_file.pmx05,",
                "pmx06.pmx_file.pmx06,",
                "pmx07.pmx_file.pmx07,",
                "pmx08.pmx_file.pmx08,",
                "pmx09.pmx_file.pmx09,",
                "pmw05.pmw_file.pmw05,",
                "pmw051.pmw_file.pmw051,",
                "pmx06t.pmx_file.pmx06t,",
                "pmx10.pmx_file.pmx10 "       #CHI-8B0018
    LET l_table = cl_prt_temptable('apmr230',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,        
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                                           
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                  #CHI-8B0018 Add ?                                                                                         
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(13)     #No.CHI-8B0018
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r230_tm(0,0)		        # Input print condition
      ELSE CALL apmr230()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r230_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW r230_w AT p_row,p_col WITH FORM "apm/42f/apmr230"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.a    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
 # LET g_prtway= "Q"
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type = '1'                   #CHI-8B0018
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmx08,pmx12,pmw01,pmx04  #FUN-650191 pmw03->pmx12
     #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
       CASE WHEN INFIELD(pmx08)      #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ima1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmx08
                 NEXT FIELD pmx08
             WHEN INFIELD(pmx12)      #廠商編號  #FUN-650191 pmw03->pmx12
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmx12   #FUN-650191 pmw03->pmx12
                 NEXT FIELD pmx12    #FUN-650191 pmw03->pmx12
 
       OTHERWISE EXIT CASE
       END CASE
     #--END---------------
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
      LET INT_FLAG = 0 CLOSE WINDOW r230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.a,tm.type,tm.more                    #CHI-8B0018 Add tm.type
   INPUT BY NAME tm.a,tm.type,tm.more WITHOUT DEFAULTS     #CHI-8B0018 Add tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[yYnN]"
            THEN NEXT FIELD a
         END IF
         
      #CHI-8B0018--Begin--#   
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12]' THEN
            NEXT FIELD type
         END IF
      #CHI-8B0018--End--#         
         
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW r230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr230'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr230','9031',1)
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
                         " '",tm.a  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'"               #No.CHI-8B0018
         CALL cl_cmdat('apmr230',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r230_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr230()
   ERROR ""
END WHILE
   CLOSE WINDOW r230_w
END FUNCTION
 
FUNCTION apmr230()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE za_file.za05              #No.FUN-680136 VARCHAR(40)
   DEFINE l_pmx10	LIKE pmx_file.pmx10,      #CHI-8B0018       
          sr              RECORD
                                  pmw01  LIKE pmw_file.pmw01,    #採購單號
                                 #pmw03  LIKE pmw_file.pmw03,    #供應商編號 #FUN-650191 remark
                                  pmx12  LIKE pmx_file.pmx12,    #供應商編號 #FUN-650191
                                  pmc03  LIKE pmc_file.pmc03,    #供應商簡稱
                                  pmw04  LIKE pmw_file.pmw04,    #交易幣別
                                  azi03  LIKE azi_file.azi03,
                                  azi04  LIKE azi_file.azi04,
                                  azi05  LIKE azi_file.azi05,
                                  pmw06  LIKE pmw_file.pmw06,    #詢價日期
                                  ima02  LIKE ima_file.ima02,    #品名
                                  ima021 LIKE ima_file.ima021,   #規格 #FUN-4C0095
                                  ima05  LIKE ima_file.ima05,    #版本
                                  ima08  LIKE ima_file.ima08,    #來源
                                  ima44  LIKE ima_file.ima44,    #採購單位
                                  pmx02  LIKE pmx_file.pmx02,    #項次
                                  pmx03  LIKE pmx_file.pmx03,    #下限數量
                                  pmx04  LIKE pmx_file.pmx04,    #生效日
                                  pmx05  LIKE pmx_file.pmx05,    #失效日
                                  pmx06  LIKE pmx_file.pmx06,    #採購單價
                                  pmx07  LIKE pmx_file.pmx07,    #折扣比例
                                  pmx08  LIKE pmx_file.pmx08,    #料件編號
                                  pmx09  LIKE pmx_file.pmx09,    #詢價單位
                                  #No.FUN-550117
                                  pmw05       LIKE pmw_file.pmw05,   #稅別
                                  pmw051      LIKE pmw_file.pmw051,  #稅率
                                  pmx06t      LIKE pmx_file.pmx06t,  #含稅單價
                                  gec07       LIKE gec_file.gec07    #含稅否
                                  #end No.FUN-550117
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang    
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-840021 *** ##                                                      
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-840021                                   
   #------------------------------ CR (2) ------------------------------#
 
# NO.FUN-670066 BEGIN--------------------------------------------- 
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr230'  #No.FUN-670066
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF               
#    LET g_len = 80       #No.FUN-550060
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
#NO,FUN-670066  END------------------------------------------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmwuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pmwgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pmwgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmwuser', 'pmwgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT ",
                 " pmw01,pmx12,pmc03,pmw04,azi03,azi04,azi05,pmw06,",  #FUN-650191 pmw03->pmx12
                 " ima02,ima021,ima05,ima08,ima44,pmx02,pmx03,",
                 "  pmx04,pmx05,pmx06,pmx07,pmx08,pmx09,",
                 #No.FUN-550117
                 "  pmw05,pmw051,pmx06t,gec07,pmx10 ",                 #CHI-8B0018 Add pmx10
                 " FROM pmw_file,OUTER pmc_file, OUTER azi_file, ",
                 " pmx_file,ima_file, OUTER gec_file",
                 " WHERE pmx_file.pmx12 = pmc_file.pmc01 AND pmw_file.pmw04 = azi_file.azi01 AND ",        #FUN-650191 pmw03->pmx12
                 " pmw01=pmx01 AND pmx08 = ima01 AND pmwacti='Y' AND ",
#                " pmx10=' ' AND ",                                    #CHI-860042      #CHI-8B0018 Mark                                                
#                " pmx11='1' AND ",                                    #CHI-860042      #CHI-8B0018 Mark
                 tm.wc CLIPPED," AND pmw_file.pmw05 = gec_file.gec01 "
                 #end No.FUN-550117
                 
      #CHI-8B0018--Begin--#
       IF tm.type = '1' THEN
             LET l_sql =l_sql  CLIPPED,
                  "   AND pmx11 = '1' "
       ELSE
             LET l_sql =l_sql  CLIPPED,
                  "   AND pmx11 = '2' "                  
       END IF      
      #CHI-8B0018--End--#                 
                 
     PREPARE r230_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r230_cs  CURSOR FOR r230_prepare
#    CALL cl_outnam('apmr230') RETURNING l_name                                    #FUN-840021 mark
#    START REPORT r230_rep TO l_name                                               #FUN-840021 mark
     FOREACH r230_cs INTO sr.*,l_pmx10                                             #CHI-8B0018 Add l_pmx10
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.pmx08  IS NULL THEN LET sr.pmx08 = ' ' END IF
#No.FUN-610018       #No.FUN-550117
#      IF sr.gec07 = 'Y' THEN      #No.FUN-560102
#         LET sr.pmx06 = sr.pmx06t
#      END IF
       #end No.FUN-550117
#      OUTPUT TO REPORT r230_rep(sr.*)                                              #FUN-840021 mark
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840021 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 sr.pmw01,sr.pmx12,sr.pmc03,sr.pmw04,sr.azi03,sr.pmw06,sr.ima02,
                 sr.ima021,sr.ima05,sr.ima08,sr.ima44,sr.pmx02,sr.pmx03,sr.pmx04,
                 sr.pmx05,sr.pmx06,sr.pmx07,sr.pmx08,sr.pmx09,sr.pmw05,sr.pmw051,
                 sr.pmx06t,l_pmx10                                                  #CHI-8B0018 Add l_pmx10
     #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#    FINISH REPORT r230_rep                                                         #FUN-840021 mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                    #FUN-840021 mark
 
#No.FUN-840021--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'pmx08,pmx12,pmw01,pmx04')                         
              RETURNING tm.wc                                                                                                        
      END IF                                                                                                                        
#No.FUN-840021--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-840021 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.a                                           #TQC-8C0029 Add tm.a
    IF tm.type = '1' THEN                                                #CHI-8B0018
       LET l_name = 'apmr230'                                            #CHI-8B0018
    ELSE                                                                 #CHI-8B0018
       LET l_name = 'apmr230_1'                                          #CHI-8B0018
    END IF	                                                             #CHI-8B0018
#   CALL cl_prt_cs3('apmr230','apmr230',g_sql,g_str)                     #CHI-8B0018 Mark
    CALL cl_prt_cs3('apmr230',l_name,g_sql,g_str)                        #CHI-8B0018                                                                                    
    #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
#NO.FUN-840021 -Mark--Begin--#
#REPORT r230_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         l_str         LIKE type_file.chr50,   #No.FUN-680136 VARCHAR(30)
#         l_sw1         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         sr              RECORD
#                                 pmw01  LIKE pmw_file.pmw01,    #採購單號
#                                #pmw03  LIKE pmw_file.pmw03,    #供應商編號  #FUN-650191 remark
#                                 pmx12  LIKE pmx_file.pmx12,    #供應商編號  #FUN-650191 
#                                 pmc03  LIKE pmc_file.pmc03,    #廠商簡稱
#                                 pmw04  LIKE pmw_file.pmw04,    #交易幣別
#                                 azi03  LIKE azi_file.azi03,
#                                 azi04  LIKE azi_file.azi04,
#                                 azi05  LIKE azi_file.azi05,
#                                 pmw06  LIKE pmw_file.pmw06,    #詢價日期
#                                 ima02  LIKE ima_file.ima02,    #品名規格
#                                 ima021 LIKE ima_file.ima021,   #規格 #FUN-4C0095
#                                 ima05  LIKE ima_file.ima05,    #版本
#                                 ima08  LIKE ima_file.ima08,    #來源
#                                 ima44  LIKE ima_file.ima44,    #採購單位
#                                 pmx02  LIKE pmx_file.pmx02,    #項次
#                                 pmx03  LIKE pmx_file.pmx03,    #上限數量
#                                 pmx04  LIKE pmx_file.pmx04,    #生效日
#                                 pmx05  LIKE pmx_file.pmx05,    #失效日
#                                 pmx06  LIKE pmx_file.pmx06,    #採購單價
#                                 pmx07  LIKE pmx_file.pmx07,    #折扣比例
#                                 pmx08  LIKE pmx_file.pmx08,    #料件編號
#                                 pmx09  LIKE pmx_file.pmx09,    #詢價單位
#                                 #No.FUN-550117
#                                 pmw05       LIKE pmw_file.pmw05,   #稅別
#                                 pmw051      LIKE pmw_file.pmw051,  #稅率
#                                 pmx06t      LIKE pmx_file.pmx06t,  #含稅單價
#                                 gec07       LIKE gec_file.gec07    #含稅否
#                                 #end No.FUN-550117
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pmx08,sr.pmw01
#  FORMAT
#  PAGE HEADER
#No.FUN-670066 -----begin
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT COLUMN((g_len-FGL_WIDTH(g_company))/2)+1,g_company        
#      IF g_towhom IS NULL OR g_towhom = ' '            
#        THEN PRINT ''                                  
#      ELSE PRINT 'TO:',g_towhom;                       
#      END IF                                           
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED 
#      LET  g_pageno=g_pageno+1
#      LET  pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head  CLIPPED , pageno_total               
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  
#      PRINT ' '
#       LET g_pageno = g_pageno + 1                             
#       PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,                 
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'   
#   PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
#No.FUN-670066 ----end
#BEFORE GROUP  OF sr.pmx08  #料件編號                                                                 
#     IF tm.a= 'Y'
#        AND (PAGENO > 1 OR LINENO > 7)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#     PRINT COLUMN 01,g_x[11] clipped,sr.pmx08,
#           COLUMN 46,g_x[17] clipped,sr.ima05,'  ',
#           COLUMN 50,g_x[17] clipped,sr.ima05,'  ',  #No.MOD-5A0120
#                     g_x[18] clipped,sr.ima08,'  ',
#                     g_x[19] clipped,sr.ima44
#     PRINT g_x[12] clipped,sr.ima02
#     PRINT g_x[20] clipped,sr.ima021 #FUN-4C0095
#     PRINT ' '
#No.FUN-670066 ---begin
#BEFORE GROUP  OF sr.pmw01  #單據編號    
#     #No.FUN-550117
#No.FUN_550060 --start--
#      PRINT g_x[13] clipped,                        
#            COLUMN 23,g_x[22] clipped,
#            g_x[14] clipped;          
#      PRINT COLUMN 64,g_x[21] CLIPPED 
#     #end No.FUN-550117
#      PRINTX NAME=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                     g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#                     g_x[45]     
#      PRINT ' '                                                                                                                                                        
#      PRINT COLUMN 03,g_x[15],COLUMN 52,g_x[16] clipped                                                                                                         
#      PRINT COLUMN 03,'---- ---- ------------ ------------ ---------',    
#                       ' ------------- -------- --------'  
#      PRINT g_dash1                                        
#       PRINT g_dash2[1,g_len]                              
 
#BEFORE GROUP  OF sr.pmw01  #單據編號                        
#      PRINT COLUMN 01,sr.pmw03 CLIPPED,              
#            COLUMN 12,sr.pmc03 CLIPPED,
#            COLUMN 23,sr.pmw01 CLIPPED,
#            COLUMN 40,sr.pmw06,
#            COLUMN 52,sr.pmw04 CLIPPED;
#     #MOD-7A0041-begin-modify
#     #No.FUN-550117 FUN-610018
#     #PRINT COLUMN g_c[31],sr.pmx12 CLIPPED,   #FUN-650191 pmw03->pmx12                                                                                            
#     #      COLUMN g_c[32],sr.pmc03 CLIPPED,                                                                                             
#     #      COLUMN g_c[33],sr.pmw01 CLIPPED,                                                                                             
#     PRINTX NAME=D1
#            COLUMN g_c[33],sr.pmw01 CLIPPED,                                                                                             
#     #MOD-7A0041-end-modify
#            COLUMN g_c[34],sr.pmw06 CLIPPED,                                                                                                    
#            COLUMN g_c[35],sr.pmw04 CLIPPED,  
#    PRINT COLUMN 64,sr.pmw05,                  #稅別    
#          COLUMN 74,sr.pmw051 USING '##&','%'  #稅率      
#          COLUMN 76,sr.gec07                                  
#          COLUMN g_c[36],sr.pmw05,                        
#          COLUMN g_c[37],sr.pmw051 USING '###&','%';   #稅率   
#No.FUN-670066-----end                                                   
#No.FUN-550060 --end--          
#     #end No.FUN-550117
#
#ON EVERY ROW              
#     #No.FUN-610018
#No.FUN-670066-----begin---------------
#      PRINT COLUMN 03,sr.pmx02 USING '####',           
#            COLUMN 08,sr.pmx09,
#            COLUMN 13,cl_numfor(sr.pmx06,11,sr.azi03) CLIPPED,
#            COLUMN 26,cl_numfor(sr.pmx06t,11,sr.azi03) CLIPPED,
#            COLUMN 40,sr.pmx07 USING '---&.&&&',
#            COLUMN 48,sr.pmx03 USING '---------&.&&&',
#            COLUMN 63,sr.pmx04,
#            COLUMN 72,sr.pmx05 
#     #MOD-7A0041-begin-add
#     PRINTX NAME=D1
#           COLUMN g_c[31],sr.pmx12 CLIPPED,   #FUN-650191 pmw03->pmx12                                                                                            
#           COLUMN g_c[32],sr.pmc03 CLIPPED,                                                                                             
#           COLUMN g_c[38],sr.pmx02 USING '#####', 
#    #PRINT  COLUMN g_c[38],sr.pmx02 USING '#####', 
#     #MOD-7A0041-end-add
#           COLUMN g_c[39],sr.pmx09,
#           COLUMN g_c[40],cl_numfor(sr.pmx06,40,sr.azi03) CLIPPED,                                                                      
#           COLUMN g_c[41],cl_numfor(sr.pmx06t,41,sr.azi03) CLIPPED,                                                                     
#           COLUMN g_c[42],sr.pmx07 USING '-----&.&&&',                                                                                 
#           COLUMN g_c[43],sr.pmx03 USING '----------&.&&&',                                                                              
#           COLUMN g_c[44],sr.pmx04,                                                                                                     
#           COLUMN g_c[45],sr.pmx05  
#  AFTER  GROUP  OF sr.pmw01  #單據編號               
#      PRINT ' '                                      
# ON LAST ROW
#      IF g_zz05 = 'Y' THEN           # (80)-70,140,210,280   /   (132)-201,240,300        
#No.FUN-670066-------end-----------                                           
#           PRINT g_dash[1,g_len]  CLIPPED
#        #    IF tm.wc[001,70] > ' ' THEN			# for 80
#        #       PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #    IF tm.wc[071,140] > ' ' THEN
#        #       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #    IF tm.wc[141,210] > ' ' THEN
# 	 #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #    IF tm.wc[211,280] > ' ' THEN
# 	 #       PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        #TQC-630166
#      CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]   CLIPPED
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]  CLIPPED	
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-840021 -Mark--End--#
#Patch....NO.TQC-610036 <001,002> #
