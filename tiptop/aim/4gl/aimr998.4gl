# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr998.4gl
# Descriptions...: 盤盈虧彙總表
# Date & Author..: 99/12/22 by Snow
# Modify..........dbo.No:7597 03/07/14 By mandy pia03 /pia04 宣告時是用char(4).., 應用 like pia_file.pia03
# Modify.........:No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02,ima021
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-690072 06/12/01 By rainy 料號合計改成是否列印小計合計，選料號或倉庫別都能印小計
# Modify.........: No.MOD-690059 06/12/07 By Claire 小計及總計的算法錯誤
# Modify.........: No.MOD-720046 07/04/04 MOD-720046 By TSD.Jin 改為Crystal Report
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-8C0087 08/12/29 By jan QBE條件需再加上[成本分群]與[標簽編號]
# Modify.........: No.FUN-930121 09/04/14 By zhaijie新增查詢字段pia931-底稿類型
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0170 10/01/11 By jan 新增ctype欄位及相關處理
# Modify.........: No:CHI-B10033 11/03/09 By sabrina 庫存數量由img10改抓pia08
# Modify.........: No:MOD-CC0207 13/01/11 By Elise 報表抓取數量順序改為複盤一,初盤一
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc              LIKE type_file.chr1000,     #No.FUN-690026 VARCHAR(500)
          #yy,mm,yy1,mm1   LIKE type_file.num5,        #No.FUN-690026 SMALLINT      #CHI-B10033 mark
           yy1,mm1         LIKE type_file.num5,        #No.FUN-690026 SMALLINT      #CHI-B10033 add
           z,a,b,c,d,e,f,h,w,s LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           ctype           LIKE type_file.chr1,        #FUN-9C0170
           more            LIKE type_file.chr1         #No.FUN-690026 VARCHAR(1)
           END RECORD
#MOD-690059-begin-add 
DEFINE g_tot1_s LIKE img_file.img10,    #img10帳列數量總計
       g_tot2_s LIKE pia_file.pia30,    #pia30實盤量總計  
       g_a01_s LIKE img_file.img10,    #img10總計    
       g_a02_s LIKE pia_file.pia30,    #pia30總計    
       g_totamt LIKE ccc_file.ccc23,    #盤盈虧量總計
       g_sum LIKE ccc_file.ccc23        #盤盈虧金額總計
#MOD-690059-end-add 
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
 
#070404 MOD-720046 By TSD.Jin--start
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#070404 MOD-720046 By TSD.Jin--end
 
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
 
#070404 MOD-720046 By TSD.Jin--start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " pia01.pia_file.pia01, ",
               " pia02.pia_file.pia02, ",
               " pia03.pia_file.pia03, ",
               " pia04.pia_file.pia04, ",
               " pia05.pia_file.pia05, ",
               " pia09.pia_file.pia09, ",
               " pia30.pia_file.pia30, ",
               " ima02.ima_file.ima02, ",
               " ima021.ima_file.ima021,",
               " img10.img_file.img10, ",
               " diff1.img_file.img10, ",
               " diff2.img_file.img10, ", 
               " ccc23.ccc_file.ccc23, ",
               " l_a01.ccc_file.ccc23, ",
               " l_a02.ccc_file.ccc23, ",
               " l_a03.ccc_file.ccc23, ",
               " l_a04.ccc_file.ccc23, ",
               " azi03.azi_file.azi03, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05, ",
               " ccc08.ccc_file.ccc08 "    #FUN-9C0170 
 
   LET l_table = cl_prt_temptable('aimr998',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?) "  #FUN-9C0170
  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#070404 MOD-720046 By TSD.Jin--end
 
   #TQC-610072-begin
   #LET g_pdate = ARG_VAL(1)
   #LET g_towhom = ARG_VAL(2)
   #LET g_rlang = ARG_VAL(3)
   #LET g_bgjob = 'N'
   #LET g_prtway = ARG_VAL(5)
   #LET g_copies = 1
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.z  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
  #LET tm.yy  = ARG_VAL(11)     #CHI-B10033 mark
  #LET tm.mm  = ARG_VAL(12)     #CHI-B10033 mark
   LET tm.yy1  = ARG_VAL(11)
   LET tm.mm1  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   LET tm.w  = ARG_VAL(16)
   LET tm.s  = ARG_VAL(17)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)  #No:FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.ctype   = ARG_VAL(22)  #FUN-9C0170
   #TQC-610072-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r998_tm(0,0)
      ELSE CALL r998()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
#----------------------------r998_tm()--------------------
FUNCTION r998_tm(p_row,p_col)
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
 
   OPEN WINDOW r998_w AT p_row,p_col
         WITH FORM "aim/42f/aimr998"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #FUN-9C0170

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.z    = 'Y'
   LET tm.b    = 'Y'
   LET tm.c    = 'Y'
   LET tm.d    = 'N'
   LET tm.e    = '3'
   LET tm.f    = 'Y'
   LET tm.w    = 'Y'
   LET tm.s    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.ctype = g_ccz.ccz28   #FUN-9C0170
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pia02,pia03,ima12,pia05,pia04,pia01,     #FUN-8C0087 add ima12,pia01
                              pia931                                   #FUN-930121 add pia931
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
      CLOSE WINDOW r998_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  #INPUT BY NAME tm.yy,tm.mm,tm.yy1,tm.mm1,tm.ctype,tm.e,tm.s,tm.z,tm.b,tm.c,  #FUN-9C0170   #CHI-B10033 mark
   INPUT BY NAME tm.yy1,tm.mm1,tm.ctype,tm.e,tm.s,tm.z,tm.b,tm.c,                            #CHI-B10033 add 
                 tm.d,tm.f,tm.w,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
   #CHI-690072--begin
     #ON CHANGE s
     #   IF tm.s ='3' THEN
     #     LET tm.f='N'
     #     DISPLAY BY NAME tm.f
     #     CALL cl_set_comp_entry("f",FALSE)
     #   ELSE
     #     CALL cl_set_comp_entry("f",TRUE)
     #   END IF
   #CHI-690012--end
 
      AFTER FIELD z
         IF tm.z NOT MATCHES '[YN]' THEN
            NEXT FIELD z
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
      AFTER FIELD w
         IF tm.w NOT MATCHES '[YN]' THEN
            NEXT FIELD w
         END IF
      AFTER FIELD s
         IF tm.s NOT MATCHES '[13]' THEN
            NEXT FIELD s
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
      CLOSE WINDOW r998_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimr998'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr998','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.z CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                        #" '",tm.yy CLIPPED,"'",         #CHI-B10033 mark     
                        #" '",tm.mm CLIPPED,"'",         #CHI-B10033 mark     
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.mm1 CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.ctype CLIPPED,"'"              #No.FUN-9C0170
         CALL cl_cmdat('aimr998',g_time,l_cmd)
      END IF
      CLOSE WINDOW r998_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r998()
   ERROR ""
END WHILE
   CLOSE WINDOW r998_w
END FUNCTION
#----------------------------FUNCTION r998()-----------------------
FUNCTION r998()
  DEFINE l_name   LIKE type_file.chr20         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#  DEFINE l_time   LIKE type_file.chr8          # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
  DEFINE l_sql    LIKE type_file.chr1000       # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
  DEFINE l_za05   LIKE za_file.za05            #No.FUN-690026 VARCHAR(40)
  DEFINE l_order1,l_order2,l_order3,l_order4,l_order5 LIKE ima_file.ima01 #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
  DEFINE l_pia40  LIKE pia_file.pia40   #No.B483 add
  DEFINE l_pia50  LIKE pia_file.pia50   #No.B483 add
  DEFINE l_pia60  LIKE pia_file.pia60   #No.B483 add
  DEFINE sr       RECORD
                  order1 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                  order2 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                  order3 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                  order4 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                  order5 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
                  pia01  LIKE pia_file.pia01, #標籤編號
                  pia02  LIKE pia_file.pia02, #No:7597
                  pia03  LIKE pia_file.pia03, #No:7597
                  pia04  LIKE pia_file.pia04, #No:7597
                  pia05  LIKE pia_file.pia05, #批號
                  pia09  LIKE pia_file.pia09, #No:7597
                  pia30  LIKE pia_file.pia30, #No:7597
                  ima02  LIKE ima_file.ima02, #No:7597
                  ima021 LIKE ima_file.ima021,#規格
                  img10  LIKE img_file.img10, #No:7597
                  diff1  LIKE img_file.img10, #MOD-530179
                  diff2  LIKE img_file.img10, #MOD-530179
                  ccc08  LIKE ccc_file.ccc08  #FUN-9C0170
                 END RECORD
 
#070404 MOD-720046 By TSD.Jin--start
   DEFINE l_yy    LIKE type_file.num5,   #SMALLINT
          l_mm    LIKE type_file.num5,   #SMALLINT
          l_ccc23 LIKE ccc_file.ccc23,
          l_a01   LIKE ccc_file.ccc23,   #帳列金額
          l_a02   LIKE ccc_file.ccc23,   #實盤金額
          l_a03   LIKE ccc_file.ccc23,   #盤盈虧損
          l_a04   LIKE ccc_file.ccc23    #盤盈虧金額
   DEFINE l_str   STRING     #FUN-9C0170  
   DEFINE l_str1  STRING     #FUN-9C0170  
   DEFINE l_str2  STRING     #FUN-9C0170  
   DEFINE l_str3  STRING     #FUN-9C0170  
   DEFINE l_str4  STRING     #FUN-9C0170  
   DEFINE l_pia30 LIKE pia_file.pia30    #MOD-CC0207 add
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr998'
#070404 MOD-720046 By TSD.Jin--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #小數位----------------------------------------------
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,zai05
#     INTO g_azi03,g_azi04,g_azi05
#     FROM azi_file
#     WHERE azi01=a_azi.azi17
#NO.CHI-6A0004--END
#----------------------------l_sql------------------------------
#FUN-9C0170--begin--modify----------------------
#    LET l_sql = "SELECT '','','','','',",
#                "pia01,pia02,pia03,pia04,pia05,pia09,pia30, ",
#              # "ima02,ima021,img10,'','' ",         #No.B483 mod
#                "ima02,ima021,img10,'','',pia40,pia50,pia60 ",
#                "  FROM pia_file, ima_file, OUTER img_file",
#                " WHERE pia02=ima01 ",
#                "   AND pia_file.pia02=img_file.img01 ",
#                "   AND pia_file.pia03=img_file.img02 ",
#                "   AND pia_file.pia04=img_file.img03 ",
#                "   AND pia_file.pia05=img_file.img04 ",
#                "   AND ", tm.wc CLIPPED
     LET l_sql=''
    #CHI-B10033---add---start---
     IF cl_null(tm.yy1) OR cl_null(tm.mm1) THEN
        SELECT ccz01,ccz02 INTO l_yy,l_mm FROM ccz_file
     ELSE
        LET l_yy=tm.yy1
        LET l_mm=tm.mm1
     END IF
    #CHI-B10033---add---end---
     LET l_sql = "SELECT '','','','','',", 
                 "pia01,pia02,pia03,pia04,pia05,pia09,pia30, ", 
                #"ima02,ima021,img10,'','',ccc08,pia40,pia50,pia60,ccc23 "       #CHI-B10033 mark
                 "ima02,ima021,pia08,'','',ccc08,pia40,pia50,pia60,ccc23 "       #CHI-B10033 add
     LET l_str1= "  LEFT OUTER JOIN img_file ON pia02=img01 AND pia03=img02 AND pia04=img03 AND pia05=img04 " ,
                #"  LEFT OUTER JOIN ccc_file ON ccc01=pia02 AND ccc02=",tm.yy," AND ccc03=",tm.mm," AND ccc07='",tm.ctype,"' "        #CHI-B10033 mark
                 "  LEFT OUTER JOIN ccc_file ON ccc01=pia02 AND ccc02=",l_yy," AND ccc03=",l_mm," AND ccc07='",tm.ctype,"' "          #CHI-B10033 add
     LET l_str2= " WHERE pia02=ima01 ",
                 "   AND ", tm.wc CLIPPED
     CASE tm.ctype
       WHEN '3'  LET l_str = " AND ccc08=pia05 "
       WHEN '5'  LET l_str = ""
       OTHERWISE LET l_str = " AND ccc08 =' ' "
     END CASE
     IF tm.ctype = '5' THEN
        LET l_str3 = "  FROM ima_file,imd_file,pia_file "
        LET l_str4 = "  AND ccc08=imd09 AND imd01=pia03"
     ELSE
        LET l_str3 = " FROM ima_file,pia_file "
        LET l_str4 = ""
     END IF
     LET l_sql = l_sql CLIPPED,l_str3,l_str1,l_str,l_str2,l_str4
#FUN-9C0170--end-mod-------------------------------
     PREPARE r998_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r998_curs1 CURSOR FOR r998_prepare1
 
    #070404 MOD-720046 By TSD.Jin--start mark
    #CALL cl_outnam('aimr998') RETURNING l_name
 
    #START REPORT r998_rep TO l_name
    #070404 MOD-720046 By TSD.Jin--end mark
 
     LET g_pageno = 0
     #MOD-690059-begin
      LET g_tot1_s  = 0
      LET g_a01_s = 0
      LET g_tot2_s  = 0
      LET g_a02_s = 0
      LET g_totamt = 0
      LET g_sum = 0
     #MOD-690059-end
 
     FOREACH r998_curs1 INTO sr.*,l_pia40,l_pia50,l_pia60,l_ccc23
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #-----------------------------------------------------------
      #CHI-B10033---mark---start---
      ##『庫存結存年月』,空白表示現有庫存
      #IF tm.yy IS NOT NULL AND tm.mm IS NOT NULL THEN
      #   SELECT imk09 INTO sr.img10 FROM imk_file
      #          WHERE imk01=sr.pia02
      #            AND imk02=sr.pia03
      #            AND imk03=sr.pia04
      #            AND imk04=sr.pia05
      #            AND imk05=tm.yy
      #            AND imk06=tm.mm
      #END IF
      #CHI-B10033---mark---end---
       IF sr.img10 IS NULL THEN LET sr.img10=0 END IF
       #------------------------------------------------------------
       IF sr.pia30 IS NULL THEN LET sr.pia30=0 END IF
      #MOD-CC0207---mark---s
      ##No.B483 010510 by linda mod 順序應為複盤二,複盤一,初盤二,初盤一
      #IF not cl_null(l_pia60)  THEN
      #   LET sr.pia30 = l_pia60
      #ELSE
      #   IF NOT cl_null(l_pia50) THEN
      #      LET sr.pia30=l_pia50
      #   ELSE
      #      IF NOT cl_null(l_pia40) THEN
      #         LET sr.pia30 = l_pia40
      #      END IF
      #   END IF
      #END IF
      ##No.B483 end---
      #MOD-CC0207---mark---e
      #MOD-CC0207---S
      #順序改為複盤一,初盤一
       SELECT pia30,pia50 INTO l_pia30,l_pia50 FROM pia_file
        WHERE pia01=sr.pia01

       IF NOT cl_null(l_pia50) THEN
          LET sr.pia30 = l_pia50
       ELSE
          IF NOT cl_null(l_pia30) THEN
             LET sr.pia30 = l_pia30
          END IF
       END IF
      #MOD-CC0207---E

       #------------------------------------------------------------
       IF tm.z='N' THEN LET sr.pia02=' ' END IF
       IF tm.b='N' THEN LET sr.pia03=' ' END IF
       IF tm.c='N' THEN LET sr.pia04=' ' END IF
 
       #IF tm.b='N' OR tm.c='N' THEN LET sr.pia01=' ' END IF@@@
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
      #070404 MOD-720046 By TSD.Jin--start
      ##-----------------------------------------------------------
      ##處理排序
      #IF tm.s='1' THEN
      #   LET sr.order1=sr.pia02
      #   LET sr.order2=sr.pia03
      #   LET sr.order3=sr.pia04
      #   LET sr.order4=sr.pia05
      #   LET sr.order5=sr.pia09
      #END IF
      #IF tm.s='3' THEN
      #   LET sr.order1=sr.pia03
      #   LET sr.order2=sr.pia04
      #   LET sr.order3=sr.pia05
      #   LET sr.order4=sr.pia09
      #   LET sr.order5=sr.pia02
      #END IF
      #OUTPUT TO REPORT r998_rep(sr.*)
#FUN-9C0170--begin--mark-----
#      #select ccc23 ...考慮計價年月
#      IF cl_null(tm.yy1) OR cl_null(tm.mm1) THEN
#         SELECT ccz01,ccz02 INTO l_yy,l_mm FROM ccz_file
#      ELSE
#         LET l_yy=tm.yy1
#         LET l_mm=tm.mm1
#      END IF
#
#      LET l_ccc23=0
#      SELECT ccc23 INTO l_ccc23 FROM ccc_file
#       WHERE ccc01=sr.pia02 AND ccc02=l_yy AND ccc03=l_mm
#         AND ccc07='1'                    #No.FUN-840041
#FUN-9C0170--end--mark-------
       IF cl_null(l_ccc23)  THEN LET l_ccc23 = 0 END IF
       LET l_a01 = l_ccc23 * sr.img10      #帳列金額
       LET l_a02 = l_ccc23 * sr.pia30      #實盤金額
       LET l_a03 = sr.pia30 - sr.img10     #盤盈虧損
       LET l_a04 = l_a03 * l_ccc23         #盤盈虧損金額
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.pia01,sr.pia02,sr.pia03,sr.pia04, sr.pia05,
          sr.pia09,sr.pia30,sr.ima02,sr.ima021,sr.img10,
          sr.diff1,sr.diff2,l_ccc23, l_a01,    l_a02,
          l_a03,   l_a04,   g_azi03, g_azi04,  g_azi05,sr.ccc08   #FUN-9C0170  
 
      #07040 iam12,pia014 MOD-720046 By TSD.Jin--end
     END FOREACH
    #070404 MOD-720046 By TSD.Jin--start
    #FINISH REPORT r998_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pia02,pia05,pia03,pia04,ima12,pia01,pia931')  #FUN-8C0087 add iam12,pia01  #FUN-930121 add pia931
           RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.b,";",tm.c,";",tm.d,";",tm.e,";",tm.f,";",
                 tm.s,";",tm.w,";",tm.z 
  
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  
     CALL cl_prt_cs3('aimr998','aimr998',l_sql,g_str)
    #070404 MOD-720046 By TSD.Jin--end
END FUNCTION
 
#070404 MOD-720046 By TSD.Jin--start mark
##---------------------------FUNCTION r998()------------------------
#REPORT r998_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
#DEFINE tot1         LIKE img_file.img10,   #img10帳列數量#MOD-530179
#       tot2         LIKE pia_file.pia30,   #pia30實盤量  #MOD-530179
#       tot1_s       LIKE img_file.img10,   #img10小計    #MOD-530179
#       tot2_s       LIKE pia_file.pia30,   #pia30小計    #MOD-530179
#       l_yy         LIKE type_file.num5,   #No.FUN-690026 SMALLINT
#       l_mm         LIKE type_file.num5,   #No.FUN-690026 SMALLINT
#       l_ccc23      LIKE ccc_file.ccc23,
#       l_ccc23_s    LIKE ccc_file.ccc23,
#       l_a01        LIKE ccc_file.ccc23, #MOD-530179 #帳列金額
#       l_a02        LIKE ccc_file.ccc23, #MOD-530179  #實盤金額
#       l_a03        LIKE ccc_file.ccc23, #MOD-530179  #盤盈虧損
#       l_a04        LIKE ccc_file.ccc23, #MOD-530179  #盤盈虧金額
#       l_a01_s      LIKE ccc_file.ccc23, #MOD-530179
#       l_a02_s      LIKE ccc_file.ccc23, #MOD-530179
#       l_a03_s      LIKE ccc_file.ccc23, #MOD-530179
#       l_a04_s      LIKE ccc_file.ccc23  #MOD-530179
#DEFINE sr           RECORD
#                    order1 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                    order2 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                    order3 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                    order4 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                    order5 LIKE ima_file.ima01, #FUN-5B0105 30->40  #No.FUN-690026 VARCHAR(40)
#                    pia01  LIKE pia_file.pia01, #標籤編號
#                    pia02  LIKE pia_file.pia02, #No:7597
#                    pia03  LIKE pia_file.pia03, #No:7597
#                    pia04  LIKE pia_file.pia04, #No:7597
#                    pia05  LIKE pia_file.pia05, #批號
#                    pia09  LIKE pia_file.pia09, #No:7597
#                    pia30  LIKE pia_file.pia30, #No:7597
#                    ima02  LIKE ima_file.ima02, #No:7597
#                    ima021 LIKE ima_file.ima021,#規格
#                    img10  LIKE img_file.img10, #No:7597
#                    diff1  LIKE img_file.img10, #MOD-530179
#                    diff2  LIKE img_file.img10  #MOD-530179
#                    END RECORD
##DEFINE l_totamt LIKE ccc_file.ccc23 #MOD-530179  #MOD-690059 mark
#DEFINE l_sum        LIKE ccc_file.ccc23
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.order4,sr.order5
# 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#    #--------------------------------------------------
#    #當以料號還排序時，才可做小計
#    #歸零
#    BEFORE GROUP OF sr.order1
#       #IF tm.s='1' THEN          #MOD-690059 mark
#            LET tot1_s = 0
#            LET tot2_s = 0
#            LET l_a01_s = 0
#            LET l_a02_s = 0
#       #END IF                    #MOD-690059 mark
#        LET l_sum = 0             #MOD-690059 add
# 
#    AFTER GROUP OF sr.order1
#        IF tm.f='Y' THEN
#          #LET l_sum = GROUP SUM((sr.pia30-sr.img10))*l_ccc23  #MOD-690059 mark
#          #PRINT g_dash2   #MOD-690059 mark
#           PRINT COLUMN g_c[35],g_x[15] CLIPPED,
#                 COLUMN g_c[37],cl_numfor(tot1_s,37,tm.e),               #帳列數量小計 No:7597
#                 COLUMN g_c[38],cl_numfor(l_a01_s,38,g_azi03), #帳列金額小計
#                 COLUMN g_c[39],cl_numfor(tot2_s,39,tm.e),               #實盤量小計
#                 COLUMN g_c[40],cl_numfor(l_a02_s,40,g_azi04), #實盤金額小計
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.pia30-sr.img10),41,tm.e),
#               # COLUMN g_c[42],cl_numfor(l_ccc23,42,6),  #MOD-690059 mark
#                 COLUMN g_c[43],cl_numfor(l_sum,43,g_azi03)
#        END IF
#          #MOD-690059-begin-add
#          PRINT g_dash2 
#          LET g_tot1_s=g_tot1_s+tot1_s
#          LET g_tot2_s=g_tot2_s+tot2_s
#          LET g_a01_s =g_a01_s +l_a01_s
#          LET g_a02_s =g_a02_s +l_a02_s
#          LET g_totamt=g_totamt+GROUP SUM(sr.pia30-sr.img10)
#          LET g_sum   =g_sum   +l_sum
#          #MOD-690059-end-add
#    #--------------------------------------------------
#    AFTER GROUP OF sr.order5
#       #select ccc23 ...考慮計價年月
#       IF cl_null(tm.yy1) OR cl_null(tm.mm1) THEN
#            SELECT ccz01,ccz02 INTO l_yy,l_mm FROM ccz_file
#       ELSE
#          LET l_yy=tm.yy1
#          LET l_mm=tm.mm1
#       END IF
# 
#       LET l_ccc23=0   #MOD-690059 add
#       SELECT ccc23 INTO l_ccc23 FROM ccc_file
#        WHERE ccc01=sr.pia02 AND ccc02=l_yy AND ccc03=l_mm
#        IF cl_null(l_ccc23) THEN LET l_ccc23=0 END IF
#    #------------------------------------------------
#       LET tot1 = GROUP SUM(sr.img10) USING '------------&.&&&' #帳列數量
#       LET tot2 = GROUP SUM(sr.pia30) USING '------------&.&&&' #實盤量　
#       LET tot1_s = tot1_s + tot1
#       LET tot2_s = tot2_s + tot2
#    #-------------------------------------------
#       LET l_a01=l_ccc23*tot1      #帳列金額
#       LET l_a02=l_ccc23*tot2      #實盤金額
#       IF cl_null(tot1) THEN LET tot1=0 END IF
#       IF cl_null(tot2) THEN LET tot2=0 END IF
#       LET l_a03=tot2-tot1         #盤盈虧損
#       LET l_a04=l_a03*l_ccc23     #盤盈虧損金額
#       LET l_a01_s=l_a01_s + l_a01
#       LET l_a02_s=l_a02_s + l_a02
#       #-------------------------------------------
#       #無盤盈虧差異者是否列印
#       IF tm.d='N' AND tot1=tot2 THEN
#       ELSE
#          #No:7597
#          IF tm.b='Y' THEN
#             PRINT COLUMN  g_c[31],sr.pia03  CLIPPED;     #倉
#          END IF
#          IF tm.c='Y' THEN
#             PRINT COLUMN g_c[32],sr.pia04  CLIPPED;     #儲
#          END IF
#          IF tm.c='Y' THEN
#             PRINT COLUMN g_c[33],sr.pia02  CLIPPED;  #料
#          END IF
#          IF tm.w='Y' THEN
#              PRINT COLUMN g_c[34],sr.ima02 CLIPPED,   #MOD-4A0238  #品
#                    COLUMN g_c[35],sr.ima021 CLIPPED;  #MOD-4A0238  #規
#          END IF
#          PRINT COLUMN g_c[36],sr.pia09  CLIPPED,          #單位
#                COLUMN g_c[37],cl_numfor(tot1,37,tm.e),    #帳列數量
#                COLUMN g_c[38],cl_numfor(l_a01,38,g_azi03),#帳列金額
#                COLUMN g_c[39],cl_numfor(tot2,39,tm.e),    #實盤量
#                COLUMN g_c[40],cl_numfor(l_a02,40,g_azi03),#實盤金額
#                COLUMN g_c[41],cl_numfor(l_a03,41,tm.e),             #盤盈虧損
#                COLUMN g_c[42],cl_numfor(l_ccc23,42,6),
#                COLUMN g_c[43],cl_numfor(l_a04,43,g_azi03) #盤盈虧金額
#          LET l_sum = l_sum + l_a04     #MOD-690059 add
#          ##
#         #LET l_totamt=l_totamt+l_a04   #MOD-690059 mark
#      END IF
# 
#   ON LAST ROW
#     #PRINT g_dash  #MOD-690059 mark
#      LET l_last_sw = 'y'
#      PRINT COLUMN g_c[35],g_x[16] CLIPPED,
#            #MOD-690059-begin-add
#            #COLUMN g_c[37],cl_numfor(SUM(tot1_s),37,tm.e),              #帳列數量總計 No:7597
#            #COLUMN g_c[38],cl_numfor(SUM(l_a01_s),38,g_azi03),#帳列金額計
#            #COLUMN g_c[39],cl_numfor(SUM(tot2_s),39,tm.e),              #實盤量計
#            #COLUMN g_c[40],cl_numfor(SUM(l_a02_s),40,g_azi03),#實盤金額計
#            #COLUMN g_c[41],cl_numfor(SUM(sr.pia30-sr.img10),41,tm.e), #No:7597
#            #COLUMN g_c[43],cl_numfor(l_totamt,43,g_azi03)   #No:7597
#            COLUMN g_c[37],cl_numfor(g_tot1_s,37,tm.e),     #帳列數量總計 
#            COLUMN g_c[38],cl_numfor(g_a01_s,38,g_azi03),   #帳列金額計
#            COLUMN g_c[39],cl_numfor(g_tot2_s,39,tm.e),     #實盤量計
#            COLUMN g_c[40],cl_numfor(g_a02_s,40,g_azi03),   #實盤金額計
#            COLUMN g_c[41],cl_numfor(g_totamt,41,tm.e), 
#            COLUMN g_c[43],cl_numfor(g_sum,43,g_azi03) 
#            #MOD-690059-end-add
# 
#      PRINT g_dash
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
# 
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#070404 MOD-720046 By TSD.Jin--end mark
 
#Patch....NO.TQC-610036 <001> #
