# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: armr150.4gl
# Descriptions...: RMA未出貨明細表列印
# Date & Author..: 97/02/12 By Alan
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-510044 05/02/02 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-750093 07/06/13 By jan 報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/31 By jan 報表打印條件的增加
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),        # Where condition
              rmc08   LIKE type_file.dat,     #No.FUN-690010 DATE,
              choice  LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),          # Print Ordered
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_order     LIKE type_file.chr20       #No.FUN-690010 VARCHAR(11)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_str        STRING          #No.FUN-750093
DEFINE   l_table      STRING          #No.FUN-750093
DEFINE   g_sql        STRING          #No.FUN-750093
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
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
   LET tm.wc = ARG_VAL(7)
   LET tm.rmc08 = ARG_VAL(8)
   LET tm.choice = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL armr150_tm(0,0)        # Input print condition
      ELSE 
         CALL armr150()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
END MAIN
 
FUNCTION armr150_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW armr150_w AT p_row,p_col
        WITH FORM "arm/42f/armr150"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.choice = '1'
   LET tm.more = 'N'
   LET tm.rmc08 = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.rmc08,tm.choice,tm.more
   CONSTRUCT BY NAME tm.wc ON rma03,rma07
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
      LET INT_FLAG = 0 CLOSE WINDOW armr150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.rmc08,tm.choice,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD rmc08
        IF cl_null(tm.rmc08) THEN NEXT FIELD rmc08 END IF
      AFTER FIELD choice
        IF cl_null(tm.choice) THEN NEXT FIELD choice END IF
        IF tm.choice='1' THEN LET g_order = 'rma03,rma12'
        ELSE
           LET g_order = 'rma12,rma03'
        END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW armr150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr150','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.rmc08 CLIPPED,"'",             #No.TQC-610087 add
                         " '",tm.choice CLIPPED,"'",            #No.TQC-610087 add 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('armr150',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr150()
   ERROR ""
END WHILE
   CLOSE WINDOW armr150_w
END FUNCTION
 
FUNCTION armr150()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          sr     RECORD  order1 LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
                    rmc01  LIKE rmc_file.rmc01,
                    rmc02  LIKE rmc_file.rmc02,
                    rmc04  LIKE rmc_file.rmc04,
                    rmc06  LIKE rmc_file.rmc06,
                    rmc061 LIKE rmc_file.rmc061,
                    rmc07  LIKE rmc_file.rmc07,
                    occ02  LIKE occ_file.occ02,
                    rma03  LIKE rma_file.rma03,
                    rma12  LIKE rma_file.rma12,
                    rmc09  LIKE rmc_file.rmc09,
                    rmc16  LIKE rmc_file.rmc16
                 END RECORD
#No.FUN-750093--Begin
    LET g_sql = " rmc01.rmc_file.rmc01,",
                " rmc02.rmc_file.rmc02,",
                " rmc04.rmc_file.rmc04,",
                " rmc06.rmc_file.rmc06,",
                " rmc07.rmc_file.rmc07,",
                " rma03.rma_file.rma03,",
                " occ02.occ_file.occ02,",
                " rma12.rma_file.rma12,",
                " rmc09.rmc_file.rmc09,",
                " rmc16.rmc_file.rmc16,",
                " rmc061.rmc_file.rmc061"
         
    LET l_table = cl_prt_temptable('armr150',g_sql) CLIPPED
    IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM

    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
       EXIT PROGRAM
    END IF
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-750093--End
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
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
 
     LET l_sql = "SELECT ' ',rmc01,rmc02,rmc04,rmc06,rmc061,rmc07,",
                 "       occ02,rma03,rma12,rmc09,rmc16",
                 "  FROM rmc_file,oay_file,rma_file,OUTER occ_file ",
                 " WHERE rma_file.rma03=occ_file.occ01 AND rma01=rmc01 ",
                 " AND (rmc14='1' OR rmc14='2' ) AND rmc08<='",tm.rmc08,"'",
#                " AND rma01[1,3]=oayslip",
                 " AND rma01 like ltrim(rtrim(oayslip)) || '_%'",     #No.FUN-550064
                 " AND oaytype='70' ",
                 " AND rma09 != '6' AND rmc21='0' ",
                 " AND rmavoid='Y' AND  ",tm.wc CLIPPED
 
     PREPARE armr150_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr150_curs1 CURSOR FOR armr150_prepare1
 
#    CALL cl_outnam('armr150') RETURNING l_name     #No.FUN-750093
#    START REPORT armr150_rep TO l_name             #No.FUN-750093
 
     LET g_pageno = 0
     FOREACH armr150_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF tm.choice="1" THEN LET sr.order1=sr.rma03,sr.rma12 USING 'yyyymmdd'
       END IF
       IF tm.choice="2" THEN LET sr.order1=sr.rma12 USING 'yyyymmdd',
                                           sr.rma03  END IF
#No.FUN-750093--Begin
#     OUTPUT TO REPORT armr150_rep(sr.*)
      EXECUTE insert_prep USING
              sr.rmc01,sr.rmc02,sr.rmc04,sr.rmc06,sr.rmc07,sr.rma03,sr.occ02,
              sr.rma12,sr.rmc09,sr.rmc16,sr.rmc061
     END FOREACH
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
#No.FUN-760086--Begin                                                           
     IF g_zz05 = 'Y' THEN                                                         
          CALL cl_wcchp(tm.wc,'rma03,rma07')                              
                RETURNING g_str
     END IF
     LET g_str = tm.choice,";",g_str
#No.FUN_760086--End
     CALL cl_prt_cs3('armr150','armr150',l_sql,g_str)
 
#    FINISH REPORT armr150_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--End
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT armr150_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
          sr   RECORD order1 LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
                      rmc01  LIKE rmc_file.rmc01,
                      rmc02  LIKE rmc_file.rmc02,
                      rmc04  LIKE rmc_file.rmc04,
                      rmc06  LIKE rmc_file.rmc06,
                      rmc061 LIKE rmc_file.rmc061,
                      rmc07  LIKE rmc_file.rmc07,
                      occ02  LIKE occ_file.occ02,
                      rma03  LIKE rma_file.rma03,
                      rma12  LIKE rma_file.rma12,
                      rmc09  LIKE rmc_file.rmc09,
                      rmc16  LIKE rmc_file.rmc16
                      END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.rmc01,sr.rmc02
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H2 g_x[41],g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINTX name=D1 COLUMN g_c[31],sr.rmc01,
                     COLUMN g_c[32],sr.rmc02 USING '---&',
                     COLUMN g_c[33],sr.rmc04,
                     COLUMN g_c[34],sr.rmc06,
                     COLUMN g_c[35],sr.rmc07,
                     COLUMN g_c[36],sr.rma03,
                     COLUMN g_c[37],sr.occ02,
                     COLUMN g_c[38],sr.rma12,
                     COLUMN g_c[39],sr.rmc09,
                     COLUMN g_c[40],sr.rmc16
      PRINTX name=D2 COLUMN g_c[41],' ',
                     COLUMN g_c[42],sr.rmc061
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT ' ',g_x[4] CLIPPED,COLUMN (g_len-10),g_x[7]
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
      PRINT ' ',g_x[4] CLIPPED,COLUMN (g_len-10),g_x[6]
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093--End
