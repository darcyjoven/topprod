# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr913.4gl
# Descriptions...: 傳票編號與總號對照表
# Input parameter:
# Return code....:
# Date & Author..: 93/10/28 By Fiona
# Modify.........: No.FUN-510007 05/01/14 By Nicola 報表架構修改
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie   調整“接下頁/結束”位置 
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750093 07/05/25 By ve 報表改為使用crystal report
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9C0049 10/10/20 By sabrina 在畫面和報表上新增"帳別"
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_str          STRING                     #FUN-750093
   DEFINE tm  RECORD                                # Print condition RECORD
                 wc      STRING,                    #Where Condiction  #TQC-630166
                 a       LIKE type_file.chr1,       #排列順序   #No.FUN-680098   VARCHAR(1)
                 b       LIKE type_file.num5,       #會計  年度 #No.FUN-680098   VARCHAR(1)
                 c       LIKE type_file.num5,       #期      別 #No.FUN-680098   VARCHAR(1)
                 d       LIKE aba_file.aba00,       #帳      別 #No.CHI-9C0049   add
                 more    LIKE type_file.chr1        #是否輸入其它特殊列印條件#No.FUN-680098 VARCHAR(1)
              END RECORD,
         g_bookno        LIKE aba_file.aba00        #帳別編號
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose   #No.FUN-680098   SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)
   LET tm.c  = ARG_VAL(11)
  #CHI-9C0049---modify---start---
   LET tm.d  = ARG_VAL(12)           #CHI-9C0049 add
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No:FUN-7C0078
   #No:FUN-570264 ---end---
  #CHI-9C0049---modify---end---
 
  #CHI-9C0049---modify---start---     #g_bookno modify tm.d
  #IF g_bookno = ' ' OR g_bookno IS NULL THEN
  #   LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
  #END IF
   IF cl_null(tm.d) THEN
      LET tm.d = g_aaz.aaz64   #帳別若為空白則使用預設帳別
   END IF
  #CHI-9C0049---modify---end---
 
   #-->使用預設帳別之幣別
  #SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno       #CHI-9C0049 mark
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.d           #CHI-9C0049 add 
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF
 
   #-->使用本國幣別
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03             #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr913_tm()
   ELSE
      CALL aglr913()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr913_tm()
DEFINE lc_qbe_sn           LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col         LIKE type_file.num5,        #No.FUN-680098 SMALLINT
          l_cmd            LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(400)
 
   CALL s_dsmark(g_bookno)     #CHI-9C0049 mark
   CALL s_dsmark(tm.d)         #CHI-9C0049 add 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW aglr913_w AT p_row,p_col
     WITH FORM "agl/42f/aglr913"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
  #CALL s_shwact(3,2,g_bookno) #CHI-9C0049 mark
   CALL s_shwact(3,2,tm.d)     #CHI-9C0049 add 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.a = '1'
   LET tm.d = g_aaz.aaz64            #CHI-9C0049 add 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON aba11,aba01,aba02
 
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
         CLOSE WINDOW aglr913_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.a,tm.more       # Condition
 
      INPUT BY NAME tm.b,tm.c,tm.d,tm.a,tm.more WITHOUT DEFAULTS      #CHI-9C0049 add tm.d
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD a #排列順序組合
            FOR g_i = 1 to 1
               IF tm.a[g_i,g_i] IS NOT NULL THEN
                  IF tm.a[g_i,g_i] NOT MATCHES "[123]" THEN
                     NEXT FIELD a
                  END IF
               END IF
            END FOR
 
         AFTER FIELD b
            IF tm.b <= 0 THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.c) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.b
            IF g_azm.azm02 = 1 THEN
               IF tm.c > 12 OR tm.c < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD c
               END IF
            ELSE
               IF tm.c > 13 OR tm.c < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD c
               END IF
            END IF
         END IF
#            IF tm.c <= 0 OR tm.c > 14 THEN
#               NEXT FIELD c
#            END IF
#No.TQC-720032 -- end --
 
        #CHI-9C0049---add---start---
         AFTER FIELD d
            IF cl_null(tm.d) THEN
               NEXT FIELD tm.d
            END IF
        #CHI-9C0049---add---end---

         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
       #CHI-9C0049---add---start---
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(d)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aaa'
                 LET g_qryparam.default1 = tm.d 
                 CALL cl_create_qry() RETURNING tm.d
                 DISPLAY BY NAME tm.d
                 NEXT FIELD d 
            END CASE
       #CHI-9C0049---add---end---

         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         CLOSE WINDOW aglr913_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aglr913'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr913','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",        #CHI-9C0049 g_bookno modify tm.d
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr913',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW aglr913_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr913()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr913_w
 
END FUNCTION
 
FUNCTION aglr913()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       STRING,                # RDSQL STATEMENT  #TQC-630166  
          l_chr       LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
          l_order       ARRAY[5] OF LIKE  type_file.chr20,  #排列順序  #No.FUN-680098  VARCHAR(10)   
          l_i           LIKE type_file.num5,                #No.FUN-680098  smallint
          sr               RECORD
                           order1    LIKE aba_file.aba01,#排列順序-1 #No.FUN-680098  VARCHAR(10) 
                           aba02     LIKE aba_file.aba02,#傳票日期
                           aba11     LIKE aba_file.aba11,#傳票總號
                           aba01     LIKE aba_file.aba01,#傳票編號
                           aba06     LIKE aba_file.aba06,#來源
                           aba03     LIKE aba_file.aba03,#會計年度
                           aba04     LIKE aba_file.aba04,#期間
                           aba08     LIKE aba_file.aba08 #借方金額
                        END RECORD
 
   SELECT aaf03 INTO g_company FROM aaf_file
   #WHERE aaf01 = g_bookno             #CHI-9C0049 mark
    WHERE aaf01 = tm.d                 #CHI-9C0049 add 
      AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT '',aba02, aba11, aba01,aba06,aba03,",
               " aba04, aba08",
               " FROM aba_file",
              #" WHERE aba00 = '",g_bookno,"'", #若為空白使用預設帳別     #CHI-9C0049 mark    
               " WHERE aba00 = '",tm.d,"'",     #若為空白使用預設帳別     #CHI-9C0049 add 
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND ",tm.wc
 
   IF tm.b IS NOT NULL THEN                     #年度
      LET l_sql = l_sql CLIPPED," AND aba03 = ",tm.b
   END IF
 
   IF tm.c IS NOT NULL THEN                     #期別
      LET l_sql = l_sql CLIPPED," AND aba04 = ",tm.c
   END IF
#FUN-750093---------------------begin------------------------------
{
   PREPARE aglr913_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr913_curs1 CURSOR FOR aglr913_prepare1
 
   CALL cl_outnam('aglr913') RETURNING l_name
   START REPORT aglr913_rep TO l_name
 
   LET g_pageno = 0
   LET g_cnt    = 1
 
   FOREACH aglr913_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      CASE WHEN tm.a= '1' LET sr.order1 = sr.aba11 USING '&&&&&&&&&&'  #No:7830
           WHEN tm.a= '2' LET sr.order1 = sr.aba01
           WHEN tm.a= '3' LET sr.order1 = sr.aba02 USING 'YYYYMMDD'
           OTHERWISE LET sr.order1 = '-'
      END CASE
 
      OUTPUT TO REPORT aglr913_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT aglr913_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
#FUN-750093-----------------------end--------------------------------
   CALL cl_wcchp(tm.wc,'aba11,aba01,aba02') RETURNING tm.wc     #CHI-9C0049 add
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
         WHERE azi01=g_aaa03
   LET g_str=tm.wc,";",tm.a,";",tm.b,";",tm.c,";",t_azi05,";",tm.d  #FUN-750093  #CHI-9C0049 add tm.d
 
   CALL cl_prt_cs1('aglr913','aglr913_1',l_sql,g_str)    #FUN-750093
END FUNCTION
#FUN-750093---------------------begin--------------------------------
{
REPORT aglr913_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_p_flag      LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_flag1       LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_zero        LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)
          l_tot1        LIKE aba_file.aba08,
          sr            RECORD
                           order1    LIKE aba_file.aba01,#排列順序-1 #No.FUN-680098  VARCHAR(10) 
                           aba02     LIKE aba_file.aba02,#傳票日期
                           aba11     LIKE aba_file.aba11,#傳票總號
                           aba01     LIKE aba_file.aba01,#傳票編號
                           aba06     LIKE aba_file.aba06,#來源
                           aba03     LIKE aba_file.aba03,#會計年度
                           aba04     LIKE aba_file.aba04,#期間
                           aba08     LIKE aba_file.aba08 #借方金額
                        END RECORD
   DEFINE g_head1  STRING 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.aba01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,tm.b USING "<<<<<<",'     ',
                       g_x[10] CLIPPED,tm.c USING "<<<<<<"
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      ON EVERY ROW
         IF sr.aba04 < 10 THEN
            LET l_zero = '0'   # 控制期間之前是否需要印0
         ELSE
            LET l_zero = NULL
         END IF
 
         PRINT COLUMN g_c[31],sr.aba02,
               COLUMN g_c[32],sr.aba11 USING "##########",
               COLUMN g_c[33],sr.aba01,
               COLUMN g_c[34],sr.aba06,
               COLUMN g_c[35],cl_numfor(sr.aba08,35,t_azi05)      #No.CHI-6A0004 g_azi-->t_azi
 
      ON LAST ROW
         LET l_tot1 = SUM(sr.aba08)
         PRINT ' '
         PRINT COLUMN g_c[34],g_x[11] CLIPPED,
               COLUMN g_c[35],cl_numfor(l_tot1,35,t_azi05)         #No.CHI-6A0004 g_azi-->t_azi
         PRINT ' '
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'aba05,aba02,aba01') RETURNING tm.wc
            PRINT g_dash[1,g_len]
        #TQC-630166
        #    IF tm.wc[001,070] > ' ' THEN                  # for 80
        #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
        #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
        #    END IF
        #    IF tm.wc[071,140] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
        #    END IF
        #    IF tm.wc[141,210] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
        #    END IF
        #    IF tm.wc[211,280] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
        #    END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED       #No.TQC-6B0093
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED       #No.TQC-6B0093
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#FUN-750093---------------------------end------------------------------------------
#Patch....NO.TQC-610035 <001> #
