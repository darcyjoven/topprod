# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfr890.4gl
# Desc/riptions..: 報廢(入庫)一覽表
# Input parameter:
# Return code....:
# Date & Author..: 00/08/21 By Mandy
# Modify.........: NO.FUN-510040 05/02/16 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550067  05/05/31 By yoyo單據編號格式放大
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-770003 07/07/03 By zhoufeng 維護幫助按鈕
# Modify.........: No.FUN-840039 08/04/21 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.MOD-940305 09/04/24 By Smapmin 明細資料重複,因為沒有以runcard做link
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60080 10/07/09 By destiny 报表打印增加制程段号，制程序
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                  # Print condition RECORD
                wc      STRING,                    # Where condition  #NO.TQC-630166
#                wc      VARCHAR(600),                # Where condition
                s        LIKE type_file.chr3,      #No.FUN-680121 VARCHAR(3)# Order by sequence
                t        LIKE type_file.chr3,      #No.FUN-680121 VARCHAR(3)#
                u        LIKE type_file.chr3,      #No.FUN-680121 VARCHAR(3)
#               mtext    LIKE apm_file.apm08,      #No.FUN-680121 VARCHAR(10)#申請單號
                mtext    LIKE oea_file.oea01,      #No.FUN-680121 VARCHAR(16)#No.FUN-550067
                c        LIKE type_file.chr1       #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
DEFINE g_orderA ARRAY[3] OF LIKE shb_file.shb10,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 10->40
#      g_mtext VARCHAR(10)
       g_mtext LIKE oea_file.oea01                        #No.FUN-680121 #No.FUN-550067
#DEFINE   g_dash          VARCHAR(400)                       #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE    g_sql           STRING    #NO.FUN-840039
DEFINE    g_str           STRING    #NO.FUN-840039
DEFINE    l_table         STRING    #NO.FUN-840039
DEFINE    l_table1        STRING    #NO.FUN-840039
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
   #NO.FUN-840039-----BEGIN-----
   LET g_sql = "order1.shb_file.shb10,",
                "order2.shb_file.shb10,",
                "order3.shb_file.shb10,",
                "shb05.shb_file.shb05,",
                "shb16.shb_file.shb16,",
                "shb10.shb_file.shb10,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "ima55.ima_file.ima55,",
                "shb06.shb_file.shb06,",
                "shb081.shb_file.shb081,",
                "shb082.shb_file.shb082,",
                "shb111.shb_file.shb111,",
                "shb112.shb_file.shb112,",
                "shb012.shb_file.shb012 "  #NO.FUN-A60080
    LET l_table = cl_prt_temptable('asfr890',g_sql) CLIPPED
    IF  l_table = -1 THEN EXIT PROGRAM END IF 
    
     LET g_sql = "shb01.shb_file.shb01,",
                 "shb03.shb_file.shb03,",
                 "qce03.qce_file.qce03,",
                 "shc05.shc_file.shc05,",
                 "shb05.shb_file.shb05,",
                 "shb081.shb_file.shb081,",
                 "shb10.shb_file.shb10,",
                 "shb06.shb_file.shb06,",
                 "shb16.shb_file.shb16"   #MOD-940305
     LET l_table1 = cl_prt_temptable('asfr890_1',g_sql) CLIPPED
     IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   #NO.FUN-840039-----END------

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #TQC-610080-begin
   LET tm.mtext= ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(11)
   #LET g_rep_clas = ARG_VAL(12)
   #LET g_template = ARG_VAL(13)
   ##No.FUN-570264 ---end---
   #TQC-610080-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r890_tm(0,0)            # Input print condition
      ELSE CALL asfr890()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r890_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r890_w AT p_row,p_col
        WITH FORM "asf/42f/asfr890"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '123'
   LET tm.t    = ''
   LET tm.u    = ''
   LET tm.mtext = ''
   LET tm.c    = 'Y'
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
 
   CONSTRUCT BY NAME tm.wc ON shb05,shb081,shb16,shb10,shb03
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(shb10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shb10
               NEXT FIELD shb10
            END IF
#No.FUN-570240 --end--
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
     ON ACTION help
        CALL cl_show_help()                       #No.TQC-770003
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r890_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.t,tm.u,tm.mtext,tm.c  # Condition
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,tm.mtext,tm.c
                   WITHOUT DEFAULTS
################################################################################
# START genero shell script ADD
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         ON ACTION help
            CALL cl_show_help()                   #No.TQC-770003
 
   END INPUT
   LET g_mtext = tm.mtext
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r890_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='asfr890'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr890','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.mtext CLIPPED,"'",             #TQC-610080
                         " '",tm.c CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr890',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r890_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr890()
   ERROR ""
END WHILE
   CLOSE WINDOW r890_w
END FUNCTION
 
FUNCTION asfr890()
   DEFINE l_name        LIKE type_file.chr20,              #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0090
          l_sql         LIKE type_file.chr1000,            # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
          l_sql1        LIKE type_file.chr1000,            # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
          l_za05        LIKE type_file.chr1000,            #No.FUN-680121 VARCHAR(40)
#         l_order       ARRAY[6] OF VARCHAR(10),
          l_order       ARRAY[6] OF LIKE shb_file.shb10,        #No.FUN-680121 VARCHAR(40)#No.FUN-550067 #FUN-5B0105 16->40
          sr            RECORD order1 LIKE shb_file.shb10,      #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                               order2 LIKE shb_file.shb10,      #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                               order3 LIKE shb_file.shb10,      #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                               shb05  LIKE shb_file.shb05,
                               shb16  LIKE shb_file.shb16,
                               shb10  LIKE shb_file.shb10,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021,
                               ima55  LIKE ima_file.ima55,
                               shb06  LIKE shb_file.shb06,
                               shb081 LIKE shb_file.shb081,
                               shb082 LIKE shb_file.shb082,
                               shb012 LIKE shb_file.shb012, #NO.FUN-A60080
                               shb111 LIKE shb_file.shb111,
                               shb112 LIKE shb_file.shb112
                        END RECORD
DEFINE  l_t       STRING  #NO.FUN-A60080                        
#NO.FUN-840039------BEGIN-----
DEFINE  l_shc05   LIKE shc_file.shc05,
        sr1       RECORD
                          shb01 LIKE shb_file.shb01,
                          shb03 LIKE shb_file.shb03,
                          qce03 LIKE qce_file.qce03,
                          shc05 LIKE shc_file.shc05
                  END RECORD
#NO.FUN-840039-----END---------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr890'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND shbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup')
     #End:FUN-980030
     #NO.FUN-840039----BEGIN-----
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)"     #NO.FUN-A60080                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"    #MOD-940305 add?                                                                                        
     PREPARE insert_prep1 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep1:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
        EXIT PROGRAM                                                                                                                 
     END IF 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     #NO.FUN-840039----END-------
 
     LET l_sql1 =" SELECT shb01,shb03,qce03,shc05 ",
                 " FROM shb_file ,sfb_file ,shc_file,",
                 " OUTER qce_file",
                 " WHERE shb05 = sfb01 AND sfb28 IS NULL ",
                 "   AND shc_file.shc04 = qce_file.qce01 ",
                 "   AND shb01 = shc01 AND ",tm.wc CLIPPED,
                 "   AND shbconf = 'Y' ",    #FUN-A70095
                 "   AND shb05=? ",
                 "   AND shb16=? ",   #MOD-940305 
                 "   AND shb081=? ",
                 "   AND shb10=? ",
                 "   AND shb06 = ? "
     PREPARE r890_pre2 FROM l_sql1
     DECLARE r890_curs2 CURSOR FOR r890_pre2
 
     LET l_sql = "SELECT '','','',shb05,shb16,shb10,ima02,ima021,",
                 " ima55,shb06,shb081,shb082,shb012,SUM(shb111),SUM(shb112) ", #NO.FUN-A60080 add shb012 
                 " FROM shb_file ,sfb_file ,OUTER ima_file  ",
                 " WHERE shb05 = sfb01 AND shb_file.shb10 = ima_file.ima01 AND sfb28 IS NULL ",
                 "   AND shb16 IS NOT NULL AND shb16 <> ' '",
                 "   AND shbconf = 'Y' ",      #FUN-A70095   
                 " AND shb112 > 0 AND ",tm.wc CLIPPED,
                 " GROUP BY shb05,shb16,shb10,ima02,ima021,ima55,shb06,shb081,shb082,shb012 "   #No.FUN-550067  #NO.FUN-A60080 add shb012 
     PREPARE r890_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
 
     DECLARE r890_curs1 CURSOR FOR r890_prepare1
 
#     CALL cl_outnam('asfr890') RETURNING l_name    #NO.FUN-840039
#     START REPORT r890_rep TO l_name               #NO.FUN-840039
#     LET g_pageno = 0                              #NO.FUN-840039
 
     FOREACH r890_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
          FOR g_i = 1 TO 3
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.shb05
                                            #LET g_orderA[g_i]= g_x[31]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.shb081
                                            #LET g_orderA[g_i]= g_x[38]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.shb16
                                            #LET g_orderA[g_i]= g_x[32]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.shb10
                                            #LET g_orderA[g_i]= g_x[33]
     #             WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.shb03
     #                                      LET g_orderA[g_i]= g_x[45]
                   OTHERWISE LET l_order[g_i]  = '-'
                             #LET g_orderA[g_i] = ' '          #清為空白
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
       #NO.FUN-840039----BEGIN-----             
       EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.shb05,sr.shb16,
             sr.shb10,sr.ima02,sr.ima021,sr.ima55,sr.shb06,sr.shb081,sr.shb082,
             sr.shb111,sr.shb112,sr.shb012  #NO.FUN-A60080  
       IF tm.c = 'Y' THEN
           LET l_shc05=0
 
           FOREACH r890_curs2 USING sr.shb05,sr.shb16,sr.shb081,sr.shb10,sr.shb06 INTO sr1.*   #MOD-940305增加sr.shb16
              EXECUTE insert_prep1 USING sr1.shb01,sr1.shb03,sr1.qce03,sr1.shc05,
                    sr.shb05,sr.shb081,sr.shb10,sr.shb06,sr.shb16   #MOD-940305增加sr.shb16
              LET l_shc05 = l_shc05 +sr1.shc05
           END FOREACH
       END IF                                  
       #NO.FUN-840039----END-------   
       #OUTPUT TO REPORT r890_rep(sr.*)
     END FOREACH
     #NO.FUN-840039----BEGIN----- 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'shb05,shb081,shb16,shb10,shb03')
            RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
   
     LET g_str=tm.wc,";",tm.c,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
               tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",tm.s[1,1],";",
               tm.s[2,2],";",tm.s[3,3]
     #NO.FUN-A60080--begin
     IF g_sma.sma541='Y' THEN  
        LET l_t='asfr890_1'
     ELSE 
     	  LET l_t='asfr890'
     END IF         
     CALL cl_prt_cs3('asfr890',l_t,g_sql,g_str) 
     #CALL cl_prt_cs3('asfr890','asfr890',g_sql,g_str)
     #NO.FUN-A60080--end
     #FINISH REPORT r890_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-840039----END-------
END FUNCTION
 
 
#NO.FUN-840039------BEGIN-------
#REPORT r890_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr1,                      #No.FUN-680121 VARCHAR(1)
#         sr            RECORD order1 LIKE shb_file.shb10,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                              order2 LIKE shb_file.shb10,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                              order3 LIKE shb_file.shb10,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
#                              shb05  LIKE shb_file.shb05,
#                              shb16  LIKE shb_file.shb16,
#                              shb10  LIKE shb_file.shb10,
#                              ima02  LIKE ima_file.ima02,
#                              ima021 LIKE ima_file.ima021,
#                              ima55  LIKE ima_file.ima55,
#                              shb06  LIKE shb_file.shb06,
#                              shb081 LIKE shb_file.shb081,
#                              shb082 LIKE shb_file.shb082,
#                              shb111 LIKE shb_file.shb111,
#                              shb112 LIKE shb_file.shb112
#                       END RECORD,
#          sr1          RECORD
#                              shb01 LIKE shb_file.shb01,
#                              shb03 LIKE shb_file.shb03,
#                              qce03 LIKE qce_file.qce03,
#                              shc05 LIKE shc_file.shc05
#                       END RECORD,
#  l_flag  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#  l_sql   LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1200)
#  l_shc05 LIKE shc_file.shc05,
#  l_amt_1 LIKE shb_file.shb112,          #No.FUN-680121 DECIMAL(12,3)
#  l_amt_2 LIKE shb_file.shb112,          #No.FUN-680121 DECIMAL(12,3)
#  l_amt_3 LIKE shb_file.shb112,          #No.FUN-680121 DECIMAL(12,3)
#  l_amt_4 LIKE shb_file.shb112,          #No.FUN-680121 DECIMAL(12,3)
#  l_amt_5 LIKE shb_file.shb112           #No.FUN-680121 DECIMAL(12,3)
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT COLUMN 1,g_x[16] CLIPPED,tm.mtext
#     PRINT g_dash[1,g_len]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41]
#     IF tm.c = 'Y' THEN
#         PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
#            g_x[49],g_x[50],g_x[51],g_x[52]
#     ELSE
#         PRINTX name=H2 g_x[42]
#     END IF
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#    IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order2
#    IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  BEFORE GROUP OF sr.order3
#    IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#  ON EVERY ROW
#    PRINTX name=D1 COLUMN g_c[31],sr.shb05 CLIPPED,
#          COLUMN g_c[32],sr.shb16 CLIPPED,
#          COLUMN g_c[33],sr.shb10 CLIPPED,
#          COLUMN g_c[34],sr.ima02 CLIPPED,
#          COLUMN g_c[35],sr.ima021 CLIPPED,
#          COLUMN g_c[36],sr.ima55 CLIPPED,
#          COLUMN g_c[37],sr.shb06 USING '##'   CLIPPED,
#          COLUMN g_c[38],sr.shb081,
#          COLUMN g_c[39],sr.shb082[1,08],
#          COLUMN g_c[40],cl_numfor(sr.shb111,6,0),
#          COLUMN g_c[41],cl_numfor(sr.shb112,5,0)
#  IF tm.c = 'Y' THEN
#    LET l_shc05=0
#
#    FOREACH r890_curs2 USING sr.shb05,sr.shb081,sr.shb10,sr.shb06 INTO sr1.*
#       PRINTX name=D2 COLUMN g_c[44],sr1.shb01 CLIPPED,
#             COLUMN g_c[45],sr1.shb03 CLIPPED,
#             COLUMN g_c[46],sr1.qce03 CLIPPED,
#             COLUMN g_c[52],cl_numfor(sr1.shc05,5,0)
#       LET l_shc05 = l_shc05 +sr1.shc05
#    END FOREACH
#  END IF
#  AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#          LET l_amt_1 = GROUP SUM(sr.shb112)
#          PRINTX name=S1
#                 COLUMN g_c[39],g_orderA[1] CLIPPED,
#                 COLUMN g_c[40],g_x[11] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(l_amt_1,5,0)
#      END IF
#  AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#          LET l_amt_2 = GROUP SUM(sr.shb112)
#          PRINTX name=S1
#                 COLUMN g_c[39],g_orderA[2] CLIPPED,
#                 COLUMN g_c[40],g_x[11] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(l_amt_2,5,0)
#      END IF
#  AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#          LET l_amt_3 = GROUP SUM(sr.shb112)
#          PRINTX name=S1
#                 COLUMN g_c[39],g_orderA[3] CLIPPED,
#                 COLUMN g_c[40],g_x[11] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(l_amt_3,5,0)
#      END IF
#   ON LAST ROW
#       IF g_zz05 = 'Y'   THEN
#           PRINT g_dash[1,g_len]
#NO.TQC-630166 start--
#            IF tm.wc[001,120] > ' ' THEN            # for 132
#                PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#                IF tm.wc[121,240] > ' ' THEN
#                   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#                   IF tm.wc[241,300] > ' ' THEN
#                       PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#            CALL cl_prt_pos_wc(tm.wc)
#NO.TQC-630166 end
#       END IF
#
#       PRINT ' '
## FUN-550124
#      # PRINT g_x[12],'  ',g_x[13],'  ',g_x[14],'  ',g_x[15],'  ',g_x[13]
#      # PRINT
#       PRINT g_dash[1,g_len]
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#       LET l_last_sw = 'y'
#   PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#           SKIP 2 LINE
#       END IF
#       PRINT
#       IF l_last_sw = 'n' THEN
#          IF g_memo_pagetrailer THEN
#              PRINT g_x[12]
#              PRINT g_memo
#          ELSE
#              PRINT
#              PRINT
#          END IF
#       ELSE
#              PRINT g_x[12]
#              PRINT g_memo
#       END IF
## END FUN-550124
 
#END REPORT
#NO.FUN-840039----------END--------------
#No.FUN-870144
