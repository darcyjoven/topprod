# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr710.4gl
# Descriptions...: 預付購料明細表列印作業
# Date & Author..: 93/02/05  By  Felicity  Tseng
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.MOD-5A0163 05/10/24 By Dido 料號欄位放大
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.TQC-740305 07/04/29 By Lynn 報表格式修改
# Modify.........: No.TQC-740326 07/04/29 By dxfwo 排列順序第三欄位未有默認值
# Modify.........: No.MOD-750118 07/05/24 By Smapmin 修改列印條件與g_len
# Modify.........: No.FUN-830103 08/03/27 By destiny 報表改為CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              #wc      LIKE type_file.chr1000,      # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc      STRING,       # Where condition   #TQC-630166
              s       LIKE type_file.chr3,          # No.FUN-690028 VARCHAR(3),         # Order by sequence
              t       LIKE type_file.chr3,          # No.FUN-690028 VARCHAR(3),         # Eject sw
              u       LIKE type_file.chr3,          # No.FUN-690028 VARCHAR(3),         # Group total sw
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
#         g_orderA    ARRAY[3] OF VARCHAR(10)  #排序名稱
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)  #排序名稱
                                            #No.FUN-550030
 
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_sma116    LIKE sma_file.sma116      #FUN-710029
DEFINE   g_sma115    LIKE sma_file.sma115      #FUN-710029
#No.FUN-830103--begin--                                                                                                             
   DEFINE g_sql       STRING                                                                                                        
   DEFINE l_table     STRING                                                                                                        
   DEFINE g_str       STRING                                                                                                        
   DEFINE l_title1    STRING                                                                                                        
#No.FUN-830103--end--
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
#No.FUN-830103--begin--                                                                                                             
   LET g_sql= "ala01.ala_file.ala01,",                                                                                              
              "ala02.ala_file.ala02,",                                                                                              
              "ala07.ala_file.ala07,",                                                                                              
              "pmc03.pmc_file.pmc03,",                                                                                              
              "ala04.ala_file.ala04,",                                                                                              
              "ala05.ala_file.ala05,",                                                                                              
              "ala08.ala_file.ala08,",                                                                                              
              "ala20.ala_file.ala20,",                                                                                              
              "ala23.ala_file.ala23,",                                                                                              
              "ala24.ala_file.ala24,",                                                                                              
              "total.ala_file.ala24,",                                                                                              
              "ala25.ala_file.ala25,",                                                                                              
              "ala34.ala_file.ala34,",                                                                                              
              "ala79.ala_file.ala79,",                                                                                              
              "alb02.alb_file.alb02,",                                                                                              
              "alb03.alb_file.alb03,",                                                                                              
              "alb04.alb_file.alb04,",                                                                                              
              "alb05.alb_file.alb05,",                                                                                              
              "alb11.alb_file.alb11,",                                                                                              
              "alb06.alb_file.alb06,",                                                                                              
              "alb86.alb_file.alb86,",                                                                                              
              "alb87.alb_file.alb87,",                                                                                              
              "alb12.alb_file.alb12,",
              "alb13.alb_file.alb13,",                                                                                              
              "alb07.alb_file.alb07,",                                                                                              
              "alb08.alb_file.alb08,",                                                                                              
              "l_str2.type_file.chr1000,",                                                                                          
              "t_azi03.azi_file.azi03,",                                                                                            
              "t_azi04.azi_file.azi04,",                                                                                            
              "t_azi05.azi_file.azi05,",                                                                                            
              "azi05.azi_file.azi05"                                                                                                
   LET l_table = cl_prt_temptable('aapr710',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?,?)"                                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
#No.FUN-830103--end--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file #FUN-710029
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r710_tm(0,0)        # Input print condition
      ELSE CALL r710()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r710_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r710_w AT p_row,p_col
        WITH FORM "aap/42f/aapr710"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.s    = '61'                          
   LET tm.s    = '612'                # TQC-740326                           
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ala01,ala02,ala04,ala05,ala08,ala07
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
      LET INT_FLAG = 0 CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
      LET tm.t = tm2.t1,tm2.t2,tm2.t3
      LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      LET INT_FLAG = 0 CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr710','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aapr710',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r710()
   ERROR ""
END WHILE
   CLOSE WINDOW r710_w
END FUNCTION
 
FUNCTION r710()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,         # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_za05    LIKE type_file.chr1000,      #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ala_file.ala01,            # No.FUN-680137  VARCHAR(16),     #No.FUN-550030
          sr               RECORD order1 LIKE ala_file.ala01,   # No.FUN-680137  VARCHAR(16),     #No.FUN-550030
                                  order2 LIKE ala_file.ala01,   # No.FUN-680137  VARCHAR(16),     #No.FUN-550030
                                  order3 LIKE ala_file.ala01,   # No.FUN-680137  VARCHAR(16),     #No.FUN-550030
                                  ala01 LIKE ala_file.ala01,
                                  ala02 LIKE ala_file.ala02,
                                  ala04 LIKE ala_file.ala04,
                                  ala05 LIKE ala_file.ala05,
                                  ala07 LIKE ala_file.ala07,
                                  pmc03 LIKE pmc_file.pmc03,
                                  ala08 LIKE ala_file.ala08,
                                  ala20 LIKE ala_file.ala20,
                                  ala23 LIKE ala_file.ala23,
                                  ala24 LIKE ala_file.ala24,
                                  ala25 LIKE ala_file.ala25,
                                  ala34 LIKE ala_file.ala34,
                                  ala79 LIKE ala_file.ala79,
                                  total LIKE ala_file.ala24,
                                  alb02 LIKE alb_file.alb02,
                                  alb03 LIKE alb_file.alb03,
                                  alb04 LIKE alb_file.alb04,
                                  alb05 LIKE alb_file.alb05,
                                  alb06 LIKE alb_file.alb06,
                                  alb07 LIKE alb_file.alb07,
                                  alb08 LIKE alb_file.alb08,
                                  alb11 LIKE alb_file.alb11, # 採購單檔
                                  alb12 LIKE alb_file.alb12,
                                  alb13 LIKE alb_file.alb13,
                                  azi03 LIKE azi_file.azi03,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  alb80 LIKE alb_file.alb80,  #FUN-710029
                                  alb81 LIKE alb_file.alb81,  #FUN-710029
                                  alb82 LIKE alb_file.alb82,  #FUN-710029
                                  alb83 LIKE alb_file.alb83,  #FUN-710029
                                  alb84 LIKE alb_file.alb84,  #FUN-710029
                                  alb85 LIKE alb_file.alb85,  #FUN-710029
                                  alb86 LIKE alb_file.alb86,  #FUN-710029
                                  alb87 LIKE alb_file.alb87,  #FUN-710029
                                  pmn20 LIKE pmn_file.pmn20,  #FUN-710029
                                  pmn07 LIKE pmn_file.pmn07,  #FUN-710029
                                  ala97 LIKE ala_file.ala97   #FUN-A60056
                        END RECORD
  DEFINE l_str2       LIKE type_file.chr1000,  #No.FUN-830103                                                                       
         l_ima906     LIKE ima_file.ima906,    #No.FUN-830103                                                                       
         l_ima021     LIKE ima_file.ima021,    #No.FUN-830103                                                                       
         l_alb85      LIKE alb_file.alb85,     #No.FUN-830103                                                                       
         l_alb82      LIKE alb_file.alb82,     #No.FUN-830103                                                                       
         l_pmn20      LIKE pmn_file.pmn20      #No.FUN-830103
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr710'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog          #No.FUN-830103                                               
     CALL cl_del_data(l_table)                                         #No.FUN-830103 
     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 176 END IF
     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 280 END IF   #FUN-710029   #MOD-750118
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 237 END IF    #MOD-750118   #No.FUN-830103 
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR                     #No.FUN-830103  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','', ",
                 " ala01,ala02,ala04,ala05,ala07,pmc03,ala08,",
                 " ala20,ala23,ala24,ala25,ala34,ala79,",
                 " 0, alb02, alb03, alb04, alb05, alb06, alb07, alb08,",
                 " alb11, alb12, alb13, azi03, azi04, azi05,",
                 " alb80, alb81, alb82, alb83, alb84, alb85,alb86,alb87,'','',ala97 ",  #FUN-710029   #FUN-A60056 add ala97
                 " FROM ala_file, alb_file, OUTER pmc_file, OUTER azi_file",
                 " WHERE alb01 = ala01 ",      # 開狀單號
                 "   AND ala_file.ala07 = pmc_file.pmc01 ",  #
                 "   AND alafirm='Y'",
                 "   AND azi_file.azi01 = ala_file.ala20 ",  #
                 "   AND ", tm.wc CLIPPED
#    LET l_sql = l_sql CLIPPED," ORDER BY ala01"
     PREPARE r710_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r710_curs1 CURSOR FOR r710_prepare1
#    LET l_name = 'aapr710.out'
#No.FUN-830103--begin--
#     CALL cl_outnam('aapr710') RETURNING l_name
#FUN-710029 start------#zaa06隱藏否
#    IF g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[35].zaa06 = "N" #計價單位
#        LET g_zaa[36].zaa06 = "N" #計價數量
#        LET g_zaa[34].zaa06 = 'Y' #數量
#    ELSE
#        LET g_zaa[35].zaa06 = "Y" #計價單位
#        LET g_zaa[36].zaa06 = "Y" #計價數量
#        LET g_zaa[34].zaa06 = 'N' #數量
#    END IF
#    IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[37].zaa06 = "N" #單位註解
#    ELSE
#        LET g_zaa[37].zaa06 = "Y" #單位註解
#    END IF
#    #-----MOD-750118---------
#    IF g_sma115='N' THEN
#       LET g_len=194
#    ELSE
#       IF g_sma116 MATCHES '[13]' THEN
#          LET g_len=237
#       ELSE
#          LET g_len=219
#       END IF
#    END IF
  IF g_sma116 MATCHES '[13]' THEN                                                                                                   
     LET l_name = 'aapr710'                                                                                                         
  ELSE                                                                                                                              
     IF g_sma115 = "Y" THEN                                                                                                         
        LET l_name = 'aapr710_1'                                                                                                    
     ELSE                                                                                                                           
        LET l_name = 'aapr710_2'                                                                                                    
     END IF                                                                                                                         
  END IF
    #CALL cl_prt_pos_len()
    #-----END MOD-750118-----
#FUN-710029 end------------
#No.FUN-830103--end-- 
#     START REPORT r710_rep TO l_name                                #No.FUN-830103
#     LET g_pageno = 0                                               #No.FUN-830103   
     FOREACH r710_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#FUN-A60056--mod--str--
#         #NO.FUN-710029 start--
#         SELECT pmn20,pmn07 INTO sr.pmn20,sr.pmn07 
#           FROM pmn_file
#          WHERE pmn01 = sr.alb04
#         #NO.FUN-710029 end----
          LET l_sql = "SELECT pmn20,pmn07 ",
                      "  FROM ",cl_get_target_table(sr.ala97,'pmn_file'),
                      " WHERE pmn01 = '",sr.alb04,"'",
                      "   AND pmn02 = '",sr.alb05,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,sr.ala97) RETURNING l_sql
          PREPARE sel_pmn20 FROM l_sql
          EXECUTE sel_pmn20 INTO sr.pmn20,sr.pmn07
#FUN-A60056--mod--end
          IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
          IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
          IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
          LET sr.total = sr.ala23 + sr.ala24
#No.FUN-830103--begin-- 
#          FOR g_i = 1 TO 3
#              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ala01
#                                            LET g_orderA[g_i]= g_x[12]
#                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ala02
#                                            LET g_orderA[g_i]= g_x[13]
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ala04
#                                            LET g_orderA[g_i]= g_x[14]
#                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ala05
#                                            LET g_orderA[g_i]= g_x[15]
#                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ala08 USING 'YYYYMMDD'
#                                            LET g_orderA[g_i]= g_x[16]
#                   WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ala07
#                                            LET g_orderA[g_i]= g_x[17]
#                   OTHERWISE LET l_order[g_i]  = '-'
#                             LET g_orderA[g_i] = ' '          #清為空白
#              END CASE
#          END FOR
#          LET sr.order1 = l_order[1]
#          LET sr.order2 = l_order[2]
#          LET sr.order3 = l_order[3]
#          IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
#          IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
#          IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
 
#          OUTPUT TO REPORT r710_rep(sr.*)
         SELECT azi03,azi04,azi05                                                                                                   
            INTO t_azi03,t_azi04,t_azi05   #No.CHI-6A0004                                                                           
            FROM azi_file                                                                                                           
           WHERE azi01=sr.ala20                                                                                                     
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file                                                                     
                         WHERE ima01=sr.alb11                                                                                       
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr.alb85) RETURNING l_alb85                                                                     
                LET l_str2 = l_alb85 , sr.alb83 CLIPPED                                                                             
                IF cl_null(sr.alb85) OR sr.alb85 = 0 THEN                                                                           
                    CALL cl_remove_zero(sr.alb82) RETURNING l_alb82                                                                 
                    LET l_str2 = l_alb82, sr.alb80 CLIPPED                                                                          
                ELSE                                                                                                                
                   IF NOT cl_null(sr.alb82) AND sr.alb82 > 0 THEN                                                                   
                      CALL cl_remove_zero(sr.alb82) RETURNING l_alb82                                                               
                      LET l_str2 = l_str2 CLIPPED,',',l_alb82, sr.alb80 CLIPPED                                                     
                   END IF 
                END IF                                                                                                              
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr.alb85) AND sr.alb85 > 0 THEN                                                                      
                    CALL cl_remove_zero(sr.alb85) RETURNING l_alb85                                                                 
                    LET l_str2 = l_alb85 , sr.alb83 CLIPPED                                                                         
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                                                                                                                        
      IF g_sma116 MATCHES '[13]' THEN                                                                                               
            IF sr.pmn07 <> sr.alb86 THEN                                                                                            
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20                                                                      
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"                                                         
            END IF                                                                                                                  
      END IF                                                                                                                        
      EXECUTE insert_prep USING                                                                                                     
                          sr.ala01,sr.ala02,sr.ala07,sr.pmc03,sr.ala04,sr.ala05,sr.ala08,sr.ala20,sr.ala23,                         
                          sr.ala24,sr.total,sr.ala25,sr.ala34,sr.ala79,sr.alb02,sr.alb03,sr.alb04,sr.alb05,                         
                          sr.alb11,sr.alb06,sr.alb86,sr.alb87,sr.alb12,sr.alb13,sr.alb07,sr.alb08,l_str2,                           
                          t_azi03,t_azi04,t_azi05,sr.azi05
     END FOREACH
 
#     FINISH REPORT r710_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      #No.FUN-BB0047--mark--Begin---
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      #No.FUN-BB0047--mark--End-----
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'ala01,ala02,ala04,ala05,ala08,ala07')                                                                   
        RETURNING tm.wc                                                                                                             
        LET g_str =tm.wc                                                                                                            
     END IF                                                                                                                         
     LET g_str =g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",                                                  
                tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]                                                   
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     CALL cl_prt_cs3('aapr710',l_name,g_sql,g_str)                                                                                  
#No.FUN-830103--end--
END FUNCTION
#No.FUN-830103--begin--
#REPORT r710_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#         sr               RECORD order1 LIKE ala_file.ala01,        # No.FUN-680137  VARCHAR(16),     #No.FUN-550030
#                                 order2 LIKE ala_file.ala01,        # No.FUN-680137  VARCHAR(16),     #No.FUN-550030
#                                 order3 LIKE ala_file.ala01,        # No.FUN-680137  VARCHAR(16),     #No.FUn-550030
#                                 ala01 LIKE ala_file.ala01,
#                                 ala02 LIKE ala_file.ala02,
#                                 ala04 LIKE ala_file.ala04,
#                                 ala05 LIKE ala_file.ala05,
#                                 ala07 LIKE ala_file.ala07,
#                                 pmc03 LIKE pmc_file.pmc03,
#                                 ala08 LIKE ala_file.ala08,
#                                 ala20 LIKE ala_file.ala20,
#                                 ala23 LIKE ala_file.ala23,
#                                 ala24 LIKE ala_file.ala24,
#                                 ala25 LIKE ala_file.ala25,
#                                 ala34 LIKE ala_file.ala34,
#                                 ala79 LIKE ala_file.ala79,
#                                 total LIKE ala_file.ala24,
#                                 alb02 LIKE alb_file.alb02,
#                                 alb03 LIKE alb_file.alb03,
#                                 alb04 LIKE alb_file.alb04,
#                                 alb05 LIKE alb_file.alb05,
#                                 alb06 LIKE alb_file.alb06,
#                                 alb07 LIKE alb_file.alb07,
#                                 alb08 LIKE alb_file.alb08,
#                                 alb11 LIKE alb_file.alb11, # 採購單檔
#                                 alb12 LIKE alb_file.alb12,
#                                 alb13 LIKE alb_file.alb13,
#                                 azi03 LIKE azi_file.azi03,
#                                 azi04 LIKE azi_file.azi04,
#                                 azi05 LIKE azi_file.azi05,
#                                 alb80 LIKE alb_file.alb80,  #FUN-710029
#                                 alb81 LIKE alb_file.alb81,  #FUN-710029
#                                 alb82 LIKE alb_file.alb82,  #FUN-710029
#                                 alb83 LIKE alb_file.alb83,  #FUN-710029
#                                 alb84 LIKE alb_file.alb84,  #FUN-710029
#                                 alb85 LIKE alb_file.alb85,  #FUN-710029
#                                 alb86 LIKE alb_file.alb86,  #FUN-710029
#                                 alb87 LIKE alb_file.alb87,  #FUN-710029
#                                 pmn20 LIKE pmn_file.pmn20,  #FUN-710029
#                                 pmn07 LIKE pmn_file.pmn07   #FUN-710029
#                       END RECORD,
#     l_amt_1      LIKE alb_file.alb06,
#     l_amt_2      LIKE alb_file.alb08,
#     l_sum_1      LIKE alb_file.alb07,
#     l_sum_2      LIKE alb_file.alb08,
#     l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
# DEFINE l_str2       LIKE type_file.chr1000, #FUN-710029
#        l_ima906     LIKE ima_file.ima906,   #FUN-710029
#        l_ima021     LIKE ima_file.ima021,   #FUN-710029
#        l_alb85      LIKE alb_file.alb85,    #FUN-710029
#        l_alb82      LIKE alb_file.alb82,    #FUN-710029
#        l_pmn20      LIKE pmn_file.pmn20     #FUN-710029
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.ala01
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED  #MOD-630098 by HCN 20060522
#     PRINT COLUMN 80,g_company CLIPPED                                # No.TQC-740305
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)-1,g_x[1] CLIPPED            # No.TQC-740305 
#     PRINT COLUMN 89,g_x[1] CLIPPED                                   # No.TQC-740305
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED    # No.TQC-740305 
#     PRINT COLUMN 182,'FROM:',g_user CLIPPED                            # No.TQC-740305
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]    # No.TQC-740305 
#     PRINT COLUMN 89,g_x[1]    # No.TQC-740305
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<' # ,"/pageno"       # No.TQC-740305 
#     PRINT g_head CLIPPED,pageno_total    # No.TQC-740305
#     LET l_chr = 'N'
# No.TQC-740305 -- begin
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 49,g_x[11] CLIPPED,
#           g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED,
#           COLUMN 188,g_x[3] CLIPPED,PAGENO USING '<<<'
# No.TQC-740305 -- end
#     PRINT g_x[11] CLIPPED,g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED,     # No.TQC-740305 
#     COLUMN 188,g_x[3] CLIPPED,PAGENO USING '<<<'               # No.TQC-740305
#     PRINT g_dash[1,g_len]   #MOD-750118取消mark
#     PRINT g_dash[1,280]   #FUN-710029
#     #PRINT '=================================================================================================================================================================================================='   #MOD-750118 mark
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.ala01
#
#     SELECT azi03,azi04,azi05
#       INTO t_azi03,t_azi04,t_azi05   #No.CHI-6A0004
#       FROM azi_file
#      WHERE azi01=sr.ala20
 
#     PRINT g_x[18],
#           COLUMN 47,g_x[19],
#no.FUN-550030--begin
#           COLUMN 87,g_x[20],
#           COLUMN 133,g_x[21],
#           COLUMN 173,g_x[22] CLIPPED
#     PRINT '-------------------- ----- ---------------       ------ ',
#           '---------- -------- ---- ------------------ ------------------ ',
#      '------------------ ------------------ ------------------ ------------------'
#     PRINT COLUMN 01,sr.ala01,
#           COLUMN 22,sr.ala02,
#           COLUMN 28,sr.ala07[1,4],
#           COLUMN 32,sr.pmc03[1,10],
#           COLUMN 50,sr.ala04,
#           COLUMN 57,sr.ala05,
#           COLUMN 68,sr.ala08,
#           COLUMN 77,sr.ala20,
#           COLUMN 81,cl_numfor(sr.ala23,18,t_azi04),  #No.CHI-6A0004
#           COLUMN  99,cl_numfor(sr.ala24,18,t_azi04), #No.CHI-6A0004
#           COLUMN 118,cl_numfor(sr.total,18,t_azi04), #No.CHI-6A0004
#           COLUMN 137,cl_numfor(sr.ala25,18,t_azi04), #No.CHI-6A0004
#           COLUMN 156,cl_numfor(sr.ala34,18,t_azi04), #No.CHI-6A0004
#           COLUMN 175,cl_numfor(sr.ala79,18,t_azi04)  #No.CHI-6A0004
#     PRINT
#     PRINT g_x[23],
#MOD-5A0163
#           COLUMN 46,g_x[24];
#           COLUMN 47,g_x[24],
#NO.FUN-710029 start--加入多單位及計價單位判斷--
#     IF g_sma116 MATCHES '[13]' THEN
#         PRINT COLUMN 104,g_x[35] CLIPPED,
#               COLUMN 122,g_x[36] CLIPPED,
#               COLUMN 144,g_x[32] CLIPPED;
#     ELSE
#NO.FUN-710029 end--------------------------------
#         PRINT COLUMN 87,g_x[34],      
#               COLUMN 124,g_x[32];
#                COLUMN 145,g_x[33] CLIPPED;
#     END IF    #FUN-710029
#NO.FUN-710029 start---
#     IF g_sma115 = 'Y' THEN   #使用雙單位
#         PRINT COLUMN 205,g_x[37] CLIPPED
#     ELSE
#         PRINT
#     END IF
#NO.FUN-710029 end----
#     PRINT '                 -- ---- ---------------- -- ---------------------------------------- ';
#     PRINT '                 -- ---- ---------------- -- -------------------- ',
#MOD-5A0163 End
#NO.FUN-710029 start---
#     IF g_sma116 MATCHES '[13]' THEN  #使用計價單位
#         PRINT  '---------------- ----------------- ---------------- ------------------ ',
#                '---------------- ------------------';
#     ELSE
#         PRINT  '---------------- ---------------- ------------------ ',
#                '---------------- ------------------';
#     END IF
#     IF g_sma115 = 'Y' THEN
#         PRINT ' --------------------------------------------'
#     ELSE
#         PRINT
#     END IF
#NO.FUN-710029 end----
#     LET l_chr = 'Y'
 
#  ON EVERY ROW
#NO.FUN-710029 start----
#     SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                        WHERE ima01=sr.alb11
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.alb85) RETURNING l_alb85
#               LET l_str2 = l_alb85 , sr.alb83 CLIPPED
#               IF cl_null(sr.alb85) OR sr.alb85 = 0 THEN
#                   CALL cl_remove_zero(sr.alb82) RETURNING l_alb82
#                   LET l_str2 = l_alb82, sr.alb80 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.alb82) AND sr.alb82 > 0 THEN
#                     CALL cl_remove_zero(sr.alb82) RETURNING l_alb82
#                     LET l_str2 = l_str2 CLIPPED,',',l_alb82, sr.alb80 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.alb85) AND sr.alb85 > 0 THEN
#                   CALL cl_remove_zero(sr.alb85) RETURNING l_alb85
#                   LET l_str2 = l_alb85 , sr.alb83 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#     IF g_sma116 MATCHES '[13]' THEN 
#           IF sr.pmn07 <> sr.alb86 THEN 
#              CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
#              LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
#           END IF
#     END IF
#NO.FUN-710029 end--------------
#     PRINT COLUMN 18, sr.alb02 USING '#&',
#           COLUMN 21,sr.alb03[1,4],
#           COLUMN 26,sr.alb04,
#           COLUMN 43,sr.alb05 USING '#&',
#MOD-5A0163
#           COLUMN 46,sr.alb11,
#           COLUMN 87,cl_numfor(sr.alb06,15,t_azi03);   #No.CHI-6A0004
#     #FUN-710029 start----------------
#     IF g_sma116 MATCHES '[13]' THEN
#         PRINT COLUMN 104,sr.alb86,
#               COLUMN 122,cl_numfor(sr.alb87,15,t_azi04),
#               COLUMN 138,cl_numfor(sr.alb08,18,t_azi04), #No.CHI-6A0004
#               COLUMN 156,sr.alb12 USING '#,###,###,##&.&&',
#               COLUMN 173,cl_numfor(sr.alb13,18,t_azi04);  #No.CHI-6A0004
#     ELSE      
#         PRINT COLUMN 104,sr.alb07 USING '#,###,###,##&.&&',
#               COLUMN 120,cl_numfor(sr.alb08,18,t_azi04), #No.CHI-6A0004
#               COLUMN 140,sr.alb12 USING '#,###,###,##&.&&',
#               COLUMN 156,cl_numfor(sr.alb13,18,t_azi04);  #No.CHI-6A0004
#     END IF
#     IF (g_sma115 = "Y" OR g_sma116 MATCHES '[13]') THEN  #使用多單位/使用計價單位
#         PRINT COLUMN 195,l_str2 CLIPPED
#     ELSE
#         PRINT
#     END IF
#     IF g_sma115 = "Y" AND g_sma116 MATCHES '[02]' THEN  #使用多單位/不使用計價單位
#         PRINT COLUMN 175,l_str2 CLIPPED
#     ELSE
#         PRINT
#     END IF
#     #FUN-710029 end-------------------
#           COLUMN 46,sr.alb11,
#           COLUMN 67,cl_numfor(sr.alb06,15,t_azi03),  #No.CHI-6A0004
#           COLUMN 84,sr.alb07 USING '#,###,###,##&.&&',
#           COLUMN 100,cl_numfor(sr.alb08,18,t_azi04), #No.CHI-6A0004
#           COLUMN 118,sr.alb12 USING '#,###,###,##&,&&',
#           COLUMN 136,cl_numfor(sr.alb13,18,t_azi04)  #No.CHI-6A0004
#MOD-5A0163 End
 
#  AFTER GROUP OF sr.ala01
#MOD-5A0163
#     #NO.FUN-710029 start---
#     IF g_sma116 MATCHES '[13]' THEN
#         PRINT COLUMN 139,'------------------',
#               COLUMN 175,'------------------'
#     ELSE
#     #NO.FUN-710029 end-----
#         PRINT COLUMN 121, '------------------',
#               COLUMN 157,'------------------'
#     END IF                                        #FUN-710029
#     PRINT COLUMN 101, '--------------',
#           COLUMN 157,'------------------'
#           COLUMN 120,'----------------'
#     PRINT COLUMN 98, g_x[25] CLIPPED;
#     PRINT COLUMN 86, g_x[25] CLIPPED,
#NO.FUN-710029 start---
#     IF g_sma116 MATCHES '[13]' THEN
#         PRINT COLUMN 138,cl_numfor(GROUP SUM(sr.alb08),18,t_azi05),  #No.CHI-6A0004
#               COLUMN 177,cl_numfor(GROUP SUM(sr.alb13),15,t_azi05)   #No.CHI-6A0004
#     ELSE
#NO.FUN-710029 end-----
#         PRINT COLUMN 120,cl_numfor(GROUP SUM(sr.alb08),18,t_azi05),  #No.CHI-6A0004
#               COLUMN 159,cl_numfor(GROUP SUM(sr.alb13),15,t_azi05)   #No.CHI-6A0004
#     END IF                                                           #FUN-710029
#           COLUMN 100,cl_numfor(GROUP SUM(sr.alb08),18,t_azi05),  #No.CHI-6A0004
#           COLUMN 118,cl_numfor(GROUP SUM(sr.alb13),15,t_azi05)   #No.CHI-6A0004
#MOD-5A0163 End
#     PRINT
 
#  AFTER GROUP OF sr.order1
#     IF tm.u[1,1] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.alb07)
#        LET l_amt_2 = GROUP SUM(sr.alb08)
#MOD-5A0163
#        #PRINT COLUMN 96, g_orderA[1] CLIPPED,g_x[27] CLIPPED,
#        #FUN-710029----start
#        IF g_sma116 MATCHES '[13]' THEN
#            PRINT COLUMN 90, g_orderA[1] CLIPPED,g_x[27] CLIPPED,   #FUN-710029
#                  COLUMN 122, cl_numfor(l_amt_1,15,sr.azi05),
#                  COLUMN 138, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#        ELSE
#        #FUN-710029 ---end--
#            PRINT COLUMN 90, g_orderA[1] CLIPPED,g_x[27] CLIPPED,   #FUN-710029
#                  COLUMN 104, cl_numfor(l_amt_1,15,sr.azi05),
#                  COLUMN 119, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#        END IF      #FUN-710029
#        PRINT COLUMN 58, g_orderA[1] CLIPPED,g_x[27] CLIPPED,
#              COLUMN 78, cl_numfor(l_amt_1,15,sr.azi05),
#              COLUMN 94, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#MOD-5A0163 End
#no.FUN-550030--end
#        PRINT
#     END IF
 
#  AFTER GROUP OF sr.order2
#     IF tm.u[2,2] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.alb07)
#        LET l_amt_2 = GROUP SUM(sr.alb08)
#MOD-5A0163
#        #PRINT COLUMN 96, g_orderA[2] CLIPPED,g_x[26] CLIPPED,
#        #FUN-710029----start
#        IF g_sma116 MATCHES '[13]' THEN
#            PRINT COLUMN 90, g_orderA[2] CLIPPED,g_x[26] CLIPPED,
#                  COLUMN 122, cl_numfor(l_amt_1,15,sr.azi05),
#                  COLUMN 138, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#        ELSE
#        #FUN-710029 ---end
#            PRINT COLUMN 90, g_orderA[2] CLIPPED,g_x[26] CLIPPED,
#                  COLUMN 104, cl_numfor(l_amt_1,15,sr.azi05),
#                  COLUMN 119, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#        END IF    #FUN-710029
#        PRINT COLUMN 58, g_orderA[2] CLIPPED,g_x[26] CLIPPED,
#              COLUMN 78, cl_numfor(l_amt_1,15,sr.azi05),
#              COLUMN 94, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#MOD-5A0163 End
#     END IF
 
#  AFTER GROUP OF sr.order3
#     IF tm.u[3,3] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.alb07)
#        LET l_amt_2 = GROUP SUM(sr.alb08)
#MOD-5A0163
#        #PRINT COLUMN 96, g_orderA[3] CLIPPED,g_x[25] CLIPPED,
#        #FUN-710029----start
#        IF g_sma116 MATCHES '[13]' THEN
#            PRINT COLUMN 90, g_orderA[2] CLIPPED,g_x[26] CLIPPED,
#                  COLUMN 122, cl_numfor(l_amt_1,15,sr.azi05),
#                  COLUMN 138, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#        ELSE
#        #FUN-710029-----end
#            PRINT COLUMN 90, g_orderA[2] CLIPPED,g_x[26] CLIPPED,
#                  COLUMN 104, cl_numfor(l_amt_1,15,sr.azi05),
#                  COLUMN 119, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#        END IF    #FUN-710029
#        PRINT COLUMN 58, g_orderA[3] CLIPPED,g_x[25] CLIPPED,
#              COLUMN 78, cl_numfor(l_amt_1,15,sr.azi05),
#              COLUMN 94, cl_numfor(l_amt_2,18,sr.azi05) CLIPPED
#MOD-5A0163 End
#     END IF
 
#  ON LAST ROW
#     LET l_sum_1 = SUM (sr.alb07)
#     LET l_sum_2 = SUM (sr.alb08)
#     SKIP 1 LINE
#MOD-5A0163
#     PRINT COLUMN 96,g_x[28] CLIPPED;
#     #NO.FUN-710029 start---
#     IF g_sma116 MATCHES '[13]' THEN
#         PRINT COLUMN 122,cl_numfor(l_sum_1,15,sr.azi05),
#               COLUMN 138,cl_numfor(l_sum_2,18,sr.azi05) CLIPPED
#     ELSE
#     #NO.FUN-710029 end---
#         PRINT COLUMN 104, cl_numfor(l_sum_1,15,sr.azi05),
#               COLUMN 119, cl_numfor(l_sum_2,18,sr.azi05) CLIPPED
#     END IF                                                       #FUN-710029
#     PRINT COLUMN 58,g_x[28] CLIPPED,
#           COLUMN 78, cl_numfor(l_sum_1,15,sr.azi05),
#           COLUMN 94, cl_numfor(l_sum_2,18,sr.azi05) CLIPPED
#MOD-5A0163 End
 
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        #CALL cl_wcchp(tm.wc,'ala01,ala02,ala03,ala04,ala05')   #MOD-750118
#        CALL cl_wcchp(tm.wc,'ala01,ala02,ala04,ala05,ala08,ala07')   #MOD-750118
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]   #MOD-750118取消mark
#        #TQC-630166
#        #    IF tm.wc[001,070] > ' ' THEN            # for 80
#        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        #    IF tm.wc[071,140] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        #    IF tm.wc[141,210] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        #    IF tm.wc[211,280] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        CALL cl_prt_pos_wc(tm.wc)   #MOD-750118取消mark
#        #END TQC-630166
#     END IF
#     PRINT g_dash[1,g_len]   #MOD-750118取消mark
#     #PRINT '=================================================================================================================================================================================================='   #MOD-750118 mark
#      PRINT g_dash[1,280]  #FUN-710029
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED           # No.TQC-740305 
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN 186,g_x[7] CLIPPED    # No.TQC-740305 
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' 
#         THEN PRINT g_dash[1,g_len]   #MOD-750118取消mark
#         THEN PRINT g_dash[1,280]    #FUN-710029
#     #PRINT '=================================================================================================================================================================================================='   #MOD-750118 mark
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED         # No.TQC-740305
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN 185,g_x[6] CLIPPED   # No.TQC-740305
#        ELSE 
#             SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-830103--end--
#Patch....NO.TQC-610035 <001> #
