# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmr812.4gl
# Descriptions...: 尾階材料用途清單
# Input parameter:
# Return code....:
# Date & Author..: 91/08/19 By Nora
# Modify.........: 93/09/14 By Apple(增列說明)
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima021
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.FUN-510033 05/01/21 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/05/26 By kim 配方BOM
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.TQC-5C0068 05/12/13 By kim 合計不對齊
# Modify.........: No.MOD-640206 06/04/09 By Alexstar 增加表頭來原碼欄位的寬度
# Modify.........: No.TQC-6B0096 06/11/17 By Ray 報表寬度不符,有效日期居中
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq612->abmr812 
# Modify.........: No.FUN-780018 07/07/19 By xiaofeizhu 制作水晶報表
# Modify.........: No.MOD-7B0058 07/11/07 By zhoufeng 增加特征代碼的處理
# Modify.........: No.TQC-8C0063 08/12/30 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920274 09/02/23 By kim 單位用量計算錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No:MOD-B20154 11/02/25 By sabrina 組成用量在更新時應多判斷bmb03
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
#CHI-6A0034 add
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
    		wc  	  VARCHAR(500),    # Where condition
   	    	revision  VARCHAR(02),		# 版本
       		effective DATE,   		# 有效日期
       		arrange   VARCHAR(1),		# 資料排列方式
   	    	more	  VARCHAR(1) 		# Input more condition(Y/N)
          END RECORD,
          g_bmb03_a       LIKE bmb_file.bmb01,
          g_tot INTEGER
 
DEFINE   g_cnt           INTEGER
DEFINE   g_i             SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING,              ### FUN-780018 ###                                                                    
         g_str           STRING,              ### FUN-780018 ###                                                                    
         g_sql           STRING               ### FUN-780018 ###  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
## *** FUN-780018 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "bmb03.bmb_file.bmb03,",                                                                                            
                "p_level.type_file.num5,",
                "p_i.type_file.num5,",
                "l_point.type_file.chr20,",
#               "l_point.type_file.chr1,",                      #FUN-780018
                "ima08.ima_file.ima08,",                                                                                            
                "ima06.ima_file.ima06,",                                                                                            
                "ima25.ima_file.ima25,",                                                                                            
                "ima02.ima_file.ima02,",                                                                                            
                "ima63.ima_file.ima63,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "ima15.ima_file.ima15,",                                                                                            
                "bmb01.bmb_file.bmb01,",         
                "ima02s.ima_file.ima02,",                                                                                           
                "ima021s.ima_file.ima021,",       
                "bmb29.bmb_file.bmb29,",                                                                                  
                "ima05.ima_file.ima05,",                                                                                            
                "ima08s.ima_file.ima08,",                                                                                           
                "bmb06.bmb_file.bmb06,",                                                                                            
                "bmb10.bmb_file.bmb10,",                                                                                            
                "bmb02.bmb_file.bmb02,",         
                "l_cnt.type_file.num5,",
                "p_acode.bmb_file.bmb29"                      #No.MOD-7B0058  add                                                                             
    LET l_table = cl_prt_temptable('abmr812',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                           
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #TQC-A40116 mod                                                                          
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",                   
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"    #No.MOD-7B0058                                                         
#                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"      #No.MOD-7B0058                                                                             
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#   
    #MOD-920274.........begin  #當一BOM結構下同時有兩個相同元件料號時,QPA要逐層乘出後,最後壘加
    #LET g_sql = "UPDATE ds_report.",l_table CLIPPED,
    LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED, #TQC-A40116 mod
               "   SET bmb06 = bmb06 + ? ",
               " WHERE bmb01 = ? ",
               "   AND bmb03 = ? ",     #MOD-B20154 add
               "   AND bmb29 = ? "
    PREPARE update_qpa_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
    #MOD-920274.........end
 
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.arrange  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--   
   CALL r812_create_tmp()
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r812_tm(0,0)			# Input print condition
      ELSE CALL r812()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r812_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_flag        SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bmb03       LIKE bmb_file.bmb01,
            l_cmd	  VARCHAR(1000)
 
 
   LET p_row = 4
   LET p_col = 9
 
   OPEN WINDOW r812_w AT p_row,p_col WITH FORM "abm/42f/abmr812"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL	
   LET tm.arrange ='1'
   LET tm.effective = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmb03,ima06 FROM item,class
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
   #--No.FUN-4B0022-------
   ON ACTION CONTROLP
     CASE WHEN INFIELD(item)      #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ima3"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
     OTHERWISE EXIT CASE
     END CASE
   #--END---------------
   ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CLOSE WINDOW r812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT bmb03) , bmb03 ",
                   " FROM bmb_file,ima_file",
                   " WHERE bmb03=ima01 AND ima08 !='A' AND ",
                   tm.wc CLIPPED," GROUP BY bmb03 "
         PREPARE r812_cnt_pre FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P0:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE r812_cnt CURSOR FOR r812_cnt_pre
         FOREACH r812_cnt INTO g_cnt,l_bmb03
            IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
               CALL cl_err(g_cnt,'mfg2601',0)
               CONTINUE WHILE
            ELSE
               #LET g_cnt=sqlca.sqlerrd[3]
               IF g_cnt=1 THEN
                  LET l_one='Y'
               END IF
            END IF
         END FOREACH
      END IF
      INPUT BY NAME tm.revision,tm.effective,tm.arrange,tm.more WITHOUT DEFAULTS
 
         BEFORE FIELD revision
            IF l_one='N' THEN
               NEXT FIELD effective
            END IF
 
         AFTER FIELD revision
            IF tm.revision IS NOT NULL THEN
               CALL s_version(l_bmb03,tm.revision)
               RETURNING l_bdate,l_edate,l_flag
               LET tm.effective = l_bdate
               DISPLAY BY NAME tm.effective
            END IF
 
         AFTER FIELD arrange
            IF tm.arrange NOT MATCHES '[12]' THEN
               NEXT FIELD arrange
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON ACTION CONTROLP
            CALL r812_wc()   # Input detail Where Condition
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
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
         CLOSE WINDOW r812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr812'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('abmr812','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.arrange CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr812',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r812_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r812()
      ERROR ""
   END WHILE
   CLOSE WINDOW r812_w
END FUNCTION
 
FUNCTION r812_wc()
#   DEFINE l_wc VARCHAR(500)
   DEFINE l_wc  STRING           #NO.FUN-910082 
   OPEN WINDOW r812_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi600")
 
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmb02,bmb03,bmb04,bmb05,bmb10,bmb06,bmb07,bmb08,
        bmauser,bmagrup,bmamodu,bmadate
        FROM
        bma01,bma04,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
        s_bmb[1].bmb10,s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,
        bmauser,bmagrup,bmamodu,bmadate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
   CLOSE WINDOW r812_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# r812()      從單身讀取合乎條件的元件資料
# r812_bom()  處理主件及其相關的展開資料
#-----------------------------------------------------------------
FUNCTION r812()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Usima time for running the job
          l_sql  VARCHAR(1000),		# RDSQL STATEMENT
          l_za05 VARCHAR(40),
          l_bmb03 LIKE bmb_file.bmb03           #元件料件
   DEFINE l_bmb29 LIKE bmb_file.bmb29           #No.MOD-7B0058
 
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
#     LET l_sql = "SELECT UNIQUE bmb03",            #No.MOD-7B0058
     LET l_sql = "SELECT UNIQUE bmb03,bmb29",       #No.MOD-7B0058
                 " FROM bmb_file, ima_file",
                 " WHERE ima01 = bmb03",
                 " AND ima08 !='A' AND ",tm.wc
     PREPARE r812_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r812_c1 CURSOR FOR r812_prepare1
 
#    CALL cl_outnam('abmr812') RETURNING l_name                   #FUN-780018
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-780018 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-780018 add ###                                              
     #------------------------------ CR (2) ------------------------------# 
#    START REPORT r812_rep TO l_name                              #FUN-780018
 
	LET g_tot=0
#     FOREACH r812_c1 INTO l_bmb03                  #No.MOD-7B0058
     FOREACH r812_c1 INTO l_bmb03,l_bmb29           #No.MOD-7B0058
       IF SQLCA.sqlcode THEN
		 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       LET g_bmb03_a=l_bmb03
       DELETE FROM abmr812_tmp
# Prog. Version..: '5.30.06-13.03.12(0,l_bmb03)                    #No.MOD-7B0058
       CALL r812_bom(0,l_bmb03,l_bmb29,1)           #No.MOD-7B0058 
     END FOREACH
 
    #DISPLAY "" AT 2,1
#    FINISH REPORT r812_rep                                       #FUN-780018
###--No.FUN-780018-BEGIN--                                                                                                          
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'bmb03,ima06')                                                                                         
              RETURNING tm.wc                                                                                                       
      END IF                                                                                                                        
###--No.FUN-780018-END--   
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                   #FUN-780018
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-780018 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.arrange,";",tm.effective,";",tm.wc,";",g_sma.sma888[1,1]                                             
    CALL cl_prt_cs3('abmr812','abmr812',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#        
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
END FUNCTION
 
#FUNCTION r812_bom(p_level,p_key)                          #No.MOD-7B0058
#FUNCTION r812_bom(p_level,p_key,p_acode)             #No.MOD-7B0058  #MOD-920274
FUNCTION r812_bom(p_level,p_key,p_acode,p_qpa)                   #MOD-920274
   DEFINE p_level	SMALLINT,
          p_key		LIKE bma_file.bma01,  #元件料件編號
          l_ac,i	SMALLINT,
          p_qpa   LIKE bmb_file.bmb06,  #MOD-920274
          arrno		SMALLINT,	#BUFFER SIZE (可存筆數)
          b_seq		LIKE bmb_file.bmb02,#滿時,重新讀單身之起始序號
          l_chr	 VARCHAR(1),
          l_ima06 LIKE ima_file.ima06,    #分群碼
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb01 LIKE bmb_file.bmb01,    #主件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb03 LIKE bmb_file.bmb03,    #元件料件
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_cnt         INTEGER,
          l_cmd	 VARCHAR(1000)
   ###-No.FUN-780018-BEGIN--                                                                                                        
   DEFINE l_ima02 LIKE ima_file.ima02,    #品名                                                                                     
          l_ima021 LIKE ima_file.ima021,  #規格                                                                                     
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima08 LIKE ima_file.ima08,    #來源                                                                                     
          l_ima15 LIKE ima_file.ima15,    #保稅否                                                                                   
          l_ima25 LIKE ima_file.ima25,    #庫存單位                                                                                 
          l_ima55 LIKE ima_file.ima55,    #生產單位                                                                                 
          l_ima63 LIKE ima_file.ima63,    #發料單位   
          l_point  VARCHAR(20),
          l_p      SMALLINT
   DEFINE r_ima02     LIKE ima_file.ima02                                                                                            
   DEFINE r_ima021    LIKE ima_file.ima021                                                                               
   ###-No.FUN-780018-END-- 
   DEFINE p_acode     LIKE bmb_file.bmb29 #No.MOD-7B0058     
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.TQC-8C0063 
   DEFINE l_bmb06     LIKE bmb_file.bmb06
 
    IF p_level > 25 THEN
       CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
        LET sr[1].bmb29 = p_acode               #No.MOD-7B0058
    #   OUTPUT TO REPORT r812_rep(1,0,sr[1].*)	#第0階主件資料
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb01,ima02,ima05,ima08,",
            "bmb02,(bmb06/bmb07),bmb10,bmb04,bmb05,bmb03,bmb29", #FUN-550093
#            " FROM bmb_file,ima_file",                          #No.MOD-7B0058
            " FROM bmb_file,ima_file,bma_file",                  #No.MOD-7B0058
            " WHERE bmb03='", p_key,"' AND bmb02 >",b_seq,
            " AND bmb01 = ima01 ",
            " AND bmb01 = bma01 ",                               #No.MOD-7B0058 add
            " AND bmb29 = '",p_acode,"'",                        #No.MOD-7B0058 add
            " AND bma06 = '",p_acode,"'"                         #No.MOD-7B0058 add
        #---->生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
        END IF
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY"
        IF tm.arrange='1' THEN
            LET l_cmd=l_cmd CLIPPED," bmb01"
        ELSE
            LET l_cmd=l_cmd CLIPPED," bmb02"
        END IF
        PREPARE r812_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
           EXIT PROGRAM 
        END IF
        DECLARE r812_cur CURSOR for r812_ppp
 
        LET l_ac = 1
        FOREACH r812_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
           #TQC-8C0063--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb01
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #TQC-8C0063--END-- 
           LET sr[l_ac].bmb06 = p_qpa * sr[l_ac].bmb06 #MOD-920274 逐層壘乘 QPA
           LET g_tot=g_tot+1
           LET l_ac = l_ac + 1			# 但BUFFER不宜太大
           IF l_ac >= arrno THEN 
              EXIT FOREACH
           END IF
        END FOREACH
         LET l_cmd= "SELECT COUNT(*) ",
#                    " FROM bmb_file,ima_file",                #No.MOD-7B0058
                    " FROM bmb_file,ima_file,bma_file",        #No.MOD-7B0058
                    " WHERE bmb03= ? ",#"' AND bmb02 >",b_seq,
                    " AND bmb01 = ima01",
                    " AND bmb01 = bma01",                      #No.FUN-7B0058 add
                    " AND bma06 = '",p_acode,"'",              #No.MOD-7B0058 add
                    " AND bmb29 = '",p_acode,"'"               #No.MOD-7B0058 add
 
         #---->生效日及失效日的判斷
         IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
         END IF
         PREPARE r812_ttt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P1:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM 
         END IF
         DECLARE r812_cux CURSOR for r812_ttt
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
          ###--No.FUN-780018--BEGIN--                                                                                               
    #            IF p_level> 10 THEN LET p_level=10 END IF                                                                          
    #            LET l_point = ' '                                                                                                  
    #            IF p_level > 1 THEN                                                                                                
    #               FOR l_p = 1 TO p_level - 1                                                                                      
    #                   LET l_point = l_point clipped,'.'                                                                           
    #               END FOR                                                                                                         
    #            END IF                                                                                                             
          ###--No.FUN-780018-END-- 
            LET l_cnt = 0
     ##1999/10/04 modify
            OPEN r812_cux USING sr[i].bmb01
            FETCH r812_cux INTO l_cnt
            IF l_cnt <= 0 THEN
               SELECT COUNT(*) INTO g_cnt FROM abmr812_tmp
                WHERE bmb01=sr[i].bmb01
                  AND bmb29=sr[i].bmb29       #No.MOD-7B0058 add
                # AND bmb03=sr[i].bmb03
               IF g_cnt = 0 THEN
#                  INSERT INTO abmr812_tmp VALUES (sr[i].bmb01,sr[i].bmb03)            #No.MOD-7B0058
                  INSERT INTO abmr812_tmp VALUES (sr[i].bmb01,sr[i].bmb03,sr[i].bmb29) #No.MOD-7B0058
                  #No.FUN-780018---Begin#add by sherry 
                  SELECT ima02,ima021,ima05,ima06,                                          
                         ima08,ima15,ima25,ima55,ima63                                      
                   INTO l_ima02,l_ima021,l_ima05,l_ima06,                                   
                        l_ima08,l_ima15,l_ima25,l_ima55,l_ima63                             
                   FROM ima_file                                                            
                  WHERE ima01=g_bmb03_a                                                     
                   IF SQLCA.sqlcode THEN                                                     
                      LET l_ima02='' LET l_ima021='' LET l_ima05=''                         
                      LET l_ima06='' LET l_ima08=''                                         
                      LET l_ima55='' LET l_ima63=''                                         
                   END IF 
                  SELECT  ima02,ima021 INTO r_ima02,r_ima021 FROM ima_file              
                    WHERE ima01 = sr[i].bmb01 
 
                  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                            
                  LET l_cnt = l_cnt + 1 
                  EXECUTE insert_prep USING                                               
                          g_bmb03_a,p_level,i,l_point,l_ima08,l_ima06,l_ima25,                   
                          l_ima02,l_ima63,l_ima021,l_ima15,                            
                          sr[i].bmb01,r_ima02,r_ima021,sr[i].bmb29,sr[i].ima05,        
                          sr[i].ima08,sr[i].bmb06,sr[i].bmb10,sr[i].bmb02,l_cnt,
                          p_acode
               #MOD-920274.............begin同一主件BOM下,有兩個以上的相同元件,需壘加QPA
               ELSE
                  EXECUTE update_qpa_prep USING
                          sr[i].bmb06,sr[i].bmb01,sr[i].bmb03,sr[i].bmb29     #MOD-B20154 add bmb03
               #MOD-920274.............end
               END IF
            ELSE
               CALL r812_bom(p_level,sr[i].bmb01,l_ima910[i],sr[i].bmb06) #No.MOD-7B0058  #TQC-8C0063  #MOD-920274
            END IF
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb03
        END IF
    END WHILE
END FUNCTION
 
{REPORT r812_rep(p_bmb03,p_level,p_i,sr)                           #FUN-780018
   DEFINE l_last_sw VARCHAR(1),
          p_level,p_i	SMALLINT,
          p_bmb03       LIKE bmb_file.bmb03,
          sr  RECORD
              bmb01 LIKE bmb_file.bmb01,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb03 LIKE bmb_file.bmb03,
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima021,  #FUN-510033
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima15 LIKE ima_file.ima15,    #保稅否
          l_ima25 LIKE ima_file.ima25,    #庫存單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_point  VARCHAR(10),
          l_p      SMALLINT,
          l_str2   VARCHAR(10),
          l_cnt    SMALLINT,
          l_k      SMALLINT
  DEFINE r_ima02     LIKE ima_file.ima02
  DEFINE r_ima021    LIKE ima_file.ima021
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 #ORDER BY sr.bmb01
  FORMAT
   PAGE HEADER
      SELECT ima02,ima021,ima05,ima06,
             ima08,ima15,ima25,ima55,ima63
       INTO l_ima02,l_ima021,l_ima05,l_ima06,
            l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
       FROM ima_file
      WHERE ima01=g_bmb03_a
      IF SQLCA.sqlcode THEN
          LET l_ima02='' LET l_ima021='' LET l_ima05=''
          LET l_ima06='' LET l_ima08=''
          LET l_ima55='' LET l_ima63=''
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT                                         #No.FUN-6C0014   
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT COLUMN (g_len-17)/2,g_x[23] CLIPPED,tm.effective    #TQC-6B0096
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN 35,g_x[23] CLIPPED,tm.effective    #TQC-6B0096
      PRINT g_dash[1,g_len]
 
#-----No.TQC-5B0107 modify    #&051112
      PRINT COLUMN  1,g_x[11] CLIPPED, g_bmb03_a CLIPPED,
            COLUMN 60,g_x[20] clipped,l_ima08,           #來源
            COLUMN 70,g_x[21] clipped,l_ima06,           #分群碼 #MOD-640206
            COLUMN 90,g_x[14] CLIPPED,l_ima25 CLIPPED    #庫存單位
      PRINT COLUMN  1,g_x[12] CLIPPED,l_ima02 CLIPPED, 
            COLUMN 90,g_x[13] CLIPPED,l_ima63 CLIPPED   #發料單位
      PRINT COLUMN  1,g_x[15] CLIPPED,l_ima021 CLIPPED
#-----No.TQC-5B0107 end
 
      IF g_sma.sma888[1,1] = 'Y'
      THEN PRINT g_x[22] clipped,l_ima15
      ELSE PRINT ''
      END IF
      PRINT ' '
      PRINT g_x[31],g_x[32],g_x[33],g_x[38],g_x[34],g_x[35],g_x[36],g_x[37] #FUN-550093
      PRINT g_dash1
      LET l_last_sw = 'n'
 
  BEFORE GROUP OF p_bmb03
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
          SELECT  ima02,ima021 INTO r_ima02,r_ima021 FROM ima_file
                    WHERE ima01 = sr.bmb01
 
#No.TQC-6B0096 --begin
#         PRINT COLUMN g_c[31],sr.bmb01 clipped,
#               COLUMN g_c[32],r_ima02,
#               COLUMN g_c[33],r_ima021 CLIPPED,  #MOD-4A0238
          PRINT COLUMN g_c[31],sr.bmb01[1,30],
                COLUMN g_c[32],r_ima02[1,30],
                COLUMN g_c[33],r_ima021[1,30],  #MOD-4A0238
#No.TQC-6B0096 --end
                COLUMN g_c[38],sr.bmb29,
                COLUMN g_c[34],sr.ima05,
                COLUMN g_c[35],sr.ima08,
                COLUMN g_c[36],cl_numfor(sr.bmb06,36,3),
                COLUMN g_c[37],sr.bmb10
 
          IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
          LET l_cnt = l_cnt + 1
 
   ON LAST ROW
#No.FUN-6C0014--begin
      NEED 6 LINES
      PRINT
      PRINT COLUMN g_c[35],g_x[27] CLIPPED,                     #TQC-5C0068
            COLUMN g_c[36],cl_numfor(l_cnt,36,0)                #TQC-5C0068
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bmb03,ima06')                   
              RETURNING tm.wc                                                   
         PRINT g_dash[1,g_len]
         CALL cl_prt_pos_wc(tm.wc)
      END IF                                                                    
      PRINT g_dash[1,g_len]                                                     
#No.FUN-6C0014--end
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.TQC-5B0030 modify
 
   PAGE TRAILER
#No.FUN-6C0014--begin
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED  #No.TQC-5B0030 modify
      ELSE
         SKIP 2 LINE
      END IF
#No.FUN-6C0014--end
END REPORT}                                                              #FUN-780018
 
FUNCTION r812_create_tmp()
 
 DROP TABLE abmr812_tmp
 CREATE TEMP TABLE abmr812_tmp(
    bmb01     LIKE bmb_file.bmb01,     #No.FUN-560074
    bmb03     LIKE bmb_file.bmb03,     #No.FUN-560074
    bmb29     LIKE bmb_file.bmb29 )    #No.MOD-7B0058
 
END FUNCTION
