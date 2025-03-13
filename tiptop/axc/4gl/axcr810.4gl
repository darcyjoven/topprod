# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr810.4gl
# Descriptions...: 成本市價低表表
# Date & Author..: 96/01/16 By Alinna
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 05/01/04 By kim 報表轉XML功能
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/10 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-630107 06/03/27 By Claire 加入sum()
# Modify.........: No.TQC-630259 06/03/28 By Claire 總計前加入====
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 07/01/03 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-710058 07/02/06 By jamie 放寬項次位數
# Mofify.........: No.FUN-7C0101 08/01/23 By Zhangyajun 成本改善增加成本計算類型字段(type)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:CHI-9A0023 10/12/10 By Summer 改用s_curr3取匯率
# Modify.........: No:MOD-C30729 12/03/15 By ck2yuan 若未AFTER FIELD mm 不會是畫面上年度期別,改在AFTER INPUT才CALL s_azm
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300)     # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              amt     LIKE ccc_file.ccc23,          #No.FUN-680122 DECIMAL(20,6)
              type    LIKE type_file.chr1,          #No.FUN-7C0101 VARCHAR(1)
              more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)         # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE type_file.num20_6      #No.FUN-680122DECIMAL(20,6)     # User defined variable
   DEFINE bdate   LIKE type_file.dat           #No.FUN-680122DATE  
   DEFINE edate   LIKE type_file.dat           #No.FUN-680122DATE  
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.amt = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET tm.type    = ARG_VAL(14)   #No.FUN-7C0101 add 
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr810_tm(0,0)        # Input print condition
      ELSE CALL axcr810()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr810_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680122 SMALLINT
       l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr810_w AT p_row,p_col
        WITH FORM "axc/42f/axcr810" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)
   LET tm.amt=0       
   LET tm.type=g_ccz.ccz28    #No.FUN-7C0101        
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON ima01, ima06, ima10, ima12,
                              ima08, ima09, ima11 
##
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
 
#No.FUN-570240 --start                                                          
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
###LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
   INPUT BY NAME tm.yy,tm.mm,tm.amt,tm.type,tm.more WITHOUT DEFAULTS #No.FUN-7C0101 add tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      AFTER FIELD amt
         IF cl_null(tm.amt) THEN NEXT FIELD amt END IF
      #No.FUN-7C0101--start--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      #No.FUN-7C0101---end---
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      AFTER INPUT                                               #MOD-C30729 add
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate    #MOD-C30729 add

################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr810','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",                #TQC-610051
                         " '",tm.mm CLIPPED,"'",                #TQC-610051
                         " '",tm.amt CLIPPED,"'",               #TQC-610051
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr810()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr810_w
END FUNCTION
 
FUNCTION axcr810()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          xxx       LIKE type_file.chr3,          #No.FUN-680122CHAR(3)
          u_sign    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE type_file.chr20,          #No.FUN-680122CHAR(10)
          l_dmy1    LIKE smy_file.smydmy1,
          l_pmm04   LIKE pmm_file.pmm04,
          l_pmm22   LIKE pmm_file.pmm22,           #No:CHI-9A0023 add
          l_pmn09   LIKE pmn_file.pmn09,
          l_pmn31   LIKE pmn_file.pmn31,
          sr               RECORD 
                                  ima02 LIKE ima_file.ima02,    # 
                                  ccc01 LIKE ccc_file.ccc01,
                                  ccc91 LIKE ccc_file.ccc91,
                                  ccc92 LIKE ccc_file.ccc92,
                                  ccc23 LIKE ccc_file.ccc23,
                                  pmn01 LIKE pmn_file.pmn01,
                                  pmn02 LIKE pmn_file.pmn02,
                                  pmn31 LIKE pmn_file.pmn31,
                                  azk03 LIKE azk_file.azk03,
                                  amt   LIKE ccc_file.ccc23,        #No.FUN-680122 DECIMAL(20,6)
                                  amt1  LIKE ccc_file.ccc23,        #No.FUN-680122 DECIMAL(20,6)
                                  amt2  LIKE ccc_file.ccc23,        #No.FUN-680122 DECIMAL(20,6)
                                  amt3  LIKE ccc_file.ccc23,        #No.FUN-680122 DECIMAL(20,6)
                                  ccc08 LIKE ccc_file.ccc08         #No.FUN-7C0101 VARCHAR(40)
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ima02,ccc01,ccc91,ccc92,ccc23,ccc08",   #No.FUN-7C0101 add ccc08
                 "  FROM ccc_file, ima_file",
                 " WHERE ",tm.wc,
                 " AND ccc01 = ima01",
                 " AND ccc02 = '",tm.yy,"'",
                 " AND ccc03 = '",tm.mm,"'",
                 " AND ccc07 = '",tm.type,"'"     #No>FUN-7C0101  #No:CHI-9A0023 modify ccc08->ccc07
     PREPARE axcr810_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr810_curs1 CURSOR FOR axcr810_prepare1
 
     CALL cl_outnam('axcr810') RETURNING l_name
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[34].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[34].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
     START REPORT axcr810_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr810_curs1 INTO sr.ima02,sr.ccc01,sr.ccc91,sr.ccc92,sr.ccc23,sr.ccc08   #No.FUN-7C0101 add
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF cl_null(sr.ccc91) THEN LET sr.ccc91=0 END IF
       IF cl_null(sr.ccc92) THEN LET sr.ccc92=0 END IF
###960413 Modify By Jackson
###    IF sr.ccc91 = 0 THEN CONTINUE FOREACH END IF
          INITIALIZE l_pmm04,sr.pmn01,sr.pmn02 TO NULL
          LET sr.pmn31 = 0 LET sr.azk03 = 0
          SELECT MAX(pmm04) INTO l_pmm04 FROM pmm_file,pmn_file
           WHERE pmn04 = sr.ccc01
             AND pmn01 = pmm01
             AND (pmm25='2' OR pmm25='6')
             AND pmm04 <= edate
       IF STATUS = 0 THEN
###960415 Modify By Jackson
          IF sr.ccc92 < tm.amt THEN CONTINUE FOREACH END IF
         #-----------------------No:CHI-9A0023 modify
         #DECLARE  axcr810_za_cur1 CURSOR FOR
         #   SELECT pmn01,pmn02,pmn31,pmn09,azk03 
         #     FROM pmn_file,pmm_file,OUTER azk_file
         #    WHERE pmm04 = l_pmm04
         #      AND pmn01 = pmm01
         #      AND pmn04 = sr.ccc01
         #      AND azk_file.azk01 = pmm_file.pmm22
         #      AND azk02 = '9999/12/31'
         #      AND (pmm25='2' OR pmm25='6')
         #FOREACH axcr810_za_cur1 INTO sr.pmn01,sr.pmn02,l_pmn31,l_pmn09,sr.azk03

          DECLARE  axcr810_za_cur1 CURSOR FOR
             SELECT pmn01,pmn02,pmn31,pmn09,pmm22
               FROM pmn_file,pmm_file
              WHERE pmm04 = l_pmm04
                AND pmn01 = pmm01
                AND pmn04 = sr.ccc01
                AND (pmm25='2' OR pmm25='6')
          FOREACH axcr810_za_cur1 INTO sr.pmn01,sr.pmn02,l_pmn31,l_pmn09,l_pmm22
         #-----------------------No:CHI-9A0023 end
             IF STATUS = 0 THEN
                CALL s_curr3(l_pmm22,edate,g_sma.sma904) RETURNING sr.azk03   #No:CHI-9A0023 add
                IF cl_null(l_pmn09) THEN LET l_pmn09 = 1 END IF
                LET sr.pmn31 = l_pmn31 /l_pmn09                #No.2810
                IF sr.pmn31 * sr.azk03 <> 0 THEN
                   EXIT FOREACH
                ELSE
                   CONTINUE FOREACH
                END IF
             END IF
          END FOREACH
       END IF
###960413 Modify By Jackson
###      IF sr.pmn31 * sr.azk03 = 0 THEN CONTINUE FOREACH END IF
         LET sr.amt = sr.ccc91 * sr.ccc23
         LET sr.amt1 = sr.pmn31 * sr.azk03
         LET sr.amt2 = sr.ccc91 * sr.amt1
         LEt sr.amt3 = sr.amt2 - sr.amt
       OUTPUT TO REPORT axcr810_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr810_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr810_rep(sr)
 #  DEFINE qty LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
   DEFINE qty LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
          u_p LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6)
          amt LIKE ccc_file.ccc23            #No.FUN-680122 DECIMAL(20,6)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
   l_ima021   LIKE ima_file.ima021,   #FUN-4C0099
       sr               RECORD 
                                  ima02 LIKE ima_file.ima02,    # 
                                  ccc01 LIKE ccc_file.ccc01,
                                  ccc91 LIKE ccc_file.ccc91,
                                  ccc92 LIKE ccc_file.ccc92,
                                  ccc23 LIKE ccc_file.ccc23,
                                  pmn01 LIKE pmn_file.pmn01,
                                  pmn02 LIKE pmn_file.pmn02,
                                  pmn31 LIKE pmn_file.pmn31,
                                  azk03 LIKE azk_file.azk03,
                                  amt   LIKE ccc_file.ccc23,         #No.FUN-680122 DECIMAL(20,6)
                                  amt1  LIKE ccc_file.ccc23,         #No.FUN-680122 DECIMAL(20,6)
                                  amt2  LIKE ccc_file.ccc23,         #No.FUN-680122 DECIMAL(20,6)
                                  amt3  LIKE ccc_file.ccc23,         #No.FUN-680122 DECIMAL(20,6)
                                  ccc08 LIKE ccc_file.ccc08          #No.FUN-7C0101 VARCHAR(40)
                        END RECORD,
     # l_qty        LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
      l_qty        LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
      l_amt        LIKE ccc_file.ccc23,        #No.FUN-680122 DECIMAL(20,6)
      l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ccc01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[12] CLIPPED,tm.yy USING '&&&&' CLIPPED,
            g_x[13] CLIPPED,tm.mm USING '&&' CLIPPED
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]         #No.FUN-7C0101 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ccc01
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.ccc01
      IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF
      PRINT COLUMN g_c[31],sr.ccc01 CLIPPED,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],sr.ccc08;            #No.FUN-7C0101 add
   ON EVERY ROW
   #No.FUN-7C0101-modify-start-
      PRINT COLUMN g_c[35],cl_numfor(sr.ccc91,34,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[36],cl_numfor(sr.ccc23,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(sr.amt,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(sr.amt1,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(sr.amt2,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(sr.amt3,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #COLUMN g_c[40],sr.pmn01,'-',sr.pmn02 USING '###'   #FUN-710058 mod
            COLUMN g_c[41],sr.pmn01,'-',sr.pmn02 USING '&&&&&' #FUN-710058 mod
   #No.FUN-7C0101-modify-end-
   ON LAST ROW
      PRINT
      PRINT g_dash     #TQC-630259
      PRINT COLUMN g_c[33],g_x[14] CLIPPED,
            COLUMN g_c[34],cl_numfor(SUM(sr.ccc91),34,g_ccz.ccz27), #CHI-690007 0->ccz27
           #MOD-630107-begin-add-sum()
            COLUMN g_c[36],cl_numfor(SUM(sr.ccc92),36,g_ccz.ccz26),  #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(SUM(sr.amt2),38,g_ccz.ccz26),   #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(SUM(sr.amt3),39,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
           #MOD-630107-end-add-sum()
      LET l_last_sw = 'y'
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
#No.8741(END)
END REPORT 
