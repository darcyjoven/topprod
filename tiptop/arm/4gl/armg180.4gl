# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: armg180.4gl
# Descriptions...: RMA INVO/實收數量差異表列印
# Date & Author..: 98/04/24 by plum
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/16 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-5B0036 05/11/07 BY yiting 公司名稱沒印出來
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650081 06/05/30 By Sarah Remove yba*
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0213 07/01/12 By chenl 修改報表頁次問題
# Modify.........: No.FUN-730019 07/03/09 By Judy Crystal Report修改
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40087 11/06/02 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-C10036 12/01/11 By yangtt   1:TQC-B70175追單
#                                                     2:程序撰寫規範修改
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C20052 12/02/09 By chenying GR調整
# Modify.........: No:FUN-C40026 12/04/11 By xumm GR動態簽核
# Modify.........: No:FUN-C50004 12/05/02 By nanbing GR優化
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
          g_name      like zx_file.zx02,
         #g_yba01     like yba_file.yba01,   # FUN-650081 mark
         #g_yba92     like yba_file.yba92,   # FUN-650081 mark
          l_za05      LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(40)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
#FUN-730019.....begin
DEFINE   g_sql        STRING
DEFINE   l_table      STRING
DEFINE   g_str        STRING
#FUN-730019.....end
###GENGRE###START
TYPE sr1_t RECORD
    rma01 LIKE rma_file.rma01,
    rma03 LIKE rma_file.rma03,
    rma04 LIKE rma_file.rma04,
    rma13 LIKE rma_file.rma13,
    rma14 LIKE rma_file.rma14,
    rma20 LIKE rma_file.rma20,
    rma21 LIKE rma_file.rma21,
    rmb02 LIKE rmb_file.rmb02,
    rmb03 LIKE rmb_file.rmb03,
    rmb05 LIKE rmb_file.rmb05,
    rmb06 LIKE rmb_file.rmb06,
    rmb11 LIKE rmb_file.rmb11,
    rmb12 LIKE rmb_file.rmb12,
    gen02 LIKE gen_file.gen02,
    gem02 LIKE gem_file.gem02,  #FUN-C40026 add,
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
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
#-----------No.TQC-610087 modify
#  LET g_pdate = g_today            # Get arguments from command line
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
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
#-----------No.TQC-610087 end
 
#FUN-730019.....begin
   LET g_sql = "rma01.rma_file.rma01,rma03.rma_file.rma03,",
               "rma04.rma_file.rma04,rma13.rma_file.rma13,",
               "rma14.rma_file.rma14,rma20.rma_file.rma20,",
               "rma21.rma_file.rma21,rmb02.rmb_file.rmb02,",
               "rmb03.rmb_file.rmb03,rmb05.rmb_file.rmb05,",
               "rmb06.rmb_file.rmb06,rmb11.rmb_file.rmb11,",
               "rmb12.rmb_file.rmb12,gen02.gen_file.gen02,",
               "gem02.gem_file.gem02,",#FUN-C40026 add 2,
               #FUN-C40026----add---str----
               "sign_type.type_file.chr1,sign_img.type_file.blob,",   #簽核方式, 簽核圖檔
               "sign_show.type_file.chr1,sign_str.type_file.chr1000"
               #FUN-C40026----add---end----
   LET l_table = cl_prt_temptable('armg180',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"    #FUN-C40026 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM
   END IF
#FUN-730019.....end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(tm.wc)
      THEN CALL armg180_tm(0,0)        # Input print condition
      ELSE LET tm.wc = "rma01='",tm.wc CLIPPED,"'"
           CALL armg180()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)     #FUN-C10036 add
END MAIN
 
FUNCTION armg180_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 10
   END IF
   OPEN WINDOW armg180_w AT p_row,p_col
        WITH FORM "arm/42f/armg180"
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
      LET INT_FLAG = 0 CLOSE WINDOW armg180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
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
      LET INT_FLAG = 0 CLOSE WINDOW armg180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armg180'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armg180','9031',1)
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
                     " '",tm.more CLIPPED,"'"  ,
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armg180',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armg180_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armg180()
   ERROR ""
END WHILE
   CLOSE WINDOW armg180_w
END FUNCTION
 
FUNCTION armg180()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
#         l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000) 
          l_sql     string,    #FUN-C10036
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          sr        RECORD
                    rma01     LIKE rma_file.rma01,      # RMA單號
                    rma03     LIKE rma_file.rma03,      # 客戶編號
                    rma04     LIKE rma_file.rma04,      # 客戶簡稱
                    rma13     LIKE rma_file.rma13,      # 人員編號
                    rma14     LIKE rma_file.rma14,      # 部門編號
                    rma20     LIKE rma_file.rma20,      # 到廠日期
                    rma21     LIKE rma_file.rma21,      # 點收日期
                    rmb02     LIKE rmb_file.rmb02,      # 項次
                    rmb03     LIKE rmb_file.rmb03,      # 產品編號
                    rmb05     LIKE rmb_file.rmb05,      # 品名
                    rmb06     LIKE rmb_file.rmb06,      # 規格
                    rmb11     LIKE rmb_file.rmb11,      # INVO數量
                    rmb12     LIKE rmb_file.rmb12,      # 實收數量
                    gen02     LIKE gen_file.gen02,      # 人員姓名
                    gem02     LIKE gem_file.gem02       # 部門名稱
                    END RECORD

     DEFINE l_img_blob      LIKE type_file.blob  #FUN-C40026 add

     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang #NO.TQC-5B0036 unmark
     CALL cl_del_data(l_table)    #FUN-730019
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
 
     LET l_sql="SELECT rma01,rma03,rma04,rma13,rma14,rma20,rma21,rmb02,rmb03, ",
               "       rmb05,rmb06,rmb11,rmb12,gen02,gem02 ",
         #      "  FROM rma_file,rmb_file,OUTER gen_file,OUTER gem_file ",  #FUN-C50004 mark
         #      "  WHERE rma01=rmb01 AND rma_file.rma13=gen_file.gen01 AND rma_file.rma14=gem_file.gem01 ",  #FUN-C50004 mark
               " FROM rmb_file ,rma_file LEFT OUTER JOIN gen_file ON rma13 = gen01 ",  #FUN-C50004 add
               "                         LEFT OUTER JOIN gem_file ON rma14 = gem01 ",  #FUN-C50004 add
               " WHERE rma01 = rmb01 ",   #FUN-C50004 add
               "  AND   rma09 !='6' AND rmavoid='Y' ",
               "  AND ",tm.wc CLIPPED
 
     PREPARE armg180_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE armg180_curs1 CURSOR FOR armg180_prepare1
 
#    CALL cl_outnam('armg180') RETURNING l_name   #FUN-730019 mark
#    START REPORT armg180_rep TO l_name           #FUN-730019 mark
     SELECT zx02 INTO g_name FROM zx_file WHERE zx01=g_user
     LET g_pageno = 0
     FOREACH armg180_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #EXECUTE insert_prep USING sr.*    #FUN-730019        #FUN-C40026 mark
       EXECUTE insert_prep USING sr.*,"",l_img_blob,"N",""   #FUN-C40026 add
#      OUTPUT TO REPORT armg180_rep(sr.*)#FUN-730019 mark
     END FOREACH
     LET g_cr_table = l_table                 #FUN-C40026 add
     LET g_cr_apr_key_f = "rma01"             #FUN-C40026 add
#FUN-730019.....bgein
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     CALL cl_wcchp(tm.wc,'rma01,rma03,rma20') RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
###GENGRE###     CALL cl_prt_cs3('armg180','armg180',l_sql,g_str)   #FUN-710080 modify
    CALL armg180_grdata()    ###GENGRE###
#    FINISH REPORT armg180_rep         
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  
#    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085   
#FUN-730019.....end
END FUNCTION
 
#FUN-730019.....begin mark
#REPORT armg180_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690010   VARCHAR(1),
#          t_rmb11   LIKE rmb_file.rmb11,    #No.FUN-690010 DEC(15,3),
#          t_rmb12   LIKE rmb_file.rmb12,    #No.FUN-690010 DEC(15,3),
#          sr        RECORD
#                    rma01     LIKE rma_file.rma01,      # RMA單號
#                    rma03     LIKE rma_file.rma03,      # 客戶編號
#                    rma04     LIKE rma_file.rma04,      # 客戶簡稱
#                    rma13     LIKE rma_file.rma13,      # 人員編號
#                    rma14     LIKE rma_file.rma14,      # 部門編號
#                    rma20     LIKE rma_file.rma20,      # 到廠日期
#                    rma21     LIKE rma_file.rma21,      # 點收日期
#                    rmb02     LIKE rmb_file.rmb02,      # 項次
#                    rmb03     LIKE rmb_file.rmb03,      # 產品編號
#                    rmb05     LIKE rmb_file.rmb05,      # 品名
#                    rmb06     LIKE rmb_file.rmb06,      # 規格
#                    rmb11     LIKE rmb_file.rmb11,      # INVO數量
#                    rmb12     LIKE rmb_file.rmb12,      # 實收數量
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
#    PAGE HEADER
#    # PRINT            #No.TQC-6C0213 mark
##No.FUN-580013 --start--
##     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
##No.FUN-580013 --end--
#      PRINT 
##     PRINT g_x[26] CLIPPED,' ',g_yba01   #FUN-650081 mark
#    # PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5), 'FROM:', g_user CLIPPED   #No.TQC-6C0213 mark
##No.FUN-580013 --start--
##     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##No.FUN-580013 --end--
#      PRINT ' '
#      LET g_pageno= g_pageno+1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"       #No.TQC-6C0213
#      PRINT g_x[9] CLIPPED,' ',sr.rma01 CLIPPED,
#            COLUMN (g_len-FGL_WIDTH(g_x[11] CLIPPED)-10),g_x[11] CLIPPED,
#           #COLUMN 60,g_x[11] CLIPPED,
#            ' ',sr.rma20
#      PRINT g_x[10] CLIPPED,' ',sr.rma03  CLIPPED,'(',sr.rma04 CLIPPED,")",
#            COLUMN (g_len-FGL_WIDTH(g_x[12] CLIPPED)-10),g_x[12] CLIPPED,
#           #COLUMN 60,g_x[12] CLIPPED,
#            ' ',sr.rma21
#      PRINT g_x[13] CLIPPED,' ',sr.rma13  CLIPPED,'(',sr.gen02,')'
#      PRINT g_x[14] CLIPPED,' ',sr.rma14  CLIPPED,'(',sr.gem02,')'
#     #PRINT g_x[2] CLIPPED,' ',g_pdate CLIPPED,' ',TIME,               #No.TQC-6C0213 mark  
#     #      COLUMN g_len-7,g_x[3] CLIPPED,' ',g_pageno USING '<<<'     #No.TQC-6C0213 mark 
#      PRINT g_head CLIPPED,pageno_total                                #No.TQC-6C0213
#      PRINT g_dash[1,g_len]
##No.FUN-580013 --start--
##     PRINT g_x[15] CLIPPED,COLUMN 89,g_x[16] CLIPPED
##    #PRINT "項次     產 品 編 號               品      名             INVO數量   實收數量"
##     PRINT "---- -------------------- ------------------------------",
##           "------------------------------ ",
##           "---------- ----------"
#      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#      PRINTX name = H2 g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
##No.FUN-580013 --end--
#      LET l_last_sw ='n'
#
#    AFTER GROUP OF sr.rma01
#      PRINT g_dash[1,g_len]
##No.FUN-580013 --start--
##     PRINT g_x[4] CLIPPED,
##           COLUMN 87,t_rmb11 USING '--,---,--&',
##           COLUMN 98,t_rmb12 USING '--,---,--&'
#      PRINT COLUMN g_c[31],g_x[4] CLIPPED,
#            COLUMN g_c[34],t_rmb11 USING '--,---,--&',
#            COLUMN g_c[35],t_rmb12 USING '--,---,--&'
##No.FUN-580013 --end--
# 
#    BEFORE GROUP OF sr.rma01
#      SKIP TO TOP OF PAGE
#      LET t_rmb11=0 LET t_rmb12=0
#
#    ON EVERY ROW
##No.FUN-580013 --start--
##     PRINT COLUMN 02,sr.rmb02 USING '--&',
##           COLUMN 06,sr.rmb03,
##           COLUMN 27,sr.rmb05,
##           COLUMN 57,sr.rmb06,
##           COLUMN 90,sr.rmb11 USING '------&',
##           COLUMN 101,sr.rmb12 USING '------&'
#      PRINTX name = D1 COLUMN g_c[31],sr.rmb02 USING '---&',
#                       COLUMN g_c[32],sr.rmb03,
#                       COLUMN g_c[33],sr.rmb05,
#                       COLUMN g_c[34],sr.rmb11 USING '---------&',
#                       COLUMN g_c[35],sr.rmb12 USING '---------&'
#      PRINTX name = D2 COLUMN g_c[38],sr.rmb06
##No.FUN-580013 --end--
#      LET t_rmb11=t_rmb11+sr.rmb11
#      LET t_rmb12=t_rmb12+sr.rmb12
#
### FUN-550114
#    ON LAST ROW
#      LET l_last_sw = 'y'
#
#    PAGE TRAILER
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
#
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
### END FUN-550114
#
#
#  {ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED,COLUMN 59,t_rmb11 USING '---,--&',4 SPACES,
#            t_rmb12 USING '---,--&'}
# 
#END REPORT
##Patch....NO.TQC-610037 <> #
#FUN-730019.....end mark

###GENGRE###START
FUNCTION armg180_grdata()
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
        LET handler = cl_gre_outnam("armg180")
        IF handler IS NOT NULL THEN
            START REPORT armg180_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       #" ORDER BY rma01,rmb02"   #FUN-C20052 mark
                        " ORDER BY lower(rma01),rmb02"   #FUN-C20052 add
          
            DECLARE armg180_datacur1 CURSOR FROM l_sql
            FOREACH armg180_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg180_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg180_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg180_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno     LIKE type_file.num5
    #FUN-B40087-----------add-----str------
    DEFINE l_sum_rmb11  LIKE rmb_file.rmb11
    DEFINE l_sum_rmb12  LIKE rmb_file.rmb12
    #FUN-B40087-----------add-----end------

    
    ORDER EXTERNAL BY sr1.rma01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rma01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rma01
       #FUN-B40087-----------add-----str------
       LET l_sum_rmb11 = GROUP SUM(sr1.rmb11)
       PRINTX l_sum_rmb11
       LET l_sum_rmb12 = GROUP SUM(sr1.rmb12)
       PRINTX l_sum_rmb12
       #FUN-B40087-----------add-----end------

        
        ON LAST ROW

END REPORT
###GENGRE###END
