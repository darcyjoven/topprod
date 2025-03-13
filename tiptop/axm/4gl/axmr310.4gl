# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axmr310.4gl
# Descriptions...: 估價單列印
# Date & Author..: 00/03/07 By Melody
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/11 By will 報表轉XML格式
# Modify.........: NO.TQC-5B0029 05/11/07 By Nicola 列印位置調整
# Modify.........: No.TQC-5B0110 05/11/11 By CoCo 料號位置調整
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-650024 06/05/08 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-660042 06/06/21 By Pengu 列印時無表頭
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0096 06/11/17 By Ray 頁次應是依每張估價單從1開始計數
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 原抓取occ_file部份也要加判斷抓取ofd_file
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10039 12/01/17 By wangrr 整合單據列印EF簽核 
# Modify.........: No.TQC-D40102 13/07/17 By lujh 估價單號、產品編號、客戶編號、部門編號、業務員號欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                               # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680137 VARCHAR(500)             # Where condition
              more    LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)              # Input more condition(Y/N)
              END RECORD
#         g_dash1     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(400)             #No.FUN-580013
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose         #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000    #No.FUN-680137
#No.FUN-580013  --begin
#DEFINE   g_dash          LIKE type_file.chr1000   #No.FUN-680137 VARCHAR(400)   #Dash line
#DEFINE   g_len           LIKE type_file.num5      #No.FUN-680137 SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        LIKE type_file.num5      #No.FUN-680137 SMALLINT   #Report page no
#DEFINE   g_zz05          LIKE type_file.chr1      #No.FUN-680137 VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
#No.FUN-710090--begin--
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING
#No.FUN-710090--end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
  #No.FUN-710090--begin--
   LET g_sql="oqa01.oqa_file.oqa01,",
             "oqa02.oqa_file.oqa02,",
             "oqa03.oqa_file.oqa03,",
             "oqa031.oqa_file.oqa031,",
             "oqa032.oqa_file.oqa032,",
             "oqa04.oqa_file.oqa04,",
             "oqa041.oqa_file.oqa041,",
             "oqa042.oqa_file.oqa042,",
             "oqa05.oqa_file.oqa05,",
             "oqa06.oqa_file.oqa06,",
             "oqa07.oqa_file.oqa07,",
             "oqa08.oqa_file.oqa08,",
             "oqa09.oqa_file.oqa09,",
             "oqa10.oqa_file.oqa10,",
             "oqa11.oqa_file.oqa11,",
             "oqa12.oqa_file.oqa12,",
             "oqa13.oqa_file.oqa13,",
             "oqa14.oqa_file.oqa14,",
             "oqa15.oqa_file.oqa15,",
             "oqa16.oqa_file.oqa16,",
             "oqa17.oqa_file.oqa17,",
             "oqaconf.oqa_file.oqaconf,",
             "oqb01.oqb_file.oqb01,",
             "oqb02.oqb_file.oqb02,",
             "oqb03.oqb_file.oqb03,",
             "oqb031.oqb_file.oqb031,",
             "oqb032.oqb_file.oqb032,",
             "oqb04.oqb_file.oqb04,",
             "oqb05.oqb_file.oqb05,",
             "oqb06.oqb_file.oqb06,",
             "oqb07.oqb_file.oqb07,",
             "oqb08.oqb_file.oqb08,",
             "oqb09.oqb_file.oqb09,",
             "oqb10.oqb_file.oqb10,",
             "oqb11.oqb_file.oqb11,",
             "oqb12.oqb_file.oqb12,",
             "oqb13.oqb_file.oqb13,",
             "oqe04_1.oqe_file.oqe04,",
             "oqe04_0.oqe_file.oqe04,",
             "occ02.occ_file.occ02,",
             "gen02.gen_file.gen02,",
             "gem02.gem_file.gem02,",
             "azi03.azi_file.azi03,",
             "azi04.azi_file.azi04,",
             "azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1,",  #TQC-C10039 簽核方式
             "sign_img.type_file.blob,",   #TQC-C10039 簽核圖檔
             "sign_show.type_file.chr1,",  #TQC-C10039 是否顯示簽核資料(Y/N)
             "sign_str.type_file.chr1000"  #TQC-C10039 sign_str

   LET  l_table = cl_prt_temptable('axmr310',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?)"                     #TQC-C10039 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #No.FUN-710090--end--
 
   INITIALIZE tm.* TO NULL            # Default condition
#------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610089 end
   IF cl_null(tm.wc)
      THEN CALL axmr310_tm(0,0)             # Input print condition
      ELSE
          #LET tm.wc="oqa01= '",tm.wc CLIPPED,"'"   #MOD-650024 mark
           CALL axmr310()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr310_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr310_w AT p_row,p_col WITH FORM "axm/42f/axmr310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#--------------No.TQC-660042 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#--------------No.TQC-660042 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oqa01,oqa02,oqa03,oqa05,oqa06,oqa07
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

     #TQC-D40102--add--str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oqa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_oqa01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa01
              NEXT FIELD oqa01
            WHEN INFIELD(oqa03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa03
              NEXT FIELD oqa03
            WHEN INFIELD(oqa05)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa05
              NEXT FIELD oqa05
            WHEN INFIELD(oqa06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa06
              NEXT FIELD oqa06
            WHEN INFIELD(oqa07)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oqa07
              NEXT FIELD oqa07
         END CASE
      #TQC-D40102--add--end--
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr310','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr310',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr310()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr310_w
END FUNCTION
 
FUNCTION axmr310()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    oqa      RECORD LIKE oqa_file.*,
                    oqb      RECORD LIKE oqb_file.*
                    END RECORD
  #No.FUN-710090--begin--
   DEFINE l_oqe     RECORD LIKE oqe_file.*,
          l_occ02   LIKE occ_file.occ02,
          l_gen02   LIKE gen_file.gen02,
          l_gem02   LIKE gem_file.gem02
   DEFINE l_oqe04_0 LIKE oqe_file.oqe04
   DEFINE l_oqe04_1 LIKE oqe_file.oqe04
   DEFINE l_azi03   LIKE azi_file.azi03
   DEFINE l_azi04   LIKE azi_file.azi04
   DEFINE l_azi05   LIKE azi_file.azi05
   DEFINE l_azi07   LIKE azi_file.azi07
  #No.FUN-710090--end--
   DEFINE l_cnt     LIKE type_file.num5           #No.FUN-890011
#TQC-C10039--add--start---
   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
#TQC-C10039--add--end---

     CALL cl_del_data(l_table) #No.FUN-710090
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr310' #No.FUN-710090
 
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr310'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
#No.FUN-580013  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oqauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oqagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oqagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqauser', 'oqagrup')
     #End:FUN-980030
 
 
     LET l_sql="SELECT * FROM oqa_file,oqb_file ",
               " WHERE oqa01=oqb01 ",
               "   AND ",tm.wc CLIPPED,
               "   AND oqaconf != 'X' ",#mandy01/08/03 不為已作廢的估價單
               " ORDER BY oqa01,oqb02 "    #No.FUN-710090 add oqb02
     PREPARE axmr310_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE axmr310_curs1 CURSOR FOR axmr310_prepare1
 
    #No.FUN-710090--begin-- mark
    #CALL cl_outnam('axmr310') RETURNING l_name
    #FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR  #No.FUN-580013
    #START REPORT axmr310_rep TO l_name
 
    #LET g_pageno = 0
    #No.FUN-710090--end-- mark
     FOREACH axmr310_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #No.FUN-710090--begin--
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oqa.oqa05
      #NO.FUN-890011--Add--Begin--# 
       SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01=sr.oqa.oqa06              
       IF l_cnt <> 0 THEN
         SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqa.oqa06
       ELSE
         SELECT ofd02 INTO l_occ02 FROM ofd_file WHERE ofd01=sr.oqa.oqa06
       END IF
      #NO.FUN-890011--Add--End--#              
#      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqa.oqa06            #FUN-890011 Mark       
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oqa.oqa07
       DECLARE oqe_cur1 CURSOR FOR
           SELECT * FROM oqe_file WHERE oqe01=sr.oqa.oqa01
                                    AND oqe02=0 ORDER BY oqe03
       LET l_oqe04_0 = ""
       FOREACH oqe_cur1 INTO l_oqe.*
           LET l_oqe04_0 = l_oqe04_0,' ',l_oqe.oqe04 CLIPPED
       END FOREACH
       DECLARE oqe_cur2 CURSOR FOR
           SELECT * FROM oqe_file WHERE oqe01=sr.oqa.oqa01
                                    AND oqe02=sr.oqb.oqb02 ORDER BY oqe03
       LET l_oqe04_1 = ""
       FOREACH oqe_cur2 INTO l_oqe.*
           LET l_oqe04_1 = l_oqe04_1,' ',l_oqe.oqe04 CLIPPED
       END FOREACH
       SELECT azi03,azi04,azi05,azi07 INTO l_azi03,l_azi04,l_azi05,l_azi07
         FROM azi_file
        WHERE azi01=sr.oqa.oqa08
 
       EXECUTE insert_prep USING sr.oqa.oqa01,sr.oqa.oqa02,sr.oqa.oqa03,sr.oqa.oqa031,sr.oqa.oqa032,
                                 sr.oqa.oqa04,sr.oqa.oqa041,sr.oqa.oqa042,sr.oqa.oqa05,sr.oqa.oqa06,
                                 sr.oqa.oqa07,sr.oqa.oqa08,sr.oqa.oqa09,sr.oqa.oqa10,sr.oqa.oqa11,
                                 sr.oqa.oqa12,sr.oqa.oqa13,sr.oqa.oqa14,sr.oqa.oqa15,sr.oqa.oqa16,
                                 sr.oqa.oqa17,sr.oqa.oqaconf,sr.oqb.oqb01,sr.oqb.oqb02,sr.oqb.oqb03,
                                 sr.oqb.oqb031,sr.oqb.oqb032,sr.oqb.oqb04,sr.oqb.oqb05,sr.oqb.oqb06,
                                 sr.oqb.oqb07,sr.oqb.oqb08,sr.oqb.oqb09,sr.oqb.oqb10,sr.oqb.oqb11,
                                 sr.oqb.oqb12,sr.oqb.oqb13,l_oqe04_1,l_oqe04_0,l_occ02,l_gen02,l_gem02,
                                 l_azi03,l_azi04,l_azi05,l_azi07,"",l_img_blob,"N",""       #TQC-C10039 ADD "",l_img_blob,"N",""
      #No.FUN-710090--end-- 
     # OUTPUT TO REPORT axmr310_rep(sr.*)   #No.FUN-710090 mark
     END FOREACH
 
    #No.FUN-710090--begin--
    #FINISH REPORT axmr310_rep
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oqa01,oqa02,oqa03,oqa05,oqa06,oqa07')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
#TQC-C10039--add--start---
     LET g_cr_table = l_table      #主報表的temp table名稱
     LET g_cr_apr_key_f = "oqa01"  #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--add--end---
   # CALL cl_prt_cs3('axmr310',g_sql,g_str)      #TQC-730088
     CALL cl_prt_cs3('axmr310','axmr310',g_sql,g_str)
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #No.FUN-710090--end--
END FUNCTION
 
#No.FUN-710090--begin-- mark
#REPORT axmr310_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,        #No.FUN-680137  VARCHAR(1)
#          sr        RECORD
#                    oqa      RECORD LIKE oqa_file.*,
#                    oqb      RECORD LIKE oqb_file.*
#                    END RECORD,
#          l_flag    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          l_oqe     RECORD LIKE oqe_file.*,
#          l_occ02   LIKE occ_file.occ02,
#          l_gen02   LIKE gen_file.gen02,
#          l_gem02   LIKE gem_file.gem02,
#          l_sum_oqb05 LIKE oqb_file.oqb05,
#          l_sum_oqb11 LIKE oqb_file.oqb11
#
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oqa.oqa01,sr.oqb.oqb02
#  FORMAT
#   PAGE HEADER
#      #no.4560
#      SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
#       FROM azi_file WHERE azi01 = sr.oqa.oqa08
#      #no.4560(end)
##No.FUN-580013  -begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#      PRINT
#      LET g_pageno = g_pageno + 1
##     LET pageno_total = PAGENO USING '<<<'    #TQC-6B0096
#      LET pageno_total = g_pageno USING '<<<'    #TQC-6B0096
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_dash
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
##     PRINT ' '
##     LET g_pageno= g_pageno+1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,' ',g_msg CLIPPED,
##           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##     PRINT g_dash[1,g_len]
##No.FUN-580013  -end
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oqa.oqa05
#      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqa.oqa06
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oqa.oqa07
#      IF g_pageno=1 THEN
###TQC-5B0110&051112 START##
#         PRINT COLUMN 01,g_x[11] CLIPPED,sr.oqa.oqa01 CLIPPED,
#               COLUMN 50,g_x[16] CLIPPED,sr.oqa.oqa05 CLIPPED,' ',l_gem02 CLIPPED,
#               COLUMN 80,g_x[19] CLIPPED,sr.oqa.oqa08
#              # COLUMN 30,g_x[16] CLIPPED,sr.oqa.oqa05 CLIPPED,' ',l_gem02 CLIPPED,
#              # COLUMN 60,g_x[19] CLIPPED,sr.oqa.oqa08
#         PRINT COLUMN 01,g_x[12] CLIPPED,sr.oqa.oqa02 CLIPPED,
#               COLUMN 50,g_x[17] CLIPPED,sr.oqa.oqa06 CLIPPED,' ',l_occ02 CLIPPED,
#               COLUMN 80,g_x[20] CLIPPED,cl_numfor(sr.oqa.oqa09,11,t_azi07)   #No.TQC-5B0029
#              # COLUMN 30,g_x[17] CLIPPED,sr.oqa.oqa06 CLIPPED,' ',l_occ02 CLIPPED,
#              # COLUMN 60,g_x[20] CLIPPED,cl_numfor(sr.oqa.oqa09,11,t_azi07)   #No.TQC-5B0029
###TQC-5B0110&051112 END##
#      ELSE
#         #No.TQC-6B0096--begin
##        PRINT COLUMN 01,g_x[23] CLIPPED,g_x[24] CLIPPED,g_x[25] CLIPPED
##        PRINT COLUMN 01,g_x[26] CLIPPED,g_x[27] CLIPPED,g_x[28] CLIPPED
#         PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#         PRINT g_dash1
#         #No.TQC-6B0096--end  
#      END IF
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.oqa.oqa01
#      SKIP TO TOP OF PAGE
#      LET g_pageno = 1      #TQC-6B0096
#      LET l_flag='N'
###TQC-5B0110&051112 START##
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.oqa.oqa03 CLIPPED,
#            COLUMN 50,g_x[18] CLIPPED,sr.oqa.oqa07 CLIPPED,' ',l_gen02 CLIPPED,
#            COLUMN 80,g_x[21] CLIPPED,sr.oqa.oqa10 USING '#######&.&&'
#           # COLUMN 30,g_x[18] CLIPPED,sr.oqa.oqa07 CLIPPED,' ',l_gen02 CLIPPED,
#           # COLUMN 60,g_x[21] CLIPPED,sr.oqa.oqa10 USING '#######&.&&'
#      PRINT COLUMN 10,sr.oqa.oqa031 CLIPPED,
#           # COLUMN 60,g_x[22] CLIPPED,sr.oqa.oqa12
#            COLUMN 80,g_x[22] CLIPPED,sr.oqa.oqa12
###TQC-5B0110&051112 END##
#
#      PRINT COLUMN 10,sr.oqa.oqa032
#      PRINT COLUMN 01,g_x[30] CLIPPED,cl_numfor(sr.oqa.oqa17,18,t_azi05),
#            COLUMN 30,g_x[31] CLIPPED,cl_numfor(sr.oqa.oqa13,18,t_azi04),
#            COLUMN 60,g_x[32] CLIPPED,cl_numfor(sr.oqa.oqa14,18,t_azi04)
#      PRINT COLUMN 30,g_x[33] CLIPPED,cl_numfor(sr.oqa.oqa15,18,t_azi04),
#            COLUMN 60,g_x[34] CLIPPED,cl_numfor(sr.oqa.oqa16,18,t_azi04)
#      IF sr.oqa.oqa04 IS NOT NULL AND sr.oqa.oqa04!=' ' THEN
#         PRINT COLUMN 01,g_x[14] CLIPPED,sr.oqa.oqa04
#      END IF
#      SELECT COUNT(*) INTO g_cnt FROM oqe_file
#          WHERE oqe01=sr.oqa.oqa01 AND oqe02=0
#      IF g_cnt>0 THEN
#         PRINT COLUMN 01,g_x[15] CLIPPED;
#         DECLARE oqe_cur1 CURSOR FOR
#             SELECT * FROM oqe_file WHERE oqe01=sr.oqa.oqa01
#                                      AND oqe02=0 ORDER BY oqe03
#         FOREACH oqe_cur1 INTO l_oqe.*
#             PRINT COLUMN 10,l_oqe.oqe04
#         END FOREACH
#      END IF
##No.FUN-580013  -begin
##     PRINT g_dash1[1,g_len]
##     PRINT COLUMN 01,g_x[23] CLIPPED,g_x[24] CLIPPED,g_x[25] CLIPPED
##     PRINT COLUMN 01,g_x[26] CLIPPED,g_x[27] CLIPPED,g_x[28] CLIPPED
#      PRINT g_dash2[1,g_len]
#      PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
#      PRINT g_dash1
##No.FUN-580013  -end
# 
#   ON EVERY ROW
##No.FUN-580013  -begin
##     PRINT COLUMN 01,sr.oqb.oqb02 USING '##&',
##           COLUMN 06,sr.oqb.oqb03,
##           COLUMN 28,sr.oqb.oqb04,
##           COLUMN 33,sr.oqb.oqb05 USING '#######&.&&',
##           COLUMN 45,cl_numfor(sr.oqb.oqb10,15,t_azi03),
##           COLUMN 61,cl_numfor(sr.oqb.oqb11,18,t_azi04),
##           COLUMN 81,sr.oqb.oqb06
##     PRINT COLUMN 06,sr.oqb.oqb031,' ',sr.oqb.oqb032
##     PRINT COLUMN g_c[41],sr.oqb.oqb02 USING '###&', #FUN-590118  #No.TQC-6B0096
#      PRINTX name =D1 COLUMN g_c[41],sr.oqb.oqb02 USING '####&', #FUN-590118  #No.TQC-6B0096
#            COLUMN g_c[42],sr.oqb.oqb03 CLIPPED,
#            COLUMN g_c[43],sr.oqb.oqb04 CLIPPED,
#            COLUMN g_c[44],cl_numfor(sr.oqb.oqb05,44,3),
#            COLUMN g_c[45],cl_numfor(sr.oqb.oqb10,45,t_azi03),
#            COLUMN g_c[46],cl_numfor(sr.oqb.oqb11,46,t_azi04),
#            COLUMN g_c[47],sr.oqb.oqb06
#      #No.TQC-6B0096--begin
##     PRINT COLUMN g_c[42],sr.oqb.oqb031
##     PRINT COLUMN g_c[42],sr.oqb.oqb032
#      PRINTX name = D1 COLUMN g_c[42],sr.oqb.oqb031
#      PRINTX name = D1 COLUMN g_c[42],sr.oqb.oqb032
#      #No.TQC-6B0096--end
##No.FUN-580013  -end
#      DECLARE oqe_cur2 CURSOR FOR
#          SELECT * FROM oqe_file WHERE oqe01=sr.oqa.oqa01
#                                   AND oqe02=sr.oqb.oqb02 ORDER BY oqe03
#      FOREACH oqe_cur2 INTO l_oqe.*
##         PRINT COLUMN 07,l_oqe.oqe04
#          PRINTX name =D1 COLUMN g_c[42],l_oqe.oqe04  #No.FUN-580013  #No.TQC-6B0096 
#      END FOREACH
# 
#   AFTER GROUP OF sr.oqa.oqa01
##     PRINT g_dash1[1,g_len]
#      PRINT g_dash2[1,g_len]  #No.FUN-580013
#      LET l_sum_oqb05 = GROUP SUM(sr.oqb.oqb05)
#      LET l_sum_oqb11 = GROUP SUM(sr.oqb.oqb11)
##No.FUN-580013  -begin
##     PRINT COLUMN 01,g_x[29] CLIPPED,
##           COLUMN 25,cl_numfor(l_sum_oqb05,18,t_azi05),     #FUN-4C0096
##           COLUMN 61,cl_numfor(l_sum_oqb11,18,t_azi05)      #FUN-4C0096
##     PRINT g_dash[1,g_len]
##     PRINT COLUMN g_c[41],g_x[29] CLIPPED,                  #No.TQC-6B0096
#      PRINTX name = D1 COLUMN g_c[41],g_x[29] CLIPPED,       #No.TQC-6B0096       #No.TQC-6B0096
#            COLUMN g_c[44],cl_numfor(l_sum_oqb05,44,t_azi05),     #FUN-4C0096
#            COLUMN g_c[46],cl_numfor(l_sum_oqb11,46,t_azi05)      #FUN-4C0096
#      PRINT g_dash
##No.FUN-580013  -end
#      LET g_pageno=0
#      LET l_flag='Y'
# 
#   #No.TQC-6B0096--begin
#   ON LAST ROW
#      PRINT g_dash[1,g_len] 
#      LET l_last_sw = 'y'
#   #No.TQC-6B0096--end
#
#   PAGE TRAILER
### FUN-550127
#      IF l_last_sw = 'n' THEN
#         IF l_flag ='Y' THEN
#            #PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
#            PRINT g_dash
##           PRINT
#         ELSE
#            PRINT g_dash
#         END IF
#         IF l_flag = 'n' THEN
#            IF g_memo_pagetrailer THEN
#                PRINT g_x[4]
#                PRINT g_memo
#            ELSE
#                PRINT
#                PRINT
#            END IF
#         ELSE
#                PRINT g_x[4]
#                PRINT g_memo
#         END IF
#      ELSE
#         SKIP 3 LINE
#      END IF
### END FUN-550127
#
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-710090--end-- mark
