# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcr002.4gl
# Descriptions...: 入庫成本調整月報
# Date & Author..: 05/08/03 By Rongyf
# Modify.........: No.TQC-610051 06/02/13 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-770070 07/07/17 By Carol 將azi05,azi04取位改為使用azi03
# Modify.........: No.FUN-780017 07/07/30 By dxfwo CR報表的制作
# Modify.........: No.FUN-7C0101 08/01/24 By shiwuying 成本改善，CR增加類別編號ccb07和各種制費
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/19 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                 # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(600),      # Where condition
              sy      LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              sm      LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              ey      LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              em      LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              type    LIKE ccb_file.ccb06,           #No.FUN-7C0101 add
              a       LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              g       LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
              more    LIKE type_file.chr1            # Prog. Version..: '5.30.06-13.03.12(01)        # Input more condition(Y/N)
              END RECORD
   DEFINE   g_msg     LIKE type_file.chr1000         #No.FUN-680122CHAR(72)
   DEFINE   l_table         STRING                   #No.FUN-780017                                                                    
   DEFINE   g_sql           STRING                   #No.FUN-780017                                                                    
   DEFINE   g_str           STRING                   #No.FUN-780017 
MAIN
   OPTIONS
      INPUT NO WRAP
      DEFER INTERRUPT    
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
#No.FUN-780017---Begin                                                                                                              
   LET g_sql = " ima12.ima_file.ima12,",                                                                                            
               " wima01.type_file.chr3,",
               " ima01.ima_file.ima01,",
               " ima02.ima_file.ima02,",
               " ccb07.ccb_file.ccb07,",      #No.FUN-7C0101 add
               " ccb22a.ccb_file.ccb22a,",
               " ccb22b.ccb_file.ccb22b,",
               " ccb22c.ccb_file.ccb22c,",
               " ccb22d.ccb_file.ccb22d,",
               " ccb22e.ccb_file.ccb22e,",
               " ccb22f.ccb_file.ccb22f,",    #No.FUN-7C0101 add
               " ccb22g.ccb_file.ccb22g,",    #No.FUN-7C0101 add
               " ccb22h.ccb_file.ccb22h,",    #No.FUN-7C0101 add
               " ccb22.ccb_file.ccb22,",
               " g_msg.type_file.chr1000"
   LET l_table = cl_prt_temptable('axcr002',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
              # " VALUES(?,?,?,?,?,?,?,?,?,?,?)"          #No.FUN-7C0101
               " VALUES(?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"  #No.FUN-7C0101                                                 
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
   END IF                                                                                                                   
#No.FUN-780017---End  
 
   INITIALIZE tm.* TO NULL 
   LET tm.more = 'N'
   LET tm.a    = 'N'
   LET tm.g    = '1'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.type=ARG_VAL(17)  #No.FUN-7C0101 add 
   #TQC-610051-begin
   LET tm.sy    = ARG_VAL(8)
   LET tm.sm    = ARG_VAL(9)
   LET tm.ey    = ARG_VAL(10)
   LET tm.em    = ARG_VAL(11)
   LET tm.a     = ARG_VAL(12)
   LET tm.g     = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #TQC-610051-end
 
   IF cl_null(g_bgjob) or g_bgjob = 'N' THEN
      CALL axcr002_tm(0,0)
   ELSE 
      CALL axcr002()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr002_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_sy,l_sm    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_ey,l_em    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 
      LET p_col = 20
   ELSE 
      LET p_row = 4 
      LET p_col = 15
   END IF
   OPEN WINDOW axcr002_w AT p_row,p_col
        WITH FORM "axc/42f/axcr002" 
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL 
   LET tm.more= 'N'
   LET tm.a   = 'N'
   LET tm.g   = '1'
   LET tm.type = g_ccz.ccz28     #No.FUN-7C0101 add
   LET tm.sy    = YEAR(g_today)  #No.FUN-7C0101 add
   LET tm.sm    = MONTH(g_today) #No.FUN-7C0101 add
   LET tm.ey    = YEAR(g_today)  #No.FUN-7C0101 add
   LET tm.em    = MONTH(g_today) #No.FUN-7C0101 add
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima12,ima01,ima57,ima08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about 
            CALL cl_about()    
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg     
            CALL cl_cmdask()    
 
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
         LET INT_FLAG = 0 
         CLOSE WINDOW axcr002_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN 
         CALL cl_err('','9046',0) CONTINUE WHILE 
      END IF
      INPUT BY NAME tm.sy,tm.sm,tm.ey,tm.em,tm.type,#No.FUN-7C0101 add tm.type
                    tm.a,tm.g,tm.more
         WITHOUT DEFAULTS 
      
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD sy
            IF tm.sy<1949 OR tm.sy>2050 THEN 
               NEXT FIELD sy 
            END IF
           
         AFTER FIELD sm
            IF tm.sm<1 OR tm.sm>12 THEN 
               NEXT FIELD sm 
            END IF
           
         AFTER FIELD ey
            IF tm.ey<1949 OR tm.ey>2050 THEN 
               NEXT FIELD ey 
            END IF
        
         AFTER FIELD em
            IF tm.em<1 OR tm.em>12 THEN 
               NEXT FIELD em 
            END IF
 
         AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
        
         AFTER INPUT
            IF tm.ey*12+tm.em < tm.sy*12+tm.sm THEN
               NEXT FIELD sy
            END IF
        
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about     
            CALL cl_about()     
    
         ON ACTION help         
            CALL cl_show_help()  
   
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW axcr002_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='axcr002'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr002','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610051-begin
                         " '",tm.sy CLIPPED,"'",
                         " '",tm.sm CLIPPED,"'",
                         " '",tm.ey CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.type CLIPPED,"'" ,           #No.FUN-7C0101 add
                         " '",tm.a CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
                         #TQC-610051-end
 
 
            CALL cl_cmdat('axcr002',g_time,l_cmd)
         END IF
         CLOSE WINDOW axcr002_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axcr002()
      ERROR ""
   END WHILE
   CLOSE WINDOW axcr002_w
END FUNCTION
 
FUNCTION axcr002()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122  VARCHAR(20),
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,        #No.FUN-680122CHAR(800),
          l_chr     LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_pmm22   LIKE pmm_file.pmm22,
          l_pmm42   LIKE pmm_file.pmm42,
          wima01    LIKE type_file.chr3,           #No.FUN-680122 VARCHAR(3)
          sr RECORD
             ima12  LIKE ima_file.ima12,
             ima01  LIKE ima_file.ima01,
             ima02  LIKE ima_file.ima02,
             ccb07  LIKE ccb_file.ccb07,           #No.FUN-7C0101 add 
             ccb22a LIKE ccb_file.ccb22a,
             ccb22b LIKE ccb_file.ccb22b,
             ccb22c LIKE ccb_file.ccb22c,
             ccb22d LIKE ccb_file.ccb22d,
             ccb22e LIKE ccb_file.ccb22e,
             ccb22f LIKE ccb_file.ccb22f,          #No.FUN-7C0101 add
             ccb22g LIKE ccb_file.ccb22g,          #No.FUN-7C0101 add
             ccb22h LIKE ccb_file.ccb22h,          #No.FUN-7C0101 add
             ccb22  LIKE ccb_file.ccb22
             END RECORD,
          l_n       LIKE type_file.num5,           #No.FUN-680122 SMALLINT
          l_rvu08   LIKE rvu_file.rvu08
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
   LET l_sql = "SELECT ima12,ima01,ima02,ccb07,",   #No.FUN-7C0101 add ccb07
               "       SUM(ccb22a),SUM(ccb22b),SUM(ccb22c),",
               "       SUM(ccb22d),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h),SUM(ccb22)",#No.FUN-7C0101
               "  FROM ima_file,ccb_file",
               " WHERE ima01 = ccb01",
               "   AND ima12 IS NOT NULL ",
               "   AND ccb06 = '",tm.type,"'",                #No.FUN-7C0101 add
               "   AND ccb02*12+ccb03 >= ",tm.sy,"*12+",tm.sm," ",
               "   AND ccb02*12+ccb03 <= ",tm.ey,"*12+",tm.em," ",
               "   AND ",tm.wc CLIPPED,
               " GROUP BY ima12,ima01,ima02,ccb07"
 
   PREPARE axcr002_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE axcr002_curs1 CURSOR FOR axcr002_prepare1
 
#  CALL cl_outnam('axcr002') RETURNING l_name         #No.FUN-780017 
 
#  START REPORT axcr002_rep TO l_name                 #No.FUN-780017 
   CALL cl_del_data(l_table)                          #No.FUN-780017       
   FOREACH axcr002_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF tm.g='2' THEN 
         LET  wima01  = sr.ima01
      END IF 
      LET g_msg=' '
      SELECT azf03 INTO g_msg FROM azf_file
       WHERE azf01=sr.ima12
         AND azf02='G' 
#No.FUN-780017---Begin
#     OUTPUT TO REPORT axcr002_rep(sr.* ,wima01)
      EXECUTE insert_prep USING sr.ima12,wima01,sr.ima01,sr.ima02,sr.ccb07,sr.ccb22a,sr.ccb22b, #No.FUN-7C0101
                                sr.ccb22c,sr.ccb22d,sr.ccb22e,sr.ccb22f,sr.ccb22g,sr.ccb22h,sr.ccb22,g_msg #No.FUN-7C0101
   END FOREACH
#  FINISH REPORT axcr002_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'ima12,ima01,ima57,ima08')         
           RETURNING tm.wc                                                     
   END IF
   #LET g_str = tm.wc,";",tm.a,";",tm.g,";",g_azi03,";",tm.type  #No.FUN-7C0101 #CHI-C30012 mark
   LET g_str = tm.wc,";",tm.a,";",tm.g,";",g_ccz.ccz26,";",tm.type  #CHI-C30012
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr002','axcr002',l_sql,g_str)
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr002','axcr002_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr002','axcr002',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
 
#No.FUN-780017---End
END FUNCTION
{                    #No.FUN-780017   
REPORT  axcr002_rep(sr,wima01)
   DEFINE l_last_sw  LIKE type_file.chr1           #No.FUN-680122CHAR(01)
   DEFINE wima01     LIKE type_file.chr3,          #No.FUN-680122CHAR(03),
       sr RECORD
          ima12      LIKE ima_file.ima12,
          ima01      LIKE ima_file.ima01,
          ima02      LIKE ima_file.ima02,
          ccb22a     LIKE ccb_file.ccb22a,
          ccb22b     LIKE ccb_file.ccb22b,
          ccb22c     LIKE ccb_file.ccb22c,
          ccb22d     LIKE ccb_file.ccb22d,
          ccb22e     LIKE ccb_file.ccb22e,
          ccb22      LIKE ccb_file.ccb22
          END RECORD,
          l_chr      LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   OUTPUT 
   TOP MARGIN g_top_margin 
   LEFT MARGIN g_left_margin 
   BOTTOM MARGIN g_bottom_margin 
   PAGE LENGTH g_page_line
  
   ORDER BY sr.ima12,wima01
  
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW   
      IF tm.a = 'Y' AND tm.g='1' THEN
        #PRINT COLUMN g_c[31], sr.ima01[1,16],  #CHI-690007
        #      COLUMN g_c[32], sr.ima02[1,30],  #CHI-690007
         PRINT COLUMN g_c[31], sr.ima01,  #CHI-690007
               COLUMN g_c[32], sr.ima02,  #CHI-690007
#MOD-770070-modify---> azi05,azi04->azi03
               COLUMN g_c[33], cl_numfor(sr.ccb22a,33,g_azi03),
               COLUMN g_c[34], cl_numfor(sr.ccb22b,34,g_azi03),
               COLUMN g_c[35], cl_numfor(sr.ccb22c,35,g_azi03),
               COLUMN g_c[36], cl_numfor(sr.ccb22d,36,g_azi03),
               COLUMN g_c[37], cl_numfor(sr.ccb22e,37,g_azi03),
               COLUMN g_c[38], cl_numfor(sr.ccb22,38,g_azi03)
#MOD-770070-modify-end
      END IF
 
   AFTER GROUP OF  wima01
      IF tm.g='2' THEN
         PRINT COLUMN g_c[31], wima01,
               COLUMN g_c[32], ' ',
#MOD-770070-modify---> azi05,azi04->azi03
               COLUMN g_c[33], cl_numfor(GROUP SUM(sr.ccb22a),33,g_azi03),
               COLUMN g_c[34], cl_numfor(GROUP SUM(sr.ccb22b),34,g_azi03),
               COLUMN g_c[35], cl_numfor(GROUP SUM(sr.ccb22c),35,g_azi03),
               COLUMN g_c[36], cl_numfor(GROUP SUM(sr.ccb22d),36,g_azi03),
               COLUMN g_c[37], cl_numfor(GROUP SUM(sr.ccb22e),37,g_azi03),
               COLUMN g_c[38], cl_numfor(GROUP SUM(sr.ccb22),38,g_azi03)
#MOD-770070-modify-end
      END IF
            
   AFTER GROUP OF sr.ima12
      PRINT g_dash2 
      LET g_msg=' '
      SELECT azf03 INTO g_msg FROM azf_file
       WHERE azf01=sr.ima12
         AND azf02='G' 
      PRINT COLUMN g_c[33], g_x[21] CLIPPED,
            COLUMN g_c[34], g_msg CLIPPED,
            COLUMN g_c[38], cl_numfor(GROUP SUM(sr.ccb22),38,g_azi03)  #MOD-770070 modify azi05->azi03
      PRINT g_dash2 
      
   ON LAST ROW
      PRINT COLUMN g_c[33], g_x[22] CLIPPED,
            COLUMN g_c[38], cl_numfor(SUM(sr.ccb22),38,g_azi03)        #MOD-770070 modify azi04->azi03
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN 
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF 
END REPORT       }           #No.FUN-780017 
