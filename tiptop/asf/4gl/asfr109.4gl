# Prog. Version..: '5.30.06-13.03.25(00009)'     #
#
# Pattern name...: asfr109.4gl
# Descriptions...: 待發放工單列印
# Date & Author..: 91/08/25 By Keith
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-580014 05/08/17 BY Nigel 改用新報表格式
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-710016 07/01/08 By ray 打印時開始日期-截止日期的位置置中
# Modify.........: No.FUN-750093 07/06/25 By arman   報表改為使用crystal report 
# Modify.........: No.FUN-750093 07/07/18 By arman   增加打印條件 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B50251 11/05/31 By Vampire 列印時，將作廢工單排除
# Modify.........: No:TQC-B80149 11/08/19 By houlia cast 語法調整 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-D30169 13/03/20 By bart 若工單沒有勾選製程，報表應該不能顯示製程編號為空白，製程追蹤檔尚未產生
# Modify.........: No.TQC-D50013 13/07/17 By yangtt “工單單號”，“生產料件”，“備注制造部門”欄位改成開窗
#                                                  增加料件名稱，規格，部門名稱

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#             wc      VARCHAR(600),       # 工單形態、單號、生產料件範圍 #TQC-630166
              wc      STRING,          # 工單形態、單號、生產料件範圍 #TQC-630166
                                       # WHERE CONDITION
              s_date   LIKE type_file.dat,           #No.FUN-680121 DATE# 發放起始日期
              d_date   LIKE type_file.dat,           #No.FUN-680121 DATE# 發放截止日期
              more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件(Y|N)
              END RECORD,
              g_sfb01_t  LIKE sfb_file.sfb01,
              g_p        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              g_num      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              g_tot_bal  LIKE ccq_file.ccq03           #No.FUN-680121 DECIMAL(13,2)# User defined variable
# No.FUN-580014 --start--
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
# No.FUN-580014 --end--
DEFINE    g_str          STRING       #NO.FUN-750093
DEFINE    l_table        STRING       #NO.FUN-750093
DEFINE    g_sql          STRING       #NO.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
   
   #NO.FUN-750093    ----------begin------------
   LET g_sql = " s_date.type_file.dat,",
               " d_date.type_file.dat,",
               " a.type_file.chr1,",
               " sfb01.sfb_file.sfb01,",
               " sfb05.sfb_file.sfb05,",
               " ima02.ima_file.ima02,",     #TQC-D50013 add
               " ima021.ima_file.ima021,",   #TQC-D50013 add
               " sfb02.sfb_file.sfb02,",
               " sfb13.sfb_file.sfb13,",
               " sfb40.sfb_file.sfb40,",
               " sfb08.sfb_file.sfb08,",
               " ima55.ima_file.ima55,",
               " sfb15.sfb_file.sfb15,",
               " sfb34.sfb_file.sfb34,",
               " sfb251.sfb_file.sfb251,",
               " sfb071.sfb_file.sfb071,",
               " sfb06.sfb_file.sfb06,",
               " sfb23.sfb_file.sfb23,",
               " sfb24.sfb_file.sfb24,",
               " sfb42.sfb_file.sfb42,",
               " sfb82.sfb_file.sfb82,",
               " gem02.gem_file.gem02,",     #TQC-D50013 add
               " ima01.ima_file.ima01,",
               " sta1.ala_file.ala32,",
               " sta2.ala_file.ala32,",
               " sta3.ala_file.ala32,",
               " sta4.ala_file.ala32,",
               " sta5.ala_file.ala32,",
               " sta6.ala_file.ala32,",
               " sta7.ala_file.ala32"
   LET l_table = cl_prt_temptable('asfr109',g_sql)  CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?, ?,?,?,?,?)"  #TQC-D50013  add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
          CALL  cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #NO.FUN-750093    --------  end --------------
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
 
   LET tm.wc = ARG_VAL(7)
   #TQC-610080-begin
   #LET tm.more  = ARG_VAL(8)
   LET tm.s_date  = ARG_VAL(8)
   LET tm.d_date  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610080-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL asfr109_tm()        # Input print condition
   ELSE
      CALL asfr109()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr109_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sta          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW asfr109_w AT p_row,p_col WITH FORM "asf/42f/asfr109"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s_date  = g_today
   LET tm.d_date = g_today
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfb02,sfb01,sfb05,sfb82

       #TQC-D50013--add--str--
       ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfb01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_sfb01_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb01
              NEXT FIELD sfb01
            WHEN INFIELD(sfb05)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_sfb050"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
            WHEN INFIELD(sfb82)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_sfb821"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb82
              NEXT FIELD sfb82
         END CASE
      #TQC-D50013--add--end--

       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
        ON ACTION CONTROLG                #NO.750093
            CALL cl_cmdask()              #NO.750093
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm.more,tm.d_date      # Condition
     INPUT BY NAME tm.s_date, tm.d_date, tm.more WITHOUT DEFAULTS
        AFTER FIELD s_date
           IF tm.s_date IS NULL THEN                    #輸入起始日期
              NEXT FIELD s_date
           END IF
        AFTER FIELD d_date
           IF tm.d_date IS NULL THEN                    #輸入截止日期
              NEXT FIELD d_date
           END IF
           IF tm.d_date < tm.s_date THEN        #截止日期不可小於起始日期
          	    CALL cl_getmsg('mfg5067',g_lang)  RETURNING l_sta
              ERROR l_sta
              NEXT FIELD s_date
           END IF
        AFTER FIELD more
           IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
              NEXT FIELD more
           END IF
           IF tm.more = "Y" THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()           # COMMAND EXECUTION
        ON ACTION CONTROLP
            CALL asfr109_wc()          # INPUT DETAIL WHERE CONDITION
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                    WHERE zz01='asfr109'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr109','9031',1)
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
                           " '",tm.s_date CLIPPED,"'",
                           " '",tm.d_date CLIPPED,"'",
                          #" '",tm.more CLIPPED,"'",           #TQC-610080
                           " '",g_rep_user CLIPPED,"'",        #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",        #No.FUN-570264
                           " '",g_template CLIPPED,"'",        #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
           CALL cl_cmdat('asfr109',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asfr109_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfr109()
     ERROR ""
   END WHILE
   CLOSE WINDOW asfr109_w
 
END FUNCTION
 
FUNCTION asfr109_wc()
   DEFINE l_wc LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(300)
 
   OPEN WINDOW asfr109_w2 AT 2,2 WITH FORM "asf/42f/asfi300"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfi300")
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
                 sfb07,sfb071,sfb06,sfb13,sfb15,
                 sfb39,sfb22,sfb40,sfb34,
                 sfbuser,sfbgrup,sfbmodu,sfbdate
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
   END CONSTRUCT
 
   CLOSE WINDOW asfr109_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr109_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION asfr109()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166         #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt,l_n    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          d_sma26  LIKE  sma_file.sma26,
          l_pointer    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_sta          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sta ARRAY[07] OF LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,         #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                       s_date  LIKE type_file.dat,           #No.FUN-680121 DATE
                       d_date  LIKE type_file.dat,           #No.FUN-680121 DATE
                       a       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
                       sfb01 LIKE sfb_file.sfb01,
                       sfb05 LIKE sfb_file.sfb05,
                       ima02 LIKE ima_file.ima02,            #TQC-D50013 add
                       ima021 LIKE ima_file.ima021,          #TQC-D50013 add
                       sfb02 LIKE sfb_file.sfb02,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb40 LIKE sfb_file.sfb40,
                       sfb08 LIKE sfb_file.sfb08,
                       ima55 LIKE ima_file.ima55,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb34 LIKE sfb_file.sfb34,
                       sfb251 LIKE sfb_file.sfb251,
                       sfb071 LIKE sfb_file.sfb071,
                       sfb06 LIKE sfb_file.sfb06,
                       sfb23 LIKE sfb_file.sfb23,
                       sfb24 LIKE sfb_file.sfb24,
                       sfb42 LIKE sfb_file.sfb42,
                       sfb82 LIKE sfb_file.sfb82,
                       gem02 LIKE gem_file.gem02,            #TQC-D50013 add
                       ima01 LIKE ima_file.ima01,
                       sfb93 LIKE sfb_file.sfb93   #MOD-D30169
                    END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file
                  WHERE zo01 = g_rlang
# No.FUN-580014 --start--
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
#                  WHERE zz01 = 'asfr109'
# No.FUN-580014 --end--
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
 
   LET l_sql =
               "SELECT '', '', '', sfb01, sfb05, '','',sfb02, sfb13, ",   #TQC-D50013 add '',''
               "       sfb40, sfb08, ima55, sfb15, sfb34, ",
               "       sfb251, sfb071, sfb06, sfb23, sfb24, sfb42, ",
               "       sfb82,'',ima01,sfb93 ",  #MOD-D30169       #TQC-D50013 add ''
               "  FROM sfb_file,ima_file",
               " WHERE sfb05 = ima01",
               "   AND sfb04 ='1' ",
               #TQC-B80149  --begin
              # "   AND sfb251 >=  cast('",tm.s_date,"' as datetime) ",
              # "   AND sfb251 <=  cast('",tm.d_date,"' as datetime) ",
               "   AND sfb251 >=  cast('",tm.s_date,"' as DATE) ",
               "   AND sfb251 <=  cast('",tm.d_date,"' as DATE) ",
               #TQC-B80149  --end
               "   AND sfb87 <> 'X' ",                         #MOD-B50251 add
               "   AND ",tm.wc CLIPPED,
               "   ORDER BY sfb82,sfb01 "
 
   PREPARE asfr109_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
   END IF
   DECLARE asfr109_curs1 CURSOR FOR asfr109_prepare1
 
#  LET l_name = 'asfr109.out'
#  CALL cl_outnam('asfr109') RETURNING l_name    #NO.FUN-750093
#No.FUN-550067-begin
#   LET g_len = 86
# No.FUN-580014 --start--
#   FOR g_i = 1 TO g_len
#       LET g_dash[g_i,g_i] = '='
#   END FOR
# No.FUN-580014 --end--
#No.FUN-550067-end
#   START REPORT asfr109_rep TO l_name          #NO.FUN-750093
    CALL cl_del_data(l_table)                   #NO.FUN-750093
   LET g_pageno = 0
   FOREACH asfr109_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0  THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      IF sr.sfb251 > tm.d_date OR sr.sfb251 < sr.s_date THEN
          CONTINUE FOREACH
      END IF

      #TQC-D50013--add--str--
      SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
       WHERE ima01 = sr.sfb05

      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.sfb82
      #TQC-D50013--add--end--
 
      IF sr.sfb02 IS NULL THEN
          LET sr.sfb02 = "  "
      END IF
      IF sr.sfb13 IS NULL THEN
          LET sr.sfb13 = "  /  /  "
      END IF
      IF sr.sfb15 IS NULL THEN
          LET sr.sfb15 = "  /  /  "
      END IF
      IF sr.sfb08 IS NULL THEN
          LET sr.sfb08 = 0
      END IF
      LET sr.s_date = tm.s_date
      LET sr.d_date = tm.d_date
#NO.FUN-750093 --------begin---------- 
      LET g_num = 0
      LET l_pointer = " "
      LET sr.a = "*"
      INITIALIZE sta[01] TO NULL
      INITIALIZE sta[02] TO NULL
      INITIALIZE sta[03] TO NULL
      INITIALIZE sta[04] TO NULL
      INITIALIZE sta[05] TO NULL
      INITIALIZE sta[06] TO NULL
      INITIALIZE sta[07] TO NULL
  ######  備料部份之判斷  ######
      WHILE TRUE
            # 1. 工單有效日期 ( sfb15 ) 為 NULL
         IF sr.sfb15 IS NULL THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5068',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
 
            # 2. 備料資料尚未產生 ( sfb23 = "N" )
         IF sr.sfb23 = "N" THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5069',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
 
            # 3. 此料件未建立產品結構(不包含再加工及拆件式工單)
         IF sr.sfb02 != "5" AND sr.sfb02 != "11" AND sr.sfb23 NOT MATCHES '[Yy]'
            THEN
            SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE sr.sfb05 = bmb01
            IF l_cnt = 0 THEN
               LET g_num = g_num + 1
		       CALL cl_getmsg('mfg5070',g_lang)  RETURNING l_sta
               LET sta[g_num] = l_sta
               LET l_pointer = "*"
               EXIT WHILE
            END IF
         END IF
 
            # 4. 無有效產品結構元件可供備料
         IF sr.sfb02 != "5" AND sr.sfb02 != "11" AND sr.sfb23 NOT MATCHES '[Yy]'
           THEN SELECT count(*) into l_n FROM bmb_file
                          WHERE bmb01 = sr.sfb05   #料件編號
                          and (bmb04 <=sr.sfb071 or bmb04 is null) #生效日控制
                          and (bmb05 > sr.sfb071 or bmb05 is null)
        		IF l_n=0 THEN
                  LET g_num=g_num+1
		          CALL cl_getmsg('mfg5071',g_lang)  RETURNING l_sta
                  LET sta[g_num] = l_sta
               END IF
         END IF
        EXIT WHILE
      END WHILE
 
  ######  製程追縱部份之判斷  ######
      IF sr.sfb93 = 'Y' THEN #MOD-D30169
      WHILE TRUE
            # 1. 不需產生製程追縱資料 ( sma26 = "1" )
         SELECT sma26 INTO d_sma26 FROM sma_file
         IF d_sma26 = "1" THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5072',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            EXIT WHILE
         END IF
 
            # 2. 此工單之製程編號為 NULL
         IF sr.sfb06 IS NULL THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5073',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
 
            # 3. 此料件未建立製程資料(不包含再加工及拆件式工單)
         IF sr.sfb02 != "5" AND sr.sfb02 != "11" THEN
            SELECT COUNT(*) INTO l_cnt FROM ecb_file WHERE sr.sfb05 = ecb01
            IF l_cnt = 0 THEN
               LET g_num = g_num + 1
		       CALL cl_getmsg('mfg5075',g_lang)  RETURNING l_sta
               LET sta[g_num] = l_sta
               LET l_pointer = "*"
               EXIT WHILE
            END IF
         END IF
 
            # 4. 製程追縱資料尚未產生 ( sfb24 = "N" )
         IF sr.sfb24 = "N" THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5074',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
        EXIT WHILE
      END WHILE
      END IF #MOD-D30169
      ###### 若所有資料皆齊,則列印正常、待發放  #####
      IF cl_null(l_pointer) THEN      # 如果l_pointer = "*",則表示有異常 #
         LET g_num = g_num + 1
         CALL cl_getmsg('mfg5077',g_lang)  RETURNING l_sta
         LET sta[g_num] = l_sta
         LET sr.a = " "
      END IF
      EXECUTE insert_prep USING sr.s_date,sr.d_date,
                                sr.a,sr.sfb01,
                                sr.sfb05,
                                sr.ima01,sr.ima021,     #TQC-D50013 add
                                sr.sfb02,
                                sr.sfb13,sr.sfb40,
                                sr.sfb08,sr.ima55,
                                sr.sfb15,sr.sfb34,
                                sr.sfb251,sr.sfb071,
                                sr.sfb06,sr.sfb23,
                                sr.sfb24,sr.sfb42,
                                sr.sfb82,sr.gem02,      #TQC-D50013 add sr.gem02
                                sr.ima01,
                                sta[01],sta[02],
                                sta[03],sta[04],
                                sta[05],sta[06],
                                sta[07]
#NO.FUN-750093 ----end------------- 
#     OUTPUT TO REPORT asfr109_rep(sr.*)    #NO.FUN-750093
   END FOREACH
   
#  FINISH REPORT asfr109_rep                #NO.FUN-750093
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #NO.FUN-750093
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #NO.FUN-750093
   IF g_zz05 = 'Y' THEN                     #NO.FUN-750093
      CALL cl_wcchp(tm.wc,'sfb02,sfb01,sfb05,sfb82')   #NO.FUN-750093
             RETURNING tm.wc                #NO.FUN-750093
   LET g_str = tm.wc                        #NO.FUN-750093
   END IF                                   #NO.FUN-750093
   LET g_str = tm.s_date,";",tm.d_date,";",g_str       #NO.FUN-750093
   CALL cl_prt_cs3('asfr109','asfr109',l_sql,g_str)    #NO.FUN-750093
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)         #NO.FUN-750093
END FUNCTION
 
#NO.FUN-750093     -------begin---------
{REPORT asfr109_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_pointer    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_pt         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_sta        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_cnt,l_n    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          d_sma26  LIKE  sma_file.sma26,
          p_bmb     RECORD
                       bmb04 LIKE bmb_file.bmb04,
                       bmb05 LIKE bmb_file.bmb05
                    END RECORD,
          sta ARRAY[07] OF LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sr        RECORD
                       s_date  LIKE type_file.dat,           #No.FUN-680121 DATE
                       d_date  LIKE type_file.dat,           #No.FUN-680121 DATE
                       a       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
                       sfb01 LIKE sfb_file.sfb01,
                       sfb05 LIKE sfb_file.sfb05,
                       sfb02 LIKE sfb_file.sfb02,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb40 LIKE sfb_file.sfb40,
                       sfb08 LIKE sfb_file.sfb08,
                       ima55 LIKE ima_file.ima55,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb34 LIKE sfb_file.sfb34,
                       sfb251 LIKE sfb_file.sfb251,
                       sfb071 LIKE sfb_file.sfb071,
                       sfb06 LIKE sfb_file.sfb06,
                       sfb23 LIKE sfb_file.sfb23,
                       sfb24 LIKE sfb_file.sfb24,
                       sfb42 LIKE sfb_file.sfb42,
                       sfb82 LIKE sfb_file.sfb82,
                       ima01 LIKE ima_file.ima01
 
                       END RECORD
   OUTPUT   TOP MARGIN g_top_margin
           LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
           PAGE LENGTH g_page_line
   ORDER BY sr.sfb82,sr.sfb01
   FORMAT
# No.FUN-580014 --start--
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      IF cl_null(g_towhom) THEN
#          PRINT '';
#      ELSE
#          PRINT 'TO:',g_towhom;
#      END IF
 
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      #PRINT COLUMN 33,tm.s_date USING "YY/MM/DD",'-', #FUN-570250 mark
      #                tm.d_date USING "YY/MM/DD" #FUN-570250 mark
#     PRINT COLUMN 33,tm.s_date,'-', #FUN-570250 add     #No.TQC-710016
      PRINT COLUMN (g_len-17)/2+1,tm.s_date,'-', #FUN-570250 add     #No.TQC-710016
                      tm.d_date #FUN-570250 add
      PRINT ' '
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[2] CLIPPED,g_pdate USING "yy/mm/dd",' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
#No.FUN-550067-begin
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]
      PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
      PRINT g_dash1
# No.FUN-580014 --end--
 
   BEFORE GROUP OF sr.sfb01
      LET g_num = 0
      LET l_pointer = " "
      LET sr.a = "*"
      INITIALIZE sta[01] TO NULL
      INITIALIZE sta[02] TO NULL
      INITIALIZE sta[03] TO NULL
      INITIALIZE sta[04] TO NULL
      INITIALIZE sta[05] TO NULL
      INITIALIZE sta[06] TO NULL
      INITIALIZE sta[07] TO NULL
  ######  備料部份之判斷  ######
      WHILE TRUE
            # 1. 工單有效日期 ( sfb15 ) 為 NULL
         IF sr.sfb15 IS NULL THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5068',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
 
            # 2. 備料資料尚未產生 ( sfb23 = "N" )
         IF sr.sfb23 = "N" THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5069',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
 
            # 3. 此料件未建立產品結構(不包含再加工及拆件式工單)
         IF sr.sfb02 != "5" AND sr.sfb02 != "11" AND sr.sfb23 NOT MATCHES '[Yy]'
            THEN
            SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE sr.sfb05 = bmb01
            IF l_cnt = 0 THEN
               LET g_num = g_num + 1
		       CALL cl_getmsg('mfg5070',g_lang)  RETURNING l_sta
               LET sta[g_num] = l_sta
               LET l_pointer = "*"
               EXIT WHILE
            END IF
         END IF
 
            # 4. 無有效產品結構元件可供備料
         IF sr.sfb02 != "5" AND sr.sfb02 != "11" AND sr.sfb23 NOT MATCHES '[Yy]'
           THEN SELECT count(*) into l_n FROM bmb_file
                          WHERE bmb01 = sr.sfb05   #料件編號
                          and (bmb04 <=sr.sfb071 or bmb04 is null) #生效日控制
                          and (bmb05 > sr.sfb071 or bmb05 is null)
        		IF l_n=0 THEN
                  LET g_num=g_num+1
		          CALL cl_getmsg('mfg5071',g_lang)  RETURNING l_sta
                  LET sta[g_num] = l_sta
               END IF
         END IF
        EXIT WHILE
      END WHILE
 
  ######  製程追縱部份之判斷  ######
 
      WHILE TRUE
            # 1. 不需產生製程追縱資料 ( sma26 = "1" )
         SELECT sma26 INTO d_sma26 FROM sma_file
         IF d_sma26 = "1" THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5072',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            EXIT WHILE
         END IF
 
            # 2. 此工單之製程編號為 NULL
         IF sr.sfb06 IS NULL THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5073',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
 
            # 3. 此料件未建立製程資料(不包含再加工及拆件式工單)
         IF sr.sfb02 != "5" AND sr.sfb02 != "11" THEN
            SELECT COUNT(*) INTO l_cnt FROM ecb_file WHERE sr.sfb05 = ecb01
            IF l_cnt = 0 THEN
               LET g_num = g_num + 1
		       CALL cl_getmsg('mfg5075',g_lang)  RETURNING l_sta
               LET sta[g_num] = l_sta
               LET l_pointer = "*"
               EXIT WHILE
            END IF
         END IF
 
            # 4. 製程追縱資料尚未產生 ( sfb24 = "N" )
         IF sr.sfb24 = "N" THEN
            LET g_num = g_num + 1
		    CALL cl_getmsg('mfg5074',g_lang)  RETURNING l_sta
            LET sta[g_num] = l_sta
            LET l_pointer = "*"
         END IF
        EXIT WHILE
      END WHILE
 
      ###### 若所有資料皆齊,則列印正常、待發放  #####
      IF cl_null(l_pointer) THEN      # 如果l_pointer = "*",則表示有異常 #
         LET g_num = g_num + 1
         CALL cl_getmsg('mfg5077',g_lang)  RETURNING l_sta
         LET sta[g_num] = l_sta
         LET sr.a = " "
      END IF
 
   ON EVERY ROW
            NEED (g_num + 3) LINES
# No.FUN-580014 --start--
        PRINTX name=D1
                  COLUMN g_c[31],sr.a,' ',
                  COLUMN g_c[32],sr.sfb01 CLIPPED,' ',
                  COLUMN g_c[33],sr.sfb05 CLIPPED,'  ',
                  COLUMN g_c[34],sr.sfb02 USING "##",' ',
                  #COLUMN g_c[35],sr.sfb13 USING "YY/MM/DD",' ', #FUN-570250 mark
                  COLUMN g_c[35],sr.sfb13,' ', #FUN-570250 add
                  COLUMN g_c[36],sr.sfb40 USING "####",'      ',
                  COLUMN g_c[37],sr.sfb08 USING "---------.---",'/',sr.ima55,
                  COLUMN g_c[38],sr.sfb42 USING "#&"
        PRINTX name=D2
                  COLUMN g_c[41],sr.sfb82 CLIPPED,
                  #COLUMN g_c[43],sr.sfb15 USING "YY/MM/DD",'  ', #FUN-570250 mark
                  COLUMN g_c[43],sr.sfb15,'  ',  #FUN-570250 add
                  COLUMN g_c[44],sr.sfb34 USING "###.###%",'  ',
                  COLUMN g_c[45],sr.sfb251
# No.FUN-580014 --end--
            PRINT COLUMN 15,g_x[16] CLIPPED,sta[01]
            IF sta[02] IS NOT NULL THEN
               PRINT COLUMN 20,sta[02]
            END IF
            IF sta[03] IS NOT NULL THEN
               PRINT COLUMN 20,sta[03]
            END IF
            IF sta[04] IS NOT NULL THEN
               PRINT COLUMN 20,sta[04]
            END IF
            IF sta[05] IS NOT NULL THEN
               PRINT COLUMN 20,sta[05]
            END IF
            IF sta[06] IS NOT NULL THEN
               PRINT COLUMN 20,sta[06]
            END IF
            IF sta[07] IS NOT NULL THEN
               PRINT COLUMN 20,sta[07]
            END IF
            PRINT ' '
#No.FUN-550067-end
 
ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
          CALL cl_wcchp(tm.wc,'sfb02,sfb01,sfb05,sfb82')   #TQC-630166
                  RETURNING tm.wc
          PRINT g_dash[1,g_len]
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#         IF tm.wc[001,070] > ' ' THEN            # for 80
#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         IF tm.wc[071,140] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         IF tm.wc[141,210] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         IF tm.wc[211,280] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#TQC-630166-end
      END IF
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
          PRINT g_dash[1,g_len]
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610037 <> #
}
#NO.FUN-750093   ------end--------------
