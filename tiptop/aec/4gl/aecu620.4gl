# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aecu620.4gl
# Descriptions...: 更新主檔前置時間作業
# Input parameter:
# Return code....:
# Date & Author..: 91/12/16 By Carol
# Mofdiy.........: 92/03/19 By Pin
# Mofdiy.........: 92/07/31 By Pin
#                  公式中,原先乘上之資源數,現去掉
#                  不考慮lead time 之來源碼為 'C/T/D/A/P/V/Z'
# Modify.........: No.FUN-510032 05/02/15 By pengu 報表轉XML
# Modify.........: No.MOD-570034 05/08/23 By pengu 更新料件主檔前置時間錯誤
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-760085 07/07/20 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.FUN-710073 07/11/29 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')  
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.MOD-940348 09/05/25 By Pengu 生產時間ecb27 ecb28為秒，但aecu620轉換為天時是以分作換算
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
	        wc  	STRING,			# Where condition
                b       LIKE type_file.chr1,    # No.FUN-680073 VARCHAR(1),# 重新計算選擇1, 2, 3 
                c       LIKE type_file.dat,     # No.FUN-680073 DATE,   # 有效日期
                d       LIKE type_file.chr1     # No.FUN-680073 VARCHAR(1) # 模擬計算或修正前置時間1, 2, 3
              END RECORD,
          sr_t          RECORD  ima01     LIKE ima_file.ima01, #料件編號
				ima02     LIKE ima_file.ima02, #品名
				ima021    LIKE ima_file.ima021,#規格   #FUN-5A0059
				ima05     LIKE ima_file.ima05, #版本
				ima08     LIKE ima_file.ima08, #來源
				ima25     LIKE ima_file.ima25, #庫存單位
				ima59     LIKE ima_file.ima59, #固定前置時間(前)
				ima60     LIKE ima_file.ima60, #變動前置時間(前)
				ima59_f   LIKE ima_file.ima59, #固定前置時間(後)
				ima60_f   LIKE ima_file.ima60, #變動前置時間(後)
                               #ima56     LIKE ima_file.ima56, #生產批量            #CHI-810015 mark #FUN-710073 add
		                ecb13     LIKE ecb_file.ecb13, #成本計算基準1,2
		                ecb26     LIKE ecb_file.ecb26, #設置時間
		                ecb11     LIKE ecb_file.ecb11, #作業重疊程度
		                ecb10     LIKE ecb_file.ecb10, #搬運時間
		                ecb15     LIKE ecb_file.ecb15, #人工數
		                ecb16     LIKE ecb_file.ecb16, #機器數
		                ecb27     LIKE ecb_file.ecb27, #排程生產時間
		                ecb28     LIKE ecb_file.ecb28, #排程廠外加工時間
		                eca01     LIKE eca_file.eca01, #工作站編號
		                eca09     LIKE eca_file.eca09, #等待時間
		                eca08     LIKE eca_file.eca08, #產能小時
		                eca04     LIKE eca_file.eca04, #工作站型態
		                eca06     LIKE eca_file.eca06  #產能型態
                        END RECORD,
	  g_unit      LIKE ima_file.ima18,     #No.FUN-680073 DECIMAL(9,3),
          g_setup     LIKE ima_file.ima18,     #No.FUN-680073 DECIMAL(9,3),
	  g_move      LIKE ima_file.ima18,     #No.FUN-680073 DECIMAL(9,3),
	  g_queue     LIKE ima_file.ima18      #No.FUN-680073 DECIMAL(9,3)
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680073 SMALLINT
#No.FUN-760085---Begin                                                          
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       g_sql          STRING,                                                   
       l_sql          STRING                                                    
#No.FUN-760085---End     
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
#No.FUN-760085---Begin 
   LET g_sql = "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",
               "ima59.ima_file.ima59,",
               "ima59_f.ima_file.ima59,",
               "ima60.ima_file.ima60,",
               "ima60_f.ima_file.ima60"
 
   LET l_table = cl_prt_temptable('aecu620',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?) "  
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
#No.FUN-760085---End               
 
   LET tm.wc = ARG_VAL(1)
   LET tm.b  = ARG_VAL(2)
   LET tm.c  = ARG_VAL(3)
   LET tm.d  = ARG_VAL(4)
   CALL u620_tm()	        	# Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION u620_tm()
   DEFINE   l_cmd	  LIKE type_file.chr1000,       #No.FUN-680073 VARCHAR(400)
            p_row,p_col   LIKE type_file.num5,          #No.FUN-680073 SMALLINT SMALLINT
	    l_eca01       LIKE eca_file.eca01
 
 
   LET p_row = 3 LET p_col = 12
 
   OPEN WINDOW u620_w AT p_row,p_col WITH FORM "aec/42f/aecu620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   IF g_sma.sma54 = 'N' THEN      #不使用製程時, 無須執行此系統
      CALL cl_err('','mfg4084',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.b    = '1'
   LET tm.c    = g_today
   LET tm.d    = '1'
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CONSTRUCT BY NAME tm.wc ON ima06,ima01
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW u620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      #先檢查看是否有合乎條件之資料再繼續執行
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT ecb01),eca01",
               	   "  FROM ima_file,ecb_file,eca_file",
                   " WHERE ima01=ecb01 AND ecb08=eca01",
                   "   AND imaacti ='Y' AND ecbacti ='Y' AND ecaacti ='Y'",
           	   "   AND ima08!='P' AND ima08!='C' ",
                   "   AND ima08!='D' AND ima08!='A' ",
                   "   AND ",tm.wc CLIPPED," GROUP BY eca01"
         PREPARE u620_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
         DECLARE u620_cnt CURSOR WITH HOLD FOR u620_precnt
         OPEN u620_cnt
         FETCH u620_cnt INTO g_cnt,l_eca01
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CLOSE u620_cnt
            CONTINUE WHILE
         END IF
      END IF
      LET tm.b='3'
      LET tm.c=g_today
      LET tm.d='1'
 
      DISPLAY BY NAME tm.b,tm.c,tm.d 		# Condition
 
      INPUT BY NAME tm.b,tm.c,tm.d WITHOUT DEFAULTS
   ON ACTION locale
    CALL cl_dynamic_locale()
    CALL cl_show_fld_cont()   #FUN-550037(smin)
 
 
 
         AFTER FIELD b  #計算選擇 1.變動 2.固定 3.兩者
            IF tm.b NOT MATCHES "[123]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c  #有效日期
            IF tm.c IS NULL THEN
               LET tm.c = g_today
    	       DISPLAY BY NAME tm.c
               NEXT FIELD c
            END IF
         AFTER FIELD d  #模擬或修正 1.模擬報表 2.修正 3.修正且含報表
            IF tm.d NOT MATCHES "[123]" THEN
               NEXT FIELD d
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW u620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aecu620()
      ERROR ""
    #--No.MOD-570034 add
      CALL cl_end(17,20)
      IF NOT cl_cont(17,20) THEN
         EXIT WHILE
      END IF
  #--end
   END WHILE
 
   CLOSE WINDOW u620_w
END FUNCTION
 
FUNCTION aecu620()
   DEFINE
          l_name        LIKE type_file.chr20,    # No.FUN-680073 VARCHAR(20), #External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0100
          l_sql 	LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(1000) # RDSQL STATEMENT    
          l_za05        LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40)
	  l_ima01       LIKE ima_file.ima01,
	  l_eca01       LIKE eca_file.eca01,
         #l_ima56       LIKE ima_file.ima56,     #CHi-810015 mark #FUN-710073 add
          sr            RECORD  ima01     LIKE ima_file.ima01, #料件編號
				ima02     LIKE ima_file.ima02, #品名
				ima021    LIKE ima_file.ima021,#規格   #FUN-5A0059
				ima05     LIKE ima_file.ima05, #版本
				ima08     LIKE ima_file.ima08, #來源
				ima25     LIKE ima_file.ima25, #庫存單位
				ima59     LIKE ima_file.ima59, #固定前置時間(前)
				ima60     LIKE ima_file.ima60, #變動前置時間(前)
				ima59_f   LIKE ima_file.ima59, #固定前置時間(後)
				ima60_f   LIKE ima_file.ima60, #變動前置時間(後)
                               #ima56     LIKE ima_file.ima56, #生產批量     #CHI-810015 mark #FUN-710073 add
		                ecb13     LIKE ecb_file.ecb13, #成本計算基準1,2
		                ecb26     LIKE ecb_file.ecb26, #設置時間
		                ecb11     LIKE ecb_file.ecb11, #作業重疊程度
		                ecb10     LIKE ecb_file.ecb10, #搬運時間
		                ecb15     LIKE ecb_file.ecb15, #人工數
		                ecb16     LIKE ecb_file.ecb16, #機器數
		                ecb27     LIKE ecb_file.ecb27, #排程生產時間
		                ecb28     LIKE ecb_file.ecb28, #排程廠外加工時間
		                eca01     LIKE eca_file.eca01, #工作站編號
		                eca09     LIKE eca_file.eca09, #等待時間
		                eca08     LIKE eca_file.eca08, #產能小時
		                eca04     LIKE eca_file.eca04, #工作站型態
		                eca06     LIKE eca_file.eca06  #產能型態
		        END RECORD
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aecuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aecgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aecgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aecuser', 'aecgrup')
     #End:FUN-980030
 
    #LET l_sql = "SELECT ima01, ima02, ima05, ima08, ima25, ima59, ima60,",          #FUN-5A0059 mark
     LET l_sql = "SELECT ima01, ima02, ima021,ima05, ima08, ima25, ima59, ima60,",   #FUN-5A0059
                #" '','',ima56, ecb13, ecb26, ecb11, ecb10, ecb15, ecb16, ecb27,",   #CHI-810015 mark#FUN-710073 add ima56
                 " '','',ecb13, ecb26, ecb11, ecb10, ecb15, ecb16, ecb27,",          #CHI-810015 mod #FUN-710073 add ima56
                 "       ecb28, eca01, eca09, eca08, eca04, eca06",
                 "  FROM ima_file, ecb_file, eca_file ",
               #   " WHERE ima01 = ecb01 AND eca01 = ecb08 AND ecb02 ='1'",       #No.MOD-570034 mark
                  " WHERE ecb01 = ima571 AND ecb02 = ima94 AND eca01 = ecb08 ",   #No.MOD-570034 add
                 "   AND imaacti ='Y' AND ecbacti ='Y' AND ecaacti ='Y'",
		 "   AND ima08 NOT IN ('C','T','D','A','P','V','Z','c','t','d','a','p','v','z') ",
                 "   AND ",tm.wc CLIPPED," ORDER BY ima01, eca01"
 
     PREPARE u620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
     END IF
     DECLARE u620_curs1 CURSOR WITH HOLD FOR u620_prepare1
 #No.FUN-760085---Begin 
 #   CALL cl_outnam('aecu620') RETURNING l_name
 #   START REPORT u620_rep TO l_name
     CALL cl_del_data(l_table)
 #No.FUN-760085---End
#--->{其實我也不想加該transaction ,但4GL有限制, 如果 "LOCK TABLE"
     {需寫在transaction 中}
  BEGIN WORK
     LOCK TABLE eca_file IN SHARE MODE
     LOCK TABLE ecb_file IN SHARE MODE
     LOCK TABLE ima_file IN SHARE MODE
 
     FOREACH u620_curs1 INTO sr_t.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
      #IF sr_t.ima56 IS NULL THEN LET sr_t.ima56 = 0 END IF   #CHI-810015 mark #FUN-710073 add
       IF sr_t.ima59 IS NULL THEN LET sr_t.ima59 = 0 END IF
       IF sr_t.ima60 IS NULL THEN LET sr_t.ima60 = 0 END IF
      #LET l_ima56=sr_t.ima56                                 #CHI-810015 mark #FUN-710073 add
     IF l_ima01 IS NOT NULL AND l_ima01 != sr_t.ima01 THEN
	   IF sr.ima59_f < 0 THEN
		LET sr.ima59_f = 0
	   END IF
	   IF sr.ima60_f < 0 THEN
		LET sr.ima60_f = 0
	   END IF
       LET g_success='Y'
#-------->BEGIN WORK
       BEGIN WORK
           CASE
    	        WHEN tm.d = '1'   #模擬報表
                 #No.FUN-760085---Begin   
                 #   OUTPUT TO REPORT u620_rep(sr.*)
                     EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima05,
                                               sr.ima25,sr.ima08,sr.ima59,
                                               sr.ima59_f,sr.ima60,sr.ima60_f  
                 #No.FUN-760085---End   
	        WHEN tm.d = '2'   #實際修正(不含報表)
	       	     CALL u620_update()
	        WHEN tm.d = '2'   #實際修正(且含報表)
	   	     CALL u620_update()
                 #No.FUN-760085---Begin                                         
                 #   OUTPUT TO REPORT u620_rep(sr.*)                            
                     EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima05,
                                               sr.ima25,sr.ima08,sr.ima59,      
                                               sr.ima59_f,sr.ima60,sr.ima60_f   
                 #No.FUN-760085---End 
           END CASE
             IF g_success = 'Y'
               THEN  COMMIT WORK
               ELSE  CALL cl_rbmsg(1) ROLLBACK WORK
               IF NOT  cl_cont(0,0) THEN EXIT FOREACH END IF
             END IF
      END IF
 
       CASE
	    WHEN tm.b = '1'   #變動前置時間
 	     	 CALL u620_unit(l_ima01)          #CHI-810015 mark還原#FUN-710073 mark
 	     	#CALL u620_unit(l_ima01,l_ima56)  #CHI-810015 mark    #FUN-710073 mod 
	    WHEN tm.b = '2'   #固定前置時間
	    	 CALL u620_fixed(l_eca01,l_ima01)          #CHI-810015 mark還原#FUN-710073 mark
	    	#CALL u620_fixed(l_eca01,l_ima01,l_ima56)  #CHI-810015 mark    #FUN-710073 mod
	    WHEN tm.b = '3'   #變動/固定前置時間
	    	 CALL u620_fixed(l_eca01,l_ima01)          #CHI-810015 mark還原#FUN-710073 mark 
 	 	 CALL u620_unit(l_ima01)                   #CHI-810015 mark還原#FUN-710073 mark
	    	#CALL u620_fixed(l_eca01,l_ima01,l_ima56)  #CHI-810015 mark    #FUN-710073 mod
 	 	#CALL u620_unit(l_ima01,l_ima56)           #CHI-810015 mark    #FUN-710073 mod
       END CASE
        #--No.MOD-570034 add
       IF cl_null(sr_t.ima59_f) THEN
          LET sr_t.ima59_f = 0
       END IF
       IF cl_null(sr_t.ima60_f) THEN
          LET sr_t.ima60_f = 0
       END IF
     #--end
 
       LET l_ima01 = sr_t.ima01
       LET l_eca01 = sr_t.eca01
       LET sr.*    = sr_t.*      #存放上一個值
     END FOREACH
     UNLOCK TABLE ima_file
     UNLOCK TABLE eca_file
     UNLOCK TABLE ecb_file
     COMMIT WORK
     CASE
    	  WHEN tm.d = '1'   #模擬報表
           #No.FUN-760085---Begin                                         
           #   OUTPUT TO REPORT u620_rep(sr.*)                            
               EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima05,
                                         sr.ima25,sr.ima08,sr.ima59,      
                                        sr.ima59_f,sr.ima60,sr.ima60_f   
           #No.FUN-760085---End  
	  WHEN tm.d = '2'   #實際修正(不含報表)
	       CALL u620_update()
	  WHEN tm.d = '3'   #實際修正(且含報表)
	       CALL u620_update()
           #No.FUN-760085---Begin                                               
           #   OUTPUT TO REPORT u620_rep(sr.*)                                  
               EXECUTE insert_prep USING sr.ima01,sr.ima02,sr.ima021,sr.ima05,      
                                         sr.ima25,sr.ima08,sr.ima59,            
                                        sr.ima59_f,sr.ima60,sr.ima60_f          
           #No.FUN-760085---End                   
     END CASE
 
#    FINISH REPORT u620_rep          #No.FUN-760085
 
     IF tm.d !='2' THEN 
    #No.FUN-760085---Begin
        IF g_zz05 = 'Y' THEN                                                       
           CALL cl_wcchp(tm.wc,'ima06,ima01')                                
             RETURNING tm.wc                                                     
           LET g_str = tm.wc                                                       
        END IF                                                                     
        LET g_str = tm.wc                                                          
        LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED    
    #   THEN CALL cl_prt(l_name,g_prtway,g_copies,g_len)
        CALL cl_prt_cs3('aecu620','aecu620',l_sql,g_str)        
    #No.FUN-760085---End
     END IF
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END FUNCTION
 
#FUNCTION u620_unit(l_ima01,l_ima56)      #CHI-810015mark     #FUN-710073 mod
FUNCTION u620_unit(l_ima01)               #CHI-810015mark還原 #FUN-710073 mark
    #Unit Lead Time = 生產時間 * 資源數
    #Unit Lead Time = 生產時間
    DEFINE l_ima01     LIKE ima_file.ima01
   #DEFINE l_ima56     LIKE ima_file.ima56    #CHI-810015 mark #FUN-710073 add
 
    IF l_ima01!=sr_t.ima01 OR l_ima01 IS NULL THEN
       LET g_unit = 0
    END IF
    IF sr_t.ecb13 = '2' THEN #unit/hour 轉成 hour/unit
       IF sr_t.ecb27 IS NULL OR sr_t.ecb27=0 THEN LET sr_t.ecb27 =1 END IF
       IF sr_t.ecb28 IS NULL OR sr_t.ecb28=0 THEN LET sr_t.ecb28 =1 END IF
       LET sr_t.ecb27 = 1 / sr_t.ecb27
       LET sr_t.ecb28 = 1 / sr_t.ecb28
    END IF
    CASE
	WHEN sr_t.eca04 = '0'  #一般工作站
             CASE
 	   	 WHEN sr_t.eca06 = '1' #機器
#                  LET g_unit = g_unit+(sr_t.ecb27/60/sr_t.eca08*sr_t.ecb16)
                  #LET g_unit = g_unit+(sr_t.ecb27/60/sr_t.eca08)     #No.MOD-940348 mark
                   LET g_unit = g_unit+(sr_t.ecb27/3600/sr_t.eca08)   #No.MOD-940348 add
	 	 WHEN sr_t.eca06 = '2' #人工
#                 LET g_unit = g_unit+(sr_t.ecb27/60/sr_t.eca08*sr_t.ecb15)
	             #LET g_unit = g_unit+(sr_t.ecb27/60/sr_t.eca08)    #No.MOD-940348 mark
	              LET g_unit = g_unit+(sr_t.ecb27/3600/sr_t.eca08)  #No.MOD-940348 add
             END CASE
	WHEN sr_t.eca04 = '1'                  #廠外加工/廠內加工
             CASE
 	   	 WHEN sr_t.eca06 = '1' #機器
#                 LET g_unit = g_unit+(sr_t.ecb28/60/sr_t.eca08*sr_t.ecb16)
                 #LET g_unit = g_unit+(sr_t.ecb28/60/sr_t.eca08)     #No.MOD-940348 mark
                  LET g_unit = g_unit+(sr_t.ecb28/3600/sr_t.eca08)   #No.MOD-940348 add
	 	 WHEN sr_t.eca06 = '2' #人工
#                 LET g_unit = g_unit+(sr_t.ecb28/60/sr_t.eca08*sr_t.ecb15)
	             #LET g_unit = g_unit+(sr_t.ecb28/60/sr_t.eca08)     #No.MOD-940348 mark 
	              LET g_unit = g_unit+(sr_t.ecb28/3600/sr_t.eca08)   #No.MOD-940348 add
             END CASE
    END CASE
#display sr_t.ima01, g_unit
#sleep 3 
    LET sr_t.ima60_f = g_unit            #CHI-810015mark還原#FUN-710073 mark 
   #LET sr_t.ima60_f = g_unit / l_ima56  #CHI-810015mark    #FUN-710073 mod
END FUNCTION
 
#FUNCTION u620_fixed(l_eca01,l_ima01,l_ima56)  #CHI-810015mark    #FUN-710073 mod
FUNCTION u620_fixed(l_eca01,l_ima01)           #CHI-810015mark還原#FUN-710073 mark
    #Fixed Lead Time = (setup time + move time + queue time ) / 產能小時
    DEFINE l_ima01     LIKE ima_file.ima01,
           l_eca01     LIKE eca_file.eca01
          #l_ima56     LIKE ima_file.ima56     #CHI-810015 mark #FUN-710073 add
 
    IF l_ima01!=sr_t.ima01 OR l_ima01 IS NULL THEN
       LET g_setup=0 LET g_move=0 LET g_queue=0
       LET l_eca01 = NULL
    END IF
    IF sr_t.eca04 = '0' THEN #若為廠外加工或廠內加工 Fixed Lead Time = 0
        LET g_setup = g_setup + (sr_t.ecb26*(1-sr_t.ecb11/100))/60
        LET g_move  = g_move  + sr_t.ecb10 / 60
        IF  l_eca01 IS NULL OR l_eca01 != sr_t.eca01 THEN #同W/C只有一queue time
            LET g_queue = g_queue + sr_t.eca09 / 60
        END IF
    END IF
    LET sr_t.ima59_f = (g_setup + g_move + g_queue) / sr_t.eca08            #CHI-810015 mark還原 #FUN-710073 mark
   #LET sr_t.ima59_f = ((g_setup + g_move + g_queue) / sr_t.eca08)/l_ima56  #CHI-810015 mark     #FUN-710073 mod
#display sr_t.ima01,'s:',g_setup,' m:',g_move,' q:',g_queue
#sleep 3
END FUNCTION
 
FUNCTION u620_update()
 
      #--No.MOD-570034 modify
    CASE
        WHEN tm.b = '1'
             UPDATE ima_file SET ima60 = sr_t.ima60_f ,
                                 imadate = g_today    #FUN-C30315 add
              WHERE ima01 = sr_t.ima01
      IF SQLCA.sqlcode THEN  LET g_success='N' END IF
        WHEN tm.b = '2'
             UPDATE ima_file SET ima59 = sr_t.ima59_f,
                                 imadate = g_today    #FUN-C30315 add
              WHERE ima01 = sr_t.ima01
      IF SQLCA.sqlcode THEN  LET g_success='N' END IF
        WHEN tm.b = '3'
             UPDATE ima_file SET ima59 = sr_t.ima59_f,
                                 imadate = g_today,      #FUN-C30315 add
                                 ima60 = sr_t.ima60_f
              WHERE ima01 = sr_t.ima01
      IF SQLCA.sqlcode THEN  LET g_success='N' END IF
    END CASE
  #--end
 
 
END FUNCTION
#No.FUN-760085---Begin
{
REPORT u620_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,     # No.FUN-680073  VARCHAR(1)
          sr            RECORD  ima01     LIKE ima_file.ima01, #料件編號
				ima02     LIKE ima_file.ima02, #品名
				ima021    LIKE ima_file.ima021,#規格   #FUN-5A0059
				ima05     LIKE ima_file.ima05, #版本
				ima08     LIKE ima_file.ima08, #來源
				ima25     LIKE ima_file.ima25, #庫存單位
				ima59     LIKE ima_file.ima59, #固定前置時間(前)
				ima60     LIKE ima_file.ima60, #變動前置時間(前)
				ima59_f   LIKE ima_file.ima59, #固定前置時間(後)
				ima60_f   LIKE ima_file.ima60, #變動前置時間(後)
		                ecb13     LIKE ecb_file.ecb13, #成本計算基準1,2
		                ecb26     LIKE ecb_file.ecb26, #設置時間
		                ecb11     LIKE ecb_file.ecb11, #作業重疊程度
		                ecb10     LIKE ecb_file.ecb10, #搬運時間
		                ecb15     LIKE ecb_file.ecb15, #人工數
		                ecb16     LIKE ecb_file.ecb16, #機器數
		                ecb27     LIKE ecb_file.ecb27, #排程生產時間
		                ecb28     LIKE ecb_file.ecb28, #排程廠外加工時間
		                eca01     LIKE eca_file.eca01, #工作站編號
		                eca09     LIKE eca_file.eca09, #等待時間
		                eca08     LIKE eca_file.eca08, #產能小時
		                eca04     LIKE eca_file.eca04, #工作站型態
		                eca06     LIKE eca_file.eca06  #產能型態
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.ima01, sr.ima05, sr.ima08
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT COLUMN (g_c[37]+(g_w[37]+g_w[38]-FGL_WIDTH(g_x[9]))/2),g_x[9],
            COLUMN (g_c[39]+(g_w[39]-FGL_WIDTH(g_x[11]))/2),g_x[11],
            COLUMN (g_c[40]+(g_w[40]+g_w[41]-FGL_WIDTH(g_x[10]))/2),g_x[10],
            COLUMN (g_c[42]+(g_w[42]-FGL_WIDTH(g_x[11]))/2),g_x[11]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED
           ,g_x[42] CLIPPED   #FUN-5A0059
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02,
           #start FUN-5A0059
            COLUMN g_c[33],sr.ima021,
            COLUMN g_c[34],sr.ima25,
            COLUMN g_c[35],sr.ima05,
            COLUMN g_c[36],sr.ima08,
	    COLUMN g_c[37],sr.ima59 USING '####,##&.###',
            COLUMN g_c[38],sr.ima59_f USING '####,##&.###',
            COLUMN g_c[39],sr.ima59-sr.ima59_f USING '--,--&.###',
	    COLUMN g_c[40],sr.ima60 USING '####,##&.###',
            COLUMN g_c[41],sr.ima60_f USING '####,##&.###',
            COLUMN g_c[42],sr.ima60-sr.ima60_f USING '--,--&.###'
           #end FUN-5A0059
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash[1,g_len]
       #-- TQC-630166 begin
         #IF tm.wc[001,070] > ' ' THEN			# for 80
	 #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #IF tm.wc[071,140] > ' ' THEN
	 #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #IF tm.wc[141,210] > ' ' THEN
	 #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #IF tm.wc[211,280] > ' ' THEN
	 #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        IF tm.wc[001,120] > ' ' THEN			# for 132
#	    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        IF tm.wc[121,240] > ' ' THEN
#	    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        IF tm.wc[241,300] > ' ' THEN
#	    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
       #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-760085---End
