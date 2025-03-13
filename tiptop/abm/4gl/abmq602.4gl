# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abmq602.4gl
# Descriptions...: 尾階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/07 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
# Modify.........: 92/10/28 By Apple
# Modify.......... 94/08/16 By Danny 改由bmt_file取插件位置
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.FUN-510033 05/02/17 By Mandy 報表轉XML
# Modify.........: No:FUN-550093 05/05/27 By kim 配方BOM
# Modify.........: No:FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No:TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No:TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整

# Modify.........: No:TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE

# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				  # Print condition RECORD
	    	wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
   	    	revision  LIKE aba_file.aba18,    #No.FUN-680096 VARCHAR(2)
       		effective LIKE type_file.dat,     #No.FUN-680096 DATE
          	a         LIKE type_file.num10,   #No.FUN-680096 INTEGER
           	s         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           	b         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
           	c         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
       		more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
            END RECORD,
		g_tot LIKE type_file.num10,       #No.FUN-680096 INTEGER
        g_bma01_a       LIKE bma_file.bma01,
        g_bma06         LIKE bma_file.bma06       #FUN-550093

DEFINE   g_chr          LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5       #count/index for any purpose  #No.FUN-680096 SMALLINT
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF


   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.b  = ARG_VAL(13)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q602_tm(0,0)			# Input print condition
      ELSE CALL q602()			# Read bmata and create out-file
   END IF
END MAIN

FUNCTION q602_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,      #No.FUN-680096 SMALLINT
            l_flag        LIKE type_file.num5,      #No.FUN-680096 SMALLINt
            l_one         LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bma01       LIKE bma_file.bma01,	    #
            l_bma06       LIKE bma_file.bma06,	    #FUN-550093
            l_cmd	  LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
            l_sql         STRING                    #FUN-550093


   IF p_row = 0 THEN
      LET p_row = 4
      LET p_col = 9
   END IF
   LET p_row = 4
   LET p_col = 9

   OPEN WINDOW q602_w AT p_row,p_col WITH FORM "abm/42f/abmq602"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.effective = g_today	#有效日期
   LET tm.a = 1
   LET tm.s = g_sma.sma65
   LET tm.c = 'N'
   LET tm.b = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT tm.wc ON bma01,ima06,ima09,ima10,ima11,ima12,bma06 FROM item,class,ima09,ima10,ima11,ima12,bma06
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
   #--No.FUN-4B0022-------
   ON ACTION CONTROLP
     CASE WHEN INFIELD(item)      #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_ima1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
     OTHERWISE EXIT CASE
     END CASE
   #--END---------------
   ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 

		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
END CONSTRUCT


      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW q602_w
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         #FUN-550093................begin
        #LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 ",
        #          " FROM bma_file,ima_file",
        #          " WHERE bma01=ima01 AND ima08 != 'A' AND ",
        #          tm.wc CLIPPED," GROUP BY bma01"
         LET l_cmd="SELECT DISTINCT bma01,bma06 ",
                   " FROM bma_file,ima_file",
                   " WHERE bma01=ima01 AND ima08 != 'A' AND ",
                   tm.wc CLIPPED," GROUP BY bma01,bma06"
         #FUN-550093................end
         PREPARE q602_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P0:',SQLCA.sqlcode,1)
            EXIT PROGRAM
         END IF
         DECLARE q602_cnt
         CURSOR FOR q602_precnt
         OPEN q602_cnt
         #FUN-550093................begin
        #FETCH q602_cnt INTO g_cnt,l_bma01
         FETCH q602_cnt INTO l_bma01,l_bma06
         DROP TABLE q602_cnttemp
#No.FUN-680096--------begin------------------------
         CREATE TEMP TABLE q602_cnttemp(
                    bma01   VARCHAR(40),
                    bma06   VARCHAR(20))
#No.FUN-680096----------end----------------------------
         LET l_sql="INSERT INTO q602_cnttemp (",l_cmd,")"
         PREPARE q602_cnttemp_sql FROM l_sql
         EXECUTE q602_cnttemp_sql
         SELECT COUNT(*) INTO g_cnt FROM q602_cnttemp
         #FUN-550093................end

         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2602',0)   
            CONTINUE WHILE
         ELSE
            #LET g_cnt=sqlca.sqlerrd[3]
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF

      INPUT BY NAME tm.revision,tm.effective,tm.a,
               tm.s,tm.c,tm.b,tm.more WITHOUT DEFAULTS
 
         BEFORE FIELD revision
            IF l_one='N' THEN
               NEXT FIELD effective
            END IF
 
         AFTER FIELD revision
            IF tm.revision IS NOT NULL THEN
               CALL s_version(l_bma01,tm.revision)
               RETURNING l_bdate,l_edate,l_flag
               LET tm.effective = l_bdate
               DISPLAY BY NAME tm.effective
            END IF
 
         AFTER FIELD a
            IF tm.a IS NULL OR tm.a < 0 THEN
               LET tm.a = 1
               DISPLAY BY NAME tm.a
            END IF
 
         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES'[1-3]' THEN
               NEXT FIELD s
            END IF

         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES'[YNyn]' THEN
               NEXT FIELD c
            END IF

         AFTER FIELD b
            IF tm.b IS NULL OR tm.b NOT MATCHES'[YNyn]' THEN
               NEXT FIELD b
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
         CLOSE WINDOW q602_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmq602'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('abmq602','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('abmq602',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW q602_w
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL q602()
      ERROR ""
   END WHILE
   CLOSE WINDOW q602_w
END FUNCTION

#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION q602()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_ute_flag    LIKE aba_file.aba18,     #No.FUN-680096 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)
          l_bma01       LIKE bma_file.bma01,     #主件料件
          l_bma06       LIKE bma_file.bma06      #FUN-550093

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同部門的資料
         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     END IF

    #FUN-550093................begin
    #LET l_sql = "SELECT bma01",
    #            " FROM bma_file, ima_file",
    #            " WHERE bma01 = ima01",
    #            " AND ",tm.wc,
    #            " ORDER BY 1 "
     LET l_sql = "SELECT bma01,bma06",
                 " FROM bma_file, ima_file",
                 " WHERE bma01 = ima01",
                 " AND ",tm.wc,
                 " ORDER BY bma01,bma06 "
    #FUN-550093................begin
     PREPARE q602_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
		CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM END IF
     DECLARE q602_c1 CURSOR FOR q602_prepare1

     CALL cl_outnam('abmq602') RETURNING l_name
   	START REPORT q602_rep TO l_name
 
    CALL q602_cur()
	LET g_tot=0
    FOREACH q602_c1 INTO l_bma01,l_bma06
      IF SQLCA.sqlcode THEN
			 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_bma01_a=l_bma01
      LET g_bma06  =l_bma06
      CALL q602_bom(0,l_bma01,tm.a,l_bma06)
    END FOREACH

   FINISH REPORT q602_rep
            LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION

FUNCTION q602_bom(p_level,p_key,p_total,p_acode)
   DEFINE p_level	LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          p_total       LIKE csa_file.csa0301,    #No.FUN-680096 DEC(13,5)
          p_acode       LIKE bma_file.bma06,
          l_total       LIKE csa_file.csa0301,    #No.FUN-680096 DEC(13,5)
          p_key		LIKE bma_file.bma01,      #主件料件編號
          l_ac,i	LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num10,     #No.FUN-680096 INTEGER
          l_chr,l_cnt   LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301,    #No.FUN-680096 DEC(13,5)
          l_ima06 LIKE ima_file.ima06,    #分群碼
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              order1 LIKE bmb_file.bmb02,   #No.FUN-680096 VARCHAR(20)
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb14 LIKE bmb_file.bmb14,    #
              bmb15 LIKE bmb_file.bmb15,    #
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb17 LIKE bmb_file.bmb17,    #
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
              rowid_no   LIKE type_file.chr18,   #No.FUN-680096 INT
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_cmd	    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)

	IF p_level > 20 THEN
		CALL cl_err('','mfg2733',1) EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 602

    WHILE TRUE
        LET l_cmd=
            "SELECT '',bma01, bmb01, bmb02, bmb03, bmb04, bmb05,",
            "       (bmb06/bmb07),  bmb08, bmb09, bmb10,",
            "       bmb13,bmb14, bmb15, bmb16, bmb17,",
            "ima02,ima021,ima05, ima08, ima15,ima55,ima63,bmb_file.ROWID,bmb29",
            "  FROM bmb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' ",#AND bmb_file.ROWID >",b_seq,
            "   AND bmb03 = ima_file.ima01",
            "   AND bmb03 = bma_file.bma01",
            "   AND bmb29 = '",p_acode,"'" #FUN-550093

        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",tm.effective,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.effective,"' OR bmb05 IS NULL)"
        END IF
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY 19"
        PREPARE q602_precur FROM l_cmd
        IF SQLCA.sqlcode THEN
			 CALL cl_err('P1:',SQLCA.sqlcode,1) EXIT PROGRAM END IF
        DECLARE q602_cur CURSOR FOR q602_precur
        LET l_ac = 1
        FOREACH q602_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            LET l_fac = 1
            IF sr[i].ima55 !=sr[i].bmb10 THEN
               CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,sr[i].ima55)
                    RETURNING l_cnt,l_fac    #單位換算
               IF l_cnt = '1'  THEN #有問題
                  CALL cl_err(sr[i].bmb03,'abm-731',1)
                  LET g_success = 'N'
                  EXIT FOR
                  RETURN
               END IF
            END IF
           #與多階展開不同之處理在此:
           #尾階在展開時, 其展開之
            IF sr[i].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
                CALL q602_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06*l_fac,' ')
            ELSE
                LET l_total=p_total*sr[i].bmb06
                CASE tm.s
                  WHEN '1'  LET sr[i].order1 = sr[i].bmb02 USING'#####'
                  WHEN '2'  LET sr[i].order1 = sr[i].bmb03
                  WHEN '3'  LET sr[i].order1 = sr[i].bmb13
                  OTHERWISE  LET sr[i].order1 = sr[i].bmb03
                END CASE
                OUTPUT TO REPORT q602_rep(p_level,i,l_total,sr[i].*,g_bma01_a,g_bma06) #FUN-550093
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno-1].ROWID_NO
        END IF
    END WHILE
END FUNCTION

FUNCTION q602_cur()
 DEFINE l_cmd    LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(1000)

#---->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  " AND bmt08 = ? ", #FUN-550093
                  " ORDER BY 1"
     PREPARE q602_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q602_bmt  CURSOR FOR q602_prebmt
#---->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  " AND bmc06 = ? ", #FUN-550093
                  " ORDER BY 1"
     PREPARE q602_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q602_bmc CURSOR FOR q602_prebmc

END FUNCTION

REPORT q602_rep(p_level,p_i,p_total,sr,p_bma01_a,p_acode) #FUN-550093
   DEFINE l_last_sw 	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total       LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          p_bma01_a     LIKE bma_file.bma01,
          p_acode       LIKE bma_file.bma06, #FUN-550093
          sr  RECORD
              order1    LIKE bmb_file.bmb02,#No.FUN-680096 VARCHAR(20)
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb14 LIKE bmb_file.bmb14,    #
              bmb15 LIKE bmb_file.bmb15,    #
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb17 LIKE bmb_file.bmb17,    #
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
              ROWID_NO   LIKE type_file.chr18,   #No.FUN-680096 INT
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_ima02 LIKE ima_file.ima02,      #品名規格
          l_ima021 LIKE ima_file.ima02,      #品名規格
          l_ima05 LIKE ima_file.ima05,      #版本
          l_ima06 LIKE ima_file.ima06,      #版本
          l_ima08 LIKE ima_file.ima08,      #來源
          l_ima63 LIKE ima_file.ima63,      #發料單位
          l_ima55 LIKE ima_file.ima55,      #生產單位
          l_ver   LIKE ima_file.ima05,
          l_bmt05 LIKE bmt_file.bmt05,
          l_bmt06 ARRAY[200] OF LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_bmc04 LIKE bmc_file.bmc04,
          l_bmc05 ARRAY[200] OF LIKE cre_file.cre08,    #No.FUN-680096 VARCHAR(10)
          l_byte,l_len   LIKE type_file.num5,           #No.FUN-680096 SMALLINT  
          l_bmt06_s      LIKE bmt_file.bmt06,           #No.FUN-680096 VARCHAR(20)
          l_bmtstr       LIKE type_file.chr20,          #No.FUN-680096 VARCHAR(20)
          l_ute_flag     LIKE type_file.chr2,           #No.FUN-680096 VARCHAR(2)
          l_now,l_now2   LIKE type_file.num5            #No.FUN-680096 SMALLINT

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 #ORDER BY p_bma01_a,sr.order1
  ORDER BY p_bma01_a,p_acode,sr.order1 #FUN-550093
  FORMAT
   PAGE HEADER
      CALL s_effver(p_bma01_a,tm.effective) RETURNING l_ver

      SELECT ima02,ima021,ima05,ima08,ima63,ima55
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
        FROM ima_file
       WHERE ima01 = p_bma01_a
      IF SQLCA.sqlcode THEN
         LET l_ima02='' LET l_ima05='' LET l_ima08=''
         LET l_ima63='' LET l_ima55=''
      END IF

      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[19] CLIPPED,tm.effective,COLUMN 20,g_x[28] CLIPPED,l_ver
      PRINT g_dash
      #----

#------No:TQC-5B0030 modify
      PRINT COLUMN  1,g_x[15] CLIPPED, p_bma01_a,
          #-----No:TQC-5B0107 modify   #&051112
            COLUMN 51,g_x[22] clipped,l_ima05,
            COLUMN 63,g_x[23] clipped,l_ima08,
            COLUMN 71,g_x[16] CLIPPED,l_ima63,
            COLUMN 85,g_x[18] CLIPPED,l_ima55
          #-----No:TQC-5B0107 end
#----end

      PRINT COLUMN  1,g_x[17] CLIPPED, l_ima02,
	    COLUMN 71,g_x[20] CLIPPED,tm.a USING'<<<<<'   #No:TQC-5B0107 modify #&051112
      PRINT COLUMN  1,g_x[30] CLIPPED,l_ima021,COLUMN 71,g_x[49],p_acode   #No:TQC-5B0107 modify #051112
      PRINT ' '
      #----
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
      PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINTX name=H3 g_x[47],g_x[48]
      PRINT g_dash1

      LET l_last_sw = 'n'

   #BEFORE GROUP OF p_bma01_a
    BEFORE GROUP OF p_acode #FUN-550093
           IF (PAGENO > 1 OR LINENO > 13) THEN
                SKIP TO TOP OF PAGE
           END IF

    ON EVERY ROW
          LET l_ute_flag='US'
          #---->改變替代特性的表示方式
          IF sr.bmb16 MATCHES '[12]' THEN
              LET g_cnt=sr.bmb16 USING '&'
              LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
          ELSE
              LET sr.bmb16=' '
          END IF
          PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '###&',
                         COLUMN g_c[32],sr.bmb03,
                         COLUMN g_c[33],sr.ima08,
                         COLUMN g_c[34],sr.bmb10,
                         COLUMN g_c[35],cl_numfor(p_total,35,4),
                         COLUMN g_c[36],sr.bmb04,
                         COLUMN g_c[37],cl_numfor(sr.bmb08,37,3),
                         COLUMN g_c[38],sr.bmb16,
                         COLUMN g_c[39],sr.ima15
          PRINTX name=D2 COLUMN g_c[40],' ',
                         COLUMN g_c[41],sr.ima02,
                         COLUMN g_c[42],' ',
                         COLUMN g_c[43],' ',
                         COLUMN g_c[44],' ',
                         COLUMN g_c[45],sr.bmb05,
                         COLUMN g_c[46],' '
          PRINTX name=D3 COLUMN g_c[47],' ',
                         COLUMN g_c[48],sr.ima021
      #-->列印插件位置
      IF tm.c ='Y' THEN
         FOR g_cnt=1 TO 200
             LET l_bmt06[g_cnt]=NULL
         END FOR
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         FOREACH q602_bmt
         USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550093
         INTO l_bmt05,l_bmt06_s
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF l_now2 > 200 THEN
               CALL cl_err('','9036',1)
               EXIT PROGRAM
            END IF
            LET l_byte = length(l_bmt06_s) + 1
            IF l_len >= l_byte THEN
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
               LET l_len = l_len - l_byte
            ELSE
               LET l_bmt06[l_now2] = l_bmtstr
               LET l_len = 20
               LET l_now2 = l_now2 + 1
               LET l_len = l_len - l_byte
               LET l_bmtstr = ''
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
            END IF
         END FOREACH
         LET l_bmt06[l_now2] = l_bmtstr
         FOR g_cnt = 1 TO l_now2
             IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
             THEN IF l_now2 = 1 THEN PRINT ' ' END IF
                  EXIT FOR
             END IF
             PRINT COLUMN 48,g_x[29] CLIPPED,l_bmt06[g_cnt] #FUN-510033
         END FOR
      ELSE PRINT ''
      END IF
          #處理說明部份
          IF tm.b ='Y' THEN
           LET l_now = 1
           FOREACH q602_bmc
           USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550093
           INTO l_bmc04,l_bmc05[l_now]
               IF SQLCA.sqlcode THEN
                  CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
               END IF
               IF l_now > 200 THEN
                   CALL cl_err('','9036',1)
                   EXIT PROGRAM
               END IF
               LET l_now=l_now+1
           END FOREACH
           LET l_now=l_now-1
           #--->列印剩下說明
           IF l_now >= 1 THEN
              FOR g_cnt = 1 TO l_now STEP 2
                  IF g_cnt =1 THEN PRINT COLUMN 52,g_x[27] clipped; END IF
                  PRINT COLUMN 59,l_bmc05[g_cnt],l_bmc05[g_cnt+1]
              END FOR
           END IF
         END IF

   #AFTER GROUP OF p_bma01_a
   #LET g_pageno = 0

   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      PRINT ' '
      PRINT g_x[21] CLIPPED
      PRINT g_dash
      IF l_last_sw = 'y'
#        OR g_pageno = 0
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
