# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmr691.4gl
# Descriptions...: 主件用料用量差異分析表
# Input parameter:
# Return code....:
# Date & Author..: 95/03/03 By Jackson
# Modify.........:
# Modify........MOD-490437 04/09/24 ching add 料件開窗
# Modify........MOD-4A0041 04/10/05 By Mandy l_rowid無用到,所以刪除
# Modify.........: No.MOD-530217 05/03/23 By kim 頁次為空白
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-550095 05/06/06 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.TQC-5A0033 05/10/12 By elva 料號欄位放大
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.MOD-5B0274 05/11/22 By kim 未使用配方BOM時,特性代碼必須隱藏(per檔dummy改為table)
# Modify.........: No.MOD-5C0057 05/12/26 By  1.輸入料件後會有錯誤訊息顯示無此料件BOM
                            #                 2.當比較三個以上(包含三)料件BOM時，報表無法顯示資料
                            #                 3.資料選項選3"差異料"組成用量無數值
# Modify.........: No.TQC-610068 06/01/18 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-620143 06/02/27 By Claire 重新給g_len值
# Modify.........: No.MOD-650015 06/06/15 By douzh cl_err----->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0083 06/11/10 By xumin 報表寬度不符問題更正
# Modify.........: No.TQC-6B0108 06/11/20 By Ray 有效日期居中
# Modify.........: No.MOD-6A0044 06/10/17 By Claire tmp03格式設為小數
# Modify.........: No.TQC-740079 07/04/23 By Ray 增加"接下頁"和"結束"
# Modify.........: No.FUN-760076 07/07/19 By yoyo 報表cr轉換
# Modify.........: No.TQC-790090 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-830108 08/03/19 By Pengu mark rm_space() FUNCTION的呼叫
# Modify.........: No.MOD-840146 08/04/19 By Pengu 主件的品名列印異常
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40033 10/04/19 By fumk 追单MOD-9B0164 
# Modify.........: No.TQC-A40116 10/04/26 By liuxqa modify sql
# Modify.........: No.TQC-A80043 10/04/19 By destiny 報錯信息mf3382不存在，應為mfg3382
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C50120 12/05/15 By fengrui 抓BOM資料時，除去無效資料

DATABASE ds
GLOBALS "../../config/top.global"
 
  #FUN-550095
  #DEFINE g_no	ARRAY[100] OF LIKE ima_file.ima01
   DEFINE g_no	DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                              bma01    LIKE bma_file.bma01,
                              bma06    LIKE bma_file.bma06
                END RECORD
  #FUN-550095(end)
   DEFINE tm  RECORD
              vdate  LIKE type_file.dat,     #No.FUN-680096 DATE
              type   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
              s_part LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
              e_part LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
              name_p LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
              more   LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
#         g_part ARRAY[13] OF LIKE type_file.chr20, 
          g_part ARRAY[6]  OF LIKE bma_file.bma01, #No.FUN-680096 VARCHAR(40)
          g_code ARRAY[6]  OF LIKE bma_file.bma06, #No.FUN-680096 VARCHAR(20)
          g_bma01  LIKE bma_file.bma01,
          g_bma06  LIKE bma_file.bma06, #FUN-550095
          g_cc  LIKE type_file.num5,  # bma01 個數,判斷是否INSERT r691 #No.FUN-680096 SMALLINT
          g_bma DYNAMIC ARRAY OF RECORD  #FUN-550095
                   bma01    LIKE bma_file.bma01,
                   bma06    LIKE bma_file.bma06
                END RECORD,
          g_ima02 ARRAY[100] OF LIKE ima_file.ima02, #No.FUN-680096 VARCHAR(60)
          g_str1     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str11    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str2     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str2a    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str2b    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str2c    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str3     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(136)
          g_str4     LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(136)
 
DEFINE   g_cnt       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
#FUN-760076--start
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_str      STRING
#FUN-760076--end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   #LET tm.wc = ARG_VAL(7)
   LET tm.vdate = ARG_VAL(8)
   LET tm.type  = ARG_VAL(9)
  #TQC-610068-begin
   LET tm.s_part = ARG_VAL(10)
   LET tm.e_part = ARG_VAL(11)
   LET tm.name_p = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(10)
   #LET g_rep_clas = ARG_VAL(11)
   #LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
  #TQC-610068-end
   LET g_bgjob='N'
#FUN-760076--start
   LET g_sql = "tmp01.type_file.chr1000,",
               "tmp04.type_file.chr20,",
               "tmp02.type_file.chr1000,",
               "ima02.ima_file.ima02,",
               "tmp03.cae_file.cae07,",
               "l_str21a.type_file.chr1000,",
               "l_str21b.type_file.chr1000,",
               "l_str21c.type_file.chr1000 "
 
   LET l_table = cl_prt_temptable('abmr691',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
#FUN-760076--end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abmr691_tm(0,0)        # Input print condition
      ELSE CALL abmr691()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION abmr691_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          i,j	       LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_flag       LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000        #No.FUN-680096 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW abmr691_w AT p_row,p_col
        WITH FORM "abm/42f/abmr691"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
   #CALL cl_set_comp_att_text("dummy02","")
    #FUN-560021................end
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.vdate= g_today
   LET tm.type = '1'
   LET tm.s_part= 'Y'
   LET tm.e_part= 'Y'
   LET tm.name_p= 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
    INPUT ARRAY g_no WITHOUT DEFAULTS FROM s_no.*
       #MOD-5B0274...............begin
       ATTRIBUTE (COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
       BEFORE INPUT
          IF i != 0 THEN
              CALL fgl_set_arr_curr(i)
           END IF
       #MOD-5B0274...............end
       BEFORE ROW
          LET i=ARR_CURR()
 
       AFTER FIELD bma01
          IF NOT cl_null(g_no[i].bma01) THEN
              IF g_sma.sma118 != 'Y' THEN #FUN-550014 add if 判斷
                  SELECT bma01 FROM bma_file
                   WHERE bma01=g_no[i].bma01
                    # AND bma06=g_no[i].bma06     #No.MOD-5C0057 mark
                  IF STATUS THEN 
#                 CALL cl_err('sel bma:',STATUS,1) #No.TQC-660046
                  CALL cl_err3("sel","bma_file",g_no[i].bma01,"",STATUS,"","sel bma:",1)  # TQC-660046
                  NEXT FIELD bma01
                  END IF
              END IF
          END IF
       AFTER FIELD bma06
          IF g_no[i].bma06 IS NULL THEN LET g_no[i].bma06 = ' ' END IF
          IF NOT cl_null(g_no[i].bma01) THEN
              IF g_sma.sma118 = 'Y' THEN #FUN-550014 add if 判斷
                  SELECT bma01 FROM bma_file
                   WHERE bma01=g_no[i].bma01
                     AND bma06=g_no[i].bma06
                  IF STATUS THEN 
#                    CALL cl_err('sel bma:',STATUS,1) #No.TQC-660046
                     CALL cl_err3("sel","bma_file",g_no[i].bma01,g_no[i].bma06,STATUS,"","sel bma:",1)  # TQC-660046
                     NEXT FIELD bma01
                  END IF
              END IF
          END IF
 
       ON ACTION gen_detail
          CALL r691_gen()
          CONTINUE WHILE
 
        #MOD-490437
       ON ACTION CONTROLP
           #FUN-550095 add
           CASE WHEN INFIELD(bma01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bma6"
                     LET g_qryparam.default1 = g_no[i].bma01
       #              LET g_qryparam.default2 = g_no[i].bma06   #No.TQC-6A0083 add
                     CALL cl_create_qry() RETURNING g_no[i].bma01,g_no[i].bma06
                    #MOD-5B0274...............begin
                    #DISPLAY g_no[i].bma01 TO bma01 #FUN-550095
                    #DISPLAY g_no[i].bma06 TO bma06
                     DISPLAY BY NAME g_no[i].bma01
                     DISPLAY BY NAME g_no[i].bma06
                    #MOD-5B0274...............end
                OTHERWISE
                     EXIT CASE
           END CASE
           #FUN-550095(end)
       #--
 
 
 
      #MOD-5B0274...............begin
      #AFTER INPUT
      #   LET i=ARR_COUNT()
      #   FOR j=i+1 TO 100
      #   #   LET g_no[j]=NULL              #FUN-550095
      #       INITIALIZE g_no[j].* TO NULL  #FUN-550095
      #   END FOR
      #MOD-5B0274...............end
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW abmr691_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
       EXIT PROGRAM
          
    END IF
    IF g_no[1].bma01 IS NULL THEN #FUN-550095
       CALL cl_err('','9046',0)
       CONTINUE WHILE
    END IF
 
   INPUT BY NAME tm.vdate,tm.type,tm.s_part,tm.e_part,tm.name_p,tm.more
                 WITHOUT DEFAULTS
 
		AFTER FIELD type
			IF cl_null(tm.type) OR tm.type NOT MATCHES'[123]' THEN
    			NEXT FIELD type
			END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
		AFTER INPUT
			IF INT_FLAG THEN CLOSE WINDOW q617_w2 EXIT INPUT END IF
            LET l_flag = 'N'
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW abmr691_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abmr691'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr691','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         #" '",tm.wc CLIPPED,"'",
                         " '",tm.vdate CLIPPED,"'",
                        #TQC-610068-begin
                         " '",tm.type CLIPPED,"'",
                         " '",tm.s_part CLIPPED,"'",
                         " '",tm.e_part CLIPPED,"'",
                         " '",tm.name_p CLIPPED,"'",
                        #TQC-610068-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr691',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abmr691_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr691()
   ERROR ""
END WHILE
   CLOSE WINDOW abmr691_w
END FUNCTION
 
FUNCTION r691_gen()
   DEFINE l_sql   LIKE type_file.chr1000,      #No.FUN-680096 VARCHAR(2000)
          l_wc	  LIKE type_file.chr1000       #No.FUN-680096 VARCHAR(600)
   DEFINE l_bma01 LIKE type_file.chr20         #No.FUN-680096 VARCHAR(20)
   DEFINE i,j	  LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
   OPEN WINDOW r691_gen_w AT 10,20
        WITH FORM "abm/42f/abmr691y"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmr691y")
 
   CONSTRUCT BY NAME l_wc ON bma01
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   LET l_wc = l_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
 
   CLOSE WINDOW r691_gen_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET l_sql="SELECT bma01,bma06 FROM bma_file WHERE ",l_wc CLIPPED #FUN-550095 add bma06
   PREPARE r691_gen_p FROM l_sql
   DECLARE r691_gen_c CURSOR FOR r691_gen_p
  #FUN-550095 改成以下FOREACH
  #FOREACH r691_gen_c INTO l_bma01,l_bma06
  #   FOR i=1 TO 100
  #      IF g_no[i].bma01=l_bma01 AND g_no[i].bma06 = l_bma06 THEN CONTINUE FOREACH END IF
  #   END FOR
  #   FOR i=1 TO 100
  #      IF g_no[i].bma01 IS NULL THEN LET g_no[i].bma01=l_bma01 LET g_no[i].bma06=l_bma06 CONTINUE FOREACH END IF
  #   END FOR
  #END FOREACH
  #FOR i=100 TO 1 STEP -1 IF g_no[i].bma01 IS NOT NULL THEN EXIT FOR END IF END FOR
   LET i = 1
   FOREACH r691_gen_c INTO g_no[i].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET i = i + 1
 
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
  #FUN-550095(end)
   CALL SET_COUNT(i)
END FUNCTION
 
FUNCTION abmr691()
DEFINE l_sql     LIKE type_file.chr1000,     #No.FUN-680096 VARCHAR(3000)
       l_cmd     LIKE type_file.chr1000,     #No.FUN-680096 VARCHAR(1000)
       l_cmd1    LIKE type_file.chr1000,     #No.FUN-680096 VARCHAR(1000)
       l_i,l_ac,l_no LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_n           LIKE type_file.num5,    #No:8218  #No.FUN-680096 SMALLINT
       l_nn          LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_cnt,l_cn    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_name    LIKE type_file.chr20,       #No.FUN-680096 VARCHAR(20)
       l_name1   LIKE type_file.chr20,       #No.FUN-680096 VARCHAR(20)
      #l_str     VARCHAR(30),
       l_str     LIKE type_file.chr1000,     #No.FUN-680096 VARCHAR(120)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0060
       l_za05    LIKE type_file.chr1000,     #No.FUN-680096 VARCHAR(40)
#      l_str11  ARRAY[13] OF VARCHAR(9),   
#      l_str21  ARRAY[13] OF VARCHAR(9),
#      l_str21a ARRAY[13] OF VARCHAR(9),
#      l_str21b ARRAY[13] OF VARCHAR(9),
#      l_str21c ARRAY[13] OF VARCHAR(9),
#      l_str31  ARRAY[13] OF VARCHAR(9),
#      l_str41  ARRAY[13] OF VARCHAR(9),
#TQC-5A0033  --begin
       l_str11  ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str12  ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str21  ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str21a ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str21b ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str21c ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str31  ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_str41  ARRAY[3] OF LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
       l_tmp02  LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(40)           
#TQC-5A0033  --end
       l_tmp03  LIKE cae_file.cae07,     #No.FUN-680096 DEC(15,5)
       sr RECORD
          tmp01  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          tmp04  LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
          tmp02  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          ima02  LIKE ima_file.ima02,    #No.FUN-680096 VARCHAR(30)
          tmp03  LIKE cae_file.cae07     ##No.FUN-680096 SMALLINT  #MOD-6A0044 
       END RECORD
 
 
   DROP TABLE r691_file
#No.FUN-680096---------begin---------------
   CREATE TEMP TABLE r691_file(
       tmp01   LIKE type_file.chr1000,
       tmp04   LIKE type_file.chr20, 
       tmp02   LIKE type_file.chr1000,
       tmp03   LIKE cae_file.cae07)      #MOD-6A0044 
      #tmp03   LIKE type_file.num5)      #MOD-6A0044 mark
 ;
#No.FUN-680096--------------end-------------
   IF STATUS THEN CALL cl_err('c_tmp',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM 
   END IF
  #CREATE UNIQUE INDEX r691_01 on r691_file (tmp01,tmp02)#FUN-550095
   CREATE UNIQUE INDEX r691_01 on r691_file (tmp01,tmp04,tmp02)#FUN-550095 add tmp04
   CREATE        INDEX r691_02 on r691_file (tmp02)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#FUN-760076--start--mark
 #  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr691'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 163 END IF  #TQC-5A0033  #TQC-6A0083
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
  # FOR g_i = 1 TO 163 LET g_dash[g_i,g_i] = '=' END FOR   #TQC-6A0083
#FUN-760076--end--mark
 
   FOR l_i= 1 TO 100
       INITIALIZE g_bma[l_i].*  TO NULL  #FUN-550095
       INITIALIZE g_ima02[l_i]  TO NULL
   END FOR
   LET l_ac=1
   FOR l_i=1 TO 100
        IF g_no[l_i].bma01 IS NULL THEN CONTINUE FOR END IF #FUN-550095
        LET g_bma01=g_no[l_i].bma01 #FUN-550095
        IF cl_null(g_no[l_i].bma06) THEN LET g_no[l_i].bma06 = ' ' END IF #FUN-550095 add
        LET g_bma06=g_no[l_i].bma06 #FUN-550095
        MESSAGE g_bma01,g_bma06     #FUN-550095
        CALL ui.Interface.refresh()
        LET g_cc=0
        CALL r691_bom(0,g_bma01,g_bma06,1) #FUN-550095 add bma06
        IF g_cc > 0 THEN
           LET g_bma[l_ac].bma01=g_bma01 #FUN-550095
           LET g_bma[l_ac].bma06=g_bma06 #FUN-550095
           SELECT ima02 INTO g_ima02[l_ac] FROM ima_file WHERE ima01=g_bma01
           LET l_ac=l_ac+1
        END IF
        IF l_ac > 100 THEN
           CALL cl_err('>100','mfg9391',2) RETURN
        END IF
   END FOR
   LET g_cnt=l_ac-1
  #No.+045 010403 by plum
  #IF g_cnt=0 THEN CALL cl_err('NOT DATE',' ',0) RETURN END IF
  #IF g_cnt=0 THEN CALL cl_err('NOT DATE_1','mfg3382',0) RETURN END IF
 #IF g_cnt=0 THEN CALL cl_err('NOT DATE_a','mf3382',1) RETURN END　IF #No.CHI-A40033 modify 
  IF g_cnt=0 THEN CALL cl_err('NOT DATE_a','mfg3382',1) RETURN END　IF #No.TQC-A80043 modify 
   ###共用料及差異料需特別處理
   IF tm.type='2' OR tm.type='3' THEN
      DECLARE tmp_cs1 CURSOR FOR
              SELECT tmp02,tmp03,COUNT(*) FROM r691_file GROUP BY tmp02,tmp03
      FOREACH tmp_cs1 INTO l_tmp02,l_tmp03,l_cn
         IF tm.type='2' AND l_cn= g_cnt THEN CONTINUE FOREACH END IF
         IF tm.type='3' AND l_cn<>g_cnt THEN CONTINUE FOREACH END IF
         DELETE FROM r691_file WHERE tmp02=l_tmp02 AND tmp03=l_tmp03
      END FOREACH
 
      #----020225 CJC modi:若列印差異時,其中主號均無時,要印抬頭
      IF tm.type='3' THEN
         FOR l_i=1 TO 100
             IF g_no[l_i].bma01 IS NULL THEN CONTINUE FOR END IF #FUN-550095
             LET l_cnt = 0
             SELECT COUNT(*) INTO l_cnt
               FROM r691_file
              WHERE tmp01 = g_no[l_i].bma01 #FUN-550095
                AND tmp04 = g_no[l_i].bma06 #FUn-550095 add
             IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
             IF l_cnt =0 THEN
                INSERT INTO r691_file VALUES(g_no[l_i].bma01,g_no[l_i].bma06,NULL,NULL) #FUN-550095
             END IF
         END FOR
      END IF
      #--------------------------------------------------------
 
      FOR l_i= 1 TO 100
          INITIALIZE g_bma[l_i].*  TO NULL   #FUN-550095
          INITIALIZE g_ima02[l_i]  TO NULL
      END FOR
      LET l_ac=1
      DECLARE tmp_cs3 CURSOR FOR
            SELECT UNIQUE tmp01,ima02 FROM r691_file,OUTER ima_file
                  WHERE r691_file.tmp01=ima_file.ima01
                  ORDER BY 1
      FOREACH tmp_cs3 INTO g_bma[l_ac].bma01,g_ima02[l_ac] #FUN-550095
		 IF SQLCA.SQLCODE<0 THEN
			CALL cl_err('foreach tmp_cs3',SQLCA.SQLCODE,1)
			EXIT FOREACH
		 END IF
        IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
        LET l_ac=l_ac+1
      END FOREACH
      LET g_cnt=l_ac-1
     #No.+045 010403 by plum
     #IF g_cnt=0 THEN CALL cl_err('NOT DATE',' ',0) RETURN END IF
     #IF g_cnt=0 THEN CALL cl_err('NOT DATE_2','mfg3382',0) RETURN END IF
      IF g_cnt=0 THEN CALL cl_err('NOT DATE_2','mfg3382',1) RETURN END IF #No.CHI-A40033 modify  
 END IF
 
#FUN-760076--start
#   CALL cl_outnam('abmr691') RETURNING l_name
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED," values(?,?,?,?,?,?,?,?) "  
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?,?,?,?) " #TQC-A40116 
    PREPARE insert1 FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF
    CALL cl_del_data(l_table)
#FUN-760076--end
 
 
   #NO:8218
   #LET l_cnt=(13-(g_cnt MOD 13))+g_cnt     ###一行 13 個
#-------No.MOD-5C0057 modify
    IF (g_cnt MOD 3) <= 0 THEN
       LET l_cnt = g_cnt
    ELSE
       LET l_cnt=(3-(g_cnt MOD 3))+g_cnt     ###一行 3 個  #TQC-5A0033
    END IF
#--------No.MOD-5C0057 end
 
  #FOR l_i = 13 TO l_cnt STEP 13
   #TQC-5A0033 --begin
#FUN-760076--start   
#   FOR l_i = 3 TO l_cnt STEP 3
       #NO:8218
 
#       LET l_name1='r691_',l_i/3 USING '&&&','.out' #--No.MOD-5C0057 modify
#       IF g_len = 0 OR g_len IS NULL THEN LET g_len = 163 END IF  #TQC-620144   #TQC-6A0083
#       START REPORT abmr691_rep TO l_name1
#       FOR l_cn=1 TO 3
#           INITIALIZE g_part[l_cn] TO NULL
#           INITIALIZE g_code[l_cn] TO NULL #FUN-550095 add
#           LET l_str11[l_cn]=' '
#           LET l_str12[l_cn]=' ' #FUN-550095 add
#           LET l_str21[l_cn]=' '
#           LET l_str21a[l_cn]=' '
#           LET l_str21b[l_cn]=' '
#           LET l_str21c[l_cn]=' '
#           LET l_str31[l_cn]=' '
#           LET l_str41[l_cn]=' '
#       END FOR
#       LET g_str1=' '  LET g_str2=' ' LET g_str3=' ' LET g_str4='   '
#       LET g_str11=' ' #FUN-550095 add
#       LET g_str2a=' ' LET g_str2b=' ' LET g_str2c=' '
#       IF l_i <= g_cnt THEN
#          #TQC-5A0033  --begin
#          LET l_no=l_i-3    #NO:8218
#          FOR l_cn=1 TO 3   #NO:8218
#             LET l_str=g_bma[l_no+l_cn].bma01 #FUN-550095
#             LET g_part[l_cn]=l_str
#             LET g_code[l_cn]=g_bma[l_no+l_cn].bma06 #FUN-550095
#             #NO:8218
#             LET l_n = length(l_str[1,40])
#             LET l_nn = length(g_code[l_cn]) #FUN-550095 add
#             LET l_str11[l_cn]=l_str[1,40]   #NO:8218
#             LET l_str12[l_cn]=g_code[l_cn] #FUN-550095
#             IF l_n < 40 THEN
#                LET l_str11[l_cn] = l_str11[l_cn],(40-l_n) spaces
#             END IF
#             IF l_nn < 40 THEN
#                LET l_str12[l_cn] = l_str12[l_cn],(40-l_nn) spaces #FUN-550095 add
#             END IF
#             #NO:8218
#             LET l_n = length(l_str[41,80])
#             LET l_str21[l_cn]=l_str[41,80]
#             IF l_n < 40 THEN
#                LET l_str21[l_cn] = l_str21[l_cn],(40-l_n) spaces
#             END IF
#
#             LET l_str=g_ima02[l_no+l_cn]
#             CALL rm_space(l_str) RETURNING l_str
#             #NO:8218
#            #LET l_str21a[l_cn]=l_str[1,20]   #NO:8218
#             LET l_n = length(l_str[1,40])
#             LET l_str21a[l_cn]=l_str[1,40]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21a[l_cn] = l_str21a[l_cn],(40-l_n) spaces
#             END IF
#            #LET l_str21b[l_cn]=l_str[21,40]
#             #NO:8218
#             LET l_n = length(l_str[41,80])
#             LET l_str21b[l_cn]=l_str[41,80]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21b[l_cn] = l_str21b[l_cn],(40-l_n) spaces
#             END IF
#           # LET l_str21c[l_cn]=l_str[41,60]
#             #NO:8218
#             LET l_n = length(l_str[81,120])
#             LET l_str21c[l_cn]=l_str[81,120]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21c[l_cn] = l_str21c[l_cn],(40-l_n) spaces
#             END IF
#             #NO:8218
#             LET l_str31[l_cn]=g_x[13] CLIPPED,'                                '
#             LET l_str41[l_cn]=g_x[15] CLIPPED,'                                '
#          END FOR
#       ELSE
#         LET l_no=(l_i-3)   #NO:8218
#          FOR l_cn=1 TO (g_cnt-(l_i-3))   #NO:8218
#             LET l_str=g_bma[l_no+l_cn].bma01 #FUN-550095
#             LET g_part[l_cn]=l_str
#             LET g_code[l_cn]=g_bma[l_no+l_cn].bma06 #FUN-550095
#             LET l_n = length(l_str[1,40])
#             LET l_nn = length(g_code[l_cn]) #FUN-550095 add
#             LET l_str11[l_cn]=l_str[1,40]   #NO:8218
#             LET l_str12[l_cn]=g_code[l_cn] #FUN-550095 add
#             IF l_n < 40 THEN
#                LET l_str11[l_cn] = l_str11[l_cn],(40-l_n) spaces
#             END IF
#             IF l_nn < 40 THEN
#                LET l_str12[l_cn] = l_str12[l_cn],(40-l_nn) spaces #FUN-550095 add
#             END IF
#           # LET l_str11[l_cn]=l_str[1,20]  #NO:8218
#             #NO:8218
#             LET l_n = length(l_str[41,80])
#             LET l_str21[l_cn]=l_str[41,80]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21[l_cn] = l_str21[l_cn],(40-l_n) spaces
#             END IF
#           # LET l_str21[l_cn]=l_str[21,40]
#             LET l_str=g_ima02[l_no+l_cn]
#             CALL rm_space(l_str) RETURNING l_str
#            #LET l_str21a[l_cn]=l_str[1,20]   #NO:8218
#             #NO:8218
#             LET l_n = length(l_str[1,40])
#             LET l_str21a[l_cn]=l_str[1,40]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21a[l_cn] = l_str21a[l_cn],(40-l_n) spaces
#             END IF
#            #LET l_str21b[l_cn]=l_str[21,40]
#             #NO:8218
#             LET l_n = length(l_str[41,80])
#             LET l_str21b[l_cn]=l_str[41,80]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21b[l_cn] = l_str21b[l_cn],(40-l_n) spaces
#             END IF
#            #LET l_str21c[l_cn]=l_str[41,60]
#             #NO:8218
#             LET l_n = length(l_str[81,120])
#             LET l_str21c[l_cn]=l_str[81,120]   #NO:8218
#             IF l_n < 40 THEN
#                LET l_str21c[l_cn] = l_str21c[l_cn],(40-l_n) spaces
#             END IF
#             #NO:8218
#             LET l_str31[l_cn]=g_x[13] CLIPPED,'                                '
#             LET l_str41[l_cn]=g_x[15] CLIPPED,'                                '
#          END FOR
#       END IF
#       LET g_str1=41 SPACES,l_str11[1],l_str11[2],l_str11[3]#,l_str11[4],
#                  #NO:8218
#                 #l_str11[5],l_str11[6],l_str11[7],l_str11[8],l_str11[9],
#                 #l_str11[10],l_str11[11],l_str11[12],l_str11[13]
#                 #l_str11[5],l_str11[6]
#       LET g_str11=41 SPACES,l_str12[1],l_str12[2],l_str12[3]#,l_str12[4],
#                         #   l_str12[5],l_str12[6]
#
#       LET g_str2=41 SPACES,l_str21[1],l_str21[2],l_str21[3]#,l_str21[4],
#                  #NO:8218
#                 #l_str21[5],l_str21[6],l_str21[7],l_str21[8],l_str21[9],
#                 #l_str21[10],l_str21[11],l_str21[12],l_str21[13]
#                 #l_str21[5],l_str21[6]
#       LET g_str2a=41 SPACES,l_str21a[1],l_str21a[2],l_str21a[3]#,l_str21a[4],
#                 #NO:8218
#                 #l_str21a[5],l_str21a[6],l_str21a[7],l_str21a[8],l_str21a[9],
#                 #l_str21a[10],l_str21a[11],l_str21a[12],l_str21a[13]
#                 #l_str21a[5],l_str21a[6]
#       LET g_str2b=41 SPACES,l_str21b[1],l_str21b[2],l_str21b[3]#,l_str21b[4],
#                 #NO:8218
#                 #l_str21b[5],l_str21b[6],l_str21b[7],l_str21b[8],l_str21b[9],
#                 #l_str21b[10],l_str21b[11],l_str21b[12],l_str21b[13]
#                 #l_str21b[5],l_str21b[6]
#       LET g_str2c=41 SPACES,l_str21c[1],l_str21c[2],l_str21c[3]#,l_str21c[4],
#                 #NO:8218
#                 #l_str21c[5],l_str21c[6],l_str21c[7],l_str21c[8],l_str21c[9],
#                 #l_str21c[10],l_str21c[11],l_str21c[12],l_str21c[13]
#                 #l_str21c[5],l_str21c[6]
#
#       LET g_str3=l_str31[1],l_str31[2],l_str31[3]#,l_str31[4],
#                 #NO:8218
#                 #l_str31[5],l_str31[6],l_str31[7],l_str31[8],l_str31[9],
#                 #l_str31[10],l_str31[11],l_str31[12],l_str31[13]
#                 #l_str31[5],l_str31[6]
#
#       LET g_str4=l_str41[1],l_str41[2],l_str41[3]#,l_str41[4],
#                 #NO:8218
#                 #l_str41[5],l_str41[6],l_str41[7],l_str41[8],l_str41[9],
#                 #l_str41[10],l_str41[11],l_str41[12],l_str41[13]
#                 #l_str41[5],l_str41[6]
#          #TQC-5A0033  --end
#FUN-760076--end
       LET l_sql="SELECT tmp01,tmp04,tmp02,ima02,tmp03", #FUN-550095 add tmp04
                 "    FROM r691_file,OUTER ima_file",
                  "   WHERE r691_file.tmp02=ima_file.ima01",
                 "   ORDER BY 1,2,3 " #FUN-550095 add 3
       PREPARE tmp_pr FROM l_sql
       IF SQLCA.SQLCODE THEN
 #         CALL cl_err('CHK1:',STATUS,2) CONTINUE FOR
           CALL cl_err('CHK1:',STATUS,2)    #FUN-760076
       END IF
       DECLARE tmp_cs CURSOR FOR tmp_pr
       FOREACH tmp_cs INTO sr.*
		 IF SQLCA.SQLCODE<0 THEN
			CALL cl_err('foreach tmp_cs',SQLCA.SQLCODE,1)
			EXIT FOREACH
		 END IF
         IF SQLCA.SQLCODE THEN
            CALL cl_err('FP1:',status,2) EXIT FOREACH
         END IF
#FUN-760076--start         
#       OUTPUT TO REPORT abmr691_rep(sr.*)
       #-------No.MOD-840146 modify
       #LET l_str=sr.ima02
        SELECT ima02 INTO l_str FROM ima_file WHERE ima01 = sr.tmp01
       #-------No.MOD-840146 add
       #CALL rm_space(l_str) RETURNING l_str    #No.MOD-830108 mark
        LET l_str21a[1] = NULL
        LET l_str21b[1] = NULL
        LET l_str21c[1] = NULL
        LET l_str21a[1] = l_str[1,40]
        LET l_str21b[1] = l_str[41,80] 
        LET l_str21c[1] = l_str[81,120]
        EXECUTE insert1 USING  sr.tmp01,sr.tmp04,sr.tmp02,sr.ima02,sr.tmp03,
                               l_str21a[1],l_str21b[1],l_str21c[1]
 
       END FOREACH
       LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
       LET l_str = tm.vdate,";",tm.name_p
       CALL cl_prt_cs3('abmr691','abmr691',l_sql,l_str)       
#FUN-760076--end
 
#FUN-760076--start--mark       
#       FINISH REPORT abmr691_rep
      #No.3770 011011 add
#        LET l_cmd="chmod 777 ",l_name1
#        RUN l_cmd
      #No.3770 end---
 
###結合報表
#      #IF l_i/13 = 1 THEN #No:8218
#       IF l_i/3 = 1 THEN  #No:8218 #TQC-5A0033
#          LET l_cmd1='cat ',l_name1
#       ELSE
#          LET l_cmd1=l_cmd1 CLIPPED,' ',l_name1
#       END IF
#   END FOR
#   LET l_cmd1=l_cmd1 CLIPPED,' >',l_name
#   RUN l_cmd1
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-760076--end--mark
END FUNCTION
 
#---------No.MOD-830108 mark
#FUNCTION rm_space(p_str)
#   #DEFINE p_str VARCHAR(30) #No:8218
#   #DEFINE l_str VARCHAR(30) #No:8218
#    DEFINE p_str	LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(60)
#    DEFINE l_str	LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(60)
#    DEFINE i,j,k	LIKE type_file.num5      #No.FUN-680096 SMALLINT
#    LET j=0
#   #FOR i=1 TO 30 #No:8218
#    FOR i=1 TO 60 #No:8218
#       IF p_str[i]<>' ' THEN
#          LET j=j+1
#          LET l_str[j]=p_str[i]
#       END IF
#    END FOR
#    RETURN l_str
#END FUNCTION
#---------No.MOD-830108 end
 
FUNCTION r691_bom(p_level,p_key,p_key2,p_QPA) #FUN-550095 add p_key2
DEFINE
    p_level   LIKE type_file.num5,        #level code #No.FUN-680096 SMALLINT
    p_QPA     LIKE bmb_file.bmb06,        #No.FUN-680096 DECIMAL(11,7),              
    l_QPA     LIKE bmb_file.bmb06,        #No.FUN-680096 DECIMAL(11,7),
    p_key     LIKE bma_file.bma01,        #assembly part number
    p_key2    LIKE bma_file.bma06,        #FUN-550095 add
    l_ac,l_i,l_x   LIKE type_file.num5,   #No.FUN-680096 SMALLINT,
    arrno     LIKE type_file.num5,        #No.FUN-680096 SMALLINT, #BUFFER SIZE
     b_seq    LIKE type_file.num10,       #No.FUN-680096 INTEGER,  #restart sequence (line number) #MOD-530537
    sr        DYNAMIC ARRAY OF RECORD     #array for storage
        bmb02 LIKE bmb_file.bmb02, #項次
        bmb03 LIKE bmb_file.bmb03, #料號
        bmb06 LIKE bmb_file.bmb06, #QPA
        ima08 LIKE ima_file.ima08, #來源碼
        bma01 LIKE bma_file.bma01  #料號
    END RECORD,
    l_ima08   LIKE ima_file.ima08,    #source code
    l_chr     LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
    l_ActualQPA LIKE bmb_file.bmb06,  #FUN-560227
    l_cnt,l_c LIKE type_file.num5,    #No.FUN-680096 smallint,
    l_cmd     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(400)
    l_bmaacti LIKE bma_file.bmaacti   #No.TQC-C50120 add
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
 
    #TQC-C50120--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file
     WHERE bma01 = p_key
       AND bma06 = p_key2
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50120--add--end--
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=" SELECT 0,bmb03,bmb06/bmb07,ima08,bma01 ",
                  "   FROM bmb_file,OUTER ima_file,OUTER bma_file ",
                  "  WHERE bmb01='",p_key,"' AND bmb02 > ?",
                  "    AND bmb29='",p_key2,"'",
                  "    AND bmb_file.bmb03 = bma_file.bma01",
                  "    AND bmb_file.bmb03 = ima_file.ima01",
                  "    AND (bmb04 <='",tm.vdate,"' OR bmb04 IS NULL) ",
                  "    AND (bmb05 >'",tm.vdate,"' OR bmb05 IS NULL)",
                  " ORDER BY 1,2 "
        PREPARE bom_pr2 FROM l_cmd
        DECLARE bom_cs2 CURSOR FOR bom_pr2
        IF SQLCA.sqlcode THEN CALL cl_err('P2:',SQLCA.sqlcode,1) RETURN  END IF
 
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH bom_cs2
        USING b_seq
        INTO sr[l_ac].*
		 IF SQLCA.SQLCODE<0 THEN
			CALL cl_err('foreach bom_cs2',SQLCA.SQLCODE,1)
			EXIT FOREACH
		 END IF
            #FUN-8B0015--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #FUN-8B0015--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
 
           #Actual QPA
           #LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
            LET l_ActualQPA=sr[l_i].bmb06*p_QPA
            LET l_QPA=sr[l_i].bmb06 * p_QPA
 
            IF sr[l_i].bma01 IS NOT NULL THEN
              #CALL r691_bom(p_level,sr[l_i].bmb03,' ',l_ActualQPA) #FUN-550095 add ' '#FUN-8B0015
               CALL r691_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_ActualQPA) #FUN-8B0015
               IF tm.s_part='N' THEN CONTINUE FOR END IF
               IF sr[l_i].ima08='X' THEN CONTINUE FOR END IF
            END IF
            IF sr[l_i].bma01 IS NULL AND tm.e_part='N' THEN CONTINUE FOR END IF
            LET g_cc=g_cc+1
            INSERT INTO r691_file VALUES(g_bma01,g_bma06,sr[l_i].bmb03,l_ActualQPA) #FUN-550095 add g_bma06
            #TQC-790090
            #IF SQLCA.SQLCODE=-239 THEN
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                 UPDATE r691_file SET tmp03=tmp03+l_ActualQPA
                  WHERE tmp01=g_bma01
                    AND tmp04=g_bma06 #FUN-550095 add
                    AND tmp02=sr[l_i].bmb03
            END IF
        END FOR
        IF l_x < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    # 避免 'X' PART 重複計算
    IF p_level >1 THEN
       RETURN
     END IF
END FUNCTION
 
 
#FUN-760076--start
{
REPORT abmr691_rep(sr)
  DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
      sr RECORD
         tmp01  LIKE bma_file.bma01,    #No.FUN-680096 VARCHAR(40)
         tmp04  LIKE bma_file.bma06,    #No.FUN-680096 VARCHAR(20)
#        tmp02  LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
         tmp02  LIKE zaa_file.zaa08,    #No.FUN-680096 VARCHAR(40)
         ima02  LIKE ima_file.ima02,    #No.FUN-680096 VARCHAR(30)
        #tmp03  LIKE type_file.num5     #No.FUN-680096 SMALLINT   #MOD-6A0044 mark
         tmp03  LIKE cae_file.cae07     #MOD-6A0044 
      END RECORD,
      l_i       LIKE type_file.num5,    #No.FUN-680096 SMALLINT
      l_tmp03   ARRAY[13] OF LIKE type_file.chr20  #No.FUN-680096 VARCHAR(20)
 
      OUTPUT  TOP MARGIN g_top_margin
              LEFT   MARGIN  0
              BOTTOM MARGIN g_bottom_margin
              PAGE   LENGTH g_page_line
      ORDER BY sr.tmp02
 
  FORMAT
   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
      PRINT (163-FGL_WIDTH(g_company))/2 SPACES,g_company   #TQC-6A0083
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT COLUMN (163-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED  #TQC-6A0083
      PRINT (163-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]   #TQC-6A0083
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#No.TQC-6B0108 --begin
#           COLUMN 58,g_x[11] clipped,tm.vdate,
            COLUMN 73,g_x[11] clipped,tm.vdate,
#No.TQC-6B0108 --end
#            COLUMN g_len-7,g_x[3] CLIPPED ,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len] CLIPPED #TQC-6A0083
            COLUMN 163-7,g_x[3] CLIPPED ,PAGENO USING '<<<'   #TQC-6A0083
      PRINT g_dash[1,163] CLIPPED #TQC-6A0083
      PRINT g_str1 CLIPPED   #TQC-6A0083
      PRINT g_str11 CLIPPED #FUN-550095 add  #TQC-6A0083
      PRINT g_str2 CLIPPED #TQC-6A0083
      IF tm.name_p='N' THEN
         LET g_str2a=NULL LET g_str2b=NULL LET g_str2c=NULL
      END IF
      PRINT g_str2a  #TQC-6A0083
      PRINT g_str2b  #TQC-6A0083
      PRINT g_str2c  #TQC-6A0083
      PRINT g_x[12] CLIPPED,COLUMN 42,g_str3 CLIPPED #TQC-5A0033  #TQC-6A0083
      PRINT g_x[14] CLIPPED,' ',g_str4 CLIPPED   #TQC-6A0083
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.tmp02
     #FOR l_i= 1 TO 13 #No:8218
      FOR l_i= 1 TO 3  #No:8218  #TQC-5A0033
          LET l_tmp03[l_i]=0
      END FOR
 
   ON EVERY ROW
     #FOR l_i=1 TO 13  #No:8218
      FOR l_i=1 TO 3   #No:8218  #TQC-5A0033
         #IF sr.tmp01=g_part[l_i] THEN
          IF sr.tmp01=g_part[l_i] AND
             (sr.tmp04=g_code[l_i] OR cl_null(g_code[l_i])) THEN #FUN-550095 #No.MOD-5C0057 modify
             LET l_tmp03[l_i]=sr.tmp03
          END IF
      END FOR
 
   AFTER GROUP OF sr.tmp02
    #----020225 CJC modi:若列印差異時,其中主號均無時,要印抬頭
    IF sr.tmp02 IS NOT NULL THEN
      PRINT sr.tmp02[1,16];
     #FOR l_i=1 TO 13  #No:8218
      #TQC-5A0033  --begin
      FOR l_i=1 TO 3   #No:8218
          IF l_i=1 THEN
             IF l_tmp03[l_i]=0 THEN
                PRINT COLUMN 42,' ';
             ELSE
               #PRINT COLUMN 42,l_tmp03[l_i] USING '########';   #MOD-6A0044 mark
                PRINT COLUMN 42,l_tmp03[l_i] USING '#########&.#####'; #MOD-6A0044  
             END IF
          ELSE
             IF l_tmp03[l_i]=0 THEN
               #PRINT COLUMN 17+(l_i-1)*9,' ';  #No:8218
                PRINT COLUMN 42+(l_i-1)*40,' '; #No:8218
             ELSE
               #PRINT COLUMN 17+(l_i-1)*9,l_tmp03[l_i] USING '########'; #No:8218
               #PRINT COLUMN 42+(l_i-1)*40,l_tmp03[l_i] USING '########';#No:8218  #MOD-6A0044
                PRINT COLUMN 42+(l_i-1)*40,l_tmp03[l_i] USING '#########&.#####';#No:8218 #MOD-6A0044
             END IF
          END IF
      END FOR
      #TQC-5A0033  --end
      PRINT ' '
      IF tm.name_p='Y' THEN PRINT '   ',sr.ima02 END IF
    END IF
 
   ON LAST ROW
#      PRINT g_dash[1,g_len] CLIPPED   #TQC-6A0083
      PRINT g_dash[1,163] CLIPPED   #TQC-6A0083
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN 154, g_x[7] CLIPPED      #No.TQC-740079
#     PRINT g_x[4],g_x[5] CLIPPED      #No.TQC-740079
 
   PAGE TRAILER
      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED   #TQC-6A0083
         THEN PRINT g_dash[1,163] CLIPPED   #TQC-6A0083
              PRINT g_x[4],g_x[5] CLIPPED , COLUMN 154, g_x[6] CLIPPED      #No.TQC-740079
#             PRINT g_x[4],g_x[5] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#FUN-760076--end
#Patch....NO.TQC-610035 <001> #
