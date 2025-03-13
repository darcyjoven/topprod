# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr910.4gl
# Descriptions...: 資金模擬明細表
# Date & Author..: 06/04/06 By Nicola
# Modify.........: 06/06/30 FUN-640089 by yiting 增加一個銀行別QBE選項,加印銀行編號/名稱/對象
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-860007 08/06/03 By Sunyanchun 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm      RECORD
                  wc      STRING,
                  nqg01   LIKE nqg_file.nqg01,
                  nqg02   LIKE nqg_file.nqg02,
                  more    LIKE type_file.chr1     #FUN-680107 VARCHAR(1)
               END RECORD
DEFINE g_cnt   LIKE type_file.num5     #FUN-680107 SMALLINT
DEFINE g_sql   STRING                  #NO.FUN-860007
DEFINE g_str   STRING                  #NO.FUN-860007
DEFINE l_table   STRING                  #NO.FUN-860007
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   #NO.FUN-860007-----BEGIN-----
   LET g_sql = "nqg02.nqg_file.nqg02,",
                "nqg04.nqg_file.nqg04,",
                "nqg05.nqg_file.nqg05,",
                "nqg06.nqg_file.nqg06,",
                "nqg01.nqg_file.nqg01,",
                "nqg03.nqg_file.nqg03,",
                "nqa01.nqa_file.nqa01,",
                "nqd02.nqd_file.nqd02,",
                "nqg16.nqg_file.nqg16,",
                "nmt02.nmt_file.nmt02,",
                "nqg17.nqg_file.nqg17,",
                "nqg07.nqg_file.nqg07,",
                "nqg08.nqg_file.nqg08,",
                "nqg09.nqg_file.nqg09,",
                "nqg10.nqg_file.nqg10,",
                "nqg12.nqg_file.nqg12,",
                "nqg13.nqg_file.nqg13,",
                "nqg14.nqg_file.nqg14,",
                "lbal.nqg_file.nqg13,",
                "cbal.nqg_file.nqg14"
 
   LET l_table = cl_prt_temptable('anmr910',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-860007-----END-------
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.nqg01 = ARG_VAL(8)
   LET tm.nqg02 = ARG_VAL(9)
   LET tm.more = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmr910_tm()
   ELSE
      CALL anmr910()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr910_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(400)
   DEFINE li_result     LIKE type_file.num5          #No.FUN-940102
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmr910_w AT p_row,p_col
     WITH FORM "anm/42f/anmr910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      #CONSTRUCT BY NAME tm.wc ON nqg06
      CONSTRUCT BY NAME tm.wc ON nqg06,nqg16   #NO.FUN-640089
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
           CASE                                #NO.FUN-640089
            WHEN INFIELD(nqg06)                #NO.FUN-640089
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nqd"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nqg06
              NEXT FIELD nqg06
#NO.FUN-640089
            WHEN INFIELD(nqg16)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_nmt"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO nqg16
              NEXT FIELD nqg16
           END CASE
#NO.FUN-640089
 
         ON ACTION locale
            CALL cl_show_fld_cont()
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr910_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.nqg01,tm.nqg02,tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD nqg02
            IF NOT cl_null(tm.nqg02) AND tm.nqg02 <> "ALL" THEN
               SELECT COUNT(*) INTO g_cnt FROM azp_file
                WHERE azp01 = tm.nqg02
               IF g_cnt = 0 THEN
                  CALL cl_err(tm.nqg02,"aap-025",0)
                  NEXT FIELD nqg02
               END IF
 #No.FUN-940102 --begin--
               CALL s_chk_demo(g_user,tm.nqg02) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD nqg02
                END IF 
#No.FUN-940102 --end-- 
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLP
            CALL cl_init_qry_var()
#           LET g_qryparam.form ="q_azp"    #No.FUN-940102
            LET g_qryparam.form ="q_zxy"    #No.FUN-940102
            LET g_qryparam.arg1 = g_user    #No.FUN-940102
            LET g_qryparam.default1 = tm.nqg02
            CALL cl_create_qry() RETURNING tm.nqg02
            NEXT FIELD nqg02
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr910_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmr910'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr910','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.nqg01 CLIPPED,"'",
                        " '",tm.nqg02 CLIPPED,"'",
                        " '",tm.more CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmr910',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmr910_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmr910()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmr910_w
 
END FUNCTION
 
FUNCTION anmr910()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0082
          l_sql       STRING,        
          l_lbal      LIKE nqg_file.nqg13,
          l_cbal      LIKE nqg_file.nqg14,
          l_plant     LIKE nqg_file.nqg02,
          sr          RECORD
                         nqg      RECORD LIKE nqg_file.*,
                         nqa01    LIKE nqa_file.nqa01,
                         nqd02    LIKE nqd_file.nqd02,
                         lbal     LIKE nqg_file.nqg13,
                         cbal     LIKE nqg_file.nqg14,
                         nmt02    LIKE nmt_file.nmt02  #NO.FUN-640089
                      END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   IF tm.nqg02 = "ALL" THEN
      #LET l_sql = "SELECT nqg_file.*,'','',0,0",   #NO.FUN-640089
      LET l_sql = "SELECT nqg_file.*,'','',0,0,''",
                  "  FROM nqg_file",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND nqg01 = '",tm.nqg01,"'",
                  " ORDER BY nqg02,nqg04,nqg05,nqg06"
   ELSE
#      LET l_sql = "SELECT nqg_file.*,'','',0,0",   #NO.FUN-640089 MARK
      LET l_sql = "SELECT nqg_file.*,'','',0,0,''",
 
                  "  FROM nqg_file",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND nqg01 = '",tm.nqg01,"'",
                  "   AND nqg02 = '",tm.nqg02,"'",
                  " ORDER BY nqg02,nqg04,nqg05,nqg06"
   END IF
 
   PREPARE anmr910_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
 
   DECLARE anmr910_curs CURSOR FOR anmr910_prepare
 
#   CALL cl_outnam('anmr910') RETURNING l_name    #NO.FUN-860007
#   START REPORT anmr910_rep TO l_name            #NO.FUN-860007
#   LET g_pageno = 0                              #NO.FUN-860007
   LET l_lbal = 0
   LET l_cbal = 0
   LET l_plant= " "
   CALL cl_del_data(l_table)                  #NO.FUN-860007 
   FOREACH anmr910_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.nqg.nqg02 <> l_plant THEN
         LET l_plant = sr.nqg.nqg02
         LET l_lbal = 0
         LET l_cbal = 0
      END IF
 
      SELECT nqa01 INTO sr.nqa01 FROM nqa_file
       WHERE nqa00 = "0"
 
      SELECT nqd02 INTO sr.nqd02 FROM nqd_file
       WHERE nqd01 = sr.nqg.nqg06
 
#NO.FUN-640089 start--
      SELECT nmt02 INTO sr.nmt02
        FROM nmt_file
       WHERE nmt01 = sr.nqg.nqg16
#NO.FUN-640089 end---
 
      IF sr.nqg.nqg06="000" OR sr.nqg.nqg06="100" OR sr.nqg.nqg06="101"
         OR sr.nqg.nqg06="102" OR sr.nqg.nqg06="103"
         OR sr.nqg.nqg06="202" OR sr.nqg.nqg06="300" THEN
         LET sr.lbal = l_lbal + sr.nqg.nqg13
         LET sr.cbal = l_cbal + sr.nqg.nqg14
      ELSE
         LET sr.lbal = l_lbal - sr.nqg.nqg13
         LET sr.cbal = l_cbal - sr.nqg.nqg14
      END IF
 
      LET l_lbal = sr.lbal
      LET l_cbal = sr.cbal
      #NO.FUN-860007---begin---- 
      EXECUTE insert_prep USING sr.nqg.nqg02,sr.nqg.nqg04,sr.nqg.nqg05,sr.nqg.nqg06,
                                sr.nqg.nqg01,sr.nqg.nqg03,sr.nqa01,sr.nqd02,
                                sr.nqg.nqg16,sr.nmt02,sr.nqg.nqg17,sr.nqg.nqg07,
                                sr.nqg.nqg08,sr.nqg.nqg09,sr.nqg.nqg10,sr.nqg.nqg12,
                                sr.nqg.nqg13,sr.nqg.nqg14,sr.lbal,sr.cbal
      #OUTPUT TO REPORT anmr910_rep(sr.*)   
   #NO.FUN-860007----end----
   END FOREACH
   #NO.FUN-860007----BEGIN-----
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'nqg06,nqg16')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ""
   END IF
 
   LET g_str = tm.wc,";",g_azi04
   CALL cl_prt_cs3('anmr910','anmr910',g_sql,g_str)
   #FINISH REPORT anmr910_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #NO.FUN-860007-----END----------
END FUNCTION
#NO.FUN-860007----BEGIN-----
#REPORT anmr910_rep(sr)
#  DEFINE l_last_sw   LIKE type_file.chr1,     #FUN-680107 VARCHAR(1)
#         sr          RECORD
#                        nqg      RECORD LIKE nqg_file.*,
#                        nqa01    LIKE nqa_file.nqa01,
#                        nqd02    LIKE nqd_file.nqd02,
#                        lbal     LIKE nqg_file.nqg13,
#                        cbal     LIKE nqg_file.nqg14,
#                        nmt02    LIKE nmt_file.nmt02  #NO.FUN-640089
#                     END RECORD
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.nqg.nqg02,sr.nqg.nqg04,sr.nqg.nqg05,sr.nqg.nqg06
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno=g_pageno+1
#        LET pageno_total=PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT g_x[9],sr.nqg.nqg01,"     ",g_x[10],sr.nqg.nqg02,"     ",
#              g_x[11],sr.nqg.nqg03,"     ",g_x[12],sr.nqa01
#        PRINT g_x[13],tm.wc
#        PRINT g_dash[1,g_len]
#        #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#              g_x[44],g_x[45],g_x[46],            #NO.FUN-640089
#              g_x[35],g_x[36],g_x[37],g_x[38],
#              g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#    
#     BEFORE GROUP OF sr.nqg.nqg02
#        SKIP TO TOP OF PAGE
#    
#     ON EVERY ROW
#        PRINT COLUMN g_c[31],sr.nqg.nqg04,
#              COLUMN g_c[32],sr.nqg.nqg05,
#              COLUMN g_c[33],sr.nqg.nqg06,
#              COLUMN g_c[34],sr.nqd02,
#              COLUMN g_c[44],sr.nqg.nqg16,   #NO.FUN-640089
#              COLUMN g_c[45],sr.nmt02,       #NO.FUN-640089
#              COLUMN g_c[46],sr.nqg.nqg17,   #NO.FUN-640089
#              COLUMN g_c[35],sr.nqg.nqg07,
#              COLUMN g_c[36],sr.nqg.nqg08,
#              COLUMN g_c[37],cl_numfor(sr.nqg.nqg09,37,0),
#              COLUMN g_c[38],sr.nqg.nqg10,
#              COLUMN g_c[39],cl_numfor(sr.nqg.nqg12,39,g_azi04),
#              COLUMN g_c[40],cl_numfor(sr.nqg.nqg13,40,g_azi04),
#              COLUMN g_c[41],cl_numfor(sr.nqg.nqg14,41,g_azi04),
#              COLUMN g_c[42],cl_numfor(sr.lbal,42,g_azi04),
#              COLUMN g_c[43],cl_numfor(sr.cbal,43,g_azi04)
#   
#     ON LAST ROW
#        PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#    
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN 
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#NO.FUN-860007----end-----
#FUN-870144
