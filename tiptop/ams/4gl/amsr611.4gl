# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amsr611.4gl
# Desc/riptions..: 資源別產能負荷明細表
# Date & Author..: 00/08/010 By Byron
# Modify.........: No.FUN-510036 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-550056 05/05/20 By Trisy 單據編號加大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-680101 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: NO.FUN-850045 08/05/15 By zhaijie老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-D10044 13/01/09 By xuxz 添加rqa01開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
             wc       STRING,       # Where condition #TQC-630166
             ver_no   LIKE rqa_file.rqa02,  #版本
             more     LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)    # Input more condition(Y/N)
          END RECORD,
         g_flag       LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
DEFINE   g_cnt        LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_i          LIKE type_file.num5     #NO.FUN-680101 SMALLINT   #count/index for any purpose
#NO.FUN-850045--start---
DEFINE   g_sql       STRING
DEFINE   g_str       STRING
DEFINE   l_table     STRING
#NO.FUN-850045--end-----
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
#NO.FUN-850045--start---
   LET g_sql ="rqa01.rqa_file.rqa01,",
              "rqa03.rqa_file.rqa03,",
              "rqa04.rqa_file.rqa04,",
              "rqa05.rqa_file.rqa05,",
              "rqa06.rqa_file.rqa06,",
              "rpf02.rpf_file.rpf02,",
              "rpf03.rpf_file.rpf03,",
              "rqb06.rqb_file.rqb06,",
              "rqb08.rqb_file.rqb08,",
              "rqb09.rqb_file.rqb09"
   LET l_table = cl_prt_temptable('amsr611',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF              
#NO.FUN-850045--end-----
 
   LET g_pdate = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'    # If background job sw is off
      THEN CALL r611_tm(0,0)        # Input print condition
      ELSE CALL amsr611()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r611_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #NO.FUN-680101 SMALLINT
          l_flag        LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(01)
          l_cmd         LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 7 LET p_col = 32
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r611_w AT p_row,p_col
        WITH FORM "ams/42f/amsr611"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
    LET tm.ver_no=' '
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON rqa01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
        #TQC-D10044--add-str--資源代號開窗
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rqa01)      #請購單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rqa01"
                  LET g_qryparam.state= "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rqa01
                  NEXT FIELD rqa01
         END CASE
         #TQC-D10044--add--end
 
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
 
		
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      IF tm.wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      LET tm.ver_no=' '
      LET tm.more = 'N'
      INPUT BY NAME tm.ver_no,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD ver_no
#           IF cl_null(tm.ver_no) THEN
#              CALL cl_err('','9033',0)
#              NEXT FIELD ver_no
#           ELSE
               SELECT COUNT(*) INTO g_cnt
                FROM rqa_file WHERE rqa02 = tm.ver_no
               IF g_cnt IS NULL OR g_cnt = 0 THEN
                  CALL cl_err(tm.ver_no,'ams-367',1)
                  LET tm.ver_no=' '
                  NEXT FIELD ver_no
               END IF
#          END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' THEN
               CALL cl_err('','9061',0)
             #  LET tm.more=' '
               NEXT FIELD more
            END IF
            If cl_null(tm.more) THEN
               CALL cl_err('','9033',0)
               NEXT FIELD more
            END IF
            IF tm.more = 'Y'  #cl_repcon只負責傳值的動作
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
              g_bgjob,g_time,g_prtway,g_copies)
              RETURNING g_pdate,g_towhom,g_rlang,
              g_bgjob,g_time,g_prtway,g_copies
              LET INT_FLAG=0 #因在開副程式時,只要按del INT_FLAG就等於1
                             #故要還原
            END IF
         AFTER INPUT #INPUT欄位時,INPUT完後的判斷
            IF INT_FLAG THEN  #USER按del時INT_FLAG=1時的判斷
               LET INT_FLAG = 0 CLOSE WINDOW r611_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
               EXIT PROGRAM
                  
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
         LET INT_FLAG = 0 CLOSE WINDOW r611_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsr611'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('amsr611','9031',1)
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
                   " '",tm.ver_no CLIPPED,"'",
                   " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                   " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                   " '",g_template CLIPPED,"'"            #No.FUN-570264
             CALL cl_cmdat('amsr611',g_time,l_cmd)   # Execute cmd at later time
         END IF
         CLOSE WINDOW r611_w #後來自己加的
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM        #後來自己加的
      END IF
      CALL cl_wait()
      CALL amsr611()
      ERROR ""
   END WHILE
   CLOSE WINDOW r611_w
END FUNCTION
 
FUNCTION amsr611()
   DEFINE
      l_name    LIKE type_file.chr20,   #NO.FUN-680101 VARCHAR(20)    # External(Disk) file name
#       l_time      LIKE type_file.chr8        #No.FUN-6A0081
      l_sql     LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(1000)  # RDSQL STATEMENT
      l_chr     LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
      l_za05    LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(40)
      l_date    LIKE type_file.dat,     #NO.FUN-680101 DATE
      sr        RECORD #要列印出來的資料放在sr
        rqa01   LIKE rqa_file.rqa01, #資源代號
        rqa03   LIKE rqa_file.rqa03, #起始日期
        rqa04   LIKE rqa_file.rqa04, #截止日期
        rqa05   LIKE rqa_file.rqa05, #當日產能
        rqa06   LIKE rqa_file.rqa06, #已耗產能
        rpf02   LIKE rpf_file.rpf02, #資源名稱
        rpf03   LIKE rpf_file.rpf03, #產能單位
        rqb06   LIKE rqb_file.rqb06, #來源單號
        rqb08   LIKE rqb_file.rqb08, #數量
        rqb09   LIKE rqb_file.rqb09  #耗用產能
      END RECORD
   CALL cl_del_data(l_table)                     #NO.FUN-850045
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amdi001' #NO.FUN-850045
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND rqauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND rqagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND rqagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rqauser', 'rqagrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT ",
               " rqa01,rqa03,rqa04,rqa05,rqa06,rpf02, ",
               "  rpf03,rqb06,rqb08,rqb09  ",
               " FROM rqa_file,rpf_file ,rqb_file",
               " WHERE rqa02 = '",tm.ver_no,"'",
               "  AND rqa01=rpf01 ",
               "  AND rqa01=rqb01 ",
               "  AND rqa02=rqb02 ",
               "  AND rqa03=rqb03 ",
               "  AND rqa04=rqb04 ",
               "  AND ",tm.wc CLIPPED
   PREPARE r611_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   DECLARE r611_cs1 CURSOR FOR r611_prepare1
#   CALL cl_outnam('amsr611') RETURNING l_name              #NO.FUN-850045
#   START REPORT r611_rep TO l_name                         #NO.FUN-850045
#   LET g_pageno = 0                                        #NO.FUN-850045
   FOREACH r611_cs1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#      OUTPUT TO REPORT r611_rep(sr.*)                      #NO.FUN-850045
#NO.FUN-850045--start---
      EXECUTE insert_prep USING
        sr.rqa01,sr.rqa03,sr.rqa04,sr.rqa05,sr.rqa06,sr.rpf02,sr.rpf03,
        sr.rqb06,sr.rqb08,sr.rqb09
#NO.FUN-850045--end-----
   END FOREACH
#   FINISH REPORT r611_rep                                  #NO.FUN-850045
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)             #NO.FUN-850045
#NO.FUN-850045--start-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'rqa01')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('amsr611','amsr611',g_sql,g_str) 
#NO.FUN-850045----end----
END FUNCTION
#NO.FUN-850045--start---mark---
#REPORT r611_rep(sr)
#   DEFINE
#   l_last_sw   LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
#   l_dash      LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
#   l_sw        LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
#   l_str       LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(50)
#   l_diff      LIKE rqa_file.rqa05,
#   l_diffpr    LIKE rqa_file.rqa05,    #NO.FUN-680101 DECIMAL(12,3)
#   sr          RECORD
#       rqa01   LIKE rqa_file.rqa01, #parts no
#       rqa03   LIKE rqa_file.rqa03, #計劃種類
#       rqa04   LIKE rqa_file.rqa04,
#       rqa05   LIKE rqa_file.rqa05, #計劃類別
#       rqa06   LIKE rqa_file.rqa06, #stock no
#       rpf02   LIKE rpf_file.rpf02, #begin date
#       rpf03   LIKE rpf_file.rpf03,  #end date
#       rqb06   LIKE rqb_file.rqb06, #來源單號
#       rqb08   LIKE rqb_file.rqb08, #數量
#       rqb09   LIKE rqb_file.rqb09  #耗用產能
#           END RECORD
#
#    OUTPUT TOP MARGIN g_top_margin
#           LEFT MARGIN g_left_margin
#           BOTTOM MARGIN g_bottom_margin
#           PAGE LENGTH g_page_line   #No.MOD-580242
#
#   ORDER BY sr.rqa01,sr.rqa03,sr.rqb06
#   FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.rqa01
#     LET g_flag = 'N'
#     PRINT COLUMN g_c[31],sr.rqa01,
#           COLUMN g_c[32],sr.rpf02,
#           COLUMN g_c[33],sr.rpf03,
#           COLUMN g_c[34],sr.rqa03,
#           COLUMN g_c[35],sr.rqa04,
#           COLUMN g_c[36],cl_numfor(sr.rqa05,36,0),
#           COLUMN g_c[37],cl_numfor(sr.rqa06,37,0);
# 
#   ON EVERY ROW
#      IF g_flag='N'
#         THEN
#         LET l_diff   = sr.rqa05 - sr.rqa06
#         LET l_diffpr = sr.rqa06 / sr.rqa05 * 100
#         PRINT COLUMN g_c[38],cl_numfor(l_diff,38,0),
#               COLUMN g_c[39],l_diffpr USING "------&",
##              COLUMN g_c[40],sr.rqb06[1,13],
#               COLUMN g_c[40],sr.rqb06,    #No.FUN-550056
#               COLUMN g_c[41],cl_numfor(sr.rqb08,41,0),
#               COLUMN g_c[42],cl_numfor(sr.rqb09,42,0)
#         LET g_flag = 'Y'
#      ELSE
##         PRINT COLUMN g_c[40],sr.rqb06[1,13],
#          PRINT COLUMN g_c[40],sr.rqb06,    #No.FUN-550056
#                COLUMN g_c[41],cl_numfor(sr.rqb08,41,0),
#                COLUMN g_c[42],cl_numfor(sr.rqb09,42,0)
#      END IF
 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,611
#          PRINT g_dash[1,g_len]
#          #TQC-630166 Start
#          #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED
#          #IF tm.wc[121,240] > ' ' THEN
#          #  PRINT COLUMN 10,     tm.wc[121,240] CLIPPED
#          #END IF
#          #IF tm.wc[241,611] > ' ' THEN
#          #  PRINT COLUMN 10,     tm.wc[241,611] CLIPPED
#          #END IF
#          
#          CALL cl_prt_pos_wc(tm.wc)
#          #TQC-630166 End
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-850045--end---mark---
#FUN-870144
