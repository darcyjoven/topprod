# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfr104.4gl
# Descriptions...: 工單發料狀況表
# Date & Author..: 92/08/14 BY MAY
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-530120 05/03/16 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550124 05/05/30 By echo  新增報表備註
# Modify.........: NO.MOD-580186 05/09/08 BY yiting 報表抬頭有誤
# Modify.........: NO.MOD-590505 05/10/03 BY Claire g_len未宣告
# Modify.........: NO.FUN-590110 05/10/08 BY day  報表轉xml
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-5B0106 05/11/12 BY Dido 單號擴大至16
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0090 06/11/06 By douzh l_time轉g_time
# Modify.........: No.MOD-790165 07/09/28 By Pengu 在SELECT取替代料時應加上bmd08=sr.sfb05條件
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-940008 09/05/12 By hongmei發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.FUN-A60027 10/06/09 By vealxu 製造功能優化-平行制程（批量修改）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#          wc       VARCHAR(600),      # Where condition  TQC-630166
           wc       STRING,         # Where condition  TQC-630166
           b        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1) # Order by sequence
           c        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1) # Eject sw
           more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r104_tm(0,0)        # Input print condition
      ELSE CALL asfr104()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r104_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000          #No.FUN-680121 VARCHAR(400)
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW r104_w AT p_row,p_col
        WITH FORM "asf/42f/asfr104"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = 'Y'
   LET tm.c    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     DISPLAY BY NAME tm.b,tm.c,tm.more # Condition
     CONSTRUCT BY NAME tm.wc ON sfb02,sfb04,sfb05,sfb01,sfb82
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
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
        EXIT WHILE
     END IF
 
     IF tm.wc = " 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
     DISPLAY BY NAME tm.b,tm.c,tm.more # Condition
     INPUT BY NAME tm.b,tm.c,tm.more
                  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD b
           IF tm.b NOT MATCHES "[yYnN]" OR tm.b IS NULL OR tm.b = ' '
              THEN NEXT FIELD b
           END IF
 
        AFTER FIELD c
           IF tm.c NOT MATCHES "[12]" OR tm.c IS NULL OR tm.c = ' '
              THEN NEXT FIELD c
           END IF
 
        AFTER FIELD more
           IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
              THEN NEXT FIELD more
           END IF
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
        EXIT WHILE
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfr104'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr104','9031',1)
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
                           " '",tm.b CLIPPED,"'",
                           " '",tm.c CLIPPED,"'",
                           " '",g_rep_user CLIPPED,"'",         #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",         #No.FUN-570264
                           " '",g_template CLIPPED,"'"          #No.FUN-570264
           CALL cl_cmdat('asfr104',g_time,l_cmd)      # Execute cmd at later time
        END IF
        CLOSE WINDOW r104_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfr104()
     ERROR ""
   END WHILE
   CLOSE WINDOW r104_w
END FUNCTION
 
FUNCTION asfr104()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  TQC-630166        #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,                       # RDSQL STATEMENT  TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sr               RECORD
                           #order1  VARCHAR(20),
                           order1 LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#NO.FUN-5B0015
                           sfb01  LIKE sfb_file.sfb01,
                           sfb02  LIKE sfb_file.sfb02,
                           sfb04  LIKE sfb_file.sfb04,
                           sfb05  LIKE sfb_file.sfb05,
                           sfb06  LIKE sfb_file.sfb06,
                           sfb07  LIKE sfb_file.sfb07,
                           sfb071 LIKE sfb_file.sfb071,
                           sfb08  LIKE sfb_file.sfb08,
                           sfb09  LIKE sfb_file.sfb09,
                           sfb10  LIKE sfb_file.sfb10,
                           sfb11  LIKE sfb_file.sfb11,
                           sfb12  LIKE sfb_file.sfb12,
                           sfb13  LIKE sfb_file.sfb13,
                           sfb15  LIKE sfb_file.sfb15,
                           sfb22  LIKE sfb_file.sfb22,
                           sfb221 LIKE sfb_file.sfb221,
                           sfb251 LIKE sfb_file.sfb251,
                           sfb27  LIKE sfb_file.sfb27,
                           sfb34  LIKE sfb_file.sfb34,
                           sfb40  LIKE sfb_file.sfb40,
                           sfb82  LIKE sfb_file.sfb82,
                           sfa03  LIKE sfa_file.sfa03,
                           sfa05  LIKE sfa_file.sfa05,
                           sfa06  LIKE sfa_file.sfa06,
                           sfa062 LIKE sfa_file.sfa062, #超領量
                           sfa07  LIKE sfa_file.sfa07,
                           sfa09  LIKE sfa_file.sfa09,
                           sfa11  LIKE sfa_file.sfa11,
                           sfa12  LIKE sfa_file.sfa12,
                           sfa25  LIKE sfa_file.sfa25,
                           sfa26  LIKE sfa_file.sfa26,
                           sfa012 LIKE sfa_file.sfa012,  #FUN-A60027
                           sfa013 LIKE sfa_file.sfa013,  #FUN-A60027 
                           qty    LIKE sfa_file.sfa05,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           ima55  LIKE ima_file.ima55
                        END RECORD
  DEFINE l_short_qty    LIKE sfa_file.sfa07    #FUN-940008 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004-------Begin---------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004------End-----------
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT ' ',sfb01,sfb02,sfb04,sfb05,sfb06,sfb07,sfb071,",
                 " sfb08,sfb09,sfb10,sfb11,sfb12,sfb13,sfb15,sfb22,sfb221,",
                 " sfb251,sfb27,sfb34,sfb40,sfb82, ",
                 " sfa03,sfa05,sfa06,sfa062,'',sfa09,sfa11,",    #FUN-940008 sfa07-->''
                 " sfa12,sfa25,sfa26,sfa012,sfa013,sfa05-sfa06,ima02,ima021,ima55",       #FUN-A60027 add sfa012,sfa013
                 " FROM sfb_file,sfa_file,ima_file ",
                 " WHERE sfb01 = sfa01 AND ",
                 " sfb23 IN ('Y','y') AND ",
                 " sfbacti IN ('Y','y') AND ",
                 " sfa26 IN ('0','1','2','3','4','5','6','T','7','8')  AND ",   #為NORMAL的 bugno:7111 add '56'  #FUN-A20037 add '7,8'
                 " sfb05 = ima01 AND sfb87!='X' AND ",
                 tm.wc CLIPPED
     IF tm.b MATCHES '[Nn]' THEN
        #若不包括巳發放全部需求數量之下階料(巳發小放應發
        LET l_sql = l_sql CLIPPED,"AND  sfa05 - sfa06 > 0 "
     END IF
 
     PREPARE r104_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     DECLARE r104_cs1 CURSOR FOR r104_prepare1
     CALL cl_outnam('asfr104') RETURNING l_name
     START REPORT r104_rep TO l_name
 
     LET g_pageno = 0
     CALL s_filldate()
     FOREACH r104_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FUN-940008---Begin add #計算欠料量
       CALL s_shortqty(sr.sfb01,sr.sfa03,'',sr.sfa12,'',sr.sfa012,sr.sfa013)            #FUN-A60027 add sfa012,sfa013
            RETURNING l_short_qty
       IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
       LET sr.sfa07 = l_short_qty
       #FUN-940008---End 
       IF sr.sfa03 IS NULL THEN LET sr.sfa03 = ' ' END IF
       IF sr.sfa09 IS NULL THEN LET sr.sfa09 = ' ' END IF
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.sfa03
       CALL s_getdate(sr.sfb13,sr.sfa09) RETURNING sr.sfb13
       IF sr.qty < 0 THEN
         LET sr.qty = 0
       END IF
       IF tm.c = '1' THEN
          LET sr.order1 = sr.sfa03
       ELSE
          LET sr.order1 = sr.sfb13
       END IF
       #FUN-A60027 ------------------start----------------------
       IF g_sma.sma541 = 'Y' THEN
          LET g_zaa[48].zaa06 = 'N'
          LET g_zaa[49].zaa06 = 'N'
       ELSE
          LET g_zaa[48].zaa06 = 'Y'
          LET g_zaa[49].zaa06 = 'Y'
       END IF 
       #FUN-A60027 --------------end------------------------
       OUTPUT TO REPORT r104_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r104_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r104_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_str         LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          l_sw          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sta         LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(12)
          l_sta1        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(22)
          l_sql1,l_sql2 LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1200)
          l_bmb16       LIKE bmb_file.bmb16,
          l_dept        LIKE gem_file.gem02,
          l_sfa         RECORD LIKE sfa_file.*,
          sr               RECORD
                           #order1  VARCHAR(20),
                           order1 LIKE sfa_file.sfa03,        #No.FUN-680121 VARCHAR(40)#NO.FUN-5B0015
                           sfb01  LIKE sfb_file.sfb01,
                           sfb02  LIKE sfb_file.sfb02,
                           sfb04  LIKE sfb_file.sfb04,
                           sfb05  LIKE sfb_file.sfb05,
                           sfb06  LIKE sfb_file.sfb06,
                           sfb07  LIKE sfb_file.sfb07,
                           sfb071 LIKE sfb_file.sfb071,
                           sfb08  LIKE sfb_file.sfb08,
                           sfb09  LIKE sfb_file.sfb09,
                           sfb10  LIKE sfb_file.sfb10,
                           sfb11  LIKE sfb_file.sfb11,
                           sfb12  LIKE sfb_file.sfb12,
                           sfb13  LIKE sfb_file.sfb13,
                           sfb15  LIKE sfb_file.sfb15,
                           sfb22  LIKE sfb_file.sfb22,
                           sfb221 LIKE sfb_file.sfb221,
                           sfb251 LIKE sfb_file.sfb251,
                           sfb27  LIKE sfb_file.sfb27,
                           sfb34  LIKE sfb_file.sfb34,
                           sfb40  LIKE sfb_file.sfb40,
                           sfb82  LIKE sfb_file.sfb82,
                           sfa03  LIKE sfa_file.sfa03,
                           sfa05  LIKE sfa_file.sfa05,
                           sfa06  LIKE sfa_file.sfa06,
                           sfa062 LIKE sfa_file.sfa062,#超領量
                           sfa07  LIKE sfa_file.sfa07,
                           sfa09  LIKE sfa_file.sfa09,
                           sfa11  LIKE sfa_file.sfa11,
                           sfa12  LIKE sfa_file.sfa12,
                           sfa25  LIKE sfa_file.sfa25,
                           sfa26  LIKE sfa_file.sfa26,
                           sfa012 LIKE sfa_file.sfa012,  #FUN-A60027
                           sfa013 LIKE sfa_file.sfa013,  #FUN-A60027
                           qty    LIKE sfa_file.sfa05,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           ima55  LIKE ima_file.ima55
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.sfb01,sr.order1
 
#No.FUN-590110-begin
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT
      PRINT g_dash[1,g_len]
      CALL s_wotype(sr.sfb02) RETURNING l_sta
      CALL s_wostatu(sr.sfb04) RETURNING l_sta1
#TQC-5B0106
      PRINT g_x[11] CLIPPED,' ',sr.sfb01,COLUMN  28,'  (',l_sta CLIPPED,'/',
            l_sta1 CLIPPED,')'
#     PRINT g_x[11] CLIPPED,' ',sr.sfb01,'  (',l_sta CLIPPED,'/',
#           l_sta1 CLIPPED,')'
      PRINT g_x[12] CLIPPED,' ',sr.sfb05
#     PRINT g_x[12] CLIPPED,' ',sr.sfb05,' ',sr.ima02
      PRINT g_x[27] CLIPPED,' ',sr.ima02
#TQC-5B0106 End
      PRINT g_x[13] CLIPPED,' ',sr.sfb07
      PRINT g_x[14] CLIPPED,' ',sr.sfb071,' ','(BOM/Routine)',
            COLUMN  53,g_x[15] CLIPPED,' ',sr.sfb34 USING '--&.&&&','%'
      PRINT g_x[16] CLIPPED,' ',sr.sfb06,COLUMN 53,
            g_x[17] CLIPPED,' ',sr.sfb40
      PRINT g_x[18] CLIPPED,' ',sr.sfb13,COLUMN 53,
            g_x[19] CLIPPED,' ',sr.sfb08,'/',sr.ima55
      PRINT g_x[20] CLIPPED,' ',sr.sfb15,COLUMN 53,
            g_x[21] CLIPPED,' ',sr.sfb10
      PRINT g_x[22] CLIPPED,' ',sr.sfb251,COLUMN 53,
            g_x[23] CLIPPED,' ',sr.sfb12
      PRINT g_x[24] CLIPPED,' ',sr.sfb22,'/',sr.sfb221 USING '<<<',
            COLUMN 53,g_x[25] CLIPPED,' ',sr.sfb11
      PRINT g_x[26] CLIPPED,' ',sr.sfb27
      IF NOT cl_null(sr.sfb02) THEN
         IF sr.sfb02 = 7 THEN
            SELECT pmc03 INTO l_dept FROM pmc_file
             WHERE pmc01 = sr.sfb82
            IF SQLCA.sqlcode THEN
               LET l_dept = ' '
            END IF
         ELSE
            SELECT gem02 INTO l_dept FROM gem_file
             WHERE gem01 = sr.sfb82
            IF SQLCA.sqlcode THEN
               LET l_dept = ' '
            END IF
         END IF
      END IF
 
      #NO.MOD-580186 MARK
      PRINT g_x[34] CLIPPED,' ',sr.sfb82 CLIPPED,' / ',l_dept,
            COLUMN 53,g_x[33] CLIPPED ,': ',sr.sfb09
      PRINT
      PRINTX name=H1 g_x[48],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],   #FUN-A60027 add g_x[48]
                     g_x[40],g_x[41],g_x[42]
      PRINTX name=H2 g_x[49],g_x[43],g_x[44],g_x[45],g_x[46]            #FUN-A60027 add g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
      #--end
 
 #NO.MOD-580186 MARK
#      PRINT g_x[28] CLIPPED,' ',sr.sfb82 CLIPPED,' / ',l_dept,
#            COLUMN 53,g_x[29] CLIPPED,' ',sr.sfb09
#      PRINTX name = H1
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#--END
 
 
   BEFORE GROUP OF sr.sfb01
      IF PAGENO > 1 OR LINENO > 9
         THEN SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      #PRINTX name=D1 COLUMN g_c[35],sr.sfa03[1,20],
     #PRINTX name=D1 COLUMN g_c[35],sr.sfa03 CLIPPED, #NO.FUN-5B0015  #FUN-A60027 mark
      PRINTX name=D1                                       #FUN-A60027
            COLUMN g_c[48],sr.sfa012 CLIPPED,              #FUN-A60027
            COLUMN g_c[35],sr.sfa03 CLIPPED,               #FUN-A60027
            COLUMN g_c[36],sr.sfa11 CLIPPED,
            COLUMN g_c[37],sr.sfa26 CLIPPED,
            COLUMN g_c[38],sr.sfb13 CLIPPED,
            COLUMN g_c[39],sr.sfa12 CLIPPED,
            COLUMN g_c[40],cl_numfor(sr.sfa05,40,3),
            COLUMN g_c[41],cl_numfor(sr.qty,41,3),
            COLUMN g_c[42],cl_numfor(sr.sfa07,42,3)
     #PRINTX name=D2  COLUMN g_c[43],sr.ima021 CLIPPED,   #FUN-A60027  mark
      PRINTX name=D2                                      #FUN-A60027
            COLUMN g_c[49],sr.sfa013 CLIPPED,             #FUN-A60027
            COLUMN g_c[43],sr.ima021 CLIPPED,             #FUN-A60027 
            COLUMN g_c[44],cl_numfor(sr.sfa06,44,3),
            COLUMN g_c[45],cl_numfor(sr.sfa062,45,3),
            COLUMN g_c[46],cl_numfor(sr.sfa25,46,3)
      SELECT bmb16 INTO l_bmb16 FROM bmb_file #取、替代料件特性
                        WHERE bmb01 = sr.sfb05  AND
                              bmb03 = sr.sfa03 AND
                              (bmb04 <= sr.sfb071 OR bmb04 IS NULL) AND #有效的
                              (bmb05 > sr.sfb071 OR bmb05 IS NULL)
         IF l_bmb16 = '1' THEN  #取代
            LET l_sql1 = "SELECT sfa_file.* FROM sfa_file,bmd_file ",
                         "WHERE bmd01 = '",sr.sfa03,"' AND ",
                         "      bmd08 = '",sr.sfb05,"' AND ",    #No.MOD-790165 add
                         "   bmd02 = '1' AND",
                         "(bmd05 <= '",sr.sfb071,"' OR bmd05 IS NULL) AND",
                         "   (bmd06 >  '",sr.sfb071,"' OR bmd06 IS NULL ) AND",
                         "   sfa01 = '",sr.sfb01,"' AND",
                         "   sfa03 = bmd04 AND ",
                         "   sfa26 = 'U' ",
                         "   AND bmdacti = 'Y'"                                           #CHI-910021
            PREPARE r104_pre1 FROM l_sql1
            DECLARE r104_cs2 CURSOR FOR r104_pre1
            FOREACH r104_cs2 INTO l_sfa.*
            IF SQLCA.sqlcode THEN EXIT FOREACH END IF
            PRINT g_x[32]
            #PRINTX name=D1 COLUMN g_c[35],l_sfa.sfa03[1,20],
           #PRINTX name=D1 COLUMN g_c[35],l_sfa.sfa03 CLIPPED, #NO.FUN-5B0015  #FUN-A60027
            PRINTX name=D1                                       #FUN-A60027
                  COLUMN g_c[48],sr.sfa012 CLIPPED,              #FUN-A60027
                  COLUMN g_c[35],l_sfa.sfa03 CLIPPED,            #FUN-A60027 
                  COLUMN g_c[36],l_sfa.sfa11 CLIPPED,
                  COLUMN g_c[37],l_sfa.sfa26 CLIPPED,
                  COLUMN g_c[38],sr.sfb13 CLIPPED,
                  COLUMN g_c[39],l_sfa.sfa12 CLIPPED,
                  COLUMN g_c[40],cl_numfor(l_sfa.sfa05,40,3),
                  COLUMN g_c[41],cl_numfor(sr.qty,41,3),
                  COLUMN g_c[42],cl_numfor(l_sfa.sfa07,42,3)
           #PRINTX name=D2 COLUMN g_c[43],sr.ima021 CLIPPED,       #FUN-A60027
            PRINTX name=D2                                         #FUN-A60027   
                  COLUMN g_c[49],sr.sfa013  CLIPPED,               #FUN-A60027
                  COLUMN g_c[43],sr.ima021 CLIPPED,                #FUN-A60027 
                  COLUMN g_c[44],cl_numfor(l_sfa.sfa06,44,3),
                  COLUMN g_c[45],cl_numfor(l_sfa.sfa062,45,3),
                  COLUMN g_c[46],cl_numfor(l_sfa.sfa25,46,3)
            END FOREACH
         END IF
 
         IF l_bmb16 = '2' THEN #替代
            LET l_sql2 = "SELECT sfa_file.* FROM sfa_file,bmd_file ",
                         "WHERE bmd01 = '",sr.sfa03,"' AND ",
                         "      bmd08 = '",sr.sfb05,"' AND ",    #No.MOD-790165 add
                         "   bmd02 = '2' AND",
                         "(bmd05 <= '",sr.sfb071,"' OR bmd05 IS NULL) AND",
                         "   (bmd06 >  '",sr.sfb071,"' OR bmd06 IS NULL ) AND",
                         "   sfa01 = '",sr.sfb01,"' AND",
                         "   sfa03 = bmd04 AND ",
                         "   sfa26 = 'S' ",
                         "   AND bmdacti = 'Y'"                                           #CHI-910021
            PREPARE r104_pre2 FROM l_sql2
            DECLARE r104_cs3 CURSOR FOR r104_pre2
            FOREACH r104_cs3 INTO l_sfa.*
            IF SQLCA.sqlcode THEN EXIT FOREACH END IF
            PRINT g_x[47]
            #PRINTX name=D1 COLUMN g_c[35],l_sfa.sfa03[1,20],
           #PRINTX name=D1 COLUMN g_c[35],l_sfa.sfa03 CLIPPED, #NO.FUN-5B0015  #FUN-A60027
             PRINTX name=D1                                      #FUN-A60027
                  COLUMN g_c[48],sr.sfa012 CLIPPED,              #FUN-A60027
                  COLUMN g_c[35],l_sfa.sfa03 CLIPPED,            #FUN-A60027
                  COLUMN g_c[36],l_sfa.sfa11 CLIPPED,
                  COLUMN g_c[37],l_sfa.sfa26 CLIPPED,
                  COLUMN g_c[38],sr.sfb13 CLIPPED,
                  COLUMN g_c[39],l_sfa.sfa12 CLIPPED,
                  COLUMN g_c[40],cl_numfor(l_sfa.sfa05,40,3),
                  COLUMN g_c[41],cl_numfor(sr.qty,41,3),
                  COLUMN g_c[42],cl_numfor(l_sfa.sfa07,42,3)
           #PRINTX name=D2 COLUMN g_c[43],sr.ima021 CLIPPED,      #FUN-A60027 
            PRINTX name=D2                                        #FUN-A60027
                  COLUMN g_c[49],sr.sfa013 CLIPPED,               #FUN-A60027
                  COLUMN g_c[43],sr.ima021 CLIPPED,               #FUN-A60027       
                  COLUMN g_c[44],cl_numfor(l_sfa.sfa06,44,3),
                  COLUMN g_c[45],cl_numfor(l_sfa.sfa062,45,3),
                  COLUMN g_c[46],cl_numfor(l_sfa.sfa25,46,3)
            END FOREACH
         END IF

#FUN-A20037 --begin--
      SELECT bmb16 INTO l_bmb16 FROM bmb_file #取、替代料件特性
                        WHERE bmb01 = sr.sfb05  AND
                              bmb03 = sr.sfa03 AND
                              (bmb04 <= sr.sfb071 OR bmb04 IS NULL) AND #有效的
                              (bmb05 > sr.sfb071 OR bmb05 IS NULL)
                              
        IF l_bmb16 = '7' THEN 
            LET l_sql2 = "SELECT sfa_file.* FROM sfa_file,bon_file,bmb_file ",
                         "WHERE bon01 = '",sr.sfa03,"'  ",
                         "  AND bon02 = '",sr.sfb05,"' ",    
                         "  AND bmb01 = bon2",
                         "  AND bmb03 = bon01",
                         "  AND bmb16 = '7' ",
                         "  AND (bon09 <= '",sr.sfb071,"' OR bon09 IS NULL) ",
                         "  AND (bon10 >  '",sr.sfb071,"' OR bon10 IS NULL ) ",
                         "  AND sfa01 = '",sr.sfb01,"' ",
                         "  AND sfa26 = 'Z' ",
                         "  AND bonacti = 'Y'"                                        
            PREPARE r104_pre3 FROM l_sql2
            DECLARE r104_cs4 CURSOR FOR r104_pre3
            FOREACH r104_cs4 INTO l_sfa.*
            IF SQLCA.sqlcode THEN EXIT FOREACH END IF
            PRINT g_x[47]
           #PRINTX name=D1 COLUMN g_c[35],l_sfa.sfa03 CLIPPED,  #FUN-A60027 mark
             PRINTX name=D1                                       #FUN-A60027
                  COLUMN g_c[48],sr.sfa012 CLIPPED,              #FUN-A60027
                  COLUMN g_c[35],l_sfa.sfa03 CLIPPED,            #FUN-A60027  
                  COLUMN g_c[36],l_sfa.sfa11 CLIPPED,
                  COLUMN g_c[37],l_sfa.sfa26 CLIPPED,
                  COLUMN g_c[38],sr.sfb13 CLIPPED,
                  COLUMN g_c[39],l_sfa.sfa12 CLIPPED,
                  COLUMN g_c[40],cl_numfor(l_sfa.sfa05,40,3),
                  COLUMN g_c[41],cl_numfor(sr.qty,41,3),
                  COLUMN g_c[42],cl_numfor(l_sfa.sfa07,42,3)
           #PRINTX name=D2 COLUMN g_c[43],sr.ima021 CLIPPED,      #FUN-A60027
            PRINTX name=D2                                        #FUN-A60027
                  COLUMN g_c[49],sr.sfa013 CLIPPED,               #FUN-A60027
                  COLUMN g_c[43],sr.ima021 CLIPPED,               #FUN-A60027   
                  COLUMN g_c[44],cl_numfor(l_sfa.sfa06,44,3),
                  COLUMN g_c[45],cl_numfor(l_sfa.sfa062,45,3),
                  COLUMN g_c[46],cl_numfor(l_sfa.sfa25,46,3)
            END FOREACH
         END IF
#FUN-A20037 --end--         
#No.FUN-590110-end
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#TQC-630166-end
 
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
## FUN-550124
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[9]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[9]
             PRINT g_memo
      END IF
## END FUN-550124
 
END REPORT
