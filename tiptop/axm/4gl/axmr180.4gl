# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmr180.4gl
# Descriptions...: 產品別預計產能與接單比較表
# Date & Author..: 01/01/02 By Kammy
 # Modify.........: No.MOD-570361 05/08/04 By Nicola 新增產品類別開窗
# Modify.........: No.FUN-680025 06/08/14 By cheunl voucher型報表轉template1 
# Modify.........: No.FUN-680137 06/08/31 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0036 06/12/11 By cheunl 修改沒有資料的情況下還會打印報表的情況
# Modify.........: No.TQC-750041 07/05/14 By Lynn 報表名在制表日期下方
# Modify.........: NO.FUN-830054 08/07/28 By zhaijie 報表格式改為CR
# Modify.........: NO.CHI-910057 09/02/05 By xiaofeizhu axmr180已轉CR，不需使用zaa
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50044 10/05/14 By Carrier MOD-990213 追单
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD

              wc      LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(500)      # Where condition
              opm02   LIKE faj_file.faj02,     #No.FUN-680137 VARCHAR(10)       # 版本
              yy      LIKE type_file.num5,     #No.FUN-680137 smallint       # 計劃年度
              mm1     LIKE type_file.num5,     #No.FUN-680137 smallint       # 計劃月份
              mm2     LIKE type_file.num5,     #No.FUN-680137 smallint       # 計劃月份
              more    LIKE type_file.chr1      #No.FUN-680137 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
           g_wc    string,         #No.FUN-580092 HCN
          l_orderA ARRAY[2] OF LIKE faj_file.faj02        #No.FUN-680137 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5              #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   gg_i            LIKE type_file.num5              #No.FUN-830054
DEFINE   g_num    ARRAY[55] OF LIKE oeb_file.oeb12        #No.TQC-A50044
DEFINE   g_tot    ARRAY[55] OF LIKE oeb_file.oeb12        #No.TQC-A50044
DEFINE   g_qty    ARRAY[55] OF LIKE oeb_file.oeb12        #NO.FUN-830054
DEFINE   a_qty    ARRAY[55] OF LIKE oeb_file.oeb12        #NO.FUN-830054
DEFINE   g_str          STRING                            #NO.FUN-830054
DEFINE   g_sql          STRING                            #NO.FUN-830054
DEFINE   l_table        STRING                            #NO.FUN-830054
DEFINE   l_table1       STRING                            #NO.FUN-830054
DEFINE   l_i            LIKE type_file.num5               #NO.FUN-830054
DEFINE   i              LIKE type_file.num5               #NO.FUN-830054
DEFINE   g_znn    DYNAMIC ARRAY OF RECORD                 #CHI-910057
                  znn08 LIKE zaa_file.zaa08               #CHI-910057
                  END RECORD                              #CHI-910057
 
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
#NO.FUN-830054-----START----
   LET g_sql = "customer.oea_file.oea03,",
               "g_num32.type_file.num10,",
               "g_num33.type_file.num10,",
               "g_num34.type_file.num10,",
               "g_num35.type_file.num10,",
               "g_num36.type_file.num10,",
               "g_num37.type_file.num10,",
               "g_num38.type_file.num10,",
               "g_num39.type_file.num10,",
               "g_num40.type_file.num10,",
               "g_num41.type_file.num10,",
               "g_num42.type_file.num10,",
               "g_num43.type_file.num10,",
               "g_num44.type_file.num10,",
               "g_num45.type_file.num10,",
               "g_num46.type_file.num10,",
               "g_num47.type_file.num10,",
               "g_num48.type_file.num10,",
               "g_num49.type_file.num10,",
               "g_num50.type_file.num10,",
               "g_num51.type_file.num10,",
               "g_num52.type_file.num10,",
               "g_num53.type_file.num10,",
               "g_num54.type_file.num10,",
               "g_num55.type_file.num10,",
               "l_qty32.type_file.num10,",
               "l_qty33.type_file.num10,",
               "l_qty34.type_file.num10,",
               "l_qty35.type_file.num10,",
               "l_qty36.type_file.num10,",
               "l_qty37.type_file.num10,",
               "l_qty38.type_file.num10,",
               "l_qty39.type_file.num10,",
               "l_qty40.type_file.num10,",
               "l_qty41.type_file.num10,",
               "l_qty42.type_file.num10,",
               "l_qty43.type_file.num10,",
               "l_qty44.type_file.num10,",
               "l_qty45.type_file.num10,",
               "l_qty46.type_file.num10,",
               "l_qty47.type_file.num10,",
               "l_qty48.type_file.num10,",
               "l_qty49.type_file.num10,",
               "l_qty50.type_file.num10,",
               "l_qty51.type_file.num10,",
               "l_qty52.type_file.num10,",
               "l_qty53.type_file.num10,",
               "l_qty54.type_file.num10,",
               "l_qty55.type_file.num10,",
               "act_qty32.type_file.num10,",
               "act_qty33.type_file.num10,",
               "act_qty34.type_file.num10,",
               "act_qty35.type_file.num10,",
               "act_qty36.type_file.num10,",
               "act_qty37.type_file.num10,",
               "act_qty38.type_file.num10,",
               "act_qty39.type_file.num10,",
               "act_qty40.type_file.num10,",
               "act_qty41.type_file.num10,",
               "act_qty42.type_file.num10,",
               "act_qty43.type_file.num10,",
               "act_qty44.type_file.num10,",
               "act_qty45.type_file.num10,",
               "act_qty46.type_file.num10,",
               "act_qty47.type_file.num10,",
               "act_qty48.type_file.num10,",
               "act_qty49.type_file.num10,",
               "act_qty50.type_file.num10,",
               "act_qty51.type_file.num10,",
               "act_qty52.type_file.num10,",
               "act_qty53.type_file.num10,",
               "act_qty54.type_file.num10,",
               "act_qty55.type_file.num10,",
               "g_tot32.type_file.num10,",
               "g_tot33.type_file.num10,",
               "g_tot34.type_file.num10,",
               "g_tot35.type_file.num10,",
               "g_tot36.type_file.num10,",
               "g_tot37.type_file.num10,",
               "g_tot38.type_file.num10,",
               "g_tot39.type_file.num10,",
               "g_tot40.type_file.num10,",
               "g_tot41.type_file.num10,",
               "g_tot42.type_file.num10,",
               "g_tot43.type_file.num10,",
               "g_tot44.type_file.num10,",
               "g_tot45.type_file.num10,",
               "g_tot46.type_file.num10,",
               "g_tot47.type_file.num10,",
               "g_tot48.type_file.num10,",
               "g_tot49.type_file.num10,",
               "g_tot50.type_file.num10,",
               "g_tot51.type_file.num10,",
               "g_tot52.type_file.num10,",
               "g_tot53.type_file.num10,",
               "g_tot54.type_file.num10,",
               "g_tot55.type_file.num10"
   LET l_table = cl_prt_temptable('axmr180',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "gx31.type_file.chr1000,",
               "gx32.type_file.chr1000,",
               "gx33.type_file.chr1000,",
               "gx34.type_file.chr1000,",
               "gx35.type_file.chr1000,",
               "gx36.type_file.chr1000,",
               "gx37.type_file.chr1000,",
               "gx38.type_file.chr1000,",
               "gx39.type_file.chr1000,",
               "gx40.type_file.chr1000,",
               "gx41.type_file.chr1000,",
               "gx42.type_file.chr1000,",
               "gx43.type_file.chr1000,",
               "gx44.type_file.chr1000,",
               "gx45.type_file.chr1000,",
               "gx46.type_file.chr1000,",
               "gx47.type_file.chr1000,",
               "gx48.type_file.chr1000,",
               "gx49.type_file.chr1000,",
               "gx50.type_file.chr1000,",
               "gx51.type_file.chr1000,",
               "gx52.type_file.chr1000,",
               "gx53.type_file.chr1000,",
               "gx54.type_file.chr1000,",
               "gx55.type_file.chr1000"
   LET l_table1 = cl_prt_temptable('axmr1801',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
#NO.FUN-830054-----END----
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more  = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.opm02 = ARG_VAL(8)
   LET tm.yy    = ARG_VAL(9)
   LET tm.mm1   = ARG_VAL(10)
   LET tm.mm2   = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   DROP TABLE r180_tmp
#No.FUN-680137----Begin---
   CREATE TEMP TABLE r180_tmp(  
     no      LIKE type_file.num5,  
     model   LIKE ima_file.ima131,
     qty     LIKE opn_file.opn05,
     act_qty LIKE opn_file.opn05)
   
#No.FUN-680137----End---
   CREATE INDEX tmpidx ON r180_tmp(no);
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axmr180_tm(0,0)
      ELSE CALL axmr180()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr180_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,      #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000      #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW axmr180_w AT p_row,p_col WITH FORM "axm/42f/axmr180"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy    = YEAR(g_today)
   LET tm.more= 'N'
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET g_pdate = g_today                 #No.TQC-6C0036
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON opm01
 
       #-----No.MOD-570361-----
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(opm01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO opm01
               NEXT FIELD opm01
         END CASE
       #-----No.MOD-570361 END-----
 
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
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('opmuser', 'opmgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.opm02,tm.yy,tm.mm1,tm.mm2,tm.more
      WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD opm02
         IF cl_null(tm.opm02) THEN NEXT FIELD opm02 END IF
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      AFTER FIELD mm1
         IF cl_null(tm.mm1) THEN NEXT FIELD mm1 END IF
         IF tm.mm1 < 1 AND tm.mm1 > 12 THEN NEXT FIELD mm1 END IF
      AFTER FIELD mm2
         IF cl_null(tm.mm2) THEN NEXT FIELD mm2 END IF
         IF tm.mm2 < 1 AND tm.mm2 > 12 THEN NEXT FIELD mm2 END IF
         IF tm.mm2 < tm.mm1 THEN NEXT FIELD mm1 END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr180'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr180','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.opm02 CLIPPED,"'",
                         " '",tm.yy    CLIPPED,"'",
                         " '",tm.mm1   CLIPPED,"'",
                         " '",tm.mm2   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('axmr180',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr180_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr180()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr180_w
END FUNCTION
 
FUNCTION axmr180()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_za05    LIKE ima_file.ima01,          #No.FUN-680137 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima131,   #No.FUN-680137 VARCHAR(10)
          l_str1    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
          l_str2    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
          l_str3    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
          l_model   LIKE ima_file.ima131,        #No.FUN-680137 VARCHAR(10)
          l_qty     LIKE opn_file.opn05,
          i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_bg,l_ed  LIKE type_file.num5,         #No.FUN-680137 smallint
          sr           RECORD
                         customer LIKE oea_file.oea03
                       END RECORD
  DEFINE  sr1          RECORD
                          no        LIKE type_file.num5,
                          model     LIKE ima_file.ima131,
                          qty       LIKE oeb_file.oeb12,
                          act_qty   LIKE oeb_file.oeb12
                       END RECORD
#NO.FUN-830054----start------
DEFINE    l_diff       LIKE oeb_file.oeb12
     CALL cl_del_data(l_table)                     #NO.FUN-830054
     CALL cl_del_data(l_table1)                    #NO.FUN-830054
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr180' 
#NO.FUN-830054-------end----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr180'
#     IF g_len < 80 OR g_len IS NULL THEN LET g_len = 80 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
LET g_len = 80
     DELETE FROM r180_tmp
     #預計產量
     LET l_sql = "SELECT opm01,SUM(opn05)  ",
                 "  FROM opm_file,opn_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND opm01 = opn01 ",
                 "   AND opm02 = opn02 ",
                 "   AND opm03 = opn03 ",
                 "   AND opm02 = '",tm.opm02 ,"'",
                 "   AND opm03 = ",tm.yy,
                 "   AND opn04 BETWEEN ",tm.mm1 ," AND ",tm.mm2,
                 " GROUP BY opm01 "
    PREPARE r180_pre1 FROM l_sql
    DECLARE r180_cs1 CURSOR FOR r180_pre1
 
    LET i = 0 
#LET l_str1='' LET l_str2='' LET l_str3=''               #NO.FUN-830054
    #No.FUN-680025 --start--
#    CALL cl_outnam('axmr180') RETURNING l_name          #NO.FUN-830054
    LET g_i = 1
    FOREACH r180_cs1 INTO l_model,l_qty
       LET g_i = g_i + 1
       LET i = i + 1
       LET l_bg = 11*(i-1)+1  LET l_ed = 11*i-1
       IF i = 1 THEN LET l_bg = 1 END IF
#       LET l_str1[l_bg,l_ed] = l_model                 #NO.FUN-830054
#       LET g_zaa[30+g_i].zaa08 = l_model                #CHI-910057 Mark
        LET g_znn[30+g_i].znn08 = l_model                #CHI-910057       
#       LET l_str2 = l_str2 CLIPPED,' ','----------'    #NO.FUN-830054
#       LET l_str3 = l_str3 CLIPPED,' ',l_qty USING '##,###,##&'#NO.FUN-830054
       LET g_num[30+g_i] = l_qty
       #印的長度暫時限制在 400 內
#       IF length(l_str1) > 400 THEN EXIT FOREACH END IF   #NO.FUN-830054
#       IF length(l_str2) > 400 THEN EXIT FOREACH END IF   #NO.FUN-830054
#       IF length(l_str3) > 400 THEN EXIT FOREACH END IF   #NO.FUN-830054
       INSERT INTO r180_tmp VALUES(i,l_model,l_qty,0)
    END FOREACH
    IF cl_null(l_qty) and cl_null(l_model) THEN CALL cl_err('','lib-216',1)              #No.TQC-6C0036 
#    IF cl_null(l_qty) THEN CALL cl_err('','lib-216',1)              #No.TQC-6C0036 
    ELSE                                                            #No.TQC-6C0036
#NO.FUN-830054----MARK---START---
#    FOR i = 1 TO 25
#       LET g_zaa[31+i].zaa06 = "N"
#    END FOR
#    FOR i = g_i TO 24
#       LET g_zaa[31+i].zaa06 = "Y"
#    END FOR
#    CALL cl_prt_pos_len()
#    IF g_len < 80 THEN
#       IF g_i = 2 THEN
#          LET g_zaa[31].zaa05 = 45
#          LET g_zaa[32].zaa05 = 30
#       END IF
#       IF g_i = 3 THEN
#          LET g_zaa[31].zaa05 = 35
#          LET g_zaa[32].zaa05 = 20
#          LET g_zaa[33].zaa05 = 20
#       END IF
#       CALL cl_prt_pos_len()
#    END IF
#NO.FUN-830054----MARK---END---
    #No.FUN-680025 --end--
 
#   IF cl_null(g_pdate) THEN LET g_pdate = g_today END IF            #No.FUN-680025
#    START REPORT axmr180_rep TO l_name                    #NO.FUN-830054
#    IF i > 0 THEN                                         #NO.FUN-830054
#       OUTPUT TO REPORT axmr180_rep(sr.*)                 #NO.FUN-830054
#    END IF                                                #NO.FUN-830054
 
    DECLARE r180_cs3 CURSOR FOR SELECT * FROM r180_tmp ORDER BY no
 
    #客戶編號(抓資料時必須與 temp 檔做 join)
    LET l_sql = "SELECT UNIQUE(oea03) ",
                "  FROM oea_file,oeb_file,ima_file, r180_tmp ",
                " WHERE oea01 = oeb01 ",
                "   AND YEAR(oea02) = ",tm.yy ,
                "   AND MONTH(oea02) BETWEEN ",tm.mm1 ," AND ",tm.mm2,
                "   AND ima01 = oeb04 ",
                "   AND ima131= model ",
                "   AND oeaconf != 'X' "   #01/08/08 mandy
 
     PREPARE r180_pre2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE r180_curs2 CURSOR FOR r180_pre2
 
#    LET g_pageno = 0                                      #CHI-910057
     FOREACH r180_curs2 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
#       OUTPUT TO REPORT axmr180_rep(sr.*)                 #NO.FUN-830054
#FUN-830054---START---
       EXECUTE insert_prep1 USING
#        g_zaa[31].zaa08,g_zaa[32].zaa08,g_zaa[33].zaa08,g_zaa[34].zaa08,               #CHI-910057 Mark
#        g_zaa[35].zaa08,g_zaa[36].zaa08,g_zaa[37].zaa08,g_zaa[38].zaa08,               #CHI-910057 Mark
#        g_zaa[39].zaa08,g_zaa[40].zaa08,g_zaa[41].zaa08,g_zaa[42].zaa08,               #CHI-910057 Mark
#        g_zaa[42].zaa08,g_zaa[43].zaa08,g_zaa[45].zaa08,g_zaa[46].zaa08,               #CHI-910057 Mark
#        g_zaa[47].zaa08,g_zaa[48].zaa08,g_zaa[49].zaa08,g_zaa[50].zaa08,               #CHI-910057 Mark
#        g_zaa[51].zaa08,g_zaa[52].zaa08,g_zaa[53].zaa08,g_zaa[54].zaa08,               #CHI-910057 Mark 
#        g_zaa[55].zaa08                                                                #CHI-910057 Mark
         g_znn[31].znn08,g_znn[32].znn08,g_znn[33].znn08,g_znn[34].znn08,               #CHI-910057 Add
         g_znn[35].znn08,g_znn[36].znn08,g_znn[37].znn08,g_znn[38].znn08,               #CHI-910057 Add
         g_znn[39].znn08,g_znn[40].znn08,g_znn[41].znn08,g_znn[42].znn08,               #CHI-910057 Add
         g_znn[42].znn08,g_znn[43].znn08,g_znn[45].znn08,g_znn[46].znn08,               #CHI-910057 Add
         g_znn[47].znn08,g_znn[48].znn08,g_znn[49].znn08,g_znn[50].znn08,               #CHI-910057 Add
         g_znn[51].znn08,g_znn[52].znn08,g_znn[53].znn08,g_znn[54].znn08,               #CHI-910057 Add
         g_znn[55].znn08                                                                #CHI-910057 Add                  
       LET gg_i =26 
       FOR i = 2 TO gg_i
#        IF cl_null(g_zaa[30+i].zaa08) THEN                                             #CHI-910057 Mark
         IF cl_null(g_znn[30+i].znn08) THEN                                             #CHI-910057 Add          
           LET gg_i = i
          END IF
       END FOR
       IF NOT cl_null(sr.customer) THEN
          LET l_i = 1
          FOREACH r180_cs3 INTO sr1.*
               LET l_i = l_i + 1
               SELECT SUM(oeb12) INTO l_qty FROM oeb_file,oea_file,ima_file
                WHERE oeb01 = oea01 AND oea03 = sr.customer
                  AND oeb04 = ima01 AND ima131= sr1.model
                  AND YEAR(oea02) = tm.yy
                  AND MONTH(oea02) BETWEEN tm.mm1 AND tm.mm2
                  AND oeaconf != 'X' 
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               UPDATE r180_tmp SET act_qty = act_qty + l_qty
                WHERE model = sr1.model AND no = sr1.no
               LET g_qty[30+l_i] = l_qty 
#              IF  NOT cl_null(g_zaa[30+l_i].zaa08) AND cl_null(g_qty[30+l_i]) THEN     #	CHI-910057 Mark
               IF  NOT cl_null(g_znn[30+l_i].znn08) AND cl_null(g_qty[30+l_i]) THEN     #	CHI-910057 Add               
                 LET g_qty[30+l_i] = 0
               END IF
          END FOREACH
       END IF
       LET l_i = 1
       FOREACH r180_cs3 INTO sr1.*
           LET l_i = l_i + 1
           LET l_diff = sr1.qty - sr1.act_qty
           LET g_tot[30+l_i] = sr1.qty - sr1.act_qty
           LET a_qty[30+l_i] = sr1.act_qty
#          IF  NOT cl_null(g_zaa[30+l_i].zaa08) AND cl_null(g_tot[30+l_i]) THEN          #CHI-910057 Mark
           IF  NOT cl_null(g_znn[30+l_i].znn08) AND cl_null(g_tot[30+l_i]) THEN          #CHI-910057 Add           
             LET g_tot[30+l_i] = 0
           END IF
#          IF  NOT cl_null(g_zaa[30+l_i].zaa08) AND cl_null(a_qty[30+l_i]) THEN          #CHI-910057 Mark
           IF  NOT cl_null(g_znn[30+l_i].znn08) AND cl_null(a_qty[30+l_i]) THEN          #CHI-910057 Add           
             LET g_tot[30+l_i] = 0
           END IF
       END FOREACH
       EXECUTE insert_prep USING
         sr.customer,g_num[32],g_num[33],g_num[34],g_num[35],g_num[36],
         g_num[37],g_num[38],g_num[39],g_num[40],g_num[41],g_num[42],g_num[43],
         g_num[44],g_num[45],g_num[46],g_num[47],g_num[48],g_num[49],g_num[50],
         g_num[51],g_num[52],g_num[53],g_num[54],g_num[55],
         g_qty[32],g_qty[33],g_qty[34],
         g_qty[35],g_qty[36],g_qty[37],g_qty[38],g_qty[39],g_qty[40],g_qty[41],
         g_qty[42],g_qty[43],g_qty[44],g_qty[45],g_qty[46],g_qty[47],g_qty[48],
         g_qty[49],g_qty[50],g_qty[51],g_qty[52],g_qty[53],g_qty[54],g_qty[55],
         a_qty[32],a_qty[33],a_qty[34],a_qty[35],a_qty[36],a_qty[37],
         a_qty[38],a_qty[39],a_qty[40],a_qty[41],a_qty[42],a_qty[43],
         a_qty[44],a_qty[45],a_qty[46],a_qty[47],a_qty[48],a_qty[49],
         a_qty[50],a_qty[51],a_qty[52],a_qty[53],a_qty[54],a_qty[55],
         g_tot[32],g_tot[33],g_tot[34],g_tot[35],g_tot[36],g_tot[37],g_tot[38],
         g_tot[39],g_tot[40],g_tot[41],g_tot[42],g_tot[43],g_tot[44],g_tot[45],
         g_tot[46],g_tot[47],g_tot[48],g_tot[49],g_tot[50],g_tot[51],g_tot[52],
         g_tot[53],g_tot[54],g_tot[55]
         
#FUN-830054----END----
     END FOREACH
 
#     FINISH REPORT axmr180_rep                            #NO.FUN-830054
#FUN-830054----satrt----
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'opm01')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.yy,";",tm.mm1,";",tm.mm2,";",gg_i         
     CALL cl_prt_cs3('axmr180','axmr180',g_sql,g_str)
#FUN-830054----end----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-830054
     END IF                                           #No.TQC-6C0036
END FUNCTION
#NO.FUN-830054-----start----mark---
#REPORT axmr180_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          l_str1        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
#          l_str2        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
#          l_str3        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
#          l_str4        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(400)
#          l_diff       LIKE oeb_file.oeb12,
#          l_qty        LIKE oeb_file.oeb12,
#          sr           RECORD
#                          customer LIKE oea_file.oea03
#                       END RECORD,
#          sr1          RECORD
#                          no        LIKE type_file.num5,        #No.FUN-680137 smallint
#                          model     LIKE ima_file.ima131,        #No.FUN-680137 VARCHAR(10)
#                          qty       LIKE oeb_file.oeb12,        #No.FUN-680137 dec(15,3)
#                          act_qty   LIKE oeb_file.oeb12         #No.FUN-680137 dec(15,3)
#                       END RECORD
#    DEFINE l_flag       LIKE type_file.num5         #No.FUN-680137 SMALLINT
#    DEFINE l_i         LIKE type_file.num5          #No.FUN-680137 SMALLINT
#    DEFINE i           LIKE type_file.num5          #No.FUN-680137 SMALLINT
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.customer
#
#  FORMAT
#   PAGE HEADER
##No.FUN-680025 ---------------------------start -------------------------------
#      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1                                                                                                   
#      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
##     PRINT g_head CLIPPED,pageno_total     # No.TQC-750041
#      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED 
#      PRINT g_head CLIPPED,pageno_total     # No.TQC-750041
#      PRINT ' '
##     PRINT g_x[2] CLIPPED,g_today ,' ',TIME;
#      PRINT COLUMN (g_len-15)/2,g_x[14] CLIPPED,tm.yy USING '####',' ',
#            g_x[15] CLIPPED,tm.mm1 USING '##' ,'-', tm.mm2 USING '##' 
##           COLUMN (g_len - 8), g_x[3],pageno_total
##           COLUMN (g_len - 8),g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      PRINT
##     PRINT COLUMN 11,l_str1
##     PRINT COLUMN 10,l_str2
#      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                       g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
#                       g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],
#                       g_x[52],g_x[53],g_x[54],g_x[55]
#      PRINT g_dash1
##     PRINT g_x[11] CLIPPED,COLUMN 10,l_str3
#      LET l_flag = 0
##No.FUN-680025 --------------------end---------------------------------------
#      LET l_last_sw = 'n'
#      LET l_str4 = ''                                     #NO.FUN-830054
#
#    BEFORE GROUP OF sr.customer
#No.FUN-680025 -----------------start----------------------------------
#       IF l_flag = 0 THEN 
#          PRINTX name = D1 COLUMN g_c[31],g_x[11] CLIPPED,
#                           COLUMN g_c[32],cl_numfor(g_num[32],32,0), 
#                           COLUMN g_c[33],cl_numfor(g_num[33],33,0), 
#                           COLUMN g_c[34],cl_numfor(g_num[34],34,0), 
#                           COLUMN g_c[35],cl_numfor(g_num[35],35,0), 
#                           COLUMN g_c[36],cl_numfor(g_num[36],36,0), 
#                           COLUMN g_c[37],cl_numfor(g_num[37],37,0), 
#                           COLUMN g_c[38],cl_numfor(g_num[38],38,0), 
#                           COLUMN g_c[39],cl_numfor(g_num[39],39,0), 
#                           COLUMN g_c[40],cl_numfor(g_num[40],40,0), 
#                           COLUMN g_c[41],cl_numfor(g_num[41],41,0), 
#                           COLUMN g_c[42],cl_numfor(g_num[42],42,0), 
#                           COLUMN g_c[43],cl_numfor(g_num[43],43,0), 
#                           COLUMN g_c[44],cl_numfor(g_num[44],44,0), 
#                           COLUMN g_c[45],cl_numfor(g_num[45],45,0), 
#                           COLUMN g_c[46],cl_numfor(g_num[46],46,0), 
#                           COLUMN g_c[47],cl_numfor(g_num[47],47,0), 
#                           COLUMN g_c[48],cl_numfor(g_num[48],48,0), 
#                           COLUMN g_c[49],cl_numfor(g_num[49],49,0), 
#                           COLUMN g_c[50],cl_numfor(g_num[50],50,0), 
#                           COLUMN g_c[51],cl_numfor(g_num[51],51,0), 
#                           COLUMN g_c[52],cl_numfor(g_num[52],52,0), 
#                           COLUMN g_c[53],cl_numfor(g_num[53],53,0), 
#                           COLUMN g_c[54],cl_numfor(g_num[54],54,0), 
#                           COLUMN g_c[55],cl_numfor(g_num[55],55,0)
#       END IF
#       LET l_flag = l_flag + 1
##No.FUN-680025 ---------------------end---------------------------------
#       PRINTX name = D1 COLUMN g_c[31],sr.customer;
# 
#    AFTER GROUP OF sr.customer
#       IF NOT cl_null(sr.customer) THEN
#          LET l_i = 1
#          FOREACH r180_cs3 INTO sr1.*
#               LET l_i = l_i + 1
#               SELECT SUM(oeb12) INTO l_qty FROM oeb_file,oea_file,ima_file
#                WHERE oeb01 = oea01 AND oea03 = sr.customer
#                  AND oeb04 = ima01 AND ima131= sr1.model
#                  AND YEAR(oea02) = tm.yy
#                  AND MONTH(oea02) BETWEEN tm.mm1 AND tm.mm2
#                  AND oeaconf != 'X' #01/08/08 mandy
#               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
#               UPDATE r180_tmp SET act_qty = act_qty + l_qty
#                WHERE model = sr1.model AND no = sr1.no
##              PRINT COLUMN(11+(sr1.no-1)*11),l_qty USING '##,###,##&';            #No.FUN-680025
#               PRINTX name = D1 COLUMN g_c[30+l_i],cl_numfor(l_qty,30+l_i,0); 
#          END FOREACH
#          PRINTX name = D1 
#       END IF
##      PRINT
 
#   ON LAST ROW
#       PRINT
#       PRINTX name = S1 COLUMN g_c[31],g_x[12] CLIPPED;
#       LET l_i = 1
#       FOREACH r180_cs3 INTO sr1.*
#           LET l_i = l_i + 1
##          PRINT COLUMN(11+(sr1.no-1)*11),sr1.act_qty USING '##,###,##&';           #No.FUN-680025
#           LET l_diff = sr1.qty - sr1.act_qty
#           LET g_tot[30+l_i] = sr1.qty - sr1.act_qty
##           LET l_str4 = l_str4 CLIPPED,' ',l_diff USING '-,---,---,---,---,---,---,--&';  #NO.FUN-830054
#           PRINTX name = S1 COLUMN g_c[30+l_i],cl_numfor(sr1.act_qty,30+l_i,0);
#       END FOREACH
#       PRINTX name = S1
#       PRINT
##No.FUN-680025 -----------------------start-----------------------------
#       PRINTX name = S1 COLUMN g_c[31],g_x[13] CLIPPED;
#       FOR i = 1 TO l_i 
#          PRINTX name = S1 COLUMN g_c[31+i],cl_numfor(g_tot[31+i],31+i,0);
#       END FOR
#       PRINTX name = S1
##      PRINT g_x[13] CLIPPED,COLUMN 10,l_str4
##      PRINT g_dash[1,g_len] CLIPPED
#       PRINT g_dash
##No.FUN-680025 ------------------------end------------------------------
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-830054----END-----
#Patch....NO.TQC-610037 <001> #
