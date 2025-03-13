# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcr432.4gl
# Descriptions...: 庫存成本期報表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/20 By Nick
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/31 By kim 報表轉XML功能
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-550160 05/06/10 By kim QBE加起迄期間
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/07 By ice 欄位類型修改
# Modify.........: No.FUN-660073 06/09/12 By Nicola 訂單樣品修改
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-740059 07/04/13 By Nicola 樣品金額印錯
# Modify.........: No.FUN-7C0101 08/01/31 By douzh 成本改善功能增加成本計算類型(type)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
              wc       LIKE type_file.chr1000,# Where condition #No.FUN-680122 VARCHAR(300)
              yy,mm    LIKE type_file.num5,   # Where condition #No.FUN-680122 SMALLINT
              yy2,mm2  LIKE type_file.num5,   #MOD-550160 #No.FUN-680122 SMALLINT
              type     LIKE type_file.chr1,   #No.FUN-7C0101
              more     LIKE type_file.chr1    #Input more condition(Y/N) #No.FUN-680122 VARCHAR(1)
           END RECORD,
       g_tot_bal    LIKE ccq_file.ccq03    #User defined variable #No.FUN-680122 DECIMAL(13,2)
DEFINE bdate,b_date LIKE type_file.dat     #MOD-550160  #No.FUN-680122 DATE
DEFINE edate,e_date LIKE type_file.dat     #MOD-550160  #No.FUN-680122 DATE
DEFINE g_chr        LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-680122 SMALLINT
 
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
   LET tm.yy2 = ARG_VAL(10)
   LET tm.mm2 = ARG_VAL(11)
   LET tm.type = ARG_VAL(15)         #No.FUN-7C0101
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL axcr432_tm(0,0)
   ELSE
      CALL axcr432()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr432_tm(p_row,p_col)
   DEFINE lc_qbe_sn    LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,   #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW axcr432_w AT p_row,p_col
     WITH FORM "axc/42f/axcr432" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy  = year(today)  #MOD-550160
   LET tm.mm  = month(today) #MOD-550160
   LET tm.yy2 = year(today)  #MOD-550160
   LET tm.mm2 = month(today) #MOD-550160
   LET tm.type= g_ccz.ccz28  #No.FUN-7C0101
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01, ima08, ima06, ima09, ima10, ima11, ima12
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr432_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
###LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
 
    INPUT BY NAME tm.yy,tm.mm,tm.yy2,tm.mm2,tm.type,tm.more WITHOUT DEFAULTS #MOD-550160   #No.FUN-7C0101
       #MOD-550160................begin
     #AFTER FIELD yy
     #   IF tm.yy IS NULL THEN NEXT FIELD yy END IF
     #AFTER FIELD mm
     #   IF tm.mm IS NULL THEN NEXT FIELD mm END IF
     #   CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
       #MOD-550160................end
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr432_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr432'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr432','9031',1)   
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.mm2 CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",              #No.FUN-7C0101
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr432',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr432_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr432()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr432_w
END FUNCTION
 
FUNCTION axcr432()
   DEFINE l_name     LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680122 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0146
          l_sql      LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680122 VARCHAR(600)
          l_chr      LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
          l_za05     LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(40)
          ccc RECORD LIKE ccc_file.*,
          ima RECORD LIKE ima_file.*
   DEFINE ccctot     LIKE type_file.num20_6  #No.FUN-680122 DEC(20,6)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #MOD-550160................begin
   CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
   LET b_date = bdate
   CALL s_azm(tm.yy2,tm.mm2) RETURNING g_chr,bdate,edate
   LET e_date = edate
   #MOD-550160................end
 
   LET l_sql = "SELECT ccc_file.*, ima_file.*",
               "  FROM ccc_file, ima_file",
               " WHERE ",tm.wc,
               #MOD-550160................begin
              #"   AND ccc02=",tm.yy," AND ccc03=",tm.mm,
              #"   AND ccc01=ima01 "
               "   AND (ccc02*12+ccc03 BETWEEN " ,tm.yy*12+tm.mm,
               "   AND ",tm.yy2*12+tm.mm2 ,") AND ccc01=ima01 " CLIPPED,
               "   AND ccc07='",tm.type,"'"                                  #No.FUN-7C0101
               #MOD-550160................end
 
   PREPARE axcr432_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   DECLARE axcr432_curs1 CURSOR FOR axcr432_prepare1
 
   CALL cl_outnam('axcr432') RETURNING l_name
 
#No.FUN-7C0101--begin
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[47].zaa06 = "Y" 
     ELSE
        LET g_zaa[47].zaa06 = "N"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-7C0101--end
 
   START REPORT axcr432_rep TO l_name
 
   LET g_pageno = 0
 
   FOREACH axcr432_curs1 INTO ccc.*, ima.*
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET ccctot = ccc.ccc92-ccc.ccc72
 
      OUTPUT TO REPORT axcr432_rep(ccc.*, ima.*)
 
   END FOREACH
 
   FINISH REPORT axcr432_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
#No.8741
REPORT axcr432_rep(ccc, ima)
   DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
   DEFINE ccc         RECORD LIKE ccc_file.*
   DEFINE ima         RECORD LIKE ima_file.*
 
  OUTPUT
     TOP MARGIN g_top_margin
     LEFT MARGIN g_left_margin 
     BOTTOM MARGIN g_bottom_margin
     PAGE LENGTH g_page_line
 
  ORDER BY ccc.ccc01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,
                    g_x[9] CLIPPED,tm.yy USING '&&&&',
                    g_x[10] CLIPPED,tm.mm USING '&&',' -- ',
                     g_x[9] CLIPPED,tm.yy2 USING '&&&&', #MOD-550160
                     g_x[10] CLIPPED,tm.mm2 USING '&&'   #MOD-550160
 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[47],    #No.FUN-7C0101
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[46]             #No.FUN-660073
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],ccc.ccc01,
            COLUMN g_c[32],ima.ima02,
            COLUMN g_c[33],ima.ima021,  
            COLUMN g_c[34],ima.ima06,
            COLUMN g_c[35],ima.ima25,
            COLUMN g_c[47],ccc.ccc08,                              #No.FUN-7C0101
            COLUMN g_c[36],cl_numfor(ccc.ccc11,36,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[37],cl_numfor(ccc.ccc21+ccc.ccc27,37,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[38],cl_numfor(ccc.ccc23,38,g_ccz.ccz26),        #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(ccc.ccc31+ccc.ccc25,39,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[40],cl_numfor(ccc.ccc41,40,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[41],cl_numfor(ccc.ccc51,41,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[42],cl_numfor(ccc.ccc61,42,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[46],cl_numfor(ccc.ccc81,46,g_ccz.ccz27),    #No.FUN-660073 #CHI-690007
            COLUMN g_c[43],cl_numfor(ccc.ccc71,43,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[44],cl_numfor(ccc.ccc91,44,g_ccz.ccz27)     #FUN-570190 #CHI-690007
           
      PRINT COLUMN g_c[36],cl_numfor(ccc.ccc12,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(ccc.ccc22+ccc.ccc28,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(ccc.ccc32+ccc.ccc26,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(ccc.ccc42,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(ccc.ccc52,41,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(ccc.ccc62,42,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(ccc.ccc82,46,g_ccz.ccz26),  #No.FUN-660073  #No.FUN-740059 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(ccc.ccc72,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(ccc.ccc92,44,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
   ON LAST ROW
      PRINT g_dash2
      PRINT COLUMN g_c[35],g_x[11] CLIPPED,
            COLUMN g_c[36],cl_numfor(SUM(ccc.ccc11),36,g_ccz.ccz27),    #FUN-570190 #CHI-690007 
            COLUMN g_c[37],cl_numfor(SUM(ccc.ccc21+ccc.ccc27),37,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[39],cl_numfor(SUM(ccc.ccc31+ccc.ccc25),39,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[40],cl_numfor(SUM(ccc.ccc41),40,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[41],cl_numfor(SUM(ccc.ccc51),41,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[42],cl_numfor(SUM(ccc.ccc61),42,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[46],cl_numfor(SUM(ccc.ccc81),46,g_ccz.ccz27),    #No.FUN-660073 #CHI-690007
            COLUMN g_c[43],cl_numfor(SUM(ccc.ccc71),43,g_ccz.ccz27),    #FUN-570190 #CHI-690007
            COLUMN g_c[44],cl_numfor(SUM(ccc.ccc91),44,g_ccz.ccz27)     #FUN-570190
      PRINT COLUMN g_c[35],g_x[12] CLIPPED,
            COLUMN g_c[36],cl_numfor(SUM(ccc.ccc12),36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(SUM(ccc.ccc22+ccc.ccc28),37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(SUM(ccc.ccc32+ccc.ccc26),39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(SUM(ccc.ccc42),40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(SUM(ccc.ccc52),41,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(SUM(ccc.ccc62),42,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(SUM(ccc.ccc82),46,g_ccz.ccz26),    #No.FUN-660073  #No.FUN-740059 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(SUM(ccc.ccc72),43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
            COLUMN g_c[44],cl_numfor(SUM(ccc.ccc92),44,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi05->g_ccz.ccz26
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
