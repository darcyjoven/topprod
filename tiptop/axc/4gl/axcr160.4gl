# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcr160.4gl
# Descriptions...: BOM 產品成本表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/24 By Roger
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/28 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-7C0101 08/01/31 By Zhangyajun 成本改善增加成本計算類型(type)
# Modify.........: No.FUN-880126 08/09/01 By Smapmin 增加特性代碼欄位
# Modify.........: No.MOD-950037 09/05/06 By lutingting 當tm.b ='2'時會有問題,因為g_sql漏掉ccc_file 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0187 09/11/02 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,          #No.FUN-7C0101CHAR(1)
              b       LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_effective LIKE type_file.dat,           #No.FUN-680122DATE
          g_tot_bal LIKE type_file.num20_6          #No.FUN-680122 DECIMAL(20,6)    # User defined variable
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
   LET g_effective = ARG_VAL(8)
   LET tm.yy = ARG_VAL(9)
   LET tm.mm = ARG_VAL(10)
   LET tm.b = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type = ARG_VAL(15)    #No.FUN-7C0101 add
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr160_tm(0,0)        # Input print condition
      ELSE CALL axcr160()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr160_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr160_w AT p_row,p_col
        WITH FORM "axc/42f/axcr160" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')   #FUN-880126
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = '1'
   LET tm.more = 'N'
   LET g_effective=g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type = g_ccz.ccz28     #No.FUN-7C0101
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON bmb01    #FUN-880126
   CONSTRUCT BY NAME tm.wc ON bmb01,bmb29    #FUN-880126
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
     ON ACTION CONTROLP                                                      
        IF INFIELD(bmb01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima5"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO bmb01                             
           NEXT FIELD bmb01                                                 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr160_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME g_effective,tm.yy,tm.mm,tm.type,tm.b,tm.more WITHOUT DEFAULTS  #No.FUN-7C0101 add tm.type 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      #NO.FUN-7C0101--start--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      #No.FUN-7C0101---end--- 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN NEXT FIELD b END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr160_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr160'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr160','9031',1)   
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
                         #TQC-610051-begin
                         " '",g_effective CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type,"'",        #No.FUN-7C0101
                         " '",tm.b CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr160',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr160_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr160()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr160_w
END FUNCTION
 
FUNCTION axcr160()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr     LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          sr        RECORD bmb01 LIKE bmb_file.bmb01,
                           bmb03 LIKE bmb_file.bmb03,
                           bmb29 LIKE bmb_file.bmb29,   #FUN-880126
                           ima02 LIKE ima_file.ima02,
                           ima25 LIKE ima_file.ima25,
                          # qty   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
                           qty   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
                           ccc08 LIKE ccc_file.ccc08,           #No.FUN-7C0101CHAR(40)
                           ucost LIKE oeb_file.oeb13            #No.FUN-680122DEC(20,6)
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
##No.3079 modify 1999/04/08
     IF tm.b = '1' THEN    #實際成本
        #LET l_sql = "SELECT bmb01,bmb03,ima02,ima25,bmb06/bmb07,ccc08,ccc23",  #No.FUN-7C0101 add ccc08   #FUN-880126
        LET l_sql = "SELECT bmb01,bmb03,bmb29,ima02,ima25,bmb06/bmb07,ccc08,ccc23",  #No.FUN-7C0101 add ccc08   #FUN-880126
"  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 ",
"                LEFT OUTER JOIN ccc_file ON bmb03 = ccc01 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07 = '",tm.type,"'",
                    " WHERE ",tm.wc CLIPPED
                    #"   AND bmb03 = ima_file.ima01",
                    #"   AND bmb03 = ccc_file.ccc01 AND ccc_file.ccc02=",tm.yy," AND ccc_file.ccc03=",tm.mm
                   #,"   AND ccc07 = '",tm.type,"'"   #No.FUN-7C0101
     ELSE
        #LET l_sql = "SELECT bmb01,bmb03,ima02,ima25,bmb06/bmb07,ccc08,ccs03",   #No.FUN-7C0101 add ccc08   #FUN-880126
        LET l_sql = "SELECT bmb01,bmb03,bmb29,ima02,ima25,bmb06/bmb07,'',ccs03",   #No.FUN-7C0101 add ccc08   #FUN-880126    #No.MOD-950037 ccc08-->'' 
                    "  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 ",
#                   "                LEFT OUTER JOIN ccs_file LEFT OUTER JOIN ccp_file ON ccs02 = ccp03 AND ccp01=",tm.yy," AND ccp02=",tm.mm," ON bmb03=ccs01 ",  #TQC-9A0187 Mark
                    "                LEFT OUTER JOIN (ccs_file LEFT OUTER JOIN ccp_file ON ccs02 = ccp03 AND ccp01=",tm.yy," AND ccp02=",tm.mm,") ON bmb03=ccs01 ",  #TQC-9A0187 Add
                    " WHERE ",tm.wc CLIPPED
                    #"   AND bmb03 = ima_file.ima01",
                    #"   AND ccp_file.ccp01=",tm.yy," AND ccp_file.ccp02=",tm.mm
                   #,"   AND ccc07 = '" ,tm.type,"'"    #No.FUN-7C0101   #No.MOD-950037 mark 
     END IF
##-----------------------------
     IF g_effective IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED,
         " AND (bmb04 <='",g_effective,"' OR bmb04 IS NULL)",
         " AND (bmb05 > '",g_effective,"' OR bmb05 IS NULL)"
     END IF
     PREPARE axcr160_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr160_curs1 CURSOR FOR axcr160_prepare1
 
     CALL cl_outnam('axcr160') RETURNING l_name
 
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[35].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[35].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
     START REPORT axcr160_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr160_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.ucost IS NULL THEN LET sr.ucost=0 END IF
       OUTPUT TO REPORT axcr160_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axcr160_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
#No.8741
REPORT axcr160_rep(sr)
   DEFINE l_ima02	LIKE ima_file.ima01         #No.FUN-680122CHAR(30)
   DEFINE l_ima021	LIKE ima_file.ima021        #No.FUN-680122CHAR(30)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680122CHAR(1)
       sr        RECORD bmb01 LIKE bmb_file.bmb01,
                           bmb03 LIKE bmb_file.bmb03,
                           bmb29 LIKE bmb_file.bmb29,   #FUN-880126
                           ima02 LIKE ima_file.ima02,
                           ima25 LIKE ima_file.ima25,
                         #  qty   LIKE ima_file.ima26,           #No.FUN-680122DEC(15,3)#FUN-A20044
                           qty   LIKE type_file.num15_3,           #No.FUN-680122DEC(15,3)#FUN-A20044
                           ccc08 LIKE ccc_file.ccc08,           #No.FUN-7C0101 VARCHAR(40)
                           ucost LIKE oeb_file.oeb13            #No.FUN-680122 DEC(20,6)
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  #ORDER BY sr.bmb01, sr.bmb03   #FUN-880126
  ORDER BY sr.bmb01, sr.bmb29, sr.bmb03    #FUN-880126
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&',
            g_x[10] CLIPPED,tm.mm USING '&&'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]        #No.FUN-7C0101 add g_x[38]
 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   #BEFORE GROUP OF sr.bmb01  #FUN-880126
   BEFORE GROUP OF sr.bmb29  #FUN-880126
      SKIP TO TOP OF PAGE
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
          WHERE ima01=sr.bmb01
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF
      PRINT
      PRINT COLUMN g_c[31],g_x[14] CLIPPED,
            COLUMN g_c[32],sr.bmb01,' ',l_ima02
      #-----FUN-880126---------
      IF g_sma.sma118 = 'Y' THEN 
         PRINT COLUMN g_c[31],g_x[15] CLIPPED,
               COLUMN g_c[32],sr.bmb29    
      ELSE
         PRINT
      END IF
      #-----END FUN-880126-----
      PRINT
 
   ON EVERY ROW
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.bmb03
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[31],sr.bmb03,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],sr.ima25,
            COLUMN g_c[35],sr.ccc08 CLIPPED,    #No.FUN-7C0101 add
            COLUMN g_c[36],cl_numfor(sr.ucost,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(sr.qty,37,3),
            COLUMN g_c[38],cl_numfor(sr.ucost*sr.qty,38,g_ccz.ccz26) #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
 
   #AFTER GROUP OF sr.bmb01   #FUN-880126
   AFTER GROUP OF sr.bmb29   #FUN-880126
      PRINT
      PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]]
 
      PRINT COLUMN g_c[36],g_x[14] CLIPPED,
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.ucost*sr.qty),38,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
