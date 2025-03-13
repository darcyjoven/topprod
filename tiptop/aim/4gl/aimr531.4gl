# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr531.4gl
# Descriptions...: 借料預償統計表
# Return code....:
# Date & Author..: 92/06/10 By Lin
# Modify.........: 92/11/17 By Pin
# Modify.........: No.FUN-4A0047 04/10/07 By Smapmin增加開窗功能
# Modify.........: No.FUN-510017 05/01/11 By Mandy 報表轉XML
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/01/29 By TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/28 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60046 10/06/19 By chenmoyan MSV中報錯insert_prep
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                       # Print condition RECORD
           wc    STRING,                # Where Condition  #TQC-630166
           s     LIKE type_file.chr1,   # 排列項目選擇     #No.FUN-690026 VARCHAR(1)
           more  LIKE type_file.chr1    # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 DEFINE l_table     STRING                        ### MOD-720046 add ###
DEFINE g_sql       STRING
DEFINE g_str       STRING
DEFINE g_i LIKE type_file.num5          #count/index for any purpose  #No.FUN-690026 SMALLINT
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
 
   #str FUN-720046 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> MOD-720046 *** ##
   LET g_sql = "order1.imp_file.imp03,",
               "order2.imp_file.imp03,",
               "imp06.imp_file.imp06," ,
               "imp03.imp_file.imp03," ,
               "imp04.imp_file.imp04," ,
               "imp05.imp_file.imp05," ,
               "imo03.imo_file.imo03," ,
               "imo04.imo_file.imo04," ,
               "imo02.imo_file.imo02," ,
               "imo01.imo_file.imo01," ,
               "ima25.ima_file.ima25," ,
               "qty.imp_file.imp04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021"
 
   LET l_table = cl_prt_temptable('aimr531',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,               #TQC-A60046
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #TQC-A60046
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-720046 add
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r531_tm()	        	# Input print condition
      ELSE CALL aimr531()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r531_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       p_row,p_col   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r531_w AT p_row,p_col
        WITH FORM "aim/42f/aimr531"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imp06,imo03,imo04,imo01,imp03
#FUN-4A0047增加開窗功能
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
        CASE  WHEN INFIELD(imo03) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmc"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imo03
              NEXT FIELD imo03
            WHEN INFIELD(imo01) #借料單號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_imo"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imo01
              NEXT FIELD imo01
            WHEN INFIELD(imp03) #料件編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_ima"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imp03
              NEXT FIELD imp03
 
        OTHERWISE EXIT CASE
        END CASE
#FUN-4A0047增加開窗功能
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r531_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.more   # Condition
   INPUT BY NAME tm.s,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD s
         IF tm.s IS NULL OR tm.s NOT MATCHES'[12]'
         THEN NEXT FIELD s
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
      LET INT_FLAG = 0 CLOSE WINDOW r531_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr531'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr531','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr531',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r531_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr531()
   ERROR ""
END WHILE
   CLOSE WINDOW r531_w
END FUNCTION
 
FUNCTION aimr531()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                 # RDSQL STATEMENT     #TQC-630166
          l_chr	    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_flag    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_factor  LIKE ima_file.ima25,
          sr        RECORD
                  order1  LIKE imp_file.imp03,#No.FUN-690026 VARCHAR(20)
                  order2  LIKE imp_file.imp03,#No.FUN-690026 VARCHAR(20)
                    imp06 LIKE imp_file.imp06,  #預計償還日
                    imp03 LIKE imp_file.imp03,  #料件編號
                    imp04 LIKE imp_file.imp04,  #借料數量
                    imp05 LIKE imp_file.imp05,  #借料單位
                    imo03 LIKE imo_file.imo03,  #廠商 #FUN-510017
                    imo04 LIKE imo_file.imo04,  #廠商簡稱
                    imo02 LIKE imo_file.imo02,  #借料日期
                    imo01 LIKE imo_file.imo01,  #借料單號
                    ima25 LIKE ima_file.ima25,  #料庫存單位
                    qty   LIKE imp_file.imp04,
                    ima02 LIKE ima_file.ima02,
                   ima021 LIKE ima_file.ima021
                    END RECORD
 
   #str FUN-720046 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> MOD-720046 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720046 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### MOD-720046 add ###
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND imouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND imogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND imogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imouser', 'imogrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT  '','', ",
               " imp06,imp03,(imp04-imp08),imp05,imo03,imo04,imo02,imo01,ima25,'',ima02,ima021 ", #FUN-510017 add imo03
               "  FROM imo_file,imp_file,ima_file",
               " WHERE ",tm.wc CLIPPED, " AND imo01=imp01 ",
               " AND imp03 = ima01 AND imp07 NOT IN ('Y','y') ",
               " AND imopost != 'X' " #mandy
   LET l_sql = l_sql CLIPPED," ORDER BY imp06,imp03 "
   PREPARE r531_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   DECLARE r531_curs1 CURSOR FOR r531_prepare1
 
   #  CALL cl_outnam('aimr531') RETURNING l_name
   #  START REPORT r531_rep TO l_name
 
   FOREACH r531_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF sr.imp03 IS NULL THEN LET sr.imp03 = ' ' END IF
      IF sr.imp06 IS NULL THEN LET sr.imp06 = ' ' END IF
      IF tm.s = '1' THEN LET sr.order1 = sr.imp06 USING 'yyyymmdd'
                         LET sr.order2 = sr.imp03
                    ELSE LET sr.order1 = sr.imp03
                         LET sr.order2 = sr.imp06 USING 'yyyymmdd'
      END IF
      CALL s_umfchk(sr.imp03,sr.imp05,sr.ima25) RETURNING l_flag,l_factor
      IF l_factor IS NULL OR l_factor = 0 THEN
         ##Modify:98/11/13----------單位換算率抓不到--------###
          CALL cl_err('','abm-731',1)
          EXIT FOREACH
       #  LET l_factor = 1
      END IF
      LET sr.qty = sr.imp04 * l_factor
 
      #str FUN-720046 add
      EXECUTE insert_prep USING 
              sr.order1,  sr.order2,  sr.imp06, sr.imp03 ,
  	      sr.imp04 , sr.imp05 , sr.imo03 , sr.imo04 ,
   	      sr.imo02 , sr.imo01 , sr.ima25 , sr.qty   ,
	      sr.ima02 , sr.ima021 
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
         EXIT PROGRAM
      END IF
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720046 add
   END FOREACH
 
   #str FUN-720046 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> MOD-720046 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'imp06,imo03,imo04,imo01,imp03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str =g_str,";", tm.s
   CALL cl_prt_cs3('aimr531','aimr531',l_sql,g_str)   #FUN-710080 modify
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720046 add
 
END FUNCTION
 
{
REPORT r531_rep(sr)
   DEFINE l_ima02   LIKE ima_file.ima02  #FUN-510017
   DEFINE l_ima021  LIKE ima_file.ima021 #FUN-510017
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr        RECORD
                    order1  LIKE imp_file.imp03, #No.FUN-690026 VARCHAR(20)
                    order2  LIKE imp_file.imp03, #No.FUN-690026 VARCHAR(20)
                    imp06   LIKE imp_file.imp06,  #預計償還日
                    imp03   LIKE imp_file.imp03,  #料件編號
                    imp04   LIKE imp_file.imp04,  #借料數量
                    imp05   LIKE imp_file.imp05,  #借料單位
                    imo03   LIKE imo_file.imo03,  #廠商 #FUN-510017
                    imo04   LIKE imo_file.imo04,  #廠商簡稱
                    imo02   LIKE imo_file.imo02,  #借料日期
                    imo01   LIKE imo_file.imo01,  #借料單號
                    ima25   LIKE ima_file.ima25,  #料庫存單位
                    qty     LIKE imp_file.imp04
                    END RECORD
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order2
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file
       WHERE ima01 = sr.imp03
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[31],sr.imp06,
            COLUMN g_c[32],sr.imp03,
            COLUMN g_c[33],l_ima02,
            COLUMN g_c[34],l_ima021;
 
   ON EVERY ROW
      PRINT COLUMN g_c[35],cl_numfor(sr.imp04,35,3),
            COLUMN g_c[36],sr.imp05,
            COLUMN g_c[37],sr.imo03,
            COLUMN g_c[38],sr.imo04,
            COLUMN g_c[39],sr.imo02,
            COLUMN g_c[40],sr.imo01
 
   AFTER GROUP OF sr.order2
      PRINT COLUMN g_c[34],g_x[13] clipped,
            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.qty),35,3),
            COLUMN g_c[36],sr.ima25
      PRINT ''
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
#TQC-630166
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash #No.TQC-5C0005
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash #No.TQC-5C0005
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
