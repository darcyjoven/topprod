# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmr411.4gl
# Descriptions...: 遠期外匯交易單列印
# Date & Author..: 99/07/21 By Apple
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: NO.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN 0改5
# Modify.........: No.TQC-650057 06/05/12 By alexstar 修改程式中cl_outnam的位置須在assign
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/07 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-710085 07/02/01 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B70168 11/07/19 By Polly 取消此 RPT gxc09/gxc10/gxc11 取位動作 
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				 # Print condition RECORD
              wc    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(600) #Where Condiction
              more  LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)   #
              END RECORD
 
   DEFINE g_i       LIKE type_file.num5          #count/index for any purpose  #No.FUN-680107 SMALLINT
   DEFINE l_table   STRING                       #No.FUN-710085                                                                       
   DEFINE g_sql     STRING                       #No.FUN-710085                                                                       
   DEFINE g_str     STRING                       #No.FUN-710085
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-710085 --start--
   LET g_sql = "gxc01.gxc_file.gxc01,gxc07.gxc_file.gxc07,gxc08.gxc_file.gxc08,",
               "alg021.alg_file.alg02,gxc05.gxc_file.gxc05,",
               "gxc03.gxc_file.gxc03,gxc06.gxc_file.gxc06,gxc10.gxc_file.gxc10,",
               "gxc04.gxc_file.gxc04,gxc041.gxc_file.gxc041,gxc09.gxc_file.gxc09,",
               "gxc11.gxc_file.gxc11,gxc12.gxc_file.gxc12,gxc02.gxc_file.gxc02,",
               "azi04.azi_file.azi04,azi07_1.azi_file.azi07,azi07_2.azi_file.azi07,",
               "azi07_3.azi_file.azi07,",  #No.TQC-C10034 add , ,
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
 
   LET l_table = cl_prt_temptable('anmr411',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,? ,?,?,?,?)"   #No.TQC-C10034 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr411_tm()	        	# Input print condition
      ELSE CALL anmr411()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr411_tm()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	   LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_jmp_flag  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr411_w AT p_row,p_col
        WITH FORM "anm/42f/anmr411"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gxc01,gxc02,gxc07,gxc03,gxc04,gxc041
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr411_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr411_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr411'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr411','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr411',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr411()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr411_w
END FUNCTION
 
FUNCTION anmr411()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680107 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
          l_rate        LIKE gxc_file.gxc09,
          l_order       ARRAY[3] OF LIKE cre_file.cre08,#No.FUN-680107 ARRAY[3] OF VARCHAR(10)
          sr            RECORD
                        gxc    RECORD LIKE gxc_file.*,  #外匯交易檔
                        alg021 LIKE alg_file.alg021,    #銀行全名
                        desc   LIKE zaa_file.zaa08      #No.FUN-680107 VARCHAR(8) #銀行全名
                        END RECORD
   DEFINE l_azi07_1     LIKE azi_file.azi07             #No.FUN-710085
   DEFINE l_azi07_2     LIKE azi_file.azi07             #No.FUN-710085
   DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
   LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
 
     CALL cl_del_data(l_table)  #No.FUN-710085
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr411'
 
     LET l_sql = "SELECT gxc_file.*,alg021,' ' ",
                 "  FROM gxc_file,OUTER alg_file ",
                 " WHERE alg_file.alg01 = gxc_file.gxc07 ",
                 "   AND gxc13 !='X' ",   #010815增
                 "   AND ",tm.wc CLIPPED
     PREPARE anmr411_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr411_curs1 CURSOR FOR anmr411_prepare1
 
#No.FUN-710085 --start-- mark
#    CALL cl_outnam('anmr411') RETURNING l_name
#  #TQC-650057---start---
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#  #TQC-650057---end---
#    START REPORT anmr411_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-710085 --end--
 
     FOREACH anmr411_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-710085 --start-- mark
#      IF sr.gxc.gxc02 = '1' THEN
#         LET sr.desc = g_x[27] clipped
#      ELSE
#         LET sr.desc = g_x[28] clipped
#      END IF
#No.FUN-710085 --end--
 
       #No.FUN-710085 --start--
       SELECT azi04,azi07 INTO t_azi04,l_azi07_1
         FROM azi_file
        WHERE azi01=sr.gxc.gxc05
       SELECT azi07 INTO l_azi07_2 FROM azi_file WHERE azi01=sr.gxc.gxc06
       LET l_azi07_1= 10    #No.MOD-B70168 add
       LET l_azi07_2=10     #No.MOD-B70168 add
       LET g_azi07 =10      #No.MOD-B70168 add
       EXECUTE insert_prep USING sr.gxc.gxc01,sr.gxc.gxc07,sr.gxc.gxc08,sr.alg021,
                                 sr.gxc.gxc05,sr.gxc.gxc03,sr.gxc.gxc06,
                                 sr.gxc.gxc10,sr.gxc.gxc04,sr.gxc.gxc041,sr.gxc.gxc09,
                                 sr.gxc.gxc11,sr.gxc.gxc12,sr.gxc.gxc02,t_azi04,
                                 l_azi07_1,l_azi07_2,g_azi07
                                 ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
       #No.FUN-710085 --end--
 
#      OUTPUT TO REPORT anmr411_rep(sr.*)         #No.FUN-710085 mark
     END FOREACH
 
#    FINISH REPORT anmr411_rep                    #No.FUN-710085 mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     CALL cl_wcchp(tm.wc,'gxc01,gxc02,gxc07,gxc03,gxc04,gxc041')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
   # CALL cl_prt_cs3('anmr411',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "gxc01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     CALL cl_prt_cs3('anmr411','anmr411',l_sql,g_str)
     #No.FUN-710085 --end--
 
END FUNCTION
 
#No.FUN-710085 --start-- mark
{REPORT anmr411_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,           #No.FUN-680107 VARCHAR(1)
          l_azi07_1     LIKE azi_file.azi07,
          l_azi07_2     LIKE azi_file.azi07,
          sr            RECORD
                        gxc   RECORD LIKE gxc_file.*,  #外匯交易檔
                        alg021 LIKE alg_file.alg02,    #銀行全名
                        desc   LIKE zaa_file.zaa08     #No.FUN-680107 VARCHAR(8)
                        END RECORD,
          l_i           LIKE type_file.num5            #No.FUN-680107 SMALLINT
  OUTPUT
      TOP MARGIN 0
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN 5   #FUN-580098
      PAGE LENGTH g_page_line
  ORDER BY sr.gxc.gxc01
  FORMAT
 
    BEFORE GROUP OF sr.gxc.gxc01
      SKIP TO TOP OF PAGE
 
    ON EVERY ROW
 
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,l_azi07_1     #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.gxc.gxc05
      SELECT azi07 INTO l_azi07_2 FROM azi_file WHERE azi01=sr.gxc.gxc06
 
          PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
          PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
          PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
          PRINT ' '
          LET g_pageno = g_pageno + 1
          PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            #    COLUMN g_len-18,g_x[29] clipped,sr.gxc.gxc01 CLIPPED
                COLUMN g_len-26,g_x[29] clipped,sr.gxc.gxc01 CLIPPED   #No.FUN-550057
          PRINT g_dash[1,g_len]
          PRINT COLUMN 1, g_x[11] CLIPPED,' ',sr.gxc.gxc07 CLIPPED,
                COLUMN 30,g_x[16] CLIPPED,' ',
                COLUMN 40,cl_numfor(sr.gxc.gxc08,18,t_azi04)        #NO.CHI-6A0004 
          PRINT COLUMN 11,sr.alg021 CLIPPED,
                COLUMN 30,g_x[26] CLIPPED,'   ',sr.desc
          PRINT COLUMN  1,g_x[12] CLIPPED,' ',sr.gxc.gxc05,
                COLUMN 30,g_x[17] CLIPPED,'   ',sr.gxc.gxc03
          PRINT COLUMN  1,g_x[13] CLIPPED,' ',sr.gxc.gxc06,
                COLUMN 30,g_x[18] CLIPPED,'   ',sr.gxc.gxc03
          PRINT COLUMN  1,g_x[14] CLIPPED,COLUMN 11,cl_numfor(sr.gxc.gxc10 ,10,l_azi07_1),
                COLUMN 30,g_x[20] CLIPPED,'   ',sr.gxc.gxc04,'-',sr.gxc.gxc041
          PRINT COLUMN  1,g_x[15] CLIPPED,COLUMN 11,cl_numfor(sr.gxc.gxc09  ,10,l_azi07_2)
          PRINT COLUMN  1,g_x[25] CLIPPED,COLUMN 11,cl_numfor(sr.gxc.gxc11 ,10,g_azi07)
          PRINT COLUMN  1,g_x[21] CLIPPED,sr.gxc.gxc12
          SKIP 2 LINE
          LET l_last_sw = 'n'
          PRINT g_dash[1,g_len]
          PRINT ' '
          PRINT g_x[22] CLIPPED,15 SPACES,g_x[23] CLIPPED,15 SPACES,
                g_x[24] CLIPPED
END REPORT} 
#No.FUN-710085 --end--
#Patch....NO.TQC-610036 <001> #
