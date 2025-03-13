# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: ammg100.4gl
# Descriptions...: 開發執行單列印
# Date & Author..: 00/12/21 by Faith
# Modify.........: No.FUN-4C0099 05/02/02 By kim 報表轉XML功能
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570174 05/07/18 By yoyo項次欄位放大
# Modify.........: No.TQC-5A0009 05/10/06 By kim料號放大
# Modify.........: NO.TQC-5B0112 05/11/12 BY Nicola 料號、品名位置修改
# Modify.........: No.TQC-610073 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630183 06/03/17 By pengu 頁尾列印條件超出報表寬度
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-730010 07/03/12 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/04/02 By Nicole 增加CR參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40097 11/05/18 By chenying \t特殊字元導致轉GR時p_gengre出錯
# Modify.........: No.FUN-B40087 11/05/23 By yangtt  憑證報表轉GRW 
# Modify.........: No.FUN-BB0047 11/11/16 By fengrui  調整時間函數問題
# Modify.........: No.MOD-BC0151 12/02/02 By yangtt GR修改     
# Modify.........: No:FUN-C40026 12/04/10 By xumm GR動態簽核
# Modify.........: No.FUN-C50008 12/05/14 By wangrr GR程式優化

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,                       #No.FUN-680100 # Where Condition  #TQC-630166
           a       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
           more    LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
           END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680100 SMALLINT
#No.FUN-730010--begin--
DEFINE     l_table STRING
DEFINE     g_sql   STRING
DEFINE     g_str   STRING
#No.FUN-730010--end--
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr3,
    mmg01 LIKE mmg_file.mmg01,
    mmg02 LIKE mmg_file.mmg02,
    mmg03 LIKE mmg_file.mmg03,
    mmg04 LIKE mmg_file.mmg04,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    mmg05 LIKE mmg_file.mmg05,
    mmi02 LIKE mmi_file.mmi02,
    mmg06 LIKE mmg_file.mmg06,
    mmg07 LIKE mmg_file.mmg07,
    mmg08 LIKE mmg_file.mmg08,
    mmg09 LIKE mmg_file.mmg09,
    mmg10 LIKE mmg_file.mmg10,
    mmg23 LIKE mmg_file.mmg23,
    mmg12 LIKE mmg_file.mmg12,
    mmg121 LIKE mmg_file.mmg121,
    mmg20 LIKE mmg_file.mmg20,
    mmh02 LIKE mmh_file.mmh02,
    mmh03 LIKE mmh_file.mmh03,
    mmh12 LIKE mmh_file.mmh12,
    mmh16 LIKE mmh_file.mmh16,
    mmh04 LIKE mmh_file.mmh04,
    mmh30 LIKE mmh_file.mmh30,
    mmh31 LIKE mmh_file.mmh31,
    mmh161 LIKE mmh_file.mmh161,
    mmh05 LIKE mmh_file.mmh05,
    ima02a LIKE ima_file.ima02,
    ima021a LIKE ima_file.ima021,
    ima08 LIKE ima_file.ima08,    #FUN-C40026 add,
#FUN-C40026----add---str---
    sign_type LIKE type_file.chr1,
    sign_img  LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000
#FUN-C40026----add---end---
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   #LET tm.more  = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)  #No.FUN-7C0078   #TQC-610073
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047  mark

 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
  #No.FUN-730010--begin-- 
   LET g_sql="order1.type_file.chr3,",
             "mmg01.mmg_file.mmg01,",
             "mmg02.mmg_file.mmg02,",
             "mmg03.mmg_file.mmg03,",
             "mmg04.mmg_file.mmg04,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "mmg05.mmg_file.mmg05,",
             "mmi02.mmi_file.mmi02,",
             "mmg06.mmg_file.mmg06,",
             "mmg07.mmg_file.mmg07,",
             "mmg08.mmg_file.mmg08,",
             "mmg09.mmg_file.mmg09,",
             "mmg10.mmg_file.mmg10,",
             "mmg23.mmg_file.mmg23,",
             "mmg12.mmg_file.mmg12,",
             "mmg121.mmg_file.mmg121,",
             "mmg20.mmg_file.mmg20,",
             "mmh02.mmh_file.mmh02,",
             "mmh03.mmh_file.mmh03,",
             "mmh12.mmh_file.mmh12,",
             "mmh16.mmh_file.mmh16,",
             "mmh04.mmh_file.mmh04,",
             "mmh30.mmh_file.mmh30,",
             "mmh31.mmh_file.mmh31,",
             "mmh161.mmh_file.mmh161,",
             "mmh05.mmh_file.mmh05,",
             "ima02a.ima_file.ima02,",
             "ima021a.ima_file.ima021,",
             "ima08.ima_file.ima08,",       #FUN-C40026 add 2,
              #FUN-C40026----add---str----
              "sign_type.type_file.chr1,",  #簽核方式
              "sign_img.type_file.blob,",   #簽核圖檔
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000"
              #FUN-C40026----add---end----
 
   LET l_table = cl_prt_temptable('ammg100',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B40087  #No.FUN-BB0047  mark
      CALL cl_gre_drop_temptable(l_table)                    #FUN-B40087
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"       #FUN-C40026 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B40087  #No.FUN-BB0047  mark
      CALL cl_gre_drop_temptable(l_table)                    #FUN-B40087
      EXIT PROGRAM
   END IF
  #No.FUN-730010--end--
 
  #LET g_pdate  = ARG_VAL(1)
  #LET g_towhom = ARG_VAL(2)
  #LET g_rlang  = ARG_VAL(3)
  #LET g_bgjob  = ARG_VAL(4)
  #LET g_prtway = ARG_VAL(5)
  #LET g_copies = ARG_VAL(6)
  #LET tm.wc    = ARG_VAL(7)
  #LET tm.a     = ARG_VAL(8)
  #LET tm.more  = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)  #No.FUN-7C0078
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-BB0047  add
   IF NOT cl_null(tm.wc) THEN
      CALL g100()
   ELSE
      CALL g100_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION g100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(400)
 
   LET p_row = 8 LET p_col = 15
 
   OPEN WINDOW g100_w AT p_row,p_col WITH FORM "amm/42f/ammg100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.a    = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mmg01,mmg06,mmg02
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
      CLOSE WINDOW g100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
     INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
        IF cl_null(tm.a) THEN LET tm.a='N' END IF
        IF tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()
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
      EXIT WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
       WHERE zz01='ammg100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammg100','9031',1)
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
                         #" '",tm.a  CLIPPED,                   #TQC-610073
                         " '",tm.wc CLIPPED,
                         " '",tm.a  CLIPPED,                    #TQC-610073
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammg100',g_time,l_cmd)
      END IF
      CLOSE WINDOW g100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g100()
   ERROR ""
 END WHILE
 CLOSE WINDOW g100_w
 
END FUNCTION
 
FUNCTION g100()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0076
DEFINE l_sql     STRING         # RDSQL STATEMENT       #TQC-630166        #No.FUN-680100
DEFINE l_za05    LIKE type_file.chr1000                 #No.FUN-680100 VARCHAR(40)
#DEFINE l_order   ARRAY[5] OF LIKE apm_file.apm08        #No.FUN-680100 VARCHAR(10)  #No.TQC-6A0079
DEFINE sr        RECORD
                        order  LIKE type_file.chr3,     #No.FUN-680100 VARCHAR(3)
                        mmg01  LIKE mmg_file.mmg01,     #開發執行單號
                        mmg02  LIKE mmg_file.mmg02,     #執行工單編號
                        mmg03  LIKE mmg_file.mmg03,     #模治具類別
                        mmg04  LIKE mmg_file.mmg04,	#料件編號
                        ima02  LIKE ima_file.ima02,	#品名規格
                        ima021 LIKE ima_file.ima021,    #規格
                        mmg05  LIKE mmg_file.mmg05,	#工作性質
                        mmi02  LIKE mmi_file.mmi02,	#工作性質說明
                        mmg06  LIKE mmg_file.mmg06,	#開立日期
                        mmg07  LIKE mmg_file.mmg07,     #需求日期
                        mmg08  LIKE mmg_file.mmg08,     #結案日期
                        mmg09  LIKE mmg_file.mmg09,     #需求部門
                        mmg10  LIKE mmg_file.mmg10,     #生產數量
                        mmg23  LIKE mmg_file.mmg23,     #生產單位
                        mmg12  LIKE mmg_file.mmg12,     #圖別
                        mmg121 LIKE mmg_file.mmg121,    #版別
                        mmg20  LIKE mmg_file.mmg20,     #穴數
                        mmh02  LIKE mmh_file.mmh02,	#需求零件號/規格說明
                        mmh03  LIKE mmh_file.mmh03,	#需求零件號/規格說明
                        mmh12  LIKE mmh_file.mmh12,     #發料單位
                        mmh16  LIKE mmh_file.mmh16,     #S/A QPA
                        mmh04  LIKE mmh_file.mmh04,	#原需/實需數量
                        mmh30  LIKE mmh_file.mmh30,     #指定倉庫
                        mmh31  LIKE mmh_file.mmh31,     #儲位
                        mmh161 LIKE mmh_file.mmh161,    #實際單位用量
                        mmh05  LIKE mmh_file.mmh05,     #應發數量
                        ima02a LIKE ima_file.ima02,     #品名
                        ima021a LIKE ima_file.ima021,    #規格
                        ima08  LIKE ima_file.ima08      #來源碼
                        END RECORD
DEFINE l_img_blob       LIKE type_file.blob  #FUN-C40026 add 

     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
     #No.FUN-BB0047--mark--End-----

     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add 
     CALL cl_del_data(l_table) #No.FUN-730010
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='ammg100'  #No.FUN-730010
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND mmguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND mmggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND mmggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmguser', 'mmggrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '',mmg01,mmg02,mmg03,mmg04,ima02,ima021,  ",
                 "       mmg05,mmi02,mmg06,mmg07,mmg08,mmg09,   ",
                 "       mmg10,mmg23,mmg12,mmg121,mmg20,mmh02,mmh03,  ",
                 "       mmh12,mmh16,mmh04,mmh30,mmh31,         ",
                  "       mmh161,mmh05,'',''  ",   #No.MOD-470532
                #FUN-C50008--mark--str
                #" FROM mmg_file, OUTER ima_file, OUTER mmi_file",
                #"      ,OUTER mmh_file  ",
                #" WHERE mmg_file.mmg01 = mmh_file.mmh01  ",
                #"   AND mmg_file.mmg02 = mmh_file.mmh011 ",
                #"   AND mmi_file.mmi01 = mmg_file.mmg05  ",
                #"   AND ima_file.ima01 = mmg_file.mmg04 ",
                #"   AND ", tm.wc CLIPPED,
                #FUN-C50008--mark--end
                #FUN-C50008--add--str
                 "  FROM mmg_file LEFT OUTER JOIN mmh_file ON (mmg01=mmh01 AND mmg02=mmh011) ",
                 "                LEFT OUTER JOIN mmi_file ON (mmg05=mmi01) ",
                 "                LEFT OUTER JOIN ima_file ON (mmg04=ima01) ",
                 " WHERE ", tm.wc CLIPPED, 
                #FUN-C50008--add--end
                 "   ORDER BY mmg01,mmh02 "  #No.FUN-730010
     PREPARE g100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE g100_curs1 CURSOR FOR g100_prepare1
    #No.FUN-730010--begin-- mark
    #CALL cl_outnam('ammg100') RETURNING l_name
    #START REPORT g100_rep TO l_name
    #LET g_pageno = 0
    #No.FUN-730010--end-- mark
     FOREACH g100_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
           #No.MOD-470532
          SELECT ima02,ima021,ima08 INTO sr.ima02a,sr.ima021a,sr.ima08 FROM ima_file
           WHERE ima01 = sr.mmh03
           #No.MOD-470532 (end)
          IF tm.a = 'Y' THEN
             LET sr.order = sr.ima08
          ELSE
             LET sr.order = sr.mmh02 USING '####'                #No.FUN-570174
          END IF
          #EXECUTE insert_prep USING sr.*                        #FUN-C40026 mark
          EXECUTE insert_prep USING sr.*,"",l_img_blob,"N",""    #FUN-C40026 add
 
         #OUTPUT TO REPORT g100_rep(sr.*) #No.FUN-730010 mark
     END FOREACH
   
     LET g_cr_table = l_table                       #FUN-C40026 add
     LET g_cr_apr_key_f = "mmg01|mmg02"             #FUN-C40026 add 
    #No.FUN-730010--begin-- 
    #FINISH REPORT g100_rep
   # LET g_sql = " SELECT * FROM ",l_table CLIPPED   #TQC-730113
###GENGRE###     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg06') RETURNING tm.wc
     ELSE                                              #FUN-C40026 add
        CALL cl_wcchp(tm.wc,'mmg01') RETURNING tm.wc   #FUN-C40026 add
     END IF
###GENGRE###     LET g_str = tm.wc
  ## CALL cl_prt_cs3('ammg100',g_sql,g_str)          #TQC-730113
###GENGRE###     CALL cl_prt_cs3('ammg100','ammg100',g_sql,g_str)
    CALL ammg100_grdata()    ###GENGRE###
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    #No.FUN-730010--end--
END FUNCTION
 
##No.FUN-730010--begin-- mark
#REPORT g100_rep(sr)
#DEFINE l_last_sw   LIKE type_file.chr1             #No.FUN-680100 VARCHAR(1)
#DEFINE sr  RECORD
#                   order  LIKE type_file.chr3,     #No.FUN-680100 VARCHAR(3)
#                   mmg01  LIKE mmg_file.mmg01,     #開發執行單號
#                   mmg02  LIKE mmg_file.mmg02,     #執行工單編號
#                   mmg03  LIKE mmg_file.mmg03,     #模治具類別
#                   mmg04  LIKE mmg_file.mmg04,	   #料件編號
#                   ima02  LIKE ima_file.ima02,     #品名規格
#                   ima021 LIKE ima_file.ima021,    #規格
#                   mmg05  LIKE mmg_file.mmg05,	   #工作性質
#                   mmi02  LIKE mmi_file.mmi02,	   #工作性質說明
#                   mmg06  LIKE mmg_file.mmg06,	   #開立日期
#                   mmg07  LIKE mmg_file.mmg07,     #需求日期
#                   mmg08  LIKE mmg_file.mmg08,     #結案日期
#                   mmg09  LIKE mmg_file.mmg09,     #需求部門
#                   mmg10  LIKE mmg_file.mmg10,     #生產數量
#                   mmg23  LIKE mmg_file.mmg23,     #生產單位
#                   mmg12  LIKE mmg_file.mmg12,     #圖別
#                   mmg121 LIKE mmg_file.mmg121,    #版別
#                   mmg20  LIKE mmg_file.mmg20,     #穴數
#                   mmh02  LIKE mmh_file.mmh02,	   #需求零件號/規格說明
#                   mmh03  LIKE mmh_file.mmh03,	   #需求零件號/規格說明
#                   mmh12  LIKE mmh_file.mmh12,     #發料單位
#                   mmh16  LIKE mmh_file.mmh16,     #S/A QPA
#                   mmh04  LIKE mmh_file.mmh04,	   #原需/實需數量
#                   mmh30  LIKE mmh_file.mmh30,     #指定倉庫
#                   mmh31  LIKE mmh_file.mmh31,     #儲位
#                   mmh161 LIKE mmh_file.mmh161,    #實際單位用量
#                   mmh05  LIKE mmh_file.mmh05,     #應發數量
#                   ima02a LIKE ima_file.ima02,     #品名
#                   ima021a LIKE ima_file.ima021,   #規格
#                   ima08  LIKE ima_file.ima08      #來源碼
#                  END RECORD,
#		l_rowno   LIKE type_file.num5      #No.FUN-680100 SMALLINT
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.mmg01,sr.mmg02,sr.order,sr.mmh02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[12] CLIPPED,' ',sr.mmg01, COLUMN 50,g_x[13] CLIPPED,' ',sr.mmg06 #TQC-5A0009  40->50
#      PRINT g_x[14] CLIPPED,' ',sr.mmg02, COLUMN 50,g_x[15] CLIPPED,' ',sr.mmg07 #TQC-5A0009  40->50
#      PRINT g_x[16] CLIPPED,' ',sr.mmg03;
#	  CASE sr.mmg03
#		WHEN  sr.mmg03 = '1' PRINT '  ',g_x[23] CLIPPED;
#		WHEN  sr.mmg03 = '2' PRINT '  ',g_x[24] CLIPPED;
#		WHEN  sr.mmg03 = '3' PRINT '  ',g_x[25] CLIPPED;
#	  END CASE
#      PRINT COLUMN 50, g_x[17] CLIPPED,' ',sr.mmg08 #TQC-5A0009  40->50
#      #-----No.TQC-5B0112 &051112-----
#     #PRINT g_x[18] CLIPPED,sr.mmg04 CLIPPED,
#     #      COLUMN 50, g_x[19] CLIPPED,' ',sr.mmg09 #TQC-5A0009  40->50
#     #PRINT COLUMN 10 ,sr.ima02 CLIPPED, COLUMN 50,              #No.FUN-550054  #TQC-5A0009  40->50
#     #      g_x[20] CLIPPED,' ',sr.mmg10 USING '#########&',' ',sr.mmg23
#     #PRINT COLUMN 10 ,sr.ima021 CLIPPED, COLUMN 50,             #No.FUN-550054  #TQC-5A0009  40->50
#     #      g_x[21] CLIPPED,' ',sr.mmg12 USING '###############&',' ',sr.mmg121
#      PRINT g_x[18] CLIPPED,sr.mmg04 CLIPPED
#      PRINT COLUMN 10,sr.ima02 CLIPPED      #No.FUN-550054  #TQC-5A0009  40->50
#      PRINT COLUMN 10,sr.ima021 CLIPPED     #No.FUN-550054  #TQC-5A0009  40->50
#      PRINT g_x[19] CLIPPED,' ',sr.mmg09, #TQC-5A0009  40->50
#            COLUMN 50,g_x[20] CLIPPED,' ',sr.mmg10 USING '#########&',
#                      ' ',sr.mmg23
#      PRINT g_x[21] CLIPPED,' ',sr.mmg12 USING '###############&',' ',sr.mmg121
#      #-----No.TQC-5B0112 &051112 END-----
#      PRINT g_x[22] CLIPPED,' ',sr.mmg05,' ',sr.mmi02,
#	    COLUMN 50,g_x[26],sr.mmg20 #TQC-5A0009  40->50
#      PRINT g_dash2
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                     g_x[36],g_x[37],g_x[38],g_x[39]
#      PRINTX name=H2 g_x[40],g_x[41],g_x[42]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.mmg01
#      SKIP TO TOP OF PAGE
# 
#   BEFORE GROUP OF sr.mmg02
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#      PRINTX name=D1 COLUMN g_c[31],sr.mmh02 USING '&&&&',                 #No.FUN-570174
#                     COLUMN g_c[32],sr.mmh03,
#                     COLUMN g_c[33],sr.mmh12,
#                     COLUMN g_c[34],cl_numfor(sr.mmh16,34,0),
#                     COLUMN g_c[35],sr.mmh04 USING '####&&',                #Jason 010201
#                     COLUMN g_c[36],sr.mmh05 USING '####&&',                #Jason 010201
#                     COLUMN g_c[37],sr.mmh30,
#                     COLUMN g_c[38],sr.ima08,                               #Jason 010201
#                     COLUMN g_c[39],sr.mmh31
#      PRINTX name=D2 COLUMN g_c[41],sr.ima02a,                               #Jason 010201
#                     COLUMN g_c[42],sr.ima021a
##           COLUMN 34,sr.mmh161 USING '#######',
##           COLUMN 42,sr.mmh05 USING '###########&&',' ',sr.imai08 #Jason
#		
#   ON LAST ROW
#      PRINT ''
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'mmg01,mmg02,mmg03,mmg04,mmg05')
#              RETURNING tm.wc
#         PRINT g_dash
##TQC-630166
##             IF tm.wc[001,070] > ' ' THEN            # for 80
##        PRINT g_x[11] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT g_dash
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
### FUN-550114
#      #PRINT g_x[8],COLUMN 20,g_x[9],COLUMN 40,g_x[10]
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]      #No.TQC-630183 modify
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[9]     #No.TQC-630183 modify
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
##No.FUN-730010--end-- mark

#FUN-B40097

###GENGRE###START
FUNCTION ammg100_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("ammg100")
        IF handler IS NOT NULL THEN
            START REPORT ammg100_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
           #            " ORDER BY mmg01,mmh02"
                        " ORDER BY lower(mmg01),mmh02"        #MOD-BC0151
          
            DECLARE ammg100_datacur1 CURSOR FROM l_sql
            FOREACH ammg100_datacur1 INTO sr1.*
                OUTPUT TO REPORT ammg100_rep(sr1.*)
            END FOREACH
            FINISH REPORT ammg100_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT ammg100_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno       LIKE type_file.num5
    #FUN-B40087 ----add--------str-------
    DEFINE l_mmg03        STRING
    DEFINE l_option       STRING
    DEFINE l_mmg05_mmi02  STRING
    DEFINE l_mmg10        STRING
    DEFINE l_mmg10_mmg23  STRING
    DEFINE l_mmg12_mmg121 STRING
    #FUN-B40087 ----add--------end--------

    
    ORDER EXTERNAL BY sr1.mmg01,sr1.mmh02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.mmg01
            LET l_lineno = 0
        #FUN-B40087 ----add--------str-------
        LET l_mmg05_mmi02 = sr1.mmg05,' ',sr1.mmi02
        PRINTX l_mmg05_mmi02
        LET l_mmg10 = sr1.mmg10 USING '---,---,---,---,--&'
        LET l_mmg10_mmg23 = l_mmg10,' ',sr1.mmg23
        PRINTX l_mmg10_mmg23
        LET l_mmg12_mmg121 = sr1.mmg12,' ',sr1.mmg121
        PRINTX l_mmg12_mmg121 
        IF NOT cl_null(sr1.mmg03) THEN
           LET l_option = cl_gr_getmsg("gre-052",g_lang,sr1.mmg03)
           LET l_mmg03 = sr1.mmg03,' ',l_option
        ELSE
           LET l_mmg03 = ' ' 
        END IF
        PRINTX l_mmg03
        #FUN-B40087 ----add--------end--------
        BEFORE GROUP OF sr1.mmh02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.mmg01
        AFTER GROUP OF sr1.mmh02

        
        ON LAST ROW

END REPORT
###GENGRE###END
