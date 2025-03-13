# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr810.4gl
# Descriptions...: 信用狀到貨明細表
# Date & Author..: 93/02/05  By  Felicity  Tseng
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-580014 05/08/19 By wujie 憑証類報表轉xml
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.MOD-670133 06/07/31 By Smapmin 修改小計問題
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0173 06/10/31 By Smapmin 畫面上多加一個"預購單號"欄位
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.FUN-710058 07/02/05 By jamie 放寬項次位數
# Modify.........: No.TQC-740326 07/04/29 By dxfwo 條件選項-排序欄位第二，三欄位未有默認值
# Modify.........: No.FUN-770093 07/10/30 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.MOD-BA0083 11/10/17 By Polly 勾選小計時，會重複計算金額
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              #wc      LIKE type_file.chr1000,      # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc       STRING,       # Where condition   #TQC-630166
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Order by sequence
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Eject sw
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Group total sw
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
#         g_orderA    ARRAY[3] OF VARCHAR(10)  #排序名稱
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)  #排序名稱
                                            #No.FUN-550030
#No.FUN-580014--begin
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
#No.FUN-580014--end
DEFINE   g_sma115    LIKE sma_file.sma115      #FUN-710029
DEFINE   g_sma116    LIKE sma_file.sma116      #FUN-710029
DEFINE   g_sql       STRING                    #FUN-770093
DEFINE   g_str       STRING                    #FUN-770093
DEFINE   l_table     STRING                    #FUN-770093
 
 
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
 
   #FUN-770093 --start--
   LET g_sql="alk01.alk_file.alk01,alk02.alk_file.alk02,alk05.alk_file.alk05,",
             "alk10.alk_file.alk10,alk03.alk_file.alk03,alk11.alk_file.alk11,",
             "alk12.alk_file.alk12,alk13.alk_file.alk13,alk26.alk_file.alk26,",
             "alk16.alk_file.alk16,alk23.alk_file.alk23,alk24.alk_file.alk24,",
             "ale02.ale_file.ale02,ale16.ale_file.ale16,ale17.ale_file.ale17,",
             "ale14.ale_file.ale14,ale15.ale_file.ale15,",
             "pmn041.pmn_file.pmn041,ale11.ale_file.ale11,",
             "ale86.ale_file.ale86,ale87.ale_file.ale87,pmn07.pmn_file.pmn07,",
             "ale06.ale_file.ale06,ale05.ale_file.ale05,ale07.ale_file.ale07,",
             "ale08.ale_file.ale08,ale09.ale_file.ale09,alk04.alk_file.alk04,",
             "azi03.azi_file.azi03,azi04.azi_file.azi04,azi05.azi_file.azi05,",
             "azi07.azi_file.azi07 "   #No.FUN-870151
   LET l_table = cl_prt_temptable('aapr810',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?)"              #FUN-870151 Add ?   
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF
   #No.FUN-770093 --end--
 
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
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file #FUN-710029
#   CALL r810_create_tmp()    #no.5197   #No.FUN-770093 --mark--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r810_tm(0,0)        # Input print condition
      ELSE CALL r810()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r810_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r810_w AT p_row,p_col
        WITH FORM "aap/42f/aapr810"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.s    = '1'                         
   LET tm.s    = '123'                # TQC-740326                        
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
   #CONSTRUCT BY NAME tm.wc ON alk01,alk02,alk11,alk05,alk10,alk04   #FUN-6A0173
   CONSTRUCT BY NAME tm.wc ON alk01,alk02,alk11,alk05,alk10,alk04,alk03   #FUN-6A0173
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
      LET INT_FLAG = 0 CLOSE WINDOW r810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW r810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr810','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapr810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r810()
   ERROR ""
END WHILE
   CLOSE WINDOW r810_w
END FUNCTION
 
FUNCTION r810()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql    STRING,      # RDSQL STATEMENT   #TQC-630166
          l_za05    LIKE type_file.chr1000,     #No.FUN-690028 VARCHAR(40)
          l_tot14,l_tot15    LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),
          l_order   ARRAY[5] OF LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),            #No.FUN-550030
          sr               RECORD order1 LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
                                  order2 LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
                                  order3 LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
                                  alk RECORD LIKE alk_file.*,
                                  ale RECORD LIKE ale_file.*,
                                  # Prog. Version..: '5.30.06-13.03.12(04),           #FUN-660117 remark
                                  #pmn041 VARCHAR(30),           #FUN-660117 remark
                                  pmn07  LIKE pmn_file.pmn07, #FUN-660117      
                                  pmn041 LIKE pmn_file.pmn041,#FUN-660117
                                  azi03  LIKE azi_file.azi03,
                                  azi04  LIKE azi_file.azi04,
                                  azi05  LIKE azi_file.azi05,
                                  azi07  LIKE azi_file.azi07,  #No.FUN-870151
                                  pmn20  LIKE pmn_file.pmn20,  #FUN-710029
                                  alk97  LIKE alk_file.alk97   #FUN-A60056
                        END RECORD
   DEFINE l_str2       LIKE type_file.chr1000,                 #No.FUN-770093  
          l_ima021     LIKE ima_file.ima021,                   #No.FUN-770093
          l_ima906     LIKE ima_file.ima906,                   #No.FUN-770093
          l_ale85      LIKE ale_file.ale85,                    #No.FUN-770093
          l_ale82      LIKE ale_file.ale82,                    #No.FUN-770093   
          l_pmn20      LIKE pmn_file.pmn20                     #No.FUN-770093
   DEFINE l_str3       LIKE type_file.chr1000                  #No.MOD-BA0083
 
     CALL cl_del_data(l_table)                         #No.FUN-770093
 
#     DELETE FROM r810_tmp                             #No.FUN-770093
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580014--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr810'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 171 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580014--end
#No.FUN-770093 --mark--
##bugno:5197................................................................
#     LET l_sql =
#         "SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5) ",
#         " FROM r810_tmp WHERE order1 = ? ",
#         " GROUP BY curr ORDER BY curr"
#     PREPARE r810tmp_pre1 FROM l_sql
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('tmp_pre1:',SQLCA.sqlcode,1) RETURN
#     END IF
#     DECLARE r810_tmpcs1 CURSOR FOR r810tmp_pre1
#
#     LET l_sql =
#         "SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5) ",
#         #" FROM r810_tmp WHERE order2 = ? ",   #MOD-670133
#         " FROM r810_tmp WHERE order1 = ? AND order2 = ? ",   #MOD-670133
#         " GROUP BY curr ORDER BY curr"
#     PREPARE r810tmp_pre2 FROM l_sql
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('tmp_pre2:',SQLCA.sqlcode,1) RETURN
#     END IF
#     DECLARE r810_tmpcs2 CURSOR FOR r810tmp_pre2
#
#     LET l_sql =
#         "SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5) ",
#         #" FROM r810_tmp WHERE order3 = ? ",   #MOD-670133
#         " FROM r810_tmp WHERE order1 = ? AND order2 = ? AND order3 = ? ",   #MOD-670133
#         " GROUP BY curr ORDER BY curr"
#     PREPARE r810tmp_pre3 FROM l_sql
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('tmp_pre3:',SQLCA.sqlcode,1) RETURN
#     END IF
#     DECLARE r810_tmpcs3 CURSOR FOR r810tmp_pre3
##bug end.................................................................
#No.FUN-770093 --end--
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND alkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alkuser', 'alkgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','', ",
                #FUN-A60056--mod--str--主sql拿掉pmn欄位
                #" alk_file.*, ale_file.*, pmn07,pmn041,azi03,azi04,azi05,azi07,", #No.FUN-870151 add azi07
                #" pmn20",  #FUN-710029
                #" FROM alk_file, ale_file, OUTER pmn_file,azi_file",
                 " alk_file.*, ale_file.*,'','',azi03,azi04,azi05,azi07,'',alk97",
                 " FROM alk_file, ale_file, azi_file", 
                #FUN-A60056--mod--end
                 " WHERE ale01 = alk01 ",
                 "   AND alk11 = azi_file.azi01 ",
                 "   AND alkfirm <> 'X' ",  #CHI-C80041
                #"   AND ale_file.ale14 = pmn_file.pmn01 AND ale_file.ale15 = pmn_file.pmn02 ",   #FUN-A60056
                 "   AND ", tm.wc CLIPPED
#    LET l_sql = l_sql CLIPPED," ORDER BY alk01"
     PREPARE r810_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r810_curs1 CURSOR FOR r810_prepare1
#    LET l_name = 'aapr810.out'
#     CALL cl_outnam('aapr810') RETURNING l_name  #No.FUN-770093
 
#No.FUN-770093 --mark--
##FUN-710029 start------#zaa06隱藏否
#    IF g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[60].zaa06 = "N" #計價單位
#        LET g_zaa[61].zaa06 = "N" #計價數量
#        LET g_zaa[51].zaa06 = "Y" #數量 
#        LET g_zaa[52].zaa06 = "Y"
#    ELSE
#        LET g_zaa[60].zaa06 = "Y" #計價單位
#        LET g_zaa[61].zaa06 = "Y" #計價數量
#        LET g_zaa[51].zaa06 = "N" #數量
#        LET g_zaa[52].zaa06 = "N"
#    END IF
#    IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN
#        LET g_zaa[62].zaa06 = "N" #單位註解
#    ELSE
#        LET g_zaa[62].zaa06 = "Y" #單位註解
#    END IF
#    CALL cl_prt_pos_len()
##FUN-710029 end------------
#     START REPORT r810_rep TO l_name
#     LET g_pageno = 0
#No.FUN-770093 --end--
 
     FOREACH r810_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #FUN-A60056--add--str--
          LET l_sql = "SELECT pmn07,pmn041,pmn20 ",
                      "  FROM ",cl_get_target_table(sr.alk.alk97,'pmn_file'),
                      " WHERE pmn01 = '",sr.ale.ale14,"'",
                      "   AND pmn02 = '",sr.ale.ale15,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,sr.alk.alk97) RETURNING l_sql
          PREPARE sel_pmn07_sel FROM l_sql
          EXECUTE sel_pmn07_sel INTO sr.pmn07,sr.pmn041,sr.pmn20
          #FUN-A60056--add--end
          #No.FUN-770093 --mark--
#          FOR g_i = 1 TO 3
#              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.alk.alk01
#                                            LET g_orderA[g_i]= g_x[12]
#                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.alk.alk02 USING 'YYYYMMDD'
#                                            LET g_orderA[g_i]= g_x[13]
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.alk.alk11
#                                            LET g_orderA[g_i]= g_x[14]
#                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.alk.alk05
#                                            LET g_orderA[g_i]= g_x[15]
#                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.alk.alk10
#                                            LET g_orderA[g_i]= g_x[16]
#                   WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.alk.alk04
#                                            LET g_orderA[g_i]= g_x[17]
#                   WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.alk.alk03   #FUN-6A0173
#                                            LET g_orderA[g_i]= g_x[29]   #FUN-6A0173
#
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
#          LET l_tot14=sr.alk.alk23+sr.alk.alk24
#          LET l_tot15=sr.alk.alk26+sr.alk.alk16+sr.alk.alk23+sr.alk.alk24
#          INSERT INTO r810_tmp          #no.5197
#                 VALUES(sr.alk.alk11,sr.alk.alk13,sr.alk.alk26,sr.alk.alk16,
#                        l_tot14,l_tot15,
#                        sr.order1,sr.order2,sr.order3)
#          OUTPUT TO REPORT r810_rep(sr.*)
          #No.FUN-770093 --end--
          #No.FUN-770093 --start--
          SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file                 
                         WHERE ima01=sr.ale.ale11                               
          LET l_str2 = ""                                                           
          IF g_sma115 = "Y" THEN                                                    
             CASE l_ima906
                WHEN "2"                                                            
                    CALL cl_remove_zero(sr.ale.ale85) RETURNING l_ale85       
                    LET l_str2 = l_ale85 , sr.ale.ale83 CLIPPED               
                    IF cl_null(sr.ale.ale85) OR sr.ale.ale85 = 0 THEN         
                       CALL cl_remove_zero(sr.ale.ale82) RETURNING l_ale82    
                       LET l_str2 = l_ale82, sr.ale.ale80 CLIPPED             
                    ELSE                                                      
                       IF NOT cl_null(sr.ale.ale82) AND sr.ale.ale82 > 0 THEN    
                          CALL cl_remove_zero(sr.ale.ale82) RETURNING l_ale82     
                          LET l_str2 = l_str2 CLIPPED,',',l_ale82, sr.ale.ale80 CLIPPED
                       END  IF
                    END IF
                WHEN "3"
                    IF NOT cl_null(sr.ale.ale85) AND sr.ale.ale85 > 0 THEN          
                    CALL cl_remove_zero(sr.ale.ale85) RETURNING l_ale85         
                    LET l_str2 = l_ale85 , sr.ale.ale83 CLIPPED                 
                    END IF                                                          
             END CASE
          ELSE                                                                      
          END IF                                                                    
          IF g_sma116 MATCHES '[13]' THEN                                           
             IF sr.pmn07 <> sr.ale.ale86 THEN                                    
                CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20                  
                LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"     
             END IF                                                              
          END IF 
          EXECUTE insert_prep USING sr.alk.alk01,sr.alk.alk02,sr.alk.alk05,
                                    sr.alk.alk10,sr.alk.alk03,sr.alk.alk11,
                                    sr.alk.alk12,sr.alk.alk13,sr.alk.alk26,
                                    sr.alk.alk16,sr.alk.alk23,sr.alk.alk24,
                                    sr.ale.ale02,sr.ale.ale16,sr.ale.ale17,
                                    sr.ale.ale14,sr.ale.ale15,sr.pmn041,
                                    sr.ale.ale11,sr.ale.ale86,sr.ale.ale87,
                                    sr.pmn07,sr.ale.ale06,sr.ale.ale05,
                                    sr.ale.ale07,sr.ale.ale08,sr.ale.ale09,
                                    sr.alk.alk04,sr.azi03,sr.azi04,sr.azi05,
                                    sr.azi07   #No.FUN-870151
          #No.FUN-770093 --end--
     END FOREACH
 
#     FINISH REPORT r810_rep                     #No.FUN-770093
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)#No.FUN-770093
     #No.FUN-770093 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'alk01,alk02,alk11,alk05,alk10,alk04,alk03')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
    #-------------------------------------MOD-BA0083----------------------------start
     LET l_str3 = "SELECT DISTINCT alk01,alk02,alk05,alk10,alk03,",
                  "                alk11,alk12,alk13,alk26,alk16,",
                  "                alk23,alk24,alk04,azi05",
                  "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #-------------------------------------MOD-BA0083----------------------------end
     LET g_str=g_str,";",g_sma116,";",g_sma115,";",tm.s[1,1],";",tm.s[2,2],";",
               tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
               tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
    #LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                    #MOD-BA0083 mark
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",l_str3,"|",l_str3,"|",l_str3   #MOD-BA0083 add
     CALL cl_prt_cs3('aapr810','aapr810',l_sql,g_str)
     #No.FUN-770093 --end--
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055     #FUN-B80105 MARK
END FUNCTION
#No.FUN-770093 --start-- mark
{REPORT r810_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_curr       LIKE alk_file.alk11,
          sr               RECORD order1 LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
                                  order2 LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
                                  order3 LIKE alk_file.alk01,      # No.FUN-690028 VARCHAR(16),   #No.FUN-550030
                                  alk RECORD LIKE alk_file.*,
                                  ale RECORD LIKE ale_file.*,
                                 # Prog. Version..: '5.30.06-13.03.12(04),            #FUN-660117 remark
                                 #pmn041 VARCHAR(30),            #FUN-660117 remark
                                  pmn07  LIKE pmn_file.pmn07, #FUN-660117      
                                  pmn041 LIKE pmn_file.pmn041,#FUN-660117
                                  azi03  LIKE azi_file.azi03,
                                  azi04  LIKE azi_file.azi04,
                                  azi05  LIKE azi_file.azi05,
                                  pmn20  LIKE pmn_file.pmn20   #FUN-710029
                        END RECORD,
      l_chr        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      tot11,tot12,tot13,tot14,tot15      LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6)
      l_str2       LIKE type_file.chr1000, #FUN-710029
      l_ima021     LIKE ima_file.ima021,   #FUN-710029 
      l_ima906     LIKE ima_file.ima906,   #FUN-710029
      l_ale85      LIKE ale_file.ale85,    #FUN-710029
      l_ale82      LIKE ale_file.ale82,    #FUN-710029
      l_pmn20      LIKE pmn_file.pmn20     #FUN-710029
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.alk.alk01
  FORMAT
   PAGE HEADER
#No.FUN-580014--begin
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
      LET l_chr = 'N'
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME, 20 SPACES,g_x[11] CLIPPED,
#           g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN 01,g_x[11] CLIPPED, g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,
            '-',g_orderA[3] CLIPPED
      PRINT g_dash [1,g_len]
      LET l_last_sw = 'n'
#No.FUN-580014--end
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET tot11=0 LET tot12=0 LET tot13=0 LET tot14=0 LET tot15=0
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.alk.alk01
#No.FUN-580014--begin
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
                     g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
                     g_x[47],g_x[50],
                     g_x[60],g_x[61],  #FUN-710029
                     g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],
                     g_x[62]           #FUN-710029
      PRINTX name=H2 g_x[57],g_x[58],g_x[59]
      PRINT g_dash1
#     PRINT g_x[18] CLIPPED,
#No.FUN-550030 start
#           COLUMN 47,g_x[19] CLIPPED,
#           COLUMN 87,g_x[20] CLIPPED,
#           COLUMN 131,g_x[21] CLIPPED
#     PRINT '---------------- -------- -------- ---- -------------------- ',
#           '---- ---------- ------------------ ------------------ ',
#           '------------------ ------------------ ------------------'
      PRINTX name = D1
            COLUMN g_c[31],sr.alk.alk01,
            COLUMN g_c[32],sr.alk.alk02,
            COLUMN g_c[33],sr.alk.alk05[1,8],
            COLUMN g_c[34],sr.alk.alk10[1,4],
            COLUMN g_c[35],sr.alk.alk03,
            COLUMN g_c[36],sr.alk.alk11,
            COLUMN g_c[37],cl_numfor(sr.alk.alk12,10,sr.azi04),
            COLUMN g_c[38],cl_numfor(sr.alk.alk13,18,sr.azi04),
            COLUMN g_c[39],cl_numfor(sr.alk.alk26,18,sr.azi04),
            COLUMN g_c[40],cl_numfor(sr.alk.alk16,18,sr.azi04),
            COLUMN g_c[41],cl_numfor((sr.alk.alk23+sr.alk.alk24),18,sr.azi04),
            COLUMN g_c[42],cl_numfor((sr.alk.alk26+sr.alk.alk16+
                                 sr.alk.alk23+sr.alk.alk24),18,sr.azi04);
            LET tot11=tot11+sr.alk.alk13
            LET tot12=tot12+sr.alk.alk26
            LET tot13=tot13+sr.alk.alk16
            LET tot14=tot14+sr.alk.alk23+sr.alk.alk24
            LET tot15=tot15+sr.alk.alk26+sr.alk.alk16+sr.alk.alk23+sr.alk.alk24
#     PRINT COLUMN 15,g_x[22] CLIPPED,
#           COLUMN 68,g_x[23] CLIPPED,
#           COLUMN 107,g_x[24] CLIPPED,
#           COLUMN 147,g_x[25] CLIPPED
#     PRINT COLUMN 15,
#          "-- ----------------.-- ----------------.-- -------------------- ---- ",
#          "---------------- --------------- ------------------ ",
#          "--------------- ------------------"
      LET l_chr = 'Y'
 
   ON EVERY ROW
#NO.FUN-710029 start----
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.ale.ale11
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.ale.ale85) RETURNING l_ale85
                LET l_str2 = l_ale85 , sr.ale.ale83 CLIPPED
                IF cl_null(sr.ale.ale85) OR sr.ale.ale85 = 0 THEN
                    CALL cl_remove_zero(sr.ale.ale82) RETURNING l_ale82
                    LET l_str2 = l_ale82, sr.ale.ale80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ale.ale82) AND sr.ale.ale82 > 0 THEN
                      CALL cl_remove_zero(sr.ale.ale82) RETURNING l_ale82
                      LET l_str2 = l_str2 CLIPPED,',',l_ale82, sr.ale.ale80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.ale.ale85) AND sr.ale.ale85 > 0 THEN
                    CALL cl_remove_zero(sr.ale.ale85) RETURNING l_ale85
                    LET l_str2 = l_ale85 , sr.ale.ale83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma116 MATCHES '[13]' THEN 
            IF sr.pmn07 <> sr.ale.ale86 THEN 
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      END IF
#NO.FUN-710029 end--------------
      PRINTX name = D1
            COLUMN g_c[43],sr.ale.ale02 USING '#&',
           #COLUMN g_c[44],sr.ale.ale16,'-',sr.ale.ale17 USING '&&',     #FUN-710058 mod
           #COLUMN g_c[47],sr.ale.ale14,'-',sr.ale.ale15 USING '&&',     #FUN-710058 mod
            COLUMN g_c[44],sr.ale.ale16,'-',sr.ale.ale17 USING '&&&&&',  #FUN-710058 mod
            COLUMN g_c[47],sr.ale.ale14,'-',sr.ale.ale15 USING '&&&&&',  #FUN-710058 mod
            #COLUMN g_c[50],sr.ale.ale11[1,20], #FUN-5B0013 mark
            COLUMN g_c[50],sr.ale.ale11 CLIPPED, #FUN-5B0013 add
            COLUMN g_c[60],sr.ale.ale86,                          #FUN-710029
            COLUMN g_c[61],cl_numfor(sr.ale.ale87,61,sr.azi03),   #FUN-710029
            COLUMN g_c[51],sr.pmn07,
            COLUMN g_c[52],sr.ale.ale06 USING '###########&.##',
            COLUMN g_c[53],cl_numfor(sr.ale.ale05,53,sr.azi03),
            COLUMN g_c[54],cl_numfor(sr.ale.ale07,54,sr.azi04),
            COLUMN g_c[55],cl_numfor(sr.ale.ale08,55,sr.azi03),
            COLUMN g_c[56],cl_numfor(sr.ale.ale09,56,sr.azi04)
      PRINTX name = D2
            COLUMN g_c[58],sr.pmn041 CLIPPED #FUN-5B0013 add CLIPPED
 
   AFTER GROUP OF sr.alk.alk01
      PRINTX name = S2
            COLUMN g_c[52], g_x[28] CLIPPED,
            COLUMN g_c[54],cl_numfor(GROUP SUM(sr.ale.ale07),18,sr.azi05),
            COLUMN g_c[56],cl_numfor(GROUP SUM(sr.ale.ale09),18,sr.azi05)
      PRINT
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         PRINTX name = D1
                COLUMN g_c[38],g_dash2[1,g_w[38]],
                COLUMN g_c[39],g_dash2[1,g_w[39]],
                COLUMN g_c[40],g_dash2[1,g_w[40]],
                COLUMN g_c[41],g_dash2[1,g_w[41]],
                COLUMN g_c[42],g_dash2[1,g_w[42]]
 
         FOREACH r810_tmpcs1 USING sr.order1
                 INTO l_curr,tot11,tot12,tot13,tot14,tot15
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach1',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               PRINTX name = S1
                     COLUMN g_c[35],l_curr,g_orderA[1] CLIPPED,g_x[26] CLIPPED,
                     COLUMN g_c[38],cl_numfor(tot11,38,sr.azi05),
                     COLUMN g_c[39],cl_numfor(tot12,39,sr.azi05),
                     COLUMN g_c[40],cl_numfor(tot13,40,sr.azi05),
                     COLUMN g_c[41],cl_numfor(tot14,41,sr.azi05),
                     COLUMN g_c[42],cl_numfor(tot15,42,sr.azi05)
         END FOREACH
         SKIP 1 LINE
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         PRINTX name = D1
                COLUMN g_c[38],g_dash2[1,g_w[38]],
                COLUMN g_c[39],g_dash2[1,g_w[39]],
                COLUMN g_c[40],g_dash2[1,g_w[40]],
                COLUMN g_c[41],g_dash2[1,g_w[41]],
                COLUMN g_c[42],g_dash2[1,g_w[42]]
         #FOREACH r810_tmpcs2 USING sr.order2   #MOD-670133
         FOREACH r810_tmpcs2 USING sr.order1,sr.order2   #MOD-670133
                 INTO l_curr,tot11,tot12,tot13,tot14,tot15
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach2',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               PRINTX name = S1
                     COLUMN g_c[35],l_curr,g_orderA[2] CLIPPED,g_x[26] CLIPPED,
                     COLUMN g_c[38],cl_numfor(tot11,38,sr.azi05),
                     COLUMN g_c[39],cl_numfor(tot12,39,sr.azi05),
                     COLUMN g_c[40],cl_numfor(tot13,40,sr.azi05),
                     COLUMN g_c[41],cl_numfor(tot14,41,sr.azi05),
                     COLUMN g_c[42],cl_numfor(tot15,42,sr.azi05)
         END FOREACH
         SKIP 1 LINE
      END IF
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         PRINTX name = D1
                COLUMN g_c[38],g_dash2[1,g_w[38]],
                COLUMN g_c[39],g_dash2[1,g_w[39]],
                COLUMN g_c[40],g_dash2[1,g_w[40]],
                COLUMN g_c[41],g_dash2[1,g_w[41]],
                COLUMN g_c[42],g_dash2[1,g_w[42]]
         #FOREACH r810_tmpcs3 USING sr.order3   #MOD-670133
         FOREACH r810_tmpcs3 USING sr.order1,sr.order2,sr.order3   #MOD-670133
                 INTO l_curr,tot11,tot12,tot13,tot14,tot15
               IF SQLCA.sqlcode THEN
                  CALL cl_err('foreach3',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               PRINTX name = S1
                     COLUMN g_c[35],l_curr,g_orderA[3] CLIPPED,g_x[26] CLIPPED,
                     COLUMN g_c[38],cl_numfor(tot11,38,sr.azi05),
                     COLUMN g_c[39],cl_numfor(tot12,39,sr.azi05),
                     COLUMN g_c[40],cl_numfor(tot13,40,sr.azi05),
                     COLUMN g_c[41],cl_numfor(tot14,41,sr.azi05),
                     COLUMN g_c[42],cl_numfor(tot15,42,sr.azi05)
#No.FUN-550030 end
         END FOREACH
         SKIP 1 LINE
      END IF
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         #CALL cl_wcchp(tm.wc,'alk01,alk02,alk03,alk04,alk05')   #FUN-6A0173
         CALL cl_wcchp(tm.wc,'alk01,alk02,alk03,alk04,alk05,alk10,alk11')   #FUN-6A0173
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #TQC-630166
         #    IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #    IF tm.wc[071,140] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #    IF tm.wc[141,210] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #    IF tm.wc[211,280] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION r810_create_tmp()    #no.5197
# No.FUN-690028 --start--
 CREATE TEMP TABLE r810_tmp(
   curr      LIKE apa_file.apa13,
   amt1      LIKE type_file.num20_6,
   amt2      LIKE type_file.num20_6,
   amt3      LIKE type_file.num20_6, 
   amt4      LIKE type_file.num20_6, 
   amt5      LIKE type_file.num20_6,
   order1    LIKE alk_file.alk01,
   order2    LIKE alk_file.alk01,
   order3    LIKE alk_file.alk01)
 
# No.FUN-690028 ---end---
END FUNCTION}
#No.FUN-770093 --end--
#Patch....NO.TQC-610035 <> #
