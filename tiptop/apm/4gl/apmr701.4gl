# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmr701.4gl
# Descriptions...: 採購驗收清單
# Input parameter:
# Date & Author..: 91/11/05 By Lin
# Modify ........: 93/11/03 By Fiona
# Modify.........: No.FUN-550060 05/05/30 By yoyo單據編號格式放大
# Modify.........: No.FUN-580014 05/08/17 By wujie 憑証類報表轉xml
# Modify.........: No.TQC-630225 06/03/27 By pengu 報表資料的單身抬頭一直重複列印，應該一頁只印一次單身抬頭即可
# Modify.........: No.FUN-640236 06/06/27 By Sarah 增加列印規格ima021
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6B0095 06/11/15 By Ray 報寬度不符的錯
# Modify.........: No.FUN-840054 08/04/13 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.CHI-8B0011 08/12/16 By Smapmin 請購單單號/項次要抓取採購單單身的資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70054 10/08/12 By Summer 增加是否列印已結案採購單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				   # Print condition RECORD
	     #wc   VARCHAR(500),		   # Where condition   #TQC-630166 mark
	      wc  	STRING,	  	           # Where condition   #TQC-630166
              jump	LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)	   # 依採購單號跳頁(Y/N)
              a         LIKE type_file.chr1,       #CHI-A70054 add                 # 是否列印已結案採購單(Y/N)
              more	LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1) 	   # Input more condition(Y/N)
              END RECORD,
          g_sw           LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)          # 判斷是否列印品名規格
#No.FUN-580014--begin
#  DEFINE   g_dash          VARCHAR(400)   #Dash line
   DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose    #No.FUN-680136 SMALLINT
#  DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#  DEFINE   g_pageno        SMALLINT   #Report page no
#  DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580014--begin
   DEFINE   l_table         STRING     #No.FUN-840054                                                                               
   DEFINE   g_sql           STRING     #No.FUN-840054                                                                               
   DEFINE   g_str           STRING     #No.FUN-840054   
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
 
#No.FUN-840054 --BEGIN                                                                                                              
   LET g_sql = "pmm01.pmm_file.pmm01,",   #采購單號                                                                                 
               #"pmm08.pmm_file.pmm08,",   #請購單號       #CHI-8B0011                                                                         
               "pmm12.pmm_file.pmm12,",   #采購員                                                                                   
               "pmm13.pmm_file.pmm13,",   #請購部門                                                                                 
               "pmm14.pmm_file.pmm14,",   #收貨部門                                                                                 
               "pmm15.pmm_file.pmm15,",   #確認人                                                                                   
               "pmm09.pmm_file.pmm09,",   #廠商代號                                                                                 
               "pmc03.pmc_file.pmc03,",   #廠商簡稱                                                                                 
               "pmm22.pmm_file.pmm22,",   #幣別                                                                                     
               "pmm20.pmm_file.pmm20,",   #付款方式                                                                                 
               "pmn02.pmn_file.pmn02,",   #采購單項次                                                                               
               "pmn04.pmn_file.pmn04,",   #料件編號                                                                                 
               "pmn041.pmn_file.pmn041,", #品名規格                                                                                 
               "pmn20.pmn_file.pmn20,",   #訂購量                                                                                   
               "pmn24.pmn_file.pmn24,",   #請購單單號   #CHI-8B0011
               "pmn25.pmn_file.pmn25,",   #請購單項次   #CHI-8B0011
               "pmn41.pmn_file.pmn41,",   #委外工單                                                                                 
               "rva01.rva_file.rva01,",   #驗收單號                                                                                 
               "rvb05.rvb_file.rvb05,",   #料件編號                                                                                 
               "rvb01.rvb_file.rvb01,",   #驗收單號                                                                                 
               "rvb02.rvb_file.rvb02,",   #驗收單項次                                                                               
               "rvb07.rvb_file.rvb07,",   #實收數量                                                                                 
               "rvb11.rvb_file.rvb11,",   #代買項次                                                                                 
               "rvb17.rvb_file.rvb17,",   #檢驗批號                                                                                 
               "rvb19.rvb_file.rvb19,",   #收貨性質         
               "rvb29.rvb_file.rvb29,",   #退貨量                                                                                   
               "rvb30.rvb_file.rvb30,",   #入庫量                                                                                   
               "rvb31.rvb_file.rvb31,",   #可入庫量                                                                                 
               "l_pmm12.pmm_file.pmm12,",                                                                                           
               "l_pmm15.pmm_file.pmm15,",                                                                                           
               "l_pmm13.pmm_file.pmm13,",                                                                                           
               "l_pmm14.pmm_file.pmm14,",                                                                                           
               "l_ima021.ima_file.ima021"                                                                                           
   LET l_table = cl_prt_temptable("apmr701",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                              
               #"        ?,?,?,?,?, ?,?,?,?,?, ? )"   #CHI-8B0011
               "        ?,?,?,?,?, ?,?,?,?,?, ?,? )"   #CHI-8B0011
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-840054 --END                  
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.jump = ARG_VAL(8)
   LET tm.a = ARG_VAL(9) #CHI-A70054 add
   #CHI-A70054 mod +1 --start--
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No:FUN-570264 ---end---
   #CHI-A70054 mod +1 --end--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r701_tm(0,0)		        # Input print condition
      ELSE CALL r701()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r701_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r701_w AT p_row,p_col WITH FORM "apm/42f/apmr701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.jump = 'N'
   LET tm.a = 'N' #CHI-A70054 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm09,pmn24,rva01
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
      LET INT_FLAG = 0 CLOSE WINDOW r701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.jump,tm.a,tm.more  # Condition #CHI-A70054 add a
   INPUT BY NAME tm.jump,tm.a,tm.more WITHOUT DEFAULTS #CHI-A70054 add a
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD jump       # 依採購單號跳頁(Y/N)
         IF tm.jump NOT MATCHES "[YN]" OR tm.jump=' '
            THEN NEXT FIELD jump
         END IF
      #CHI-A70054 add --start--
      AFTER FIELD a       # 是否列印已結案採購單(Y/N)
         IF tm.a NOT MATCHES "[YN]" OR tm.a=' '
            THEN NEXT FIELD a
         END IF
      #CHI-A70054 add --end--
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command epmnecution
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
      LET INT_FLAG = 0 CLOSE WINDOW r701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr701'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr701','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,	#(at time fglgo pmnpmnpmnpmn p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.jump CLIPPED,"'",
                         " '",tm.a CLIPPED,"'", #CHI-A70054 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr701',g_time,l_cmd)	# Epmnecute cmd at later time
      END IF
      CLOSE WINDOW r701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r701()
   ERROR ""
END WHILE
   CLOSE WINDOW r701_w
END FUNCTION
 
FUNCTION r701()
   DEFINE l_name	LIKE type_file.chr20, 		# Epmnternal(Disk) file name           #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job        #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT   #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,		                # RDSQL STATEMENT   #TQC-630166
          l_za05	LIKE type_file.chr1000,         #No.FUN-680136 VARCHAR(40)
          sr    RECORD
                 pmm01  LIKE pmm_file.pmm01, #採購單號
                 #pmm08  LIKE pmm_file.pmm08, #請購單號   #CHI-8B0011
                 pmm12  LIKE pmm_file.pmm12, #採購員
                 pmm13  LIKE pmm_file.pmm13, #請購部門
                 pmm14  LIKE pmm_file.pmm14, #收貨部門
                 pmm15  LIKE pmm_file.pmm15, #確認人
                 pmm09  LIKE pmm_file.pmm09, #廠商代號
                 pmc03  LIKE pmc_file.pmc03, #廠商簡稱
                 pmm22  LIKE pmm_file.pmm22, #幣別
                 pmm20  LIKE pmm_file.pmm20, #付款方式
                 pmn02  LIKE pmn_file.pmn02, #採購單項次
                 pmn04  LIKE pmn_file.pmn04, #料件編號
                 pmn041 LIKE pmn_file.pmn041,#品名規格
                 pmn20  LIKE pmn_file.pmn20, #訂購量
                 pmn24  LIKE pmn_file.pmn24, #請購單單號   #CHI-8B0011
                 pmn25  LIKE pmn_file.pmn25, #請購單項次   #CHI-8B0011
                 pmn41  LIKE pmn_file.pmn41, #委外工單
                 rva01  LIKE rva_file.rva01, #驗收單號
                 rvb05  LIKE rvb_file.rvb05, #料件編號
                 rvb01  LIKE rvb_file.rvb01, #驗收單號
                 rvb02  LIKE rvb_file.rvb02, #驗收單項次
                 rvb07  LIKE rvb_file.rvb07, #實收數量
                 rvb11  LIKE rvb_file.rvb11, #代買項次
                 rvb17  LIKE rvb_file.rvb17, #檢驗批號
                 rvb19  LIKE rvb_file.rvb19, #收貨性質
              #  rvb28  LIKE rvb_file.rvb28, #報廢量
                 rvb29  LIKE rvb_file.rvb29, #退貨量
                 rvb30  LIKE rvb_file.rvb30, #入庫量
                 rvb31  LIKE rvb_file.rvb31  #可入庫量
                END RECORD
#No.FUN-840054  --BEGIN                                                                                                             
     DEFINE l_pmm12  LIKE pmm_file.pmm12                                                                                            
     DEFINE l_pmm15  LIKE pmm_file.pmm15                                                                                            
     DEFINE l_pmm13  LIKE pmm_file.pmm13                                                                                            
     DEFINE l_pmm14  LIKE pmm_file.pmm14                                                                                            
     DEFINE l_ima021 LIKE ima_file.ima021                                                                                           
     CALL cl_del_data(l_table)                                                                                                      
#No.FUN-840054  --end                     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580014--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr701'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580014--end
 
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
 
     #採購單之單頭和單身的狀況碼都必須為'2'
     LET l_sql = " SELECT ",
                 #" pmm01,pmm08,pmm12,pmm13,pmm14,pmm15,pmm09,'',pmm22,pmm20,",   #CHI-8B0011
                 " pmm01,pmm12,pmm13,pmm14,pmm15,pmm09,'',pmm22,pmm20,",   #CHI-8B0011
                 #" pmn02,pmn04,pmn041,pmn20,pmn41,rva01,",   #CHI-8B0011
                 " pmn02,pmn04,pmn041,pmn20,pmn24,pmn25,pmn41,rva01,",   #CHI-8B0011
                 " rvb05,rvb01,rvb02,rvb07,rvb11,rvb17,rvb19,",
                 " rvb29,rvb30,rvb31 ",
                 " FROM pmm_file,pmn_file,rva_file,rvb_file",
                 " WHERE pmm01=pmn01 ",
                #No.+454 010720 by plum
                #"  AND pmm01 = rva02 AND rva01=rvb01 ",
                 "  AND pmm01 = rvb04 AND rva01=rvb01 ",
                #No.+454..end
                #"  AND pmm25='2' AND pmn16='2' ", #CHI-A70054 mark
                 "  AND rvb03=pmn02 ",
                 "  AND rvaconf !='X' ",
                 "  AND ",tm.wc CLIPPED
     #CHI-A70054 add --start--
     IF tm.a ='Y' THEN
        LET l_sql = l_sql," AND pmm25 IN ('2','6') AND pmn16 IN ('2','6','7','8') "
     ELSE
        LET l_sql = l_sql," AND pmm25='2' AND pmn16='2' "
     END IF
     #CHI-A70054 add --end--
 
     PREPARE r701_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r701_curs  CURSOR FOR r701_prepare
#No.FUN-840054  --begin                                                                                                             
{                       
     CALL cl_outnam('apmr701') RETURNING l_name
     START REPORT r701_rep TO l_name
     LET g_pageno = 0
     CALL cl_prt_pos_len()
}                                                                                                                                   
#No.FUN-840054  --end   
     FOREACH r701_curs  INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.FUN-840054  --BEGIN  
       #OUTPUT TO REPORT r701_rep(sr.*)
       LET l_pmm12='' LET l_pmm15='' LET l_pmm13='' LET l_pmm14=''                                                                  
       SELECT gen02 INTO l_pmm12    #采購員                                                                                         
        FROM gen_file   WHERE gen01=sr.pmm12                                                                                        
       SELECT gen02 INTO l_pmm15    #確認人                                                                                         
        FROM gen_file   WHERE gen01=sr.pmm15                                                                                        
       SELECT gem02 INTO l_pmm13    #請購部門                                                                                       
        FROM gem_file   WHERE gem01=sr.pmm13                                                                                        
       SELECT gem02 INTO l_pmm14    #收貨部門                                                                                       
        FROM gem_file   WHERE gem01=sr.pmm14                                                                                        
       SELECT pmc03 INTO sr.pmc03      #廠商簡稱                                                                                    
        FROM pmc_file WHERE pmc01=sr.pmm09                                                                                          
       LET l_ima021 = ''                                                                                                            
       SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.rvb05                                                               
       IF STATUS THEN LET l_ima021 = '' END IF                                                                                      
       #EXECUTE insert_prep USING sr.pmm01,sr.pmm08,sr.pmm12, sr.pmm13,sr.pmm14,   #CHI-8B0011
       EXECUTE insert_prep USING sr.pmm01,sr.pmm12, sr.pmm13,sr.pmm14,   #CHI-8B0011
                                 sr.pmm15,sr.pmm09,sr.pmc03, sr.pmm22,sr.pmm20,                                                     
                                 #sr.pmn02,sr.pmn04,sr.pmn041,sr.pmn20,sr.pmn41,   #CHI-8B0011
                                 sr.pmn02,sr.pmn04,sr.pmn041,sr.pmn20,sr.pmn24,sr.pmn25,sr.pmn41,   #CHI-8B0011
                                 sr.rva01,sr.rvb05,sr.rvb01, sr.rvb02,sr.rvb07,                                                     
                                 sr.rvb11,sr.rvb17,sr.rvb19, sr.rvb29,sr.rvb30,                                                     
                                 sr.rvb31,l_pmm12, l_pmm15,  l_pmm13, l_pmm14,                                                      
                                 l_ima021                                                                                           
     #No.FUN-840054  --END                          
     END FOREACH
     
     #No.FUN-840054  --BEGIN  
     #FINISH REPORT r701_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09,pmn24,rva01')                                                                        
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str=g_str CLIPPED,';',tm.jump                                                                                            
     LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('apmr701','apmr701',g_sql,g_str)                                                                               
     #No.FUN-840054  --end           
END FUNCTION
 
#No.FUN-840054  --BEGIN                                                                                                             
{                   
REPORT r701_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         #l_str         VARCHAR(30),               #TQC-630166 mark
          l_str         STRING,                 #TQC-630166
          l_sw          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
         #l_sql1        LIKE type_file.chr1000, #TQC-630166 mark      #No.FUN-680136 VARCHAR(1000)
          l_sql1        STRING,                 #TQC-630166
          l_pmm04       LIKE pmm_file.pmm04,
          l_pmm12       LIKE gen_file.gen02,
          l_pmm15       LIKE gen_file.gen02,
          l_pmm13       LIKE gem_file.gem02,
          l_pmm14       LIKE gem_file.gem02,
          l1_ima02      LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,   #FUN-640236 add
          sr      RECORD
                 pmm01  LIKE pmm_file.pmm01, #採購單號
                 pmm08  LIKE pmm_file.pmm08, #請購單號
                 pmm12  LIKE pmm_file.pmm12, #採購員
                 pmm13  LIKE pmm_file.pmm13, #請購部門
                 pmm14  LIKE pmm_file.pmm14, #收貨部門
                 pmm15  LIKE pmm_file.pmm15, #確認人
                 pmm09  LIKE pmm_file.pmm09, #廠商代號
                 pmc03  LIKE pmc_file.pmc03, #廠商簡稱
                 pmm22  LIKE pmm_file.pmm22, #幣別
                 pmm20  LIKE pmm_file.pmm20, #付款方式
                 pmn02  LIKE pmn_file.pmn02, #採購單項次
                 pmn04  LIKE pmn_file.pmn04, #料件編號
                 pmn041 LIKE pmn_file.pmn041,#品名規格
                 pmn20  LIKE pmn_file.pmn20, #訂購量
                 pmn41  LIKE pmn_file.pmn41, #委外工單
                 rva01  LIKE rva_file.rva01, #驗收單號
                 rvb05  LIKE rvb_file.rvb05, #料件編號
                 rvb01  LIKE rvb_file.rvb01, #驗收單號
                 rvb02  LIKE rvb_file.rvb02, #驗收單項次
                 rvb07  LIKE rvb_file.rvb07, #實收數量
                 rvb11  LIKE rvb_file.rvb11, #代買項次
                 rvb17  LIKE rvb_file.rvb17, #檢驗批號
                 rvb19  LIKE rvb_file.rvb19, #收貨性質
               # rvb28  LIKE rvb_file.rvb28, #報廢量
                 rvb29  LIKE rvb_file.rvb29, #退貨量
                 rvb30  LIKE rvb_file.rvb30, #入庫量
                 rvb31  LIKE rvb_file.rvb31  #可入庫量
                END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmm01,sr.pmn02,sr.rvb01,sr.rvb02
  FORMAT
   PAGE HEADER
#No.FUN-580014--begin
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),' FROM:',g_user
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     PRINT g_x[2] CLIPPED,g_today,'  ',TIME,
#           COLUMN (g_len-FGL_WIDTH(g_user)-4),g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      LET l_last_sw = 'n'
      PRINT g_dash[1,g_len] CLIPPED
#No.FUN-580014--end
#-------------------------No.TQC-630225 add------------------
      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],
                       g_x[35],g_x[36],g_x[37],g_x[38],
                       g_x[39],g_x[40],g_x[41],g_x[42],
                       g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[54]
      PRINTX name = H2 g_x[48],g_x[49],g_x[50],g_x[51],
                       g_x[52],g_x[53]
      PRINT g_dash1
#-------------------------No.TQC-630225 end------------------
 
BEFORE GROUP  OF sr.pmm01   #列印採購單單頭資料
      IF  tm.jump='Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
      LET l_pmm12='' LET l_pmm15='' LET l_pmm13='' LET l_pmm14=''
      SELECT gen02 INTO l_pmm12    #採購員
        FROM gen_file   WHERE gen01=sr.pmm12
      SELECT gen02 INTO l_pmm15    #確認人
        FROM gen_file   WHERE gen01=sr.pmm15
      SELECT gem02 INTO l_pmm13    #請購部門
        FROM gem_file   WHERE gem01=sr.pmm13
      SELECT gem02 INTO l_pmm14    #收貨部門
        FROM gem_file   WHERE gem01=sr.pmm14
      NEED 6 LINES
#No.FUN_550060 --start--
#No.FUN-580014--begin
#     PRINT g_x[11] CLIPPED,sr.pmm01 CLIPPED,
#          COLUMN 27,g_x[12] CLIPPED,sr.pmm08 CLIPPED,
#          COLUMN 52,g_x[13] CLIPPED,l_pmm12 CLIPPED,
#          COLUMN 72,g_x[14] CLIPPED,l_pmm13 CLIPPED,
#          COLUMN 94,g_x[15] CLIPPED,l_pmm14 CLIPPED,
#          COLUMN 115,g_x[16] CLIPPED,l_pmm15 CLIPPED
      SELECT pmc03 INTO sr.pmc03      #廠商簡稱
        FROM pmc_file WHERE pmc01=sr.pmm09
#     PRINT g_x[17] CLIPPED,sr.pmm09,
#          COLUMN 27,g_x[18] CLIPPED,sr.pmc03 CLIPPED,
#          COLUMN 52,g_x[19] CLIPPED,sr.pmm22 CLIPPED,
#          COLUMN 72,g_x[20] CLIPPED,sr.pmm20 CLIPPED
#     SKIP 1 LINE
#     PRINT g_x[22],
#           COLUMN 41,g_x[25] CLIPPED,
#          COLUMN 85,g_x[28]   #列印單身表頭
#     PRINT g_x[23],
#           COLUMN 41,g_x[26] CLIPPED,
#          COLUMN 85,g_x[29]
#     PRINT g_x[24],
#           COLUMN 41,g_x[27] CLIPPED,' ',g_x[30]
#-------------------------No.TQC-630225 mark------------------
#     PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],
#                      g_x[35],g_x[36],g_x[37],g_x[38],
#                      g_x[39],g_x[40],g_x[41],g_x[42],
#                      g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[54]
#     PRINTX name = H2 g_x[48],g_x[49],g_x[50],g_x[51],
#                      g_x[52],g_x[53]
#     PRINT g_dash1
#-------------------------No.TQC-630225 end------------------
      PRINTX name = D1
             COLUMN g_c[31],sr.pmm01 CLIPPED,
             COLUMN g_c[32],sr.pmm08 CLIPPED,
             COLUMN g_c[33],l_pmm12  CLIPPED,
             COLUMN g_c[34],l_pmm13  CLIPPED,
             COLUMN g_c[35],l_pmm14  CLIPPED,
             COLUMN g_c[36],l_pmm15  CLIPPED,
             COLUMN g_c[37],sr.pmm09 CLIPPED,
             COLUMN g_c[38],sr.pmc03 CLIPPED,
             COLUMN g_c[39],sr.pmm22 CLIPPED,
             COLUMN g_c[54],sr.pmm20 CLIPPED;
#No.FUN-580014--end
 
BEFORE GROUP OF sr.pmn02     #採購單項次
#No.FUN-580014--begin
     PRINTX name = D1
           COLUMN g_c[40],sr.pmn02 USING "###&",
           COLUMN g_c[41],sr.pmn04,
           COLUMN g_c[42],sr.pmn20 USING '##########.###';
     LET g_sw='Y'
#No.FUN-580014--end
 
ON EVERY ROW
#No.FUN-580014--begin
      PRINTX name = D1
           COLUMN g_c[43],sr.rvb01,
           COLUMN g_c[44],sr.rvb02 USING "###&",
           COLUMN g_c[45],sr.rvb07 USING '##########&.###',
           COLUMN g_c[47],cl_numfor(sr.rvb29,47,3)
#No.FUN-580014--end
 
     #--->相同的採購項次只印一次品名規格,為'Y'時,才列印品名規格
     IF g_sw='Y' THEN
       #start FUN-640236 add
        LET l_ima021 = ''
        SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.rvb05
        IF STATUS THEN LET l_ima021 = '' END IF
       #end FUN-640236 add
#No.FUN-580014--begin
          PRINTX name = D2
               COLUMN g_c[49],sr.pmn041[1,30],   #No.TQC-6B0095
               COLUMN g_c[50],l_ima021[1,37] CLIPPED,   #FUN-640236 add
               COLUMN g_c[51],sr.rvb17[1,15],   #No.TQC-6B0095
               COLUMN g_c[52],cl_numfor(sr.rvb30,52,3),
               COLUMN g_c[53],cl_numfor(sr.rvb31,53,3)
     ELSE
          PRINTX name = D2
               COLUMN g_c[51],sr.rvb17[1,15],
               COLUMN g_c[52],cl_numfor(sr.rvb30,52,3),
               COLUMN g_c[53],cl_numfor(sr.rvb31,53,3)
#No.FUN-580014--end
     END IF
#No.FUN-550060 --end--
     LET g_sw='N'
     SKIP 1 LINE
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-201,240,300
         THEN PRINT g_dash[1,g_len]
             #TQC-630166
             #IF tm.wc[001,70] > ' ' THEN			# for 80
             #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
             #IF tm.wc[071,140] > ' ' THEN
             #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
             #IF tm.wc[141,210] > ' ' THEN
  	     #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
             #IF tm.wc[211,280] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-840054  --END 
#Patch....NO.TQC-610036 <> #
