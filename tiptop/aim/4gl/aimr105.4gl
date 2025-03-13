# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr105.4gl
# Desc/riptions...: 料件成本資料列印
# Input parameter:
# Return code....:
# Date & Author..: 92/03/17 By DAVID
#      Modify ...: 92/05/25 By David
#      Modify ...: No:9749 04/07/09 By Mandy 每一頁最底端皆顯示結束!,改成只有最後一頁show 結束,其它show接下頁
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0045 05/10/17 By Sarah 品名規格(ima02)放大到60碼
# Modify.........: No.TQC-5C0067 05/12/13 By kim 報表料號放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770006 07/08/02 By zhoufeng 報表產出改為Crystal Report
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm  RECORD				# Print condition RECORD
	      wc  	LIKE type_file.chr1000,	# Where condition  #No.FUN-690026 VARCHAR(500)
   	      s    	LIKE type_file.chr3,  	# Order by sequence  #No.FUN-690026 VARCHAR(3)
   	      y    	LIKE type_file.chr1,  	# group code choice  #No.FUN-690026 VARCHAR(1)
   	      more	LIKE type_file.chr1   	# Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
             END RECORD,
         g_ima01        LIKE ima_file.ima01,   # item no
         g_ima05        LIKE ima_file.ima05,   # version
         g_ima06        LIKE ima_file.ima06,   # group code
         g_ima08        LIKE ima_file.ima08    # source code
DEFINE   g_i            LIKE type_file.num5    # count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_sql          STRING                 #No.FUN-770006
DEFINE   g_str          STRING                 #No.FUN-770006
DEFINE   l_table        STRING                 #No.FUN-770006
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #No.FUN-770006 --start--
   LET g_sql="ima01.ima_file.ima01,ima05.ima_file.ima05,ima08.ima_file.ima08,",
             "ima02.ima_file.ima02,ima25.ima_file.ima25,ima03.ima_file.ima03,",
             "ima34.ima_file.ima34,smh02.smh_file.smh02,ima39.ima_file.ima39,",
             "ima87.ima_file.ima87,ima871.ima_file.ima871,",
             "ima872.ima_file.ima872,ima873.ima_file.ima873,",
             "ima874.ima_file.ima874,smg02.smg_file.smg02,",
             "smg02_1.smg_file.smg02,smg02_2.smg_file.smg02,",
             "ima06.ima_file.ima06,ima09.ima_file.ima09,ima10.ima_file.ima10,",
             "ima11.ima_file.ima11,ima12.ima_file.ima12"
 
   LET l_table = cl_prt_temptable('aimr105',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-770006 --end-- 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.y  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r114_tm(0,0)		# Input print condition
      ELSE CALL aimr105()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r114_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17
   ELSE
       LET p_row = 3 LET p_col = 14
   END IF
 
   OPEN WINDOW r114_w AT p_row,p_col
        WITH FORM "aim/42f/aimr105"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
WHILE TRUE
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,ima09,
							  ima10,ima11,ima12,ima08
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end
 
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r114_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.y,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD y
         IF tm.y NOT MATCHES "[0-4]" OR tm.y IS NULL
            THEN NEXT FIELD y
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r114_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr105'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr105','9031',1)
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
                         " '",tm.s  CLIPPED,"'",
                         " '",tm.y  CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr105',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r114_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr105()
   ERROR ""
END WHILE
   CLOSE WINDOW r114_w
END FUNCTION
 
FUNCTION aimr105()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_za05	LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,#FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                         order1  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         ima01   LIKE ima_file.ima01,
                         ima05   LIKE ima_file.ima05,
                         ima06   LIKE ima_file.ima06,
                         ima09   LIKE ima_file.ima09,
                         ima10   LIKE ima_file.ima10,
                         ima11   LIKE ima_file.ima11,
                         ima12   LIKE ima_file.ima12,
                         ima08   LIKE ima_file.ima08,
                         ima02   LIKE ima_file.ima02,
                         ima25   LIKE ima_file.ima25,
                         ima03   LIKE ima_file.ima03,
                        #ima86   LIKE ima_file.ima86,         #FUN-560183
                        #ima86_fac LIKE ima_file.ima86_fac, #FUN-560183
                         ima34   LIKE ima_file.ima34,
                         ima39   LIKE ima_file.ima39,
                         ima87   LIKE ima_file.ima87,
                         ima871  LIKE ima_file.ima871,
                         ima872  LIKE ima_file.ima872,
                         ima873  LIKE ima_file.ima873,
                         ima874  LIKE ima_file.ima874,
                         smh02   LIKE smh_file.smh02,
                         smg02_1 LIKE smg_file.smg02,
                         smg02_2 LIKE smg_file.smg02,
                         smg02_3 LIKE smg_file.smg02
                        END RECORD
   DEFINE l_chr LIKE type_file.chr1000                #No.FUN-770006
 
     CALL cl_del_data(l_table)                        #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr105'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
 
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
 
     LET l_sql = "SELECT '','','',",
                 " ima01,ima05,ima06,ima09,ima10, ",
                 " ima11,ima12,ima08,ima02,ima25,ima03, ",
                 " ima34,ima39,ima87, ", #FUN-560183 拿掉 ima86,ima86_fac,
                 " ima871,ima872,ima873,ima874,smh02,'','','' ",
                 " FROM ima_file ,OUTER smh_file ",
                 " WHERE ima_file.ima34= smh_file.smh01 AND ",
                   tm.wc CLIPPED
 
     PREPARE r114_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r114_cs1 CURSOR FOR r114_prepare1
#     CALL cl_outnam('aimr105') RETURNING l_name       #No.FUN-770006
#     START REPORT r114_rep TO l_name                  #No.FUN-770006
 
#     LET g_pageno = 0                                 #No.FUN-770006
     FOREACH r114_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
	      CALL cl_err('foreach:',SQLCA.sqlcode,1)
		  EXIT FOREACH
	   END IF
	   SELECT smg02 INTO sr.smg02_1 FROM smg_file WHERE sr.ima87 = smg01
            IF SQLCA.sqlcode != 0 THEN LET sr.smg02_1 = NULL END IF
	   SELECT smg02 INTO sr.smg02_2 FROM smg_file WHERE sr.ima872= smg01
            IF SQLCA.sqlcode != 0 THEN LET sr.smg02_2 = NULL END IF
	   SELECT smg02 INTO sr.smg02_3 FROM smg_file WHERE sr.ima874= smg01
            IF SQLCA.sqlcode != 0 THEN LET sr.smg02_3 = NULL END IF
       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
#No.FUN-770006 --start-- mark
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
#               WHEN tm.s[g_i,g_i] = '3'
#                   CASE
#			 WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#			 WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#			 WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#			 WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#			 WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#                   END CASE
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT r114_rep(sr.*)
#No.FUN-770006 --end--
#No.FUN-770006 --start--
       EXECUTE insert_prep USING sr.ima01,sr.ima05,sr.ima08,sr.ima02,
                                 sr.ima25,sr.ima03,sr.ima34,sr.smh02,
                                 sr.ima39,sr.ima87,sr.ima871,sr.ima872,
                                 sr.ima873,sr.ima874,sr.smg02_1,sr.smg02_2,
                                 sr.smg02_3,sr.ima06,sr.ima09,sr.ima10,
                                 sr.ima11,sr.ima12
#No.FUN-770006 --end--
     END FOREACH
 
#     FINISH REPORT r114_rep                      #No.FUN-770006
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-770006
#No.FUN-770006 --start--                                                        
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                  
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'ima01,ima05,ima06,ima09,ima10,ima11,ima12,ima08') 
              RETURNING tm.wc                                                   
         LET g_str = tm.wc                                                      
      END IF                                                                    
      IF g_towhom IS NULL OR g_towhom = ' ' THEN                                
         LET l_chr = ' '                                                        
      ELSE LET l_chr = 'TO:',g_towhom                                           
      END IF                                                                    
      LET g_str = g_str,";",l_chr,";",tm.s[1,1],";",tm.s[2,2],";",              
                  tm.s[3,3],";",tm.y         
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                   
      CALL cl_prt_cs3('aimr105','aimr105',l_sql,g_str)                          
#No.FUN-770006 --end-- 
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT r114_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_str         LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(20)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          i,l_page      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr            RECORD
                         order1  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         ima01   LIKE ima_file.ima01,
                         ima05   LIKE ima_file.ima05,
                         ima06   LIKE ima_file.ima06,
                         ima09   LIKE ima_file.ima09,
                         ima10   LIKE ima_file.ima10,
                         ima11   LIKE ima_file.ima11,
                         ima12   LIKE ima_file.ima12,
                         ima08   LIKE ima_file.ima08,
                         ima02   LIKE ima_file.ima02,
                         ima25   LIKE ima_file.ima25,
                         ima03   LIKE ima_file.ima03,
                        #ima86   LIKE ima_file.ima86,          #FUN-560183
                        #ima86_fac LIKE ima_file.ima86_fac,  #FUN-560183
                         ima34   LIKE ima_file.ima34,
                         ima39   LIKE ima_file.ima39,
                         ima87   LIKE ima_file.ima87,
                         ima871  LIKE ima_file.ima871,
                         ima872  LIKE ima_file.ima872,
                         ima873  LIKE ima_file.ima873,
                         ima874  LIKE ima_file.ima874,
                         smh02   LIKE smh_file.smh02,
                         smg02_1 LIKE smg_file.smg02,
                         smg02_2 LIKE smg_file.smg02,
                         smg02_3 LIKE smg_file.smg02
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
	  LET l_page =0
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n' #No:9749
 
   BEFORE GROUP OF sr.ima01
      IF l_page >0
         THEN SKIP TO TOP OF PAGE
      END IF
      PRINT ' ',g_x[11] CLIPPED,sr.ima01,
            COLUMN 55,g_x[12] CLIPPED,sr.ima05; #TQC-5C0067 33->55
      PRINT COLUMN 65,g_x[13] CLIPPED,sr.ima08, #TQC-5C0067 45->65
            COLUMN 81,g_x[14] CLIPPED; #TQC-5C0067 67->81
      PRINT sr.ima25
      PRINT ' ',g_x[15] CLIPPED,sr.ima02,
           #COLUMN 53,g_x[16] CLIPPED,sr.ima03   #FUN-5A0045 mark
            COLUMN 65,g_x[16] CLIPPED,sr.ima03   #FUN-5A0045 #TQC-5C0067 67->65
     #PRINT g_x[26] CLIPPED,g_x[27] CLIPPED      #FUN-5A0045 mark
      PRINT  g_dash2[1,g_len]                    #FUN-5A0045
     #LET l_last_sw = 'n' #No:9749
 
   ON EVERY ROW
      #FUN-560183................begin
     #PRINT ' ',g_x[17] CLIPPED,sr.ima86,COLUMN 44,g_x[18] CLIPPED,
     #         cl_facfor(sr.ima86_fac)
      #FUN-560183................end
      PRINT ' ',g_x[19] CLIPPED,sr.ima34
      PRINT '          ',sr.smh02
      PRINT ' ',g_x[20] CLIPPED,sr.ima39
      PRINT  g_dash2[1,g_len]
      PRINT ' ',g_x[21] CLIPPED,sr.ima87,' ',sr.smg02_1
      PRINT ' ',g_x[22] CLIPPED,sr.ima871
      PRINT ' ',g_x[23] CLIPPED,sr.ima872,' ',sr.smg02_2
      PRINT ' ',g_x[24] CLIPPED,sr.ima873
      PRINT ' ',g_x[25] CLIPPED,sr.ima874,' ',sr.smg02_3
 
   #No:9749
   AFTER GROUP OF sr.ima01
    LET l_page = 1
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE
             PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
     END IF
   #No:9749(end)
END REPORT}
#No.FUN-770006 --end--
#Patch....NO.TQC-610036 <> #
