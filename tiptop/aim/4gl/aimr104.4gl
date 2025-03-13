# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr104.4gl
# Desc/riptions...: 料件生管資料列印
# Input parameter:
# Return code....:
# Date & Author..: 92/03/17 By DAVID
# Modify ........: 92/05/25 By David
# Modify ........: No:9747 04/07/09 By Mandy 每一頁最底端皆顯示結束!,改成只有最後一頁show 結束,其它show接下頁
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5A0046 05/10/17 By Sarah 品名規格(ima02)放大到60碼
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 調整報表出表欄位的位置,對齊
# Modify.........: No.TQC-5B0121 05/11/16 By Sarah 報表單頭料號長度應調整成40碼
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.MOD-640200 06/04/14 BY yiting 取消g_x[41],g_x[39] 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770006 07/08/02 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm  RECORD				# Print condition RECORD
              wc  	LIKE type_file.chr1000,	# Where condition  #No.FUN-690026 VARCHAR(500)
              s    	LIKE type_file.chr3,  	# Order by sequence  #No.FUN-690026 VARCHAR(3)
              y    	LIKE type_file.chr1,  	# group code choice  #No.FUN-690026 VARCHAR(1)
              more	LIKE type_file.chr1   	# Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
             END RECORD,
         g_ima01        LIKE ima_file.ima01,    # item no
         g_ima05        LIKE ima_file.ima05,    # version
         g_ima06        LIKE ima_file.ima06,    # group code
         g_ima08        LIKE ima_file.ima08     # source code
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_str          STRING                  #No.FUN-770006
 
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
      THEN CALL r113_tm(0,0)		# Input print condition
      ELSE CALL aimr104()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r113_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 14 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17
   ELSE
       LET p_row = 3 LET p_col = 14
   END IF
 
   OPEN WINDOW r113_w AT p_row,p_col
        WITH FORM "aim/42f/aimr104"
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
      CLOSE WINDOW r113_w
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
      LET INT_FLAG = 0 CLOSE WINDOW r113_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr104'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr104','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr104',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r113_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr104()
   ERROR ""
END WHILE
   CLOSE WINDOW r113_w
END FUNCTION
 
FUNCTION aimr104()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_za05	LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
          l_order	ARRAY[3] OF LIKE ima_file.ima01,#FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr            RECORD
                         order1 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         ima01 LIKE ima_file.ima01,   # part no
                         ima02 LIKE ima_file.ima02,   # discription
                         ima05 LIKE ima_file.ima05,   # version
                         ima06 LIKE ima_file.ima06,   # group code
                         ima09 LIKE ima_file.ima09,   # group code
                         ima10 LIKE ima_file.ima10,   # group code
                         ima11 LIKE ima_file.ima11,   # group code
                         ima12 LIKE ima_file.ima12,   # group code
                         ima08 LIKE ima_file.ima08,   # source code
                         ima25 LIKE ima_file.ima25,   # inventory unit
                         ima03 LIKE ima_file.ima03,   # dir ref. no
                         ima70 LIKE ima_file.ima70,
                         ima42 LIKE ima_file.ima42,   # trace lot no
                         ima55 LIKE ima_file.ima55,   # production unit
                         ima55_fac LIKE ima_file.ima55_fac, # Inv/Prod factor
                         ima56  LIKE ima_file.ima56,  # prod unit lot size
                         ima561 LIKE ima_file.ima561, # min prod. qty
                         ima562 LIKE ima_file.ima562, #
                         ima59 LIKE ima_file.ima59,   # fix prepare time
                         ima60 LIKE ima_file.ima60,   # var prepare time
                         ima61 LIKE ima_file.ima61,   # QC prepare time
                         ima62 LIKE ima_file.ima62,   # max sumary pre time
                         ima58 LIKE ima_file.ima58,   # last lable hour
                         ima67 LIKE ima_file.ima67,   # planner
                         ima68 LIKE ima_file.ima68,   # time offset
                         ima69 LIKE ima_file.ima69,   #plan offset
                         ima63 LIKE ima_file.ima63,   #
                         ima63_fac LIKE ima_file.ima63_fac,
                         ima64  LIKE ima_file.ima64,
                         ima641 LIKE ima_file.ima641,
                         ima571 LIKE ima_file.ima571,
                         ima65  LIKE ima_file.ima65,
                         ima66  LIKE ima_file.ima66
                        END RECORD
   DEFINE l_chr LIKE type_file.chr1000                 #No.FUN-770006
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr104'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
 
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
 
#    LET l_sql = "SELECT '','','',",                       #No.FUN-770006
     LET l_sql = "SELECT ",                                #No.FUN-770006
                 " ima01,ima02,ima05,ima06,ima09, ",
                 " ima10,ima11,ima12,ima08,ima25,ima03, ",
                 " ima70,ima42,ima55,ima55_fac,ima56, ",
                 " ima561,ima562,ima59,ima60,ima61,ima62,ima58, ",
                 " ima67,ima68,ima69,ima63,ima63_fac, ",
                 " ima64,ima641,ima571,ima65,ima66 ",
                 " FROM ima_file ",
                 " WHERE ", tm.wc CLIPPED
 
#No.FUN-770006 --start-- mark
#     PREPARE r113_prepare1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#        EXIT PROGRAM
#           
#     END IF
#     DECLARE r113_cs1 CURSOR FOR r113_prepare1
#     CALL cl_outnam('aimr104') RETURNING l_name
#     START REPORT r113_rep TO l_name
#
#     LET g_pageno = 0
#     FOREACH r113_cs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#       END IF
#       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
#       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
#       IF sr.ima06 IS NULL THEN LET sr.ima06 = ' ' END IF
#       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
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
#       OUTPUT TO REPORT r113_rep(sr.*)
#     END FOREACH
#
#     FINISH REPORT r113_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-770006 --end--
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
      CALL cl_prt_cs1('aimr104','aimr104',l_sql,g_str)                          
#No.FUN-770006 --end-- 
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT r113_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_str         LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(20)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          i,l_page      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr            RECORD
                         order1 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order2 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         order3 LIKE ima_file.ima01,  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                         ima01 LIKE ima_file.ima01,
                         ima02 LIKE ima_file.ima02,
                         ima05 LIKE ima_file.ima05,
                         ima06 LIKE ima_file.ima06,
                         ima09 LIKE ima_file.ima09,   # group code
                         ima10 LIKE ima_file.ima10,   # group code
                         ima11 LIKE ima_file.ima11,   # group code
                         ima12 LIKE ima_file.ima12,   # group code
                         ima08 LIKE ima_file.ima08,
                         ima25 LIKE ima_file.ima25,
                         ima03 LIKE ima_file.ima03,
                         ima70 LIKE ima_file.ima70,
                         ima42 LIKE ima_file.ima42,
                         ima55 LIKE ima_file.ima55,
                         ima55_fac LIKE ima_file.ima55_fac,
                         ima56  LIKE ima_file.ima56,
                         ima561 LIKE ima_file.ima561,
                         ima562 LIKE ima_file.ima562,
                         ima59 LIKE ima_file.ima59,
                         ima60 LIKE ima_file.ima60,
                         ima61 LIKE ima_file.ima61,
                         ima62 LIKE ima_file.ima62,
                         ima58 LIKE ima_file.ima58,
                         ima67 LIKE ima_file.ima67,
                         ima68 LIKE ima_file.ima68,
                         ima69 LIKE ima_file.ima69,
                         ima63 LIKE ima_file.ima63,
                         ima63_fac LIKE ima_file.ima63_fac,
                         ima64  LIKE ima_file.ima64,
                         ima641 LIKE ima_file.ima641,
                         ima571 LIKE ima_file.ima571,
                         ima65  LIKE ima_file.ima65,
                         ima66  LIKE ima_file.ima66
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
      LET l_last_sw = 'n' #No:9747
 
   BEFORE GROUP OF sr.ima01
      IF l_page >0
         THEN SKIP TO TOP OF PAGE
      END IF
      PRINT ' ',g_x[11] CLIPPED,sr.ima01,
     #start TQC-5B0121
     #      COLUMN 33,g_x[12] CLIPPED,sr.ima05;
     #PRINT COLUMN 45,g_x[13] CLIPPED,sr.ima08,
     #      COLUMN 67,g_x[14] CLIPPED;
            COLUMN 53,g_x[12] CLIPPED,sr.ima05;
      PRINT COLUMN 65,g_x[13] CLIPPED,sr.ima08,
            COLUMN 80,g_x[14] CLIPPED;
     #end TQC-5B0121
      PRINT sr.ima25
      PRINT ' ',g_x[15] CLIPPED,sr.ima02,
           #COLUMN 53,g_x[16] CLIPPED,sr.ima03   #FUN-5A0046 mark
           #start TQC-5B0121
           #COLUMN 67,g_x[16] CLIPPED,sr.ima03   #FUN-5A0046
            COLUMN 80,g_x[16] CLIPPED,sr.ima03   #FUN-5A0046
           #end TQC-5B0121
      PRINT g_dash2[1,g_len]
     #LET l_last_sw = 'n' #No:9747
 
   ON EVERY ROW
      PRINT ' ',g_x[17] CLIPPED,sr.ima70,
            COLUMN 39,g_x[18] CLIPPED
      PRINT COLUMN 42,g_x[20] CLIPPED,sr.ima67
      PRINT ' ',g_x[21] CLIPPED,
            COLUMN 42,g_x[22] CLIPPED,sr.ima68
     #start TQC-5B0059
     #PRINT ' ',g_x[23] CLIPPED,sr.ima55,
     #      COLUMN 42,g_x[24] CLIPPED,sr.ima69
     #PRINT ' ',g_x[25] CLIPPED,cl_facfor(sr.ima55_fac),
     #      COLUMN 39,g_x[26] CLIPPED
     #PRINT ' ',g_x[27] CLIPPED,sr.ima56,
     #      COLUMN 42,g_x[28] CLIPPED,sr.ima63
     #PRINT ' ',g_x[29] CLIPPED,sr.ima561,
     #      COLUMN 42,g_x[30] CLIPPED,cl_facfor(sr.ima63_fac)
     #PRINT ' ',g_x[31] CLIPPED,sr.ima562,'%',
     #      COLUMN 42,g_x[32] CLIPPED,sr.ima64
     #PRINT ' ',g_x[33] CLIPPED,sr.ima59,
     #      COLUMN 42,g_x[34] CLIPPED,sr.ima641
     #PRINT ' ',g_x[35] CLIPPED,sr.ima60,
     #      COLUMN 42,g_x[36] CLIPPED,sr.ima571
     #PRINT ' ',g_x[37] CLIPPED,sr.ima61
     #PRINT ' ',g_x[38] CLIPPED,' ',sr.ima62,
     #      COLUMN 42,g_x[39] CLIPPED,sr.ima65
     #PRINT ' ',g_x[40] CLIPPED,sr.ima58,
     #      COLUMN 42,g_x[41] CLIPPED,sr.ima66
      PRINT ' ',g_x[23] CLIPPED,sr.ima55,
            COLUMN 42,g_x[24] CLIPPED,sr.ima69
      PRINT ' ',g_x[25] CLIPPED,COLUMN 26,cl_facfor(sr.ima55_fac),
            COLUMN 39,g_x[26] CLIPPED
      PRINT ' ',g_x[27] CLIPPED,COLUMN 18,sr.ima56,
            COLUMN 42,g_x[28] CLIPPED,sr.ima63
      PRINT ' ',g_x[29] CLIPPED,COLUMN 18,sr.ima561,
            COLUMN 42,g_x[30] CLIPPED,COLUMN 56,cl_facfor(sr.ima63_fac)
      PRINT ' ',g_x[31] CLIPPED,COLUMN 27,sr.ima562,'%',
            COLUMN 42,g_x[32] CLIPPED,COLUMN 56,sr.ima64
      PRINT ' ',g_x[33] CLIPPED,COLUMN 24,sr.ima59,
            COLUMN 42,g_x[34] CLIPPED,COLUMN 56,sr.ima641
      PRINT ' ',g_x[35] CLIPPED,COLUMN 24,sr.ima60,
            COLUMN 42,g_x[36] CLIPPED,COLUMN 65,sr.ima571
      PRINT ' ',g_x[37] CLIPPED,COLUMN 24,sr.ima61
#NO.MOD-640200 mark
#      PRINT ' ',g_x[38] CLIPPED,' ',COLUMN 24,sr.ima62,
#            COLUMN 42,g_x[39] CLIPPED,COLUMN 56,sr.ima65
#      PRINT ' ',g_x[40] CLIPPED,COLUMN 18,sr.ima58,
#            COLUMN 42,g_x[41] CLIPPED,COLUMN 62,sr.ima66
#NO.MOD-640200 mark
     #end TQC-5B0059
   #No:9747
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
   #No:9447(end)
END REPORT}
#No.FUN-770006 --end--
#Patch....NO.TQC-610036 <> #
