# Prog. Version..: '1.00.01-04.05.17'     #
# Pattern name...: axmr410.4gl
# Descriptions...: 客戶訂單明細表
# Date & Author..: 95/01/07 by Nick
#

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD            
           wc      VARCHAR(500),            # QBE 條件
           s       VARCHAR(03),             # 排列 (INPUT 條件)
           t       VARCHAR(03),             # 跳頁 (INPUT 條件)
           u       VARCHAR(03),             # 合計 (INPUT 條件)
           a       VARCHAR(01),     
           b       VARCHAR(01),     
           c       VARCHAR(01),     
           more    VARCHAR(01)              # 輸入其它特殊列印條件
           END RECORD 
DEFINE    g_x ARRAY[38] OF VARCHAR(40)      # 放置 za Array 變數
DEFINE    g_orderA ARRAY[3] OF VARCHAR(10)  # 篩選排序條件用變數

DEFINE   g_dash          VARCHAR(400)       #Dash line
DEFINE   g_i             SMALLINT           #count/index for any purpose
DEFINE   g_len           SMALLINT           #Report width(79/132/136)
DEFINE   g_zz05          VARCHAR(1)         #Print tm.wc ?(Y/N)
DEFINE   g_pageno        SMALLINT           #Report page no
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT   

   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   LET g_pdate  = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.u     = ARG_VAL(10)
   LET tm.a     = ARG_VAL(11)
   LET tm.b     = ARG_VAL(12)
   LET tm.c     = ARG_VAL(13)
   LET tm.more  = ARG_VAL(14)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
  
   IF NOT cl_null(tm.wc) THEN  
      CALL r410()
   ELSE  
      CALL r410_tm(0,0)        
   END IF
END MAIN

FUNCTION r410_tm(p_row,p_col)
DEFINE p_row,p_col    SMALLINT 
DEFINE l_cmd          VARCHAR(1000)

   #開啟視窗
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r410_w AT p_row,p_col WITH FORM "axm/42f/axmr410" 
      ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   #預設畫面欄位
   INITIALIZE tm.* TO NULL        
   LET tm2.s1  = '1'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.c    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'

WHILE TRUE

   # QBE 
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,
                              oea14,oea15,oea23,oea12,oeahold
       ON ACTION locale
          LET g_action_choice = "locale"
          EXIT CONSTRUCT

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r410_w 
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE 
   END IF


   # INPUT 
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.a,tm.b,tm.c,tm.more
      WITHOUT DEFAULTS 
      AFTER FIELD more    #是否輸入其它特殊條件
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()  

      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW r410_w 
      EXIT PROGRAM
   END IF

   #選擇延後執行本作業 ( Background Job 設定)
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='axmr410'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr410','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'"
         CALL cl_cmdat('axmr410',g_time,l_cmd) 
      END IF
      CLOSE WINDOW r410_w
      EXIT PROGRAM
   END IF

   CALL cl_wait()  # 列印中，請稍候
   #開始製作報表 
   CALL r410()
   ERROR ""
END WHILE
   CLOSE WINDOW r410_w
END FUNCTION

FUNCTION r410()
DEFINE l_name    VARCHAR(20)          # External(Disk) file name
DEFINE l_time    VARCHAR(8)           # Used time for running the job
DEFINE l_sql     VARCHAR(1000)        # SQL STATEMENT
DEFINE l_za05    VARCHAR(40) 
DEFINE l_order   ARRAY[5] OF VARCHAR(10) 
DEFINE sr        RECORD order1  VARCHAR(20),
                        order2  VARCHAR(20),
                        order3  VARCHAR(20),
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,      
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,	#客戶簡稱
                        oea04   LIKE oea_file.oea04,	#客戶編號
                        occ02   LIKE occ_file.occ02,	#客戶簡稱
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea23   LIKE oea_file.oea23,      
                        oea21   LIKE oea_file.oea21,      
                        oea12   LIKE oea_file.oea12,      
                        oea25   LIKE oea_file.oea25,      
                        oea32   LIKE oea_file.oea32,      
                        oeahold LIKE oea_file.oeahold,
                        oeaconf LIKE oea_file.oeaconf,
                        oeb03   LIKE oeb_file.oeb03,      
                        oeb04   LIKE oeb_file.oeb04,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,      
                        oeb12   LIKE oeb_file.oeb12,
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
                        oeb15   LIKE oeb_file.oeb15 
                        END RECORD

     CALL cl_used('axmr410',l_time,1) RETURNING l_time
     #抓取公司名稱
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
     #抓取表頭資料 (za_file)
     DECLARE r410_za_cur CURSOR FOR
             SELECT za02,za05 
               FROM za_file
              WHERE za01 = "axmr410" AND za03 = g_rlang
     FOREACH r410_za_cur INTO g_i,l_za05
      LET g_x[g_i] = l_za05
     END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05    #取得報表長度 & 是否列印選擇條件 
       FROM zz_file WHERE zz01 = 'axmr410'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     IF g_priv2='4' THEN                   #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                   #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     SELECT azi03,azi04,azi05 
       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
       FROM azi_file
      WHERE azi01=g_aza.aza17

     #抓取資料
     LET l_sql = "SELECT '','','',                                ",
                 "      oea01, oea02, oea03, A.occ02, oea04, B.occ02, ",
                 "      gen02, gem02, oea23, oea21, oea12, oea25, ",
                 "      oea32, oeahold,oeaconf,oeb03, oeb04, oeb06,",
                 "      oeb05, oeb12, oeb13,oeb14, oeb15 ",
                 " FROM oea_file, OUTER occ_file A,OUTER occ_file B,",
                 "      OUTER gen_file, OUTER gem_file, oeb_file ",
                 " WHERE oea03 = A.occ01 AND B.occ01 = oea04  ",
                 "   AND gen_file.gen01 = oea14 ",
                 "   AND gem_file.gem01 = oea15 AND oea01=oeb_file.oeb01 ",
                 "   AND oeaconf!='X' ",
                 "   AND ", tm.wc CLIPPED
     PREPARE r410_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        EXIT PROGRAM 
     END IF
     DECLARE r410_curs1 CURSOR FOR r410_prepare1
     CALL cl_outnam('axmr410') RETURNING l_name
     START REPORT r410_rep TO l_name
     LET g_pageno = 0
     FOREACH r410_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN 
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
          END IF
          IF tm.a = '1' AND sr.oeaconf = 'N' THEN
             CONTINUE FOREACH 
          END IF
          IF tm.a = '2' AND sr.oeaconf = 'Y' THEN 
             CONTINUE FOREACH 
          END IF
          IF tm.b = '1' AND cl_null(sr.oeahold) THEN
             CONTINUE FOREACH 
          END IF
          IF tm.b = '2' AND NOT cl_null(sr.oeahold) THEN 
             CONTINUE FOREACH 
          END IF

          #篩選排列順序條件
          FOR g_i = 1 TO 3
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea01
                                            LET g_orderA[g_i]= g_x[30]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea02 
                                                USING 'yyyymmdd'
                                            LET g_orderA[g_i]= g_x[31]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea03
                                            LET g_orderA[g_i]= g_x[32]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea04
                                            LET g_orderA[g_i]= g_x[33]
                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.gen02
                                            LET g_orderA[g_i]= g_x[34]
                   WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.gem02
                                            LET g_orderA[g_i]= g_x[35]
                   WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
                                            LET g_orderA[g_i]= g_x[36]
                   WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oea12
                                            LET g_orderA[g_i]= g_x[37]
                   WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i]=sr.oeahold
                                            LET g_orderA[g_i]= g_x[38]
                   OTHERWISE LET l_order[g_i]  = '-'       
                             LET g_orderA[g_i] = ' '          #清為空白
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          OUTPUT TO REPORT r410_rep(sr.*)
     END FOREACH

     FINISH REPORT r410_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_used('axmr410',l_time,2) RETURNING l_time
END FUNCTION

REPORT r410_rep(sr)
DEFINE l_last_sw    VARCHAR(1) 
DEFINE sr           RECORD order1 VARCHAR(20),
                           order2 VARCHAR(20),
                           order3 VARCHAR(20),
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,      
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,	#客戶簡稱
                        oea04   LIKE oea_file.oea04,	#客戶編號
                        occ02   LIKE occ_file.occ02,	#客戶簡稱
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea23   LIKE oea_file.oea23,      
                        oea21   LIKE oea_file.oea21,      
                        oea12   LIKE oea_file.oea12,      
                        oea25   LIKE oea_file.oea25,      
                        oea32   LIKE oea_file.oea32,      
                        oeahold LIKE oea_file.oeahold,
                        oeaconf LIKE oea_file.oeaconf,
                        oeb03   LIKE oeb_file.oeb03,      
                        oeb04   LIKE oeb_file.oeb04,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,      
                        oeb12   LIKE oeb_file.oeb12,
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
                        oeb15   LIKE oeb_file.oeb15
                    END RECORD,
		l_rowno SMALLINT,
		l_amt_1 DECIMAL(17,5),
		l_amt_2 DECIMAL(17,5)
  
  #邊界設定
  OUTPUT TOP MARGIN 0
         LEFT MARGIN 0
         BOTTOM MARGIN 5
         PAGE LENGTH 66
  ORDER BY sr.order1,sr.order2,sr.order3     #排序
  #格式設定
  FORMAT
 
   #列印表頭
   PAGE HEADER
      PRINT (g_len-length(g_company))/2 SPACES,g_company
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-length(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-length(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN 40,g_x[23] CLIPPED,
            g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,'-',
            g_orderA[3] CLIPPED;
	  CASE tm.a 
		WHEN '1' PRINT '     ',g_x[24] CLIPPED; 
		WHEN '2' PRINT '     ',g_x[25] CLIPPED; 
		WHEN '3' PRINT '     ',g_x[26] CLIPPED; 
	  END CASE
	  CASE tm.b
		WHEN '1' PRINT '     ',g_x[27] CLIPPED; 
		WHEN '2' PRINT '     ',g_x[28] CLIPPED; 
		WHEN '3' PRINT '     ',g_x[29] CLIPPED; 
	  END CASE
	  PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      PRINT g_x[11],COLUMN 41,g_x[12],COLUMN 81,g_x[13],
            COLUMN 121,g_x[14] CLIPPED
      PRINT g_x[15],COLUMN 41,g_x[16] CLIPPED
      PRINT g_x[17] CLIPPED, g_x[18] CLIPPED, 
            g_x[19] CLIPPED, g_x[20] CLIPPED
      LET l_last_sw = 'n'

   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y'           #跳頁控制
         THEN SKIP TO TOP OF PAGE
      END IF

   BEFORE GROUP OF sr.order2       #跳頁控制 
      IF tm.t[2,2] = 'Y'           
         THEN SKIP TO TOP OF PAGE
      END IF

   BEFORE GROUP OF sr.order3       #跳頁控制
      IF tm.t[3,3] = 'Y' 
         THEN SKIP TO TOP OF PAGE
      END IF

   BEFORE GROUP OF sr.oea01
      SELECT azi03,azi04,azi05
        INTO g_azi03,g_azi04,g_azi05 
        FROM azi_file
       WHERE azi01=sr.oea23
      LET l_rowno = 1
      PRINT 	COLUMN 1 ,sr.oea01 CLIPPED,
                        COLUMN 12,sr.oea03[1,6] CLIPPED,
                        COLUMN 19,sr.oea032 CLIPPED,
                        COLUMN 28,sr.gen02 CLIPPED,
                        COLUMN 37,sr.oea23 CLIPPED,
                        COLUMN 42,sr.oea12 CLIPPED,
                        COLUMN 53,sr.oea25 CLIPPED,
                        COLUMN 60,sr.oeahold CLIPPED;
   

   ON EVERY ROW
      PRINT COLUMN 65,sr.oeb03 USING '##',
            COLUMN 68,sr.oeb04 CLIPPED,
            COLUMN 89,sr.oeb05 CLIPPED,
            COLUMN 94,sr.oeb12 USING '########.##',
            COLUMN 106,cl_numfor(sr.oeb13,9,g_azi03),
            COLUMN 117,cl_numfor(sr.oeb14,10,g_azi04),
            COLUMN 129,sr.oeb15
      IF l_rowno = 1 THEN
         PRINT COLUMN 1 ,sr.oea02 CLIPPED,
               COLUMN 12,sr.oea04 CLIPPED,
               COLUMN 19,sr.occ02 CLIPPED,
               COLUMN 28,sr.gem02 CLIPPED,
               COLUMN 37,sr.oea21 CLIPPED,
               COLUMN 53,sr.oea32 CLIPPED,
               COLUMN 60,sr.oeaconf CLIPPED;
		LET l_rowno = l_rowno + 1
      END IF
      PRINT COLUMN 68,sr.oeb06 CLIPPED
		
   AFTER GROUP OF sr.order1            #金額小計
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.oeb14)
         LET l_amt_2 = GROUP SUM(sr.oeb12)
         PRINT ''
         PRINT COLUMN 70,g_orderA[1] CLIPPED,
               COLUMN 80,g_x[21] CLIPPED,
               COLUMN 94,l_amt_2 USING '########.##',
               COLUMN 117,cl_numfor(l_amt_1,10,g_azi05)
		PRINT ''
      END IF

   AFTER GROUP OF sr.order2            #金額小計
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.oeb14)
         LET l_amt_2 = GROUP SUM(sr.oeb12)
         PRINT ''
         PRINT COLUMN 70,g_orderA[2] CLIPPED,
               COLUMN 80,g_x[21] CLIPPED,
               COLUMN 94,l_amt_2 USING '########.##',
               COLUMN 117,cl_numfor(l_amt_1,10,g_azi05)
               PRINT ''
      END IF

   AFTER GROUP OF sr.order3            #金額小計
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.oeb14)
         LET l_amt_2 = GROUP SUM(sr.oeb12)
         PRINT ''
         PRINT COLUMN 70,g_orderA[3] CLIPPED,
               COLUMN 80,g_x[21] CLIPPED,
               COLUMN 94,l_amt_2 USING '########.##',
               COLUMN 117,cl_numfor(l_amt_1,10,g_azi05)
         PRINT ''
      END IF

   ON LAST ROW                         #金額總計
      PRINT ''
      LET l_amt_1 = SUM(sr.oeb14)
      LET l_amt_2 = SUM(sr.oeb12)
      PRINT COLUMN 80,g_x[22] CLIPPED,
            COLUMN 94,l_amt_2 USING '########.##',
            COLUMN 117,cl_numfor(l_amt_1,10,g_azi05)

      #是否列印選擇條件
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
              IF tm.wc[001,070] > ' ' THEN            # for 80
         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
              IF tm.wc[071,140] > ' ' THEN
          PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
              IF tm.wc[141,210] > ' ' THEN
          PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
              IF tm.wc[211,280] > ' ' THEN
          PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, 
            COLUMN (g_len-9), g_x[7] CLIPPED

   #表尾列印
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, 
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
