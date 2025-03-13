# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aimr407.4gl
# Descriptions...: 庫存數量表
# Input parameter:
# Return code....:
# Date & Author..: 95/02/10 By Nick
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 產品編號開窗
# Modify.........: No.FUN-510017 05/01/25 By Mandy 報表轉XML
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-7A0036 07/10/30 By baofei 報表輸出至Crystal Reports功能  
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.CHI-8B0023 08/12/05 By claire  沒有勾選倉儲批應以總量呈現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      STRING,                 # TQC-630166
           a,b,c   LIKE type_file.chr1,    # Order by sequence  #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
       i   LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#CHI-8B0023-begin-add
DEFINE g_sql         STRING
DEFINE g_str         STRING
DEFINE l_table       STRING
#CHI-8B0023-end-add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
   #CHI-8B0023-begin-add
   LET g_sql = "img01.img_file.img01,",   
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "img02.img_file.img02,", 
               "img03.img_file.img03,", 
               "img04.img_file.img04,", 
               "img10.img_file.img10,", 
               "img21.img_file.img21,", 
               "l_tot.type_file.num26_10"
   LET l_table = cl_prt_temptable('aimr407',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   #CHI-8B0023-end-add
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610072-begin
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.c = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr407_tm(0,0)        # Input print condition
      ELSE CALL aimr407()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr407_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW aimr407_w AT p_row,p_col
        WITH FORM "aim/42f/aimr407"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP    #FUN-4B0001
         CASE WHEN INFIELD(img01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO img01
              NEXT FIELD img01
         END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr407_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more         # Condition
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS
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
#      ON ACTION CONTROLP CALL aimr407_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr407_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr407'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr407','9031',1)
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
                         " '",tm.a CLIPPED,"'",                 #TQC-610072
                         " '",tm.b CLIPPED,"'",                 #TQC-610072
                         " '",tm.c CLIPPED,"'",                 #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr407',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr407_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr407()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr407_w
END FUNCTION
 
FUNCTION aimr407()
   DEFINE l_name    LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                 #TQC-630166 
          g_str     STRING,                 #No.FUN-7A0036 
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_i       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr        RECORD img01   LIKE img_file.img01,    #
                           #ima02  VARCHAR(30),             #FUN-660078 remari
                           #ima021 VARCHAR(30),             #FUN-660078 remark
                           #ima25  VARCHAR(4),              #FUN-660078 remark
                           ima02   LIKE ima_file.ima02,  #FUN-660078
                           ima021  LIKE ima_file.ima021, #FUN-660078
                           ima25   LIKE ima_file.ima25,  #FUN-660078
                           img02   LIKE img_file.img02,
                           img03   LIKE img_file.img03,
                           img04   LIKE img_file.img04,
                           img10   LIKE img_file.img10,  #CHI-8B0023 modify
                           img21   LIKE img_file.img21,  #CHI-8B0023 add
                           l_tot   LIKE type_file.num26_10   #CHI-8B0023 add
                    END RECORD
 
     CALL cl_del_data(l_table)        #CHI-8B0023 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #CHI-8B0023-begin-add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM
   END IF
   #CHI-8B0023-end-add
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT img01,ima02,ima021,ima25,img02,",
#               "img03,img04,img10*img21,''",      #No.FUN-7A0036
               #"img03,img04,img10,img21,''",       #No.FUN-7A0036  #CHI-8B0023 mark
               "img03,img04,img10,img21,img10*img21", #CHI-8B0023 
               "  FROM img_file, ima_file ",
               " WHERE ",tm.wc,
               "   AND img10 > 0 ",
               "   AND img01=ima01"
 
      #CHI-8B0023-begin-add
      PREPARE r407_prepare FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r407_cs CURSOR FOR r407_prepare
 
      FOREACH r407_cs INTO sr.*
         IF cl_null(sr.img02) THEN LET sr.img02=' ' END IF 
         IF cl_null(sr.img03) THEN LET sr.img03=' ' END IF 
         IF cl_null(sr.img04) THEN LET sr.img04=' ' END IF 
         IF tm.a <> 'Y' THEN LET sr.img02=' ' END IF  
         IF tm.b <> 'Y' THEN LET sr.img03=' ' END IF  
         IF tm.c <> 'Y' THEN LET sr.img04=' ' END IF  
         EXECUTE insert_prep USING sr.*
      END FOREACH
 
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
      #CHI-8B0023-end-add
 
#No.FUN-7A0036----Begin 
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
      IF g_zz05 = 'Y' THEN                                                        
        CALL cl_wcchp(tm.wc,'img01,img02,img03,img04')   
            RETURNING tm.wc                                                     
      END IF
      LET g_str = tm.wc                                                        
      LET g_str = g_str,";",tm.a,";",tm.b,";",tm.c
 
     #CALL cl_prt_cs1('aimr407','aimr407',l_sql,g_str)   #CHI-8B0023 mark
      CALL cl_prt_cs3('aimr407','aimr407',g_sql,g_str)   #CHI-8B0023
 
#     PREPARE aimr407_prepare1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#        EXIT PROGRAM
#           
#     END IF
#     DECLARE aimr407_curs1 CURSOR FOR aimr407_prepare1
#
#     CALL cl_outnam('aimr407') RETURNING l_name
#     START REPORT aimr407_rep TO l_name
#
#     LET g_pageno = 0
#     FOREACH aimr407_curs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       IF tm.a = 'N' THEN LET sr.img02=' ' END IF
#       IF tm.b = 'N' THEN LET sr.img03=' ' END IF
#       IF tm.c = 'N' THEN LET sr.img04=' ' END IF
#       OUTPUT TO REPORT aimr407_rep(sr.*)
#     END FOREACH
#
#     FINISH REPORT aimr407_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7A0036----End
END FUNCTION
 
#No.FUN-7A0036----Begin
{REPORT aimr407_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,                #No.FUN-690026 VARCHAR(1)
          sr           RECORD img01   LIKE img_file.img01, #
                              #ima02  VARCHAR(30),            #FUN-660078 remark
                              #ima021 VARCHAR(30),            #FUN-660078 remark
                              # Prog. Version..: '5.30.06-13.03.12(04),            #FUN-660078 remark
                              ima02   LIKE ima_file.ima02, #FUN-660078
                              ima021  LIKE ima_file.ima021,#FUN-660078
                              ima25   LIKE ima_file.ima25, #FUN-660078
                              img02   LIKE img_file.img02,
                              img03   LIKE img_file.img03,
                              img04   LIKE img_file.img04,
                              img10   LIKE img_file.img10
                       END RECORD,
          l_count      LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.img01,sr.img02,sr.img03,sr.img04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.img01
         PRINT COLUMN g_c[31],sr.img01,
               COLUMN g_c[32],sr.ima02,
               COLUMN g_c[33],sr.ima021;
 
   ON EVERY ROW
         PRINT COLUMN g_c[34],sr.img02,
               COLUMN g_c[35],sr.img03,
               COLUMN g_c[36],sr.img04,
               COLUMN g_c[37],cl_numfor(sr.img10,37,3),
               COLUMN g_c[38],sr.ima25
 
   AFTER GROUP OF sr.img01
      PRINT COLUMN g_c[36],g_x[11] clipped,
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.img10),37,3),
            COLUMN g_c[38],sr.ima25
      PRINT
 
   ON LAST ROW
      PRINT COLUMN g_c[36],g_x[12] clipped,
            COLUMN g_c[37],cl_numfor(SUM(sr.img10),37,3)
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,img23,img15')
              RETURNING tm.wc
         PRINT g_dash
       #TQC-630166
       #       IF tm.wc[001,070] > ' ' THEN            # for 80
       #  PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
       #       IF tm.wc[071,140] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
       #       IF tm.wc[141,210] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
       #       IF tm.wc[211,280] > ' ' THEN
       #  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#      #       IF tm.wc[001,120] > ' ' THEN            # for 132
#      #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#      #       IF tm.wc[121,240] > ' ' THEN
#      #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#      #       IF tm.wc[241,300] > ' ' THEN
#      #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
       CALL cl_prt_pos_wc(tm.wc)
       #END TQC-630166
 
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-7A0036----End
