# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aimr999.4gl
# Descriptions...: 盤盈虧明細表
# Date & Author..: 99/12/24 by Snow
# Modify..........dbo.No:7597 03/07/14 By mandy pia03 /pia04 宣告時是用char(4).., 應用 like pia_file.pia03
# Modify.........:No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02,ima021
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/13 By baogui 結束位置調整
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.MOD-910174 09/01/15 By claire 列印格式調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0170 10/01/11 By jan 新增ctype欄位及相關處理
# Modify.........: No.TQC-C80081 12/08/14 By qiull 料號總計一行沒有值，使各欄位均有值顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc            LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
           yy,mm,yy1,mm1 LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           a,b,c,d,e,f,s LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           ctype         LIKE type_file.chr1,    #FUN-9C0170
           more          LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
  #TQC-610072-begin
   #LET g_pdate = ARG_VAL(1)
   #LET g_towhom = ARG_VAL(2)
   #LET g_rlang = ARG_VAL(3)
   #LET g_bgjob = 'N'
   #LET g_prtway = ARG_VAL(5)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.yy  = ARG_VAL(11)
   LET tm.mm  = ARG_VAL(12)
   LET tm.yy1  = ARG_VAL(13)
   LET tm.mm1  = ARG_VAL(14)
   LET tm.d  = ARG_VAL(15)
   LET tm.e  = ARG_VAL(16)
   LET tm.f  = ARG_VAL(17)
   LET tm.s  = ARG_VAL(18)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   #No.FUN-570264 ---end---
   LET tm.ctype   = ARG_VAL(22)  #FUN-9C0170
  #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r999_tm(0,0)
      ELSE CALL r999()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
#-------------------------r999_tm()---------------------------
FUNCTION r999_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 13 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 3 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 13
   END IF
 
   OPEN WINDOW r999_w AT p_row,p_col
         WITH FORM "aim/42f/aimr999"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################

   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #FUN-9C0170

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.d    = 'N'
   LET tm.e    = '3'
   LET tm.f    = 'Y'
   LET tm.s    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.ctype = g_ccz.ccz28   #FUN-9C0170
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pia02,pia05,pia03,pia04,pia01
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         IF INFIELD(pia02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pia02
            NEXT FIELD pia02
         END IF
#No.FUN-570240 --end
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r999_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.yy,tm.mm,tm.yy1,tm.mm1,
                 tm.ctype,  #FUN-9C0170
                 tm.d,tm.e,tm.f,tm.s,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
      AFTER FIELD d
         IF tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e NOT MATCHES '[0123]' THEN
            NEXT FIELD e
         END IF
      AFTER FIELD f
         IF tm.f NOT MATCHES '[YN]' THEN
            NEXT FIELD f
         END IF
      AFTER FIELD s
         IF tm.s NOT MATCHES '[13]' THEN
            NEXT FIELD s
         END IF
      AFTER FIELD mm1
         IF tm.mm1 >12 THEN
            NEXT FIELD mm1
         END IF
      AFTER FIELD mm
         IF tm.mm1 >12 THEN
            NEXT FIELD mm
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()
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
      CLOSE WINDOW r999_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimr999'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr999','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.mm1 CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",tm.ctype CLIPPED,"'"              #FUN-9C0170
         CALL cl_cmdat('aimr999',g_time,l_cmd)
      END IF
      CLOSE WINDOW r999_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r999()
   ERROR ""
END WHILE
   CLOSE WINDOW r999_w
END FUNCTION
#-------------------------FUNCTION r999()------------------------
FUNCTION r999()
  DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#  DEFINE l_time    LIKE type_file.chr8            # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
  DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
  DEFINE l_za05    LIKE za_file.za05  #No.FUN-690026 VARCHAR(40)
  DEFINE l_pia40   LIKE pia_file.pia40   #No.B482 add
  DEFINE l_pia50   LIKE pia_file.pia50   #No.B482 add
  DEFINE l_pia60   LIKE pia_file.pia60   #No.B482 add
  DEFINE sr        RECORD
                        order1 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order2 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order3 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order4 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order5 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order6 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        pia01  LIKE pia_file.pia01, #標籤編號 No:7597
                        pia02  LIKE pia_file.pia02, #料號     No:7597
                        pia03  LIKE pia_file.pia03, #倉庫     No:7597
                        pia04  LIKE pia_file.pia04, #儲位     No:7597
                        pia05  LIKE pia_file.pia05, #批號
                        pia09  LIKE pia_file.pia09, #庫存單位 No:7597
                        pia30  LIKE pia_file.pia30, #初盤     No:7597
                        pia60  LIKE pia_file.pia60, #         No:7597
                        ima02  LIKE ima_file.ima02, #品名
                        ima021 LIKE ima_file.ima021,#規格
                        img10  LIKE img_file.img10, #庫存數量 No:759
                        diff1  LIKE img_file.img10, #MOD-530179
                        diff2  LIKE img_file.img10  #MOD-530179
                     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #小數位----------------------------------------------
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,zai05
#     INTO g_azi03,g_azi04,g_azi05
#     FROM azi_file
#     WHERE azi01=a_azi.azi17
#NO.CHI-6A0004--END
#--------------------------------------l_sql--------------------------------
     LET l_sql = "SELECT '','','','','','',",
                 "pia01,pia02,pia03,pia04,pia05,pia09,pia30,pia60, ",
               # "ima02,ima021,img10,'','' ",    #No.B482
                 "ima02,ima021,img10,'','',pia40,pia50 ",
                 "  FROM pia_file, ima_file, OUTER img_file",
                 " WHERE pia02=ima01 ",
                 "   AND pia_file.pia02=img_file.img01 ",
                 "   AND pia_file.pia03=img_file.img02 ",
                 "   AND pia_file.pia04=img_file.img03 ",
                 "   AND pia_file.pia05=img_file.img04 ",
                 "   AND ", tm.wc CLIPPED
 
     PREPARE r999_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r999_curs1 CURSOR FOR r999_prepare1
     CALL cl_outnam('aimr999') RETURNING l_name
 
     START REPORT r999_rep TO l_name
     LET g_pageno = 0
     FOREACH r999_curs1 INTO sr.*,l_pia40,l_pia50
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #-----------------------------------------------------------
       #『庫存結存年月』,空白表示現有庫存
       IF tm.yy IS NOT NULL AND tm.mm IS NOT NULL THEN
          SELECT imk09 INTO sr.img10 FROM imk_file
                 WHERE imk01=sr.pia02
                   AND imk02=sr.pia03
                   AND imk03=sr.pia04
                   AND imk04=sr.pia05
                   AND imk05=tm.yy
                   AND imk06=tm.mm
       END IF
       IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       #------------------------------------------------------------
       IF sr.pia30 IS NULL THEN LET sr.pia30=0 END IF
       #------------------------------------------------------------
       #-->複盤有值先以複盤為主
       #No.B482 010510 by linda mod 順序應為複盤二,複盤一,初盤二,初盤一
     # IF not cl_null(sr.pia60) AND sr.pia60 > 0 THEN
     #    LET sr.pia30 = sr.pia60
     # END IF
       IF not cl_null(sr.pia60)  THEN
          LET sr.pia30 = sr.pia60
       ELSE
          IF NOT cl_null(l_pia50) THEN
             LET sr.pia30=l_pia50
          ELSE
             IF NOT cl_null(l_pia40) THEN
                LET sr.pia30 = l_pia40
             END IF
          END IF
       END IF
       #No.B482 end---
 
       IF tm.a='N' THEN LET sr.pia05=' ' END IF
       IF tm.b='N' THEN LET sr.pia03=' ' END IF
       IF tm.c='N' THEN LET sr.pia04=' ' END IF
       IF tm.a='N' OR tm.b='N' OR tm.c='N' THEN LET sr.pia01=' ' END IF
       #無盤盈虧差異者..
       IF tm.d='N' AND sr.img10=sr.pia30 THEN CONTINUE FOREACH END IF
       #------------------------------------------------------------
       IF sr.img10 > sr.pia30 THEN
          LET sr.diff2=sr.img10-sr.pia30
          LET sr.diff1=0
       ELSE
          LET sr.diff1=sr.pia30-sr.img10
          LET sr.diff2=0
       END IF
       #-----------------------------------------------------------
       #處理排序
       IF tm.s='1' THEN   #料號
          LET sr.order1=sr.pia02
          LET sr.order2=sr.pia03
          LET sr.order3=sr.pia04
          LET sr.order4=sr.pia05
          LET sr.order5=sr.pia09
          LET sr.order6=sr.pia01
       END IF
       IF tm.s='3' THEN   #倉庫
          LET sr.order1=sr.pia03
          LET sr.order2=sr.pia04
          LET sr.order3=sr.pia05
          LET sr.order4=sr.pia09
          LET sr.order5=sr.pia02
          LET sr.order6=sr.pia01
       END IF
       OUTPUT TO REPORT r999_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r999_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
#---------------------------FUNCTION r998()------------------------
REPORT r999_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE tot1,   #img10
       tot2,   #pia30
       tot3,
       tot4         LIKE img_file.img10,#MOD-530179
   #========================================
       tot1_s       LIKE img_file.img10,#MOD-530179   #img10小計
       tot2_s       LIKE pia_file.pia30,#MOD-530179   #pia30小計
       l_yy         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_mm         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_ccc23      LIKE ccc_file.ccc23,
       l_ccc23_s    LIKE ccc_file.ccc23,
       l_a01        LIKE ccc_file.ccc23, #MOD-530179  #帳列金額
       l_a02        LIKE ccc_file.ccc23, #MOD-530179  #實盤金額
       l_a03        LIKE ccc_file.ccc23, #MOD-530179  #盤盈虧損
       l_a04        LIKE ccc_file.ccc23, #MOD-530179  #盤盈虧金額
       l_a01_s      LIKE ccc_file.ccc23, #MOD-530179
       l_a02_s      LIKE ccc_file.ccc23, #MOD-530179
       l_a03_s      LIKE ccc_file.ccc23, #MOD-530179
       l_a04_s      LIKE ccc_file.ccc23  #MOD-530179
    #==================================
 
  DEFINE sr        RECORD
                        order1 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order2 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order3 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order4 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order5 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        order6 LIKE pia_file.pia02, #No.FUN-690026 VARCHAR(30)
                        pia01  LIKE pia_file.pia01, #標籤編號 No:7597
                        pia02  LIKE pia_file.pia02, #料號     No:7597
                        pia03  LIKE pia_file.pia03, #倉庫     No:7597
                        pia04  LIKE pia_file.pia04, #儲位     No:7597
                        pia05  LIKE pia_file.pia05, #批號
                        pia09  LIKE pia_file.pia09, #庫存單位 No:7597
                        pia30  LIKE pia_file.pia30, #初盤     No:7597
                        pia60  LIKE pia_file.pia60, #         No:7597
                        ima02  LIKE ima_file.ima02, #品名
                        ima021 LIKE ima_file.ima021,#規格
                        img10  LIKE img_file.img10, #庫存數量 No:759
                        diff1  LIKE img_file.img10, #MOD-530179
                        diff2  LIKE img_file.img10  #MOD-530179
                     END RECORD
   DEFINE l_totamt   LIKE ccc_file.ccc23 #MOD-530179
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5,sr.order6
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED      #TQC-6A0088加CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44]
      PRINT g_dash1
      LET l_last_sw = 'n'
    #----------------------------------------------------------
    #歸零#@@@@@@@@@@@@@@@@@@不用sum
    BEFORE GROUP OF sr.order1
        IF tm.s='1' THEN
            LET tot1_s = 0
            LET tot2_s = 0
            LET l_a01_s = 0
            LET l_a02_s = 0
        END IF
 
    AFTER GROUP OF sr.order1
        #以料號排序 時才做小計
        #IF tm.s='1' AND tm.f='Y' THEN
        IF tm.f='Y' THEN
           PRINT COLUMN g_c[35],g_x[15] CLIPPED,
                 COLUMN g_c[37],cl_numfor(tot1_s,37,tm.e),#帳列數量小計 No:7597
                 COLUMN g_c[38],cl_numfor(l_a01_s,38,g_azi03),#帳列金額小計
                 COLUMN g_c[40],cl_numfor(tot2_s,40,tm.e) ,#實盤量小計   No:7597
                 COLUMN g_c[41],cl_numfor(l_a02_s,41,g_azi03),#實盤金額小計
                 COLUMN g_c[42],cl_numfor(GROUP SUM(sr.pia30-sr.img10),42,tm.e),
                 COLUMN g_c[44],cl_numfor(GROUP SUM((sr.pia30-sr.img10))*l_ccc23,44,g_azi03)
   #       PRINT g_dash2,"-------------------------"        #TQC-6A0088
           PRINT g_dash2                                   #TQC-6A0088
        END IF
    #-------------------------------------------------
    BEFORE GROUP OF sr.order6
       LET l_yy=0
       LET l_mm=0
       LET l_ccc23=0
       LET l_ccc23_s=0
       LET l_a01 =0
       LET l_a02 =0
       LET l_a03=0
       LET l_a04=0
 
 
 
    AFTER GROUP OF sr.order6
       #select ccc23 ...考慮計價年月
       IF cl_null(tm.yy1) OR cl_null(tm.mm1) THEN
            SELECT ccz01,ccz02
            INTO l_yy,l_mm
            FROM ccz_file
       ELSE
          LET l_yy=tm.yy1
          LET l_mm=tm.mm1
       END IF
       SELECT AVG(ccc23) INTO l_ccc23 FROM ccc_file WHERE ccc01=sr.pia02 #FUN-9C0170
                                                AND ccc02=l_yy AND ccc03=l_mm
                                               #AND ccc07='1'  #No.FUN-840041 #FUN-9C0170
                                                AND ccc07=tm.ctype #FUN-9C0170
       IF cl_null(l_ccc23) THEN LET l_ccc23=0 END IF
    #------------------------------------------------
       LET tot1 = GROUP SUM(sr.img10) USING '------------&.&&&' #帳列數量
       LET tot2 = GROUP SUM(sr.pia30) USING '------------&.&&&' #實盤量　  #MOD-910174
      #LET tot2 = GROUP SUM(sr.pia30) USING '&.&&&' #實盤量　              #MOD-910174 mark
       LET tot1_s = tot1_s + tot1
       LET tot2_s = tot2_s + tot2
    #-------------------------------------------
       LET l_a01=l_ccc23*tot1      #帳列金額
       LET l_a02=l_ccc23*tot2      #實盤金額
       IF cl_null(tot2) THEN LET tot2=0 END IF
       IF cl_null(tot1) THEN LET tot1=0 END IF
       LET l_a03=tot2-tot1         #盤盈虧損
       LET l_a04=l_a03*l_ccc23     #盤盈虧損金額
       LET l_a01_s=l_a01_s + l_a01
       LET l_a02_s=l_a02_s + l_a02
       #-------------------------------------------
       #無盤盈虧差異者是否列印
       IF tm.d='N' AND tot1=tot2 THEN
       ELSE
          #No:7597
          PRINT COLUMN g_c[31],sr.pia03  CLIPPED,          #倉
                COLUMN g_c[32],sr.pia04  CLIPPED,          #儲
                COLUMN g_c[33],sr.pia02  CLIPPED,    #料
                 COLUMN g_c[34],sr.ima02 CLIPPED, #MOD-4A0238
                 COLUMN g_c[35],sr.ima021 CLIPPED, #MOD-4A0238   #規
                COLUMN g_c[36],sr.pia09  CLIPPED,          #單位
                COLUMN g_c[37],cl_numfor(tot1,37,tm.e) ,              #帳列數量
                COLUMN g_c[38],cl_numfor(l_a01,38,g_azi03),#帳列金額
                COLUMN g_c[39],sr.pia01 CLIPPED,           #盤點卡號
                COLUMN g_c[40],cl_numfor(tot2,40,tm.e),              #實盤量
                COLUMN g_c[41],cl_numfor(l_a02,41,g_azi03),#實盤金額
                COLUMN g_c[42],cl_numfor(l_a03,42,tm.e) ,             #盤盈虧損
                COLUMN g_c[43],cl_numfor(l_ccc23,43,6),
                COLUMN g_c[44], cl_numfor(l_a04,44,g_azi03)
          ##
                LET l_totamt = l_totamt+l_a04    #總盤盈虧金額
           END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT COLUMN g_c[35],g_x[16] CLIPPED,
          # COLUMN g_c[37],cl_numfor(SUM(tot1_s),37,tm.e) ,   #帳列數量總計   #TQC-C80081  mark
            COLUMN g_c[37],cl_numfor(SUM(sr.img10),37,tm.e) ,   #帳列數量總計  #TQC-C80081  add
          # COLUMN g_c[38],cl_numfor(SUM(l_a01_s),15,g_azi03),#帳列金額計     #TQC-C80081  mark
            COLUMN g_c[38],cl_numfor(SUM(sr.img10)*l_ccc23,38,g_azi03),#帳列金額計        #TQC-C80081  add
          # COLUMN g_c[40],cl_numfor(SUM(tot2_s),39,tm.e),    #實盤量計       #TQC-C80081  mark
            COLUMN g_c[40],cl_numfor(SUM(sr.pia30),40,tm.e),    #實盤量計          #TQC-C80081  add
          # COLUMN g_c[41],cl_numfor(SUM(l_a02_s),41,g_azi03),#實盤金額計     #TQC-C80081  mark
            COLUMN g_c[41],cl_numfor(SUM(sr.pia30)*l_ccc23,41,g_azi03),#實盤金額計        #TQC-C80081  add
            COLUMN g_c[42],cl_numfor(SUM(sr.pia30-sr.img10),42,tm.e),
          # COLUMN g_c[44],cl_numfor(l_totamt,44,g_azi03)                         #TQC-C80081  mark
            COLUMN g_c[44],cl_numfor(SUM((sr.pia30-sr.img10))*l_ccc23,44,g_azi03)  #TQC-C80081  add
 
      PRINT g_dash
  #   PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_c[44], g_x[7] CLIPPED          #TQC-6A0088
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED          #TQC-6A0088
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_c[44], g_x[6] CLIPPED         #TQC-6A0088
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED         #TQC-6A0088
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610036 <001> #
