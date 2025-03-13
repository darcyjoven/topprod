# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asfr110.4gl
# Descriptions...: 工單派工單
# Date & Author..: 92/08/17 By yen
#        Modify  : 92/11/23 By David
#                : Add Push & Non-Tracking
# Modify.........: No.FUN-4A0007 04/10/05 By Yuna 單號.料件要開窗
# Modify.........: No.MOD-530103 05/03/15 By Carol 程式中應加上工單是否走製程的判斷
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modfiy.........: No.FUN-590110 05/09/28 By jackie 報表轉XML
# Modify.........: NO.FUN-5B0015 05/11/01 BY Yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-970054 09/07/14 By mike 在UI畫面的QBE中加上"開單日期"(sfb81)與"預計開工日期"(sfb13)兩欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-D50050 13/07/18 By yangtt 1."工單狀態"位增加開窗   2.單身增加"品名"和"規格"欄位顯示
#                                                   3.單身抓取"類型"和"狀態"的說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#             wc      VARCHAR(600),    # Where condition  #TQC-630166
              wc      STRING,       # Where condition  #TQC-630166
              s_date  LIKE type_file.dat,           #No.FUN-680121 DATE
              d_date  LIKE type_file.dat,           #No.FUN-680121 DATE
              b       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# sort type
              d       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              c       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# include done workstation
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
          g_tot_bal   LIKE ccq_file.ccq03           #No.FUN-680121 DECIMAL(13,2)# User defined variable
 
DEFINE   g_count      LIKE type_file.num5           #No.FUN-680121 SMALLINT  
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose        #No.FUN-680121 SMALLINT
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
   #TQC-610080-begin
   LET tm.s_date  = ARG_VAL(8)
   LET tm.d_date  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #LET tm.b  = ARG_VAL(8)
   #LET tm.c  = ARG_VAL(10)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(11)
   #LET g_rep_clas = ARG_VAL(12)
   #LET g_template = ARG_VAL(13)
   ##No.FUN-570264 ---end---
   #LET tm.d  = ARG_VAL(9)
   #TQC-610080-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r110_tm(0,0)        # Input print condition
      ELSE CALL r110()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_direct       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW r110_w AT p_row,p_col WITH FORM "asf/42f/asfr110"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = '1'
   LET tm.s_date = g_today
   LET tm.d_date = g_today
   LET tm.c    = 'N'
   LET tm.d    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     CLEAR FORM
     CONSTRUCT BY NAME tm.wc ON sfb02,sfb04,sfb01,sfb05,sfb81,sfb13 #FUN-970054 add sfb81 sfb13
       #--No.FUN-4A0007--------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP
          CASE WHEN INFIELD(sfb05) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima"
        	  CALL cl_create_qry() RETURNING g_qryparam.multiret
       	          DISPLAY g_qryparam.multiret TO sfb05
       	          NEXT FIELD sfb05
                WHEN INFIELD(sfb01) #訂單單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_sfb3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
              #No.TQC-D50050 ---Add--- Start
               WHEN INFIELD(sfb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_sfb041"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb04
                  NEXT FIELD sfb04
              #No.TQC-D50050 ---Add--- End
 
          OTHERWISE EXIT CASE
          END CASE
       #--END---------------
 
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
        EXIT WHILE
     END IF
 
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm.d,tm.c,tm.more         # Condition
     INPUT BY NAME tm.s_date,tm.d_date,tm.b,tm.d,tm.c,tm.more WITHOUT DEFAULTS
        #report 要列印日期區間
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD s_date
           IF cl_null(tm.s_date) THEN
              NEXT FIELD s_date
           ELSE
              IF cl_null(tm.d_date) THEN
                 LET tm.d_date=tm.s_date
                 DISPLAY tm.d_date TO d_date
              END IF
           END IF
        AFTER FIELD d_date
           IF cl_null(tm.d_date) THEN
              NEXT FIELD d_date
           ELSE
              IF tm.d_date < tm.s_date THEN
                 CALL cl_err(tm.d_date,'mfg6164',0)
                 NEXT FIELD d_date
              END IF
           END IF
           IF tm.d_date - tm.s_date > 500 THEN
              CALL cl_err('','mfg0155',1)
              NEXT FIELD d_date
           END IF
        AFTER FIELD b
           IF tm.b NOT MATCHES "[1234]" OR tm.b IS NULL OR tm.b = ' '
              THEN NEXT FIELD b
           END IF
           LET l_direct='D'
        BEFORE FIELD c
           IF g_sma.sma54 = 'N' OR g_sma.sma26 = '1' THEN
              LET tm.c = 'N'
              DISPLAY tm.c TO c
              IF l_direct = 'D' THEN
                 NEXT FIELD more
              ELSE NEXT FIELD b
              END IF
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF tm.s_date IS NOT NULL
         THEN LET tm.wc=tm.wc clipped, " AND sfb15 >='",tm.s_date,"'"
     END IF
 
     IF tm.d_date IS NOT NULL
         THEN LET tm.wc=tm.wc clipped, " AND sfb15 <='",tm.d_date,"'"
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfr110'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr110','9031',1)
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
                           " '",tm.s_date CLIPPED,"'",          #TQC-610080 
                           " '",tm.d_date CLIPPED,"'",          #TQC-610080
                           " '",tm.b CLIPPED,"'",
                           " '",tm.d CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
           CALL cl_cmdat('asfr110',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW r110_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL r110()
     ERROR ""
 
   END WHILE
   CLOSE WINDOW r110_w
 
END FUNCTION
 
FUNCTION r110()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166        #No.FUN-680121 VARCHAR(1100)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sr  RECORD order1 LIKE ima_file.ima34,  #No.FUN-680121 VARCHAR(10)
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
                     sfb24 LIKE sfb_file.sfb93,
                     ima55 LIKE ima_file.ima55,
                     eca02 LIKE eca_file.eca02,
                     eca03 LIKE eca_file.eca03,
                     eca04 LIKE eca_file.eca04,
                     gem02 LIKE gem_file.gem02,
                     ecm301 LIKE ecm_file.ecm301,   #(dec.)
                     ecm311 LIKE ecm_file.ecm311,   #(dec.)
                     ecm313 LIKE ecm_file.ecm313,   #(dec.)
                     ecb03 LIKE ecb_file.ecb03,   #operation seq.(sint.)
                     ecb06 LIKE ecb_file.ecb06,   #operation no.
                     ecb08 LIKE ecb_file.ecb08,   #work center.
                     takhur LIKE ecm_file.ecm20,          #No.FUN-680121 DECIMAL(7,2)#尚需工時
                     srtdt  LIKE type_file.dat,           #No.FUN-680121 DATE# start date
                     duedt  LIKE type_file.dat,           #No.FUN-680121 DATE# due date
                     esrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest start date
                     lsrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#lastest start date
                     eduedt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest due date
                     lduedt LIKE type_file.dat,           #No.FUN-680121 DATE#endlest due date
                     flt    LIKE ima_file.ima59,          #No.FUN-680121 DECIMAL(12,3)#fixed lead time
                     ult    LIKE ima_file.ima59,          #No.FUN-680121 DECIMAL(12,3)#unit  lead time
                     alot   INTEGER                       #No.FUN-680121 DECIMAL(16,6)#part's lead time
              END RECORD,
        i               LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        j               LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        ss              LIKE type_file.num5,          #No.FUN-680121 SMALLINT#status code
        l_s1            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        g_pdate         LIKE type_file.dat,           #No.FUN-680121 DATE# Print date
        g_towhom        LIKE oea_file.oea01           #No.FUN-680121 VARCHAR(15)# To Whom
       ,l_ecb012        LIKE ecb_file.ecb012          #No.FUN-A60027
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
     #No.B533 010516 BY ANN CHEN
     #IF g_sma.sma54 = 'N' OR g_sma.sma26 = '1' THEN
     IF tm.d='N' THEN
     LET l_sql = "SELECT UNIQUE '',",
                 " sfb01, sfb02, sfb04, sfb05, sfb23, sfb40,",
                 " sfb08, sfb34, sfb13, sfb15, sfb071,sfb06,",
                 " '','','','','','',0,0,0,0,'','',0,'','','','','','',0,0,0",
                 "  FROM sfb_file ",
                 "   WHERE sfbacti IN ('Y','y')",
                 "   AND sfb04 IN ('2','3','4','5','6','7')",
                 "   AND ",tm.wc  CLIPPED
     ELSE
     LET l_sql = "SELECT UNIQUE '',",
                 " sfb01, sfb02, sfb04, sfb05, sfb23, sfb40,",
                 " sfb08, sfb34, sfb13, sfb15, sfb071,sfb06,sfb24,",
                 " '','','','','','',0,0,0,0,'','',0,'','','','','','',0,0,0",
                 "  FROM sfb_file, OUTER(ecb_file, eca_file) ",
                 " WHERE ecb_file.ecb01 = sfb05",
                 "   AND ecb_file.ecb02 = sfb06",
                 "   AND ecb_file.ecb08 = eca_file.eca01",
                 "   AND sfbacti IN ('Y','y')",
                 "   AND sfb04 IN ('2','3','4','5','6','7')",
                 "   AND ",tm.wc  CLIPPED
     END IF
 
     PREPARE r110_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
     DECLARE r110_c1 CURSOR FOR r110_p1
 
#    LET l_name = 'asfr110.out'
#No.FUN-590110 --start--
     CALL cl_outnam('asfr110') RETURNING l_name
     IF tm.d='N' THEN
        LET g_zaa[41].zaa06='N'
        LET g_zaa[42].zaa06='N'
        LET g_zaa[43].zaa06='N'
        LET g_zaa[44].zaa06='N'
        LET g_zaa[45].zaa06='N'
        LET g_zaa[46].zaa06='N'
        LET g_zaa[47].zaa06='N'
        LET g_zaa[48].zaa06='N'
        LET g_zaa[49].zaa06='N'
        LET g_zaa[50].zaa06='N'
        LET g_zaa[51].zaa06='N'
        LET g_zaa[52].zaa06='N'
        LET g_zaa[53].zaa06='N'
        LET g_zaa[54].zaa06='N'
 
        LET g_zaa[55].zaa06='Y'
        LET g_zaa[56].zaa06='Y'
        LET g_zaa[57].zaa06='Y'
        LET g_zaa[58].zaa06='Y'
        LET g_zaa[59].zaa06='Y'
        LET g_zaa[60].zaa06='Y'
        LET g_zaa[61].zaa06='Y'
        LET g_zaa[62].zaa06='Y'
        LET g_zaa[63].zaa06='Y'
        LET g_zaa[64].zaa06='Y'
        LET g_zaa[65].zaa06='Y'
        LET g_zaa[66].zaa06='Y'
        LET g_zaa[67].zaa06='Y'
        LET g_zaa[69].zaa06='Y'
        LET g_zaa[71].zaa06='Y'
        LET g_zaa[72].zaa06='Y'
        LET g_zaa[73].zaa06='Y'
        LET g_zaa[74].zaa06='Y'
        LET g_zaa[75].zaa06='Y'
        LET g_zaa[76].zaa06='Y'
        LET g_zaa[77].zaa06='Y'
        LET g_zaa[78].zaa06='Y'
        LET g_zaa[80].zaa06='Y'
        LET g_zaa[81].zaa06='Y'
        LET g_zaa[82].zaa06='Y'
        LET g_zaa[83].zaa06='Y'
        LET g_zaa[84].zaa06='Y'
        LET g_zaa[85].zaa06='Y'
        LET g_zaa[86].zaa06='Y'
        LET g_zaa[87].zaa06='Y'
        LET g_zaa[88].zaa06='Y'
        LET g_zaa[68].zaa06='Y'
        LET g_zaa[70].zaa06='Y'
        LET g_zaa[79].zaa06='Y'
        LET g_zaa[89].zaa06='Y'
       #No.TQC-D50050 ---Add--- Start
        LET g_zaa[90].zaa06='N'
        LET g_zaa[91].zaa06='N'
        LET g_zaa[92].zaa06='Y'
        LET g_zaa[93].zaa06='Y'
       #No.TQC-D50050 ---Add--- End
    ELSE
        LET g_zaa[41].zaa06='Y'
        LET g_zaa[42].zaa06='Y'
        LET g_zaa[43].zaa06='Y'
        LET g_zaa[44].zaa06='Y'
        LET g_zaa[45].zaa06='Y'
        LET g_zaa[46].zaa06='Y'
        LET g_zaa[47].zaa06='Y'
        LET g_zaa[48].zaa06='Y'
        LET g_zaa[49].zaa06='Y'
        LET g_zaa[50].zaa06='Y'
        LET g_zaa[51].zaa06='Y'
        LET g_zaa[52].zaa06='Y'
        LET g_zaa[53].zaa06='Y'
        LET g_zaa[54].zaa06='Y'
 
        LET g_zaa[55].zaa06='N'
        LET g_zaa[56].zaa06='N'
        LET g_zaa[57].zaa06='N'
        LET g_zaa[58].zaa06='N'
        LET g_zaa[59].zaa06='N'
        LET g_zaa[60].zaa06='N'
        LET g_zaa[61].zaa06='N'
        LET g_zaa[62].zaa06='N'
        LET g_zaa[63].zaa06='N'
        LET g_zaa[64].zaa06='N'
        LET g_zaa[65].zaa06='N'
        LET g_zaa[66].zaa06='N'
        LET g_zaa[67].zaa06='N'
        LET g_zaa[69].zaa06='N'
        LET g_zaa[71].zaa06='N'
        LET g_zaa[72].zaa06='N'
        LET g_zaa[73].zaa06='N'
        LET g_zaa[74].zaa06='N'
        LET g_zaa[75].zaa06='N'
        LET g_zaa[76].zaa06='N'
        LET g_zaa[77].zaa06='N'
        LET g_zaa[78].zaa06='N'
        LET g_zaa[80].zaa06='N'
        LET g_zaa[81].zaa06='N'
        LET g_zaa[82].zaa06='N'
        LET g_zaa[83].zaa06='N'
        LET g_zaa[84].zaa06='N'
        LET g_zaa[85].zaa06='N'
        LET g_zaa[86].zaa06='N'
        LET g_zaa[87].zaa06='N'
        LET g_zaa[88].zaa06='N'
      IF g_sma.sma26='1' THEN
        LET g_zaa[68].zaa06='Y'
        LET g_zaa[70].zaa06='Y'
        LET g_zaa[79].zaa06='Y'
        LET g_zaa[89].zaa06='Y'
      ELSE
        LET g_zaa[68].zaa06='N'
        LET g_zaa[70].zaa06='N'
        LET g_zaa[79].zaa06='N'
        LET g_zaa[89].zaa06='N'
      END IF
       #No.TQC-D50050 ---Add--- Start
        LET g_zaa[90].zaa06='Y'
        LET g_zaa[91].zaa06='Y'
        LET g_zaa[92].zaa06='N'
        LET g_zaa[93].zaa06='N'
       #No.TQC-D50050 ---Add--- End
    END IF
    CALL cl_prt_pos_len()
    START REPORT r110_rep TO l_name
#No.FUN-590110 --end--
     #今天 - 30 再將工作日置入 array 中以備 s_ofday(起日,止日)算工作日
     CALL s_filldate()
     LET g_pageno = 0
     FOREACH r110_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       CASE WHEN tm.b = '1' LET sr.order1 = sr.sfb40
            WHEN tm.b = '2' LET sr.order1 = sr.sfb13
            WHEN tm.b = '3' LET sr.order1 = sr.sfb15
            WHEN tm.b = '4' LET sr.order1 = sr.sfb34
            OTHERWISE LET sr.order1 = '-'
       END CASE
       #計算工作日
       CALL s_ofday(g_sma.sma30,sr.sfb15) RETURNING sr.alot
       #不含今天
       IF sr.alot IS NULL THEN LET sr.alot=0 END IF
       IF sr.alot >0 THEN LET sr.alot=sr.alot-1 END IF
       SELECT ima55 INTO sr.ima55
          FROM ima_file
          WHERE ima01 = sr.sfb05
       IF SQLCA.sqlcode != 0 THEN
          LET sr.ima55 = ' '
       END IF
       #不產生製程
       #IF g_sma.sma54 = 'N'   THEN
       IF tm.d='N' THEN
           OUTPUT TO REPORT r110_rep(sr.*)
           CONTINUE FOREACH
       END IF
       CALL s_taskdat(0,sr.sfb13,sr.sfb15,sr.sfb071,
                      sr.sfb01,sr.sfb06,sr.sfb02,sr.sfb05,
                      sr.sfb08) RETURNING ss
       IF g_sma.sma26 != '1' THEN
          CALL s_taskhur(sr.sfb071,sr.sfb01,sr.sfb06,sr.sfb08)
                         RETURNING l_s1
       ELSE
         FOR i = 1 TO g_count
             LET g_takhur[i].takhur = 0   #尚需工時
         END FOR
       END IF
       LET j = 0
 
 #MOD-530103
       SELECT COUNT(*) INTO g_count FROM ecm_file
        WHERE ecm01=sr.sfb01
          AND ecm11=sr.sfb06
       IF cl_null(g_count) THEN LET g_count=0 END IF
##
       IF g_count  > 0 THEN
         FOR i = g_count TO 1 STEP -1
           LET j = j + 1
           LET sr.ecb08 = g_takdate[i].ecb08   #work center.
           LET sr.ecb03 = g_takdate[i].ecb03   #operation seq.
           LET sr.ecb06 = g_takdate[i].ecb06   #operation no.
           LET l_ecb012 = g_takdate[i].ecb012  #process session no FUN-A60027 
           LET sr.srtdt = g_takdate[i].srtdt   # start date
           LET sr.duedt = g_takdate[i].duedt   # due date
           LET sr.esrtdt= g_takdate[i].esrtdt  #earlest start date
           LET sr.lsrtdt= g_takdate[i].lsrtdt  #lastest start date
           LET sr.eduedt= g_takdate[i].eduedt  #earlest due date
           LET sr.lduedt= g_takdate[i].lduedt  #endlest due date
           LET sr.flt = g_takdate[i].flt       #fixed lead time
           LET sr.ult = g_takdate[i].ult       #unit  lead time
           LET sr.takhur= g_takhur[j].takhur   #尚需工時
           #No.B533 010516 BY ANN CHEN
           IF tm.c = 'N' THEN
              #IF g_sma.sma26 != '1' AND (sr.takhur <= 0 OR sr.takhur IS NULL)
              IF g_sma.sma26 != '1' AND (sr.takhur < 0 OR sr.takhur IS NULL)
                 THEN CONTINUE FOR
              END IF
           END IF
           IF g_sma.sma26 != '1' THEN      #參數設定:(1)不產生製程追蹤
              SELECT (ecm301+ecm302),(ecm311+ecm312+ecm314),ecm313
                 INTO sr.ecm301,sr.ecm311,sr.ecm313
                 FROM ecm_file
                 WHERE ecm01 = sr.sfb01 AND ecm03 = sr.ecb03 AND
                       ecm11 = sr.sfb06 AND ecm012 = l_ecb012   #FUN-A60027 add l_ecm012 
              IF SQLCA.sqlcode != 0 THEN
                 LET sr.ecm301 = 0
                 LET sr.ecm311 = 0
                 LET sr.ecm313 = 0
              END IF
           ELSE
                LET sr.ecm301 = 0
                LET sr.ecm311 = 0
                LET sr.ecm313 = 0
           END IF
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
           #產生製程檔
           CASE
                WHEN g_sma.sma26 = '1'
                     #不產生製程追蹤
                     OUTPUT TO REPORT r110_rep(sr.*)
                OTHERWISE
                     #產生製程追蹤
                     OUTPUT TO REPORT r110_rep(sr.*)
           END CASE
         END FOR
       END IF
     END FOREACH
     #IF g_sma.sma54 = 'N'   THEN
     IF tm.d  ='N' THEN
        FINISH REPORT r110_rep
     ELSE
        CASE
                WHEN g_sma.sma26 = '1'
                 FINISH REPORT r110_rep
            OTHERWISE
                 FINISH REPORT r110_rep
        END CASE
     END IF
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r110_rep(sr)
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
                     sfb24 LIKE sfb_file.sfb93,
                     ima55 LIKE ima_file.ima55,
                     eca02 LIKE eca_file.eca02,
                     eca03 LIKE eca_file.eca03,
                     eca04 LIKE eca_file.eca04,
                     gem02 LIKE gem_file.gem02,
                     ecm301 LIKE ecm_file.ecm301,   #(dec.)
                     ecm311 LIKE ecm_file.ecm311,   #(dec.)
                     ecm313 LIKE ecm_file.ecm313,   #(dec.)
                     ecb03 LIKE ecb_file.ecb03,   #operation seq.(sint.)
                     ecb06 LIKE ecb_file.ecb06,   #operation no.
                     ecb08 LIKE ecb_file.ecb08,   #work center.
                     takhur LIKE ecm_file.ecm20,          #No.FUN-680121 DECIMAL(7,2)#尚需工時
                     srtdt  LIKE type_file.dat,           #No.FUN-680121 DATE# start date
                     duedt  LIKE type_file.dat,           #No.FUN-680121 DATE# due date
                     esrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest start date
                     lsrtdt LIKE type_file.dat,           #No.FUN-680121 DATE#lastest start date
                     eduedt LIKE type_file.dat,           #No.FUN-680121 DATE#earlest due date
                     lduedt LIKE type_file.dat,           #No.FUN-680121 DATE#endlest due date
                     flt    LIKE ima_file.ima59,          #No.FUN-680121 DECIMAL(12,3)#fixed lead time
                     ult    LIKE ima_file.ima59,          #No.FUN-680121 DECIMAL(12,3)#unit  lead time
                     alot   INTEGER                       #No.FUN-680121 DECIMAL(16,6)#part's lead time
              END RECORD,
      l_sw                  LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
   DEFINE l_ima02      LIKE ima_file.ima02   #No.TQC-D50050   Add
   DEFINE l_ima021     LIKE ima_file.ima021  #No.TQC-D50050   Add
   DEFINE l_sfb02_1    LIKE type_file.chr50  #No.TQC-D50050   Add
   DEFINE l_sfb04_1    LIKE type_file.chr50  #No.TQC-D50050   Add

 
  OUTPUT
         TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.sfb01,sr.ecb03
  FORMAT
   PAGE HEADER
#No.FUN-590110  --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
 
      #PRINT COLUMN ((g_len-20)/2)+1,tm.s_date USING '(YY/MM/DD','~', #FUN-570250 mark
      #                tm.d_date USING 'YY/MM/DD)' #FUN-570250 mark
      PRINT COLUMN ((g_len-20)/2)+1,tm.s_date,'~', #FUN-570250 add
                      tm.d_date  #FUN-570250 add
      PRINT g_dash[1,g_len]
#No.FUN-550067-begin
      PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[90],g_x[91],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],  #No.TQC-D50050   Add ,g_x[90],g_x[91]
                     g_x[55],g_x[56],g_x[57],g_x[58],g_x[59],g_x[92],g_x[93],g_x[60],g_x[61],g_x[62],  #No.TQC-D50050   Add ,g_x[92],g_x[93]
                     g_x[63],g_x[64],g_x[65],g_x[66],g_x[67],g_x[68],g_x[69],g_x[70]
      PRINTX name=H2 g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[71],g_x[72],
                     g_x[73],g_x[74],g_x[75],g_x[76],g_x[77],g_x[78],g_x[79],g_x[80]
      PRINTX name=H3 g_x[81],g_x[82],g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                     g_x[89]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.sfb01
      LET l_sw = 'Y'
 
 
   ON EVERY ROW
   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = sr.sfb05   #No.TQC-D50050   Add
    #TQC-D50050--add--end---
    CASE sr.sfb02
       WHEN '1' LET l_sfb02_1 = cl_getmsg('asf-841',g_lang)
       WHEN '5' LET l_sfb02_1 = cl_getmsg('asf-842',g_lang)
       WHEN '7' LET l_sfb02_1 = cl_getmsg('asf-843',g_lang)
       WHEN '8' LET l_sfb02_1 = cl_getmsg('asf-856',g_lang)
       WHEN '11' LET l_sfb02_1 = cl_getmsg('asf-853',g_lang)
       WHEN '13' LET l_sfb02_1 = cl_getmsg('asf-843',g_lang)
       WHEN '15' LET l_sfb02_1 = cl_getmsg('asf-855',g_lang)
    END CASE
    CASE sr.sfb04
       WHEN '1' LET l_sfb04_1 = cl_getmsg('asf-845',g_lang)
       WHEN '2' LET l_sfb04_1 = cl_getmsg('asf-846',g_lang)
       WHEN '3' LET l_sfb04_1 = cl_getmsg('asf-847',g_lang)
       WHEN '4' LET l_sfb04_1 = cl_getmsg('asf-848',g_lang)
       WHEN '5' LET l_sfb04_1 = cl_getmsg('asf-849',g_lang)
       WHEN '6' LET l_sfb04_1 = cl_getmsg('asf-850',g_lang)
       WHEN '7' LET l_sfb04_1 = cl_getmsg('asf-851',g_lang)
       WHEN '8' LET l_sfb04_1 = cl_getmsg('asf-852',g_lang)
    END CASE
    LET l_sfb02_1 = sr.sfb02 USING "####",'.',l_sfb02_1
    LET l_sfb04_1 = sr.sfb04 USING "####",'.',l_sfb04_1
    #TQC-D50050--add--end---
    IF tm.d='N' THEN
      IF sr.sfb13 < g_sma.sma30 THEN
         PRINTX name=D1 COLUMN g_c[41], '*';
      ELSE
         PRINTX name=D1 COLUMN g_c[41], ' ';
      END IF
      PRINTX name=D1
            COLUMN g_c[42],sr.sfb01 CLIPPED,
            #COLUMN g_c[43],sr.sfb05[1,20] CLIPPED,
            COLUMN g_c[43],sr.sfb05 CLIPPED,  #NO.FUN-5B0015
           #No.TQC-D50050 ---Add--- Start
            COLUMN g_c[90],l_ima02  CLIPPED,
            COLUMN g_c[91],l_ima021 CLIPPED,
           #No.TQC-D50050 ---Add--- End
           #COLUMN g_c[44],sr.sfb02 USING "####",  #TQC-D50050
           #COLUMN g_c[45],sr.sfb04 USING "####",  #TQC-D50050
            COLUMN g_c[44],l_sfb02_1,  #TQC-D50050
            COLUMN g_c[45],l_sfb04_1,  #TQC-D50050
            COLUMN g_c[46],sr.sfb13 CLIPPED,
            COLUMN g_c[47],sr.sfb08 USING '##########&.&&&' ,
            COLUMN g_c[48],sr.alot USING "------&.##" CLIPPED
      PRINTX name=D2
            COLUMN g_c[51],sr.sfb34 CLIPPED,'%',
            COLUMN g_c[52],sr.sfb40 CLIPPED,
            COLUMN g_c[53],sr.sfb15 CLIPPED,
            COLUMN g_c[54],sr.ima55 CLIPPED
    ELSE
      IF l_sw = 'Y' THEN
        IF g_sma.sma26='1' THEN
         IF sr.sfb13 > g_sma.sma30 THEN
            PRINTX name=D1 COLUMN g_c[55], '*';
         ELSE
            PRINTX name=D1 COLUMN g_c[55], ' ';
         END IF
        ELSE
         IF sr.sfb13 < g_sma.sma30 THEN
            PRINTX name=D1 COLUMN g_c[55], '*';
         ELSE
            PRINTX name=D1 COLUMN g_c[55], ' ';
         END IF
        END IF
 
            PRINTX name=D1
                  COLUMN g_c[56],sr.sfb01 CLIPPED,
                 #COLUMN g_c[57],sr.sfb02 USING "####",   #TQC-D50050
                 #COLUMN g_c[58],sr.sfb04 USING "####",   #TQC-D50050
                  COLUMN g_c[57],l_sfb02_1,  #TQC-D50050
                  COLUMN g_c[58],l_sfb04_1,  #TQC-D50050
                  #COLUMN g_c[59],sr.sfb05[1,20] CLIPPED;
                  COLUMN g_c[59],sr.sfb05 CLIPPED,    #NO.FUN-5B0015
                 #No.TQC-D50050 ---Add--- Start
                  COLUMN g_c[92],l_ima02  CLIPPED,
                  COLUMN g_c[93],l_ima021 CLIPPED;
                 #No.TQC-D50050 ---Add--- End
               IF sr.sfb23 = 'Y' OR sr.sfb23 = 'y' THEN
                  PRINTX name=D1 COLUMN g_c[60],g_x[36] CLIPPED;
               ELSE
                  PRINTX name=D1 COLUMN g_c[60],g_x[37] CLIPPED;
               END IF
            PRINTX name=D1
                  COLUMN g_c[61],sr.alot USING "########",
                  COLUMN g_c[62],sr.ecb03 USING "########",
                  COLUMN g_c[63],sr.ecb06 CLIPPED,
                  COLUMN g_c[64],sr.ecb08 CLIPPED,
                  COLUMN g_c[65],sr.eca03 CLIPPED,
                  COLUMN g_c[66],sr.srtdt,
                  COLUMN g_c[67],sr.duedt,
                  COLUMN g_c[68],sr.ecm301 USING "##########&.&&&" CLIPPED,
                  COLUMN g_c[69],sr.flt USING "######.###" CLIPPED,
                  COLUMN g_c[70],sr.takhur USING "############.###" CLIPPED
            PRINTX name=D2
                  COLUMN g_c[72],sr.sfb40 USING "########",
                  COLUMN g_c[73],sr.sfb08 USING "###############&.&&&",
                  COLUMN g_c[74],sr.ima55 CLIPPED,
                  COLUMN g_c[76],g_x[34] CLIPPED,
                  COLUMN g_c[77],sr.esrtdt,
                  COLUMN g_c[78],sr.lsrtdt,
                  COLUMN g_c[79],sr.ecm311 USING "##########&.&&&",
                  COLUMN g_c[80],sr.ult USING "######.###" CLIPPED
            PRINTX name=D3
                  COLUMN g_c[82],sr.sfb34 CLIPPED,'%',
                  COLUMN g_c[83],sr.sfb13 CLIPPED,
                  COLUMN g_c[84],sr.sfb15 CLIPPED,
                  COLUMN g_c[86],g_x[35] CLIPPED,
                  COLUMN g_c[87],sr.eduedt,
                  COLUMN g_c[88],sr.lduedt CLIPPED ,
                  COLUMN g_c[89],sr.ecm313 USING "##########&.&&&"
         LET l_sw = 'N'
      ELSE
         PRINTX name=D1
               COLUMN g_c[62],sr.ecb03 USING "########",
               COLUMN g_c[63],sr.ecb06 CLIPPED,
               COLUMN g_c[64],sr.ecb08 CLIPPED,
               COLUMN g_c[65],sr.eca03 CLIPPED,
               COLUMN g_c[66],sr.srtdt,
               COLUMN g_c[67],sr.duedt,
               COLUMN g_c[68],sr.ecm301 USING "##########&.&&&" ,
               COLUMN g_c[69],sr.flt USING "######.###" CLIPPED,
               COLUMN g_c[70],sr.takhur USING "############.###" CLIPPED
         PRINTX name=D2
               COLUMN g_c[76],g_x[34] CLIPPED,
               COLUMN g_c[77],sr.esrtdt,
               COLUMN g_c[78],sr.lsrtdt,
               COLUMN g_c[79],sr.ecm311 USING "##########&.&&&",
               COLUMN g_c[80],sr.ult USING "######.###" CLIPPED
         PRINTX name=D3
               COLUMN g_c[86],g_x[35] CLIPPED,
               COLUMN g_c[87],sr.eduedt,
               COLUMN g_c[88],sr.lduedt CLIPPED ,
               COLUMN g_c[89],sr.ecm313 USING "##########&.&&&"
      END IF
   END IF
# No.FUN-590110 --end--
#No.FUN-550067-end
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb02,sfb04,sfb01,sfb05,sfb15')  #TQC-630166
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
#TQC-630166-end
 
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
#Patch....NO.TQC-610037 <> #
