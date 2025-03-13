# Prog. Version..: '5.30.06-13.04.03(00010)'     #
#
# Pattern name...: axsr500.4gl
# Descriptions...: 銷售全年度統計表
# Date & Author..: 95/05/15 By Danny
# Modify.........: No.FUN-550091 05/05/26 By Smapmin 新增地區欄位
# Modify.........: No.FUN-580013 05/08/18 By will 報表轉XML格式
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0064 06/11/14 By Carrier 長度為CHAR(21)的azp03定義改為type_file.chr21
# Modify.........: No.TQC-6C0010 06/12/05 By Judy 調整報表格式
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740015 07/04/17 By TSD.liquor 報表改寫由Crystal Report產出
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.CHI-870001 08/07/22 By Smapmin 走出貨簽收流程,未簽收前不可納入銷貨收入
# Modify.........: No.CHI-870039 08/07/24 By xiaofeizhu 抓oga_file資料時，排除oga00=A的資料
# Modify.........: No.CHI-920089 09/02/26 By Smapmin 過濾MISC料
# Modify.........: No.MOD-950018 09/05/05 By Smapmin 營運中心欄位應加上營運中心使用權限判斷
# Modify.........: No.TQC-950044 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.MOD-950210 09/05/26 By Pengu “寄銷出貨”不應納入 “銷貨收入”
# Modify.........: No.CHI-950025 09/06/24 By mike SQL語句調整        
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960154 09/09/07 By chenmoyan 改CONSTRUCT的欄位皆可開窗
# Modify.........: No.FUN-980059 09/09/11 By arman GP5.2架構,修改SUB傳入參數
# Modify.........: No.FUN-9C0072 10/01/09 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/18 By chenls GP5.2跨DB報表--財務類
# Modify.........: No.TQC-A50147 10/05/25 By Carrier main中结构调整 & FUN-830159追单
# Modify.........: No:CHI-A60005 10/06/22 By Summer 條件式有oga09就加上'A'的類別
# Modify.........: No.FUN-B80059 11/08/03 By minpp 程序撰寫規範修改
# Modify.........: No.FUN-B90090 11/09/14 By Sakura QBE及排序增加其他分群碼一二三
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-BB0155 12/01/17 By Vampire :明細金額需在程式段就先取位，以避免到了rpt段時造成明細金額加總與總計不合
# Modify.........: No.MOD-C50184 12/05/25 By Vampire 第二次列印是g_str變數未清空導致
# Modify.........: No.MOD-C90182 12/09/28 By Vampire 排除非成本倉資料
# Modify.........: No.MOD-D30276 13/04/01 By Elise tm.wc,tm.wc2型態調整為STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_sql	      string                           #No.FUN-580092 HCN
   DEFINE tm  RECORD                                   # Print condition RECORD
             #wc      LIKE type_file.chr1000,          # Where condition   #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark     
              wc      STRING,                          #MOD-D30276
             #wc2     LIKE type_file.chr1000,          # Where condition   #No.FUN-680130 VARCHAR(1000) #MOD-D30276 mark
              wc2     STRING,                          #MOD-D30276    
              s       LIKE type_file.chr3,             #No.FUN-680130 VARCHAR(3)
              t       LIKE type_file.chr2,             #No.FUN-680130 VARCHAR(2)
              u       LIKE type_file.chr1,             #No.FUN-680130 VARCHAR(1)
              y1      LIKE type_file.num5,             #No.FUN-680130 SMALLINT
              m1      LIKE type_file.num5,             #No.FUN-680130 SMALLINT
              ch      LIKE type_file.chr1,             #No.FUN-680130 VARCHAR(1)
              op      LIKE type_file.chr1,             #No.FUN-680130 VARCHAR(1)
              unit    LIKE ima_file.ima25,             #No.FUN-680130 VARCHAR(4)
              y       LIKE type_file.chr1,             #No.FUN-680130 VARCHAR(1)
              more    LIKE type_file.chr1              # Input more condition(Y/N) #No.FUN-680130 VARCHAR(1)     
              END RECORD,
          g_order     LIKE type_file.chr1000,          #No.FUN-680130 VARCHAR(134)
          g_date    ARRAY[12] OF LIKE type_file.dat,   #No.FUN-680130 DATE 
          g_buf           LIKE type_file.chr1000,      #No.FUN-680130 VARCHAR(04)
          g_str1,g_str2   LIKE type_file.chr1000,      #No.FUN-680130 VARCHAR(30)
          l_azi03         LIKE azi_file.azi03,         #
          l_azi04         LIKE azi_file.azi04,         #
          l_azi05         LIKE azi_file.azi05,         #
          b_date,e_date   LIKE type_file.dat,          #No.FUN-680130 DATE
          g_str           STRING,                      #No.FUN-740015
          l_table         STRING                       #No.FUN-740015
 
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose #No.FUN-680130 SMALLINT
DEFINE g_before_input_done   STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50147  --Begin
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.s   = ARG_VAL(9)
   LET tm.t   = ARG_VAL(10)
   LET tm.u   = ARG_VAL(11)
   LET tm.y1  = ARG_VAL(12)
   LET tm.m1  = ARG_VAL(13)
   LET tm.ch  = ARG_VAL(14)
   LET tm.op  = ARG_VAL(15)
   LET tm.unit= ARG_VAL(16)
   LET tm.y   = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD #FUN-BB0047 mark
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/17 TSD.liquor *** ##
   LET g_sql  = "order1.oab_file.oab02,",
                "order2.oab_file.oab02,",
                "order3.oab_file.oab02,",
                "tot1.ogb_file.ogb14,",
                "tot2.ogb_file.ogb14,",
                "tot3.ogb_file.ogb14,",
                "tot4.ogb_file.ogb14,",
                "tot5.ogb_file.ogb14,",
                "tot6.ogb_file.ogb14,",
                "tot7.ogb_file.ogb14,",
                "tot8.ogb_file.ogb14,",
                "tot9.ogb_file.ogb14,",
                "tot10.ogb_file.ogb14,",
                "tot11.ogb_file.ogb14,",
                "tot12.ogb_file.ogb14,",
                "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('axsr500',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-780054
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   #No.TQC-A50147  --End  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axsr500_tm(0,0)        # Input print condition
      ELSE CALL axsr500()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
END MAIN
 
FUNCTION axsr500_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW axsr500_w AT p_row,p_col
        WITH FORM "axs/42f/axsr500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '26 '
   LET tm.t    = 'Y '
   LET tm.u    = 'Y'
   LET tm.y1   = YEAR(g_today)
   LET tm.m1   = MONTH(g_today)
   LET tm.ch   = '2'
   LET tm.op   = '3'
   LET tm.y    = 'Y'
   LET tm.more = 'N'
   LET g_str1  = ''
   LET g_str2  = ''
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
 
WHILE TRUE
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      LET tm.wc="azp01='",g_plant,"'"
   END IF
   CONSTRUCT BY NAME tm.wc2 ON oga15,oga14,oga25,oga26,oga03,oca01,oga04,oga23,
                               ima131,ima06,ogb04,occ20,occ21,occ22
                              ,ima09,ima10,ima11 #FUN-B90090 add                                
      ON ACTION controlp
         CASE
              WHEN INFIELD(oga03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga03
                   NEXT FIELD oga03
              WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga04
                   NEXT FIELD oga04
              WHEN INFIELD(oga15)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form="q_gem"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga15
                   NEXT FIELD oga15
              WHEN INFIELD(oga14)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga14
                   NEXT FIELD oga14
              WHEN INFIELD(oga23)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_azi'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga23
                   NEXT FIELD oga23
              WHEN INFIELD(oga25)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oab"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga25
                   NEXT FIELD oga25
              WHEN INFIELD(oga26)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oab"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oga26
                   NEXT FIELD oga26
              WHEN INFIELD(ogb04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ogb04
                   NEXT FIELD ogb04
              WHEN INFIELD(occ20)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gea'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.occ20
                   NEXT FIELD occ20
              WHEN INFIELD(occ21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_geb'
                   LET g_qryparam.state  = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.occ21
                   NEXT FIELD occ21
              WHEN INFIELD(ima06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_imz"
                   LET g_qryparam.state    = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima06
                   NEXT FIELD ima06
              WHEN INFIELD(ima131)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oba"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.ima131
                   NEXT FIELD ima131
              WHEN INFIELD(oca01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oca"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.oca01
                   NEXT FIELD oca01
              WHEN INFIELD(occ22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_geo"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO FORMONLY.occ22
                   NEXT FIELD occ22
              #FUN-B90090----------add-------str
              WHEN INFIELD(ima09)#其他分群碼一
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
            #FUN-B90090----------add-------end                   
            OTHERWISE EXIT CASE
         END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc2 = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2, tm2.t1,tm2.t2, tm2.u1,
                 tm.y1,tm.m1,tm.ch,tm.op,tm.unit,tm.y,
                 tm.more WITHOUT DEFAULTS
      BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL r500_set_entry()
           CALL r500_set_no_entry()
           LET g_before_input_done = TRUE
 
      AFTER FIELD y1
         IF cl_null(tm.y1) THEN NEXT FIELD y1 END IF
      AFTER FIELD m1
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
         IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF
      BEFORE FIELD ch
         CALL r500_set_entry()
      AFTER FIELD ch
         IF NOT cl_null(tm.ch) THEN
            IF tm.ch NOT MATCHES '[1-3]' THEN
               NEXT FIELD ch
            END IF
         END IF
         CALL r500_set_no_entry()
      AFTER FIELD op
         IF tm.ch ='1' OR tm.ch ='2' THEN
            IF cl_null(tm.op) OR tm.op NOT MATCHES '[1-3]' THEN
               NEXT FIELD op
            END IF
            IF tm.ch='1'
               THEN LET g_buf=g_x[29].substring(1,4)    #原幣
               ELSE LET g_buf=g_x[29].substring(5,8)    #本幣
            END IF
            LET g_str1=g_x[33] CLIPPED
            CASE tm.op
              WHEN '1' LET g_str1=g_str1 CLIPPED,g_x[30] CLIPPED,'/',g_buf
              WHEN '2' LET g_str1=g_str1 CLIPPED,g_x[31] CLIPPED,'/',g_buf
              WHEN '3' LET g_str1=g_str1 CLIPPED,g_x[32] CLIPPED,'/',g_buf
            END CASE
            NEXT FIELD y
         END IF
      AFTER FIELD unit            #單位
         IF NOT cl_null(tm.unit)
            THEN LET g_str2=g_x[28] CLIPPED,tm.unit
            ELSE LET g_str2=''
         END IF
      AFTER FIELD y
         IF NOT cl_null(tm.y) THEN
            IF tm.y NOT MATCHES '[YN]' THEN
               NEXT FIELD y
            END IF
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
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axsr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axsr500','9031',1)   
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
                         " '",tm.wc2 CLIPPED,"'",       #No.TQC-610090 add
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.y1 CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.ch CLIPPED,"'",
                         " '",tm.op CLIPPED,"'",
                         " '",tm.unit CLIPPED,"'" ,
                         " '",tm.y CLIPPED,"'",            #No.TQC-610090 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axsr500',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axsr500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axsr500()
   ERROR ""
END WHILE
   CLOSE WINDOW axsr500_w
END FUNCTION
FUNCTION r500_set_entry()
   IF INFIELD(ch) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("op",TRUE)
   END IF
 
END FUNCTION
FUNCTION r500_set_no_entry()
   IF INFIELD(ch) OR (NOT g_before_input_done) THEN
      IF tm.ch ='3' THEN
            LET tm.op=''
            LET g_str1=''
            DISPLAY tm.op TO op
         CALL cl_set_comp_entry("op",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION axsr500()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name      #No.FUN-680130 VARCHAR(20)
          l_azp01   LIKE azp_file.azp01,
          l_azp03   LIKE type_file.chr21,          #No.FUN-680130 VARCHAR(21) #No.TQC-6B0064
          l_oab02   LIKE oab_file.oab02,
          l_occ02   LIKE occ_file.occ02,
          l_occ20   LIKE occ_file.occ20,
          l_occ21   LIKE occ_file.occ21,
          l_occ22   LIKE occ_file.occ22,           #FUN-550091
          l_order   ARRAY[5] OF LIKE oab_file.oab02, #No.FUN-680130 VARCHAR(40)           #FUN-5B0105 20->40
          l_flag    LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_factor  LIKE ima_file.ima31_fac,       #No.FUN-680130 DECIMAL(16,8),
          l_year    LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_month   LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_i       LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_str     LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(04)
          l_sql     LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(3000)
          l_azf03   LIKE azf_file.azf03,           #FUN-B90090 add 
          sr  RECORD order1 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
                     order2 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
                     order3 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40)
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
                     ima06  LIKE ima_file.ima06,   #主要分群碼
                     azp01  LIKE azp_file.azp01,   #工廠編號
                     ogb04  LIKE ogb_file.ogb04,   #料件編號
                     ogb05  LIKE ogb_file.ogb05,   #銷售單位
                     oga02  LIKE oga_file.oga02,   #日期
                     ogb12  LIKE ogb_file.ogb12,   #數量
                     tot1   LIKE ogb_file.ogb14,
                     tot2   LIKE ogb_file.ogb14,
                     tot3   LIKE ogb_file.ogb14,
                     tot4   LIKE ogb_file.ogb14,
                     tot5   LIKE ogb_file.ogb14,
                     tot6   LIKE ogb_file.ogb14,
                     tot7   LIKE ogb_file.ogb14,
                     tot8   LIKE ogb_file.ogb14,
                     tot9   LIKE ogb_file.ogb14,
                     tot10  LIKE ogb_file.ogb14,
                     tot11  LIKE ogb_file.ogb14,
                     tot12  LIKE ogb_file.ogb14
                    ,ima09  LIKE ima_file.ima09, #FUN-B90090 add 
                     ima10  LIKE ima_file.ima10, #FUN-B90090 add
                     ima11  LIKE ima_file.ima11  #FUN-B90090 add
              END RECORD
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740015 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql ="SELECT azp01,azp03 FROM azp_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND azp01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01='",g_user,"') ",   #MOD-950018
                "   AND azp053 != 'N' " #no.7341
     PREPARE azp_pr FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('azp_pr',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
        EXIT PROGRAM
     END IF
     DECLARE azp_cur CURSOR FOR azp_pr
 
#    CALL cl_outnam('axsr500') RETURNING l_name  #No.TQC-A50147
     #取得起始/結束日期
     LET l_year = tm.y1
     LET l_month = tm.m1
     FOR l_i=1 TO 12
         CALL s_azn01(l_year,l_month) RETURNING b_date,e_date
         IF b_date = '01/01/01' OR e_date = '01/01/01' THEN
            CALL cl_err(b_date,'axm-250',1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
            EXIT PROGRAM
         END IF
         LET g_date[l_i] = b_date
         LET l_month = l_month + 1
         IF l_month > 12 THEN
            LET l_month = l_month - 12   LET l_year = l_year + 1
         END IF
     END FOR
     LET g_pageno = 0
     FOREACH azp_cur INTO l_azp01,l_azp03
         IF STATUS THEN CALL cl_err('azp_cur',STATUS,0) EXIT FOREACH END IF
         
         #MOD-BB0155 ----- start -----
         LET l_sql = "SELECT azi04,azi05 ",
                     "  FROM ",cl_get_target_table(l_azp01, 'azi_file'),
                     " WHERE azi01=? "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_azp01) RETURNING l_sql
         PREPARE azi_prepare FROM l_sql
         DECLARE azi_c CURSOR FOR azi_prepare
         #MOD-BB0155 -----  end  -----
         
         LET g_sql = "SELECT '','','',",
                     "       gem02,gen02,oab02,oga26,oga032,oca02,",
                     "       oga04,oga23,oga24,ogb14,oga15,oga14,",
                     "       oga25,oga03,oca01,ima131,ima06,'',ogb04,ogb05,",
                     "       oga02,ogb12,0,0,0,0,0,0,0,0,0,0,0,0 ",
                     "      ,ima09,ima10,ima11 ", #FUN-B90090 add 
#FUN-A10098---BEGIN
#                     "  FROM ",s_dbstring(l_azp03),"oga_file,",                                                                     
#                               s_dbstring(l_azp03),"ogb_file,",                                                                     
#                               s_dbstring(l_azp03),"occ_file,",                                                                     
#                     " OUTER ",s_dbstring(l_azp03),"ima_file,",                                                                     
#                     " OUTER ",s_dbstring(l_azp03),"oca_file,",                                                                     
#                     " OUTER ",s_dbstring(l_azp03),"gem_file,",                                                                     
#                     " OUTER ",s_dbstring(l_azp03),"gen_file,",                                                                     
#                     " OUTER ",s_dbstring(l_azp03),"oab_file ",
#                     "  FROM ",cl_get_target_table(l_azp01,'oga_file'),",",
#                               cl_get_target_table(l_azp01,'ogb_file'),",",
#                               cl_get_target_table(l_azp01,'occ_file'),",",
#                     " OUTER ",cl_get_target_table(l_azp01,'ima_file'),",",
#                     " OUTER ",cl_get_target_table(l_azp01,'oca_file'),",",
#                     " OUTER ",cl_get_target_table(l_azp01,'gem_file'),",",
#                     " OUTER ",cl_get_target_table(l_azp01,'gen_file'),",",
#                     " OUTER ",cl_get_target_table(l_azp01,'oab_file'),
                     "  FROM ",cl_get_target_table(l_azp01,'oga_file'),
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gem_file')," ON oga_file.oga15 = gem_file.gem01 ",
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'gen_file')," ON oga_file.oga14 = gen_file.gen01 ",
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oab_file')," ON oga_file.oga25 = oab_file.oab01 ",
                     ",",cl_get_target_table(l_azp01,'ogb_file'),
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'ima_file')," ON ogb_file.ogb04 = ima_file.ima01 ",
                     ",",cl_get_target_table(l_azp01,'occ_file'),
                     " LEFT OUTER JOIN ",cl_get_target_table(l_azp01,'oca_file')," ON occ_file.occ03 = oca_file.oca01 ",
                     
#FUN-A10098---END
                     " WHERE ",tm.wc2 CLIPPED,
                     "   AND oga02 BETWEEN '",g_date[1],"'",
                     "   AND '",e_date,"'",
                     "   AND oga01 = ogb01 ",
                     "   AND oga00 NOT IN ('A','3','7') ",
                     "   AND oga09 IN ('2','8','3','4','6','A') ",  #No.FUN-610079   #No.MOD-950210 add '3' #CHI-950025 add 4,6 #CHI-A60005 add 'A'
                     "   AND (oga65 != 'Y' OR oga09 = '8')",  #CHI-870001
#FUN-A10098---START
#                     "   AND ima_file.ima01 = ogb_file.ogb04 ",
#                     "   AND ogb04 NOT LIKE 'MISC%' ",   #CHI-920089
#                     "   AND occ01 = oga03 ",
#                     "   AND oca_file.oca01 = occ_file.occ03 ",
#                     "   AND gem_file.gem01 = oga_file.oga15 ",
#                     "   AND gen_file.gen01 = oga_file.oga14 ",
#                     "   AND oab_file.oab01 = oga_file.oga25 ",
#                     "   AND ogaconf != 'X' " #01/08/20 mandy
                     "   AND ogb04 NOT LIKE 'MISC%' ",   #CHI-920089
                     "   AND ogb09 NOT IN (SELECT jce02 FROM ",cl_get_target_table(l_azp01,'jce_file'),")",    #MOD-C90182 add
                     "   AND occ01 = oga03 ",
                     "   AND ogaconf != 'X' " #01/08/20 mandy
#FUN-A10098---END
      IF tm.y='Y' THEN LET g_sql = g_sql CLIPPED," AND ogapost='Y' " END IF
 
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING  g_sql   #FUN-A10098
         PREPARE r500_p1 FROM g_sql
         IF STATUS THEN CALL cl_err('prepare #1',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
            EXIT PROGRAM
         END IF
         DECLARE r500_c1 CURSOR FOR r500_p1
         FOREACH r500_c1 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #1',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
              #本幣金額 (原幣金額 * 匯率)
              IF tm.ch = '2' THEN LET sr.ogb14 = sr.ogb14 * sr.oga24 END IF
              IF tm.ch = '1' OR tm.ch = '2' THEN                #金額(原/本)
                 IF tm.op='1' THEN LET sr.ogb14 = sr.ogb14 / 1000000 END IF
                 IF tm.op='2' THEN LET sr.ogb14 = sr.ogb14 / 1000 END IF
              ELSE                                              #數量
                 IF NOT cl_null(tm.unit) THEN                   #單位轉換
                    LET l_azp03[21]=':'
                    CALL s_umfchk1(sr.ogb04,sr.ogb05,tm.unit,l_azp01)  #No.FUN-980059
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
                 LET sr.ogb14 = sr.ogb12
              END IF
              #MOD-BB0155 ----- start -----
              IF tm.ch='1' THEN 
                 OPEN azi_c USING sr.oga23
                 FETCH azi_c INTO l_azi04,l_azi05
              END IF
              IF tm.ch='2' THEN
                 LET l_azi04 = g_azi04
                 LET l_azi05 = g_azi05
              END IF
              CALL cl_digcut(sr.ogb14,l_azi04) RETURNING sr.ogb14
              #MOD-BB0155 -----  end  -----
              CASE
                WHEN sr.oga02 >= g_date[1] AND sr.oga02 < g_date[2]
                     LET sr.tot1 = sr.ogb14
                WHEN sr.oga02 >= g_date[2] AND sr.oga02 < g_date[3]
                     LET sr.tot2 = sr.ogb14
                WHEN sr.oga02 >= g_date[3] AND sr.oga02 < g_date[4]
                     LET sr.tot3 = sr.ogb14
                WHEN sr.oga02 >= g_date[4] AND sr.oga02 < g_date[5]
                     LET sr.tot4 = sr.ogb14
                WHEN sr.oga02 >= g_date[5] AND sr.oga02 < g_date[6]
                     LET sr.tot5 = sr.ogb14
                WHEN sr.oga02 >= g_date[6] AND sr.oga02 < g_date[7]
                     LET sr.tot6 = sr.ogb14
                WHEN sr.oga02 >= g_date[7] AND sr.oga02 < g_date[8]
                     LET sr.tot7 = sr.ogb14
                WHEN sr.oga02 >= g_date[8] AND sr.oga02 < g_date[9]
                     LET sr.tot8 = sr.ogb14
                WHEN sr.oga02 >= g_date[9] AND sr.oga02 < g_date[10]
                     LET sr.tot9 = sr.ogb14
                WHEN sr.oga02 >= g_date[10] AND sr.oga02 < g_date[11]
                     LET sr.tot10 = sr.ogb14
                WHEN sr.oga02 >= g_date[11] AND sr.oga02 < g_date[12]
                     LET sr.tot11 = sr.ogb14
                WHEN sr.oga02 >= g_date[12] LET sr.tot12 = sr.ogb14
              END CASE
              LET sr.azp01 = l_azp01
              LET g_order=''
              FOR g_i = 1 TO 2
                CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azp01
                          LET g_order=g_order CLIPPED,' ',g_x[19] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[19] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.gem02
                          LET g_order=g_order CLIPPED,' ',g_x[20] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[20] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.gen02
                          LET g_order=g_order CLIPPED,' ',g_x[21] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[21] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oab02
                          LET g_order=g_order CLIPPED,' ',g_x[22] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[22] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '5'
                          SELECT oab02 INTO l_oab02 FROM oab_file
                          WHERE oab01=sr.oga26
                          IF STATUS THEN LET l_oab02='' END IF
                          LET l_order[g_i] = l_oab02
                          LET g_order=g_order CLIPPED,' ',g_x[23] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[23] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oga032
                          LET g_order=g_order CLIPPED,' ',g_x[24] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[24] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oca02
                          LET g_order=g_order CLIPPED,' ',g_x[25] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[25] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '8'
                          SELECT occ02 INTO l_occ02 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF STATUS THEN LET l_occ02='' END IF
                          LET l_order[g_i] = l_occ02
                          LET g_order=g_order CLIPPED,' ',g_x[26] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[26] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oga23
                          LET g_order=g_order CLIPPED,' ',g_x[27] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[27] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.ima131
                          LET g_order=g_order CLIPPED,' ',g_x[35] CLIPPED
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
                          IF STATUS THEN LET l_occ20='' END IF
                          LET l_order[g_i] = l_occ20
                          LET g_order=g_order CLIPPED,'  ',g_x[38] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[38] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'e'
                          SELECT occ21 INTO l_occ21 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF STATUS THEN LET l_occ21='' END IF
                          LET l_order[g_i] = l_occ21
                          LET g_order=g_order CLIPPED,'  ',g_x[39] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[39] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'f'
                          SELECT occ22 INTO l_occ22 FROM occ_file
                           WHERE occ01=sr.oga04
                          IF STATUS THEN LET l_occ22='' END IF
                          LET l_order[g_i] = l_occ22
                          LET g_order=g_order CLIPPED,'  ',g_x[40] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[40] CLIPPED   #No.FUN-580013
                     #FUN-B90090----------add-------str
                     WHEN tm.s[g_i,g_i] = 'g'  #其他分群碼一
                          LET l_sql = " SELECT azf03 FROM ",
                                      cl_get_target_table(l_azp01,'azf_file'),
                                      " WHERE azf01 = '",sr.ima09,"'",
                                      "   AND azf02 = 'D' AND azfacti = 'Y' "
                          PREPARE sel_azf03_pre1 FROM l_sql
                          EXECUTE sel_azf03_pre1 INTO l_azf03
                          IF STATUS THEN LET l_azf03='' END IF
                          LET l_order[g_i] = l_azf03

                     WHEN tm.s[g_i,g_i] = 'h'  #其他分群碼二
                          LET l_sql = " SELECT azf03 FROM ",
                                      cl_get_target_table(l_azp01,'azf_file'),
                                      " WHERE azf01 = '",sr.ima10,"'",
                                      "   AND azf02 = 'E' AND azfacti = 'Y' "
                          PREPARE sel_azf03_pre2 FROM l_sql
                          EXECUTE sel_azf03_pre2 INTO l_azf03
                          IF STATUS THEN LET l_azf03='' END IF
                          LET l_order[g_i] = l_azf03

                     WHEN tm.s[g_i,g_i] = 'i'  #其他分群碼三
                          LET l_sql = " SELECT azf03 FROM ",
                                      cl_get_target_table(l_azp01,'azf_file'),
                                      " WHERE azf01 = '",sr.ima11,"'",
                                      "   AND azf02 = 'F' AND azfacti = 'Y' "
                          PREPARE sel_azf03_pre3 FROM l_sql
                          EXECUTE sel_azf03_pre3 INTO l_azf03
                          IF STATUS THEN LET l_azf03='' END IF
                          LET l_order[g_i] = l_azf03
                     #FUN-B90090----------add-------end                            
                     OTHERWISE
                          LET l_order[g_i] = ''
                 END CASE
             END FOR
             LET sr.order1 = l_order[1]
             LET sr.order2 = l_order[2]
 
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
           CALL r500_m(sr.oga23)
           EXECUTE insert_prep USING 
             sr.order1,sr.order2,sr.order3,sr.tot1,sr.tot2,sr.tot3,
             sr.tot4,sr.tot5,sr.tot6,sr.tot7,sr.tot8,sr.tot9,sr.tot10,
             sr.tot11,sr.tot12,l_azi05
         #------------------------------ CR (3) ------------------------------#
         END FOREACH
     END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740015 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-740015 modify
   #是否列印選擇條件
   LET g_str = '' #MOD-C50184 add
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gem02,gen02,oab02,oga26,oga032,oca02,oga04,oga23,
                    oga24,ogb14,oga15,oga14,oga25,oga03,oca01,ima131,
                    ima06,azp01,ogb04,ogb05,ogb12,ccc23,oga02
                   ,ima09,ima10,ima11') #FUN-B90090 add 
           RETURNING tm.wc
      CALL cl_wcchp(tm.wc2,'gem02,gen02,oab02,oga26,oga032,oca02,oga04,oga23,
                    oga24,ogb14,oga15,oga14,oga25,oga03,oca01,ima131,
                    ima06,azp01,ogb04,ogb05,ogb12,ccc23,oga02
                   ,ima09,ima10,ima11') #FUN-B90090 add
           RETURNING tm.wc2
      LET g_str = tm.wc,tm.wc2
   END IF
   LET g_str = g_str ,";",tm.s,";",tm.t,";",tm.u,";",tm.ch,";",tm.y1,";",tm.m1,";",
               g_date[1] USING "YY/MM",";",
               g_date[2] USING "YY/MM",";",
               g_date[3] USING "YY/MM",";",
               g_date[4] USING "YY/MM",";",
               g_date[5] USING "YY/MM",";",
               g_date[6] USING "YY/MM",";",
               g_date[7] USING "YY/MM",";",
               g_date[8] USING "YY/MM",";",
               g_date[9] USING "YY/MM",";",
               g_date[10] USING "YY/MM",";",
               g_date[11] USING "YY/MM",";",
               g_date[12] USING "YY/MM",";",
               tm.op
 
   CALL cl_prt_cs3('axsr500','axsr500',l_sql,g_str)  
   #------------------------------ CR (4) ------------------------------#
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
FUNCTION r500_m(p_code)
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
      IF cl_null(l_azi04) THEN LET l_azi03=0 END IF
      IF cl_null(l_azi05) THEN LET l_azi03=0 END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼
