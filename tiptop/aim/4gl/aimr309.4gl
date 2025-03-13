# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimr309.4gl
# Descriptions...: 料件預計償還一覽表
# Return code....:
# Date & Author..: 92/06/16 By Lin
# Modify.........: 92/11/17 By Pin
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-570240 05/07/26 By day   料件編號欄位加CONTROLP
# Modify.........: No.MOD-580222 05/08/25 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-5B0310 05/11/24 By kim 料號長度不夠
# Modify.........: No.FUN-680025 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           #Print condition RECORD
            wc       STRING,                #TQC-630166
            more     LIKE type_file.chr1    #Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0074
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
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r309_tm()	        	# Input print condition
      ELSE
        IF g_sma.sma12 ='N' THEN
           CALL aimr309_n()			# Read data and create out-file
        ELSE
           CALL aimr309_y()
        END IF
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r309_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 17
   ELSE
       LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r309_w AT p_row,p_col
        WITH FORM "aim/42f/aimr309"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imo03,imo04,imo02,imo01,imo06,
                              imp03,imp06
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
            IF INFIELD(imp03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imp03
               NEXT FIELD imp03
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
      LET INT_FLAG = 0 CLOSE WINDOW r309_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more   # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r309_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr309'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr309','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimr309',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r309_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   IF g_sma.sma12='N' THEN
      CALL aimr309_n()
   ELSE
      CALL aimr309_y()
   END IF
   ERROR ""
END WHILE
   CLOSE WINDOW r309_w
END FUNCTION
 
FUNCTION aimr309_y()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql         STRING,                 #TQC-630166	
          l_chr		LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                               imo01 LIKE imo_file.imo01,  #借料單號
                               imo02 LIKE imo_file.imo02,  #借料日期
                               imo03 LIKE imo_file.imo03,  #廠商編號
                               imo04 LIKE imo_file.imo04,  #廠商簡稱
                               imo06 LIKE imo_file.imo06,  #借料人員
                               gen02 LIKE gen_file.gen02,  #借料人員
                               imp02 LIKE imp_file.imp02,  #項次
                               imp03 LIKE imp_file.imp03,  #料件編號
                               imp04 LIKE imp_file.imp04,  #借料數量
                               imp05 LIKE imp_file.imp05,  #借料單位
                               imp06 LIKE imp_file.imp06,  #預計償還日
                               img02 LIKE img_file.img02,  #倉庫代號
                               img03 LIKE img_file.img03,  #存放位置
                               img04 LIKE img_file.img04,  #存放批號
                               img09 LIKE img_file.img09,  #庫存單位
                               img10 LIKE img_file.img10,  #庫存數量
                               qty   LIKE imp_file.imp04,  #庫存可用量
                               imp48 LIKE imp_file.imp04   #未還數量
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr309'
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imogrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imouser', 'imogrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ",
                 " imo01,imo02,imo03,imo04,imo06,gen02, ",
                 " imp02,imp03,imp04,imp05,imp06,",
                 " '','','','', '','',(imp04-imp08) ",
                 "  FROM imo_file,imp_file,OUTER gen_file",
                 " WHERE ",tm.wc CLIPPED, " AND imo01=imp01 ",
                 " AND imo_file.imo06=gen_file.gen01  AND imp07 NOT IN ('y','Y') ",
                 " ORDER BY imo04,imo01,imp02,imo02 "
     PREPARE r309_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r309_curs1 CURSOR FOR r309_prepare1
 
     CALL cl_outnam('aimr309') RETURNING l_name
#FUN-680025--begin
#No.FUN-550029-start
#     LET g_len = 145 #MOD-5B0310
#     FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550029-end
#FUN-680025--end
     START REPORT r309_rep1 TO l_name
#FUN-680025--begin
     LET g_pageno = 0
     LET g_zaa[53].zaa06='Y'                                                                                               
     LET g_zaa[54].zaa06='Y'                                                                                               
     LET g_zaa[55].zaa06='Y'                                                                                               
     LET g_zaa[56].zaa06='Y'                                                                                               
     LET g_zaa[57].zaa06='Y'                                                                                               
     LET g_zaa[58].zaa06='Y'
     CALL cl_prt_pos_len()
#FUN-680025--end
     FOREACH r309_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
	   IF sr.imo03 IS NULL THEN LET sr.imo03 = ' ' END IF
	   IF sr.imo04 IS NULL THEN LET sr.imo04 = ' ' END IF
       IF sr.imo02 IS NULL THEN LET sr.imo02 = ' ' END IF
       OUTPUT TO REPORT r309_rep1(sr.*)
     END FOREACH
 
     FINISH REPORT r309_rep1
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r309_rep1(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr            RECORD
                               imo01 LIKE imo_file.imo01,  #借料單號
                               imo02 LIKE imo_file.imo02,  #借料日期
                               imo03 LIKE imo_file.imo03,  #廠商編號
                               imo04 LIKE imo_file.imo04,  #廠商簡稱
                               imo06 LIKE imo_file.imo06,  #借料人員
                               gen02 LIKE gen_file.gen02,  #借料人員
                               imp02 LIKE imp_file.imp02,  #項次
                               imp03 LIKE imp_file.imp03,  #料件編號
                               imp04 LIKE imp_file.imp04,  #借料數量
                               imp05 LIKE imp_file.imp05,  #借料單位
                               imp06 LIKE imp_file.imp06,  #預計償還日
                               img02 LIKE img_file.img02,  #倉庫代號
                               img03 LIKE img_file.img03,  #存放位置
                               img04 LIKE img_file.img04,  #存放批號
                               img09 LIKE img_file.img09,  #庫存單位
                               img10 LIKE img_file.img10,  #庫存數量
                               qty   LIKE imp_file.imp04,  #庫存可用量
                               imp48 LIKE imp_file.imp04   #未還數量
                        END RECORD ,
         l_sql          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
         l_sw           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.imo04,sr.imo01,sr.imp02
  FORMAT
   PAGE HEADER
#FUN-680025--begin
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED  
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
      PRINT '' 
#FUN-680025--end
      PRINT g_dash[1,g_len]
#No.FUN-550029  --start
      PRINT g_x[11] CLIPPED,sr.imo04," (",sr.imo03,") "
#FUN-680025--begin
      PRINT ''
#	  PRINT g_x[12] ,' ',g_x[13] CLIPPED ,COLUMN 102,g_x[19] CLIPPED #MOD-5B0310
#         PRINT COLUMN 41,g_x[14] CLIPPED,
#               COLUMN 87,g_x[15] CLIPPED ,g_x[16] CLIPPED #MOD-5B0310
#No.FUN-550029  --end
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                     g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],
                     g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]  
      PRINT g_dash1
#FUN-680025--end
      LET l_sw='N'
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.imo04   #廠商編號
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
      IF l_sw='Y' THEN
      PRINT g_x[11] CLIPPED,sr.imo04," (",sr.imo03,") "
#FUN--680025--begin
#     PRINT g_x[12] ,g_x[13]
#No.FUN-550029  --start
#         PRINT COLUMN 41,g_x[14] CLIPPED,
#               COLUMN 87,g_x[15] CLIPPED ,g_x[16] CLIPPED #MOD-5B0310
#No.FUN-550029  --end
#FUN--680025--end
      PRINT g_dash[1,g_len]
     END IF
     LET l_sw='Y'
 
   BEFORE GROUP OF sr.imo01    #借料單號
#     PRINT sr.imo01;                    #FUN-680025                        
   BEFORE GROUP OF sr.imp02    #借料
#FUN-680025--begin
#No.FUN-550029  --start
#     PRINT COLUMN 18,sr.imp02 USING "###&" ,
#           COLUMN 23,sr.imo02 CLIPPED,
#           COLUMN 32,sr.gen02 CLIPPED,
#           COLUMN 41,sr.imp03 CLIPPED,
#           COLUMN 72,sr.imp05 CLIPPED, #MOD-5B0310
#           COLUMN 87,cl_numfor(sr.imp04,14,3),  #MOD-5B0310
#           COLUMN 104,cl_numfor(sr.imp48,14,3), #MOD-5B0310
#           COLUMN 121,sr.imp06 #MOD-5B0310
      PRINTX name=D1 COLUMN g_c[31],sr.imo01; 
      PRINT COLUMN g_c[32],sr.imp02 USING "####&",
            COLUMN g_c[33],sr.imo02 CLIPPED,
            COLUMN g_c[34],sr.gen02 CLIPPED,
            COLUMN g_c[35],sr.imp03 CLIPPED,
            COLUMN g_c[38],sr.imp05 CLIPPED,
            COLUMN g_c[39],cl_numfor(sr.imp04,39,3),
            COLUMN g_c[40],cl_numfor(sr.imp48,40,3),
            COLUMN g_c[41],sr.imp06  	
#No.FUN-550029  --end
#FUN-680025--end
 
   ON EVERY ROW
      LET l_sql = " SELECT  img02,img03,img04,img09,img10 ",
                  " FROM img_file ",
                  " WHERE img01='",sr.imp03,"' ",
                  " ORDER BY 1,2,3 "
     PREPARE r309_p3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r309_cs3 CURSOR FOR r309_p3
     FOREACH r309_cs3 INTO sr.img02,sr.img03,sr.img04,sr.img09,
                           sr.img10,sr.qty
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET sr.qty = sr.img10
#FUN-680025-begin	
#No.FUN-550029  --start
#      PRINT COLUMN 41,sr.img02 CLIPPED,COLUMN 51,'/ ',
#            COLUMN 53,sr.img03 CLIPPED,COLUMN 63,'/ ',
#            COLUMN 65,sr.img04 CLIPPED,' ',
#            COLUMN 87,sr.img09 CLIPPED, #MOD-5B0310
#            COLUMN 102,sr.img10 USING "------------&.&&&", #MOD-5B0310
#            COLUMN 117,sr.qty  USING "------------&.&&&",' ', #MOD-5B0310
       PRINTX name=D2
             COLUMN g_c[46],sr.img02 CLIPPED,
             COLUMN g_c[47],sr.img03 CLIPPED,
             COLUMN g_c[48],sr.img04 CLIPPED,
             COLUMN g_c[49],sr.img09 CLIPPED,
             COLUMN g_c[50],cl_numfor(sr.img10,50,3),
             COLUMN g_c[51],cl_numfor(sr.qty,51,3), 
             COLUMN g_c[52],'________'
#No.FUN-550029  --end
     END FOREACH
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
       #TQC-630166
       #       IF tm.wc[001,120] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              IF tm.wc[121,240] > ' ' THEN
# 		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              IF tm.wc[241,300] > ' ' THEN
# 		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION aimr309_n()
   DEFINE l_name	LIKE type_file.chr20, 	#External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	LIKE type_file.chr1000,	#RDSQL STATEMENT           #No.FUN-690026 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                               imo01 LIKE imo_file.imo01,  #借料單號
                               imo02 LIKE imo_file.imo02,  #借料日期
                               imo03 LIKE imo_file.imo03,  #廠商編號
                               imo04 LIKE imo_file.imo04,  #廠商簡稱
                               imo06 LIKE imo_file.imo06,  #借料人員
                               gen02 LIKE gen_file.gen02,  #借料人員
                               imp02 LIKE imp_file.imp02,  #項次
                               imp03 LIKE imp_file.imp03,  #料件編號
                               imp04 LIKE imp_file.imp04,  #借料數量
                               imp05 LIKE imp_file.imp05,  #借料單位
                               imp06 LIKE imp_file.imp06,  #預計償還日
                               imp14 LIKE imp_file.imp14,  #庫存單位
#                              ima262 LIKE ima_file.ima262,  #庫存數量    #FUN-A20044
                               avl_stk LIKE type_file.num15_3,            #FUN-A20044
                               qty   LIKE imp_file.imp04,  #庫存可用量
                               imp48 LIKE imp_file.imp04   #未還數量
                        END RECORD
          ,l_avl_stk_mpsmrp LIKE type_file.num15_3,        #FUN-A20044
           l_unavl_stk      LIKE type_file.num15_3,        #FUN-A20044
           l_avl_stk        LIKE type_file.num15_3         #FUN-A20044
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DECLARE r309_za_cur2 CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "aimr309" AND za03 = g_rlang
     FOREACH r309_za_cur2 INTO g_i,l_za05
        LET g_x[g_i] = l_za05
     END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr309'
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
     #End:FUN-980030
 
     LET l_sql = "SELECT ",
                 " imo01,imo02,imo03,imo04,imo06,gen02, ",
                 " imp02,imp03,imp04,imp05,imp06,",
#                " imp14, ima262,",                  #FUN-A20044
                 " imp14, ' ',",                     #FUN-A20044
                 " '',(imp04-imp08) ",
                 "  FROM imo_file,imp_file,ima_file,OUTER gen_file",
                 " WHERE ",tm.wc CLIPPED, " AND imo01=imp01 ",
                 " AND imo_file.imo06=gen_file.gen01  AND imp07 NOT IN ('y','Y') ",
                 " AND ima01=imp03 ",
                 " ORDER BY imo04,imo01,imp02,imo02 "
     PREPARE r309_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE r309_curs2 CURSOR FOR r309_prepare2
 
     CALL cl_outnam('aimr309') RETURNING l_name
#FUN-680025--begin
#No.FUN-550029-start
#    LET g_len = 156
#    FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550029-end
#FUN-680025-end
     START REPORT r309_rep2 TO l_name
#FUN-680025--begin
      LET g_pageno = 0
      LET g_zaa[36].zaa06='Y'
      LET g_zaa[37].zaa06='Y'
      LET g_zaa[40].zaa06='Y'                                                                                                       
      LET g_zaa[41].zaa06='Y'                                                                                                       
      LET g_zaa[42].zaa06='Y'                                                                                                       
      LET g_zaa[43].zaa06='Y'                                                                                                       
      LET g_zaa[44].zaa06='Y'                                                                                                       
      LET g_zaa[45].zaa06='Y'                                                                                                       
      LET g_zaa[46].zaa06='Y'                                                                                                       
      LET g_zaa[47].zaa06='Y'                                                                                                       
      LET g_zaa[48].zaa06='Y'                                                                                                       
      LET g_zaa[49].zaa06='Y'                                                                                                       
      LET g_zaa[50].zaa06='Y'
      LET g_zaa[51].zaa06='Y'                                                                                                       
      LET g_zaa[52].zaa06='Y'                                                                                                       
      CALL cl_prt_pos_len()
#FUN-680025-end                                                                                                        
     FOREACH r309_curs2 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

#FUN-A20044 ---start---
       CALL s_getstock(sr.imp03,g_plant) RETURNING l_avl_Stk_mpsmrp, l_unavl_stk,l_avl_stk
       LET sr.avl_stk = l_avl_stk
#No.FUN-A20044 ---end---

	   IF sr.imo03 IS NULL THEN LET sr.imo03 = ' ' END IF
	   IF sr.imo04 IS NULL THEN LET sr.imo04 = ' ' END IF
       IF sr.imo02 IS NULL THEN LET sr.imo02 = ' ' END IF
#      LET sr.qty=sr.ima262                #FUN-A20044
       LET sr.qty = sr.avl_stk             #FUN-A20044
       OUTPUT TO REPORT r309_rep2(sr.*)
     END FOREACH
 
     FINISH REPORT r309_rep2
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r309_rep2(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr            RECORD
                               imo01  LIKE imo_file.imo01,  #借料單號
                               imo02  LIKE imo_file.imo02,  #借料日期
                               imo03  LIKE imo_file.imo03,  #廠商編號
                               imo04  LIKE imo_file.imo04,  #廠商簡稱
                               imo06  LIKE imo_file.imo06,  #借料人員
                               gen02  LIKE gen_file.gen02,  #借料人員
                               imp02  LIKE imp_file.imp02,  #項次
                               imp03  LIKE imp_file.imp03,  #料件編號
                               imp04  LIKE imp_file.imp04,  #借料數量
                               imp05  LIKE imp_file.imp05,  #借料單位
                               imp06  LIKE imp_file.imp06,  #預計償還日
                               imp14  LIKE imp_file.imp14,  #庫存單位
#                              ima262 LIKE ima_file.ima262, #庫存數量   #FUN-A20044
                               avl_stk LIKE type_file.num15_3,          #FUN-A20044  
                               qty    LIKE imp_file.imp04,  #庫存可用量
                               imp48  LIKE imp_file.imp04   #未還量
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.imo04,sr.imo01,sr.imp02
  FORMAT
   PAGE HEADER
#FUN-680025--begin
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1 
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
      PRINT ''  
#FUN-680025--end
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.imo04   #廠商編號
      IF (PAGENO > 1 OR LINENO > 5)
         THEN SKIP TO TOP OF PAGE
      END IF
      PRINT g_x[11] CLIPPED,sr.imo04," (",sr.imo03,") "
#FUN-680025--begin
      PRINT ''
#No.FUN-550029  --start
#     PRINT g_x[12] ,' ', g_x[13] CLIPPED ,COLUMN 92,g_x[20] CLIPPED, COLUMN 101,g_x[17].substring(1,23),
#           COLUMN 138,g_x[18] clipped
#No.FUN-550029  --end
#     PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                     g_x[38],g_x[39],
             g_x[53],g_x[54],g_x[55],g_x[56],g_x[57],g_x[58]
#     PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],                                                               
#                    g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]  
      PRINT g_dash1  
#FUN-680025--end
 
   BEFORE GROUP OF sr.imo01    #借料單號
#      PRINT sr.imo01;                        #FUN-680025
   ON EVERY ROW
#FUN-680025--begin
      #No.FUN-550029  --start
#     PRINT COLUMN 18,sr.imp02 USING "###&" ,
#           COLUMN 23,sr.imo02,
#           COLUMN 32,sr.gen02 CLIPPED,
#           COLUMN 39,sr.imp03 CLIPPED,
#           COLUMN 60,sr.imp05 CLIPPED,
#           COLUMN 65,sr.imp04 USING "------------&.&&&",' ',
#           COLUMN 83,sr.imp48 USING "------------&.&&&",
#           COLUMN 101,sr.imp06 CLIPPED,
#           COLUMN 110,sr.imp14 CLIPPED,
#           COLUMN 115,sr.ima262 USING "-----------&.&&&",
#           COLUMN 132,sr.qty    USING "-----------&.&&&",' ',
#           '________'
      PRINTX name=D1  COLUMN g_c[31],sr.imo01,
            COLUMN g_c[32],sr.imp02 USING "####&", 
            COLUMN g_c[33],sr.imo02,
            COLUMN g_c[34],sr.gen02 CLIPPED,
            COLUMN g_c[35],sr.imp03 CLIPPED,
            COLUMN g_c[38],sr.imp05 CLIPPED, 
            COLUMN g_c[39],cl_numfor(sr.imp04,39,3),
            COLUMN g_c[53],cl_numfor(sr.imp48,53,3),
            COLUMN g_c[54],sr.imp06 CLIPPED,
            COLUMN g_c[55],sr.imp14 CLIPPED,
#           COLUMN g_c[56],cl_numfor(sr.ima262,56,3),     #FUN-A20044
            COLUMN g_c[56],cl_numfor(sr.avl_stk,56,3),    #FUN-A20044 
            COLUMN g_c[57],cl_numfor(sr.qty,57,3),
            COLUMN g_c[58],'________' 
      #No.FUN-550029  --end
#FUN-680025--end
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
       #TQC-630166
       #       IF tm.wc[001,120] > ' ' THEN			# for 132
 #		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
 #             IF tm.wc[121,240] > ' ' THEN
 #		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
 #             IF tm.wc[241,300] > ' ' THEN
 #		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
#Patch....NO.TQC-610036 <001> #
