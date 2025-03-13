# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apjr120.4gl
# Descriptions...: 專案材料進出月報
# Date & Author..: 03/04/23 By Nicola
# Modify.........:No.MOD-580222 05/08/26 by rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-590003 05/09/06 By DAY 報表仍在抓za,導致zaa抓不到
# Modify.........: No.TQC-5A0049 05/10/14 By elva 報表位置不正確
# Modify.........: NO.TQC-5B0025 05/11/09 BY yiting 品名規格要分二行
# Modify.........: No.TQC-610084 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-690118 06/10/16 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-760086 07/07/04 By jan 報表修改，使用CR打印報表
# Modify.........: No.FUN-830107 08/03/24 By ChenMoyan 項目管理報表部分
# Modify.........: No.MOD-8C0167 08/12/17 By sherry 報表少了關聯條件pjb02=tlf41
# Modify.........: No.MOD-930102 09/03/10 By rainy 資料重覆多筆
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.TQC-AC0268 10/12/17 By yinhy 增加開窗功能
# Modify.........: No.TQC-B70215 11/08/01 By lixia 開窗全選報錯
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		            # Print condition RECORD
             #wc     VARCHAR(500),             # Where Condition
              wc     STRING,                # Where Condition  #TQC-630166
              edate  LIKE type_file.dat,    #No.FUN-680103 DATE
              choice LIKE type_file.chr1,   #No.FUN-680103 VARCHAR(01)
              more   LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01)  # 特殊列印條件
 
              END RECORD
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose #No.FUN-680103 SMALLINT
DEFINE   g_str       STRING                  #No.FUN-760086
DEFINE   g_sql       STRING                  #No.FUN-760086
DEFINE   g_sql1      STRING                  #No.FUN-760086
DEFINE   l_table     STRING                  #No.FUN-760086
DEFINE   l_table1    STRING   
 
MAIN
#     DEFINE    l_time   LIKE type_file.chr8      #No.FUN-6A0083
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690118
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
 #--------No.TQC-610084 modify
   LET tm.edate  = ARG_VAL(8)
   LET tm.choice = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #-------No.TQC-610084 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r120_tm(0,0)	
   ELSE
      CALL r120()		
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
END MAIN
 
FUNCTION r120_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01      #No.FUN-580031 
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680103 SMALLINT
          l_cmd		LIKE type_file.chr1000   #No.FUN-680103 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5
      LET p_col = 18
   ELSE
      LET p_row = 4
      LET p_col = 11
   END IF
   OPEN WINDOW r120_w AT p_row,p_col
        WITH FORM "apj/42f/apjr120"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.edate  = TODAY
   LET tm.choice = '1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
 
   WHILE TRUE
#     CONSTRUCT BY NAME  tm.wc ON pja01,pja02,pja03,pja04           #No.FUN-830107
      CONSTRUCT BY NAME  tm.wc ON pja01,pjb02,pja05,pja09,pja08     #No.FUN-830107
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     #No.TQC-AC0268  --Begin
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pja01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pja"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja01
               NEXT FIELD pja01
            WHEN INFIELD(pjb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjb02
               NEXT FIELD pjb02
            WHEN INFIELD(pja09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja09
               NEXT FIELD pja09
            WHEN INFIELD(pja08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pja08
               NEXT FIELD pja08
            OTHERWISE EXIT CASE
         END CASE
     #No.TQC-AC0268  --End
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
         CLOSE WINDOW r120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.edate,tm.choice,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD choice
            IF tm.choice NOT MATCHES'[12]' THEN
               NEXT FIELD choice
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
         CLOSE WINDOW r120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='apjr120'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apjr120','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",          #No.TQC-610084 add
                            " '",tm.choice CLIPPED,"'",         #No.TQC-610084 add
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('apjr120',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      IF tm.choice='1' THEN
         CALL r120()    # 明細
      ELSE
         CALL r1201()   #彙總
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW r120_w
END FUNCTION
 
FUNCTION r120()
   DEFINE#l_name     VARCHAR(20),		      # External(Disk) file name
          l_name     LIKE type_file.chr20,    #No.FUN-680103 VARCHAR(20)
#         l_time     LIKE type_file.chr8      #No.FUN-6A0083
#          l_sql      LIKE type_file.chr1000,  # RDSQL STATEMENT   #No.FUN-680103 VARCHAR(1000)
          l_sql      STRING,                  #TQC-B70215
          l_sum      LIKE    tlf_file.tlf10,  #No.FUN-760086
          l_za05     LIKE type_file.chr1000,  #No.FUN-680103 VARCHAR(40)   
          l_type     LIKE aba_file.aba00,     #No.FUN-680103 VARCHAR(05)
          sr         RECORD
                     pja01     LIKE    pja_file.pja01,   #專案代號
                     edate     LIKE    type_file.dat,    #No.FUN-680103  date #截至日期
                     tlf01     LIKE    tlf_file.tlf01,   #料件編號
                     ima02     LIKE    ima_file.ima02,   #品名
                     ima021    LIKE    ima_file.ima021,  #規格
                     tlf06     LIKE    tlf_file.tlf06,   #異動日期
                     tlf905    LIKE    tlf_file.tlf905,  #異動單號
                     type      LIKE    type_file.chr8,   # Prog. Version..: '5.30.06-13.03.12(08), #類別 
                     amount    LIKE    tlf_file.tlf10,   #數量
                     tlf11     LIKE    tlf_file.tlf11,   #No.FUN-830107
                     pja02     LIKE    pja_file.pja02,   #No.FUN-830107
                     pjb02     LIKE    pjb_file.pjb02,   #No.FUN-830107
                     pjb03     LIKE    pjb_file.pjb03,   #No.FUN-830107
                     tlf13     LIKE    tlf_file.tlf13    #異動命令
                     END RECORD
 
#No.FUN-760086--Begin
     LET g_sql = " pja01.pja_file.pja01,",
                 " edate.type_file.dat,",
                 " tlf01.tlf_file.tlf01,",
                 " ima02.ima_file.ima02,",
                 " ima021.ima_file.ima021,",
                 " tlf06.tlf_file.tlf06,",
                 " tlf905.tlf_file.tlf905,",
                 " tlf13.tlf_file.tlf13,",
                 " amount.tlf_file.tlf10,",
                 #No.FUN-830107 --Begin
                 " tlf11.tlf_file.tlf11,",
                 " pja02.pja_file.pja02,",
                 " pjb02.pjb_file.pjb02,",
                 " pjb03.pjb_file.pjb03,",
                 #No.FUN-830107 --End
                 " l_sum.tlf_file.tlf10"
     LET l_table = cl_prt_temptable('apjr120',g_sql) CLIPPED                    
     IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF                                   
     #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                      
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
#                " VALUES(?,?,?,?,?, ?,?,?,?,?)"         #No.FUN-830107
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"#No.FUN-830107
     PREPARE insert_prep FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM                       
     END IF                                                                     
     CALL cl_del_data(l_table)                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                            
#No.FUN-760086--End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apjr120'
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pjauser', 'pjagrup')
     #End:FUN-980030
 
 
#    LET l_sql = " SELECT pja01,'',tlf01,'','',tlf06,tlf905,tlf13,tlf10*tlf60*tlf907,tlf13 ",         #No.FUN-830107
     LET l_sql = " SELECT DISTINCT pja01,'',tlf01,'','',tlf06,tlf905,tlf13,tlf10*tlf60*tlf907,tlf11,pja02,pjb02,pjb03,tlf13 ",#No.FUN-830107  #MOD-930102 add DISTINCT
#                " FROM pja_file,tlf_file ",                                                          #No.FUN-830107
                 " FROM pja_file,pjb_file,tlf_file ",                                                 #No.FUN-830107
                 " WHERE pja01=tlf20 AND tlf907 <> 0 ",
                 " AND pja01 = pjb01 ",                                                               #No.FUN-830107
                 " AND pjb02 = tlf41 ",        #MOD-8C0167 add
                 " AND tlf06 <= '",tm.edate,"' AND ",tm.wc CLIPPED,            
                 " ORDER BY pja01,pjb02,tlf01,tlf06 "                                                 #No.FUN-830107                                           
 
 
     PREPARE r120_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
     DECLARE r120_c1 CURSOR FOR r120_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
#No.FUN-760086--Begin
#    CALL cl_outnam('apjr120') RETURNING l_name         
 
#    START REPORT r120_rep TO l_name                    
#    IF g_len = 0 OR g_len IS NULL THEN
#       LET g_len = 80
#    END IF
 
#    FOR g_i = 1 TO g_len
#       LET g_dash[g_i,g_i] = '='
#    END FOR
#No.FUN-760086--End
 
     LET g_pageno = 0
     FOREACH r120_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       LET sr.edate=tm.edate
       SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
        WHERE ima01=sr.tlf01
       LET l_type =sr.tlf13[1,5]
#No.FUN-760086--Begin
#       CASE
#          WHEN l_type='asfi5'
             LET sr.type=24
      #      LET sr.type='工單領出'
#          WHEN sr.tlf13='aimt301'
#             LET sr.type=25
      #      LET sr.type='雜項領出'
#          WHEN sr.tlf13='aimt311'
#             LET sr.type=26
      #      LET sr.type='WIP 雜出'
#          WHEN sr.tlf13='aimt302'
#             LET sr.type=27
      #      LET sr.type='雜項入庫'
#          WHEN sr.tlf13='aimt312'
#             LET sr.type=28
      #      LET sr.type='WIP 雜入'
#          WHEN sr.tlf13='aimt303'
#             LET sr.type=29
      #      LET sr.type='雜項報廢'
#          WHEN sr.tlf13='aimt313'
#             LET sr.type=30
      #      LET sr.type='WIP 報廢'
#          WHEN l_type='axmt6'
#             LET sr.type=31
      #      LET sr.type='銷貨領出'
#          WHEN l_type='asft6'
#             LET sr.type=32
      #      LET sr.type='工單入庫'
#          WHEN sr.tlf13='apmt150' OR sr.tlf13='apmt230'
#             LET sr.type=33
      #      LET sr.type='採購入庫'
#          WHEN sr.tlf13='apmt102'
#             LET sr.type=34
      #      LET sr.type='採購驗退'
#          WHEN sr.tlf13='apmt1072'
#             LET sr.type=35
      #      LET sr.type='採購倉退'
#          OTHERWISE
#             LET sr.type=36
      #      LET sr.type='其他'
#       END CASE
        LET l_sum=0
        LET l_sum=l_sum+sr.amount
 
#      OUTPUT TO REPORT r120_rep(sr.*)
       EXECUTE insert_prep USING
               sr.pja01,sr.edate,sr.tlf01,sr.ima02,sr.ima021,sr.tlf06,sr.tlf905,
#              sr.tlf13,sr.amount,l_sum                      #No.FUN-830107
               sr.tlf13,sr.amount,sr.tlf11,sr.pja02,sr.pjb02,sr.pjb03,l_sum  #No.FUN-830107
     END FOREACH
 
#    FINISH REPORT r120_rep
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED           
     LET g_str = ''
     IF g_zz05 = 'Y' THEN                                                         
#       CALL cl_wcchp(tm.wc,'pja01,pja02,pja03,pja04')       #No.FUN-830107
        CALL cl_wcchp(tm.wc,'pja01,pjb02,pja05,pja09,pja08') #No.FUN-830107                       
              RETURNING g_str
     END IF
     CALL cl_prt_cs3('apjr120','apjr120',l_sql,g_str)
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-760086--End
END FUNCTION
 
#No.FUN-760086--Begin
{
REPORT r120_rep(sr)
   DEFINE#l_last_sw VARCHAR(1),
          l_last_sw     LIKE type_file.chr1,        #No.FUN-680103 VARCHAR(1)
          l_sum     LIKE    tlf_file.tlf10,   #結存
           sr        RECORD
                     pja01     LIKE    pja_file.pja01,   #專案代號
                     edate     LIKE    type_file.dat,    #No.FUN-680103  date,  #截止日期
                     tlf01     LIKE    tlf_file.tlf01,   #料件編號
                     ima02     LIKE    ima_file.ima02,   #品名
                     ima021    LIKE    ima_file.ima021,  #規格
                     tlf06     LIKE    tlf_file.tlf06,   #異動日期
                     tlf905    LIKE    tlf_file.tlf905,  #異動單號
                     type      LIKE    type_file.chr8,   # Prog. Version..: '5.30.06-13.03.12(08), #類別 
                     amount    LIKE    tlf_file.tlf10,   #數量
                     tlf13     LIKE    tlf_file.tlf13
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pja01,sr.tlf01,sr.tlf06
 
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pja01
      PRINT COLUMN 01,g_x[9] CLIPPED,sr.pja01 CLIPPED,COLUMN 40,g_x[10] CLIPPED,sr.edate CLIPPED
 
   BEFORE GROUP OF sr.tlf01
      LET l_sum=0
      PRINT COLUMN 01,g_x[11] CLIPPED,sr.tlf01 CLIPPED
      #PRINT COLUMN 01,g_x[12] CLIPPED,sr.ima02 CLIPPED,COLUMN 40,g_x[13] CLIPPED,sr.ima021 CLIPPED
      #NO.TQC-5B0025
      PRINT COLUMN 01,g_x[12] CLIPPED,sr.ima02 CLIPPED
      PRINT COLUMN 40,g_x[13] CLIPPED,sr.ima021 CLIPPED
      #NO.TQC-5B0025
      PRINT COLUMN 01,g_x[14] CLIPPED,COLUMN 32,g_x[15] CLIPPED
      PRINT COLUMN 01,g_x[16] CLIPPED,COLUMN 32,g_x[17] CLIPPED
 
   ON EVERY ROW
      LET l_sum=l_sum+sr.amount
      PRINT COLUMN 01,sr.tlf06 CLIPPED,
            COLUMN 10,sr.tlf905 CLIPPED,
            COLUMN 23,g_x[sr.type] CLIPPED,
            COLUMN 32,sr.amount USING '##########&.&&&', #TQC-5A0049
            COLUMN 48,l_sum USING '#############&.&&&' #TQC-5A0049
 
   AFTER GROUP OF sr.tlf01
      SKIP 1 LINE
 
   AFTER GROUP OF sr.pja01
      SKIP 3 LINE
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
         #     IF tm.wc[001,80] > ' ' THEN			# for 132
 	 #   	 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
          #TQC-630166
          CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-760086--End
 
FUNCTION r1201()
   DEFINE#l_name     VARCHAR(20),	                # External(Disk) file name
          l_name     LIKE type_file.chr20,      #No.FUN-680103 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0083
#          l_sql      LIKE type_file.chr1000,	# RDSQL STATEMENT     #No.FUN-680103 VARCHAR(1000)
          l_sql      STRING,                    #TQC-B70215
          l_sum      LIKE tlf_file.tlf10,       #No.FUN-760086
          l_za05     LIKE type_file.chr1000,    #No.FUN-680103 VARCHAR(40)
          l_type     LIKE aba_file.aba00,       #No.FUN-680103 VARCHAR(05)
          sr         RECORD
                     pja01     LIKE    pja_file.pja01,   #專案代號
                     edate     LIKE    type_file.dat,    #No.FUN-680103 date, #截止日期
                     tlf01     LIKE    tlf_file.tlf01,   #料件編號
                     ima02     LIKE    ima_file.ima02,   #品名
                     ima021    LIKE    ima_file.ima021,  #規格
                     amount    LIKE    tlf_file.tlf10,   #
                     tlf907    LIKE    tlf_file.tlf907,  #入出庫碼
                     pja02     LIKE    pja_file.pja02,   #No.FUN-830107
                     pjb02     LIKE    pjb_file.pjb02,   #No.FUN-830107
                     pjb03     LIKE    pjb_file.pjb03,   #No.FUN-830107
                     in1       LIKE    tlf_file.tlf10,   #入庫數量   #No.FUN-760086
                     out1      LIKE    tlf_file.tlf10    #出庫數量   #No.FUN-760086
                     END RECORD
#No.FUN-760086--Begin
     LET g_sql1 = " pja01.pja_file.pja01,",                                                                                          
                  " edate.type_file.dat,",                                                                                           
                  " tlf01.tlf_file.tlf01,",
                  " in1.tlf_file.tlf10,",
                  " out1.tlf_file.tlf10,",
                  " l_sum.tlf_file.tlf10,",                                                                                          
                  " ima02.ima_file.ima02,",
                  " pja02.pja_file.pja02,",              #No.FUN-830107
                  " pjb02.pjb_file.pjb02,",              #No.FUN-830107
                  " pjb03.pjb_file.pjb03,",              #No.FUN-830107
                  " ima021.ima_file.ima021"                                                                                        
     LET l_table1 = cl_prt_temptable('apjr1201',g_sql1) CLIPPED                    
     IF l_table1 = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
     END IF                                   
     #LET g_sql1 = "INSERT INTO ds_report.",l_table1 CLIPPED,                      
      LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-A50009 mod
#                 " VALUES(?,?,?,?,?, ?,?,?)"             #No.FUN-830107
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"      #No.FUN-830107                   
     PREPARE insert_prep1 FROM g_sql1                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM                       
     END IF                                                                     
     CALL cl_del_data(l_table1)                                                  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-760086--End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apjr120'
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pjauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pjagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pjagrup IN ",cl_chk_tgrup_list()
     #     END IF
     #End:FUN-980030
 
 
#    LET l_sql = " SELECT pja01,'',tlf01,'','',tlf10*tlf60,tlf907,0,0 ",        #No.FUN-830107   
     LET l_sql = " SELECT pja01,'',tlf01,'','',tlf10*tlf60,tlf907,pja02,pjb02,pjb03,0,0 ",  #No.FUN-830107
#                " FROM pja_file,tlf_file ",                                    #No.FUN-830107 
                 " FROM pja_file,tlf_file,pjb_file ",                           #No.FUN-830107 
                 " WHERE pja01=tlf20 AND tlf907 <> 0 ",
                 " AND pja01 = pjb01 ",                                         #No.FUN-830107 
                 " AND pjb02 = tlf41 ",        #MOD-8C0167 add
                 " AND tlf06 <= '",tm.edate,"' AND ",tm.wc CLIPPED
 
 
     PREPARE r1201_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
     DECLARE r1201_c1 CURSOR FOR r1201_p1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
        EXIT PROGRAM
     END IF
#No.FUN-760086--Begin
#      CALL cl_outnam('apjr120') RETURNING l_name    
#    IF g_len = 0 OR g_len IS NULL THEN
#       LET g_len = 90   #TQC-5A0049
#    END IF
 
#    FOR g_i = 1 TO g_len
#       LET g_dash[g_i,g_i] = '='
#    END FOR
 
#    START REPORT r1201_rep TO l_name    
#No.FUN-760086--End            
 
     LET g_pageno = 0
     FOREACH r1201_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       LET sr.edate=tm.edate
       SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
        WHERE ima01=sr.tlf01
       IF sr.tlf907='1' THEN
          LET sr.in1=sr.amount       #No.FUN-760086
       ELSE
          LET sr.out1=sr.amount      #No.FUN-760086
       END IF
#No.FUN-760086--Begin
       LET l_sum=0        
 
#      OUTPUT TO REPORT r1201_rep(sr.*)
       EXECUTE insert_prep1 USING
#              sr.pja01,sr.edate,sr.tlf01,sr.in1,sr.out1,l_sum,sr.ima02,sr.ima021         #No.FUN-830107
               sr.pja01,sr.edate,sr.tlf01,sr.in1,sr.out1,l_sum,sr.ima02,sr.pja02,sr.pjb02,sr.pjb03,sr.ima021#No.FUN-830107
     END FOREACH
 
#    FINISH REPORT r1201_rep
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED           
     LET g_str = ''                                          
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'pja01,pja02,pja03,pja04')                              
              RETURNING tm.wc                                                   
        LET g_str = tm.wc                                                       
     END IF                   
     LET g_str = tm.wc                                                          
     CALL cl_prt_cs3('apjr120','apjr120_1',l_sql,g_str)
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-760086--End
END FUNCTION
 
#No.FUN-760086--Begin
{
REPORT r1201_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,       #No.FUN-680103 VARCHAR(1) 
          l_sum     LIKE    tlf_file.tlf10,   #結存
           sr        RECORD
                     pja01     LIKE    pja_file.pja01,   #專案代號
                     edate     LIKE type_file.dat,       #No.FUN-680103 date,  #截止日期
                     tlf01     LIKE    tlf_file.tlf01,   #料件編號
                     ima02     LIKE    ima_file.ima02,   #品名
                     ima021    LIKE    ima_file.ima021,  #規格
                     amount    LIKE    tlf_file.tlf10,   #
                     tlf907    LIKE    tlf_file.tlf907,  #入出庫碼
                     in        LIKE    tlf_file.tlf10,   #入庫數量
                     out       LIKE    tlf_file.tlf10    #出庫數量
                     END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pja01,sr.tlf01
 
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pja01
      PRINT COLUMN 01,g_x[9] CLIPPED,sr.pja01 CLIPPED,COLUMN 40,g_x[10] CLIPPED,sr.edate CLIPPED
      PRINT COLUMN 01,g_x[18] CLIPPED,COLUMN 42,g_x[19] CLIPPED,COLUMN 74,g_x[20] CLIPPED  #TQC-5A0049
      PRINT COLUMN 01,g_x[21] CLIPPED,COLUMN 42,g_x[22] CLIPPED,COLUMN 74,g_x[23] CLIPPED  #TQC-5A0049
 
   BEFORE GROUP OF sr.tlf01
      LET l_sum=0
#   ON EVERY ROW
#      LET l_sum=l_sum+sr.in-sr.out
#      PRINT COLUMN 01,sr.tlf01 CLIPPED,
#            COLUMN 22,sr.in,
#            COLUMN 38,sr.out,
#            COLUMN 54,l_sum
#      PRINT COLUMN 01,sr.ima02 CLIPPED,
#            COLUMN 22,sr.ima021 CLIPPED
 
   AFTER GROUP OF sr.tlf01
      LET l_sum=l_sum+GROUP SUM(sr.in)-GROUP SUM(sr.out)
      PRINT COLUMN 01,sr.tlf01 CLIPPED,
            COLUMN 42,GROUP SUM(sr.in) USING '##########&.###',
            COLUMN 58,GROUP SUM(sr.out) USING '##########&.###',
            COLUMN 74,l_sum USING '##########&.###'
      PRINT COLUMN 01,sr.ima02 CLIPPED,
            COLUMN 42,sr.ima021 CLIPPED
 
   AFTER GROUP OF sr.pja01
      SKIP 3 LINE
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
         #     IF tm.wc[001,80] > ' ' THEN			# for 132
 	 #	 PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED END IF
         #TQC-630166
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-760086--End
#Patch....NO.TQC-610036 <001> #
