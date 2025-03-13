# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aapr802.4gl
# Descriptions...: 提單費用分攤表
# Date & Author..: 96/01/05  By  Roger
# Modify.........: No.FUN-4C0097 05/01/04 By Nicola 報表架構修改
#                                                   增加列印品名ima02、規格ima021
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0128 06/11/27 By Rayven "接下頁" "結束"位置有誤
# Modify.........: No.FUN-7A0025 07/10/16 By mike 報表輸出修改為Crystal Reports
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                      # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition  #No.FUN-690028 VARCHAR(600)
              yymm    LIKE type_file.chr8,          # No.FUN-690028 VARCHAR(6),         #

              fee     LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),         # 分攤費用來源(1)依<   實際  >分攤
                                       #             (2)依<實際-預估>分攤
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
           END RECORD,
       g_als41   LIKE als_file.als41,
       g_als42   LIKE als_file.als42,
       g_als43   LIKE als_file.als43,
       g_als44   LIKE als_file.als44,
       g_als45   LIKE als_file.als45,
       g_als46   LIKE als_file.als46,
       g_cost    LIKE als_file.als46
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
DEFINE l_table   STRING                        #No.FUN-7A0025
DEFINE g_sql     STRING                        #No.FUN-7A0025
DEFINE g_str     STRING                        #No.FUN-7A0025
 
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
   
   #No.FUN-7A0025 -STR
   LET g_sql = "part.alt_file.alt11,",                                                                                
               "qty.alt_file.alt06,",                                                                                
               "cost.alt_file.alt07,",                                                                                
               "ima02.ima_file.ima02,",                                                                                
               "ima021.ima_file.ima021,",
               "g_als41.als_file.als41,",
               "g_als42.als_file.als42,",
               "g_als43.als_file.als43,",
               "g_als44.als_file.als44,",
               "g_als45.als_file.als45,",
               "g_als46.als_file.als46,",
               "g_cost.als_file.als46"
 
   LET l_table = cl_prt_temptable('aapr802',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)
      EXIT PROGRAM
   END IF
   #No.FUN-7A0025 -END
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yymm = ARG_VAL(8)
   LET tm.fee  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r802_tm(0,0)
   ELSE
      CALL r802()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r802_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r802_w AT p_row,p_col
     WITH FORM "aap/42f/aapr802"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yymm = TODAY USING 'yyyymm'
   LET tm.fee  = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON als01,als02,als04
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm.yymm,tm.fee,tm.more WITHOUT DEFAULTS
 
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
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         CLOSE WINDOW r802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr802'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr802','9031',1)
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
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.yymm CLIPPED,"'",   #TQC-610053
                        " '",tm.fee CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr802',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r802()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r802_w
 
END FUNCTION
 
FUNCTION r802()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_order   ARRAY[5] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
          als       RECORD LIKE als_file.*,
          alk       RECORD LIKE alk_file.*,
          alt       RECORD LIKE alt_file.*,
          sr        RECORD
                       part     LIKE alt_file.alt11,
                       qty      LIKE alt_file.alt06,
                       cost     LIKE alt_file.alt07,
                       ima02    LIKE ima_file.ima02,
                       ima021   LIKE ima_file.ima021
                    END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   
   CALL cl_del_data(l_table)                    #No.FUN-7A0025
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog      #No.FUN-7A0025
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alsuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alsgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alsgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alsuser', 'alsgrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT als_file.*, alk_file.* FROM als_file, OUTER alk_file",
               " WHERE als_file.als01=alk_file.alk01 AND ", tm.wc CLIPPED,
               "   AND alsfirm <> 'X' ", #CHI-C80041
               "   AND alkfirm <> 'X' "  #CHI-C80041
 
   PREPARE r802_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r802_curs1 CURSOR FOR r802_prepare1
 
   #CALL cl_outnam('aapr802') RETURNING l_name           #No.FUN-7A0025
   #START REPORT r802_rep TO l_name                      #No.FUN-7A0025
 
   LET g_pageno = 0
   LET g_als41=0
   LET g_als42=0
   LET g_als43=0
   LET g_als44=0
   LET g_als45=0
   LET g_als46=0
   LET g_cost =0
   FOREACH r802_curs1 INTO als.*, alk.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF alk.alk42 = 0 OR alk.alk42 IS NULL THEN LET alk.alk42=1 END IF
      IF als.als31 IS NULL THEN LET als.als31=0 END IF
      IF als.als32 IS NULL THEN LET als.als32=0 END IF
      IF als.als33 IS NULL THEN LET als.als33=0 END IF
      IF als.als34 IS NULL THEN LET als.als34=0 END IF
      IF als.als35 IS NULL THEN LET als.als35=0 END IF
      IF als.als36 IS NULL THEN LET als.als36=0 END IF
      IF als.als41 IS NULL THEN LET als.als41=0 END IF
      IF als.als42 IS NULL THEN LET als.als42=0 END IF
      IF als.als43 IS NULL THEN LET als.als43=0 END IF
      IF als.als44 IS NULL THEN LET als.als44=0 END IF
      IF als.als45 IS NULL THEN LET als.als45=0 END IF
      IF als.als46 IS NULL THEN LET als.als46=0 END IF
      IF als.als41m!=tm.yymm OR als.als41m IS NULL THEN LET als.als31=0 END IF
      IF als.als42m!=tm.yymm OR als.als42m IS NULL THEN LET als.als32=0 END IF
      IF als.als43m!=tm.yymm OR als.als43m IS NULL THEN LET als.als33=0 END IF
      IF als.als44m!=tm.yymm OR als.als44m IS NULL THEN LET als.als34=0 END IF
      IF als.als45m!=tm.yymm OR als.als45m IS NULL THEN LET als.als35=0 END IF
      IF als.als46m!=tm.yymm OR als.als46m IS NULL THEN LET als.als36=0 END IF
      IF als.als41m!=tm.yymm OR als.als41m IS NULL THEN LET als.als41=0 END IF
      IF als.als42m!=tm.yymm OR als.als42m IS NULL THEN LET als.als42=0 END IF
      IF als.als43m!=tm.yymm OR als.als43m IS NULL THEN LET als.als43=0 END IF
      IF als.als44m!=tm.yymm OR als.als44m IS NULL THEN LET als.als44=0 END IF
      IF als.als45m!=tm.yymm OR als.als45m IS NULL THEN LET als.als45=0 END IF
      IF als.als46m!=tm.yymm OR als.als46m IS NULL THEN LET als.als46=0 END IF
 
      IF tm.fee='2' THEN
         LET als.als41=als.als41-als.als31
         LET als.als42=als.als42-als.als32
         LET als.als43=als.als43-als.als33
         LET als.als44=als.als44-als.als34
         LET als.als45=als.als45-als.als35
         LET als.als46=als.als46-als.als36
      END IF
 
      IF als.als41=0 AND als.als42=0 AND als.als43=0 AND
         als.als44=0 AND als.als45=0 AND als.als46=0 THEN
         CONTINUE FOREACH
      END IF
 
      LET g_als41=g_als41+als.als41
      LET g_als42=g_als42+als.als42
      LET g_als43=g_als43+als.als43
      LET g_als44=g_als44+als.als44
      LET g_als45=g_als45+als.als45
      LET g_als46=g_als46+als.als46
 
      DECLARE c2 CURSOR FOR SELECT * FROM alt_file
                             WHERE alt01 = als.als01
 
      FOREACH c2 INTO alt.*
         LET sr.part=alt.alt11
         LET sr.qty =alt.alt06
         LET sr.cost=alt.alt07
         LET g_cost =g_cost + sr.cost
 
         SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
          WHERE ima01 = sr.part
 
         #OUTPUT TO REPORT r802_rep(sr.*)         #No.FUN-7A0025
         
         EXECUTE insert_prep USING sr.part,sr.qty,sr.cost,sr.ima02,sr.ima021,   #No.FUN-7A0025
                 g_als41,g_als42,g_als43,g_als44,g_als45,g_als46,g_cost         #No.FUN-7A0025
 
      END FOREACH
   END FOREACH
 
   #No.FUN-7A0025 -str
   #FINISH REPORT r802_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str clipped,l_table CLIPPED
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'als01,als02,als04')
      RETURNING tm.wc
   END IF
   LET g_str = ''
   LET g_str = tm.wc,';',tm.yymm[1,4],';',tm.yymm[5,6],';',g_azi04,';',g_azi05
   CALL cl_prt_cs3("aapr802","aapr802",g_sql,g_str)
   #No.FUN-7A0025 -end
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
 
END FUNCTION
 
#No.FUN-7A0025 -str
{
REPORT r802_rep(sr)
   DEFINE l_fee1        LIKE als_file.als41
   DEFINE l_fee2        LIKE als_file.als42
   DEFINE l_fee3        LIKE als_file.als43
   DEFINE l_fee4        LIKE als_file.als44
   DEFINE l_fee5        LIKE als_file.als45
   DEFINE l_fee6        LIKE als_file.als46
   DEFINE l_fee         LIKE als_file.als41
   DEFINE l_tot1        LIKE als_file.als41
   DEFINE l_tot2        LIKE als_file.als42
   DEFINE l_tot3        LIKE als_file.als43
   DEFINE l_tot4        LIKE als_file.als44
   DEFINE l_tot5        LIKE als_file.als45
   DEFINE l_tot6        LIKE als_file.als46
   DEFINE l_tot         LIKE als_file.als41
   DEFINE l_cost        LIKE alt_file.alt07
   DEFINE l_last_sw     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE sr            RECORD
                           part     LIKE alt_file.alt11,
                           qty      LIKE alt_file.alt06,
                           cost     LIKE alt_file.alt07,
                           ima02    LIKE ima_file.ima02,
                           ima021   LIKE ima_file.ima021
                        END RECORD
   DEFINE g_head1       STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.part
 
   FORMAT
      PAGE HEADER
         IF PAGENO=1 THEN
            LET l_tot1 = 0
            LET l_tot2 = 0
            LET l_tot3 = 0
            LET l_tot4 = 0
            LET l_tot5 = 0
            LET l_tot6 = 0
            LET l_tot  = 0
         END IF
 
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,tm.yymm[1,4],"/",tm.yymm[5,6]
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      AFTER GROUP OF sr.part
         LET l_cost = GROUP SUM(sr.cost)
         LET l_fee1 = g_als41 * l_cost / g_cost
         LET l_fee2 = g_als42 * l_cost / g_cost
         LET l_fee3 = g_als43 * l_cost / g_cost
         LET l_fee4 = g_als44 * l_cost / g_cost
         LET l_fee5 = g_als45 * l_cost / g_cost
         LET l_fee6 = g_als46 * l_cost / g_cost
         LET l_fee  = l_fee1 + l_fee2 + l_fee3 + l_fee4 + l_fee5 + l_fee6
         LET l_tot1 = l_tot1 + l_fee1
         LET l_tot2 = l_tot2 + l_fee2
         LET l_tot3 = l_tot3 + l_fee3
         LET l_tot4 = l_tot4 + l_fee4
         LET l_tot5 = l_tot5 + l_fee5
         LET l_tot6 = l_tot6 + l_fee6
         LET l_tot  = l_tot  + l_fee
 
         PRINT COLUMN g_c[31],sr.part,
               COLUMN g_c[32],sr.ima02,
               COLUMN g_c[33],sr.ima021,
               COLUMN g_c[34],GROUP SUM(sr.qty) USING '###########.##&',
               COLUMN g_c[35],cl_numfor(l_fee1,35,g_azi04),
               COLUMN g_c[36],cl_numfor(l_fee2,36,g_azi04),
               COLUMN g_c[37],cl_numfor(l_fee3,37,g_azi04),
               COLUMN g_c[38],cl_numfor(l_fee4,38,g_azi04),
               COLUMN g_c[39],cl_numfor(l_fee5,39,g_azi04),
               COLUMN g_c[40],cl_numfor(l_fee6,40,g_azi04),
               COLUMN g_c[41],cl_numfor(l_fee,41,g_azi05)
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT COLUMN g_c[33],g_x[10] CLIPPED,
               COLUMN g_c[35],cl_numfor(l_tot1,35,g_azi04),
               COLUMN g_c[36],cl_numfor(l_tot2,36,g_azi04),
               COLUMN g_c[37],cl_numfor(l_tot3,37,g_azi04),
               COLUMN g_c[38],cl_numfor(l_tot4,38,g_azi04),
               COLUMN g_c[39],cl_numfor(l_tot5,39,g_azi04),
               COLUMN g_c[40],cl_numfor(l_tot6,40,g_azi04),
               COLUMN g_c[41],cl_numfor(l_tot,41,g_azi05)
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[41],g_x[7] CLIPPED   #No.TQC-6B0128 mark
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-6B0128
         PRINT
         PRINT COLUMN g_c[31],g_x[11] CLIPPED,
               COLUMN g_c[33],g_x[12] CLIPPED,
               COLUMN g_c[35],g_x[13] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[42],g_x[6] CLIPPED   #No.TQC-6B0128 mark
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-6B0128
            PRINT g_dash[1,g_len]
            PRINT
            PRINT COLUMN g_c[31],g_x[11] CLIPPED,
                  COLUMN g_c[33],g_x[12] CLIPPED,
                  COLUMN g_c[35],g_x[13] CLIPPED
         ELSE
            SKIP 4 LINE
         END IF
 
END REPORT
}
#No.FUN-7A0025 -end
