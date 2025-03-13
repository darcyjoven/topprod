# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aglr903.4gl
# Descriptions...: 傳票憑証
# Input parameter:
# Return code....:
# Date & Author..: 92/03/04 By DAVID
# Reference File : aba_file,abb_file,abc_file,aac_file,aag_file
# 需傳遞帳別----> MAY
# modi           :960321 by nick arg(1) must by bookno not dbs!
# Modify.........: By Danny     OUTER 作法、新增 l_sql 程式段
# Modify.........: By Melody    列印時應將異動碼二、三、四也一併列印出
# Modify.........: By Melody    修正 ARG_VAL 順序
# Modify.........: By Melody 97.07.17 sr.order1 改為 SMALLINT
# Modify.........: No.MOD-450292 05/01/28 By cate 報表標題標準化
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.FUN-550114 05/05/25 By echo 新增報表備註
# Modify.........: No.MOD-580046 05/08/08 By Smapmin 報表行數改為g_page_line - 9
# Modify.........: No.MOD-590097 05/09/08 By will 全型表格修改
# Modify.........: No.MOD-5A0165 05/10/24 By Dido 報表修改
# Modify.........: No.FUN-5C0015 06/01/03 列印abb11時，只印[1,12]。
#                  傳票只能印abb11，且為憑證式報表，欄寬不可再放大。
# Modify.........: No.MOD-610010 06/01/05 By Smapmin 每個表尾都要有簽核
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.MOD-670096 06/07/24 By Smapmin 於每一傳票憑證加入該傳票總頁次
# Modify.........: No.MOD-680073 06/08/24 By Smapmin 將報表長度改為80
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.MOD-690131 06/10/14 By Smapmin 修改每頁列印行數
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.MOD-710091 07/01/18 By jamie  拋傳票至總帳資料庫成功後的列印沒有判斷資料庫
# Modify.........: No.TQC-730028 07/03/06 By Smapmin 修改DB name字串
# Modify.........: No.FUN-710080 07/03/21 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-750116 07/07/10 By Sarah 報表資料重複出現
# Modify.........: No.MOD-7A0024 07/10/05 By Smapmin 由aglt110串過來應列印科目名稱非額外名稱
# Modify.........: No.MOD-7A0108 07/10/19 By Smapmin 回寫列印次數
# Modify.........: No.MOD-7C0197 07/12/26 By Smapmin 修改報表名稱
# Modify.........: No.MOD-820170 08/02/27 By Smapmin 加入aaz82的判斷
# Modify.........: No.MOD-840052 08/04/08 By Carol 加傳參數 aaz82
# Modify.........: No.MOD-850015 08/05/09 By Carol 調整rpt
# Modify.........: No.FUN-940041 09/04/28 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.TQC-970124 09/07/14 By Kevin 調整 p_dbs
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/20 By chenls  s_dbstring(g_dbs CLIPPED) mark 掉，程式中的跨DB語法都改成不跨
# Modify.........: No.CHI-B70028 11/09/27 By Polly 增加帳別選項
# Modify.........: No.FUN-B90077 11/10/07 By Belle 修改列印格式
# Modify.........: No.MOD-BA0113 11/10/17 By Polly 設定原幣取位抓取abb24幣別
# Modify.........: No.MOD-BA0148 11/10/21 By Polly 當列印額外摘要未勾選時，摘要才抓取abb04
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.MOD-C20140 12/02/16 By Polly 修正aglt110無法列印00帳之外的單據
# Modify.........: No.CHI-C30078 12/06/04 By jinjj調整列印額外摘要參數tm.v預設值為 'N'
# Modify.........: No.MOD-C70017 12/07/03 By Polly 單身摘要在同一項次設定兩筆以上時一律抓取第一筆顯示
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.MOD-D30048 13/03/06 By apo 無論是否有額外摘要,都應該顯示資料
# Modify.........: No.TQC-DA0023 13/10/21 By yangxf “憑證編號”，“來源”欄位添加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                              # Print condition RECORD
             wc     LIKE type_file.chr1000,    # Where condition             #No.FUN-680098   VARCHAR(300)
             wc2    LIKE type_file.chr1000,    # Where condition             #No.FUN-680098   VARCHAR(300)
             t      LIKE type_file.chr2,       # Post                        #No.FUN-680098   VARCHAR(1)
             u      LIKE type_file.chr1,       # Activity                    #No.FUN-680098   VARCHAR(1)
             v      LIKE type_file.chr1,       # extra detail (Y/N)          #No.FUN-680098   VARCHAR(1)
             w      LIKE type_file.chr1,       # already print (Y/N)         # No.FUN-680098   VARCHAR(1)
             e      LIKE type_file.chr1,       #FUN-6C0012
             more   LIKE type_file.chr1        # Input more condition(Y/N)   #No.FUN-680098   VARCHAR(1)
       END RECORD,
       l_abc04      LIKE abc_file.abc04,       # Like file abc_file.abc04 #No.FUN-680098   VARCHAR(30)
       g_bookno     LIKE aba_file.aba00,       #帳別
       g_type       LIKE type_file.chr1000,    #No.FUN-680098   VARCHAR(40)
       p_dbs        LIKE type_file.chr21,      #No.FUN-680098   VARCHAR(20)
       g_part       LIKE aac_file.aac01,       #No.FUN-680098   VARCHAR(40)
       g_spac       LIKE type_file.chr6,       #No.FUN-680098   VARCHAR(6)
       g_tot_bal    LIKE type_file.num20_6     # User defined variable#No.FUN-680098   dec(20,6)
DEFINE g_rpt_name   LIKE type_file.chr20       # For TIPTOP 串 EasyFlow  #No.FUN-680098   VARCHAR(20)
 
DEFINE g_aaa03      LIKE aaa_file.aaa03
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680098  integer
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680098  smallint
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-680098    VARCHAR(72)
DEFINE totpageno    LIKE type_file.num5        #MOD-670096     #No.FUN-680098   smallint
DEFINE l_table      STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "aba01.aba_file.aba01,aba02.aba_file.aba02,",
               "aba08.aba_file.aba08,aba09.aba_file.aba09,",
               "abb02.abb_file.abb02,abb03.abb_file.abb03,",
               "abb11.abb_file.abb11,abb04.abb_file.abb04,",
               "abb05.abb_file.abb05,gem02.gem_file.gem02,",
               "abb06.abb_file.abb06,abb07.abb_file.abb07,",
               "aag13.aag_file.aag13,abb12.abb_file.abb12,",
               "abb13.abb_file.abb13,abb14.abb_file.abb14,",
               "g_msg.type_file.chr1000,azi04.azi_file.azi04,",
               "aac02.aac_file.aac02,",
               "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-940041
               "sign_show.type_file.chr1,",                             #是否顯示簽核資料(Y/N)  #FUN-940041
               "sign_str.type_file.chr1000,",   #簽核字串                   #No.TQC-C10034 add
               "aee04.aee_file.aee04,",                                 #FUN-B90077 
               "abb24.abb_file.abb24,abb25.abb_file.abb25,",            #FUN-B90077
               "abb07f.abb_file.abb07f,",                               #FUN-B90077
               "t_azi04.azi_file.azi04"                                 #MOD-BA0113 add
   LET l_table = cl_prt_temptable('aglr903',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生


   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,",   #MOD-7C0197 add ?
               "        ?,?,?,",                #FUN-940041 加3個?
               "        ?,?,?,?,?,?)"             #FUN-B90077 加4個?  #MOD-BA0113 加1個？#No.TQC-C10034 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF


   #------------------------------ CR (1) ------------------------------#
 
   LET g_rpt_name = ''
   LET g_bookno =ARG_VAL(1)                    #modi by nick 960321
   LET p_dbs    =ARG_VAL(2)
   LET g_pdate  =ARG_VAL(3)             # Get arguments from command line
   LET g_towhom =ARG_VAL(4)
   LET g_rlang  =ARG_VAL(5)
   LET g_bgjob  =ARG_VAL(6)
   LET g_prtway =ARG_VAL(7)
   LET g_copies =ARG_VAL(8)
   LET tm.wc    =ARG_VAL(9)
   LET tm.t     =ARG_VAL(10)
   LET tm.u     =ARG_VAL(11)
   LET tm.v     =ARG_VAL(12)
   LET tm.w     =ARG_VAL(13)
  #LET g_bookno =ARG_VAL(14)     #CHI-B70028 add #MOD-C20140 mark
   LET g_rpt_name =ARG_VAL(14)   # 外部指定報表名稱
   LET g_rep_user =ARG_VAL(15)
   LET g_rep_clas =ARG_VAL(16)
   LET g_template =ARG_VAL(17)
   LET tm.e       =ARG_VAL(18)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
 
   #-->帳別若為空白則使用預設帳別
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
      LET g_bookno = g_aaz.aaz64
   END IF
 
#   LET p_dbs = s_dbstring(g_dbs CLIPPED)        #No.FUN-A10098 -----mark
 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
 
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL aglr903_tm(0,0)              # Input print condition
      ELSE CALL aglr903()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr903_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,  #No.FUN-580031
          p_row,p_col    LIKE type_file.num5,  #No.FUN-680098   smallint
          l_cmd          LIKE type_file.chr1000#No.FUN-680098   VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5   #No.CHI-B70028   add
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 18
   ELSE 
      LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW aglr903_w AT p_row,p_col WITH FORM "agl/42f/aglr903"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL                      # Default condition
 
   LET tm.more = 'N'
   LET tm.t    = '3'
   LET tm.u    = '3'
   #LET tm.v    = 'Y'    #CHI-C30078 mark
   LET tm.v    = 'N'     #CHI-C30078 add
   LET tm.w    = '3'
   LET tm.e    = 'N'  #FUN-6C0012
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
#------------------------------CHI-B70028-------------------------------------start
   INPUT g_bookno FROM aba00 ATTRIBUTE(WITHOUT DEFAULTS)
      AFTER FIELD aba00
        IF NOT cl_null(g_bookno) THEN
           CALL s_check_bookno(g_bookno,g_user,g_plant)
           RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
               NEXT FIELD aba00
           END IF
           SELECT aaa02 FROM aaa_file WHERE aaa01 = g_bookno
           IF STATUS THEN
              CALL cl_err3("sel","aaa_file",g_bookno,"","agl-043","","",0)
              NEXT FIELD  aba00
           END IF
         END IF
      ON ACTION CONTROLP
         CASE
          WHEN INFIELD(aba00)
               CALL cl_init_qry_var()                 #帳別編號
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = g_bookno
               CALL cl_create_qry() RETURNING g_bookno
               DISPLAY BY NAME g_bookno
               NEXT FIELD aba00
          OTHERWISE EXIT CASE
         END CASE
      END INPUT
#------------------------------CHI-B70028----------------------------------------end
   CONSTRUCT BY NAME tm.wc ON aba01,aba05,aba02,aba06
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 

#TQC-DA0023 add begin ---
      ON ACTION controlp
         CASE
            WHEN INFIELD(aba01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_aba01_2"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aba01
                 NEXT FIELD aba01
            WHEN INFIELD(aba06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_aba06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aba06
                 NEXT FIELD aba06
         END CASE
#TQC-DA0023 add end -----

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
      LET INT_FLAG = 0 CLOSE WINDOW aglr903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
   DISPLAY BY NAME tm.e,tm.more             # Condition   #FUN-6C0012
   INPUT BY NAME tm.t,tm.u,tm.w,tm.v,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD t
         IF tm.t NOT MATCHES "[123]" OR tm.t IS NULL THEN NEXT FIELD t END IF
      AFTER FIELD u
         IF tm.u NOT MATCHES "[123]" OR tm.u IS NULL THEN NEXT FIELD u END IF
      AFTER FIELD v
         IF tm.v NOT MATCHES "[YN]" OR tm.v IS NULL THEN NEXT FIELD v END IF
      AFTER FIELD w
         IF tm.w NOT MATCHES "[123]" OR tm.w IS NULL THEN NEXT FIELD w END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         CALL cl_cmdask()        # Command execution
 
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
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr903'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr903','9031',1)  
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",p_dbs CLIPPED,"'",
                         " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.v CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",
                         " '",g_bookno CLIPPED,"'",             #CHI-B70028
                         " '",tm.e CLIPPED,"'",  #FUN-6C0012
                         " '",g_rpt_name CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr903',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr903_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr903()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr903_w
END FUNCTION
 
FUNCTION aglr903()
   DEFINE l_name      LIKE type_file.chr20,    # External(Disk) file name     #No.FUN-680098    VARCHAR(20)
          l_sql       STRING,                  # RDSQL STATEMENT    #No.FUN-680098   VARCHAR(1000)   #FUN-B90077 mod 1000
          l_aac01     LIKE type_file.chr5,     #NO.FUN-550028   #No.FUN-680098   VARCHAR(5)
          l_za05      LIKE za_file.za05,       #No.FUN-680098   VARCHAR(60)
          l_order     ARRAY[5] OF LIKE type_file.chr20,         #No.FUN-680098   VARCHAR(10)
          sr          RECORD
                       order1  LIKE  type_file.num5,      #No.FUN-680098  smallint
                       aba     RECORD LIKE aba_file.*,
                       abb     RECORD LIKE abb_file.*,
                       aag02   LIKE aag_file.aag02,
                       aag13   LIKE aag_file.aag13, #FUN-6C0012
                       gem02   LIKE gem_file.gem02
                      END RECORD,
          l_str,l_cmd STRING,   #MOD-670096
          l_aac02     LIKE aac_file.aac02,    #FUN-750116 add
          l_aba01     LIKE aba_file.aba01,    #MOD-7A0108
          l_aee04     LIKE aee_file.aee04     #FUN-B90077
   DEFINE l_img_blob     LIKE type_file.blob
  # DEFINE l_ii           INTEGER
  # DEFINE l_key          RECORD                  #主鍵
  #           v1          LIKE aba_file.aba01
   #          END RECORD
   DEFINE t_azi04     LIKE azi_file.azi04             #MOD-BA0113 add
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041
   #------------------------------ CR (2) ------------------------------#
 
   SELECT aaf03 INTO g_company FROM aaf_file 
                              WHERE aaf01 = g_bookno AND aaf02 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr903'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
 
#No.FUN-A10098 ----------mark start
#   LET l_sql = "SELECT ' ',",p_dbs,"aba_file.*,",p_dbs,"abb_file.*,",             #MOD-710091 mod
#               "             aag02,aag13,gem02 ",#FUN-6C0012                      #MOD-710091 mod
#               "  FROM ",p_dbs,"aba_file,",p_dbs,"abb_file",                     #MOD-710091 mod 
#               " LEFT OUTER JOIN ",p_dbs,"aag_file ON abb00 = aag_file.aag00 AND abb03 = aag_file.aag01",
#               " LEFT OUTER JOIN ",p_dbs,"gem_file ON abb05 = gem_file.gem01", 
#               " WHERE aba00 = '",g_bookno,"' AND abb00 ='",g_bookno,"'",
#               " AND abb02 > 0 AND aba01 = abb01 ",
#No.FUN-A10098 ----------mark end
#No.FUN-A10098 ----------add start
   LET l_sql = "SELECT ' ',aba_file.*,abb_file.*,             aag02,aag13,gem02   FROM aba_file,abb_file",
               " LEFT OUTER JOIN aag_file ON abb00 = aag_file.aag00 AND abb03 = aag_file.aag01",
               " LEFT OUTER JOIN gem_file ON abb05 = gem_file.gem01",
               " WHERE aba00 = '",g_bookno,"' AND abb00 ='",g_bookno,"'",
               " AND abb02 > 0 AND aba01 = abb01 ",
               " AND aba19 <> 'X' ",  #CHI-C80041
#No.FUN-A10098 ----------add end 
 
               " AND ",tm.wc CLIPPED
   CASE tm.t
        WHEN '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N'"
        WHEN '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y'"
        OTHERWISE EXIT CASE
   END CASE
   CASE tm.u
        WHEN '1' LET l_sql = l_sql CLIPPED," AND abaacti = 'Y'"
        WHEN '2' LET l_sql = l_sql CLIPPED," AND abaacti = 'N'"
        OTHERWISE EXIT CASE
   END CASE
   CASE tm.w
        WHEN '1' LET l_sql = l_sql CLIPPED," AND abaprno = 0"
        WHEN '2' LET l_sql = l_sql CLIPPED," AND abaprno > 0"
        OTHERWISE EXIT CASE
   END CASE
   IF g_aaz.aaz82='Y' THEN
      LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb06"   
   ELSE
      LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb02"   
   END IF
 
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032   #No.FUN-A10098 ---MARK
   PREPARE aglr903_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr903_curs1 CURSOR FOR aglr903_prepare1
 
  #-->額外摘要
#   LET l_sql = " SELECT abc03,abc04 FROM ",p_dbs,"abc_file",  #MOD-710091 mod     #No.FUN-A10098 --mark
   LET l_sql = " SELECT abc03,abc04 FROM abc_file",                                #No.FUN-A10098 --add    
               "  WHERE abc00 = ? AND abc01=?  AND abc02= ? ",
               "   ORDER BY 1 "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032    #No.FUN-A10098 ---MARK
   PREPARE aglr903_pre2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
  #DECLARE r903_c2  CURSOR FOR aglr903_pre2             #MOD-C70017 mark
   DECLARE r903_c2  SCROLL CURSOR FOR aglr903_pre2      #MOD-C70017 add
 
   FOREACH aglr903_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0
          THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      #-->是否依借貸排序
      IF g_aaz.aaz82 = 'Y'
         THEN LET sr.order1 = sr.abb.abb06
         ELSE LET sr.order1 = sr.abb.abb02
      END IF
 
      LET g_msg=''                        #MOD-BA0148 add
      IF tm.v='Y' THEN   #單身摘要應列印
        #FOREACH r903_c2 USING sr.aba.aba00,sr.aba.aba01,sr.abb.abb02  #MOD-C70017 mark
        #                 INTO g_cnt,g_msg                             #MOD-C70017 mark
         OPEN r903_c2 USING sr.aba.aba00,sr.aba.aba01,sr.abb.abb02     #MOD-C70017 add
         FETCH FIRST r903_c2 INTO g_cnt,g_msg                          #MOD-C70017 add
           #MOD-D30048--mark--str
           #IF SQLCA.sqlcode THEN
           #   CALL cl_err('r903_c2',SQLCA.sqlcode,0)
           #   EXIT FOREACH
           #END IF
           #MOD-D30048--mark--end
        #END FOREACH                                          #MOD-C70017 mark
         CLOSE r903_c2                                        #MOD-C70017 add
      ELSE                                 #MOD-BA0148 add
         LET g_msg = sr.abb.abb04          #MOD-BA0148 add
      END IF
 
      IF tm.e = 'N' OR tm.e IS NULL THEN 
         LET sr.aag13 = sr.aag02 
      END IF
      #報表名稱
      CALL s_get_doc_no(sr.aba.aba01) RETURNING g_part  
      SELECT aac02 INTO l_aac02 FROM aac_file WHERE aac01 = g_part
      IF SQLCA.sqlcode THEN 
         SELECT gaz03 INTO l_aac02 FROM gaz_file 
                                  WHERE gaz01 = g_prog AND gaz02=g_rlang
      END IF
     #FUN-B90077--Begin--
      LET l_aee04 = null
     #---------------------------------MOD-BA0113-----------------------stare
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = sr.abb.abb24
     #---------------------------------MOD-BA0113-------------------------end
      CALL r903_get_ahe02(sr.abb.abb03,sr.abb.abb11,'aag15','1') RETURNING l_aee04
     #FUN-B90077---End---
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.aba.aba01,sr.aba.aba02,sr.aba.aba08,sr.aba.aba09,sr.abb.abb02,
         sr.abb.abb03,sr.abb.abb11,sr.abb.abb04,sr.abb.abb05,sr.gem02    ,
         sr.abb.abb06,sr.abb.abb07,sr.aag13    ,sr.abb.abb12,sr.abb.abb13,
         sr.abb.abb14,g_msg,g_azi04,l_aac02,   #MOD-7C0197
         "",l_img_blob,"N","",    #FUN-940041   #No.TQC-C10034  ADD 
         l_aee04,sr.abb.abb24,sr.abb.abb25,sr.abb.abb07f,      #FUN-B90077
         t_azi04                                               #MOD-BA0113 add
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      

   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aba01,aba05,aba02,aba06')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ' '
   END IF
   LET g_str = tm.wc,";",'',";",tm.v,";",tm.e,";",g_aaz.aaz82  #MOD-840052-modify
 
   LET g_cr_table = l_table                 #主報表的temp table名稱
   LET g_cr_apr_key_f = "aba01"             #報表主鍵欄位名稱，用"|"隔開 
   LET l_sql = "SELECT DISTINCT aba01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  # PREPARE key_pr FROM l_sql
  # DECLARE key_cs CURSOR FOR key_pr
  # LET l_ii = 1
   #報表主鍵值
  # CALL g_cr_apr_key.clear()                #清空
  # FOREACH key_cs INTO l_key.*            
   #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
    #  LET l_ii = l_ii + 1
 #  END FOREACH
 
   CALL cl_prt_cs3('aglr903','aglr903',g_sql,g_str)
   LET l_sql = "SELECT DISTINCT aba01 FROM ",
               g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE r903_p3 FROM l_sql
   DECLARE r903_c3 CURSOR FOR r903_p3
   FOREACH r903_c3 INTO l_aba01 
      UPDATE aba_file SET abaprno = abaprno + 1
                    WHERE aba01 = l_aba01
                      AND aba00 = g_bookno
      IF sqlca.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","aba_file",l_aba01,g_bookno,STATUS,"","upd abaprno",1)
      END IF
   END FOREACH
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
FUNCTION r903_get_ahe02(p_aag01,p_aed02,p_gaq01,p_aee02)
  DEFINE p_aag01         LIKE type_file.chr50
  DEFINE p_aed02         LIKE aed_file.aed02
  DEFINE p_gaq01         LIKE gaq_file.gaq01  
  DEFINE l_ahe01         LIKE ahe_file.ahe01
  DEFINE l_ahe03         LIKE ahe_file.ahe03    
  DEFINE l_ahe04         LIKE ahe_file.ahe04
  DEFINE l_ahe05         LIKE ahe_file.ahe05
  DEFINE l_ahe07         LIKE ahe_file.ahe07
  DEFINE l_sql1          STRING              
  DEFINE l_ahe02_d       LIKE ze_file.ze03
  DEFINE p_aee02         LIKE aee_file.aee02  

     IF g_aaz.aaz119 ='N' THEN RETURN ' ' END IF 
     #查找異動碼(核算項)值
     LET l_sql1 = " SELECT ",p_gaq01 CLIPPED," FROM aag_file ",
                  "  WHERE aag00 = '",g_bookno,"'",
                  "    AND aag01 LIKE ? ",
                  "    AND aag07 IN ('2','3') ",
                  "    AND ",p_gaq01 CLIPPED," IS NOT NULL"
     PREPARE r903_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
     END IF
     DECLARE r903_gaq01_cs SCROLL CURSOR FOR r903_gaq01_p  #材

     #取異動碼(核算項)名稱
     LET l_ahe01 = NULL
     OPEN r903_gaq01_cs USING p_aag01
     IF SQLCA.sqlcode THEN
        CLOSE r903_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST r903_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE r903_gaq01_cs
        RETURN NULL
     END IF
     CLOSE r903_gaq01_cs
     IF NOT cl_null(l_ahe01) THEN
        LET l_ahe03 = ''     #MOD-B40231 
        LET l_ahe04 = ''     #MOD-B40231 
        LET l_ahe05 = ''     #MOD-B40231 
        LET l_ahe07 = ''     #MOD-B40231 
        SELECT ahe03,ahe04,ahe05,ahe07 INTO l_ahe03,l_ahe04,l_ahe05,l_ahe07 
          FROM ahe_file
         WHERE ahe01 = l_ahe01
        IF NOT cl_null(l_ahe04) AND NOT cl_null(l_ahe05) AND
           NOT cl_null(l_ahe07) AND l_ahe03 = '1' THEN     
           LET l_ahe02_d = ''                             
           LET l_sql1 = "SELECT UNIQUE ",l_ahe07 CLIPPED,
                        "  FROM ",l_ahe04 CLIPPED,
                        " WHERE ",l_ahe05 CLIPPED," = '",p_aed02,"'"
           PREPARE ahe_p1 FROM l_sql1
           EXECUTE ahe_p1 INTO l_ahe02_d
        END IF
        IF l_ahe03 = '2' THEN
           LET l_ahe02_d = '' 
           SELECT aee04 INTO l_ahe02_d
             FROM aee_file
            WHERE aee00 = g_bookno
              AND aee01 = p_aag01
              AND aee02 = p_aee02
              AND aee03 = p_aed02 
        END IF
     END IF
     LET l_ahe02_d = l_ahe02_d CLIPPED
     RETURN l_ahe02_d
END FUNCTION
