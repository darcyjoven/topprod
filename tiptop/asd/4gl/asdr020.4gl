# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asdr020.4gl
# Descriptions...: 料件標準成本表
# Date & Author..: 98/08/07 By ERIC
# Modify.........: No.FUN-510037 05/02/17 By pengu 報表轉XML
# Modify.........: No.MOD-530125  05/03/17 By Carol QBE欄位順序調整
# Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850086 08/05/19 By Sunyanchun 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No:MOD-C50140 12/05/18 By ck2yuan 抓取bom資料應串主件於aimi100的主特性代碼
# Modify.........: No.FUN-C50075 12/08/27 By bart 加印主特性代碼

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD            
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300), 
              byear   LIKE type_file.num5,         #No.FUN-690010smallint,
              bmonth  LIKE type_file.num5,         #No.FUN-690010smallint,
              dd      LIKE type_file.dat,          #No.FUN-690010DATE,
              more    LIKE type_file.chr1         #No.FUN-690010CHAR(01)       
              END RECORD,
          last_y,last_m  LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_za05        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(40)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING       #NO.FUN-850086
DEFINE   g_str           STRING       #NO.FUN-850086
DEFINE   l_table         STRING       #NO.FUN-850086
DEFINE   l_table1        STRING       #NO.FUN-850086
MAIN
#     DEFINE  l_time  LIKE type_file.chr8             #No.FUN-6A0089
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #NO.FUN-850086----BEGIN------
   LET g_sql = "sta01.sta_file.sta01,",
    		"ima08.ima_file.ima08,",
                "ima02.ima_file.ima02,", 
                "ima021.ima_file.ima021,", 
                "stb07.stb_file.stb07,", 
                "stb08.stb_file.stb08,", 
                "stb09.stb_file.stb09,", 
                "stb09a.stb_file.stb09a,",
                "sum.stb_file.stb07,",
                "stb04.stb_file.stb04,",
                "stb05.stb_file.stb05,", 
                "stb06.stb_file.stb06,", 
                "stb06a.stb_file.stb06a,",
                "sta03.sta_file.sta03,",
                "sta05.sta_file.sta05,",
                "sta08.sta_file.sta08,",
                "sta09.sta_file.sta09,",
                "sta06.sta_file.sta06,",
                "sta06a.sta_file.sta06a,",
                "ima910.ima_file.ima910"    #FUN-C50075
 
   LET l_table = cl_prt_temptable('asdr020',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "sta01.sta_file.sta01,",
                "bmb03.bmb_file.bmb03,",
                "ima08.ima_file.ima08,",
                "ima02.ima_file.ima02,", 
                "ima021.ima_file.ima021,",
                "stb07.stb_file.stb07,", 
                "stb08.stb_file.stb08,", 
                "stb09.stb_file.stb09,", 
                "stb09a.stb_file.stb09a,",  
                "sum.stb_file.stb07,",
                "mod.stb_file.stb07,",
                "fg.stb_file.stb07,",
                "ima910.ima_file.ima910"    #FUN-C50075
   LET l_table1 = cl_prt_temptable('asdr020_1',g_sql)                              
   IF l_table1 = -1 THEN EXIT PROGRAM END IF  
   #NO.FUN-850086----END--------
   LET g_pdate = ARG_VAL(1)      
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.byear  = ARG_VAL(8)
   LET tm.bmonth = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN 
      CALL r020_tm()        
   ELSE 
      CALL r020()             
   END IF
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
END MAIN
 
FUNCTION r020_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
          
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r020_w AT p_row,p_col WITH FORM "asd/42f/asdr020" 
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
 #MOD-530125
      CONSTRUCT BY NAME tm.wc ON sta01,ima12,ima06,ima08 
##
#No.FUN-570244 --start                                                          
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP                                                      
            IF INFIELD(sta01) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO sta01                             
               NEXT FIELD sta01                                                 
            END IF                                                              
#No.FUN-570244 --end             
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         EXIT WHILE
      END IF
      
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      
      LET tm.byear=YEAR(g_today)
      LET tm.bmonth=MONTH(g_today)
      IF tm.bmonth=1 THEN
         LET tm.byear=tm.byear-1
         LET tm.bmonth=12
      ELSE
         LET tm.bmonth=tm.bmonth-1
      END IF
      
      INPUT BY NAME tm.byear,tm.bmonth,tm.more WITHOUT DEFAULTS 
      
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD byear
            IF cl_null(tm.byear) THEN NEXT FIELD byear END IF
      
         AFTER FIELD bmonth 
            IF cl_null(tm.bmonth) THEN NEXT FIELD bmonth END IF
            IF tm.bmonth <1 OR g_aza.aza02 = 1 AND tm.bmonth >12 OR 
               (g_aza.aza02 = 2 AND tm.bmonth >13 ) THEN 
               NEXT FIELD bmonth
            END IF
            LET last_m=tm.bmonth-1
            IF  last_m=0 THEN
                LET last_y=tm.byear-1 LET last_m=12
            ELSE LET last_y=tm.byear END IF
      
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
         EXIT WHILE 
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
          WHERE zz01='asdr020'
      
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
           CALL cl_err('asdr020','9031',1)   
            
            CONTINUE WHILE 
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,     
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.byear  CLIPPED,"'",         #TQC-610079
                            " '",tm.bmonth CLIPPED,"'",         #TQC-610079
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('asdr020',g_time,l_cmd) 
            EXIT WHILE   
         END IF
      END IF
      
      CALL cl_wait()
      CALL r020()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r020_w
 
END FUNCTION
 
FUNCTION r020()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(600)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          sr        RECORD 
                    sta01  LIKE sta_file.sta01,
                    ima02  LIKE ima_file.ima02,
                    ima021 LIKE ima_file.ima021,   #FUN-5A0059
                    ima08  LIKE ima_file.ima08,
                    #stb07  LIKE stb_file.stb07,   #FUN-C50075
                    #stb08  LIKE stb_file.stb08,   #FUN-C50075
                    #stb09  LIKE stb_file.stb09,   #FUN-C50075
                    #stb09a LIKE stb_file.stb09a   #FUN-C50075 
                    ima910 LIKE ima_file.ima910    #FUN-C50075 
                    END RECORD 
   DEFINE l_sum     LIKE stb_file.stb07    #NO.FUN-850086
   DEFINE l_mod     LIKE stb_file.stb07    #NO.FUN-850086
   DEFINE l_fg      LIKE alb_file.alb06    #NO.FUN-850086
   DEFINE l_bmb     RECORD LIKE bmb_file.*  #NO.FUN-850086
   DEFINE l_sta     RECORD LIKE sta_file.*  #NO.FUN-850086
   DEFINE l_stb     RECORD LIKE stb_file.*  #NO.FUN-850086
   DEFINE l_ima02   LIKE ima_file.ima02     #NO.FUN-850086
   DEFINE l_ima08   LIKE ima_file.ima08     #NO.FUN-850086
   DEFINE l_ima021  LIKE ima_file.ima021    #NO.FUN-850086
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #NO.FUN-850086----BEGIN-----
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ? ,?, ?, ? )"  #FUN-C50075                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,            
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"   #FUN-C50075                    
     PREPARE insert_prep1 FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1)                                    
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM                                                            
     END IF
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     #CALL cl_outnam('asdr020') RETURNING l_name
     #START REPORT r020_rep TO l_name
     #LET g_pageno = 0
     #NO.FUN-850056----END-------
#--------------------------------------------------------------------
     IF tm.bmonth=12 THEN
        LET tm.dd=MDY(12,31,tm.byear)
     ELSE
        LET tm.dd=MDY(tm.bmonth+1,1,tm.byear)-1
     END IF
 
    #LET l_sql = " SELECT * FROM bmb_file ",               #MOD-C50140 mark
     LET l_sql = " SELECT * FROM bmb_file,ima_file ",      #MOD-C50140 add
                 "  WHERE bmb01= ? ",
                 "    AND bmb29= ? ",  #FUN-C50075
                 "    AND bmb01=ima01 AND bmb29=ima910 ",  #MOD-C50140 add 
                 "    AND (bmb04 <='",tm.dd,"' OR bmb04 IS NULL) ",
                 "    AND (bmb05 >'",tm.dd,"' OR bmb05 IS NULL)",
                 "  ORDER BY bmb03 "
 
     PREPARE bmb_prebmb   FROM l_sql
     IF STATUS THEN CALL cl_err('prebmb:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE bmb_cur CURSOR FOR bmb_prebmb  
 
    #LET l_sql = " SELECT sta01,ima02,ima08",          #FUN-5A0059 mark
     LET l_sql = " SELECT sta01,ima02,ima021,ima08,ima910",   #FUN-5A0059  #FUN-C50075
                 " FROM sta_file,ima_file ",
                 " WHERE ima01 = sta01 AND ", tm.wc CLIPPED,
                 " ORDER BY 1 "
 
     PREPARE r020_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM
     END IF
     DECLARE r020_curs1 CURSOR FOR r020_prepare1
     FOREACH r020_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #NO.FUN-850086----BEGIN----
       SELECT * INTO l_stb.* FROM stb_file
           WHERE stb01=sr.sta01 AND stb02=tm.byear AND stb03=tm.bmonth
       IF SQLCA.sqlcode  THEN
          LET l_stb.stb07=0 LET l_stb.stb08=0
          LET l_stb.stb09=0 LET l_stb.stb09a=0
       END IF
 
       LET l_stb.stb04=l_stb.stb07+l_stb.stb08+l_stb.stb09
                       -l_stb.stb05 -l_stb.stb06
       SELECT * INTO l_sta.* FROM sta_file WHERE sta01=sr.sta01
       LET l_sum = l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a
 
       EXECUTE insert_prep USING sr.sta01,sr.ima08,sr.ima02,sr.ima021,
                                 l_stb.stb07,l_stb.stb08,l_stb.stb09,
                                 l_stb.stb09a,l_sum,l_stb.stb04,l_stb.stb05,
                                 l_stb.stb06,l_stb.stb06a,l_sta.sta03,l_sta.sta05,
                                 l_sta.sta08,l_sta.sta09,l_sta.sta06,l_sta.sta06a
                                 ,sr.ima910  #FUN-C50075
       INITIALIZE l_stb.* TO NULL
       INITIALIZE l_sta.* TO NULL
       
       FOREACH bmb_cur USING sr.sta01,sr.ima910 INTO l_bmb.*   #FUN-C50075
          IF SQLCA.sqlcode THEN 
             CALL cl_err('bmb_cur',SQLCA.sqlcode,0)   
             EXIT FOREACH 
          END IF 
      
          SELECT ima02,ima021,ima08 INTO l_ima02,l_ima021,l_ima08
             FROM ima_file WHERE ima01=l_bmb.bmb03
          IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
 
          SELECT * INTO l_stb.* FROM stb_file
             WHERE stb01=l_bmb.bmb03 AND stb02=tm.byear AND stb03=tm.bmonth
          IF SQLCA.sqlcode  THEN
             LET l_stb.stb07=0 LET l_stb.stb08=0
             LET l_stb.stb09=0 LET l_stb.stb09a=0
          END IF
          LET l_fg=(l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a)
                  *l_bmb.bmb06/l_bmb.bmb07
          LET l_sum = l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a
          LET l_mod = l_bmb.bmb06/l_bmb.bmb07
          EXECUTE insert_prep1 USING sr.sta01,l_bmb.bmb03,l_ima08,l_ima02,
                                     l_ima021,l_stb.stb07,l_stb.stb08,l_stb.stb09,
                                     l_stb.stb09a,l_sum,l_mod,l_fg
                                     ,sr.ima910  #FUN-C50075
          INITIALIZE l_stb.* TO NULL
       END FOREACH
       #MESSAGE sr.sta01 
       #CALL ui.Interface.refresh()
       #OUTPUT TO REPORT r020_rep(sr.*)
       #NO.FUN-850089----END------
     END FOREACH
     #NO.FUN-850089----BEGIN-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'sta01,ima12,ima06,ima08')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str=tm.wc,";",g_azi04,";",tm.byear,";",tm.bmonth
     CALL cl_prt_cs3('asdr020','asdr020',g_sql,g_str)
     #FINISH REPORT r020_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-850089----END-------
END FUNCTION
#NO.FUN-850086-----BEGIN------
#REPORT r020_rep(sr)
#  DEFINE l_str         LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
#         l_last_sw     LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_ima02       LIKE ima_file.ima02,
#         l_ima021      LIKE ima_file.ima021,   #FUN-5A0059
#         l_ima08       LIKE ima_file.ima08,
#         l_fg          LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
#         l_bmb         RECORD LIKE bmb_file.*,
#         l_sta         RECORD LIKE sta_file.*,
#         l_stb         RECORD LIKE stb_file.*,
#         sr            RECORD 
#                       sta01  LIKE sta_file.sta01,
#                       ima02  LIKE ima_file.ima02, 
#                       ima021 LIKE ima_file.ima021,   #FUN-5A0059 
#                       ima08  LIKE ima_file.ima08,
#                       stb07  LIKE stb_file.stb07, 
#                       stb08  LIKE stb_file.stb08, 
#                       stb09  LIKE stb_file.stb09, 
#                       stb09a LIKE stb_file.stb09a 
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.sta01
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[10] CLIPPED,tm.byear USING '####','/',tm.bmonth USING '&&'
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED
#          ,g_x[41] CLIPPED   #FUN-5A0059
#     PRINT g_dash1
 
#  BEFORE GROUP OF sr.sta01
#     SKIP TO TOP OF PAGE
 
#  ON EVERY ROW 
#       SELECT * INTO l_stb.* FROM stb_file
#        WHERE stb01=sr.sta01 AND stb02=tm.byear AND stb03=tm.bmonth
#        IF SQLCA.sqlcode  THEN
#           LET l_stb.stb07=0 LET l_stb.stb08=0
#           LET l_stb.stb09=0 LET l_stb.stb09a=0
#        END IF
 
#     #-->本階材料定義 = 累計(直接材料 + 直接人工 + 製造費用)
#     #                - 本階投入(人工) - 本階投入(製費)
#     LET l_stb.stb04=l_stb.stb07+l_stb.stb08+l_stb.stb09
#                      -l_stb.stb05 -l_stb.stb06
#     PRINT COLUMN g_c[31],sr.sta01,
#           COLUMN g_c[32],sr.ima08,
#           COLUMN g_c[33],sr.ima02,
#   #start FUN-5A0059
#           COLUMN g_c[34],sr.ima021,
#           COLUMN g_c[35],cl_numfor(l_stb.stb07 ,35,g_azi04),   #累計直接材料
#           COLUMN g_c[35],cl_numfor(l_stb.stb08 ,36,g_azi04),   #累計直接人工
#           COLUMN g_c[37],cl_numfor(l_stb.stb09 ,37,g_azi04),   #累計製造費用
#           COLUMN g_c[38],cl_numfor(l_stb.stb09a,38,g_azi04),  #累計其他費用
#           COLUMN g_c[39],cl_numfor(l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a ,39,g_azi04), 
#           COLUMN g_c[40],g_x[14] CLIPPED
 
#     PRINT COLUMN g_c[35],cl_numfor(l_stb.stb04 ,35,g_azi04), #本階直接材料
#           COLUMN g_c[36],cl_numfor(l_stb.stb05 ,36,g_azi04), #本階直接人工
#           COLUMN g_c[37],cl_numfor(l_stb.stb06 ,37,g_azi04), #本階製造費用
#           COLUMN g_c[38],cl_numfor(l_stb.stb06a,38,g_azi04), #本階其他費用
#           COLUMN g_c[40],g_x[15] CLIPPED
#    #end FUN-5A0059
#     PRINT ' '
#     SELECT * INTO l_sta.* FROM sta_file WHERE sta01=sr.sta01
#     #-->列印下階料號
#     FOREACH bmb_cur USING sr.sta01 INTO l_bmb.*
#       IF SQLCA.sqlcode THEN 
#          CALL cl_err('bmb_cur',SQLCA.sqlcode,0)   
#          EXIT FOREACH 
#       END IF 
#      #SELECT ima02,ima08 INTO l_ima02,l_ima08                   #FUN-5A0059 mark
#       SELECT ima02,ima021,ima08 INTO l_ima02,l_ima021,l_ima08   #FUN-5A0059
#         FROM ima_file WHERE ima01=l_bmb.bmb03
#       IF SQLCA.sqlcode THEN CONTINUE FOREACH END IF
 
#       SELECT * INTO l_stb.* FROM stb_file
#        WHERE stb01=l_bmb.bmb03 AND stb02=tm.byear AND stb03=tm.bmonth
#       IF SQLCA.sqlcode  THEN
#          LET l_stb.stb07=0 LET l_stb.stb08=0
#          LET l_stb.stb09=0 LET l_stb.stb09a=0
#       END IF
#       LET l_fg=(l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a)
#                 *l_bmb.bmb06/l_bmb.bmb07
#       PRINT COLUMN g_c[31],l_bmb.bmb03,
#             COLUMN g_c[32],l_ima08,
#             COLUMN g_c[33],l_ima02,
#            #start FUN-5A0059
#             COLUMN g_c[34],l_ima021,   
#             COLUMN g_c[35],cl_numfor(l_stb.stb07, 35,g_azi04),  
#             COLUMN g_c[36],cl_numfor(l_stb.stb08, 36,g_azi04),
#             COLUMN g_c[37],cl_numfor(l_stb.stb09, 37,g_azi04),
#             COLUMN g_c[38],cl_numfor(l_stb.stb09a,38,g_azi04),
#             COLUMN g_c[39],cl_numfor(l_stb.stb07+l_stb.stb08+l_stb.stb09+l_stb.stb09a ,39,g_azi04), 
#             COLUMN g_c[40],cl_numfor(l_bmb.bmb06/l_bmb.bmb07,40,2), 
#             COLUMN g_c[41],cl_numfor(l_fg,41,g_azi04) 
#            #end FUN-5A0059
 
#     END FOREACH
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN g_c[31],g_x[16] CLIPPED,COLUMN g_c[32],l_sta.sta03 USING '####&.&&&&&',
#           COLUMN g_c[33],g_x[17] CLIPPED,COLUMN g_c[34],l_sta.sta05 USING '##,##&.&&'
#     PRINT COLUMN g_c[31],g_x[18] CLIPPED,COLUMN g_c[32],l_sta.sta08 USING '#,##&.&&',  
#           COLUMN g_c[33],g_x[19] CLIPPED,COLUMN g_c[34],l_sta.sta09 USING '##,##&.&&'
#     PRINT COLUMN g_c[31],g_x[20] CLIPPED,COLUMN g_c[32],l_sta.sta06 USING '#,##&.&&',  
#           COLUMN g_c[33],g_x[21] CLIPPED,COLUMN g_c[34],l_sta.sta06a USING '##,##&.&&'
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-850086----END------
#No.FUN-870144
