# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abmq611.4gl
# Descriptions...: 多階材料用途清單
# Input parameter:
# Return code....:
# Date & Author..: 91/08/19 By Nora
# Modify.........: 93/09/14 By Apple(增列說明)
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No:FUN-550093 05/05/26 By kim 配方BOM
# Modify.........: No.FUN-590110 05/09/26 By will  報表轉xml格式
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No:FUN-5A0061 05/11/02 By Pengu 1.報表缺品名或規格
# Modify.........: No:TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No:TQC-620026 06/02/09 By Claire 列印總頁數
# Modify.........: No.FUN-630097 06/04/03 By Claire 排除無效資料
# Modify.........: No.MOD-640206 06/04/09 By Alexstar 增加表頭來原碼欄位的寬度
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No:MOD-6A0022 06/10/31 By pengu FUN-630097,sql組錯,造成報表無法列印
DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm  RECORD				  # Print condition RECORD
    		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
   	    	revision  LIKE aba_file.aba18,    #No.FUN-680096 VARCHAR(2)
       		effective LIKE type_file.dat,     #No.FUN-680096 DATE
       		arrange   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	    	more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
          END RECORD,
          g_bmb03_a       LIKE bmb_file.bmb01,
          g_tot           LIKE type_file.num10    #No.FUN-680096 INTEGER

DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
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
   LET tm.arrange  = ARG_VAL(10)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No:FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q611_tm(0,0)			# Input print condition
      ELSE CALL q611()			# Read bmata and create out-file
   END IF
END MAIN

FUNCTION q611_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
            l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
            l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bmb03       LIKE bmb_file.bmb01,
            l_cmd	  LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)


   LET p_row = 4
   LET p_col = 9

   OPEN WINDOW q611_w AT p_row,p_col WITH FORM "abm/42f/abmq611"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
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
      CONSTRUCT tm.wc ON bmb03,ima06 FROM FORMONLY.item,FORMONLY.class
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
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
         CLOSE WINDOW q611_w
         EXIT PROGRAM
      END IF
      #IF tm.wc = ' 1=1' THEN
      #   CALL cl_err('','9046',0)
      # CONTINUE WHILE
      #END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT bmb03),bmb03 ",
                   "  FROM bmb_file,ima_file",
                   " WHERE bmb03=ima01 AND ima08 !='A' ",
                   "   AND ",tm.wc CLIPPED,
                   " GROUP BY bmb03"
         PREPARE q611_cnt_pre FROM l_cmd
         DECLARE q611_cnt CURSOR FOR q611_cnt_pre
         FOREACH q611_cnt INTO g_cnt,l_bmb03
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

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution

         ON ACTION CONTROLP
            CALL q611_wc()   # Input detail Where Condition
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
         CLOSE WINDOW q611_w
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmq611'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmq611','9031',1)
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
                            " '",tm.arrange CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('abmq611',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW q611_w
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL q611()
      ERROR ""
   END WHILE
   CLOSE WINDOW q611_w
END FUNCTION

FUNCTION q611_wc()
   DEFINE l_wc    LIKE type_file.chr1000#No.FUN-680096 #No.FUN-680096 VARCHAR(500)
   OPEN WINDOW q611_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

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
   CLOSE WINDOW q611_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION

#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# q611()      從單身讀取合乎條件的元件資料
# q611_bom()  處理主件及其相關的展開資料
#-----------------------------------------------------------------
FUNCTION q611()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_bmb03 LIKE bmb_file.bmb03           #元件料件

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-590110  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmq611'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len
#        LET g_dash1[g_i,g_i] = '-'
#        LET g_dash[g_i,g_i] = '='
#    END FOR
#No.FUN-590110  --end

     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同部門的資料
         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     END IF

     LET l_sql = "SELECT UNIQUE bmb03",
                 " FROM bmb_file, ima_file, bma_file",  #FUN-630097
                 " WHERE ima01 = bmb03",
               #---------No:MOD-6A0022 modify
                #" AND bma01 = bmb03",    #FUN-630097
                 " AND bma01 = bmb01",    
               #---------No:MOD-6A0022 end
                 " AND bmaacti = 'Y'",    #FUN-630097
                 " AND ima08 !='A' AND ",tm.wc
     PREPARE q611_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
		 CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM END IF
     DECLARE q611_c1 CURSOR FOR q611_prepare1

     CALL cl_outnam('abmq611') RETURNING l_name
     START REPORT q611_rep TO l_name

# genero  script marked      LET g_pageno = 0
	LET g_tot=0
     FOREACH q611_c1 INTO l_bmb03
       IF SQLCA.sqlcode THEN
		 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       LET g_bmb03_a=l_bmb03
       CALL q611_bom(0,l_bmb03)
     END FOREACH

    #DISPLAY "" AT 2,1
     FINISH REPORT q611_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0060
END FUNCTION

FUNCTION q611_bom(p_level,p_key)
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #元件料件編號
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE bmb_file.bmb02,    #滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_ima06       LIKE ima_file.ima06,    #分群碼
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb01 LIKE bmb_file.bmb01,    #主件料號
              ima02 LIKE ima_file.ima02,    #品名
              ima021 LIKE ima_file.ima021,  #規格  No:FUN-5A0061 add
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
          l_cmd     LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)

	IF p_level > 25 THEN
		CALL cl_err('','mfg2733',1) EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
# genero  script marked         LET g_pageno = 0
        LET sr[1].bmb03 = p_key
        OUTPUT TO REPORT q611_rep(1,0,sr[1].*)	#第0階主件資料
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb01,ima02,ima021,ima05,ima08,",       #No:FUN-5A0061 add
            "bmb02,(bmb06/bmb07),bmb10,bmb04,bmb05,bmb03,bmb29", #FUN-550093
            " FROM bmb_file,ima_file",
            " WHERE bmb03='", p_key,"' AND bmb02 >",b_seq,
            " AND bmb01 = ima01"

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
        PREPARE q611_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
			 CALL cl_err('P1:',SQLCA.sqlcode,1) EXIT PROGRAM END IF
        DECLARE q611_cur CURSOR for q611_ppp

        LET l_ac = 1
        FOREACH q611_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
			LET g_tot=g_tot+1
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            OUTPUT TO REPORT q611_rep(p_level,i,sr[i].*)
            CALL q611_bom(p_level,sr[i].bmb01)
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION

REPORT q611_rep(p_level,p_i,sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          sr  RECORD
              bmb01 LIKE bmb_file.bmb01,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名
              ima021 LIKE ima_file.ima021,  #規格  #No:FUN-5A0061 add
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
          l_ima02 LIKE ima_file.ima02,    #品名
          l_ima021 LIKE ima_file.ima021,  #規格  #No:FUN-5A0061 add
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima15 LIKE ima_file.ima15,    #保稅否
          l_ima25 LIKE ima_file.ima25,    #庫存單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_point  LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
          l_p      LIKE type_file.num5,   #No.FUN-680096 SMALLINT
          l_str2   LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(10)
          l_k      LIKE type_file.num5    #No.FUN-680096 SMALLINT

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
#No.FUN-590110  --begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      #LET pageno_total = PAGENO USING '<<<'           #TQC-620026
      LET pageno_total = PAGENO USING '<<<',"/pageno"  #TQC-620026
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[23] CLIPPED,tm.effective
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     #報表名稱
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
# genero  script marked       LET g_pageno = g_pageno + 1
#     PRINT ' '
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#           COLUMN 35,g_x[23] CLIPPED,tm.effective,
#           COLUMN g_len-7,g_x[3] CLIPPED
#           g_pageno USING '<<<'
      PRINT g_dash[1,g_len]
      SELECT ima02,ima021,ima05,ima06,        #No:FUN-5A0061 add
             ima08,ima15,ima25,ima55,ima63
       INTO l_ima02,l_ima021,l_ima05,l_ima06, #No:FUN-5A0061 add
            l_ima08,l_ima15,l_ima25,l_ima55,l_ima63
       FROM ima_file
      WHERE ima01=g_bmb03_a
      IF SQLCA.sqlcode THEN
          LET l_ima02='' LET l_ima05=''
          LET l_ima06='' LET l_ima08=''
          LET l_ima55='' LET l_ima63=''
      END IF

#------No:TQC-5B0107 modify  #&051112
      PRINT COLUMN  1,g_x[11] CLIPPED, g_bmb03_a CLIPPED, #FUN-5B0013 add CLIPPED
            COLUMN 55,g_x[20] clipped,l_ima08,           #來源
            COLUMN 65,g_x[21] clipped,l_ima06,           #分群碼 #MOD-640206
            COLUMN 85,g_x[14] CLIPPED,l_ima25 CLIPPED    #庫存單位
      PRINT COLUMN  1,g_x[12] CLIPPED,l_ima02 CLIPPED, #FUN-5B0013 add CLIPPED
            COLUMN 85,g_x[13] CLIPPED,l_ima63 CLIPPED   #發料單位
      PRINT COLUMN  1,g_x[25] CLIPPED,l_ima021 CLIPPED; #No:FUN-5A0061 add
      IF g_sma.sma888[1,1] = 'Y'
      THEN PRINT COLUMN 85,g_x[22] clipped,l_ima15      #No:FUN-5A0061 modify
#------No:TQC-5B0107 end

      ELSE PRINT ''
      END IF
      PRINT ' '
      #FUN-550093................begin
     #PRINT COLUMN 56,g_x[17] CLIPPED
     #PRINT g_x[15] CLIPPED,COLUMN 25,g_x[16] CLIPPED,
     #      COLUMN 56,g_x[18] CLIPPED
     #PRINT '1.3.5.7.9-------------- --------------',
     #      '---------------- -- -- ----------- ----'
#     PRINT COLUMN 77,g_x[17] CLIPPED
#     PRINT g_x[15] CLIPPED,COLUMN 25,g_x[24],COLUMN 46,g_x[16] CLIPPED,
#           COLUMN 77,g_x[18] CLIPPED
#     PRINT '1.3.5.7.9-------------- --------------------',
#           ' ------------------------------ -- -- ----------- ----'
#---------No:FUN-5A0061 add
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINTx name=H2 g_x[36],g_x[37],g_x[38],g_x[39]
#-----------end
      PRINT g_dash1
      #FUN-550093................end
      LET l_last_sw = 'n'

   ON EVERY ROW
      IF p_level = 1 AND p_i = 0 THEN
           IF (PAGENO > 1 OR LINENO > 13) THEN
# genero  script marked                 LET g_pageno = 0
                SKIP TO TOP OF PAGE
# genero  script marked                 LET g_pageno = 1
           END IF
      ELSE
          IF p_level> 10 THEN LET p_level=10 END IF
          LET l_point = ' '
          IF p_level > 1 THEN
             FOR l_p = 1 TO p_level - 1
                 LET l_point = l_point clipped,'.'
             END FOR
          END IF
#         PRINT column p_level,sr.bmb01 clipped,
#         PRINT COLUMN  1,l_point clipped,sr.bmb01 clipped,
#               COLUMN 25,sr.bmb29,
#               COLUMN 46,sr.ima02,
#               COLUMN 77,sr.ima05,
#               COLUMN 80,sr.ima08,
#               COLUMN 83,sr.bmb06 USING '-----&.&&&&',
#               COLUMN 95,sr.bmb10

#---------No:FUN-5A0061 modify
#         PRINT COLUMN g_c[31],l_point CLIPPED,sr.bmb01 CLIPPED,
#               COLUMN g_c[32],sr.bmb29,
#               #COLUMN g_c[33],sr.ima02[1,30] CLIPPED, #FUN-5B0013 mark
#               COLUMN g_c[33],sr.ima02 CLIPPED, #FUN-5B0013 add
#               COLUMN g_c[34],sr.ima05,
#               COLUMN g_c[35],sr.ima08,
#               COLUMN g_c[36],cl_numfor(sr.bmb06,36,4),
#               COLUMN g_c[37],sr.bmb10
          PRINTX name=D1
                 COLUMN g_c[31],l_point CLIPPED,sr.bmb01 CLIPPED,
                 COLUMN g_c[32],sr.bmb29,
                 COLUMN g_c[33],sr.ima02 CLIPPED, #FUN-5B0013 add
                 COLUMN g_c[34],sr.ima05,
                 COLUMN g_c[35],cl_numfor(sr.bmb06,35,4)
          PRINTX name=D2
                 COLUMN g_c[37],sr.ima021 CLIPPED,
                 COLUMN g_c[38],sr.ima08,
                 COLUMN g_c[39],sr.bmb10
#------------end

      END IF
#No.FUN-590110  --end

   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'

   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT
#Patch....NO:TQC-610035 <> #
