# Prog. Version..: '5.30.06-13.03.29(00008)'     #
#
# Pattern name...: aglg903.4gl
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
# Modify.........: No.FUN-B40097 11/06/07 By chenying 憑證類CR轉GR
# Modify.........: No.FUN-B40097 11/08/17 By chenying 程式規範修改
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz FUN-B90077 CHI-B70028 MOD-BA0113 MOD-BA0148追單
# Modify.........: No.FUN-C40028 12/06/18 By Downheal 修改部分程式片段, 以達到列印簽核的功能
# Modify.........: No.CHI-D10006 13/01/07 By apo 修正依參數aaz82決定是否依借貸別排序
# Modify.........: No.FUN-D10078 13/01/16 By odyliao 修正填充空白行的作法
# Modify.........: No.TQC-D10092 13/01/24 By odyliao 調整中一刀樣板設計架構
# Modify.........: No.MOD-D30251 13/03/28 By apo 若以借貸別排序時，在排序上增加abb02的排序方式
# Modify.........: No.FUN-D50063 13/06/26 By wangrr 32區追單,修改每頁列印行數為4，4rp也調整
 
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
 
###GENGRE###START
TYPE sr1_t RECORD
    aba01 LIKE aba_file.aba01,
    aba02 LIKE aba_file.aba02,
    aba08 LIKE aba_file.aba08,
    aba09 LIKE aba_file.aba09,
    abb02 LIKE abb_file.abb02,
    abb03 LIKE abb_file.abb03,
    abb11 LIKE abb_file.abb11,
    abb04 LIKE abb_file.abb04,
    abb05 LIKE abb_file.abb05,
    gem02 LIKE gem_file.gem02,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    aag13 LIKE aag_file.aag13,
    abb12 LIKE abb_file.abb12,
    abb13 LIKE abb_file.abb13,
    abb14 LIKE abb_file.abb14,
    g_msg LIKE type_file.chr1000,
    azi04 LIKE azi_file.azi04,
    aac02 LIKE aac_file.aac02,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000,
    #FUN-C10036 --add--str
    aee04 LIKE aee_file.aee04,
    abb24 LIKE abb_file.abb24,
    abb25 LIKE abb_file.abb25,
    abb07f LIKE abb_file.abb07f,
    t_azi04 LIKE azi_file.azi04
    #FUN-C10036--add--end
END RECORD
###GENGRE###END

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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114  #FUN-BB0047 mark
 
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
               "sign_show.type_file.chr1, sign_str.type_file.chr1000,",                               #是否顯示簽核資料(Y/N)  #FUN-940041
               "aee04.aee_file.aee04,",                                 #FUN-C10036(FUN-B90077 )
               "abb24.abb_file.abb24,abb25.abb_file.abb25,",            #FUN-C10036(FUN-B90077)
               "abb07f.abb_file.abb07f,",                               #FUN-C10036(FUN-B90077)
               "t_azi04.azi_file.azi04"                                 #FUN-C10036(MOD-BA0113) add
   LET l_table = cl_prt_temptable('aglg903',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097 #FUN-BB0047 mark
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM 
   END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,",   #MOD-7C0197 add ?
               "        ?,?,?,  ",   #FUN-940041 加3個?
               "        ?,?,?,?,?,?)"             #FUN-C10036(FUN-B90077 加4個?  #MOD-BA0113 加1個？)
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097 #FUN-BB0047 mark
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
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
   LET g_bookno =ARG_VAL(14)   #FUN-C10036(CHI-B70028)
   LET g_rpt_name =ARG_VAL(15)   # 外部指定報表名稱
   LET g_rep_user =ARG_VAL(16)
   LET g_rep_clas =ARG_VAL(17)
   LET g_template =ARG_VAL(18)
   LET tm.e       =ARG_VAL(19)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
 
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
      THEN CALL aglg903_tm(0,0)              # Input print condition
      ELSE CALL aglg903()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION aglg903_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,  #No.FUN-580031
          p_row,p_col    LIKE type_file.num5,  #No.FUN-680098   smallint
          l_cmd          LIKE type_file.chr1000#No.FUN-680098   VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5 #FUN-C10036(CHI-B70028) add
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 18
   ELSE 
      LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW aglg903_w AT p_row,p_col WITH FORM "agl/42f/aglg903"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL                      # Default condition
 
   LET tm.more = 'N'
   LET tm.t    = '3'
   LET tm.u    = '3'
   LET tm.v    = 'Y'
   LET tm.w    = '3'
   LET tm.e    = 'N'  #FUN-6C0012
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   #----------------FUN-C10036(CHI-B70028)-----------------
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
   #----------------FUN-C10036(CHI-B70028)-----------------
   CONSTRUCT BY NAME tm.wc ON aba01,aba05,aba02,aba06
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aglg903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)
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
      LET INT_FLAG = 0 CLOSE WINDOW aglg903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aglg903'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglg903','9031',1)  
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
                         " '",g_bookno CLIPPED,"'", #FUN-C10036(CHI-B70028)
                         " '",tm.e CLIPPED,"'",  #FUN-6C0012
                         " '",g_rpt_name CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglg903',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW aglg903_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglg903()
   ERROR ""
END WHILE
   CLOSE WINDOW aglg903_w
END FUNCTION
 
FUNCTION aglg903()
   DEFINE l_name      LIKE type_file.chr20,     # External(Disk) file name     #No.FUN-680098    VARCHAR(20)
          l_sql       STRING,   # RDSQL STATEMENT    #No.FUN-680098   VARCHAR(1000) #FUN-C10036(FUN-B90077 mod 1000)
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
          l_aba01     LIKE aba_file.aba01,   #MOD-7A0108
          l_aee04     LIKE aee_file.aee04   #FUN-C10036(FUN-B90077)
   DEFINE l_img_blob     LIKE type_file.blob
   #FUN-C40028 mark
   #DEFINE l_ii           INTEGER
   #DEFINE l_key          RECORD                  #主鍵
             #v1          LIKE aba_file.aba01
             #END RECORD
   #FUN-C40028 mark             
  DEFINE t_azi04     LIKE azi_file.azi04  #FUN-C10036(MOD-BA0113)
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   LOCATE l_img_blob IN MEMORY   #blob初始化   #FUN-940041  
   #------------------------------ CR (2) ------------------------------#
 
   SELECT aaf03 INTO g_company FROM aaf_file 
                              WHERE aaf01 = g_bookno AND aaf02 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg903'
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
   PREPARE aglg903_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE aglg903_curs1 CURSOR FOR aglg903_prepare1
 
  #-->額外摘要
#   LET l_sql = " SELECT abc03,abc04 FROM ",p_dbs,"abc_file",  #MOD-710091 mod     #No.FUN-A10098 --mark
   LET l_sql = " SELECT abc03,abc04 FROM abc_file",                                #No.FUN-A10098 --add
               "  WHERE abc00 = ? AND abc01=?  AND abc02= ? ",
               "   ORDER BY 1 "
# 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032    #No.FUN-A10098 ---MARK
   PREPARE aglg903_pre2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE g903_c2  CURSOR FOR aglg903_pre2
 
   FOREACH aglg903_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0
          THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      #-->是否依借貸排序
      IF g_aaz.aaz82 = 'Y'
         THEN LET sr.order1 = sr.abb.abb06
         ELSE LET sr.order1 = sr.abb.abb02
      END IF
 
      LET g_msg=''   #FUN-C10036(MOD-BA0148)
      IF tm.v='Y' THEN   #單身摘要應列印
         FOREACH g903_c2 USING sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
                          INTO g_cnt,g_msg
            IF SQLCA.sqlcode THEN
               CALL cl_err('g903_c2',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
         END FOREACH
      ELSE                                 #FUN-C10036(MOD-BA0148 add
         LET g_msg = sr.abb.abb04          #FUN-C10036(MOD-BA0148 add
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
 
      #FUN-C10036(FUN-B90077--Begin--
      LET l_aee04 = null
     #---------------------------------FUN-C10036(MOD-BA0113-----------------------stare
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = sr.abb.abb24
     #---------------------------------FUN-C10036(MOD-BA0113-------------------------end
      CALL g903_get_ahe02(sr.abb.abb03,sr.abb.abb11,'aag15','1') RETURNING l_aee04
     #FUN-C10036(FUN-B90077---End---
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.aba.aba01,sr.aba.aba02,sr.aba.aba08,sr.aba.aba09,sr.abb.abb02,
         sr.abb.abb03,sr.abb.abb11,sr.abb.abb04,sr.abb.abb05,sr.gem02    ,
         sr.abb.abb06,sr.abb.abb07,sr.aag13    ,sr.abb.abb12,sr.abb.abb13,
         sr.abb.abb14,g_msg,g_azi04,l_aac02,   #MOD-7C0197
         "",l_img_blob,"N", "",   #FUN-940041 
         l_aee04,sr.abb.abb24,sr.abb.abb25,sr.abb.abb07f,      #FUN-C10036(FUN-B90077
         t_azi04                                               #FUN-C10036(MOD-BA0113 add
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aba01,aba05,aba02,aba06')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ' '
   END IF
###GENGRE###   LET g_str = tm.wc,";",'',";",tm.v,";",tm.e,";",g_aaz.aaz82  #MOD-840052-modify
 
   LET g_cr_table = l_table                 #主報表的temp table名稱
   #LET g_cr_gcx01 = "agli108"              #單別維護程式
   LET g_cr_apr_key_f = "aba01"             #報表主鍵欄位名稱，用"|"隔開 
   LET l_sql = "SELECT DISTINCT aba01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE key_pr FROM l_sql
   DECLARE key_cs CURSOR FOR key_pr
   
   #FUN-C40028 mark
   #LET l_ii = 1
   #報表主鍵值
   #CALL g_cr_apr_key.clear()                #清空
   #FOREACH key_cs INTO l_key.*            
      #LET g_cr_apr_key[l_ii].v1 = l_key.v1
      #LET l_ii = l_ii + 1
   #END FOREACH
   #FUN-C40028 mark 
   
###GENGRE###   CALL cl_prt_cs3('aglg903','aglg903',g_sql,g_str)
    CALL aglg903_grdata()    ###GENGRE###
   LET l_sql = "SELECT DISTINCT aba01 FROM ",
               g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE g903_p3 FROM l_sql
   DECLARE g903_c3 CURSOR FOR g903_p3
   FOREACH g903_c3 INTO l_aba01 
      UPDATE aba_file SET abaprno = abaprno + 1
                    WHERE aba01 = l_aba01
                      AND aba00 = g_bookno
      IF sqlca.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","aba_file",l_aba01,g_bookno,STATUS,"","upd abaprno",1)
      END IF
   END FOREACH
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

###GENGRE###START
FUNCTION aglg903_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY #FUN-C40028
    CALL cl_gre_init_apr()        #FUN-C40028
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg903")
        IF handler IS NOT NULL THEN
            START REPORT aglg903_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#                        " ORDER BY aba01,abb02"             #CHI-D10006--mark
            #CHI-D10006--add--str
            IF g_aaz.aaz82='Y' THEN
               LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb06"
                                        ,"         ,abb02"   #MOD-D30251
            ELSE
               LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb02"
            END IF
            #CHI-D10006--add--end
            DECLARE aglg903_datacur1 CURSOR FROM l_sql
            FOREACH aglg903_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg903_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg903_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg903_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_abb07_1 LIKE abb_file.abb07    #FUN-B40097
    DEFINE l_abb07_2 LIKE abb_file.abb07    #FUN-B40097
    DEFINE l_abb07_1_fmt  STRING            #FUN-B40097
    DEFINE l_abb07_2_fmt  STRING            #FUN-B40097
    DEFINE l_aba08_fmt    STRING            #FUN-B40097
    DEFINE l_aba09_fmt    STRING            #FUN-B40097
    DEFINE l_abb07f_fmt   STRING            #FUN-C10036
    DEFINE l_abb07f_1     LIKE abb_file.abb07    #FUN-C10036
    DEFINE l_abb07f_2     LIKE abb_file.abb07    #FUN-C10036
    DEFINE l_display_line2 LIKE type_file.chr1   #FUN-D10078
    DEFINE l_display_line3 LIKE type_file.chr1   #FUN-D10078
    DEFINE l_display_line4 LIKE type_file.chr1   #FUN-D10078
    DEFINE l_display_sum   LIKE type_file.chr1   #FUN-D10078
    DEFINE l_body_cnt      LIKE type_file.num5   #FUN-D10078 此單號的單身數(不含合計)
    DEFINE l_body_tot      LIKE type_file.num5   #FUN-D10078 此單號的單身數(含最後合計)
    DEFINE l_cmd           STRING
    DEFINE l_pageno        STRING #ody test
    DEFINE l_pagecnt       LIKE type_file.num5 #ody test
    DEFINE l_pagetot       LIKE type_file.num5 #ody test
    DEFINE l_display_header LIKE type_file.chr1 #ody test
    DEFINE l_skip_page     LIKE type_file.chr1  #未列印完跳頁flag #FUN-D50063
 
    ORDER EXTERNAL BY sr1.aba01,sr1.abb02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aba01
            LET l_lineno = 0
           #FUN-D10078 ----(s) #先取得單身總筆數
            LET l_cmd = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE aba01 = '",sr1.aba01,"'"
            PREPARE g903_body_cnt_pr FROM l_cmd
            EXECUTE g903_body_cnt_pr INTO l_body_cnt
            LET l_body_tot = l_body_cnt + 1 #多加合計那一筆
            
        BEFORE GROUP OF sr1.abb02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
 
           #FUN-D10078 ----(s)
            LET l_display_line2 = 'N'
            LET l_display_line3 = 'N'
            LET l_display_line4 = 'N'
            LET l_display_sum = 'N'
            LET l_skip_page = 'N' #FUN-D50063 add
            IF l_lineno = l_body_cnt THEN #此單號最後一筆時檢查還需要補幾筆空白行
              #CASE (l_body_tot MOD 5)  #FUN-D50063 mark
               CASE (l_body_tot MOD 4)  #FUN-D50063 add
                 WHEN 2 LET l_display_line2 = 'Y'
                        LET l_display_line3 = 'Y'
                        LET l_display_line4 = 'Y'
                 WHEN 3 LET l_display_line3 = 'Y'
                        LET l_display_line4 = 'Y'
                 WHEN 4 LET l_display_line4 = 'Y'
               END CASE
               LET l_display_sum = 'Y'
        #FUN-D50063 ---(s)
            ELSE
               IF l_lineno MOD 4 = 0 THEN
                  LET l_skip_page = 'Y'
               ELSE
                  LET l_skip_page = 'N'
               END IF
        #FUN-D50063 ---(e)
            END IF

       #TQC-D10092 ---(S)
           #判斷是否要印表頭
           #CASE (l_lineno MOD 5)  #FUN-D50063 mark
            CASE (l_lineno MOD 4)  #FUN-D50063 add
              WHEN 1 LET l_display_header= 'Y'
              OTHERWISE LET l_display_header='N'
            END CASE
           #判斷是否要印表頭
       #TQC-D10092 ---(E)
              
            PRINTX l_display_line2
            PRINTX l_display_line3
            PRINTX l_display_line4
            PRINTX l_display_sum
            PRINTX l_display_header
            PRINTX l_skip_page #FUN-D50063
           #FUN-D10078 ----(e)

            #FUN-C10036---add---str-----
            IF sr1.abb06='2' THEN
               LET l_abb07f_2 = sr1.abb07f
            ELSE
               LET l_abb07f_2 = 0
            END IF
            PRINTX l_abb07f_2
            IF sr1.abb06='1' THEN
               LET l_abb07f_1 = sr1.abb07f
            ELSE
               LET l_abb07f_1 = 0
            END IF
            PRINTX l_abb07f_1

            LET l_abb07f_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.t_azi04)
            PRINTX l_abb07f_fmt
            #FUN-C10036---add---end-----

            #FUN-B40097----add----str-----------------
            IF sr1.abb06='1' THEN
               LET l_abb07_1 = sr1.abb07
            ELSE
               LET l_abb07_1 = 0
            END IF
            PRINTX l_abb07_1
            IF sr1.abb06='2' THEN
               LET l_abb07_2 = sr1.abb07
            ELSE
               LET l_abb07_2 = 0
            END IF
            PRINTX l_abb07_2

            LET l_abb07_1_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)    #FUN-C10036 g_azi04->sr1.azi04
            PRINTX l_abb07_1_fmt

            LET l_abb07_2_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)    #FUN-C10036 g_azi04->sr1.azi04
            PRINTX l_abb07_2_fmt

            LET l_aba08_fmt = cl_gr_numfmt('aba_file','aba08',sr1.azi04)    #FUN-C10036 g_azi04->sr1.azi04
            PRINTX l_aba08_fmt

            LET l_aba09_fmt = cl_gr_numfmt('aba_file','aba09',sr1.azi04)    #FUN-C10036 g_azi04->sr1.azi04
            PRINTX l_aba09_fmt
            #FUN-B40097----add----end-----------------

            PRINTX sr1.*
       #TQC-D10092 ---(S)
           #FUN-D50063 mark-(s)
           # LET l_pagecnt = (l_lineno / 5) + 1    #目前頁次
           # IF (l_body_cnt MOD 5) > 0 THEN
           #    LET l_pagetot = (l_body_cnt / 5) + 1  #總頁次
           # ELSE
           #    LET l_pagetot = (l_body_cnt / 5)      #總頁次
           # END IF
           #FUN-D50063 mark-(e)
           #FUN-D50063 add-(s)
            LET l_pagecnt = (l_lineno / 4) + 1    #目前頁次#FUN-D50063
            IF (l_body_cnt MOD 4) > 0 THEN
               LET l_pagetot = (l_body_cnt / 4) + 1  #總頁次
            ELSE
               LET l_pagetot = (l_body_cnt / 4)      #總頁次
            END IF
           #FUN-D50063 add-(e)
            IF cl_null(l_pagetot) OR l_pagetot = 0 THEN LET l_pagetot=1 END IF
            IF cl_null(l_pagecnt) OR l_pagecnt = 0 THEN LET l_pagecnt=1 END IF
            LET l_pageno= l_pagecnt USING '##','/',l_pagetot USING '##'
            PRINTX l_pageno
       #TQC-D10092 ---(E)

        AFTER GROUP OF sr1.aba01
        AFTER GROUP OF sr1.abb02

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C10036 --add--str
FUNCTION g903_get_ahe02(p_aag01,p_aed02,p_gaq01,p_aee02)
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
     PREPARE g903_gaq01_p FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
     END IF
     DECLARE g903_gaq01_cs SCROLL CURSOR FOR g903_gaq01_p  

     #取異動碼(核算項)名稱
     LET l_ahe01 = NULL
     OPEN g903_gaq01_cs USING p_aag01
     IF SQLCA.sqlcode THEN
        CLOSE g903_gaq01_cs
        RETURN NULL
     END IF
     FETCH FIRST g903_gaq01_cs INTO l_ahe01
     IF SQLCA.sqlcode THEN
        CLOSE g903_gaq01_cs
        RETURN NULL
     END IF
     CLOSE g903_gaq01_cs
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
#FUN-C10036--add--end
