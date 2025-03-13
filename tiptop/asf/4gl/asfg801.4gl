# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asfg801.4gl
# Desc/riptions..: 工單變更列印
# Input parameter:
# Return code....:
# Date & Author..: 2003/03/19 By Hjwang (Ref. apmr910.4gl)
# Modify.........: No.MOD-4B0278 04/11/25 By Carol 由asft801列印時應直接帶出目前的變更單據進行列印。不需讓使用者再行輸入。
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: NO.TQC-5A0038 05/10/14 By Rosayu 料件/品名/規格放大,品名規格移到下一行
# Modify.........: NO.TQC-5A0038 05/11/08 By kim 報表表頭品名往下移
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0007 06/12/11 By johnray 修改報表格式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B60002 11/07/05 By Sakura 報表改為GR呈現
# Modify.........: No.FUN-C40020 12/04/11 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/11 By yangtt GR程式優化
# Modify.........: No.FUN-C30085 12/07/03 By lixiang 修改GR顯示排序問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm        RECORD                     # Print condition RECORD
          wc        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(500)# Where condition
          a         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          b         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          more      LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
                END RECORD
 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_snb01         LIKE snb_file.snb01   #MOD-4B0278 add
DEFINE   g_snb02         LIKE snb_file.snb02   #MOD-4B0278 add
DEFINE   g_sql      STRING   #FUN-B60002 add                                                      
DEFINE   l_table    STRING   #FUN-B60002 add                  

#FUN-B60002----------add-------str
TYPE sr1_t RECORD
    snb01 LIKE snb_file.snb01,
    snb02 LIKE snb_file.snb02,
    snb022 LIKE snb_file.snb022,
    snb04 LIKE snb_file.snb04,
    snb08b LIKE snb_file.snb08b,
    snb13b LIKE snb_file.snb13b,
    snb15b LIKE snb_file.snb15b,
    snb82b LIKE snb_file.snb82b,
    snb98b LIKE snb_file.snb98b,
    snb08a LIKE snb_file.snb08a,
    snb13a LIKE snb_file.snb13a,
    snb15a LIKE snb_file.snb15a,
    snb82a LIKE snb_file.snb82a,
    snb98a LIKE snb_file.snb98a,
	sna04 LIKE sna_file.sna04,
    sna10 LIKE sna_file.sna10,
    sna50 LIKE sna_file.sna50,
    sna03b LIKE sna_file.sna03b,
    sna08b LIKE sna_file.sna08b,
    sna12b LIKE sna_file.sna12b,
    sna26b LIKE sna_file.sna26b,
    sna28b LIKE sna_file.sna28b,
    sna05b LIKE sna_file.sna05b,
    sna06b LIKE sna_file.sna06b,
    sna27b LIKE sna_file.sna27b,
    sna11b LIKE sna_file.sna11b,
    sna100b LIKE sna_file.sna100b,
    sna161b LIKE sna_file.sna161b,
    sna062b LIKE sna_file.sna062b,
    sna07b LIKE sna_file.sna07b,
    sna03a LIKE sna_file.sna03a,
    sna08a LIKE sna_file.sna08a,
    sna12a LIKE sna_file.sna12a,
    sna26a LIKE sna_file.sna26a,
    sna28a LIKE sna_file.sna28a,
    sna05a LIKE sna_file.sna05a,
    sna06a LIKE sna_file.sna06a,
    sna27a LIKE sna_file.sna27a,
    sna11a LIKE sna_file.sna11a,
    sna100a LIKE sna_file.sna100a,
    sna161a LIKE sna_file.sna161a,
    sna062a LIKE sna_file.sna062a,
    sna07a LIKE sna_file.sna07a,
    sfb02 LIKE sfb_file.sfb02,
    sfb04 LIKE sfb_file.sfb04,
    sfb05 LIKE sfb_file.sfb05,
    ima02 LIKE ima_file.ima02,       #FUN-C50003 add
    ima02_03b     LIKE ima_file.ima02,    # 變更前料號品名規格
    ima02_03a     LIKE ima_file.ima02,     # 變更後料號品名規格
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
#FUN-B60002----------add-------end
 
MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   #TQC-610080-begin
   ##MOD-4B0278 modify
   #LET g_snb01 = ARG_VAL(1)
   #LET g_snb02 = ARG_VAL(2)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(3)
   #LET g_rep_clas = ARG_VAL(4)
   #LET g_template = ARG_VAL(5)
   ##No.FUN-570264 ---end---
 
   #IF cl_null(g_snb01) THEN
   # Prog. Version..: '5.30.06-13.03.12(0,0)                 # Input print condition
   #ELSE
   #   LET tm.wc = "snb01 = '",g_snb01 CLIPPED,"' AND snb02 = ",g_snb02 CLIPPED
   #   LET tm.a = '3'
   #   LET tm.b = 'Y'
   #   LET g_rlang = g_lang
   #   CALL asfg801()                    # Read data and create out-file
   #END IF
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #TQC-610080-end

#FUN-B60002----------add-------str
LET g_sql ="snb01.snb_file.snb01,",
           "snb02.snb_file.snb02,",
           "snb022.snb_file.snb022,",
           "snb04.snb_file.snb04,",
           "snb08b.snb_file.snb08b,",
           "snb13b.snb_file.snb13b,",
           "snb15b.snb_file.snb15b,",
           "snb82b.snb_file.snb82b,",
           "snb98b.snb_file.snb98b,",
           "snb08a.snb_file.snb08a,",
           "snb13a.snb_file.snb13a,",
           "snb15a.snb_file.snb15a,",
           "snb82a.snb_file.snb82a,",
           "snb98a.snb_file.snb98a,",
           "sna04.sna_file.sna04,",
           "sna10.sna_file.sna10,",
           "sna50.sna_file.sna50,",
           "sna03b.sna_file.sna03b,",
           "sna08b.sna_file.sna08b,",
           "sna12b.sna_file.sna12b,",
           "sna26b.sna_file.sna26b,",
           "sna28b.sna_file.sna28b,",
           "sna05b.sna_file.sna05b,",
           "sna06b.sna_file.sna06b,",
           "sna27b.sna_file.sna27b,",
           "sna11b.sna_file.sna11b,",
           "sna100b.sna_file.sna100b,",
           "sna161b.sna_file.sna161b,",
           "sna062b.sna_file.sna062b,",
           "sna07b.sna_file.sna07b,",
           "sna03a.sna_file.sna03a,",
           "sna08a.sna_file.sna08a,",
           "sna12a.sna_file.sna12a,",
           "sna26a.sna_file.sna26a,",
           "sna28a.sna_file.sna28a,",
           "sna05a.sna_file.sna05a,",
           "sna06a.sna_file.sna06a,",
           "sna27a.sna_file.sna27a,",
           "sna11a.sna_file.sna11a,",
           "sna100a.sna_file.sna100a,",
           "sna161a.sna_file.sna161a,",
           "sna062a.sna_file.sna062a,",
           "sna07a.sna_file.sna07a,",
           "sfb02.sfb_file.sfb02,",
           "sfb04.sfb_file.sfb04,",
           "sfb05.sfb_file.sfb05,",
           "ima02.ima_file.ima02,",
           "ima02_03b.ima_file.ima02,",
           "ima02_03a.ima_file.ima02,",
           "sign_type.type_file.chr1,",   # No.FUN-C50003 add
           "sign_img.type_file.blob,",    # No.FUN-C50003 add
           "sign_show.type_file.chr1,",   # No.FUN-C50003 add
           "sign_str.type_file.chr1000"   # No.FUN-C50003 add
 
    LET l_table = cl_prt_temptable('asfg801',g_sql) CLIPPED # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                # Temp Table產生

    IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
        THEN CALL g801_tm(0,0)              # Input print condition
        ELSE CALL asfg801()                 # Read data and create out-file
    END IF
#FUN-B60002----------add-------end
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   CALL cl_gre_drop_temptable(l_table)  #FUN-B60002 add
END MAIN
 
# Description: 讀入批次執行條件
FUNCTION g801_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
    DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW g801_w AT p_row,p_col WITH FORM "asf/42f/asfg801"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('p')
 
#   INITIALIZE tm.* TO NULL			# Default condition
    LET g_pdate   = g_today
    LET g_rlang   = g_lang
    LET g_bgjob   = 'N'
    LET g_copies  = '1'
    LET tm.a      = '1'
    LET tm.b      = 'N'
    LET tm.more   = 'N'
 
    WHILE TRUE
        CONSTRUCT BY NAME tm.wc ON snb01,snb022,snb02
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
           CLOSE WINDOW g801_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
        END IF
 
        IF tm.wc=" 1=1 " THEN
           CALL cl_err(' ','9046',0)
           CONTINUE WHILE
        END IF
 
        # Condition
        DISPLAY BY NAME tm.a,tm.b,tm.more
 
        INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
           AFTER FIELD a
              IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL
                 THEN NEXT FIELD a
              END IF
 
           AFTER FIELD b
              IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
                 THEN NEXT FIELD b
              END IF
 
           AFTER FIELD more
              IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
                 THEN NEXT FIELD more
              END IF
              IF tm.more = 'Y' THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
              END IF
 
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
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
 
        END INPUT
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW g801_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
        END IF
 
        IF g_bgjob = 'Y' THEN
 
            #get exec cmd (fglgo xxxx)
            SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='asfg801'
 
            IF SQLCA.sqlcode OR l_cmd IS NULL THEN
                CALL cl_err('asfg801','9031',1)
            ELSE
                # time fglgo xxxx p1 p2 p3
                LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
 
                LET l_cmd = l_cmd CLIPPED
                           ," '",g_pdate  CLIPPED,"'"
                           ," '",g_towhom CLIPPED,"'"
                           ," '",g_lang   CLIPPED,"'"
                           ," '",g_bgjob  CLIPPED,"'"
                           ," '",g_prtway CLIPPED,"'"
                           ," '",g_copies CLIPPED,"'"
                           ," '",tm.wc    CLIPPED,"'"
                           ," '",tm.b     CLIPPED,"'"
                           ," '",tm.a     CLIPPED,"'"
                          ," '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'"            #No.FUN-570264
 
                # Execute cmd at later time
                CALL cl_cmdat('asfg801',g_time,l_cmd)
            END IF
 
            CLOSE WINDOW g801_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
        END IF
 
        CALL cl_wait()
        CALL asfg801()
        ERROR ""
 
    END WHILE
    CLOSE WINDOW g801_w
 
END FUNCTION
 
FUNCTION asfg801()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
   DEFINE l_name	LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0090
   DEFINE l_sql 	LIKE type_file.chr1000       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
   DEFINE l_chr		LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE l_za05	LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(40)
 
   DEFINE sr1   RECORD  LIKE snb_file.*,
          sr2   RECORD  LIKE sna_file.*,
          sr3   RECORD
          sfb02         LIKE sfb_file.sfb02,    # 工單型態
          sfb04         LIKE sfb_file.sfb04,    # 工單狀態
          sfb05         LIKE sfb_file.sfb05,    # 料件編號
          ima02         LIKE ima_file.ima02,    # 品名規格
          ima02_03b     LIKE ima_file.ima02,    # 變更前料號品名規格
          ima02_03a     LIKE ima_file.ima02     # 變更後料號品名規格
          END RECORD
   DEFINE        l_ima02_03b  LIKE ima_file.ima02,    # 變更前料號品名規格
                 l_ima02_03a  LIKE ima_file.ima02    # 變更後料號品名規格
 
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#FUN-B60002----------mark str
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfg801'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#FUN-B60002----------mark end     
 
     #只能使用自己的資料
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc clipped," AND pnauser = '",g_user,"'"
     #     END IF
 
     #只能使用相同群的資料
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc clipped," AND pnagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pnagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')
     #End:FUN-980030
 
 
     LET l_sql = " SELECT snc05,snc06 FROM snc_file ",
                 "  WHERE snc01 = ? AND snc02 = ? ",
                 "  ORDER BY snc05 "
     PREPARE g801_pr2 FROM l_sql
     DECLARE g801_cs2 CURSOR FOR g801_pr2
     IF SQLCA.SQLCODE THEN
        CALL cl_err('prepare:#2',sqlca.sqlcode,1)
     END IF
 
     LET l_sql = " SELECT snb_file.*,sna_file.*,sfb02,sfb04,sfb05,ima02 ",
                #FUN-C50003----mod----str---
                # "   FROM snb_file,OUTER sna_file,sfb_file,OUTER ima_file ", #MOD-4B0278 modify
                #"  WHERE snb_file.snb01=sna_file.sna01 AND snb_file.snb02=sna_file.sna02 ",
                #"    AND snb01=sfb01 AND sfb_file.sfb05=ima_file.ima01 ",
                 "  FROM snb_file LEFT OUTER JOIN sna_file ON snb01=sna01 AND snb02=sna02,",
                 "       sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01",
                 "  WHERE snb01=sfb01 ",
                #FUN-C50003----mod----str---
                 "    AND ",tm.wc CLIPPED

#FUN-B60002----------add-------str
     IF tm.a='1' THEN 
        LET l_sql=l_sql CLIPPED,"   AND snb99 = '2'" 
     END IF
     IF tm.a='2' THEN 
        LET l_sql=l_sql CLIPPED,"   AND snb99!= '2'" 
     END IF
     LET l_sql=l_sql CLIPPED," ORDER BY snb01,snb02,sna04"
#FUN-B60002----------add-------end     
 
     PREPARE g801_pr1 FROM l_sql
 
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
 
     DECLARE g801_cs1 CURSOR FOR g801_pr1
 
#     LET l_name = 'asfg801.out'    #FUN-B60002 mark
 
#     CALL cl_outnam('asfg801') RETURNING l_name    #FUN-B60002 mark
 
#     START REPORT g801_rep TO l_name   #FUN-B60002 mark
 
#     LET g_pageno = 0

#FUN-B60002----------add-------str
     CALL cl_del_data(l_table) 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?,?,?,? ) "     # # No.FUN-C40020 add4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time#FUN-C20053
        EXIT PROGRAM
     END IF
#FUN-B60002----------add-------end
 
     FOREACH g801_cs1 INTO sr1.*,sr2.*,sr3.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time#FUN-C20053
          EXIT FOREACH
       END IF
       SELECT ima02 INTO l_ima02_03b FROM ima_file
        WHERE sr2.sna03b=ima01
       SELECT ima02 INTO l_ima02_03a FROM ima_file
        WHERE sr2.sna03a=ima01
#       OUTPUT TO REPORT g801_rep(sr1.*,sr2.*,sr3.*)    #FUN-B60002 mark

#FUN-B60002----------add-------str
       EXECUTE insert_prep USING sr1.snb01,sr1.snb02,sr1.snb022,sr1.snb04,sr1.snb08b,
                                 sr1.snb13b,sr1.snb15b,sr1.snb82b,sr1.snb98b,sr1.snb08a,
                                 sr1.snb13a,sr1.snb15a,sr1.snb82a,sr1.snb98a,sr2.sna04,
                                 sr2.sna10,sr2.sna50,sr2.sna03b,sr2.sna08b,sr2.sna12b,
                                 sr2.sna26b,sr2.sna28b,sr2.sna05b,sr2.sna06b,sr2.sna27b,
                                 sr2.sna11b,sr2.sna100b,sr2.sna161b,sr2.sna062b,sr2.sna07b,
                                 sr2.sna03a,sr2.sna08a,sr2.sna12a,sr2.sna26a,sr2.sna28a,
                                 sr2.sna05a,sr2.sna06a,sr2.sna27a,sr2.sna11a,sr2.sna100a,
                                 sr2.sna161a,sr2.sna062a,sr2.sna07a,sr3.sfb02,
                                 sr3.sfb04,sr3.sfb05,sr3.ima02,l_ima02_03b,l_ima02_03a
				 ,"",  l_img_blob,"N",""  # No.FUN-C40020 add

       LET l_ima02_03b=''
       LET l_ima02_03a=''
#FUN-B60002----------add-------end

     END FOREACH

    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "snb01|snb02"                    # No.FUN-C40020 add
     CALL asfg801_grdata()  #FUN-B60002 add 
 
#     FINISH REPORT g801_rep    #FUN-B60002 mark
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-B60002 mark



END FUNCTION
 
#No.FUN-B60002  --begin 
#REPORT g801_rep(sr1,sr2,sr3)
#   DEFINE sr1   RECORD  LIKE snb_file.*,
#          sr2   RECORD  LIKE sna_file.*,
#          sr3   RECORD
#          sfb02         LIKE sfb_file.sfb02,    # 工單型態
#          sfb04         LIKE sfb_file.sfb04,    # 工單狀態
#          sfb05         LIKE sfb_file.sfb05,    # 料件編號
#          ima02         LIKE ima_file.ima02,    # 品名規格
#          ima02_03b     LIKE ima_file.ima02,    # 變更前料號品名規格
#          ima02_03a     LIKE ima_file.ima02     # 變更後料號品名規格
#          END RECORD
#   DEFINE
#    l_snc05  LIKE snc_file.snc05,
#    l_snc06  LIKE snc_file.snc06,
#    l_swich  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#    l_str    LIKE ima_file.ima34,          #No.FUN-680121 VARCHAR(30)
#    l_last_sw LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr1.snb01,sr1.snb02,sr2.sna04
 
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
      #對外單據不需列印FROM
#No.TQC-6B0007 -- begin --
#      PRINT ' '
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#             COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED,
#             COLUMN g_len-8,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
#No.TQC-6B0007 -- end --
#      PRINT g_x[11] CLIPPED,sr1.snb04,1 SPACES;
#       CASE sr1.snb04
#            WHEN '1' LET l_str=g_x[12] CLIPPED
#            WHEN '2' LET l_str=g_x[13] CLIPPED
#       END CASE
#      PRINT l_str CLIPPED,
#            COLUMN 35,g_x[14] CLIPPED,sr1.snb022,
#            COLUMN 56,g_x[15] CLIPPED,sr1.snb02 USING '##'
#            COLUMN 88,g_x[3] CLIPPED,g_pageno USING '<<<'    #No.TQC-6B0007
#      PRINT g_dash[1,g_len]
#      PRINT g_x[16] CLIPPED,sr1.snb01
            #COLUMN 35,g_x[17] CLIPPED,sr3.sfb05 CLIPPED,1 SPACES,sr3.ima02 #TQC-5A0038 mark
#      PRINT g_x[17] CLIPPED,sr3.sfb05 CLIPPED #TQC-5A0038 add
#      PRINT g_x[62] CLIPPED,sr3.ima02  #TQC-5A0038 add
#      PRINT g_x[18] CLIPPED,sr3.sfb02 USING '##',1 SPACES;
#       CASE sr3.sfb02
#            WHEN '1' LET l_str=g_x[20] CLIPPED
#            WHEN '5' LET l_str=g_x[21] CLIPPED
#            WHEN '7' LET l_str=g_x[22] CLIPPED
#            WHEN '8' LET l_str=g_x[23] CLIPPED
#            WHEN '11' LET l_str=g_x[24] CLIPPED
#            WHEN '13' LET l_str=g_x[25] CLIPPED
#            WHEN '15' LET l_str=g_x[26] CLIPPED
#       END CASE
#      PRINT l_str CLIPPED,
#            COLUMN 35,g_x[19] CLIPPED,sr3.sfb04,1 SPACES;
#       CASE sr3.sfb04
#            WHEN '1' LET l_str=g_x[27] CLIPPED
#            WHEN '2' LET l_str=g_x[28] CLIPPED
#            WHEN '3' LET l_str=g_x[29] CLIPPED
#            WHEN '4' LET l_str=g_x[30] CLIPPED
#            WHEN '5' LET l_str=g_x[31] CLIPPED
#            WHEN '6' LET l_str=g_x[32] CLIPPED
#            WHEN '7' LET l_str=g_x[33] CLIPPED
#            WHEN '8' LET l_str=g_x[34] CLIPPED
#       END CASE
#      PRINT l_str CLIPPED
#      PRINT ' '
#   IF sr1.snb04='2' THEN
#      SKIP 5 LINES
#   ELSE
#      PRINT g_x[35] CLIPPED,cl_numfor(sr1.snb08b,14,3),
#            COLUMN 35,g_x[36] CLIPPED,sr1.snb13b,
#            COLUMN 56,g_x[37] CLIPPED,sr1.snb15b
#      PRINT g_x[38] CLIPPED,
#            COLUMN 17,cl_numfor(sr1.snb08a,14,3) CLIPPED,
#            COLUMN 44,sr1.snb13a,
#            COLUMN 65,sr1.snb15a
#      PRINT ' '
#      PRINT g_x[39] CLIPPED,
#            COLUMN 22,sr1.snb82b,
#            COLUMN 35,g_x[40] CLIPPED,sr1.snb98b
#      PRINT g_x[38] CLIPPED,
#            COLUMN 22,sr1.snb82a,
#            COLUMN 44,sr1.snb98a
#   END IF
#      PRINT g_x[53] CLIPPED,g_x[53] CLIPPED,g_x[61] CLIPPED
 
#   IF sr1.snb04='1' AND (sr2.sna10!='4' OR (sr2.sna10='4' AND tm.b='N'))  THEN
#      SKIP 2LINE
#   ELSE
#      PRINT g_x[41],g_x[42],g_x[58] CLIPPED
#      PRINT g_x[43],g_x[44],g_x[59] CLIPPED
#   END IF
#   LET l_last_sw = 'n'           #FUN-550124
 
#BEFORE GROUP OF sr1.snb01
#   IF PAGENO > 1 OR LINENO > 9 THEN
#      SKIP TO TOP OF PAGE
#   END IF
#BEFORE GROUP OF sr1.snb02
#   IF PAGENO > 1 OR LINENO > 9 THEN
#      SKIP TO TOP OF PAGE
#   END IF
#ON EVERY ROW
#   IF sr1.snb04='1' AND (sr2.sna10!='4' OR (sr2.sna10='4' AND tm.b='N'))  THEN
#      SKIP 9 LINE
#   ELSE
#      PRINT g_x[45],g_x[46],g_x[60] CLIPPED
#      PRINT COLUMN 03,sr2.sna04 USING '###',
#            COLUMN 10,g_x[47] CLIPPED,sr2.sna10,1 SPACES;
#       CASE sr2.sna10
#            WHEN '1' LET l_str=g_x[54] CLIPPED
#            WHEN '2' LET l_str=g_x[55] CLIPPED
#            WHEN '3' LET l_str=g_x[56] CLIPPED
#            WHEN '4' LET l_str=g_x[57] CLIPPED
#       END CASE
#      PRINT l_str CLIPPED,
#            COLUMN 47,g_x[48] CLIPPED,sr2.sna50
#      PRINT COLUMN 03,g_x[49] CLIPPED,sr2.sna03b,
#            COLUMN 31,sr2.sna08b,
#            COLUMN 44,sr2.sna12b,
#            COLUMN 49,sr2.sna26b,
#            COLUMN 58,cl_numfor(sr2.sna28b,5,3),
#            COLUMN 65,cl_numfor(sr2.sna05b,14,3),
#            COLUMN 81,cl_numfor(sr2.sna06b,14,3)
#      PRINT COLUMN 10,sr2.sna27b,
#            COLUMN 39,sr2.sna11b,
#            COLUMN 41,cl_numfor(sr2.sna100b,5,3),
#            COLUMN 49,cl_numfor(sr2.sna161b,14,3),
#            COLUMN 65,cl_numfor(sr2.sna062b,14,3),
#            COLUMN 81,cl_numfor(sr2.sna07b,14,3)
#      PRINT COLUMN 10,sr3.ima02_03b
#      PRINT COLUMN 03,g_x[50] CLIPPED,sr2.sna03a,
#            COLUMN 31,sr2.sna08a,
#            COLUMN 44,sr2.sna12a,
#            COLUMN 49,sr2.sna26a,
#            COLUMN 58,cl_numfor(sr2.sna28a,5,3),
#            COLUMN 65,cl_numfor(sr2.sna05a,14,3),
#            COLUMN 81,cl_numfor(sr2.sna06a,14,3)
#      PRINT COLUMN 10,sr2.sna27a,
#            COLUMN 39,sr2.sna11a,
#            COLUMN 41,cl_numfor(sr2.sna100a,5,3),
#            COLUMN 49,cl_numfor(sr2.sna161a,14,3),
#            COLUMN 65,cl_numfor(sr2.sna062a,14,3),
#            COLUMN 81,cl_numfor(sr2.sna07a,14,3)
#      PRINT COLUMN 10,sr3.ima02_03a
#   END IF
 
#AFTER GROUP OF sr1.snb02
#   LET l_swich=1
#   LET l_snc05=0
#   LET l_snc06=' '
#   SKIP 1 LINE
#   FOREACH g801_cs2 USING sr1.snb01,sr1.snb02
#     INTO l_snc05,l_snc06
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED     
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED     
#      END IF                                                                    
#No.TQC-6B0007 -- end --
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[51]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[51]
#             PRINT g_memo
#      END IF
## END FUN-550124
 
#END REPORT
 
#Patch....NO.TQC-610037 <001> #
#No.FUN-B60002  --end

#FUN-B60002------add-------str----------
FUNCTION asfg801_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C50003 add
    CALL cl_gre_init_apr()             # No.FUN-C50003 add

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asfg801")
        IF handler IS NOT NULL THEN
            START REPORT asfg801_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY snb01 "   #FUN-C30085 add 
            DECLARE asfg801_datacur1 CURSOR FROM l_sql
            FOREACH asfg801_datacur1 INTO sr1.*
                OUTPUT TO REPORT asfg801_rep(sr1.*)
            END FOREACH
            FINISH REPORT asfg801_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg801_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sfb02_desc    STRING
    DEFINE l_option        STRING
    DEFINE l_option1       STRING
    DEFINE l_sfb04_desc    STRING
    DEFINE l_option2       STRING
    DEFINE l_option3       STRING
    DEFINE l_sna10_desc    STRING
    DEFINE l_option4       STRING
    DEFINE l_snb04_desc    STRING
    DEFINE l_option7       STRING
    DEFINE l_sql           STRING
    DEFINE l_snb_show      STRING
    DEFINE l_display   LIKE type_file.chr1
    
    ORDER EXTERNAL BY sr1.snb01,sr1.snb02,sr1.sna04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime    #FUN-C50003 add g_user_name,g_ptime
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.snb01
            IF sr1.snb04 = '1' AND sr1.sna10 != '4' OR sr1.sna10 = '4' AND tm.b = 'N' THEN
               LET l_display = 'N'
            ELSE 
               LET l_display = 'Y'
            END IF
            PRINTX l_display

                                             
            LET l_option7 = cl_gr_getmsg("gre-078",g_lang,sr1.snb04)
            LET l_snb04_desc = sr1.snb04,' ',l_option7
            PRINTX l_snb04_desc
 
            LET l_option2 = sr1.sfb04 USING '--,---,---,---,---,--&'
            LET l_option3 = cl_gr_getmsg("gre-065",g_lang,sr1.sfb04)
            LET l_sfb04_desc = l_option2,' ',l_option3
            PRINTX l_sfb04_desc

            LET l_option = sr1.sfb02 USING '--,---,---,---,---,--&'
            LET l_option1 = cl_gr_getmsg("gre-064",g_lang,sr1.sfb02)
            LET l_sfb02_desc = l_option,' ',l_option1
            PRINTX l_sfb02_desc

            IF sr1.snb04 = '2' THEN
                LET l_snb_show = 'N'
            ELSE 
                LET l_snb_show = 'Y'
            END IF
            PRINTX l_snb_show
            

            LET l_lineno = 0
        BEFORE GROUP OF sr1.snb02
        BEFORE GROUP OF sr1.sna04



            LET l_option4 = cl_gr_getmsg("gre-077",g_lang,sr1.sna10) 
            LET l_sna10_desc = sr1.sna10,' ',l_option4
            PRINTX l_sna10_desc


        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.snb01
        AFTER GROUP OF sr1.snb02
        AFTER GROUP OF sr1.sna04

        
        ON LAST ROW

END REPORT
#FUN-B60002------add-------end----------
