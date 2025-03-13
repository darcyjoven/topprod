# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr002.4gl
# Descriptions...: 收貨單號與入庫單號年月不合稽核表
# Input parameter:
# Return code....:
# Date & Author..: 01/03/16 By Wiky
# Modify.........: No.FUN-4C0095 04/12/21 By Mandy 報表轉XML
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No;FUN-750101 07/05/28 By mike  報表格式改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
              wc      STRING,                  #TQC-630166  # Where condition
              yy      LIKE type_file.num5,     #No.FUN-680136 SMALLINT # 收貨年
              mm      LIKE type_file.num5,     #No.FUN-680136 SMALLINT # 收貨月
              more    LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)  #Input more condition(Y/N)
              END RECORD,
       l_cd      LIKE zaa_file.zaa08,          #No.FUN-680136 VARCHAR(40)
       l_i       LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_cnt     LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_cnt1    LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       g_tot_bal LIKE tlf_file.tlf18           #No.FUN-680136 DECIMAL(13,3)
DEFINE g_i       LIKE type_file.num5           #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_str     LIKE type_file.chr1000        #No;FUN-750101 
DEFINE l_table   STRING                        #No;FUN-750101 
DEFINE g_sql     STRING                        #No;FUN-750101 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
##No;FUN-750101 --BEGIN--
   LET g_sql= "rva01.rva_file.rva01,",#收貨單號
              "rva06.rva_file.rva06,",#收貨日期
              "rvb02.rvb_file.rvb02,",#收貨單項次
              "rva10.rva_file.rva10,",#采購類別
              "rva05.rva_file.rva05,",#供應廠商
              "pmc03.pmc_file.pmc03,",#簡稱
              "rvu01.rvu_file.rvu01,",#入庫單號
              "rvu03.rvu_file.rvu03"  #異動日期
   LET l_table=cl_prt_temptable('apmr002',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)  EXIT PROGRAM
   END IF
#No;FUN-750101 --END--
 
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy=ARG_VAL(8)
   LET tm.mm=ARG_VAL(9)
#--------No.TQC-610085 modify
  #LET tm.more = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------No.TQC-610085 end
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL apmr002_tm(0,0)             # Input print condition
      ELSE CALL apmr002()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr002_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 35
 
   OPEN WINDOW apmr002_w AT p_row,p_col WITH FORM "apm/42f/apmr002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rva01
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc = '1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
 
   INPUT BY NAME tm.yy,tm.mm,tm.more
         WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
        IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm
        IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
      AFTER FIELD more
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
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr002'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr002','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr002',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr002()
   ERROR ""
END WHILE
   CLOSE WINDOW apmr002_w
END FUNCTION
 
FUNCTION apmr002()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,        # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE za_file.za05,          #No.FUN-680136 VARCHAR(40)
          sr        RECORD 
                     rva01  LIKE rva_file.rva01,    #收貨單號
                     rva06  LIKE rva_file.rva06,    #收貨日期
                     rvb02  LIKE rvb_file.rvb02,    #項次
                     rva10  LIKE rva_file.rva10,    #採購類別
                     rva05  LIKE rva_file.rva05,    #廠商編號
                     pmc03  LIKE pmc_file.pmc03,    #廠商簡稱
                     rvu01  LIKE rvu_file.rvu01,    #入庫單號
                     rvu03  LIKE rvu_file.rvu03     #入庫日期
                    END RECORD
   
     CALL cl_del_data(l_table)  #No;FUN-750101 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-750101
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
     #End:FUN-980030
 
    LET l_sql="SELECT rva01,rva06,rvb02,rva10,rva05,pmc03,'',''",
                 " FROM rva_file,rvb_file, OUTER pmc_file",
                 " WHERE rva01 = rvb01",
                 "   AND rva_file.rva05 = pmc_file.pmc01",
                 "   AND rvaconf !='X'",
                 "   AND Year(rva06) = '",tm.yy,"'",
                 "   AND Month(rva06) = '",tm.mm,"'",
                 "   AND ",tm.wc CLIPPED
     display l_sql
     LET g_str=''                               #No.FUN-750101 
     PREPARE apmr002_p1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE apmr002_c1 CURSOR FOR apmr002_p1
    # CALL cl_outnam('apmr002') RETURNING l_name #No;FUN-750101
    # START REPORT apmr002_rep TO l_name   #No;FUN-750101
     #LET g_pageno = 0                  #No.FUN-750101 
     
     #LET l_cnt=0                       #No.FUN-750101 
     #LET l_i=0                         #No.FUN-750101
     FOREACH apmr002_c1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF 
          DECLARE apmr002_c2 CURSOR FOR                    #抓入庫單號，入庫日期
            SELECT rvu01,rvu03 FROM rvu_file
             WHERE rvu02=sr.rva01 AND rvu00 = '1' AND rvuconf !='X'
          FOREACH apmr002_c2 INTO sr.rvu01,sr.rvu03
              IF Year(sr.rva06) != Year(sr.rvu03) OR
                 Month(sr.rva06) != Month(sr.rvu03) THEN
                 # OUTPUT TO REPORT apmr002_rep(sr.*)             #No;FUN-750101
                 EXECUTE insert_prep USING
                          sr.rva01,sr.rva06,sr.rvb02,sr.rva10,sr.rva05,
                          sr.pmc03,sr.rvu01,sr.rvu03
              ELSE  
                  CONTINUE FOREACH
              END IF
          END FOREACH
     END FOREACH
#No;FUN-750101--begin--
{
 
     FINISH REPORT apmr002_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
     IF g_zz05='Y' THEN
       CALL cl_wcchp(tm.wc,'rva01,rva04')
            RETURNING tm.wc
       LET g_str=tm.wc
     END IF
     LET g_str=g_str CLIPPED,';',tm.yy,';',tm.mm,';',l_cnt
     CALL cl_prt_cs3('apmr002','apmr002',l_sql,g_str)         #No;FUN-750101
 #No;FUN-750101--end-- 
END FUNCTION
 
#No;FUN-750101 --begin--
{
REPORT apmr002_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          sr        RECORD
                     rva01  LIKE rva_file.rva01,    #收貨單號
                     rva06  LIKE rva_file.rva06,    #收貨日期
                     rvb02  LIKE rvb_file.rvb02,    #項次
                     rva10  LIKE rva_file.rva10,    #採購類別
                     rva05  LIKE rva_file.rva05,    #廠商編號
                     pmc03  LIKE pmc_file.pmc03,    #廠商簡稱
                     rvu01  LIKE rvu_file.rvu01,    #入庫單號
                     rvu03  LIKE rvu_file.rvu03     #入庫日期
                    END RECORD,
      l_n           LIKE ogd_file.ogd15,      #No.FUN-680136 DECIMAL(8,2)
      l_chr         LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
      i             LIKE type_file.num5,      #No.FUN-680136 SMALLINT
      l_k           LIKE type_file.num5,      #No.FUN-680136 SMALLINT
      l_count       LIKE type_file.num5       #No.FUN-680136 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.rva01,sr.rva06,sr.rvb02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET l_cd=g_x[11] CLIPPED,tm.yy,"/" CLIPPED,tm.mm USING '<<<<'
      PRINT l_cd
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.rva01
       LET  l_cnt=l_cnt+1
       PRINT COLUMN g_c[31],sr.rva01 CLIPPED;            #列印單號 #FUN-4C0095
   ON EVERY ROW
       LET l_i=l_i+1
       PRINT  COLUMN g_c[32],sr.rva06 CLIPPED,           #FUN-4C0095
              COLUMN g_c[33],sr.rvb02 USING '###&' CLIPPED, #FUN-590118
              COLUMN g_c[34],sr.rvu01 CLIPPED,
              COLUMN g_c[35],sr.rvu03 CLIPPED,
              COLUMN g_c[36],sr.rva10 CLIPPED,
              COLUMN g_c[37],sr.rva05 CLIPPED,
              COLUMN g_c[38],sr.pmc03 CLIPPED
 
   ON LAST ROW
      PRINT g_dash1 #FUN-4C0095
      PRINT COLUMN g_c[32],g_x[18] CLIPPED, #FUN-4C0095
            COLUMN g_c[33],l_cnt CLIPPED,
            COLUMN g_c[34],g_x[19] CLIPPED,
            COLUMN g_c[35],l_i CLIPPED,
            COLUMN g_c[36],g_x[20] CLIPPED
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'rva01,rva04')
              RETURNING tm.wc
         #   IF tm.wc[001,070] > ' ' THEN            # for 80
         #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #   IF tm.wc[071,140] > ' ' THEN
         #      PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #   IF tm.wc[141,210] > ' ' THEN
         #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #   IF tm.wc[211,280] > ' ' THEN
         #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
 
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash #FUN-4C0095
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED #FUN-4C0095
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED #FUN-4C0095
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No;FUN-750101  --end--
