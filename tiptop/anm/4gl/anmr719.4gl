# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr719.4gl
# Descriptions...: 融資到期彙總表
# Date & Author..: 01/12/03 By plum
# Reference File : nne_file
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.TQC-5A0027 05/10/31 By Smapmin 幣別多印
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-680025 06/08/24 By bnlent voucher型報表轉template1  
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-740024 07/04/06 By Judy 制表日期與報表名稱行數顛倒
# Modify.........: No.MOD-7B0100 07/11/12 By Smapmin 修正SQL語法
# Modify.........: NO.FUN-830054 08/07/28 By zhaijie 報表打印修改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.MOD-990246 09/09/28 By mike LET l_nne04=l_algno[j,j+7]  -->請改成 LET l_nne04=l_algno[j,j+10]                 
# Modify.........: NO.MOD-990205 09/10/18 By mike anmr719條件選項的資料範圍選項1:已結案 2:未結案之SQL相反了.                        
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                           # Print condition RECORD
                wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600) # Where condition
                bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
                edate   LIKE type_file.dat,    #No.FUN-680107 DATE
                t       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
                more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) # Input more condition(Y/N)
          END RECORD
   DEFINE g_seq          LIKE type_file.num5    #No.FUN-680107 smallint         
   DEFINE l_max          LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_head         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
   DEFINE l_yyyy,l_mm    LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_no           LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_algno        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(80)
   DEFINE g_tit          ARRAY[8] OF LIKE mpz_file.mpz04  #No.FUN-680107 ARRAY[8] OF VARCHAR(19)
   DEFINE g_dash_1       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(800)
 
   DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
#NO.FUN-830054----start----
   DEFINE g_sql          STRING
   DEFINE g_str          STRING
   DEFINE l_table        STRING
   DEFINE l_table1       STRING
   DEFINE l_table2       STRING
   DEFINE l_table3       STRING
#NO.FUN-830054----start----
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#NO.FUN-830054----start----
   LET g_sql = "yymm.type_file.chr8,",
               "rdate.type_file.dat,",   
               "lweek.type_file.num5,",  
               "flag.type_file.num5,",  
               "curr.azi_file.azi01,",  
               "bank.nne_file.nne04,",  
               "amt.nne_file.nne12,",   
               "l_head.type_file.chr1000"
   LET l_table = cl_prt_temptable('anmr719',g_sql) CLIPPED
   IF  l_table =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "yymm.type_file.chr8,",
               "l_curr.azi_file.azi01,",  
               "l_nne04.nne_file.nne04,",  
               "l_amt.nne_file.nne12"
   LET l_table1 = cl_prt_temptable('anmr7191',g_sql) CLIPPED
   IF  l_table1 =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "curr.azi_file.azi01,",
               "yymm.type_file.chr8,",
               "c_amt.nne_file.nne12"   
   LET l_table2 = cl_prt_temptable('anmr7192',g_sql) CLIPPED
   IF  l_table2 =-1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "yymm.type_file.chr8,",
               "rdate.type_file.dat,",   
               "l_curr.azi_file.azi01,",  
               "l_nne04.nne_file.nne04,",  
               "l_amt.nne_file.nne12"   
   LET l_table3 = cl_prt_temptable('anmr7193',g_sql) CLIPPED
   IF  l_table3 =-1 THEN EXIT PROGRAM END IF
#NO.FUN-830054----end----
   LET g_pdate = ARG_VAL(1)             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.t   = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
  #DROP TABLE r719alg
  #CREATE TEMP TABLE r719alg (yymm VARCHAR(07),no VARCHAR(08),bank VARCHAR(20))
  #CREATE UNIQUE INDEX r719_01 ON r719alg(yymm,no)
   DROP TABLE r719_file
#No.FUN-680107 --START
#   CREATE TEMP TABLE r719_file
# Prog. Version..: '5.30.06-13.03.12(07),                     #年度+月份
#      lweek  SMALLINT,                     #週次
#      rdate  DATE,                         #到期日
# Prog. Version..: '5.30.06-13.03.12(04),                     #幣別
# Prog. Version..: '5.30.06-13.03.12(08),                     #銀行
#      amt    DEC(20,6))                    #原幣未還金額
    CREATE TEMP TABLE r719_file(
       yyyymm LIKE type_file.chr8,  
       lweek  LIKE type_file.num5,  
       rdate  LIKE type_file.dat,   
       curr   LIKE azi_file.azi01,
       bank   LIKE nne_file.nne04,
       amt    LIKE nne_file.nne12)
 
   DROP TABLE r719algno
#  CREATE TEMP TABLE r719algno
# Prog. Version..: '5.30.06-13.03.12(07),                       #年月
#     seq   smallint,                       #年月: 銀行次數
#     algno VARCHAR(80),                       #銀行代號
#     ghead VARCHAR(200))                      #銀行代號,' ',銀行簡稱
   CREATE TEMP TABLE r719algno(
      yymm  LIKE type_file.chr7,   
      seq   LIKE type_file.num5,  
      algno LIKE type_file.chr1000,
      ghead LIKE type_file.chr1000)
#No.FUN-680107 --END
   CREATE UNIQUE INDEX r719_02 ON r719algno(yymm)
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'         # If background job sw is off
      THEN CALL anmr719_tm(0,0)                 # Input print condition
      ELSE CALL anmr719()                       # Read data and create out-file
   END IF
   CLEAR SCREEN
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr719_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd         LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW anmr719_w AT p_row,p_col
        WITH FORM "anm/42f/anmr719"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bdate  = g_today
   LET tm.edate  = g_today
   LET tm.t    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nne01,nne02,nne04,nne112,nne06,nne16
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr719_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.t,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN NEXT FIELD edate END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr719_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr719'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr719','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.bdate CLIPPED,"'",
                     " '",tm.edate  CLIPPED,"'",
                     " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr719',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr719_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr719()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr719_w
END FUNCTION
 
FUNCTION anmr719()
   DEFINE l_name        LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680107 VARCHAR(1200)
          l_yymm,l_ym   LIKE type_file.chr8,    #No.FUN-680107 VARCHAR(7)
          l_za05        LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
          i,j           LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_week        LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_i,l_cn      LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_day         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          bdate,edate   LIKE type_file.dat,     #No.FUN-680107 DATE
          l_nne04       LIKE nne_file.nne04,
          l_bank        LIKE nne_file.nne04,
          l_alg02       LIKE alg_file.alg02,
          sr            RECORD
                           rdate    LIKE type_file.dat,     #No.FUN-680107 DATE     #日期nne112
                           lweek    LIKE type_file.num5,    #No.FUN-680107 SMALLINT #週次
                           flag     LIKE type_file.num5,    #No.FUN-680107 SMALLINT #有資料否
                           curr     LIKE azi_file.azi01,    # Prog. Version..: '5.30.06-13.03.12(04) #幣別
                           bank     LIKE nne_file.nne04,    #銀行
                           amt      LIKE nne_file.nne12     #原幣未還金額
                        END RECORD
 
#NO.FUN-830054------start-----
   DEFINE c_amt    LIKE type_file.num20_6        #幣別:總計
   DEFINE l_amt    LIKE type_file.num20_6        #銀行/幣別:小計
   DEFINE l_curr   LIKE nne_file.nne16           #幣別
#NO.FUN-830054------start------
      CALL g_zaa_dyn.clear()    #No.FUN-680025 
#NO.FUN-830054------start------
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     DELETE FROM r719algno
     DELETE FROM r719_file
 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
     END IF
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
     END IF 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                " VALUES(?,?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
     END IF 
     LET g_sql ="INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                " VALUES(?,?,?,?,?)"
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM
     END IF 
   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='anmr719'
#NO.FUN-830054-----end----
     SELECT zo02 INTO g_company FROM zo_file WHERE
                        zo01 = g_rlang
 #No.FUN-680025---Begin-- 
#    FOR g_i = 1 TO 500 LET g_dash2[g_i,g_i] = '=' END FOR     
#    FOR g_i = 1 TO 500 LET g_dash[g_i,g_i] = '-' END FOR      
 #No.FUN-680025---End---
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
     #End:FUN-980030
 
 
 #   LET l_day=cl_days(tm.bdate,tm.edate)
 
#     DELETE FROM r719algno
#     DELETE FROM r719_file
    #FOR l_i = 1 TO 8 LET g_tit[l_i]=' ' END FOR
    #不可超過 8 家銀行
    #LET l_sql = "SELECT COUNT(DISTINCT nne04) FROM nne_file ",
     LET l_sql = "SELECT DISTINCT nne04,YEAR(nne112),MONTH(nne112) ",
                 " FROM nne_file ",
                 " WHERE nneconf='Y' ",
                 "   AND  ",tm.wc CLIPPED,
                 "   AND (nne12-nne27) >0 ",
                 "   AND ( nne112 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') "
     IF tm.t='1' THEN
        #LET l_sql=l_sql CLIPPED," AND (nne26 IS NULL OR nne26=' ' ) "   #MOD-7B0100
        LET l_sql=l_sql CLIPPED," AND nne26 IS NOT NULL "   #MOD-7B0100 #MOD-990205 ADD NOT 
     END IF
     IF tm.t='2' THEN
        #LET l_sql=l_sql CLIPPED," AND (nne26 IS NOT NULL OR nne26 !=' ' ) "   #MOD-7B0100
        LET l_sql=l_sql CLIPPED," AND nne26 IS NULL "   #MOD-7B0100 #MOD-990205 del not   
     END IF
     LET l_sql=l_sql CLIPPED," ORDER BY 2,3,1 "
     PREPARE anmr719_pcn1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare nne1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr719_ccn1 CURSOR FOR anmr719_pcn1
     LET l_max=0 LET l_ym='' LET l_cn=0 LET l_algno='' LET l_head=''
     LET i=1 LET j=1
     FOREACH anmr719_ccn1 INTO l_nne04,l_yyyy,l_mm
 
       LET l_yymm=l_yyyy USING '&&&&','/',l_mm USING '&&'
 
       IF l_ym IS NULL OR l_ym != l_yymm THEN
          LET l_cn=0  LET l_algno=''  LET i=1 LET j=1  LET l_head=''
          INSERT INTO r719algno VALUES(l_yymm,l_cn,l_algno,l_head)
          LET l_cn=0  LET l_algno='' LET l_head=''
         #LET i=1  LET j=1
       END IF
       IF l_cn= 0 THEN
          LET l_algno=l_nne04
       ELSE
          LET l_algno=l_algno[1,8*l_cn],l_nne04
       END IF
       SELECT alg02 INTO  l_alg02 FROM alg_file WHERE alg01=l_nne04
       IF l_cn=0 THEN
          LET l_head=l_nne04,' ',l_alg02
       ELSE
          LET l_head=l_head[1,21*l_cn],l_nne04,' ',l_alg02
       END IF
       LET l_cn=l_cn+1  #LET i=i+7 LET j=j+20
       UPDATE r719algno SET algno=l_algno,seq=l_cn,ghead=l_head
        WHERE yymm=l_yymm
       IF l_max < l_cn THEN LET l_max=l_cn END IF
       LET l_ym=l_yymm
     END FOREACH
     IF l_max=0 THEN
        CALL cl_err('','mfg3122',1)
#       EXIT PROGRAM      #No.FUN-680107
        RETURN            #No.FUN-680107
     END IF
   # unload to "/u/tei/anm/4gl/bb1" select * from r719algno
    {
     LET l_max=0 LET l_ym=' ' LET l_cn=0 LET l_algno='' LET l_head=''
     LET i=1 LET j=1
     DECLARE r719_cym CURSOR FOR
       SELECT yymm,no FROM r719alg ORDER BY 1,2
     FOREACH r719_cym INTO l_yymm,l_nne04
       IF l_ym IS NULL OR l_ym != l_yymm THEN
          LET l_cn=0  LET l_algno=''  LET i=1 LET j=1  LET l_head=''
          INSERT INTO r719algno VALUES(l_ym,l_cn,l_algno,l_head)
          LET l_cn=0  LET l_algno=''  LET i=1 LET j=1  LET l_head=''
       END IF
 
       LET l_algno=l_algno[i,i+7],l_nne04
       LET l_cn=l_cnt+1  LET i=i+8
       SELECT alg02 INTO  l_alg02 FROM alg_file WHERE alg01=l_nne04
       LET l_head=l_nne04,' ',l_alg02
       UPDATE r719algno SET algno=l_algno,seq=l_cn WHERE yymm=l_yymm
       IF l_max < l_cn THEN LET l_max=l_cn END IF
       LET l_ym=l_yymm
     END FOREACH
     LET g_len=9+g_seq*20+42
     LET l_no=g_seq*8
    }
 
    #行事曆
     LET l_sql = "SELECT sme01,azn05,'','','','' FROM sme_file,OUTER azn_file ",
                 " WHERE ( sme01 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
                 "   AND azn_file.azn01=sme_file.sme01 "
     PREPARE anmr719_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare sme:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr719_curs1 CURSOR FOR anmr719_prepare1
 
     LET l_sql = "SELECT nne16,nne04,SUM(nne12-nne27) ",
                 "  FROM nne_file " ,
                 " WHERE nneconf='Y' ",
                 "   AND (nne12-nne27) >0 ",
                 "   AND  ",tm.wc CLIPPED,
                 "   AND nne112 =?  AND nne04=? "
     IF tm.t='1' THEN
        #LET l_sql=l_sql CLIPPED," AND (nne26 IS NULL OR nne26=' ' ) "   #MOD-7B0100
        LET l_sql=l_sql CLIPPED," AND nne26 IS NOT NULL "   #MOD-7B0100 #MOD-990205 add not  
     END IF
     IF tm.t='2' THEN
        #LET l_sql=l_sql CLIPPED," AND (nne26 IS NOT NULL OR nne26 !=' ' ) "   #MOD-7B0100
        LET l_sql=l_sql CLIPPED," AND nne26 IS NULL "   #MOD-7B0100 #MOD-990205 del not  
     END IF
     LET l_sql=l_sql CLIPPED," GROUP BY nne16,nne04 ORDER BY nne04,nne16 "
     PREPARE anmr719_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare nne2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr719_curs2 CURSOR FOR anmr719_prepare2
     
#     CALL g_x.clear()                                 #No.FUN-680025#830054
    # CALL cl_outnam('anmr719') RETURNING l_name      #NO.FUN-830054
    # START REPORT anmr719_rep TO l_name              #NO.FUN-830054
 
    # LET g_pageno = 0                                #NO.FUN-830054
     LET l_week=1      LET l_algno=''
     LET l_ym=''
     FOREACH anmr719_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0
            THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_yymm=YEAR(sr.rdate) USING '&&&&','/',MONTH(sr.rdate) USING '&&'
        IF l_ym IS NULL OR l_ym != l_yymm THEN
           LET l_algno=''
           LET l_no = 0
           SELECT algno,seq INTO l_algno,l_no FROM r719algno WHERE yymm=l_yymm
        END IF
        LET l_ym=l_yymm LET j=1  LET g_cnt=0
        FOR i =1 TO l_no
           #LET l_nne04=l_algno[j,j+7] #MOD-990246                                                                                  
            LET l_nne04=l_algno[j,j+10] #MOD-990246    
            LET l_cn=0
            OPEN anmr719_curs2 USING sr.rdate,l_nne04
            FOREACH anmr719_curs2 INTO sr.curr,sr.bank,sr.amt
              LET l_cn=l_cn+1
              LET sr.flag=l_cn
              IF cl_null(sr.amt) THEN LET sr.amt=0 END IF
#              OUTPUT TO REPORT anmr719_rep(l_yymm,sr.*)   #NO.FUN-830054
#NO.FUN-830054-------START-----
      LET l_algno=''
      SELECT algno,seq,ghead INTO l_algno,g_seq,l_head
       FROM r719algno WHERE yymm=l_yymm
      IF cl_null(g_seq) THEN LET g_seq=0 END IF
      LET l_no=g_seq
      LET g_zaa[33].zaa08 =l_head
      #CALL cl_prt_pos_dyn()
 
      DECLARE c_ym CURSOR FOR
        SELECT DISTINCT curr FROM r719_file
         WHERE yyyymm=l_yymm ORDER BY 1
      OPEN c_ym
      FOREACH c_ym INTO l_curr
        SELECT azi05 INTO t_azi05   #NO.CHI-6A0004
          FROM azi_file
         WHERE azi01=l_curr
        LET c_amt=0 LET j=1 
        FOR i =1 TO g_seq
           #LET l_nne04=l_algno[j,j+7] #MOD-990246                                                                                  
            LET l_nne04=l_algno[j,j+10] #MOD-990246    
            SELECT SUM(amt) INTO l_amt FROM r719_file
             WHERE yyyymm=l_yymm AND curr=l_curr
               AND bank  =l_nne04
            IF cl_null(l_amt) THEN LET l_amt=0 END IF
            EXECUTE insert_prep1 USING
                l_yymm,l_curr,l_nne04,l_amt
            LET c_amt=c_amt+l_amt
            LET j=j+8
        END FOR
        EXECUTE insert_prep2 USING l_curr,l_yymm,c_amt
      END FOREACH
 
      IF sr.flag !=0 THEN
         LET c_amt=0 LET j=1
         FOR i =1 TO g_seq
             SELECT azi05 INTO t_azi05  
               FROM azi_file
              WHERE azi01=sr.curr
            #LET l_nne04=l_algno[j,j+7] #MOD-990246                                                                                  
            LET l_nne04=l_algno[j,j+10] #MOD-990246    
             SELECT SUM(amt) INTO l_amt FROM r719_file
              WHERE yyyymm=l_yymm AND curr=sr.curr
                AND bank  =l_nne04 AND rdate=sr.rdate
             IF cl_null(l_amt) THEN LET l_amt=0 END IF
             EXECUTE insert_prep3 USING
                l_yymm,sr.rdate,sr.curr,l_nne04,l_amt
             LET c_amt=c_amt+l_amt
             LET j=j+8
         END FOR
      END IF
          EXECUTE insert_prep USING
             l_yymm,sr.rdate,sr.lweek,sr.flag,sr.curr,sr.bank,
             sr.amt,l_head
#NO.FUN-830054------END-----
              INSERT INTO r719_file VALUES(l_yymm,sr.lweek,sr.rdate,
                                           sr.curr,sr.bank,sr.amt)
            END FOREACH
            LET j=j+8  LET g_cnt=g_cnt+1
        END FOR
        IF g_cnt=0 THEN
           IF cl_null(sr.amt) THEN LET sr.amt=0 END IF
           LET sr.curr=' '
           LET sr.bank=l_nne04
           LET sr.flag=0
#           OUTPUT TO REPORT anmr719_rep(l_yymm,sr.*)      #NO.FUN-830054
#NO.FUN-830054-------START-----
      LET l_algno=''
      SELECT algno,seq,ghead INTO l_algno,g_seq,l_head
       FROM r719algno WHERE yymm=l_yymm
      IF cl_null(g_seq) THEN LET g_seq=0 END IF
      LET l_no=g_seq
      LET g_zaa[33].zaa08 =l_head
      #CALL cl_prt_pos_dyn()
 
      DECLARE c_ym0 CURSOR FOR
        SELECT DISTINCT curr FROM r719_file
         WHERE yyyymm=l_yymm ORDER BY 1
      OPEN c_ym0
      FOREACH c_ym0 INTO l_curr
        SELECT azi05 INTO t_azi05   #NO.CHI-6A0004
          FROM azi_file
         WHERE azi01=l_curr
        LET c_amt=0 LET j=1 
        FOR i =1 TO g_seq
           #LET l_nne04=l_algno[j,j+7] #MOD-990246                                                                                  
            LET l_nne04=l_algno[j,j+10] #MOD-990246    
            SELECT SUM(amt) INTO l_amt FROM r719_file
             WHERE yyyymm=l_yymm AND curr=l_curr
               AND bank  =l_nne04
            IF cl_null(l_amt) THEN LET l_amt=0 END IF
            LET l_curr= ''
            LET l_amt = 0
            EXECUTE insert_prep1 USING
                l_yymm,l_curr,l_nne04,l_amt
            LET c_amt=c_amt+l_amt
            LET j=j+8
        END FOR
 
            LET l_curr= ''
            LET c_amt = 0
        EXECUTE insert_prep2 USING l_curr,l_yymm,c_amt
      END FOREACH
 
          EXECUTE insert_prep USING
             l_yymm,sr.rdate,sr.lweek,sr.flag,sr.curr,sr.bank,
             sr.amt,l_head
#NO.FUN-830054------END-----
        END IF
     END FOREACH
    #unload to "/u/tei/anm/4gl/bb" select * from r719_file
 
#     FINISH REPORT anmr719_rep                            #NO.FUN-830054
 
  #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     CALL cl_prt(l_name,g_prtway,g_copies,l_max)          #NO.FUN-830054
 
#NO.FUN-830054-----start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
     IF g_zz05 ='Y' THEN 
       CALL cl_wcchp(tm.wc,'nne01,nne02,nne04,nne112,nne06,nne16')
            RETURNING tm.wc
     END IF 
     LET  g_str=tm.wc,";",g_cnt
     CALL cl_prt_cs3('anmr719','anmr719',g_sql,g_str)
#NO.FUN-830054-----end----
END FUNCTION
 
#NO.FUN-830054-----start----mark
#REPORT anmr719_rep(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0082
#          l_nne04    LIKE nne_file.nne04,
#          t_azi05    LIKE azi_file.azi05,    #NO.CHI-6A0004
#          sr       RECORD
# Prog. Version..: '5.30.06-13.03.12(07) #YYYY/MM
#                           rdate    LIKE type_file.dat,     #No.FUN-680107 DATE     #日期nne112
#                           lweek    LIKE type_file.num5,    #No.FUN-680107 SMALLINT #週次
#                           flag     LIKE type_file.num5,    #No.FUN-680107 SMALLINT #有資料否
# Prog. Version..: '5.30.06-13.03.12(04) #幣別
#                           bank     LIKE nne_file.nne04,    #銀行
#                           amt      LIKE nne_file.nne12     #原幣未還金額
#                   END RECORD
#   DEFINE b_tot    LIKE type_file.num20_6        #到期日/幣別/銀行  #No.FUN-680107 DECIMAL(20,6)
#   DEFINE l_tot    LIKE type_file.num20_6        #當日總計  #No.FUN-680107 DECIMAL(20,6)
#   DEFINE s_tot    LIKE type_file.num20_6        #各週總計  #No.FUN-680107 DECIMAL(20,6)
#   DEFINE c_amt    LIKE type_file.num20_6        #幣別:總計  #No.FUN-680107 DECIMAL(20,6)
#   DEFINE l_amt    LIKE type_file.num20_6        #銀行/幣別:小計計  #No.FUN-680107 DECIMAL(20,6)
#   DEFINE l_curr   LIKE nne_file.nne16           #幣別
#   DEFINE l_str    LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(500)
#   DEFINE i,j      LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
#  OUTPUT TOP MARGIN g_top_margin
#         BOTTOM MARGIN g_bottom_margin
#         LEFT MARGIN g_left_margin
#         PAGE LENGTH g_page_line
#
 #到期日/幣別/週尾
#  ORDER BY sr.yymm,sr.lweek,sr.rdate,sr.curr,sr.bank
#
#  FORMAT
#   PAGE HEADER
#      LET l_algno='' # LET l_head=''
#      SELECT algno,seq,ghead INTO l_algno,g_seq,l_head
#       FROM r719algno WHERE yymm=sr.yymm
#      IF cl_null(g_seq) THEN LET g_seq=0 END IF
#      LET l_no=g_seq
#No.FUN-680025------Begin----
#     IF l_max > g_seq THEN
#        LET g_len=9+l_max*20+54
#     ELSE
#        LET g_len=9+g_seq*20+54
#     END IF
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED 
#      PRINT ' '   #TQC-740024
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED #TQC-740024
#      PRINT (g_len-20)/2 SPACES,'年度月份: ',sr.yymm  #TQC-740024          
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5), 'FROM:', g_user CLIPPED
#      LET g_pageno = g_pageno+1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total  
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED  #TQC-740024 mark
#No.FUN-680025-------End--- 
#     PRINT ' '   #TQC-740024
#     PRINT (g_len-20)/2 SPACES,'年度月份: ',sr.yymm  #TQC-740024 mark
#     PRINT
#No.FUN-680025-------Begin--- 
#     PRINT g_x[2] CLIPPED, g_pdate, ' ',TIME,                       
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'         
#      PRINT g_dash[1,g_len]
#     PRINT COLUMN 2,g_x[11] clipped;
#     PRINT COLUMN 18,l_head CLIPPED;
##     PRINT COLUMN 44,g_x[14] CLIPPED,COLUMN 69,g_x[15] CLIPPED
##     PRINT '--------';
#      LET g_zaa[33].zaa08 =l_head
#      CALL cl_prt_pos_dyn()           
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINT g_dash1
#     FOR i = 1 TO g_seq
#         PRINT COLUMN 15, '-------------------';
#     END FOR
#No.TQC-5C0051 start
      #PRINT COLUMN 39,'--------------------',
      #      COLUMN 64,'--------------------'
#      PRINT COLUMN 39,'-------------------',
##            COLUMN 64,'-------------------'
##No.TQC-5C0051 end
##No.FUN-680025-------End---
#      LET l_last_sw = 'N'
#
#   AFTER GROUP OF sr.yymm  #年度月份
#      DECLARE c_ym CURSOR FOR
#        SELECT DISTINCT curr FROM r719_file
#         WHERE yyyymm=sr.yymm ORDER BY 1
#      OPEN c_ym
#      FOREACH c_ym INTO l_curr
#        SELECT azi05 INTO t_azi05   #NO.CHI-6A0004
#          FROM azi_file
#         WHERE azi01=l_curr
#        LET c_amt=0 LET j=1
#       PRINT l_curr,COLUMN 5,g_x[13] CLIPPED;   #TQC-5A0027
#        PRINT COLUMN 5,g_x[13] CLIPPED;   #TQC-5A0027
#        FOR i =1 TO g_seq
#            LET l_nne04=l_algno[j,j+7]
#            SELECT SUM(amt) INTO l_amt FROM r719_file
#             WHERE yyyymm=sr.yymm AND curr=l_curr
#               AND bank  =l_nne04
#            IF cl_null(l_amt) THEN LET l_amt=0 END IF
##No.FUN-680025------Begin----
##           PRINT COLUMN 10,l_curr,COLUMN 15,cl_numfor(l_amt,18,t_azi05) ;  #NO.CHI-6A0004
#            PRINT COLUMN g_c[32],l_curr,
#                  COLUMN g_c[33],l_amt  USING '#,###,###,###,##&.&&';   
##No.FUN-680025------End-----
#            LET c_amt=c_amt+l_amt
#            LET j=j+8
#        END FOR
##No.FUN-680025------Begin-----  
##       PRINT COLUMN 60,l_curr,COLUMN 64,cl_numfor(c_amt,18,t_azi05)  #NO.CHI-6A0004
#        PRINT COLUMN g_c[36],l_curr,
#              COLUMN g_c[37],c_amt  USING '#,###,###,###,##&.&&'  
##No.FUN-680025------End-----  
#      END FOREACH
#
#   BEFORE GROUP OF sr.yymm  #年度月份
#      LET s_tot=0 LET l_tot=0 LET b_tot=0
#      LET l_algno=''  LET l_head=''
#      SELECT algno,seq,ghead INTO l_algno,g_seq,l_head
#       FROM r719algno WHERE yymm=sr.yymm
#      IF cl_null(g_seq) THEN LET g_seq=0 END IF
#      LET l_no=g_seq
#No.FUN-680025------Begin----  
#     IF l_max > g_seq THEN
#        LET g_len=9+l_max*20+54
#     ELSE
#        LET g_len=9+g_seq*20+54
#     END IF
##No.FUN-680025------End---  
#      SKIP TO TOP OF PAGE
#
#   AFTER GROUP OF sr.lweek   #週次
#      LET c_amt=0
#      DECLARE c_week CURSOR FOR     #年度+幣別+銀行:小計
#        SELECT curr,SUM(amt) FROM r719_file
#         WHERE yyyymm=sr.yymm AND lweek=sr.lweek
#         GROUP BY curr  ORDER BY curr
#      LET g_cnt=0 LET c_amt=0
#      FOREACH c_week INTO l_curr,c_amt
#        SELECT azi05 INTO t_azi05  #NO.CHI-6A0004
#          FROM azi_file
#         WHERE azi01=l_curr
#        IF cl_null(c_amt) THEN LET c_amt=0 END IF
#No.FUN-680025------Begin----  
##       PRINT COLUMN  60,l_curr,COLUMN 64,cl_numfor(c_amt,18,l_azi05)
#        PRINT COLUMN g_c[36],l_curr,
#              COLUMN g_c[37],c_amt  USING '#,###,###,###,##&.&&'
##No.FUN-680025------End----  
#        LET g_cnt=g_cnt+1
#      END FOREACH
#      IF g_cnt=0 THEN
# Prog. Version..: '5.30.06-13.03.12(0,37,t_azi05)           #No.FUN-680025 #NO.CHI-6A0004
#      END IF
#      PRINT g_dash2[1,g_len]                                   #No.FUN-680025
#
#   BEFORE GROUP OF sr.rdate   #到期日
#      #PRINT sr.rdate USING 'YY/MM/DD',' '; #FUN-570250 mark
#      PRINT sr.rdate,' '; #FUN-570250 add
#
#   AFTER GROUP OF sr.rdate   #到期日
#      IF sr.flag =0 THEN
# Prog. Version..: '5.30.06-13.03.12(0,35,t_azi05)           #No.FUN-680025  #NO.CHI-6A0004
#      END IF
#
#   AFTER GROUP OF sr.curr    #幣別
#      IF sr.flag !=0 THEN
#         LET c_amt=0 LET j=1
#         FOR i =1 TO g_seq
#             SELECT azi05 INTO t_azi05  #NO.CHI-6A0004
#               FROM azi_file
#              WHERE azi01=sr.curr
#             LET l_nne04=l_algno[j,j+7]
#             SELECT SUM(amt) INTO l_amt FROM r719_file
#              WHERE yyyymm=sr.yymm AND curr=sr.curr
#                AND bank  =l_nne04 AND rdate=sr.rdate
#             IF cl_null(l_amt) THEN LET l_amt=0 END IF
#             IF i=1 THEN
 
##No.FUN-680025------Begin----  
##    PRINT COLUMN 10,sr.curr, COLUMN 15,cl_numfor(l_amt,31,l_azi05);
#     PRINT COLUMN g_c[32],sr.curr,
#           COLUMN g_c[33],l_amt  USING '#,###,###,###,##&.&&' ;       
#             ELSE
##    PRINT COLUMN 10,sr.curr,COLUMN 15,cl_numfor(l_amt,18,l_azi05);
#     PRINT COLUMN g_c[32],sr.curr,
#           COLUMN g_c[33],l_amt  USING '#,###,###,###,##&.&&';         
##No.FUN-680025------End----  
#             END IF
#             LET c_amt=c_amt+l_amt
#             LET j=j+8
#         END FOR
##No.FUN-680025------Begin----  
##        PRINT COLUMN 35,sr.curr,COLUMN 39,cl_numfor(c_amt,18,l_azi05)
#         PRINT COLUMN g_c[34],sr.curr,
#               COLUMN g_c[35],c_amt  USING '#,###,###,###,##&.&&' 
#No.FUN-680025------End----  
#      END IF
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]                         #No.FUN-680025
#      LET l_last_sw = 'Y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#     IF l_last_sw = 'N' THEN
#      PRINT g_dash[1,g_len] CLIPPED                 #No.FUN-680025
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len - 9),g_x[6] CLIPPED
#     ELSE
#      SKIP 2 LINE
#     END IF
#END REPORT
