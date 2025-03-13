# Prog. Version..: '5.30.06-13.03.27(00008)'     #
#
# Version........: '6.00.03-02.11.25'     #
# Pattern name...: anmr820.4gl
# Descriptions...: 定期存款應收利息明細表
# Date & Author..: 98/12/04 By ANN CHEN
# Modify.........: No.7354 03/10/28 By Kitty gxf06的欄位加長,位置調整
# Modify.........: No.FUN-4C0098 05/01/05 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.MOD-780065 07/08/09 By Smapmin 修改利息計算公式
# Modify.........: NO.FUN-7B0026 07/11/12 By Zhaijie 報表輸出改為Crystal Report
# Modify.........: No.MOD-820112 08/02/26 By Smapmin 天數計算有誤
# Modify.........: No.MOD-870291 08/07/29 By Sarah 延續MOD-820112修改部份,不應用gxf22來判斷，應更正以gxf23來判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No:MOD-D30022 13/03/06 By Polly 應息始日錯誤時，則依截止日期取得當月最後一天當應息始日
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			        # Print condition RECORD
                 wc    LIKE type_file.chr1000,  #FUN-680107 VARCHAR(600) #Where Condiction
                 bdate LIKE type_file.dat,      #FUN-680107 DATE      # 截止日期
                 more  LIKE type_file.chr1      #FUN-680107 VARCHAR(1)   #
              END RECORD,
          g_buf      LIKE type_file.chr1000,    #FUN-680107 VARCHAR(30)
          l_name     LIKE type_file.chr20       #FUN-680107 VARCHAR(10)             #使用者名稱
DEFINE   g_i         LIKE type_file.num5        #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_head1     STRING
DEFINE   l_table     STRING                     #NO.FUN-7B0026
DEFINE   g_str       STRING                     #NO.FUN-7B0026
DEFINE   g_sql       STRING                     #NO.FUN-7B0026
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
#NO.FUN-7B0026----------start-------
 
   LET g_sql = "gxf03.gxf_file.gxf03,",
               "gxf05.gxf_file.gxf05,",
               "gxf02.gxf_file.gxf02,",
               "gxf011.gxf_file.gxf011,", 
               "gxf01.gxf_file.gxf01,",
               "gxf09.gxf_file.gxf09,",
               "gxf08.gxf_file.gxf08,",
               "gxf021.gxf_file.gxf021,",
               "gxf06.gxf_file.gxf06,",
               "gxf10.gxf_file.gxf10,",
               "gxf11.gxf_file.gxf11,",
               "gxf04.gxf_file.gxf04,",
               "gxf22.gxf_file.gxf22,",
               "gxf24.gxf_file.gxf24,",
               "cdate.type_file.dat,",
               "A11.type_file.num5,",
               "A12.gxf_file.gxf021,",
               "A13.gxf_file.gxf021,",
               "l_nma02.nma_file.nma02,",
               "azi04.azi_file.azi04"
   LET l_table=cl_prt_temptable('anmr820',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql =" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7B0026--------end-----
 # SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aza.aza17
   SELECT zx02  INTO l_name  FROM zx_file  WHERE g_user=zx01
   INITIALIZE tm.* to NULL
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.bdate= ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr820_tm()	        	# Input print condition
      ELSE CALL anmr820()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr820_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(400)
          l_jmp_flag    LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 16
   END IF
   OPEN WINDOW anmr820_w AT p_row,p_col
        WITH FORM "anm/42f/anmr820"
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
   LET tm.bdate = g_today
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON gxf02,gxf03
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr820_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr820_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr820'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr820','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr820',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr820_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr820()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr820_w
END FUNCTION
 
FUNCTION anmr820()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,         #標題內容        #No.FUN-680107 VARCHAR(40)
          sr            RECORD
                        gxf03   LIKE gxf_file.gxf03,  #原存日期
                        gxf05   LIKE gxf_file.gxf05,  #到期日
                        gxf02   LIKE gxf_file.gxf02,  #原存銀行
                        gxf011  LIKE gxf_file.gxf011, #申請號碼
                        gxf01   LIKE gxf_file.gxf01,  #存單號碼
                        gxf09   LIKE gxf_file.gxf09,  #實押金額
                        gxf08   LIKE gxf_file.gxf08,  #實押銀行
                        gxf021  LIKE gxf_file.gxf021, #定存金額
                        gxf06   LIKE gxf_file.gxf06,  #利率
                        gxf10   LIKE gxf_file.gxf10,  #實壓性質
                        gxf11   LIKE gxf_file.gxf11,  #存單狀態
                        gxf04   LIKE gxf_file.gxf04,  #計息方式
                        gxf22   LIKE gxf_file.gxf22,  #解除日期
                        gxf23   LIKE gxf_file.gxf23,  #解除日期   #MOD-870291 add
                        gxf24   LIKE gxf_file.gxf24,  #幣別
                        cdate   LIKE type_file.dat,        #FUN-680107 DATE                #應息始日
                        A11     LIKE type_file.num5,       #FUN-680107 SMALLINT            #應息日數
                        A12     LIKE gxf_file.gxf021,             #應收利息收入
                        A13     LIKE gxf_file.gxf021              #每月利昔收入
                        END RECORD
   DEFINE l_nma02       LIKE nma_file.nma02               #FUN-7B0026
   DEFINE l_bdate       LIKE type_file.dat                #MOD-820112
 
     CALL cl_del_data(l_table)                            #FUN-7B0026
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 ='anmr820'  #FUN-7B0026
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND gxfuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND gxfgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND gxfgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gxfuser', 'gxfgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT gxf03,gxf05,gxf02,gxf011,gxf01,gxf09,gxf08,",
                 "       gxf021,gxf06,gxf10,gxf11,gxf04,gxf22,gxf23,gxf24,'','',0,0 ",    #MOD-870291 add gxf23
                 "  FROM gxf_file",
               # " WHERE gxf11 <> '3'",
                 " WHERE ",tm.wc CLIPPED
 
     PREPARE anmr820_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM 
     END IF
     DECLARE anmr820_curs1 CURSOR FOR anmr820_prepare1
 
#     CALL cl_outnam('anmr820') RETURNING l_name       #FUN-7B0026
#     START REPORT anmr820_rep TO l_name               #FUN-7B0026
 
#     LET g_pageno = 0                                 #FUN-7B0026
 
     FOREACH anmr820_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       IF cl_null(sr.gxf021) THEN
          LET sr.gxf021=0
       END IF
 
       #-----modify in 99/07/31 -------
       LET l_bdate = tm.bdate   #MOD-820112
       IF NOT cl_null(sr.gxf23) THEN   #MOD-870291 mod gxf22->gxf23
          IF sr.gxf23 < tm.bdate THEN  #MOD-870291 mod gxf22->gxf23
             IF sr.gxf11='3' THEN
                CONTINUE FOREACH
             ELSE
               #LET tm.bdate= sr.gxf22   #MOD-820112    
                LET l_bdate = sr.gxf23   #MOD-820112  #MOD-870291 mod gxf22->gxf23
             END IF
          END IF
       END IF
       #-------------------------------
       #no.5884 定存到期
       IF NOT cl_null(sr.gxf05) THEN
          IF sr.gxf05 < tm.bdate THEN
             IF sr.gxf11='4' THEN CONTINUE FOREACH END IF
          END IF
       END IF
       #no.5884(end)
 
      #LET sr.A11 = tm.bdate - sr.gxf04
      #計息方式為1.月付->應息始日=取截止日期的年度月份+原存日期(gxf03)的日
       IF  sr.gxf04='1' THEN
        #LET sr.cdate=MDY(MONTH(tm.bdate),DAY(sr.gxf03),YEAR(tm.bdate))     #MOD-820112
         LET sr.cdate=MDY(MONTH(l_bdate),DAY(sr.gxf03),YEAR(l_bdate))     #MOD-820112
        #-------------MOD-D30022-------------(S)
         IF cl_null(sr.cdate) THEN
            LET sr.cdate = s_last(l_bdate)   #取出當月最後一天
         END IF
        #-------------MOD-D30022-------------(E)
         LET sr.A11=tm.bdate-sr.cdate+1
       END IF
      #計息方式為2.到期整付->應息始日=取原存日期(gxf03)
       IF  sr.gxf04='2' THEN
           LET sr.cdate=sr.gxf03
           LET sr.A11=tm.bdate-sr.cdate+1
       END IF
       #-----MOD-780065---------
       #LET sr.A12 = (sr.gxf021*sr.gxf06/100)/365*sr.A11
      #IF sr.gxf24 <> g_aza.aza17 THEN                             #CHI-A10014 mark
       IF g_aza.aza26 <> '0' OR sr.gxf24 <> g_aza.aza17 THEN       #CHI-A10014 add
          LET sr.A12 = (sr.gxf021*sr.gxf06/100)/360*sr.A11
       ELSE
          LET sr.A12 = (sr.gxf021*sr.gxf06/100)/365*sr.A11
       END IF
       #-----END MOD-780065-----
       LET sr.A13 = (sr.gxf021*sr.gxf06/100)/12
#FUN-7C0026--------start------
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.gxf24
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.gxf02
 
      EXECUTE insert_prep USING 
         sr.gxf03,sr.gxf05,sr.gxf02,sr.gxf011,sr.gxf01,sr.gxf09,sr.gxf08,
         sr.gxf021,sr.gxf06,sr.gxf10,sr.gxf11,sr.gxf04,sr.gxf22,sr.gxf24,
         sr.cdate,sr.A11,sr.A12,sr.A13,l_nma02,t_azi04
#FUN-7B0026---------end----
#       OUTPUT TO REPORT anmr820_rep(sr.*)                 #FUN-7B0026
     END FOREACH
 
#     FINISH REPORT anmr820_rep                            #FUN-7B0026
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #FUN-7B0026
#NO.FUN-7B0026---------start----------
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'gxf02,gxf03')
          RETURNING tm.wc
     END IF
     LET g_str=tm.wc,";",tm.bdate
     CALL  cl_prt_cs3('anmr820','anmr820',g_sql,g_str)
#NO.FUN-7B0026-------end-------
END FUNCTION
#NO.FUN-7B0026------------start --------mark---
{REPORT anmr820_rep(sr)
   DEFINE l_last_sw	    LIKE type_file.chr1,       #FUN-680107 VARCHAR(1)
          l_nma02       LIKE nma_file.nma02,   #銀行簡稱
          sr            RECORD
                        gxf03   LIKE gxf_file.gxf03,  #原存日期
                        gxf05   LIKE gxf_file.gxf05,  #到期日
                        gxf02   LIKE gxf_file.gxf02,  #原存銀行
                        gxf011  LIKE gxf_file.gxf011, #申請號碼
                        gxf01   LIKE gxf_file.gxf01,  #存單號碼
                        gxf09   LIKE gxf_file.gxf09,  #實押金額
                        gxf08   LIKE gxf_file.gxf08,  #實押銀行
                        gxf021  LIKE gxf_file.gxf021, #原存銀行
                        gxf06   LIKE gxf_file.gxf06,  #利率
                        gxf10   LIKE gxf_file.gxf10,  #實壓性質
                        gxf11   LIKE gxf_file.gxf11,  #存單狀態
                        gxf04   LIKE gxf_file.gxf04,  #應息始日
                        gxf22   LIKE gxf_file.gxf22,  #解除日期
                        gxf23   LIKE gxf_file.gxf23,  #解除日期   #MOD-870291 add
                        gxf24   LIKE gxf_file.gxf24,  #幣別
                        cdate   LIKE type_file.dat,        #FUN-680107 DATE
                        A11     LIKE type_file.num5,       #FUN-680107 SMALLINT             #應息日數
                        A12     LIKE gxf_file.gxf021,             #應收利息收入
                        A13     LIKE gxf_file.gxf021              #每月利昔收入
                        END RECORD
  OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.gxf03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[15] CLIPPED, tm.bdate
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
            g_x[43] CLIPPED,g_x[44] CLIPPED,g_x[45] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
 
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
        FROM azi_file
       WHERE azi01=sr.gxf24
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.gxf02
 
      PRINT COLUMN g_c[31],sr.gxf03,
            COLUMN g_c[32],sr.cdate,
            COLUMN g_c[33],sr.gxf05,
            COLUMN g_c[34],sr.gxf02 CLIPPED,
            COLUMN g_c[35],l_nma02,
            COLUMN g_c[36],sr.gxf011 CLIPPED,
            COLUMN g_c[37],sr.gxf01 CLIPPED;
      IF sr.gxf11 = '1' THEN
         PRINT COLUMN g_c[38],cl_numfor(sr.gxf09,38,t_azi04); #NO.CHI-6A0004
      END IF
      PRINT COLUMN g_c[39],sr.gxf08;
      IF sr.gxf11 <> '1' THEN
         PRINT COLUMN g_c[40],cl_numfor(sr.gxf021,40,t_azi04);#NO.CHI-6A0004
      END IF
#No.TQC-6A0110 -- begin --
#      PRINT COLUMN g_c[41],sr.gxf06 USING '#&.####',           #No:7354
#            COLUMN g_c[42],sr.A11 USING '###&',
      PRINT COLUMN g_c[41],sr.gxf06 USING '##&.####',
            COLUMN g_c[42],sr.A11 USING '#######&',
#No.TQC-6A0110 -- end --
            COLUMN g_c[43],cl_numfor(sr.A12,43,t_azi04),  #NO.CHI-6A0004
            COLUMN g_c[44],cl_numfor(sr.A13,44,t_azi04),  #NO.CHI-6A0004
            COLUMN g_c[45],sr.gxf10[1,16]
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
   #  PRINT COLUMN 1,  g_x[27] CLIPPED,
   #        COLUMN 41, g_x[28] CLIPPED,
   #        COLUMN 78, g_x[29] CLIPPED,
   #        COLUMN 111,g_x[30] CLIPPED,
   #        COLUMN 118,l_name CLIPPED            #使用者名稱
END REPORT}
#NO.FUN-7B0026------------end-----
