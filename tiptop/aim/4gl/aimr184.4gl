# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr184.4gl
# Descriptions...: 料件單位換算資料列印
# Input parameter:
# Return code....:
# Date & Author..: 92/03/17 By DAVID
#      Modify ...: 92/05/25 By David
#      Modify ...: No:9750 04/07/13 By Mandy 每一頁最底端皆顯示結束!,改成只有最後一頁show 結束,其它show接下頁
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加開窗查詢
# Modify.........: No.FUN-580014 05/08/16 By jackie 轉XML
# Modify.........: No.MOD-5B0310 05/11/24 By kim 料號放大
# Modify.........: No.TQC-5C0068 05/12/13 By kim 資料不對齊
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-780012 07/08/08 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD                         # Print condition RECORD
                wc    LIKE type_file.chr1000,  # Where condition    #No.FUN-690026 VARCHAR(500)
                s     LIKE type_file.chr3,     # Order by sequence  #No.FUN-690026 VARCHAR(3)
                y     LIKE type_file.chr1,     # group code choice  #No.FUN-690026 VARCHAR(1)
                more  LIKE type_file.chr1      # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                END RECORD,
       g_ima01  LIKE ima_file.ima01,   # item no
       g_ima05  LIKE ima_file.ima05,   # version
       g_ima06  LIKE ima_file.ima06,   # group code
       g_ima08  LIKE ima_file.ima08    # source code
DEFINE g_i      LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_str    STRING                 #No.FUN-780012
 
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
      THEN CALL r115_tm(0,0)		# Input print condition
      ELSE CALL aimr184()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r115_tm(p_row,p_col)
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
   OPEN WINDOW r115_w AT p_row,p_col
        WITH FORM "aim/42f/aimr184"
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
   LET tm2.s1   = '1'
   LET tm2.s2   = '2'
   LET tm2.s3   = '3'
WHILE TRUE
   DISPLAY BY NAME tm.s,tm.y,tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima05,ima06,ima09,
							  ima10,ima11,ima12,ima08
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
      LET INT_FLAG = 0 CLOSE WINDOW r114_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW r115_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr184'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr184','9031',1)
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
         CALL cl_cmdat('aimr184',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r115_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr184()
   ERROR ""
END WHILE
   CLOSE WINDOW r115_w
END FUNCTION
 
FUNCTION aimr184()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_za05	LIKE za_file.za05,                 #No.FUN-690026 VARCHAR(40)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01  LIKE ima_file.ima01,
                               ima05  LIKE ima_file.ima05,
                               ima06  LIKE ima_file.ima06,
                               ima09  LIKE ima_file.ima09,
                               ima10  LIKE ima_file.ima10,
                               ima11  LIKE ima_file.ima11,
                               ima12  LIKE ima_file.ima12,
                               ima08  LIKE ima_file.ima08,
                               ima02  LIKE ima_file.ima02,
                               ima25  LIKE ima_file.ima25,
                               ima44  LIKE ima_file.ima44,
                               ima63  LIKE ima_file.ima63,
                               ima55  LIKE ima_file.ima55,
                               smd02  LIKE smd_file.smd02,
                               smd03  LIKE smd_file.smd03,
                               smd04  LIKE smd_file.smd04,
                               smd05  LIKE smd_file.smd05,
                               smd06  LIKE smd_file.smd06
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 " ima01,ima05,ima06,ima09,ima10,ima11,ima12, ",
                 " ima08,ima02,ima25,ima44, ",
                 " ima63,ima55,smd02,smd03,smd04, ",
                 " smd05 ,smd06 ",
                 " FROM ima_file,smd_file ",
                 " WHERE ima01= smd01 AND ",tm.wc CLIPPED
 
#No.FUN-780012 --start-- mark
#     PREPARE r115_prepare1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#        EXIT PROGRAM
#           
#     END IF
#     DECLARE r115_cs1 CURSOR FOR r115_prepare1
#     CALL cl_outnam('aimr184') RETURNING l_name
#     START REPORT r115_rep TO l_name
#
#     LET g_pageno = 0
#     FOREACH r115_cs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN
#	      CALL cl_err('foreach:',SQLCA.sqlcode,1)
#		  EXIT FOREACH
#	   END IF
#       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
#       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
#       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
#       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
#               WHEN tm.s[g_i,g_i] = '3'
#                   CASE
#                    WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
#                    WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
#                    WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
#                    WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
#                    WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
#                   END CASE
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima08
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT r115_rep(sr.*)
#     END FOREACH
#
#     FINISH REPORT r115_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-780012 --end--
#No.FUN-780012 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                    
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'ima01,ima05,ima06,ima09,ima10,ima11,ima12,ima08')                                 
            RETURNING tm.wc                                                     
       LET g_str = tm.wc                                                        
    END IF                                                                      
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.y
    CALL cl_prt_cs1('aimr184','aimr184',l_sql,g_str)
#No.FUN-780012 --end--
END FUNCTION
#No.FUN-780012 --start-- mark
{REPORT r115_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_factor      LIKE ima_file.ima86_fac,
          i,l_page      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr            RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                               ima01 LIKE ima_file.ima01,
                               ima05 LIKE ima_file.ima05,
                               ima06 LIKE ima_file.ima06,
                               ima09 LIKE ima_file.ima09,
                               ima10 LIKE ima_file.ima10,
                               ima11 LIKE ima_file.ima11,
                               ima12 LIKE ima_file.ima12,
                               ima08 LIKE ima_file.ima08,
                               ima02 LIKE ima_file.ima02,
                               ima25 LIKE ima_file.ima25,
                               ima44 LIKE ima_file.ima44,
                               ima63 LIKE ima_file.ima63,
                               ima55 LIKE ima_file.ima55,
                               smd02 LIKE smd_file.smd02,
                               smd03 LIKE smd_file.smd03,
                               smd04 LIKE smd_file.smd04,
                               smd05 LIKE smd_file.smd05,
                               smd06 LIKE smd_file.smd06
                        END RECORD
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.ima01
  FORMAT
   PAGE HEADER
#No.FUN-580014 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
         LET l_page =0
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n' #No:9750
 
   BEFORE GROUP OF sr.ima01
      IF l_page >0
         THEN SKIP TO TOP OF PAGE
      END IF
      PRINT g_x[11] CLIPPED,sr.ima01,COLUMN 51,g_x[12] CLIPPED,sr.ima05; #TQC-5C0068 41->51
      PRINT COLUMN 83,g_x[13] CLIPPED,sr.ima08 #TQC-5C0068 73->83
      PRINT g_x[15] CLIPPED,sr.ima02 CLIPPED,COLUMN 83,g_x[16] CLIPPED,sr.ima06 #TQC-5C0068 73->83
      PRINT g_dash2[1,g_len]
      PRINT g_x[14] CLIPPED,sr.ima25,COLUMN 24,g_x[17] CLIPPED,sr.ima44;
      PRINT COLUMN 51,g_x[18] CLIPPED,sr.ima63,COLUMN 64,g_x[19] CLIPPED,                   sr.ima44
      PRINTX name=H1
                 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
          PRINT g_dash1
      LET l_last_sw = 'n' #No:9750
 
   ON EVERY ROW
	  LET l_factor = sr.smd06 / sr.smd04
      PRINTX name=D1
           #COLUMN g_c[32],sr.smd02,'/',sr.smd04 USING "########.###",
           #COLUMN g_c[33],':',
           #COLUMN g_c[34],sr.smd03,'/',sr.smd06 USING "########.###",
	   #COLUMN g_c[35],cl_facfor(l_factor),
           #COLUMN g_c[36],sr.smd05 CLIPPED
            COLUMN g_c[32],sr.smd02,
            COLUMN g_c[33],'/',
            COLUMN g_c[34],cl_numfor(sr.smd04,34,3),
            COLUMN g_c[35],':',
            COLUMN g_c[36],sr.smd03,
            COLUMN g_c[37],'/',
            COLUMN g_c[38],cl_numfor(sr.smd04,38,3),
            COLUMN g_c[39],cl_facfor(l_factor),
            COLUMN g_c[40],sr.smd05 CLIPPED
#No.FUN-580014 --end--
   #No:9750
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
   #No:9750(end)
END REPORT}
#No.FUN-780012 --end--
#Patch....NO.TQC-610036 <> #
