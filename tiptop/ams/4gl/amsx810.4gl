# Prog. Version..: '5.30.07-13.05.30(00005)'     #
#
# Pattern name...: amsx810.4gl
# Descriptions...: MPS Inventory projection report
# Input parameter:
# Return code....:
# Date & Author..: 98/06/29 By Eric
# Modify.........: No.FUN-510036 05/03/02 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-580014 05/08/18 By jackie 轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl   修改報表格式
# Modify.........: NO.FUN-740078 07/05/04 By TSD.c123k 改為crystal report
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-B60093 11/06/30 By Vampire 增加條件選項 成本計算類別
# Modify.........: No.FUN-CB0003 12/11/12 By chenjing CR轉XtraGrid
# Modify.........: No.FUN-D40020 13/01/30 By chenjing 打印增加主分群碼和說明
# Modify.........: No.FUN-D30053 13/03/18 By chenying XtraGrid报表修改
# Modify.........: No.FUN-D40129 13/05/16 By yangtt 調整報表排序         

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(600)    # Where condition
              ver_no  LIKE rqa_file.rqa02,   #NO.FUN-680101 VARCHAR(2)
              yy      LIKE ccc_file.ccc02,   #NO.FUN-680101 SMALLINT
              mm      LIKE ccc_file.ccc03,   #NO.FUN-680101 SMALLINT
              order   LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
              more    LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)      # Input more condition(Y/N)
              type    LIKE type_file.chr1    #CHI-B60093 add
              END RECORD,
          g_date0   LIKE type_file.dat,      #NO.FUN-680101 DATE
          g_date1   LIKE type_file.dat,      #NO.FUN-680101 DATE
          g_date2   LIKE type_file.dat,      #NO.FUN-680101 DATE
          g_date3   LIKE type_file.dat,      #NO.FUN-680101 DATE
          g_date4   LIKE type_file.dat,      #NO.FUN-680101 DATE
          g_date5   LIKE type_file.dat       #NO.FUN-680101 DATE
   DEFINE st  RECORD
              qty0   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              amt0   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              qty1   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              amt1   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              qty2   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              amt2   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              qty3   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3) 
              amt3   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              qty4   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              amt4   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              qty5   LIKE ccc_file.ccc23,    #NO.FUN-680101 DEC(12,3)
              amt5   LIKE ccc_file.ccc23     #NO.FUN-680101 DEC(12,3)
              END RECORD
 
DEFINE   g_i        LIKE type_file.num5     #NO.FUN-680101 SMALLINT   #count/index for any purpose
DEFINE   l_table    STRING                  # FUN-740078
DEFINE   g_sql      STRING                  # FUN-740078
DEFINE   g_str      STRING                  # FUN-740078
 
 
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
 
#FUN-740078 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740078 *** ##
   LET g_sql = "g_date0.type_file.dat,",
               "g_date1.type_file.dat,",
               "g_date2.type_file.dat,",
               "g_date3.type_file.dat,",
               "g_date4.type_file.dat,",
               "g_date5.type_file.dat,",
               "order1.ima_file.ima23,",
               "ima01.ima_file.ima01,",
               "ima08.ima_file.ima08,",
               "ima25.ima_file.ima25,",
               "qty0.ccc_file.ccc23,",   
               "qty1.ccc_file.ccc23,",    
               "qty2.ccc_file.ccc23,",  
               "qty3.ccc_file.ccc23,", 
               "qty4.ccc_file.ccc23,",  
               "qty5.ccc_file.ccc23,",  
               "amt0.ccc_file.ccc23,",  
               "amt1.ccc_file.ccc23,",  
               "amt2.ccc_file.ccc23,",  
               "amt3.ccc_file.ccc23,",  
               "amt4.ccc_file.ccc23,",  
               "amt5.ccc_file.ccc23,",   
          #FUN-CB0003--add--str--
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima06.ima_file.ima06,",     #FUN-D40020
               "imz02.imz_file.imz02,",     #FUN-D40020
               "l_ima08.type_file.chr1000,", #FUN-D40020
               "gen02.gen_file.gen02"
          #FUN-CB0003--add--end--
 
   LET l_table = cl_prt_temptable('amsx810',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?, ?,?,?,?,?,?)"      #FUN-CB0003 add 3? #FUN-D40020 add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
#FUN-740078 - END
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610075-begin
   LET tm.ver_no = ARG_VAL(8)
   LET tm.yy = ARG_VAL(9)
   LET tm.mm = ARG_VAL(10)
   LET tm.order = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610075-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsx810_tm(0,0)        # Input print condition
      ELSE CALL amsx810()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsx810_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01    #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,   #NO.FUN-680101 SMALLINT
          l_msr RECORD LIKE msr_file.*,
          l_cmd          LIKE type_file.chr1000 #NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 13
   END IF
   OPEN WINDOW amsx810_w AT p_row,p_col
        WITH FORM "ams/42f/amsx810"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.order = '1'
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'    #CHI-B60093 add
   LET tm.type = g_ccz.ccz28                                      #CHI-B60093 add
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)
   IF tm.mm = 1 THEN
      LET tm.yy=tm.yy - 1
      LET tm.mm=12
   ELSE
       LET tm.mm=tm.mm - 1
   END IF
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima06,ima08,ima67,ima43,ima23
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(mps01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO mps01
               NEXT FIELD mps01
            END IF
#FUN-CB0003--add--str--
            IF INFIELD(ima67) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima67"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima67
               NEXT FIELD ima67
            END IF
            IF INFIELD(ima43) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima43"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima43
               NEXT FIELD ima43
            END IF
            IF INFIELD(ima23) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_im23_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima23
               NEXT FIELD ima23
            END IF
            IF INFIELD(ima06) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imz"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima06
               NEXT FIELD ima06
            END IF

            IF INFIELD(ima08) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima7"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima08
               NEXT FIELD ima08
            END IF
#FUN-CB0003--add--end--
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
      LET INT_FLAG = 0 CLOSE WINDOW amsx810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.yy,tm.mm,tm.order,tm.more,tm.type      #CHI-B60093 add tm.type
    WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
         SELECT * INTO l_msr.* FROM msr_file WHERE msr_v=tm.ver_no
         IF STATUS <> 0 THEN
            ERROR 'MRP Version not found!'
            LET tm.ver_no=' '
            NEXT FIELD ver_no
         END IF
 
        AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD yy
            END IF
 
        AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD mm
            END IF
            IF tm.mm < 1 OR tm.mm > 12 THEN
               LET tm.mm=MONTH(g_today)
               NEXT FIELD mm
            END IF
 
      AFTER FIELD order
         IF cl_null(tm.order) THEN NEXT FIELD order END IF
         IF tm.order NOT MATCHES '[12345]' THEN
            LET tm.order='1'
            NEXT FIELD order
         END IF

      #CHI-B60093 --- modify --- start ---
      AFTER FIELD type 
         IF cl_null(tm.type) THEN NEXT FIELD type END IF
         IF tm.type NOT MATCHES '[12345]' THEN
            LET tm.type = g_ccz.ccz28
            NEXT FIELD type
         END IF
      #CHI-B60093 --- modify ---  end  ---
     
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      LET INT_FLAG = 0 CLOSE WINDOW amsx810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsx810'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsx810','9031',1)
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
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.order CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.type CLIPPED ,"'"              #CHI-B60093
         CALL cl_cmdat('amsx810',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsx810_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsx810()
   ERROR ""
END WHILE
   CLOSE WINDOW amsx810_w
END FUNCTION
 
FUNCTION amsx810()
   DEFINE l_name    LIKE type_file.chr20,   #NO.FUN-680101 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(1000)  # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
          l_n       LIKE type_file.num5,    #NO.FUN-680101 SMALLINT
          l_za05    LIKE type_file.num5,    #NO.FUN-680101 VARCHAR(40)
          l_supply,l_demand  LIKE ccc_file.ccc23,  #NO.FUN-680101 DEC(12,3)
          l_mps01 LIKE mps_file.mps01,
          sr  RECORD
              order  LIKE ima_file.ima23,
              ima01  LIKE ima_file.ima01,
              ima02  LIKE ima_file.ima02,
              ima06  LIKE ima_file.ima06,
              ima08  LIKE ima_file.ima08,
              ima23  LIKE ima_file.ima23,
              ima25  LIKE ima_file.ima25,
              ima43  LIKE ima_file.ima43,
              ima67  LIKE ima_file.ima67,
              qty0   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              amt0   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              qty1   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              amt1   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              qty2   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              amt2   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              qty3   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              amt3   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              qty4   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              amt4   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              qty5   LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
              amt5   LIKE ccc_file.ccc23    #NO.FUN-680101 DEC(12,3)
              END RECORD
 
     DEFINE l_ima021 LIKE ima_file.ima021  #FUN-CB0003
     DEFINE l_date0  LIKE type_file.chr20  #FUN-CB0003
     DEFINE l_date1  LIKE type_file.chr20  #FUN-CB0003
     DEFINE l_date2  LIKE type_file.chr20  #FUN-CB0003
     DEFINE l_date3  LIKE type_file.chr20  #FUN-CB0003
     DEFINE l_date4  LIKE type_file.chr20  #FUN-CB0003
     DEFINE l_date5  LIKE type_file.chr20  #FUN-CB0003
     DEFINE l_gen02  LIKE gen_file.gen02   #FUN-CB0003
     DEFINE l_ima06  LIKE ima_file.ima06   #FUN-D40020
     DEFINE l_imz02  LIKE imz_file.imz02   #FUN-D40020
     DEFINE l_ima08  LIKE type_file.chr1000   #FUN-D40020
     DEFINE l_str    LIKE type_file.chr1000   #FUN-D40020
#FUN-740078 - add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740078 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
#FUN-740078 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET st.qty0=0
     LET st.amt0=0
     LET st.qty1=0
     LET st.amt1=0
     LET st.qty2=0
     LET st.amt2=0
     LET st.qty3=0
     LET st.amt3=0
     LET st.qty4=0
     LET st.amt4=0
     LET st.qty5=0
     LET st.amt5=0
     LET l_sql = "SELECT UNIQUE mps01",
                 "  FROM mps_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mps01=ima01 ",
                 "   AND mps_v='",tm.ver_no,"'"
 
     #CALL cl_outnam('amsx810') RETURNING l_name  #FUN-740078 TSD.c123k mark
     #START REPORT amsx810_rep TO l_name          #FUN-740078 TSD.c123k mark
     LET g_pageno = 0
     IF MONTH(g_today) = 12 THEN
        LET g_date0=MDY(12,31,YEAR(g_today))
     ELSE
        LET g_date0=MDY(MONTH(g_today)+1,1,YEAR(g_today))-1
     END IF
     LET g_date1=x810_nextmonth(g_date0)
     LET g_date2=x810_nextmonth(g_date1)
     LET g_date3=x810_nextmonth(g_date2)
     LET g_date4=x810_nextmonth(g_date3)
     LET g_date5=x810_nextmonth(g_date4)
     PREPARE amsx810_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amsx810_curs1 CURSOR FOR amsx810_prepare1
     FOREACH amsx810_curs1 INTO sr.ima01
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) EXIT FOREACH END IF
       CALL x810_bal(sr.ima01,g_date0) RETURNING sr.qty0,sr.amt0
       CALL x810_bal(sr.ima01,g_date1) RETURNING sr.qty1,sr.amt1
       CALL x810_bal(sr.ima01,g_date2) RETURNING sr.qty2,sr.amt2
       CALL x810_bal(sr.ima01,g_date3) RETURNING sr.qty3,sr.amt3
       CALL x810_bal(sr.ima01,g_date4) RETURNING sr.qty4,sr.amt4
       CALL x810_bal(sr.ima01,g_date5) RETURNING sr.qty5,sr.amt5
       IF sr.qty0=0 AND sr.qty1=0 AND sr.qty2=0 AND sr.qty3=0 AND
          sr.qty4=0 AND sr.qty5=0 THEN
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima06,ima08,ima23,ima25,ima43,ima67,ima021    #FUN-CB0003 add ima021
         INTO sr.ima01,sr.ima02,sr.ima06,sr.ima08,sr.ima23,sr.ima25,sr.ima43,sr.ima67,l_ima021   #FUN-CB0003 add ima021
         FROM ima_file WHERE ima01=sr.ima01
       IF STATUS <> 0 THEN CONTINUE FOREACH END IF
       CASE WHEN tm.order = '1'
                 LET sr.order=sr.ima23
            WHEN tm.order = '2'
                 LET sr.order=sr.ima67
            WHEN tm.order = '3'
                 LET sr.order=sr.ima43
            WHEN tm.order = '4'
                 LET sr.order=sr.ima06
            WHEN tm.order = '5'           #FUN-D40129  add
                 LET sr.order=sr.ima01    #FUN-D40129  add
            OTHERWISE
                 LET sr.order=' '
       END CASE
       #OUTPUT TO REPORT amsx810_rep(sr.*) #FUN-740078 TSD.c123k mark
      #FUN-CB0003--add--str--
      #IF sr.order=' ' THEN         #FUN-D40129 mark
       IF cl_null(sr.order) THEN    #FUN-D40129 add
          LET l_gen02 = ' '
       ELSE
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.order
       END IF
      #FUN-CB0003--add--end--
      #FUN-D40020--add--str--
       SELECT imz02 INTO l_imz02 FROM imz_file WHERE imz01 = sr.ima06
       LET l_str = cl_gr_getmsg("gre-339",g_lang,sr.ima08)
       LET l_ima08 = sr.ima08, ":", l_str
      #FUN-D40020--add--end--
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740078 *** #
       EXECUTE insert_prep USING
            g_date0,  g_date1,  g_date2,  g_date3,  g_date4,  g_date5,
            sr.order, sr.ima01, sr.ima08, sr.ima25, sr.qty0,  sr.qty1,
            sr.qty2,  sr.qty3,  sr.qty4,  sr.qty5,  sr.amt0,  sr.amt1, 
            sr.amt2,  sr.amt3,  sr.amt4,  sr.amt5,sr.ima02,l_ima021,
            sr.ima06,l_imz02,l_ima08,l_gen02    #FUN-CB0003 add sr.ima02,l_ima021,l_gen02  #FUN-D40020 add sr.ima06,l_imz02,l_ima08
       #------------------------------ CR (3) -------------------------------
 
     END FOREACH
 
     #FINISH REPORT amsx810_rep   #FUN-740078 TSD.c123k mark
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len) #FUN-740078 TSD.c123k mark
 
     # FUN-740078 START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'mps01,ima06,ima08,ima67,ima43,ima23')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###XtraGrid###     LET g_str = g_str,";",tm.order
 
###XtraGrid###     CALL cl_prt_cs3('amsx810','amsx810',l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003---add--str--
    LET l_date0 = g_date0 USING 'yyyy/mm'   
    LET l_date1 = g_date1 USING 'yyyy/mm'   
    LET l_date2 = g_date2 USING 'yyyy/mm'   
    LET l_date3 = g_date3 USING 'yyyy/mm'   
    LET l_date4 = g_date4 USING 'yyyy/mm'   
    LET l_date5 = g_date5 USING 'yyyy/mm'   
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'qty0',l_date0,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'amt0',l_date0,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'qty1',l_date1,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'amt1',l_date1,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'qty2',l_date2,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'amt2',l_date2,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'qty3',l_date3,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'amt3',l_date3,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'qty4',l_date4,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'amt4',l_date4,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'qty5',l_date5,'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'amt5',l_date5,'')
   #FUN-D40129---add---str--
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'order1',cl_gr_getmsg('gre-365',g_lang,tm.order),'')
    CASE tm.order 
       WHEN '4'
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"ima06","Y")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"imz02","Y")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"order1","N")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"gen02","N")
       WHEN '5'
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"ima01","N")
          LET g_xgrid.visible_column = cl_xg_column_visible(g_xgrid.visible_column,"gen02","N")
    END CASE
   #FUN-D40129---add---end--
   #FUN-D30053--mod--str---
   #LET g_xgrid.order_field = cl_get_order_field(tm.order,"mps01,ima67,ima43,ima23,ima08")
   #LET g_xgrid.grup_field = cl_get_order_field(tm.order,"mps01,ima67,ima43,ima23,ima08")
   #LET g_xgrid.order_field = cl_get_order_field(tm.order,"ima23,ima67,ima43,ima06,mps01") #FUN-D40129 mark
   #LET g_xgrid.grup_field = cl_get_order_field(tm.order,"ima23,ima67,ima43,ima06,mps01")  #FUN-D40129 mark
    LET g_xgrid.order_field = 'order1'    #FUN-D40129  
   #FUN-D30053--mod--end---
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
#FUN-CB0003---add--end--
    CALL cl_xg_view()    ###XtraGrid###
     #------------------------------ CR (4) ------------------------------#
     # FUN-740078 end
 
END FUNCTION
 
FUNCTION x810_bal(l_partno,l_date)
    DEFINE l_partno LIKE ima_file.ima01,
           l_date   LIKE type_file.dat,    #NO.FUN-680101 DATE
           l_qty    LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
           l_amt    LIKE ccc_file.ccc23,   #NO.FUN-680101 DEC(12,3)
           l_ccc23   LIKE ccc_file.ccc23
 
    DECLARE mps_cur CURSOR FOR
     SELECT mps08,mps03 FROM mps_file
      WHERE mps_v=tm.ver_no AND mps01=l_partno AND mps03 <= l_date
      ORDER BY mps03 DESC
    OPEN mps_cur
    FETCH mps_cur INTO l_qty
    IF STATUS <> 0 THEN LET l_qty=0 END IF
    CLOSE mps_cur
    IF l_qty < 0 THEN LET l_qty=0 END IF
#   SELECT ccc23 INTO l_ccc23 FROM ccc_file      #CHI-B60093 mark
    SELECT AVG(ccc23) INTO l_ccc23 FROM ccc_file #CHI-B60093 add
     WHERE ccc01=l_partno AND ccc02=tm.yy AND ccc03=tm.mm
#      AND ccc07='1'                             #No.FUN-840041   #CHI-B60093 mark
       AND ccc07 = tm.type                       #CHI-B60093 add
     GROUP BY ccc01
    IF STATUS <> 0 THEN LET l_ccc23=0 END IF
    IF l_ccc23 IS NULL THEN LET l_ccc23=0 END IF
    LET l_amt=l_qty*l_ccc23
    RETURN l_qty,l_amt
END FUNCTION
 
FUNCTION x810_nextmonth(l_date)
    DEFINE l_date    LIKE type_file.dat,     #NO.FUN-680101 DATE 
           r_date    LIKE type_file.dat,     #NO.FUN-680101 DATE
           l_yy,l_mm LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
    LET l_yy=YEAR(l_date) USING '&&&&'
    LET l_mm=MONTH(l_date)
    IF l_mm = 12 THEN
       LET l_yy=l_yy+1
       LET l_mm=1
    ELSE
       LET l_mm=l_mm+1
    END IF
    IF l_mm = 12 THEN
       LET l_yy=l_yy+1
       LET l_mm=1
    ELSE
       LET l_mm=l_mm+1
    END IF
    LET r_date=MDY(l_mm,1,l_yy)-1
    RETURN r_date
END FUNCTION


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
