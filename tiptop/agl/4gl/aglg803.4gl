# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglg803.4gl
# Descriptions...: 科目異動別立沖帳列印
# Input parameter:
# Return code....:
# Date & Author..: 92/08/03 By DAVID
# modi by nick 96/05/18 line 367 l_bamt WHERE條件漏掉帳別
#                  By Melody    aee00 改為 no-use
# Modify.........: No.FUN-510007 05/01/11 By Nicola 報表架構修改
# Modify.........: No: FUN-5C0015 06/01/05 By kevin
#                  畫面QBE加aec052異動碼類型代號，^p q_ahe。
#                  (p_zaa)序號32放寬至30
#                  程式行數:357將aec052替換成aed012
# Modify.........: No.MOD-660027 06/06/08 By Smapmin 總頁次無法印出
# Modify.........: No.FUN-660060 06/06/27 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/10 By bnlent 會計科目加帳套
# Modify.........: No.FUN-830094 08/05/20 By zhaijie 報表輸出改為CR
# Modify.........: No.MOD-880171 08/08/26 By Sarah 報表加印期初餘額
# Modify.........: No.MOD-880170 08/08/26 By Sarah 增加g803_subchr(),g803_subchr1(),修正字串替換時程序當出的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:MOD-A90077 10/09/10 By Dido 帳別串連問題處理 
# Modify.........: No.FUN-B20054 10/02/21 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No:MOD-B30715 11/03/30 By Dido l_wc 轉換 aec052 位置對調;aglg803_prepare1語法調整 
# Modify.........: No:FUN-B80158 11/09/22 By yangtt 明細類CR轉換成GRW

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
              wc        STRING, # Where condition  #TQC-630166  
              t         LIKE type_file.chr3,     # none trans print (Y/N) ?  #No.FUN-680098 VARCHAR(3)
              y         LIKE type_file.chr3,     #No.FUN-680098 VARCHAR(3)
              w         LIKE type_file.chr3,     #No.FUN-680098 VARCHAR(3)
              x         LIKE type_file.chr3,     #No.FUN-680098 VARCHAR(3)
              e         LIKE type_file.chr1,     #FUN-6C0012
              more      LIKE type_file.chr1     # Input more condition(Y/N)   #No.FUN-680098 VARCHAR(1)
           END RECORD,
           bookno  LIKE aaa_file.aaa01,             #No.FUN-740020
           bdate   LIKE type_file.dat,              # Begin date  #No.FUN-680098 date
           edate   LIKE type_file.dat,              # Ended date  #No.FUN-680098 date
           l_begin,l_end   LIKE type_file.dat,      # Ended date  #No.FUN-680098 date
           yy   LIKE azn_file.azn02,               #No.FUN-680098 SMALLINT
           mm   LIKE azn_file.azn04,               #No.FUN-680098 SMALLINT
           #g_bookno LIKE aaa_file.aaa01,  #帳別   #No.FUN-740020
           l_flag  LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680098 SMALLINT
DEFINE g_sql      STRING                                         #NO.FUN-830094
DEFINE g_sql1     STRING                                         #NO.FUN-B80158 add
DEFINE g_sql2     STRING                                         #NO.FUN-B80158 add
DEFINE g_str      STRING                                         #NO.FUN-830094
DEFINE l_table    STRING                                         #NO.FUN-830094
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE oay_file.oayslip,
    aec01 LIKE aec_file.aec01,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    aag04 LIKE aag_file.aag04,
    aec051 LIKE aec_file.aec051,
    aec05 LIKE aec_file.aec05,
    aec02 LIKE aec_file.aec02,
    aec03 LIKE aec_file.aec03,
    aec04 LIKE aec_file.aec04,
    abb04 LIKE abb_file.abb04,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    aee04 LIKE aee_file.aee04,
    l_bamt LIKE aed_file.aed05,
    #FUN-B80158------add-------str-----
    amt34  LIKE abb_file.abb07,
    amt35  LIKE abb_file.abb07
    #FUN-B80158------add-------end-----
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#NO.FUN-830094-----START----
   LET g_sql = "order1.oay_file.oayslip,aec01.aec_file.aec01,",
               "aag02.aag_file.aag02,   aag13.aag_file.aag13,",
               "aag04.aag_file.aag04,   aec051.aec_file.aec051,",
               "aec05.aec_file.aec05,   aec02.aec_file.aec02,",
               "aec03.aec_file.aec03,   aec04.aec_file.aec04,",
               "abb04.abb_file.abb04,   abb06.abb_file.abb06,",
               "abb07.abb_file.abb07,   aee04.aee_file.aee04,",
               "l_bamt.aed_file.aed05,",
               #FUN-B80158------add-------str-----
               "amt34.abb_file.abb07,",
               "amt35.abb_file.abb07"
               #FUN-B80158------add-------end-----
   LET l_table = cl_prt_temptable('aglg803',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"     #FUN-B80158  add 2?   
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF               
#NO.FUN-830094-----START----
#  LET g_bookno= ARG_VAL(1)            #No.FUN-740020
   LET bookno  = ARG_VAL(1)              #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.wc   = ARG_VAL(8)
   LET tm.t    = ARG_VAL(9)
   LET tm.y    = ARG_VAL(10)
   LET tm.w    = ARG_VAL(11)
   LET tm.x    = ARG_VAL(12)
   LET bdate   = ARG_VAL(13)   #TQC-610056
   LET edate   = ARG_VAL(14)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-740020 --Begin
   #IF g_bookno IS  NULL OR g_bookno = ' ' THEN
   #   LET g_bookno = g_aaz.aaz64
   #END IF
   IF bookno IS  NULL OR bookno = ' ' THEN
      LET bookno = g_aza.aza81
   END IF
#No.FUN-740020  --End--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg803_tm()
   ELSE
      CALL aglg803()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
END MAIN
 
FUNCTION aglg803_tm()
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680098 SMALLINT
   DEFINE l_cmd          LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
   CALL s_dsmark(bookno)     #No.FUN-740020
   LET p_row = 2 LET p_col = 16
   OPEN WINDOW aglg803_w AT p_row,p_col
     WITH FORM "agl/42f/aglg803"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,bookno)   #No.FUN-740020
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET bdate   = g_today
   LET edate   = g_today
   LET tm.t    = 'N'
   LET tm.y    = 'Y'
   LET tm.w    = '1'
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.x    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
#FUN-B20054--add--start--
      DIALOG  ATTRIBUTE(unbuffered)
         INPUT BY NAME bookno ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD bookno
              IF NOT cl_null(bookno) THEN
                   CALL s_check_bookno(bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
             END IF
         END INPUT
#FUN-B20054--add--end--
      #  FUN-5C0015 mod (s)
      #  add aec052
      CONSTRUCT BY NAME tm.wc ON aec01,aec051,aec052,aec05
      #  FUN-5C0015 mod (e)
 
         # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#No.FUN-B20054--mark--start-- 
#         ON ACTION controlp
#            CASE
#              WHEN INFIELD(aec052) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aec052
#                NEXT FIELD aec052
#              OTHERWISE EXIT CASE
#            END CASE
#         # FUN-5C0015 (e)
# 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
# 
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION controlg      #MOD-4C0121
#            CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end--
 
      END CONSTRUCT
#No.FUN-B20054--mark--start-- 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglg803_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN
#         CALL cl_err('','9046',0)
#         CONTINUE WHILE
#      END IF
# 
#      LET tm.wc = g803_subchr(tm.wc,'"',"'")   #MOD-880170 add
#No.FUN-B20054--mark--end-- 
    #  INPUT BY NAME bookno,bdate,edate,tm.t,tm.y,tm.x,tm.w,tm.e,tm.more WITHOUT DEFAULTS  #FUN-6C0012   #No.FUN-740020
       INPUT BY NAME bdate,edate,tm.t,tm.y,tm.x,tm.w,tm.e,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         #No.FUN-740020  --Begin
         AFTER FIELD bookno
            IF bookno IS NULL THEN
               NEXT FIELD bookno
            END IF
         #No.FUN-740020  --End
         AFTER FIELD bdate
            IF bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD edate
            IF edate IS NULL THEN
               NEXT FIELD edate
            END IF
 
            IF edate < bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
 
         AFTER FIELD t
            IF tm.t NOT MATCHES "[YN]" THEN
               NEXT FIELD t
            END IF
 
         AFTER FIELD y
            IF tm.y NOT MATCHES "[YN]" THEN
               NEXT FIELD y
            END IF
 
         AFTER FIELD x
            IF tm.x NOT MATCHES "[YN]" THEN
               NEXT FIELD x
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF

#No.FUN-B20054--mark--start--
#        #No.FUN-740020  --Begin
#         ON ACTION CONTROLP
#          CASE
#            WHEN INFIELD(bookno)                                                                                                       
#              CALL cl_init_qry_var()                                                                                                 
#              LET g_qryparam.form = 'q_aaa'                                                                                          
#              LET g_qryparam.default1 = bookno                                                                                     
#              CALL cl_create_qry() RETURNING bookno                                                                                
#              DISPLAY BY NAME bookno                                                                                               
#              NEXT FIELD bookno 
#          END CASE
#         #No.FUN-740020  --End
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
      END INPUT
#No.FUN-B20054--add--end--
         ON ACTION controlp
            CASE
               WHEN INFIELD(aec052) #異動碼類型代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_ahe"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aec052
                  NEXT FIELD aec052
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = bookno
                  CALL cl_create_qry() RETURNING bookno
                  DISPLAY BY NAME bookno
                  NEXT FIELD bookno
                WHEN INFIELD(aec01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aag02'
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.where = " aag00 = '",bookno CLIPPED,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aec01
                  NEXT FIELD aec01
               OTHERWISE EXIT CASE
            END CASE
 
          ON ACTION locale
             LET g_action_choice = "locale"
             CALL cl_show_fld_cont()               
             EXIT DIALOG
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG
 
          ON ACTION about       
             CALL cl_about()   
 
          ON ACTION help        
             CALL cl_show_help() 
 
          ON ACTION controlg    
             CALL cl_cmdask()  
 
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT DIALOG
 
          ON ACTION qbe_select
             CALL cl_qbe_select()
        
          ON ACTION accept
             EXIT DIALOG

          ON ACTION cancel
             LET INT_FLAG=1
             EXIT DIALOG
       END DIALOG
#No.FUN-B20054--add--end-- 
      SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
      #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(yy,mm,g_plant,bookno) RETURNING l_flag,l_begin,l_end
      ELSE
         CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
      END IF
      #CHI-A70007 add --end--

#No.FUN-B20054--add--start--
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
#No.FUN-B20054--add--end--
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglg803_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
#No.FUN-B20054--add--start-- 
       IF tm.wc = ' 1=1' THEN
          CALL cl_err('','9046',0)
          CONTINUE WHILE
       END IF

       LET tm.wc = g803_subchr(tm.wc,'"',"'")   #MOD-880170 add
#No.FUN-B20054--add--end--

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg803'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('aglg803','9031',1)   
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",bookno CLIPPED,"' ",   #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.y CLIPPED,"'",
                        " '",tm.w CLIPPED,"'",
                        " '",tm.x CLIPPED,"'",
                        " '",bdate CLIPPED,"'",   #TQC-610056
                        " '",edate CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg803',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglg803_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglg803()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg803_w
 
END FUNCTION
 
FUNCTION aglg803()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680098 VARCHAR(20)
#         l_time      LIKE type_file.chr8           #No.FUN-6A0073
         #l_wc        LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(600)
          l_wc        STRING,                       #No.FUN-680098 VARCHAR(600)
          l_sql       STRING,                       #TQC-630166       
          l_sql1      STRING,                       #TQC-630166       
          l_buf       LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(100)
          l_chr       LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          i           LIKE type_file.num5,          #No.FUN-680098 smallint
          sr          RECORD
                         order1 LIKE oay_file.oayslip,#No.FUN-680098 
                         aec01 LIKE aec_file.aec01,   # acct. kinds
                         aag02 LIKE aag_file.aag02,   #
                         aag13 LIKE aag_file.aag13,   #FUN-6C0012
                         aag04 LIKE aag_file.aag04,   #
                         aec051 LIKE aec_file.aec051, # trans seq
                         aec05 LIKE aec_file.aec05,   # trans no
                         aec02 LIKE aec_file.aec02,   # trans date
                         aec03 LIKE aec_file.aec03,   # trans no
                         aec04 LIKE aec_file.aec04,   # trans no
                         abb04 LIKE abb_file.abb04,   # Description
                         abb06 LIKE abb_file.abb06,   # D or  C
                         abb07 LIKE abb_file.abb07,   # amount
                         aee04 LIKE aee_file.aee04,
                         #FUN-B80158------add-------str-----
                         amt34  LIKE abb_file.abb07,
                         amt35  LIKE abb_file.abb07
                         #FUN-B80158------add-------end-----
                      END RECORD
#NO.FUN-830094---START----- 
DEFINE       l_bamt,l_d,l_c                 LIKE aed_file.aed05
 
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aglg803' 
#NO.FUN-830094---END-----
 
   SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = bookno    #No.FUN-740020
                                               AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
#  CALL cl_outnam('aglg803') RETURNING l_name             #NO.FUN-830094
#  START REPORT aglg803_rep TO l_name                     #NO.FUN-830094
 
   LET g_pageno = 0
   LET g_cnt = 0
   LET l_flag='N'
 
   #期初餘額
   LET l_wc = tm.wc
 
  #str MOD-880170 mod
  #FOR i = 1 TO 300
  #   IF l_wc[i,i] != 'a' THEN CONTINUE FOR END IF
  #   IF l_wc[i,i+4] = 'aec01' THEN LET l_wc[i,i+4] = 'aed01' END IF
  #   IF l_wc[i,i+5] = 'aec051' THEN LET l_wc[i,i+4] = 'aed011' END IF
  #   IF l_wc[i,i+4] = 'aec05' THEN LET l_wc[i,i+4] = 'aed02' END IF
  #   # FUN-5C0015  (s)
  #   IF l_wc[i,i+5] = 'aec052' THEN LET l_wc[i,i+4] = 'aed012' END IF
  #   # FUN-5C0015  (e)
  #END FOR
   LET l_wc = g803_subchr1(l_wc,'aec01','aed01')
   LET l_wc = g803_subchr1(l_wc,'aec051','aed011')
  #LET l_wc = g803_subchr1(l_wc,'aec05','aed02')   #MOD-B30715 mark
   LET l_wc = g803_subchr1(l_wc,'aec052','aed012')
   LET l_wc = g803_subchr1(l_wc,'aec05','aed02')   #MOD-B30715
  #end MOD-880170 mod
 
   CASE
      WHEN tm.w = '1'
         LET l_sql="SELECT aag223,"
         LET l_buf="GROUP BY aag223,aed01,aag02,aag13,aag04,aed011,aed02,aee04"   #FUN-6C0012
      WHEN tm.w = '2'
         LET l_sql="SELECT aag224,"
         LET l_buf="GROUP BY aag224,aed01,aag02,aag13,aag04,aed011,aed02,aee04"   #FUN-6C0012
      WHEN tm.w = '3'
         LET l_sql="SELECT aag225,"
         LET l_buf="GROUP BY aag225,aed01,aag02,aag13,aag04,aed011,aed02,aee04"   #FUN-6C0012
      WHEN tm.w = '4'
         LET l_sql="SELECT aag226,"
         LET l_buf="GROUP BY aag226,aed01,aag02,aag13,aag04,aed011,aed02,aee04"   #FUN-6C0012
      OTHERWISE
         LET l_sql="SELECT '',    "
         LET l_buf="GROUP BY aed01,aag02,aag13,aag04,aed011,aed02,aee04"    #FUN-6C0012
   END CASE
 
   LET l_sql = l_sql CLIPPED,
               "       aed01,aag02,aag13,aag04,aed011,aed02,' ',' ',' ', ",   #FUN-6C0012
               "       ' ',' ',SUM(aed05-aed06),aee04,0,0 ",         #FUN-B80158 add 2 0 
               "  FROM aed_file LEFT OUTER JOIN aag_file",
              #"   ON aed01 = aag01",                        #MOD-A90077 mark
               "   ON aed01 = aag01 AND aed00 = aag00 ",     #MOD-A90077
               "  LEFT OUTER JOIN aee_file",
              #"   ON aee01 = aed01 AND aee02 = aed011 AND aee03 = aed02",                     #MOD-A90077 mark
               "   ON aee01 = aed01 AND aee02 = aed011 AND aee03 = aed02 AND aee00 = aed00 ",  #MOD-A90077
               " WHERE aed03 = ",year(bdate),"  AND aed04 < ",month(bdate),
               "   AND aag00 = '",bookno,"' ",     #No.FUN-740020
               "   AND ",l_wc CLIPPED," ",l_buf CLIPPED
   PREPARE aglg803_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE aglg803_curs2 CURSOR FOR aglg803_prepare2
 
   FOREACH aglg803_curs2 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach2:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF sr.abb07 = 0 OR sr.abb07 IS NULL THEN
         CONTINUE FOREACH
      END IF
 
      LET l_bamt = sr.abb07   #MOD-880171 add
      LET sr.abb07 = 0
 
      #FUN-B80158------add-----------str----
      IF sr.abb06 = '1' THEN
         LET sr.amt34 = sr.abb07 
      ELSE
         LET sr.amt34 = 0
      END IF
 
      IF sr.abb06 = '1' THEN
         LET sr.amt35 = 0
      ELSE
         LET sr.amt35 = sr.abb07 
      END IF
      
      #FUN-B80158------add-----------end----


      LET l_flag='Y'
#     OUTPUT TO REPORT aglg803_rep(sr.*)           #NO.FUN-830094
#NO.FUN-830094---START-----
      EXECUTE insert_prep USING
        sr.order1,sr.aec01,sr.aag02,sr.aag13,sr.aag04,sr.aec051,sr.aec05,
        sr.aec02,sr.aec03,sr.aec04,sr.abb04,sr.abb06,sr.abb07,sr.aee04,
       #'0'        #MOD-880171 mark
        l_bamt,sr.amt34,sr.amt35     #MOD-880171      #FUN-B80158   add sr.amt34,amt35
#NO.FUN-830094---END-----
   END FOREACH
 
   CASE WHEN tm.w = '1' LET l_sql="SELECT aag223,"
        WHEN tm.w = '2' LET l_sql="SELECT aag224,"  
        WHEN tm.w = '3' LET l_sql="SELECT aag225,"
        WHEN tm.w = '4' LET l_sql="SELECT aag226,"
        OTHERWISE       LET l_sql="SELECT '',    "
   END CASE
 
   LET l_sql = l_sql CLIPPED,
               "       aec01,aag02,aag13,aag04,",    #FUN-6C0012
               "       aec051,aec05,aec02,aec03,aec04, ",
               "       abb04,abb06,abb07,aee04,0,0 ",       #FUN-B80158   add 2 0 
              #"  FROM aec_file LEFT OUTER JOIN aag_file",  #MOD-B30715 mark
               "  FROM aec_file ",                          #MOD-B30715 
              #"   ON aec01 = aag01",                       #MOD-B30715
               "  LEFT OUTER JOIN aee_file",
              #"   ON aee01 = aec01 AND aee02 = aec051 AND aee03 = aec05,abb_file",                     #MOD-A90077 mark
              #"   ON aee01 = aec01 AND aee02 = aec051 AND aee03 = aec05 AND aee00 = abb00,abb_file",   #MOD-A90077      #MOD-B30715 mark
               "   ON aee01 = aec01 AND aee02 = aec051 AND aee03 = aec05 AND aee00 = aec00, ",
               "       abb_file LEFT OUTER JOIN aag_file ON abb00 = aag00 AND abb03 = aag01 ",   
               " WHERE aec00 = '",bookno,"' ",   #No.FUN-740020
               "   AND aec02 BETWEEN '",bdate,"' AND '",edate,"' ",
              #"   AND abb00 = '",bookno,"' ",   #No.FUN-740020 #MOD-B30715 mark
               "   AND abb00 = aec00 ",                         #MOD-B30715 
              #"   AND aag00 = '",bookno,"' ",   #No.FUN-740020 #MOD-B30715 mark
               "   AND abb01 = aec03 AND abb02 = aec04 ",
               "   AND ",tm.wc CLIPPED    
 
   PREPARE aglg803_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE aglg803_curs1 CURSOR FOR aglg803_prepare1
 
   FOREACH aglg803_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach1:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_flag='Y'
#     OUTPUT TO REPORT aglg803_rep(sr.*)           #NO.FUN-830094
#NO.FUN-830094---START-----
      LET l_d = 0
      LET l_c = 0 
      LET l_bamt = 0
 
      IF sr.aag04 = '1' THEN
         SELECT sum(aed05-aed06) INTO l_bamt
           FROM aed_file
          WHERE aed01 = sr.aec01
            AND aed03 = yy
            AND aed04 < mm
            AND aed011= sr.aec051
            AND aed02 = sr.aec05
            AND aed00 = bookno     
         IF l_bamt IS NULL THEN
            LET l_bamt = 0
         END IF
      END IF
      
      SELECT sum(abb07) INTO l_d
        FROM abb_file,aec_file
       WHERE aec00 = bookno        
         AND aec01 = sr.aec01
         AND aec02 >= l_begin
         AND aec02 < bdate
         AND aec051 = sr.aec051
         AND aec05 = sr.aec05
         AND abb00 = bookno
         AND abb01 = aec03
         AND abb02 = aec04
         AND abb06 = '1'
      
      SELECT sum(abb07) INTO l_c
        FROM abb_file,aec_file
       WHERE aec00 = bookno        
         AND aec01 = sr.aec01
         AND aec02 >= l_begin
         AND aec02 < bdate
         AND aec051 = sr.aec051
         AND aec05 = sr.aec05
         AND abb00 = bookno 
         AND abb01 = aec03
         AND abb02 = aec04
         AND abb06 = '2'
      
      IF l_bamt IS NULL THEN
         LET l_bamt = 0
      END IF
 
      IF l_d IS NULL THEN
         LET l_d = 0
      END IF
      
      IF l_c IS NULL THEN
         LET l_c = 0
      END IF
      
      LET l_bamt = l_bamt + l_d - l_c

      #FUN-B80158------add-----------str----
      IF sr.abb06 = '1' THEN
         LET sr.amt34 = sr.abb07 
      ELSE
         LET sr.amt34 = 0
      END IF
 
      IF sr.abb06 = '1' THEN
         LET sr.amt35 = 0
      ELSE
         LET sr.amt35 = sr.abb07 
      END IF
      
      #FUN-B80158------add-----------end----

      EXECUTE insert_prep USING 
        sr.order1,sr.aec01,sr.aag02,sr.aag13,sr.aag04,sr.aec051,sr.aec05,
        sr.aec02,sr.aec03,sr.aec04,sr.abb04,sr.abb06,sr.abb07,sr.aee04,
        l_bamt,sr.amt34,sr.amt35           #FUN-B80158   add sr.amt34,amt35
#NO.FUN-830094---END-----
   END FOREACH
 
#  FINISH REPORT aglg803_rep                             #NO.FUN-830094
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-830094
#NO.FUN-830094--------start------------
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(tm.wc,'aec01,aec051,aec052,aec05')
         RETURNING tm.wc
   END IF
###GENGRE###   LET g_str = tm.wc,";",bdate,";",edate,";",tm.x,";",
###GENGRE###               tm.t,";",tm.w,";",tm.e,";",g_azi04,";",
###GENGRE###               tm.y             
###GENGRE###   CALL cl_prt_cs3('aglg803','aglg803',g_sql,g_str)                      
    CALL aglg803_grdata()    ###GENGRE###
#NO.FUN-7830094--------end------------
END FUNCTION
#NO.FUN-830094--START-----
#REPORT aglg803_rep(sr)
#DEFINE sr     RECORD
#                 order1 LIKE type_file.chr8,   #No.FUN-680098 VARCHAR(5)
#                 aec01 LIKE aec_file.aec01,   # acct. kinds
#                 aag02 LIKE aag_file.aag02,   #
#                 aag13 LIKE aag_file.aag13,   #FUN-6C0012
#                 aag04 LIKE aag_file.aag04,   #
#                 aec051 LIKE aec_file.aec051, # trans no
#                 aec05 LIKE aec_file.aec05,   # trans no
#                 aec02 LIKE aec_file.aec02,   # trans date
#                 aec03 LIKE aec_file.aec03,   # trans no
#                 aec04 LIKE aec_file.aec04,   # trans no
#                 abb04 LIKE abb_file.abb04,   # Description
#                 abb06 LIKE abb_file.abb06,   # D or  C
#                 abb07 LIKE abb_file.abb07,   # amount
#                 aee04 LIKE aee_file.aee04
#              END RECORD,
#       l_bamt,l_d,l_c                 LIKE aed_file.aed05,
#       l_t_d,l_t_c                    LIKE abb_file.abb07,
#       m_t_d,m_t_c,m_t_bal,m_t_begin  LIKE abb_file.abb07,
#       l_last_sw,l_chr,l_abb06        LIKE type_file.chr1,        #No.FUN-680098 VARCHAR(1)
#       m                              LIKE type_file.num5         #No.FUN-680098 smallint
#DEFINE g_head1                        STRING
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.order1,sr.aec01,sr.aec051,sr.aec05,sr.aec02
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         LET g_head1 = g_x[11] CLIPPED,bdate,'-',edate
#         #PRINT g_head1                        #FUN-660060 remark
#         PRINT COLUMN (g_len-25)/2+1, g_head1  #FUN-660060
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
# 
#      BEFORE GROUP OF sr.order1
#         IF tm.x = 'Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#         LET m_t_d = 0
#         LET m_t_c = 0
#         LET m_t_bal = 0
#         LET m_t_begin = 0
#
#      BEFORE GROUP OF sr.aec01
#         IF tm.t = 'Y' THEN
#            SKIP TO TOP OF PAGE
#         END IF
#
#         IF tm.w MATCHES "[12345]" THEN
#            PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#                  COLUMN g_c[32],sr.order1 CLIPPED;
#         END IF
#
#         PRINT COLUMN g_c[33],g_x[9] CLIPPED,
#               COLUMN g_c[34],sr.aec01 CLIPPED;
##              COLUMN g_c[35],sr.aag02 CLIPPED   #FUN-6C0012
#         #FUN-6C0012.....begin
#         IF tm.e = 'N' THEN
#            PRINT COLUMN g_c[35],sr.aag02 CLIPPED
#         ELSE
#            PRINT COLUMN g_c[35],sr.aag13 CLIPPED
#         END IF
#         #FUN-6C0012.....end
# 
#      BEFORE GROUP OF sr.aec05
#         LET l_bamt = 0
#         IF sr.aag04 = '1' THEN
#            SELECT sum(aed05-aed06) INTO l_bamt
#              FROM aed_file
#             WHERE aed01 = sr.aec01
#               AND aed03 = yy
#               AND aed04 < mm
#               AND aed011= sr.aec051
#               AND aed02 = sr.aec05
#               AND aed00 = bookno     #No.FUN-740020
#            IF l_bamt IS NULL THEN
#               LET l_bamt = 0
#            END IF
#         END IF
#
#         SELECT sum(abb07) INTO l_d
#           FROM abb_file,aec_file
#          WHERE aec00 = bookno        #No.FUN-740020
#            AND aec01 = sr.aec01
#            AND aec02 >= l_begin
#            AND aec02 < bdate
#            AND aec051 = sr.aec051
#            AND aec05 = sr.aec05
#            AND abb00 = bookno         #No.FUN-740020
#            AND abb01 = aec03
#            AND abb02 = aec04
#            AND abb06 = '1'
#
#         SELECT sum(abb07) INTO l_c
#           FROM abb_file,aec_file
#          WHERE aec00 = bookno        #No.FUN-740020
#            AND aec01 = sr.aec01
#            AND aec02 >= l_begin
#            AND aec02 < bdate
#            AND aec051 = sr.aec051
#            AND aec05 = sr.aec05
#            AND abb00 = bookno        #No.FUN-740020
#            AND abb01 = aec03
#            AND abb02 = aec04
#            AND abb06 = '2'
#
#         IF l_d IS NULL THEN
#            LET l_d = 0
#         END IF
#
#         IF l_c IS NULL THEN
#            LET l_c = 0
#         END IF
#
#         LET l_bamt = l_bamt + l_d - l_c
#
#         IF l_bamt >= 0 THEN
#            PRINT COLUMN g_c[31],'(',sr.aec051,') ',
#                  COLUMN g_c[32],sr.aec05 CLIPPED,
#                  # FUN-5C0015 (s)
#                  #COLUMN g_c[33],sr.aee04,
#                  COLUMN g_c[33],sr.aee04[1,16],
#                  # FUN-5C0015 (e)
#                  COLUMN g_c[36],cl_numfor(l_bamt,36,g_azi04),
#                  COLUMN g_c[37],'D'
#         ELSE
#            LET l_bamt = l_bamt * (-1)
#            PRINT COLUMN g_c[31],'(',sr.aec051,') ',
#                  COLUMN g_c[32],sr.aec05 CLIPPED,
#                  # FUN-5C0015 (s)
#                  #COLUMN g_c[33],sr.aee04,
#                  COLUMN g_c[33],sr.aee04[1,16],
#                  # FUN-5C0015 (e)
#                  COLUMN g_c[36],cl_numfor(l_bamt,36,g_azi04),
#                  COLUMN g_c[37],'C'
#            LET l_bamt = l_bamt * (-1)
#         END IF
#
#         LET m_t_begin = m_t_begin + l_bamt
#         LET l_t_d = 0
#         LET l_t_c = 0
 
#     ON EVERY ROW
#         IF sr.abb07 != 0 THEN
#            PRINT COLUMN g_c[32],sr.aec02,
#                  COLUMN g_c[33],sr.aec03;
#            LET m = 0
#            IF sr.abb06 = '1' THEN
#               PRINT COLUMN g_c[34],cl_numfor(sr.abb07,34,g_azi04);
#               LET l_bamt = l_bamt +sr.abb07
#               LET l_t_d = l_t_d + sr.abb07
#               LET m_t_d = m_t_d + sr.abb07
#            ELSE
#               PRINT COLUMN g_c[35],cl_numfor(sr.abb07,35,g_azi04);
#               LET l_bamt= l_bamt- sr.abb07
#               LET l_t_c = l_t_c + sr.abb07
#               LET m_t_c = m_t_c + sr.abb07
#            END IF
#            IF l_bamt >= 0 THEN
#               PRINT COLUMN g_c[36],cl_numfor(l_bamt,36,g_azi04),
#                     COLUMN g_c[37],'D'
#            ELSE
#               LET l_bamt = l_bamt * (-1)
#               PRINT COLUMN g_c[36],cl_numfor(l_bamt,36,g_azi04),
#                     COLUMN g_c[37],'C'
#               LET l_bamt = l_bamt * (-1)
#            END IF
#            IF tm.y = 'Y' AND NOT cl_null(sr.abb04) THEN
#               PRINT COLUMN g_c[33],sr.abb04
#            END IF
#         END IF
# 
#      AFTER GROUP OF sr.aec05
#         #LET g_pageno = 0   #MOD-660027
#         PRINT
#         PRINT COLUMN g_c[33],g_x[10] CLIPPED,
#               COLUMN g_c[34],cl_numfor(l_t_d,34,g_azi04),
#               COLUMN g_c[35],cl_numfor(l_t_c,35,g_azi04)
#         PRINT
#         LET m_t_bal = m_t_bal + l_bamt
#
#      AFTER GROUP OF sr.order1
#         PRINT g_dash2
#         PRINT COLUMN g_c[31],g_x[13] CLIPPED;
#
#         IF m_t_begin >= 0 THEN
#            PRINT COLUMN g_c[32],cl_numfor(m_t_begin,34,g_azi04),
#                  COLUMN g_c[33],'D';
#         ELSE
#            LET m_t_begin = m_t_begin * (-1)
#            PRINT COLUMN g_c[32],cl_numfor(m_t_begin,34,g_azi04),
#                  COLUMN g_c[33],'C';
#         END IF
#
#         PRINT COLUMN g_c[34],cl_numfor(m_t_d,34,g_azi04),
#               COLUMN g_c[35],cl_numfor(m_t_c,35,g_azi04);
#
#         IF m_t_bal >= 0 THEN
#            PRINT COLUMN g_c[36],cl_numfor(m_t_bal,36,g_azi04),
#                  COLUMN g_c[37],'D'
#         ELSE
#            LET m_t_bal = m_t_bal * (-1)
#            PRINT COLUMN g_c[36],cl_numfor(m_t_bal,36,g_azi04),
#                  COLUMN g_c[37],'C'
#         END IF
#         PRINT g_dash2
# 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#            CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
#            PRINT g_dash[1,g_len]
#          #TQC-630166 
          # IF tm.wc[001,070] > ' ' THEN                  # for 80
          #    PRINT COLUMN g_c[31],g_x[8] CLIPPED,
          #          COLUMN g_c[32],tm.wc[001,070] CLIPPED
          # END IF
          # IF tm.wc[071,140] > ' ' THEN
          #    PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
          # END IF
          # IF tm.wc[141,210] > ' ' THEN
          #    PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
          # END IF
          # IF tm.wc[211,280] > ' ' THEN
          #    PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
          # END IF
#          CALL cl_prt_pos_wc(tm.wc)
          #END TQC-630166
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-7 ,g_x[7] CLIPPED   #MOD-660027
# 
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-7,g_x[6] CLIPPED   #MOD-660027
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#NO.FUN-830094-------END----
 
#str MOD-880170 add
FUNCTION g803_subchr(p_str,p_chr1,p_chr2)
DEFINE p_str          LIKE type_file.chr1000
DEFINE p_chr1,p_chr2  LIKE type_file.chr1
DEFINE l_str          LIKE type_file.chr1000
DEFINE l_n            LIKE type_file.num5
DEFINE buf            base.StringBuffer
 
   LET buf = base.StringBuffer.create()
   CALL buf.clear()
   CALL buf.append(p_str)
   DISPLAY buf.toString()
   CALL buf.replace(p_chr1,p_chr2,0)
   DISPLAY buf.toString()
   LET l_str = buf.toString()
   RETURN l_str
END FUNCTION
 
FUNCTION g803_subchr1(p_str,p_chr1,p_chr2)
DEFINE p_str          LIKE type_file.chr1000
DEFINE p_chr1,p_chr2  LIKE type_file.chr6
DEFINE l_str          LIKE type_file.chr1000
DEFINE l_n            LIKE type_file.num5
DEFINE buf            base.StringBuffer
 
   LET buf = base.StringBuffer.create()
   CALL buf.clear()
   CALL buf.append(p_str)
   DISPLAY buf.toString()
   CALL buf.replace(p_chr1,p_chr2,0)
   DISPLAY buf.toString()
   LET l_str = buf.toString()
   RETURN l_str
END FUNCTION
#end MOD-880170 add

###GENGRE###START
FUNCTION aglg803_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    #FUN-B80158---add----str-------------
 #  LET g_sql1 = "SELECT COUNT(DISTINCT aec01) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, 
 #               " WHERE aec01 = ? AND order1 = ?"   
 #  DECLARE aglg803_repcur1 CURSOR FROM g_sql1 
 #  LET g_sql2 = "SELECT COUNT(DISTINCT order1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, 
 #               " WHERE aec01 = ? AND order1 = ?"   
 #  DECLARE aglg803_repcur2 CURSOR FROM g_sql2
    #FUN-B80158---add---end----------------------

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg803")
        IF handler IS NOT NULL THEN
            START REPORT aglg803_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY order1 asc nulls first,aec01,aec051,aec05,aec02"  #FUN-B80158 add
          
            DECLARE aglg803_datacur1 CURSOR FROM l_sql
            FOREACH aglg803_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg803_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg803_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg803_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158---------add-------str----
    DEFINE l_amt34     LIKE abb_file.abb07
    DEFINE l_amt34_sum LIKE abb_file.abb07
    DEFINE l_amt35_sum LIKE abb_file.abb07
    DEFINE l_amt35     LIKE abb_file.abb07
    DEFINE g_c33       LIKE aee_file.aee04
    DEFINE g_c31       STRING
    DEFINE gc35        STRING
    DEFINE l_bamt      LIKE aed_file.aed05
    DEFINE l_abmt      LIKE aed_file.aed05
    DEFINE l_bamt_dc   LIKE type_file.chr1
    DEFINE l_bamt_34   LIKE abb_file.abb07
    DEFINE l_bamt_34_dc LIKE type_file.chr1
    DEFINE l_abmt2     LIKE aed_file.aed05
    DEFINE l_abmt2_dc  LIKE type_file.chr1
    DEFINE l_abmt2_34  LIKE aed_file.aed05
    DEFINE l_abmt2_34_dc LIKE type_file.chr1 
    DEFINE l_amt_fmt   STRING
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_cnt1      LIKE type_file.num10
    DEFINE l_cnt2      LIKE type_file.num10
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_aec01_cnt LIKE type_file.num10
    DEFINE l_skip      LIKE type_file.chr1
    DEFINE l_order1_cnt LIKE type_file.num10
    DEFINE l_skip2     LIKE type_file.chr1
    DEFINE l_skip3     LIKE type_file.chr1
    DEFINE l_skip1     LIKE type_file.chr1
    DEFINE l_order1    LIKE oay_file.oayslip
    DEFINE l_order1_o    LIKE oay_file.oayslip
    DEFINE l_flag1     LIKE type_file.chr1
    #FUN-B80158---------add-------end----

    
    ORDER EXTERNAL BY sr1.order1,sr1.aec01,sr1.aec051,sr1.aec05,sr1.aec02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime    #FUN-B80158  add g_user_name,g_ptime
            PRINTX tm.*
            PRINTX bdate,edate        #FUN-B80158 add
            LET l_aec01_cnt = 0                               #FUN-B80158 add
            LET l_order1_cnt = 0                              #FUN-B80158 add
            LET l_cnt = 0  
            
        BEFORE GROUP OF sr1.order1
           LET g_sql2 = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, 
                       " WHERE order1 IS NULL OR order1 = '",sr1.order1,"'" 
           LET l_cnt2 = 0          
     
           DECLARE aglg803_repcur2 CURSOR FROM g_sql2
           FOREACH aglg803_repcur2  INTO l_cnt2 END FOREACH 
            
        BEFORE GROUP OF sr1.aec01
           #FUN-B80158---------add-------str----
           IF tm.e = 'N' THEN
              LET gc35 = sr1.aag02
           ELSE
              LET gc35 = sr1.aag13
           END IF
           PRINTX gc35
           IF l_flag1 != 'N' THEN
           LET l_flag1 = 'Y'
           END IF
           #FUN-B80158---------add-------end----
        BEFORE GROUP OF sr1.aec051
        BEFORE GROUP OF sr1.aec05
           #FUN-B80158---------add-------str----
           LET g_c31 = '(',sr1.aec051,')'
           PRINTX g_c31
           LET g_c33 = sr1.aee04[1,16]
           PRINTX g_c33
           IF sr1.l_bamt >= 0 THEN
              LET l_bamt = sr1.l_bamt 
           ELSE 
              LET l_bamt = sr1.l_bamt * (-1)
           END IF
           PRINTX l_bamt
           IF sr1.l_bamt >= 0 THEN
              LET l_bamt_dc = 'D'
           ELSE
              LET l_bamt_dc = 'C'
           END IF
           PRINTX l_bamt_dc

           #FUN-B80158---------add-------end----
        BEFORE GROUP OF sr1.aec02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158---------add-------str----
            IF l_cnt2 = 0 THEN 
               LET l_order1_cnt = 0 
            END IF
            LET l_order1_cnt = l_order1_cnt + 1    

 
            LET g_sql1 = "SELECT COUNT(DISTINCT aec01) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
            DECLARE aglg803_repcur1 CURSOR FROM g_sql1 
            FOREACH aglg803_repcur1  INTO l_cnt1 END FOREACH   #FUN-B80158 add
     
      

            IF tm.y = 'Y' AND NOT cl_null(sr1.abb04) THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display
            LET l_amt_fmt = cl_gr_numfmt("aed_file","aed05",g_azi04)
            PRINTX l_amt_fmt
            LET l_bamt_34 = sr1.l_bamt + l_amt34 - l_amt35	
            IF l_bamt_34 >= 0 THEN
               LET l_bamt_34 = l_bamt_34 
               LET l_bamt_34_dc = 'D' 
            ELSE
               LET l_bamt_34 = l_bamt_34 * (-1) 
               LET l_bamt_34_dc = 'C' 
            END IF
            PRINTX l_bamt_34
            PRINTX l_bamt_34_dc
            #FUN-B80158---------add-------end----

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1
           #FUN-B80158---------add-------str----
           LET l_amt34_sum = GROUP SUM(sr1.amt34)
           PRINTX l_amt34_sum
           LET l_amt35_sum = GROUP SUM(sr1.amt35)
           PRINTX l_amt35_sum
           LET l_abmt = GROUP SUM(sr1.l_bamt)
           PRINTX l_abmt
           IF l_abmt >= 0 THEN
              LET l_abmt2 = l_abmt
              LET l_abmt2_dc = 'D' 
           ELSE
              LET l_abmt2 = l_abmt * (-1)
              LET l_abmt2_dc = 'C' 
           END IF
           PRINTX l_abmt2
           PRINTX l_abmt2_dc
           LET l_abmt2_34 = l_abmt + GROUP SUM(sr1.amt34) - GROUP SUM(sr1.amt35)
           IF l_abmt2_34 >=0 THEN
              LET l_abmt2_34 = l_abmt2_34
              LET l_abmt2_34_dc = 'D' 
           ELSE
              LET l_abmt2_34 = l_abmt2_34 * (-1)
              LET l_abmt2_34_dc = 'C' 
           END IF
           PRINTX l_abmt2_34
           PRINTX l_abmt2_34_dc
           #FUN-B80158---------add-------end----
        AFTER GROUP OF sr1.aec01
           #FUN-B80158---------add-------str----
           LET l_aec01_cnt = l_aec01_cnt + 1
           IF l_aec01_cnt = l_cnt1 THEN
              LET l_skip = 'N'
           ELSE 
              LET l_skip = 'Y'
           END IF
           PRINTX l_skip

           IF l_order1_cnt = l_cnt2 THEN
              LET l_skip2 = 'N'
              LET l_order1_cnt = 0
           ELSE
              LET l_skip2 = 'Y'
           END IF
           IF l_skip2 = 'N'  OR  l_skip = 'N' then 
              let l_skip3 = 'N'
           else
              let l_skip3 = 'Y'  
           END IF
              
           IF tm.t="Y" AND l_skip3="Y" THEN
              let l_skip1 = 'Y'
           else
              let l_skip1 = 'N'  
           END IF
            
           PRINTX l_skip1 

 
         
           #FUN-B80158---------add-------end----
        AFTER GROUP OF sr1.aec051
        AFTER GROUP OF sr1.aec05
           #FUN-B80158---------add-------str----
           LET l_amt34 = GROUP SUM(sr1.amt34)
           PRINTX l_amt34
           LET l_amt35 = GROUP SUM(sr1.amt35)
           PRINTX l_amt35
           LET l_abmt = GROUP SUM(sr1.l_bamt)
           PRINTX l_abmt
           #FUN-B80158---------add-------end----
        AFTER GROUP OF sr1.aec02

        
        ON LAST ROW

END REPORT
###GENGRE###END
