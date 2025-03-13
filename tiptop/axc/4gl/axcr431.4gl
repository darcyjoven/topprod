# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcr431.4gl
# Descriptions...: 庫存成本進出存期報表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/20 By Nick
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 05/01/26 By kim 報表轉XML功能
# Modify.........: No.MOD-550125 05/06/16 By kim QBE加起迄期間
# Modify.........: No.MOD-550159 05/06/16 By kim 列印 "本月結存調整金額(ccc93)"
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/05 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/07 By ice 欄位類型修改
# Modify.........: No.FUN-660073 06/09/12 By Nicola 訂單樣品修改
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-7C0101 08/01/31 By douzh 成本改善功能增加成本計算類型(type)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
              wc       LIKE type_file.chr1000,# Where condition #No.FUN-680122 VARCHAR(300)
              yy,mm    LIKE type_file.num5,   # Where condition #No.FUN-680122 SMALLINT
              yy2,mm2  LIKE type_file.num5,   #MOD-550125 #No.FUN-680122 SMALLINT
              type     LIKE type_file.chr1,   #No.FUN-7C0101
              azh01    LIKE azh_file.azh01,   #No.FUN-680122 VARCHAR(10)
              azh02    LIKE azh_file.azh02,   #No.FUN-680122 VARCHAR(40)
              n        LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(1)
              more     LIKE type_file.chr1    #Input more condition(Y/N) #No.FUN-680122 VARCHAR(1)
           END RECORD,
       g_tot_bal    LIKE ccq_file.ccq03    #User defined variable #No.FUN-680122 DECIMAL(13,2)
DEFINE bdate,b_date LIKE type_file.dat     #No.FUN-680122 DATE
DEFINE edate,e_date LIKE type_file.dat     #No.FUN-680122 DATE
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
   LET tm.type = ARG_VAL(18)       #No.FUN-7C0101
   LET tm.azh02 = ARG_VAL(12)
   LET tm.azh01 = ARG_VAL(13)
   LET tm.n = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL axcr431_tm(0,0)
   ELSE
      CALL axcr431()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr431_tm(p_row,p_col)
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col LIKE type_file.num5,   #No.FUN-680122 SMALLINT
       l_cmd       LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW axcr431_w AT p_row,p_col
     WITH FORM "axc/42f/axcr431" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
    #MOD-550125................begin
   LET tm.yy   =  year( today)
   LET tm.mm   = month( today)
   LET tm.yy2  =  year( today)
   LET tm.mm2  = month( today)
    #MOD-550125................end
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima57,ima08,ima06,ima09,ima10,ima11,ima12
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr431_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
    INPUT BY NAME tm.yy,tm.mm,tm.yy2,tm.mm2,tm.type,tm.azh02,tm.azh01,tm.n,tm.more WITHOUT DEFAULTS #MOD-550125 #No.FUN-7C0101
 
       #MOD-550125................begin
     #AFTER FIELD yy
     #   IF tm.yy IS NULL THEN NEXT FIELD yy END IF
     #AFTER FIELD mm
     #   IF tm.mm IS NULL THEN NEXT FIELD mm END IF
     #   CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
       #MOD-550125................end
      AFTER FIELD azh01
         SELECT azh02 INTO tm.azh02 FROM azh_file WHERE azh01=tm.azh01
         DISPLAY BY NAME tm.azh02
       AFTER FIELD type                                                            #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF              #No.FUN-7C0101
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLP CASE WHEN INFIELD(azh01)
#                            CALL q_azh(4,4,tm.azh01,tm.azh02)
#                                 RETURNING tm.azh01,tm.azh02
#                            CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#                            CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azh'
    LET g_qryparam.default1 = tm.azh01
    LET g_qryparam.default2 = tm.azh02
    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
                             DISPLAY BY NAME tm.azh01,tm.azh02
                        END CASE
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr431_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr431'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr431','9031',1)   
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
                         " '",tm.azh02 CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.n CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr431',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr431_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr431()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr431_w
END FUNCTION
 
FUNCTION axcr431()
   DEFINE l_name  LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680122 VARCHAR(20)
#       l_time          LIKE type_file.chr8      #No.FUN-6A0146
          l_sql   LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680122 VARCHAR(600)
          l_chr   LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1)
          l_za05  LIKE type_file.chr1000, #No.FUN-680122 VARCHAR(40)
          ccc	RECORD LIKE ccc_file.*,
          ima	RECORD LIKE ima_file.*
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
      #MOD-550125................begin
     CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
     LET b_date = bdate
     CALL s_azm(tm.yy2,tm.mm2) RETURNING g_chr,bdate,edate
     LET e_date = edate
      #MOD-550125................end
 
     LET l_sql = "SELECT ccc_file.*, ima_file.*",
                 "  FROM ccc_file, ima_file",
                 " WHERE ",tm.wc,
      #MOD-550125................begin
                #" AND ccc02=",tm.yy," AND ccc03=",tm.mm,
                #" AND ccc01=ima01 "
                 " AND (ccc02*12+ccc03 BETWEEN " ,tm.yy*12+tm.mm,
                 " AND ",tm.yy2*12+tm.mm2 ,") AND ccc01=ima01 " CLIPPED,
                 " AND ccc07='",tm.type,"'"                                  #No.FUN-7C0101
      #MOD-550125................end
     PREPARE axcr431_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr431_curs1 CURSOR FOR axcr431_prepare1
 
     CALL cl_outnam('axcr431') RETURNING l_name
     #TQC-6A0078...............begin                                                                                                
     IF NOT cl_null(tm.azh02) THEN                                                                                                  
        LET g_x[1]=tm.azh02 CLIPPED                                                                                                 
     END IF                                                                                                                         
     #TQC-6A0078...............end
     START REPORT axcr431_rep TO l_name
     LET g_pageno = 0
     FOREACH axcr431_curs1 INTO ccc.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       OUTPUT TO REPORT axcr431_rep(ccc.*, ima.*)
     END FOREACH
 
     FINISH REPORT axcr431_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#No.8741
REPORT axcr431_rep(ccc, ima)
   DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
   DEFINE ccc	      RECORD LIKE ccc_file.*
   DEFINE ima	      RECORD LIKE ima_file.*
   DEFINE l_str       STRING #CHI-690007
 
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
      PRINT g_x[9] CLIPPED,tm.yy USING '&&&&',
            g_x[10] CLIPPED,tm.mm USING '&&',
            g_x[9] CLIPPED,tm.yy2 USING '&&&&', #MOD-550125
            g_x[10] CLIPPED,tm.mm2 USING '&&'   #MOD-550125
 
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
 
#     PRINT COLUMN r410_getStartPos(33,33,g_x[11]),g_x[11],
#           COLUMN r410_getStartPos(34,34,g_x[12]),g_x[12],
#           COLUMN r410_getStartPos(35,35,g_x[13]),g_x[13],
#           COLUMN r410_getStartPos(36,36,g_x[14]),g_x[14],
#           COLUMN r410_getStartPos(37,37,g_x[15]),g_x[15],
#           COLUMN r410_getStartPos(38,38,g_x[16]),g_x[16],
#           COLUMN r410_getStartPos(39,39,g_x[17]),g_x[17],
#           COLUMN r410_getStartPos(40,40,g_x[18]),g_x[18],
#           COLUMN r410_getStartPos(41,41,g_x[19]),g_x[19],
#           COLUMN r410_getStartPos(42,42,g_x[20]),g_x[20],
#           COLUMN r410_getStartPos(43,43,g_x[21]),g_x[21]
      PRINT COLUMN  48,g_x[11],
            COLUMN  67,g_x[12],
            COLUMN  86,g_x[13],
            COLUMN 105,g_x[14],
            COLUMN 124,g_x[15],
            COLUMN 143,g_x[16],
            COLUMN 162,g_x[17],
            COLUMN 181,g_x[18],
            COLUMN 200,g_x[19],
            COLUMN 219,g_x[45],  #No.FUN-660073
            COLUMN 238,g_x[20],
            COLUMN 257,g_x[21]
      PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
            COLUMN g_c[34],g_dash2[1,g_w[34]],
            COLUMN g_c[35],g_dash2[1,g_w[35]],
            COLUMN g_c[36],g_dash2[1,g_w[36]],
            COLUMN g_c[37],g_dash2[1,g_w[37]],
            COLUMN g_c[38],g_dash2[1,g_w[38]],
            COLUMN g_c[39],g_dash2[1,g_w[39]],
            COLUMN g_c[40],g_dash2[1,g_w[40]],
            COLUMN g_c[41],g_dash2[1,g_w[41]],
            COLUMN g_c[46],g_dash2[1,g_w[46]],  #No.FUN-660073
            COLUMN g_c[42],g_dash2[1,g_w[42]],
            COLUMN g_c[43],g_dash2[1,g_w[43]]
#No.FUN-7C0101--begin
      IF tm.type MATCHES '[345]' THEN
         LET g_x[31] = g_x[27] CLIPPED
      END IF
#No.FUN-7C0101--end
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[46]  #No.FUN-660073 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      LET l_str=ccc.ccc01,' ',ima.ima25 #CHI-690007
      PRINT COLUMN g_c[31],l_str, #CHI-690007
            COLUMN g_c[33],cl_numfor(ccc.ccc11,33,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27
            COLUMN g_c[34],cl_numfor(ccc.ccc21,34,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[35],cl_numfor(ccc.ccc25,35,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[36],cl_numfor(ccc.ccc27,36,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[37],cl_numfor(ccc.ccc23,37,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(ccc.ccc31,38,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[39],cl_numfor(ccc.ccc41,39,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27              
            COLUMN g_c[40],cl_numfor(ccc.ccc51,40,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[41],cl_numfor(ccc.ccc61,41,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[46],cl_numfor(ccc.ccc81,46,g_ccz.ccz27),  #No.FUN-660073 #CHI-690007 g_azi03->ccz27
            COLUMN g_c[42],cl_numfor(ccc.ccc71,42,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27               
            COLUMN g_c[43],cl_numfor(ccc.ccc91,43,g_ccz.ccz27),    #FUN-570190 #CHI-690007  g_azi03->ccz27
            COLUMN g_c[44],cl_numfor(ccc.ccc93,44,g_ccz.ccz26) #MOD-550159    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26                
      PRINT COLUMN g_c[31],ima.ima02,
            COLUMN g_c[33],cl_numfor(ccc.ccc12,33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[34],cl_numfor(ccc.ccc22,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[35],cl_numfor(ccc.ccc26,35,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[36],cl_numfor(ccc.ccc28,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(ccc.ccc32,38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(ccc.ccc42,39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[40],cl_numfor(ccc.ccc52,40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[41],cl_numfor(ccc.ccc62,41,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[46],cl_numfor(ccc.ccc82,46,g_ccz.ccz26),    #No.FUN-660073 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[42],cl_numfor(ccc.ccc72,42,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[43],cl_numfor(ccc.ccc92,43,g_ccz.ccz26)     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT COLUMN g_c[31],ima.ima021
#No.FUN-7C0101--begin
      IF tm.type MATCHES '[345]' THEN
         PRINT COLUMN g_c[31],ccc.ccc08                  
      END IF
#No.FUN-7C0101--end 
      IF tm.n='Y' THEN
#        PRINT
         PRINT COLUMN g_c[32],g_x[23] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12a,33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22a,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26a,35,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28a,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92a,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93a,44,g_ccz.ccz26) #MOD-550159     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT COLUMN g_c[32],g_x[24] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12b,33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22b,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26b,35,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28b,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92b,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93b,44,g_ccz.ccz26) #MOD-550159    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT COLUMN g_c[32],g_x[25] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12c,33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22c,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26c,35,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28c,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92c,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93c,44,g_ccz.ccz26) #MOD-550159    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT COLUMN g_c[32],g_x[26] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12d,33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22d,34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26d,35,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28d,36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92d,43,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93d,44,g_ccz.ccz26) #MOD-550159     #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
#No.FUN-7C0101--begin
         PRINT COLUMN g_c[32],g_x[28] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12e,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22e,34,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26e,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28e,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92e,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93e,44,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT COLUMN g_c[32],g_x[29] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12f,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22f,34,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26f,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28f,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92f,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93f,44,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT COLUMN g_c[32],g_x[30] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12g,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22g,34,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26g,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28g,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92g,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93g,44,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
         PRINT COLUMN g_c[32],g_x[47] CLIPPED,
                         COLUMN g_c[33], cl_numfor(ccc.ccc12h,33,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[34], cl_numfor(ccc.ccc22h,34,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[35], cl_numfor(ccc.ccc26h,35,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[36], cl_numfor(ccc.ccc28h,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[43], cl_numfor(ccc.ccc92h,43,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
                         COLUMN g_c[44], cl_numfor(ccc.ccc93h,44,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
#No.FUN-7C0101--end
         PRINT
      END IF
 
   ON LAST ROW
      PRINT COLUMN g_c[32],g_x[22] CLIPPED,
        COLUMN g_c[33],cl_numfor(SUM(ccc.ccc11) ,33,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27
        COLUMN g_c[34],cl_numfor(SUM(ccc.ccc21) ,34,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[35],cl_numfor(SUM(ccc.ccc25) ,35,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[36],cl_numfor(SUM(ccc.ccc27) ,36,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[38],cl_numfor(SUM(ccc.ccc31) ,38,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[39],cl_numfor(SUM(ccc.ccc41) ,39,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[40],cl_numfor(SUM(ccc.ccc51) ,40,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[41],cl_numfor(SUM(ccc.ccc61) ,41,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[46],cl_numfor(SUM(ccc.ccc81) ,46,g_ccz.ccz27),    #No.FUN-660073 #CHI-690007 g_azi03->ccz27
        COLUMN g_c[42],cl_numfor(SUM(ccc.ccc71) ,42,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
        COLUMN g_c[43],cl_numfor(SUM(ccc.ccc91) ,43,g_ccz.ccz27),    #FUN-570190  #CHI-690007 g_azi03->ccz27            
         COLUMN g_c[44],cl_numfor(SUM(ccc.ccc93),44,g_ccz.ccz26) #MOD-550159    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
      PRINT
        COLUMN g_c[33],cl_numfor(SUM(ccc.ccc12),33,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[34],cl_numfor(SUM(ccc.ccc22),34,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[35],cl_numfor(SUM(ccc.ccc26),35,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[36],cl_numfor(SUM(ccc.ccc28),36,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[38],cl_numfor(SUM(ccc.ccc32),38,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[39],cl_numfor(SUM(ccc.ccc42),39,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[40],cl_numfor(SUM(ccc.ccc52),40,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[41],cl_numfor(SUM(ccc.ccc62),41,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[46],cl_numfor(SUM(ccc.ccc82),46,g_ccz.ccz26),  #No.FUN-660073 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[42],cl_numfor(SUM(ccc.ccc72),42,g_ccz.ccz26),    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
        COLUMN g_c[43],cl_numfor(SUM(ccc.ccc92),43,g_ccz.ccz26)    #FUN-570190 #CHI-C30012 g_azi03->g_ccz.ccz26
 
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]   #No.TQC-6A0078
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
FUNCTION r410_getStartPos(l_sta,l_end,l_str)
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5    #No.FUN-680122 SMALLINT
DEFINE l_str STRING
   LET l_str=l_str.trim()
   LET l_length=l_str.getLength()
   LET l_w_tot=0
   FOR l_i=l_sta to l_end
      LET l_w_tot=l_w_tot+g_w[l_i]
   END FOR
   LET l_pos=(l_w_tot/2)-(l_length/2)
   IF l_pos<0 THEN LET l_pos=0 END IF
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
   RETURN l_pos
END FUNCTION
