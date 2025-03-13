# Prog. Version..: '5.30.06-13.04.02(00004)'     #
#
# Prog. Versi/n..: '5.00.02-07.06.21(00000)'     #
#
# Pattern name...: abmr810.4gl
# Descriptions...: 單階產品結構用途查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/08/07 By Wu
# Modify.........: 92/10/27 By Apple
# Modify.........: 93/04/30 By Apple
# Modify.........: No:8379 03/10/01 By Melody ima的欄位下QBE條件時,會出現-324的錯誤訊息,因 OUTER用法特殊,應改掉
# Modify.........: No.FUN-4B0001 04/11/01 By Smapmin 元件編號開窗
# Modify.........: No.FUN-510033 05/01/20 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/05/30 By kim 配方BOM
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.MOD-660077 06/06/20 By claire q_bma03 -> q_bmb203
# Modify.........: No.FUN-670041 06/07/27 By Pengu 1.將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq610->abmr810 
# Modify.........: No.FUN-780018 07/07/08 By xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-A40116 10/04/26 By liuxqa modify sql
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: NO.CHI-B80027 13/01/22 By Alberti 報表未撈出規格資料

 
DATABASE ds
#CHI-6A0034 add
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
        		wc  	  VARCHAR(500),		# Where condition
   	        	class	  VARCHAR(04),		# 分群碼
   	        	effective DATE,   		# 有效日期
           		arrange   VARCHAR(1),		# 資料排列方式
                blow      VARCHAR(1),
           		more	  VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD,
          g_bmb03 LIKE bmb_file.bmb03,
          g_ima02 LIKE ima_file.ima02,    #品名規格
          g_ima05 LIKE ima_file.ima05,    #版本
          g_ima06 LIKE ima_file.ima06,    #分群碼
          g_ima08 LIKE ima_file.ima08,    #來源
          g_ima15 LIKE ima_file.ima15,    #保稅否
          g_ima37 LIKE ima_file.ima37,    #補貨
          g_ima25 LIKE ima_file.ima25,
          g_ima63 LIKE ima_file.ima63,
          g_bmb29 LIKE bmb_file.bmb29 #FUN-550093
 
DEFINE   g_i             SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING,              ### FUN-780018 ###                                                             
         g_str           STRING,              ### FUN-780018 ### 
         g_sql           STRING               ### FUN-780018 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
## *** FUN-780018 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "bmb03.bmb_file.bmb03,",                                                                                            
                "ima08.ima_file.ima08,",                                                                                            
                "ima06.ima_file.ima06,",                                                                                            
                "ima25.ima_file.ima25,",                                                                                            
                "ima02.ima_file.ima02,",                                                                                            
                "ima63.ima_file.ima63,",                                                                                            
                "ima021.ima_file.ima021,",                                                                                          
                "ima15.ima_file.ima15,",                                                                                            
                "bmb01.bmb_file.bmb01,",                                                                                            
                "bmb29.bmb_file.bmb29,",                                                                                            
                "ima02s.ima_file.ima02,",                                                                                           
                "ima021s.ima_file.ima021,",                                                                                         
                "ima05.ima_file.ima05,",                                                                                            
                "ima08s.ima_file.ima08,",                                                                                           
                "bmb06.bmb_file.bmb06,",                                                                                            
                "bmb10.bmb_file.bmb10,",                                                                                            
                "bmb02.bmb_file.bmb02"                                                                                              
    LET l_table = cl_prt_temptable('abmr810',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                           
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,   #TQC-A40116 mod                                                                        
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,                                                                                 
                         ?, ?, ?, ?, ?, ?, ?, ?)" 
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)		        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.class  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.arrange  = ARG_VAL(10)
   LET tm.blow     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r810_tm(0,0)			# Input print condition
      ELSE CALL abmr810()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r810_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_flag        SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bmb01       LIKE bmb_file.bmb01,
            l_bmb03       LIKE bmb_file.bmb03,
            l_ima06       LIKE ima_file.ima06,
            l_cmd	  VARCHAR(1000)
 
 
   LET p_row = 4
   LET p_col = 9
 
   OPEN WINDOW r810_w AT p_row,p_col WITH FORM "abm/42f/abmr810"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.arrange ='1'              #按元件料件編號遞增順序排列
   LET tm.effective = g_today	    #有效日期
  #-------No.FUN-670041 modify
  #LET tm.blow      = g_sma.sma29
   LET tm.blow      = 'Y'
  #-------No.FUN-670041 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bmb03,ima06,ima09,ima10,ima11,ima12
           FROM item,class,ima09,ima10,ima11,ima12
 
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
 
         ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         ON ACTION CONTROLP    #FUN-4B0001
            IF INFIELD(item) THEN
               CALL cl_init_qry_var()
              #LET g_qryparam.form     = "q_bma3"     #MOD-660077 mark
               LET g_qryparam.form     = "q_bmb203"   #MOD-660077
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
            END IF
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r810_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT bmb01,ima06 FROM bmb_file,ima_file",
                   " WHERE bmb03 = ima01 AND ",tm.wc CLIPPED
         PREPARE r810_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE r810_cnt
         CURSOR FOR r810_precnt
         MESSAGE " SEARCHING ! "
         FOREACH r810_cnt INTO l_bmb01,l_ima06
            IF SQLCA.sqlcode  THEN
               CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
               CONTINUE WHILE
            ELSE
               LET l_one = 'Y'
               EXIT FOREACH
            END IF
         END FOREACH
         MESSAGE " "
         IF l_bmb01 IS NULL OR l_bmb01 = ' ' THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         END IF
      END IF
 
      INPUT BY NAME tm.effective,tm.arrange,tm.blow,tm.more WITHOUT DEFAULTS
 
         AFTER FIELD arrange
            IF tm.arrange NOT MATCHES '[12]' THEN
               NEXT FIELD arrange
            END IF
 
         AFTER FIELD blow
            IF tm.blow IS NULL OR tm.blow NOT MATCHES '[YNyn]' THEN
               NEXT FIELD blow
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
            CALL r810_wc()   # Input detail Where Condition
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
         CLOSE WINDOW r810_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr810'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmr810','9031',1)
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
                            " '",tm.class CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.arrange CLIPPED,"'",
                            " '",tm.blow    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr810',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r810_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abmr810()
      ERROR ""
   END WHILE
   CLOSE WINDOW r810_w
END FUNCTION
 
FUNCTION r810_wc()
#   DEFINE l_wc VARCHAR(500)
   DEFINE l_wc  STRING           #NO.FUN-910082          
   OPEN WINDOW r810_w2 AT 2,2
        WITH FORM "abm/42f/abmi610"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi610")
 
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bma02,bma03,
        bmb02,bmb03,bmb06,bmb08,bmb14,bmb15,bmb16,bmb17,bmb07,bmb09
        FROM
        bma01,bma04,bma02,bma03,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb06,s_bmb[1].bmb08,
        s_bmb[1].bmb14,s_bmb[1].bmb15,s_bmb[1].bmb16,s_bmb[1].bmb17,
        s_bmb[1].bmb07,s_bmb[1].bmb09
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
 
   CLOSE WINDOW r810_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
END FUNCTION
 
FUNCTION r810_cur()
DEFINE l_sql  VARCHAR(1000)
 
#    LET l_sql = "SELECT '',",
#                " bma01, bmb02, bmb03, bmb06/bmb07,bmb10,'',",
#                " A.ima02, A.ima05, A.ima06, A.ima08, A.ima15,",
#                " A.ima37, A.ima25, A.ima63,",
#                " B.ima02,B.ima05,B.ima08 ",
#                " FROM bmb_file, OUTER ima_file A,",
#                "      bma_file, OUTER ima_file B ",
#                " WHERE bma01=bmb01",
#                "   AND bmb03 = A.ima01 AND bma01 = B.ima01 ",
#                "   AND bmb03 = ? "
#No:8379
     LET l_sql = "SELECT '',",
                 " bma01, bmb02, bmb03, bmb06/bmb07,bmb10,'',",
                 " ima02, ima05, ima06, ima08, ima15,",
                 " ima37, ima25, ima63,bmb29, '','','','' ", #FUN-550093
                 " FROM bmb_file, OUTER ima_file, bma_file ",  #No:8379
                 " WHERE bma01=bmb01 ",
                 "   AND bmb_file.bmb03 = ima_file.ima01 AND bmb03 = ? ",
                 "   AND bmb29=bma06" #FUN-550093
#No:8379(end)
 
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
          LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
          "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
          "' OR bmb05 IS NULL)"
     END IF
     PREPARE r810_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r810_cs2 CURSOR WITH HOLD FOR r810_prepare2
END FUNCTION
 
FUNCTION r810_phatom(p_phatom,p_qpa)
   DEFINE p_phatom  LIKE bmb_file.bmb01,
          p_qpa     LIKE bmb_file.bmb06,
          l_ac,l_i  SMALLINT,
          l_tot,l_times SMALLINT,
          arrno		SMALLINT,	#BUFFER SIZE (可存筆數)
          b_seq		SMALLINT,	#當BUFFER滿時,重新讀單身之起始序號
          l_chr	 VARCHAR(1),
          l_ute_flag VARCHAR(2),
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              order1  VARCHAR(20),
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              phatom LIKE bmb_file.bmb01,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima25 LIKE ima_file.ima25,    #庫存單位
              ima63 LIKE ima_file.ima63,    #發料單位
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          sr2 DYNAMIC ARRAY OF RECORD       #每階存放資料
              ima02  LIKE ima_file.ima02,
              ima05  LIKE ima_file.ima05,
              ima08  LIKE ima_file.ima08,
              ima15  LIKE ima_file.ima15
          END RECORD,
          l_bmb01  LIKE bmb_file.bmb01
   DEFINE l_ima021      LIKE ima_file.ima021 #FUN-780018                                                                            
   DEFINE l_ima021_s    LIKE ima_file.ima021 #FUN-780018
 
    LET l_ac = 1
    LET arrno = 600
    LET l_ute_flag='US'
    FOREACH r810_cs2 USING p_phatom INTO sr[l_ac].*,sr2[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      #-----No:8379
      SELECT ima02,ima05,ima08,ima15
        INTO sr2[l_ac].ima02,sr2[l_ac].ima05, sr2[l_ac].ima08, sr2[l_ac].ima15
        FROM bma_file,OUTER ima_file
       WHERE bma01 = sr[l_ac].bmb01
         AND bma_file.bma01 = ima_file.ima01
      IF STATUS THEN
         LET sr2[l_ac].ima02=' '
         LET sr2[l_ac].ima05=' '
         LET sr2[l_ac].ima08=' '
         LET sr2[l_ac].ima15=' '
      END IF
      #-----
 
      LET sr[l_ac].phatom = p_phatom
      LET sr[l_ac].bmb06= sr[l_ac].bmb06 * p_qpa
      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
#      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
	LET l_tot=l_ac-1
    FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
        IF sr2[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
           CALL r810_phatom(sr[l_i].bmb01,sr[l_i].bmb06)
           CONTINUE FOR
        END IF
        IF tm.arrange='1' THEN
            LET sr[l_i].order1=sr[l_i].bmb01
        ELSE
            LET sr[l_i].order1=sr[l_i].bmb02
        END IF
        LET sr[l_i].bmb03= g_bmb03
        LET sr[l_i].ima02= g_ima02
        LET sr[l_i].ima05= g_ima05
        LET sr[l_i].ima06= g_ima06
        LET sr[l_i].ima08= g_ima08
        LET sr[l_i].ima15= g_ima15
        LET sr[l_i].ima37= g_ima37
        LET sr[l_i].ima25= g_ima25
        LET sr[l_i].ima37= g_ima37
        LET sr[l_i].ima25= g_ima25
        LET sr[l_i].ima63= g_ima63
        LET sr[l_i].bmb29= g_bmb29
#       OUTPUT TO REPORT r810_rep(sr[l_i].*,sr2[l_i].*)                    #FUN-780018
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-780018 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr[l_i].bmb03,sr[l_i].ima08,sr[l_i].ima06,sr[l_i].ima25,sr[l_i].ima02,
                   sr[l_i].ima63,l_ima021_s,sr[l_i].ima15,                                       
                   sr[l_i].bmb01,sr[l_i].bmb29,sr2[l_i].ima02,l_ima021,
                   sr2[l_i].ima05,sr2[l_i].ima08,sr[l_i].bmb06,sr[l_i].bmb10,                                      
                   sr[l_i].bmb02                                                                                                         
        #------------------------------ CR (3) ------------------------------# 
    END FOR
END FUNCTION
 
FUNCTION abmr810()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Used time for running the job
          l_sql  VARCHAR(1000),		# RDSQL STATEMENT
          l_za05 VARCHAR(40),
          sr  RECORD
              order1  VARCHAR(20),
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              phatom LIKE bmb_file.bmb01,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,   #規格      #CHI-B80027 add
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima25 LIKE ima_file.ima25,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          sr2 RECORD
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,   #CHI-B80027 add
              ima05  LIKE ima_file.ima05,
              ima08  LIKE ima_file.ima08,
              ima15  LIKE ima_file.ima15
          END RECORD
 
   DEFINE l_ima021      LIKE ima_file.ima021 #FUN-780018                                                                            
   DEFINE l_ima021_s    LIKE ima_file.ima021 #FUN-780018 

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
 
#    LET l_sql = "SELECT '',",
#                " bma01, bmb02, bmb03, bmb06/bmb07,bmb10,'',",
#                " A.ima02, A.ima05, A.ima06, A.ima08, A.ima15,",
#                " A.ima37, A.ima25, A.ima63,",
#                " B.ima02,B.ima05,B.ima08 ",
#                " FROM bmb_file, OUTER ima_file A,",
#                "      bma_file, OUTER ima_file B ",
#                " WHERE bma01=bmb01 AND ",
#                " bmb03 = A.ima01 AND bma01 = B.ima01 ",
#                " AND ",tm.wc
#No:8379
  LET l_sql = "SELECT '',",
                 " bma01, bmb02, bmb03, bmb06/bmb07,bmb10,'',",
                 " ima02,ima021, ima05, ima06, ima08, ima15,",       #CHI-B80027 add ima021
                 " ima37, ima25, ima63,bmb29, '','','','' ",  #FUN-550093
                 " FROM bmb_file, OUTER ima_file, bma_file ",   #No:8379
                 " WHERE bma01=bmb01 AND bmb_file.bmb03 = ima_file.ima01 ",
                 " AND bmb29=bma06", #FUN-550093
                 " AND ",tm.wc
#No:8379(end)
 
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
          LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
                   "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
                   "' OR bmb05 IS NULL)"
     END IF
     PREPARE r810_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r810_curs1 CURSOR FOR r810_prepare1
 
#    CALL cl_outnam('abmr810') RETURNING l_name               #FUN-780018
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-780018 *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-780018 add ###                                              
     #------------------------------ CR (2) ------------------------------# 
#    START REPORT r810_rep TO l_name                          #FUN-780018
     CALL r810_cur()
# genero  script marked      LET g_pageno = 0
     FOREACH r810_curs1 INTO sr.*,sr2.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #-----No:8379
       SELECT ima02, ima021,ima05,ima08,ima15                           #CHI-B80027 add ima021
         INTO sr2.ima02, sr2.ima021,sr2.ima05, sr2.ima08, sr2.ima15     #CHI-B80027 add sr2.ima021
         FROM bma_file,OUTER ima_file
        WHERE bma01 = sr.bmb01
          AND bma_file.bma01 = ima_file.ima01
       IF STATUS THEN
          LET sr2.ima02=' '
          LET sr2.ima05=' '
          LET sr2.ima08=' '
          LET sr2.ima15=' '
       END IF
      #-----
          LET l_ima021_s = sr.ima021    #CHI-B80027 add
          LET l_ima021   = sr2.ima021   #CHI-B80027 add
 
       IF sr2.ima08 = 'X' AND tm.blow = 'Y' THEN
          LET g_bmb03 = sr.bmb03
          LET g_ima02 = sr.ima02
          LET g_ima05 = sr.ima05
          LET g_ima06 = sr.ima06
          LET g_ima08 = sr.ima08
          LET g_ima15 = sr.ima15
          LET g_ima37 = sr.ima37
          LET g_ima25 = sr.ima25
          LET g_ima63 = sr.ima63
          LET g_bmb29 = sr.bmb29 #FUN-550093
          CALL r810_phatom(sr.bmb01,sr.bmb06)
          CONTINUE FOREACH
       END IF
       IF tm.arrange='1' THEN
           LET sr.order1=sr.bmb01
       ELSE
           LET sr.order1=sr.bmb02
       END IF
#      OUTPUT TO REPORT r810_rep(sr.*,sr2.*)                   #FUN-780018
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-780018 *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.bmb03,sr.ima08,sr.ima06,sr.ima25,sr.ima02,sr.ima63,l_ima021_s,sr.ima15,                                                           
                   sr.bmb01,sr.bmb29,sr2.ima02,l_ima021,sr2.ima05,sr2.ima08,sr.bmb06,sr.bmb10,
                   sr.bmb02                                                            
        #------------------------------ CR (3) ------------------------------#  
     END FOREACH
 
    #DISPLAY "" AT 2,1
#    FINISH REPORT r810_rep                                              #FUN-780018
 
         CALL cl_wcchp(tm.wc,'bmb03,ima06,ima09,ima10')                                                                             
              RETURNING tm.wc                                      
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                         #FUN-780018
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-780018 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = '' 
    LET g_str = tm.arrange,";",tm.effective,";",tm.wc,";",g_sma.sma888[1,1]                                                                                                                 
    CALL cl_prt_cs3('abmr810','abmr810',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#       
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
     #No.FUN-B80100--mark--End-----
END FUNCTION
 
{REPORT r810_rep(sr,sr2)                     #FUN-780018
   DEFINE l_ima021      LIKE ima_file.ima021 #FUN-510033
   DEFINE l_ima021_s    LIKE ima_file.ima021 #FUN-510033
   DEFINE l_last_sw VARCHAR(1),
          sr  RECORD
              order1  VARCHAR(20),
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              phatom LIKE bmb_file.bmb01,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37,    #補貨
              ima25 LIKE ima_file.ima25,    #庫存單位
              ima63 LIKE ima_file.ima63,    #發料單位
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          sr2 RECORD
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15     #保稅否
          END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bmb03,sr.bmb29,sr.order1 #FUN-550093
  FORMAT
   PAGE HEADER
      SELECT ima021 INTO l_ima021_s
        FROM ima_file
       WHERE ima01 = sr.bmb03
      IF SQLCA.sqlcode THEN
          LET l_ima021_s = NULL
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
      PRINT                                                        #No.FUN-6C0014
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT g_x[22] clipped,tm.effective
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
 
#--------No.TQC-5B0107 modify  #&051112
      PRINT COLUMN  1,g_x[15] CLIPPED,sr.bmb03 CLIPPED,
            COLUMN 56,g_x[20] clipped,sr.ima08,   #來源
            COLUMN 63,g_x[21] clipped,sr.ima06,   #分群碼
            COLUMN 75,g_x[17] CLIPPED,sr.ima25 clipped
      PRINT COLUMN  1,g_x[16] CLIPPED,sr.ima02,
            COLUMN 75,g_x[18] CLIPPED,sr.ima63 clipped
      PRINT COLUMN  1,g_x[24] CLIPPED,l_ima021_s CLIPPED
#--------No.TQC-5B0107 end
 
      IF g_sma.sma888[1,1] ='Y' THEN
          PRINT g_x[23] clipped,sr.ima15
      ELSE
          PRINT ' '
      END IF
      PRINT
      PRINT g_x[31],g_x[38],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.bmb03
#FUN-550093................begin
#     IF (PAGENO > 1 OR LINENO > 13)
#        THEN SKIP TO TOP OF PAGE
#     END IF
      SKIP TO TOP OF PAGE
#FUN-550093................end
   ON EVERY ROW
      SELECT ima021 INTO l_ima021
        FROM ima_file
       WHERE ima01 = sr.bmb01
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[31],sr.bmb01,
            COLUMN g_c[38],sr.bmb29,
            COLUMN g_c[32],sr2.ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],sr2.ima05,
            COLUMN g_c[35],sr2.ima08,
            COLUMN g_c[36],cl_numfor(sr.bmb06,36,3),
            COLUMN g_c[37],sr.bmb10
 
   ON LAST ROW
#No.FUN-6C0014--begin
      NEED 4 LINES
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bmb03,ima06,ima09,ima10')                   
              RETURNING tm.wc                                                   
         PRINT g_dash[1,g_len]
         CALL cl_prt_pos_wc(tm.wc)
      END IF                                                                    
#No.FUN-6C0014--end
      PRINT g_dash[1,g_len]                                                     
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
       #----No.FUN-6C0014--begin
       #----No.TQC-5B0030 modify
         PRINT g_dash[1,g_len]                                                     
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
       ELSE
         SKIP 2 LINE
       #----No.FUN-6C0014--end
       #------end
      END IF
END REPORT}                                                            #FUN-780018
#Patch....NO.TQC-610035 <001> #
