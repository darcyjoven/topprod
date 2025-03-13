# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armr140.4gl
# Descriptions...: RMA覆出單列印
# Date & Author..: 98/03/14 by plum
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.FUN-550122 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/17 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: NO.MOD-590504 05/10/04 By Rosayu 列印缺公司名稱
# Modify.........: No.TQC-5C0064 05/12/13 By kevin 結束位置調整
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650081 06/05/30 By Sarah Remove yba*
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6C0213 07/01/12 By chenl 修正報表頁次問題
# Modify.........: No.FUN-730019 07/03/13 By Judy Crystal Report修改
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-720014 07/04/10 By rainy 地址欄位加2個
# Modify.........: No.TQC-760177 07/06/25 By rainy 有資料報表卻跑不出來
# Modify.........: No.MOD-890206 08/09/23 By Smapmin SQL語法錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:TQC-C10039 12/01/14 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
       #g_yba01     LIKE yba_file.yba01,     # FUN-650081 mark
       #g_yba92     LIKE yba_file.yba92,     # FUN-650081 mark
        l_outbill   LIKE rme_file.rme01      # RMA覆出單號,傳參數用
 
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
 
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#FUN-730019.....begin 
   LET g_sql = "rme01.rme_file.rme01,rme03.rme_file.rme03,",
               "rme073.rme_file.rme073,rme074.rme_file.rme074,",
               #"rme075.rme_file.rme075,rme21.rme_file.rme21,",  #FUN-720014
               "rme075.rme_file.rme075,rme076.rme_file.rme076,", #FUN-720014
               "rme077.rme_file.rme077,rme21.rme_file.rme21,",   #FUN-720014
               "rmc01.rmc_file.rmc01,rmc02.rmc_file.rmc02,",
               "rmc04.rmc_file.rmc04,rmc05.rmc_file.rmc05,",
               "rmc06.rmc_file.rmc06,rmc061.rmc_file.rmc061,",
               "rmc07.rmc_file.rmc07,rmc09.rmc_file.rmc09,",
               "rmc16.rmc_file.rmc16,rmc31.rmc_file.rmc31,",
               "occ18.occ_file.occ18,l_str1.type_file.num5,",
               "l_str2.rme_file.rme01,",
               "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
               "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
               "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
    LET l_table = cl_prt_temptable('armr140',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #TQC-760177
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #TQC-760177   #TQC-C10039  ADD 4?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#FUN-730019.....end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073    ADD  #FUN-BB0047 從IF中拉出 
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL armr140_tm(0,0)        # Input print condition
      ELSE
      CALL armr140()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD  #FUN-BB0047 從IF中拉出
  
END MAIN
 
FUNCTION armr140_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW armr140_w AT p_row,p_col
        WITH FORM "arm/42f/armr140"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rme01,rme02,rme03
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
               IF INFIELD(rme03) THEN #客戶編號    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rme03
                  NEXT FIELD rme03
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
      LET INT_FLAG = 0 CLOSE WINDOW armr140_w
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
      LET INT_FLAG = 0 CLOSE WINDOW armr140_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr140'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr140','9031',1)
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
         CALL cl_cmdat('armr140',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr140_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr140()
   ERROR ""
END WHILE
   CLOSE WINDOW armr140_w
END FUNCTION
 
FUNCTION armr140()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_str1    LIKE type_file.num5,    #FUN-730019
          l_str2    LIKE rme_file.rme01,    #FUN-730019
          sr        RECORD
                    rme01     LIKE rme_file.rme01,      # RMA覆出單號
                    rme03     LIKE rme_file.rme03,      # 客戶編號
                    occ18     LIKE occ_file.occ18,      # 客戶全名
                    rme21     LIKE rme_file.rme21,      # 備註
                    rme073    LIKE rme_file.rme073,     # 送貨地址1
                    rme074    LIKE rme_file.rme074,     # 送貨地址2
                    rme075    LIKE rme_file.rme075,     # 送貨地址3
                    rme076    LIKE rme_file.rme076,     # 送貨地址4 #FUN-720014
                    rme077    LIKE rme_file.rme077,     # 送貨地址5 #FUN-720014
                    rmc01     LIKE rmc_file.rmc01,      # RMA單號
                    rmc02     LIKE rmc_file.rmc02,      # 項次
                    rmc04     LIKE rmc_file.rmc04,      # 產品編號
                    rmc061    LIKE rmc_file.rmc061,     # 品名
                    rmc06     LIKE rmc_file.rmc06,      # 規格
                    rmc07     LIKE rmc_file.rmc07,      # S/N
                    rmc05     LIKE rmc_file.rmc05,      # 單位
                    rmc31     LIKE rmc_file.rmc31,      # 數量
                    rmc09     LIKE rmc_file.rmc09,      # 收費否: Y/N
                    rmc16     LIKE rmc_file.rmc16       # 保固否
                    END RECORD
     DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang #MOD-590504 unmark
     CALL cl_del_data(l_table)    #FUN-730019
 
     #SELECT yba02,yba01,yba92 INTO g_company,g_yba01,g_yba92  #MOD-590504 mark
     #  FROM yba_file                                          #MOD-590504 mark
    #SELECT yba01,yba92 INTO g_yba01,g_yba92   #MOD-590504 add   #FUN-650081 mark
    #  FROM yba_file                           #MOD-590504 add   #FUN-650081 mark
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
     #End:FUN-980030
 
     LET l_sql="SELECT rme01,rme03,occ18,rme21,rme073,rme074,rme075,rme076,rme077, ",  #FUN-720014 add rme076/77   #MOD-890206最後少一個逗號
               "       rmc01,rmc02,rmc04,rmc061,rmc06,rmc07,rmc05,",
               "       rmc31,rmc09,rmc16 ",
               "  FROM rme_file,rmc_file,OUTER occ_file ",
               "  WHERE rme01=rmc23 AND rme_file.rme03=occ_file.occ01 ",
               "    AND rmeconf <> 'X' ",  #CHI-C80041
               "    AND rmevoid='Y' AND ",tm.wc CLIPPED
 
     PREPARE armr140_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr140_curs1 CURSOR FOR armr140_prepare1
 
#    CALL cl_outnam('armr140') RETURNING l_name  #FUN-730019 mark
#    START REPORT armr140_rep TO l_name          #FUN-730019 mark
 
     LET g_pageno = 0
     FOREACH armr140_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#FUN-730019.....begin
       LET  l_str1=sr.rme01[g_doc_len+1,g_no_ep]    
       LET  l_str2=sr.rme01[1,g_doc_len],4*4       
       EXECUTE insert_prep USING sr.rme01,sr.rme03,sr.rme073,sr.rme074,
                                 sr.rme075,sr.rme076,sr.rme077,sr.rme21,sr.rmc01,sr.rmc02,   #FUN-720014 add rme076/77
                                 #sr.rmc04,sr.rmc06,sr.rmc07,sr.rmc05,   #TQC-760177
                                 #sr.rmc31,sr.rmc09,sr.rmc16,sr.rmc061,  #TQC-760177
                                 sr.rmc04,sr.rmc05,sr.rmc06,sr.rmc061,   #TQC-760177
                                 sr.rmc07,sr.rmc09,sr.rmc16,sr.rmc31,    #TQC-760177
                                 sr.occ18,l_str1,l_str2,"",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob,"N",""
#      OUTPUT TO REPORT armr140_rep(sr.*)
#FUN-730019.....end
     END FOREACH
#FUN-730019.....begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     CALL cl_wcchp(tm.wc,'rme01,rme02,rme03') RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "rme01"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('armr140','armr140',l_sql,g_str)   #FUN-710080 modify
#    FINISH REPORT armr140_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
#FUN-730019.....end
END FUNCTION
 
#FUN-730019.....begin mark
#REPORT armr140_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          sr        RECORD
#                    rme01     LIKE rme_file.rme01,      # RMA覆出單號
#                    rme03     LIKE rme_file.rme03,      # 客戶編號
#                    occ18     LIKE occ_file.occ18,      # 客戶全名
#                    rme21     LIKE rme_file.rme21,      # 備註
#                    rme073    LIKE rme_file.rme073,     # 送貨地址1
#                    rme074    LIKE rme_file.rme074,     # 送貨地址2
#                    rme075    LIKE rme_file.rme075,     # 送貨地址3
#                    rmc01     LIKE rmc_file.rmc01,      # RMA單號
#                    rmc02     LIKE rmc_file.rmc02,      # 項次
#                    rmc04     LIKE rmc_file.rmc04,      # 產品編號
#                    rmc061    LIKE rmc_file.rmc061,     # 品名
#                    rmc06     LIKE rmc_file.rmc06,      # 規格
#                    rmc07     LIKE rmc_file.rmc07,      # S/N
#                    rmc05     LIKE rmc_file.rmc05,      # 單位
#                    rmc31     LIKE rmc_file.rmc31,      # 數量
#                    rmc09     LIKE rmc_file.rmc09,      # 收費否: Y/N
#                    rmc16     LIKE rmc_file.rmc16       # 保固否
#                    END RECORD,
#                ll  LIKE rme_file.rme01,   #No.FUN-690010 VARCHAR(10),
#                 l  LIKE type_file.num5    #No.FUN-690010 smallint
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.rme01,sr.rmc01,sr.rmc02
#
#  FORMAT
#    PAGE HEADER
#      PRINT       
##     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company    #No.FUN-580013
#      PRINT     
##     PRINT g_x[21] CLIPPED,' ',g_yba01   #FUN-650081 mark
#    # PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5), 'FROM:', g_user CLIPPED   #No.TQC-6C0213 mark
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED  #No.FUN-580013
#    # PRINT        #No.TQC-6C0213 mark
#      LET g_pageno= g_pageno+1
#      PRINT g_x[9] CLIPPED,' ',sr.rme01 CLIPPED
#      PRINT g_x[10] CLIPPED,' ',sr.rme03 CLIPPED
#      PRINT g_x[11] CLIPPED,' ',sr.rme073 CLIPPED
#      PRINT COLUMN 11,sr.rme074 CLIPPED
#      PRINT COLUMN 11,sr.rme075 CLIPPED
#    # PRINT g_x[2] CLIPPED,' ',g_pdate CLIPPED,' ',TIME,              #No.TQC-6C0213  mark 
#    #       COLUMN g_len-7,g_x[3] CLIPPED,' ',g_pageno USING '<<<'    #No.TQC-6C0213  mark 
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total                               #No.TQC-6C0213    
#      PRINT g_dash
##No.FUN-580013 --start--
###    PRINT g_x[12],COLUMN 41,g_x[13] CLIPPED,g_x[14] CLIPPED
##     PRINT g_x[12],COLUMN 47,g_x[13] CLIPPED,g_x[14] CLIPPED         #No.FUN-550064
##     PRINT '---------------- ---- --------------------',      #No.FUN-550064
##           ' ---------------   ----   ----   ----    ----'
#      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                       g_x[37],g_x[38],g_x[39]
#      PRINTX name = H2 g_x[40],g_x[41],g_x[42],g_x[43]
#      PRINT g_dash1
##No.FUN-580013 --end--
#      LET l_last_sw = 'n'     #FUN-550122
# 
#    BEFORE GROUP OF sr.rme01
#      SKIP TO TOP OF PAGE
#      #LET l_last_sw ='y'       #FUN-550122
#
#    AFTER GROUP OF sr.rme01
#      PRINT
#      #PRINT g_dash             #No.TQC-5C0064
#      #PRINT ' ',g_x[4] CLIPPED #No.TQC-5C0064
#
#    ON EVERY ROW
##No.FUN-580013 --start--
##        PRINT sr.rmc01,
##     #No.FUN-550064 --start--
###             COLUMN 12,sr.rmc02 USING '---&',
###             COLUMN 17,sr.rmc04,
###             COLUMN 38,sr.rmc07,
###             COLUMN 56,sr.rmc05,
###             COLUMN 63,sr.rmc31 USING '---&',
###             COLUMN 72,sr.rmc09,
###             COLUMN 80,sr.rmc16
###       PRINT COLUMN 17,sr.rmc06 CLIPPED,' ',sr.rmc061
##              COLUMN 18,sr.rmc02 USING '---&',
##              COLUMN 23,sr.rmc04,
##              COLUMN 44,sr.rmc07,
##              COLUMN 62,sr.rmc05,
##              COLUMN 69,sr.rmc31 USING '---&',
##              COLUMN 78,sr.rmc09,
##              COLUMN 86,sr.rmc16
##        PRINT COLUMN 23,sr.rmc06 CLIPPED,' ',sr.rmc061
##     #No.FUN-550064---end---
#      PRINTX name = D1
#             COLUMN g_c[31],sr.rmc01,
#             COLUMN g_c[32],sr.rmc02 USING '---&',
#             COLUMN g_c[33],sr.rmc04,
#             COLUMN g_c[34],sr.rmc06,
#             COLUMN g_c[35],sr.rmc07,
#             COLUMN g_c[36],sr.rmc05,
#             COLUMN g_c[37],sr.rmc31 USING '---&',
#             COLUMN g_c[38],sr.rmc09,
#             COLUMN g_c[39],sr.rmc16
#      PRINTX name = D2
#             COLUMN g_c[43],sr.rmc061
##No.FUN-580013 --end--
##        LET  l=sr.rme01[4,10]
#         LET  l=sr.rme01[g_doc_len+1,g_no_ep]    #No.FUN-550064
##        LET ll=sr.rme01[1,3],4*4
#         LET ll=sr.rme01[1,g_doc_len],4*4        #No.FUN-550064
#         print 'l:',l,'ll: ' ,ll
#
### FUN-550122
#    ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT ''  #N.TQC-6A0091
#      PRINT g_dash[1,g_len] #No.TQC-5C0064  #No.TQC-6A0091
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0064  #No.TQC-6A0091
#      PRINT g_x[15]  #No.TQC-6A0091
#      PRINT g_memo  #No.TQC-6A0091
#
#    PAGE TRAILER
#      #IF l_last_sw = 'y' THEN
#      #   PRINT
#      #   PRINT sr.rme21
#      #   PRINT g_x[15] ,g_x[16] CLIPPED,g_x[17] CLIPPED
#      #   PRINT
#      #   PRINT g_x[18] CLIPPED,g_x[19] CLIPPED,g_x[20] CLIPPED,' ',g_yba92
#      #   LET l_last_sw='n'
#      #ELSE
#      #   SKIP 5 LINE
#      #END IF
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#            PRINT ''   #No.TQC-6A0091
#            PRINT g_dash[1,g_len] #No.TQC-5C0064
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0064
#            PRINT g_x[15]
#            PRINT g_memo
#         ELSE
#            PRINT ''   #No.TQC-6A0091
#            PRINT #No.TQC-5C0064
#            PRINT #No.TQC-5C0064
#            PRINT
#            PRINT
#         END IF
#      ELSE
#         SKIP 5 LINE
#      END IF
### END FUN-550122
# 
#END REPORT
#Patch....NO.TQC-610037 <> #
#FUN-730019.....end mark
