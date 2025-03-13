# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: acor600.4gl
# Descriptions...: 轉廠申請表列印
# Date & Author..: 00/09/25 By Mandy
# Modify.........: NO.MOD-490398 04/11/22 BY DAY  add HS Code
# Modify.........: No.FUN-580013 05/08/15 BY Nigel 改用新報表格式
# Modify.........: No.TQC-5B0108 05/11/12 BY Claire 調整商品編號長度
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-730019 07/03/16 By Judy Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-840150 08/04/18 By Zhangyajun CR SQL修改 
# Modify.........: No.FUN-850132 08/05/27 By baofei 修改報表打印的錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao CR報表簽核處理 
# Modify.........: No.TQC-C20055 12/02/09 By zhuhao CR報表簽核處理還原
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                                     # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
              choice  LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # 確認否
              a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) # NO.MOD-490398
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # 是否輸入其它特殊列印條件?
              END RECORD
# No: FUN-580013 --start--
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
 #DEFINE   g_zz05          LIKE zz_file.zz05   #Print tm.wc ?(Y/N)  #NO.MOD-490398
#FUN-730019.....begin
DEFINE   g_sql      STRING,
         g_str      STRING,
         l_table1   STRING,
         l_table2   STRING
#FUN-730019.....end
# No: FUN-580013 --end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
   LET g_pdate   = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)
   LET tm.choice = ARG_VAL(8)
#------------No.TQC-610082 modify
   LET tm.a    = ARG_VAL(9)
#   LET tm.a = 'N'                         #MOD-490398
#  LET tm.more   = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610082 end
 
#FUN-730019.....begin
   LET g_sql = "cnm01.cnm_file.cnm01,cnm03.cnm_file.cnm03,",
               "l_desc1.type_file.chr20,l_desc2.type_file.chr20,",
               "cnm071.cnm_file.cnm071,cnm081.cnm_file.cnm081"
              #TQC-C20055--mark--begin
              #TQC-C10034---add---begin
              #"sign_type.type_file.chr1,sign_img.type_file.blob,",
              #"sign_show.type_file.chr1,sign_str.type_file.chr1000"
              #TQC-C10034---add---end
              #TQC-C20055--mark--end
   LET l_table1 = cl_prt_temptable('acor6001',g_sql) CLIPPED 
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "cnm01.cnm_file.cnm01,cnm03.cnm_file.cnm03,",
               "l_desc1.type_file.chr20,l_desc2.type_file.chr20,",
               "cnm071.cnm_file.cnm071,cnm081.cnm_file.cnm081,",
               "memo.type_file.chr1,cnm06.cnm_file.cnm06,",
               "cnn04.cnn_file.cnn04,cnn05.cnn_file.cnn05,",
               "cnn06.cnn_file.cnn06,cnn07.cnn_file.cnn07,",
               "cnn08.cnn_file.cnn08,cob02.cob_file.cob02,",
               "cob09.cob_file.cob09"

   LET l_table2 = cl_prt_temptable('acor6002',g_sql) CLIPPED   
   IF l_table2  = -1 THEN EXIT PROGRAM END IF
#FUN-730019.....end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
       THEN CALL acor600_tm(0,0)        # Input print condition
       ELSE CALL acor600()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor600_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 12
 
   OPEN WINDOW acor600_w AT p_row,p_col WITH FORM "aco/42f/acor600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL            # Default condition
    LET tm.more = 'N'
     LET tm.a = 'N'                         #MOD-490398
    LET tm.choice = '3'
    LET g_pdate = g_today
    LET g_rlang = g_lang
    LET g_bgjob = 'N'
    LET g_copies= '1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON cnm01,cnm02,cnm04,cnm05
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
        LET INT_FLAG = 0
        CLOSE WINDOW acor600_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
    END IF
     DISPLAY BY NAME tm.choice,tm.a,tm.more      # Condition  #MOD-490398
     INPUT BY NAME tm.choice,tm.a,tm.more WITHOUT DEFAULTS    #MOD-490398
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD choice
            IF tm.choice NOT MATCHES "[123]" OR cl_null(tm.choice) THEN
                NEXT FIELD choice
            END IF
        AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
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
            CALL cl_cmdask()    # Command execution
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
        CLOSE WINDOW acor600_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01 = 'acor600'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('acor600','9031',1)
        ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",                #MOD-490398
                        #" '",tm.more CLIPPED,"'",        #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('acor600',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW acor600_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    CALL cl_wait() #作業中,請稍後...
    CALL acor600() #製作報表
    ERROR ""
END WHILE
    CLOSE WINDOW acor600_w
END FUNCTION
 
FUNCTION acor600()
    DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time           LIKE type_file.chr8        #No.FUN-6A0063
           l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
           l_chr     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           l_za05    LIKE za_file.za05,           #MOD-490398
           l_order   ARRAY[5] OF LIKE qcs_file.qcs03, #No.FUN-680069 VARCHAR(10)
           sr        RECORD
                            cnm01   LIKE cnm_file.cnm01, #申請編號
                            cnm02   LIKE cnm_file.cnm02, #申請日期
                            cnm03   LIKE cnm_file.cnm03, #申請表編號
                            cnm04   LIKE cnm_file.cnm04, #轉廠型態
                            cnm05   LIKE cnm_file.cnm05, #合同編號
                            cnm06   LIKE cnm_file.cnm06, #幣別
                            cnm07   LIKE cnm_file.cnm07, #
                            l_desc1 LIKE cnb_file.cnb04, #公司簡稱
                            cnm071  LIKE cnm_file.cnm071,#手冊編號
                            cnm08   LIKE cnm_file.cnm08,
                            l_desc2 LIKE pmc_file.pmc03, #廠商簡稱
                            cnm081  LIKE cnm_file.cnm081,#手冊編號
                            cnn04   LIKE cnn_file.cnn04, #商品編號
                            cob09   LIKE cob_file.cob09, #MOD-490398
                            cob02   LIKE cob_file.cob02, #貨物名稱規格
                            cnn05   LIKE cnn_file.cnn05, #數量
                            cnn06   LIKE cnn_file.cnn06, #單位
                            cnn07   LIKE cnn_file.cnn07, #單價
                            cnn08   LIKE cnn_file.cnn08  #總值
                    END RECORD
#FUN-730019.....begin
    DEFINE l_n           LIKE type_file.num5,
           l_memo        LIKE type_file.chr1
#TQC-C20055--mark--bengin
#TQC-C10034--add--begin
#   DEFINE l_img_blob     LIKE type_file.blob
#       LOCATE l_img_blob IN MEMORY
#TQC-C10034--add--end    
#TQC-C20055--mark--end   
        CALL cl_del_data(l_table1)
        CALL cl_del_data(l_table2)
 
        LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                    " VALUES(?,?,?,?,?,?)"  #,?,?,?,?)"    #TQC-C10034 add 4?  #TQC-C20055--mark
        PREPARE insert_prep1 FROM g_sql
        IF STATUS THEN
           CALL cl_err('insert_prep1:',status,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
           EXIT PROGRAM
        END IF
  
        LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  
        PREPARE insert_prep2 FROM g_sql
        IF STATUS THEN
           CALL cl_err('insert_prep2:',status,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD
           EXIT PROGRAM
        END IF
#FUN-730019.....end
 
    SELECT zo02 INTO g_company FROM zo_file
        WHERE zo01 = g_rlang
# No: FUN-580013 --start--
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
#        WHERE zz01 = 'acor600'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
# No: FUN-580013 --end--
 
    #Begin:FUN-980030
    #    IF g_priv2 = '4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND cnmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND cnmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND cnmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cnmuser', 'cnmgrup')
    #End:FUN-980030
 
    #抓取資料
    LET l_sql = "SELECT cnm01,cnm02,cnm03,cnm04,cnm05,cnm06,cnm07,'',cnm071, ",
                 "  cnm08,'',cnm081,cnn04,'','',cnn05,cnn06,cnn07,cnn08 ",   #MOD-490398
                "   FROM cnm_file, OUTER cnn_file ",
                "   WHERE  cnm_file.cnm01 = cnn_file.cnn01 ",
                "     AND cnmacti = 'Y' ",
                "     AND ",tm.wc CLIPPED
     IF tm.choice = '1' THEN
        LET l_sql = l_sql CLIPPED," AND cnmconf = 'Y' "
     END IF
     IF tm.choice = '2' THEN
        LET l_sql = l_sql CLIPPED," AND cnmconf = 'N' "
      END IF
     LET l_sql = l_sql CLIPPED, " ORDER BY cnm01 "
     PREPARE acor600_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE acor600_curs1 CURSOR FOR acor600_prepare1
#FUN-730019.....begin mark
#    CALL cl_outnam('acor600') RETURNING l_name
 
#    START REPORT acor600_rep TO l_name
#FUN-730019.....end mark
     LET g_pageno = 0
     FOREACH acor600_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0  THEN
             CALL cl_err('foreach:curs1',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         SELECT cnb04  INTO sr.l_desc1 FROM cnb_file
                WHERE cnb01 = sr.cnm07
         SELECT pmc03 INTO sr.l_desc2 FROM pmc_file
                WHERE pmc01 = sr.cnm08
#FUN-730019.....begin
         EXECUTE insert_prep1 USING sr.cnm01,sr.cnm03,sr.l_desc1,sr.l_desc2,
                                    sr.cnm071,sr.cnm081
                                  # "",  l_img_blob,   "N",""    #TQC-C10034  add   #TQC-C20055--mark
        FOR l_n=1 TO 7
         LET l_memo = tm.a
         SELECT cob02 INTO sr.cob02 FROM cob_file
                WHERE cob01 = sr.cnn04
         EXECUTE insert_prep2 USING sr.cnm01,sr.cnm03,sr.l_desc1,sr.l_desc2,
                                    sr.cnm071,sr.cnm081,l_memo,sr.cnm06,
                                    sr.cnn04,sr.cnn05,sr.cnn06,sr.cnn07,
                                    sr.cnn08,sr.cob02,sr.cob09
        END FOR
 
#        OUTPUT TO REPORT acor600_rep(sr.*)
#FUN-730019.....end
 
     END FOREACH
#FUN-730019.....begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#MOD-840150-mark-start-
#     LET l_sql = "SELECT ",l_table1,".*,",l_table2,".cnm01,",l_table2,".cnm03,",
#                 l_table2,".l_desc1,",l_table2,".l_desc2,",l_table2,".cnm071,",
#                 l_table2,".cnm081,",l_table2,".memo,",l_table2,".cnm06,",
#                 l_table2,".cnn04,",l_table2,".cnn05,",l_table2,".cnn06,",
#                 l_table2,".cnn07,",l_table2,".cnn08,",l_table2,".cob02,",
#                 l_table2,".cob09",
#   #TQC-730113## " FROM ",l_table1 CLIPPED,",",l_table2 CLIPPED,
#                 " FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,",",g_cr_db_str CLIPPED,l_table2 CLIPPED,
#                 " WHERE ",l_table1,".cnm01= ",l_table2,".cnm01",
#                 "   AND ",l_table1,".l_desc1= ",l_table2,".l_desc1",
#                 "   AND ",l_table1,".cnm071= ",l_table2,".cnm071"
#MOD-840150-start-                                                                                                                  
     LET l_sql = "SELECT A.*,B.cnm01,B.cnm03,",                                                                                     
                 "B.l_desc1,B.l_desc2,B.cnm071,",                                                                                   
                 "B.cnm081,B.memo,B.cnm06,",                                                                                        
                 "B.cnn04,B.cnn05,B.cnn06,",                                                                                        
                 "B.cnn07,B.cnn08,B.cob02,",                                                                                        
                 "B.cob09",
                 " FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," A,",g_cr_db_str CLIPPED,l_table2 clIPPED," B",
                 " WHERE A.cnm01 = B.cnm01"          #No.FUN-850132
#                " WHERE A.cnm01 = B.cnm01,"         #No.FUN-850132 
#                 "   AND A.l_desc1 = B.l_desc1",    #No.FUN-850132                                                                                
#                 "   AND A.cnm071 = B.cnm071"       #No.FUN-850132                                                                                      
#MOD-840150-end-
     CALL cl_wcchp(tm.wc,'cnm01,cnm02,cnm04,cnm05') RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05 
   # CALL cl_prt_cs3('acor600',l_sql,g_str)   #TQC-730113
 #TQC-C20055--mark--begin
    #TQC-C10034--add--begin
  #  LET g_cr_table = l_table1
  #  LET g_cr_apr_key_f = "cnm01" 
    #TQC-C10034--add--end
 #TQC-C20055--mark--end
     CALL cl_prt_cs3('acor600','acor600',l_sql,g_str)
 
#    FINISH REPORT acor600_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#FUN-730019......begin mark
#REPORT acor600_rep(sr)
#    DEFINE l_last_sw    LIKE type_file.chr1,      #No.FUN-680069 VARCHAR(1)
#           sr           RECORD
#                            cnm01   LIKE cnm_file.cnm01, #申請編號
#                            cnm02   LIKE cnm_file.cnm02, #申請日期
#                            cnm03   LIKE cnm_file.cnm03, #申請表編號
#                            cnm04   LIKE cnm_file.cnm04, #轉廠型態
#                            cnm05   LIKE cnm_file.cnm05, #合同編號
#                            cnm06   LIKE cnm_file.cnm06, #幣別
#                            cnm07   LIKE cnm_file.cnm07, #
#                            l_desc1 LIKE cnb_file.cnb04, #公司簡稱
#                            cnm071  LIKE cnm_file.cnm071,#手冊編號
#                            cnm08   LIKE cnm_file.cnm08,
#                            l_desc2 LIKE pmc_file.pmc03, #廠商簡稱
#                            cnm081  LIKE cnm_file.cnm081,#手冊編號
#                            cnn04   LIKE cnn_file.cnn04, #商品編號
#                            cob09   LIKE cob_file.cob09, #MOD-490398
#                            cob02   LIKE cob_file.cob02, #貨物名稱規格
#                            cnn05   LIKE cnn_file.cnn05, #數量
#                            cnn06   LIKE cnn_file.cnn06, #單位
#                            cnn07   LIKE cnn_file.cnn07, #單價
#                            cnn08   LIKE cnn_file.cnn08  #總值
#                        END RECORD
#    OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#    ORDER BY sr.cnm01
#    FORMAT
#      PAGE HEADER
#        LET g_x[11] = g_x[11] CLIPPED
## No: FUN-580013 --start--
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[11]))/2)+1,g_x[11]
## No: FUN-580013 --end--
#        PRINT
#        PRINT
#        PRINT g_x[12] CLIPPED,' ', sr.l_desc1,
#              COLUMN 51 ,g_x[13] CLIPPED,' ',sr.l_desc2  #TQC-5b0108 &051112 41->51
#        PRINT
#        PRINT g_x[14] CLIPPED,
#              COLUMN 51 ,g_x[14] CLIPPED  #TQC-5b0108 &051112 41->51
#        PRINT
#        PRINT g_x[15] CLIPPED,
#              COLUMN 51 ,g_x[15] CLIPPED  #TQC-5b0108 &051112 41->51
#        PRINT
#        PRINT g_x[16] CLIPPED,' ', sr.cnm071 ,
#              COLUMN 51 ,g_x[16] CLIPPED,' ',sr.cnm081  #TQC-5b0108 &051112 41->51
#        PRINT
#        PRINT g_x[17] CLIPPED,' ', sr.cnm01  ,
#              COLUMN 51 ,g_x[18] CLIPPED,' ',sr.cnm03  #TQC-5b0108 &051112 41->51
#        PRINT
#        PRINT g_x[19] CLIPPED
#        PRINT
# #MOD-490398(BEGIN)
## No: FUN-580013 --start--
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#        PRINT g_dash1
## No: FUN-580013 --end--
#    BEFORE GROUP OF sr.cnm01
#        SKIP TO TOP OF PAGE
#
#    ON EVERY ROW
#        IF tm.a = 'N' THEN
#           PRINT COLUMN g_c[31],sr.cnn04;  #TQC-5B0108 &051112 [1,10];
#        ELSE
#           SELECT cob09 INTO sr.cob09 FROM cob_file WHERE cob01=sr.cnn04
#           PRINT COLUMN g_c[31],sr.cob09;  #TQC-5b0108 &051112 [1,10];
#        END IF
## No: FUN-580013 --start--
#        PRINT COLUMN g_c[32],sr.cob02[1,30], #TQC-5b0108 &051112  [1,24],
#              COLUMN g_c[33],sr.cnn06,
#              COLUMN g_c[34],sr.cnn05 USING "######&.&#",' ',
#              COLUMN g_c[35],sr.cnn07 USING "######&.&#",' ',
#              COLUMN g_c[36],sr.cnn08 USING "########&.&#",' ',
#              COLUMN g_c[37],sr.cnm06
## No: FUN-580013 --end--
#
#    AFTER GROUP OF sr.cnm01
#        NEED 10 LINES
#        PRINT
#        PRINT g_x[22] CLIPPED,                COLUMN 41 ,g_x[23] CLIPPED
#        PRINT
#        PRINT g_x[24] CLIPPED,                COLUMN 41 ,g_x[24] CLIPPED
#        PRINT
#        PRINT g_x[25] CLIPPED,                COLUMN 41 ,g_x[25] CLIPPED
#        PRINT
#        PRINT g_x[26] CLIPPED,                COLUMN 41 ,g_x[26] CLIPPED
#        PRINT
#        PRINT g_x[27] CLIPPED,                COLUMN 41 ,g_x[27] CLIPPED
# #MOD-490398(END)
#END REPORT
#FUN-730019.....end
#Patch....NO.TQC-610035 <> #
