# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: aapr150.4gl
# Descriptions...: 應付帳款明細帳列印作業
# Date & Author..: 2000/02/22 By
# Modify.........: No.B072 04/05/25 By Kitty 若有AR沖AP者, 其沖帳記錄不論apa00=1* or 2*
#                  皆會回寫至aapt330. 故可計算aapt330沖帳記錄即可
# Modify.........: No.FUN-4C0097 04/12/27 By Nicola 報表架構修改
# Modify.........: No.MOD-5C0070 05/12/13 By Carrier apz27='N'-->apa34-apa35,
#                                                    apz27='Y'-->apa73
# Modify.........: NO.FUN-570250 05/12/22 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.TQC-620101 06/02/21 By Smapmin 若一月份立暫估，二月份沖暫估，
#                                                    截止日若下一月底時，會讀不到一月底時之數字
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0088 06/11/13 By baogui 未按幣別合計
# Modify.........: No.FUN-720033 07/03/06 By jamie 增加本幣總計
# Modify.........: No.FUN-730064 07/04/04 By lora  會計科目加帳套 
# Modify ........: No.TQC-740042 07/04/09 By johnray s_get_bookno和s_get_bookno1參數應先取出年份
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 應付金額不應扣除留置金額
# Modify.........: No.MOD-770043 07/07/10 By Smapmin 修改抓取沖帳金額的條件
# Modify.........: No.MOD-780019 07/08/24 By Smapmin 過濾已作廢資料
# Modify.........: No.FUN-770093 07/10/10 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.MOD-820116 08/02/21 By Smapmin 沖帳部份應將零用金的沖帳考慮進去
# Modify.........: No.MOD-830019 08/03/04 By Smapmin 因為沖帳於資料登打時就回寫已沖金額
# Modify.........: No.MOD-880086 08/08/14 By Sarah 傳票編號沒帶出來
# Modify.........: No.MOD-8A0192 08/10/29 By Sarah 報表增加抓取成本分攤資料
# Modify.........: No.FUN-940013 09/04/21 By jan apa06,apa54 欄位增加開窗功能
# Modify.........: No.FUN-940027 09/05/15 By jan 增加動態排序功能(選項:1.帳款編號、2.付款廠商、3.會計科目、4.傳票編號)、跳頁、小計功能
# Modify.........: No.MOD-970007 09/07/01 By mike 若參數有設定要做重評,則需抓取重評價匯率,再來計算本幣金額=原幣金額*重評價匯率      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0115 09/11/19 By wujie 报表改抓多帐期资料
# Modify.........: No:MOD-9C0030 09/12/07 By Sarah l_apa14應給予預設值'',抓不到值時不需給予預設值1
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No:CHI-850030 10/05/10 By Summer 增加外購與預購部分,並考量回溯機制
# Modify.........: No:MOD-A90114 10/09/20 By Dido 陣列變數清空 
# Modify.........: No:MOD-AB0159 10/11/15 By Dido 陣列變數清空;原 apa74 改用 apa75 判斷 
# Modify.........: No:CHI-AB0019 10/11/19 By Summer 增加apc04付款日期
# Modify.........: No:CHI-AB0004 10/11/23 By Summer 增加apc02子帳期項次
# Modify.........: No:MOD-B40220 11/04/25 By Dido r150_prepare7 ORDER BY 改用 oox01 DESC 
# Modify.........: No:MOD-B50196 11/05/23 By Sarah 抓取alk_file資料時,本幣金額應該抓應攤合計(alk25+alk26)
# Modify.........: No:MOD-B60199 11/06/23 By Polly 增加抓取直接付款的金額,計算sr.apa34f與sr.apa34時將直接付款金額加回來
# Modify.........: No:TQC-B70203 11/07/28 By Sarah 未付金額計算應包含apc14與apc15
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90241 11/09/29 By yinhy QBE條件中,賬款編號，傳票編號欄位建議開窗，方便報表的輸出
# Modify.........: No:MOD-BB0071 11/11/06 By Dido 檢核預購時餘額計算也須包含結案部分 
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:MOD-BC0170 11/12/19 By Sarah 先到單後到貨時,應該改用alk07來抓l_alh14跟l_alh16
# Modify.........: No:MOD-C20191 12/02/23 By Polly 因取位問題，改用本幣判斷是否大於零
# Modify.........: No:MOD-C30617 12/03/13 By Polly 查詢條件後需再重新給予 INPUT 欄位變數
# Modify.........: No:MOD-C50037 12/05/08 By Elise 帳款的回溯功能應將aapt335的帳款也列進來
# Modify.........: No:MOD-C50072 12/05/11 By Elise 未加入aapt720預付貨款與aapt810的已沖預付
# Modify.........: No:TQC-C50219 12/05/31 By lujh 加入alhfirm=Y已審核的判斷條件
# Modify.........: No:MOD-C70238 12/07/24 By Polly 帳款的回溯功能將3開頭的帳款都列進來
# Modify.........: No:MOD-C90126 12/10/12 By yinhy 更改付款廠商開窗
# Modify.........: No:MOD-CA0051 12/10/08 By Polly 回溯時使用的是到單日期(alh021)為時間依據，因此應增加alh021判斷
# Modify.........: No:MOD-CA0154 12/10/23 By Polly 調整抓取撤票的應收帳款金額apa75條件
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No:MOD-D10055 13/01/08 By Polly 預購段改用foreach迴圈方式抓取alk03資料

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc       STRING,   #TQC-630166
              e_date  LIKE type_file.dat,     #No.FUN-690028 DATE
              s       LIKE type_file.chr3,    #FUN-940027
              t       LIKE type_file.chr3,    #FUN-940027
              u       LIKE type_file.chr3,    #FUN-940027
              more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730064                                                                        
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730064
DEFINE g_flag           LIKE type_file.chr1   #No.FUN-730064
DEFINE g_str            STRING                #No.FUN-770093
DEFINE g_sql            STRING                #No.FUN-770093
DEFINE l_table          STRING                #No.FUN-770093
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   LET g_sql="apa02.apa_file.apa02,apa44.apa_file.apa44,apa01.apa_file.apa01,",
             "apa06.apa_file.apa06,apa07.apa_file.apa07,apa25.apa_file.apa25,",
             "apc02.apc_file.apc02,", #CHI-AB0004 add
             "apa12.apa_file.apa12,apa13.apa_file.apa13,apa34f.apa_file.apa34f,", #CHI-AB0019 add apa12
             "apa34.apa_file.apa34,apa54.apa_file.apa54,aag02.aag_file.aag02,",
             "azi03.azi_file.azi03,azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('aapr150',g_sql) CLIPPED
   IF l_table = -1 THEN
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF

   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)" #CHI-AB0019 add ? #CHI-AB0004 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1)
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.e_date  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   LET tm.s  = ARG_VAL(13)    #FUN-940027
   LET tm.t  = ARG_VAL(14)    #FUN-940027
   LET tm.u  = ARG_VAL(15)    #FUN-940027

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r150_tm(0,0)
   ELSE
      CALL r150()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r150_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW r150_w AT p_row,p_col
     WITH FORM "aap/42f/aapr150"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.e_date    = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa01,apa06,apa54,apa44
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION controlp
           CASE
              WHEN INFIELD(apa06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   #LET g_qryparam.form = "q_pmc1"    #MOD-C90126  
                   LET g_qryparam.form = "q_apa12"    #MOD-C90126
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa06
                   NEXT FIELD apa06
              WHEN INFIELD(apa54)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apa54
                   NEXT FIELD apa54
              #No.TQC-B90241  --Begin
              WHEN INFIELD(apa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apa08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
              WHEN INFIELD(apa44) #傳票編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aba02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa44
                  NEXT FIELD apa44
              #No.TQC-B90241  --End
              OTHERWISE EXIT CASE
           END CASE
 
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r150_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.e_date,
                    tm2.s1,tm2.s2,tm2.s3,    #FUN-940027 add
                    tm2.t1,tm2.t2,tm2.t3,    #FUN-940027 add 
                    tm2.u1,tm2.u2,tm2.u3,    #FUN-940027 add
                    tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
           #--------------------MOD-C30617----------------start
            LET tm.e_date = GET_FLDBUF(e_date)
            LET tm2.s1 = GET_FLDBUF(s1)
            LET tm2.s2 = GET_FLDBUF(s2)
            LET tm2.s3 = GET_FLDBUF(s3)
            LET tm2.t1 = GET_FLDBUF(t1)
            LET tm2.t2 = GET_FLDBUF(t2)
            LET tm2.t3 = GET_FLDBUF(t3)
            LET tm2.u1 = GET_FLDBUF(u1)
            LET tm2.u2 = GET_FLDBUF(u2)
            LET tm2.u3 = GET_FLDBUF(u3)
           #--------------------MOD-C30617------------------end
 
         AFTER FIELD e_date
            IF cl_null(tm.e_date) THEN
               NEXT FIELD e_date
         END IF
 
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         AFTER INPUT 
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r150_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr150'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr150','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.e_date CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.s CLIPPED,"'",                 #FUN-940027
                         " '",tm.t CLIPPED,"'",                 #FUN-940027
                         " '",tm.u CLIPPED,"'"                  #FUN-940027
            CALL cl_cmdat('aapr150',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r150_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r150()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r150_w
 
END FUNCTION
 
FUNCTION r150()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
DEFINE l_sql      STRING            # RDSQL STATEMENT
DEFINE l_sql1     STRING            # RDSQL STATEMENT
DEFINE l_sql2     STRING            # RDSQL STATEMENT   #FUN-720033 add
DEFINE l_apg05f  LIKE apg_file.apg05f    #原幣沖帳金額
DEFINE l_apg05   LIKE apg_file.apg05     #本幣沖帳金額
DEFINE l_apv04f  LIKE apv_file.apv04f    #原幣沖帳金額
DEFINE l_apv04   LIKE apv_file.apv04     #本幣沖帳金額
DEFINE l_aph05f  LIKE aph_file.aph05f    #原幣沖帳金額
DEFINE l_aph05f_1 LIKE aph_file.aph05f   #MOD-B60199 add
DEFINE l_aph05   LIKE aph_file.aph05     #本幣沖帳金額
DEFINE l_aph05_1 LIKE aph_file.aph05     #MOD-B60199 add
DEFINE l_oob09   LIKE oob_file.oob09     #原幣沖帳金額
DEFINE l_oob10   LIKE oob_file.oob10     #本幣沖帳金額
DEFINE l_aqb04f  LIKE aqb_file.aqb04     #原幣分攤金額   #MOD-8A0192 add
DEFINE l_aqb04   LIKE aqb_file.aqb04     #本幣分攤金額   #MOD-8A0192 add
DEFINE l_apa14   LIKE apa_file.apa14     #待抵帳款匯率   #MOD-8A0192 add
DEFINE l_apa14_1 LIKE apa_file.apa14     #MOD-9C0030 add
DEFINE l_alk07   LIKE alk_file.alk07     #到單單號       #MOD-BC0170 add
DEFINE l_alh14   LIKE alh_file.alh14     #原幣沖帳金額   #CHI-850030 add
DEFINE l_alh16   LIKE alh_file.alh16     #本幣沖帳金額   #CHI-850030 add
DEFINE l_ala95f  LIKE ala_file.ala95     #原幣沖帳金額   #CHI-850030 add
DEFINE l_ala95   LIKE ala_file.ala95     #本幣沖帳金額   #CHI-850030 add
DEFINE sr        RECORD
                    apa00  LIKE apa_file.apa00,    #帳款類別
                    apa01  LIKE apa_file.apa01,    #帳款編號
                    apa02  LIKE apa_file.apa02,    #帳款日期
                    apa06  LIKE apa_file.apa06,    #廠商編號
                    apa07  LIKE apa_file.apa07,    #廠商簡稱
                    apa08  LIKE apa_file.apa08,    #發票號碼   #MOD-880086 add
                    apa58  LIKE apa_file.apa58,    #折讓性質   #MOD-880086 add
                    apc02  LIKE apc_file.apc02,    #子帳期項次 #CHI-AB0004 add
                    apa12  LIKE apa_file.apa12,    #付款日期   #CHI-AB0019 add
                    apa13  LIKE apa_file.apa13,    #幣別
                    apa25  LIKE apa_file.apa25,    #摘要
                    apa44  LIKE apa_file.apa44,    #傳票編號
                    apa54  LIKE apa_file.apa54,    #會計科目
                    aag02  LIKE aag_file.aag02,    #科目名稱
                    apa34f LIKE apa_file.apa34f,   #原幣金額
                    apa34  LIKE apa_file.apa34,    #本幣金額    #CHI-850030 add ,
                    apa74  LIKE apa_file.apa74     #外購付款否  #CHI-850030 add
                 END RECORD
#CHI-850030 add --start--
DEFINE ala       RECORD
                    ala86  LIKE ala_file.ala86,
                    ala95  LIKE ala_file.ala95,
                    ala94  LIKE ala_file.ala94,
                    ala59  LIKE ala_file.ala59,
                    ala51  LIKE ala_file.ala51,
                    ala771 LIKE ala_file.ala771   #MOD-BB0071
                 END RECORD
DEFINE alh       RECORD
                    alh14  LIKE alh_file.alh14,
                    alh16  LIKE alh_file.alh16
                 END RECORD
#CHI-850030 add --end--
DEFINE l_oox01   STRING                           #MOD-970007                                                                       
DEFINE l_oox02   STRING                           #MOD-970007                                                                       
DEFINE l_sql_1   STRING                           #MOD-970007                                                                       
DEFINE l_sql_2   STRING                           #MOD-970007                                                                       
DEFINE l_year    LIKE oox_file.oox01              #MOD-970007   
DEFINE l_tm_wc   STRING                           #CHI-850030 add                                                             
DEFINE l_tm_wc2  STRING                           #CHI-850030 add                                                               
DEFINE l_ala22   LIKE ala_file.ala22              #CHI-AB0019 add
DEFINE l_alk02   LIKE alk_file.alk02              #MOD-C50072
DEFINE l_alk26   LIKE alk_file.alk26              #MOD-C50072

   CALL cl_del_data(l_table)                      #No.FUN-770093
   INITIALIZE alh.* TO NULL                       #MOD-A90114
   INITIALIZE ala.* TO NULL                       #MOD-A90114
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')

   #CHI-850030 add --start-- 
   LET l_tm_wc =""
   CALL cl_replace_str(tm.wc,"apa01","ala01") RETURNING l_tm_wc
   CALL cl_replace_str(l_tm_wc,"apa06","ala05") RETURNING l_tm_wc
   CALL cl_replace_str(l_tm_wc,"apa54","ala41") RETURNING l_tm_wc
   CALL cl_replace_str(l_tm_wc,"apa44","ala72") RETURNING l_tm_wc
   LET l_tm_wc2 =""
   CALL cl_replace_str(tm.wc,"apa01","alk01") RETURNING l_tm_wc2
   CALL cl_replace_str(l_tm_wc2,"apa06","alk05") RETURNING l_tm_wc2
   CALL cl_replace_str(l_tm_wc2,"apa54","alk41") RETURNING l_tm_wc2
   CALL cl_replace_str(l_tm_wc2,"apa44","alk72") RETURNING l_tm_wc2
   #CHI-850030 add --end--

   LET l_sql1 ="SELECT SUM(apv04f),SUM(apv04) ",
               " FROM apv_file,apa_file",
               " WHERE apv03= ?  AND apv01=apa01 AND apa41<>'X' ",   #MOD-770043
               "   AND apa02 > '",tm.e_date,"' ",
               "   AND apa42 = 'N'",   #MOD-780019 #CHI-AB0004 add ,
               "   AND apv05 = ?"   #CHI-AB0004 add
 
   PREPARE r150_papv FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apv:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_capv CURSOR FOR r150_papv
 
   #no.6128 待抵帳款要考慮到在 aapt330 與 axrt400 沖帳的情況
   LET l_sql1 = "SELECT SUM(aph05f),SUM(aph05) ",
                "  FROM aph_file,apf_file",
                " WHERE aph04 = ? AND aph01 = apf01 AND  apf41 = 'Y' ",
                "   AND apf02 > '",tm.e_date,"' ", #CHI-AB0004 add ,
                "   AND aph17 = ? " #CHI-AB0004 add
   PREPARE r150_paph FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aph:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_caph CURSOR FOR r150_paph
#------------------------MOD-B60199---------------------------add
   LET l_sql1 = "SELECT SUM(aph05f),SUM(aph05) ",
                "  FROM aph_file,apa_file",
                " WHERE aph04 = ? AND aph01 = apa01",
                "   AND  apa41 = 'N' ",
                "   AND aph17 = ? "
   PREPARE r150_paph1 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aph:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_caph1 CURSOR FOR r150_paph1

#------------------------MOD-B60199---------------------------end 
   LET l_sql1 = "SELECT SUM(oob09),SUM(oob10) ",
                "  FROM oob_file,ooa_file",
                " WHERE oob06 = ? AND oob01 = ooa01 AND  ooaconf = 'Y' ",
                "   AND oob03 = '2' AND oob04 = '9' ",
                "   AND ooa02 > '",tm.e_date,"' ", #CHI-AB0004 add ,
                "   AND oob19 = ? " #CHI-AB0004 add
   PREPARE r150_poob FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare oob:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_coob CURSOR FOR r150_poob
 
   LET l_sql1 ="SELECT SUM(apg05f),SUM(apg05) ",
               " FROM apf_file,apg_file",
               " WHERE apf01=apg01 ",
               "   AND apf41='Y' ",   #已確認
               "   AND apf02 > '",tm.e_date,"' ",
               "   AND apg04 = ? ", #CHI-AB0004 add ,
               "   AND apg06 = ? " #CHI-AB0004 add
   PREPARE r150_papg FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apg:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_capg CURSOR FOR r150_papg
 
   LET l_sql1 ="SELECT SUM(aqb04)",
               " FROM aqb_file,aqa_file,apa_file",
               " WHERE aqb01=aqa01 ",
               "   AND aqb02=apa01 ",
               "   AND (apa00='23' OR apa00='25') ",
               "   AND aqa04='Y' ",
               "   AND aqaconf='Y' ",
               "   AND aqa02 > '",tm.e_date,"' ",
               "   AND aqb02 = ? "
   PREPARE r150_paqb FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aqb:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_caqb CURSOR FOR r150_paqb
 
   #CHI-850030 add --start--
   LET l_sql1 = "SELECT SUM(alh14),SUM(alh16) ",
                "  FROM alh_file",
                " WHERE alh30 = ? ",
                "   AND  alhfirm = 'Y' ",
                "   AND alh021 > '",tm.e_date,"' "
   PREPARE r150_palh FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare alh:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_calh CURSOR FOR r150_palh

   #str MOD-BC0170 add
   CALL cl_replace_str(l_sql1,"alh30","alh01") RETURNING l_sql1
   PREPARE r150_palh01 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare alh01:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_calh01 CURSOR FOR r150_palh01
   #end MOD-BC0170 add

   LET l_sql1 = "SELECT SUM(ala95/ala94),SUM(ala95) ",
                "  FROM ala_file",
                " WHERE ala01 = ? ",
                "   AND  alafirm = 'Y' ",
                "   AND ala86 > '",tm.e_date,"' "
   PREPARE r150_pala1 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare ala:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_cala1 CURSOR FOR r150_pala1

   LET l_sql1 = "SELECT SUM(ala59/ala51),SUM(ala59) ",
                "  FROM ala_file",
                " WHERE ala01 = ? ",
                "   AND  alafirm = 'Y' ",
                "   AND ala771 > '",tm.e_date,"' "
   PREPARE r150_pala2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare ala:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
   DECLARE r150_cala2 CURSOR FOR r150_pala2
   #CHI-850030 add --end--

   IF g_apz.apz27 = 'N' THEN
#No.MOD-9B0115 --begin

      LET l_sql = "SELECT apa00,apa01,apa02,apa06,apa07,apc12,apa58,apc02,apc04,apa13,apa25,",   #MOD-880086 add apa08,apa58 #CHI-AB0019 add apc04 #CHI-AB0004 add apc02
                  "       apa44,apa54,'',(apc08-apc10-apc14),",   #TQC-610098   #MOD-720128  #TQC-B70203 add apc14
                  "       (apc09-apc11-apc15),apa74 ",    #TQC-610098   #MOD-720128 #CHI-850030 add apa74  #TQC-B70203 add acp15
                  " FROM apa_file,apc_file",  #No.MOD-9B0115 
                 #" WHERE apa42 = 'N' AND apa74='N' ",   #非作廢&外購付款  #No.FUN-730064 #MOD-AB0159 mark 
                 #" WHERE apa42 = 'N' AND apa75='N' ",                #非作廢&外購付款  #No.FUN-730064 #MOD-AB0159 #MOD-CA0154 mark
                  " WHERE apa42 = 'N' ",                              #非作廢&外購付款  #MOD-CA0154 add
                  "   AND (apa75 = 'N' OR apa75 IS NULL) ",           #非作廢&外購付款  #MOD-CA0154 add
                  "   AND apa02 <='",tm.e_date,"'",
                  "   AND apa01 =apc01",   #No.MOD-9B0115 
                  "   AND apa41 = 'Y'",   #已確認
                  "   AND ", tm.wc CLIPPED,
                 #"   AND ( (apa34f-apa35f) >0 OR ",   #TQC-610098 #MOD-720128 #MOD-C20191 mark
                  #"   AND ( (apa34-apa35) >0 OR ",     #MOD-C20191 add  #mark by dengsy170410
                  "   AND ( (apa34-apa35) <>0 OR ",   #add by dengsy170410
                  "        apa01 IN (SELECT apg04 FROM apf_file,apg_file ",
                 #"                   WHERE apf01=apg01 AND (apf00='33' OR apf00='34') ",   #MOD-820116    #MOD-C50037 mark
                 #"                   WHERE apf01=apg01 AND (apf00='33' OR apf00='34' OR apf00 = '36') ",  #MOD-C50037 #MOD-C70238 mark
                  "                   WHERE apf01=apg01 AND (apf00 LIKE '3%') ",                           #MOD-C70238 add
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",tm.e_date,"' )  OR ",
                  "        apa01 IN (SELECT apv03 FROM apv_file,apa_file ",
                  "                   WHERE apv01=apa01  ",
                  "                     AND apa42 = 'N' ",   #MOD-780019
                  "                     AND apa02 >'",tm.e_date,"' )  OR ",
                  "        apa01 IN (SELECT aph04 FROM apf_file,aph_file ",
                  "                   WHERE aph01=apf01  ",
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",tm.e_date,"' ) OR ",
                  #No.MOD-B60199---------------------------------------------------------add
                  "        apa01 IN (SELECT aph04 FROM aph_file ",
                  "                   WHERE aph01 NOT IN (SELECT apf01 FROM apf_file) ",
                  "                     AND aph07 >'",tm.e_date,"' ) OR ",
                  #No.MOD-B60199---------------------------------------------------------end
                  "        apa01 IN (SELECT oob06 FROM oob_file,ooa_file ",
                  "                   WHERE oob01=ooa01  ",
                  "                     AND ooaconf = 'Y' ",
                  "                     AND oob03 = '2' AND oob04 = '9' ",
                  "                     AND ooa02 >'",tm.e_date,"' ) OR ",
                  "        apa01 IN (SELECT aqb02 FROM aqb_file,aqa_file,apa_file ",
                  "                   WHERE aqb01 = aqa01  ",
                  "                     AND aqb02 = apa01  ",
                  "                     AND (apa00 ='23' OR apa00='25')",
                  "                     AND aqa04 = 'Y' ",
                  "                     AND aqaconf = 'Y' ",
                  "                     AND aqa02 >'",tm.e_date,"' ) OR ",
                  "        apa01 IN (SELECT api26 FROM api_file,apa_file ",
                  "                   WHERE api01 = apa01 ",
                  "                     AND api02 = '2' " , #沖暫估
                  "                     AND apa42 ='N' ",   #MOD-780019
                  "                     AND apa41 ='Y' ",
                  "                     AND apa02 >'",tm.e_date,"')) "
      #CHI-850030 add --start--
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',ala01,ala08,ala05,pmc03,'','',0,ala86,ala20,ala32,", #CHI-AB0019 add ala86 #CHI-AB0004 add 0
                  "       ala72,ala41,'',ala59/ala51,", 
                  "       ala59 ,'R' ", 
                  " FROM ala_file,pmc_file ",
                  " WHERE ala05 = pmc01 ",
                  "   AND ala08 <='",tm.e_date,"'",
                  "   AND alafirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc CLIPPED
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',alk01,alk02,alk05,pmc03,alk46,'',0,alk02,alk11,alk08,", #CHI-AB0019 add alk02 #CHI-AB0004 add 0
                  "       alk72,alk41,'',alk13,", 
                 #"       alk13*alk12 ,'O' ",   #MOD-B50196 mark
                 #"       alk25+alk26 ,'O' ",   #MOD-B50196  #MOD-C50072 mark
                  "       alk25 ,'O' ",         #MOD-C50072
                  " FROM alk_file,pmc_file ",
                  " WHERE alk05 = pmc01 ",
                  "   AND alk02 <='",tm.e_date,"'",
                  "   AND alkfirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc2 CLIPPED
      #CHI-850030 add --end--
   ELSE
      LET l_sql = "SELECT apa00,apa01,apa02,apa06,apa07,apc12,apa58,apc02,apc04,apa13,apa25,",   #MOD-880086 add apa08,apa58 #CHI-AB0019 add apc04 #CHI-AB0004 add apc02
                  "       apa44,apa54,'',(apc08-apc10-apc14),",  #TQC-B70203 add apc14
                  "       apc13,apa74 ", #CHI-850030 add apa74 
                  " FROM apa_file,apc_file",   #No.MOD-9B0115 
                 #" WHERE apa42 = 'N' AND apa74='N' ",   #非作廢&外購付款 #MOD-AB0159 mark
                 #" WHERE apa42 = 'N' AND apa75='N' ",                                           #非作廢&外購付款 #MOD-AB0159 #MOD-CA0154 mark
                  " WHERE apa42 = 'N' ",                                                         #非作廢&外購付款 #MOD-CA0154 add
                  "   AND (apa75 = 'N' OR apa75 IS NULL) ",                                      #非作廢&外購付款 #MOD-CA0154 add
                  "   AND apa02 <='",tm.e_date,"'",
                  "   AND apa01 =apc01",   #No.MOD-9B0115 
                  "   AND apa41 = 'Y'",   #已確認
                  "   AND ", tm.wc CLIPPED,
                 #"   AND ( (apa34f-apa35f) >0 OR ",   #TQC-610098 #MOD-720128 #MOD-C20191 mark
                  #"   AND ( (apa34-apa35) >0 OR ",     #MOD-C20191 add  #MARK BY DENGSY170410
                  "   AND ( (apa34-apa35) <>0 OR ",   #add by dengsy170410
                  "        apa01 IN (SELECT apg04 FROM apf_file,apg_file ",
                 #"                   WHERE apf01=apg01 AND (apf00='33' OR apf00='34') ",   #MOD-820116    #MOD-C50037 mark
                 #"                   WHERE apf01=apg01 AND (apf00='33' OR apf00='34' OR apf00 = '36') ",  #MOD-C50037 #MOD-C70238 mark
                  "                   WHERE apf01=apg01 AND (apf00 LIKE '3%') ",                           #MOD-C70238 add
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",tm.e_date,"' )  OR ",
                  "        apa01 IN (SELECT apv03 FROM apv_file,apa_file ",
                  "                   WHERE apv01=apa01  ",
                  "                     AND apa42 = 'N' ",   #MOD-780019
                  "                     AND apa02 >'",tm.e_date,"' )  OR ",
                  "        apa01 IN (SELECT aph04 FROM apf_file,aph_file ",
                  "                   WHERE aph01=apf01  ",
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",tm.e_date,"' ) OR ",
                  "        apa01 IN (SELECT oob06 FROM oob_file,ooa_file ",
                  "                   WHERE oob01=ooa01  ",
                  "                     AND ooaconf = 'Y' ",
                  "                     AND oob03 = '2' AND oob04 = '9' ",
                  "                     AND ooa02 >'",tm.e_date,"' ) OR ",
                  "        apa01 IN (SELECT aqb02 FROM aqb_file,aqa_file,apa_file ",
                  "                   WHERE aqb01 = aqa01  ",
                  "                     AND aqb02 = apa01  ",
                  "                     AND (apa00 ='23' OR apa00='25')",
                  "                     AND aqa04 = 'Y' ",
                  "                     AND aqaconf = 'Y' ",
                  "                     AND aqa02 >'",tm.e_date,"' ) OR ",
                  "        apa01 IN (SELECT api26 FROM api_file,apa_file ",
                  "                   WHERE api01 = apa01 ",
                  "                     AND api02 = '2' " , #沖暫估
                  "                     AND apa41 ='Y' ",
                  "                     AND apa42 ='N' ",   #MOD-780019
                  "                     AND apa02 >'",tm.e_date,"')) "
      #CHI-850030 add --start--
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',ala01,ala08,ala05,pmc03,'','',0,ala86,ala20,ala32,", #CHI-AB0019 add ala86 #CHI-AB0004 add 0
                  "       ala72,ala41,'',ala59/ala51,", 
                  "       ala59 ,'R' ", 
                  " FROM ala_file,pmc_file ",
                  " WHERE ala05 = pmc01 ",
                  "   AND ala08 <='",tm.e_date,"'",
                  "   AND alafirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc CLIPPED
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',alk01,alk02,alk05,pmc03,alk46,'',0,alk02,alk11,alk08,", #CHI-AB0019 add alk02 #CHI-AB0004 add 0
                  "       alk72,alk41,'',alk13,", 
                 #"       alk13*alk12 ,'O' ",   #MOD-B50196 mark
                 #"       alk25+alk26 ,'O' ",   #MOD-B50196  #MOD-C50072 mark
                  "       alk25 ,'O' ",         #MOD-C50072
                  " FROM alk_file,pmc_file ",
                  " WHERE alk05 = pmc01 ",
                  "   AND alk02 <='",tm.e_date,"'",
                  "   AND alkfirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc2 CLIPPED
      #CHI-850030 add --end--
   END IF
 
   PREPARE r150_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
  #--------------------MOD-D10055---------------(S)
   LET l_sql = "SELECT alk02,alk26,alk07 FROM alk_file",
               " WHERE alk03 = ? "
   PREPARE r150_cc FROM l_sql
   DECLARE r150_ccc CURSOR FOR r150_cc
  #--------------------MOD-D10055---------------(E)
   DECLARE r150_curs1 CURSOR FOR r150_prepare1
 

   FOREACH r150_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL s_get_bookno(YEAR(sr.apa02)) RETURNING g_flag,g_bookno1,g_bookno2                                                                #No.TQC-740042
      IF g_flag =  '1' THEN  #抓不到帳別                                                                                              
         CALL cl_err(sr.apa02,'aoo-081',1)                                                                                            
      END IF                                                                                                                          
      SELECT aag02 INTO sr.aag02  from aag_file                                                                                       
       WHERE aag01 = sr.apa54                                                                                                         
         AND aag00 = g_bookno1                                                                                                        
      #No.FUN-730064  --End       #讀取截止日之後的沖帳金額
      LET l_apg05f =0
      LET l_apg05  =0
 
      OPEN r150_capg USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_capg INTO l_apg05f,l_apg05
      IF SQLCA.SQLCODE <> 0 THEN
         LET l_apg05f=0
         LET l_apg05 =0
      END IF
      CLOSE r150_capg
 
      #讀取截止日之後的直接沖帳金額(K.沖帳)
      LET l_apv04f =0
      LET l_apv04  =0
 
      OPEN r150_capv USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_capv INTO l_apv04f,l_apv04
      IF SQLCA.SQLCODE <> 0 THEN
         LET l_apv04f = 0
         LET l_apv04 = 0
      END IF
 
      LET l_oob09 = 0
      LET l_oob10 = 0
      LET l_aph05f = 0
      LET l_aph05 = 0
      LET l_aph05f_1=0          #MOD-B60199 add
      LET l_aph05_1=0           #MOD-B60199 add
 
      OPEN r150_caph USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_caph INTO l_aph05f,l_aph05
#----------------------------MOD-B60199------------------------------add
      OPEN r150_caph1 USING sr.apa01,sr.apc02
      FETCH r150_caph1 INTO l_aph05f_1,l_aph05_1
#----------------------------MOD-B60199------------------------------end
      OPEN r150_coob USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_coob INTO l_oob09,l_oob10
 
      IF cl_null(l_oob09) THEN
         LET l_oob09 = 0
      END IF
 
      IF cl_null(l_oob10) THEN
         LET l_oob10 = 0
      END IF
 
      IF cl_null(l_aph05f) THEN
         LET l_aph05f = 0
      END IF
 
      IF cl_null(l_aph05) THEN
         LET l_aph05 = 0
      END IF
#----------------------#MOD-B60199 add------------------------------------ 
      IF cl_null(l_aph05f_1) THEN 
         LET l_aph05f_1= 0 
      END IF           

      IF cl_null(l_aph05_1) THEN 
         LET l_aph05_1=0 
      END IF              
#----------------------#MOD-B60199 end-----------------------------------
      OPEN r150_caqb USING sr.apa01
      FETCH r150_caqb INTO l_aqb04
      IF cl_null(l_aqb04) THEN
         LET l_aqb04 = 0
      END IF

      #CHI-850030 add --start--
         LET l_ala95f = 0
         LET l_ala95 = 0
         LET l_alh14 = 0
         LET l_alh16 = 0

         INITIALIZE alh.* TO NULL                       #MOD-AB0159
         INITIALIZE ala.* TO NULL                       #MOD-AB0159
         IF sr.apa74='O' THEN  #外購
            SELECT alh14,alh16 INTO alh.*
              FROM alh_file
             WHERE alh30 = sr.apa01
               AND alhfirm = 'Y'     #TQC-C50219   add
               AND alh02 <= tm.e_date                               #MOD-CA0051 add
            IF cl_null(alh.alh14) THEN LET alh.alh14 = 0 END IF
            IF cl_null(alh.alh16) THEN LET alh.alh16 = 0 END IF
            LET sr.apa34f = sr.apa34f - alh.alh14
            LET sr.apa34  = sr.apa34  - alh.alh16
            OPEN r150_calh USING sr.apa01
            FETCH r150_calh INTO l_alh14,l_alh16
           #str MOD-BC0170 add
           #先到單後到貨時,應該改用alk07來抓l_alh14跟l_alh16
            IF cl_null(l_alh14) AND cl_null(l_alh16) THEN
               LET l_alk07=''
               SELECT alk07 INTO l_alk07 FROM alk_file WHERE alk01=sr.apa01
               OPEN r150_calh01 USING l_alk07
               FETCH r150_calh01 INTO l_alh14,l_alh16
            END IF
           #end MOD-BC0170 add
            IF cl_null(l_alh14) THEN LET l_alh14 = 0 END IF
            IF cl_null(l_alh16) THEN LET l_alh16 = 0 END IF
         END IF

         IF sr.apa74='R' THEN  #預購
            SELECT ala86,ala95,ala94,ala59,ala51,ala771 INTO ala.*    #MOD-BB0071 add ala771
              FROM ala_file
             WHERE ala01 = sr.apa01

            #若aapt711存在,則不考慮 aapt750,依付款日(ala86) ala95(本幣)須再行分析原幣與本幣
            #若aapt711不存在,則 aapt750存在,依結案日(ala771) 回溯金額則抓取 aapt720 的 ala59(本幣)
            IF ala.ala86 !="" OR (NOT cl_null(ala.ala86)) THEN
               #立帳、外購在SLECT時已用餘額計算,故預購回溯前要先求出原幣本幣餘額
               LET sr.apa34f = sr.apa34f - ala.ala95/ala.ala94
               LET sr.apa34  = sr.apa34  - ala.ala95
               OPEN r150_cala1 USING sr.apa01
               FETCH r150_cala1 INTO l_ala95f,l_ala95
              #MOD-C50072---S---
               LET l_alk02=0   LET l_alk26=0
           #--------------------------MOD-D10055-----------------------(S)
           #--MOD-D10055--mark
           #SELECT alk02,SUM(alk26) INTO l_alk02,l_alk26 FROM alk_file
           # WHERE alk03=sr.apa01  
           #   AND alkfirm <> 'X'  #CHI-C80041
           # GROUP BY alk02
           #IF l_alk02 > tm.e_date THEN
           #   LET sr.apa34f =  sr.apa34f + l_alk26/ala.ala94
           #   LET sr.apa34  =  sr.apa34  + l_alk26
           #END IF
           #  #MOD-C50072---E---
           #--MOD-D10055--mark
            FOREACH r150_ccc USING sr.apa01 INTO l_alk02,l_alk26,l_alk07
               IF l_alk02 > tm.e_date THEN
                  IF NOT cl_null(l_alk07) THEN
                     LET l_alk26 = l_alk26 * -1
                  END IF
                  LET sr.apa34f = sr.apa34f + l_alk26/ala.ala94
                  LET sr.apa34  = sr.apa34  + l_alk26
               END IF
            END FOREACH
           #--------------------------MOD-D10055-----------------------(E)
            ELSE
               IF ala.ala771 !="" OR (NOT cl_null(ala.ala771)) THEN   #MOD-BB0071
                  LET sr.apa34f = sr.apa34f - ala.ala59/ala.ala51
                  LET sr.apa34  = sr.apa34  - ala.ala59
                  OPEN r150_cala2 USING sr.apa01
                  FETCH r150_cala2 INTO l_ala95f,l_ala95
               END IF                                                 #MOD-BB0071
            END IF
            IF cl_null(l_ala95f) THEN LET l_ala95f = 0 END IF
            IF cl_null(l_ala95) THEN LET l_ala95 = 0 END IF
         END IF
         #CHI-850030 add --end--

      IF g_apz.apz27 = 'Y' THEN                                                                                                     
         LET l_oox01 = YEAR(tm.e_date)                                                                                              
         LET l_oox02 = MONTH(tm.e_date)                                                                                             
         LET l_sql_2 = "SELECT oox01 FROM oox_file",                                                                                
                       " WHERE oox00 = 'AP' AND oox01 <= '",l_oox01,"'",                                                            
                       "   AND oox03 = '",sr.apa01,"'",                                                                             
                       "   AND oox04 = '0'",                                                                                        
                      #" ORDER BY oox01"        #MOD-B40220 mark                                                                                        
                       " ORDER BY oox01 DESC "  #MOD-B40220 
         PREPARE r150_prepare7 FROM l_sql_2                                                                                         
         DECLARE r150_oox7 CURSOR FOR r150_prepare7                                                                                 
         LET l_apa14 = ''   #MOD-9C0030 add
         FOREACH r150_oox7 INTO l_year                                                                                              
             IF l_year = l_oox01 THEN                                                                                               
                 LET l_sql_1 = "SELECT oox07 FROM oox_file",                                                                        
                               " WHERE oox00 = 'AP' AND oox01 = '",l_year,"'",                                                      
                               "   AND oox02 <= '",l_oox02,"'",                                                                     
                               "   AND oox03 = '",sr.apa01,"'",                                                                     
                               "   AND oox04 = '0'",                                                                                
                               " ORDER BY oox02 DESC "                                                                              
             ELSE                                                                                                                   
                 LET l_sql_1 = "SELECT oox07 FROM oox_file",                                                                        
                               " WHERE oox00 = 'AP' AND oox01 = '",l_year,"'",                                                      
                               "   AND oox03 = '",sr.apa01,"'",                                                                     
                               "   AND oox04 = '0'",         
                               " ORDER BY oox02 DESC "                                                                              
             END IF                                                                                                                 
             PREPARE r150_prepare07 FROM l_sql_1                                                                                    
             DECLARE r150_oox07 CURSOR FOR r150_prepare07                                                                           
             OPEN r150_oox07                                                                                                        
             FETCH r150_oox07 INTO l_apa14                                                                                          
             CLOSE r150_oox07                                                                                                       
             IF NOT cl_null(l_apa14) THEN                                                                                           
                EXIT FOREACH                                                                                                        
             ELSE                                                                                                                   
                CONTINUE FOREACH                                                                                                    
             END IF                                                                                                                 
          END FOREACH                                                                                                               
      END IF                                                                                                                        
      IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN                                                                            
         #LET sr.apa34 = sr.apa34f * l_apa14  #mark by dengsy170309 #本币=原币*汇率                                                                                         
      END IF                

      IF NOT cl_null(l_apa14) THEN
         LET l_apa14_1 = l_apa14
      ELSE
         LET l_apa14_1=0
         SELECT apa14 INTO l_apa14_1 FROM apa_file
          WHERE apa01=sr.apa01
            AND (apa00='23' OR apa00='25')
         IF cl_null(l_apa14_1) THEN LET l_apa14_1=1 END IF
      END IF
      LET l_aqb04f = cl_digcut(l_aqb04/l_apa14_1,g_azi04)
 
      IF cl_null(sr.apa34f) THEN LET sr.apa34f=0 END IF
      IF cl_null(sr.apa34 ) THEN LET sr.apa34 =0 END IF
      IF cl_null(l_apg05f) THEN LET l_apg05f=0 END IF
      IF cl_null(l_apg05)  THEN LET l_apg05 =0 END IF
      IF cl_null(l_apv04f) THEN LET l_apv04f=0 END IF
      IF cl_null(l_apv04)  THEN LET l_apv04 =0 END IF
 

      LET sr.apa34f = sr.apa34f + l_apg05f + l_apv04f + l_aph05f #No:B072 mark + l_oob09
                                + l_aqb04f   #MOD-8A0192 add
                                + l_alh14  + l_ala95f  #CHI-850030 add
                                + l_aph05f_1           #MOD-B60199 add
      LET sr.apa34  = sr.apa34  + l_apg05  + l_apv04  + l_aph05  #No:B072 mark + l_oob10
                                + l_aqb04    #MOD-8A0192 add
                                + l_alh16  + l_ala95   #CHI-850030 add
                                + l_aph05_1            #MOD-B60199 add
      #IF sr.apa34f =0 THEN CONTINUE FOREACH END IF  #CHI-850030 add  #mark by dengsy170410
      IF sr.apa34f =0 AND sr.apa34 =0 THEN CONTINUE FOREACH END IF    #add by dengsy170410   
      IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN   #MOD-9C0030                         
         #LET sr.apa34 = sr.apa34f * l_apa14  #mark by dengsy170309 #本币=原币*汇率                                                                                          
      END IF                                                                                                                        
 
      IF sr.apa00[1,1] = '2' THEN
         LET sr.apa34f = sr.apa34f * -1
         LET sr.apa34  = sr.apa34  * -1
      END IF
 
      IF sr.apa54 IS NULL THEN
         LET sr.apa54=' '
      END IF
 
      #抓取傳票編號(參考saapt110的t110_show_ref()段,根據不同的apa00抓法不同)
      CALL r150_apa44_ref(sr.*) RETURNING sr.apa44   #MOD-880086 add

      #CHI-AB0019 add --start--
      IF sr.apa74='O' THEN  #外購
         SELECT ala22 INTO l_ala22 FROM ala_file WHERE ala01=sr.apa01
         LET sr.apa12 =  sr.apa12 + l_ala22 
      END IF
      #CHI-AB0019 add --end--

      #CHI-AB0004 add --start--
      IF sr.apa74 MATCHES "[RO]" THEN
         LET sr.apc02 =''
      END IF
      #CHI-AB0004 add --end--
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file
             WHERE azi01=sr.apa13
      EXECUTE insert_prep USING
         sr.apa02,sr.apa44,sr.apa01,sr.apa06,sr.apa07,
         sr.apa25,sr.apc02,sr.apa12,sr.apa13,sr.apa34f,sr.apa34,sr.apa54, #CHI-AB0019 add apa12 #CHI-AB0004 add apc02
         sr.aag02,t_azi03,t_azi04,t_azi05
   END FOREACH
 

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05='Y' THEN 
      CALL cl_wcchp(tm.wc,'apa01,apa06,apa54,apa44')
           RETURNING tm.wc
      LET g_str=tm.wc
   END IF
   LET g_str = g_str,";",tm.e_date,";",g_azi04,";",g_azi05,";",
               tm.u[1,1],';',tm.u[2,2],';',tm.u[3,3],';',   #FUN-940027
               tm.t[1,1],';',tm.t[2,2],';',tm.t[3,3],';',   #FUN-940027
               tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3]        #FUN-940027
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aapr150','aapr150',l_sql,g_str)
 #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
 
FUNCTION r150_apa44_ref(sr)
   DEFINE f_apa    RECORD LIKE apa_file.*
   DEFINE f_apv    RECORD LIKE apv_file.*
   DEFINE f_apf    RECORD LIKE apf_file.*
   DEFINE f_apg    RECORD LIKE apg_file.*
   DEFINE f_aph    RECORD LIKE aph_file.*
   DEFINE l_sql    STRING
   DEFINE sr       RECORD
                    apa00  LIKE apa_file.apa00,    #帳款類別
                    apa01  LIKE apa_file.apa01,    #帳款編號
                    apa02  LIKE apa_file.apa02,    #帳款日期
                    apa06  LIKE apa_file.apa06,    #廠商編號
                    apa07  LIKE apa_file.apa07,    #廠商簡稱
                    apa08  LIKE apa_file.apa08,    #發票號碼
                    apa58  LIKE apa_file.apa58,    #折讓性質
                    apc02  LIKE apc_file.apc02,    #子帳期項次 #CHI-AB0004 add
                    apa12  LIKE apa_file.apa12,    #付款日期   #CHI-AB0019 add
                    apa13  LIKE apa_file.apa13,    #幣別
                    apa25  LIKE apa_file.apa25,    #摘要
                    apa44  LIKE apa_file.apa44,    #傳票編號
                    apa54  LIKE apa_file.apa54,    #會計科目
                    aag02  LIKE aag_file.aag02,    #科目名稱
                    apa34f LIKE apa_file.apa34f,   #原幣金額
                    apa34  LIKE apa_file.apa34,    #本幣金額    #CHI-850030 add ,
                    apa74  LIKE apa_file.apa74     #外購付款否  #CHI-850030 add
                   END RECORD
 
   LET l_sql = "SELECT * FROM apa_file WHERE apa01 = ? "
   PREPARE apa44_ref_p1 FROM l_sql
   DECLARE apa44_ref_c1 CURSOR FOR apa44_ref_p1
 
   LET l_sql = "SELECT apa_file.* ",
               "  FROM apv_file,apa_file ",
               " WHERE apv03 = ? ",
               "   AND apv01 = apa01 "
   PREPARE apa44_ref_p2 FROM l_sql
   DECLARE apa44_ref_c2 CURSOR FOR apa44_ref_p2
 
   LET l_sql = "SELECT apf_file.* ",
               "  FROM apf_file,aph_file ",
               " WHERE aph04 = ? ",
               "   AND apf01 = aph01 "
   PREPARE apa44_ref_p3 FROM l_sql
   DECLARE apa44_ref_c3 CURSOR FOR apa44_ref_p3
 
   #折讓處理
   IF sr.apa00 = '21' THEN
      IF sr.apa58 = '1' THEN                   #請款折讓
         OPEN apa44_ref_c1 USING sr.apa08
         FETCH apa44_ref_c1 INTO f_apa.*
         IF STATUS THEN
            SLEEP 0
         ELSE
            LET sr.apa44 = f_apa.apa44
         END IF
         CLOSE apa44_ref_c1
      ELSE
         OPEN apa44_ref_c2  USING sr.apa01
         FETCH apa44_ref_c2 INTO f_apa.*
         IF STATUS THEN
            OPEN apa44_ref_c3 USING sr.apa01
            FETCH apa44_ref_c3 INTO f_apf.*
            IF STATUS THEN
               SLEEP 0
            ELSE
               #no.    若aapt210本身沒有拋轉傳票才 show aapt330所拋的傳票
               IF cl_null(sr.apa44) THEN
                  LET sr.apa44 = f_apf.apf44
               END IF
            END IF
            CLOSE apa44_ref_c3
         ELSE
            IF cl_null(sr.apa44) THEN         #No:9383
               LET sr.apa44 = f_apa.apa44
            END IF
         END IF
         CLOSE apa44_ref_c2
      END IF
   END IF
 
   IF (sr.apa00 = '23' OR sr.apa00 = '25') THEN     #SE 單 #No.FUN-690080
      OPEN apa44_ref_c1 USING sr.apa08
      FETCH apa44_ref_c1 INTO f_apa.*
      IF STATUS THEN
         SLEEP 0
      ELSE
         LET sr.apa44 = f_apa.apa44
      END IF
      CLOSE apa44_ref_c1
   END IF
 
   IF sr.apa00 = '22' THEN                        #DM 單
      OPEN apa44_ref_c2 USING sr.apa01
      FETCH apa44_ref_c2 INTO f_apa.*
      IF STATUS THEN
         OPEN apa44_ref_c3 USING sr.apa01
         FETCH apa44_ref_c3 INTO f_apf.*
         IF STATUS THEN
            SLEEP 0
         ELSE
            #no.    若aapt220本身沒有拋轉傳票才 show aapt330所拋的傳票
            IF cl_null(sr.apa44) THEN
               LET sr.apa44 = f_apf.apf44
            END IF
         END IF
         CLOSE apa44_ref_c3
      ELSE 
         IF cl_null(sr.apa44) THEN
            LET sr.apa44 = f_apa.apa44
         END IF
      END IF
      CLOSE apa44_ref_c2
   END IF
 
   RETURN sr.apa44
 
END FUNCTION
 
#No.FUN-9C0077 程式精簡
