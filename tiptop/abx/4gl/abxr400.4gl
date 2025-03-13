# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr400.4gl
# Descriptions...: 進口原料關稅總表列印
# Date & Author..: 97/08/14 By Danny
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima02
# Modify.........: No.FUN-530012 05/03/21 By kim 報表轉XML功能
# Modify.........: No.FUN-560231 05/06/27 By Mandy QPA欄位放大
# Modify.........: No.MOD-580042 05/08/09 By Rosayu1.l_sql內應剔除出通單的資料
# Modify.........:                                 2.r400_bom中的l_cmd�，b_seq未給初值，導致初次進本段程序時b_seq為空，語法錯誤
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-730122 07/04/02 By Ray 無法抓到資料
# Modify.........: No.FUN-740077 07/04/19 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.TQC-920040 08/02/16 By ve007 MARK rowid 和b_seq 的內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE g_wc          STRING,	# Where condition  #No.FUN-580092 HCN       
           g_bnd01_a     LIKE bnd_file.bnd01,
           g_effective   LIKE type_file.dat      #No.FUN-680062  date
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   l_table     STRING                       ### FUN-740077 add ###
DEFINE   g_sql       STRING                       ### FUN-740077 add ###
DEFINE   g_str       STRING                       ### FUN-740077 add ###


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	       			# Supress DEL key function

   LET g_pdate = ARG_VAL(1)	       	# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF

  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740077 *** ##
     LET g_sql = "bnd01.bnd_file.bnd01,",
                 "bne03.bne_file.bne03,",    #項次
                 "bne05.bne_file.bne05,",    #元件料號
                 "bne08.bne_file.bne08,",    #QPA
                 "ima02.ima_file.ima02,",    #品名規格
                 "ima15.ima_file.ima15,",    #品名規格
                 "ima22.ima_file.ima22,",    #稅率
                 "ima25.ima_file.ima25,",    #單位
                 "ima95.ima_file.ima95,",    #保稅單價
                 "oga01.oga_file.oga01,",    
                 "ogb03.ogb_file.ogb03,",    
                 "ogb04.ogb_file.ogb04,",    
                 "ogb12.ogb_file.ogb12,",    
                 "tot.bne_file.bne08,",    
                 "amt.type_file.num20_6,",
                 "l_ima02_1.ima_file.ima02,",
                 "l_ima021_1.ima_file.ima021,",
                 "l_ima021_2.ima_file.ima021"
 
   LET l_table = cl_prt_temptable('abxr400',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r400_tm(0,0)		# Input print condition
      ELSE CALL abxr400()	        # Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION r400_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680062 smallint
          l_flag        LIKE type_file.num5,          #No.FUN-680062 smallint 
          l_one         LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)            	#資料筆數
          l_bdate       LIKE bnd_file.bnd02,
          l_edate       LIKE bnd_file.bnd03,
          l_bnd01       LIKE bnd_file.bnd01,	#工程變異之生效日期
          l_cmd		LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   OPEN WINDOW r400_w WITH FORM "abx/42f/abxr400" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
   CONSTRUCT BY NAME g_wc ON oga01,oga02 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION locale
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

         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
 END CONSTRUCT
 LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM 
   END IF
   IF g_wc = " 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   CALL cl_wait()
   CALL abxr400()
   ERROR ""
END WHILE
   CLOSE WINDOW r400_w
END FUNCTION
 
FUNCTION abxr400()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680062 VARCHAR(20)
          l_use_flag    LIKE type_file.chr2,            #No.FUN-680062 VARCHAR(2) 
          l_ute_flag    LIKE type_file.chr2,            #No.FUN-680062 VARCHAR(2)
          l_sql 	LIKE type_file.chr1000,         # RDSQL STATEMENT    #No.FUN-680062 VARCHAR(1000)
          l_cmd 	LIKE type_file.chr1000,		# RDSQL STATEMENT    #No.FUN-680062 VARCHAR(1000)
          sr            RECORD 
                        oga01   LIKE oga_file.oga01,
                        oga02   LIKE oga_file.oga02,
                        ogb03   LIKE ogb_file.ogb03,
                        ogb04   LIKE ogb_file.ogb04,
                        ogb12   LIKE ogb_file.ogb12 
                        END RECORD
 
   #str FUN-740077  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740077 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-740077  add
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740077 add ###
 
     LET l_sql = "SELECT oga01,oga02,ogb03,ogb04,ogb12 ",
                 "  FROM oga_file,ogb_file ",
                 " WHERE oga01 = ogb01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ogaconf != 'X' ", #01/08/20 mandy
                  "   AND oga09 NOT IN ('1','5') ", #MOD-580042 需剔除出貨通知單的資料  
                 " ORDER BY oga01,ogb03 "
     PREPARE r400_pre FROM l_sql
     IF STATUS THEN CALL cl_err('r400_pre',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
     END IF
     DECLARE r400_curs CURSOR FOR r400_pre
 
     LET g_pageno = 0
     FOREACH r400_curs INTO sr.*
         IF STATUS THEN CALL cl_err('r400_curs',STATUS,1) EXIT FOREACH END IF
         LET g_bnd01_a=sr.ogb04
         LET g_effective = sr.oga02
         CALL r400_bom(0,sr.ogb04,sr.ogb12,sr.oga01,sr.ogb03,sr.ogb04,sr.ogb12)
     END FOREACH
 
   #str FUN-740077 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740077 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'oga01,oga02')
           RETURNING g_wc
      LET g_str = g_wc
   END IF
 
   CALL cl_prt_cs3('abxr400','abxr400',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740077 add 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END FUNCTION
   
FUNCTION r400_bom(p_level,p_key,p_total,p_so,p_seq,p_part,p_qty)
   DEFINE p_level       LIKE type_file.num5,    #No.FUN-680062 smallint
          p_so          LIKE oga_file.oga01,
          p_seq         LIKE ogb_file.ogb03,
          p_part        LIKE ogb_file.ogb04,
          p_qty         LIKE ogb_file.ogb12,
          p_total       LIKE bne_file.bne08, #FUN-560231
          l_total       LIKE bne_file.bne08, #FUN-560231
          p_key		LIKE bnd_file.bnd01,  #主件料件編號
          l_ac,i	LIKE type_file.num5,                             #No.FUN-680062  smallint
          arrno         LIKE type_file.num5,  	#BUFFER SIZE (可存筆數)  #No.FUN-680062  smallint
          l_chr		LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          l_ima02_1     LIKE ima_file.ima02,
          l_ima021_1,l_ima021_2     LIKE ima_file.ima021,
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
                        bnd01    LIKE bnd_file.bnd01,
                        bne03    LIKE bne_file.bne03,    #項次
                        bne05    LIKE bne_file.bne05,    #元件料號
                        bne08    LIKE bne_file.bne08,    #QPA
                        ima02    LIKE ima_file.ima02,    #品名規格
                        ima15    LIKE ima_file.ima15,    #品名規格
                        ima22    LIKE ima_file.ima22,    #稅率
                        ima25    LIKE ima_file.ima25,    #單位
                        ima95    LIKE ima_file.ima95,    #保稅單價
                        oga01    LIKE oga_file.oga01,    
                        ogb03    LIKE ogb_file.ogb03,    
                        ogb04    LIKE ogb_file.ogb04,    
                        ogb12    LIKE ogb_file.ogb12,    
                        tot      LIKE bne_file.bne08,
                        amt      LIKE type_file.num20_6        #No.FUN-680062  dec(20,6)
                        END RECORD,
    	  l_tot,l_times LIKE type_file.num5,                  #No.FUN-680062  smallint
          l_cmd		LIKE type_file.chr1000                #No.FUN-680062  VARCHAR(1000)   
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET g_pageno = 0
        LET sr[1].bne05 = p_key
    END IF
 
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bnd01,bne03,bne05,bne08,ima02,ima15,ima22,ima25,ima95,",
            "       '',0,'',0,0,0 ",                   #NO.TQC-920040 
            "  FROM bne_file,OUTER ima_file,OUTER bnd_file ",
           " WHERE bne01='",p_key,"'",
           "   AND bne_file.bne05 = ima_file.ima01",
           "   AND bne_file.bne05 = bnd_file.bnd01",
           "   AND ima_file.ima08 != 'A' ",
           "   AND (bnd_file.bnd02 <='",g_effective,"' OR bnd_file.bnd02 IS NULL) ",
           "   AND (bnd_file.bnd03 > '",g_effective,"' OR bnd_file.bnd03 IS NULL) "
           LET l_cmd = l_cmd CLIPPED, " ORDER BY bne03 "
 
        PREPARE r400_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
	   CALL cl_err('P1:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
   EXIT PROGRAM 
   
        END IF
        DECLARE r400_cur CURSOR FOR r400_ppp
 
        LET l_ac = 1
        FOREACH r400_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
        END FOREACH
        FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
           #與多階展開不同之處理在此:
           #尾階在展開時, 其展開之
            LET sr[i].oga01 = p_so
            LET sr[i].ogb03 = p_seq
            LET sr[i].ogb04 = p_part
            LET sr[i].ogb12 = p_qty 
            IF sr[i].bnd01 IS NOT NULL THEN         #若為主件(有BOM單頭)
               CALL r400_bom(p_level,sr[i].bne05,p_total*sr[i].bne08,p_so,
                             p_seq,p_part,p_qty)
            ELSE
                LET l_total=p_total*sr[i].bne08
                LET sr[i].tot = l_total
                LET sr[i].amt = sr[1].tot * sr[1].ima95 * sr[1].ima22 / 100
 
                SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file 
                    WHERE ima01=sr[i].ogb04
                IF SQLCA.sqlcode THEN 
                    LET l_ima02_1 = NULL 
                    LET l_ima021_1 = NULL 
                END IF
 
                SELECT ima021 INTO l_ima021_2 FROM ima_file 
                    WHERE ima01=sr[i].bne05
                IF SQLCA.sqlcode THEN 
                    LET l_ima021_2 = NULL 
                END IF
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740077 *** ##
         EXECUTE insert_prep USING 
         sr[i].bnd01,sr[i].bne03,sr[i].bne05,sr[i].bne08,sr[i].ima02,
         sr[i].ima15,sr[i].ima22,sr[i].ima25,sr[i].ima95,sr[i].oga01,
         sr[i].ogb03,sr[i].ogb04,sr[i].ogb12,sr[i].tot  ,sr[i].amt,
         l_ima02_1,l_ima021_1,l_ima021_2                          #No.TQC-920040
                                
       #end FUN-740077 add 
 
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        END IF
    END WHILE
END FUNCTION
   
REPORT r400_rep(p_total,sr,p_bnd01_a)
   DEFINE l_last_sw	LIKE type_file.chr1,                  #No.FUN-680062  VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,                  #No.FUN-680062  smallint
          p_total       LIKE bne_file.bne08, #FUN-560231    
          p_bnd01_a     LIKE bnd_file.bnd01,
          l_amt         LIKE type_file.num20_6,               #No.FUN-680062  DEC(20,6)
          l_ima02_1     LIKE ima_file.ima02,
          l_ima021_1,l_ima021_2     LIKE ima_file.ima021,
          sr            RECORD
                        bnd01    LIKE bnd_file.bnd01,
                        bne03    LIKE bne_file.bne03,    #項次
                        bne05    LIKE bne_file.bne05,    #元件料號
                        bne08    LIKE bne_file.bne08,    #QPA
                        ima02    LIKE ima_file.ima02,    #品名規格
                        ima15    LIKE ima_file.ima15,    #品名規格
                        ima22    LIKE ima_file.ima22,    #稅率
                        ima25    LIKE ima_file.ima25,    #單位
                        ima95    LIKE ima_file.ima95,    #保稅單價
                        oga01    LIKE oga_file.oga01,    
                        ogb03    LIKE ogb_file.ogb03,    
                        ogb04    LIKE ogb_file.ogb04,    
                        ogb12    LIKE ogb_file.ogb12,    
                        tot      LIKE bne_file.bne08,    
                        amt      LIKE type_file.num20_6#No.FUN-680062  DEC(20,6) 
                        END RECORD 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.oga01,sr.ogb03,sr.bne05
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
  BEFORE GROUP OF sr.oga01
     SKIP TO TOP OF PAGE
     LET l_amt = 0
 
  BEFORE GROUP OF sr.ogb03
     SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file 
         WHERE ima01=sr.ogb04
     IF SQLCA.sqlcode THEN 
         LET l_ima02_1 = NULL 
         LET l_ima021_1 = NULL 
     END IF
 
     PRINT COLUMN g_c[31],sr.ogb03 USING '###&',
           COLUMN g_c[32],sr.ogb04,
           COLUMN g_c[33],l_ima02_1,
           COLUMN g_c[34],l_ima021_1,
           COLUMN g_c[35],cl_numfor(sr.ogb12,35,0);
 
  ON EVERY ROW
     SELECT ima021 INTO l_ima021_2 FROM ima_file 
         WHERE ima01=sr.bne05
     IF SQLCA.sqlcode THEN 
         LET l_ima021_2 = NULL 
     END IF
 
     PRINT COLUMN g_c[36],sr.bne05,
           COLUMN g_c[37],sr.ima02 CLIPPED,  #MOD-4A0238
           COLUMN g_c[38],l_ima021_2 CLIPPED,
           COLUMN g_c[39],sr.ima25,
           COLUMN g_c[40],cl_numfor(sr.bne08,40,4),
           COLUMN g_c[41],cl_numfor(sr.tot,41,4),
           COLUMN g_c[42],cl_numfor(sr.ima95,42,2),
           COLUMN g_c[43],sr.ima22 USING '###&.&&',
           COLUMN g_c[44],cl_numfor(sr.amt,44,3)
 
  AFTER GROUP OF sr.ogb03
     LET l_amt = GROUP SUM(sr.amt)
     PRINT COLUMN g_c[42],g_x[16] CLIPPED,cl_numfor(l_amt,42,3)
 
  AFTER GROUP OF sr.oga01
     SKIP 1 LINE
     LET l_amt = GROUP SUM(sr.amt)
     PRINT COLUMN g_c[42],g_x[17] CLIPPED,cl_numfor(l_amt,42,3)
 
  ON LAST ROW
     PRINT g_dash
     LET l_last_sw = 'y'
     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
  PAGE TRAILER
     IF l_last_sw = 'n' THEN
        PRINT g_dash
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
     ELSE
        SKIP 2 LINE
     END IF
END REPORT
