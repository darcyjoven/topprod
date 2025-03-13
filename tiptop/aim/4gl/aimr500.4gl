# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr500.4gl
# Descriptions...: ＡＢＣ分類表列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/29 By Carol
# Modify.........: 92/05/21 By Wu
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.TQC-680072 06/08/18 By kim 外部串接不執行_tm(),直接列印
# Modify.........: No.FUN-690026 06/09/18 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-830164 08/04/02 By dxfwo 報表改由CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                            # Print condition RECORD
            wc       STRING,                 # Where condition   #TQC-630166
            c        LIKE type_file.chr1,    # 分群碼排列選擇  #No.FUN-690026 VARCHAR(1)
            more     LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-830164---Begin
DEFINE g_sql         STRING
DEFINE g_str         STRING
DEFINE l_table       STRING
#No.FUN-830164---End
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#No.FUN-830164---Begin   
   LET g_sql = " ima07.ima_file.ima07,",
               " ima20.ima_file.ima20,",
               " ima01.ima_file.ima01,", 
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ima05.ima_file.ima05,",
               " ima08.ima_file.ima08,",
               " ima37.ima_file.ima37,",
               " ima06.ima_file.ima06,",
               " ima09.ima_file.ima09,",
               " ima10.ima_file.ima10,",
               " ima11.ima_file.ima11,",
               " ima12.ima_file.ima12 "
   LET l_table = cl_prt_temptable('aimr500',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF            
#No.FUN-830164---End 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.c  = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF (cl_null(g_bgjob) OR g_bgjob = 'N')		# If background job sw is off
      AND (cl_null(tm.wc))   #TQC-680072
      THEN CALL r500_tm()		# Input print condition
      ELSE CALL aimr500()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r500_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r500_w AT p_row,p_col
        WITH FORM "aim/42f/aimr500"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima07, ima06, ima09, ima10,
                	ima11, ima12, ima01, ima23
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
 
 
#No.FUN-570240  --start-
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end--
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.c,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD c
		 IF tm.c IS NULL OR tm.c = ' ' OR tm.c NOT MATCHES'[01234]'
			THEN NEXT FIELD c
		 END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr500','9031',1)
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
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr500',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr500()
   ERROR ""
END WHILE
   CLOSE WINDOW r500_w
END FUNCTION
 
FUNCTION aimr500()
   DEFINE l_name     LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0074
          l_sql      STRING,                # RDSQL STATEMENT   #TQC-630166
          l_za05     LIKE za_file.za05,     #No.FUN-690026 VARCHAR(40)
          sr         RECORD
                            order1 LIKE ima_file.ima06,    # 排序
                            ima07  LIKE ima_file.ima07,    # 類別
                            ima06  LIKE ima_file.ima06,    # 分群碼
                            ima09  LIKE ima_file.ima09,    # 其他一
                            ima10  LIKE ima_file.ima10,    # 其他二
                            ima11  LIKE ima_file.ima11,    # 其他三
                            ima12  LIKE ima_file.ima12,    # 其他四
                            ima01  LIKE ima_file.ima01,    # 料件編號
                            ima02  LIKE ima_file.ima02,    # 品名規格
                            ima021 LIKE ima_file.ima021,   # 品名規格 #FUN-510017
                            ima05  LIKE ima_file.ima05,    # 版本
                            ima08  LIKE ima_file.ima08,    # 來源
                            ima20  LIKE ima_file.ima20,    #
                            ima37  LIKE ima_file.ima37     # OPC
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ' ',ima07, ima06, ima09,ima10,",
                 " ima11, ima12, ima01, ima02,ima021, ima05, ima08, ima20,", #FUN-510017 add ima021
                 " ima37 ",
                 "  FROM ima_file",
                 " WHERE ",tm.wc," AND imaacti ='Y' ",
                 " ORDER BY ima07 "
 
     PREPARE r500_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r500_curs1 CURSOR FOR r500_prepare1
 
#    CALL cl_outnam('aimr500') RETURNING l_name         #No.FUN-830164
#    START REPORT r500_rep TO l_name                    #No.FUN-830164
     CALL cl_del_data(l_table)                          #No.FUN-830164  
   
     FOREACH r500_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.ima07 IS NULL THEN LET sr.ima07 = ' ' END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima09 IS NULL THEN LET sr.ima09 = ' ' END IF
       IF sr.ima10 IS NULL THEN LET sr.ima10 = ' ' END IF
       IF sr.ima11 IS NULL THEN LET sr.ima11 = ' ' END IF
       IF sr.ima12 IS NULL THEN LET sr.ima12 = ' ' END IF
       CASE tm.c
           WHEN '0' LET sr.order1 = sr.ima06
    	   WHEN '1' LET sr.order1 = sr.ima09
    	   WHEN '2' LET sr.order1 = sr.ima10
    	   WHEN '3' LET sr.order1 = sr.ima11
    	   WHEN '4' LET sr.order1 = sr.ima12
           OTHERWISE LET sr.order1 = '-'
       END CASE
#No.FUN-830164---Begin 
#       OUTPUT TO REPORT r500_rep(sr.*)
        EXECUTE insert_prep USING sr.ima07, sr.ima20, sr.ima01, sr.ima02, sr.ima021,
                                  sr.ima05, sr.ima08, sr.ima37, sr.ima06, sr.ima09 ,
                                  sr.ima10, sr.ima11, sr.ima12  
     END FOREACH
 
#    FINISH REPORT r500_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     IF g_zz05 = 'Y' THEN                                                        
        CALL cl_wcchp(tm.wc,'ima07, ima06, ima09, ima10')         
          RETURNING tm.wc                                                                                                             
    END IF                                                                                                                          
#                 p1       p2
    LET g_str = tm.wc,";",tm.c                                                           
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
    CALL cl_prt_cs3('aimr500','aimr500',l_sql,g_str)
#No.FUN-830164---End    
END FUNCTION
#No.FUN-830164---Begin
#REPORT r500_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr            RECORD order1 LIKE ima_file.ima06,
#                               ima07  LIKE ima_file.ima07,    # 類別
#                               ima06  LIKE ima_file.ima06,    # 分群碼
#                               ima09  LIKE ima_file.ima09,    # 其他一
#                               ima10  LIKE ima_file.ima10,    # 其他二
#                               ima11  LIKE ima_file.ima11,    # 其他三
#                               ima12  LIKE ima_file.ima12,    # 其他四
#                               ima01  LIKE ima_file.ima01,    # 料件編號
#                               ima02  LIKE ima_file.ima02,    # 品名規格
#                               ima021 LIKE ima_file.ima021,   # 品名規格 #FUN-510017
#                               ima05  LIKE ima_file.ima05,    # 版本
#                               ima08  LIKE ima_file.ima08,    # 來源
#                               ima20  LIKE ima_file.ima20,    #
#                               ima37  LIKE ima_file.ima37     # OPC
#                        END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.ima07, sr.ima20 desc, sr.order1, sr.ima01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[11] CLIPPED ,' ',sr.ima07
#      PRINT
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#s
#   BEFORE GROUP OF sr.ima07
#      IF (PAGENO > 1 OR LINENO > 11)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.order1,
#            COLUMN g_c[32],sr.ima01,
#            COLUMN g_c[33],sr.ima02,
#            COLUMN g_c[34],sr.ima021,
#            COLUMN g_c[35],sr.ima05,
#	    COLUMN g_c[36],sr.ima08,
#            COLUMN g_c[37],sr.ima37,
#            COLUMN g_c[38],sr.ima20 USING '###&.&&','%'
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'ima07,ima06,ima09,ima10,ima11,ima12,ima01,ima23')
#              RETURNING tm.wc
#         PRINT g_dash
#       #TQC-630166
#       #       IF tm.wc[001,070] > ' ' THEN			# for 80
##		 PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##              IF tm.wc[071,140] > ' ' THEN
##	 	 PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##              IF tm.wc[141,210] > ' ' THEN
##	 	 PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##              IF tm.wc[211,280] > ' ' THEN
##	 	 PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#       CALL cl_prt_pos_wc(tm.wc)
#       #END TQC-630166
#
#      END IF
#      PRINT g_dash #No.TQC-5C0005
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash #No.TQC-5C0005
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-830164---End
#FUN-870144
