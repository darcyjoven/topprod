# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr900.4gl
# Descriptions...: Paylink download 付款單列印作業
# Date & Author..: 981020 by plum
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-550099 05/05/25 By echo 新增報表備註
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.FUN-710086 07/03/01 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/22 By Nicole 新增 CR 參數
# Modify.........: No.FUN-840080 08/04/18 By baofei 把SQL中的table寫法加上用上別名
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By chenls 跨DB改為不跨DB
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD
 
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   l_table     STRING                    #FUN-710086 add 
DEFINE   g_sql       STRING                    #FUN-710086 add
DEFINE   g_str       STRING                    #FUN-710086 add
DEFINE   l_table1    STRING                    #FUN-720053 add
DEFINE   l_table2    STRING                    #FUN-720053 add
DEFINE   l_table3    STRING                    #FUN-720053 add
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
 
#No.FUN-720053--begin
   LET g_sql = "apf01.apf_file.apf01,",
               "apf02.apf_file.apf02,",
               "apf03.apf_file.apf03,",
               "apf44.apf_file.apf44,",
               "aph05.aph_file.aph05,",
               "aph07.aph_file.aph07,",
               "aph13.aph_file.aph13,",
               "pmc081.pmc_file.pmc081,",
               "pmc082.pmc_file.pmc082,",
               "pmc53.pmc_file.pmc53,",  
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table1= cl_prt_temptable('aapr9001',g_sql) CLIPPED  
   IF l_table1= -1 THEN EXIT PROGRAM END IF                
 
   LET g_sql = "apf01.apf_file.apf01,",
               "apk03.apk_file.apk03,",
               "apk05.apk_file.apk05"
 
   LET l_table2= cl_prt_temptable('aapr9002',g_sql) CLIPPED  
   IF l_table2= -1 THEN EXIT PROGRAM END IF                
 
 
   LET g_sql = "apf01.apf_file.apf01,",
               "apg04.apg_file.apg04,",
               "apa08.apa_file.apa08,",
               "apa09.apa_file.apa09"
 
 
   LET l_table3= cl_prt_temptable('aapr9003',g_sql) CLIPPED  
   IF l_table3= -1 THEN EXIT PROGRAM END IF                
#No.FUN-720053--end
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
#  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aza.aza17   #NO.CHI-6A0004
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r900_tm(0,0)        # Input print condition
      ELSE CALL r900()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r900_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r900_w AT p_row,p_col
        WITH FORM "aap/42f/aapr900"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apf02,apf04,apf01,apf06,aph08
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
      LET INT_FLAG = 0 CLOSE WINDOW r900_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr900'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr900','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aapr900',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r900()
   ERROR ""
END WHILE
   CLOSE WINDOW r900_w
END FUNCTION
 
FUNCTION r900()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF  LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10),
          sr1              RECORD
                                  apf01  LIKE apf_file.apf01,  #付款單單頭檔
                                  apf02  LIKE apf_file.apf02,  #付款日期
                                  apf03  LIKE apf_file.apf03,  #付款廠商
                                  apf44  LIKE apf_file.apf44,  #傳票編號
                                  aph05  LIKE aph_file.aph05,  #沖付款金額
                                  aph07  LIKE aph_file.aph07,  #到期日
                                  aph13  LIKE aph_file.aph13,
                                  pmc081 LIKE pmc_file.pmc081, #廠商全名1
                                  pmc082 LIKE pmc_file.pmc082, #廠商全名2
                                  pmc53 LIKE pmc_file.pmc53    #地址
                        END RECORD
#                        END RECORD,                                                #FUN-A10098 ----mark
#        l_dbs_anm,l_dbs LIKE type_file.chr20       # No.FUN-690028  VARCHAR(20)    #FUN-A10098 ----mark
#No,FUN-710086--begin
   DEFINE l_apg03      LIKE apg_file.apg03,
          l_apg04      LIKE apg_file.apg04,
          l_apa08      LIKE apa_file.apa08,
          l_apa09      LIKE apa_file.apa09,
          l_apk03      LIKE apk_file.apk03,
          l_apk05      LIKE apk_file.apk05,
          l_apk06      LIKE apk_file.apk06,
          l_apk07      LIKE apk_file.apk07,
          l_apk08      LIKE apk_file.apk08,
          l_apd03      LIKE apd_file.apd03,    #備註檔
          l_miscnum     LIKE type_file.num5
    DEFINE l_count     LIKE type_file.num5
 
 
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
 
#No.FUN-710086--end
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr900'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND apfuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND apfgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT apf01,apf02,apf03,apf44,aph05,aph07,aph13,pmc081,pmc082, ",
                 "       pmc53 ",
                 " FROM apf_file, aph_file,  pmc_file ",
                 " WHERE apf01 = aph01 AND apf00='33' ",
                 "   AND apf41 <> 'X' ",
                 "   AND aph03='Z' AND apf_file.apf03=pmc_file.pmc01 AND ",tm.wc clipped,
                 " ORDER BY apf03,apf44,apf01 "

     SELECT COUNT(apf01) INTO l_count FROM apf_file, aph_file,  pmc_file
                         WHERE apf01 = aph01 AND apf00='33'    AND apf41 <> 'X'    AND aph03='Z'
                         AND apf_file.apf03=pmc_file.pmc01 AND apf04 like '%' ORDER BY apf03,apf44,apf01
     DISPLAY "............",l_count
 
     PREPARE r900_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r900_curs1 CURSOR FOR r900_prepare1
 
     #-->列印付款單的貸方
     LET l_sql = " SELECT apg03,apg04 FROM apg_file ",
                 " WHERE apg01 = ?  "
     PREPARE apg_prepare FROM l_sql
     DECLARE apg_curs CURSOR FOR apg_prepare
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('perpare apg_fiie error!',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
#No.FUN-710086--begin
#     CALL cl_outnam('aapr900') RETURNING l_name
#     START REPORT r900_rep TO l_name
#     LET g_pageno = 0
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep3:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
#No.FUN-710086--end
     FOREACH r900_curs1 INTO sr1.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#No.FUN-710086--begin
    SELECT azi03,azi04,azi05
      INTO t_azi03,t_azi04,t_azi05 
      FROM azi_file
     WHERE azi01=sr1.aph13
 
 
      #--->列印付款單借方資料: apg_file
      FOREACH  apg_curs USING sr1.apf01 INTO l_apg03,l_apg04
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach apg_file error !',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          #-->各廠的請款發票資料讀取
           LET l_miscnum = 1
           LET g_plant_new = l_apg03
#No.FUN-A10098 ----mark start
#           CALL s_getdbs()
#           LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
#                     " FROM  ",g_dbs_new CLIPPED," apk_file  ",
#                     " WHERE apk01 =  ? "
#No.FUN-A10098 ----mark end
#No.FUN-A10098 ----add begin
           LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08  FROM   apk_file  WHERE apk01 =  ? "
#No.FUN-A10098 ----add end
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032    #No.FUN-A10098 ----mark
           PREPARE r900_premisc FROM l_sql
           DECLARE r900_misc CURSOR FOR r900_premisc
           FOREACH r900_misc USING l_apg04
                          INTO l_apk03,l_apk05,l_apk06,l_apk07,l_apk08
              IF SQLCA.sqlcode THEN
                 CALL cl_err('misc invoice',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
              EXECUTE insert_prep2 USING sr1.apf01,l_apk03,l_apk05
              LET l_miscnum = l_miscnum + 1
           END FOREACH
           IF l_miscnum = 1 THEN                           #未讀到 apk_file
              SELECT apa08,apa09 INTO l_apa08,l_apa09 FROM apa_file
               WHERE apa01=l_apg04 AND apa42 = 'N'
              EXECUTE insert_prep3 USING sr1.apf01,l_apg04,l_apa08,l_apa09
           END IF
           EXECUTE insert_prep1 USING sr1.*,t_azi03,t_azi04,t_azi05
      END FOREACH
#           OUTPUT TO REPORT r900_rep(sr1.*)
#No.FUN-710086--end
     END FOREACH
#No.FUN-720053--begin
#    FINISH REPORT aapr900_rep
     CALL cl_wcchp(tm.wc,'apf02,apf04,apf01,apf06,aph08') 
          RETURNING tm.wc 
#No.FUN-840080---Begin
#     LET g_sql = "SELECT ",l_table1,".*,",
#                  l_table2,".apk03,",l_table2,".apk05,",
#                  l_table3,".apg04,",l_table3,".apa08,",l_table3,".apa09 ",
##TQC-730088     # "FROM ", l_table1 CLIPPED,",",l_table2 CLIPPED,",",l_table3 CLIPPED,
#                  "FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED, " LEFT OUTER JOIN " ,g_cr_db_str CLIPPED, l_table2 CLIPPED," ON ",l_table1,".apf01 = ",l_table2,".apf01",
#                  " LEFT OUTER JOIN " ,g_cr_db_str CLIPPED, l_table3 CLIPPED," ON ",l_table1,".apf01 = ",l_table3,".apf01"
#                 
      LET g_sql = "SELECT A.*,B.apk03,B.apk05,C.apg04,C.apa08,C.apa09 ",                                                            
                  " FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED," A  ",                                                       
                           "LEFT OUTER JOIN ",g_cr_db_str CLIPPED, l_table2 CLIPPED," B ON A.apf01 = B.apf01  " ,
                           "LEFT OUTER JOIN ",g_cr_db_str CLIPPED, l_table3 CLIPPED," C  ON A.apf01 = C.apf01"
#No.FUN-840080---End
     LET g_str = tm.wc
   # CALL cl_prt_cs3('aapr900',g_sql,g_str)   #TQC-730088
     CALL cl_prt_cs3('aapr900','aapr900',g_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-720053--end
    #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
END FUNCTION
 
FUNCTION r900_upd(l_apf01)
     DEFINE l_apf01 LIKE apf_file.apf01
 
     UPDATE apf_file SET apfprno = apfprno + 1 WHERE apf01 = l_apf01
     IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('update apfprno :',SQLCA.sqlcode,1) #No.FUN-660122
           CALL cl_err3("upd","apf_file",l_apf01,"",SQLCA.sqlcode,"","update apfprno:",1)  #No.FUN-660122
     END IF
END FUNCTION
 
#No.FUN-710086--begin 
#REPORT r900_rep(sr1)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#          sr1              RECORD
#                                  apf01  LIKE apf_file.apf01,  #付款單單頭檔
#                                  apf02  LIKE apf_file.apf02,  #付款日期
#                                  apf03  LIKE apf_file.apf03,  #付款廠商
#                                  apf44  LIKE apf_file.apf44,  #傳票編號
#                                  aph05  LIKE aph_file.aph05,  #沖付款金額
#                                  aph07  LIKE aph_file.aph07,  #到期日
#                                  aph13  LIKE aph_file.aph13,
#                                  pmc081 LIKE pmc_file.pmc081, #廠商全名1
#                                  pmc082 LIKE pmc_file.pmc082, #廠商全名2
#                                  pmc53 LIKE pmc_file.pmc53    #地址
#                        END RECORD,
#          sr12             RECORD apa02 LIKE apa_file.apa02,
#                                  apa08 LIKE apa_file.apa08,
#                                  apa09 LIKE apa_file.apa09,
#                                  apa12 LIKE apa_file.apa12,
#                                  apa13 LIKE apa_file.apa13,
#                                  apa14 LIKE apa_file.apa14,
#                                  apa24 LIKE apa_file.apa24,
#                                  apa31 LIKE apa_file.apa31,
#                                  apa32 LIKE apa_file.apa32,
#                                  apa60 LIKE apa_file.apa60,
#                                  apa61 LIKE apa_file.apa61,
#                                  apb04 LIKE apb_file.apb04, #應付帳款單身檔
#                                  apb06 LIKE apb_file.apb06,
#                                  apb08 LIKE apb_file.apb08,
#                                  apb09 LIKE apb_file.apb09,
#                                  apb10 LIKE apb_file.apb10,
#                                  apb13 LIKE apb_file.apb13,
#                                  apb15 LIKE apb_file.apb15,
#                                  apb14 LIKE apb_file.apb14,
#                                  rvb05 LIKE rvb_file.rvb05, #驗收單身檔
#                                  azi03 LIKE azi_file.azi03, #幣別檔
#                                  azi04 LIKE azi_file.azi04,
#                                  azi05 LIKE azi_file.azi05
#                       END RECORD,
#      l_sql         LIKE type_file.chr1000,     # No.FUN-690028 CHAR (600),
#      l_cnt         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
#      l_apgnum      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
#      l_pritem      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
#      l_miscnum     LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
#      l_amt                     LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
#      l_totsum,l_total          LIKE type_file.num20_6,     # No.FUN-690028  DECIMAL(20,6),
#      l_apg03      LIKE apg_file.apg03,
#      l_apg04      LIKE apg_file.apg04,
#      l_apa08      LIKE apa_file.apa08,
#      l_apa09      LIKE apa_file.apa09,
#      l_apk03      LIKE apk_file.apk03,
#      l_apk05      LIKE apk_file.apk05,
#      l_apk06      LIKE apk_file.apk06,
#      l_apk07      LIKE apk_file.apk07,
#      l_apk08      LIKE apk_file.apk08,
#      l_apd03      LIKE apd_file.apd03    #備註檔
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr1.apf03,sr1.apf44,sr1.apf01
#
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT g_dash[1,g_len]
#
#   BEFORE GROUP OF sr1.apf03    #付款廠商
#      IF PAGENO > 1 OR LINENO > 9
#         THEN SKIP TO TOP OF PAGE
#      END IF
#      LET l_totsum=0 LET l_total=0
#      PRINT g_x[17] clipped,sr1.apf03,' ',sr1.pmc081,sr1.pmc082
#      PRINT g_x[32] clipped,sr1.pmc53
#      PRINT g_x[23] clipped,'  ',g_x[24] clipped
#     #PRINT COLUMN 14,g_x[25] clipped
##    PRINT "------------  ----------  ----------  -------- ---------------------"
#     PRINT "----------------  ----------------  ----------  -------- ---------------------"  #No.FUN-550030
#
#   BEFORE GROUP OF sr1.apf44    #傳票編號
#      LET l_totsum=0
#      LET l_pritem=1
#      PRINT sr1.apf44,'  ';
#
#   BEFORE GROUP OF sr1.apf01    #付款單號
#    SELECT azi03,azi04,azi05
##     INTO g_azi03,g_azi04,g_azi05   #NO.CHI-6A0004
#      INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
#      FROM azi_file
#     WHERE azi01=sr1.aph13
#
#      LET l_apgnum = 1
#      #No.FUN-550030 start
#      PRINT COLUMN 19,sr1.apf01,
#            COLUMN 37,sr1.apf02,
#            COLUMN 49,sr1.aph07,
##           COLUMN 58,cl_numfor(sr1.aph05,20,g_azi04)   #NO.CHI-6A0004
#            COLUMN 58,cl_numfor(sr1.aph05,20,t_azi04)   #NO.CHI-6A0004
#      #No.FUN-550030 end
#      IF l_pritem=1 THEN
#         PRINT COLUMN 18,g_x[25] clipped    #No.FUN-550030
#         PRINT "                  ---------------------  --------------  -------- "  #No.FUN-550030
#         LET l_pritem=2
#      END IF
##     PRINT 18 spaces;        #No.FUN-550030
#
#      #--->列印付款單借方資料: apg_file
#      FOREACH  apg_curs USING sr1.apf01 INTO l_apg03,l_apg04
#           IF SQLCA.sqlcode != 0 THEN
#              CALL cl_err('foreach apg_file error !',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF
##          IF l_apgnum = 1 THEN
##             PRINT COLUMN 19,l_apg04;
##          ELSE
##             PRINT COLUMN 19,l_apg04;       #No.FUN-550030
##          END IF
#          #-->各廠的請款發票資料讀取
#           LET l_miscnum = 1
#           LET g_plant_new = l_apg03
#           CALL s_getdbs()
#           LET l_sql=" SELECT apk03,apk05,apk06,apk07,apk08 ",
#                     " FROM  ",g_dbs_new CLIPPED," apk_file  ",
#                     " WHERE apk01 =  ? "
#           PREPARE r900_premisc FROM l_sql
#           DECLARE r900_misc CURSOR FOR r900_premisc
#           FOREACH r900_misc USING l_apg04
#                          INTO l_apk03,l_apk05,l_apk06,l_apk07,l_apk08
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err('misc invoice',SQLCA.sqlcode,0)
#                 EXIT FOREACH
#              END IF
##             IF l_miscnum != 1 THEN
##                PRINT 37 spaces;        #No.FUN-550030
##             END IF
#              PRINT COLUMN 42, l_apk03,                    #發票號碼
#                                                           #No.FUN-550030
#                    #COLUMN 58, l_apk05 USING 'YY/MM/DD' #發票日期#FUN-570250 mark
#                    COLUMN 58, l_apk05     #發票日期#FUN-570250 add
#              LET l_miscnum = l_miscnum + 1
#           END FOREACH
#           IF l_miscnum = 1 THEN                           #未讀到 apk_file
#              SELECT apa08,apa09 INTO l_apa08,l_apa09 FROM apa_file
#               WHERE apa01=l_apg04 AND apa42 = 'N'
#              #PRINT COLUMN 19,l_apg04,COLUMN 37,l_apa08,COLUMN 58,l_apa09 using 'YY/MM/DD'   #No.FUN-550030#FUN-570250 mark
#              PRINT COLUMN 19,l_apg04,COLUMN 37,l_apa08,COLUMN 58,l_apa09 #No.FUN-550030 #FUN-570250 add
#           END IF
#           LET l_apgnum=l_apgnum+1
#      END FOREACH
#      SKIP 1 LINE
#      LET l_totsum = l_totsum + sr1.aph05
#      LET l_total  = l_total  + sr1.aph05
#
#   AFTER GROUP OF sr1.apf01    #付款單號
#    #PRINT COLUMN 13,g_x[24] clipped
#    #PRINT "              ----------  ----------  -------- "
#     LET l_pritem=1
##    PRINT 18 SPACES;    #No.FUN-550030
#
#   AFTER GROUP OF sr1.apf44    #傳票編號
#      PRINT                                 #totsum:
#      PRINT COLUMN 50,g_x[28] clipped,                  #No.FUN-550030
##           COLUMN 58,cl_numfor(l_totsum,20,g_azi05)    #No.FUN-550030 #NO.CHI-6A0004
#            COLUMN 58,cl_numfor(l_totsum,20,t_azi05)    #No.FUN-550030 #NO.CHI-6A0004
#      PRINT
#
#   AFTER  GROUP OF sr1.apf03    #付款廠商
#      SKIP 2 LINE
#      PRINT COLUMN 50,g_x[29] clipped,       #No.FUN-550030
##           COLUMN 58,cl_numfor(l_total,20,g_azi05)   #No.FUN-550030 #NO.CHI-6A0004
#            COLUMN 58,cl_numfor(l_total,20,t_azi05)   #No.FUN-550030 #NO.CHI-6A0004
#      LET l_last_sw = 'n'
#      LET g_pageno = 0
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
# 
### FUN-550099
#PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#      #PRINT
#      #LET l_last_sw = 'n'
#      #PRINT g_x[26],g_x[27]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[26]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[26]
#             PRINT g_memo
#      END IF
### END FUN-550099
#
#END REPORT
##Patch....NO.TQC-610035 <001,002> #
#No.FUN-710086--end
