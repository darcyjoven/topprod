# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr108.4gl
# Descriptions...: 收料對應工單備/欠料明細表
# Date & Author..: 97/07/31  By  Sophia
# Modify.........: NO.FUN-4A0006 04/10/04 By echo 材料料號,工單單號,部門編號,生產料號，收料單號要開窗
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-530120 05/03/16 By Carol 修改報表架構轉XML
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-580005 05/08/10 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: NO.FUN-5B0015 05/11/01 BY Yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-750093 07/06/21 By arman  報表改為使用crystal report
# Modify.........: No.FUN-750093 07/07/18 By arman  加controlg功能 
# Modify.........: No.MOD-870195 08/07/16 By claire 程式名稱:收料對應工單備/欠料明細表應調整為收料對應工單備/欠料明細表(委外代買料) 
# Modify.........: No.FUN-940008 09/05/13 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/10 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A70128 10/08/02 By lixia dateadd相關修改
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-C30010 12/03/02 By Elise 應對所有的收貨單收進來的料皆考慮才對，將(委外代買料)拿掉
# Modify.........: No.MOD-D10038 13/01/07 By bart 修正3張出貨單會有3倍應發數量
# Modify.........: No.TQC-D40104 13/07/17 By yangtt 1.程序中加上CALL cl_show_help()函數 2.修改畫面檔,增加開窗
#                                                   3.修改rpt模版,增加品名規格
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
#             wc      VARCHAR(600),   #TQC-630166
              wc      STRING,      #TQC-630166
              bdate   LIKE type_file.dat,           #No.FUN-680121 DATE
              edate   LIKE type_file.dat,           #No.FUN-680121 DATE
              bdate1  LIKE type_file.dat,           #No.FUN-680121 DATE
              edate1  LIKE type_file.dat,           #No.FUN-680121 DATE
              c       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              d       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
              END RECORD,
          g_ordera  ARRAY[5] OF LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_str             STRING                #NO.FUN-750093
DEFINE   l_table           STRING                #NO.FUN-750093
DEFINE   g_sql             STRING                #NO.FUN-750093                              
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   #NO.FUN-750093      -------begin--------
   LET g_sql = "sfa03.sfa_file.sfa03,",
               "rvb05.rvb_file.rvb05,",
               "ima02.ima_file.ima02,",
               "rvb07.rvb_file.rvb07,",
               "rvb12.rvb_file.rvb12,",
               "sfb01.sfb_file.sfb01,",
               "sfb05.sfb_file.sfb05,",
               "ndate.type_file.dat,",
               "sfa12.sfa_file.sfa12,",
               "sfa05.sfa_file.sfa05,",
               "sfa012.sfa_file.sfa012,",           #FUN-A60027 
               "sfa013.sfa_file.sfa013,",           #FUN-A60027 
               "qty.sfa_file.sfa07,",
               "sfa07.sfa_file.sfa07,",
               "ima021.ima_file.ima021,",             #No.TQC-D40104   Add
               "l_ima02.ima_file.ima02,",             #No.TQC-D40104   Add
               "l_ima021.ima_file.ima021"             #No.TQC-D40104   Add
   LET l_table = cl_prt_temptable('asfr108',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"         #FUN-A60027 add 2?  #No.TQC-D40104  add 3?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
   #NO.FUN-750093      ---------------END-----------
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.bdate1 = ARG_VAL(10)
   LET tm.edate1 = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r108_tm()
      ELSE CALL r108()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN
 
FUNCTION r108_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW r108_w AT p_row,p_col
        WITH FORM "asf/42f/asfr108"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.bdate1= g_today
   LET tm.edate1= g_today
   LET tm.c    = 'Y'
   LET tm.d    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfa03,rvb01,sfb01,sfb82,sfb05,sfb85
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
       #### No.FUN-4A0006
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(sfa03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfa03
                NEXT FIELD sfa03
 
              WHEN INFIELD(rvb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rvb3"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rvb01
                NEXT FIELD rvb01
 
              WHEN INFIELD(sfb01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb9"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01
 
              WHEN INFIELD(sfb82)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb82
                NEXT FIELD sfb82
 
              WHEN INFIELD(sfb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05

            #No.TQC-D40104 ---add--- str
             WHEN INFIELD(sfb85)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb85_1"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb85
                NEXT FIELD sfb85
            #No.TQC-D40104 ---add--- end
           END CASE
      ### END  No.FUN-4A0006
 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
         ON ACTION CONTROLG                    #NO.750093                                                                                      
            CALL cl_cmdask()                   #NO.750093
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

        #No.TQC-D40104 ---add--- str
         ON ACTION help
            CALL cl_show_help()
        #No.TQC-D40104 ---add--- end
 
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
 
     INPUT BY NAME tm.bdate,tm.edate,tm.bdate1,tm.edate1,tm.c,tm.d,tm.more
                    WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
            IF tm.edate < tm.bdate THEN NEXT FIELD bdate END IF
 
         AFTER FIELD bdate1
            IF cl_null(tm.bdate1) THEN NEXT FIELD bdate1 END IF
 
         AFTER FIELD edate1
            IF cl_null(tm.edate1) THEN NEXT FIELD edate1 END IF
            IF tm.edate1 < tm.bdate1 THEN NEXT FIELD bdate1 END IF
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG 
            CALL cl_cmdask()            #NO.FUN-750093
 
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
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asfr108'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asfr108','9031',1)
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
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",tm.bdate1 CLIPPED,"'",
                            " '",tm.edate1 CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
            CALL cl_cmdat('asfr108',g_time,l_cmd)
         END IF
         CLOSE WINDOW r108_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r108()
      ERROR ""
   END WHILE
   CLOSE WINDOW r108_w
END FUNCTION
 
FUNCTION r108()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT    #TQC-630166       #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT    #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[4] OF LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          sr        RECORD
                    sfa03    LIKE sfa_file.sfa03,
                    rvb05    LIKE rvb_file.rvb05,  #收料料號
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,  #No.TQC-D40104   Add
                    rvb07    LIKE rvb_file.rvb07,  #收料數量
                    rvb12    LIKE rvb_file.rvb12,
                    sfb01    LIKE sfb_file.sfb01,
                    sfb05    LIKE sfb_file.sfb05,
                    ndate    LIKE type_file.dat,           #No.FUN-680121 DATE#需要日期
                    sfb13    LIKE sfb_file.sfb13,         #No.TQC-A70128
                    sfa09    LIKE sfa_file.sfa09,         #No.TQC-A70128
                    sfa12    LIKE sfa_file.sfa12,
                    sfa05    LIKE sfa_file.sfa05,
                    sfa012   LIKE sfa_file.sfa012,         #No.FUN-A60027
                    sfa013   LIKE sfa_file.sfa013,         #NO.FUN-A60027 
                    qty      LIKE sfa_file.sfa07,          #No.FUN-680121 DEC(12,3)#未發
                    sfa07    LIKE sfa_file.sfa07,  #欠料
                    sfa08    LIKE sfa_file.sfa08,  #FUN-940008 add
                    sfa27    LIKE sfa_file.sfa27   #FUN-940008 add 
                    END RECORD
   DEFINE l_short_qty   LIKE sfa_file.sfa07        #FUN-940008 add 
   DEFINE l_ima02   LIKE ima_file.ima02   #No.TQC-D40104   Add
   DEFINE l_ima021  LIKE ima_file.ima021  #No.TQC-D40104   Add
 
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
 
     LET l_sql = "SELECT ",
                 #"sfa03,rvb05,ima02,0,rvb12,sfb01,sfb05,",  #MOD-D10038
                 "sfa03,sfa03,ima02,ima021,0,'',sfb01,sfb05,",  #MOD-D10038  #No.TQC-D40104   Add ima021
              #  "dateadd(dd,sfa09,sfb13),sfa12,sfa05,sfa05-sfa06,sfa07",    #FUN-940008 mark
                 #"dateadd(dd,sfa09,sfb13),sfa12,sfa05,sfa012,sfa013,sfa05-sfa06,'','',''", #FUN-940008 sfa07-->''  #FUN-A60027 add sfa012,sfa013
                 #"'',sfb13,sfa09,sfa12,sfa05,sfa012,sfa013,sfa05-sfa06,'','',''", #MOD-D10038 
                 "sfb13+COALESCE(sfa09,0),sfb13,sfa09,sfa12,sfa05,sfa012,sfa013,sfa05-sfa06,'','',''", #MOD-D10038
                 #" FROM sfb_file,sfa_file,rvb_file,ima_file",  #MOD-D10038
                 " FROM sfb_file,sfa_file,ima_file",  #MOD-D10038
                 " WHERE ", tm.wc CLIPPED,
                #"   AND sfb01 = rvb34",    #MOD-C30010 mark
                 #"   AND sfa03 = rvb05",  "   AND rvb05 = ima_file.ima01",
                 # "   AND rvb12 BETWEEN  cast('",tm.bdate1,"' as datetime)  AND  cast('",tm.edate1,"' as datetime) ",
                 #"   AND rvb12 BETWEEN  '",tm.bdate1 ,"' AND  '",tm.edate1 ,"' ",             #TQC-A70128 #MOD-D10038
                 "   AND sfb13+COALESCE(sfa09,0) BETWEEN  '",tm.bdate1 ,"' AND  '",tm.edate1 ,"' ",  #MOD-D10038
                 #"   AND rvb05 = ima_file.ima01",  #MOD-D10038
                 "   AND sfa03 = ima_file.ima01",  #MOD-D10038
                 #"   AND sfb01 = sfa01 AND sfb87!='X' ",                                     #TQC-A70128
                 "   AND sfb01 = sfa01 AND sfb87!='X' "                                       #TQC-A70128
                 #"   AND dateadd(dd,sfa09,sfb13) BETWEEN  cast('",tm.bdate,"' as datetime) ",#TQC-A70128
                 #"   AND  cast('",tm.edate,"' as datetime) "                                 #TQC-A70128
 
 
     PREPARE r108_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r108_curs1 CURSOR FOR r108_prepare1
#    CALL cl_outnam('asfr108') RETURNING l_name        #NO.FUN-750093
#    START REPORT r108_rep TO l_name                   #NO.FUN-750093
     CALL cl_del_data(l_table)                         #NO.FUN-750093
     LET g_pageno = 0
     FOR g_i = 1 TO 5
         LET g_ordera[g_i]= NULL
     END FOR
     FOREACH r108_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #MOD-D10038---begin mark
          ##TQC-A70128--add--str--
          #IF cl_null(sr.sfa09) THEN
          #   LET sr.sfa09 = 0
          #END IF
          #LET sr.ndate =  sr.sfb13 + sr.sfa09
          #   IF sr.ndate < tm.bdate OR sr.ndate > tm.edate THEN
          #      CONTINUE FOREACH
          #   END IF           
          ##TQC-A70128--add--end--
          #MOD-D10038---end
          ##FUN-940008---Begin
          CALL s_shortqty(sr.sfb01,sr.sfa03,sr.sfa08,sr.sfa12,sr.sfa27,sr.sfa012,sr.sfa013)     #FUN-A60027 add sfa012,sfa013
               RETURNING l_short_qty
          IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
          LET sr.sfa07 = l_short_qty
          #FUN-940008---End
          IF sr.qty <= 0 AND sr.sfa07 <= 0 THEN CONTINUE FOREACH END IF
          IF tm.c = 'N' THEN   #未發者不列印
             IF sr.qty <=0 THEN CONTINUE FOREACH END IF
          END IF
          IF tm.d = 'N' THEN   #欠料者不列印
             IF sr.sfa07 > 0 THEN CONTINUE FOREACH END IF
          END IF
           SELECT SUM(rvb07) INTO sr.rvb07 FROM rvb_file
           WHERE rvb05 = sr.rvb05
             AND rvb12 BETWEEN tm.bdate1 AND tm.edate1
          IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF
          # NO.FUN-750093     -------begin-------
          SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = sr.sfb05  #No.TQC-D40104   Add
          EXECUTE insert_prep USING sr.sfa03,sr.rvb05,
                                    sr.ima02,sr.rvb07,
                                    sr.rvb12,sr.sfb01,
                                    sr.sfb05,sr.ndate,
                                    sr.sfa12,sr.sfa05,
                                    sr.sfa012,sr.sfa013,              #FUN-A60027 add 
                                    sr.qty,sr.sfa07,
                                    sr.ima021,l_ima02,        #No.TQC-D40104   Add
                                    l_ima021                  #No.TQC-D40104   add 
#         OUTPUT TO REPORT r108_rep(sr.*)
     # NO.FUN-750093  --------end-------
     END FOREACH
#    FINISH REPORT r108_rep                        #NO.FUN-750093
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #NO.FUN-750093
     IF g_zz05 = 'Y' THEN                          #NO.FUN-750093
         CALL cl_wcchp(tm.wc,'sfa03,rvb01,sfb01,sfb82,sfb05,sfb85')#NO.FUN-750093
              RETURNING tm.wc                      #NO.FUN-750093
     LET g_str = tm.wc                             #NO.FUN-750093
     END IF                                        #NO.FUN-750093
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #NO.FUN-750093
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #NO.FUN-750093
#    CALL cl_prt_cs3('asfr108','asfr108',l_sql,g_str) #NO.FUN-750093
     #No.FUN-A60027 --------------------start----------------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr108','asfr108_1',l_sql,g_str)
     ELSE
        CALL cl_prt_cs3('asfr108','asfr108',l_sql,g_str)
     END IF 
     #No.FUN-A60027 ----------------------end---------------------- 
END FUNCTION
 
#No.FUN-750093 ----------begin-------------
{REPORT r108_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(01)
          sr        RECORD
                    sfa03    LIKE sfa_file.sfa03,
                    rvb05    LIKE rvb_file.rvb05,  #收料料號
                    ima02    LIKE ima_file.ima02,
                    rvb07    LIKE rvb_file.rvb07,  #收料數量
                    rvb12    LIKE rvb_file.rvb12,
                    sfb01    LIKE sfb_file.sfb01,
                    sfb05    LIKE sfb_file.sfb05,
                    ndate    LIKE type_file.dat,           #No.FUN-680121 DATE#需要日期
                    sfa12    LIKE sfa_file.sfa12,
                    sfa05    LIKE sfa_file.sfa05,
                    qty      LIKE sfa_file.sfa07,          #No.FUN-680121 DEC(12,3)#未發
                    sfa07    LIKE sfa_file.sfa07   #欠料
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.rvb05,sr.sfb01
#No.FUN-580005-begin
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37]
      PRINT g_dash1
 
      LET l_last_sw = 'n'
 
#     IF cl_null(g_towhom)
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,COLUMN g_len/2-8,g_x[13] CLIPPED,
#           tm.bdate1,'--',tm.edate1,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
 
#No.FUN-550067-begin
#     PRINT g_x[11],g_x[12] CLIPPED
#     PRINT '---------------- -------------------- -------- ----',
#           ' ---------- ---------- ----------'
#     LET l_last_sw = 'n'
 
 
   BEFORE GROUP OF sr.rvb05    #收料單號
#      PRINT g_x[14],sr.rvb05[1,20]
      PRINT g_x[14],sr.rvb05 CLIPPED  #NO.FUN-5B0015
       PRINT g_x[16],sr.ima02 CLIPPED, #MOD-4A0238
            COLUMN 45,g_x[15],sr.rvb07 USING '------&'
      PRINT ''
 
   AFTER GROUP OF sr.sfb01
#     PRINT COLUMN g_c[31],sr.ksc03,
#           COLUMN g_c[32],sr.ksc01,
#           COLUMN g_c[33],sr.ksc02,
#           COLUMN g_c[34],sr.ksc04,
#           COLUMN g_c[35],l_gem02,
#           COLUMN g_c[36],sr.ksd03 USING '###&',
#           COLUMN g_c[37],sr.ksd11,
 
      PRINT COLUMN g_c[31],sr.sfb01 CLIPPED,
            COLUMN g_c[32],sr.sfb05 CLIPPED,
            COLUMN g_c[33],sr.ndate CLIPPED,
            COLUMN g_c[34],sr.sfa12 CLIPPED,
            COLUMN g_c[35],GROUP SUM(sr.sfa05) USING '---------&',' ',
            COLUMN g_c[36],GROUP SUM(sr.qty)   USING '---------&',' ',
            COLUMN g_c[37],GROUP SUM(sr.sfa07) USING '---------&'
 
   AFTER GROUP OF sr.rvb05     #收料單號
#     PRINT COLUMN 46,g_x[17] CLIPPED,
#           COLUMN 53,GROUP SUM(sr.sfa05) USING '---------&',
#           COLUMN 64,GROUP SUM(sr.qty)   USING '---------&',
#           COLUMN 75,GROUP SUM(sr.sfa07) USING '---------&'
      PRINT COLUMN g_c[34],g_x[17] CLIPPED,
            COLUMN g_c[35],GROUP SUM(sr.sfa05) USING '---------&',
            COLUMN g_c[36],GROUP SUM(sr.qty)   USING '---------&',
            COLUMN g_c[37],GROUP SUM(sr.sfa07) USING '---------&'
#No.FUN-550067-end
#No.FUN-580005-begin
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfa03,rvb01,sfb01,sfb82,sfb05,sfb85')
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
#             IF tm.wc[510,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[510,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILE
}
#NO.FUN-750093 --------end ---------
#MOD-870195
