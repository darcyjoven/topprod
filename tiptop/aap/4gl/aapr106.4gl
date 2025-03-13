# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aapr106.4gl
# Descriptions...: 進貨發票明細表列印作業
# Input parameter:
# Return code....:
# Date & Author..: 93/02/30 By yen
# Modify.........: 93/03/08 By Felicity 報表格式
#                  93/08/18 BY Felicity <^P>之 Construct
# Modify.........: No.FUN-540057 05/05/09 By wujie 發票號碼調整
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.TQC-630233 06/03/24 By Smapmin 拿掉CONTROLP
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-710139 07/01/25 By Smapmin 放寬項次位數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/19 By chenls 修改跨DB寫法 
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc       STRING,   #TQC-630166
              t       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
              h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
              END RECORD
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#No.FUN-580010 --start
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#     DEFINEl_time    LIKE type_file.chr8         #No.FUN-6A0055
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.h  = ARG_VAL(8)     #TQC-610053
   LET tm.t  = ARG_VAL(9)     #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aapr106_tm(0,0)        # Input print condition
      ELSE CALL aapr106()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr106_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 14
 
   OPEN WINDOW aapr106_w AT p_row,p_col WITH FORM "aap/42f/aapr106"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET tm.t    = 'N'
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apa21,apa22,apa05,apa06,apa01,apa02,apa36
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
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapr106_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
     INPUT BY NAME tm.h,tm.t,tm.more
                   WITHOUT DEFAULTS HELP 1
      AFTER FIELD t
         IF tm.t NOT MATCHES '[YN]' OR cl_null(tm.t) THEN NEXT FIELD t END IF
      AFTER FIELD h
         IF tm.h NOT MATCHES '[123]' OR cl_null(tm.h) THEN NEXT FIELD h END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      #ON ACTION CONTROLP   #TQC-630233
      #   CALL aapr106_wc()   # Input detail Where Condition   #TQC-630233
 
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
     END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapr106_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr106'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr106','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.h CLIPPED,"'" ,   #TQC-610053
                         " '",tm.t CLIPPED,"'" ,   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aapr106',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aapr106_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aapr106()
   ERROR ""
END WHILE
   CLOSE WINDOW aapr106_w
END FUNCTION
 
FUNCTION aapr106_wc()
   #DEFINE l_wc LIKE type_file.chr1000  #TQC-630166  #No.FUN-690028 VARCHAR(300)
   DEFINE l_wc  STRING   #TQC-630166
 
   OPEN WINDOW aapr106_w2 AT 2,2
        WITH FORM "aap/42f/aapt110"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt110")
 
   CALL cl_opmsg('q')
    #資料權限的檢查
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
              apa01, apa02, apa05,
              apa06, apa18, apa08, apa09, apa11, apa12,
              apa13, apa14, apa15, apa16, apa55, apa41,
              apa19, apa20, apa171,  apa17,  apa172,  apa173,  apa174,
              apa21, apa22,
              apa24, apa25, apa44, apamksg, apa36,
              apa31, apa51, apa32, apa52, apa34, apa54,
              apa35, apa33, apa53,
              apainpd, apauser, apagrup, apamodu, apadate, apaacti
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
   END CONSTRUCT
 
   CLOSE WINDOW aapr106_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapr106_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION aapr106()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,            # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql     STRING,       # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE faj_file.faj02,   # No.FUN-690028 VARCHAR(10),
          sr               RECORD
                           apa01 LIKE apa_file.apa01,   # 帳款編號
                           apa02 LIKE apa_file.apa02,   # 帳款日期
                           apa06 LIKE apa_file.apa06,   #付款廠商編號
                           apa08 LIKE apa_file.apa08,   #發票號碼
                           apa11 LIKE apa_file.apa11,   #付款方式
                           apa12 LIKE apa_file.apa12,   #應付款日
                           apa13 LIKE apa_file.apa13,   #幣別
                           apa15 LIKE apa_file.apa15,   #稅別
                           apa19 LIKE apa_file.apa19,   #留置原因
                           apa20 LIKE apa_file.apa20,   #HOLD
                           apa21 LIKE apa_file.apa21,   #帳款人員
                           apa22 LIKE apa_file.apa22,   #帳款部門
                           apa24 LIKE apa_file.apa24,   #票期
                           apa31 LIKE apa_file.apa31,   #貨款
                           apa32 LIKE apa_file.apa32,   #稅額
                           apa33 LIKE apa_file.apa33,   #其它
                           apa34 LIKE apa_file.apa34,   #合計金額
                           apa36 LIKE apa_file.apa36,   #帳款類別
                           apa56 LIKE apa_file.apa56,   #
                           apa57 LIKE apa_file.apa57,   #
                           apa60 LIKE apa_file.apa60,   #
                           apa61 LIKE apa_file.apa61,   #
                           apb03 LIKE apb_file.apb03,
                           apb04 LIKE apb_file.apb04,   #憑證單號(驗收單號)
                           apb05 LIKE apb_file.apb05,   #憑證單項次
                           apb06 LIKE apb_file.apb06,   #採購單號
                           apb07 LIKE apb_file.apb07,   #採購單項次
                           apb08 LIKE apb_file.apb08,   #未稅單價
                           apb09 LIKE apb_file.apb09,   #數量
                           apb10 LIKE apb_file.apb10,   #金額
                           apb21 LIKE apb_file.apb21,   #
                           apb22 LIKE apb_file.apb22,   #
                           gen02 LIKE gen_file.gen02,   #員工姓名
                           gem02 LIKE gem_file.gem02,   #部門簡稱
                           apb12 LIKE pmn_file.pmn04,   #料號
                           pmn041 LIKE pmn_file.pmn041, #品名
                           apa07 LIKE apa_file.apa07,   #廠商簡稱
                           azi03 LIKE azi_file.azi03,   #單位小數位數
                           azi04 LIKE azi_file.azi04,   #金額小數位數
                           azi05 LIKE azi_file.azi05,   #小計小數位數,
                           apb37 LIKE apb_file.apb37    #FUN-A60056 來源營運中心
                        END RECORD

#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010 --start
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr106'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010 --end
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ",
                 "  apa01, apa02, apa06, apa08, apa11, apa12, apa13,",
                 "  apa15, apa19, apa20, apa21, apa22, apa24, apa31, apa32,",
                 "  apa33, apa34, apa36, apa56, apa57, apa60, apa61,",
                 "  apb03, apb04, apb05, apb06, apb07, apb08, apb09,",
                #"  apb10, apb21, apb22, gen02, gem02, apb12, pmn041,apa07,",  #FUN-A60056
                 "  apb10, apb21, apb22, gen02, gem02, apb12, '',apa07,",  #FUN-A60056 
                 "       azi03, azi04, azi05,apb37",                      #FUN-A60056 add apb37
                #"  FROM apa_file, OUTER (apb_file, OUTER pmn_file),",   #FUN-A60056
                 "  FROM apa_file, OUTER apb_file,",                     #FUN-A60056
                 "       OUTER gen_file,OUTER gem_file,",
                 "       OUTER azi_file",
                 " WHERE apa00 = '11'",
                 "   AND apa_file.apa01 = apb_file.apb01",
                #"   AND apb_file.apb06 = pmn_file.pmn01",   #FUN-A60056
                #"   AND apb_file.apb07 = pmn_file.pmn02",   #FUN-A60056
                 "   AND gen_file.gen01 = apa_file.apa21",
                 "   AND gem_file.gem01 = apa_file.apa22",
                 "   AND azi_file.azi01 = apa_file.apa13",
                 "   AND apaacti = 'Y' AND apa42='N' ",
                 "   AND ",tm.wc
 
 
     IF tm.h = '1' THEN
        LET l_sql = l_sql CLIPPED," AND apa41 = 'Y'"
     END IF
     IF tm.h = '2' THEN
        LET l_sql = l_sql CLIPPED," AND apa41 = 'N'"
     END IF
     PREPARE aapr106_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE aapr106_curs1 CURSOR FOR aapr106_prepare1
 
     CALL cl_outnam('aapr106') RETURNING l_name
     START REPORT aapr106_rep TO l_name
 
     LET g_pageno = 0
     FOREACH aapr106_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #FUN-A60056--add--str--
       LET l_sql = "SELECT pmn041 FROM ",cl_get_target_table(sr.apb37,'pmn_file'),
                   " WHERE pmn01 = '",sr.apb06,"'",
                   "   AND pmn02 = '",sr.apb07,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,sr.apb37) RETURNING l_sql
       PREPARE sel_pmn041_cs FROM l_sql
       EXECUTE sel_pmn041_cs INTO sr.pmn041
       #FUN-A60056--add--end
       IF cl_null(sr.pmn041) THEN
           SELECT ima02 INTO sr.pmn041 FROM ima_file WHERE ima01 = sr.apb12
       END IF
    
#FUN-A60056--mark--str--
#      IF sr.apb03 != g_plant THEN
#           LET g_plant_new = sr.apb03
##            CALL s_getdbs()                    #No.FUN-A10098 -----mark
##            LET l_sql = "SELECT pmn041 FROM ",g_dbs_new,"pmn_file",     #No.FUN-A10098 -----mark
#           LET l_sql = "SELECT pmn041 FROM ",cl_get_target_table(g_plant_new,'pmn_file'),    #No.FUN-A10098 -----add
#                       " WHERE pmn01 = '",sr.apb06,"'",
#                       "   AND pmn02 = '",sr.apb07,"'"
#	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING  l_sql           #No.FUN-A10098 -----add
#           PREPARE r106_p2 FROM l_sql
#           OPEN r106_p2
#           FETCH r106_p2 INTO sr.pmn041
#      END IF
#FUN-A60056--mark--end
       IF sr.apa57 IS NULL THEN LET sr.apa57 = 0 END IF
       OUTPUT TO REPORT aapr106_rep(sr.*)
     END FOREACH
 
     FINISH REPORT aapr106_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
END FUNCTION
 
REPORT aapr106_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr               RECORD
                           apa01 LIKE apa_file.apa01,   # 帳款編號
                           apa02 LIKE apa_file.apa02,   # 帳款日期
                           apa06 LIKE apa_file.apa06,   #付款廠商編號
                           apa08 LIKE apa_file.apa08,   #發票號碼
                           apa11 LIKE apa_file.apa11,   #付款方式
                           apa12 LIKE apa_file.apa12,   #應付款日
                           apa13 LIKE apa_file.apa13,   #幣別
                           apa15 LIKE apa_file.apa15,   #稅別
                           apa19 LIKE apa_file.apa19,   #留置原因
                           apa20 LIKE apa_file.apa20,   #HOLD
                           apa21 LIKE apa_file.apa21,   #帳款人員
                           apa22 LIKE apa_file.apa22,   #帳款部門
                           apa24 LIKE apa_file.apa24,   #票期
                           apa31 LIKE apa_file.apa31,   #貨款
                           apa32 LIKE apa_file.apa32,   #稅額
                           apa33 LIKE apa_file.apa33,   #其它
                           apa34 LIKE apa_file.apa34,   #合計金額
                           apa36 LIKE apa_file.apa36,   #帳款類別
                           apa56 LIKE apa_file.apa56,   #
                           apa57 LIKE apa_file.apa57,   #
                           apa60 LIKE apa_file.apa60,   #
                           apa61 LIKE apa_file.apa61,   #
                           apb03 LIKE apb_file.apb03,
                           apb04 LIKE apb_file.apb04, #憑證單號(驗收單號)
                           apb05 LIKE apb_file.apb05, #憑證單項次
                           apb06 LIKE apb_file.apb06,   #採購單號
                           apb07 LIKE apb_file.apb07,   #採購單項次
                           apb08 LIKE apb_file.apb08,   #未稅單價
                           apb09 LIKE apb_file.apb09,   #數量
                           apb10 LIKE apb_file.apb10,   #金額
                           apb21 LIKE apb_file.apb21,   #
                           apb22 LIKE apb_file.apb22,   #
                           gen02 LIKE gen_file.gen02,   #員工姓名
                           gem02 LIKE gem_file.gem02,   #部門簡稱
                           apb12 LIKE pmn_file.pmn04,   #料號
                           pmn041 LIKE pmn_file.pmn041, #品名
                           apa07 LIKE apa_file.apa07,   #廠商簡稱
                           azi03 LIKE azi_file.azi03,   #單位小數位數
                           azi04 LIKE azi_file.azi04,   #金額小數位數
                           azi05 LIKE azi_file.azi05,   #小計小數位數
                           apb37 LIKE apb_file.apb37    #FUN-A60056 來源營運中心
                        END RECORD,
      l_amt11,l_amt12,l_amt13,l_amt14,l_amt15,l_amt16,l_amt17,l_amt18,l_amt19,
      l_amt21,l_amt22,l_amt23,l_amt24,l_amt25,l_amt26,l_amt27,l_amt28,l_amt29,
      l_amt31,l_amt32,l_amt33,l_amt34,l_amt35,l_amt36,l_amt37,l_amt38,l_amt39,
      l_amt,l_diff         LIKE type_file.num20_6,     # No.FUN-690028 DECIMAL(20,6),
      l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY  sr.apa21,sr.apa06,sr.apa08,sr.apa01
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
#NO.FUN540057--begin
         PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                        g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                        g_x[41],g_x[42],g_x[43],g_x[44] CLIPPED
         PRINTX name=H2 g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],
                        g_x[50],g_x[51] CLIPPED
         PRINT g_dash1
#NO.FUN540057--end
#No.FUN-580010 --end
      LET l_last_sw = 'n'
      IF g_pageno = 1 THEN
         LET l_amt31=0 LET l_amt32=0 LET l_amt33=0
         LET l_amt34=0 LET l_amt35=0 LET l_amt36=0
         LET l_amt37=0 LET l_amt38=0 LET l_amt39=0
      END IF
 
   BEFORE GROUP OF sr.apa21
      LET l_amt21=0 LET l_amt22=0 LET l_amt23=0
      LET l_amt24=0 LET l_amt25=0 LET l_amt26=0
      LET l_amt27=0 LET l_amt28=0 LET l_amt29=0
 
   BEFORE GROUP OF sr.apa06    # 付款廠商編號
      IF tm.t = 'Y' THEN SKIP TO TOP OF PAGE END IF
#No.FUN-580010 --start
      PRINT g_x[19] CLIPPED,sr.apa06,' ',sr.apa07,
            COLUMN g_c[34],g_x[20] CLIPPED,sr.apa21,COLUMN g_c[36],sr.gen02  CLIPPED,
            COLUMN g_c[38],g_x[21] CLIPPED,sr.apa22,COLUMN g_c[40],sr.gem02  CLIPPED
#No.FUN-580010 --end
{T}   SKIP 1 LINE
      LET l_amt11=0 LET l_amt12=0 LET l_amt13=0
      LET l_amt14=0 LET l_amt15=0 LET l_amt16=0
      LET l_amt17=0 LET l_amt18=0 LET l_amt19=0
 
#NO.FUN540057--begin
   BEFORE GROUP OF sr.apa01    # 帳款編號
#No.FUN-580010 --start
      PRINTX name=D1
            COLUMN g_c[31],sr.apa01,
            COLUMN g_c[32],sr.apa08,
            COLUMN g_c[33],sr.apa36,
            COLUMN g_c[34],sr.apa02,
            COLUMN g_c[35],sr.apa15,
            COLUMN g_c[36],sr.apa13,
            COLUMN g_c[37],sr.apa12,
            COLUMN g_c[38],sr.apa19,
            COLUMN g_c[39],sr.apa11,
            COLUMN g_c[40],sr.apa24 USING '##',
            COLUMN g_c[41],cl_numfor(sr.apa31,18,g_azi04) CLIPPED,
            COLUMN g_c[42],cl_numfor(sr.apa32,18,g_azi04) CLIPPED,
            COLUMN g_c[43],cl_numfor(sr.apa33,18,g_azi04) CLIPPED,
            COLUMN g_c[44],cl_numfor(sr.apa34,18,g_azi04) CLIPPED
     PRINT  g_dash1
#NO.FUN540057--end
 
   ON EVERY ROW
      PRINTX name=D2
            #COLUMN g_c[45],sr.apb21,'-',sr.apb22 USING "&&&&",   #MOD-710139
            #COLUMN g_c[46],sr.apb06,'-',sr.apb07 USING "&&&&",   #MOD-710139
            COLUMN g_c[45],sr.apb21,'-',sr.apb22 USING "&&&&&",   #MOD-710139
            COLUMN g_c[46],sr.apb06,'-',sr.apb07 USING "&&&&&",   #MOD-710139
            COLUMN g_c[47],sr.apb12,
            COLUMN g_c[48],sr.pmn041,
            COLUMN g_c[49],cl_numfor(sr.apb08,18,g_azi03) CLIPPED,
            COLUMN g_c[50],cl_numfor(sr.apb09,18,3) CLIPPED,
            COLUMN g_c[51],cl_numfor(sr.apb10,18,g_azi04) CLIPPED
 
   AFTER GROUP OF sr.apa01
      LET l_diff = sr.apa31 - sr.apa57
      IF sr.apa31 != sr.apa57 THEN
         PRINTX name=S1
               COLUMN g_c[47],g_x[26] CLIPPED,sr.apa56,
               COLUMN g_c[48],g_x[27] CLIPPED,
               COLUMN g_c[49],cl_numfor(l_diff,18,g_azi05) CLIPPED;
      END IF
      PRINTX name=S2
            COLUMN g_c[50],g_x[22] CLIPPED,
            COLUMN g_c[51],cl_numfor(sr.apa57,18,g_azi05) CLIPPED
#No.FUN-580010 --end
      SKIP 1 LINE
      LET l_amt11 = l_amt11 + sr.apa31 LET l_amt12 = l_amt12 + sr.apa32
      LET l_amt13 = l_amt13 + sr.apa60 LET l_amt14 = l_amt14 + sr.apa61
      LET l_amt18 = l_amt18 + sr.apa57 LET l_amt19 = l_amt19 + sr.apa20
      LET l_amt21 = l_amt21 + sr.apa31 LET l_amt22 = l_amt22 + sr.apa32
      LET l_amt23 = l_amt23 + sr.apa60 LET l_amt24 = l_amt24 + sr.apa61
      LET l_amt28 = l_amt28 + sr.apa57 LET l_amt29 = l_amt29 + sr.apa20
      LET l_amt31 = l_amt31 + sr.apa31 LET l_amt32 = l_amt32 + sr.apa32
      LET l_amt33 = l_amt33 + sr.apa60 LET l_amt34 = l_amt34 + sr.apa61
      LET l_amt38 = l_amt38 + sr.apa57 LET l_amt39 = l_amt39 + sr.apa20
      CASE WHEN sr.apa56 = '2' LET l_amt15 = l_amt15 + l_diff
                               LET l_amt25 = l_amt25 + l_diff
                               LET l_amt35 = l_amt35 + l_diff
           WHEN sr.apa56 = '3' LET g_chr = '1'
           WHEN sr.apa56 = '4' LET l_amt16 = l_amt16 + l_diff
                               LET l_amt26 = l_amt26 + l_diff
                               LET l_amt36 = l_amt36 + l_diff
           OTHERWISE           LET l_amt17 = l_amt17 + l_diff
                               LET l_amt27 = l_amt27 + l_diff
                               LET l_amt37 = l_amt37 + l_diff
      END CASE
 
   AFTER GROUP OF sr.apa06   #付款廠商
      LET l_amt = l_amt11 - l_amt13
#No.FUN-580010 --start
      PRINT 2 SPACES,g_x[19].substring(1,4) CLIPPED,COLUMN 07,
            g_x[52] CLIPPED,cl_numfor(l_amt11,18,g_azi05) CLIPPED,' - ',
            g_x[56] CLIPPED,cl_numfor(l_amt13,18,g_azi05) CLIPPED,' = ',
                            cl_numfor(l_amt  ,18,g_azi05) CLIPPED,' ',
            g_x[55] CLIPPED,cl_numfor(l_amt15,18,g_azi05) CLIPPED,' ',
            g_x[58] CLIPPED,cl_numfor(l_amt18,18,g_azi05) CLIPPED
      LET l_amt = l_amt12 - l_amt14
      PRINT COLUMN 07,
            g_x[53] CLIPPED,cl_numfor(l_amt12,18,g_azi05) CLIPPED,' - ',
            g_x[53] CLIPPED,cl_numfor(l_amt14,18,g_azi05) CLIPPED,' = ',
                            cl_numfor(l_amt  ,18,g_azi05) CLIPPED,' ',
            g_x[56] CLIPPED,cl_numfor(l_amt16,18,g_azi05) CLIPPED
      LET l_amt = l_amt11 + l_amt12 - l_amt13 - l_amt14
      PRINT COLUMN 07,
           g_x[54] CLIPPED,cl_numfor(l_amt11+l_amt12,18,g_azi05) CLIPPED,' - ',
           g_x[54] CLIPPED,cl_numfor(l_amt13+l_amt14,18,g_azi05) CLIPPED,' = ',
                            cl_numfor(l_amt  ,18,g_azi05) CLIPPED,' ',
            g_x[57] CLIPPED,cl_numfor(l_amt17,18,g_azi05) CLIPPED,' ',
            g_x[59] CLIPPED,cl_numfor(l_amt19,18,g_azi05) CLIPPED
      PRINT g_dash[1,g_len]
      SKIP 1 LINE
 
   ON LAST ROW
      LET l_amt = l_amt31 - l_amt33
      PRINT 2 SPACES,g_x[25] CLIPPED,COLUMN 07,
            g_x[52] CLIPPED,cl_numfor(l_amt31,18,g_azi05) CLIPPED,' - ',
            g_x[56] CLIPPED,cl_numfor(l_amt33,18,g_azi05) CLIPPED,' = ',
                            cl_numfor(l_amt  ,18,g_azi05) CLIPPED,' ',
            g_x[55] CLIPPED,cl_numfor(l_amt35,18,g_azi05) CLIPPED,' ',
            g_x[58] CLIPPED,cl_numfor(l_amt38,18,g_azi05) CLIPPED
      LET l_amt = l_amt32 - l_amt34
      PRINT COLUMN 07,
            g_x[53] CLIPPED,cl_numfor(l_amt32,18,g_azi05) CLIPPED,' - ',
            g_x[53] CLIPPED,cl_numfor(l_amt34,18,g_azi05) CLIPPED,' = ',
                            cl_numfor(l_amt  ,18,g_azi05) CLIPPED,' ',
            g_x[53] CLIPPED,cl_numfor(l_amt36,18,g_azi05) CLIPPED
      LET l_amt = l_amt31 + l_amt32 - l_amt33 - l_amt34
      PRINT COLUMN 07,
           g_x[54] CLIPPED,cl_numfor(l_amt31+l_amt32,18,g_azi05) CLIPPED,' - ',
           g_x[54] CLIPPED,cl_numfor(l_amt33+l_amt34,18,g_azi05) CLIPPED,' = ',
                            cl_numfor(l_amt  ,18,g_azi05) CLIPPED,' ',
            g_x[57] CLIPPED,cl_numfor(l_amt37,18,g_azi05) CLIPPED,' ',
            g_x[59] CLIPPED,cl_numfor(l_amt39,18,sr.azi05) CLIPPED
#No.FUN-580010 --end
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         PRINT g_dash[1,g_len]
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
#Patch....NO.TQC-610035 <> #
