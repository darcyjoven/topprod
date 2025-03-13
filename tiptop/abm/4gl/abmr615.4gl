# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abmr615.4gl
# Descriptions...: 單階插件位置用途查詢
# Input parameter: 
# Return code....: 
# Date & Author..: 92/02/12 BY MAY
# Modify.........: 92/10/28 BY Apple
# Modify.........: No.FUN-4B0024 04/11/03 By Smapmin 主件編號,元件編號開窗
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560098 05/06/18 By kim 報表列印要加印主件特性代碼
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-7A0066 08/04/03 By jamie 排序錯誤
# Modify.........: No.FUN-850057 08/05/14 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			   	    # Print condition RECORD
        		wc  	  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
           		effective LIKE type_file.dat,     #No.FUN-680096 DATE
                        s         LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
           		more	  LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
 
DEFINE   g_i     LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE  g_str    STRING    #NO.FUN-850057
DEFINE  g_sql    STRING    #NO.FUN-850057
DEFINE  l_table  STRING    #NO.FUN-850057
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
   #NO.FUN-850057----BEGIN-----
   LET g_sql = "order1.bmb_file.bmb01,", 
                "order2.bmb_file.bmb01,",
                "order3.bmb_file.bmb01,",
                "bmt06.bmt_file.bmt06,",
                "bmb03.bmb_file.bmb03,",
                "ima08.ima_file.ima08,",
                "ima37.ima_file.ima37,",
                "bmb01.bmb_file.bmb01,",
                "l_ver.ima_file.ima05,",
                "ima08_1.ima_file.ima08,",
                "ima37_1.ima_file.ima37,",
                "bmt07.bmt_file.bmt07,",
                "bmb10.bmb_file.bmb10,",
                "bmb04.bmb_file.bmb04,", 
                "bmb05.bmb_file.bmb05,",
                "ima02.ima_file.ima02,",
                "ima02_1.ima_file.ima02,",
                "ima021.ima_file.ima021,",                                        
                "ima021_1.ima_file.ima021,",
                "bmb29.bmb_file.bmb29"
   LET l_table = cl_prt_temptable('abmr615',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850057----END-----
 
   LET g_pdate = ARG_VAL(1)		         # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.effective  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r615_tm(0,0)			# Input print condition
      ELSE CALL abmr615()	    		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r615_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,    #資料筆數  #No.FUN-680096 VARCHAR(1)
          l_date        LIKE type_file.dat,     #工程變異之生效日期 #No.FUN-680096 DATE
          l_bmb03       LIKE bmb_file.bmb01,	#工程變異之生效日期
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 9
 
   OPEN WINDOW r615_w AT p_row,p_col
        WITH FORM "abm/42f/abmr615" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL	            		# Default condition
   LET tm.effective = g_today                   # 有效日期
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bmt06,bmt03,bmt01,bmt08 #FUN-560098
   
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP #FUN-4B0024
      IF INFIELD(bmt01) THEN
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_bmt"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO bmt01
         NEXT FIELD bmt01
      END IF
       IF INFIELD(bmt03) THEN
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_bmt1"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO bmt03
         NEXT FIELD bmt03
      END IF
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r615_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.effective,tm2.s1,tm2.s2,tm2.s3,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         IF INT_FLAG THEN EXIT INPUT END IF
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW r615_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr615'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr615','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",            #TQC-610068
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr615',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r615_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr615()
   ERROR ""
END WHILE
   CLOSE WINDOW r615_w
END FUNCTION
 
FUNCTION abmr615()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(40)
          sr  RECORD
              order1  LIKE bmb_file.bmb01,    #No.FUN-680096 VARCHAR(40)
              order2  LIKE bmb_file.bmb01,    #No.FUN-680096 VARCHAR(40)
              order3  LIKE bmb_file.bmb01,    #No.FUN-680096 VARCHAR(40)
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #生效日
              bmb05 LIKE bmb_file.bmb05,    #失效日
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb29 LIKE bmb_file.bmb29,    #FUN-560098
              bmt06 LIKE bmt_file.bmt06,    #balloon 
              bmt07 LIKE bmt_file.bmt07,    #QPA     
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本 
              ima08 LIKE ima_file.ima08,    #來源
              ima37 LIKE ima_file.ima37     #補貨
          END RECORD
#NO.FUN-850057---BEGIN----
DEFINE  l_ima02   LIKE ima_file.ima02,
        l_ima021  LIKE ima_file.ima021, 
        l_ima05   LIKE ima_file.ima05,
        l_ima08   LIKE ima_file.ima08,
        l_ima37   LIKE ima_file.ima37,
        l_ver     LIKE ima_file.ima05
#NO.FUN-850057----END------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '','','',",
                 " bmb01,bmb03,bmb04,bmb05,",
                 " bmb10,bmb29,bmt06,bmt07,ima02,ima021,ima05,ima08,ima37 ", #FUN-510033 add ima021  #FUN-560098
                 " FROM bmb_file,ima_file,bmt_file ",
                 " WHERE bmb03 = ima01    ",     #元件
                 "   AND bmb01 = bmt01    ",   
                 "   AND bmb02 = bmt02    ",  
                 "   AND bmb03 = bmt03    ", 
                 "   AND bmb04 = bmt04    ", 
                 "   AND bmb29 = bmt08    ",  #FUN-560098
                 " AND ",tm.wc CLIPPED
 
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
          LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
          "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
          "' OR bmb05 IS NULL)"
     END IF
 
     PREPARE r615_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
           
     END IF
     DECLARE r615_curs1 CURSOR FOR r615_prepare1
 
#     CALL cl_outnam('abmr615') RETURNING l_name    #NO.FUN-850057
#     START REPORT r615_rep TO l_name               #NO.FUN-850057
     CALL cl_del_data(l_table)   #NO.FUN-850057
     LET g_pageno = 0
     FOREACH r615_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF sr.bmb03 IS NULL THEN LET sr.bmb03 = ' ' END IF
       IF sr.bmb01 IS NULL THEN LET sr.bmb01 = ' ' END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bmt06
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bmb03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.bmb01
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       #NO.FUN-850057------BEGIN-----
       SELECT ima02,ima021,ima05,ima08,ima37 
          INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima37
          FROM ima_file 
         WHERE ima01 = sr.bmb01
       CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver
       EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.bmt06,
                                 sr.bmb03,sr.ima08,sr.ima37,sr.bmb01,
                                 l_ver,l_ima08,l_ima37,sr.bmt07,sr.bmb10,
                                 sr.bmb04,sr.bmb05,sr.ima02,l_ima02,
                                 sr.ima021,l_ima021,sr.bmb29
       #OUTPUT TO REPORT r615_rep(sr.*)
       #NO.FUN-8500
     END FOREACH
 
    #DISPLAY "" AT 2,1
    #NO.FUN-850057-----BEGIN----
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
    IF g_zz05='Y' THEN
       CALL cl_wcchp(tm.wc,'bmt06,bmt03,bmt01,bmt08')
            RETURNING tm.wc
    ELSE
       LET tm.wc = ""
    END IF
    LET g_str = tm.wc,";",tm.effective,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
    CALL cl_prt_cs3('abmr615','abmr615',g_sql,g_str)
    # FINISH REPORT r615_rep
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #NO.850057-----END------
END FUNCTION
#NO.FUN-870144
#NO.FUN-850057-----BEGIN-----
#REPORT r615_rep(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
#         l_ima02   LIKE ima_file.ima02,
#         l_ima021  LIKE ima_file.ima021,  #FUN-510033
#         l_ima05   LIKE ima_file.ima05,
#         l_ima08   LIKE ima_file.ima08,
#         l_ima37   LIKE ima_file.ima37,
#         l_cnt     LIKE type_file.num10,  #No.FUN-680096 INTEGER
#         sr  RECORD
#             order1  LIKE bmb_file.bmb01,  #No.FUN-680096 VARCHAR(40)
#             order2  LIKE bmb_file.bmb01,  #No.FUN-680096 VARCHAR(40)
#             order3  LIKE bmb_file.bmb01,  #No.FUN-680096 VARCHAR(40)
#             bmb01 LIKE bmb_file.bmb01,    #主件料件
#             bmb03 LIKE bmb_file.bmb03,    #元件料號
#             bmb04 LIKE bmb_file.bmb04,    #生效日
#             bmb05 LIKE bmb_file.bmb05,    #失效日
#             bmb10 LIKE bmb_file.bmb10,    #發料單位
#             bmb29 LIKE bmb_file.bmb29,    #FUN-560098
#             bmt06 LIKE bmt_file.bmt06,    #balloon
#             bmt07 LIKE bmt_file.bmt07,    #QPA
#             ima02 LIKE ima_file.ima02,    #品名規格
#             ima021 LIKE ima_file.ima021,  #FUN-510033
#             ima05 LIKE ima_file.ima05,    #版本 
#             ima08 LIKE ima_file.ima08,    #來源
#             ima37 LIKE ima_file.ima37     #補貨
#         END RECORD,
#         l_ver   LIKE ima_file.ima05
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
##ORDER BY sr.bmt06,sr.bmb03,sr.order1,sr.order2,sr.order3 #FUN-7A0066 mark 
# ORDER BY sr.order1,sr.order2,sr.order3,sr.bmt06,sr.bmb03 #FUN-7A0066 mod 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno" 
#     PRINT g_head CLIPPED,pageno_total     
#     PRINT g_x[18] CLIPPED,tm.effective
#     PRINT g_dash
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#     PRINTX name=H2 g_x[42],g_x[50],g_x[51],g_x[43],g_x[44],g_x[45]
#     PRINTX name=H3 g_x[46],g_x[52],g_x[53],g_x[47],g_x[48],g_x[49]  #FUN-560098
#     PRINT g_dash1 
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.bmt06
#     PRINTX name=D1 COLUMN g_c[31],sr.bmt06;
 
#  BEFORE GROUP OF sr.bmb03 
#     PRINTX name=D1 COLUMN g_c[32],sr.bmb03,
#                    COLUMN g_c[33],sr.ima08,
#                    COLUMN g_c[34],sr.ima37;
#     LET l_cnt = 0
 
#  ON EVERY ROW
#     SELECT ima02,ima021,ima05,ima08,ima37 
#       INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima37
#       FROM ima_file 
#      WHERE ima01 = sr.bmb01
#     CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver
#     PRINTX name=D1 COLUMN g_c[35],sr.bmb01,
#                    COLUMN g_c[36],l_ver,
#                    COLUMN g_c[37],l_ima08,
#                    COLUMN g_c[38],l_ima37,
#                    #COLUMN g_c[39],cl_numfor(sr.bmt07,39,3),   #FUN-550106
#                    COLUMN g_c[39],cl_numfor(sr.bmt07,39,5),   #FUN-550106
#                    COLUMN g_c[40],sr.bmb10,
#                    COLUMN g_c[41],sr.bmb04
#     IF l_cnt = 0 THEN 
#        PRINTX name=D2 COLUMN g_c[42],' ',
#                       COLUMN g_c[43],sr.ima02;
#     END IF
#     PRINTX name=D2 COLUMN g_c[44],l_ima02,
#                    COLUMN g_c[45],sr.bmb05
#     IF l_cnt = 0 THEN 
#        PRINTX name=D3 COLUMN g_c[46],' ',
#                       COLUMN g_c[47],sr.ima021;
#     END IF
#     PRINTX name=D3 COLUMN g_c[48],l_ima021,
#                    COLUMN g_c[49],sr.bmb29 #FUN-560098
#     LET l_cnt = l_cnt + 1
#     PRINT ' '   #FUN-7A0066 add
 
#  ON LAST ROW
#     IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     ELSE
#         SKIP 2 LINE
#     END IF
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-850057----EDN------
