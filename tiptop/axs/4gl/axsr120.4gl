# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: axsr120.4gl
# Descriptions...: 銷售統計表
# Date & Author..: 95/04/24 By Danny
# Modify.........: No:7845 03/08/20 Carol 將退貨的處理方式為"2"換貨出貨
#                                         的訂單金額不應納入計算
# Modify.........: No.MOD-4C0074 04/12/13 By Mandy SQL 段的 oca_file 應該用 OUTER ，以免客戶主檔未分類者會撈不到資料。
# Modify.........: No.FUN-550072 05/05/23 By Will 單據編號放大
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 新增地區欄位
# Modify.........: No.FUN-580013 05/08/18 By vivien 報表轉XML格式
# Modify.........: NO.MOD-5A0090 05/10/11 By Rosayu 排列順序選幣別 後,整個程式會跳開
# Modify.........: No.MOD-5A0080 05/10/21 By Nicola 查詢輸入方式修改
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0064 06/11/14 By Carrier 長度為CHAR(21)的azp03定義改為type_file.chr21
# Modify.........: No.TQC-6C0119 06/12/20 By Ray 1.表頭調整
#                                                2.增加check數量單位是否存在于gfe_file及是否有效
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740015 07/04/12 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.MOD-750028 07/05/08 By Carol 調整SQL語法->有關單別取位的處理
# Modify.........: No.MOD-750028 07/05/08 By Carol FUN-550072未調整到.ora的SQL語法
# Modify.........: No.TQC-870002 08/07/01 By lumx  修改替換字符的寫法 避免在UTF8下程序down出
# Modify.........: No.CHI-870001 08/07/22 By Smapmin 走出貨簽收流程,未簽收前不可納入銷貨收入
# Modify.........: No.CHI-870039 08/07/24 By xiaofeizhu 抓oga_file資料時，排除oga00=A的資料
# Modify.........: No.MOD-940121 09/04/14 by Smapmin 換貨出貨的出貨也應該納入計算
# Modify.........: No.MOD-950018 09/05/05 By Smapmin 營運中心欄位應加上營運中心使用權限判斷
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法     
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入
# Modify.........: No.CHI-950025 09/06/24 By mike 報表篩選條件更動     
# Modify.........: No.MOD-980040 09/08/06 By mike 清空g_str             
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990046 09/09/11 By Smapmin order4未給值
# Modify.........: No.FUN-980059 09/09/11 By arman GP5.2架構,修改SUB傳入參數
# Modify.........: No.FUN-9A0100 09/10/30 By liuxqa 标准SQL修改。
# Modify.........: No:MOD-9B0025 09/11/04 By Smapmin 無法設定背景執行
# Modify.........: No.FUN-9C0072 10/01/08 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/21 By wuxj GP5.2 跨DB 報表 財務類 ，修改
# Modify.........: No.TQC-A50147 10/05/25 By Carrier main中结构调整 & MOD-A30167 追单
# Modify.........: No:CHI-A60005 10/06/22 By Summer 條件式有oga09就加上'A'的類別
# Modify.........: No:MOD-A80201 10/08/31 By Smapmin 要納入oga00='2'的資料
# Modify.........: No:FUN-AB0100 10/11/24 By rainy 修正FUN-980059錯誤
# Modify.........: No:FUN-B30158 11/03/30 By Suncx 報表增加列印品名和規格欄位
# Modify.........: No.FUN-B80059 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-B90090 11/09/14 By Sakura QBE及排序增加其他分群碼一二三
# Modify.........: No:MOD-B40244 11/10/11 By Smapmin 跨不同幣別的營運中心時,明細/小計與總計會有錯
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-BB0155 12/01/17 By Vampire 明細金額需在程式段就先取位，以避免到了rpt段時造成明細金額加總與總計不合
# Modify.........: No.MOD-C40186 12/04/24 By Vampire CALL cl_wcchp() RETURNING tm.wc少了tm.wc2
# Modify.........: No.MOD-D30276 13/04/01 By Elise tm.wc,tm.wc2型態調整為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_sql,l_sql string                       #No.FUN-580092 HCN
   DEFINE tm  RECORD                               # Print condition RECORD
             #wc      LIKE type_file.chr1000,      # Where condition    #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark
              wc      STRING,                      #MOD-D30276
             #wc2     LIKE type_file.chr1000,      # Where condition    #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark
              wc2     STRING,                      #MOD-D30276
              s       LIKE type_file.chr4,         #No.FUN-680130 VARCHAR(4)
              t       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              u       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              unit    LIKE ima_file.ima25,         #No.FUN-680130 VARCHAR(4)
              y1      LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m1b,m1e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              ch      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              x       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              y       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              more    LIKE type_file.chr1          # Input more condition(Y/N)    #No.FUN-680130 VARCHAR(1)
              END RECORD,
          g_order           LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(60)
          g_buf             LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(10)
          g_str1,g_str2     LIKE type_file.chr8,   #No.FUN-680130 VARCHAR(8)
          g_str3,g_str4     LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(20)
          b_date,e_date     LIKE type_file.dat,    #No.FUN-680130 DATE
          l_azi03           LIKE azi_file.azi03,   #
          l_azi04           LIKE azi_file.azi04,   #
          l_azi05           LIKE azi_file.azi05,   #
          g_total           LIKE oga_file.oga50,
          g_total1,g_total2 LIKE oga_file.oga50
 
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose  #No.FUN-680130 SMALLINT
DEFINE   g_head1         LIKE type_file.chr1000    #No.FUN-680130 VARCHAR(400)
DEFINE l_table     STRING   #MOD-9B0025
DEFINE g_str       STRING                       ### FUN-740015 add ###
DEFINE buf     base.StringBuffer    #TQC-870002
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
   LET tm.t    = ARG_VAL(10)
   LET tm.u    = ARG_VAL(11)
   LET tm.y1   = ARG_VAL(12)
   LET tm.m1b  = ARG_VAL(13)
   LET tm.m1e  = ARG_VAL(14)
   LET tm.ch   = ARG_VAL(15)
   LET tm.x    = ARG_VAL(16)
   LET tm.unit = ARG_VAL(17)
   LET tm.y    = ARG_VAL(18)
   LET g_rep_user = ARG_VAL(19)
   LET g_rep_clas = ARG_VAL(20)
   LET g_template = ARG_VAL(21)
   LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD #FUN-BB0047 mark
 
# *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/12 *** ##
     LET g_sql = "order1.oab_file.oab02,",
                 "order2.oab_file.oab02,",
                 "order3.oab_file.oab02,",
                 "order4.oab_file.oab02,",
                 "gem02.gem_file.gem02,",     #部門名稱
                 "gen02.gen_file.gen02,",     #人員名稱
                 "oab02.oab_file.oab02,",     #銷售名稱
                 "oga26.oga_file.oga26,",     #銷售分類二
                 "oga032.oga_file.oga032,",   #帳款客戶名稱
                 "oca02.oca_file.oca02,",     #客戶分類
                 "oga04.oga_file.oga04,",     #送貨客戶
                 "oga23.oga_file.oga23,",     #幣別
                 "oga24.oga_file.oga24,",     #匯率
                 "ogb14.ogb_file.ogb14,",     #金額
                 "oga15.oga_file.oga15,",     #部門編號
                 "oga14.oga_file.oga14,",     #人員編號
                 "oga25.oga_file.oga25,",     #銷售分類一
                 "oga03.oga_file.oga03,",     #帳款客戶
                 "oca01.oca_file.oca01,",     #帳款客戶分類
                 "ima131.ima_file.ima131,",   #產品分類
                 "ima06.ima_file.ima06,",     #主要分群碼
                 "azp01.azp_file.azp01,",     #工廠編號
                 "ogb04.ogb_file.ogb04,",     #料件編號
                 "ima02.ima_file.ima02,",     #品名      #FUN-B30158 add
                 "ima021.ima_file.ima021,",   #規格      #FUN-B30158 add
                 "ogb05.ogb_file.ogb05,",     #銷售單位
                 "ogb12.ogb_file.ogb12,",     #數量
                 "l_oab02.oab_file.oab02,",    
                 "occ02.occ_file.occ02,",   
                 "occ20.occ_file.occ20,",    
                 "occ21.occ_file.occ21,",   
                 "occ22.occ_file.occ22,",
                 "azi04.azi_file.azi04,",
                 "azi05.azi_file.azi05,",
                 "curr.oga_file.oga24,",    #MOD-B40244
                 #FUN-B90090----------add-------str
                 "azf03_1.azf_file.azf03,",
                 "azf03_2.azf_file.azf03,",
                 "azf03_3.azf_file.azf03"
                 #FUN-B90090----------add-------end
 
    LET l_table = cl_prt_temptable('axsr120',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,? ,?,?,?,?,?,
                         ?,?,?,?,? ,?,?,?,?,?,
                         ?,?,?,?,? ,?,?,?,?,?,
                         ?,?,?,?,? ,?,?,?)"     #FUN-B30158 add ?,?   #MOD-B40244 add ? #FUN-B90090 add 3?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
   #No.TQC-A50147  --End  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axsr120_tm(0,0)        # Input print condition
      ELSE CALL axsr120()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
END MAIN
 
FUNCTION axsr120_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,       #No.FUN-680130 SMALLINT
          l_za05       LIKE type_file.chr1000,    #No.FUN-680130 VARCHAR(40)
          l_cmd        LIKE type_file.chr1000     #No.FUN-680130 VARCHAR(1000)
   DEFINE l_gfeacti    LIKE gfe_file.gfeacti      #No.TQC-6C0119
 
   LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW axsr120_w AT p_row,p_col
        WITH FORM "axs/42f/axsr120"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '26 '
   LET tm.u    = 'Y  '
   LET tm.y1   = YEAR(g_today)
   LET tm.m1b  = MONTH(g_today)
   LET tm.m1e  = MONTH(g_today)
   LET tm.ch   = '2'
   LET tm.x    = '3'
   LET tm.y    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
WHILE TRUE   #No.MOD-5A0080
   CONSTRUCT BY NAME tm.wc ON azp01
     ON ACTION locale
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      LET tm.wc="azp01='",g_plant,"'"
   END IF
   EXIT WHILE   #No.MOD-5A0080
END WHILE   #No.MOD-5A0080
 
WHILE TRUE   #No.MOD-5A0080
   #CONSTRUCT BY NAME tm.wc2 ON oga15,oga14,oga25,oga26,oga03,oca01,oga04, #FUN-B90090 mark 
   #                            oga23,ima131,ima06,ogb04,occ20,occ21,occ22 #FUN-B90090 mark
#FUN-B90090----------add-------str
   CONSTRUCT BY NAME tm.wc2 ON oga15,oga14,oga25,oga26,oga03,oca01,oga04,
                               oga23,ima131,ima06,ogb04,occ20,occ21,occ22,
                               ima09,ima10,ima11

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
      LET INT_FLAG = 0 CLOSE WINDOW axsr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc2 = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   EXIT WHILE   #No.MOD-5A0080
END WHILE   #No.MOD-5A0080
 
 
   INPUT BY NAME
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                 tm.y1,tm.m1b,tm.m1e,tm.ch,tm.x,tm.unit,
                 tm.y,tm.more WITHOUT DEFAULTS
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
         CASE WHEN tm.ch='1' LET g_str4=g_x[12]
              WHEN tm.ch='2' LET g_str4=g_x[13]
         END CASE
 
      AFTER FIELD x
         IF cl_null(tm.x) OR tm.x NOT MATCHES '[1-3]' THEN
            NEXT FIELD x
         END IF
         CASE tm.x
            WHEN '1' LET g_str1 = g_x[28] CLIPPED
                     LET g_str2 = g_x[29] CLIPPED
            WHEN '2' LET g_str1 = g_x[30] CLIPPED
                     LET g_str2 = g_x[31] CLIPPED
            WHEN '3' LET g_str1 = g_x[32] CLIPPED
                     LET g_str2 = g_x[33] CLIPPED
         END CASE
 
      AFTER FIELD unit
         IF NOT cl_null(tm.unit) THEN 
            SELECT gfeacti INTO l_gfeacti FROM gfe_file
             WHERE gfe01 = tm.unit
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","gfe_file",tm.unit,"",SQLCA.sqlcode,"","",0)
               NEXT FIELD unit
            ELSE
               IF l_gfeacti = 'N' THEN
                  CALL cl_err(tm.unit,'ams-106',0)
                  NEXT FIELD unit
               END IF
            END IF
            LET g_str3=g_x[15] CLIPPED,tm.unit 
         END IF
      AFTER FIELD y
         IF cl_null(tm.y) OR tm.y NOT MATCHES '[YN]' THEN NEXT FIELD y END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
       AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.x) OR tm.x NOT MATCHES '[1-3]' THEN NEXT FIELD x END IF
         CASE tm.x
            WHEN '1' LET g_str1 = g_x[28] CLIPPED
                     LET g_str2 = g_x[29] CLIPPED
            WHEN '2' LET g_str1 = g_x[30] CLIPPED
                     LET g_str2 = g_x[31] CLIPPED
            WHEN '3' LET g_str1 = g_x[32] CLIPPED
                     LET g_str2 = g_x[33] CLIPPED
         END CASE
      #No.+443...end
 
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axsr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axsr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axsr120','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")   #MOD-9B0025
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",              #No.TQC-610090 add
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",          #No.TQC-610090 add
                         " '",tm.u CLIPPED,"'",          #No.TQC-610090 add
                         " '",tm.y1 CLIPPED,"'",
                         " '",tm.m1b CLIPPED,"'",
                         " '",tm.m1e CLIPPED,"'",
                         " '",tm.ch CLIPPED,"'",
                         " '",tm.x CLIPPED,"'",
                         " '",tm.unit CLIPPED,"'" ,
                         " '",tm.y CLIPPED,"'",                 #No.TQC-610090 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axsr120',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axsr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axsr120()
   ERROR ""
END WHILE
   CLOSE WINDOW axsr120_w
END FUNCTION
 
FUNCTION axsr120()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name        #No.FUN-680130 VARCHAR(20)
          l_azp01   LIKE azp_file.azp01,
          l_azp03   LIKE type_file.chr21,          #No.FUN-680130 VARCHAR(21) #No.TQC-6B0064
          l_date1   LIKE type_file.dat,            #No.FUN-680130 DATE
          l_date2   LIKE type_file.dat,            #No.FUN-680130 DATE
          l_oab02   LIKE oab_file.oab02,
          l_occ02   LIKE occ_file.occ02,
          l_occ20   LIKE occ_file.occ20,
          l_occ21   LIKE occ_file.occ21,
          l_occ22   LIKE occ_file.occ22,           #FUN-550091
          l_order   ARRAY[5] OF LIKE oab_file.oab02, #No.FUN-680130 VARCHAR(40)           #FUN-5B0105 20->40
          l_flag    LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_factor  LIKE ima_file.ima31_fac,       #No.FUN-680130 DECIMAL(16,8) 
          l_i       LIKE type_file.num10,          #No.FUN-680130 INTEGER
          l_j       LIKE type_file.num10,          #No.FUN-680130 INTEGER
          l_buf     LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(1000)
          l_aza17   LIKE aza_file.aza17,           #MOD-B40244
          l_curr    LIKE oga_file.oga24,           #MOD-B40244
          exT       LIKE type_file.chr1,           #MOD-B40244
          sr  RECORD order1 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
                     order2 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
                     order3 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
                     order4 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
                     code1  LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
                     oga02  LIKE oga_file.oga02,   #MOD-B40244
                     oga08  LIKE oga_file.oga08,   #MOD-B40244
                     gem02  LIKE gem_file.gem02,   #部門名稱
                     gen02  LIKE gen_file.gen02,   #人員名稱
                     oab02  LIKE oab_file.oab02,   #銷售名稱
                     oga26  LIKE oga_file.oga26,   #銷售分類二
                     oga032 LIKE oga_file.oga032,  #帳款客戶名稱
                     oca02  LIKE oca_file.oca02,   #客戶分類
                     oga04  LIKE oga_file.oga04,   #送貨客戶
                     oga23  LIKE oga_file.oga23,   #幣別
                     oga24  LIKE oga_file.oga24,   #匯率
                     ogb14  LIKE ogb_file.ogb14,   #金額
                     oga15  LIKE oga_file.oga15,   #部門編號
                     oga14  LIKE oga_file.oga14,   #人員編號
                     oga25  LIKE oga_file.oga25,   #銷售分類一
                     oga03  LIKE oga_file.oga03,   #帳款客戶
                     oca01  LIKE oca_file.oca01,   #帳款客戶分類
                     ima131 LIKE ima_file.ima131,  #產品分類
                     ima06  LIKE ima_file.ima06 ,  #主要分群碼
                     azp01  LIKE azp_file.azp01,   #工廠編號
                     ogb04  LIKE ogb_file.ogb04,   #料件編號
                     ima02  LIKE ima_file.ima02,   #品名    #FUN-B30158 add
                     ima021 LIKE ima_file.ima021,  #規格    #FUN-B30158 add
                     ogb05  LIKE ogb_file.ogb05,   #銷售單位
                     ogb12  LIKE ogb_file.ogb12    #數量
              END RECORD
#FUN-B90090----------add-------str
   DEFINE l_ima09     LIKE ima_file.ima09,
          l_ima10     LIKE ima_file.ima10,
          l_ima11     LIKE ima_file.ima11,
          l_azf03_1   LIKE azf_file.azf03,
          l_azf03_2   LIKE azf_file.azf03,
          l_azf03_3   LIKE azf_file.azf03
#FUN-B90090----------add-------end              
 
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740015 *** ##
 
    CALL cl_del_data(l_table)
 
# ------------------------------------------------------ CR (2) ------- ##
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740015 add ###
     LET l_sql ="SELECT azp01,azp03 FROM azp_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND azp01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01='",g_user,"') ",   #MOD-950018
                "   AND azp053 != 'N' " #no.7431
     PREPARE azp_pr FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('azp_pr',sqlca.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
        EXIT PROGRAM 
     END IF
     DECLARE azp_cur CURSOR FOR azp_pr
 
     CALL s_azn01(tm.y1,tm.m1b) RETURNING b_date,l_date1
     CALL s_azn01(tm.y1,tm.m1e) RETURNING l_date2,e_date
 
     CASE tm.x
        WHEN '1' LET g_str1 = g_x[28] CLIPPED
                 LET g_str2 = g_x[29] CLIPPED
        WHEN '2' LET g_str1 = g_x[30] CLIPPED
                 LET g_str2 = g_x[31] CLIPPED
        WHEN '3' LET g_str1 = g_x[32] CLIPPED
                 LET g_str2 = g_x[33] CLIPPED
     END CASE
         LET g_zaa[44].zaa08 = g_str1 CLIPPED   #No.FUN-580013
         LET g_zaa[46].zaa08 = g_str2 CLIPPED   #No.FUN-580013
 
     LET g_pageno = 0
     LET g_total1 = 0
     LET g_total2 = 0
     LET l_aza17 = ''   #MOD-B40244
     FOREACH azp_cur INTO l_azp01,l_azp03

      #MOD-BB0155 ----- start -----
      LET l_sql = "SELECT azi04,azi05 ",
                  "  FROM ",cl_get_target_table(l_azp01, 'azi_file'),
                  " WHERE azi01=? "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
      PREPARE azi_prepare FROM l_sql
      DECLARE azi_c CURSOR FOR azi_prepare
      #MOD-BB0155 -----  end  -----
     
      #-----MOD-B40244---------
      LET l_sql = "SELECT aza17",
                  "  FROM ",cl_get_target_table(l_azp01,'aza_file'), 
                  " WHERE aza01 = '0'"
      CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql    
      PREPARE r120_p FROM l_sql
      DECLARE r120_c CURSOR FOR r120_p
      OPEN r120_c
      FETCH r120_c INTO l_aza17
      CLOSE r120_c 
      #-----END MOD-B40244-----
      IF sqlca.sqlcode THEN CALL cl_err('azp_cur',sqlca.sqlcode,0) EXIT FOREACH END IF
      LET l_sql=''
      IF tm.x = '1' OR tm.x = '3' THEN
         LET g_sql = "SELECT '','','','','1',oga02,oga08,",   #MOD-B40244
                     "       gem02,gen02,oab02,oga26,oga032,oca02,",
                     "       oga04,oga23,oga24,ogb14,oga15,oga14,",
                     "       oga25,oga03,oca01,ima131,ima06,",
                     #"       '',ogb04,ogb05,ogb12 ",     #FUN-B30158 mark
                     "       '',ogb04,ima02,ima021,ogb05,ogb12 ",    #FUN-B30158 add ima02,ima021
                     "       ,ima09,ima10,ima11 ", #FUN-B90090 add                     
                  #FUN-A10098  ----START---
                  #  "  FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file LEFT OUTER JOIN ",      #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"gem_file ON(oga15 = gem01)  LEFT OUTER JOIN ",  #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"gen_file ON(oga14 = gen01)  LEFT OUTER JOIN ",  #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"oab_file ON(oga25 = oab01),",   #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"ogb_file,",                     #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"occ_file LEFT OUTER JOIN ",     #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"oca_file ON( occ03 = oca01),",  #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"ima_file,",    #FUN-9A0100 mod
                  #            s_dbstring(l_azp03 CLIPPED),"oay_file ",    #FUN-9A0100 mod
                     "  FROM ",cl_get_target_table(l_azp01,'oga_file')," LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'gem_file')," ON(oga15 = gem01)  LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'gen_file')," ON(oga14 = gen01)  LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'oab_file')," ON(oga25 = oab01),",
                               cl_get_target_table(l_azp01,'ogb_file'),",", 
                               cl_get_target_table(l_azp01,'occ_file')," LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'oca_file')," ON( occ03 = oca01),",
                               cl_get_target_table(l_azp01,'ima_file'),",",
                               cl_get_target_table(l_azp01,'oay_file'),
                  #FUN-A10098  ---end---
                     " WHERE ",tm.wc2 CLIPPED,
                     "   AND oga02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "   AND oga01 LIKE ltrim(rtrim(oayslip)) || '-%' ",   #MOD-750028 modify
                     "   AND oga01 = ogb01 ",
                     "   AND oga00 <> 'A' ",                     #No.CHI-870039
                     "   AND ima01 = ogb04 ",
                     "   AND ogb04 NOT LIKE 'MISC%' ",
                     "   AND ogb09 NOT IN (SELECT jce02 FROM ",cl_get_target_table(l_azp01,'jce_file'),")",   #No.TQC-A50147
                     "   AND occ01 = oga03 ",
                     "   AND ogaconf != 'X' ",
                     "   AND (oga65 != 'Y' OR oga09 = '8')"
           IF tm.y='Y' THEN
              LET g_sql = g_sql CLIPPED," AND ogapost='Y' "
           END IF
           LET l_sql=g_sql CLIPPED," AND oga09 IN ('2','3','4','6','8','A') ", #No.FUN-610079 #CHI-A60005 add 'A'
                                   #" AND oga00 NOT MATCHES '[23]' "   #No:7845   #MOD-940121
                                  #" AND oga00 NOT MATCHES '[37]' "   #No:7845   #MOD-940121  #No.MOD-950210 add 7 #CHI-950025
                                   " AND oga00 NOT IN ('3','7')"  #CHI-950025    #MOD-A80201 add '2'  
      END IF
 
      IF tm.x = '3' THEN LET l_sql = l_sql CLIPPED,' UNION ALL ' END IF
 
      IF tm.x = '2' OR tm.x = '3' THEN
         LET buf = base.StringBuffer.create() 
         CALL buf.append(tm.wc2)             
         CALL buf.replace("oga","oha",0)    
         CALL buf.replace("ogb","ohb",0)   
         LET l_buf = buf.toString()
 
         LET g_sql = " SELECT '','','','','2',oha02,oha08,",   #MOD-B40244 add oha02,oha08
                     "       gem02,gen02,oab02,oha26,oha032,oca02,",
                     "       oha04,oha23,oha24,ohb14,oha15,oha14,",
                     "       oha25,oha03,oca01,ima131,ima06,",
                     #"       '',ohb04,ohb05,ohb12 ",    #FUN-B30158 mark
                     "       '',ohb04,ima02,ima021,ohb05,ohb12 ",    #FUN-B30158 add ima02,ima021
                     "       ,ima09,ima10,ima11 ", #FUN-B90090 add                     
                 #FUN-A10098  ---start---
                 #   "  FROM ",s_dbstring(l_azp03 CLIPPED),"oha_file LEFT OUTER JOIN ",  #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"gem_file ON(oha15 = gem01)  LEFT OUTER JOIN ", #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"gen_file ON(oha14 = gen01)  LEFT OUTER JOIN ", #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"oab_file ON(oha25 = oab01),",     #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"ohb_file,",           #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"occ_file LEFT OUTER JOIN ",  #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"oca_file ON( occ03 = oca01),", #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"ima_file,",    #FUN-9A0100 mod
                 #             s_dbstring(l_azp03 CLIPPED),"oay_file ",    #FUN-9A0100 mod
                     "  FROM ",cl_get_target_table(l_azp01,'oha_file')," LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'gem_file')," ON(oha15 = gem01)  LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'gen_file')," ON(oha14 = gen01)  LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'oab_file')," ON(oha25 = oab01),",
                               cl_get_target_table(l_azp01,'ohb_file'),",",
                               cl_get_target_table(l_azp01,'occ_file')," LEFT OUTER JOIN ",
                               cl_get_target_table(l_azp01,'oca_file')," ON( occ03 = oca01),",
                               cl_get_target_table(l_azp01,'ima_file'),",",
                               cl_get_target_table(l_azp01,'oay_file'),
                  #FUN-A10098  ---end---

                     " WHERE ",l_buf CLIPPED,
                     "   AND oha02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "   AND oha01 LIKE ltrim(rtrim(oayslip)) || '-%' ",   #MOD-750028 modify
                     "   AND oha01 = ohb01 ",
                     "   AND ima01 = ohb04 ",
                     "   AND ohb04 NOT LIKE 'MISC%' ",
                     "   AND ohb09 NOT IN (SELECT jce02 FROM ",cl_get_target_table(l_azp01,'jce_file'),")",   #No.TQC-A50147
                     "   AND occ01 = oha03 ",
                     "   AND ohaconf != 'X' " #01/08/20 mandy
           IF tm.y='Y' THEN
              LET g_sql = g_sql CLIPPED," AND ohapost='Y' "
           END IF
           LET l_sql=l_sql CLIPPED,
                     g_sql CLIPPED," AND oha09 IN ('1','2','3','4','5') " CLIPPED
      END IF
      CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql    #FUN-A10098
      PREPARE r120_p1 FROM l_sql
      IF sqlca.sqlcode THEN CALL cl_err('prepare #1',sqlca.sqlcode,1) RETURN  END IF
      DECLARE r120_c1 CURSOR FOR r120_p1
      IF sqlca.sqlcode THEN CALL cl_err('declare #1',sqlca.sqlcode,1) RETURN  END IF
 
      #FOREACH r120_c1 INTO sr.* #FUN-B90090 mark
      FOREACH r120_c1 INTO sr.*,l_ima09,l_ima10,l_ima11 #FUN-B90090 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach #1',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              IF sr.code1='2' THEN
                 LET sr.ogb12 = sr.ogb12 * -1       #銷退數量
                 LET sr.ogb14 = sr.ogb14 * -1       #銷退金額
              END IF
              IF tm.ch='2' THEN       #本幣
                 LET sr.ogb14 = sr.ogb14 * sr.oga24
              END IF
              IF cl_null(sr.ogb14) THEN LET sr.ogb14=0 END IF
              #MOD-BB0155 ----- start -----
              IF tm.ch='2' THEN
                 LET l_azi04 = g_azi04
                 LET l_azi05 = g_azi05
              ELSE
                 OPEN azi_c USING sr.oga23
                 FETCH azi_c INTO l_azi04,l_azi05
              END IF
              CALL cl_digcut(sr.ogb14,l_azi04) RETURNING sr.ogb14
              #MOD-BB0155 -----  end  -----
              IF NOT cl_null(tm.unit) THEN                   #單位轉換
                 LET l_azp03=s_dbstring(l_azp03 CLIPPED) #TQC-950020
                 #LET l_azp01=s_dbstring(l_azp01 CLIPPED) #FUN-980059   #FUN-AB0100 mark
                 CALL s_umfchk1(sr.ogb04,sr.ogb05,tm.unit,l_azp01)   #No.FUN-980059
                      RETURNING l_flag,l_factor
                 IF l_flag = 1 THEN
                    CALL cl_err('','abm-731',1)
                    EXIT FOREACH
                    LET l_factor = 1
                 END IF  #無此轉換率
              ELSE
                 LET l_factor = 1                            #單位空白
              END IF
              LET sr.ogb12 = sr.ogb12 * l_factor
 
              LET sr.azp01=l_azp01
              LET g_order=''
              FOR g_i = 1 TO 3
                CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azp01
                          LET g_order=g_order CLIPPED,'  ',g_x[19] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[19] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gem02
                          LET g_order=g_order CLIPPED,'  ',g_x[20] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[20] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.gen02
                          LET g_order=g_order CLIPPED,'  ',g_x[21] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[21] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oab02
                          LET g_order=g_order CLIPPED,'  ',g_x[22] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[22] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '5'
                          SELECT oab02 INTO l_oab02 FROM oab_file
                           WHERE oab01=sr.oga26
                          IF sqlca.sqlcode THEN LET l_oab02='' END IF
                          LET l_order[g_i] = l_oab02
                          LET g_order=g_order CLIPPED,'  ',g_x[23] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[23] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga032
                          LET g_order=g_order CLIPPED,'  ',g_x[24] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[24] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oca02
                          LET g_order=g_order CLIPPED,'  ',g_x[25] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[25] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '8'
                          SELECT occ02 INTO l_occ02 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF sqlca.sqlcode THEN LET l_occ02='' END IF
                          LET l_order[g_i] = l_occ02
                          LET g_order=g_order CLIPPED,'  ',g_x[26] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[26] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oga23
                          LET g_order=g_order CLIPPED,'  ',g_x[27] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[27] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.ima131
                          LET g_order=g_order CLIPPED,'  ',g_x[35] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[35] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'b' LET l_order[g_i] = sr.ima06
                          LET g_order=g_order CLIPPED,'  ',g_x[36] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[36] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'c' LET l_order[g_i] = sr.ogb04
                          LET g_order=g_order CLIPPED,'  ',g_x[37] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[37] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'd'
                          SELECT occ20 INTO l_occ20 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF sqlca.sqlcode THEN LET l_occ20='' END IF
                          LET l_order[g_i] = l_occ20
                          LET g_order=g_order CLIPPED,'  ',g_x[38] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[38] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'e'
                          SELECT occ21 INTO l_occ21 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF sqlca.sqlcode THEN LET l_occ21='' END IF
                          LET l_order[g_i] = l_occ21
                          LET g_order=g_order CLIPPED,'  ',g_x[39] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[39] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'f'
                          SELECT occ22 INTO l_occ22 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF sqlca.sqlcode THEN LET l_occ22='' END IF
                          LET l_order[g_i] = l_occ22
                          LET g_order=g_order CLIPPED,'  ',g_x[40] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[40] CLIPPED   #No.FUN-580013
                    #FUN-B90090----------add-------str
                     WHEN tm.s[g_i,g_i] = 'g'
                          LET l_sql = "SELECT azf03 ",
                                      "  FROM ",cl_get_target_table(l_azp01,'azf_file'),
                                      " WHERE azf01 = '",l_ima09,"'",
                                      "   AND azf02 = 'D' AND azfacti = 'Y' "
                          PREPARE sel_azf03_pre1 FROM l_sql
                          DECLARE sel_azf03_cs1 CURSOR FOR sel_azf03_pre1
                          OPEN sel_azf03_cs1
                          FETCH sel_azf03_cs1 INTO l_azf03_1
                          CLOSE sel_azf03_cs1
                          IF sqlca.sqlcode THEN LET l_azf03_1 = '' END IF
                          LET l_order[g_i] = l_azf03_1
                     WHEN tm.s[g_i,g_i] = 'h'
                          LET l_sql = "SELECT azf03 ",
                                      "  FROM ",cl_get_target_table(l_azp01,'azf_file'),
                                      " WHERE azf01 = '",l_ima10,"'",
                                      "   AND azf02 = 'E' AND azfacti = 'Y' "
                          PREPARE sel_azf03_pre2 FROM l_sql
                          DECLARE sel_azf03_cs2 CURSOR FOR sel_azf03_pre2
                          OPEN sel_azf03_cs2
                          FETCH sel_azf03_cs2 INTO l_azf03_2
                          CLOSE sel_azf03_cs2
                          IF sqlca.sqlcode THEN LET l_azf03_2 = '' END IF
                          LET l_order[g_i] = l_azf03_2
                     WHEN tm.s[g_i,g_i] = 'i'
                          LET l_sql = "SELECT azf03 ",
                                      "  FROM ",cl_get_target_table(l_azp01,'azf_file'),
                                      " WHERE azf01 = '",l_ima11,"'",
                                      "   AND azf02 = 'F' AND azfacti = 'Y' "
                          PREPARE sel_azf03_pre3 FROM l_sql
                          DECLARE sel_azf03_cs3 CURSOR FOR sel_azf03_pre3
                          OPEN sel_azf03_cs3
                          FETCH sel_azf03_cs3 INTO l_azf03_3
                          CLOSE sel_azf03_cs3
                          IF sqlca.sqlcode THEN LET l_azf03_3 = '' END IF
                          LET l_order[g_i] = l_azf03_3                    
                    #FUN-B90090----------add-------end                       
                    OTHERWISE LET l_order[g_i] = ''
                 END CASE
             END FOR
             LET sr.order1 = l_order[1]
             LET sr.order2 = l_order[2]
             LET sr.order3 = l_order[3]
             IF tm.ch = '1' THEN
                LET sr.order4 = sr.oga23     
             ELSE
                #LET sr.order4 = g_aza.aza17       #MOD-B40244
                LET sr.order4 = l_aza17       #MOD-B40244
             END IF
             #-----MOD-B40244---------
             IF sr.oga08='1' THEN
                LET exT=g_oaz.oaz52
             ELSE
                LET exT=g_oaz.oaz70
             END IF
             LET l_curr = s_curr3(sr.order4,sr.oga02,exT)   
             #-----END MOD-B40244-----
 
             CALL r120_m(sr.oga23) 
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.order2, sr.order3,sr.order4,sr.gem02,
         sr.gen02, sr.oab02,  sr.oga26, sr.oga032,sr.oca02,
         sr.oga04, sr.oga23,  sr.oga24, sr.ogb14, sr.oga15,
         sr.oga14, sr.oga25,  sr.oga03, sr.oca01, sr.ima131,
         #sr.ima06, sr.azp01,  sr.ogb04, sr.ogb05, sr.ogb12,      #FUN-B30158 mark
         sr.ima06, sr.azp01,  sr.ogb04, sr.ima02, sr.ima021, sr.ogb05, sr.ogb12,  #FUN-B30158 add ima02,ima021
         l_oab02,  l_occ02,   l_occ20,  l_occ21,  l_occ22,
         l_azi04,  l_azi05,   l_curr   #MOD-B40244
         ,l_azf03_1,l_azf03_2,l_azf03_3 #FUN-B90090 add
       #------------------------------ CR (3) ------------------------------#
 
             LET g_total1 = g_total1 + sr.ogb12      #數量
             LET g_total2 = g_total2 + sr.ogb14      #金額
         END FOREACH
     END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   LET g_str = ' ' #MOD-980040      
   IF g_zz05 = 'Y' THEN
      #MOD-C40186 mark start -----
      #CALL cl_wcchp(tm.wc,'azp01,oga15,oga14,oga25,oga26,oga03,oca01,oga04,
      #                     oga23,ima131,ima06,ogb04,occ20,occ21,occ22,
      #                     ima09,ima10,ima11') #FUN-B90090 add
      #MOD-C40186 mark end   -----
      CALL cl_wcchp(tm.wc,'azp01') #MOD-C40186 add
           RETURNING tm.wc
      #MOD-C40186 add start -----
      CALL cl_wcchp(tm.wc2,'oga15, oga14, oga25, oga26, oga03
                           ,oca01, oga04, oga23, ima131,ima06
                           ,ogb04, occ20, occ21, occ22, ima09
                           ,ima10, ima11')
           RETURNING tm.wc2
      #MOD-C40186 add end -----
      #LET g_str = tm.wc       #MOD-C40186 mark
      LET g_str = tm.wc,tm.wc2 #MOD-C40186 add
   END IF
   LET g_str = g_str,";",tm.s,";",tm.t,";",tm.u,";",tm.ch,";",b_date,";",e_date,";",tm.x
   CALL cl_prt_cs3('axsr120','axsr120',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
 
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
FUNCTION r120_m(p_code)
DEFINE p_code  LIKE oga_file.oga23
 
      IF tm.ch=1  THEN          #(原幣)
          SELECT azi03,azi04,azi05 INTO l_azi03,l_azi04,l_azi05  #抓幣別取位  
            FROM azi_file
           WHERE azi01=p_code
      ELSE
          LET l_azi03=t_azi03   #本幣
          LET l_azi04=t_azi04
          LET l_azi05=t_azi05
      END IF
      IF cl_null(l_azi03) THEN LET l_azi03=0 END IF
      IF cl_null(l_azi04) THEN LET l_azi04=0 END IF
      IF cl_null(l_azi05) THEN LET l_azi05=0 END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
