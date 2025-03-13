# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axcr230.4gl
# Descriptions...: 料件成本單價列印
# Input parameter: 
# Return code....: 
# Date & Author..: 98/05/20 By Aladin
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify.........: No.FUN-4C0099 04/12/30 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-7C0101 08/01/25 By Zhangyajun 成本改善增加成本計算類型(type)
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc       STRING,         # Where condition #TQC-630166
              s_y     LIKE type_file.num10,          #No.FUN-680122 INTEGER
              type    LIKE type_file.chr1,     #No.FUN-7C0101 VARCHAR(1)
              s       LIKE type_file.chr3,     #No.FUN-680122CHAR(3)      # Order by sequence #TQC-840066
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)       # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03     #No.FUN-680122 DECIMAL(13,2)     # User defined variable
 
 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                    # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate = ARG_VAL(1)           # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   #TQC-610051-begin
   LET tm.s_y  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET tm.type    = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr230_tm(0,0)        # Input print condition
      ELSE CALL axcr230()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
 
 
FUNCTION axcr230_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW axcr230_w AT p_row,p_col
        WITH FORM "axc/42f/axcr230" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '41'
   LET tm.type = g_ccz.ccz28    #No.FUN-7C0101 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
 
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima57,ima02,ccc03 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   let tm.s_y=g_ccz.ccz01
   let tm.s='123'
   let tm.more='N'
 
   DISPLAY BY NAME tm.s_y,tm.s,tm.more         # Condition
 
   INPUT BY NAME tm.s_y,tm.type,              #No.FUN-7C0101 add tm.type
                   tm2.s1,tm2.s2,tm2.s3,
                   tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD s_y
         IF cl_null(tm.s_y) THEN NEXT FIELD s_y END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr230'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr230','9031',1)   
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
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.s_y CLIPPED,"'" ,              #TQC-610051
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axcr230',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr230_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr230()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr230_w
END FUNCTION
 
 
FUNCTION axcr230()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_order    ARRAY[3] OF LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
 
          sr         RECORD
                     order1  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
                     order2  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
                     order3  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
                     ccc03   like ccc_file.ccc03,
                     ima01   like ima_file.ima01,
                     ima02   like ima_file.ima02,
                     ima021   like ima_file.ima021,   #FUN-4C0099
                     ccc08   LIKE ccc_file.ccc08,      #No.FUN-7C0101
                     ccc23a  like ccc_file.ccc23a,
                     ccc23b  like ccc_file.ccc23b,
                     tot     like ccc_file.ccc23c,
                     ccc23   like ccc_file.ccc23,
                     ima57   like ima_file.ima57
                     END RECORD
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = " SELECT '','','',",
                 " ccc03,ima01,ima02,ima021,ccc08,ccc23a,",               #No.FUN-7C0101 add ccc08
                 " ccc23b,(ccc23c+ccc23d+ccc23e+ccc23f+ccc23g+ccc23h),",  #No.FUN-7C0101 mod
                 " ccc23,ima57 ",
                 " FROM ccc_file,ima_file ",
                 " WHERE ima01=ccc01 and ",
                 " ccc02 = ",tm.s_y," and ",tm.wc CLIPPED,
                 " AND ccc07= '",tm.type,"'"                      #No.FUN-7C0101
 
     PREPARE axcr230_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM    
          
     END IF
     DECLARE axcr230_curs1 CURSOR FOR axcr230_prepare1
 
     CALL cl_outnam('axcr230') RETURNING l_name
     
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[35].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[35].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
     
     START REPORT axcr230_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axcr230_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
 
       FOR g_i = 1 TO 3
          CASE
               WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima02
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima57
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ccc03
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
 
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       # DISPLAY sr.ima01,' ',sr.ccc03 at 2,1
       OUTPUT TO REPORT axcr230_rep(sr.*)
 
     END FOREACH
 
     FINISH REPORT axcr230_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
#No.8741
REPORT axcr230_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
         sr         RECORD
                       order1  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
                       order2  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
                       order3  LIKE type_file.chr1000,       #No.FUN-680122CHAR(40) #FUN-5B0105 30->40
                       ccc03   like ccc_file.ccc03,
                       ima01   like ima_file.ima01,
                       ima02   like ima_file.ima02,
                       ima021   like ima_file.ima021,   #FUN-4C0099
                       ccc08   LIKE ccc_file.ccc08,      #No.FUN-7C0101 
                       ccc23a  like ccc_file.ccc23a,
                       ccc23b  like ccc_file.ccc23b,
                       tot     like ccc_file.ccc23c,
                       ccc23   like ccc_file.ccc23,
                       ima57   like ima_file.ima57
                       END RECORD,
          l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2,sr.order3
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT tm.s_y using '&&&&', g_x[12] clipped
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39]             #No.FUN-7C0101 add g_x[39]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ccc03 using '<<'   ,
            COLUMN g_c[32],sr.ima01,
            COLUMN g_c[33],sr.ima02,
            COLUMN g_c[34],sr.ima021,
            COLUMN g_c[35],sr.ccc08,                        #No.FUN-7C0101
            COLUMN g_c[36],cl_numfor(sr.ccc23a,36,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[37],cl_numfor(sr.ccc23b,37,g_ccz.ccz26), #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[38],cl_numfor(sr.tot,38,g_ccz.ccz26),    #CHI-C30012 g_azi03->g_ccz.ccz26
            COLUMN g_c[39],cl_numfor(sr.ccc23,39,g_ccz.ccz26)   #CHI-C30012 g_azi03->g_ccz.ccz26
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
 
        {
         CALL cl_wcchp(tm.wc,'ccc02,ctj02,ctj03,ctj04,ctj05')
              RETURNING tm.wc
        }
 
         PRINT g_dash
           #TQC-630166 Start
           #   IF tm.wc[001,070] > ' ' THEN            # for 80
        # PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #      IF tm.wc[071,140] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #      IF tm.wc[141,210] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #      IF tm.wc[211,280] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          
          CALL cl_prt_pos_wc(tm.wc)
          #TQC-630166 End
 
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
 
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
