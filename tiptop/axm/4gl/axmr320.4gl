# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmr320.4gl
# Descriptions...: 估價單成本一覽表列印
# Date & Author..: 00/03/07 By Melody
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.TQC-5A0046 05/10/14 By Carrier 報表格式修改
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-670106 06/08/24 By bnlent voucher型報表轉template1
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-740269 07/04/25 By bnlent 報表表頭位置修改
# Modify.........: NO.FUN-850009 08/07/02 By zhaijie 老報表修改為CR
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 原抓取occ_file部份也要加判斷抓取ofd_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
# Modify.........: No.TQC-D40102 13/07/17 By lujh 估價單號、產品編號、客戶編號、部門編號、業務員號欄位增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(500)             # Where condition
              more    LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
          g_dash1_1     LIKE type_file.chr1000   # No.FUN-680137 VARCHAR(400)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
#NO.FUN-850009--start---
DEFINE   g_sql     STRING
DEFINE   g_str     STRING
DEFINE   l_table   STRING
DEFINE   l_table1  STRING
DEFINE   l_table2  STRING
DEFINE   l_table3  STRING      
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
    LET  g_sql = "oqa01.oqa_file.oqa01,",
                 "oqa02.oqa_file.oqa02,",
                 "oqa03.oqa_file.oqa03,",
                 "oqa05.oqa_file.oqa05,",
                 "oqa06.oqa_file.oqa06,",
                 "oqa07.oqa_file.oqa07,",
                 "oqa08.oqa_file.oqa08,",
                 "oqa09.oqa_file.oqa09,",
                 "oqa10.oqa_file.oqa10,",
                 "oqa031.oqa_file.oqa031,",
                 "oqa032.oqa_file.oqa032,",
                 "oqa12.oqa_file.oqa12,",
                 "l_gem02.gem_file.gem02,",
                 "l_gen02.gen_file.gen02,",
                 "l_occ02.occ_file.occ02,",
                 "tot_amt.oqb_file.oqb11,",
                 "t_azi03.azi_file.azi03,",
                 "t_azi04.azi_file.azi04,",
                 "t_azi05.azi_file.azi05,",
                 "t_azi07.azi_file.azi07"
   LET l_table = cl_prt_temptable('axmr320',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
 
    LET  g_sql = "oqb01.oqb_file.oqb01,",
                 "oqb02.oqb_file.oqb02,",
                 "oqb03.oqb_file.oqb03,",
                 "oqb031.oqb_file.oqb031,",
                 "oqb04.oqb_file.oqb04,",
                 "oqb05.oqb_file.oqb05,",
                 "oqb10.oqb_file.oqb10,",
                 "oqb11.oqb_file.oqb11,",
                 "oqb06.oqb_file.oqb06"
   LET l_table1 = cl_prt_temptable('axmr3201',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
    LET  g_sql = "oqc01.oqc_file.oqc01,",
                 "oqc02.oqc_file.oqc02,",
                 "oqc03.oqc_file.oqc03,",
                 "oqc031.oqc_file.oqc031,",
                 "oqc04.oqc_file.oqc04,",
                 "oqc06.oqc_file.oqc06,",
                 "oqc13.oqc_file.oqc13,",
                 "oqc14.oqc_file.oqc14,",
                 "l_ima02.ima_file.ima02"
   LET l_table2 = cl_prt_temptable('axmr3202',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   
    LET  g_sql = "oqd01.oqd_file.oqd01,",
                 "oqd02.oqd_file.oqd02,",
                 "oqd03.oqd_file.oqd03,",
                 "oqd04.oqd_file.oqd04"
   LET l_table3 = cl_prt_temptable('axmr3203',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF  
#NO.FUN-850009---end---
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc)
      THEN CALL axmr320_tm(0,0)             # Input print condition
      ELSE LET tm.wc="oqa01= '",tm.wc CLIPPED,"'"
           CALL axmr320()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr320_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr320_w AT p_row,p_col WITH FORM "axm/42f/axmr320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 #--------------No.TQC-610089 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CALL cl_opmsg('p')
 #--------------No.TQC-610089 end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oqa01,oqa02,oqa03,oqa05,oqa06,oqa07
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

      #TQC-D40102--add--str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oqa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_oqa01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa01
              NEXT FIELD oqa01
            WHEN INFIELD(oqa03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa03
              NEXT FIELD oqa03
            WHEN INFIELD(oqa05)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa05
              NEXT FIELD oqa05
            WHEN INFIELD(oqa06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa06
              NEXT FIELD oqa06
            WHEN INFIELD(oqa07)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa07
              NEXT FIELD oqa07
         END CASE
      #TQC-D40102--add--end--
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr320_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr320'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr320','9031',1)
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
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr320',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr320_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr320()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr320_w
END FUNCTION
 
FUNCTION axmr320()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    oqa      RECORD LIKE oqa_file.*
                    END RECORD
#NO.FUN-850009--start---
   DEFINE tot_amt,tot_oqb11,tot_oqc13,tot_oqc14,tot_oqd04   LIKE oqb_file.oqb11
   DEFINE l_oqb     RECORD LIKE oqb_file.*
   DEFINE l_oqc     RECORD LIKE oqc_file.*
   DEFINE l_oqd     RECORD LIKE oqd_file.*
   DEFINE l_occ02   LIKE occ_file.occ02
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_cnt     LIKE type_file.num5           #No.FUN-890011   
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF 
     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF   
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)                                
#NO.FUN-850009---end--- 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr320'  #NO.FUN-850009
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr320'                  #No.FUN-670106
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '-' END FOR                                #No.FUN-670106 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oqauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oqagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oqagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqauser', 'oqagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT * FROM oqa_file ",
               " WHERE 1=1 AND ",tm.wc CLIPPED,
               "   AND oqaconf != 'X' ",#mandy01/08/03 不為已作廢的估價單
 
               " ORDER BY oqa01 "
     PREPARE axmr320_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE axmr320_curs1 CURSOR FOR axmr320_prepare1
 
#     CALL cl_outnam('axmr320') RETURNING l_name            #NO.FUN-850009
#     START REPORT axmr320_rep TO l_name                    #NO.FUN-850009
 
     LET g_pageno = 0
     FOREACH axmr320_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#       OUTPUT TO REPORT axmr320_rep(sr.*)                  #NO.FUN-850009
#NO.FUN-850009----start----
      SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
        FROM azi_file WHERE azi01 = sr.oqa.oqa08
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oqa.oqa05
     #NO.FUN-890011--Add--Begin--# 
      SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01=sr.oqa.oqa06              
      IF l_cnt <> 0 THEN
        SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqa.oqa06
      ELSE
        SELECT ofd02 INTO l_occ02 FROM ofd_file WHERE ofd01=sr.oqa.oqa06
      END IF
     #NO.FUN-890011--Add--End--#              
#     SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqa.oqa06            #FUN-890011 Mark      
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oqa.oqa07
      LET tot_amt=0
      LET tot_oqb11=0
      LET tot_oqc13=0
      LET tot_oqc14=0
      LET tot_oqd04=0 
      LET l_oqb.oqb11=0
      LET l_oqc.oqc13=0
      LET l_oqc.oqc14=0
      LET l_oqd.oqd04=0 
      #----- 材料成本
      DECLARE oqb_cur CURSOR FOR
          SELECT * FROM oqb_file WHERE oqb01=sr.oqa.oqa01 ORDER BY oqb02
      FOREACH oqb_cur INTO l_oqb.*
          IF l_oqb.oqb05 IS NULL THEN LET l_oqb.oqb05=0 END IF
          IF l_oqb.oqb10 IS NULL THEN LET l_oqb.oqb10=0 END IF
          IF l_oqb.oqb11 IS NULL THEN LET l_oqb.oqb11=0 END IF
          EXECUTE insert_prep1 USING
            l_oqb.oqb01,l_oqb.oqb02,l_oqb.oqb03,l_oqb.oqb031,l_oqb.oqb04,
            l_oqb.oqb05,l_oqb.oqb10,l_oqb.oqb11,l_oqb.oqb06
          LET tot_oqb11=tot_oqb11+l_oqb.oqb11
      END FOREACH
      LET tot_amt=tot_amt+tot_oqb11
      #----- 人工/製費
      DECLARE oqc_cur CURSOR FOR
          SELECT * FROM oqc_file WHERE oqc01=sr.oqa.oqa01 ORDER BY oqc02
      FOREACH oqc_cur INTO l_oqc.*
          IF l_oqc.oqc13 IS NULL THEN LET l_oqc.oqc13=0 END IF
          IF l_oqc.oqc14 IS NULL THEN LET l_oqc.oqc14=0 END IF
          SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=l_oqc.oqc04
          EXECUTE insert_prep2 USING
            l_oqc.oqc01,l_oqc.oqc02,l_oqc.oqc03,l_oqc.oqc031,l_oqc.oqc04,
            l_oqc.oqc06,l_oqc.oqc13,l_oqc.oqc14,l_ima02
          LET tot_oqc13=tot_oqc13+l_oqc.oqc13
          LET tot_oqc14=tot_oqc14+l_oqc.oqc14
      END FOREACH
      LET tot_amt=tot_amt+tot_oqc13+tot_oqc14
      #----- 其他費用
      DECLARE oqd_cur CURSOR FOR
          SELECT * FROM oqd_file WHERE oqd01=sr.oqa.oqa01 ORDER BY oqd02
      FOREACH oqd_cur INTO l_oqd.*
          IF l_oqd.oqd04 IS NULL THEN LET l_oqd.oqd04=0 END IF
          EXECUTE insert_prep3 USING 
            l_oqd.oqd01,l_oqd.oqd02,l_oqd.oqd03,l_oqd.oqd04
          LET tot_oqd04=tot_oqd04+l_oqd.oqd04
      END FOREACH
      LET tot_amt=tot_amt+tot_oqd04
      EXECUTE insert_prep USING
        sr.oqa.oqa01,sr.oqa.oqa02,sr.oqa.oqa03,sr.oqa.oqa05,sr.oqa.oqa06,
        sr.oqa.oqa07,sr.oqa.oqa08,sr.oqa.oqa09,sr.oqa.oqa10,sr.oqa.oqa031,
        sr.oqa.oqa032,sr.oqa.oqa12,l_gem02,l_gen02,l_occ02,tot_amt,
        t_azi03,t_azi04,t_azi05,t_azi07
#NO.FUN-850009---end-----
     END FOREACH
 
#     FINISH REPORT axmr320_rep                             #NO.FUN-850009
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850009
#NO.FUN-850009--start-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'oqa01,oqa02,oqa03,oqa05,oqa06,oqa07')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('axmr320','axmr320',g_sql,g_str) 
#NO.FUN-850009----end----
END FUNCTION
#NO.FUN-850009----START--MARK--
#REPORT axmr320_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          sr        RECORD
#                    oqa      RECORD LIKE oqa_file.*
#                    END RECORD,                            #FUN-4C0096 modify
#          tot_amt,tot_oqb11,tot_oqc13,tot_oqc14,tot_oqd04 LIKE oqb_file.oqb11,
#          l_oqb     RECORD LIKE oqb_file.*,
#          l_oqc     RECORD LIKE oqc_file.*,
#          l_oqd     RECORD LIKE oqd_file.*,
#          l_ima02   LIKE ima_file.ima02,
#          l_occ02   LIKE occ_file.occ02,
#          l_gen02   LIKE gen_file.gen02,
#          l_gem02   LIKE gem_file.gem02
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oqa.oqa01
#  FORMAT
#   PAGE HEADER
#      #no.4560
#      SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
#       FROM azi_file WHERE azi01 = sr.oqa.oqa08
      #no.4560(end)
#FUN-670106----Begin--
##      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company 
##      IF g_towhom IS NULL OR g_towhom = ' '
##         THEN PRINT '';
##         ELSE PRINT 'TO:',g_towhom;
##      END IF
#       PRINT COLUMN  ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]     #No.TQC-740269 
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<',"/pageno"
#       PRINT g_head CLIPPED,pageno_total
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
#       #PRINT ' '                                                       #No.TQC-740269
##      LET g_pageno= g_pageno+1
##      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,' ',g_msg CLIPPED,
##            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##FUN-670106----End-- 
#      PRINT g_dash[1,g_len]
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oqa.oqa05
#      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqa.oqa06
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oqa.oqa07
#      #No.TQC-5A0046  --begin
#      PRINT COLUMN  01,g_x[11] CLIPPED,sr.oqa.oqa01,
#            COLUMN  55,g_x[16] CLIPPED,sr.oqa.oqa05,' ',l_gem02,
#            COLUMN 100,g_x[19] CLIPPED,sr.oqa.oqa08
#      PRINT COLUMN  01,g_x[12] CLIPPED,sr.oqa.oqa02,
#            COLUMN  55,g_x[17] CLIPPED,sr.oqa.oqa06,' ',l_occ02,
#            COLUMN 100,g_x[20] CLIPPED,cl_numfor(sr.oqa.oqa09,15,t_azi07)
#      PRINT COLUMN  01,g_x[13] CLIPPED,sr.oqa.oqa03,
#            COLUMN  55,g_x[18] CLIPPED,sr.oqa.oqa07,' ',l_gen02,
#            COLUMN 100,g_x[21] CLIPPED,cl_numfor(sr.oqa.oqa10,15,t_azi04)
#      PRINT COLUMN  10,sr.oqa.oqa031,
#            COLUMN 100,g_x[22] CLIPPED,sr.oqa.oqa12
#      PRINT COLUMN  10,sr.oqa.oqa032
#      #No.TQC-5A0046  --end
##     PRINT g_dash1_1[1,g_len]
#      PRINT g_dash2                                   #No.FUN-670106
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.oqa.oqa01
#      SKIP TO TOP OF PAGE
# 
#   AFTER GROUP OF sr.oqa.oqa01
#      LET tot_amt=0
#      LET tot_oqb11=0
#      LET tot_oqc13=0
#      LET tot_oqc14=0
#      LET tot_oqd04=0
#     
#     #----- 材料成本
#      #No.TQC-5A0046  --begin
##FUN-670106----Begin--  
#      PRINT COLUMN  01,g_x[23] CLIPPED
##      PRINT COLUMN  11,g_x[24] CLIPPED,
##            COLUMN  52,g_x[40] CLIPPED,
##           COLUMN  57,g_x[41] CLIPPED,
##            COLUMN  70,g_x[25] CLIPPED,
##            COLUMN  91,g_x[42] CLIPPED,
##            COLUMN 112,g_x[43] CLIPPED
##      PRINT '          ---------------------------------------- ---- ',
##            '------------ -------------------- -------------------- --------'
#     PRINTX name = H1  g_x[31],g_x[32], g_x[33], g_x[34], g_x[35], g_x[36],g_x[37] 
#     PRINT g_dash1
##FUN-670106----End--   
#      #PRINT COLUMN 02,g_x[26] CLIPPED,g_x[27] CLIPPED
#      #No.TQC-5A0046  --end
#      DECLARE oqb_cur CURSOR FOR
#          SELECT * FROM oqb_file WHERE oqb01=sr.oqa.oqa01 ORDER BY oqb02
#      FOREACH oqb_cur INTO l_oqb.*
#          IF l_oqb.oqb05 IS NULL THEN LET l_oqb.oqb05=0 END IF
#          IF l_oqb.oqb10 IS NULL THEN LET l_oqb.oqb10=0 END IF
#          IF l_oqb.oqb11 IS NULL THEN LET l_oqb.oqb11=0 END IF
#          #No.TQC-5A0046  --begin
##FUN-670106----Begin--   
#          PRINTX name = D1 
#                COLUMN  g_c[31],l_oqb.oqb03,
#                COLUMN  g_c[32],l_oqb.oqb031,
#                COLUMN  g_c[33],l_oqb.oqb04,
#                COLUMN  g_c[34],l_oqb.oqb05 USING '###########&.&&' ,
#                COLUMN  g_c[35],cl_numfor(l_oqb.oqb10,35,t_azi03),
#                COLUMN  g_c[36],cl_numfor(l_oqb.oqb11,36,t_azi04),
#                COLUMN  g_c[37],l_oqb.oqb06 
##FUN-670106---End--   
#          #No.TQC-5A0046  --end
#          LET tot_oqb11=tot_oqb11+l_oqb.oqb11
#      END FOREACH
#      #No.TQC-5A0046  --begin
##      PRINT COLUMN 91,'--------------------'
#      PRINT COLUMN g_c[35], g_dash2[1,g_w[35]]                              #No.FUN-670106 
#      PRINT COLUMN 01,g_x[38] CLIPPED,
#           COLUMN g_c[35],cl_numfor(tot_oqb11,35,t_azi05)                 #No.FUN-670106 
#      #No.TQC-5A0046  --end
# 
##     PRINT g_dash1_1[1,g_len]
#      PRINT g_dash2                                                     #No.FUN-670106  
#      PRINT
#      LET tot_amt=tot_amt+tot_oqb11
#     
#      #----- 人工/製費
# 
#       PRINT COLUMN 01,g_x[28] CLIPPED
#       PRINT COLUMN 01,g_x[29] CLIPPED,g_x[30] CLIPPED
#       PRINT COLUMN 01,g_x[61] CLIPPED,g_x[62] CLIPPED
#      DECLARE oqc_cur CURSOR FOR
#          SELECT * FROM oqc_file WHERE oqc01=sr.oqa.oqa01 ORDER BY oqc02
#      FOREACH oqc_cur INTO l_oqc.*
#          IF l_oqc.oqc13 IS NULL THEN LET l_oqc.oqc13=0 END IF
#          IF l_oqc.oqc14 IS NULL THEN LET l_oqc.oqc14=0 END IF
#          SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=l_oqc.oqc04
#  #No.FUN-670106-----begin---
#          PRINT COLUMN 1,l_oqc.oqc03 CLIPPED,' ',l_oqc.oqc031 CLIPPED,                                                             
#                COLUMN 22,l_oqc.oqc04,                                                                                              
#                COLUMN 43,l_oqc.oqc06 CLIPPED,                                                                                      
#                COLUMN 55,cl_numfor(l_oqc.oqc13,19,t_azi04)                                                                         
#          PRINT COLUMN 22,l_ima02,                                                                                                  
#                COLUMN 55,cl_numfor(l_oqc.oqc14,19,t_azi04) 
#          PRINT COLUMN 22,l_ima02,
#                COLUMN 55,cl_numfor(l_oqc.oqc14,19,t_azi04)
#  #No.FUN-670106-----end------
#          LET tot_oqc13=tot_oqc13+l_oqc.oqc13
#          LET tot_oqc14=tot_oqc14+l_oqc.oqc14
#      END FOREACH
#      PRINT COLUMN 52,'----------------------'           #No.FUN-670106
#      PRINT COLUMN 01,g_x[38] CLIPPED,
##No.FUN-670106------begin---
#            COLUMN 55,cl_numfor(tot_oqc13,19,t_azi04)
#      PRINT COLUMN 55,cl_numfor(tot_oqc14,19,t_azi04)
##     PRINT g_dash1_1[1,g_len]
#      PRINT g_dash2                         
##No.FUN-670106------end----               
#      PRINT
#      LET tot_amt=tot_amt+tot_oqc13+tot_oqc14
#
#      #----- 其他費用
#       PRINT COLUMN 01,g_x[63] CLIPPED
# #No.FUN-670106----begin--
#       PRINT COLUMN 01,g_x[64],COLUMN 42,g_x[65] CLIPPED
#       PRINT COLUMN 01,g_x[66] CLIPPED,g_x[67] CLIPPED
# #No.FUN-670106----end----
#      DECLARE oqd_cur CURSOR FOR
#          SELECT * FROM oqd_file WHERE oqd01=sr.oqa.oqa01 ORDER BY oqd02
#      FOREACH oqd_cur INTO l_oqd.*
#          IF l_oqd.oqd04 IS NULL THEN LET l_oqd.oqd04=0 END IF
# #No.FUN-670106----begin--
#           PRINT COLUMN 1,l_oqd.oqd03,                                                                                              
#                 COLUMN 42,cl_numfor(l_oqd.oqd04,19,t_azi04)   
# #No.FUN-670106----end---
#          LET tot_oqd04=tot_oqd04+l_oqd.oqd04
#      END FOREACH
#      PRINT COLUMN 42,'-------------------'                #No.FUN-670106
#      PRINT COLUMN 01,g_x[38] CLIPPED,
#            COLUMN 42,cl_numfor(tot_oqd04,19,t_azi05)     #No.FUN-670106
#      PRINT
#      LET tot_amt=tot_amt+tot_oqd04
 
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN 01,g_x[39] CLIPPED,
#            COLUMN 49,cl_numfor(tot_amt,18,t_azi05)
 
#   ON LAST ROW
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#END REPORT
#Patch....NO.TQC-610037 <001,002,003,004,005> #
#NO.FUN-850009----END--MARK--
