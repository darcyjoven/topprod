# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr811.4gl
# Descriptions...: 到貨到單未匹配明細表
# Date & Author..: 95/12/15  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 05/01/05 By Nicola 報表架構修改
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.TQC-6B0128 06/11/27 By Rayven "接下頁" "結束"位置有誤
# Modify.........: No.FUN-750093 07/05/25 By zhoufeng CR報表打印
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.MOD-BC0284 11/12/29 By Polly 讀取條件時，先清除暫存table
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                      # Print condition RECORD
                 wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
                 bno,eno LIKE type_file.chr8,        # No.FUN-690028 VARCHAR(8),         #
                 a,b     LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
                 more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
   DEFINE g_sql     STRING                          #No.FUN-750093
   DEFINE l_table   STRING                          #No.FUN-750093
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
#No.FUN-750093 --start--
   LET g_sql ="alk05.alk_file.alk05,chr8.type_file.chr8,alk02.alk_file.alk02,",
              "alk01.alk_file.alk01,alk07.alk_file.alk07,alk03.alk_file.alk03,",
              "alk11.alk_file.alk11,alk12.alk_file.alk12,alk13.alk_file.alk13,",
              "pmc03.pmc_file.pmc03,azi04.azi_file.azi04,azi07.azi_file.azi07"   #No.FUN-870151
 
   LET l_table = cl_prt_temptable('aapr811',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"                                #No.FUN-870151 Add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   #LET tm.wc = ARG_VAL(7)   #TQC-610053
   LET tm.bno = ARG_VAL(7)   #TQC-610053
   LET tm.eno = ARG_VAL(8)   #TQC-610053
   LET tm.a = ARG_VAL(9)     #TQC-610053
   LET tm.b = ARG_VAL(10)    #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r811_tm(0,0)
   ELSE
      CALL r811()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r811_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 24
   OPEN WINDOW r811_w AT p_row,p_col
     WITH FORM "aap/42f/aapr811"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bno = '0'
   LET tm.eno = 'z'
   LET tm.a   = 'Y'
   LET tm.b   = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      INPUT BY NAME tm.bno,tm.eno,tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
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
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r811_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr811'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr811','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        #" '",tm.wc CLIPPED,"'",   #TQC-610053
                        " '",tm.bno CLIPPED,"'",   #TQC-610053
                        " '",tm.eno CLIPPED,"'",   #TQC-610053
                        " '",tm.a CLIPPED,"'",   #TQC-610053
                        " '",tm.b CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr811',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r811_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r811()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r811_w
 
END FUNCTION
 
FUNCTION r811()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          sr        RECORD vendor    LIKE alk_file.alk05,
#                          type      LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(4)#No.FUN-750093
                           type      LIKE type_file.chr8,
                           date1     LIKE alk_file.alk02,
                           no1       LIKE alk_file.alk01,
                           no2       LIKE alk_file.alk07,
                           lc        LIKE alk_file.alk03,
                           curr      LIKE alk_file.alk11,
                           ex        LIKE alk_file.alk12,
                           amt       LIKE alk_file.alk13,
                           pmc03     LIKE pmc_file.pmc03
                    END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   CALL cl_del_data(l_table)           #MOD-BC0284
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alkuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alkgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alkgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alkuser', 'alkgrup')
   #End:FUN-980030
 
#No.FUN-750093 --mark--
#   CALL cl_outnam('aapr811') RETURNING l_name
#   START REPORT r811_rep TO l_name
#
#   LET g_pageno = 0
 
   IF tm.a='Y' THEN         #到貨
      DECLARE r811_c1 CURSOR FOR SELECT alk05,'',alk02,alk01,alk07,alk03,
                                        alk11,alk12,alk13-alk33,''
                                   FROM alk_file
                                  WHERE alk05 BETWEEN tm.bno AND tm.eno
                                    AND alk07 IS NULL
                                    AND alk13 > alk33
                                    AND alkfirm <> 'X'  #CHI-C80041
 
      FOREACH r811_c1 INTO sr.*
#        LET sr.type = g_x[20] CLIPPED         #No.FUN-750093
         LET sr.type = 'Y' CLIPPED
 
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file
          WHERE pmc01=sr.vendor
#No.FUN-750093 --start--
         SELECT azi04,azi07      #No.FUN-870151 add azi07                                              
           INTO t_azi04,t_azi07  #No.FUN-870151 add azi07                       
           FROM azi_file                                                        
          WHERE azi01=sr.curr    
#No.FUN-750093 --end--                                            
 
#         OUTPUT TO REPORT r811_rep(sr.*)     #No.FUN-750093
#No.FUN-750093 --strat--
   EXECUTE insert_prep USING sr.vendor,sr.type,sr.date1,sr.no1,sr.no2,sr.lc,
                             sr.curr,sr.ex,sr.amt,sr.pmc03,t_azi04,t_azi07 #No.FUN-870151 add azi07
 
#No.FUN-750093 --end--
 
      END FOREACH
   END IF
 
   IF tm.b='Y' THEN
      DECLARE r811_c2 CURSOR FOR SELECT alh05,'',alh02,alh01,alh30,alh03,
                                        alh11,alh15,alh12-alh17,''
                                   FROM alh_file
                                  WHERE alh05 BETWEEN tm.bno AND tm.eno
                                    AND alh32 = 0
                                    AND alh12 > alh17
 
      FOREACH r811_c2 INTO sr.*
#         LET sr.type = g_x[21] CLIPPED        #No.FUN-750093
         LET sr.type = 'N' CLIPPED    
 
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file
          WHERE pmc01=sr.vendor
#No.FUN-750093 --start--                                                        
         SELECT azi04,azi07      #No.FUN-870151 add azi07                                              
           INTO t_azi04,t_azi07  #No.FUN-870151 add azi07                                                         
           FROM azi_file                                                        
          WHERE azi01=sr.curr                                                   
#No.FUN-750093 --end--                                                      
 
#         OUTPUT TO REPORT r811_rep(sr.*)     #No.FUN-750093
#No.FUN-750093 --strat--     
   EXECUTE insert_prep USING sr.vendor,sr.type,sr.date1,sr.no1,sr.no2,sr.lc,          
                             sr.curr,sr.ex,sr.amt,sr.pmc03,t_azi04,t_azi07 #No.FUN-870151 add azi07                                                     
#No.FUN-750093 --end--                                                        
 
 
      END FOREACH
   END IF
 
#   FINISH REPORT r811_rep                   #No.FUN-750093
#No.FUN-750093 --add--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   LET l_sql = "SELECT * FROM " , g_cr_db_str CLIPPED,l_table CLIPPED
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)#No.FUN-750093
     CALL cl_prt_cs3('aapr811','aapr811',l_sql,'')
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
#No.FUN-750093 --start-- --mark--
{REPORT r811_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr        RECORD vendor    LIKE alk_file.alk05,
                           type      LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(4),
                           date1     LIKE alk_file.alk02,
                           no1       LIKE alk_file.alk01,
                           no2       LIKE alk_file.alk07,
                           lc        LIKE alk_file.alk03,
                           curr      LIKE alk_file.alk11,
                           ex        LIKE alk_file.alk12,
                           amt       LIKE alk_file.alk13,
                           pmc03     LIKE pmc_file.pmc03
                    END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.vendor, sr.date1
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.vendor
         PRINT COLUMN g_c[31],g_x[16] CLIPPED,
               COLUMN g_c[32],sr.vendor,
               COLUMN g_c[33],sr.pmc03
         PRINT
 
      ON EVERY ROW
         SELECT azi03,azi04,azi05
#          INTO g_azi03,g_azi04,g_azi05   #NO.CHI-6A0004
           INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
           FROM azi_file
          WHERE azi01=sr.curr
 
         PRINT COLUMN g_c[31],sr.type,
               COLUMN g_c[32],sr.date1,
               COLUMN g_c[33],sr.no1,
               COLUMN g_c[34],sr.no2,
               COLUMN g_c[35],sr.lc,
               COLUMN g_c[36],sr.curr,
               COLUMN g_c[37],sr.ex USING '#####.####',
#              COLUMN g_c[38],cl_numfor(sr.amt,38,g_azi04)   #NO.CHI-6A0004
               COLUMN g_c[38],cl_numfor(sr.amt,38,t_azi04)   #NO.CHI-6A0004
 
      AFTER GROUP OF sr.vendor
         PRINT g_dash2[1,g_len]
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[7] CLIPPED   #No.TQC-6B0128 mark
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-6B0128
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[6] CLIPPED   #No.TQC-6B0128 mark
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-6B0128
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-750093 --end--
