# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abmq600.4gl
# Descriptions...: 單階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/02 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
# Modify.........: 92/10/24 By Apple
# Modify.........: 93/04/27 BY Apple 虛擬料件是否展開
# Modify.......... 94/08/15 By Danny 改由bmt_file取插件位置
#	.........: 組成用量以不除以底數呈現
# Modify.........: No:FUN-4A0036 04/10/08 By Smapmin新增開窗功能
 # Modify.........: No:MOD-4A0358 04/11/01 By Mandy 列印頁次
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
 # Modify.........: No:MOD-530298 05/03/28 By kim 取替代料件前,請加上'替代'('SUB')或'取代'('UTE')字樣提示
# Modify.........: No:FUN-550093 05/05/27 By kim 配方BOM
# Modify.........: No:FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No:FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No:TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No:TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No:FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE

# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				# Print condition RECORD
        		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
           		class	  LIKE fan_file.fan02,    #No.FUN-680096 VARCHAR(4)
   	        	revision  LIKE aba_file.aba18,    #No.FUN-680096 VARCHAR(2)
           		effective LIKE type_file.dat,     #No.FUN-680096 DATE
   	        	engine    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        a         LIKE type_file.num10,   #No.FUN-680096 INTEGER
                        s         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        blow      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        b         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        c         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                        d         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	        	more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          sr  RECORD
              order1  LIKE bmb_file.bmb02,  #No.FUN-680096 VARCHAR(20)  
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #來源
              phatom LIKE ima_file.ima01,   #虛擬料件
              bma06 LIKE bma_file.bma06     #FUN-550093
          END RECORD,
          g_bma01 LIKE bma_file.bma01

DEFINE   g_cnt     LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
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
   LET tm.effective  = ARG_VAL(8)
   LET tm.engine  = ARG_VAL(9)
   LET tm.a    = ARG_VAL(10)
   LET tm.s    = ARG_VAL(11)
   LET tm.blow = ARG_VAL(12)
   LET tm.c    = ARG_VAL(13)
   LET tm.b    = ARG_VAL(14)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q600_tm(0,0)			# Input print condition
      ELSE CALL q600()			# Read data and create out-file
   END IF
END MAIN

FUNCTION q600_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
            l_one         LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
            l_date        LIKE type_file.dat,      #No.FUN-680096 DATE
            l_bmb01       LIKE bmb_file.bmb01,	
            l_cmd	  LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)


   LET p_row = 3
   LET p_col = 11

   OPEN WINDOW q600_w AT p_row,p_col WITH FORM "abm/42f/abmq600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    #FUN-560021................begin
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
    #FUN-560021................end

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.engine ='N'           #不列印工程技術資料
   LET tm.effective = g_today	#有效日期
  #---------No:FUN-670041 modify
  #LET tm.blow = g_sma.sma29
   LET tm.blow = 'Y'
  #---------No:FUN-670041 modify
   LET tm.a    = 1
   LET tm.s    = g_sma.sma65
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'

   WHILE TRUE
      CONSTRUCT tm.wc ON bmb01,bmb03,bmb13,bmb29 FROM item,com_part,balloon,bmb29  #FUN-550093
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
#FUN-4A0036新增開窗功能
   ON ACTION CONTROLP
         CASE
            WHEN INFIELD(item)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bmb204"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
            WHEN INFIELD(com_part)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bmb203"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO com_part
         END CASE

   ON ACTION locale
         CALL cl_dynamic_locale()

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
         CLOSE WINDOW q600_w
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT bmb01 FROM bmb_file",
                   " WHERE ",tm.wc CLIPPED
         PREPARE q600_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
            EXIT PROGRAM
         END IF
         DECLARE q600_cnt
         CURSOR FOR q600_precnt
         MESSAGE " SEARCHING ! "
         FOREACH q600_cnt INTO l_bmb01
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

      INPUT BY NAME tm.effective,tm.a,tm.s,tm.blow,tm.c,tm.b,tm.d,tm.more
         WITHOUT DEFAULTS

         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a < 0 THEN
               LET tm.a = 1
               DISPLAY BY NAME tm.a
            END IF

         AFTER FIELD s
            IF cl_null(tm.s) OR tm.s NOT MATCHES '[1-3]' THEN
               NEXT FIELD s
            END IF

         AFTER FIELD blow
            IF cl_null(tm.blow) OR tm.blow NOT MATCHES'[yYnN]' THEN
               NEXT FIELD blow
            END IF

         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES'[yYnN]' THEN
               NEXT FIELD b
            END IF

         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES'[yYnN]' THEN
               NEXT FIELD c
            END IF

         #No.B066 010321 by linda add
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES'[yYnN]' THEN
               NEXT FIELD d
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

         ON ACTION CONTROLP CALL q600_wc()   # Input detail Where Condition
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
         CLOSE WINDOW q600_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmq600'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmq600','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.engine CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.blow CLIPPED,"'",
                            " '",tm.c    CLIPPED,"'",
                            " '",tm.b    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('abmq600',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW q600_w
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL q600()
      ERROR ""
   END WHILE
   CLOSE WINDOW q600_w
END FUNCTION


 FUNCTION q600_wc()
    DEFINE l_wc LIKE type_file.chr1000   #No.FUN-680096  VARCHAR(500)
    OPEN WINDOW q600_w2 AT 2,2
         WITH FORM "abm/42f/abmi600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

    CALL cl_ui_locale("abmi600")

    CALL cl_opmsg('q')
    CONSTRUCT l_wc ON                               # 螢幕上取條件
         bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
         bmb02,bmb03,bmb04,bmb05,bmb10,bmb13,bmb06,bmb07,bmb08
         FROM
         bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
         s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
         s_bmb[1].bmb10,s_bmb[1].bmb13,s_bmb[1].bmb06,s_bmb[1].bmb07,
         s_bmb[1].bmb08
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN

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
    CLOSE WINDOW q600_w2
    LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
 END FUNCTION

FUNCTION q600_cur()
DEFINE l_sql  LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
       l_cmd  LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(1000)

#---->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  " AND bmc06=? ",  #FUN-550093
                  " ORDER BY 1"
     PREPARE q600_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q600_bmc CURSOR FOR q600_prebmc

#---->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  " AND bmt08=? ",  #FUN-550093
                  " ORDER BY 1"
     PREPARE q600_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q600_bmt  CURSOR WITH  HOLD FOR q600_prebmt

     LET l_sql = "SELECT '',",
                 " bma01,",		#95/12/21 Modify By Lynn
                 " bmb02,bmb03,bmb04,bmb05,bmb06,",
                 " bmb07,bmb08,bmb10,bmb13,bmb16,",
                 " ima02,ima021,ima05,ima08,ima15,'',bma06", #FUN-550093
                 " FROM bma_file,bmb_file,ima_file",
                 " WHERE bma01 = bmb01 AND bma01 = ? ",
                 "   AND bmb03 = ima01",
                 "   AND bma06=bmb29"  #FUN-550093
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
          " AND (bmb04 <='",tm.effective CLIPPED,"' OR bmb04 IS NULL)",
          " AND (bmb05 > '",tm.effective CLIPPED,"' OR bmb05 IS NULL)"
     END IF

     PREPARE q600_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q600_cs2 CURSOR FOR q600_prepare2
END FUNCTION

FUNCTION q600_phatom(p_phatom,p_qpa)
   DEFINE p_phatom      LIKE bmb_file.bmb01,
          p_qpa         LIKE bmb_file.bmb06,
          l_ac,l_i      LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_tot,l_times LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          b_seq		LIKE type_file.num5,      #No.FUN-680096 SMALLINT
          l_chr		LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
          l_ute_flag    LIKE type_file.chr2,      #No.FUN-680096 VARCHAR(2)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              order1  LIKE type_file.chr20, #No.FUN-680096 VARCHAR(20)
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #來源
              phatom LIKE ima_file.ima01,   #虛擬料件
              bma06 LIKE bma_file.bma06     #FUN-550093
          END RECORD,
          l_bma01  LIKE bma_file.bma01

    LET l_ac = 1
    LET arrno = 600
    LET l_ute_flag='US'
    FOREACH q600_cs2 USING p_phatom INTO sr[l_ac].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET sr[l_ac].phatom = p_phatom
      LET sr[l_ac].bmb06= sr[l_ac].bmb06 * p_qpa
      LET l_ac = l_ac + 1			# 但BUFFER不宜太大
#      IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
	LET l_tot=l_ac-1
    FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
        IF sr[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
           CALL q600_phatom(sr[l_i].bmb03,sr[l_i].bmb06)
           CONTINUE FOR
        END IF
        CASE tm.s
          WHEN '1' LET sr[l_i].order1=sr[l_i].bmb02 using'#####'
          WHEN '2' LET sr[l_i].order1=sr[l_i].bmb03
          WHEN '3' LET sr[l_i].order1=sr[l_i].bmb13
          OTHERWISE LET sr[l_i].order1 = ' '
        END CASE
        #改變替代特性的表示方式
        IF sr[l_i].bmb16 MATCHES '[12]' THEN
           LET g_cnt=sr[l_i].bmb16 USING '&'
           LET sr[l_i].bmb16=l_ute_flag[g_cnt,g_cnt]
        ELSE
           LET sr[l_i].bmb16=' '
        END IF
        LET sr[l_i].bma01= g_bma01
        OUTPUT TO REPORT q600_rep(sr[l_i].*)
    END FOR
END FUNCTION
 
FUNCTION q600()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_ute_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_bma01       LIKE bma_file.bma01

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

     LET l_sql = "SELECT '',",
                 " bma01,",		    #95/12/21 Modify By Lynn
                 " bmb02,bmb03,bmb04,bmb05,bmb06,",
                 " bmb07,bmb08,bmb10,bmb13,bmb16,",
                 " ima02,ima021,ima05,ima08,ima15,'',bma06", #FUN-550093
                 " FROM bma_file, bmb_file,ima_file",
                 " WHERE bma01 = bmb01",
                 "   AND bma06=bmb29", #FUN-550093
                 "   AND bmb03 = ima01",
                 "   AND ",tm.wc

     #---->生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
          " AND (bmb04 <='",tm.effective CLIPPED,"' OR bmb04 IS NULL)",
          " AND (bmb05 > '",tm.effective CLIPPED,"' OR bmb05 IS NULL)"
     END IF

     PREPARE q600_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
     END IF
     DECLARE q600_c1 CURSOR FOR q600_prepare1

     CALL cl_outnam('abmq600') RETURNING l_name
     START REPORT q600_rep TO l_name

     CALL q600_cur()
      LET g_pageno = 0 #MOD-4A0358
     LET l_ute_flag='US'
     FOREACH q600_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.ima08 = 'X' AND tm.blow = 'Y' THEN
          LET g_bma01 = sr.bma01
          CALL q600_phatom(sr.bmb03,sr.bmb06)
          CONTINUE FOREACH
       END IF
       CASE tm.s
           WHEN '1' LET sr.order1=sr.bmb02  USING'#####'
           WHEN '2' LET sr.order1=sr.bmb03
           WHEN '3' LET sr.order1=sr.bmb13
           OTHERWISE LET sr.order1 = ' '
       END CASE

       #---->改變替代特性的表示方式
       IF sr.bmb16 MATCHES '[12]' THEN
           LET g_cnt=sr.bmb16 USING '&'
           LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
       ELSE
           LET sr.bmb16=' '
       END IF
       OUTPUT TO REPORT q600_rep(sr.*)
     END FOREACH

     FINISH REPORT q600_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION

REPORT q600_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          sr  RECORD 
              order1  LIKE bmb_file.bmb02,  #No.FUN-680096 VARCHAR(20)
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,   #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #來源
              phatom LIKE ima_file.ima01,   #虛擬料件
              bma06 LIKE bma_file.bma06     #FUN-550093
          END RECORD,
          l_bmd	RECORD LIKE bmd_file.*,
         #l_bmb06 DECIMAL(12,5),          #組成用量
          l_bmb06 LIKE bmb_file.bmb06,    #組成用量 #FUN-560227
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima02,    #品名規格
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_ver   LIKE ima_file.ima05,
          l_bmt01 LIKE bmt_file.bmt01,
          l_bmt05 LIKE bmt_file.bmt05,
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06, #No.FUN-680096 VARCHAR(20)
          l_bmc01 LIKE bmc_file.bmc01,
          l_bmc04 LIKE bmc_file.bmc04,
          l_bmc05 ARRAY[200] OF LIKE bmt_file.bmt05, #No.FUN-680096 VARCHAR(10)
          l_no          LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_sql 	LIKE type_file.chr1000,  # RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000)
          l_byte,l_len  LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_bmt06_s     LIKE bmt_file.bmt06,     #No.FUN-680096 VARCHAR(20)
          l_bmtstr      LIKE type_file.chr20,    #No.FUN-680096 VARCHAR(20)
          l_tmpstr      STRING,                  #MOD-530298 替代(SUB)或'取代(UTE) 
          l_now,l_now2  LIKE type_file.num5      #No.FUN-680096 SMALLINT

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bma01,sr.bma06,sr.order1 #FUN-550093
  FORMAT
   PAGE HEADER
      CALL s_effver(sr.bma01,tm.effective) RETURNING l_ver
      #有效日期

      SELECT ima02,ima021,ima05,ima08,ima63,ima55
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
        FROM ima_file
       WHERE ima01 = sr.bma01
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

#-------No:TQC-5B0107 modify #&051112
#   #----No:TQC-5B0030 modify
#     PRINT COLUMN  1,g_x[15] CLIPPED,sr.bma01,
#           COLUMN 40,g_x[21] CLIPPED,l_ima05,
#           COLUMN 56,g_x[22] CLIPPED,l_ima08,
#           COLUMN 63,g_x[16] CLIPPED,l_ima63,
#           COLUMN 77,g_x[18] CLIPPED,l_ima55
#   #-----end
      PRINT COLUMN 1,g_x[21] CLIPPED,l_ima05,
            COLUMN 17,g_x[22] CLIPPED,l_ima08,
            COLUMN 25,g_x[16] CLIPPED,l_ima63,
            COLUMN 40,g_x[18] CLIPPED,l_ima55,
            COLUMN 57,g_x[20] CLIPPED,tm.a USING '<<<<<',
            COLUMN 71,g_x[49] CLIPPED,sr.bma06 #FUN-550093
      PRINT COLUMN  1,g_x[15] CLIPPED,sr.bma01
 
      PRINT COLUMN  1,g_x[17] CLIPPED,l_ima02
#           COLUMN 50,g_x[20] CLIPPED,tm.a USING '<<<<<',
#           COLUMN 64,g_x[49] CLIPPED,sr.bma06 #FUN-550093
      PRINT COLUMN  1,g_x[30] CLIPPED,l_ima021
      PRINT ' '
      #----
#------------No:TQC-5B0030 end

      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
      PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINTX name=H3 g_x[47],g_x[48]
      PRINT g_dash1
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.bma06 #FUN-550093
      IF (PAGENO > 1 OR LINENO > 13)
         THEN SKIP TO TOP OF PAGE
      END IF

   ON EVERY ROW
      IF sr.phatom IS NOT NULL AND sr.phatom != ' ' THEN
         PRINT column 5,g_x[23] clipped,' ',sr.phatom
      END IF
      LET l_bmb06 = sr.bmb06 * tm.a
      IF sr.bmb08=0 THEN LET sr.bmb08=NULL END IF
      PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '###&', #FUN-590118
                     COLUMN g_c[32],sr.bmb03,
                     COLUMN g_c[33],sr.ima08,
                     COLUMN g_c[34],sr.bmb10,
                     COLUMN g_c[35],cl_numfor(l_bmb06,35,4),
                     COLUMN g_c[36],sr.bmb04,
                     COLUMN g_c[37],cl_numfor(sr.bmb08,37,3),
                     COLUMN g_c[38],sr.bmb16,' ';
      IF g_sma.sma888[1,1] = 'Y' THEN
          PRINTX name=D1 COLUMN g_c[39],sr.ima15 CLIPPED
      ELSE
          PRINTX name=D1 COLUMN g_c[39],' '
      END IF
      IF sr.phatom IS NOT NULL AND sr.phatom !=' '
      THEN LET l_bmt01 = sr.phatom
      ELSE LET l_bmt01 = sr.bma01
      END IF
      IF sr.bmb07=1 THEN LET sr.bmb07=NULL END IF
      PRINTX name=D2 COLUMN g_c[40],' ',
                     COLUMN g_c[41],sr.ima02,
                     COLUMN g_c[42],' ',
                     COLUMN g_c[43],' ',
                     COLUMN g_c[44],sr.bmb07 USING '#####&.&&&&',
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
         FOREACH q600_bmt
         USING l_bmt01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 #FUN-550093
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
      ELSE
         PRINT ''
      END IF
      #-->列印取替代料
      IF tm.d ='Y' AND sr.bmb16 MATCHES '[12SU]' THEN
         LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file",
                   " WHERE bmd01='",sr.bmb03,"' AND bmd04=ima01",
                   "  AND (bmd08='",sr.bma01,"' OR bmd08='ALL')"
         IF tm.effective IS NOT NULL THEN
            LET l_sql=l_sql CLIPPED,
                " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
                " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
         END IF
         PREPARE q600_sub_p FROM l_sql
         DECLARE q600_sub_c CURSOR FOR q600_sub_p
         FOREACH q600_sub_c INTO l_bmd.*, l_ima02, l_ima021
           #PRINT '   (',l_bmd.bmd04,')',
           #          COLUMN 38,l_bmd.bmd07 USING '####&.&&&&',
           #          COLUMN 49,l_bmd.bmd05
           #PRINT '    ',l_ima02,COLUMN 49,l_bmd.bmd06
           #PRINT '    ',l_ima021
             #MOD-530298
            LET l_tmpstr=''
            IF sr.bmb16='S' THEN
               LET l_tmpstr='(SUB) '
            END IF
            IF sr.bmb16='U' THEN
               LET l_tmpstr='(UTE) '
            END IF
            PRINTX name=D1 COLUMN g_c[32],l_tmpstr,'(',l_bmd.bmd04,')',
                           COLUMN g_c[35],cl_numfor(l_bmd.bmd07,35,4),
                           COLUMN g_c[36],l_bmd.bmd05
            PRINTX name=D2 COLUMN g_c[41],l_ima02,
                           COLUMN g_c[45],l_bmd.bmd06
            PRINTX name=D3 COLUMN g_c[48],l_ima021

         END FOREACH
      END IF
      IF tm.b ='Y' THEN
         #--->處理說明的部份, 本程式在此假設其最大的內容不會超過100筆
         FOR g_cnt=1 TO 100
             LET l_bmc05[g_cnt]=NULL
         END FOR
         LET l_now=1
         IF sr.phatom IS NOT NULL AND sr.phatom !=' '
         THEN LET l_bmc01 = sr.phatom
         ELSE LET l_bmc01 = sr.bma01
         END IF
         FOREACH q600_bmc
         USING l_bmc01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bma06 #FUN-550093
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
                PRINT COLUMN 58,l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED
            END FOR
         END IF
      END IF

  #AFTER GROUP OF sr.bma01
  #   LET g_pageno = 0

   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      PRINT ' '
      PRINT g_x[24] CLIPPED
      PRINT g_dash
      IF l_last_sw = 'y'
#       OR l_last_sw = 'y'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
