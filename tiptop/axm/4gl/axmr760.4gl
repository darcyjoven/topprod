# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axmr760.4gl
# Descriptions...: 客訴案未處理警訊
# Date & Author..: 02/03/29 By Wiky
# Modify.........: 02/06/10 By Mandy
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 結束位置調整
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-750110 07/06/18 By dxfwo CR報表的制作
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A70128 10/08/02 By lixia datediff相關修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,
           od      LIKE type_file.num5,        # No.FUN-680137 SMALLINT
           more    LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)
           END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table     STRING                    #No.FUN-750110                                                                       
DEFINE   g_sql       STRING                    #No.FUN-750110                                                                       
DEFINE   g_str       STRING                    #No.FUN-750110 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
   #No.FUN-750110 --start--  
   LET g_sql = " ohc01.ohc_file.ohc01,",
               " ohc06.ohc_file.ohc06,",
               " ohc061.ohc_file.ohc061,",
               " ohc13.ohc_file.ohc13,",
               " ohc02.ohc_file.ohc02,",
               " ohc041.ohc_file.ohc041,",
               " ohc10.ohc_file.ohc10,",
               " gen02.gen_file.gen02,",
               " ohc11.ohc_file.ohc11,",
               " gen04.gen_file.gen04 "   
   LET l_table = cl_prt_temptable('axmr760',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   #No.FUN-750110 --end--  
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.od    = ARG_VAL(8)
#--------------No.TQC-610089 modify
  #LET tm.more  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------No.TQC-610089 end
   IF NOT cl_null(tm.wc) THEN
       CALL r760()
   ELSE
       CALL r760_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r760_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW r760_w AT p_row,p_col WITH FORM "axm/42f/axmr760"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ohc01,ohc02,ohc06
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
      LET INT_FLAG = 0
      CLOSE WINDOW r760_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.od,tm.more
      WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
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
      LET INT_FLAG = 0
      CLOSE WINDOW r760_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmr760'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr760','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.od CLIPPED,"'",                #No.TQC-610089 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr760',g_time,l_cmd)
      END IF
      CLOSE WINDOW r760_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r760()
   ERROR ""
END WHILE
   CLOSE WINDOW r760_w
END FUNCTION
 
FUNCTION r760()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0094
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT        #No.FUN-680137  VARCHAR(1000)
DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE faj_file.faj02     # No.FUN-680137 VARCHAR(10)
DEFINE l_gen02_1    LIKE gen_file.gen02     #負責業務人員名稱
DEFINE l_gen02_2    LIKE gen_file.gen02     #處理人員名稱
DEFINE sr        RECORD
                     ohc01    LIKE ohc_file.ohc01,    #客訴單號
                     ohc06    LIKE ohc_file.ohc06,    #客戶編號
                     ohc061   LIKE ohc_file.ohc061,   #客戶簡稱
                     ohc13    LIKE ohc_file.ohc13,    #處理期限
                     ohc02    LIKE ohc_file.ohc02,    #客訴日期
                     ohc10    LIKE ohc_file.ohc10,    #負責業務
                     ohc11    LIKE ohc_file.ohc11,    #處理人員
                     overday  LIKE type_file.num5     # No.FUN-680137 SMALLINT    #超過天數
                 END RECORD
     CALL cl_del_data(l_table)  #No.FUN-750110 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ohcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ohcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ohcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohcuser', 'ohcgrup')
     #End:FUN-980030
 
#     LET l_gen02_1= NULL
#     LET l_gen02_2= NULL
#     SELECT gen02 INTO l_gen02_1 FROM gen_file  #負責業務人員名稱
#      WHERE gen01=sr.ohc10
#     SELECT gen02 INTO l_gen02_2 FROM gen_file  #處理人員名稱
#      WHERE gen01=sr.ohc11
 
     LET l_sql = " SELECT ohc01,ohc06,ohc061,ohc13,ohc02,ohc10,ohc11,",
                 #" datediff(day,ohc13,cast('",g_today,"' as DATETIME))  ,'','' ",  #TQC-A70128
                 " '' ",                                                            #TQC-A70128
                 " FROM ohc_file ",
                 " WHERE ohc03 = '0' ",
                 "   AND ohcconf != 'X' ",
                 #" AND datediff(day,ohc13,cast('",g_today,"' as DATETIME))  >= 0 ",#TQC-A70128
                 "   AND ", tm.wc CLIPPED
          #TQC-A70128--mark--str--       
          #IF NOT cl_null(tm.od) THEN      #判斷計算超過天數
          #    LET l_sql = l_sql CLIPPED,
          #                " AND datediff(day,ohc13,cast('",g_today,"' as DATETIME))  >=",tm.od
          #END IF
          #TQC-A70128--mark--end-- 
     LET l_sql = l_sql CLIPPED," ORDER BY ohc13"
     PREPARE r760_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
     END IF
     DECLARE r760_curs1 CURSOR FOR r760_prepare1
#    CALL cl_outnam('axmr760') RETURNING l_name  #No.FUN-750110 
#    START REPORT r760_rep TO l_name             #No.FUN-750110     
#    LET g_pageno = 0                            #No.FUN-750110
     FOREACH r760_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
#        OUTPUT TO REPORT r760_rep(sr.*)
      #TQC-A70128--add--str--
      LET sr.overday =  g_today - sr.ohc13
      IF sr.overday < 0 THEN
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(tm.od) THEN
         IF sr.overday < tm.od THEN
            CONTINUE FOREACH
         END IF
      END IF      
      #TQC-A70128--add--end--
      LET l_gen02_1= NULL                                           #No.FUN-750110
      LET l_gen02_2= NULL                                           #No.FUN-750110
      SELECT gen02 INTO l_gen02_1 FROM gen_file  #負責業務人員名稱  #No.FUN-750110
       WHERE gen01=sr.ohc10                                         #No.FUN-750110      
      SELECT gen02 INTO l_gen02_2 FROM gen_file  #處理人員名稱      #No.FUN-750110    
       WHERE gen01=sr.ohc11                                         #No.FUN-750110
         EXECUTE insert_prep USING sr.ohc01,sr.ohc06,sr.ohc061,sr.ohc13,sr.ohc02,   #No.FUN-750110
                                   sr.overday,sr.ohc10,l_gen02_1,sr.ohc11,l_gen02_2 #No.FUN-750110   
 
     END FOREACH
#    FINISH REPORT r760_rep                                          #No.FUN-750110
#No.FUN-750110--------begin--------  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
     CALL cl_wcchp(tm.wc,'ohc01,ohc02,ohc06')                                                                                             
          RETURNING tm.wc 
     LET g_str = tm.wc 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED    
     CALL cl_prt_cs3('axmr760','axmr760',l_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750110--------end--------  
END FUNCTION
{                     #No.FUN-750110
REPORT r760_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
DEFINE l_gen02_1    LIKE gen_file.gen02     #負責業務人員名稱
DEFINE l_gen02_2    LIKE gen_file.gen02     #處理人員名稱
DEFINE sr           RECORD
                     ohc01    LIKE ohc_file.ohc01,    #客訴單號
                     ohc06    LIKE ohc_file.ohc06,    #客戶編號
                     ohc061   LIKE ohc_file.ohc061,   #客戶簡稱
                     ohc13    LIKE ohc_file.ohc13,    #處理期限
                     ohc02    LIKE ohc_file.ohc02,    #客訴日期
                     ohc10    LIKE ohc_file.ohc10,    #負責業務
                     ohc11    LIKE ohc_file.ohc11,    #處理人員
                     overday  LIKE type_file.num5     # No.FUN-680137 SMALLINT    #超過天數
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ohc13
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      LET l_gen02_1= NULL
      LET l_gen02_2= NULL
      SELECT gen02 INTO l_gen02_1 FROM gen_file  #負責業務人員名稱
       WHERE gen01=sr.ohc10
      SELECT gen02 INTO l_gen02_2 FROM gen_file  #處理人員名稱
       WHERE gen01=sr.ohc11
 
      PRINT COLUMN  g_c[31],sr.ohc01   CLIPPED,
            COLUMN  g_c[32],sr.ohc06   CLIPPED,
            COLUMN  g_c[33],sr.ohc061  CLIPPED,
            COLUMN  g_c[34],sr.ohc13   CLIPPED,
            COLUMN  g_c[35],sr.ohc02   CLIPPED,
            COLUMN  g_c[36],sr.overday USING '########',#No.TQC-5B0212
            COLUMN  g_c[37],sr.ohc10   CLIPPED,
            COLUMN  g_c[38],l_gen02_1  CLIPPED,
            COLUMN  g_c[39],sr.ohc11   CLIPPED,
            COLUMN  g_c[40],l_gen02_2  CLIPPED
   ON LAST ROW
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'ohc01,ohc06,ohc061,ohc13,ohc02')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5B0212
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5B0212
         ELSE SKIP 2 LINE
      END IF
END REPORT               }     #No.FUN-750110
