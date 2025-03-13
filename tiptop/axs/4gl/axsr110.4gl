# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: axsr110.4gl
# Descriptions...: 訂單統計表
# Date & Author..: 95/04/22 By Danny
# Modify.........: No.MOD-530523 05/03/29 By kim 百分比列印size加大
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 新增地區欄位
# Modify.........: No.FUN-580013 05/08/18 By vivien 報表轉XML格式
# Modify.........: No.FUN-570268 05/08/08 By Sarah 產品分類請加開窗
# Modify.........: No.MOD-5A0072 05/10/20 By Nicola 查詢輸入方式修改
# Modify.........: No.MOD-5A0079 05/10/20 By Nicola 總計欄位沒有對齊
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.TQC-610090 06/02/06 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0095 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6C0119 06/12/20 By Ray 表頭調整
# Modify.........: No.CHI-6C0019 06/12/27 By jamie wc2 chr1->chr1000
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740015 07/04/09 By TSD.Achick報表改寫由Crystal Report產出
# Modify.........: No.MOD-950018 09/05/05 By Smapmin 營運中心欄位應加上營運中心使用權限判斷
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/21 By wuxj GP5.2 跨DB報表 財務類   修改
# Modify.........: No.TQC-A50147 10/05/25 By Carrier main中结构调整 & MOD-A10015追单
# Modify.........: No.FUN-B80059 11/08/03 By minpp程序撰寫規範修改	
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No:TQC-CC0099 12/12/18 By qirl 增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_sql	string                             #No.FUN-580092 HCN
   DEFINE tm  RECORD                               # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-680130 VARCHAR(1000)
             #wc2     LIKE type_file.chr1,         # Where condition  #No.FUN-680130 VARCHAR(1000) #CHI-6C0019 mark
              wc2     LIKE type_file.chr1000,      # Where condition  #CHI-6C0019 mod
              s       LIKE type_file.chr4,         #No.FUN-680130 VARCHAR(4)
              t       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              u       LIKE type_file.chr3,         #No.FUN-680130 VARCHAR(3)
              y1      LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              m1b,m1e LIKE type_file.num5,         #No.FUN-680130 SMALLINT
              ch      LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              w       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
              more    LIKE type_file.chr1          # Input more condition(Y/N)  #No.FUN-680130 VARCHAR(1)
              END RECORD,
          g_order           LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(60)
          g_buf             LIKE type_file.chr1000,#No.FUN-680130 VARCHAR(10)
          g_str1,g_str2     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(04)
          g_str3,g_str4     LIKE zaa_file.zaa08,   #No.FUN-680130 VARCHAR(06)
          b_date,e_date     LIKE type_file.dat,    #No.FUN-680130 DATE
          g_total           LIKE oea_file.oea61,
          g_total1,g_total2 LIKE oea_file.oea61,
          l_azi03    LIKE azi_file.azi03,
          l_azi04    LIKE azi_file.azi04,
          l_azi05    LIKE azi_file.azi05
DEFINE    l_table    STRING                        #No.TQC-A50147
DEFINE    g_head1    LIKE type_file.chr1000        #No.FUN-680130 VARCHAR(400)
DEFINE    g_i        LIKE type_file.num5           #count/index for any purpose   #No.FUN-680130 SMALLINT
DEFINE g_str       STRING                       ### FUN-740015 add ###
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
#-------------No.TQC-610090 modify
   LET tm.wc   = ARG_VAL(7)
   LET tm.wc2  = ARG_VAL(8)
   LET tm.s    = ARG_VAL(9)
   LET tm.t    = ARG_VAL(10)
   LET tm.u    = ARG_VAL(11)
   LET tm.y1   = ARG_VAL(12)
   LET tm.m1b  = ARG_VAL(13)
   LET tm.m1e  = ARG_VAL(14)
   LET tm.w    = ARG_VAL(15)
   LET tm.ch   = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-------------No.TQC-610090 end

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80059    ADD #FUN-BB0047 mark
   #str FUN-740015 add
# *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/04/09 *** ##
     LET g_sql = "order1.oab_file.oab02,",
                 "order2.oab_file.oab02,",
                 "order3.oab_file.oab02,",
                 "order4.oab_file.oab02,",
                 "gem02.gem_file.gem02,",     #部門名稱
                 "gen02.gen_file.gen02,",     #人員名稱
                 "oab02.oab_file.oab02,",     #銷售名稱
                 "oea26.oea_file.oea26,",     #銷售分類二
                 "oea032.oea_file.oea032,",   #帳款客戶名稱
                 "oca02.oca_file.oca02,",     #客戶分類
                 "oea04.oea_file.oea04,",     #送貨客戶
                 "oea23.oea_file.oea23,",     #幣別
                 "oea24.oea_file.oea24,",     #匯率
                 "oeb14.oeb_file.oeb14,",     #金額
                 "oeb04.oeb_file.oeb04,",     #產品編號
                 "oea15.oea_file.oea15,",     #部門編號
                 "oea14.oea_file.oea14,",     #人員編號
                 "oea25.oea_file.oea25,",     #銷售分類一
                 "oea03.oea_file.oea03,",     #帳款客戶
                 "oca01.oca_file.oca01,",     #帳款客戶分類
                 "ima131.ima_file.ima131,",   #產品分類
                 "ima06.ima_file.ima06,",     #主要分群碼
                 "azp01.azp_file.azp01,",     #工廠編號
                 "oeb12.oeb_file.oeb12,",      #數量
                 "l_oab02.oab_file.oab02,",    
                 "occ02.occ_file.occ02,",   
                 "occ20.occ_file.occ20,",    
                 "occ21.occ_file.occ21,",   
                 "occ22.occ_file.occ22,",
                 "azi04.azi_file.azi04"    
 
    LET l_table = cl_prt_temptable('axsr110',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,? ,?,?,?,?,?,
                         ?,?,?,?,? ,?,?,?,?,?,
                         ?,?,?,?,? ,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
   #No.TQC-A50147  --End  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axsr110_tm(0,0)                # Input print condition
      ELSE CALL axsr110()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
END MAIN
 
FUNCTION axsr110_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,         #No.FUN-680130 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 18
 
   OPEN WINDOW axsr110_w AT p_row,p_col
        WITH FORM "axs/42f/axsr110"
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
   LET tm.w    = 'Y'
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
WHILE TRUE   #No.MOD-5A0072
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
 
     #-----MOD-610033---------
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
     #-----END MOD-610033-----
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      LET tm.wc="azp01='",g_plant,"'"
   END IF
   EXIT WHILE   #No.MOD-5A0072
END WHILE   #No.MOD-5A0072
 
WHILE TRUE   #No.MOD-5A0072
 
   CONSTRUCT BY NAME tm.wc2 ON oea15,oea14,oea25,oea26,oea03,oca01,
                               oea04,oea23,ima131,ima06,oeb04,
                               #occ20, occ21    #FUN-550091
                               occ20, occ21 ,occ22   #FUN-550091
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
#start FUN-570268
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ima131)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
#---TQC-CC0099--add--star--
            WHEN INFIELD(oea15)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_oea151"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea15
               NEXT FIELD oea15
            WHEN INFIELD(oea14)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_oea141"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
            WHEN INFIELD(oea03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_oea18"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea03
               NEXT FIELD oea03
            WHEN INFIELD(oeb04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_oeb04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oeb04
               NEXT FIELD oeb04
            WHEN INFIELD(oca01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_oca"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oca01
               NEXT FIELD oca01
            WHEN INFIELD(occ20)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form     = "q_occ20"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ20
               NEXT FIELD occ20
#---TQC-CC0099--add--end--
         END CASE
#end FUN-570268
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc2 = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   EXIT WHILE   #No.MOD-5A0072
END WHILE   #No.MOD-5A0072
 
#UI
   INPUT BY NAME #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                 tm.y1,tm.m1b,tm.m1e,tm.w,tm.ch,
                 tm.more WITHOUT DEFAULTS
      AFTER FIELD y1
         IF cl_null(tm.y1) THEN NEXT FIELD y1 END IF
      AFTER FIELD m1b
#No.TQC-720032 -- begin --
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
#No.TQC-720032 -- end --
         IF cl_null(tm.m1b) THEN NEXT FIELD m1b END IF
#         IF tm.m1b > 13 OR tm.m1b < 1 THEN NEXT FIELD m1b END IF  #No.TQC-720032 -- end --
      AFTER FIELD m1e
#No.TQC-720032 -- begin --
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
#No.TQC-720032 -- end --
         IF cl_null(tm.m1e) THEN NEXT FIELD m1e END IF
#No.TQC-720032 -- begin --
#         IF tm.m1e > 13 OR tm.m1e < 1 OR tm.m1e < tm.m1b THEN
#            NEXT FIELD m1e
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD ch
         IF cl_null(tm.ch) OR tm.ch NOT MATCHES '[1-2]' THEN
            NEXT FIELD ch
         END IF
         CASE WHEN tm.ch='1' LET g_str4=g_x[12]
              WHEN tm.ch='2' LET g_str4=g_x[13]
         END CASE
      AFTER FIELD w
         IF cl_null(tm.w) OR tm.w NOT MATCHES '[YN]' THEN NEXT FIELD w END IF
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
      LET INT_FLAG = 0 CLOSE WINDOW axsr110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axsr110'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axsr110','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",        #No.TQC-610090 add
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",          #No.TQC-610090 add
                         " '",tm.u CLIPPED,"'",          #No.TQC-610090 add
                         " '",tm.y1 CLIPPED,"'",
                         " '",tm.m1b CLIPPED,"'",
                         " '",tm.m1e CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",          #No.TQC-610090 add
                         " '",tm.ch CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axsr110',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axsr110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axsr110()
   ERROR ""
END WHILE
   CLOSE WINDOW axsr110_w
END FUNCTION
 
FUNCTION axsr110()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name       #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_azp01   LIKE azp_file.azp01,
          l_azp03   LIKE azp_file.azp03,
          l_date1   LIKE type_file.dat,            #No.FUN-680130 DATE
          l_date2   LIKE type_file.dat,            #No.FUN-680130 DATE
          l_oab02   LIKE oab_file.oab02,
          l_occ02   LIKE occ_file.occ02,
          l_occ20   LIKE occ_file.occ20,
          l_occ21   LIKE occ_file.occ21,
          l_occ22   LIKE occ_file.occ22,           #FUN-550091
          l_order   ARRAY[5] OF LIKE oab_file.oab02, #No.FUN-680130 VARCHAR(40)          #FUN-5B0105 20->40
          l_i       LIKE type_file.num5,           #No.FUN-680130 SMALLINT
          l_sql     LIKE type_file.chr1000,        #No.FUN-680130 VARCHAR(3000)
          sr  RECORD order1 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40) 
                     order2 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40) 
                     order3 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40) 
                     order4 LIKE oab_file.oab02,   #No.FUN-680130 VARCHAR(40) 
                     gem02  LIKE gem_file.gem02,   #部門名稱
                     gen02  LIKE gen_file.gen02,   #人員名稱
                     oab02  LIKE oab_file.oab02,   #銷售名稱
                     oea26  LIKE oea_file.oea26,   #銷售分類二
                     oea032 LIKE oea_file.oea032,  #帳款客戶名稱
                     oca02  LIKE oca_file.oca02,   #客戶分類
                     oea04  LIKE oea_file.oea04,   #送貨客戶
                     oea23  LIKE oea_file.oea23,   #幣別
                     oea24  LIKE oea_file.oea24,   #匯率
                     oeb14  LIKE oeb_file.oeb14,   #金額
                     oeb04  LIKE oeb_file.oeb04,   #產品編號
                     oea15  LIKE oea_file.oea15,   #部門編號
                     oea14  LIKE oea_file.oea14,   #人員編號
                     oea25  LIKE oea_file.oea25,   #銷售分類一
                     oea03  LIKE oea_file.oea03,   #帳款客戶
                     oca01  LIKE oca_file.oca01,   #帳款客戶分類
                     ima131 LIKE ima_file.ima131,  #產品分類
                     ima06  LIKE ima_file.ima06,   #主要分群碼
                     azp01  LIKE azp_file.azp01,   #工廠編號
                     oeb12  LIKE oeb_file.oeb12,    #數量
                     l_oab02 LIKE oab_file.oab02,    
                     occ02   LIKE occ_file.occ02,   
                     occ20   LIKE occ_file.occ20,    
                     occ21   LIKE occ_file.occ21,   
                     occ22   LIKE occ_file.occ22,
                     azi04   LIKE azi_file.azi04    
              END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
     #No.FUN-BB0047--mark--End-----
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-740015 add ###
 
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
 
     CALL s_azn01(tm.y1,tm.m1b) RETURNING b_date,l_date1
     CALL s_azn01(tm.y1,tm.m1e) RETURNING l_date2,e_date
 
     LET g_pageno = 0
     LET g_total1 = 0
     LET g_total2 = 0
 
#str FUN-740015 add
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740015 *** ##
 
    CALL cl_del_data(l_table)
 
# ------------------------------------------------------ CR (2) ------- ##
 
     FOREACH azp_cur INTO l_azp01,l_azp03
         IF STATUS THEN CALL cl_err('azp_cur',STATUS,0) EXIT FOREACH END IF
         LET g_sql = "SELECT '','','','',",
                     "       gem02,gen02,oab02,oea26,oea032,oca02,",
                     "       oea04,oea23,oea24,oeb14,oeb04,oea15,oea14,",
                     "       oea25,oea03,oca01,ima131,ima06,'',oeb12 ",
#TQC-950020   ---start  
                    #"  FROM ",l_azp03 CLIPPED,".oea_file,",
                    #          l_azp03 CLIPPED,".oeb_file,",
                    #          l_azp03 CLIPPED,".occ_file,",
                    #" OUTER ",l_azp03 CLIPPED,".ima_file,",
                    #" OUTER ",l_azp03 CLIPPED,".oca_file,",
                    #" OUTER ",l_azp03 CLIPPED,".gem_file,",
                    #" OUTER ",l_azp03 CLIPPED,".gen_file,",
                    #" OUTER ",l_azp03 CLIPPED,".oab_file ",
                 #FUN-A10098  ----start---
                 #   "  FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file,",  
                 #             s_dbstring(l_azp03 CLIPPED),"oeb_file,",    
                 #             s_dbstring(l_azp03 CLIPPED),"occ_file,",  
                 #   " OUTER ",s_dbstring(l_azp03 CLIPPED),"ima_file,",  
                 #   " OUTER ",s_dbstring(l_azp03 CLIPPED),"oca_file,", 
                 #   " OUTER ",s_dbstring(l_azp03 CLIPPED),"gem_file,",   
                 #   " OUTER ",s_dbstring(l_azp03 CLIPPED),"gen_file,",  
                 #   " OUTER ",s_dbstring(l_azp03 CLIPPED),"oab_file ",     
                     "  FROM ",cl_get_target_table(l_azp01,'oea_file'),",",
                               cl_get_target_table(l_azp01,'oeb_file'),",",
                               cl_get_target_table(l_azp01,'occ_file'),",",
                     " OUTER ",cl_get_target_table(l_azp01,'ima_file'),",",
                     " OUTER ",cl_get_target_table(l_azp01,'oca_file'),",",
                     " OUTER ",cl_get_target_table(l_azp01,'gem_file'),",",
                     " OUTER ",cl_get_target_table(l_azp01,'gen_file'),",",
                     " OUTER ",cl_get_target_table(l_azp01,'oab_file'),
                 #FUN-A10098  ---end---  
#TQC-950020   ---end   
                     " WHERE ",tm.wc2 CLIPPED,
                     "   AND oea02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "   AND oea01 = oeb01 ",
                     "   AND ima_file.ima01 = oeb_file.oeb04 ",
                     "   AND occ01 = oea03 ",
                     "   AND oca_file.oca01 = occ_file.occ03 ",
                     "   AND gem_file.gem01 = oea_file.oea15 ",
                     "   AND gen_file.gen01 = oea_file.oea14 ",
                     "   AND oab_file.oab01 = oea_file.oea25 "
      IF tm.w='Y' THEN
          LET g_sql = g_sql CLIPPED," AND oeaconf='Y' "
      ELSE
          LET g_sql = g_sql CLIPPED," AND oeaconf != 'X' " #01/08/16 mandy
      END IF
         CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql      #FUN-A10098 
         PREPARE r110_p1 FROM g_sql
         IF STATUS THEN CALL cl_err('prepare #1',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
            EXIT PROGRAM 
         END IF
         DECLARE r110_c1 CURSOR FOR r110_p1
         FOREACH r110_c1 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach #1',SQLCA.sqlcode,1)
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80059    ADD
                 EXIT PROGRAM
              END IF
              IF tm.ch='2' THEN       #本幣
                 LET sr.oeb14 = sr.oeb14 * sr.oea24
              END IF
              IF cl_null(sr.oeb14) THEN LET sr.oeb14=0 END IF
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
                           WHERE oab01=sr.oea26
                          IF STATUS THEN LET l_oab02='' END IF
                          LET l_order[g_i] = l_oab02
                          LET g_order=g_order CLIPPED,'  ',g_x[23] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[23] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oea032
                          LET g_order=g_order CLIPPED,'  ',g_x[24] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[24] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oca02
                          LET g_order=g_order CLIPPED,'  ',g_x[25] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[25] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '8'
                          SELECT occ02 INTO l_occ02 FROM occ_file
                           WHERE occ01=sr.oea04
                          IF STATUS THEN LET l_occ02='' END IF
                          LET l_order[g_i] = l_occ02
                          LET g_order=g_order CLIPPED,'  ',g_x[26] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[26] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.oea23
                          LET g_order=g_order CLIPPED,'  ',g_x[27] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[27] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'a' LET l_order[g_i] = sr.ima131
                          LET g_order=g_order CLIPPED,'  ',g_x[35] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[35] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'b' LET l_order[g_i] = sr.ima06
                          LET g_order=g_order CLIPPED,'  ',g_x[36] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[36] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'c' LET l_order[g_i] = sr.oeb04
                          LET g_order=g_order CLIPPED,'  ',g_x[37] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[37] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'd'
                          SELECT occ20 INTO l_occ20 FROM occ_file
                           WHERE occ01=sr.oea04
                          IF STATUS THEN LET l_occ20='' END IF
                          LET l_order[g_i] = l_occ20
                          LET g_order=g_order CLIPPED,'  ',g_x[38] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[38] CLIPPED   #No.FUN-580013
                     WHEN tm.s[g_i,g_i] = 'e'
                          SELECT occ21 INTO l_occ21 FROM occ_file
                           WHERE occ01=sr.oea04
                          IF STATUS THEN LET l_occ21='' END IF
                          LET l_order[g_i] = l_occ21
                          LET g_order=g_order CLIPPED,'  ',g_x[39] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[39] CLIPPED   #No.FUN-580013
#FUN-550091
                     WHEN tm.s[g_i,g_i] = 'f'
                          SELECT occ22 INTO l_occ22 FROM occ_file
                           WHERE occ01=sr.oea04
                          IF STATUS THEN LET l_occ22='' END IF
                          LET l_order[g_i] = l_occ22
                          LET g_order=g_order CLIPPED,'  ',g_x[40] CLIPPED
                          LET g_zaa[40+g_i].zaa08 = g_x[40] CLIPPED   #No.FUN-580013
#END FUN-550091
                    OTHERWISE LET l_order[g_i] = ''
                 END CASE
             END FOR
             LET sr.order1 = l_order[1]
             LET sr.order2 = l_order[2]
             LET sr.order3 = l_order[3]
             LET sr.l_oab02 = l_oab02   #FUN-740015 TSD.Achick
             LET sr.occ02 = l_occ02     #FUN-740015 TSD.Achick
             LET sr.occ20 = l_occ20     #FUN-740015 TSD.Achick
             LET sr.occ21 = l_occ21     #FUN-740015 TSD.Achick
             LET sr.occ22 = l_occ22     #FUN-740015 TSD.Achick
 
             CALL r110_m(sr.oea23) 
             LET sr.azi04 = l_azi04     #FUN-740015 TSD.Achick
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
         EXECUTE insert_prep USING 
         sr.order1,sr.order2,sr.order3,sr.order4,sr.gem02,
         sr.gen02, sr.oab02, sr.oea26, sr.oea032,sr.oca02,
         sr.oea04, sr.oea23, sr.oea24, sr.oeb14, sr.oeb04,
         sr.oea15, sr.oea14, sr.oea25, sr.oea03, sr.oca01,
         sr.ima131,sr.ima06, sr.azp01, sr.oeb12, sr.l_oab02,
         sr.occ02, sr.occ20, sr.occ21, sr.occ22, sr.azi04
       #------------------------------ CR (3) ------------------------------#
       #end FUN-740015 add 
             LET g_total1 = g_total1 + sr.oeb12      #數量
             LET g_total2 = g_total2 + sr.oeb14      #金額
         END FOREACH
     END FOREACH
 
   #str FUN-740015 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'azp01,oea15,oea14,oea25,oea26,
                          oea03,oca01,oea04,oea23,ima131,
                          ima06,oeb04,occ20,occ21,occ22')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str,";",tm.s,";",tm.t,";",tm.u,";",tm.ch,";",b_date,";",e_date
   CALL cl_prt_cs3('axsr110','axsr110',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-740015 add 
 
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
   #No.FUN-BB0047--mark--End-----
END FUNCTION
FUNCTION r110_m(p_code)
DEFINE p_code  LIKE oea_file.oea23
 
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
