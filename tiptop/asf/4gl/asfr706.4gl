# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asfr706.4gl
# Descriptions...: LABOR SUMMARY
# Date & Author..: 99/08/09 BY Kammy
# Modify.........: No.MOD-4A0322 04/10/26 By Yuna 作業編號輸入地方不要新增及刪除功能
# Modify.........: No.FUN-580014 05/08/16 By yoyo 憑証類報表原則修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.TQC-5B0153 05/12/09 BY kim 報表欄位不對齊
# Modify.........: NO.FUN-5C0096 06/04/25 BY Claire 報表欄位不對齊
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-720005 07/04/11 By TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                          # Print condition RECORD
               wc     LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(600),      # Where condition
               b      LIKE type_file.chr6,    #No.FUN-680121 VARCHAR(6),
               a01 ARRAY[10] OF LIKE type_file.chr6,    #No.FUN-680121 VARCHAR(6),
               more   LIKE type_file.chr1     #No.FUN-680121  VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
         g_tot,tot       LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE l_table     STRING                        ### FUN-720005 add ###
DEFINE g_sql       STRING                        ### FUN-720005 add ###
DEFINE g_str       STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720005 *** ##
   LET g_sql = "ima01.ima_file.ima01,",    
               "ecb02.ecb_file.ecb02,",   
               "ecb03.ecb_file.ecb03,",  
               "ecb06.ecb_file.ecb06,", 
               "ecb19.ecb_file.ecb19,",
               "ecb38.ecb_file.ecb38,",
               "flag.type_file.num5 "    
  LET l_table = cl_prt_temptable('asfr706',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF# Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
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
  #No.FUN-680121-BEGIN
   CREATE TEMP TABLE r706_tmp(
    tmp01     LIKE type_file.num5,  
    tmp02     LIKE fbb_file.fbb07,
    tmp03     LIKE fbb_file.fbb07)
  #No.FUN-680121-END
  create unique index r706_tmp_01 on r706_tmp(tmp01);
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r706_tm(0,0)        # Input print condition
      ELSE CALL asfr706()        # Read data and create out-file
   END IF
   DROP TABLE r706_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r706_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_ac,i         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(400)
          l_ima571       LIKE ima_file.ima571,
           l_allow_insert  LIKE type_file.num5,          #可新增否  #No.MOD-4A0322        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5            #可刪除否        #No.FUN-680121 SMALLINT
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r706_w AT p_row,p_col
        WITH FORM "asf/42f/asfr706"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   INITIALIZE tm.a01 TO NULL
WHILE TRUE
   DISPLAY BY NAME tm.more # Condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima131
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r706_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   DISPLAY BY NAME tm.more # Condition
 
   CALL SET_COUNT(1)
    #--No.MOD-4A0322--#
   INPUT ARRAY tm.a01 WITHOUT DEFAULTS FROM s_a01.*
             ATTRIBUTE(INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
   #-------END-------#
    BEFORE ROW
      LET l_ac = ARR_CURR()
 
    AFTER FIELD a01
      IF NOT cl_null(tm.a01[l_ac]) THEN
         SELECT COUNT(*) INTO g_cnt FROM ecd_file
          WHERE ecd01=tm.a01[l_ac]
         IF g_cnt = 0 THEN CALL cl_err('','aec-015',0) NEXT FIELD a01 END IF
      END IF
 
    AFTER INPUT  #至少輸入一個製程序號
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT INPUT END IF
      LET g_tot = ARR_COUNT()  #計算輸入總筆數
      FOR i = 1 TO g_tot
            IF NOT cl_null(tm.a01[i]) THEN EXIT INPUT END IF
      END FOR
      IF i = g_tot+1 THEN
            CALL cl_err('','asf-027',1)
            NEXT FIELD a01
      END IF
 
      ON ACTION CONTROLP
         CALL q_ecd(FALSE,TRUE,tm.a01[l_ac]) RETURNING tm.a01[l_ac]
         DISPLAY tm.a01[l_ac] TO s_a01[l_ac].a01
         NEXT FIELD a01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r706_w RETURN END IF
 
   INPUT BY NAME tm.b,tm.more
        WITHOUT DEFAULTS
      AFTER FIELD b
         IF cl_null(tm.b) THEN
            NEXT FIELD b
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #No.B573 010522 BY ANN CHEN
      ON ACTION CONTROLP
         CASE WHEN INFIELD(b)
#                  CALL q_ecu1(0,0,'','')
#                      RETURNING l_ima571,tm.b
#                  CALL FGL_DIALOG_SETBUFFER( l_ima571 )
#                  CALL FGL_DIALOG_SETBUFFER( tm.b )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_ecu1'
    LET g_qryparam.default1 = l_ima571
    LET g_qryparam.default2 = tm.b
    CALL cl_create_qry() RETURNING l_ima571,tm.b
#    CALL FGL_DIALOG_SETBUFFER( l_ima571 )
#    CALL FGL_DIALOG_SETBUFFER( tm.b )
# END genero shell script ADD
################################################################################
                  DISPLAY BY NAME tm.b
              OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r706_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr706'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr706','9031',1)
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
                         " '",tm.b CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr706',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r706_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfr706()
   ERROR ""
END WHILE
   CLOSE WINDOW r706_w
END FUNCTION
 
FUNCTION asfr706()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          tot,i,j   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40),
          l_ima01   LIKE ima_file.ima01,
          sr       RECORD
                   ima01   LIKE ima_file.ima01,    #產品料號
                   ecb02   LIKE ecb_file.ecb02,    #製編
                   ecb03   LIKE ecb_file.ecb03,    #製程序號
                   ecb06   LIKE ecb_file.ecb06,    #作業編號
                   ecb19   LIKE ecb_file.ecb19,
                   ecb38   LIKE ecb_file.ecb38,
                   flag    LIKE type_file.num5     #No.FUN-680121 SMALLINT
                   END RECORD,
    l_str VARCHAR(50),
    l_ecd02 LIKE ecd_file.ecd02
 
     #str FUN-720005 add
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     DELETE FROM r706_tmp
#     CALL cl_outnam('asfr706') RETURNING l_name
#     START REPORT r706_rep TO l_name
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND ecbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND ecbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup')
    #End:FUN-980030
 
 
     LET j = 0
     FOR i = 1 TO 10   
         IF cl_null(tm.a01[i]) THEN CONTINUE FOR END IF
         LET j = j + 1
         LET l_sql = " SELECT ima01,ecb02,ecb03,ecb06,ecb19,ecb38,0 ",
                     "  FROM ecb_file,ecu_file,ima_file ",
                     " WHERE ecu01 = ecb01 ",
                     #"  AND  ima01 = ecu01 ",  #No.B573
                     "  AND  ima571=ecu01 ",  #No.B573
                     "  AND  ecb02 = '",tm.b,"'",
                     "  AND  ecb06 = '",tm.a01[i] ,"'",
                     "  AND  ecu02 = ecb02 ",
                     "  AND ",tm.wc CLIPPED
 
        PREPARE r706_pre FROM l_sql
        IF SQLCA.sqlcode THEN  CALL cl_err('r706_pre',STATUS,1) END IF
        DECLARE r706_cur CURSOR FOR r706_pre
        IF SQLCA.sqlcode THEN  CALL cl_err('r706_cur',STATUS,1) END IF
 
        FOREACH r706_cur INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET sr.flag  = j
          LET sr.ecb19 = sr.ecb19 / 60
          MESSAGE sr.ecb02
          CALL ui.Interface.refresh()
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
           EXECUTE insert_prep USING sr.*
           #------------------------------ CR (3) ------------------------------#
 
 #         OUTPUT TO REPORT r706_rep(sr.*,g_tot)
        END FOREACH
    END FOR
 #str FUN-720005 add
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080
 #是否列印選擇條件
 IF g_zz05 = 'Y' THEN
    CALL cl_wcchp(tm.wc,'ima01,ima131')
         RETURNING tm.wc
    LET g_str = tm.wc
 END IF
 LET g_str = g_str CLIPPED,";",tm.b
      FOR i = 1 TO 10
         IF cl_null(tm.a01[i]) THEN CONTINUE FOR END IF
         LET j = j + 1
         LET l_ecd02 = ' '
         SELECT ecd02 INTO l_ecd02 FROM ecd_file
         WHERE ecd01 = tm.a01[i]
         LET l_str=tm.a01[i] CLIPPED,l_ecd02
         LET g_str=g_str CLIPPED,";",l_str
      END FOR
 CALL cl_prt_cs3('asfr706','asfr706',l_sql,g_str)   #FUN-710080 modify
 #------------------------------ CR (4) ------------------------------#
 
 #    FINISH REPORT r706_rep
 #    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r706_rep(sr,l_count)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1),
          i,l_count,j   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_n           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_ecb38  LIKE ecb_file.ecb38,
          l_ecb19  LIKE ecb_file.ecb19,
          l_ecd02  LIKE ecd_file.ecd02,
          sr       RECORD
                   ima01   LIKE ima_file.ima01,    #產品料號
                   ecb02   LIKE ecb_file.ecb02,    #製編
                   ecb03   LIKE ecb_file.ecb03,    #製程序號
                   ecb06   LIKE ecb_file.ecb06,    #作業編號
                   ecb19   LIKE ecb_file.ecb19,
                   ecb38   LIKE ecb_file.ecb38,
                   flag    LIKE type_file.num5     #No.FUN-680121 SMALLINT
                   END RECORD
 
  OUTPUT TOP MARGIN g_top_margin  LEFT  MARGIN 0 BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ecb02,sr.ima01,sr.flag   #製程編號,產品料號
 
  FORMAT
    PAGE HEADER
#No.FUN-580014--start
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF cl_null(g_towhom) THEN
#        PRINT '';
#     ELSE
#        PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT g_x[2] CLIPPED,g_today,TIME,
#           COLUMN (g_len-7),g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
#No.FUN-580014--end
 
 
    BEFORE GROUP OF sr.ecb02
      PRINT g_x[12] CLIPPED,sr.ecb02 CLIPPED #製編
      PRINT g_dash[1,g_len]
 
      LET j = 0
      FOR i = 1 TO 10
         IF cl_null(tm.a01[i]) THEN CONTINUE FOR END IF
         LET j = j + 1
         LET l_ecd02 = ' '
         SELECT ecd02 INTO l_ecd02 FROM ecd_file
         WHERE ecd01 = tm.a01[i]
         IF i = 1 THEN
#           PRINT COLUMN 23,tm.a01[i] CLIPPED,COLUMN 27,l_ecd02[1,10] ;
            LET g_zaa[32].zaa08=tm.a01[i] CLIPPED,l_ecd02[1,10]
         ELSE
#           PRINT COLUMN (23+(j-1)*16),tm.a01[i] CLIPPED,l_ecd02[1,10];
            LET g_zaa[32+j].zaa08=tm.a01[i] CLIPPED,l_ecd02[1,10]
         END IF
      END FOR
 
      PRINT ' '
 
#     FOR i = 1 TO 10
#         IF i = 1 THEN
#           PRINT COLUMN 9,g_x[9] CLIPPED,COLUMN 23,g_x[10] CLIPPED;
#           PRINT COLUMN (23+(i-1)*16),g_x[10] CLIPPED;
#         END IF
#    END FOR
#    PRINT ' '
#    PRINT '--------------------';
#    FOR i = 1 TO 10 PRINT ' ','---------------'; END FOR
#    PRINT ' '
     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
     PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]
     PRINT g_dash1
#No.FUN-580014--end
  BEFORE GROUP OF sr.ima01
#    PRINT sr.ima01[1,20] CLIPPED;
     #PRINTX name=D2 COLUMN g_c[42],sr.ima01[1,20] CLIPPED;           #No.FUN-580014
     PRINTX name=D2 COLUMN g_c[42],sr.ima01 CLIPPED;           #No.FUN-5B0015
 
  AFTER GROUP OF sr.flag
     LET l_n = 0
     SELECT COUNT(*) INTO l_n FROM r706_tmp
      WHERE tmp01=sr.flag
     IF l_n > 0 THEN
        UPDATE r706_tmp SET tmp02=tmp02+sr.ecb38,
                            tmp03=tmp03+sr.ecb19
         WHERE tmp01=sr.flag
     ELSE
         INSERT INTO r706_tmp VALUES(sr.flag,sr.ecb38,sr.ecb19)
     END IF
 
  AFTER GROUP OF sr.ima01
      PRINTX name=D2
            COLUMN g_c[43],GROUP SUM(sr.ecb38) WHERE sr.flag=1 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=1 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[44],GROUP SUM(sr.ecb38) WHERE sr.flag=2 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=2 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[45],GROUP SUM(sr.ecb38) WHERE sr.flag=3 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=3 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[46],GROUP SUM(sr.ecb38) WHERE sr.flag=4 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=4 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[47],GROUP SUM(sr.ecb38) WHERE sr.flag=5 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=5 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[48],GROUP SUM(sr.ecb38) WHERE sr.flag=6 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=6 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[49],GROUP SUM(sr.ecb38) WHERE sr.flag=7 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=7 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[50],GROUP SUM(sr.ecb38) WHERE sr.flag=8 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=8 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[51],GROUP SUM(sr.ecb38) WHERE sr.flag=9 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=9 USING '######.#&';
      PRINTX name=D2
            COLUMN g_c[52],GROUP SUM(sr.ecb38) WHERE sr.flag=10 USING '###.#&',' ',
            GROUP SUM(sr.ecb19) WHERE sr.flag=10 USING '######.#&'
#No.FUN-580014--end
 
  AFTER GROUP OF sr.ecb02
     PRINT ' '
     PRINTX name=S2 COLUMN g_c[42],g_x[11] CLIPPED;                       #No.FUN-580014
     DECLARE r706_tmp_cs CURSOR FOR
      SELECT * FROM r706_tmp ORDER BY tmp01
     FOREACH r706_tmp_cs INTO l_n,l_ecb38,l_ecb19
       PRINT COLUMN g_c[43],l_ecb38 USING '###.#&',' ',l_ecb19 USING '######.#&';                #No.fUN-580014
     END FOREACH
     PRINT ' '
 
  ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
     IF l_last_sw = 'n' THEN
        PRINT g_dash[1,g_len]
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
     ELSE
        SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610037 <> #
