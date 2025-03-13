# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr640.4gl
# Descriptions...: 佣金資料列印
# Date & Author..: 02/12/06 By Leagh
# Modify.........: No.MOD-590003 05/09/06 By jackie 修正報表中依舊抓za的錯誤
# Modify.........: No.TQC-5A0046 05/10/14 By Carrier 報表格式修改
# Modify.........: No.TQC-650043 06/05/12 By CoCo cl_outnam需在assign g_len之前
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-670067 06/07/18 By baogui voucher型報表轉template1
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-790076 07/09/12 By judy 1.報表中制表日期在程序名稱之上
#                                                 2.選匯Excel時，程序名稱在最左邊
# Modify.........: NO.FUN-850009 08/07/02 By zhaijie 老報表修改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50044 10/05/17 By Carrier 加CONSTRCUT后权限内容
#
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改 
# Modify.........: No:TQC-D50057 13/07/16 By yangtt 增加傭金編號開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc     LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(500)             # Where condition
              b      LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01)              # Input condition(1/2/3)
              more   LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
#          g_x  ARRAY[35] OF LIKE aaf_file.aaf03      # No.FUN-680137 VARCHAR(40)         # Report Heading & prompt   #No.MOD-590003
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#NO.FUN-850009--start---
DEFINE   g_sql     STRING
DEFINE   g_str     STRING
DEFINE   l_table   STRING
DEFINE   l_table1  STRING
DEFINE   l_table2  STRING
#NO.FUN-850009---end---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
#NO.FUN-850009--start---
    LET  g_sql = "ofs01.ofs_file.ofs01,",
                 "ofs02.ofs_file.ofs02,",
                 "ofs04.ofs_file.ofs04,",
                 "ofs05.ofs_file.ofs05,",
                 "ofs06.ofs_file.ofs06,",
                 "ofs07.ofs_file.ofs07,",
                 "ofs08.ofs_file.ofs08,",
                 "ofs09.ofs_file.ofs09,",
                 "ofs10.ofs_file.ofs10,",
                 "ofs11.ofs_file.ofs11,",
                 "ofs12.ofs_file.ofs12,",
                 "ofs13.ofs_file.ofs13,",
                 "ofs14.ofs_file.ofs14,",
                 "ofs15.ofs_file.ofs15"
   LET l_table = cl_prt_temptable('axmr640',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
 
    LET  g_sql = "ofs02.ofs_file.ofs02,",
                 "occ02.occ_file.occ02,",
                 "ofu01.ofu_file.ofu01,",
                 "ofu02.ofu_file.ofu02,",
                 "ofu03.ofu_file.ofu03,",
                 "ofu04.ofu_file.ofu04,",
                 "ofu05.ofu_file.ofu05,",
                 "ofu06.ofu_file.ofu06,",
                 "ofu07.ofu_file.ofu07,",
                 "ofu08.ofu_file.ofu08,",
                 "ofu09.ofu_file.ofu09,",
                 "ofu10.ofu_file.ofu10,",
                 "ofu11.ofu_file.ofu11,",
                 "ofu12.ofu_file.ofu12,",
                 "ofu13.ofu_file.ofu13,",
                 "ofu14.ofu_file.ofu14"
   LET l_table1 = cl_prt_temptable('axmr6401',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
    LET  g_sql = "ofs02.ofs_file.ofs02,",
                 "ima02.ima_file.ima02,",
                 "ofv01.ofv_file.ofv01,",
                 "ofv02.ofv_file.ofv02,",
                 "ofv03.ofv_file.ofv03,",
                 "ofv04.ofv_file.ofv04,",
                 "ofv05.ofv_file.ofv05,",
                 "ofv06.ofv_file.ofv06,",
                 "ofv07.ofv_file.ofv07,",
                 "ofv08.ofv_file.ofv08,",
                 "ofv09.ofv_file.ofv09,",
                 "ofv10.ofv_file.ofv10,",
                 "ofv11.ofv_file.ofv11,",
                 "ofv12.ofv_file.ofv12,",
                 "ofv13.ofv_file.ofv13,",
                 "ofv14.ofv_file.ofv14"
   LET l_table2 = cl_prt_temptable('axmr6402',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
#NO.FUN-850009---end---
 
   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.b ='1'
  #LET tm.wc    = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmr640_tm(0,0)             # Input print condition
      ELSE CALL axmr640()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr640_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 25
 
   OPEN WINDOW axmr640_w AT p_row,p_col WITH FORM "axm/42f/axmr640"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET tm.b    = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofs01,ofs04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

   #TQC-D50057--add--start
      ON ACTION CONTROLP
         IF INFIELD (ofs01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofs"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ofs01
            NEXT FIELD ofs01
         END IF
   #TQC-D50057--add--end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.b,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[123]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr640'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr640','9031',1)   
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
                         " '",tm.b CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr640',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr640_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr640()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr640_w
END FUNCTION
 
FUNCTION axmr640()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          srs       RECORD
                    ofs       RECORD LIKE ofs_file.*
                    END RECORD,
          sru       RECORD
                    ofu       RECORD LIKE ofu_file.*,
                    ofs02     LIKE ofs_file.ofs02,
                    occ02     LIKE occ_file.occ02
                    END RECORD,
          srv       RECORD
                    ofv       RECORD LIKE ofv_file.*,
                    ofs02     LIKE ofs_file.ofs02,
                    ima02     LIKE ima_file.ima02
                    END RECORD
#NO.FUN-850009--start---
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF 
     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF   
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2) 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr640'                       
#NO.FUN-850009---end--- 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('',SQLCA.sqlcode,0)#No.FUN-660167
        CALL cl_err3("sel","zo_file",g_rlang,"",SQLCA.sqlcode,"","",0)  #No.FUN-660167 
     END IF
#No.MOD-590003 --start--
#     DECLARE axmr640_za_cur CURSOR FOR
#             SELECT za02,za05 FROM za_file
#              WHERE za01 = "axmr640" AND za03 = g_rlang
#     FOREACH axmr640_za_cur INTO g_i,l_za05
#        LET g_x[g_i] = l_za05
#     END FOREACH
#No.MOD-590003 --end--
#     CALL cl_outnam('axmr640') RETURNING l_name ##TQC-650043##      #NO.FUN-850009
     CASE WHEN tm.b = '1'
               LET g_len = 127  #No.TQC-5A0046
               #Begin:FUN-980030
               #               IF g_priv2='4' THEN
               #                   LET tm.wc = tm.wc CLIPPED," AND ofsuser = '",g_user,"'"
               #               END IF
               #               IF g_priv3='4' THEN
               #                   LET tm.wc = tm.wc CLIPPED," AND ofsgrup MATCHES '",
               #                               g_grup CLIPPED,"*'"
               #               END IF
 
               #               IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
               #                   LET tm.wc = tm.wc CLIPPED," AND ofsgrup IN ",cl_chk_tgrup_list()
               #               END IF
               LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofsuser', 'ofsgrup')
               #End:FUN-980030
 
               LET l_sql="SELECT * FROM ofs_file ",
                         " WHERE ofs03 = '1' AND ",tm.wc CLIPPED,
                         " ORDER BY ofs01 "
          WHEN tm.b = '2'
               LET g_len = 148  #No.TQC-5A0046
               #Begin:FUN-980030
               #               IF g_priv2='4' THEN
               #                   LET tm.wc = tm.wc CLIPPED," AND ofuuser = '",g_user,"'"
               #               END IF
               #               IF g_priv3='4' THEN
               #                   LET tm.wc = tm.wc CLIPPED," AND ofugrup MATCHES '",
               #                               g_grup CLIPPED,"*'"
               #               END IF
 
               #               IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
               #                   LET tm.wc = tm.wc CLIPPED," AND ofugrup IN ",cl_chk_tgrup_list()
               #               END IF
               #End:FUN-980030
               LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofuuser', 'ofugrup')  #No.TQC-A50044
 
               LET l_sql="SELECT ofu_file.*,ofs02,occ02 ",
                         "  FROM ofu_file,ofs_file,OUTER occ_file ",
                         " WHERE ofs01 = ofu01 AND ofu_file.ofu02 = occ_file.occ01 ",
                         "   AND ",tm.wc CLIPPED,
                         " ORDER BY ofu01,ofu02 "
          WHEN tm.b = '3'
               LET g_len = 188  #No.TQC-5A0046
               #Begin:FUN-980030
               #               IF g_priv2='4' THEN
               #                   LET tm.wc = tm.wc CLIPPED," AND ofvuser = '",g_user,"'"
               #               END IF
               #               IF g_priv3='4' THEN
               #                   LET tm.wc = tm.wc CLIPPED," AND ofvgrup MATCHES '",
               #                               g_grup CLIPPED,"*'"
               #               END IF
 
               #               IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
               #                   LET tm.wc = tm.wc CLIPPED," AND ofvgrup IN ",cl_chk_tgrup_list()
               #               END IF
               #End:FUN-980030
               LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofvuser', 'ofvgrup')  #No.TQC-A50044
 
               LET l_sql="SELECT ofv_file.*,ofs02,ima02 ",
                         "  FROM ofv_file,ofs_file,OUTER ima_file ",
                         " WHERE ofs01 = ofv01 AND ofv_file.ofv02 = ima_file.ima01",
                         "   AND ",tm.wc CLIPPED,
                         " ORDER BY ofv01,ofv02 "
          OTHERWISE
#No.FUN-670067--begin      
           #    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file    #No.FUN-670067
           #     WHERE zz01 = 'axmr640'        #No.FUN-670067
           #    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF   #No.FUN-670067
#No.FUN-670067--end
     END CASE
 #    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR   #No.FUN-670067
     PREPARE axmr640_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr640_curs1 CURSOR FOR axmr640_prepare1
 
     #CALL cl_outnam('axmr640') RETURNING l_name##TQC-650043##
     CASE
       WHEN tm.b = '1'    #依佣金定義
#            START REPORT axmr640s_rep TO l_name            #NO.FUN-850009
#            LET g_pageno = 0                               #NO.FUN-850009
            FOREACH axmr640_curs1 INTO srs.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
               END IF
#               OUTPUT TO REPORT axmr640s_rep(srs.*)        #NO.FUN-850009
#NO.FUN-850009----start---
              EXECUTE insert_prep USING
                srs.ofs.ofs01,srs.ofs.ofs02,srs.ofs.ofs04,srs.ofs.ofs05,
                srs.ofs.ofs06,srs.ofs.ofs07,srs.ofs.ofs08,srs.ofs.ofs09,
                srs.ofs.ofs10,srs.ofs.ofs11,srs.ofs.ofs12,srs.ofs.ofs13,
                srs.ofs.ofs14,srs.ofs.ofs15
#NO.FUN-850009----end----
            END FOREACH
#            FINISH REPORT axmr640s_rep                     #NO.FUN-850009
       WHEN tm.b = '2'    #依客戶
#            START REPORT axmr640u_rep TO l_name            #NO.FUN-850009
#            LET g_pageno = 0                               #NO.FUN-850009
            FOREACH axmr640_curs1 INTO sru.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach #2:',SQLCA.sqlcode,1) EXIT FOREACH
               END IF
#               OUTPUT TO REPORT axmr640u_rep(sru.*)        #NO.FUN-850009
#NO.FUN-850009----start---
              EXECUTE insert_prep1 USING
                sru.ofs02,sru.occ02,sru.ofu.ofu01,sru.ofu.ofu02,sru.ofu.ofu03,
                sru.ofu.ofu04,sru.ofu.ofu05,sru.ofu.ofu06,sru.ofu.ofu07,
                sru.ofu.ofu08,sru.ofu.ofu09,sru.ofu.ofu10,sru.ofu.ofu11,
                sru.ofu.ofu12,sru.ofu.ofu13,sru.ofu.ofu14
#NO.FUN-850009----end----
            END FOREACH
#            FINISH REPORT axmr640u_rep                     #NO.FUN-850009
       WHEN tm.b = '3'    #依料件
#            START REPORT axmr640v_rep TO l_name            #NO.FUN-850009
#           LET g_pageno = 0                                #NO.FUN-850009
            FOREACH axmr640_curs1 INTO srv.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach #3:',SQLCA.sqlcode,1) EXIT FOREACH
               END IF
#               OUTPUT TO REPORT axmr640v_rep(srv.*)        #NO.FUN-850009
#NO.FUN-850009----start---
              EXECUTE insert_prep2 USING
                srv.ofs02,srv.ima02,srv.ofv.ofv01,srv.ofv.ofv02,srv.ofv.ofv03,
                srv.ofv.ofv04,srv.ofv.ofv05,srv.ofv.ofv06,srv.ofv.ofv07,
                srv.ofv.ofv08,srv.ofv.ofv09,srv.ofv.ofv10,srv.ofv.ofv11,
                srv.ofv.ofv12,srv.ofv.ofv13,srv.ofv.ofv14
#NO.FUN-850009----end----               
            END FOREACH
#            FINISH REPORT axmr640v_rep                     #NO.FUN-850009
     END CASE
  #   LET g_pageno =0   #No.FUN-670067  
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850009
#NO.FUN-850009--start-----
     CASE
       WHEN tm.b = '1'  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       WHEN tm.b = '2'  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
       WHEN tm.b = '3'  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
     END CASE
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ofs01,ofs04')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.b
     CASE
       WHEN tm.b = '1'  LET l_name = 'axmr640'
       WHEN tm.b = '2'  LET l_name = 'axmr640_1'
       WHEN tm.b = '3'  LET l_name = 'axmr640_2'
     END CASE
     CALL cl_prt_cs3('axmr640',l_name,g_sql,g_str) 
END FUNCTION
#NO.FUN-850009--start---mark--
#REPORT axmr640s_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          sr        RECORD
#                    ofs       RECORD LIKE ofs_file.*
#                    END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ofs.ofs01
#  FORMAT
#   PAGE HEADER
#No.FUN-670067--begin
  #    PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
  #    PRINT ' '
  #    PRINT (g_len-12)/2 SPACES,g_x[1].substring(1,12) CLIPPED
  #    PRINT ' '
#  #    PRINT g_x[2] CLIPPED, g_today,' ',TIME CLIPPED,
#  #          COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING'<<<'
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED   #No.FUN-670067
#       PRINT COLUMN((g_len-FGL_WIDTH(g_x[9] CLIPPED))/2)+1,g_x[9] CLIPPED   #TQC-790076
#       LET g_pageno = g_pageno + 1   #NO.FUN-670067
#       LET pageno_total = PAGENO USING '<<<',"/pageno"   #No.FUN-670067
#       PRINT g_head CLIPPED,pageno_total       #No.FUN-670067
##      PRINT COLUMN((g_len-12)/2)+1,g_x[1].substring(1,12) CLIPPED   #No.FUN-670067  #TQC-790076
#      PRINT g_dash[1,g_len]
#No.FUN-670067--end
      #No.TQC-5A0046  --begin 
#No.FUN-670067--begin         
  #    PRINT COLUMN  1,g_x[11] CLIPPED,     #NO.FUN-670067 
  #          COLUMN 10,g_x[21] CLIPPED,     #No.FUN-670067 
  #          COLUMN 51,g_x[12] CLIPPED,     #No.FUN-670067     
  #          COLUMN 93,g_x[13] CLIPPED      #No.FUN-670067 
  #    PRINT COLUMN 51,g_x[14] CLIPPED,COLUMN 93,g_x[15] CLIPPED  #No.FUN-670067 
  #    PRINT '-------- ---------------------------------------- ',#No.FUN-670067  
  #          '------------ ------------ ',   #No.FUN-670067 
  #          '------------ ------------ ------------ ------------' #No.FUN-670067 
      #No.TQC-5A0046  --end
#No.FUN-670067--end
##NO.FUN-670067--begin
#      PRINTX name=H1 g_x[31],g_x[32],g_x[35],g_x[36],g_x[37],
#                     g_x[38],g_x[39],g_x[40]
#      PRINTX name=H2 g_x[41],g_x[42],g_x[45],g_x[46],g_x[47],
#                     g_x[48],g_x[49],g_x[50]
#      PRINT g_dash1
#NO.FUN-670067--end
#      LET l_last_sw = 'n'
 
#   ON EVERY ROW
      #No.TQC-5A0046  --begin
#NO.FUN-670067--begin  
    #  PRINT COLUMN 1, sr.ofs.ofs01 CLIPPED,
    #        COLUMN 10,sr.ofs.ofs02 CLIPPED,
    #        COLUMN 51,sr.ofs.ofs04 CLIPPED;
#       PRINTX name=D1 COLUMN g_c[31],sr.ofs.ofs01 CLIPPED,  #NO.FUN-670067
#                      COLUMN g_c[32],sr.ofs.ofs02 CLIPPED;  #NO.FUN-670067
#      CASE sr.ofs.ofs04
    #    WHEN '1'  PRINT COLUMN 53,g_x[17] CLIPPED;
    #    WHEN '2'  PRINT COLUMN 53,g_x[18] CLIPPED;
    #    WHEN '3'  PRINT COLUMN 53,g_x[19] CLIPPED;
    #    WHEN '4'  PRINT COLUMN 53,g_x[20] CLIPPED;
#         WHEN '1'  PRINTX name=D1 COLUMN g_c[35],sr.ofs.ofs04 ,g_x[17] CLIPPED;    #NO.FUN-670067
#         WHEN '2'  PRINTX name=D1 COLUMN g_c[35],sr.ofs.ofs04 ,g_x[18] CLIPPED;    #NO.FUN-670067
#         WHEN '3'  PRINTX name=D1 COLUMN g_c[35],sr.ofs.ofs04 ,g_x[19] CLIPPED;    #NO.FUN-670067
#         WHEN '4'  PRINTX name=D1 COLUMN g_c[35],sr.ofs.ofs04 ,g_x[20] CLIPPED;    #NO.FUN-670067
#      END CASE
   #   PRINT COLUMN 64,sr.ofs.ofs06 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN  77,sr.ofs.ofs08 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN  90,sr.ofs.ofs10 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN 103,sr.ofs.ofs12 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN 116,sr.ofs.ofs14 USING '#######&.&&&'   #NO.FUN-670067
   #   PRINT COLUMN  51,sr.ofs.ofs05 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN  64,sr.ofs.ofs07 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN  77,sr.ofs.ofs09 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN  90,sr.ofs.ofs11 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN 103,sr.ofs.ofs13 USING '#######&.&&&',  #NO.FUN-670067
   #         COLUMN 116,sr.ofs.ofs15 USING '#######&.&&&'   #NO.FUN-670067
#       PRINTX name=D1 COLUMN g_c[36],sr.ofs.ofs06 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[37],sr.ofs.ofs08 USING '#######&.&&&',  #NO.FUN-670067 
#                      COLUMN g_c[38],sr.ofs.ofs10 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[39],sr.ofs.ofs12 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[40],sr.ofs.ofs14 USING '#######&.&&&'   #NO.FUN-670067
#       PRINTX name=D2 COLUMN g_c[45],sr.ofs.ofs05 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[46],sr.ofs.ofs07 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[47],sr.ofs.ofs09 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[48],sr.ofs.ofs11 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[49],sr.ofs.ofs13 USING '#######&.&&&',  #NO.FUN-670067
#                      COLUMN g_c[50],sr.ofs.ofs15 USING '#######&.&&&'  #NO.FUN-670067
#NO.FUN-670067--end
      #No.TQC-5A0046  --end
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
 
#REPORT axmr640u_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          sr        RECORD
#                    ofu       RECORD LIKE ofu_file.*,
#                    ofs02     LIKE ofs_file.ofs02,
#                    occ02     LIKE occ_file.occ02
#                    END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ofu.ofu01,sr.ofu.ofu02
#  FORMAT
#   PAGE HEADER  
#NO.FUN-670067--begin
    #  PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
    #  PRINT ' '
    #  PRINT (g_len-14)/2 SPACES,g_x[1].substring(13,26) CLIPPED
    #  PRINT ' '
    #  PRINT g_x[2] CLIPPED, g_today,' ',TIME CLIPPED,
#    #        COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING'<<<'
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#       PRINT COLUMN((g_len-FGL_WIDTH(g_x[10] CLIPPED))/2)+1,g_x[10] CLIPPED   #TQC-790076
#       LET g_pageno = g_pageno + 1   #NO.FUN-670067
#       LET pageno_total = PAGENO USING '<<<',"/pageno"    #NO.FUN-670067
#       PRINT g_head CLIPPED,pageno_total       #NO.FUN-670067
  #    PRINT COLUMN((g_len-14)/2)+1,g_x[1].substring(13,26) CLIPPED  #TQC-790076
#      PRINT g_dash[1,g_len]
#NO.FUN-670067--end
#NO.FUN-670067--begin
      #No.TQC-5A0046  --begin
   #   PRINT COLUMN   1,g_x[11] CLIPPED,
   #         COLUMN  10,g_x[21] CLIPPED,
   #         COLUMN  51,g_x[16].substring(1,8)   CLIPPED,
   #         COLUMN  72,g_x[12].substring(1,8)   CLIPPED,
   #         COLUMN  85,g_x[12].substring(17,22) CLIPPED,
   #         COLUMN  98,g_x[12].substring(30,35) CLIPPED,
   #         COLUMN 111,g_x[13].substring(1,6)   CLIPPED,
   #         COLUMN 124,g_x[13].substring(14,19) CLIPPED,
   #         COLUMN 137,g_x[13].substring(27,32) CLIPPED
   #   PRINT COLUMN  51,g_x[16].substring(10,17) CLIPPED,
   #         COLUMN  72,g_x[14].substring(1,8)   CLIPPED,
   #         COLUMN  85,g_x[14].substring(17,22) CLIPPED,
   #         COLUMN  98,g_x[14].substring(30,35) CLIPPED,
   #         COLUMN 111,g_x[15].substring(1,6)   CLIPPED,
   #         COLUMN 124,g_x[15].substring(14,19) CLIPPED,
   #         COLUMN 137,g_x[15].substring(27,32) CLIPPED
   #   PRINT '-------- ---------------------------------------- -------------------- ------------ ',
   #         '------------ ------------ ------------ ------------ ------------'
#      #No.TQC-5A0046  --end
#       PRINTX name=H1 g_x[31],g_x[32],g_x[33],   #NO.FUN-670067
#                      g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]  #NO.FUN-670067
#
#       PRINTX name=H2 g_x[41],g_x[42],g_x[43],       #NO.FUN-670067       
#                      g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]  #NO.FUN-670067
#       PRINT g_dash1
#NO.FUN-670067--end               
#      LET l_last_sw = 'n'
#No.FUN-670067--begin
#   BEFORE GROUP OF sr.ofu.ofu01               #NO.FUN-670067
      #No.TQC-5A0046  --begin
   #    PRINT COLUMN  1,sr.ofu.ofu01 CLIPPED, #NO.FUN-670067
#   #          COLUMN 10,sr.ofs02     CLIPPED; #NO.FUN-670067
#        PRINTX name=D1 COLUMN g_c[31],sr.ofu.ofu01 CLIPPED, #NO.FUN-670067
#              COLUMN g_c[32],sr.ofs02     CLIPPED; #NO.FUN-670067
      #No.TQC-5A0046  --end
#No.FUN-670067--end
 
#   ON EVERY ROW
      #No.TQC-5A0046  --begin 
#NO.FUN-670067--begin
 #    PRINT COLUMN 51, sr.ofu.ofu02;    
#        #  COLUMN 72, sr.ofu.ofu03;   #NO.FUN-670067 
#      PRINTX name=D1 COLUMN g_c[33],sr.ofu.ofu02;        
#NO.FUN-670067--end
#NO.FUN-670067--begin
#      CASE sr.ofu.ofu03
##       WHEN '1'  PRINT COLUMN 74,g_x[17] CLIPPED;
##       WHEN '2'  PRINT COLUMN 74,g_x[18] CLIPPED;
##       WHEN '3'  PRINT COLUMN 74,g_x[19] CLIPPED;
##       WHEN '4'  PRINT COLUMN 74,g_x[20] CLIPPED;
#        WHEN '1'  PRINTX name=D1 COLUMN g_c[35],sr.ofu.ofu03 CLIPPED, g_x[17] CLIPPED;
#        WHEN '2'  PRINTX name=D1 COLUMN g_c[35],sr.ofu.ofu03 CLIPPED, g_x[18] CLIPPED;
#        WHEN '3'  PRINTX name=D1 COLUMN g_c[35],sr.ofu.ofu03 CLIPPED, g_x[19] CLIPPED;
#        WHEN '4'  PRINTX name=D1 COLUMN g_c[35],sr.ofu.ofu03 CLIPPED, g_x[20] CLIPPED;
#      END CASE
#NO.FUN-670067--end
#NO.FUN-670067--begin
#      PRINT COLUMN  85,sr.ofu.ofu05 USING '#######&.&&&',
#            COLUMN  98,sr.ofu.ofu07 USING '#######&.&&&',
#            COLUMN 111,sr.ofu.ofu09 USING '#######&.&&&',
#            COLUMN 124,sr.ofu.ofu11 USING '#######&.&&&',
#            COLUMN 137,sr.ofu.ofu13 USING '#######&.&&&'
#      PRINT COLUMN  51,sr.occ02,
#            COLUMN  72,sr.ofu.ofu04 USING '#######&.&&&',
#            COLUMN  85,sr.ofu.ofu06 USING '#######&.&&&',
#            COLUMN  98,sr.ofu.ofu08 USING '#######&.&&&',
#            COLUMN 111,sr.ofu.ofu10 USING '#######&.&&&',
#            COLUMN 124,sr.ofu.ofu12 USING '#######&.&&&',
#            COLUMN 137,sr.ofu.ofu14 USING '#######&.&&&'
      #No.TQC-5A0046  --end
#      PRINTX name=D1 COLUMN g_c[36],sr.ofu.ofu05 USING '#######&.&&&',
#                     COLUMN g_c[37],sr.ofu.ofu07 USING '#######&.&&&',
#                     COLUMN g_c[38],sr.ofu.ofu09 USING '#######&.&&&',
#                     COLUMN g_c[39],sr.ofu.ofu11 USING '#######&.&&&',
#                     COLUMN g_c[40],sr.ofu.ofu13 USING '#######&.&&&'
#      PRINTX name=D2 COLUMN g_c[43],sr.occ02,
#                     COLUMN g_c[45],sr.ofu.ofu04 USING '#######&.&&&',
#                     COLUMN g_c[46],sr.ofu.ofu06 USING '#######&.&&&',
#                     COLUMN g_c[47],sr.ofu.ofu08 USING '#######&.&&&',
#                     COLUMN g_c[48],sr.ofu.ofu10 USING '#######&.&&&',
#                     COLUMN g_c[49],sr.ofu.ofu12 USING '#######&.&&&',
#                     COLUMN g_c[50],sr.ofu.ofu14 USING '#######&.&&&'
#NO.FUN-670067--end
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
 
#REPORT axmr640v_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,        # No.FUN-680137  VARCHAR(1)
#          sr        RECORD
#                    ofv       RECORD LIKE ofv_file.*,
#                    ofs02     LIKE ofs_file.ofs02,
#                    ima02     LIKE ima_file.ima02
#                    END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ofv.ofv01,sr.ofv.ofv02
#  FORMAT
#   PAGE HEADER
#NO.FUN-670067--begin
    #  PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
    #  PRINT ' '
    #  PRINT (g_len-14)/2 SPACES,g_x[1].substring(27,40) CLIPPED
    #  PRINT ' '
    #  PRINT g_x[2] CLIPPED, g_today,' ',TIME CLIPPED,
#    #        COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING'<<<'
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#       PRINT COLUMN((g_len-FGL_WIDTH(g_x[11] CLIPPED))/2)+1,g_x[11] CLIPPED   #TQC-790076
#       LET g_pageno = g_pageno + 1   #NO.FUN-670067
#       LET pageno_total = PAGENO USING '<<<',"/pageno"    #NO.FUN-670067
#       PRINT g_head CLIPPED,pageno_total       #NO.FUN-670067
##      PRINT COLUMN((g_len-12)/2)+1,g_x[1].substring(27,40) CLIPPED  #TQC-790076
#      PRINT g_dash[1,g_len]
#NO.FUN-670067--end
      #No.TQC-5A0046  --begin
#NO.FUN-670067--begin
   #   PRINT COLUMN   1,g_x[11]        CLIPPED,
   #         COLUMN  10,g_x[21] CLIPPED,
   #         COLUMN  51,g_x[16].substring(19,26) CLIPPED,
   #         COLUMN 112,g_x[12].substring(1,8)   CLIPPED,
   #         COLUMN 125,g_x[12].substring(17,22) CLIPPED,
   #         COLUMN 138,g_x[12].substring(30,35) CLIPPED,
   #         COLUMN 151,g_x[13].substring(1,6)   CLIPPED,
   #         COLUMN 164,g_x[13].substring(14,19) CLIPPED,
   #         COLUMN 177,g_x[13].substring(27,32) CLIPPED
   #   PRINT COLUMN  51,g_x[16].substring(28,35) CLIPPED,
   #         COLUMN 112,g_x[14].substring(1,8)  CLIPPED,
   #         COLUMN 125,g_x[14].substring(17,22) CLIPPED,
   #         COLUMN 138,g_x[14].substring(30,35) CLIPPED,
   #         COLUMN 151,g_x[15].substring(1,6) CLIPPED,
   #         COLUMN 164,g_x[15].substring(14,19) CLIPPED,
   #         COLUMN 177,g_x[15].substring(27,32) CLIPPED
   #   PRINT '-------- ---------------------------------------- ',
   #         '------------------------------------------------------------ ',
#   #         '------------ ------------ ------------ ------------ ------------',
#   #         ' ------------'
#      PRINTX name=H1 g_x[31],g_x[32],g_x[34],g_x[35],g_x[36],
#                     g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINTX name=H2 g_x[41],g_x[42],g_x[44],g_x[45],g_x[46],
#                     g_x[47],g_x[48],g_x[49],g_x[50]
#      PRINT g_dash1
#NO.FUN-670067--end
      #No.TQC-5A0046  --end
#      LET l_last_sw = 'n'
#NO.FUN-670067--begin
#   BEFORE GROUP OF sr.ofv.ofv01
      #No.TQC-5A0046  --begin
 #     PRINT COLUMN  1,sr.ofv.ofv01 CLIPPED;   #NO.FUN-670067
 #          COLUMN 10,sr.ofs02     CLIPPED;   #NO.FUN-670067
#      PRINTX name=D1 COLUMN g_c[31],sr.ofv.ofv01 CLIPPED,   #NO.FUN-670067
#            COLUMN g_c[32],sr.ofs02     CLIPPED;   #NO.FUN-670067
      #No.TQC-5A0046  --end  
#NO.FUN-670067--end
#   ON EVERY ROW
      #No.TQC-5A0046  --begin
#No.FUN-670067--begin
   #   PRINT COLUMN  51,sr.ofv.ofv02,   #NO.FUN-670067
#   #         COLUMN 112,sr.ofv.ofv03;   #NO.FUN-670067
#       PRINTX name=D1 COLUMN g_c[34],sr.ofv.ofv02;   #NO.FUN-670067
#      CASE sr.ofv.ofv03
   #     WHEN '1'  PRINT COLUMN 114,g_x[17] CLIPPED;  #NO.FUN-670067
   #     WHEN '2'  PRINT COLUMN 114,g_x[18] CLIPPED;  #NO.FUN-670067
   #     WHEN '3'  PRINT COLUMN 114,g_x[19] CLIPPED;  #NO.FUN-670067
   #     WHEN '4'  PRINT COLUMN 114,g_x[20] CLIPPED;  #NO.FUN-670067
#         WHEN '1'  PRINTX name=D1 COLUMN g_c[35],sr.ofv.ofv03 CLIPPED,g_x[17] CLIPPED;  #NO.FUN-670067
#         WHEN '2'  PRINTX name=D1 COLUMN g_c[35],sr.ofv.ofv03 CLIPPED,g_x[18] CLIPPED;  #NO.FUN-670067
#         WHEN '3'  PRINTX name=D1 COLUMN g_c[35],sr.ofv.ofv03 CLIPPED,g_x[19] CLIPPED;  #NO.FUN-670067
#         WHEN '4'  PRINTX name=D1 COLUMN g_c[35],sr.ofv.ofv03 CLIPPED,g_x[20] CLIPPED;  #NO.FUN-670067
#      END CASE
#No.FUN-670067--end
##NO.FUN-670067--begin
#   #   PRINT COLUMN 125,sr.ofv.ofv05 USING '#######&.&&&',
#   #         COLUMN 138,sr.ofv.ofv07 USING '#######&.&&&',
#   #         COLUMN 151,sr.ofv.ofv09 USING '#######&.&&&',
#   #         COLUMN 164,sr.ofv.ofv11 USING '#######&.&&&',
#   #         COLUMN 177,sr.ofv.ofv13 USING '#######&.&&&'
#   #   PRINT COLUMN  51,sr.ima02 CLIPPED,
#   #         COLUMN 112,sr.ofv.ofv04 USING '#######&.&&&',
#   #         COLUMN 125,sr.ofv.ofv06 USING '#######&.&&&',
#   #         COLUMN 138,sr.ofv.ofv08 USING '#######&.&&&',
#   #         COLUMN 151,sr.ofv.ofv10 USING '#######&.&&&',
#   #         COLUMN 164,sr.ofv.ofv12 USING '#######&.&&&',
#   #         COLUMN 177,sr.ofv.ofv14 USING '#######&.&&&'
#      PRINTX name=D1 COLUMN g_c[36],sr.ofv.ofv05 USING '#######&.&&&',
#                     COLUMN g_c[37],sr.ofv.ofv07 USING '#######&.&&&',
#                     COLUMN g_c[38],sr.ofv.ofv09 USING '#######&.&&&',
#                     COLUMN g_c[39],sr.ofv.ofv11 USING '#######&.&&&',
#                     COLUMN g_c[40],sr.ofv.ofv13 USING '#######&.&&&'
#      PRINTX name=D2 COLUMN g_c[44],sr.ima02 CLIPPED,
#                     COLUMN g_c[45],sr.ofv.ofv04 USING '#######&.&&&',
#                     COLUMN g_c[46],sr.ofv.ofv06 USING '#######&.&&&',
#                     COLUMN g_c[47],sr.ofv.ofv08 USING '#######&.&&&',
#                     COLUMN g_c[48],sr.ofv.ofv10 USING '#######&.&&&',
#                     COLUMN g_c[49],sr.ofv.ofv12 USING '#######&.&&&',
#                     COLUMN g_c[50],sr.ofv.ofv14 USING '#######&.&&&'
      #No.TQC-5A0046  --end
#NO.FUN-670067--end
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#Patch....NO.TQC-610037 <001> #
#NO.FUN-850009--end---mark--
