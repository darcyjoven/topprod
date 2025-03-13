# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr622.4gl
# Descriptions...: B O M 成本明細表(底階)
# Input parameter:
# Return code....:
# Date & Author..: 92/10/21 By Apple
# Modify By......: 96/06/10 By Chiang 增加主件料件之全部成本之合計數
# Modify.........: No.FUN-4A0001 04/10/05 By Yuna 主件編號開窗
# Modify.........: No.FUN-4B0061 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.MOD-530204 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.MOD-530217 05/03/23 By kim 頁次分母永遠為1
# Modify.........: No.FUN-550095 05/06/03 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560100 05/06/18 By kim 料件+特性代碼 第一個不同 無做小計
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加開窗查詢
# Modify.........: No.TQC-5A0032 05/10/13 By elva 料件編號欄位放大，調整不對齊的欄位
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0072 05/11/09 By Claire 表頭調整
# Modify.........: No.TQC-5B0130 05/11/22 By Echo 單身料號下一行出現資料怪異
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-5B0121 06/02/13 By Sarah 每項下階料只有單價沒有金額，建議下階料加上相應的採購金額/平均金額/市價金額及單位
# Modify.........: No.MOD-640130 06/04/09 By Echo 按下確定時會出現一警告訊息Warning lib-301
# Modify.........: No.FUN-610092 06/05/24 By Joe 報表新增採購單位欄位
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-670106 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改    
# Modify.........: No.TQC-6B0108 06/11/23 By Ray 未打印有效日期
# Modify.........: No.TQC-6C0034 06/12/14 By Joe 將單位改為BOM單位
# Modify.........: No.MOD-720044 07/02/02 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-830030 08/03/19 By Pengu 當元件有下起迄條件時資料會異常
# Modify.........: No.MOD-850052 08/05/06 By claire l_desc 2碼長會造成資料被截掉
# Modify.........: No.MOD-850277 08/05/27 By claire 幣別中文名稱於unicode區會被截掉
# Modify.........: No.MOD-870284 08/07/30 By chenl  增加判斷，該主件下，是否存在元件，若存在，則判斷是否存在沒有失效的元件，若有則遞歸，否則將該主件做為末階料件打印。
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C30914 12/04/02 By ck2yuan 修改bmb03s、bmb03e 判斷
# Modify.........: No.TQC-C50120 12/05/15 By fengrui 抓BOM資料時，除去無效資料
# Modify.........: No.FUN-C40074 12/09/20 By bart 增加條件 列印取替代資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm  RECORD                              #Print condition RECORD
            wc        STRING,                   #Where condition No.TQC-630166
            qty       LIKE type_file.num10,     #主件數量   #FUN-5B0121  #No.FUN-680096 INTEGER
            revision  LIKE type_file.chr2,      #版本   #No.FUN-680096 VARCHAR(2)
            effective LIKE type_file.dat,       #有效日期  #No.FUN-680096 DATE
            bmb03s    LIKE bmb_file.bmb03,
            bmb03e    LIKE bmb_file.bmb03,
            choice    LIKE type_file.chr1,      #是否列印彙總 #No.FUN-680096 VARCHAR(1)
            loccur    LIKE aza_file.aza17,      #本幣   #No.FUN-680096 VARCHAR(4)
            cur       LIKE aza_file.aza17,      #轉換幣別  #No.FUN-680096 VARCHAR(4)
            rate1     LIKE azk_file.azk03,      #匯率
            rate2     LIKE azk_file.azk03,      #匯率
            s         LIKE type_file.chr1,      #Sort Sequence  #No.FUN-680096 VARCHAR(1)
            sub_flag  LIKE type_file.chr1,      #FUN-C40074
            more      LIKE type_file.chr1       #Input more condition(Y/N)  #No.FUN-680096 VARCHAR(1)
        END RECORD,
        g_azi02,g_azi02_2   LIKE azi_file.azi02,
#No.CHI-6A0004-------Begin-----
#        g_azi03_2   LIKE azi_file.azi03,
#        g_azi04_2   LIKE azi_file.azi04,
#        g_azi05_2   LIKE azi_file.azi05,
#No.CHI-6A0004------End-------
        g_tot               LIKE type_file.num10,   #No.FUN-680096 INTEGER
        #g_str1,g_str2      LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)  #MOD-850277 mark
        #g_cur,g_cur2       LIKE aab_file.aab02,    #No.FUN-680096 VARCHAR(6)   #MOD-850277 mark
        g_str1,g_str2       LIKE type_file.chr50,   #MOD-850277
        g_cur,g_cur2        LIKE azi_file.azi02,    #MOD-850277 
        g_bma01_a           LIKE bma_file.bma01,
        g_bma06_a           LIKE bma_file.bma06     #FUN-550095
       #g_dash2             VARCHAR(142)  #TQC-5A0032  #FUN-5B0121 mark
DEFINE   g_chr           LIKE type_file.chr1        #No.FUN-680096 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE    l_table     STRING,                 ### CR11 ###
          g_str       STRING,                 ### CR11 ###
          g_sql       STRING                  ### CR11 ###
DEFINE    l_table1    STRING   #FUN-C40074

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
   #MOD-720044 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/01/29 TSD.Martin  *** ##
   LET g_sql = "bma01.bma_file.bma01, ",        #主件料件
               "bmb01.bmb_file.bmb01,",         #本階主件
               "bmb03.bmb_file.bmb03,",         #元件料號
               "bmb06.bmb_file.bmb06,",         #QPA/BASE
               "bmb10_fac.bmb_file.bmb10_fac,", #發料單位
               "ima44_fac.ima_file.ima44_fac,", #採購單位
               "ima02.ima_file.ima02,",         #品名規格
               "ima08.ima_file.ima08,",         #來源
               "ima103.ima_file.ima103,",
               "ima53.ima_file.ima53,",
               "ima531.ima_file.ima531,",
               "ima532.ima_file.ima532,",
               "ima91.ima_file.ima91,",
               "imb218.imb_file.imb218,",
               "imb221.imb_file.imb221,",
               "bmb10.bmb_file.bmb10  ,",
               "g_bma01_a.bma_file.bma01,",
               "g_bma06_a.bma_file.bma06,", 
               "l_ima02.ima_file.ima02,",      #品名規格
               "l_ima05.ima_file.ima05,",      #版本
               "l_ima08.ima_file.ima08,",      #來源
               "l_ima25.ima_file.ima25,",      #庫存單位
               "l_ima25_b.ima_file.ima25, ",   #單身的庫存單位
               "g_azi03.azi_file.azi03, ",
               "azi03.azi_file.azi03, ",
               "azi07.azi_file.azi07 ," ,      #No.FUN-870151
               "l_desc.type_file.chr20,",        #MOD-850052 modify 2->20
              "bmb16.bmb_file.bmb16"          #FUN-C40074 
   
   LET l_table = cl_prt_temptable('abmr622',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生

   #FUN-C40074---begin
      LET g_sql = "l_bma01.bma_file.bma01,l_ima25a.ima_file.ima25,",
                  "l_ima02a.ima_file.ima02,l_bmd01.bmd_file.bmd01,",
                  "l_ima021a.ima_file.ima02,l_bmd04.bmd_file.bmd04,",
                  "l_bmd05.bmd_file.bmd05,l_bmd06.bmd_file.bmd06,",
                  "l_bmd07.bmd_file.bmd07,l_bmb06a.bmb_file.bmb06,",
                  "l_ima53a.ima_file.ima53,l_azi03.azi_file.azi03,",
                  "l_amt1a.ima_file.ima53,l_imb218a.imb_file.imb218,",
                  "l_amt2a.ima_file.ima53,l_ima531a.ima_file.ima531,",
                  "l_amt3a.ima_file.ima53"
   LET l_table1 = cl_prt_temptable('abmr6221',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
   #FUN-C40074---end   
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? ,?, ",
               "        ?, ?, ?, ?, ?,   ?, ? , ?, ? ,?, ",
               "        ?, ?, ?, ?, ?,   ?, ? , ?) " #FUN-870151 add ? #FUN-C40074
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   #FUN-C40074---begin 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)" 
   PREPARE insert_prep1 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM                         
   END IF 
   #FUN-C40074---end
   
   #----------------------------------------------------------CR (1) ------------#
   #MOD-720044 - END
 
   LET g_pdate = ARG_VAL(1)                     #Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.qty = ARG_VAL(8)   #FUN-5B0121
   LET tm.revision = ARG_VAL(9)
   LET tm.effective= ARG_VAL(10)
   LET tm.choice   = ARG_VAL(11)
   LET tm.loccur   = ARG_VAL(12)
   LET tm.cur      = ARG_VAL(13)
   LET tm.rate1    = ARG_VAL(14)
   LET tm.rate2    = ARG_VAL(15)
   LET tm.s        = ARG_VAL(16)
   LET tm.sub_flag = ARG_VAL(17) #FUN-C40074
  #TQC-610068-begin
   LET tm.bmb03s   = ARG_VAL(18)
   LET tm.bmb03e   = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
  #TQC-610068-end
 
   IF cl_null(g_bgjob)  OR g_bgjob = 'N' THEN   #If background job sw is off
      CALL r622_tm(0,0)                         #Input print condition
   ELSE
      CALL r622()                              #Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r622_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_fld       LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          l_one       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_bdate     LIKE bmx_file.bmx07,
          l_edate     LIKE bmx_file.bmx08,
          l_bma01     LIKE bma_file.bma01,
          l_bma06     LIKE bma_file.bma06,    #FUN-550095
          l_cmd       LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW r622_w AT p_row,p_col WITH FORM "abm/42f/abmr622"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.qty = 1    #FUN-5B0121
   LET tm.effective = g_today
   LET tm.s      = '1'
   LET tm.sub_flag  = 'N'  #FUN-C40074
#  LET tm.choice = '3'                #FUN-670106
   LET tm.choice = '1'                #FUN-670106  
   LET tm.loccur = g_aza.aza17
   LET tm.cur    = g_aza.aza17
   LET tm.rate1  = 1
   LET tm.rate2  = 1
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   LET tm.bmb03s = NULL
   LET tm.bmb03e = NULL
   LET l_one='N'
 
   CONSTRUCT tm.wc ON bma01,bma06,ima103,ima06,ima09,ima10,ima11,ima12 #FUN-550095 add
                 FROM bma01,bma06,ima103,ima06,ima09,ima10,ima11,ima12
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    #--No.FUN-4A0001--------
     ON ACTION CONTROLP
        CASE WHEN INFIELD(bma01) #主件編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
     	      LET g_qryparam.form = "q_ima"
     	      CALL cl_create_qry() RETURNING g_qryparam.multiret
     	      DISPLAY g_qryparam.multiret TO bma01
     	      NEXT FIELD bma01
        OTHERWISE EXIT CASE
        END CASE
     #--END---------------
 
     ON ACTION locale
        #CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        LET g_action_choice = "locale"
        EXIT CONSTRUCT
 
     AFTER FIELD bma01
        LET l_fld = GET_FLDBUF(bma01)
        IF l_fld IS NOT NULL THEN
           LET l_one  ='Y'
        END IF
 
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
      LET INT_FLAG = 0 EXIT WHILE
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
  #INPUT BY NAME tm.bmb03s,tm.bmb03e,tm.revision,tm.effective,          #FUN-5B0121 mark
   INPUT BY NAME tm.qty,tm.bmb03s,tm.bmb03e,tm.revision,tm.effective,   #FUN-5B0121
#                tm.choice,                       #FUN-670106
                 tm.loccur,tm.cur,
                 tm.rate1,tm.rate2,tm.s,tm.sub_flag,tm.more  #FUN-C40074
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     #start FUN-5B0121
      AFTER FIELD qty
         IF cl_null(tm.qty) OR tm.qty < 0 THEN
            CALL cl_err(tm.qty,'mfg1322',1)
            NEXT FIELD qty
         END IF
     #end FUN-5B0121
 
      BEFORE FIELD bmb03e
         LET tm.bmb03e = tm.bmb03s
         DISPLAY BY NAME tm.bmb03e
 
      AFTER FIELD bmb03e
         IF tm.bmb03e < tm.bmb03s THEN
            NEXT FIELD bmb03s
         END IF
 
      BEFORE FIELD revision
         IF l_one='N' THEN
             NEXT FIELD effective
         END IF
 
      AFTER FIELD revision
         IF tm.revision IS NOT NULL THEN
            CALL s_version(l_bma01,tm.revision)
            RETURNING l_bdate,l_edate,l_flag
            LET tm.effective = l_bdate
            DISPLAY BY NAME tm.effective
         END IF
#FUN-670106--begin
#     AFTER FIELD choice
#        IF tm.choice IS NULL OR tm.choice NOT MATCHES'[123]'
#        THEN NEXT FIELD choice
#        END IF
#FUN-670106--end
      AFTER FIELD cur
         IF tm.cur IS NULL OR tm.cur = ' '
         THEN NEXT FIELD cur
         ELSE SELECT azi01 FROM azi_file WHERE azi01 = tm.cur
              IF SQLCA.sqlcode THEN
                 CALL cl_err(tm.cur,'mfg3008',1)
                 NEXT FIELD cur
              END IF
              CALL s_curr3(tm.cur,g_today,'B')     #買入
                   RETURNING tm.rate1
              CALL s_curr3(tm.cur,g_today,'S')     #賣出
                   RETURNING tm.rate2
              DISPLAY BY NAME tm.rate1,tm.rate2
         END IF
 
      AFTER FIELD rate1
         IF tm.rate1 IS NULL OR tm.rate1 = ' '
            OR tm.rate1 = 0  OR tm.rate1 <= 0
         THEN  NEXT FIELD rate1
         END IF
      AFTER FIELD rate2
         IF tm.rate2 IS NULL OR tm.rate2 = ' '
            OR tm.rate2 = 0  OR tm.rate2 <= 0
         THEN  NEXT FIELD rate2
         END IF
      AFTER FIELD s
         IF tm.s IS NULL OR tm.s NOT MATCHES'[12]'
         THEN NEXT FIELD s
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF tm.loccur IS NULL OR tm.loccur = ' '
         THEN NEXT FIELD loccur
         END IF
         IF tm.cur IS NULL OR tm.cur = ' '
         THEN NEXT FIELD cur
         END IF
         IF tm.rate1 IS NULL OR tm.rate1 = ' '
         THEN LET tm.rate1 = 1
         END IF
         IF tm.rate2 IS NULL OR tm.rate2 = ' '
         THEN LET tm.rate2 = 1
         END IF
 
      ON ACTION controlp     #查詢條件
         CASE
            WHEN INFIELD(cur)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = tm.cur
               CALL cl_create_qry() RETURNING tm.cur
               DISPLAY BY NAME tm.cur
               NEXT FIELD cur
#FUN-4B0061 add
            WHEN INFIELD(rate2)
               CALL s_rate(tm.cur,tm.rate2) RETURNING tm.rate2
               DISPLAY BY NAME tm.rate2
               NEXT FIELD rate2
##
#No.FUN-570240  --start-
            WHEN INFIELD(bmb03s)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.default1 = tm.bmb03s
               CALL cl_create_qry() RETURNING tm.bmb03s
               DISPLAY BY NAME tm.bmb03s
               NEXT FIELD bmb03s
            WHEN INFIELD(bmb03e)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.default1 = tm.bmb03e
               CALL cl_create_qry() RETURNING tm.bmb03e
               DISPLAY BY NAME tm.bmb03e
#No.FUN-570240 --end--
           OTHERWISE EXIT CASE
         END CASE
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
   IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
  #MOD-C30914 str mark------
  #IF tm.bmb03s IS NULL THEN
  #   LET tm.bmb03s = '00000000'
  #END IF
  #IF tm.bmb03e IS NULL THEN
  #   LET tm.bmb03e = 'zzzzzzzz'
  #END IF
  #MOD-C30914 end mark------
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='abmr622'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('abmr622','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.qty CLIPPED,"'",     #FUN-5B0121
                        #" '",tm.bmb03s CLIPPED,"'",  #TQC-610068
                        #" '",tm.bmb03e CLIPPED,"'",  #TQC-610068
                         " '",tm.revision CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'",
                        #" '",tm.choice    CLIPPED,"'",#FUN-670106
                         " '",tm.loccur    CLIPPED,"'",
                         " '",tm.cur       CLIPPED,"'",
                         " '",tm.rate1     CLIPPED,"'",
                         " '",tm.rate2     CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.sub_flag CLIPPED,"'",  #FUN-C40074
                        #TQC-610068-begin
                         " '",tm.bmb03s     CLIPPED,"'",
                         " '",tm.bmb03e     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
                        #TQC-610068-end
         CALL cl_cmdat('abmr622',g_time,l_cmd)
      END IF
      EXIT WHILE
   END IF
   CALL cl_wait()
   CALL r622()
   ERROR ""
END WHILE
CLOSE WINDOW r622_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION r622()
    DEFINE l_name       LIKE type_file.chr20,   #External(Disk) file name #No.FUN-680096 VARCHAR(20)
           l_name2      LIKE type_file.chr20,   #External(Disk) file name #No.FUN-680096 VARCHAR(20)
#       l_time           LIKE type_file.chr8           #No.FUN-6A0060
           l_sql        LIKE type_file.chr1000, #RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
           l_za05       LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
           l_cmd        LIKE type_file.chr50,   #No.FUN-680096  #No.FUN-680096 VARCHAR(30)
           l_bma01      LIKE bma_file.bma01,    #主件料件
           l_bma06      LIKE bma_file.bma06     #FUN-550095
 
   #MOD-720044 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)  #FUN-C40074
   #------------------------------ CR (2) ------------------------------#
   #MOD-720044 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720044 add
 
#No.FUN-670106--begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr622'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 156 END IF   #TQC-5B0072   #FUN-5B0121 142->156
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-670106--end
    FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
   #LET g_len=117 #TQC-5B0072   #FUN-5B0121 mark
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc CLIPPED," AND bmauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同部門的資料
    #        LET tm.wc = tm.wc CLIPPED," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc CLIPPED," AND bmagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
    #End:FUN-980030
 
    LET l_sql = "SELECT UNIQUE bma01,bma06 ", #FUN-550095 add bma06
                " FROM bma_file, ima_file",
                " WHERE ima01 = bma01",
                " AND ",tm.wc CLIPPED,
                " ORDER BY 1,2 " #FUN-550095
    PREPARE r622_prepare1 FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM 
       END IF
    DECLARE r622_c1 CURSOR FOR r622_prepare1
#FUN-670106--begin
#   IF tm.choice = '3' THEN                    
    LET tm.choice = '1'                      
        LET l_name2=l_name
        LET l_name2[11,11]='x'
#   ELSE
       LET l_name2= l_name
#   END IF
{
    IF tm.choice matches'[13]' THEN
       START REPORT r622_rep TO l_name
    END IF
}
#   IF tm.choice matches'[23]' THEN
#      START REPORT r622_rep2 TO l_name2
#   END IF
#FUN-670106--end
    #---->讀取本幣資料
#NO.CHI-6A0004-------Begin-------
#    SELECT azi02,azi03,azi04,azi05
#      INTO g_azi02,g_azi03,g_azi04,g_azi05
#      FROM azi_file
#     WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004------End----------
   #LET g_cur = g_azi02[1,6]   #MOD-850277 mark
    LET g_cur = g_azi02        #MOD-850277 
 
    #---->讀取外幣資料
    SELECT azi02,azi03,azi04,azi05
      INTO g_azi02_2,t_azi03,t_azi04,t_azi05           #No.CHI-6A0004
      FROM azi_file
     WHERE azi01 = tm.cur
   #LET g_cur2 = g_azi02_2[1,6]   #MOD-850277 mark
    LET g_cur2 = g_azi02_2        #MOD-850277
    LET g_str  = g_cur ,'             ',
                 g_cur2,'             ',
                 g_cur ,'             ',
                 g_cur2,'             ',
                 g_cur ,'             ',g_cur2
     LET g_str1 = g_cur, g_x[30].substring(1,2),g_cur2,g_x[30].substring(3,6),':' #MOD-520129
     LET g_str2 = g_cur2,g_x[30].substring(1,2),g_cur, g_x[30].substring(3,6),':' #MOD-520129
     LET g_pageno = 0  #MOD-530217    #TQC-5B0072 mark 取消
    LET g_tot=0
    FOREACH r622_c1 INTO l_bma01,l_bma06 #FUN-550095 add l_bma06
	message "->",l_bma01 CLIPPED,l_bma06 #FUN-550095
        CALL ui.Interface.refresh()
        IF SQLCA.sqlcode THEN
                 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH   
        END IF
        LET g_bma01_a=l_bma01
        LET g_bma06_a=l_bma06 #FUN-550095
        CALL r622_bom(1,l_bma01,l_bma06) #FUN-550095 add bma06
    END FOREACH
{
    IF tm.choice matches'[13]' THEN
       FINISH REPORT r622_rep
    END IF
    IF tm.choice  = '1' THEN                
#FUN-670106--end
       LET l_sql='cat ',l_name2,'>> ',l_name
       RUN l_sql
       LET l_sql='rm  ',l_name2
       RUN l_sql
    END IF
    
}
    LET INT_FLAG = 0  ######add for prompt bug
    IF INT_FLAG THEN LET INT_FLAG = 0 END IF
  #  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
   #MOD-720044 - START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, "|",   #FUN-710080 modify #FUN-C40074
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED  #FUN-C40074
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'bma01,bma06,ima103,ima06,ima09,ima10,ima11,ima12')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
    
   IF tm.choice = '1' THEN   
      LET g_str = g_str,";",tm.s,";",tm.rate1,";",tm.rate2,
                  ";",g_cur,";",g_cur2,";",tm.qty,";",tm.sub_flag #FUN-C40074
      CALL cl_prt_cs3('abmr622','abmr622',l_sql,g_str)   #FUN-710080 modify
   END IF 
   #MOD-720044 - END
END FUNCTION
 
FUNCTION r622_bom(p_total,p_key,p_key2) #FUN-550095 add p_key2
   DEFINE p_total    LIKE type_file.num20_6, #No.FUN-680096 DEC(20,6)
          p_key      LIKE bma_file.bma01,    #主件料件編號
          p_key2     LIKE bma_file.bma02,    #FUN-550095
          l_ac,i,arrno    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_bmb03    LIKE bmb_file.bmb03,    #元件料號
          sr  DYNAMIC ARRAY OF RECORD        #每階存放資料
              order1 LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              order2 LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              bma01  LIKE bma_file.bma01,       #主件料件
              bmb01  LIKE bmb_file.bmb01,       #本階主件
              bmb03  LIKE bmb_file.bmb03,       #元件料號
              bmb06  LIKE bmb_file.bmb06,       #QPA/BASE
              bmb10_fac LIKE bmb_file.bmb10_fac,#發料單位
              ima44_fac LIKE ima_file.ima44_fac,#採購單位
              ima02 LIKE ima_file.ima02,       #品名規格        #TQC-5B0130
              ima08  LIKE ima_file.ima08,       #來源
              ima103 LIKE ima_file.ima103,
              ima53  LIKE ima_file.ima53,
              ima531 LIKE ima_file.ima531,
              ima532 LIKE ima_file.ima532,
              ima91  LIKE ima_file.ima91,
              imb218 LIKE imb_file.imb218,
              imb221 LIKE imb_file.imb221,
            ##ima44  LIKE ima_file.ima44    ##NO.FUN-610092 ##NO.TQC-6C0034
              bmb10  LIKE bmb_file.bmb10,    ##NO.FUN-610092 ##NO.TQC-6C0034
              bmb16  LIKE bmb_file.bmb16    #FUN-C40074
          END RECORD,
          l_ima02 LIKE ima_file.ima02,      #品名規格
          l_ima05 LIKE ima_file.ima05,      #版本
          l_ima08 LIKE ima_file.ima08,      #來源
          l_ima25 LIKE ima_file.ima25,      #庫存單位
          l_desc  LIKE type_file.chr20,     #No.FUN-680096 VARCHAR(2)  #MOD-850052 modify 2->20
          l_cmd   LIKE type_file.chr1000,   #No.FUN-680096 VARCHAR(1000)
          l_bmaacti LIKE bma_file.bmaacti   #No.TQC-C50120 add
   DEFINE l_ima25_b LIKE ima_file.ima25
   DEFINE l_cnt     LIKE type_file.num10    #No.MOD-870284
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
   #FUN-C40074---begin
   DEFINE l_sql     STRING                  
   DEFINE l_bmd     RECORD LIKE bmd_file.*  
   DEFINE l_bon     RECORD LIKE bon_file.*  
   DEFINE l_ima01   LIKE ima_file.ima01    
   DEFINE l_ima02a  LIKE ima_file.ima02     
   DEFINE l_ima021a LIKE ima_file.ima021    
   DEFINE l_ima25_a LIKE ima_file.ima25     
   DEFINE l_bmb06a  LIKE bmb_file.bmb06     
   DEFINE l_ima53a  LIKE ima_file.ima53     
   DEFINE l_amt1a   LIKE ima_file.ima53  
   DEFINE l_imb218a LIKE imb_file.imb218
   DEFINE l_amt2a   LIKE ima_file.ima53 
   DEFINE l_ima531a LIKE ima_file.ima531
   DEFINE l_amt3a   LIKE ima_file.ima53
   #FUN-C40074---end
   
    #TQC-C50120--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file
     WHERE bma01 = p_key
       AND bma06 = p_key2
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50120--add--end--
    LET arrno = 600
    LET l_bmb03 = ' '
    WHILE TRUE
        LET l_cmd=
            "SELECT '','',bma01,bmb01,bmb03,((bmb06/bmb07)*bmb10_fac),",
            "       bmb10_fac,ima44_fac,ima02,",         #TQC-5B0130
         ## "ima08,ima103,ima53,ima531,ima532,ima91,imb218,imb221",
         ## "ima08,ima103,ima53,ima531,ima532,ima91,imb218,imb221,ima44 ", ## NO.FUN-610092 #NO.TQC-6C0034
            "ima08,ima103,ima53,ima531,ima532,ima91,imb218,imb221,bmb10,bmb16 ", ## NO.FUN-610092 #NO.TQC-6C0034 #FUN-C40074
            "  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03=ima01 LEFT OUTER JOIN bma_file ON bmb03=bma01  LEFT OUTER JOIN imb_file ON bmb03=imb01 ",
            " WHERE ",
            "  bmb01='",p_key,"'",
            "   AND bmb29='",p_key2,"'" #FUN-550095 add
 
        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",tm.effective,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.effective,"' OR bmb05 IS NULL)"
        END IF
  # modified by Joanne Chen 97/09/18 --- begin
        IF l_bmb03 !=' ' THEN
           LET l_cmd=l_cmd CLIPPED,
                     " AND bmb03 > '",l_bmb03,"'",
                     " ORDER BY bmb01,bmb03"
        END IF
  # modified by Joanne Chen 97/09/18  ---- end
        PREPARE r622_prepare2 FROM l_cmd
        IF SQLCA.sqlcode THEN
            CALL cl_err('P1:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
            EXIT PROGRAM 
            END IF
        DECLARE r622_cur CURSOR FOR r622_prepare2
        LET l_ac = 1
        FOREACH r622_cur INTO sr[l_ac].*
	message sr[l_ac].bmb01,"->",sr[l_ac].bmb03
        CALL ui.Interface.refresh()
            IF SQLCA.sqlcode THEN
               #CALL cl_err(SQLCA.sqlcode,'r622_cur',0) #No.+045 010403 by plum
                CALL cl_err('r622_cur',SQLCA.SQLCODE,0)
                EXIT FOREACH
            END IF
            IF  sr[l_ac].ima103 IS NULL THEN LET sr[l_ac].ima103 = 0 END IF
            IF  sr[l_ac].ima531 IS NULL THEN LET sr[l_ac].ima531 = 0 END IF
            #-------市價如大於最近採購單價則以最近採購為主--------------
            IF sr[l_ac].ima53 > 0 THEN
               IF sr[l_ac].ima531 > sr[l_ac].ima53 THEN
                  LET sr[l_ac].ima531 = sr[l_ac].ima53
               END IF
            END IF
            IF  sr[l_ac].ima53  IS NULL THEN LET sr[l_ac].ima53  = 0 END IF
            IF  sr[l_ac].imb218 IS NULL THEN LET sr[l_ac].imb218 = 0 END IF
            IF  sr[l_ac].imb221 IS NULL THEN LET sr[l_ac].imb221 = 0 END IF
            IF  sr[l_ac].bmb06  IS NULL THEN LET sr[l_ac].bmb06  = 1 END IF
            LET sr[l_ac].bmb06 = sr[l_ac].bmb06 * p_total
           #FUN-8B0015--BEGIN-- 
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #FUN-8B0015--END--  
            LET l_ac = l_ac + 1
            IF  l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        FOR i = 1 TO l_ac-1
            #No.MOD-870284--begin--
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bmb_file
             WHERE bmb01 = sr[i].bma01
               AND (bmb04 <=tm.effective OR bmb04 IS NULL)
               AND (bmb05 > tm.effective OR bmb05 IS NULL)
            #NO.MOD-870284---end---
           #IF sr[i].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭) #No.MOD-870284 mark
            IF (sr[i].bma01 IS NOT NULL)  AND (l_cnt > 0) THEN  #No.MOD-870284
               #CALL r622_bom(sr[i].bmb06,sr[i].bmb03,' ') #FUN-550095 add ' '#FUN-8B0015
                CALL r622_bom(sr[i].bmb06,sr[i].bmb03,l_ima910[i]) #FUN-8B0015
            ELSE
                IF tm.s = '2' THEN
                    LET sr[i].order1 = sr[i].ima103
                    LET sr[i].order2 = sr[i].bmb03
                ELSE
                    LET sr[i].order1 = sr[i].bmb03
                    LET sr[i].order2 = sr[i].ima103
                END IF
               #------------------------------ CR (3) ------------------------------#
               #---->讀取本幣資料
              #-------------------No.MOD-830030 modify
              #IF sr[i].bmb03 >= tm.bmb03s AND sr[i].bmb03 <= tm.bmb03e THEN
              #IF sr[i].bmb03 < tm.bmb03s OR sr[i].bmb03 > tm.bmb03e THEN      #MOD-C30914 mark
               IF (sr[i].bmb03 < tm.bmb03s AND NOT cl_null(tm.bmb03s))  OR     #MOD-C30914 add
                  (sr[i].bmb03 > tm.bmb03e AND NOT cl_null(tm.bmb03e))  THEN   #MOD-C30914 add
              #-------------------No.MOD-830030 modify
                  CONTINUE FOR
               END IF 
               SELECT azi02
                 INTO g_azi02
                 FROM azi_file
                WHERE azi01 = g_aza.aza17
               LET g_cur = g_azi02[1,6]
               SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 =  g_aza.aza17  #No.FUN-870151
 
               #---->讀取外幣資料
               SELECT azi02,azi03,azi04,azi05
                 INTO g_azi02_2,t_azi03,t_azi04,t_azi05   #No.CHI-6A0004
                 FROM azi_file
                WHERE azi01 = tm.cur
               LET g_cur2 = g_azi02_2[1,6]
 
               LET l_ima25_b = '' 
                SELECT ima25 INTO l_ima25_b FROM ima_file 
                 WHERE ima01=sr[i].bmb03
                IF SQLCA.sqlcode THEN LET l_ima25_b = '' END IF
               SELECT ima02,ima05,ima08,ima25
                 INTO l_ima02,l_ima05,l_ima08,l_ima25
                 FROM ima_file
                WHERE ima01 = g_bma01_a
               IF SQLCA.sqlcode THEN
                  LET l_ima02='' LET l_ima05=''
                  LET l_ima08='' LET l_ima25=''
               END IF
               CALL s_purdesc(sr[i].ima103) RETURNING l_desc

               #FUN-C40074---begin
               IF tm.sub_flag ='Y' AND sr[i].bmb16 MATCHES '[12SU]' THEN
                  LET l_sql="SELECT bmd_file.*, ima02,ima021 FROM bmd_file,ima_file", 
                            " WHERE bmd01='",sr[i].bmb03,"' AND bmd04=ima01",
                            "  AND (bmd08='",sr[i].bmb01,"' OR bmd08='ALL')",
                            "  AND bmdacti = 'Y'"                                                
                   IF tm.effective IS NOT NULL THEN
                      LET l_sql=l_sql CLIPPED,
                         " AND (bmd05 <='",tm.effective CLIPPED,"' OR bmd05 IS NULL)",
                         " AND (bmd06 > '",tm.effective CLIPPED,"' OR bmd06 IS NULL)"
                   END IF
                  PREPARE r622_sub_p FROM l_sql
                  DECLARE r622_sub_c CURSOR FOR r622_sub_p
                  FOREACH r622_sub_c INTO l_bmd.*, l_ima02a, l_ima021a 
                  
                     LET l_ima25_a = '' 
                     SELECT ima25,ima53/ima44_fac,ima531/ima44_fac 
                       INTO l_ima25_a,l_ima53a,l_ima531a
                       FROM ima_file 
                      WHERE ima01=l_bmd.bmd04
                     IF SQLCA.sqlcode THEN 
                        LET l_ima25_a = ''
                        LET l_ima53a = ''
                        LET l_ima531a = ''
                     END IF
                     SELECT imb218+imb221
                       INTO l_imb218a
                     FROM imb_file 
                     WHERE imb01= l_bmd.bmd04
                     IF cl_null(l_imb218a) THEN LET l_imb218a = 0 END IF 

                     LET l_bmb06a = sr[i].bmb06 * l_bmd.bmd07
                     LET l_amt2a = l_imb218a*sr[i].bmb10_fac*l_bmb06a
                     
                     IF NOT cl_null(tm.qty) THEN
                        LET l_ima53a = l_ima53a * tm.qty
                        LET l_amt2a = l_amt2a * tm.qty
                        LET l_ima531a = l_ima531a * tm.qty
                     END IF 
                     
                     LET l_amt1a = l_ima53a*sr[i].bmb10_fac*l_bmb06a
                     LET l_amt3a = l_ima531a*sr[i].bmb10_fac*l_bmb06a
                 
                     EXECUTE insert_prep1 USING
                        sr[i].bmb01,l_ima25_a,l_ima02a,sr[i].bmb03,l_ima021a,   
                        l_bmd.bmd04,l_bmd.bmd05,l_bmd.bmd06,l_bmd.bmd07,l_bmb06a,
                        l_ima53a,g_azi03,l_amt1a,l_imb218a,l_amt2a,l_ima531a,
                        l_amt3a      
                  END FOREACH
               END IF
              IF tm.sub_flag ='Y' AND sr[i].bmb16 MATCHES '[7Z]' THEN                                  
                  LET l_sql="SELECT bon_file.*, ima01,ima02,ima021 FROM bon_file,bmb_file,ima_file",                
                            " WHERE imaacti = 'Y'",
                            "   AND bmb03 = '",sr[i].bmb03,"' AND bmb03 = bon01",
                            "   AND bmb01 = '",sr[i].bmb01,"' AND (bmb01 = bon02 or bon02 = '*')",
                            "   AND bmb16 = '7' AND bonacti = 'Y'",
                            "   AND ima251 = bon06  AND ima109 = bon07",
                            "   AND ima54  = bon08  AND ima022 BETWEEN bon04 AND bon05",
                            "   AND ima01 != bon01",
                            "   ORDER BY ima01"              
                  IF tm.effective IS NOT NULL THEN
                     LET l_sql=l_sql CLIPPED,
                         " AND (bon09 <='",tm.effective CLIPPED,"' OR bon09 IS NULL)",
                         " AND (bon10 > '",tm.effective CLIPPED,"' OR bon10 IS NULL)"
                  END IF
                  PREPARE r622_bon FROM l_sql
                  DECLARE r622_bon_c CURSOR FOR r622_bon
                  FOREACH r622_bon_c INTO l_bon.*,l_ima01,l_ima02a,l_ima021a  

                     LET l_ima25_a = '' 
                     SELECT ima25,ima53/ima44_fac,ima531/ima44_fac 
                       INTO l_ima25_a,l_ima53a,l_ima531a
                       FROM ima_file 
                      WHERE ima01=l_ima01
                     IF SQLCA.sqlcode THEN 
                        LET l_ima25_a = ''
                        LET l_ima53a = ''
                        LET l_ima531a = ''
                     END IF
                     SELECT imb218+imb221
                       INTO l_imb218a
                     FROM imb_file 
                     WHERE imb01= l_ima01
                     IF cl_null(l_imb218a) THEN LET l_imb218a = 0 END IF 

                     LET l_bmb06a = sr[i].bmb06 * l_bon.bon11
                     LET l_amt2a = l_imb218a*sr[i].bmb10_fac*l_bmb06a
                     
                     IF NOT cl_null(tm.qty) THEN
                        LET l_ima53a = l_ima53a * tm.qty
                        LET l_amt2a = l_amt2a * tm.qty
                        LET l_ima531a = l_ima531a * tm.qty
                     END IF 
                     
                     LET l_amt1a = l_ima53a*sr[i].bmb10_fac*l_bmb06a 
                     LET l_amt3a = l_ima531a*sr[i].bmb10_fac*l_bmb06a

                  
                     EXECUTE insert_prep1 USING
                        sr[i].bmb01,l_ima25_a,l_ima02a,sr[i].bmb03,l_ima021a,       
                        l_ima01,l_bon.bon09,l_bon.bon10,l_bon.bon11,l_bmb06a,
                        l_ima53a,g_azi03,l_amt1a,l_imb218a,l_amt2a,l_ima531a,
                        l_amt3a   
                  END FOREACH
               END IF   
               #FUN-C40074---end
               
               ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
               EXECUTE insert_prep USING 
                     sr[i].bma01, sr[i].bmb01, sr[i].bmb03, sr[i].bmb06,
                 sr[i].bmb10_fac, sr[i].ima44_fac, sr[i].ima02, sr[i].ima08,
                    sr[i].ima103, sr[i].ima53, sr[i].ima531, sr[i].ima532,
                     sr[i].ima91, sr[i].imb218, sr[i].imb221, sr[i].bmb10,
                     g_bma01_a  , g_bma06_a   , l_ima02     , l_ima05    ,
                     l_ima08    , l_ima25     , l_ima25_b   , g_azi03    , 
                     t_azi03    , t_azi07     ,l_desc       , sr[i].bmb16      #No.FUN-870151 add azi07 #FUN-C40074
       #------------------------------ CR (3) ------------------------------#
                IF tm.choice matches'[13]' THEN 
         #           OUTPUT TO REPORT r622_rep(sr[i].*,g_bma01_a,g_bma06_a) #FUN-550095 add bma06
                END IF
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        END IF
        LET l_bmb03 = sr[arrno].bmb03
    END WHILE
END FUNCTION
 
REPORT r622_rep(sr,p_bma01_a,p_bma06_a) #FUN-550095 add bma06
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          p_bma01_a  LIKE bma_file.bma01,
          p_bma06_a  LIKE bma_file.bma06,    #FUN-550095
          sr  RECORD
              order1 LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              order2 LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              bma01  LIKE bma_file.bma01,    #主件料件
              bmb01  LIKE bmb_file.bmb01,    #本階主件
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb10_fac LIKE bmb_file.bmb10_fac,#發料單位
              ima44_fac LIKE ima_file.ima44_fac,#採購單位
              ima02  LIKE ima_file.ima02,    #品名規格
              ima08  LIKE ima_file.ima08,    #來源
              ima103 LIKE ima_file.ima103,
              ima53  LIKE ima_file.ima53,
              ima531 LIKE ima_file.ima531,
              ima532 LIKE ima_file.ima532,
              ima91  LIKE ima_file.ima91,
              imb218 LIKE imb_file.imb218,
              imb221 LIKE imb_file.imb221,
            ##ima44  LIKE ima_file.ima44     #NO.FUN-610092 #NO.TQC-6C0034
              bmb10  LIKE bmb_file.bmb10     #NO.FUN-610092 #NO.TQC-6C0034
          END RECORD,
          l_ima02 LIKE ima_file.ima02,      #品名規格
          l_ima05 LIKE ima_file.ima05,      #版本
          l_ima08 LIKE ima_file.ima08,      #來源
          l_ima25 LIKE ima_file.ima25,      #庫存單位
          l_pur1,l_pur2,l_pur3,l_pur4       LIKE type_file.num20_6,#No.FUN-680096 DEC(20,6)
          l_avg1,l_avg2,l_avg3,l_avg4       LIKE type_file.num20_6,#No.FUN-680096 DEC(20,6)
          l_cst1,l_cst2,l_cst3,l_cst4       LIKE type_file.num20_6,#No.FUN-680096 DEC(20,6)
          l_purtot,l_avgtot,l_csttot LIKE type_file.num20_6,       #No.FUN-680096 DEC(20,6)
          l_unit_fac LIKE bmb_file.bmb10_fac,
          l_desc  LIKE type_file.chr20,     #No.FUN-680096 VARCHAR(2)  #MOD-850052 modify 2->20
          l_ima44_fac LIKE ima_file.ima44_fac
  #start FUN-5B0121
   DEFINE l_ima25_b LIKE ima_file.ima25,    #單身的庫存單位
          l_amt1    LIKE ima_file.ima53,  #qty*組成用量*採購單價    #No.FUN-680096 DECIMAL(20,6)
          l_amt2    LIKE ima_file.ima53,  #qty*組成用量*平均單價    #No.FUN-680096 DECIMAL(20,6)
          l_amt3    LIKE ima_file.ima53   #qty*組成用量*市價單價    #No.FUN-680096 DECIMAL(20,6)
  #end FUN-5B0121
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY p_bma01_a,p_bma06_a,sr.order1,sr.order2 #FUN-550095 add bma06
  FORMAT
   PAGE HEADER
      #公司名稱
#No.FUN-670106--begin
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
      #報表名稱
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED 
      LET g_pageno = g_pageno + 1                                                                                             
      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                         
      PRINT g_head CLIPPED,pageno_total                                                                                       
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
      PRINT ''
      PRINT COLUMN (g_len-17)/2,g_x[19] CLIPPED,tm.effective     #No.TQC-6B0108 
      SELECT ima02,ima05,ima08,ima25
        INTO l_ima02,l_ima05,l_ima08,l_ima25
        FROM ima_file
       WHERE ima01 = p_bma01_a
      IF SQLCA.sqlcode THEN
         LET l_ima02='' LET l_ima05=''
         LET l_ima08='' LET l_ima25=''
      END IF
#     PRINT g_dash CLIPPED #[1,g_len]           #MOD-640130  #FUN-670106
      PRINT g_dash[1,g_len]                     #FUN-670106
      #TQC-5A0032  --begin
      PRINT COLUMN  1,g_x[11] CLIPPED, p_bma01_a CLIPPED,' ',p_bma06_a CLIPPED, #FUN-550095 add
            COLUMN 52,g_x[13] CLIPPED, l_ima05,
            COLUMN 61,g_x[14] CLIPPED, l_ima08,
            COLUMN 85,g_x[15] CLIPPED, l_ima25
      PRINT g_x[12] CLIPPED, l_ima02,
#FUN-670106--begin
            COLUMN 52,g_x[30] CLIPPED, tm.rate1,
            COLUMN 85,g_x[45] CLIPPED, tm.cur
     PRINT ''
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
             g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
      PRINTX name=H2 g_x[47]
      PRINT g_dash1 
#FUN-670106--end
      LET l_last_sw = 'n'
 
   #BEFORE GROUP OF p_bma01_a #FUN-550095
   #   IF (PAGENO > 1 OR LINENO > 13) THEN
   #        SKIP TO TOP OF PAGE
   #   END IF
 
    BEFORE GROUP OF p_bma06_a #FUN-550095
       SKIP TO TOP OF PAGE
       LET l_pur1 = 0 LET l_avg1 = 0 LET l_cst1 = 0
       LET l_pur2 = 0 LET l_avg2 = 0 LET l_cst2 = 0
       LET l_pur3 = 0 LET l_avg3 = 0 LET l_cst3 = 0
       LET l_pur4 = 0 LET l_avg4 = 0 LET l_cst4 = 0
       LET l_purtot = 0 LET l_avgtot = 0 LET l_csttot = 0
 
    ON EVERY ROW
       NEED 2 LINES
       CALL s_purdesc(sr.ima103) RETURNING l_desc
       LET l_amt1 = 0  LET l_amt2 = 0  LET l_amt3 = 0   #FUN-5B0121
       IF sr.bmb03 >= tm.bmb03s AND sr.bmb03 <= tm.bmb03e THEN
       #TQC-5A0032  --begin
         #start FUN-5B0121
          SELECT ima25 INTO l_ima25_b FROM ima_file WHERE ima01=sr.bmb03
          IF SQLCA.sqlcode THEN LET l_ima25_b = '' END IF
          LET l_amt1 = cl_numfor(sr.ima53,15,g_azi03) * sr.bmb06 * tm.qty              #採購金額
          LET l_amt2 = cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06 * tm.qty   #平均金額
          LET l_amt3 = cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06 * tm.qty             #市價金額
          PRINTX name=D1 COLUMN g_c[31],sr.bmb03 CLIPPED,
                 COLUMN g_c[32],l_ima25_b CLIPPED, 
                 COLUMN g_c[33],cl_numfor(sr.bmb06,33,4) CLIPPED,
                 COLUMN g_c[34],sr.bmb10 CLIPPED,               #NO.TQC-6C0034
                 COLUMN g_c[35],cl_numfor(sr.ima53,35,g_azi03) CLIPPED,
                 COLUMN g_c[36],cl_numfor(l_amt1,36,g_azi03) CLIPPED,
                 COLUMN g_c[37],cl_numfor(sr.imb218+sr.imb221,37,g_azi03) CLIPPED,
                 COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi03) CLIPPED,
                 COLUMN g_c[39],cl_numfor(sr.ima531,39,g_azi03) CLIPPED,
                 COLUMN g_c[40],cl_numfor(l_amt3,40,g_azi03) CLIPPED,
                 COLUMN g_c[41],sr.ima532,
                 COLUMN g_c[42],l_desc            
           PRINTX name=D2 COLUMN g_c[47],sr.ima02 
            LET l_unit_fac = sr.bmb10_fac / sr.ima44_fac
            LET sr.ima53 = sr.ima53 * l_unit_fac
            LET sr.ima531= sr.ima531* l_unit_fac
            CASE
              WHEN sr.ima103 ='0'
                   LET l_pur1 = l_pur1 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
                   LET l_avg1 = l_avg1 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
                   LET l_cst1 = l_cst1 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
              WHEN sr.ima103 ='1'
                   LET l_pur2 = l_pur2 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
                   LET l_avg2 = l_avg2 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
                   LET l_cst2 = l_cst2 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
              OTHERWISE
                   LET l_pur3 = l_pur3 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
                   LET l_avg3 = l_avg3 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
                   LET l_cst3 = l_cst3 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
            END CASE
           #end FUN-610080
       END IF
       LET l_pur4 = l_pur4 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
       LET l_avg4 = l_avg4 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
       LET l_cst4 = l_cst4 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
 
   AFTER GROUP OF p_bma06_a #FUN-560100
       NEED  5 LINES
       PRINT g_dash2 CLIPPED #[1,g_len]    #MOD-640130
       LET l_purtot =  l_pur1 + l_pur2 + l_pur3
       LET l_avgtot =  l_avg1 + l_avg2 + l_avg3
       LET l_csttot =  l_cst1 + l_cst2 + l_cst3
       PRINT COLUMN  1,g_x[20] CLIPPED,
             COLUMN g_c[35],g_x[24],      
             COLUMN g_c[36],cl_numfor(l_pur1,36,g_azi03) CLIPPED,
             COLUMN g_c[37],g_x[25],    
             COLUMN g_c[38],cl_numfor(l_avg1,38,g_azi03) CLIPPED,
             COLUMN g_c[39],g_x[26], 
             COLUMN g_c[40],cl_numfor(l_cst1,40,g_azi03) CLIPPED
       PRINT COLUMN  1,g_x[21] CLIPPED,
             COLUMN g_c[35],g_x[24] CLIPPED, 
             COLUMN g_c[36],cl_numfor(l_pur2,36,g_azi03) CLIPPED,
             COLUMN g_c[37],g_x[25] CLIPPED, 
             COLUMN g_c[38],cl_numfor(l_avg2,38,g_azi03) CLIPPED,
             COLUMN g_c[39],g_x[26] CLIPPED,
             COLUMN g_c[40],cl_numfor(l_cst2,40,g_azi03) CLIPPED
       PRINT COLUMN  1,g_x[22] CLIPPED,
             COLUMN g_c[35],g_x[24] CLIPPED,
             COLUMN g_c[36],cl_numfor(l_pur3,36,g_azi03) CLIPPED,
             COLUMN g_c[37],g_x[25] CLIPPED,
             COLUMN g_c[38],cl_numfor(l_avg3,38,g_azi03) CLIPPED,
             COLUMN g_c[39],g_x[26] CLIPPED,
             COLUMN g_c[40],cl_numfor(l_cst3,40,g_azi03) CLIPPED
       PRINT COLUMN  1,g_x[46] CLIPPED,
             COLUMN g_c[35],g_x[24] CLIPPED,
             COLUMN g_c[36],cl_numfor(l_purtot,36,g_azi03) CLIPPED,
             COLUMN g_c[37],g_x[25] CLIPPED,
             COLUMN g_c[38],cl_numfor(l_avgtot,38,g_azi03) CLIPPED,
             COLUMN g_c[39],g_x[26] CLIPPED,
             COLUMN g_c[40],cl_numfor(l_csttot,40,g_azi03) CLIPPED
       PRINT COLUMN  1,g_x[23] CLIPPED,
             COLUMN g_c[35],g_x[24] CLIPPED,
             COLUMN g_c[36],cl_numfor(l_pur4,36,g_azi03) CLIPPED,
             COLUMN g_c[37],g_x[25] CLIPPED,
             COLUMN g_c[38],cl_numfor(l_avg4,38,g_azi03) CLIPPED,
             COLUMN g_c[39],g_x[26] CLIPPED,
             COLUMN g_c[40],cl_numfor(l_cst4,40,g_azi03) CLIPPED
 #      LET g_pageno = 0  #MOD-530217
 
   ON LAST ROW
      PRINT g_dash CLIPPED #[1,g_len]          #MOD-640130
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash CLIPPED #[1,g_len]       #MOD-640130 
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
 
END REPORT
 
#-------------------------------------------
#  報表格式(二)
#-------------------------------------------
REPORT r622_rep2(sr,p_bma01_a)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          p_bma01_a  LIKE bma_file.bma01,
          sr  RECORD
              order1 LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              order2 LIKE bmb_file.bmb03,    #No.FUN-680096 VARCHAR(20)
              bma01  LIKE bma_file.bma01,    #主件料件
              bmb01  LIKE bmb_file.bmb01,    #本階主件
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb10_fac LIKE bmb_file.bmb10_fac,#發料單位
              ima44_fac LIKE ima_file.ima44_fac,#採購單位
              ima02  LIKE ima_file.ima02,    #品名規格
              ima08  LIKE ima_file.ima08,    #來源
              ima103 LIKE ima_file.ima103,
              ima53  LIKE ima_file.ima53,
              ima531 LIKE ima_file.ima531,
              ima532 LIKE ima_file.ima532,
              ima91  LIKE ima_file.ima91,
              imb218 LIKE imb_file.imb218,
              imb221 LIKE imb_file.imb221,
            ##ima44  LIKE ima_file.ima44     #NO.FUN-610092 #NO.TQC-6C0034
              bmb10  LIKE bmb_file.bmb10     #NO.FUN-610092 #NO.TQC-6C0034
          END RECORD,
          l_ima02 LIKE ima_file.ima02,      #品名規格
          l_ima05 LIKE ima_file.ima05,      #版本
          l_ima08 LIKE ima_file.ima08,      #來源
          l_ima25 LIKE ima_file.ima25,      #庫存單位
          l_pur1,l_pur2,l_pur3,l_pur4       LIKE type_file.num20_6,#No.FUN-680096 DEC(20,6)
          l_avg1,l_avg2,l_avg3,l_avg4       LIKE type_file.num20_6,#No.FUN-680096 DEC(20,6)
          l_cst1,l_cst2,l_cst3,l_cst4       LIKE type_file.num20_6,#No.FUN-680096 DEC(20,6)
          l_purtot,l_avgtot,l_csttot        LIKE type_file.num20_6,#No.FUN-680096 DECIMAL(20,6)
          l_desc  LIKE type_file.chr20      #No.FUN-680096 VARCHAR(2)  #MOD-850052 modify 2->20
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY p_bma01_a,sr.order1,sr.order2
  FORMAT
   PAGE HEADER
      #公司名稱
      LET g_len=142                    #TQC-5B0072         #TQC-5B0130
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' ' THEN
         PRINT '';
      ELSE
         PRINT 'TO:',g_towhom;
      END IF
      #報表名稱
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[9]))/2 SPACES,g_x[9]
      #有效日期
      LET g_pageno = g_pageno + 1
      PRINT ''
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[19])-6)/2,
            g_x[19] CLIPPED,tm.effective,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash[1,g_len]
      PRINT COLUMN 52,g_str1,tm.rate1
      PRINT COLUMN 52,g_str2,tm.rate2
      PRINT ' '
      PRINT COLUMN 55,g_x[27] CLIPPED,COLUMN 123,g_x[28] CLIPPED
      PRINT COLUMN 15,g_x[29] CLIPPED,COLUMN  48,g_str CLIPPED  #TQC-5A0032
      PRINT '---------------------------------------- ', #TQC-5A0032
            '---------------- ',
            '---------------- ',
            '---------------- ',
            '---------------- ',
            '---------------- ',
           #'---------------- ' 
            '----------------'                 #MOD-640130
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF p_bma01_a
#      IF (PAGENO > 1 OR LINENO > 13) THEN
#           SKIP TO TOP OF PAGE
#      END IF
       LET l_pur1 = 0   LET l_avg1 = 0   LET l_cst1 = 0
       LET l_pur2 = 0   LET l_avg2 = 0   LET l_cst2 = 0
       LET l_pur3 = 0   LET l_avg3 = 0   LET l_cst3 = 0
       LET l_pur4 = 0   LET l_avg4 = 0   LET l_cst4 = 0
       LET l_purtot = 0 LET l_avgtot = 0 LET l_csttot = 0
 
    ON EVERY ROW
       IF sr.bmb03 >= tm.bmb03s AND sr.bmb03 <= tm.bmb03e THEN
         #start FUN-5B0121
         #CASE
         #  WHEN sr.ima103 ='0'   #內購成本
         #       LET l_pur1 = l_pur1 + (sr.ima53  * sr.bmb06)
         #       LET l_avg1 = l_avg1 + ((sr.imb218+sr.imb221) * sr.bmb06)
         #       LET l_cst1 = l_cst1 + (sr.ima531 * sr.bmb06)
         #  WHEN sr.ima103 ='1'   #外購成本
         #       LET l_pur2 = l_pur2 + (sr.ima53  * sr.bmb06)
         #       LET l_avg2 = l_avg2 + ((sr.imb218+sr.imb221) * sr.bmb06)
         #       LET l_cst2 = l_cst2 + (sr.ima531 * sr.bmb06)
         #  OTHERWISE             #其他成本
         #       LET l_pur3 = l_pur3 + (sr.ima53  * sr.bmb06)
         #       LET l_avg3 = l_avg3 + ((sr.imb218+sr.imb221) * sr.bmb06)
         #       LET l_cst3 = l_cst3 + (sr.ima531 * sr.bmb06)
         #END CASE
          CASE
            WHEN sr.ima103 ='0'   #內購成本
                 LET l_pur1 = l_pur1 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
                 LET l_avg1 = l_avg1 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
                 LET l_cst1 = l_cst1 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
            WHEN sr.ima103 ='1'   #外購成本
                 LET l_pur2 = l_pur2 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
                 LET l_avg2 = l_avg2 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
                 LET l_cst2 = l_cst2 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
            OTHERWISE             #其他成本
                 LET l_pur3 = l_pur3 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
                 LET l_avg3 = l_avg3 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
                 LET l_cst3 = l_cst3 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
          END CASE
         #end FUN-5B0121
       END IF
      #start FUN-5B0121
      #LET l_pur4 = l_pur4 + (sr.ima53  * sr.bmb06)
      #LET l_avg4 = l_avg4 + ((sr.imb218+sr.imb221) * sr.bmb06)
      #LET l_cst4 = l_cst4 + (sr.ima531 * sr.bmb06)
       LET l_pur4 = l_pur4 + (cl_numfor(sr.ima53,15,g_azi03)  * sr.bmb06) * tm.qty
       LET l_avg4 = l_avg4 + (cl_numfor(sr.imb218+sr.imb221,15,g_azi03) * sr.bmb06) * tm.qty
       LET l_cst4 = l_cst4 + (cl_numfor(sr.ima531,15,g_azi03) * sr.bmb06) * tm.qty
      #end FUN-5B0121
 
   AFTER GROUP OF p_bma01_a
       NEED 5 LINES
       LET l_purtot = l_pur1 + l_pur2 + l_pur3 #採購成本
       LET l_avgtot = l_avg1 + l_avg2 + l_avg3 #平均成本
       LET l_csttot = l_cst1 + l_cst2 + l_cst3 #市價成本
 
       ##TQC-5A0032  --begin
       PRINT p_bma01_a,
          COLUMN  42,cl_numfor(l_purtot,15,g_azi03)            CLIPPED,
          COLUMN  59,cl_numfor(l_purtot/tm.rate1,15,t_azi03)   CLIPPED,  #No.CHI-6A0004
          COLUMN  76,cl_numfor(l_avgtot,15,g_azi03)            CLIPPED,
          COLUMN  93,cl_numfor(l_avgtot/tm.rate1,15,t_azi03)   CLIPPED,  #No.CHI-6A0004
          COLUMN 110,cl_numfor(l_csttot,15,g_azi03)            CLIPPED,
          COLUMN 127,cl_numfor(l_csttot/tm.rate1,15,t_azi03)   CLIPPED    #No.CHI-6A0004
 
       PRINT g_x[20] CLIPPED,
          COLUMN  42,cl_numfor(l_pur1,15,g_azi03)            CLIPPED,
          COLUMN  59,cl_numfor(l_pur1/tm.rate1,15,t_azi03)   CLIPPED,   #No.CHI-6A0004
          COLUMN  76,cl_numfor(l_avg1,15,g_azi03)            CLIPPED,
          COLUMN  93,cl_numfor(l_avg1/tm.rate1,15,t_azi03)   CLIPPED,   #No.CHI-6A0004
          COLUMN 110,cl_numfor(l_cst1,15,g_azi03)            CLIPPED,
          COLUMN 127,cl_numfor(l_cst1/tm.rate1,15,t_azi03)   CLIPPED    #No.CHI-6A0004
 
       PRINT g_x[21] CLIPPED,
          COLUMN  42,cl_numfor(l_pur2,15,g_azi03)            CLIPPED,
          COLUMN  59,cl_numfor(l_pur2/tm.rate1,15,t_azi03)   CLIPPED,   #No.CHI-6A0004
          COLUMN  76,cl_numfor(l_avg2,15,g_azi03)            CLIPPED,
          COLUMN  93,cl_numfor(l_avg2/tm.rate1,15,t_azi03)   CLIPPED,   #No.CHI-6A0004
          COLUMN 110,cl_numfor(l_cst2,15,g_azi03)            CLIPPED,
          COLUMN 127,cl_numfor(l_cst2/tm.rate1,15,t_azi03)   CLIPPED   #No.CHI-6A0004
 
       PRINT g_x[22] CLIPPED,
          COLUMN  42,cl_numfor(l_pur3,15,g_azi03)            CLIPPED,
          COLUMN  59,cl_numfor(l_pur3/tm.rate1,15,t_azi03)   CLIPPED,  #No.CHI-6A0004
          COLUMN  76,cl_numfor(l_avg3,15,g_azi03)            CLIPPED,
          COLUMN  93,cl_numfor(l_avg3/tm.rate1,15,t_azi03)   CLIPPED,  #No.CHI-6A0004
          COLUMN 110,cl_numfor(l_cst3,15,g_azi03)            CLIPPED,
          COLUMN 127,cl_numfor(l_cst3/tm.rate1,15,t_azi03)   CLIPPED   #No.CHI-6A0004
 
       PRINT g_x[23] CLIPPED,
          COLUMN  42,cl_numfor(l_pur4,15,g_azi03)            CLIPPED,
          COLUMN  59,cl_numfor(l_pur4/tm.rate1,15,t_azi03)   CLIPPED,  #No.CHI-6A0004
          COLUMN  76,cl_numfor(l_avg4,15,g_azi03)            CLIPPED,
          COLUMN  93,cl_numfor(l_avg4/tm.rate1,15,t_azi03)   CLIPPED,  #No.CHI-6A0004
          COLUMN 110,cl_numfor(l_cst4,15,g_azi03)            CLIPPED, 
          COLUMN 127,cl_numfor(l_cst4/tm.rate1,15,t_azi03)   CLIPPED   #No.CHI-6A0004
       ##TQC-5A0032  --end
       PRINT ' '
 #      LET g_pageno = 0  #MOD-530217
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'bmb03,ima103,bma06,bmb09,bma10,bma11,bma12')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
         #No.TQC-630166 --start--
#        IF tm.wc[001,070]>' ' THEN
#           PRINT g_x[8] CLIPPED, COLUMN 10,tm.wc[001,070] CLIPPED END IF
#        IF tm.wc[071,140]>' ' THEN
#           PRINT COLUMN 10,tm.wc[071,140] CLIPPED END IF
#        IF tm.wc[141,210]>' ' THEN
#           PRINT COLUMN 10,tm.wc[141,210] CLIPPED END IF
#        IF tm.wc[211,280]>' ' THEN
#           PRINT COLUMN 10,tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #No.TQC-630166 ---end---
      END IF
 
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      PRINT ' '
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
 
END REPORT
#Patch....NO.TQC-610035 <002> #
