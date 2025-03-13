# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: amsg512.4gl
# Descriptions...: MPS 模擬明細表
# Input parameter:
# Return code....:
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/03/02 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-550056 05/05/23 By Trisy 單據編號加大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580294 05/10/17 By Pengu 1.雖然表頭列印了很多欄，但是大部分欄位都沒有寫至相對應的數據。
                                           #       2.報表列印格式為舊式，將之改為新式列印格式
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.MOD-580209 05/08/18 By Carol g_msg1 改用 g_msg
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: No.TQC-750041 07/05/15 By mike 修改報表格式
# Modify.........: No.FUN-770012 07/07/23 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-940413 09/05/21 By Pengu 1.供需日期會出現1899/12/31的資料
#                                                  2.若勾選列印PLP/PLM時，列印時的結存數量會異常
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.TQC-AB0408 10/12/04 By huangtao 需求單號和供給單號長度不夠，會被截掉 
# Modify.........: No.FUN-B80027 11/08/03 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-CB0072 12/11/22 By dongsz CR轉GR

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm RECORD                           # Print condition RECORD
              #wc      LIKE type_file.chr1000,  #NO.FUN-680101 VARCHAR(600)   # Where condition   #FUN-CB0072 mark
               wc      STRING,                  #FUN-CB0072 add
              #n       VARCHAR(1),                 #TQC-610075
               ver_no  LIKE mps_file.mps_v,     #NO.FUN-680101 VARCHAR(2)
               part1   LIKE bma_file.bma01,     #FUN-560011    #NO.FUN-680101 VARCHAR(40)
               part2   LIKE ima_file.ima01,     #FUN-560011    #NO.FUN-680101 VARCHAR(40)
               print_adj LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
               print_plp LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
               order_way LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
               more    LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)    # Input more condition(Y/N)
            END RECORD
#       g_dash1 VARCHAR(400),     #No.MOD-580294 mark
#       g_msg1  VARCHAR(300),      #MOD-580209 mark
#       g_dash2 VARCHAR(400)      #No.MOD-580294 mark
 
DEFINE  g_i             LIKE type_file.num5    #NO.FUN-680101 SMALLINT    #count/index for any purpose
DEFINE  g_msg           LIKE type_file.chr1000 #NO.FUN-680101 VARCHAR(72)
#DEFINE g_len           SMALLINT   #Report width(79/132/136)  #MOD-580294 mark
#DEFINE g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)   #MOD-580294 mark
DEFINE  g_head1         STRING    #MOD-580294
#No.FUN-770012 -- begin --
DEFINE  g_sql      STRING
DEFINE  l_table    STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING
DEFINE  l_table1   STRING  #No.CHI-A10003 mod LIKE type_file.chr20-->STRING
DEFINE  g_str      STRING
#No.FUN-770012 -- end --
 
###GENGRE###START
TYPE sr1_t RECORD
    mps01 LIKE mps_file.mps01,
    mps03 LIKE mps_file.mps03,
    order1 LIKE mpt_file.mpt06,
    mpt04 LIKE mpt_file.mpt04,
    mpt05 LIKE mpt_file.mpt05,
    ima02 LIKE ima_file.ima02,
    ima25 LIKE ima_file.ima25,
    mps00 LIKE mps_file.mps00,
    mpt08 LIKE mpt_file.mpt08,
    mpt06 LIKE mpt_file.mpt06,
    mpt061 LIKE mpt_file.mpt061,
    mpt07 LIKE mpt_file.mpt07
END RECORD

TYPE sr2_t RECORD
    mps01 LIKE mps_file.mps01,
    ima02 LIKE ima_file.ima02,
    ima25 LIKE ima_file.ima25,
    mps00 LIKE mps_file.mps00,
    mps03 LIKE mps_file.mps03,
    order1 LIKE mpt_file.mpt06,
    mpt04 LIKE mpt_file.mpt04,
    mpt05 LIKE mpt_file.mpt05,
    bal LIKE mpt_file.mpt08,
    d_mpt04 LIKE mpt_file.mpt04,
    d_mpt05 LIKE type_file.chr30,
    d_mpt06 LIKE mpt_file.mpt06,
    d_mpt07 LIKE mpt_file.mpt07,
    d_mpt08 LIKE mpt_file.mpt08,
    s_mpt04 LIKE mpt_file.mpt04,
    s_mpt05 LIKE type_file.chr30,
    s_mpt06 LIKE mpt_file.mpt06,
    s_mpt07 LIKE mpt_file.mpt07,
    s_mpt08 LIKE mpt_file.mpt08,
    num1    LIKE type_file.num5    #FUN-CB0072 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610075-begin
   LET tm.ver_no   = ARG_VAL(8)
   LET tm.part1    = ARG_VAL(9)
   LET tm.part2    = ARG_VAL(10)
   LET tm.print_adj = ARG_VAL(11)
   LET tm.print_plp = ARG_VAL(12)
   LET tm.order_way = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610075-end
#No.FUN-770012 -- begin --
   LET g_sql = "mps01.mps_file.mps01,",    #存儲拋給REPORT的數據
               "mps03.mps_file.mps03,",
               "order1.mpt_file.mpt06,",
               "mpt04.mpt_file.mpt04,",
               "mpt05.mpt_file.mpt05,",
               "ima02.ima_file.ima02,",
               "ima25.ima_file.ima25,",
               "mps00.mps_file.mps00,",
               "mpt08.mpt_file.mpt08,",
               "mpt06.mpt_file.mpt06,",
               "mpt061.mpt_file.mpt061,",
               "mpt07.mpt_file.mpt07"
   LET l_table = cl_prt_temptable('amsg512',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "mps01.mps_file.mps01,",    #存儲拋給CR的數據
               "ima02.ima_file.ima02,",
               "ima25.ima_file.ima25,",
               "mps00.mps_file.mps00,",
               "mps03.mps_file.mps03,",
               "order1.mpt_file.mpt06,",
               "mpt04.mpt_file.mpt04,",
               "mpt05.mpt_file.mpt05,",
               "bal.mpt_file.mpt08,",
               "d_mpt04.mpt_file.mpt04,",
               "d_mpt05.type_file.chr30,",
               "d_mpt06.mpt_file.mpt06,",
               "d_mpt07.mpt_file.mpt07,",
               "d_mpt08.mpt_file.mpt08,",
               "s_mpt04.mpt_file.mpt04,",
               "s_mpt05.type_file.chr30,",
               "s_mpt06.mpt_file.mpt06,",
               "s_mpt07.mpt_file.mpt07,",
               "s_mpt08.mpt_file.mpt08,",
               "num1.type_file.num5"        #FUN-CB0072 add
   LET l_table1 = cl_prt_temptable('amsg5121',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
#No.FUN-770012 -- end --
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsg512_tm(0,0)        # Input print condition
      ELSE CALL amsg512()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsg512_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amsg512_w AT p_row,p_col
        WITH FORM "ams/42f/amsg512"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.n    = '2'                  #TQC-610075
   LET tm.print_adj = 'Y'
   LET tm.print_plp = 'Y'
   LET tm.order_way = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima08,ima67,ima43,mps03
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
           #IF INFIELD(mps01) THEN                 #FUN-CB0072 mark
         CASE                                      #FUN-CB0072 add
            WHEN INFIELD(mps01)                    #FUN-CB0072 add
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO mps01
               NEXT FIELD mps01
        #FUN-CB0072--add--str---
            WHEN INFIELD(ima67)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima67
               NEXT FIELD ima67
            WHEN INFIELD(ima43)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima43
               NEXT FIELD ima43
         END CASE
        #FUN-CB0072--add--end---
        #   END IF                     #FUN-CB0072 mark
#No.FUN-570240 --end--
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW amsg512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
      EXIT PROGRAM
   END IF
   INPUT BY NAME tm.ver_no, tm.part1, tm.part2,
                 tm.print_adj, tm.print_plp, tm.order_way, tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
      AFTER FIELD part1
         IF NOT cl_null(tm.part1) THEN
            SELECT bma01 FROM bma_file WHERE bma01=tm.part1
            IF STATUS THEN
               CALL cl_err('sel bma:',STATUS,0) NEXT FIELD part1
            END IF
         END IF
      AFTER FIELD part2
         IF NOT cl_null(tm.part2) THEN
            SELECT ima01 FROM ima_file WHERE ima01=tm.part2
            IF STATUS THEN
               CALL cl_err('sel ima:',STATUS,0) NEXT FIELD part2
            END IF
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLP
         CASE WHEN INFIELD(part1)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bma'
                   LET g_qryparam.default1 = tm.part1
                   CALL cl_create_qry() RETURNING tm.part1
                   DISPLAY BY NAME tm.part1
              WHEN INFIELD(part2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_ima'
                   LET g_qryparam.default1 = tm.part2
                   CALL cl_create_qry() RETURNING tm.part2
                   DISPLAY BY NAME tm.part2
         END CASE
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW amsg512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsg512'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsg512','9031',1)
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
                         #TQC-610075-begin
                         " '",tm.ver_no    CLIPPED,"'",
                         " '",tm.part1     CLIPPED,"'",
                         " '",tm.part2     CLIPPED,"'",
                         " '",tm.print_adj CLIPPED,"'",
                         " '",tm.print_plp CLIPPED,"'",
                         " '",tm.order_way CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amsg512',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsg512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsg512()
   ERROR ""
END WHILE
   CLOSE WINDOW amsg512_w
END FUNCTION
 
FUNCTION amsg512()
   DEFINE l_name    LIKE type_file.chr20,   #NO.FUN-680101 VARCHAR(20)      # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
         #l_sql     LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(1000)    # RDSQL STATEMENT   #FUN-CB0072 mark
          l_sql     STRING,                 #FUN-CB0072 add
          l_chr     LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(40)
          mps	RECORD LIKE mps_file.*,
          mpt	RECORD LIKE mpt_file.*,
          ima	RECORD LIKE ima_file.*,
          sr	RECORD
                   order1 LIKE mpt_file.mpt06, #NO.FUN-680101 VARCHAR(20)
                   ima02  LIKE ima_file.ima02,
                   ima08  LIKE ima_file.ima08,
                   ima25  LIKE ima_file.ima25
          	END RECORD
#No.FUN-770012 -- begin --
   DEFINE bal    LIKE mpt_file.mpt08
   DEFINE l_buf  LIKE mpt_file.mpt05
   DEFINE l_mps01_t  LIKE mps_file.mps01    #分組,備份舊值
   DEFINE demand RECORD
                    mpt04 LIKE mpt_file.mpt04,
                    mpt05 LIKE type_file.chr30,
                    mpt06 LIKE mpt_file.mpt06,
                    mpt07 LIKE mpt_file.mpt07,
                    mpt08 LIKE mpt_file.mpt08
                 END RECORD
   DEFINE supply RECORD
                    mpt04 LIKE mpt_file.mpt04,
                    mpt05 LIKE type_file.chr30,
                    mpt06 LIKE mpt_file.mpt06,
                    mpt07 LIKE mpt_file.mpt07,
                    mpt08 LIKE mpt_file.mpt08
                 END RECORD
   DEFINE l_num1    LIKE type_file.num5     #FUN-CB0072 add
   DEFINE l_d_t5_name LIKE type_file.chr30  #FUN-CB0072 add
   DEFINE l_s_t5_name LIKE type_file.chr30  #FUN-CB0072 add
 
   CALL cl_del_data(l_table)     #No.FUN-770012
   CALL cl_del_data(l_table1)    #No.FUN-770012
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"                                                                                 
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used( g_prog,g_time,2) RETURNING g_time  # FUN-B80027
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                           
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?)"      #FUN-CB0072 add 1?                                                                                     
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used( g_prog,g_time,2) RETURNING g_time  # FUN-B80027
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
      EXIT PROGRAM                                                                            
   END IF
#No.FUN-770012 -- end --
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#----No.MOD-580294 mark
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amsg512'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 120 END IF
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
#    FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
#-----end
 
     CASE WHEN tm.part1 IS NOT NULL
               CALL r512_bom1_main()
               LET l_sql = "SELECT mps_file.*, ima_file.*",
                           "  FROM r512_tmp, mps_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,
                           "   AND partno=mps01",
                           "   AND mps01=ima01 ",
                           "   AND mps_v='",tm.ver_no,"'"
          WHEN tm.part2 IS NOT NULL
               CALL r512_bom2_main()
               LET l_sql = "SELECT mps_file.*, ima_file.*",
                           "  FROM r512_tmp, mps_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,
                           "   AND partno=mps01",
                           "   AND mps01=ima01 ",
                           "   AND mps_v='",tm.ver_no,"'"
          OTHERWISE
               LET l_sql = "SELECT mps_file.*, ima_file.*",
                           "  FROM mps_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,
                           "   AND mps01=ima01 ",
                           "   AND mps_v='",tm.ver_no,"'"
     END CASE
     DISPLAY 'l_sql:',l_sql
     PREPARE amsg512_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
        EXIT PROGRAM
     END IF
     DECLARE amsg512_curs1 CURSOR FOR amsg512_prepare1
 
#No.FUN-770012 -- begin --
#     CALL cl_outnam('amsg512') RETURNING l_name
#     START REPORT amsg512_rep TO l_name
#     LET g_pageno = 0
#No.FUN-770012 -- end --
     FOREACH amsg512_curs1 INTO mps.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       message mps.mps01 clipped
       CALL ui.Interface.refresh()
       LET sr.ima02=ima.ima02
       LET sr.ima08=ima.ima08
       LET sr.ima25=ima.ima25
       DECLARE amsg512_curs2 CURSOR FOR
          SELECT * FROM mpt_file
            WHERE mpt01=mps.mps01 AND mpt03=mps.mps03
              AND mpt_v=mps.mps_v
       FOREACH amsg512_curs2 INTO mpt.*
         #message 'mpt:',mpt.mpt01 clipped
         CASE WHEN tm.order_way='1' LET sr.order1=mpt.mpt03
              WHEN tm.order_way='2' LET sr.order1=mpt.mpt04
              OTHERWISE             LET sr.order1=mpt.mpt04,mpt.mpt05,mpt.mpt06
         END CASE
#No.FUN-770012 -- begin --
#         OUTPUT TO REPORT amsg512_rep(mps.*, mpt.*, sr.*)
 
         EXECUTE insert_prep USING mps.mps01,mps.mps03,sr.order1,mpt.mpt04,
                                   mpt.mpt05,sr.ima02,sr.ima25,mps.mps00,mpt.mpt08,
                                   mpt.mpt06,mpt.mpt061,mpt.mpt07
         IF STATUS THEN
            CALL cl_err("execute insert_prep:",STATUS,1)
            EXIT FOREACH
         END IF
#No.FUN-770012 -- end --
       END FOREACH
       INITIALIZE mpt.* TO NULL
       LET mpt.mpt01=mps.mps01
       LET mpt.mpt03=mps.mps03
       LET mpt.mpt04=mps.mps03
       LET sr.order1=mps.mps03
       IF tm.print_adj='Y' THEN     #是否列印交期調整建議資料
          IF mps.mps072-mps.mps071 != 0 THEN
             LET mpt.mpt05='71'
             LET mpt.mpt08=mps.mps072-mps.mps071
#No.FUN-770012 -- begin --
#             OUTPUT TO REPORT amsg512_rep(mps.*, mpt.*, sr.*)
             EXECUTE insert_prep USING mps.mps01,mps.mps03,sr.order1,mpt.mpt04,
                                       mpt.mpt05,sr.ima02,sr.ima25,mps.mps00,mpt.mpt08,
                                       mpt.mpt06,mpt.mpt061,mpt.mpt07
             IF STATUS THEN
                CALL cl_err("execute insert_prep:",STATUS,1)
                EXIT FOREACH
             END IF
#No.FUN-770012 -- end --
          END IF
       END IF
       IF tm.print_plp='Y' THEN     #是否列印PLM/PLP建議資料
          IF mps.mps09 != 0 THEN
             IF ima.ima08='M'
                THEN LET mpt.mpt05=' M' # 這樣才會排在前面
                ELSE LET mpt.mpt05=' P' # 這樣才會排在前面
             END IF
             LET mpt.mpt08=mps.mps09
#No.FUN-770012 -- begin --
#             OUTPUT TO REPORT amsg512_rep(mps.*, mpt.*, sr.*)
             EXECUTE insert_prep USING mps.mps01,mps.mps03,sr.order1,mpt.mpt04,
                                       mpt.mpt05,sr.ima02,sr.ima25,mps.mps00,mpt.mpt08,
                                       mpt.mpt06,mpt.mpt061,mpt.mpt07
             IF STATUS THEN
                CALL cl_err("execute insert_prep:",STATUS,1)
                EXIT FOREACH
             END IF
#No.FUN-770012 -- end --
          END IF
       END IF
     END FOREACH
 
#No.FUN-770012 -- begin --
#     FINISH REPORT amsg512_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #-------------No.MOD-940413 modify
    #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " ORDER BY mps01,mps03,mpt04,mpt05 "
    #-------------No.MOD-940413 end
     PREPARE r512_pre3 FROM g_sql
     DECLARE r512_cur3 CURSOR FOR r512_pre3
     INITIALIZE l_mps01_t TO NULL            #初始化分組舊值
     FOREACH r512_cur3 INTO mps.mps01,mps.mps03,sr.order1,mpt.mpt04,mpt.mpt05,
                            sr.ima02,sr.ima25,mps.mps00,mpt.mpt08,mpt.mpt06,
                            mpt.mpt061,mpt.mpt07
       #--------------No.MOD-940413 add
        INITIALIZE demand TO NULL
        INITIALIZE supply TO NULL
       #--------------No.MOD-940413 end
        IF cl_null(l_mps01_t) OR mps.mps01 <> l_mps01_t THEN
           LET bal = 0
           LET l_mps01_t = mps.mps01
        ELSE
          #-------No.MOD-940413 modify
          #IF mpt.mpt05 MATCHES '4*' THEN
           IF (mpt.mpt05 MATCHES '4*') OR (mpt.mpt05 = '53' AND mpt.mpt08 < 0)
              OR (mpt.mpt05 = '71' AND mpt.mpt08 < 0) OR (mpt.mpt05 = '39') THEN
          #-------No.MOD-940413 end
              LET bal = bal - mpt.mpt08
           ELSE
              LET bal = bal + mpt.mpt08
           END IF
        END IF
        IF (mpt.mpt05 MATCHES '4*') OR (mpt.mpt05 = '53' AND mpt.mpt08 < 0) OR
          #(mpt.mpt05 = '71' AND mpt.mpt08 < 0) THEN                          #No.MOD-940413 mark
           (mpt.mpt05 = '71' AND mpt.mpt08 < 0) OR (mpt.mpt05 = '39') THEN    #No.MOD-940413 add
           LET l_d_t5_name = cl_gr_getmsg('gre-338',g_lang,mpt.mpt05)         #FUN-CB0072 add
          #LET l_buf=s_mpt05(mpt.mpt05)                                       #FUN-CB0072 mark
           LET demand.mpt04=mpt.mpt04
          #LET demand.mpt05=mpt.mpt05,' ',l_buf                               #FUN-CB0072 mark
           LET demand.mpt05=mpt.mpt05,':',l_d_t5_name                         #FUN-CB0072 add
  #         LET demand.mpt06=mpt.mpt06[1,10],' ',mpt.mpt061 USING '###'        #TQC-AB0408 mark
            LET demand.mpt06=mpt.mpt06[1,20],' ',mpt.mpt061 USING '###'        #TQC-AB0408
           LET demand.mpt07=mpt.mpt07
           LET demand.mpt08=mpt.mpt08
        ELSE
           LET l_s_t5_name = cl_gr_getmsg('gre-338',g_lang,mpt.mpt05)         #FUN-CB0072 add
          #LET l_buf=s_mpt05(mpt.mpt05)                                       #FUN-CB0072 mark
           LET supply.mpt04=mpt.mpt04
          #LET supply.mpt05=mpt.mpt05,' ',l_buf                               #FUN-CB0072 mark
           LET supply.mpt05=mpt.mpt05,':',l_s_t5_name                         #FUN-CB0072 add             
  #         LET supply.mpt06=mpt.mpt06[1,10],' ',mpt.mpt061 USING '###'        #TQC-AB0408 mark
           LET supply.mpt06=mpt.mpt06[1,20],' ',mpt.mpt061 USING '###'        #TQC-AB0408
           LET supply.mpt07=mpt.mpt07
           LET supply.mpt08=mpt.mpt08
        END IF
        LET l_num1 = 0                 #FUN-CB0072 add
        EXECUTE insert_prep1 USING mps.mps01,sr.ima02,sr.ima25,mps.mps00,mps.mps03,sr.order1,
                                   mpt.mpt04,mpt.mpt05,bal,demand.mpt04,demand.mpt05,
                                   demand.mpt06,demand.mpt07,demand.mpt08,supply.mpt04,
                                   supply.mpt05,supply.mpt06,supply.mpt07,supply.mpt08,l_num1    #FUN-CB0072 add l_num1
        IF STATUS THEN
           CALL cl_err("execute insert_prep1:",STATUS,1)
           EXIT FOREACH
        END IF
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'mps01,ima08,ima67,ima43,mps03')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05,";",g_azi03,";",g_azi04,";",g_azi05
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
###GENGRE###     CALL cl_prt_cs3('amsg512','amsg512',g_sql,g_str)
    CALL amsg512_grdata()    ###GENGRE###
#No.FUN-770012 -- end --
END FUNCTION
 
FUNCTION r512_bom1_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM r512_tmp
   IF STATUS THEN
      CREATE TEMP TABLE r512_tmp (
                                  partno LIKE type_file.chr1000)
      CREATE UNIQUE INDEX r512_tmp_i1 ON r512_tmp(partno)
   END IF
   INSERT INTO r512_tmp VALUES(tm.part1)
   IF STATUS THEN
#  CALL cl_err('ins(0) r512_tmp:',STATUS,1)
   CALL cl_err3("ins","r512_tmp","","",STATUS,"","ins(0) r512_tmp",1)      #No.FUN-660108
    END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part1
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL r512_bom1(0,tm.part1,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION r512_bom2_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM r512_tmp
   IF STATUS THEN
      CREATE TEMP TABLE r512_tmp (
                                  partno LIKE type_file.chr1000)
      CREATE UNIQUE INDEX r512_tmp_i1 ON r512_tmp(partno)
   END IF
   INSERT INTO r512_tmp VALUES(tm.part2)
   IF STATUS THEN CALL cl_err('ins(0) r512_tmp:',STATUS,1) END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part2
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL r512_bom2(0,tm.part2,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION r512_bom1(p_level,p_key,p_key2)       #FUN-550110
   DEFINE p_level	LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          p_key		LIKE bma_file.bma01,   #主件料件編號
          p_key2        LIKE ima_file.ima910,  #FUN-550110
          l_ac,i	LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          arrno		LIKE type_file.num5,   #NO.FUN-680101 SMALLINT	#BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bmb03 LIKE bmb_file.bmb03,       #元件料號
              bma01 LIKE bma_file.bma01        #NO.FUN-680101 VARCHAR(20)
          END RECORD,
         #l_sql		LIKE type_file.chr1000 #NO.FUN-680101 VARCHAR(1000)   #FUN-CB0072 mark
          l_sql         STRING                 #FUN-CB0072 add
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01",
               " FROM bmb_file, OUTER bma_file",
               " WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01",
               "   AND bmb29 ='",p_key2,"' "  #FUN-550110
    PREPARE r512_ppp FROM l_sql
    DECLARE r512_cur CURSOR FOR r512_ppp
    LET l_ac = 1
    FOREACH r512_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]='' 
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END-- 
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore r512_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb03 clipped
        CALL ui.Interface.refresh()
        INSERT INTO r512_tmp VALUES(sr[i].bmb03)
        IF sr[i].bma01 IS NOT NULL THEN
          #CALL r512_bom1(p_level,sr[i].bmb03,' ')  #FUN-550110#FUN-8B0035
           CALL r512_bom1(p_level,sr[i].bmb03,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
FUNCTION r512_bom2(p_level,p_key,p_key2)        #FUN-550110
   DEFINE p_level	LIKE type_file.num5,    #NO.FUN-680101
          p_key		LIKE bma_file.bma01, 	#元件料件編號
          p_key2        LIKE ima_file.ima910,   #FUN-550110
          l_ac,i	LIKE type_file.num5,    #NO.FUN-680101
          arrno		LIKE type_file.num5,    #NO.FUN-680101	#BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bmb01     LIKE bmb_file.bmb01,    #元件料號	#主件料號      #NO.FUN-680101
              bmb03     LIKE bmb_file.bmb03     #還有沒有       #NO.FUN-680101
          END RECORD,
         #l_sql		LIKE type_file.chr1000  #NO.FUN-680101  #FUN-CB0072 mark
          l_sql         STRING                  #FUN-CB0072 add
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #FUN-CB0072 add
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT a.bmb01, b.bmb03",
               " FROM bmb_file a, OUTER bmb_file b",
               " WHERE a.bmb03='", p_key,"' AND a.bmb01 = b.bmb03",
               "   AND a.bmb29 ='",p_key2,"' "  #FUN-550110
    PREPARE r512_ppp2 FROM l_sql
    DECLARE r512_cur2 CURSOR FOR r512_ppp2
    LET l_ac = 1
    FOREACH r512_cur2 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN--
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb01
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END-- 
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore r512_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb01 clipped
        INSERT INTO r512_tmp VALUES(sr[i].bmb01)
        IF sr[i].bmb03 IS NOT NULL THEN
          #CALL r512_bom2(p_level,sr[i].bmb01,' ')  #FUN-550110#FUN-8B0035
           CALL r512_bom2(p_level,sr[i].bmb01,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION

#FUN-CB0072--mark--str--- 
#REPORT amsg512_rep(mps, mpt, sr)
#  DEFINE l_last_sw     LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
#  DEFINE l_buf		LIKE mpt_file.mpt05          #NO.FUN-680101 VARCHAR(8)
#  DEFINE order1	LIKE mpt_file.mpt06          #NO.FUN-680101 VARCHAR(20)
#  DEFINE mps		RECORD LIKE mps_file.*
#  DEFINE mpt		RECORD LIKE mpt_file.*
#  DEFINE sr	RECORD
#         	order1	LIKE mpt_file.mpt06,         #NO.FUN-680101 VARCHAR(20)
#         	ima02	LIKE ima_file.ima02,
#         	ima08	LIKE ima_file.ima08,
#         	ima25	LIKE ima_file.ima25
#         	END RECORD
#  DEFINE qty,bal	LIKE mpt_file.mpt08          #NO.FUN-680101 DEC(15,3)
#  DEFINE i,j,k		LIKE type_file.num10         #NO.FUN-680101 INTEGER
# # DEFINE demand,supply	ARRAY[300] OF VARCHAR(70)   #No.MOD-580294 mark
##------------------------No.MOD-580294  add--------------------------------------
#  DEFINE demand        DYNAMIC ARRAY OF RECORD
#            mpt04    LIKE mpt_file.mpt04,
#            mpt05    LIKE mpt_file.mpt05,
#            mpt06    LIKE mpt_file.mpt06,
#            mpt07    LIKE mpt_file.mpt07,
#            mpt08    LIKE mpt_file.mpt08
#            END RECORD
#  DEFINE supply        DYNAMIC ARRAY OF RECORD
#              mpt04    LIKE mpt_file.mpt04,
#              mpt05    LIKE mpt_file.mpt05,
#              mpt06    LIKE mpt_file.mpt06,
#              mpt07    LIKE mpt_file.mpt07,
#              mpt08    LIKE mpt_file.mpt08
#              END RECORD
#
## DEFINE demand        DYNAMIC ARRAY OF RECORD
#
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY mps.mps01,mps.mps03,sr.order1,mpt.mpt04,mpt.mpt05
# FORMAT
#   PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[16] CLIPPED,tm.ver_no
#     PRINT COLUMN (g_len-7)/2,g_head1 CLIPPED
#
#     PRINT g_dash
#     PRINT g_x[50] CLIPPED,g_x[51] CLIPPED,g_x[52] CLIPPED,g_x[53] CLIPPED,
#           g_x[54] CLIPPED,g_x[55] CLIPPED,g_x[56] CLIPPED,g_x[57] CLIPPED,
#           g_x[58] CLIPPED,g_x[59] CLIPPED,g_x[60] CLIPPED,g_x[61] CLIPPED,
#           g_x[62] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw = 'n'
##------end
#
##-----No.MOD-580294 mark
## FORMAT
##  PAGE HEADER
#
##     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
##     IF cl_null(g_towhom)
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN (g_len-7)/2,g_x[16] CLIPPED,tm.ver_no,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##     PRINT g_dash2[1,g_len] CLIPPED
##     PRINT g_x[11],
##           COLUMN 41,g_x[12],
##           COLUMN 81,g_x[13],
##           COLUMN 121,g_x[14],
##           COLUMN 161,g_x[15] CLIPPED
##     PRINT g_x[38],
##           COLUMN 41,g_x[39],
##           COLUMN 81,g_x[40],
##           COLUMN 121,g_x[41],
##           COLUMN 161,g_x[42] CLIPPED
##     LET l_last_sw = 'n'
##-----end
# 
##----No.MOD-580294 modify
#   BEFORE GROUP OF mps.mps01
#     PRINT COLUMN g_c[50],g_x[17] CLIPPED,
#           COLUMN g_c[51],mps.mps01,
#           COLUMN g_c[52],g_x[18] CLIPPED,
#           COLUMN g_c[53],sr.ima02,
#           COLUMN g_c[54],g_x[19] CLIPPED,
#           COLUMN g_c[55],sr.ima25
#     PRINT
#     LET bal=0
##---end
# 
##----No.MOD-580294 modify
#    BEFORE GROUP OF mps.mps03
#       PRINT COLUMN g_c[50],mps.mps00 USING '###&', #FUN-590118
#             COLUMN g_c[51],mps.mps03 USING 'mm/dd';
##---end
#
#  BEFORE GROUP OF sr.order1
#     #FOR i=1 TO 100 LET demand[i]=' ' LET supply[i]=' ' END FOR   #No.MOD-580294 mark
#     LET i=0 LET j=0
#     CALL demand.clear()  #No.MOD-580294 add
#     CALL supply.clear()  #No.MOD-580294 add
#
##----No.MOD-580294 add
#ON EVERY ROW
#   IF (mpt.mpt05 = '53' AND mpt.mpt08 < 0) OR
#      (mpt.mpt05 = '71' AND mpt.mpt08 < 0)
#      THEN LET qty=mpt.mpt08*-1
#      ELSE LET qty=mpt.mpt08
#   END IF
#   IF (mpt.mpt05 MATCHES '4*') OR (mpt.mpt05 = '53' AND mpt.mpt08 < 0) OR
#      (mpt.mpt05 = '71' AND mpt.mpt08 < 0) THEN
#      LET i=i+1
#      LET l_buf=s_mpt05(mpt.mpt05)
#      LET demand[i].mpt04=mpt.mpt04
#      LET demand[i].mpt05=mpt.mpt05,' ',l_buf
##      LET demand[i].mpt06=mpt.mpt06[1,10],' ',mpt.mpt061 USING '###'       #TQC-AB0408  mark
#      LET demand[i].mpt06=mpt.mpt06[1,20],' ',mpt.mpt061 USING '###'       #TQC-AB0408
#      LET demand[i].mpt07=mpt.mpt07
#      LET demand[i].mpt08=mpt.mpt08
#   ELSE
#      LET j=j+1
#      LET l_buf=s_mpt05(mpt.mpt05)
#      LET supply[j].mpt04=mpt.mpt04
#      LET supply[j].mpt05=mpt.mpt05,' ',l_buf
##      LET supply[j].mpt06=mpt.mpt06[1,10],' ',mpt.mpt061 USING '###'       #TQC-AB0408  mark
#      LET supply[j].mpt06=mpt.mpt06[1,20],' ',mpt.mpt061 USING '###'       #TQC-AB0408 
#      LET supply[j].mpt07=mpt.mpt07
#      LET supply[j].mpt08=mpt.mpt08
#   END IF
#   IF mpt.mpt05 MATCHES '4*'
#      THEN LET bal=bal-mpt.mpt08
#      ELSE LET bal=bal+mpt.mpt08
#   END IF
##-----end
#
##-------No.MOD-580294 mark
##  ON EVERY ROW
##     IF (mpt.mpt05 = '53' AND mpt.mpt08 < 0) OR
##        (mpt.mpt05 = '71' AND mpt.mpt08 < 0)
##        THEN LET qty=mpt.mpt08*-1
##        ELSE LET qty=mpt.mpt08
##     END IF
##     LET l_buf=s_mpt05(mpt.mpt05)
##No.FUN-550056 --start--
##     LET g_msg=mpt.mpt04,'  ',mpt.mpt05,' ',l_buf,'  ',
##               mpt.mpt06[1,10], mpt.mpt061 USING '###',
##               ' ',mpt.mpt07,
##               qty USING '----,---,---'
##     LET g_msg=mpt.mpt04,'  ',mpt.mpt05,' ',l_buf,'  ',
##               mpt.mpt06, mpt.mpt061 USING '###',
##               ' ',mpt.mpt07,
##               qty USING '----,---,---'
##No.FUN-550056 ---end---
##
##     LET g_msg=mpt.mpt04,'  ',mpt.mpt05,' ',l_buf,'  ',
##               mpt.mpt06[1,10], mpt.mpt061 USING '###',
##               ' ',mpt.mpt07,
##               qty USING '----,---,---'
##     LET g_msg1= mpt.mpt04,'  ',mpt.mpt05,' ',l_buf,' ',
##                mpt.mpt06[1,10],' ', mpt.mpt061 USING '###',
##                ' ',mpt.mpt07 ,
##               qty USING '----,---,---'
##
##     IF (mpt.mpt05 MATCHES '4*') OR
##        (mpt.mpt05 = '53' AND mpt.mpt08 < 0) OR
##        (mpt.mpt05 = '71' AND mpt.mpt08 < 0)
##        THEN LET i=i+1 LET demand[i]=g_msg
##        ELSE LET j=j+1 LET supply[j]=g_msg  #MOD-580209 g_msg1 -> g_msg
##      END IF
##     IF mpt.mpt05 MATCHES '4*'
##        THEN LET bal=bal-mpt.mpt08
##        ELSE LET bal=bal+mpt.mpt08
##     END IF
##------end
#
##----No.MOD-580294 add
#  AFTER GROUP OF sr.order1
#     IF i>j THEN LET k=i ELSE LET k=j END IF
#     FOR i=1 TO k
#         PRINT COLUMN g_c[52],demand[i].mpt04 CLIPPED,
#               COLUMN g_c[53],demand[i].mpt05 CLIPPED,
#               COLUMN g_c[54],demand[i].mpt06 CLIPPED,
#               COLUMN g_c[55],demand[i].mpt07 CLIPPED,
#               COLUMN g_c[56],cl_numfor(demand[i].mpt08,56,0),
#               COLUMN g_c[57],supply[i].mpt04 CLIPPED,
#               COLUMN g_c[58],supply[i].mpt05 CLIPPED,
#               COLUMN g_c[59],supply[i].mpt06 CLIPPED,
#               COLUMN g_c[60],supply[i].mpt07 CLIPPED,
#               COLUMN g_c[61],cl_numfor(supply[i].mpt08,61,0);
#          IF i=k THEN
#             PRINT COLUMN g_c[62],cl_numfor(bal,62,0)
#          ELSE
#             PRINT ''
#          END IF
#       END FOR
##-----end
#
##----No.MOD-580294 mark
##  AFTER GROUP OF sr.order1
##     IF i>j THEN LET k=i ELSE LET k=j END IF
##     FOR i=1 TO k
##        #PRINT COLUMN 13, demand[i],COLUMN 84,supply[i] CLIPPED;
##       IF i=k
##          THEN PRINT COLUMN 153,cl_numfor(bal,15,0)
##          THEN PRINT COLUMN 168,cl_numfor(bal,15,0)  #No.FUN-550056
##    LET g_len = 184
##    LET g_len = 184
##          ELSE PRINT ''
##       END IF
##     END FOR
##-----end
#
#  AFTER GROUP OF mps.mps03
#     PRINT
#  AFTER GROUP OF mps.mps01
#     PRINT g_dash2 CLIPPED
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash CLIPPED    #No.TQC-750041
#     PRINT g_x[04],COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-6A0080
#
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash CLIPPED
#             PRINT g_x[04],COLUMN (g_len-9),g_x[6] CLIPPED #NO.TQC-6A0080
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#FUN-CB0072--mark--end---
 
FUNCTION s_mpt05(p1)
   DEFINE p1 STRING       #NO.FUN-680101 VARCHAR(2)
   DEFINE p2 STRING       #NO.FUN-680101 VARCHAR(10)
        CASE WHEN p1='40' LET p2=g_x[21]
             WHEN p1='41' LET p2=g_x[22]
             WHEN p1='42' LET p2=g_x[23]
             WHEN p1='43' LET p2=g_x[24]
             WHEN p1='44' LET p2=g_x[25]
             WHEN p1='45' LET p2=g_x[26]
             WHEN p1='51' LET p2=g_x[27]
             WHEN p1='52' LET p2=g_x[28]
             WHEN p1='53' LET p2=g_x[29]
             WHEN p1='61' LET p2=g_x[30]
             WHEN p1='62' LET p2=g_x[31]
             WHEN p1='63' LET p2=g_x[32]
             WHEN p1='64' LET p2=g_x[33]
             WHEN p1='65' LET p2=g_x[34]
             WHEN p1='71' LET p2=g_x[35]
             WHEN p1=' P' LET p2=g_x[36]
             WHEN p1=' M' LET p2=g_x[37]
        END CASE
   RETURN p2
END FUNCTION
#Patch....NO.TQC-610036 <001> #

###GENGRE###START
FUNCTION amsg512_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t                 #FUN-CB0072 add
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

   #LET l_cnt = cl_gre_rowcnt(l_table)    #FUN-CB0072 mark
    LET l_cnt = cl_gre_rowcnt(l_table1)   #FUN-CB0072 add
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amsg512")
        IF handler IS NOT NULL THEN
            START REPORT amsg512_rep TO XML HANDLER handler
           #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #FUN-CB0072 mark
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED     #FUN-CB0072 add
                       ," ORDER BY mps01,mps03,order1,mpt04,mpt05 "               #FUN-CB0072 add           

            DECLARE amsg512_datacur1 CURSOR FROM l_sql
            FOREACH amsg512_datacur1 INTO sr2.*             #FUN-CB0072 sr1->sr2
                OUTPUT TO REPORT amsg512_rep(sr2.*)         #FUN-CB0072 sr1->sr2
            END FOREACH
            FINISH REPORT amsg512_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amsg512_rep(sr2)             #FUN-CB0072 sr1->sr2
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr2_o sr2_t              #FUN-CB0072 add
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_mps00  LIKE mps_file.mps00    #FUN-CB0072 add
    DEFINE l_mps03  LIKE mps_file.mps03    #FUN-CB0072 add
    DEFINE l_d_mpt08_fmt STRING            #FUN-CB0072 add
    DEFINE l_s_mpt08_fmt STRING            #FUN-CB0072 add
    DEFINE l_bal_fmt     STRING            #FUN-CB0072 add
    
   #ORDER EXTERNAL BY sr1.mps01,sr1.mps03,sr1.order1,sr1.mpt04,sr1.mpt05        #FUN-CB0072 mark
    ORDER EXTERNAL BY sr2.mps01,sr2.mps03,sr2.order1        #FUN-CB0072 add
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
            LET sr2_o.mps00 = NULL          #FUN-CB0072 add 
            LET sr2_o.mps03 = NULL          #FUN-CB0072 add
              
       #BEFORE GROUP OF sr1.mps01           #FUN-CB0072 mark
       #BEFORE GROUP OF sr1.mps03           #FUN-CB0072 mark
       #BEFORE GROUP OF sr1.order1          #FUN-CB0072 mark
        BEFORE GROUP OF sr2.mps01           #FUN-CB0072 add
        BEFORE GROUP OF sr2.mps03           #FUN-CB0072 add
        BEFORE GROUP OF sr2.order1          #FUN-CB0072 add

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

           #FUN-CB0072--add--str---
            IF NOT cl_null(sr2_o.mps00) THEN
               IF sr2_o.mps00 = sr2.mps00 THEN
                  LET l_mps00 = ' '
               ELSE
                  LET l_mps00 = sr2.mps00
               END IF
            ELSE
               LET l_mps00 = sr2.mps00
            END IF
            IF NOT cl_null(sr2_o.mps03) THEN
               IF sr2_o.mps03 = sr2.mps03 THEN
                  LET l_mps03 = ' '
               ELSE
                  LET l_mps03 = sr2.mps03
               END IF
            ELSE
               LET l_mps03 = sr2.mps03
            END IF

            PRINTX l_mps00
            PRINTX l_mps03

            LET l_d_mpt08_fmt = cl_gr_numfmt('mpt_file','mpt08',sr2.num1)
            PRINTX l_d_mpt08_fmt
            LET l_s_mpt08_fmt = cl_gr_numfmt('mpt_file','mpt08',sr2.num1)
            PRINTX l_s_mpt08_fmt
            LET l_bal_fmt = cl_gr_numfmt('mpt_file','mpt08',sr2.num1)
            PRINTX l_bal_fmt
           #FUN-CB0072--add--end---

            LET sr2_o.* = sr2.*             #FUN-CB0072 add
            PRINTX sr2.*

       #AFTER GROUP OF sr1.mps01            #FUN-CB0072 mark
       #AFTER GROUP OF sr1.mps03            #FUN-CB0072 mark
       #AFTER GROUP OF sr1.order1           #FUN-CB0072 mark
        AFTER GROUP OF sr2.mps01            #FUN-CB0072 add
        AFTER GROUP OF sr2.mps03            #FUN-CB0072 add
        AFTER GROUP OF sr2.order1           #FUN-CB0072 add
        
        ON LAST ROW

END REPORT
###GENGRE###END
