# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr520.4gl
# Descriptions...: 採購單交貨異常表
# Input parameter:
# Return code....:
# Date & Author..: 94/07/09 By DANNY
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 修改報表結束定位點
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-750093 07/06/07 By jan 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70005 10/07/01 By lixh1 加上營運中心欄位& 同一改為跨DB形式   
# Modify.........: No:MOD-B70037 11/07/06 By JoHung 排除已結案的採購項次
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-C40109 12/06/15 By Vampire 1.欄位控卡不可為負
#                                                    2.目前條件判斷都是用>(大於),才會LET l_repflag='Y',請調整為>=(大於等於) 
# Modify.........: No:TQC-CC0109 12/12/24 By qirl 欄位開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
             #wc       VARCHAR(500),               # Where condition   #TQC-630166 mark
              wc1      STRING,             
              wc       STRING,                  # Where condition   #TQC-630166
              s        LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)        # Order by sequence
              t        LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)        # Eject sw
              u        LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)        # Group total sw
              a        LIKE type_file.num5,     #No.FUN-680136 SMALLINT       #提前交貨日
              b        LIKE type_file.num5,     #No.FUN-680136 SMALLINT       #延遲交貨日
              c        LIKE oad_file.oad041,    #No.FUN-680136 DECIMAL(6,2)   #超交率
              d        LIKE oad_file.oad041,    #No.FUN-680136 DECIMAL(6,2)   #短交率
              more     LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD,
          l_cd         LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(60)       #排列順序
          l_i          LIKE type_file.num5      #No.FUN-680136 SMALLINT
   DEFINE g_i          LIKE type_file.num5      #count/index for any purpose  #No.FUN-680136 SMALLINT
   DEFINE l_table      STRING,                  #No.FUN-750093
          g_str        STRING,                  #No.FUN-750093
          g_sql        STRING                   #No.FUN-750093
   DEFINE g_chk_auth   STRING                   #FUN-A70005   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.d  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL apmr520_tm(0,0)        # Input print condition
      ELSE CALL apmr520()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr520_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
#FUN-A70005--Begin--
   DEFINE l_zxy03        LIKE zxy_file.zxy03
   DEFINE l_azp01        LIKE azp_file.azp01
   DEFINE l_sql,l_err    STRING
   DEFINE l_azp01_str    STRING
   DEFINE tok            base.StringTokenizer 
#FUN-A70005--End--   
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW apmr520_w AT p_row,p_col WITH FORM "apm/42f/apmr520"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '31'
   LET tm.a    = '0'
   LET tm.b    = '0'
   LET tm.c    = '0'
   LET tm.d    = '0'
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
#FUN-A70005 --begin--
   CONSTRUCT BY NAME tm.wc1 ON azp01
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
         AFTER FIELD azp01            
            LET l_azp01_str = get_fldbuf(azp01)  
            LET l_err='' 
            LET g_chk_auth = ''         
            IF NOT cl_null(l_azp01_str) AND l_azp01_str <> "*" THEN
               LET tok = base.StringTokenizer.create(l_azp01_str,"|")
               LET l_azp01 = ""
               WHILE tok.hasMoreTokens()
                  LET l_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy03 = l_azp01 AND zxy01 = g_user
                  IF STATUS THEN
                     CONTINUE WHILE
                  ELSE
                     IF g_chk_auth IS NULL THEN
                        LET g_chk_auth = "'",l_zxy03,"'"
                     ELSE
                        LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                     END IF    
                  END IF                  
               END WHILE
            ELSE
               DECLARE r520_zxy_cs  CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r520_zxy_cs  INTO l_zxy03
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
            END IF           
            IF g_chk_auth IS NOT NULL THEN
               LET g_chk_auth = "(",g_chk_auth,")"
            END IF                         
      ON ACTION CONTROLP 
        CASE
         WHEN INFIELD(azp01)            
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azw"
            LET g_qryparam.state = "c"
            LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO azp01
            NEXT FIELD azp01
     #--TQC-CC0109--add---star---
              WHEN INFIELD(pmm01)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm011"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm01
              NEXT FIELD pmm01
              WHEN INFIELD(pmm09)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm091"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm09
              NEXT FIELD pmm09
     #--TQC-CC0109--add---end---
        OTHERWISE EXIT CASE
        END CASE
      ON ACTION locale
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()  
 
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF       
 
   IF cl_null(tm.wc1) THEN
         LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
   END IF 
#FUN-A70005 --end--             
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm09,pmn04,pmn33
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
        CASE
         WHEN INFIELD(pmn04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pmn04
            NEXT FIELD pmn04
     #--TQC-CC0109--add---star---
              WHEN INFIELD(pmm01)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm011"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm01
              NEXT FIELD pmm01
              WHEN INFIELD(pmm09)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm091"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm09
              NEXT FIELD pmm09
     #--TQC-CC0109--add---end---
        OTHERWISE EXIT CASE
        END CASE
  
#No.FUN-570243 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
#   IF tm.wc = ' 1=1' THEN                        #FUN-A70005
#      CALL cl_err('','9046',0) CONTINUE WHILE    #FUN-A70005
#   END IF                                        #FUN-A70005
   IF cl_null(tm.wc) THEN
      LET tm.wc = " 1=1"
   END IF
   DISPLAY BY NAME tm.more         # Condition
#UI
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
       tm.a,tm.c,tm.b,tm.d,tm.more
       WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a  END IF
         IF tm.a < 0 THEN CALL cl_err('','mfg5034',0) NEXT FIELD a  END IF #MOD-C40109 add
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b  END IF
         IF tm.b < 0 THEN CALL cl_err('','mfg5034',0) NEXT FIELD b  END IF #MOD-C40109 add
      AFTER FIELD c
         IF tm.c > 100  AND cl_null(tm.c) THEN NEXT FIELD c  END IF
         IF tm.c < 0 THEN CALL cl_err('','mfg5034',0) NEXT FIELD c  END IF #MOD-C40109 add
      AFTER FIELD d
         IF tm.d > 100  AND cl_null(tm.d) THEN NEXT FIELD d  END IF
         IF tm.d < 0 THEN CALL cl_err('','mfg5034',0) NEXT FIELD d  END IF #MOD-C40109 add
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(tm.a) THEN NEXT FIELD a  END IF
         IF cl_null(tm.b) THEN NEXT FIELD b  END IF
         IF tm.c > 100  AND cl_null(tm.c) THEN NEXT FIELD c  END IF
         IF tm.d > 100  AND cl_null(tm.d) THEN NEXT FIELD d  END IF
      #UI
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW apmr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr520'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr520','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr520',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr520()
   ERROR ""
END WHILE
   CLOSE WINDOW apmr520_w
END FUNCTION
 
FUNCTION apmr520()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_repflag LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_order    ARRAY[5] OF LIKE aaf_file.aaf03,             #No.FUN-680136 VARCHAR(40)
          sr               RECORD order1 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  order2 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  order3 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  azp01 LIKE azp_file.azp01,      #FUN-A70005
                                  pmm01 LIKE pmm_file.pmm01,
                                  pmm04 LIKE pmm_file.pmm04,
                                  pmm09 LIKE pmm_file.pmm09,
                                  pmc03 LIKE pmc_file.pmc03,
                                  pmn04 LIKE pmn_file.pmn04,
                                  pmn041 LIKE pmn_file.pmn041,#FUN-4C0095
                                  ima021 LIKE ima_file.ima021, #No.FUN-750093
                                  pmn20 LIKE pmn_file.pmn20,
                                  pmn50 LIKE pmn_file.pmn50,
                                  pmn33 LIKE pmn_file.pmn33,
                                  rva06 LIKE rva_file.rva06,
                                  pmn02 LIKE pmn_file.pmn02,
                                  l_a   LIKE type_file.num5,      #No.FUN-680136 SMALLINT
                                  l_b   LIKE type_file.num5,      #No.FUN-680136 SMALLINT
                                  l_c   LIKE oad_file.oad041,     #No.FUN-680136 DECIMAL(6,2) 
                                  l_d   LIKE oad_file.oad041      #No.FUN-680136 DECIMAL(6,2)
                                  
                                  
                        END RECORD
   DEFINE l_plant   LIKE  azp_file.azp01          #FUN-A70005
   DEFINE l_azp02   LIKE  azp_file.azp02          #FUN-A70005               
 
# No.FUN-750093--Begin
     LET g_sql = " azw01.azw_file.azw01,",         #FUN-A70005
                 " pmm01.pmm_file.pmm01,",
                 " pmm04.pmm_file.pmm04,",
                 " pmm09.pmm_file.pmm09,",
                 " pmc03.pmc_file.pmc03,",
                 " pmn04.pmn_file.pmn04,",
                 " pmn041.pmn_file.pmn041,",
                 " ima021.ima_file.ima021,",
                 " pmn20.pmn_file.pmn20,",
                 " pmn50.pmn_file.pmn50,",
                 " pmn33.pmn_file.pmn33,",
                 " rva06.rva_file.rva06,", 
                 " l_cd.type_file.chr1000,",
                 " l_a.type_file.num5,",
                 " l_b.type_file.num5,",
                 " l_c.oad_file.oad041,",
                 " l_d.oad_file.oad041" 
 
     LET l_table = cl_prt_temptable('apmr520',g_sql) CLIPPED
     IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"       #FUN-A70005
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-750093--End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
#FUN-A70005 --begin--
   LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
               " WHERE azp01 IN ",g_chk_auth ,     
               "   AND azw01 = azp01  ",
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 

   FOREACH sel_azp01_cs INTO l_plant,l_azp02                                 ##--最外围的FOREACH--

      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
#FUN-A70005 --end--     
 
#No.FUN-750093--Begin
#    LET l_sql = "SELECT '','','',",
#                "  pmm01,pmm04,pmm09,pmc03,pmn04,pmn041,pmn20,pmn50,", #FUN-4C0095 add pmn041
#                "  pmn33,' ',pmn02,0,0,0,0 ",
#                "  FROM pmm_file,pmn_file,OUTER pmc_file ",
#                " WHERE pmm01=pmn01 AND pmm09=pmc_file.pmc01 AND pmm18 <> 'X' ",
#                "  AND ", tm.wc
    LET l_sql = "SELECT '','','',",                                            
                 "  azp01,pmm01,pmm04,pmm09,pmc03,pmn04,pmn041,ima021,pmn20,pmn50,", #FUN-4C0095 add pmn041   #FUN-A70005  add azw01
                 "  pmn33,' ',pmn02,0,0,0,0 ",                                  
#            "  FROM pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc01,",         #FUN-A70005
            "  FROM ",cl_get_target_table(l_plant,'pmm_file'),                   #FUN-A70005
            "  LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmc_file'),        #FUN-A70005   
            "  ON pmm09 = pmc01 ",",",                                              #FUN-A70005
#	         "  azw_file,pmn_file LEFT OUTER JOIN ima_file ON ima01=pmn04 ",     #FUN-A70005
            cl_get_target_table(l_plant,'azp_file'),"," ,                        #FUN-A70005
            cl_get_target_table(l_plant,'pmn_file'),                             #FUN-A70005
            " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ima_file'),         #FUN-A70005
            " ON ima01 = pmn04 ",                                                #FUN-A70005
            " WHERE pmm01=pmn01 AND pmm18 <> 'X' ",
            "  AND  pmmplant=azp01 ",               #FUN-A70005
            "  AND  pmmplant='",l_plant,"'",        #FUN-A70005      
            "  AND  pmn16 <> '6' AND pmn16 <> '7' AND pmn16 <> '8' ",            #MOD-B70037 add
            "  AND ", tm.wc
#No.FUN-750093--End
     PREPARE apmr520_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE apmr520_curs1 CURSOR FOR apmr520_p1
 
 #    LET l_sql="SELECT MAX(rva06) FROM rva_file,rvb_file ",            #FUN-A70005
     LET l_sql="SELECT MAX(rva06) ",                                    #FUN-A70005 
               "  FROM ",cl_get_target_table(l_plant,'rva_file'),"," ,  #FUN-A70005
                         cl_get_target_table(l_plant,'rvb_file'),       #FUN-A70005
               " WHERE rva01=rvb01 AND rvb04=? AND rvb03=? AND rvaconf !='X' "
 
     PREPARE apmr520_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE apmr520_curs2 scroll CURSOR FOR apmr520_p2
 
#    CALL cl_outnam('apmr520') RETURNING l_name        #No.FUN-750093
#    START REPORT apmr520_rep TO l_name                #No.FUN-750093
 
     LET g_pageno = 0
     FOREACH apmr520_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
#    SELECT MAX(rva06) FROM rva_file,rvb_file
#           WHERE rva01=rvb01 AND rvb04=sr.pmm01 AND rvb03=sr.pmn02
      OPEN apmr520_curs2 USING sr.pmm01,sr.pmn02
      FETCH first apmr520_curs2 INTO sr.rva06
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('fetch:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
#No.FUN-750093--Begin
#       LET l_cd = g_x[22]
#       LET l_i=0
#       FOR g_i=1 TO 3
#           IF NOT cl_null(tm.s[g_i,g_i]) THEN
#              LET l_i = l_i +1
#           END IF
#       END FOR
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmm01
#                    LET l_cd = l_cd CLIPPED,g_x[23] CLIPPED
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmm04 USING 'YYYYMMDD'
#                    LET l_cd = l_cd CLIPPED,g_x[24] CLIPPED
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmm09
#                    LET l_cd = l_cd CLIPPED,g_x[25] CLIPPED
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pmn04
#                    LET l_cd = l_cd CLIPPED,g_x[26] CLIPPED
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pmn33 USING 'YYYYMMDD'
#                    LET l_cd = l_cd CLIPPED,g_x[27] CLIPPED
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#          CASE
#            WHEN l_i=2
#              IF  g_i =1  THEN
#                  LET l_cd = l_cd CLIPPED,'+'
#              END IF
#           WHEN l_i=3
#             IF g_i != 3  THEN
#              LET l_cd = l_cd CLIPPED,'+'
#             END IF
#         END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#No.FUN-750093--End
   LET l_repflag='N'
#----------------------------------------- 提前/延遲
   IF cl_null(sr.rva06) THEN
      #IF g_today-sr.pmn33 > tm.b THEN #MOD-C40109 mark
      IF g_today-sr.pmn33 >= tm.b THEN #MOD-C40109 add
         LET l_repflag='Y'
         LET sr.l_b=g_today-sr.pmn33
      END IF
   ELSE
         #IF sr.pmn33-sr.rva06 > tm.a THEN #MOD-C40109 mark
         IF sr.pmn33-sr.rva06 >= tm.a THEN #MOD-C40109 add
            LET l_repflag='Y'
            LET sr.l_a=sr.pmn33-sr.rva06
         END IF
        #IF sr.rva06-sr.pmn33 > tm.b THEN #MOD-C40109 mark
        IF sr.rva06-sr.pmn33 >= tm.b THEN #MOD-C40109 add
           LET l_repflag='Y'
           LET sr.l_b=sr.rva06-sr.pmn33
        END IF
   END IF
#----------------------------------------- 超交/短交
     IF sr.pmn20 != 0 THEN
         #IF (sr.pmn50-sr.pmn20)/sr.pmn20*100 > tm.c THEN #MOD-C40109 mark
         IF (sr.pmn50-sr.pmn20)/sr.pmn20*100 >= tm.c THEN #MOD-C40109 add
            LET l_repflag='Y'
            LET sr.l_c=(sr.pmn50-sr.pmn20)/sr.pmn20*100
         END IF
         #IF (sr.pmn20-sr.pmn50)/sr.pmn20*100 > tm.d THEN #MOD-C40109 mark
         IF (sr.pmn20-sr.pmn50)/sr.pmn20*100 >= tm.d THEN #MOD-C40109 add
            LET l_repflag='Y'
            LET sr.l_d=(sr.pmn20-sr.pmn50)/sr.pmn20*100
         END IF
     END IF
     IF l_repflag='Y' THEN
#No.FUN-750093--Begin
#       OUTPUT TO REPORT apmr520_rep(sr.*)
        EXECUTE insert_prep USING
                sr.azp01,sr.pmm01,sr.pmm04,sr.pmm09,sr.pmc03,sr.pmn04,sr.pmn041,sr.ima021,      #FUN-A70005
                sr.pmn20,sr.pmn50,sr.pmn33,sr.rva06,l_cd,sr.l_a,sr.l_b,sr.l_c,sr.l_d
     END IF
     END FOREACH
  END FOREACH     
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
        LET tm.wc = tm.wc1," AND ",tm.wc                                #FUN-A70005
        CALL cl_wcchp(tm.wc,'azp01,pmm01,pmm04,pmm09,pmn04,pmn33')      #FUN-A70005               
              RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u
     CALL cl_prt_cs3('apmr520','apmr520',l_sql,g_str)
#    FINISH REPORT apmr520_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--End
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT apmr520_rep(sr)
   DEFINE l_ima021     LIKE ima_file.ima021  #FUN-4C0095
   DEFINE l_last_sw    LIKE type_file.chr1   #No.FUN-680136 VARCHAR(1)
   DEFINE l_printa     LIKE aab_file.aab02   #No.FUN-680136 VARCHAR(6)
   DEFINE l_printb     LIKE aab_file.aab02   #No.FUN-680136 VARCHAR(6)
   DEFINE l_printc     LIKE aab_file.aab02   #No.FUN-680136 VARCHAR(6)
   DEFINE l_printd     LIKE aab_file.aab02   #No.FUN-680136 VARCHAR(6)
   DEFINE sr               RECORD order1 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  order2 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  order3 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40)
                                  pmm01 LIKE pmm_file.pmm01,
                                  pmm04 LIKE pmm_file.pmm04,
                                  pmm09 LIKE pmm_file.pmm09,
                                  pmc03 LIKE pmc_file.pmc03,
                                  pmn04 LIKE pmn_file.pmn04,
                                  pmn041 LIKE pmn_file.pmn041,#FUN-4C0095
                                  pmn20 LIKE pmn_file.pmn20,
                                  pmn50 LIKE pmn_file.pmn50,
                                  pmn33 LIKE pmn_file.pmn33,
                                  rva06 LIKE rva_file.rva06,
                                  pmn02 LIKE pmn_file.pmn02,
                                  l_a   LIKE type_file.num5,      #No.FUN-680136 SMALLINT
                                  l_b   LIKE type_file.num5,      #No.FUN-680136 SMALLINT
                                  l_c   LIKE oad_file.oad041,     #No.FUN-680136 DECIMAL(6,2)
                                  l_d   LIKE oad_file.oad041      #No.FUN-680136 DECIMAL(6,2)
                        END RECORD,
      l_chr             LIKE type_file.chr1                       #No.FUN-680136 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.pmm01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT l_cd
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      SELECT ima021
        INTO l_ima021
        FROM ima_file
       WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
      IF sr.l_a != 0  THEN
          LET l_printa = sr.l_a USING "####",g_x[29] CLIPPED
      ELSE
          LET l_printa = NULL
      END IF
      IF sr.l_b != 0  THEN
          LET l_printb = sr.l_b USING "####",g_x[29] CLIPPED
      ELSE
          LET l_printb = NULL
      END IF
      IF sr.l_c != 0  THEN
          LET l_printc = sr.l_c USING "###.##"
      ELSE
          LET l_printc = NULL
      END IF
      IF sr.l_d != 0  THEN
          LET l_printd = sr.l_d USING "###.##"
      ELSE
          LET l_printd = NULL
      END IF
      PRINT COLUMN g_c[31],sr.pmm01,
            COLUMN g_c[32],sr.pmm04,
            COLUMN g_c[33],sr.pmm09,
            COLUMN g_c[34],sr.pmc03,
            COLUMN g_c[35],sr.pmn04,
            COLUMN g_c[36],sr.pmn041,
            COLUMN g_c[37],l_ima021,
            COLUMN g_c[38],cl_numfor(sr.pmn20,38,3),
            COLUMN g_c[39],cl_numfor(sr.pmn50,39,3),
            COLUMN g_c[40],sr.pmn33,
            COLUMN g_c[41],sr.rva06,
            COLUMN g_c[42],l_printa,
            COLUMN g_c[43],l_printb,
            COLUMN g_c[44],l_printc,
            COLUMN g_c[45],l_printd
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         PRINT g_dash1
         PRINT COLUMN g_c[37],g_x[21] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.pmn20),38,3),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pmn50),39,3)
         PRINT g_dash
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         PRINT g_dash1
         PRINT COLUMN g_c[37],g_x[21] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.pmn20),38,3),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pmn50),39,3)
         PRINT g_dash
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         PRINT g_dash1
         PRINT COLUMN g_c[37],g_x[21] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.pmn20),38,3),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pmn50),39,3)
         PRINT g_dash
      END IF
 
   ON LAST ROW
         PRINT COLUMN g_c[37],g_x[28] CLIPPED,
               COLUMN g_c[38],cl_numfor(SUM(sr.pmn20),38,3),
               COLUMN g_c[39],cl_numfor(SUM(sr.pmn50),39,3)
      IF g_zz05 = 'Y' THEN   # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09,pmn04,pmn33')
              RETURNING tm.wc
         PRINT g_dash
        #TQC-630166
        #    IF tm.wc[001,120] > ' ' THEN            # for 132
        #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #    IF tm.wc[121,240] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #   IF tm.wc[241,300] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[45], g_x[7] CLIPPED  #TQC-5B0037 mark
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0037 add
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[45], g_x[6] CLIPPED  #TQC-5B0037 mark
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0037 add
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093--End
#F
