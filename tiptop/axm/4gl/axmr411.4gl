# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr411.4gl
# Descriptions...: 接單統計分析表
# Date & Author..: 02/07/30 By Snow
# Modify For DAM.: 02/08/10 By Snow
#                  1.新增以區域作匯總
#                  2.總計欄位放寬
#                  3.新增INPUT條件:區域
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率改DEC(20,10)
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.MOD-530870 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 新增地區欄位
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/11 By will 報表轉XML格式
# Modify.........: No.MOD-580222 05/08/26 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-610020 06/01/17 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-630212 06/03/22 By pengu 3x列印時出現「ins r411_tmp查無此錯誤訊息-11023」
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650095 06/05/26 By Sarah 將兩個QBE合併成一個
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-720035 07/02/09 By claire 期別為11,12月會帶錯日期
# Modify.........: No.FUN-7A0025 07/10/17 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.MOD-810069 08/01/09 By claire 考慮occ22為空白時應該''
# Modify.........: No.MOD-890060 08/09/04 By wujie  r411_1()的時候，第一期漏加了occ22的條件
#                                                   插入臨時表前，occ20，occ21，occ22如果是null，應賦值' '
# Modify.........: No.MOD-8C0243 08/12/24 By Smapmin 轉換查詢條件時超過陣列大小,導致出錯
# Modify.........: No.MOD-920350 09/02/26 By Smapmin 本幣應抓取aza17
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B10108 11/01/14 By Summer occ22為空時給一個空白
# Modify.........: No:MOD-B80020 11/08/03 By johung 在ORACLE資料庫擷取字串內容應用SUBSTR
# Modify.........: No:TQC-C50115 12/05/12 By zhuhao 字段定義類型修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
        #  wc      VARCHAR(300),
          #wc2     VARCHAR(300),   #FUN-650095 mark
           wc      STRING,   #TQC-630166
           s       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           t       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           u       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           yy,mm   LIKE type_file.num5,        # No.FUN-680137 SMALLINT
           a       LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)        #'1'本幣 '2'原幣
           cdate   LIKE type_file.dat,         # No.FUN-680137 DATE                     #匯率日期
           more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)
      END RECORD ,
      g_so,g_date  LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(50)
      g_ys,g_ms,g_ye,g_me,g_m2,g_y2  LIKE type_file.num5,        # No.FUN-680137 SMALLINT
      g_dates,g_datee,g_d1,g_d2,g_d3,g_d4,g_d5,g_d6 LIKE type_file.dat,         # No.FUN-680137 DATE
      ext          LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
      g_curr       LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
     #wc3          VARCHAR(300),   #FUN-650095 mark
#      g_str	   LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(3000)
      g_str        STRING                      #No.FUN-7A0025
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#No.FUN-580013  --begin
#DEFINE   g_dash          VARCHAR(400)  #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
DEFINE    g_sql           STRING     #No.FUN-7A0025
DEFINE    l_table         STRING     #No.FUN-7A0025
 
MAIN
#     DEFINE   l_time    LIKE type_file.chr8       #No.FUN-6A0094
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   #No.FUN-7A0025 --start--
   LET g_sql="occ20.occ_file.occ20,occ21.occ_file.occ21,geb02.geb_file.geb02,",
             "occ22.occ_file.occ22,oea03.oea_file.oea03,",
             "oea032.oea_file.oea032,oeb112.oeb_file.oeb12,",
             "oeb114.oeb_file.oeb14,ogb112.ogb_file.ogb12,",
             "ogb114.ogb_file.ogb14,oeb212.oeb_file.oeb12,",
             "oeb214.oeb_file.oeb14,ogb212.ogb_file.ogb12,",
             "ogb214.ogb_file.ogb14,oeb312.oeb_file.oeb12,",
             "oeb314.oeb_file.oeb14,ogb312.ogb_file.ogb12,",
             "ogb314.ogb_file.ogb14,oeb012.oeb_file.oeb12,",
             "oeb014.oeb_file.oeb14,ogb012.ogb_file.ogb12,",
             "ogb014.ogb_file.ogb14,oea23.oea_file.oea23"
   LET l_table = cl_prt_temptable('axmr411',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql 
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7A0025 --end--
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
  #LET tm.wc2   = ARG_VAL(8)   #FUN-650095 mark
#-----------No.TQC-610089 modify
   LET tm.yy    = ARG_VAL(8)
   LET tm.mm    = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   LET tm.cdate = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------No.TQC-610089 end
 
 
   IF NOT cl_null(tm.wc) THEN
      CALL r411_1()  #本幣
   ELSE
      CALL r411_tm(0,0)
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r411_tm(p_row,p_col)
   DEFINE p_row,p_col,i  LIKE type_file.num5        #No.FUN-680137 SMALLINT
   DEFINE l_cmd          LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(400)
   DEFINE l_wc,l_wc1     LIKE type_file.chr1000  #FUN-650095 add        #No.FUN-680137 VARCHAR(300)
   DEFINE j,k            LIKE type_file.num5     #FUN-650095 add        #No.FUN-680137 SMALLINT
   DEFINE a              LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)     #FUN-650095 add
   DEFINE l_str          LIKE type_file.chr30  #MOD-8C0243
   DEFINE l_begin,l_end  LIKE type_file.num5   #MOD-8C0243
 
   LET p_row = 4 LET p_col = 7
 
   OPEN WINDOW r411_w AT p_row,p_col WITH FORM "axm/42f/axmr411"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy=YEAR(g_today)
   LET tm.mm=MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   #Modify By Snow..020810
   #CONSTRUCT BY NAME tm.wc ON occ20,occ21,oea03,oea25,oeb04,oeb15    #FUN-550091
   CONSTRUCT BY NAME tm.wc ON occ20,occ21,occ22,oea03,oea25,oeb04,oeb15,oea01    #FUN-550091   #FUN-650095 add oea01
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(occ20) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gea"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO occ20
              NEXT FIELD occ20
           END IF
           IF INFIELD(occ21) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_geb"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO occ21
              NEXT FIELD occ21
           END IF
#FUN-550091
           IF INFIELD(occ22) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_geo"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO occ22
              NEXT FIELD occ22
           END IF
#END FUN-550091
           IF INFIELD(oea03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           END IF
           IF INFIELD(oea25) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oab"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea25
              NEXT FIELD oea25
           END IF
           IF INFIELD(oeb04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oeb04
              NEXT FIELD oeb04
           END IF
          #start FUN-650095 add
           IF INFIELD(oea01) THEN
              #CALL q_oay(TRUE,FALSE,'','30',g_sys)  #TQC-670008
              CALL q_oay(TRUE,FALSE,'','30','AXM')   #TQC-670008
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea01
              NEXT FIELD oea01
           END IF
          #end FUN-650095 add
 
        ON ACTION locale
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
  END CONSTRUCT
  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()   #FUN-550037(smin)
     CONTINUE WHILE
  END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   ELSE
      #-----MOD-8C0243---------
      #LET l_wc = tm.wc
      #LET k = length(l_wc) + 13
      LET a = g_doc_len
      #FOR j=1 TO k-4
      #   IF l_wc[j,j+4]='oea01' THEN
      #      LET l_wc1=l_wc[j+5,k]
      #      LET l_wc[j,k]=''
      #      LET l_wc[j,j+16]='SUBSTRING(oea01,1,',a,')'
      #      LET tm.wc=l_wc[1,k] CLIPPED,l_wc1
      #      EXIT FOR
      #   END IF
      #END FOR
#     LET l_str = 'SUBSTRING(oea01,1,',a,')'   #MOD-B80020 mark
      LET l_str = 'SUBSTR(oea01,1,',a,')'      #MOD-B80020
      LET l_begin = tm.wc.getIndexOf('oea01',1)
      LET l_end = l_begin + 4
      IF l_begin > 0 THEN   #MOD-920350
         LET tm.wc =  cl_replace_str_by_index(tm.wc,l_begin,l_end,l_str)
      END IF   #MOD-920350
      #-----END MOD-8C0243-----
   END IF
 
  #start FUN-650095 mark
  #CONSTRUCT BY NAME tm.wc2 ON oea01
  #   ON ACTION locale
  #      LET g_action_choice = "locale"
  #      EXIT CONSTRUCT
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE CONSTRUCT
  #   ON ACTION about         #MOD-4C0121
  #      CALL cl_about()      #MOD-4C0121
  #   ON ACTION help          #MOD-4C0121
  #      CALL cl_show_help()  #MOD-4C0121
  #   ON ACTION controlg      #MOD-4C0121
  #      CALL cl_cmdask()     #MOD-4C0121
  #   ON ACTION exit
  #      LET INT_FLAG = 1
  #      EXIT CONSTRUCT
  #   ON ACTION controlp
  #      CALL q_oay(TRUE,FALSE,'','30',g_sys)
  #           RETURNING g_qryparam.multiret
  #      DISPLAY g_qryparam.multiret TO oea01
  #      NEXT FIELD oea01
  #   AFTER CONSTRUCT
  #      IF tm.wc2 = '1=1' THEN
  #         CALL cl_err('','9046',0) CONTINUE CONSTRUCT
  #      END IF
  #END CONSTRUCT
  #IF g_action_choice = "locale" THEN
  #   LET g_action_choice = ""
  #   CALL cl_dynamic_locale()
  #   CALL cl_show_fld_cont()   #FUN-550037(smin)
  #   CONTINUE WHILE
  #END IF
  #IF tm.wc2[1,5]='oea01' THEN LET wc3=tm.wc2[6,300] CLIPPED END IF
  #end FUN-650095 mark
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
 
   LET tm.a='1'
   LET tm.cdate=g_today
   INPUT BY NAME tm.yy,tm.mm,tm.a,tm.cdate,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD yy
        IF cl_null(tm.yy) OR tm.yy<1911 THEN NEXT FIELD yy END IF
      AFTER FIELD mm
        IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN NEXT FIELD mm END IF
      AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
      AFTER FIELD cdate
        IF cl_null(tm.cdate) THEN NEXT FIELD cdate END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmr411'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr411','9031',1)   
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
                        #" '",tm.wc2 CLIPPED,"'",   #FUN-650095 mark
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",                 #No.TQC-610089 add
                         " '",tm.cdate CLIPPED,"'",             #No.TQC-610089 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr411',g_time,l_cmd)
      END IF
      CLOSE WINDOW r411_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   IF tm.a='1' THEN
      CALL r411_1()   #本幣(NTD)
   ELSE
      CALL r411_2()   #原幣
   END IF
   ERROR ""
END WHILE
   CLOSE WINDOW r411_w
END FUNCTION
 
#本幣
FUNCTION r411_1()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0094
#DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(600)  #TQC-C50115 mark
DEFINE l_sql     STRING       #TQC-C50115 add
DEFINE l_za05    LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
DEFINE sr        RECORD
                        occ20  LIKE occ_file.occ20,  #區域 #Add By Snow..020810
                        occ21  LIKE occ_file.occ21,      #國別
                        occ22  LIKE occ_file.occ22,      #地區   #FUN-550091
                        geb02  LIKE geb_file.geb02,      #國別名
                        oea01  LIKE oea_file.oea01,      #訂單
                        oea02  LIKE oea_file.oea02,      #訂單日
                        oea03  LIKE oea_file.oea03,      #客戶編號
                        oea032 LIKE oea_file.oea032,	 #客戶簡稱
                        oea08  LIKE oea_file.oea08,      #內外銷
                        oea23  LIKE oea_file.oea23,      #幣別
                        oea24  LIKE oea_file.oea24,      #匯率
                        oeb03  LIKE oeb_file.oeb03,      #訂單項次
                        oeb04  LIKE oeb_file.oeb04,
                        oeb12  LIKE oeb_file.oeb12,
                        oeb14  LIKE oeb_file.oeb14,
                        oeb15  LIKE oeb_file.oeb15,
                        ogb12  LIKE ogb_file.ogb12,
                        ogb14  LIKE ogb_file.ogb14
                END RECORD,
       sr1       RECORD
                        occ20 LIKE occ_file.occ20,   #區域 #Add By Snow..020810
                        occ21 LIKE occ_file.occ21,      #國別
                        occ22 LIKE occ_file.occ22,      #地區   #FUN-550091
                        geb02 LIKE geb_file.geb02,      #國別名
                        oea03 LIKE oea_file.oea03,      #客戶編號
                        oea032 LIKE oea_file.oea032     #客戶簡稱
                 END RECORD,
       sr2       RECORD
                        oeb112 LIKE oeb_file.oeb12,     #第一期
                        oeb114 LIKE oeb_file.oeb14,
                        ogb112 LIKE ogb_file.ogb12,
                        ogb114 LIKE ogb_file.ogb14,
                        oeb212 LIKE oeb_file.oeb12,     #第二期
                        oeb214 LIKE oeb_file.oeb14,
                        ogb212 LIKE ogb_file.ogb12,
                        ogb214 LIKE ogb_file.ogb14,
                        oeb312 LIKE oeb_file.oeb12,     #第三期
                        oeb314 LIKE oeb_file.oeb14,
                        ogb312 LIKE ogb_file.ogb12,
                        ogb314 LIKE ogb_file.ogb14,
                        oeb012 LIKE oeb_file.oeb12,     #總計
                        oeb014 LIKE oeb_file.oeb14,
                        ogb012 LIKE ogb_file.ogb12,
                        ogb014 LIKE ogb_file.ogb14
                 END RECORD
     CALL cl_del_data(l_table)                          #No.FUN-7A0025
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr411'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580013  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
 
#    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05    #No.CHI-6A0004
#      FROM azi_file WHERE azi01=g_aza.aza17                  #No.CHI-6A0004 
 
     #No.FUN-7A0025 --mark-- 在CR中處理
#     #組幣別
#     IF tm.a='1' THEN
#        LET g_curr='(本幣',tm.cdate,')' CLIPPED
#     ELSE
#        LET g_curr='(原幣)'
#     END IF
     #No.FUN-7A0025 --end--
 
     #取三期
     LET g_ys=tm.yy  LET g_ms=tm.mm
     IF tm.mm=11 OR tm.mm=12 THEN
        LET g_ye=tm.yy+1
       #MOD-720035-begin-add
       #IF tm.mm=11 THEN LET g_me=1 LET g_m2=2 END IF
       #IF tm.mm=12 THEN LET g_me=2 LET g_m2=3 END IF
        IF tm.mm=11 THEN
           LET g_y2=tm.yy
           LET g_m2=12
           LET g_me=1
        ELSE
           LET g_y2=tm.yy+1
           LET g_m2=1
           LET g_me=2
        END IF
       #MOD-720035-end-add
     ELSE
        LET g_y2=tm.yy LET g_ye=tm.yy
        LET g_me=tm.mm+2 LET g_m2=tm.mm+1
     END IF
 
     #取截止期別當月起迄(第三期)
     CALL s_azn01(g_ye,g_me) RETURNING g_d5,g_d6
     #取起始期別當月第一天(第一期)
     CALL s_azn01(g_ys,g_ms) RETURNING g_d1,g_d2
     #取第二期
     CALL s_azn01(g_y2,g_m2) RETURNING g_d3,g_d4
 
     #組預交日
     LET g_date=''
     LET g_date=g_d1 USING 'yyyy/mm',' ',
                g_d3 USING 'yyyy/mm',' ',
                g_d5 USING 'yyyy/mm' CLIPPED
 
     CALL r411_cretmp()
 
     #Modify By Snow..020810
     #LET l_sql = "SELECT occ21,geb02,oea01,oea02,oea03,oea032,oea08,",
     #LET l_sql = "SELECT occ20,occ21,geb02,oea01,oea02,oea03,oea032,oea08,",   #FUN-550091
     LET l_sql = "SELECT occ20,occ21,occ22,geb02,oea01,oea02,oea03,oea032,oea08,",   #FUN-550091
                 "       oea23,oea24,",
                 "       oeb03,oeb04,oeb12,oeb14,oeb15,'',''",
                 " FROM oea_file,oeb_file,occ_file, OUTER geb_file",
                 " WHERE oea03 = occ01 AND oea01=oeb01 AND oeaconf='Y' ",
		 "   AND geb_file.geb01 = occ_file.occ21",
                 "   AND ",tm.wc CLIPPED,
#No.FUN-550070--begin
#                "   AND SUBSTR(oea01,1,3) ",wc3 CLIPPED,
                #"   AND oea01 ",wc3 CLIPPED,   #FUN-650095 mark
#No.FUN-550070--end
                 "   AND (oeb15 BETWEEN '", g_d1, "' AND '", g_d6, "')" CLIPPED
 
     PREPARE r411_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE r411_curs1 CURSOR FOR r411_prepare1
     FOREACH r411_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       IF tm.a='1' THEN  #本幣
          #取訂單日匯率
          IF sr.oea08='1' THEN #內銷
             LET ext=g_oaz.oaz52
          ELSE                 #外銷
             LET ext=g_oaz.oaz70
          END IF
          CALL s_curr3(sr.oea23,tm.cdate,ext) RETURNING sr.oea24
          LET sr.oeb14=sr.oeb14*sr.oea24  #本幣
       END IF
 
       #sum出貨
       SELECT SUM(ogb12),SUM(ogb14) INTO sr.ogb12,sr.ogb14
         FROM oga_file,ogb_file
        WHERE oga01=ogb01 AND ogb31=sr.oea01 AND ogb32=sr.oeb03
          AND ogaconf='Y' AND ogapost='Y'
          AND (oga09='2' OR oga09='4' OR oga09='6' OR oga09='8') #No.8347 #No.FUN-610020
                         AND oga65='N'     #No.FUN-610020
 
       IF tm.a='1' THEN #本幣
          LET sr.ogb14=sr.ogb14*sr.oea24  #本幣
       END IF
 
#No.MOD-890060 --begin
       #MOD-810069-begin-add
#       IF cl_null(sr.occ20) THEN LET sr.occ20='' END IF
#       IF cl_null(sr.occ21) THEN LET sr.occ21='' END IF
#       IF cl_null(sr.occ22) THEN LET sr.occ22='' END IF
       #MOD-810069-end-add
        IF cl_null(sr.occ20) THEN LET sr.occ20=' ' END IF
        IF cl_null(sr.occ21) THEN LET sr.occ21=' ' END IF
        IF cl_null(sr.occ22) THEN LET sr.occ22=' ' END IF
#No.MOD-890060 --end
       INSERT INTO r411_tmp VALUES(sr.*)
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('ins r411_tmp',SQLCA.SQLCODE,1)   #No.FUN-660167
          CALL cl_err3("ins","r411_tmp","","",SQLCA.SQLCODE,"","ins r411_tmp",1)   #No.FUN-660167
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
          EXIT PROGRAM
       END IF
     END FOREACH
 
     #No.FUN-7A0025 --mark--
#     CALL cl_outnam('axmr411') RETURNING l_name
##No.FUN-580013  -begin
#     LET g_zaa[36].zaa08 = g_zaa[36].zaa08,'(',g_d1,')'
#     LET g_zaa[40].zaa08 = g_zaa[40].zaa08,'(',g_d3,')'
#     LET g_zaa[44].zaa08 = g_zaa[44].zaa08,'(',g_d5,')'
#     LET g_zaa[48].zaa08 = g_zaa[48].zaa08,'(',g_x[20],')'
##No.FUN-580013  -end
#     START REPORT r411_rep1 TO l_name
#     LET g_pageno = 0
     #No.FUN-7A0025 --end--
 
     #區域,國別,客戶,幣別
     #Modify By Snow..020810
     #LET l_sql = "SELECT DISTINCT occ21,geb02,oea03,oea032",
     #LET l_sql = "SELECT DISTINCT occ20,occ21,geb02,oea03,oea032",   #FUN-550091
     LET l_sql = "SELECT DISTINCT occ20,occ21,occ22,geb02,oea03,oea032",   #FUN-550091
                 #"  FROM r411_tmp ORDER BY occ21,oea03" CLIPPED
                 #"  FROM r411_tmp ORDER BY occ20,occ21,oea03" CLIPPED   #FUN-550091
                 "  FROM r411_tmp ORDER BY occ20,occ21,occ22,oea03" CLIPPED   #FUN-550091
     PREPARE r411_p1pre FROM l_sql
     DECLARE r411_cur1 CURSOR FOR r411_p1pre
     #Modify By Snow..020810
     #FOREACH r411_cur1 INTO sr1.occ21,sr1.geb02,sr1.oea03,sr1.oea032
     #FOREACH r411_cur1 INTO sr1.occ20,sr1.occ21,sr1.geb02,sr1.oea03,sr1.oea032   #FUN-550091
     FOREACH r411_cur1 INTO sr1.occ20,sr1.occ21,sr1.occ22,sr1.geb02,sr1.oea03,sr1.oea032   #FUN-550091
       #第一期
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb112,sr2.oeb114,sr2.ogb112,sr2.ogb114
         FROM r411_tmp
#       WHERE occ21=sr1.occ21 AND oea03=sr1.oea03
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03   #No.MOD-890060
          AND (oeb15 BETWEEN g_d1 AND g_d2)
          AND occ20=sr1.occ20  #Add By Snow..020810
 
       #第二期
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb212,sr2.oeb214,sr2.ogb212,sr2.ogb214
         FROM r411_tmp
        #WHERE occ21=sr1.occ21 AND oea03=sr1.oea03    #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03   #FUN-550091
          AND (oeb15 BETWEEN g_d3 AND g_d4)
          AND occ20=sr1.occ20  #Add By Snow..020810
 
       #第三期
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb312,sr2.oeb314,sr2.ogb312,sr2.ogb314
         FROM r411_tmp
        #WHERE occ21=sr1.occ21 AND oea03=sr1.oea03   #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03  #FUN-550091
          AND (oeb15 BETWEEN g_d5 AND g_d6)
          AND occ20=sr1.occ20  #Add By Snow..020810
 
       #總計
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb012,sr2.oeb014,sr2.ogb012,sr2.ogb014
         FROM r411_tmp
        #WHERE occ21=sr1.occ21 AND oea03=sr1.oea03   #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03  #FUN-550091
          AND occ20=sr1.occ20  #Add By Snow..020810
 
#       OUTPUT TO REPORT r411_rep1(sr1.*,sr2.*)      #No.FUN-7A0025
       #No.FUN-7A0025 --start--
       EXECUTE insert_prep USING sr1.occ20,sr1.occ21,sr1.geb02,sr1.occ22,sr1.oea03,
                                 sr1.oea032,sr2.oeb112,sr2.oeb114,sr2.ogb112,
                                 sr2.ogb114,sr2.oeb212,sr2.oeb214,sr2.ogb212,
                                 sr2.ogb214,sr2.oeb312,sr2.oeb314,sr2.ogb312,
                                 sr2.ogb314,sr2.oeb012,sr2.oeb014,sr2.ogb012,
                                 sr2.ogb014,sr.oea23
       #No.FUN-7A0025 --end--
     END FOREACH
 
#     FINISH REPORT r411_rep1                      #No.FUN-7A0025
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-7A0025
     #No.FUN-7A0025 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'occ20,occ21,occ22,oea03,oea25,oeb04,oeb15,oea01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.cdate,";",g_so,";",g_date,";",tm.a,";",
                 g_d1,";",g_d3,";",g_d5,";",g_azi04,";",g_aza.aza17   #MOD-920350 add aza17
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('axmr411','axmr411',l_sql,g_str)
     #No.FUN-7A0025 --end--
END FUNCTION
#No.FUN-7A0025 --start-- mark
{REPORT r411_rep1(sr)
DEFINE l_last_sw   LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)
DEFINE sr           RECORD
                        occ20 LIKE occ_file.occ20, #區域  #Add By Snow..020810
                        occ21 LIKE occ_file.occ21,      #國別
                        occ22 LIKE occ_file.occ22,      #地區   #FUN-550091
                        geb02 LIKE geb_file.geb02,      #國別名
                        oea03 LIKE oea_file.oea03,      #客戶編號
                        oea032 LIKE oea_file.oea032,	#客戶簡稱
                        oeb112 LIKE oeb_file.oeb12,     #第一期
                        oeb114 LIKE oeb_file.oeb14,
                        ogb112 LIKE ogb_file.ogb12,
                        ogb114 LIKE ogb_file.ogb14,
                        oeb212 LIKE oeb_file.oeb12,     #第二期
                        oeb214 LIKE oeb_file.oeb14,
                        ogb212 LIKE ogb_file.ogb12,
                        ogb214 LIKE ogb_file.ogb14,
                        oeb312 LIKE oeb_file.oeb12,     #第三期
                        oeb314 LIKE oeb_file.oeb14,
                        ogb312 LIKE ogb_file.ogb12,
                        ogb314 LIKE ogb_file.ogb14,
                        oeb012 LIKE oeb_file.oeb12,     #總計
                        oeb014 LIKE oeb_file.oeb14,
                        ogb012 LIKE ogb_file.ogb12,
                        ogb014 LIKE ogb_file.ogb14
                 END RECORD,
		l_rowno  LIKE type_file.num5,        # No.FUN-680137 SMALLINT
		l_amt_11,l_amt_13,l_amt_21,l_amt_23   LIKE oeb_file.oeb12,
                l_amt_31,l_amt_33,l_amt_01,l_amt_03   LIKE oeb_file.oeb12,
		l_amt_12,l_amt_14,l_amt_22,l_amt_24   LIKE oeb_file.oeb14,
                l_amt_32,l_amt_34,l_amt_02,l_amt_04   LIKE oeb_file.oeb14
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  #Modify By Snow..020810
  #ORDER BY sr.occ21,sr.oea03
  #ORDER BY sr.occ20,sr.occ21,sr.oea03   #FUN-550091
  ORDER BY sr.occ20,sr.occ21,sr.occ22,sr.oea03   #FUN-550091
  FORMAT
   PAGE HEADER
#No.FUN-580013  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[21] CLIPPED,g_so CLIPPED,      #訂單別
            COLUMN 31,g_x[22] CLIPPED,g_date CLIPPED,   #預交日
            COLUMN 71,g_curr CLIPPED
      PRINT g_dash
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 71,g_x[21] CLIPPED,g_so CLIPPED,      #訂單別
#           COLUMN 159,g_x[22] CLIPPED,g_date CLIPPED,   #預交日
#                  COLUMN 211,g_curr CLIPPED,
#                  COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
 
#     PRINT COLUMN 098,g_d1 USING 'yyyy/mm',  #第一期
#           COLUMN 172,g_d3 USING 'yyyy/mm',  #第二期
#           COLUMN 246,g_d5 USING 'yyyy/mm',  #第三期
#           COLUMN 320,g_x[20] CLIPPED        #合計
#     PRINT COLUMN 001,g_x[11] CLIPPED,
#           COLUMN 061,g_x[27] CLIPPED,COLUMN 098,g_x[12] CLIPPED,
#           COLUMN 135,g_x[13] CLIPPED,COLUMN 172,g_x[12] CLIPPED,
#           COLUMN 209,g_x[13] CLIPPED,COLUMN 246,g_x[12] CLIPPED,
#           COLUMN 283,g_x[13] CLIPPED,COLUMN 320,g_x[12] CLIPPED,
#           COLUMN 357,g_x[13] CLIPPED
#     PRINT COLUMN 001,g_x[14],g_x[15] CLIPPED,
#           COLUMN 061,g_x[16] CLIPPED,COLUMN 098,g_x[16] CLIPPED,
#           COLUMN 135,g_x[16] CLIPPED,COLUMN 172,g_x[16] CLIPPED,
#           COLUMN 209,g_x[16] CLIPPED,COLUMN 246,g_x[16] CLIPPED,
#           COLUMN 283,g_x[16] CLIPPED,COLUMN 320,g_x[16] CLIPPED,
#           COLUMN 357,g_x[16] CLIPPED
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
            g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
      PRINT g_dash1
#No.FUN-580013  -end
      LET l_last_sw = 'n'
 
   #Modify By Snow..020810
   #BEFORE GROUP OF sr.occ21  #國別
   BEFORE GROUP OF sr.occ20  #區域
#No.FUN-580013  -begin
#    PRINT COLUMN 001,sr.occ20 CLIPPED,  #區域
#          COLUMN 006,sr.occ21 CLIPPED,  #國別
#          COLUMN 011,sr.geb02 CLIPPED,  #國別名
#          COLUMN 032,sr.occ22 CLIPPED;  #地區
     LET sr.geb02 = '  ',sr.geb02
     PRINT COLUMN g_c[31],sr.occ20 CLIPPED,  #區域
           COLUMN g_c[32],sr.occ21 CLIPPED,sr.geb02 CLIPPED,  #國別
           COLUMN g_c[33],sr.occ22 CLIPPED;  #地區
#No.FUN-580013  -end
 
   ON EVERY ROW
#No.FUN-580013  -begin
      PRINT COLUMN g_c[34],sr.oea03 CLIPPED,  #客戶代號
            COLUMN g_c[35],sr.oea032 CLIPPED, #客戶簡稱
            COLUMN g_c[36],cl_numfor(sr.oeb112,36,g_azi04), #第一期訂單量
            COLUMN g_c[37],cl_numfor(sr.oeb114,37,g_azi04), #第一期訂單金額
            COLUMN g_c[38],cl_numfor(sr.ogb112,38,g_azi04),#第一期已交量
            COLUMN g_c[39],cl_numfor(sr.ogb114,39,g_azi04), #第一期已交金額
            COLUMN g_c[40],cl_numfor(sr.oeb212,40,g_azi04),#第二期訂單量
            COLUMN g_c[41],cl_numfor(sr.oeb214,41,g_azi04), #第二期訂單金額
            COLUMN g_c[42],cl_numfor(sr.ogb212,42,g_azi04),#第二期已交量
            COLUMN g_c[43],cl_numfor(sr.ogb214,43,g_azi04), #第二期已交金額
            COLUMN g_c[44],cl_numfor(sr.oeb312,44,g_azi04),#第三期訂單量
            COLUMN g_c[45],cl_numfor(sr.oeb314,45,g_azi04), #第三期訂單金額
            COLUMN g_c[46],cl_numfor(sr.ogb312,46,g_azi04),#第三期已交量
            COLUMN g_c[47],cl_numfor(sr.ogb314,47,g_azi04), #第三期已交金額
            COLUMN g_c[48],cl_numfor(sr.oeb012,48,g_azi04),#總計訂單量
            COLUMN g_c[49],cl_numfor(sr.oeb014,49,g_azi04), #總計訂單金額
            COLUMN g_c[50],cl_numfor(sr.ogb012,50,g_azi04),#總計已交量
            COLUMN g_c[51],cl_numfor(sr.ogb014,51,g_azi04) #總計已交金額
#No.FUN-580013  -end
		
   #AFTER GROUP OF sr.occ21 #國別
   AFTER GROUP OF sr.occ22 #地區
     LET l_amt_11 = GROUP SUM(sr.oeb112) LET l_amt_12 = GROUP SUM(sr.oeb114)
     LET l_amt_13 = GROUP SUM(sr.ogb112) LET l_amt_14 = GROUP SUM(sr.ogb114)
     LET l_amt_21 = GROUP SUM(sr.oeb212) LET l_amt_22 = GROUP SUM(sr.oeb214)
     LET l_amt_23 = GROUP SUM(sr.ogb212) LET l_amt_24 = GROUP SUM(sr.ogb214)
     LET l_amt_31 = GROUP SUM(sr.oeb312) LET l_amt_32 = GROUP SUM(sr.oeb314)
     LET l_amt_33 = GROUP SUM(sr.ogb312) LET l_amt_34 = GROUP SUM(sr.ogb314)
     LET l_amt_01 = GROUP SUM(sr.oeb012) LET l_amt_02 = GROUP SUM(sr.oeb014)
     LET l_amt_03 = GROUP SUM(sr.ogb012) LET l_amt_04 = GROUP SUM(sr.ogb014)
#No.FUN-580013  -begin
     PRINT COLUMN g_c[33],g_x[18] CLIPPED,'NTD',  #小計
#          COLUMN ,'NTD',            #原幣
           COLUMN g_c[36],cl_numfor(l_amt_11,36,g_azi04),#第一期訂單量
           COLUMN g_c[37],cl_numfor(l_amt_12,37,g_azi04), #第一期訂單金額
           COLUMN g_c[38],cl_numfor(l_amt_13,38,g_azi04),#第一期已交量
           COLUMN g_c[39],cl_numfor(l_amt_14,39,g_azi04), #第一期已交金額
           COLUMN g_c[40],cl_numfor(l_amt_21,40,g_azi04),#第二期訂單量
           COLUMN g_c[41],cl_numfor(l_amt_22,41,g_azi04), #第二期訂單金額
           COLUMN g_c[42],cl_numfor(l_amt_23,42,g_azi04),#第二期已交量
           COLUMN g_c[43],cl_numfor(l_amt_24,43,g_azi04), #第二期已交金額
           COLUMN g_c[44],cl_numfor(l_amt_31,44,g_azi04),#第三期訂單量
           COLUMN g_c[45],cl_numfor(l_amt_32,45,g_azi04), #第三期訂單金額
           COLUMN g_c[46],cl_numfor(l_amt_33,46,g_azi04),#第三期已交量
           COLUMN g_c[47],cl_numfor(l_amt_34,47,g_azi04), #第三期已交金額
           COLUMN g_c[48],cl_numfor(l_amt_01,48,g_azi04),#總計訂單量
           COLUMN g_c[49],cl_numfor(l_amt_02,49,g_azi04), #總計訂單金額
           COLUMN g_c[50],cl_numfor(l_amt_03,50,g_azi04),#總計已交量
           COLUMN g_c[51],cl_numfor(l_amt_04,51,g_azi04) #總計已交金額
#No.FUN-580013  -end
      PRINT ''
 
   ON LAST ROW
     PRINT ''
     LET l_amt_11 = GROUP SUM(sr.oeb112) LET l_amt_12 = GROUP SUM(sr.oeb114)
     LET l_amt_13 = GROUP SUM(sr.ogb112) LET l_amt_14 = GROUP SUM(sr.ogb114)
     LET l_amt_21 = GROUP SUM(sr.oeb212) LET l_amt_22 = GROUP SUM(sr.oeb214)
     LET l_amt_23 = GROUP SUM(sr.ogb212) LET l_amt_24 = GROUP SUM(sr.ogb214)
     LET l_amt_31 = GROUP SUM(sr.oeb312) LET l_amt_32 = GROUP SUM(sr.oeb314)
     LET l_amt_33 = GROUP SUM(sr.ogb312) LET l_amt_34 = GROUP SUM(sr.ogb314)
     LET l_amt_01 = GROUP SUM(sr.oeb012) LET l_amt_02 = GROUP SUM(sr.oeb014)
     LET l_amt_03 = GROUP SUM(sr.ogb012) LET l_amt_04 = GROUP SUM(sr.ogb014)
#No.FUN-580013  -begin
     PRINT COLUMN g_c[33],g_x[19] CLIPPED,  #總計
           COLUMN g_c[36],cl_numfor(l_amt_11,36,g_azi04),#第一期訂單量
           COLUMN g_c[37],cl_numfor(l_amt_12,37,g_azi04), #第一期訂單金額
           COLUMN g_c[38],cl_numfor(l_amt_13,38,g_azi04),#第一期已交量
           COLUMN g_c[39],cl_numfor(l_amt_14,39,g_azi04), #第一期已交金額
           COLUMN g_c[40],cl_numfor(l_amt_21,40,g_azi04),#第二期訂單量
           COLUMN g_c[41],cl_numfor(l_amt_22,41,g_azi04), #第二期訂單金額
           COLUMN g_c[42],cl_numfor(l_amt_23,42,g_azi04),#第二期已交量
           COLUMN g_c[43],cl_numfor(l_amt_24,43,g_azi04), #第二期已交金額
           COLUMN g_c[44],cl_numfor(l_amt_31,44,g_azi04),#第三期訂單量
           COLUMN g_c[45],cl_numfor(l_amt_32,45,g_azi04), #第三期訂單金額
           COLUMN g_c[46],cl_numfor(l_amt_33,46,g_azi04),#第三期已交量
           COLUMN g_c[47],cl_numfor(l_amt_34,47,g_azi04), #第三期已交金額
           COLUMN g_c[48],cl_numfor(l_amt_01,48,g_azi04),#總計訂單量
           COLUMN g_c[49],cl_numfor(l_amt_02,49,g_azi04), #總計訂單金額
           COLUMN g_c[50],cl_numfor(l_amt_03,50,g_azi04),#總計已交量
           COLUMN g_c[51],cl_numfor(l_amt_04,51,g_azi04) #總計已交金額
#No.FUN-580013  -end
 
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
  #           IF tm.wc[001,070] > ' ' THEN            # for 80
  #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
  #           IF tm.wc[071,140] > ' ' THEN
  #       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
  #           IF tm.wc[141,210] > ' ' THEN
  #       PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
  #           IF tm.wc[211,280] > ' ' THEN
  #       PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	 #TQC-630166
	 CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw='y'
 
      PRINT g_x[23] CLIPPED,
            COLUMN (g_len-9),g_x[7] CLIPPED  #結束
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[23] CLIPPED,
               COLUMN (g_len-9), g_x[6] CLIPPED  #接下頁
      ELSE
## FUN-550127
         SKIP 2 LINE
       #  LET l_last_sw = 'y' #簽核
       #  PRINT g_x[4],g_x[5] CLIPPED
      END IF
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[4]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[4]
             PRINT g_memo
      END IF
## END FUN-550127
 
END REPORT}
#No.FUN-7A0025 --end--
 
FUNCTION r411_cretmp()
  DROP TABLE r411_tmp
# No.FUN-680137 --start--
  CREATE TEMP TABLE r411_tmp(
    occ20 LIKE occ_file.occ20,
    occ21 LIKE occ_file.occ21,
    occ22 LIKE occ_file.occ22,
    geb02 LIKE geb_file.geb02,
    oea01 LIKE oea_file.oea01,
    oea02 LIKE oea_file.oea02,
    oea03 LIKE oea_file.oea03,
    oea032 LIKE oea_file.oea032,
    oea08  LIKE oea_file.oea08,
    oea23 LIKE oea_file.oea23,
    oea24 LIKE oea_file.oea24,
    oeb03 LIKE oeb_file.oeb03,
    oeb04 LIKE oeb_file.oeb04,
    oeb12 LIKE oeb_file.oeb12,
    oeb14 LIKE oeb_file.oeb14,
    oeb15 LIKE oeb_file.oeb15,
    ogb12 LIKE ogb_file.ogb12,
    ogb14 LIKE ogb_file.ogb14)      
 
# No.FUN-680137 ---end---   
 
  IF SQLCA.SQLCODE THEN
     CALL cl_err('cretmp',SQLCA.SQLCODE,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM
        
  END IF
END FUNCTION
 
########################################################################
FUNCTION r411_2()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name         #No.FUN-680137 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0094
#DEFINE l_sql     LIKE type_file.chr1000        # RDSQL STATEMENT                  #No.FUN-680137 VARCHAR(600)  #TQC-C50115 mark
DEFINE l_sql     STRING                         #TQC-C50115 add
DEFINE l_za05    LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
DEFINE sr        RECORD
                        occ20  LIKE occ_file.occ20,  #區域 #Add By Snow..020810
                        occ21  LIKE occ_file.occ21,      #國別
                        occ22  LIKE occ_file.occ22,      #地區   #FUN-550091
                        geb02  LIKE geb_file.geb02,      #國別名
                        oea01  LIKE oea_file.oea01,      #訂單
                        oea02  LIKE oea_file.oea02,      #訂單日
                        oea03  LIKE oea_file.oea03,      #客戶編號
                        oea032 LIKE oea_file.oea032,	 #客戶簡稱
                        oea08  LIKE oea_file.oea08,      #內外銷
                        oea23  LIKE oea_file.oea23,      #幣別
                        oea24  LIKE oea_file.oea24,      #匯率
                        oeb03  LIKE oeb_file.oeb03,      #訂單項次
                        oeb04  LIKE oeb_file.oeb04,
                        oeb12  LIKE oeb_file.oeb12,
                        oeb14  LIKE oeb_file.oeb14,
                        oeb15  LIKE oeb_file.oeb15,
                        ogb12  LIKE ogb_file.ogb12,
                        ogb14  LIKE ogb_file.ogb14
                END RECORD,
       sr1       RECORD
                        occ20 LIKE occ_file.occ20, #區域 #Add By Snow..020810
                        occ21 LIKE occ_file.occ21,      #國別
                        occ22 LIKE occ_file.occ22,      #地區   #FUN-550091
                        geb02 LIKE geb_file.geb02,      #國別名
                        oea03 LIKE oea_file.oea03,      #客戶編號
                        oea032 LIKE oea_file.oea032,	#客戶簡稱
                        oea23  LIKE oea_file.oea23      #幣別
                 END RECORD,
       sr2       RECORD
                        oeb112 LIKE oeb_file.oeb12,     #第一期
                        oeb114 LIKE oeb_file.oeb14,
                        ogb112 LIKE ogb_file.ogb12,
                        ogb114 LIKE ogb_file.ogb14,
                        oeb212 LIKE oeb_file.oeb12,     #第二期
                        oeb214 LIKE oeb_file.oeb14,
                        ogb212 LIKE ogb_file.ogb12,
                        ogb214 LIKE ogb_file.ogb14,
                        oeb312 LIKE oeb_file.oeb12,     #第三期
                        oeb314 LIKE oeb_file.oeb14,
                        ogb312 LIKE ogb_file.ogb12,
                        ogb314 LIKE ogb_file.ogb14,
                        oeb012 LIKE oeb_file.oeb12,     #總計
                        oeb014 LIKE oeb_file.oeb14,
                        ogb012 LIKE ogb_file.ogb12,
                        ogb014 LIKE ogb_file.ogb14
                 END RECORD
     CALL cl_del_data(l_table)                          #No.FUN-7A0025
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr411'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580013  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     #End:FUN-980030
 
 
   #  SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05    #No.CHI-6A0004
   #   FROM azi_file WHERE azi01=g_aza.aza17                   #No.CHI-6A0004 
 
    #No.FUN-7A0025 --mark-- 由CR處理 
#    #組幣別
#     IF tm.a='1' THEN
#        LET g_curr='(本幣',tm.cdate,')'  CLIPPED
#     ELSE
#        LET g_curr='(原幣)'
#     END IF
     #No.FUN-7A0025 --end--
 
     #取三期
     LET g_ys=tm.yy  LET g_ms=tm.mm
     IF tm.mm=11 OR tm.mm=12 THEN
        LET g_ye=tm.yy+1
       #MOD-720035-begin-add
       #IF tm.mm=11 THEN LET g_me=1 LET g_m2=2 END IF
       #IF tm.mm=12 THEN LET g_me=2 LET g_m2=3 END IF
        IF tm.mm=11 THEN
           LET g_y2=tm.yy
           LET g_m2=12
           LET g_me=1
        ELSE
           LET g_y2=tm.yy+1
           LET g_m2=1
           LET g_me=2
        END IF
       #MOD-720035-end-add
     ELSE
        LET g_y2=tm.yy LET g_ye=tm.yy
        LET g_me=tm.mm+2 LET g_m2=tm.mm+1
     END IF
 
     #取截止期別當月起迄(第三期)
     CALL s_azn01(g_ye,g_me) RETURNING g_d5,g_d6
     #取起始期別當月第一天(第一期)
     CALL s_azn01(g_ys,g_ms) RETURNING g_d1,g_d2
     #取第二期
     CALL s_azn01(g_y2,g_m2) RETURNING g_d3,g_d4
 
     #組預交日
     LET g_date=''
     LET g_date=g_d1 USING 'yyyy/mm',' ',
                g_d3 USING 'yyyy/mm',' ',
                g_d5 USING 'yyyy/mm' CLIPPED
 
     CALL r411_cretmp()
 
     #Modify By Snow..020810
     #LET l_sql = "SELECT occ21,geb02,oea01,oea02,oea03,oea032,oea08,",
     #LET l_sql = "SELECT occ20,occ21,geb02,oea01,oea02,oea03,oea032,oea08,",   #FUN-550091
     LET l_sql = "SELECT occ20,occ21,occ22,geb02,oea01,oea02,oea03,oea032,oea08,",   #FUN-550091
                 "       oea23,oea24,",
                 "       oeb03,oeb04,oeb12,oeb14,oeb15,'',''",
                 " FROM oea_file,oeb_file,occ_file, OUTER geb_file",
                 " WHERE oea03 = occ01 AND oea01=oeb01 AND oeaconf='Y' ",
		 "   AND geb_file.geb01 = occ_file.occ21",
                 "   AND ",tm.wc CLIPPED,
                 #"   AND SUBSTR(oea01,1,3) ",tm.wc2 CLIPPED,
#No.FUN-550070--begin
#                "   AND SUBSTR(oea01,1,3) ",wc3 CLIPPED,
                #"   AND oea01 ",wc3 CLIPPED,   #FUN-650095 mark
#No.FUN-550070--end
                 "   AND (oeb15 BETWEEN '",g_d1,"' AND '",g_d6,"')"
                 CLIPPED
 
     PREPARE r411_prepare12 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE r411_curs12 CURSOR FOR r411_prepare12
     FOREACH r411_curs12 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach2:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       IF tm.a='1' THEN  #本幣
          #取訂單日匯率
          IF sr.oea08='1' THEN #內銷
             LET ext=g_oaz.oaz52
          ELSE                 #外銷
             LET ext=g_oaz.oaz70
          END IF
          CALL s_curr3(sr.oea23,tm.cdate,ext) RETURNING sr.oea24
          LET sr.oeb14=sr.oeb14*sr.oea24  #本幣
       END IF
 
       #sum出貨
       SELECT SUM(ogb12),SUM(ogb14) INTO sr.ogb12,sr.ogb14
         FROM oga_file,ogb_file
        WHERE oga01=ogb01 AND ogb31=sr.oea01 AND ogb32=sr.oeb03
          AND ogaconf='Y' AND ogapost='Y' AND (oga09='2' OR oga09='8') #一般工單 #No.FUN-610020
                         AND oga65='N'     #No.FUN-610020
 
       IF tm.a='1' THEN #本幣
          LET sr.ogb14=sr.ogb14*sr.oea24  #本幣
       END IF
#No.MOD-890060 --begin
       #MOD-810069-begin-add
#       IF cl_null(sr.occ20) THEN LET sr.occ20='' END IF
#       IF cl_null(sr.occ21) THEN LET sr.occ21='' END IF
#       IF cl_null(sr.occ22) THEN LET sr.occ22='' END IF
       #MOD-810069-end-add
       #MOD-B10108 mod ''->' ' --start--
        IF cl_null(sr.occ20) THEN LET sr.occ20=' ' END IF
        IF cl_null(sr.occ21) THEN LET sr.occ21=' ' END IF
        IF cl_null(sr.occ22) THEN LET sr.occ22=' ' END IF
       #MOD-B10108 mod ''->' ' --end--
#No.MOD-890060 --end
       INSERT INTO r411_tmp VALUES(sr.*)
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('ins r411_tmp2',SQLCA.SQLCODE,1)   #No.FUN-660167
          CALL cl_err3("ins","r411_tmp","","",SQLCA.SQLCODE,"","ins r411_tmp2",1)   #No.FUN-660167
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
          EXIT PROGRAM
       END IF
     END FOREACH
     #No.FUN-7A0025 --mark--
#     CALL cl_outnam('axmr411') RETURNING l_name
##No.FUN-580013  -begin
#     LET g_zaa[36].zaa08 = g_zaa[36].zaa08,'(',g_d1,')'
#     LET g_zaa[40].zaa08 = g_zaa[40].zaa08,'(',g_d3,')'
#     LET g_zaa[44].zaa08 = g_zaa[44].zaa08,'(',g_d5,')'
#     LET g_zaa[48].zaa08 = g_zaa[48].zaa08,'(',g_x[20],')'
##No.FUN-580013  -end
#     START REPORT r411_rep2 TO l_name
#     LET g_pageno = 0
     #No.FUN-7A0025 --end--
     
     #區域,國別,客戶,幣別
     #Modify By Snow..020810
     #LET l_sql = "SELECT DISTINCT occ21,geb02,oea03,oea032,oea23",
     #LET l_sql = "SELECT DISTINCT occ20,occ21,geb02,oea03,oea032,oea23",  #FUN-550091
     LET l_sql = "SELECT DISTINCT occ20,occ21,occ22,geb02,oea03,oea032,oea23",   #FUN-550091
                 #"  FROM r411_tmp ORDER BY occ21,oea03,oea23" CLIPPED
                 #"  FROM r411_tmp ORDER BY occ20,occ21,oea03,oea23" CLIPPED   #FUN-550091
                 "  FROM r411_tmp ORDER BY occ20,occ21,occ22,oea03,oea23" CLIPPED   #FUN-550091
     PREPARE r411_p1pre2 FROM l_sql
     DECLARE r411_cur12 CURSOR FOR r411_p1pre2
     #Modify By Snow..020810
     #FOREACH r411_cur12 INTO sr1.occ21,sr1.geb02,sr1.oea03,sr1.oea032,sr1.oea23
     #FOREACH r411_cur12 INTO sr1.occ20,sr1.occ21,sr1.geb02,sr1.oea03,sr1.oea032,sr1.oea23      #FUN-550091
     FOREACH r411_cur12 INTO sr1.occ20,sr1.occ21,sr1.occ22,sr1.geb02,sr1.oea03,sr1.oea032,sr1.oea23     #FUN-550091
 
       #第一期
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb112,sr2.oeb114,sr2.ogb112,sr2.ogb114
         FROM r411_tmp
        #WHERE occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
          AND (oeb15 BETWEEN g_d1 AND g_d2)
          AND occ20=sr1.occ20  #Add By Snow..020810
 
       #第二期
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb212,sr2.oeb214,sr2.ogb212,sr2.ogb214
         FROM r411_tmp
	#WHERE occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23  #FUN-550091
          AND (oeb15 BETWEEN g_d3 AND g_d4)
          AND occ20=sr1.occ20  #Add By Snow..020810
 
       #第三期
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb312,sr2.oeb314,sr2.ogb312,sr2.ogb314
         FROM r411_tmp
        #WHERE occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
          AND (oeb15 BETWEEN g_d5 AND g_d6)
          AND occ20=sr1.occ20  #Add By Snow..020810
 
       #總計
       SELECT SUM(oeb12),SUM(oeb14),SUM(ogb12),SUM(ogb14)
         INTO sr2.oeb012,sr2.oeb014,sr2.ogb012,sr2.ogb014
         FROM r411_tmp
        #WHERE occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
        WHERE occ22=sr1.occ22 AND occ21=sr1.occ21 AND oea03=sr1.oea03 AND oea23=sr1.oea23   #FUN-550091
          AND occ20=sr1.occ20  #Add By Snow..020810
 
#       OUTPUT TO REPORT r411_rep2(sr1.*,sr2.*)      #No.FUN-7A0025
       #No.FUN-7A0025 --start--                                                 
       EXECUTE insert_prep USING sr1.occ20,sr1.occ21,sr1.geb02,sr1.occ22,sr1.oea03,  
                                 sr1.oea032,sr2.oeb112,sr2.oeb114,sr2.ogb112,       
                                 sr2.ogb114,sr2.oeb212,sr2.oeb214,sr2.ogb212,       
                                 sr2.ogb214,sr2.oeb312,sr2.oeb314,sr2.ogb312,       
                                 sr2.ogb314,sr2.oeb012,sr2.oeb014,sr2.ogb012,       
                                 sr2.ogb014,sr1.oea23                             
       #No.FUN-7A0025 --end-- 
 
     END FOREACH
 
#     FINISH REPORT r411_rep2                     #No.FUN-7A0025
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-7A0025
     #No.FUN-7A0025 --start--                                                   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                   
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'occ20,occ21,occ22,oea03,oea25,oeb04,oeb15,oea01')  
             RETURNING tm.wc                                                    
        LET g_str = tm.wc                                                       
     END IF                                                                     
     LET g_str = g_str,";",tm.cdate,";",g_so,";",g_date,";",tm.a,";",             
                 g_d1,";",g_d3,";",g_d5,";",g_azi04                             
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED           
     CALL cl_prt_cs3('axmr411','axmr411',l_sql,g_str)                           
     #No.FUN-7A0025 --end--
 
END FUNCTION
#No.FUN-7A0025 --start-- mark
{REPORT r411_rep2(sr)
DEFINE l_last_sw     LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
DEFINE sr           RECORD
                        occ20 LIKE occ_file.occ20, #區域 #Add By Snow..020810
                        occ21 LIKE occ_file.occ21,      #國別
                        occ22 LIKE occ_file.occ22,      #地區   #FUN-550091
                        geb02 LIKE geb_file.geb02,      #國別名
                        oea03 LIKE oea_file.oea03,      #客戶編號
                        oea032 LIKE oea_file.oea032,	#客戶簡稱
                        oea23  LIKE oea_file.oea23,     #幣別
                        oeb112 LIKE oeb_file.oeb12,     #第一期
                        oeb114 LIKE oeb_file.oeb14,
                        ogb112 LIKE ogb_file.ogb12,
                        ogb114 LIKE ogb_file.ogb14,
                        oeb212 LIKE oeb_file.oeb12,     #第二期
                        oeb214 LIKE oeb_file.oeb14,
                        ogb212 LIKE ogb_file.ogb12,
                        ogb214 LIKE ogb_file.ogb14,
                        oeb312 LIKE oeb_file.oeb12,     #第三期
                        oeb314 LIKE oeb_file.oeb14,
                        ogb312 LIKE ogb_file.ogb12,
                        ogb314 LIKE ogb_file.ogb14,
                        oeb012 LIKE oeb_file.oeb12,     #總計
                        oeb014 LIKE oeb_file.oeb14,
                        ogb012 LIKE ogb_file.ogb12,
                        ogb014 LIKE ogb_file.ogb14
                 END RECORD,
		l_rowno LIKE type_file.num5,   #No.FUN-680137 SMALLINT
		l_amt_11,l_amt_12,l_amt_13,l_amt_14 LIKE oeb_file.oeb12, #No.FUN-680137 DECIMAL(17,5)
		l_amt_21,l_amt_22,l_amt_23,l_amt_24 LIKE oeb_file.oeb12, #No.FUN-680137 DECIMAL(17,5)
		l_amt_31,l_amt_32,l_amt_33,l_amt_34 LIKE oeb_file.oeb14, #No.FUN-680137 DECIMAL(17,5)
		l_amt_01,l_amt_02,l_amt_03,l_amt_04 LIKE oeb_file.oeb14  #No.FUN-680137 DECIMAL(17,5)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  #Modify By Snow..020810
  #ORDER BY sr.occ21,sr.oea03,sr.oea23
  #ORDER BY sr.occ20,sr.occ21,sr.oea03,sr.oea23   #FUN-550091
  ORDER BY sr.occ20,sr.occ21,sr.occ22,sr.oea03,sr.oea23   #FUN-550091
  FORMAT
   PAGE HEADER
#No.FUN-580013  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[21] CLIPPED,g_so CLIPPED,      #訂單別
            COLUMN 31,g_x[22] CLIPPED,g_date CLIPPED,   #預交日
            COLUMN 71,g_curr CLIPPED
      PRINT g_dash
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 71,g_x[21] CLIPPED,wc3 CLIPPED,      #訂單別
#           COLUMN 159,g_x[22] CLIPPED,g_date CLIPPED,   #預交日
#                  COLUMN 211,g_curr CLIPPED,
#                  COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN 098,g_d1 USING 'yyyy/mm',  #第一期
#           COLUMN 172,g_d3 USING 'yyyy/mm',  #第二期
#           COLUMN 246,g_d5 USING 'yyyy/mm',  #第三期
#           COLUMN 320,g_x[20] CLIPPED        #合計
#     PRINT COLUMN 001,g_x[11] CLIPPED,
#           COLUMN 061,g_x[27] CLIPPED,COLUMN 098,g_x[12] CLIPPED,
#           COLUMN 135,g_x[13] CLIPPED,COLUMN 172,g_x[12] CLIPPED,
#           COLUMN 209,g_x[13] CLIPPED,COLUMN 246,g_x[12] CLIPPED,
#           COLUMN 283,g_x[13] CLIPPED,COLUMN 320,g_x[12] CLIPPED,
#           COLUMN 357,g_x[13] CLIPPED
#     PRINT COLUMN 001,g_x[14],g_x[15] CLIPPED,
#           COLUMN 061,g_x[16] CLIPPED,COLUMN 098,g_x[16] CLIPPED,
#           COLUMN 135,g_x[16] CLIPPED,COLUMN 172,g_x[16] CLIPPED,
#           COLUMN 209,g_x[16] CLIPPED,COLUMN 246,g_x[16] CLIPPED,
#           COLUMN 283,g_x[16] CLIPPED,COLUMN 320,g_x[16] CLIPPED,
#           COLUMN 357,g_x[16] CLIPPED
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
            g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
      PRINT g_dash1
#No.FUN-580013  -end
      LET l_last_sw = 'n'
 
   #Modify By Snow..020810
   #BEFORE GROUP OF sr.occ21  #國別
   BEFORE GROUP OF sr.occ20  #區域
#No.FUN-580013  -begin
#    PRINT COLUMN 001,sr.occ20 CLIPPED,  #區域
#          COLUMN 006,sr.occ21 CLIPPED,  #國別
#          COLUMN 011,sr.geb02 CLIPPED,  #國別名
#          COLUMN 032,sr.occ22 CLIPPED;  #地區
     LET sr.geb02 = '  ',sr.geb02
     PRINT COLUMN g_c[31],sr.occ20 CLIPPED,  #區域
           COLUMN g_c[32],sr.occ21 CLIPPED,sr.geb02 CLIPPED,  #國別
           COLUMN g_c[33],sr.occ22 CLIPPED;  #地區
#No.FUN-580013  -end
 
   ON EVERY ROW
#No.FUN-580013  -begin
      PRINT COLUMN g_c[34],sr.oea03 CLIPPED,  #客戶代號
            COLUMN g_c[35],sr.oea032 CLIPPED, #客戶簡稱
            COLUMN g_c[36],cl_numfor(sr.oeb112,36,g_azi04), #第一期訂單量
            COLUMN g_c[37],cl_numfor(sr.oeb114,37,g_azi04), #第一期訂單金額
            COLUMN g_c[38],cl_numfor(sr.ogb112,38,g_azi04),#第一期已交量
            COLUMN g_c[39],cl_numfor(sr.ogb114,39,g_azi04), #第一期已交金額
            COLUMN g_c[40],cl_numfor(sr.oeb212,40,g_azi04),#第二期訂單量
            COLUMN g_c[41],cl_numfor(sr.oeb214,41,g_azi04), #第二期訂單金額
            COLUMN g_c[42],cl_numfor(sr.ogb212,42,g_azi04),#第二期已交量
            COLUMN g_c[43],cl_numfor(sr.ogb214,43,g_azi04), #第二期已交金額
            COLUMN g_c[44],cl_numfor(sr.oeb312,44,g_azi04),#第三期訂單量
            COLUMN g_c[45],cl_numfor(sr.oeb314,45,g_azi04), #第三期訂單金額
            COLUMN g_c[46],cl_numfor(sr.ogb312,46,g_azi04),#第三期已交量
            COLUMN g_c[47],cl_numfor(sr.ogb314,47,g_azi04), #第三期已交金額
            COLUMN g_c[48],cl_numfor(sr.oeb012,48,g_azi04),#總計訂單量
            COLUMN g_c[49],cl_numfor(sr.oeb014,49,g_azi04), #總計訂單金額
            COLUMN g_c[50],cl_numfor(sr.ogb012,50,g_azi04),#總計已交量
            COLUMN g_c[51],cl_numfor(sr.ogb014,51,g_azi04) #總計已交金額
#No.FUN-580013  -end
		
   AFTER GROUP OF sr.oea23 #幣別
     LET l_amt_11 = GROUP SUM(sr.oeb112) LET l_amt_12 = GROUP SUM(sr.oeb114)
     LET l_amt_13 = GROUP SUM(sr.ogb112) LET l_amt_14 = GROUP SUM(sr.ogb114)
     LET l_amt_21 = GROUP SUM(sr.oeb212) LET l_amt_22 = GROUP SUM(sr.oeb214)
     LET l_amt_23 = GROUP SUM(sr.ogb212) LET l_amt_24 = GROUP SUM(sr.ogb214)
     LET l_amt_31 = GROUP SUM(sr.oeb312) LET l_amt_32 = GROUP SUM(sr.oeb314)
     LET l_amt_33 = GROUP SUM(sr.ogb312) LET l_amt_34 = GROUP SUM(sr.ogb314)
     LET l_amt_01 = GROUP SUM(sr.oeb012) LET l_amt_02 = GROUP SUM(sr.oeb014)
     LET l_amt_03 = GROUP SUM(sr.ogb012) LET l_amt_04 = GROUP SUM(sr.ogb014)
#No.FUN-580013  -begin
     PRINT COLUMN g_c[33],g_x[18] CLIPPED;  #小計
           IF tm.a='1' THEN  #本幣
              PRINT 'NTD';
           ELSE              #原幣
              PRINT sr.oea23;
           END IF
     PRINT COLUMN g_c[36],cl_numfor(l_amt_11,36,g_azi04),#第一期訂單量
           COLUMN g_c[37],cl_numfor(l_amt_12,37,g_azi04), #第一期訂單金額
           COLUMN g_c[38],cl_numfor(l_amt_13,38,g_azi04),#第一期已交量
           COLUMN g_c[39],cl_numfor(l_amt_14,39,g_azi04), #第一期已交金額
           COLUMN g_c[40],cl_numfor(l_amt_21,40,g_azi04),#第二期訂單量
           COLUMN g_c[41],cl_numfor(l_amt_22,41,g_azi04), #第二期訂單金額
           COLUMN g_c[42],cl_numfor(l_amt_23,42,g_azi04),#第二期已交量
           COLUMN g_c[43],cl_numfor(l_amt_24,43,g_azi04), #第二期已交金額
           COLUMN g_c[44],cl_numfor(l_amt_31,44,g_azi04),#第三期訂單量
           COLUMN g_c[45],cl_numfor(l_amt_32,45,g_azi04), #第三期訂單金額
           COLUMN g_c[46],cl_numfor(l_amt_33,46,g_azi04),#第三期已交量
           COLUMN g_c[47],cl_numfor(l_amt_34,47,g_azi04), #第三期已交金額
           COLUMN g_c[48],cl_numfor(l_amt_01,48,g_azi04),#總計訂單量
           COLUMN g_c[49],cl_numfor(l_amt_02,49,g_azi04), #總計訂單金額
           COLUMN g_c[50],cl_numfor(l_amt_03,50,g_azi04),#總計已交量
           COLUMN g_c[51],cl_numfor(l_amt_04,51,g_azi04) #總計已交金額
#No.FUN-580013  -end
      PRINT ''
 
   ON LAST ROW
     PRINT ''
     LET l_amt_11 = GROUP SUM(sr.oeb112) LET l_amt_12 = GROUP SUM(sr.oeb114)
     LET l_amt_13 = GROUP SUM(sr.ogb112) LET l_amt_14 = GROUP SUM(sr.ogb114)
     LET l_amt_21 = GROUP SUM(sr.oeb212) LET l_amt_22 = GROUP SUM(sr.oeb214)
     LET l_amt_23 = GROUP SUM(sr.ogb212) LET l_amt_24 = GROUP SUM(sr.ogb214)
     LET l_amt_31 = GROUP SUM(sr.oeb312) LET l_amt_32 = GROUP SUM(sr.oeb314)
     LET l_amt_33 = GROUP SUM(sr.ogb312) LET l_amt_34 = GROUP SUM(sr.ogb314)
     LET l_amt_01 = GROUP SUM(sr.oeb012) LET l_amt_02 = GROUP SUM(sr.oeb014)
     LET l_amt_03 = GROUP SUM(sr.ogb012) LET l_amt_04 = GROUP SUM(sr.ogb014)
#No.FUN-580013  -begin
     PRINT COLUMN g_c[33],g_x[19] CLIPPED,  #總計
           COLUMN g_c[36],cl_numfor(l_amt_11,36,g_azi04),#第一期訂單量
           COLUMN g_c[37],cl_numfor(l_amt_12,37,g_azi04), #第一期訂單金額
           COLUMN g_c[38],cl_numfor(l_amt_13,38,g_azi04),#第一期已交量
           COLUMN g_c[39],cl_numfor(l_amt_14,39,g_azi04), #第一期已交金額
           COLUMN g_c[40],cl_numfor(l_amt_21,40,g_azi04),#第二期訂單量
           COLUMN g_c[41],cl_numfor(l_amt_22,41,g_azi04), #第二期訂單金額
           COLUMN g_c[42],cl_numfor(l_amt_23,42,g_azi04),#第二期已交量
           COLUMN g_c[43],cl_numfor(l_amt_24,43,g_azi04), #第二期已交金額
           COLUMN g_c[44],cl_numfor(l_amt_31,44,g_azi04),#第三期訂單量
           COLUMN g_c[45],cl_numfor(l_amt_32,45,g_azi04), #第三期訂單金額
           COLUMN g_c[46],cl_numfor(l_amt_33,46,g_azi04),#第三期已交量
           COLUMN g_c[47],cl_numfor(l_amt_34,47,g_azi04), #第三期已交金額
           COLUMN g_c[48],cl_numfor(l_amt_01,48,g_azi04),#總計訂單量
           COLUMN g_c[49],cl_numfor(l_amt_02,49,g_azi04), #總計訂單金額
           COLUMN g_c[50],cl_numfor(l_amt_03,50,g_azi04),#總計已交量
           COLUMN g_c[51],cl_numfor(l_amt_04,51,g_azi04) #總計已交金額
#No.FUN-580013  -end
 
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea05')
              RETURNING tm.wc
         PRINT g_dash
     #        IF tm.wc[001,070] > ' ' THEN            # for 80
     #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
     #        IF tm.wc[071,140] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
     #        IF tm.wc[141,210] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
     #        IF tm.wc[211,280] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw='y'
 
      PRINT g_x[23] CLIPPED,
            COLUMN (g_len-9),g_x[7] CLIPPED  #結束
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[23] CLIPPED,
               COLUMN (g_len-9), g_x[6] CLIPPED  #接下頁
      ELSE
         SKIP 1 LINE
         LET l_last_sw = 'y' #簽核
         PRINT g_x[4],g_x[5] CLIPPED
      END IF
END REPORT}
#No.FUN-7A0025 --end--
#Patch....NO.TQC-610037 <> #
