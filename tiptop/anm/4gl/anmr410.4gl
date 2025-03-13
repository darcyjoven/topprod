# Prog. Version..: '5.30.06-13.04.16(00008)'     #
#
# Pattern name...: anmr410.4gl
# Descriptions...: 遠期外匯交割單列印
# Date & Author..: 02/06/27 By Kammy
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: NO.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-590488 05/10/03 By Dido 報表調整
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN 0改5
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710085 07/02/01 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-C90141 12/09/18 By Polly 簽核報表取消已確認限制
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		            #Print condition RECORD
              wc    LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(600) #Where Condiction
              more  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)   #
              END RECORD
 
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE l_table       STRING                   #FUN-710085 add 
DEFINE g_sql         STRING                   #FUN-710085 add
DEFINE g_str         STRING                   #FUN-710085 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			    # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-710085--begin 
   LET g_sql = "gxe01.gxe_file.gxe01,", 
               "gxe011.gxe_file.gxe011,",
               "gxe02.gxe_file.gxe02,",
               "gxe03.gxe_file.gxe03,", 
               "gxe04.gxe_file.gxe04,", 
               "gxe05.gxe_file.gxe05,", 
               "gxe06.gxe_file.gxe06,", 
               "gxe07.gxe_file.gxe07,", 
               "gxe071.gxe_file.gxe071,",
               "gxe08.gxe_file.gxe08,", 
               "gxe09.gxe_file.gxe09,", 
               "gxe10.gxe_file.gxe10,", 
               "gxe11.gxe_file.gxe11,", 
               "gxe12.gxe_file.gxe12,", 
               "gxe13.gxe_file.gxe13,", 
               "gxe14.gxe_file.gxe14,", 
               "gxe141.gxe_file.gxe141,",
               "gxe15.gxe_file.gxe15,", 
               "gxe16.gxe_file.gxe16,", 
               "gxe17.gxe_file.gxe17,", 
               "gxe18.gxe_file.gxe18,", 
               "alg02.alg_file.alg02,",
               "desc1.zaa_file.zaa08,",
               "l_alg021.alg_file.alg021,",
               "azi03.azi_file.azi04,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07_1.azi_file.azi07,",
               "azi07_2.azi_file.azi07,", 
               "azi07.azi_file.azi07,",     #No.TQC-C10034 add , ,
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
   LET l_table = cl_prt_temptable('anmr410',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ,?,?,?,?)"  #No.TQC-C10034 add 4? 
   PREPARE insert_prep FROM g_sql    
   IF STATUS THEN  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM    
   END IF                           
#No.FUN-710085--end 
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
      THEN CALL anmr410_tm()	        	# Input print condition
      ELSE CALL anmr410()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr410_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,   #No.FUN-680107 SMALLINT
       l_cmd	     LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(400)
       l_jmp_flag    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW anmr410_w AT p_row,p_col
        WITH FORM "anm/42f/anmr410"
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
   CONSTRUCT BY NAME tm.wc ON gxe01,gxe02,gxe07,gxe03,gxe04
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr410_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr410_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr410'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr410','9031',1)
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
         CALL cl_cmdat('anmr410',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr410()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr410_w
END FUNCTION
 
FUNCTION anmr410()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680107 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,         #標題內容 #No.FUN-680107 VARCHAR(40)
          l_rate        LIKE gxe_file.gxe09,
          l_order       ARRAY[3] OF LIKE cre_file.cre08,#No.FUN-680107 ARRAY[3] OF VARCHAR(10)
          sr            RECORD
                        gxe    RECORD LIKE gxe_file.*,  #外匯交易檔
                        alg021 LIKE alg_file.alg021,    #銀行全名
                        desc   LIKE zaa_file.zaa08      #No.FUN-680107 VARCHAR(8) #銀行全名
                        END RECORD
#No.FUN-710085--begin
    DEFINE l_alg021     LIKE alg_file.alg02,
           t_azi07_1    LIKE azi_file.azi07,           
           t_azi07_2    LIKE azi_file.azi07             
#No.FUN-710085--end
     DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
     LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
 
#No.FUN-710085--begin                                                                                                               
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'anmr410'                                                                    
#No.FUN-710085--end 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr410'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     LET g_len = 90                           #No.FUN-550057
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     LET l_sql = "SELECT gxe_file.*,alg021,' ' ",
                 "  FROM gxe_file,OUTER alg_file ",
                 " WHERE alg_file.alg01 = gxe_file.gxe07 ",
                #"   AND gxe13 ='Y' ",                         #MOD-C90141 mark
                 "   AND ",tm.wc CLIPPED
     PREPARE anmr410_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr410_curs1 CURSOR FOR anmr410_prepare1
 
#No.FUN-710085--begin 
#    CALL cl_outnam('anmr410') RETURNING l_name
#    START REPORT anmr410_rep TO l_name
 
#    LET g_pageno = 0
#No.FUN-710085--end
     FOREACH anmr410_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-710085--begin
#      IF sr.gxe.gxe02 = '1' THEN
#         LET sr.desc = g_x[27] clipped
#      ELSE
#         LET sr.desc = g_x[28] clipped
#      END IF
      SELECT azi03,azi04,azi05,azi07
        INTO t_azi03,t_azi04,t_azi05,t_azi07_1  #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.gxe.gxe05
       SELECT azi07 INTO t_azi07_2 FROM  azi_file WHERE azi01=sr.gxe.gxe06  #NO.CHI-6A0004
       SELECT alg021 INTO l_alg021 FROM alg_file
        WHERE alg01 = sr.gxe.gxe071
       EXECUTE insert_prep USING  sr.gxe.gxe01,sr.gxe.gxe011,sr.gxe.gxe02,sr.gxe.gxe03,sr.gxe.gxe04,sr.gxe.gxe05,
                                  sr.gxe.gxe06,sr.gxe.gxe07,sr.gxe.gxe071,sr.gxe.gxe08,sr.gxe.gxe09,sr.gxe.gxe10,
                                  sr.gxe.gxe11,sr.gxe.gxe12,sr.gxe.gxe13,sr.gxe.gxe14,sr.gxe.gxe141,sr.gxe.gxe15,
                                  sr.gxe.gxe16,sr.gxe.gxe17,sr.gxe.gxe18,sr.alg021,sr.desc,l_alg021,
                                  t_azi03,t_azi04,t_azi05,t_azi07_1,t_azi07_2,g_azi07   
                                  ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
 
#      OUTPUT TO REPORT anmr410_rep(sr.*)
#No.FUN-710085--end
     END FOREACH
 
#No.FUN-710085--begin
#    FINISH REPORT anmr410_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_wcchp(tm.wc,'gxe01,gex02,gxe07,gxe03,gxe04')
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
     LET g_str = tm.wc         
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "gxe01|gxe011"                  #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
   # CALL cl_prt_cs3('anmr410',g_sql,g_str)         #TQC-730088
     CALL cl_prt_cs3('anmr410','anmr410',g_sql,g_str)  
#No.FUN-710085--end
END FUNCTION
 
#No.FUN-710085--begin
#REPORT anmr410_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,             #No.FUN-680107 VARCHAR(1)
#          sr            RECORD
#                        gxe   RECORD LIKE gxe_file.*,    #外匯交易檔
#                        alg021 LIKE alg_file.alg02,      #銀行全名
#                        desc   LIKE zaa_file.zaa08       #No.FUN-680107 VARCHAR(8)
#                        END RECORD,
#          l_i           LIKE type_file.num5,             #No.FUN-680107 SMALLINT
#          l_alg021      LIKE alg_file.alg021,
#          t_azi07_1     LIKE azi_file.azi07,             #NO.CHI-6A0004
#          t_azi07_2     LIKE azi_file.azi07              #NO.CHI-6A0004
#  OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN 5   #FUN-580098
#      PAGE LENGTH g_page_line
#  ORDER BY sr.gxe.gxe01
#  FORMAT
#    PAGE HEADER
#         LET l_last_sw = 'n'   #FUN-550114
#
#    BEFORE GROUP OF sr.gxe.gxe01
#      SKIP TO TOP OF PAGE
#
#    ON EVERY ROW
#
#      SELECT azi03,azi04,azi05,azi07
#        INTO t_azi03,t_azi04,t_azi05,t_azi07_1  #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.gxe.gxe05
#       SELECT azi07 INTO t_azi07_2 FROM  azi_file WHERE azi01=sr.gxe.gxe06  #NO.CHI-6A0004
#
#          PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##MOD-590488
#          PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##         PRINT ' '
##MOD-590488 End
#          PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#          LET g_pageno = g_pageno + 1
#          PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#                COLUMN g_len-26,g_x[29] clipped,sr.gxe.gxe01 CLIPPED      #No.FUN-550057
#          PRINT g_dash[1,g_len]
#          PRINT COLUMN 1, g_x[30] CLIPPED,' ',sr.gxe.gxe011 USING '<<<',
#                COLUMN 34,g_x[26] CLIPPED,' ',sr.desc
#          PRINT
#          PRINT COLUMN 01, g_x[11] CLIPPED,' ',sr.gxe.gxe07 CLIPPED,
#                COLUMN 34, g_x[31] CLIPPED,' ',sr.gxe.gxe15
#          PRINT COLUMN 11,sr.alg021 CLIPPED
#          SELECT alg021 INTO l_alg021 FROM alg_file
#           WHERE alg01 = sr.gxe.gxe071
#          PRINT COLUMN 01,g_x[33] CLIPPED,' ',sr.gxe.gxe071 CLIPPED,
#                COLUMN 34, g_x[32] CLIPPED,' ',sr.gxe.gxe16
#          PRINT COLUMN 11,l_alg021 CLIPPED
#          PRINT COLUMN  1,g_x[12] CLIPPED,' ',sr.gxe.gxe05,
#                COLUMN 34,g_x[16] CLIPPED,
#                COLUMN 43,cl_numfor(sr.gxe.gxe08,18,t_azi04) #NO.CHI-6A0004
#          PRINT COLUMN  1,g_x[13] CLIPPED,' ',sr.gxe.gxe06,
#                COLUMN 34,g_x[18] CLIPPED,' ',sr.gxe.gxe03
#          PRINT COLUMN  1,g_x[14] CLIPPED,COLUMN 11,cl_numfor(sr.gxe.gxe10,10,t_azi07_1),  #NO.CHI-6A0004
#                COLUMN 34,g_x[20] CLIPPED,' ',sr.gxe.gxe04
#          PRINT COLUMN  1,g_x[15] CLIPPED,COLUMN 11,cl_numfor(sr.gxe.gxe09,10,t_azi07_2)  #NO.CHI-6A0004
#          PRINT COLUMN  1,g_x[25] CLIPPED,COLUMN 11,cl_numfor(sr.gxe.gxe11,10,g_azi07)
#          PRINT COLUMN  1,g_x[21] CLIPPED,' ',sr.gxe.gxe12
#          SKIP 2 LINE
#          LET l_last_sw = 'n'
#          PRINT g_dash[1,g_len]
#          PRINT ' '
### FUN-550114
#         # PRINT g_x[22] CLIPPED,15 SPACES,g_x[23] CLIPPED,15 SPACES,
#         #       g_x[24] CLIPPED
#ON LAST ROW
#     LET l_last_sw = 'y'
#
#PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[22]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[22]
#            PRINT g_memo
#     END IF
### END FUN-550114
#
#END REPORT
#Patch....NO.TQC-610036 <001> #
#No.FUN-710085--end
