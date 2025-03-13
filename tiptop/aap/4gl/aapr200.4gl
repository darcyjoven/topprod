# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapr200.4gl
# Desc/riptions..: 個人費用轉帳明細表
# Date & Author..: 97/12/16 By Melody
# Modify.........: No.FUN-4C0097 05/01/06 By Nicola 報表架構修改
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690080 06/10/11 By douzh 零用金作業修改(增加apf03員工編號欄位)   
 
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.TQC-6C0172 06/12/27 By wujie 調整“接下頁/結束”位置
# Modify.........: No.CHI-780046 07/09/10 By sherry  新增時，員工編號帶不到資料
     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc        LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
              apf43     LIKE type_file.dat      #No.FUN-690028 DATE
           END RECORD
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8               #No.FUN-6A0055
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                       # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.apf43 = ARG_VAL(8)   #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r110_tm(0,0)
   ELSE
      CALL aapr200()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col      LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd            LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r110_w AT p_row,p_col
     WITH FORM "aap/42f/aapr200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON apf02,apf03,apf12   #No.FUN-690080--add apf03
 
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
#No.FUN-690080 --start--                                                                                                            
      ON ACTION CONTROLP                                                                                                            
            IF INFIELD(apf03) THEN                                                                                                  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"      
               #LET g_qryparam.form = "q_cpf"        #No.CHI-780046                                                                                        
               LET g_qryparam.form = "q_gen"         #No.CHI-780046                                                                               
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO apf03                                                                                 
               NEXT FIELD apf03                                                                                                     
            END IF                                                                                                                  
#No.FUN-690080 --end--
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
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.apf43
 
      INPUT BY NAME tm.apf43 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD apf43
            IF cl_null(tm.apf43) THEN
               NEXT FIELD apf43
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
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
         CLOSE WINDOW r200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr200'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr200','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.apf43 CLIPPED,"'",   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr200',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr200()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r110_w
 
END FUNCTION
 
FUNCTION aapr200()
   DEFINE l_name      LIKE type_file.chr20,   #No.FUN-690028 VARCHAR(20)
#         l_time      LIKE type_file.chr8,    #No.FUN-690028 VARCHAR(8)
          l_sql       LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(1200)
          sr          RECORD
                         apf12    LIKE apf_file.apf12,
#                        pmc01    LIKE pmc_file.pmc01,   #No.FUN-690080
#                        pmc56    LIKE pmc_file.pmc56,   #No.FUN-690080
                         #No.CHI-780046---Begin
                         #cpf01   LIKE cpf_file.cpf01,   #No.FUN-690080  #No.CHI-780046
                         gen01    LIKE gen_file.gen01,   #No.CHI-780046
                         #cpf42    LIKE cpf_file.cpf42,   #No.FUN-690080    #TQC-B90211
                         #No.CHI-780046---End
                         apf10    LIKE apf_file.apf10
                      END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apfuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
   #End:FUN-980030
 
#No.FUN-690080 --start--
#  LET l_sql = "SELECT  apf12,pmc01,pmc56,apf10",
#              " FROM apf_file,pmc_file",
#              " WHERE apf03=pmc01 AND apf43='",tm.apf43,"'",
#              "   AND pmc14 = '3'",
#              "   AND apf41 <> 'X' ",
#              "   AND ",tm.wc CLIPPED
#No.CHI-780046---Begin  
#  LET l_sql = "SELECT  apf12,cpf01,cpf42,apf10",                                                                                   
#              " FROM apf_file,cpf_file",                                                                                           
#              " WHERE apf03=cpf01 ",
#              "   AND apf43='",tm.apf43,"'",                                                                       
#              "   AND apf41 <> 'X' ",                                                                                              
#              "   AND ",tm.wc CLIPPED
   #-----TQC-B90211---------
   #LET l_sql = "SELECT  apf12,gen01,cpf42,apf10",                                                                                   
   #            " FROM apf_file,gen_file,OUTER cpf_file",                                                                                           
   #            " WHERE apf03=gen01 AND gen_file.gen01 = cpf_file.cpf01 ",
   #            "   AND apf43='",tm.apf43,"'",                                                                       
   #            "   AND apf41 <> 'X' ",                                                                                              
   #            "   AND ",tm.wc CLIPPED
   LET l_sql = "SELECT  apf12,gen01,apf10",                                                                                   
               " FROM apf_file,gen_file",                                                                                           
               " WHERE apf03=gen01",
               "   AND apf43='",tm.apf43,"'",                                                                       
               "   AND apf41 <> 'X' ",                                                                                              
               "   AND ",tm.wc CLIPPED
   #-----END TQC-B90211-----
#No.CHI-780046---End
#No.FUN-690080 --end--
 
   DISPLAY l_sql
 
   PREPARE r110_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r110_cs1 CURSOR FOR r110_prepare1
 
   CALL cl_outnam('aapr200') RETURNING l_name
   START REPORT r110_rep TO l_name
 
   LET g_pageno = 0
 
   FOREACH r110_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      OUTPUT TO REPORT r110_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT r110_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105  MARK
 
END FUNCTION
 
REPORT r110_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_sw          LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr            RECORD
                           apf12    LIKE apf_file.apf12,
#                          pmc01    LIKE pmc_file.pmc01,     #No.FUN-690080
#                          pmc56    LIKE pmc_file.pmc56,     #No.FUN-690080
                           #cpf01    LIKE cpf_file.cpf01,    #No.FUN-690080  #No.CHI-780046
                           gen01    LIKE gen_file.gen01,     #No.CHI-780046
                           #cpf42    LIKE cpf_file.cpf42,     #No.FUN-690080   #TQC-B90211
                           apf10    LIKE apf_file.apf10
                        END RECORD
   DEFINE g_head1        STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   #ORDER BY sr.cpf01   #No.FUN-690080  #No.CHI-780046
   ORDER BY sr.gen01    #No.CHI-780046
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,tm.apf43
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      #AFTER GROUP OF sr.cpf01             #No.FUN-690080   #No.CHI-780046
      AFTER GROUP OF sr.gen01              #No.CHI-780046
         PRINT COLUMN g_c[31],sr.apf12,    
               #COLUMN g_c[32],sr.cpf01,   #No.FUN-690080   #No.CHI-780046
               COLUMN g_c[32],sr.gen01,    #No.CHI-780046
               #COLUMN g_c[33],sr.cpf42,    #No.FUN-690080    #TQC-B90211
               COLUMN g_c[33],'',    #No.FUN-690080    #TQC-B90211
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.apf10),34,g_azi04)
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[34],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED      #No.TQC-6C0172
         LET l_last_sw = 'y'
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[34],g_x[6] CLIPPED
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #No.TQC-6C0172
         ELSE
            SKIP 2 LINES
         END IF
 
END REPORT
