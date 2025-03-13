# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr106.4gl
# Descriptions...: 科目部門餘額表
# Modify.........: No.FUN-510007 05/01/07 By Nicola 報表架構修改,增加列印部門名稱gem02
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增打印額外名稱欄位
# Modify.........: No.FUN-740020 07/04/06 By mike 會計科目加帳套
# Modify.........: No.TQC-6C0098 07/04/22 By Sarah QBE加一選項"是否列印內部管理科目"(aag38)
# Modify.........: No.MOD-740215 07/04/22 By Nicola 重新過單
# Modify.........: No.FUN-760083 07/07/26 By mike 報表格式修改為crystal reports
# Modify.........: No.MOD-8C0291 08/12/30 By Sarah g_tot值不可給NULL,因傳到CR後是分母的角色,若g_tot=NULL會出現公式錯誤的訊息
# Modify.........: No.MOD-920135 09/02/10 By chenl 調整月余額計算方式。
# Modify.........: No.MOD-930094 09/03/10 By shiwuying 修改GROUP BY
# Modify.........: No.FUN-940013 09/04/30 By jan aag01/aao02 欄位增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40133 10/05/07 By liuxqa modify sql
# Modify.........: No.MOD-AC0168 10/12/20 By Dido 取消期間起迄,改用單一期別選擇 
# Modify.........: No.FUN-B20054 11/02/22 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              wc       LIKE type_file.chr1000,                    #No.FUN-680098  VARCHAR(300)
             #yy,m1,m2 LIKE type_file.num10,                      #No.FUN-680098  integer   #MOD-AC0168 mark
              yy,mm    LIKE type_file.num10,                      #No.FUN-680098  integer   #MOD-AC0168 mod m2 -> mm
              f        LIKE type_file.num5,                       #No.FUN-680098  smallint
              e        LIKE type_file.chr1,    #列印額外名稱      #FUN-6C0012
              g        LIKE type_file.chr1,                       #No.FUN-680098  VARCHAR(1)
              aag38    LIKE aag_file.aag38                        #No.TQC-6C0098 add
           END RECORD,
     #  g_bookno  LIKE aba_file.aba00,     #帳別編號#No.FUN-740020  
       b         LIKE aba_file.aba00,     #帳別編號   #No.FUN-740020
       g_tot     LIKE aao_file.aao05
DEFINE g_aaa03   LIKE aaa_file.aaa03
DEFINE g_cnt     LIKE type_file.num10    #No.FUN-680098  integer
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_sql     STRING                  #No.FUN-760083
DEFINE g_str     STRING                  #No.FUN-760083 
DEFINE l_table   STRING                  #No.FUN-760083 
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
#No.FUN-760083   --begin--
   LET g_sql="order1.type_file.chr4,",
             "aag01.aag_file.aag01,",
             "aag02.aag_file.aag02,",
             "aag13.aag_file.aag13,",
             "aao02.aao_file.aao02,",
             "gem02.gem_file.gem02,",
             "dc.type_file.chr2,",
             "aao05.aao_file.aao05,"
   LET l_table=cl_prt_temptable("aglr106",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
  #LET g_sql="INSERT INTO ds_report.",l_table CLIPPED,  #TQC-A40133 mark
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,   #TQC-A40133 mod
             " VALUES(?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err("insert_prep:",status,1)
   END IF
#No.FUN-760083   --END--
   LET b=ARG_VAL(1)                   #No.FUN-740020
   LET g_pdate  = ARG_VAL(2)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.yy    = ARG_VAL(9)
  #LET tm.m1    = ARG_VAL(10)                   #MOD-AC0168 mark
   LET tm.mm    = ARG_VAL(10)                   #MOD-AC0168 mod 11 -> 10; m2 -> mm 
   LET tm.f     = ARG_VAL(11)                   #MOD-AC0168 mod 12 -> 11
   LET tm.g     = ARG_VAL(12)                   #MOD-AC0168 mod 13 -> 12
   LET tm.aag38 = ARG_VAL(13)   #TQC-6C0098 add #MOD-AC0168 mod 14 -> 13
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)                 #MOD-AC0168 mod 15 -> 14
   LET g_rep_clas = ARG_VAL(15)                 #MOD-AC0168 mod 16 -> 15
   LET g_template = ARG_VAL(16)                 #MOD-AC0168 mod 17 -> 16
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(17)   #FUN-6C0012        #MOD-AC0168 mod 18 -> 17
   LET g_rpt_name = ARG_VAL(18)  #No:FUN-7C0078 #MOD-AC0168 mod 19 -> 18
 
   #-->帳別若為空白則使用預設帳別
   IF b = ' ' OR b IS NULL THEN  #No.FUN-740020 
      LET b = g_aza.aza81            #No.FUN-740020 
   END IF
 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = b  #No.FUN-740020 
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF
 
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03     #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr106_tm()
   ELSE
      CALL aglr106()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr106_tm()
DEFINE lc_qbe_sn          LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col        LIKE type_file.num5,     #No.FUN-680098 smallint
       l_cmd              LIKE type_file.chr1000   #No.FUN-680098  VARCHAR(400)
DEFINE li_chk_bookno      LIKE type_file.num5      #FUN-B20054
 
   CALL s_dsmark(b)
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW aglr106_w AT p_row,p_col
     WITH FORM "agl/42f/aglr106"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,b)  #No.FUN-740020  
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.yy = YEAR(TODAY)
  #LET tm.m1 = 1                            #MOD-AC0168 mark
   LET tm.mm = MONTH(TODAY)                 #MOD-AC0168 m2 -> mm
   LET tm.f  = 0
   LET tm.g  = 'N'
   LET tm.aag38 = 'N'   #TQC-6C0098 add
   LET tm.e  = 'N'   #FUN-6C0012
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME b ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD b 
            IF NOT cl_null(b) THEN
                   CALL s_check_bookno(b,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD b 
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 =b 
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",b,"","agl-043","","",0)
                   NEXT FIELD b 
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      CONSTRUCT BY NAME tm.wc ON aag01,aao02,aag07
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#FUN-B20054--mark--str--
#         #FUN-940013--begin--add 
#         ON ACTION controlp
#           CASE
#              WHEN INFIELD(aag01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c" 
#                   LET g_qryparam.form = "q_aag" 
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aag01
#                   NEXT FIELD aag01
#              WHEN INFIELD(aao02)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c"
#                   LET g_qryparam.form = "q_gem"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aao02 
#                   NEXT FIELD aao02 
#              OTHERWISE EXIT CASE
#           END CASE 
#         #FUN-940013--end--add--
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
#FUN-B20054--mark--end
 
      END CONSTRUCT

##FUN-B20054--mark-str-- 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglr106_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--end
 
     #INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.f,b,tm.aag38,tm.e,tm.g WITHOUT DEFAULTS   #FUN-6C0012#No:FUN-740020    #TQC-6C0098 add aag38 #MOD-AC0168 mark
      INPUT BY NAME tm.yy,tm.mm,tm.f,
              #      b,      #No.FUN-B20054
                    tm.aag38,tm.e,tm.g 
              #      WITHOUT DEFAULTS  #FUN-B20054   #FUN-6C0012#No:FUN-740020    #TQC-6C0098 add aag38       #MOD-AC0168
                     ATTRIBUTE(WITHOUT DEFAULTS)
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      #FUN-B20054--mark-str--
      #   #No.FUN-740020  --begin--
      #   AFTER FIELD b
      #       IF b IS NULL THEN
      #          NEXT FIELD b
      #       END IF
      #    #No.FUN-740020  --end--
      #FUN-B20054--mark--end

         AFTER FIELD g
            IF cl_null(tm.g) or tm.g not matches '[YN]' THEN
               NEXT FIELD g
            END IF
 
            IF tm.g = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         #No.FUN-740020  --begin--
         #str TQC-6C0098 add
         AFTER FIELD aag38
            IF cl_null(tm.aag38) or tm.aag38 not matches '[YN]' THEN
               NEXT FIELD aag38
            END IF
         #end TQC-6C0098 add

#FUN-B20054--mark--str--
#         ON ACTION CONTROLP
#           CASE
#             WHEN INFIELD(b)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form='q_aaa'
#               LET g_qryparam.default1=b
#               CALL cl_create_qry() RETURNING b
#               DISPLAY BY NAME b
#               NEXT FIELD b
#           END CASE
#           #No.FUN-740020  --end--
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
#FUN-B20054--mark--end
 
      END INPUT

      #FUN-B20054--add--str-- 
       ON ACTION controlp
           CASE
              WHEN INFIELD(b)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form='q_aaa'
                   LET g_qryparam.default1=b
                   CALL cl_create_qry() RETURNING b
                   DISPLAY BY NAME b
                   NEXT FIELD b
              WHEN INFIELD(aag01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = " aag00 = '",b CLIPPED,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aag01
                   NEXT FIELD aag01
              WHEN INFIELD(aao02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_gem"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aao02
                   NEXT FIELD aao02
              OTHERWISE EXIT CASE
           END CASE
         #FUN-940013--end--add--
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT DIALOG
       
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---      
 
         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            EXIT DIALOG
     END DIALOG
    #FUN-B20054--add--end

    #FUN-B20054--add--str--
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglr106_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
   #FUN-B20054--add--end
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr106'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr106','9031',1)  
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",b CLIPPED,"'" ,   #No.FUN-740020 
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                       #" '",tm.m1 CLIPPED,"'",        #MOD-AC0168 mark
                        " '",tm.mm CLIPPED,"'",        #MOD-AC0168 mod m2 -> mm
                        " '",tm.f  CLIPPED,"'",
                        " '",tm.g CLIPPED,"'",
                        " '",tm.aag38 CLIPPED,"'",     #TQC-6C0098 add
                        " '",tm.e CLIPPED,"'",         #FUN-6C0012
                        " '",g_rep_user CLIPPED,"'",   #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",   #No.FUN-570264
                        " '",g_template CLIPPED,"'",   #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr106',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr106_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr106()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr106_w
 
END FUNCTION
 
FUNCTION aglr106()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name             #No.FUN-680098   VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,           # RDSQL STATEMENT        #No.FUN-680098  VARCHAR(1000)
          l_chr       LIKE type_file.chr1,              #No.FUN-680098    VARCHAR(1)       
          l_abb06     LIKE abb_file.abb06,
          l_abb07     LIKE abb_file.abb07,
          l_order     ARRAY[5] OF LIKE type_file.chr20,   #排列順序  #No.FUN-680098  VARCHAR(10) 
          l_i         LIKE type_file.num5,                           #No.FUN-680098  smallint
          sr          RECORD
                         order1    LIKE type_file.chr4,              #No.FUN-680098   VARCHAR(4)
                         aag01     LIKE aag_file.aag01,              #科目
                         aag02     LIKE aag_file.aag02,              #科目名稱
                         aag13     LIKE aag_file.aag13,              #額外名稱 #FUN-6C0012
                         aao02     LIKE aao_file.aao02,
                         gem02     LIKE gem_file.gem02,
                         dc        LIKE type_file.chr2,              #No.FUN-680098    VARCHAR(2)
                         aao05     LIKE aao_file.aao05
                      END RECORD
    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = b AND aaf02 = g_rlang  #No.FUN-740020 
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
  #LET l_sql = "SELECT '',aag01,aag02,aag13,aao02,'','',SUM(aao05-aao06)",  #FUN-6C0012  #No.MOD-920135 mark
   LET l_sql = "SELECT '',aag01,aag02,aag13,aao02,'','',0 ",  #FUN-6C0012                #No.MOD-920135  
               " FROM aag_file,aao_file",
               " WHERE aag03='2' AND ",tm.wc CLIPPED,
               "   AND aag01 = aao01",
               "   AND aag00 = '",b,"'", #No.FUN-740020 
               "   AND aao00 = '",b,"'", #若為空白使用預設帳別#No.FUN-740020  
               "   AND aao03 = ",tm.yy,
              #"   AND aao04 BETWEEN ",tm.m1," AND ",tm.m2   #MOD-AC0168 mark
               "   AND aao04 <= ",tm.mm                      #MOD-AC0168
   LET l_sql = l_sql CLIPPED," AND aag38 = '",tm.aag38,"'"   #TQC-6C0098 add
#  LET l_sql = l_sql," GROUP BY aag01,aag02,aag13,aao02"   #FUN-6C0012 #No.MOD-930094
   LET l_sql = l_sql CLIPPED," GROUP BY aag01,aag02,aag13,aao02"       #No.MOD-930094
 
   PREPARE aglr106_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr106_curs1 CURSOR FOR aglr106_prepare1
 
  #No.MOD-920135--begin--
   LET l_sql = " SELECT SUM(aao05-aao06) FROM aao_file ",
               "  WHERE aao00 = '",b,"'",
               "    AND aao03 = ",tm.yy,
               "    AND aao04 <= ",tm.mm,           #MOD-AC0168 mod m2 -> mm
               "    AND aao01 = ? AND aao02 = ? " 
   PREPARE aglr106_prepare2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE aglr106_curs2 CURSOR FOR aglr106_prepare2
  #No.MOD-920135---end---
 
#No.FUN-760083  --begin--
   #CALL cl_outnam('aglr106') RETURNING l_name               
 
   #No.FUN-6C0012 --start--                                                  
   #IF tm.e = 'Y' THEN                                                     
      #LET g_zaa[33].zaa06 = 'Y'                                              
   #ELSE                                                                  
      #LET g_zaa[39].zaa06 = 'Y'                                           
   #END IF                                                                      
                                                                                
   #CALL cl_prt_pos_len()                                                         
   #No.FUN-6C0012 --end--
 
   #START REPORT aglr106_rep TO l_name   
   LET g_str = ''                        
   CALL cl_del_data(l_table)             
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
   IF tm.e='Y' THEN 
      LET l_name='aglr106_1'
   ELSE 
      LET l_name='aglr106'
   END IF
 
   LET g_pageno = 0
   LET g_cnt    = 1
   LET g_tot    = 0
 
   FOREACH aglr106_curs1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
     #No.MOD-920135--begin--
      OPEN aglr106_curs2 USING sr.aag01,sr.aao02
      FETCH aglr106_curs2 INTO sr.aao05
      CLOSE aglr106_curs2
     #No.MOD-920135---end---
 
      IF sr.aao05 IS NULL OR sr.aao05 = 0 THEN
         CONTINUE FOREACH
      END IF
 
      IF sr.aao05 >= 0 THEN
         LET sr.dc = "D"
      ELSE
         LET sr.dc = "C"
      END IF
 
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.aao02
 
      LET l_i = tm.f
      IF l_i>=1 AND l_i<=4 THEN
         LET sr.order1 = sr.aag01[1,l_i]
      END IF
 
      LET g_tot = g_tot + sr.aao05
      EXECUTE insert_prep USING sr.order1,sr.aag01,sr.aag02,sr.aag13,     #No.FUN-760083 
                                sr.aao02,sr.gem02,sr.dc,sr.aao05          #No.FUN-760083 
 
      #OUTPUT TO REPORT aglr106_rep(sr.*)    #No.FUN-760083 
 
   END FOREACH
 
  #str MOD-8C0291 mark
  #IF g_tot = 0 THEN
  #   LET g_tot = NULL
  #END IF
  #end MOD-8C0291 mark
 
   #FINISH REPORT aglr106_rep                #No.FUN-760083 
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-760083 
#No.FUN-760083 --begin--
   IF g_zz05='Y' THEN 
      CALL cl_wcchp(tm.wc,'aag01,aao02,aag07')
      RETURNING tm.wc
   END IF
  #LET g_str=tm.wc,';',g_tot,';',tm.e,';',tm.yy,';',tm.m1,';',tm.m2,';',t_azi04,';',t_azi05,';',tm.f   #MOD-AC0168 mark 
   LET g_str=tm.wc,';',g_tot,';',tm.e,';',tm.yy,';',tm.mm,';',t_azi04,';',t_azi05,';',tm.f             #MOD-AC0168 mod m2 -> mm 
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED        
   CALL cl_prt_cs3("aglr106",l_name,g_sql,g_str)     
#No.FUN-760083 --end--
                   
END FUNCTION
#No.FUN-760083 --begin--
{
REPORT aglr106_rep(sr)
DEFINE l_last_sw                  LIKE type_file.chr1,              #No.FUN-680098   VARCHAR(1)
       l_amt1,l_amt2,l_amt_tot    LIKE  aao_file.aao05,
       l_per,l_peramt1,l_peramt2,l_pertot  LIKE type_file.num20_6,  #No.FUN-680098 decimal(20,6)
       sr            RECORD
                        order1    LIKE type_file.chr4,              #No.FUN-680098  VARCHAR(4)
                        aag01     LIKE aag_file.aag01,#科目
                        aag02     LIKE aag_file.aag02,#科目名稱
                        aag13     LIKE aag_file.aag13,#額外名稱  #FUN-6C0012
                        aao02     LIKE aao_file.aao02,
                        gem02     LIKE gem_file.gem02,
                        dc        LIKE type_file.chr2,              #No.FUN-680098  VARCHAR(2)
                        aao05     LIKE aao_file.aao05
                     END RECORD
   DEFINE g_head1    STRING              
   DEFINE l_dc       LIKE type_file.chr2                            #No.FUN-680098  VARCHAR(2) 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.aag01,sr.aao02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '&&&&',' ',
                       g_x[10] CLIPPED,tm.m1 USING '&&','-',tm.m2 USING '&&'
         #PRINT g_head1                                         #FUN-660060 remark
         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
         PRINT g_dash[1,g_len]
         #FUN-6C0012.....begin
         IF tm.e = 'N' THEN
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] 
         ELSE
            PRINT g_x[31],g_x[32],g_x[39],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
         END IF
         #FUN-6C0012
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         PRINT COLUMN g_c[31],sr.order1;
 
      BEFORE GROUP OF sr.aag01
         PRINT COLUMN g_c[32],sr.aag01;
         IF tm.e = 'N' THEN
            PRINT COLUMN g_c[33],sr.aag02;
         ELSE
            PRINT COLUMN g_c[39],sr.aag13;   #FUN-6C0012 
         END IF
 
      ON EVERY ROW
         LET l_per = (sr.aao05 / g_tot) * 100
         PRINT COLUMN g_c[34],sr.aao02,
               COLUMN g_c[35],sr.gem02,
               COLUMN g_c[36],cl_numfor(sr.aao05,36,t_azi04),  #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[37],sr.dc,
               COLUMN g_c[38],l_per USING '####&.&&'
 
      AFTER GROUP OF sr.aag01
         LET g_cnt = GROUP COUNT(*)
         IF g_cnt > 1 THEN
            LET l_amt1 = GROUP SUM(sr.aao05)
            LET l_peramt1 = (l_amt1/g_tot) * 100
            IF l_amt1 >= 0 THEN
               LET l_dc = 'D'
            ELSE
               LET l_dc = 'C'
            END IF
            PRINT ' '
            PRINT COLUMN g_c[35],g_x[11] CLIPPED,
                  COLUMN g_c[36],cl_numfor(l_amt1,36,t_azi05),  #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[37],l_dc,
                  COLUMN g_c[38],l_peramt1 USING '####&.&&'
         END IF
         PRINT
 
      AFTER GROUP OF sr.order1
         LET g_cnt = GROUP COUNT(*)
         IF tm.f > 0 AND g_cnt > 1 THEN
            LET l_amt2 = GROUP SUM(sr.aao05)
            LET l_peramt2 = (l_amt2 / g_tot) * 100
            IF l_amt2 >= 0 THEN
               LET l_dc = 'D'
            ELSE
               LET l_dc = 'C'
            END IF
            PRINT ' '
            PRINT COLUMN g_c[35],g_x[12] CLIPPED,
                  COLUMN g_c[36],cl_numfor(l_amt2,36,t_azi05),          #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[37],l_dc,
                  COLUMN g_c[38],l_peramt2 USING '####&.&&'
         END IF
         PRINT
 
      ON LAST ROW
         LET l_amt_tot = SUM(sr.aao05)
         LET l_pertot = (l_amt_tot / g_tot) * 100
         IF l_amt_tot >= 0 THEN
            LET l_dc = 'D'
         ELSE
            LET l_dc = 'C'
         END IF
         PRINT ' '
         PRINT COLUMN g_c[35],g_x[13] CLIPPED,
               COLUMN g_c[36],cl_numfor(l_amt_tot,36,t_azi05),             #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[37],l_dc,
               COLUMN g_c[38],l_pertot USING '####&.&&'
         LET l_last_sw = 'y'
 
      PAGE TRAILER
         PRINT g_dash[1,g_len]
         IF l_last_sw = 'n' THEN
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[6] CLIPPED   #FUN-6C0012
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #FUN-6C0012
         ELSE
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[38],g_x[7] CLIPPED   #FUN-6C0012
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #FUN-6C0012
         END IF
 
END REPORT
}
#No.FUN-760083 
#Patch....NO.TQC-610035 <001> #
#No.MOD-740215
