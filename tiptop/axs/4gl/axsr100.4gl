# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: axsr100.4gl
# Descriptions...: 銷售排名表
# Date & Author..: 95/04/10 By Danny
# Modify.........: 95/07/14 By Danny  (出貨數量/金額扣除銷退數量/金額)
# Modify.........: 97-04-21 By Joanne 前幾名列印完後, 剩餘彙總一筆 other
# Modify.........: No:9470 04/04/16 Melody 1.表頭幣別不會show本幣，請先判斷tm.ch
#                                          2.Print sr.order1，sr.order2,sr.order
# Modify.........: No.MOD-4A0325 04/10/27 By Mandy 當選擇3.出貨實際 所組的SQL有誤
# Modify.........: No.MOD-530211 05/03/23 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.MOD-530536 05/03/29 By kim 百分比列印size加大
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 新增地區欄位
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-580013 05/08/18 By vivien 報表轉XML格式
# Modify.........: No.MOD-5A0082 05/10/21 By Nicola 查詢輸入方式修改
# Modify.........: No.MOD-5B0169 05/11/22 By Rosayu join ima_file=> OUTER ima_file
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0095 06/11/14 By xumin 報表寬度不符問題修改
# Modify.........: No.TQC-6C0119 06/12/20 By Ray 表頭調整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740015 07/04/04 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.MOD-780043 07/08/09 By Carol oga09加上類別'6'
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.MOD-7B0181 07/11/21 By Pengu 輸入條件選項後按確定,出現-201錯誤訊息
# Modify.........: No.MOD-810251 08/02/26 By Pengu 取消UI畫面tm.a1的輸入
# Modify.........: No.MOD-880226 08/08/27 By chenl 修改字符替換寫法。
# Modify.........: No.MOD-8A0246 08/11/15 By Pengu 連續列印時表頭的其間日期會異常
# Modify.........: No.MOD-8A0105 08/11/15 By Pengu 下某些條件執行時整個程式會跳掉
# Modify.........: No.MOD-950018 09/05/05 By Smapmin 營運中心欄位應加上營運中心使用權限判斷
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.CHI-950025 09/06/24 By mike 報表篩選條件的更動  
# Modify.........: No.MOD-970174 09/07/24 By Smapmin 走出貨簽收流程,未簽收前不可納入銷貨收入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/08 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/18 By baofei GP5.2跨DB報表--財務類 
# Modify.........: No.TQC-A50147 10/05/25 By Carrier main结构调整 & FUN-830159 追单
# Modify.........: No:CHI-A60005 10/06/22 By Summer 條件式有oga09就加上'A'的類別
# Modify.........: No:MOD-B30581 11/03/17 By Summer 若報表條件有勾選"出貨數量/金額 扣除 銷退數量/金額"，銷退部分不加客戶簽收判斷 
# Modify.........: No:MOD-B70074 11/07/08 By JoHung 銷退部分排除借貸還量
# Modify.........: No.FUN-B80059 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90090 11/09/14 By Sakura QBE及排序增加其他分群碼一二三
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-BB0155 12/01/17 By Vampire 明細金額需在程式段就先取位，以避免到了rpt段時造成明細金額加總與總計不合
# Modify.........: No.MOD-C20056 12/02/09 By jt_chen 銷退部分排除借貸還量(補修正 調整拿掉oga09)
# Modify.........: No.MOD-BB0241 12/02/17 By bart 還原MOD-810251 
# Modify.........: No.MOD-D30137 13/03/15 By Vampire 在 axsr100() 主FOREACH 迴圈加上 tm.pr 的筆數判斷
# Modify.........: No.MOD-D30276 13/04/01 By Elise tm.wc,tm.wc2型態調整為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_sql string                             #No.FUN-580092 HCN
   DEFINE tm  RECORD                               # Print condition RECORD
             #wc      LIKE type_file.chr1000,      # Where condition    #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark  
              wc      STRING,                      #MOD-D30276
             #wc2     LIKE type_file.chr1000,      # Where condition    #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark
              wc2     STRING,                      #MOD-D30276 
              s       LIKE type_file.chr4,         # Order by sequence  #No.FUN-680130 VARCHAR(4)
              a1      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              b1      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              y1      LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m1b,m1e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              pr      LIKE type_file.num10,        #No.FUN-680130 INTEGER 
              ch      LIKE type_file.chr1,         #No.FUN-740015 
              z       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              w       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1) 
              y       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              more    LIKE type_file.chr1          # Input more condition(Y/N)   #No.FUN-680130 VARCHAR(1)
              END RECORD,
          sr  RECORD order1 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)              #FUN-560011
                     order2 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)              #FUN-560011
                     order3 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)              #FUN-560011
                     gem02  LIKE gem_file.gem02,   #部門名稱
                     gen02  LIKE gen_file.gen02,   #人員名稱
                     oab02  LIKE oab_file.oab02,   #銷售名稱
                     oea26  LIKE oea_file.oea26,   #銷售分類二
                     oea032 LIKE oea_file.oea032,  #帳款客戶名稱
                     oca02  LIKE oca_file.oca02,   #客戶分類
                     oea04  LIKE oea_file.oea04,   #送貨客戶
                     oea23  LIKE oea_file.oea23,   #幣別
                     oea24  LIKE oea_file.oea24,   #匯率
                     amt1   LIKE oea_file.oea61,   #金額
                     amt2   LIKE oea_file.oea61,
                     oea15  LIKE oea_file.oea15,   #部門編號
                     oea14  LIKE oea_file.oea14,   #人員編號
                     oea25  LIKE oea_file.oea25,   #銷售分類一
                     oea03  LIKE oea_file.oea03,   #帳款客戶
                     oca01  LIKE oca_file.oca01,   #帳款客戶分類
                     ima131 LIKE ima_file.ima131,  #產品分類
                     ima06  LIKE ima_file.ima06,   #主要分群碼
                     azp01  LIKE azp_file.azp01,
                     oeb04  LIKE oeb_file.oeb04
              END RECORD,
          g_order           LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(60)
          g_buf             LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(10)
          g_str1            LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(04)
          g_str2            LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(08)
          g_str3,g_str4     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(06)
          b_date1,e_date1   LIKE type_file.dat,    #No.FUN-680130 DATE
          g_total           LIKE oea_file.oea61
 
DEFINE   g_chr           LIKE type_file.chr1       #No.FUN-680130 VARCHAR(1)
DEFINE   g_head1         LIKE type_file.chr1000    #No.FUN-680130 VARCHAR(400)
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose  #No.FUN-680130 SMALLINT
DEFINE   i               LIKE type_file.num5       #No.FUN-680130 SMALLINT
DEFINE   l_table         STRING, #FUN-740015###
         g_str           STRING  #FUN-740015###
#FUN-B90090----------add-------str         
DEFINE   g_ima09         LIKE ima_file.ima09,
         g_ima10         LIKE ima_file.ima10,
         g_ima11         LIKE ima_file.ima11
#FUN-B90090----------add-------end
DEFINE   g_cnt           LIKE type_file.num5       #MOD-D30137 add
         
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50147  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.wc2  = ARG_VAL(8)
   LET tm.s    = ARG_VAL(9)
   LET tm.a1   = ARG_VAL(10)
   LET tm.b1   = ARG_VAL(11)
   LET tm.y1   = ARG_VAL(12)
   LET tm.m1b  = ARG_VAL(13)
   LET tm.m1e  = ARG_VAL(14)
   LET tm.ch   = ARG_VAL(15)
   LET tm.pr   = ARG_VAL(16)
   LET tm.z    = ARG_VAL(17)
   LET tm.w    = ARG_VAL(18)
   LET tm.y    = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD #FUN-BB0047 mark
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/04 TSD.liquor *** ##
   LET g_sql  = "order1.oab_file.oab02,",
                "order2.oab_file.oab02,",
                "order3.oab_file.oab02,",
                "count.type_file.num5,",
                "azi05.azi_file.azi05,",   #MOD-BB0155 add
                "amt.oea_file.oea61,",
                "am.qcg_file.qcg06,"
   LET l_table = cl_prt_temptable('axsr100',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-780054
               " VALUES(?, ?, ?, ?, ?, ?, ?)"    #MOD-BB0155 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #No.TQC-A50147  --End  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axsr100_tm(0,0)        # Input print condition
      ELSE CALL axsr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
END MAIN
 
FUNCTION axsr100_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,   #No.FUN-680130 SMALLINT
          l_za05       LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(40)
          l_cmd        LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 10
   END IF
 
   OPEN WINDOW axsr100_w AT p_row,p_col
        WITH FORM "axs/42f/axsr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '26 '
   LET tm.y1   = YEAR(g_today)
   LET tm.m1b  = MONTH(g_today)
   LET tm.m1e  = MONTH(g_today)
   LET tm.a1   = '1'
   LET tm.b1   = '3'
   LET tm.pr   = 99999
   LET tm.ch   = '2'
   LET tm.z    = 'N'
   LET tm.w    = 'Y'
   LET tm.y    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
WHILE TRUE
WHILE TRUE   #No.MOD-5A0082
   CONSTRUCT BY NAME tm.wc ON azp01
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
 
     ON ACTION CONTROLP
        CASE
              WHEN INFIELD(azp01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   #LET g_qryparam.form = "q_azp"   #MOD-950018
                   LET g_qryparam.form = "q_zxy"   #MOD-950018
                   LET g_qryparam.arg1 = g_user   #MOD-950018
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
        END CASE
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      LET tm.wc="azp01='",g_plant,"'"
   END IF
   EXIT WHILE   #No.MOD-5A0082
END WHILE   #No.MOD-5A0082
 
WHILE TRUE   #No.MOD-5A0082

#   CONSTRUCT BY NAME tm.wc2 ON oea15,oea14,oea25,oea26,oea03,oca01,oea04,oea23,ima131, #FUN-B90090 mark
#                               ima06,ima01,occ20,occ21,occ22                           #FUN-B90090 mark
#FUN-B90090----------add-------str
   CONSTRUCT BY NAME tm.wc2 ON oea15,oea14,oea25,oea26,oea03,oca01,oea04,oea23,ima131,
                               ima06,ima01,occ20,occ21,occ22,ima09,ima10,ima11

      ON ACTION controlp
         CASE WHEN INFIELD(ima09) #其他分群碼一
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "D"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima09
                   NEXT FIELD ima09
              WHEN INFIELD(ima10) #其他分群碼二
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "E"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima10
                   NEXT FIELD ima10
              WHEN INFIELD(ima11) #其他分群碼三
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_azf"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.arg1     = "F"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima11
                   NEXT FIELD ima11
              OTHERWISE EXIT CASE
           END CASE
#FUN-B90090----------add-------end

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
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc2 = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   EXIT WHILE   #No.MOD-5A0082
END WHILE   #No.MOD-5A0082
   INPUT BY NAME
                 tm2.s1,tm2.s2,tm2.s3,
                 tm.a1,tm.b1,tm.y1,tm.m1b,tm.m1e,tm.pr,tm.ch, #MOD-BB0241 add tm.a1
                 tm.z,tm.w,tm.y,tm.more WITHOUT DEFAULTS
      AFTER FIELD y1
         IF cl_null(tm.y1) THEN NEXT FIELD y1 END IF
      AFTER FIELD m1b
         IF NOT cl_null(tm.m1b) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1b > 12 OR tm.m1b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1b
               END IF
            ELSE
               IF tm.m1b > 13 OR tm.m1b < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1b
               END IF
            END IF
         END IF
         IF cl_null(tm.m1b) THEN NEXT FIELD m1b END IF
      AFTER FIELD m1e
         IF NOT cl_null(tm.m1e) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1e > 12 OR tm.m1e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1e
               END IF
            ELSE
               IF tm.m1e > 13 OR tm.m1e < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1e
               END IF
            END IF
         END IF
         IF cl_null(tm.m1e) THEN NEXT FIELD m1e END IF
 
      AFTER FIELD ch
         IF cl_null(tm.ch) OR tm.ch NOT MATCHES '[1-2]' THEN
            NEXT FIELD ch
         END IF
      AFTER FIELD pr
         IF cl_null(tm.pr) OR tm.pr <=0 THEN NEXT FIELD pr END IF
      AFTER FIELD z
         IF cl_null(tm.z) OR tm.z NOT MATCHES '[YN]' THEN NEXT FIELD z END IF
      AFTER FIELD w
         IF cl_null(tm.w) OR tm.w NOT MATCHES '[YN]' THEN NEXT FIELD w END IF
      AFTER FIELD y
         IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN NEXT FIELD y END IF
      AFTER FIELD more
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axsr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axsr100','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",    #No.TQC-610090 add
                         " '",tm.s CLIPPED,"'",
                         " '",tm.a1 CLIPPED,"'",
                         " '",tm.b1 CLIPPED,"'",
                         " '",tm.y1 CLIPPED,"'",
                         " '",tm.m1b CLIPPED,"'",
                         " '",tm.m1e CLIPPED,"'",
                         " '",tm.ch CLIPPED,"'",
                         " '",tm.pr CLIPPED,"'",
                         " '",tm.z  CLIPPED,"'" ,
                         " '",tm.w  CLIPPED,"'" ,    #No.TQC-610090 add
                         " '",tm.y  CLIPPED,"'" ,    #No.TQC-610090 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axsr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axsr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axsr100()
   ERROR ""
   DROP TABLE tmp_file
END WHILE
   CLOSE WINDOW axsr100_w
END FUNCTION
 
FUNCTION r100_wc2(p_x)
  DEFINE l_i,l_j  LIKE type_file.num5,        #No.FUN-680130 SMALLINT
         l_buf    LIKE type_file.chr1000,     #tm.wc2之長度  #No.FUN-680130 VARCHAR(1000) 
         p_x      LIKE type_file.chr1         #No.FUN-680130 VARCHAR(01)
 
    LET l_buf=tm.wc2
    LET l_j=length(l_buf) - 2
    IF p_x='2' THEN   #訂單/出貨目標
       FOR l_i=1 TO l_j
           IF l_buf[l_i,l_i+2]='oea' THEN LET l_buf[l_i,l_i+2]='osa' END IF
       END FOR
    END IF
    IF p_x='3' THEN   #出貨實際
       FOR l_i=1 TO l_j
           IF l_buf[l_i,l_i+2]='oea' THEN LET l_buf[l_i,l_i+2]='oga' END IF
       END FOR
    END IF
    RETURN l_buf
END FUNCTION
 
#FUNCTION r100_g_sql(p_azp03,p_b,p_y,p_mb,p_me,p_bdate,p_edate)   #FUN-A10098
FUNCTION r100_g_sql(p_azp01,p_b,p_y,p_mb,p_me,p_bdate,p_edate)   #FUN-A10098
   DEFINE p_azp03   LIKE azp_file.azp03,    #工廠別
          p_azp01   LIKE azp_file.azp01,    #FUN-A10098
          p_b       LIKE type_file.chr1,    #訂單/出貨/目標   #No.FUN-680130 VARCHAR(01)
          p_y       LIKE type_file.num10,   #年別             #No.FUN-680130 INTEGER
          p_mb      LIKE type_file.num10,   #起始期別         #No.FUN-680130 INTEGER
          p_me      LIKE type_file.num10,   #結束期別         #No.FUN-680130 INTEGER
          p_bdate   LIKE type_file.dat,     #起始日期         #No.FUN-680130 DATE
          p_edate   LIKE type_file.dat,     #結束日期         #No.FUN-680130 DATE
          l_wc      LIKE type_file.chr1000                    #No.FUN-680130 VARCHAR(1000)
   IF p_b = '1' THEN #-->訂單實際(oea_file)
      LET g_sql = "SELECT '','','',",
                  "       gem02,gen02,oab02,oea26,oea032,oca02,",
                  "       oea04,oea23,oea24,oeb14,0,oea15,oea14,",
                  "       oea25,oea03,oca01,ima131,ima06,'',oeb04 ",
                  "      ,ima09,ima10,ima11 ", #FUN-B90090 add
#FUN-A10098---BEGIN
#                  "  FROM ",s_dbstring(p_azp03 CLIPPED),"oea_file,",   
#                            s_dbstring(p_azp03 CLIPPED),"oeb_file,", 
#                            s_dbstring(p_azp03 CLIPPED),"occ_file,",  
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"ima_file,",   
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"oca_file,",  
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"gem_file,",  
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"gen_file,",     
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"oab_file ",    
                  "  FROM ",cl_get_target_table(p_azp01,'oeb_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'ima_file')," ON(ima01 = oeb04),",
                   cl_get_target_table(p_azp01,'occ_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oca_file')," ON(oca01 = occ03),",
                  cl_get_target_table(p_azp01,'oea_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gem_file')," ON(gem01 = oea15)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gen_file')," ON(gen01 = oea14)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oab_file')," ON(oab01 = oea25)",       
#FUN-A10098---END
                  " WHERE ",tm.wc2 CLIPPED,
                  "   AND oea02 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                  "   AND oea01 = oeb01 ",
       #           "   AND ima_file.ima01 = oeb_file.oeb04 ",
                  "   AND occ01 = oea03 ",
       #           "   AND oca_file.oca01 = occ_file.occ03 ",
       #           "   AND gem_file.gem01 = oea_file.oea15 ",
       #           "   AND gen_file.gen01 = oea_file.oea14 ",
       #           "   AND oab_file.oab01 = oea_file.oea25 ",
                  "   AND oea00 <> '3A' "  #CHI-950025         
      IF tm.w='Y' THEN
          LET g_sql = g_sql CLIPPED," AND oeaconf='Y' "
      ELSE
          LET g_sql = g_sql CLIPPED," AND oeaconf != 'X' " #01/08/16 mandy
      END IF
   END IF
   IF p_b MATCHES "[24]" THEN #-->訂單/出貨目標(osa_file)
      IF p_b = '2' THEN LET g_chr='1' END IF
      IF p_b = '4' THEN LET g_chr='2' END IF
      CALL r100_wc2('2') RETURNING l_wc
      LET g_sql = "SELECT '','','',",
                  "       gem02,gen02,oab02,osa26,occ02,oca02,",
                  "       osa04,osa23,osa24,osb04,osb05,osa15,osa14,",
                  "       osa25,osa03,oca01,osa90,ima06,'','' ",
                  "      ,ima09,ima10,ima11 ", #FUN-B90090 add
#FUN-A10098---BEGIN
#                  "  FROM ",s_dbstring(p_azp03 CLIPPED),"osa_file,", 
#                            s_dbstring(p_azp03 CLIPPED),"osb_file,",  
#                            s_dbstring(p_azp03 CLIPPED),"occ_file,",    
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"ima_file,",    
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"oca_file,",   
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"gem_file,",  
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"gen_file,",  
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"oab_file ",     
                  "  FROM ",cl_get_target_table(p_azp01,'osb_file'),",",
                            cl_get_target_table(p_azp01,'osa_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'ima_file')," ON(ima131= osa90)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gem_file')," ON(gem01 = osa15)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gen_file')," ON(gen01 = osa14)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oab_file')," ON(oab01 = osa25),",
                            cl_get_target_table(p_azp01,'occ_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oca_file')," ON(oca01 = occ03)",

#FUN-A10098---END
                  " WHERE ",l_wc CLIPPED,
                  "   AND osb01 = osa01 ",
               #   "   AND ima_file.ima131= osa_file.osa90 ",
                  "   AND osb02 = ",p_y,
                  "   AND osb03 BETWEEN ",p_mb," AND ",p_me,
                  "   AND occ01 = osa03 ",
               #   "   AND oca_file.oca01 = occ_file.occ03 ",
               #   "   AND gem_file.gem01 = osa_file.osa15 ",
               #   "   AND gen_file.gen01 = osa_file.osa14 ",
               #   "   AND oab_file.oab01 = osa_file.osa25 ",
                  "   AND osa05 = '",g_chr,"'"          #訂單/出貨
   END IF
   IF p_b='3' THEN #-->出貨實際(oga_file)
      CALL r100_wc2('3') RETURNING l_wc
      LET g_sql = "SELECT '','','',",
                  "       gem02,gen02,oab02,oga26,oga032,oca02,",
                  "       oga04,oga23,oga24,ogb14,0,oga15,oga14,",
                  "       oga25,oga03,oca01,ima131,ima06,'',ogb04 ",
                  "      ,ima09,ima10,ima11 ", #FUN-B90090 add
#FUN-A10098---BEGIN
#                  "  FROM ",s_dbstring(p_azp03 CLIPPED),"oga_file,",   
#                            s_dbstring(p_azp03 CLIPPED),"occ_file,",   
#                            s_dbstring(p_azp03 CLIPPED),"ogb_file,",   
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"ima_file,",    
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"oca_file,",   
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"gem_file,",    
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"gen_file,",  
#                  " OUTER ",s_dbstring(p_azp03 CLIPPED),"oab_file ",    
                  "  FROM ",cl_get_target_table(p_azp01,'oga_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gem_file')," ON(gem01 = oga15)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'gen_file')," ON(gen01 = oga14)",
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oab_file')," ON(oab01 = oga25),",
                            cl_get_target_table(p_azp01,'occ_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'oca_file')," ON(oca01 = occ03),",
                            cl_get_target_table(p_azp01,'ogb_file'),
                  " LEFT OUTER JOIN ",cl_get_target_table(p_azp01,'ima_file')," ON(ima01 = ogb04)",
#FUN-A10098---END
                  " WHERE ",l_wc CLIPPED,
                  "   AND (oga65 != 'Y' OR oga09 = '8')",  #MOD-970174
                 #"   AND oga09 IN ('2','3','4','6','8','A')", #NO:7459 #No.FUN-610079 #MOD-780043 add '6' #CHI-60005 add 'A'       #MOD-C20056 mark
                  "   AND oga09 IN ('2','3','4','8','A')", #NO:7459 #No.FUN-610079 #MOD-780043 add '6' #CHI-60005 add 'A'           #MOD-C20056 modify del '6'
                  "   AND oga02 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                  "   AND oga01 = ogb01 ",
               #   "   AND ima_file.ima01 = ogb_file.ogb04 ",
                  "   AND occ01 = oga03 "
               #   "   AND oca_file.oca01 = occ_file.occ03 ",
               #   "   AND gem_file.gem01 = oga_file.oga15 ",
               #   "   AND gen_file.gen01 = oga_file.oga14 ",
               #   "   AND oab_file.oab01 = oga_file.oga25 "
      IF tm.y='Y' THEN LET g_sql = g_sql CLIPPED," AND ogapost='Y' " END IF
      IF tm.w = 'Y' THEN
          LET g_sql = g_sql CLIPPED, " AND ogaconf = 'Y' "
      ELSE
          LET g_sql = g_sql CLIPPED, " AND ogaconf != 'X' "
      END IF
   END IF
END FUNCTION
 
FUNCTION axsr100()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name       #No.FUN-680130 VARCHAR(20)
          l_azp01   LIKE azp_file.azp01,
          l_azp03   LIKE azp_file.azp03,
          l_date1   LIKE type_file.dat,            #No.FUN-680130 DATE
          l_date2   LIKE type_file.dat,            #No.FUN-680130 DATE
          l_i,l_j   LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_sql     LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(3000)
          l_buf     LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(3000)
          sr1 RECORD order1 LIKE oab_file.oab02,   
                     order2 LIKE oab_file.oab02,   
                     order3 LIKE oab_file.oab02,   
                     order  LIKE oea_file.oea61,   
                     azi05   LIKE azi_file.azi05,   #MOD-BB0155 add
                     count  LIKE type_file.num5,   
                     amt    LIKE oea_file.oea61
              END RECORD,
          l_am       LIKE qcg_file.qcg06,
          l_lc       LIKE type_file.num5,   
          l_count    LIKE type_file.num5,   
          l_lamt     LIKE oea_file.oea61  
DEFINE    buf        base.StringBuffer      #No.MOD-880226
DEFINE    l_azi04    LIKE azi_file.azi04    #MOD-BB0155 add 
DEFINE    l_azi05    LIKE azi_file.azi05    #MOD-BB0155 add 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740015 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
     CALL s_azn01(tm.y1,tm.m1b) RETURNING b_date1,l_date1
     CALL s_azn01(tm.y1,tm.m1e) RETURNING l_date2,e_date1
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql ="SELECT azp01,azp03 FROM azp_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND azp01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01='",g_user,"') ",   #MOD-950018
                "   AND azp053 != 'N' " #no.7431
     PREPARE azp_pr FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('azp_pr',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
        EXIT PROGRAM 
     END IF
     DECLARE azp_cur CURSOR FOR azp_pr
     CREATE TEMP TABLE tmp_file
            ( order1    LIKE oab_file.oab02,  
              order2    LIKE oab_file.oab02,  
              order3    LIKE oab_file.oab02,  
              amt      LIKE oea_file.oea61,
              azi05     LIKE azi_file.azi05)   #MOD-BB0155 add
     DELETE FROM tmp_file
     DECLARE tmp_curs CURSOR FOR
        SELECT order1,order2,order3,0,azi05,COUNT(*),SUM(amt)   #MOD-BB0155 add azi05
        FROM tmp_file
        GROUP BY order1,order2,order3,azi05                    #MOD-BB0155 add azi05
     IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
        EXIT PROGRAM 
     END IF
 
#    CALL cl_outnam('axsr100') RETURNING l_name   #No.TQC-A50147
         FOREACH azp_cur INTO l_azp01,l_azp03 
           IF STATUS THEN 
              CALL cl_err('azp_cur',STATUS,0) 
              EXIT FOREACH 
           END IF 
           FOR i=1 TO 2 
             IF i=2 AND tm.b1 !='3' THEN 
                EXIT FOR 
             END IF
         IF i=2 AND tm.b1='3' AND tm.z='N' THEN EXIT FOR END IF

         #MOD-BB0155 ----- start -----
         LET l_sql = "SELECT azi04,azi05 ",
                     "  FROM ",cl_get_target_table(l_azp01, 'azi_file'),
                     " WHERE azi01=? "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
         PREPARE azi_prepare FROM l_sql
         DECLARE azi_c CURSOR FOR azi_prepare
         #MOD-BB0155 -----  end  ----- 
         
#         CALL r100_g_sql(l_azp03,tm.b1,tm.y1,tm.m1b,tm.m1e,b_date1,e_date1) #FUN-A10098
         CALL r100_g_sql(l_azp01,tm.b1,tm.y1,tm.m1b,tm.m1e,b_date1,e_date1)  #FUN-A10098
         IF i=2 AND tm.b1 ='3' AND tm.z ='Y' THEN
            LET buf = base.StringBuffer.create()
            CALL buf.clear()
            CALL buf.append(g_sql)
#           LET l_buf = "AND oga09 IN ('2','3','4','6','8','A')" #CHI-A60005 add 'A'   #MOD-B70074 mark
            LET l_buf = "AND oga09 IN ('2','3','4','8','A')"     #MOD-B70074
            CALL buf.replace(l_buf," AND 1=1 ",0)
            #MOD-B30581 add --start--
            LET l_buf = "   AND (oga65 != 'Y' OR oga09 = '8')"
            CALL buf.replace(l_buf," AND 1=1 ",0)
            #MOD-B30581 add --end--
            CALL buf.replace("oga","oha",0)
            CALL buf.replace("ogb","ohb",0)
            LET g_sql = buf.toString()
         END IF
          IF i=1 AND tm.b1 = '3' THEN                                    #MOD-4A0325
             LET g_sql=g_sql CLIPPED," AND oga00 NOT IN ('A','3','7') "                #MOD-4A0325
         END IF
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING  g_sql   #FUN-A10098
         PREPARE r100_p1 FROM g_sql
         IF STATUS THEN CALL cl_err('prepare #2',STATUS,1) EXIT PROGRAM END IF
         DECLARE r100_c1 CURSOR FOR r100_p1
         #FOREACH r100_c1 INTO sr.*                        #FUN-B90090 mark
         FOREACH r100_c1 INTO sr.*,g_ima09,g_ima10,g_ima11 #FUN-B90090 add
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #1',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
              IF tm.b1='2' OR tm.b1='4' THEN   #訂單/出貨目標
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt2 END IF
              ELSE
                 IF tm.ch='2' THEN LET sr.amt1=sr.amt1*sr.oea24 END IF  #本幣
              END IF
              LET sr.amt2=0
              IF cl_null(sr.amt1) THEN LET sr.amt1=0 END IF
              #MOD-BB0155 ----- start -----
              IF tm.ch='2' THEN
                 LET l_azi04 = g_azi04   
                 LET l_azi05 = g_azi05   
              ELSE
                 OPEN azi_c USING sr.oea23
                 FETCH azi_c INTO l_azi04,l_azi05
              END IF
              CALL cl_digcut(sr.amt1,l_azi04) RETURNiNG sr.amt1
              #MOD-BB0155 -----  end  -----
              #銷退
              IF i=2 AND tm.b1='3' AND tm.z='Y' THEN
                 LET sr.amt1 = sr.amt1 * -1
              END IF
              LET sr.azp01=l_azp01
              #CALL r100_case()       #FUN-B90090 mark
              CALL r100_case(l_azp03) #FUN-B90090 add
              INSERT INTO tmp_file
                         VALUES(sr.order1,sr.order2,sr.order3,sr.amt1,l_azi05)   #MOD-BB0155 add l_azi05
              IF STATUS THEN
                 CALL cl_err3("ins","tmp_file",sr.order1,sr.order2,STATUS,"","INS-tmp",1)   #No.FUN-660155
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
         END FOREACH
       END FOR
     END FOREACH
 
     LET g_pageno = 0
     LET g_total=0
     LET l_i=0
     LET g_cnt = 1 #MOD-D30137 add
     FOREACH tmp_curs INTO sr1.*
         LET g_total = g_total+ sr1.amt
     END FOREACH
     FOREACH tmp_curs INTO sr1.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,0) EXIT FOREACH END IF
        #MOD-D30137 add start -----
         IF g_cnt > tm.pr THEN
            EXIT FOREACH
         END IF
        #MOD-D30137 add end   -----
         IF cl_null(sr1.amt) THEN LET sr1.amt=0 END IF
         LET sr1.order = 999999999 - sr1.amt
         IF cl_null(sr1.order) THEN LET sr1.order=0 END IF
         LET l_count=l_count+sr1.count
         IF g_total =0 OR sr1.amt =0
          THEN LET l_am=0
          ELSE LET l_am=sr1.amt/g_total*100
         END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
           EXECUTE insert_prep USING 
             sr1.order1,sr1.order2,sr1.order3,sr1.count,sr1.azi05,   #MOD-BB0155 add sr1.azi05
             sr1.amt,l_am 
         #------------------------------ CR (3) ------------------------------#
         LET g_cnt = g_cnt + 1 #MOD-D30137 add
     END FOREACH
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = NULL    #No.MOD-8A0246 add
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gem02,gen02,oab02,oea26,oea032,oca02,oea04,oea23,oea24,
                    oea61,oea15,oea14,oea25,oea03,oca01,ima131,ima06,azp01,oeb04
                   ,ima09,ima10,ima11') #FUN-B90090 add 
           RETURNING tm.wc
      CALL cl_wcchp(tm.wc2,'gem02,gen02,oab02,oea26,oea032,oca02,oea04,oea23,oea24,
                    oea61,oea15,oea14,oea25,oea03,oca01,ima131,ima06,azp01,oeb04
                   ,ima09,ima10,ima11') #FUN-B90090 add 
           RETURNING tm.wc2
      LET g_str = tm.wc,tm.wc2
   END IF
  #LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.b1[1,1],";",tm.ch,";",b_date1,";",e_date1            #MOD-BB0241 mark
   LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.a1[1,1],tm.b1[1,1],";",tm.ch,";",b_date1,";",e_date1 #MOD-BB0241
   CALL cl_prt_cs3('axsr100','axsr100',l_sql,g_str)  
   #------------------------------ CR (4) ------------------------------#
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#FUNCTION r100_case()       #FUN-B90090 mark
FUNCTION r100_case(p_azp01) #FUN-B90090 add
  DEFINE l_order   ARRAY[5] OF LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40) #FUN-560011
         l_oab02   LIKE oab_file.oab02,
         l_occ02   LIKE occ_file.occ02,
         l_occ20   LIKE occ_file.occ20,
         l_occ21   LIKE occ_file.occ21,
         l_occ22   LIKE occ_file.occ22   #FUN-550091
  DEFINE p_azp01   LIKE azp_file.azp03,  #FUN-B90090 add
         l_azf03_1 LIKE azf_file.azf03,  #FUN-B90090 add
         l_azf03_2 LIKE azf_file.azf03,  #FUN-B90090 add
         l_azf03_3 LIKE azf_file.azf03,  #FUN-B90090 add
         l_sql     STRING                #FUN-B90090 add
 
     LET g_order=''
     FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azp01
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gem02
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.gen02
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oab02
              WHEN tm.s[g_i,g_i] = '5'
                   SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01=sr.oea26
                   IF STATUS THEN LET l_oab02='' END IF
                   LET l_order[g_i] = l_oab02
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oea032
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oca02
              WHEN tm.s[g_i,g_i] = '8'
                   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oea04
                   IF STATUS THEN LET l_occ02='' END IF
                   LET l_order[g_i] = l_occ02
              WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oea23
              WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.ima131
              WHEN tm.s[g_i,g_i] = 'b' LET l_order[g_i] = sr.ima06
              WHEN tm.s[g_i,g_i] = 'c' LET l_order[g_i] = sr.oeb04
              WHEN tm.s[g_i,g_i] = 'd'
                   SELECT occ20 INTO l_occ20 FROM occ_file
                   IF STATUS THEN LET l_occ20='' END IF
                   LET l_order[g_i] = l_occ20
              WHEN tm.s[g_i,g_i] = 'e'
                   SELECT occ21 INTO l_occ21 FROM occ_file
                    WHERE occ01=sr.oea04
                    IF STATUS THEN LET l_occ21='' END IF
                   LET l_order[g_i] = l_occ21
              WHEN tm.s[g_i,g_i] = 'f'
                   SELECT occ22 INTO l_occ22 FROM occ_file
                    WHERE occ01=sr.oea04
                    IF STATUS THEN LET l_occ22='' END IF
                   LET l_order[g_i] = l_occ22
#FUN-B90090----------add-------str
              WHEN tm.s[g_i,g_i] = 'g'
                   LET l_sql = "SELECT azf03 FROM ",s_dbstring(p_azp01) CLIPPED,"azf_file",
                               " WHERE azf01 = '",g_ima09,"'",
                               "   AND azf02 = 'D' AND azfacti = 'Y' "
                   PREPARE sel_azf03_pre1 FROM l_sql
                   DECLARE sel_azf03_cs1 CURSOR FOR sel_azf03_pre1
                   OPEN sel_azf03_cs1
                   FETCH sel_azf03_cs1 INTO l_azf03_1
                   CLOSE sel_azf03_cs1
                   IF STATUS THEN LET l_azf03_1 = '' END IF
                   LET l_order[g_i] = l_azf03_1
              WHEN tm.s[g_i,g_i] = 'h'
                   LET l_sql = "SELECT azf03 FROM ",s_dbstring(p_azp01) CLIPPED,"azf_file",
                               " WHERE azf01 = '",g_ima10,"'",
                               "   AND azf02 = 'E' AND azfacti = 'Y' "
                   PREPARE sel_azf03_pre2 FROM l_sql
                   DECLARE sel_azf03_cs2 CURSOR FOR sel_azf03_pre2
                   OPEN sel_azf03_cs2
                   FETCH sel_azf03_cs2 INTO l_azf03_2
                   CLOSE sel_azf03_cs2
                   IF STATUS THEN LET l_azf03_2 = '' END IF
                   LET l_order[g_i] = l_azf03_2
              WHEN tm.s[g_i,g_i] = 'i'
                   LET l_sql = "SELECT azf03 FROM ",s_dbstring(p_azp01) CLIPPED,"azf_file",
                               " WHERE azf01 = '",g_ima11,"'",
                               "   AND azf02 = 'F' AND azfacti = 'Y' "
                   PREPARE sel_azf03_pre3 FROM l_sql
                   DECLARE sel_azf03_cs3 CURSOR FOR sel_azf03_pre3
                   OPEN sel_azf03_cs3
                   FETCH sel_azf03_cs3 INTO l_azf03_3
                   CLOSE sel_azf03_cs3
                   IF STATUS THEN LET l_azf03_3 = '' END IF
                   LET l_order[g_i] = l_azf03_3
#FUN-B90090----------add-------end                   
             OTHERWISE LET l_order[g_i] = ''
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
END FUNCTION
#No.FUN-9C0072 精簡程式碼
