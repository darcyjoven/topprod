# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armr181.4gl
# Descriptions...: RMA 成品存倉表列印
# Date & Author..: 98/06/14 by plum
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/16 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650081 06/05/30 By Sarah Remove yba*
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0213 07/01/12 By chenl 報表表尾修正。
# Modify.........: No.FUN-730019 07/03/12 By Judy Crystal Report修改
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B70175 11/07/28 By houlia 調整ｓｑｌ定義為ｓｔｒｉｎｇ型
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改 
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:TQC-C10039 12/01/14 By minpp  CR报表列印TIPTOP与EasyFlow签核图片
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
          g_name      LIKE zx_file.zx02
         #g_yba01     LIKE yba_file.yba01,   # FUN-650081 mark
         #g_yba92     LIKE yba_file.yba92    # FUN-650081 mark
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
#FUN-730019.....begin
DEFINE   g_sql      STRING
DEFINE   l_table    STRING
DEFINE   g_str      STRING
#FUN-730019.....end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
#---------------------No.TQC-610087 modify---------------------
#  LET g_pdate = g_today            # Get arguments from command line
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
#  LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
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
 
#FUN-730019.....begin
   LET g_sql = "rma01.rma_file.rma01,rma03.rma_file.rma03,",
               "rma04.rma_file.rma04,rma10.rma_file.rma10,",
               "rma11.rma_file.rma11,rma13.rma_file.rma13,",
               "rma14.rma_file.rma14,rma18.rma_file.rma18,",
               "rma20.rma_file.rma20,rma21.rma_file.rma21,",
               "rmb02.rmb_file.rmb02,rmb03.rmb_file.rmb03,",
               "rmb05.rmb_file.rmb05,rmb06.rmb_file.rmb06,",
               "rmb12.rmb_file.rmb12,gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",
               "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
               "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
               "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('armr181',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #TQC-C10039  ADD 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#FUN-730019.....end
#---------------------No.TQC-610087 end---------------------
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-BB0047 add
   IF cl_null(tm.wc)
      THEN CALL armr181_tm(0,0)        # Input print condition
      ELSE 
     #LET tm.wc = "rma01='",tm.wc CLIPPED,"'"    #No.TQC-610087 mark
     #ELSE LET tm.wc = tm.wc CLIPPED
     #   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073 ADD #No.FUN-BB0047--mark
         CALL armr181()            # Read data and create out-file
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073 ADD #No.FUN-BB0047--mark
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-BB0047 add
END MAIN
 
FUNCTION armr181_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW armr181_w AT p_row,p_col
        WITH FORM "arm/42f/armr181"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rma01,rma03,rma20
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
               IF INFIELD(rma03) THEN #客戶編號    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rma03
                  NEXT FIELD rma03
               END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW armr181_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW armr181_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr181'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr181','9031',1)
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
                    #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610087 mark
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armr181',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr181_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr181()
   ERROR ""
END WHILE
   CLOSE WINDOW armr181_w
END FUNCTION
 
FUNCTION armr181()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
      #   l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1100)
          l_sql     string,        #TQC-B70175 
          sr        RECORD
                    rma01     LIKE rma_file.rma01,      # RMA單號
                    rma03     LIKE rma_file.rma03,      # 客戶編號
                    rma04     LIKE rma_file.rma04,      # 客戶簡稱
                    rma13     LIKE rma_file.rma13,      # 人員編號
                    rma14     LIKE rma_file.rma14,      # 部門編號
                    rma20     LIKE rma_file.rma20,      # 到廠日期
                    rma10     LIKE rma_file.rma10,      # 進口報單
                    rma11     LIKE rma_file.rma11,      # 進口方式
                    rma18     LIKE rma_file.rma18,      # 備註
                    rma21     LIKE rma_file.rma21,      # 點收日期
                    rmb02     LIKE rmb_file.rmb02,      # 項次
                    rmb03     LIKE rmb_file.rmb03,      # 產品編號
                    rmb05     LIKE rmb_file.rmb05,      # 品名
                    rmb06     LIKE rmb_file.rmb06,      # 規格
                    rmb12     LIKE rmb_file.rmb12,      # 點收數量
                    gen02     LIKE gen_file.gen02,      # 人員姓名
                    gem02     LIKE gem_file.gem02       # 部門名稱
                    END RECORD
     DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)   #FUN-730019
 
    #SELECT yba02,yba01,yba92 INTO g_company,g_yba01,g_yba92   #FUN-650081 mark
    #  FROM yba_file                                           #FUN-650081 mark
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT rma01,rma03,rma04,rma13,rma14,rma20,rma10,rma11,rma18,",
               " rma21,rmb02,rmb03,rmb05,rmb06,rmb12,gen02,gem02 ",
               " FROM rma_file,rmb_file,oay_file,OUTER gen_file,OUTER gem_file",
               " WHERE rma01=rmb01 AND rma_file.rma13=gen_file.gen01 AND rma_file.rma14=gem_file.gem01 ",
               " AND rma09 !='6' AND rmavoid='Y' ",
#              " AND rma01[1,3]=oayslip",
               " AND rma01 like ltrim(rtrim(oayslip)) || '_%'",       #No.FUN-550064
               " AND oaytype='70' ",
               " AND rmb12 >0 AND ",tm.wc CLIPPED,
               " ORDER BY rma01,rmb02 "
 
     PREPARE armr181_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr181_curs1 CURSOR FOR armr181_prepare1
#FUN-730019.....begin mark
#    CALL cl_outnam('armr181') RETURNING l_name
#    START REPORT armr181_rep TO l_name
#FUN-730019.....end mark
     LET g_pageno = 0
     LET g_cnt = 0
     FOREACH armr181_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_cnt=0 THEN
          SELECT zx02 INTO g_name FROM zx_file
                 WHERE zx01=g_user
          LET g_cnt=1
       END IF
       EXECUTE insert_prep USING sr.rma01,sr.rma03,sr.rma04,sr.rma10,sr.rma11,
                                 sr.rma13,sr.rma14,sr.rma18,sr.rma20,sr.rma21,
                                 sr.rmb02,sr.rmb03,sr.rmb05,sr.rmb06,sr.rmb12,
                                 sr.gen02,sr.gem02,         #FUN-730019
                                 "",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""
#      OUTPUT TO REPORT armr181_rep(sr.*)     #FUN-730019 mark
     END FOREACH
#FUN-730019.....begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'rma01,rma03,rma20') RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "rma01"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('armr181','armr181',l_sql,g_str)   #FUN-710080 modify
#    FINISH REPORT armr181_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#FUN-730019.....end
END FUNCTION
 
#FUN-730019.....begin mark
#REPORT armr181_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          t_rmb12   LIKE rmb_file.rmb12,    #No.FUN-690010 DEC(15,3),
#          sr        RECORD
#                    rma01     LIKE rma_file.rma01,      # RMA單號
#                    rma03     LIKE rma_file.rma03,      # 客戶編號
#                    rma04     LIKE rma_file.rma04,      # 客戶簡稱
#                    rma13     LIKE rma_file.rma13,      # 人員編號
#                    rma14     LIKE rma_file.rma14,      # 部門編號
#                    rma20     LIKE rma_file.rma20,      # 到廠日期
#                    rma10     LIKE rma_file.rma10,      # 進口報單
#                    rma11     LIKE rma_file.rma11,      # 進口方式
#                    rma18     LIKE rma_file.rma18,      # 備註
#                    rma21     LIKE rma_file.rma21,      # 點收日期
#                    rmb02     LIKE rmb_file.rmb02,      # 項次
#                    rmb03     LIKE rmb_file.rmb03,      # 產品編號
#                    rmb05     LIKE rmb_file.rmb05,      # 品名
#                    rmb06     LIKE rmb_file.rmb06,      # 規格
#                    rmb12     LIKE rmb_file.rmb12,      # 點收數量
#                    gen02     LIKE gen_file.gen02,      # 人員姓名
#                    gem02     LIKE gem_file.gem02       # 部門名稱
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.rma01,sr.rmb02
#
#  FORMAT
#   PAGE HEADER
#      PRINT
##No.FUN-580013 --start--
##     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
##No.FUN-580013 --end--
#      PRINT
##     PRINT g_x[29] CLIPPED,' ',g_yba01   #FUN-650081 mark
#    # PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5), 'FROM:', g_user CLIPPED   #No.TQC-6C0213 mark
##No.FUN-580013 --start--
##     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[5] CLIPPED))/2 SPACES,g_x[5] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[5]))/2)+1 ,g_x[5]
##No.FUN-580013 --end--
#      PRINT ' '
#      LET g_pageno= g_pageno+1
#      PRINT g_x[9] CLIPPED,' ',sr.rma01 CLIPPED,
#            COLUMN (g_len-FGL_WIDTH(g_x[11] CLIPPED)-10),g_x[11] CLIPPED,
#            ' ',sr.rma20
#      PRINT g_x[10] CLIPPED,' ',sr.rma03  CLIPPED,'(',sr.rma04 CLIPPED,")",
#            COLUMN (g_len-FGL_WIDTH(g_x[12] CLIPPED)-10),g_x[12] CLIPPED,
#            ' ',sr.rma21
#      PRINT g_x[13] CLIPPED,' ',sr.rma13  CLIPPED,'(',sr.gen02 CLIPPED,')'
#      PRINT g_x[14] CLIPPED,' ',sr.rma14  CLIPPED,'(',sr.gem02 CLIPPED,')'
#      PRINT g_x[26] CLIPPED,' ',sr.rma10
#      PRINT g_x[27] CLIPPED,' ',sr.rma11
#      PRINT g_x[28] CLIPPED,' ',sr.rma18
#     #PRINT g_x[2] CLIPPED,' ',g_pdate CLIPPED,' ',TIME,             #No.TQC-6C0213 mark  
#     #      COLUMN g_len-7,g_x[3] CLIPPED,' ',g_pageno USING '<<<'   #No.TQC-6C0213 mark 
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash
##No.FUN-580013 --start--
##     PRINT g_x[15] CLIPPED,g_x[16] CLIPPED,COLUMN 89,g_x[30] CLIPPED
##     PRINT "---- -------------------- ------------------------------",
##           "------------------------------",
##           " ----------"
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#      PRINT g_dash1
##No.FUN-580013 --end--
#      LET l_last_sw ='n'
#
#   AFTER GROUP OF sr.rma01
#     #PRINT g_dash             #No.TQC-6C0213 mark
#      PRINT g_dash2[1,g_len]   #No.TQC-6C0213
##No.FUN-580013 --start--
##     PRINT g_x[4] CLIPPED,
##           COLUMN 86,t_rmb12 USING '--,---,--&'
#      PRINT COLUMN g_c[31],g_x[15] CLIPPED;          #No.TQC-6C0213 
#      PRINT COLUMN g_c[35],cl_numfor(t_rmb12,35,0)
#      PRINT g_dash                                   #No.TQC-6C0213
#      PRINT g_x[4] CLIPPED
##No.FUN-580013 --end--
#   BEFORE GROUP OF sr.rma01
#      SKIP TO TOP OF PAGE
#      LET t_rmb12=0
#
#   ON EVERY ROW
##No.FUN-580013 --start--
##     PRINT COLUMN 02,sr.rmb02 USING '--&',
##           COLUMN 06,sr.rmb03,
##           COLUMN 27,sr.rmb05,
##           COLUMN 57,sr.rmb06,
##           COLUMN 89,sr.rmb12 USING '------&'
#      PRINT COLUMN g_c[31],sr.rmb02 USING '--&',
#            COLUMN g_c[32],sr.rmb03,
#            COLUMN g_c[33],sr.rmb05,
#            COLUMN g_c[34],sr.rmb06,
#            COLUMN g_c[35],sr.rmb12 USING '---------&'
##No.FUN-580013 --end--
#      LET t_rmb12=t_rmb12+sr.rmb12
#
#  {ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED,COLUMN 59,t_rmb12 USING '---,--&',4 SPACES,
#            t_rmb12 USING '---,--&'}
# ## MOD-530271
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#     #IF l_last_sw = 'n' THEN
#     #   PRINT g_x[17] CLIPPED,g_x[18] CLIPPED,g_x[19] CLIPPED
#     #   PRINT
#     #   PRINT g_x[20] CLIPPED,g_x[21] CLIPPED,g_x[22] CLIPPED,'   ',
#     #         g_name
#     #   PRINT
#     #   PRINT g_x[23] CLIPPED,g_x[24] CLIPPED,g_x[25] CLIPPED,' ',g_yba92
#     #ELSE
#     #   SKIP 5 LINE
#     #END IF
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#            PRINT g_x[17]
#            PRINT g_memo
#         ELSE
#            PRINT
#            PRINT
#         END IF
#      ELSE
#         PRINT g_x[17]
#         PRINT g_memo
#      END IF
# ## END MOD-530271
#
#END REPORT
#Patch....NO.TQC-610037 <> #
#FUN-730019.....end mark
