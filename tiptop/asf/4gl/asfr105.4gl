# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asfr105.4gl
# Descriptions...: 工作站派工單
# Date & Author..: 92/08/17 By yen
# Modify.........: NO.FUN-510040 05/02/17 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.MOD-530102 05/03/15 By Carol 程式中應加上工單是否走製程的判斷
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0026 05/12/06 By kevin 欄位沒對齊
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B80260 11/08/31 By houlia 調整日期區間的取值方式
# Modify.........: No.TQC-C90022 12/09/04 By chenjing 工單單號，工單狀態，部門編號，生產料件，工作站欄位增加開窗，方便使用
# Modify.........: No.TQC-C90023 12/09/04 By chenjing 報表輸出問題
# Modify.........: No.TQC-D70042 13/07/18 By lujh 顯示的報表中單身增加作業名稱和機器名稱的顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#             wc      VARCHAR(600),        # Where condition #TQC-630166
              wc      STRING,           # Where condition #TQC-630166
              wc1     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where condition
              s_date  LIKE type_file.dat,           #No.FUN-680121 DATE
              d_date  LIKE type_file.dat,           #No.FUN-680121 DATE
              b       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# sort type
              c       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# include done workstation
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
          g_tot_bal   LIKE ccq_file.ccq03           #No.FUN-680121 DECIMAL(13,2) # User defined variable
 
DEFINE   g_count      LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   #TQC-610080-begin
   LET tm.s_date  = ARG_VAL(10)
   LET tm.d_date  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(10)
   #LET g_rep_clas = ARG_VAL(11)
   #LET g_template = ARG_VAL(12)
   ##No.FUN-570264 ---end---
   #TQC-610080-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r105_tm(0,0)        # Input print condition
      ELSE CALL r105()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r105_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_direct       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW r105_w AT p_row,p_col
        WITH FORM "asf/42f/asfr105"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = '2'
   LET tm.c    = 'N'
   LET tm.more = 'N'
   LET tm.s_date = g_today
   LET tm.d_date = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     CLEAR FORM
     CONSTRUCT BY NAME tm.wc ON sfb01,sfb02,sfb04,eca03,sfb05
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
   #TQC-C90022--ADD--START
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(sfb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb_3"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01
             WHEN INFIELD(sfb04)
                CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_sfb040"    #TQC-D70042 mark
                LET g_qryparam.form = "q_sfb041"     #TQC-D70042 add
                LET g_qryparam.arg1 = g_lang         #TQC-D70042 add   
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb04
                NEXT FIELD sfb04
             WHEN INFIELD(eca03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eca03" 
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO eca03
                NEXT FIELD eca03
             WHEN INFIELD(sfb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb050"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05
             OTHERWISE 
                EXIT CASE
          END CASE
   #TQC-C90022--ADD--END--
 
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
 
#w/o by  s_taskhur() 中沒對 工作站作選擇
     CONSTRUCT BY NAME tm.wc1 ON eca01
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
   #TQC-C90022--ADD--START
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(eca01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ctg01"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO eca01
                NEXT FIELD eca01
             OTHERWISE
                EXIT CASE
          END CASE
   #TQC-C90022--ADD--END--
         ON ACTION exit
             LET INT_FLAG = 1
             EXIT CONSTRUCT
     END CONSTRUCT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.wc=" 1=1 " AND tm.wc1=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm.c,tm.more         # Condition
     INPUT BY NAME tm.s_date,tm.d_date,tm.b,tm.c,tm.more WITHOUT DEFAULTS
        #report 要列印日期區間
 
        BEFORE INPUT
            IF g_sma.sma54 = 'N' OR g_sma.sma26 = '1' THEN
               LET tm.c = "N"
               CALL cl_set_comp_entry("c",FALSE)
            ELSE
               CALL cl_set_comp_entry("c",TRUE)
            END IF
 
        AFTER FIELD s_date
                      	 IF tm.s_date IS NOT NULL AND tm.d_date IS NULL THEN
                      		LET tm.d_date=tm.s_date
                      		DISPLAY tm.d_date TO d_date
                      	 END IF
        AFTER FIELD d_date
                      	 IF tm.d_date < tm.s_date THEN
                      		CALL cl_err(tm.d_date,'mfg6164',0)
                      		NEXT FIELD d_date
                      	 END IF
        AFTER FIELD b
           IF tm.b NOT MATCHES "[1234]" OR tm.b IS NULL OR tm.b = ' '
              THEN NEXT FIELD b
           END IF
 
        AFTER FIELD c
           IF tm.c NOT MATCHES "[YN]"
              THEN NEXT FIELD c
           END IF
 
        AFTER FIELD more
           LET l_direct='U'
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
 
        ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
     LET tm.wc=tm.wc clipped, " AND ",tm.wc1 CLIPPED
     IF tm.s_date IS NOT NULL
         THEN LET tm.wc=tm.wc clipped, " AND sfb15 >='",tm.s_date,"'"
     END IF
     IF tm.d_date IS NOT NULL
      #  THEN LET tm.wc=tm.wc clipped, " AND sfb15 <'",tm.d_date,"'"    #TQC-B80260  mark
         THEN LET tm.wc=tm.wc clipped, " AND sfb15 <='",tm.d_date,"'"  #TQC-B80260  modify
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfr105'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr105','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           " '",g_lang CLIPPED,"'",
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.b CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                           " '",tm.s_date CLIPPED,"'",          #TQC-610080
                           " '",tm.d_date CLIPPED,"'",          #TQC-610080
                           " '",g_rep_user CLIPPED,"'",         #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",         #No.FUN-570264
                           " '",g_template CLIPPED,"'"          #No.FUN-570264
           CALL cl_cmdat('asfr105',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW r105_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL r105()
     ERROR ""
   END WHILE
   CLOSE WINDOW r105_w
END FUNCTION
 
FUNCTION r105()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT    #TQC-630166       #No.FUN-680121 VARCHAR(1000)
#         l_sql1    LIKE type_file.chr1000,       # RDSQL STATEMENT FOR WORK CENTER #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT    #TQC-630166
          l_sql1    STRING,                       # RDSQL STATEMENT FOR WORK CENTER #TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sr  RECORD order1 LIKE ima_file.ima34,  #No.FUN-680121 VARCHAR(10)
                     sfb01 LIKE sfb_file.sfb01,   #
                     sfb02 LIKE sfb_file.sfb02,
                     sfb04 LIKE sfb_file.sfb04,
                     sfb05 LIKE sfb_file.sfb05,
                     sfb23 LIKE sfb_file.sfb23,
                     sfb40 LIKE sfb_file.sfb40,
                     sfb08 LIKE sfb_file.sfb08,
                     sfb34 LIKE sfb_file.sfb34,
                     sfb13 LIKE sfb_file.sfb13,
                     sfb15 LIKE sfb_file.sfb15,
                     sfb071 LIKE sfb_file.sfb071,
                     sfb06 LIKE sfb_file.sfb06,
                     ima55 LIKE ima_file.ima55,
                     eca02 LIKE eca_file.eca02,
                     eca03 LIKE eca_file.eca03,
                     eca04 LIKE eca_file.eca04,
                     gem02 LIKE gem_file.gem02,
                     ecm05 LIKE ecm_file.ecm05,   #機器編號
                     bza02 LIKE bza_file.bza02,   #機器名稱  #TQC-D70042 add
                     ecm301 LIKE ecm_file.ecm301,   #(dec.)
                     ecm311 LIKE ecm_file.ecm311,   #(dec.)
                     ecm313 LIKE ecm_file.ecm313,   #(dec.)
                     ecb03 LIKE ecb_file.ecb03,   #operation seq.(sint.)
                     ecb06 LIKE ecb_file.ecb06,   #operation no.
                     ecb17 LIKE ecb_file.ecb17,   #作業說明  #TQC-D70042 add
                     ecb08 LIKE ecb_file.ecb08,   #work center.
                     takhur LIKE ecm_file.ecm20,          #No.FUN-680121 DECIMAL(7,2)#尚需工時
                     srtdt  LIKE type_file.dat,           #No.FUN-680121 DATE# start date
                     duedt  LIKE type_file.dat,           #No.FUN-680121 DATE# due date
                     esrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest start date
                     lsrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#lastest start date
                     eduedt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest due date
                     lduedt LIKE type_file.dat,           #No.FUN-680121 DATE#endlest due date
                     flt    LIKE ima_file.ima59,          #No.FUN-680121 DEC(12,3)#fixed lead time
                     ult    LIKE ima_file.ima59           #No.FUN-680121 DEC(12,3)#unit  lead time
              END RECORD,
        i               LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        j               LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        ss              LIKE type_file.num5,          #No.FUN-680121 SMALLINT#status code
        l_s1            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        g_pdate         LIKE type_file.dat,           #No.FUN-680121 DATE# Print date
        l_center_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#work center chech switch
        g_towhom        LIKE oea_file.oea01           #No.FUN-680121 VARCHAR(15)# To Whom
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr105'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT UNIQUE '',",
                 " sfb01, sfb02, sfb04, sfb05, sfb23, sfb40,",
                 " sfb08, sfb34, sfb13, sfb15, sfb071,sfb06,",
                 " '','','','','','','',0,0,0,0,'',ecb17,'',0,'','','','','','',0,0",   #TQC-D70042 add '',ecb17
                 "  FROM sfb_file, ecb_file,eca_file",
                 " WHERE ecb01 = sfb05",
                 "   AND ecb02 = sfb06",
                 "   AND ecb08 = eca01",
                 "   AND sfbacti IN ('Y','y')",
                 "   AND sfb04 IN ('2','3','4','5','6','7')",
                 "   AND ",tm.wc  CLIPPED
 
     #work  center must reselect
     LET l_sql1= " SELECT eca01 FROM eca_file ",
                 " WHERE ", tm.wc1 CLIPPED
     PREPARE r105_p2 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare(eca):',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r105_center_cs CURSOR FOR r105_p2
 
     PREPARE r105_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r105_c1 CURSOR FOR r105_p1
 
#    LET l_name = 'asfr105.out'
     CALL cl_outnam('asfr105') RETURNING l_name
     START REPORT r105_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r105_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       CASE WHEN tm.b = '1' LET sr.order1 = sr.sfb40
            WHEN tm.b = '2' LET sr.order1 = sr.sfb13
            WHEN tm.b = '3' LET sr.order1 = sr.sfb15
            WHEN tm.b = '4' LET sr.order1 = sr.sfb34
            OTHERWISE LET sr.order1 = '-'
       END CASE
       SELECT ima55 INTO sr.ima55
          FROM ima_file
          WHERE ima01 = sr.sfb05
       IF SQLCA.sqlcode != 0 THEN
          LET sr.ima55 = ' '
       END IF
       CALL s_taskdat(0,sr.sfb13,sr.sfb15,sr.sfb071,
                      sr.sfb01,sr.sfb06,sr.sfb02,sr.sfb05,
                      sr.sfb08) RETURNING ss
       IF g_sma.sma26 != '1' THEN
          CALL s_taskhur(sr.sfb071,sr.sfb01,sr.sfb06,sr.sfb08)
                         RETURNING l_s1
       ELSE
          LET sr.takhur = 0   #尚需工時
       END IF
       LET j = 0
 
 #MOD-530102 add
       SELECT COUNT(*) INTO g_count FROM ecm_file
        WHERE ecm01=sr.sfb01
          AND ecm11=sr.sfb06
       IF cl_null(g_count) THEN LET g_count=0 END IF
##
       IF g_count  > 0 THEN
         FOR i = g_count TO 1 STEP -1
           LET j = j + 1
           LET sr.ecb08 = g_takdate[i].ecb08   #work center.
           CALL r105_center(sr.ecb08) RETURNING l_center_sw
           IF l_center_sw = 'N' THEN CONTINUE FOR END IF
           LET sr.ecb03 = g_takdate[i].ecb03   #operation seq.
           LET sr.ecb06 = g_takdate[i].ecb06   #operation no.
           LET sr.srtdt = g_takdate[i].srtdt   # start date
           LET sr.duedt = g_takdate[i].duedt   # due date
           LET sr.esrtdt= g_takdate[i].esrtdt  #earlest start date
           LET sr.lsrtdt= g_takdate[i].lsrtdt  #lastest start date
           LET sr.eduedt= g_takdate[i].eduedt  #earlest due date
           LET sr.lduedt= g_takdate[i].lduedt  #endlest due date
           LET sr.flt = g_takdate[i].flt       #fixed lead time
           LET sr.ult = g_takdate[i].ult       #unit  lead time
           LET sr.takhur= g_takhur[j].takhur   #尚需工時
 #         LET sr.takhur= 0  #尚需工時      #TQC-C90023
           IF tm.c = 'N' THEN
              IF g_sma.sma26 != '1' AND (sr.takhur <= 0 OR sr.takhur IS NULL)
                 THEN CONTINUE FOR
              END IF
           END IF
           IF g_sma.sma26 != '1' THEN      #參數設定:(1)不產生製程追蹤
              SELECT ecm05,(ecm301+ecm302),(ecm311+ecm312+ecm314),ecm313
                 INTO sr.ecm05,sr.ecm301,sr.ecm311,sr.ecm313
                 FROM ecm_file
                 WHERE ecm01 = sr.sfb01 AND ecm03 = sr.ecb03 AND
                       ecm11 = sr.sfb06
              IF SQLCA.sqlcode != 0 THEN
                 LET sr.ecm05 = ' '
                 LET sr.ecm301 = 0
                 LET sr.ecm311 = 0
                 LET sr.ecm313 = 0
              END IF
           ELSE
               #如果有使用製程，而沒有使用製程追蹤，則會按製程資料顯示。
               SELECT UNIQUE ecb07 INTO sr.ecm05
                   FROM sfb_file, ecb_file
                   WHERE ecb01 = sr.sfb05
                     AND ecb02 = sr.sfb06
                     AND ecb03 = sr.ecb03
                     AND ecbacti IN ('Y','y')
                LET sr.ecm301 = 0
                LET sr.ecm311 = 0
                LET sr.ecm313 = 0
           END IF
           SELECT bza02 INTO sr.bza02 FROM bza_file WHERE bza01 = sr.ecm05   #TQC-D70042 add
           SELECT eca02,eca03,eca04,gem02
              INTO sr.eca02,sr.eca03,sr.eca04,sr.gem02
              FROM eca_file, OUTER gem_file
              WHERE eca01 = sr.ecb08 AND eca03 = gem_file.gem01
           IF SQLCA.sqlcode != 0 THEN
                LET sr.eca02 = ' '
                LET sr.eca03 = ' '
                LET sr.eca04 = ' '
                LET sr.gem02 = ' '
           END IF
           OUTPUT TO REPORT r105_rep(sr.*)
         END FOR
       END IF
     END FOREACH
     FINISH REPORT r105_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
FUNCTION r105_center(l_ecb08)
   DEFINE l_center_sw  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# center check switch
          l_ecb08 LIKE ecb_file.ecb08,   #work center.
          l_eca01   LIKE eca_file.eca01 # work center
 
     LET l_center_sw = 'N'
     FOREACH r105_center_cs INTO l_eca01
        IF  l_ecb08 = l_eca01 THEN
            LET l_center_sw = 'Y'
            EXIT FOREACH
            RETURN l_center_sw
        END IF
     END FOREACH
     RETURN l_center_sw
END FUNCTION
 
REPORT r105_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          sr  RECORD order1 LIKE ima_file.ima34,     #No.FUN-680121 VARCHAR(10)
                     sfb01 LIKE sfb_file.sfb01,    #
                     sfb02 LIKE sfb_file.sfb02,
                     sfb04 LIKE sfb_file.sfb04,
                     sfb05 LIKE sfb_file.sfb05,
                     sfb23 LIKE sfb_file.sfb23,
                     sfb40 LIKE sfb_file.sfb40,
                     sfb08 LIKE sfb_file.sfb08,
                     sfb34 LIKE sfb_file.sfb34,
                     sfb13 LIKE sfb_file.sfb13,
                     sfb15 LIKE sfb_file.sfb15,
                     sfb071 LIKE sfb_file.sfb071,
                     sfb06 LIKE sfb_file.sfb06,
                     ima55 LIKE ima_file.ima55,
                     eca02 LIKE eca_file.eca02,
                     eca03 LIKE eca_file.eca03,
                     eca04 LIKE eca_file.eca04,
                     gem02 LIKE gem_file.gem02,
                     ecm05 LIKE ecm_file.ecm05,
                     bza02 LIKE bza_file.bza02,     #TQC-D70042 add
                     ecm301 LIKE ecm_file.ecm301,   #(dec.)
                     ecm311 LIKE ecm_file.ecm311,   #(dec.)
                     ecm313 LIKE ecm_file.ecm313,   #(dec.)
                     ecb03 LIKE ecb_file.ecb03,   #operation seq.(sint.)
                     ecb06 LIKE ecb_file.ecb06,   #operation no.
                     ecb17 LIKE ecb_file.ecb17,     #TQC-D70042 add
                     ecb08 LIKE ecb_file.ecb08,   #work center.
                     takhur LIKE ecm_file.ecm20,          #No.FUN-680121 DECIMAL(7,2)#尚需工時
                     srtdt  LIKE type_file.dat,           #No.FUN-680121 DATE# start date
                     duedt  LIKE type_file.dat,           #No.FUN-680121 DATE# due date
                     esrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest start date
                     lsrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#lastest start date
                     eduedt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest due date
                     lduedt LIKE type_file.dat,           #No.FUN-680121 DATE#endlest due date
                     flt    LIKE ima_file.ima59,          #No.FUN-680121 DECIMAL(12,3)#fixed lead time
                     ult    LIKE ima_file.ima59           #No.FUN-680121 DECIMAL(12,3)#unit  lead time
              END RECORD,
      l_sw         LIKE type_file.chr1,                   #No.FUN-680121 VARCHAR(1)
      l_ima02      LIKE ima_file.ima02,
      l_ima021     LIKE ima_file.ima021
 
  OUTPUT
         TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.ecb08,sr.order1,sr.sfb01,sr.ecb03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      #PRINT COLUMN 57,tm.s_date USING '(YY/MM/DD','~', #FUN-570250 mark
      #                tm.d_date USING 'YY/MM/DD)' #FUN-570250 mark
      PRINT COLUMN 57,tm.s_date,'~', #FUN-570250 add
                      tm.d_date #FUN-570250 add
      PRINT ' '
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,' ',sr.ecb08,'  (';
           CASE WHEN sr.eca04 = '0' PRINT g_x[28] CLIPPED;
                WHEN sr.eca04 = '1' PRINT g_x[29] CLIPPED;
                WHEN sr.eca04 = '2' PRINT g_x[30] CLIPPED;
           END CASE
           PRINT ')',COLUMN 100,g_x[12] CLIPPED,' ',sr.eca03,' ',sr.gem02
      PRINT g_x[13] CLIPPED,' ',sr.eca02
      SKIP 1 LINE
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] ,
                     g_x[39],g_x[78],g_x[40],g_x[79],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]   #TQC-D70042 add  g_x[78] g_x[79]
      PRINTX name=H2 g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],
                     g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],g_x[61],g_x[62]
      PRINTX name=H3 g_x[63],g_x[64],g_x[65],g_x[66],g_x[67],g_x[68],g_x[69],g_x[70],
                     g_x[71],g_x[72],g_x[73],g_x[74],g_x[75],g_x[76],g_x[77]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ecb08
      IF PAGENO > 1 OR LINENO > 9
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.sfb01
      LET l_sw = 'Y'
 
   ON EVERY ROW
      IF l_sw = 'Y' THEN
         IF sr.sfb13 < g_sma.sma30 THEN
            PRINTX name=D1 COLUMN g_c[31],' *';
         ELSE
            PRINTX name=D1 COLUMN g_c[31],'  ';
         END IF
          SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
              WHERE ima01 = sr.sfb05
            PRINTX name=D1 COLUMN g_c[32],sr.sfb01,
                  COLUMN g_c[33],sr.sfb02 USING "##",
                  COLUMN g_c[34],sr.sfb04,
                  COLUMN g_c[35],sr.sfb05,
                  COLUMN g_c[36],l_ima02;
                  IF sr.sfb23 = 'Y' OR sr.sfb23 = 'y' THEN
                     PRINTX name=D1 COLUMN g_c[37],g_x[26] CLIPPED;
                  ELSE
                     PRINTX name=D1 COLUMN g_c[37],g_x[27] CLIPPED;
                  END IF
            PRINTX name=D1 COLUMN g_c[38],sr.ecb03 USING '########', #No.TQC-5C0026
                  COLUMN g_c[39],sr.ecb06,
                  COLUMN g_c[78],sr.ecb17,    #TQC-D70042 add
                  COLUMN g_c[40],sr.ecm05,
                  COLUMN g_c[79],sr.bza02,    #TQC-D70042 add
                  COLUMN g_c[41],' ',
                  COLUMN g_c[42],sr.srtdt,
                  COLUMN g_c[43],sr.duedt,
                  COLUMN g_c[44],sr.ecm301,
                  COLUMN g_c[45],sr.flt,
                  COLUMN g_c[46],sr.takhur CLIPPED
 
         PRINTX name=D2 COLUMN g_c[49],sr.sfb40 USING '####',
               COLUMN g_c[52],l_ima021,
               COLUMN g_c[53], sr.sfb08,
               COLUMN g_c[54], sr.ima55,
               COLUMN g_c[57], g_x[24] CLIPPED,
               COLUMN g_c[58], sr.esrtdt,
               COLUMN g_c[59], sr.lsrtdt,
               COLUMN g_c[60], sr.ecm311,
               COLUMN g_c[61], sr.ult CLIPPED
 
         PRINTX name=D3 COLUMN g_c[65],sr.sfb34,'%  ',
               COLUMN g_c[69],sr.sfb13,
               COLUMN g_c[70],sr.sfb15,
               COLUMN g_c[73],g_x[25] CLIPPED,
               COLUMN g_c[74],sr.eduedt,
               COLUMN g_c[75],sr.lduedt,
               COLUMN g_c[76],sr.ecm313 CLIPPED
 
         LET l_sw = 'N'
      ELSE
         PRINTX name=D1 COLUMN g_c[38],sr.ecb03 USING '########', #No.TQC-5C0026
               COLUMN g_c[39],sr.ecb06,
               COLUMN g_c[78],sr.ecb17,    #TQC-D70042 add
               COLUMN g_c[40],sr.ecm05,
               COLUMN g_c[79],sr.bza02,    #TQC-D70042 add
               COLUMN g_c[41],' ',
               COLUMN g_c[42],sr.srtdt,
               COLUMN g_c[43],sr.duedt,
               COLUMN g_c[44],sr.ecm301,
               COLUMN g_c[45],sr.flt,
               COLUMN g_c[46],sr.takhur CLIPPED
 
         PRINTX name=D2 COLUMN g_c[57], g_x[24] CLIPPED,
               COLUMN g_c[58], sr.esrtdt,
               COLUMN g_c[59], sr.lsrtdt,
               COLUMN g_c[60], sr.ecm311,
               COLUMN g_c[61],sr.ult CLIPPED
         PRINTX name=D3 COLUMN g_c[73], g_x[25] CLIPPED,
               COLUMN g_c[74], sr.eduedt,
               COLUMN g_c[75], sr.lduedt,
               COLUMN g_c[76], sr.ecm313
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb01,sfb02,sfb04,eca03,eca01,sfb05,sfb15')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
