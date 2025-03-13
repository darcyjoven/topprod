# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abmq601.4gl
# Descriptions...: 多階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/02 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
# Modify.........: 92/10/26 By Apple(全面整修)
# Modify.......... 94/08/16 By Danny 改由bmt_file取插件位置
# Modify.........: 99/09/15 By Carol:數量check生產單位及庫存單位之換算
# Modify.........: No:MOD-4A0359 04/11/01 By Mandy 列印頁次
# Modify.........: No:FUN-4B0001 04/11/02 By Smapmin 主件編號開窗
# Modify.........: No:MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No:FUN-550093 05/05/27 By kim 配方BOM
# Modify.........: No:FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No:TQC-5A0028 05/10/12 By Carrier 報表格式調整
# Modify.........: No:TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE

# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD        	                  # Print condition RECORD
    		wc  	  LIKE type_file.chr1000, #No.FUN-680096  VARCHAR(500)
       		revision  LIKE aba_file.aba18,    #No.FUN-680096  VARCHAR(2)
       		effective LIKE type_file.dat,     #No.FUN-680096  DATE
                a         LIKE type_file.num10,   #No.FUN-680096  INTEGER
                s         LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
                loc       LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
                c         LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
                b         LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
                x         LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
                y         LIKE type_file.chr1,    #No.FUN-680096  VARCHAR(1)
       		more	  LIKE type_file.chr1     #No.FUN-680096  VARCHAR(1)
        END RECORD,
        g_bma01_a    LIKE bma_file.bma01,
    	g_tot        LIKE type_file.num10,   #No.FUN-680096 INTEGER
        g_str        LIKE type_file.chr50    #No.FUN-680096 VARCHAR(50)

DEFINE   g_chr       LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
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
   LET tm.a       = ARG_VAL(10)
   LET tm.s       = ARG_VAL(11)
   LET tm.loc     = ARG_VAL(12)
   LET tm.c       = ARG_VAL(13)
   LET tm.b       = ARG_VAL(14)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q601_tm(0,0)			# Input print condition
      ELSE CALL q601()			# Read bmata and create out-file
   END IF
END MAIN

FUNCTION q601_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
            l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT 
            l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
            l_bdate       LIKE bmx_file.bmx07,	
            l_edate       LIKE bmx_file.bmx08,	
            l_bma01       LIKE bma_file.bma01,
            l_ima06       LIKE ima_file.ima06,	
            l_cmd	  LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)


   IF p_row = 0 THEN
      LET p_row = 3
      LET p_col = 9
   END IF
   LET p_row = 3
   LET p_col = 9

   OPEN WINDOW q601_w AT p_row,p_col WITH FORM "abm/42f/abmq601"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.effective = g_today	#有效日期
   LET tm.a  = 1
   LET tm.s  = g_sma.sma65
   LET tm.loc= '1'
   LET tm.c  = 'N'
   LET tm.b  = 'N'
   LET tm.x  = 'N'
   LET tm.y  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT tm.wc ON bma01,ima06,ima09,ima10,ima11,ima12,bma06 #FUN-550093
                    FROM item,class,ima09,ima10,ima11,ima12,bma06  #FUN-550093
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
   ON ACTION CONTROLP    #FUN-4B0001
      CASE WHEN INFIELD(item)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_bma3"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO item
           NEXT FIELD item
      END CASE


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
         CLOSE WINDOW q601_w
         EXIT PROGRAM
      END IF
      LET l_one='N'
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT bma01,ima06 ",
                   " FROM bma_file,ima_file",
                   " WHERE bma01=ima01 AND ima08 != 'A' AND ",
                    tm.wc CLIPPED
         PREPARE q601_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            EXIT PROGRAM
         END IF
         DECLARE q601_cnt
         CURSOR FOR q601_precnt
         MESSAGE " SEARCHING ! "
         FOREACH q601_cnt INTO l_bma01,l_ima06
           IF SQLCA.sqlcode  THEN
              CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
              CONTINUE WHILE
           ELSE
              LET l_one = 'Y'
              EXIT FOREACH
           END IF
         END FOREACH
         MESSAGE " "
         IF l_bma01 IS NULL OR l_bma01 = ' ' THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         END IF
      END IF

      INPUT BY NAME tm.revision,tm.effective,tm.a,
                    tm.s,tm.loc,tm.c,tm.b,tm.x,tm.y,tm.more WITHOUT DEFAULTS
 
         BEFORE FIELD revision
            IF l_one='N' THEN
               NEXT FIELD effective
            END IF

         AFTER FIELD revision
            IF tm.revision IS NOT NULL THEN
               CALL s_version(l_bma01,tm.revision)
               RETURNING l_bdate,l_edate,l_flag
               LET tm.effective = l_bdate
               IF cl_null(tm.effective) THEN
                   LET tm.effective = g_today	#有效日期
               END IF
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

         AFTER FIELD loc
            IF tm.loc IS NULL OR tm.loc NOT MATCHES'[1-2]' THEN
               NEXT FIELD loc
            END IF

         AFTER FIELD b
            IF tm.b   IS NULL OR tm.b   NOT MATCHES'[YNyn]' THEN
               NEXT FIELD b
            END IF

         AFTER FIELD c
            IF tm.c   IS NULL OR tm.c   NOT MATCHES'[YNyn]' THEN
               NEXT FIELD c
            END IF

         #BugNo:5347--{
         AFTER FIELD x
            IF cl_null(tm.x) OR tm.x NOT MATCHES'[YNyn]' THEN
               NEXT FIELD x
            END IF

         AFTER FIELD y
            IF cl_null(tm.y) OR tm.y NOT MATCHES'[YNyn]' THEN
               NEXT FIELD y
            END IF

         #BugNo:5347--}
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
         ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
         CLOSE WINDOW q601_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmq601'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmq601','9031',1)
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
                            " '",tm.loc CLIPPED,"'",
                            " '",tm.c   CLIPPED,"'",
                            " '",tm.b   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('abmq601',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW q601_w
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL q601()
      ERROR ""
   END WHILE
   CLOSE WINDOW q601_w
END FUNCTION

#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION q601()
   DEFINE l_name    LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0060
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_bma01   LIKE bma_file.bma01,    #主件料件
          l_bma06   LIKE bma_file.bma06     #FUN-550093

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmq601'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同部門的資料
         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     END IF

     LET l_sql = "SELECT bma01,bma06 ", #FUN-550093
                 " FROM bma_file,ima_file",
                 " WHERE bma01 = ima01",
                 " AND ima08 !='A' AND ",tm.wc
     PREPARE q601_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q601_c1 CURSOR FOR q601_prepare1

     CALL cl_outnam('abmq601') RETURNING l_name
     START REPORT q601_rep TO l_name
 
     #報表示
     IF tm.loc = '1'
     #No.TQC-5A0028  --begin
     THEN LET g_str = g_x[26] clipped,'         ',g_x[25] clipped
     ELSE LET g_str = g_x[25] clipped,'                      ',g_x[26] clipped
     #No.TQC-5A0028  --end
     END IF
     CALL q601_cur()
      LET g_pageno = 0 #MOD-4A0359
	 LET g_tot=0
     FOREACH q601_c1 INTO l_bma01,l_bma06 #FUN-550093
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01_a=l_bma01
       CALL q601_bom(0,l_bma01,tm.a,l_bma06)
     END FOREACH

     FINISH REPORT q601_rep

            LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN
        LET INT_FLAG = 0
     END IF
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION

FUNCTION q601_bom(p_level,p_key,p_total,p_acode) #FUN-550093
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total       LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          l_total       LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          p_acode       LIKE bma_file.bma06,    #FUN-550093
          l_tot         LIKE type_file.num10,   #No.FUN-680096 INTEGER
          l_times       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num10,   #No.FUN-680096 INTEGER
          l_chr,l_cnt   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          l_order2      LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          sr DYNAMIC ARRAY OF RECORD        #每階存放資料
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,   #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_cmd	    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)

	IF p_level > 20 THEN
	CALL cl_err('','mfg2733',1) EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN					#第0階主件資料
        INITIALIZE sr[1].* TO NULL
         LET g_pageno = 0 #MOD-4A0359
        LET sr[1].bmb03 = p_key
        OUTPUT TO REPORT q601_rep(1,0,tm.a,sr[1].*,p_acode)	#第0階主件資料
    END IF
	LET l_times=1
    LET arrno = 601
    WHILE TRUE
        LET l_cmd=
            "SELECT bma01, bmb01,bmb02, bmb03, bmb04, bmb05,",
            "       bmb06/bmb07,  bmb08, bmb10,",
            "       bmb13, bmb16, ",
            "       ima02,ima021,ima05, ima08, ima15,ima55,ima63,bmb29 ", #FUN-550093
            "  FROM bmb_file,OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
             "   AND bmb03 = ima_file.ima01", #MOD-4A0359
            "   AND bmb03 = bma_file.bma01",  #
            "   AND bmb29 ='",p_acode,"'" #FUN-550093

        #---->生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",tm.effective,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.effective,"' OR bmb05 IS NULL)"
        END IF

        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY "
    	CASE WHEN tm.s = '1'
                  LET l_cmd = l_cmd CLIPPED, ' bmb02'
                 WHEN tm.s = '2'
                  LET l_cmd = l_cmd CLIPPED, ' bmb03'
                 WHEN tm.s = '3'
                  LET l_cmd = l_cmd CLIPPED, ' bmb13'
        END CASE

        PREPARE q601_precur FROM l_cmd
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) EXIT PROGRAM END IF
        DECLARE q601_cur CURSOR FOR q601_precur
        LET l_ac = 1
        FOREACH q601_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1		    	# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_tot = l_ac - 1
        FOR i = 1 TO l_tot    	        	# 讀BUFFER傳給REPORT
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
            LET l_total=p_total*sr[i].bmb06*l_fac
            OUTPUT TO REPORT q601_rep(p_level,i,p_total*sr[i].bmb06,sr[i].*,' ')
            IF sr[i].bma01 IS NOT NULL THEN #若為主件
               CALL q601_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06*l_fac,' ') #FUN-550093
            END IF
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_tot].bmb02
		LET l_times=l_times+1
        END IF
    END WHILE
END FUNCTION
 
FUNCTION q601_cur()
  DEFINE  l_cmd   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)

#---->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  " AND bmt08 = ?",  #FUN-550093
                  " ORDER BY 1"
     PREPARE q601_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q601_bmt  CURSOR FOR q601_prebmt

#---->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  " AND bmc06 = ? ", #FUN-550093
                  " ORDER BY 1"
     PREPARE q601_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q601_bmc CURSOR FOR q601_prebmc
 
     #BugNo:5347{
     #(1)宣告抓元件替代料號的CURSOR
     LET l_cmd = "SELECT bmd02,bmd04,bmd05,bmd06,bmd09,bmd07,'','' FROM bmd_file",
                 " WHERE bmd01 = ?",
                 "   AND (bmd08 = ? OR bmd08 = 'ALL')"
     #---->生效日及失效日的判斷
     IF NOT cl_null(tm.effective) THEN
         LET l_cmd = l_cmd CLIPPED,
                    " AND (bmd05 <='",tm.effective,"' OR bmd05 IS NULL)",
                    " AND (bmd06 > '",tm.effective,"' OR bmd06 IS NULL)"
     END IF
     PREPARE q601_prebmd    FROM l_cmd
     IF SQLCA.sqlcode THEN
         CALL cl_err('prebmd',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q601_bmd CURSOR FOR q601_prebmd
     #(2)宣告抓料件承認資料的CURSOR
     LET l_cmd = "SELECT bmj02,bmj04,bmj03,bmj10,bmj11 FROM bmj_file",
                 " WHERE bmj01 = ?",
                 "   AND bmj08 = '3'"
     #---->生效日及失效日的判斷
     IF NOT cl_null(tm.effective) THEN
         LET l_cmd = l_cmd CLIPPED,
                    " AND (bmj11 <='",tm.effective,"' OR bmj11 IS NULL)"
     END IF
     PREPARE q601_prebmj    FROM l_cmd
     IF SQLCA.sqlcode THEN
         CALL cl_err('prebmj',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q601_bmj CURSOR FOR q601_prebmj
     #BugNo:5347}
END FUNCTION

REPORT q601_rep(p_level,p_i,p_total,sr,p_acode)
   DEFINE l_last_sw	LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          p_acode       LIKE bma_file.bma06, 
          p_total       LIKE csa_file.csa0301,   #No.FUN-680096 DEC(13,5)
          sr  RECORD
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima02,    #品名規格
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_str2        LIKE cre_file.cre08,    #No.FUN-680096 VARCHAR(10)
          l_bmb03       LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(33)
          l_k,l_p       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_now,l_now2  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_point       LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(10)
          l_ver   LIKE ima_file.ima05,
          l_bmt01 LIKE bmt_file.bmt01,
          l_bmt05 LIKE bmt_file.bmt05,
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06, #No.FUN-680096 VARCHAR(20)
          l_bmc04 LIKE bmc_file.bmc04,
          l_byte,l_len   LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_bmt06_s      LIKE bmt_file.bmt06,   #No.FUN-680096 VARCHAR(20)
          l_bmtstr       LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20)
          l_bmc05 ARRAY[200] OF LIKE bmc_file.bmc05, #No.FUN-680096 VARCHAR(10) 
          l_ute_flag   LIKE type_file.chr2      #No.FUN-680096 VARCHAR(2)
   DEFINE l_bmd RECORD	#BugNo:5347
                  bmd02  LIKE bmd_file.bmd02,
                  bmd04  LIKE bmd_file.bmd04,
                  bmd05  LIKE bmd_file.bmd05,
                  bmd06  LIKE bmd_file.bmd06,
                  bmd09  LIKE bmd_file.bmd09,
                  bmd07  LIKE bmd_file.bmd07,
                  ima02  LIKE ima_file.ima02,
                  ima021 LIKE ima_file.ima021
                END RECORD
   DEFINE l_bmj RECORD	#BugNo:5347
                  bmj02  LIKE bmj_file.bmj02,
                  bmj04  LIKE bmj_file.bmj04,
                  bmj03  LIKE bmj_file.bmj03,
                  bmj10  LIKE bmj_file.bmj10,
                  bmj11  LIKE bmj_file.bmj11
                END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      #公司名稱
      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      #報表名稱
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
      #有效日期
       LET g_pageno = g_pageno + 1 #MOD-4A0359
      CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
      PRINT ''
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[19])-6)/2,
            g_x[19] CLIPPED,tm.effective,'  ',
            g_x[28] CLIPPED,l_ver,
            COLUMN g_len-7,g_x[3] CLIPPED,
             g_pageno USING '<<<' #MOD-4A0359
      SELECT ima02,ima021,ima05,ima08,ima63,ima55
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
        FROM ima_file
       WHERE ima01 = g_bma01_a
      IF SQLCA.sqlcode THEN
         LET l_ima02='' LET l_ima05='' LET l_ima08=''
         LET l_ima63='' LET l_ima55=''
      END IF
      PRINT g_dash[1,g_len]

#------No:TQC-5B0030 modify
      PRINT COLUMN  1,g_x[15] CLIPPED, g_bma01_a,
            COLUMN 45,g_x[21] CLIPPED, l_ima05,
            COLUMN 57,g_x[22] CLIPPED, l_ima08,
            COLUMN 64,g_x[16] CLIPPED, l_ima63,
            COLUMN 78,g_x[18] CLIPPED, l_ima55
#----end

      #No.TQC-5A0028  --begin
      PRINT COLUMN 01,g_x[17] CLIPPED, l_ima02
      PRINT COLUMN 10,l_ima021
      PRINT COLUMN 01,g_x[20] CLIPPED,tm.a USING'<<<<<'
      PRINT COLUMN 01,g_x[34],p_acode
      PRINT COLUMN 52,g_x[11] clipped,column 84,g_x[12] clipped;
      IF g_sma.sma888[1,1] ='Y'
       THEN PRINT column 96,g_x[24].substring(1,2) #MOD-520129
      ELSE PRINT ' '
      END IF
      PRINT g_str,column 52,g_x[13] clipped,column 65,g_x[14] clipped;
      IF g_sma.sma888[1,1] ='Y'
       THEN PRINT column 96,g_x[24].substring(3,4) #MOD-520129
      ELSE PRINT ' '
      END IF
      PRINT '----------------------------------------------------- -- ', # No:TQC-5B0030 modify
            '---- ----------- -------- -------- --';
      IF g_sma.sma888[1,1] = 'Y'
      THEN PRINT column 96,'--'
      ELSE PRINT ' '
      END IF
      #No.TQC-5A0028  --end
      LET l_ute_flag = 'US'
      LET l_last_sw = 'n'

    ON EVERY ROW
       IF p_level = 1 AND p_i = 0 THEN
          IF (PAGENO > 1 OR LINENO > 13) THEN
               LET g_pageno = 0  #MOD-4A0359
              SKIP TO TOP OF PAGE
               LET g_pageno = 1  #MOD-4A0359
          END IF
       ELSE
          #---->改變替代特性的表示方式
          IF sr.bmb16 MATCHES '[12]' THEN
              LET g_cnt=sr.bmb16 USING '&'
              LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
          ELSE
              LET sr.bmb16=' '
          END IF
          IF p_level>10 THEN LET p_level=10 END IF
          NEED 2 LINE
          IF tm.loc ='1' THEN    #項次前置
             PRINT column p_level,sr.bmb02 using'<<<',
                   column 14,sr.bmb03;
          ELSE                 #元件前置
            #No.B579 010523 by plum
            LET l_point=''
            #No.B579..end
             IF p_level >1 THEN
               #No.B579 010523 by plum
               #FOR l_p = 1 TO p_level
                FOR l_p = 1 TO p_level -1
               #No.B579 ..end
                    LET l_point = l_point clipped,'.'
                END FOR
             ELSE
                LET l_point = ''
             END IF
             PRINT l_point clipped,
                   column p_level,sr.bmb03 clipped,
                   #No.TQC-5A0028  --begin
                   #column 31,sr.bmb02 using'<<<';
                   COLUMN 41,sr.bmb02 using'<<<';
                   #No.TQC-5A0028  --end
          END IF
          #No.TQC-5A0028  --begin
          PRINT column 38+17,sr.ima08,
                COLUMN 41+17,sr.bmb10,
                COLUMN 46+17,p_total USING '#####&.&&&&',
                COLUMN 58+17,sr.bmb04,
                COLUMN 67+17,sr.bmb08 USING '###&.&&&',
                COLUMN 76+17,sr.bmb16;
          IF g_sma.sma888[1,1] ='Y'
          THEN PRINT column 80+17,sr.ima15
          ELSE PRINT ' '
          END IF
          #No.TQC-5A0028  --end
          #PRINT column p_level+3,sr.ima02,
          PRINT column 14,sr.ima02,
                column 58+17,sr.bmb05  #No.TQC-5A0028
          PRINT column 14,sr.ima021
          #-->列印插件位置
          IF tm.c = 'Y' THEN
             FOR g_cnt=1 TO 200
                 LET l_bmt06[g_cnt]=NULL
             END FOR
             LET l_now2=1
             LET l_len =20
             LET l_bmtstr = ''
             FOREACH q601_bmt
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
                   LET l_now2 = l_now2 + 1
                   LET l_len = 20
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
                 #NO.TQC-5A0028  --begin
                 IF g_cnt =1 THEN PRINT COLUMN 48+17,g_x[29] clipped; END IF
                 PRINT COLUMN 58+17,l_bmt06[g_cnt]
                 #NO.TQC-5A0028  --end
             END FOR
          END IF
          #-->列印說明部份
          IF tm.b ='Y' THEN
             FOR g_cnt=1 TO 200
                 LET l_bmc05[g_cnt]=NULL
             END FOR
             LET l_now = 1
             FOREACH q601_bmc
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
                 #NO.TQC-5A0028  --begin
                  IF g_cnt =1 THEN PRINT COLUMN 48+17,g_x[27] clipped; END IF
                  PRINT COLUMN 58+17,l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED
                 #NO.TQC-5A0028  --end
                END FOR
             END IF
          END IF
          #BugNo:5347{
          #--->列印元件取替代料號
          IF tm.x ='Y' THEN
              INITIALIZE l_bmd.* TO NULL

              LET g_i = 1
              FOREACH q601_bmd USING sr.bmb03,sr.bmb01
                 INTO l_bmd.*
                 IF g_i = 1 THEN #title只印第一次
                    #PRINT COLUMN 12,"取替代  替代料號/品名        生效日   失效日  取替代日     替代量     "
                     #No.TQC-5A0028  --begin
                     PRINT COLUMN 12,g_x[30] CLIPPED,COLUMN 59,g_x[31] CLIPPED
                     #No.TQC-5A0028  --end
                 END IF

                  SELECT ima02,ima021
                    INTO l_bmd.ima02,l_bmd.ima021
                    FROM ima_file
                   WHERE ima01 = l_bmd.bmd04
 
                  #No.TQC-5A0028  --begin
                  PRINT COLUMN 12,"------ ---------------------------------------- -------- -------- -------- -------------- "
                  IF l_bmd.bmd02='1' THEN
                      PRINT COLUMN 12,"UTD";
                  ELSE
                      PRINT COLUMN 12,"SUB";
                  END IF
                  PRINT COLUMN 19,l_bmd.bmd04,
                        COLUMN 40+20,l_bmd.bmd05,
                        COLUMN 49+20,l_bmd.bmd06,
                        COLUMN 58+20,l_bmd.bmd09,
                        COLUMN 67+20,l_bmd.bmd07
                  PRINT COLUMN 19,l_bmd.ima02
                  PRINT COLUMN 19,l_bmd.ima021
                  #No.TQC-5A0028  --end
                  LET g_i = 0
              END FOREACH
          END IF
          #--->列印料件承認資料
          IF tm.y ='Y' THEN
              INITIALIZE l_bmj.* TO NULL

              LET g_i = 1
              FOREACH q601_bmj USING sr.bmb03
                 INTO l_bmj.*
                 IF g_i= 1 THEN #title只印第一次
                    #PRINT COLUMN 14,"製造商         廠商料號         供應商    承認文號  承認日期"
                    #No.TQC-5A0028  --begin
                     PRINT COLUMN 14,g_x[32] CLIPPED,COLUMN 64,g_x[33] CLIPPED
                    #No.TQC-5A0028  --end
                 END IF

                  #No.TQC-5A0028  --begin
                  PRINT COLUMN 12,"---------- ---------------------------------------- ---------- ---------- --------"
                  PRINT COLUMN 12,l_bmj.bmj02,
                        COLUMN 23,l_bmj.bmj04,
                        COLUMN 44+20,l_bmj.bmj03,
                        COLUMN 55+20,l_bmj.bmj10,
                        COLUMN 66+20,l_bmj.bmj11
                  #No.TQC-5A0028  --end
                  LET g_i = 0
              END FOREACH
          END IF
          #BugNo:5347}

      END IF

   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      PRINT ''
      PRINT g_x[23] CLIPPED
      PRINT g_dash[1,g_len]
      IF l_last_sw = 'y'
       OR g_pageno = 0  #MOD-4A0359
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
#Patch....NO:TQC-610035 <001> #
