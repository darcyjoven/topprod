# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aglr404.4gl
# Descriptions...: 傳票簽核狀況表
# Input parameter:
# Return code....:
# Date & Author..: 92/09/23 By yen
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-510007 05/02/21 By Nicola 報表架構修改
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-B70028 11/09/27 By Polly 增加帳別選項
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      STRING,         # Where condition
              s       LIKE type_file.chr3,         # Order by sequence  #No.FUN-680098  VARCHAR(3)
              a       LIKE azc_file.azc03,         # 應簽核人員    #No.FUN-680098 VARCHAR(6)
              b       LIKE type_file.chr1,         # 是否僅列印該人員應簽傳票(Y/N) #No.FUN-680098  VARCHAR(1)    
              more    LIKE type_file.chr1          # Input more condition(Y/N)     #No.FUN-680098  VARCHAR(1)    
              END RECORD,
          g_bookno   LIKE aah_file.aah00,   #帳別   #TQC-610056
          a_name     LIKE gen_file.gen02    #簽核人猿姓名   #No.FUN-680098  VARCHAR(8)
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098 smallint
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_bookno= ARG_VAL(1)   #TQC-610056
   #-----No.MOD-4C0171-----
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
   LET tm.b  = ARG_VAL(11)
   LET g_bookno  = ARG_VAL(12)    #CHI-B70028 add
  #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
  #No.FUN-570264 ---end---
  #-----No.MOD-4C0171 END-----
  #-----------------------------------CHI-B70028---------------------start
  #-->帳別若為空白則使用預設帳別
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
      LET g_bookno = g_aaz.aaz64
   END IF
  #-----------------------------------CHI-B70028---------------------start
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aglr404_tm(0,0)        # Input print condition
      ELSE CALL aglr404()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr404_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680098 SMALLINT
          l_cmd       LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(400)    
DEFINE li_chk_bookno  LIKE type_file.num5         #No.CHI-B70028   add
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW aglr404_w AT p_row,p_col
        WITH FORM "agl/42f/aglr404"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.b    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
 
WHILE TRUE
#------------------------------CHI-B70028-------------------------------------start
   INPUT g_bookno FROM aba00 ATTRIBUTE(WITHOUT DEFAULTS)
      AFTER FIELD aba00
        IF NOT cl_null(g_bookno) THEN
           CALL s_check_bookno(g_bookno,g_user,g_plant)
           RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
               NEXT FIELD aba00
           END IF
           SELECT aaa02 FROM aaa_file WHERE aaa01 = g_bookno
           IF STATUS THEN
              CALL cl_err3("sel","aaa_file",g_bookno,"","agl-043","","",0)
              NEXT FIELD  aba00
           END IF
         END IF
      ON ACTION CONTROLP
         CASE
          WHEN INFIELD(aba00)
               CALL cl_init_qry_var()                 #帳別編號
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = g_bookno
               CALL cl_create_qry() RETURNING g_bookno
               DISPLAY BY NAME g_bookno
               NEXT FIELD aba00
          OTHERWISE EXIT CASE
         END CASE
      END INPUT
#------------------------------CHI-B70028----------------------------------------end
   CONSTRUCT BY NAME tm.wc ON aba01,aba02,aba05,aba06,aba08
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
      LET INT_FLAG = 0 CLOSE WINDOW aglr404_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.s,tm.b,tm.more         # Condition
   INPUT BY NAME tm.a,tm2.s1,tm2.s2,tm2.s3,
                 tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a = ' ' THEN
            NEXT FIELD a
         END IF
         SELECT UNIQUE gen02 INTO a_name
             FROM gen_file,azc_file
             WHERE gen01 = azc03 AND azc03 = tm.a
         IF SQLCA.sqlcode != 0 THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("sel","gen_file,azc_file",tm.a,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
            NEXT FIELD a
         END IF
         DISPLAY a_name TO FORMONLY.a_name
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]"
            THEN NEXT FIELD b
         END IF
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW aglr404_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr404'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr404','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'",   #TQC-610056
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_bookno CLIPPED,"'",             #CHI-B70028
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr404',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr404_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr404()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr404_w
END FUNCTION
 
FUNCTION aglr404()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098  VARCHAR(20)    
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT     #No.FUN-680098  VARCHAR(1000)    
          l_cnt     LIKE type_file.num5,          # 計算未簽人數        #No.FUN-680098 smallint
          l_order   ARRAY[5] OF LIKE type_file.chr20,                    #No.FUN-680098 VARCHAR(10)
          sr        RECORD
#                      order1 VARCHAR(10),
                       order1 LIKE type_file.chr20,     #No.FUN-550028    #No.FUN-680098 VARCHAR(16)
#                      order2 VARCHAR(10),  
                       order2  LIKE type_file.chr20,      #No.FUN-550028    #No.FUN-680098 VARCHAR(16)
#                      order3 VARCHAR(10),
                       order3  LIKE type_file.chr20,     #No.FUN-550028    #No.FUN-680098 VARCHAR(16)
                       aba01 LIKE aba_file.aba01,     #傳票編號
                       aba02 LIKE aba_file.aba02,     #傳票日期
                       abasign LIKE aba_file.abasign, #簽核等級
                       aba08 LIKE aba_file.aba08,     #借方金額
                       azc02 LIKE azc_file.azc02,     #簽核順序
                       azc03 LIKE azc_file.azc03,     #簽核人員代號
                       azd04 LIKE azd_file.azd04,     #簽核日期
                       aba05 LIKE aba_file.aba05,     #輸入日期
                       aba06 LIKE aba_file.aba06,     #來源碼
                       abasseq LIKE aba_file.abasseq  #已簽等級
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "       aba01, aba02, abasign, aba08,",
                 "       azc02, azc03, azd04",
                 "  FROM aba_file LEFT OUTER JOIN azd_file ON aba01 = azd_file.azd01 AND azd_file.azd02 = 4,azc_file",
                #" WHERE aba00 = '",g_aaz.aaz64,"'",                  #No.CHI-B70028 mark
                 " WHERE aba00 = '",g_bookno,"'",                     #No.CHI-B70028 add
                 "   AND abasign = azc01",
                 "   AND azc03 = '",tm.a,"'",
                 
                 "   AND abaacti = 'Y'",
                 "   AND abamksg = 'Y'",
                 "   AND abasseq < abasmax",
                 "   AND ",tm.wc
#    LET l_sql = l_sql CLIPPED," ORDER BY aba01,gkc03"
     PREPARE aglr404_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
     END IF
     DECLARE aglr404_curs1 CURSOR FOR aglr404_prepare1
 
     CALL cl_outnam('aglr404') RETURNING l_name
     START REPORT aglr404_rep TO l_name
 
     LET g_pageno = 0
     FOREACH aglr404_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
       #IF sr.azd04 IS NOT NULL AND sr.azd04 != ' ' THEN
        IF sr.azd04 IS NOT NULL THEN
            CONTINUE FOREACH
        END IF
        LET l_cnt = sr.azc02 - sr.abasseq
        IF tm.b = 'Y' THEN
            IF l_cnt != 1 THEN
                CONTINUE FOREACH
            END IF
        END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.aba01
               WHEN tm.s[g_i,g_i] = '2'
                    LET l_order[g_i] = sr.aba02 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '3'
                    LET l_order[g_i] = sr.aba05 USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.aba06
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.aba08
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT aglr404_rep(sr.*)
     END FOREACH
 
     FINISH REPORT aglr404_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT aglr404_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)    
          sr           RECORD
                          order1 LIKE aba_file.aba01, #No.FUN-680098  VARCHAR(10)      
                          order2 LIKE aba_file.aba02, #No.FUN-680098  VARCHAR(10)    
                          order3 LIKE aba_file.aba05, #No.FUN-680098  VARCHAR(10)    
                          aba01 LIKE aba_file.aba01,     #傳票編號
                          aba02 LIKE aba_file.aba02,     #傳票日期
                          abasign LIKE aba_file.abasign, #簽核等級
                          aba08 LIKE aba_file.aba08,     #借方金額
                          azc02 LIKE azc_file.azc02,     #簽核順序
                          azc03 LIKE azc_file.azc03,     #簽核人員代號
                          azd04 LIKE azd_file.azd04,     #簽核日期
                          aba05 LIKE aba_file.aba05,     #輸入日期
                          aba06 LIKE aba_file.aba06,     #來源碼
                          abasseq LIKE aba_file.abasseq  #已簽等級
                       END RECORD,
          l_n          LIKE type_file.num5,          #No.FUN-680098 smallint
          l_acc        LIKE type_file.num5,          #No.FUN-680098 smallint
          l_gen02      LIKE gen_file.gen02,          #人員姓名   #No.FUN-680098  VARCHAR(8)    
          l_buf        LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(80)    
          l_buf2       LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(80)
          l_sw1        LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1)    
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.aba01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      ON EVERY ROW
         DECLARE azc_curs CURSOR FOR SELECT azc02,azc03,azd04,gen02
                                        FROM gen_file, azc_file LEFT OUTER JOIN azd_file
                                       ON azc03 = azd03
				       AND azd_file.azd01 = sr.aba01
                                       AND azd_file.azd02 = 4
                                       WHERE azc01 = sr.abasign
                                       AND azc03 = gen0
                                       ORDER BY azc02
         LET l_sw1 = 'Y'
         LET l_buf = ' '
         LET l_buf2 = ' '
         LET l_n   = 0
         PRINT COLUMN g_c[31],sr.aba01,
               COLUMN g_c[32],sr.aba02,
               COLUMN g_c[33],sr.aba08 USING "##############.###";
         FOREACH azc_curs INTO sr.azc02,sr.azc03,sr.azd04,l_gen02
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('azc_curs:',SQLCA.sqlcode,0)
               LET sr.azc03 = ' '
               CONTINUE FOREACH
            END IF
            LET l_acc = l_n * 10
            IF sr.azd04 IS NOT NULL THEN
                LET l_buf[l_acc,l_acc+1] = '*' CLIPPED
                LET l_buf2[l_acc,l_acc+9] = ' ',sr.azd04 CLIPPED
            END IF
            LET l_buf[l_acc+1,l_acc+9] = l_gen02  CLIPPED
            LET l_sw1 = 'N'
            LET l_n = l_n + 1
            IF l_n >= 4 THEN
               PRINT COLUMN g_c[34],l_buf CLIPPED
               PRINT COLUMN g_c[34],l_buf2 CLIPPED
               LET l_sw1 = 'Y'
               LET l_n = 0
               LET l_buf = ' '
            END IF
         END FOREACH
         IF l_sw1 = 'N' THEN
            PRINT COLUMN g_c[34],l_buf CLIPPED
            PRINT COLUMN g_c[34],l_buf2 CLIPPED
            SKIP 1 LINE
         END IF
         PRINT ' '
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'aba01,aba02,aba05,aba06,aba05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
          #-- TQC-630166 begin
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(tm.wc)
          #-- TQC-630166 end
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
