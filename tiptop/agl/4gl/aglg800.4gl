# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglr800.4gl
# Descriptions...: 科目異動碼試算表
# Input parameter:
# Return code....:
# Date & Author..: 92/03/01 By Nora
#                  By Melody    aee00 改為 no-use
# Modify.........: No.MOD-4A0338 04/10/28 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗,per配合調整
# Modify.........: No.FUN-510007 05/01/11 By Nicola 報表架構修改
# Modify.........: No: FUN-5C0015 06/01/05 By kevin
#                  畫面QBE加aee021異動碼類型代號，^p q_ahe。
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie  調整“接下頁/結束”位置
# Modify.........: No.FUN-6C0012 06/12/27 By Judy 新增列印額外名稱功能
# Modify.........: No.MOD-720040 07/02/07 BY TSD.hoho 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-760131 07/06/14 By Sarah 在繁體\英文環境程式執行後會掛掉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B20026 11/02/11 By Dido 增加帳別條件 
# Modify.........: No.FUN-B20054 11/02/24 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: NO.FUN-B90028 11/09/09 By qirl明細CR報表轉GR 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                        # Print condition RECORD
              wc    LIKE type_file.chr1000,#科目&異動碼範圍   #No.FUN-680098 VARCHAR(400)
              yy    LIKE aed_file.aed03,  #輸入年度    
              bm    LIKE aed_file.aed04,  #起始期別
              em    LIKE aed_file.aed04,  #截止期別
              aed00 LIKE aed_file.aed00,  #帳別
              d     LIKE type_file.num5,  #小數位數   #No.FUN-680098 smallint
              e     LIKE type_file.chr1,  #異動額及餘額為0者是否列印   #No.FUN-680098  VARCHAR(1) 
              f     LIKE type_file.chr1,  #列印額外名稱 #FUN-6C0012
               more LIKE type_file.chr1   #Input more condition(Y/N)   #No.FUN-680098 VARCHAR(1)
           END RECORD,
       g_bookno  LIKE aed_file.aed00  #帳別
DEFINE g_aaa03   LIKE aaa_file.aaa03
DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
 
DEFINE l_table   STRING   #Add MOD-720040 By TSD.hoho CR11 add
DEFINE g_sql     STRING   #Add MOD-720040 By TSD.hoho CR11 add
DEFINE g_str     STRING   #Add MOD-720040 By TSD.hoho CR11 add
 
 
###GENGRE###START
TYPE sr1_t RECORD
    aee01 LIKE aee_file.aee01,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    aee02 LIKE aee_file.aee02,
    aee03 LIKE aee_file.aee03,
    bdr LIKE aed_file.aed05,
    bcr LIKE aed_file.aed05,
    dr LIKE aed_file.aed05,
    cr LIKE aed_file.aed05,
    edr LIKE aed_file.aed05,
    ecr LIKE aed_file.aed05
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
 
   #----------------Add MOD-720040 By TSD.hoho CR11 add----------------(S)
   # CREATE TEMP TABLE
   LET g_sql = " aee01.aee_file.aee01,",
               " aag02.aag_file.aag02,",
               " aag13.aag_file.aag13,",
               " aee02.aee_file.aee02,",
               " aee03.aee_file.aee03,",
               " bdr.aed_file.aed05,",
               " bcr.aed_file.aed05,",
               " dr.aed_file.aed05,",
               " cr.aed_file.aed05,",
               " edr.aed_file.aed05,",
               " ecr.aed_file.aed05"
   LET l_table = cl_prt_temptable('aglr800',g_sql) CLIPPED  #產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF
   #----------------Add MOD-720040 By TSD.hoho CR11 add----------------(E)
 
   LET g_bookno= ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom= ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway= ARG_VAL(6)
   LET g_copies= ARG_VAL(7)
   LET tm.wc   = ARG_VAL(8)
   LET tm.yy   = ARG_VAL(9)
   LET tm.bm   = ARG_VAL(10)
   LET tm.em   = ARG_VAL(11)
   LET tm.aed00 = ARG_VAL(12)   #TQC-610056
   LET tm.d    = ARG_VAL(13)
   LET tm.e    = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   #No.FUN-570264 ---end---
   LET tm.f    = ARG_VAL(18)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aaz.aaz64
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglr800_tm()
   ELSE
      CALL aglr800()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
END MAIN
 
FUNCTION aglr800_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col     LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_sw         LIKE type_file.chr1,          #重要欄位是否空白 #No.FUN-680098 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000        #No.FUN-680098    VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5         #No.FUN-670005    #No.FUN-680098 smallint
   CALL s_dsmark(g_bookno)
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW aglr800_w AT p_row,p_col
     WITH FORM "agl/42f/aglr800"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   SELECT azi04,azi05 INTO g_azi04,tm.d FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   LET tm.aed00= g_bookno
   LET tm.more = 'N'
   LET tm.d = '1'
   LET tm.e = 'N'
   LET tm.f = 'N' #FUN-6C0012
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_sw = 1
 
   WHILE TRUE
    #FUN-B20054--add--str--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.aed00 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD aed00
            IF NOT cl_null(tm.aed00) THEN
                   CALL s_check_bookno(tm.aed00,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD aed00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.aed00
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.aed00,"","agl-043","","",0)
                   NEXT FIELD aed00
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      #  FUN-5C0015 mod (s)
      #  add aee021
      #CONSTRUCT BY NAME tm.wc ON aee01,aee02,aee03
      CONSTRUCT BY NAME tm.wc ON aee01,aee02,aee03,aee021
      #  FUN-5C0015 mod (e)
 
         # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#FUN-B20054--mark--str--
#         ON ACTION controlp
#            CASE
#              WHEN INFIELD(aee021) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aee021
#                NEXT FIELD aee021
#              OTHERWISE EXIT CASE
#            END CASE
#         # FUN-5C0015 (e)
# 
#         ON ACTION locale
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#        ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
      END CONSTRUCT
#FUN-B20054--mark--str-- 
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW aglr800_w
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
#FUN-B20054--mark--end
 
     # INPUT BY NAME tm.yy,tm.aed00,tm.bm,tm.em,tm.d,tm.e,tm.f,tm.more WITHOUT DEFAULTS   #FUN-6C0012 FUN-B20054
       INPUT BY NAME tm.yy,tm.bm,tm.em,tm.d,tm.e,tm.f,tm.more
                     ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
                     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD bm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.bm IS NULL THEN
               NEXT FIELD bm
            END IF
 
#No.TQC-720032 -- begin --
#            IF tm.bm <1 OR tm.bm > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD bm
#            END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF tm.em IS NULL THEN
               NEXT FIELD em
            END IF
 
#No.TQC-720032 -- begin --
#            IF tm.em <1 OR tm.em > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD em
#            END IF
#No.TQC-720032 -- end --
 
            IF tm.bm > tm.em THEN
               CALL cl_err('',9011,0)
               NEXT FIELD bm
            END IF
    #FUN-B20054--mark-str--
    #     AFTER FIELD aed00
    #        IF tm.aed00 IS NULL THEN
    #           NEXT FIELD aed00
    #        END IF
    #        #No.FUN-670005--begin
    #         CALL s_check_bookno(tm.aed00,g_user,g_plant) 
    #              RETURNING li_chk_bookno
    #         IF (NOT li_chk_bookno) THEN
    #              NEXT FIELD aed00 
    #         END IF 
    #        #No.FUN-670005--end  
    #        SELECT aaa02 FROM aaa_file
    #         WHERE aaa01 = tm.aed00
    #           AND aaaacti IN ('Y','y')
    #        IF STATUS THEN
    #        #   CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660123
    #           CALL cl_err3("sel","aaa_file",tm.aed00,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
    #           NEXT FIELD aed00
    #        END IF
    #FUN-B20054--mark--end 
         AFTER FIELD d
            IF tm.d IS NULL OR tm.d < 0  THEN
               LET tm.d = 0
               DISPLAY BY NAME tm.d
               NEXT FIELD d
            END IF
 
         AFTER FIELD e
            IF tm.e IS NULL OR tm.e NOT MATCHES "[YN]" THEN
               NEXT FIELD e
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
         #FUN-B20054--mark-str--
         #  IF INT_FLAG THEN
         #      EXIT INPUT
         #   END IF
         #FUN-B20054--mark--end
         
            IF tm.yy IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.yy
            END IF
 
            IF tm.bm IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.bm
            END IF
 
            IF tm.em IS NULL THEN
               LET l_sw = 0
               DISPLAY BY NAME tm.em
            END IF
 
            IF l_sw = 0 THEN
               LET l_sw = 1
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
#FUN-B20054--mark--str-- 
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
# 
#         ON ACTION CONTROLP
#             #No.MOD-4C0156 add
#            IF INFIELD(aed00) THEN
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_aaa'
#               LET g_qryparam.default1 = tm.aed00
#               CALL cl_create_qry() RETURNING tm.aed00
#               DISPLAY BY NAME tm.aed00
#               NEXT FIELD aed00
#            END IF
#             #No.MOD-4C0156 end
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
              WHEN INFIELD(aed00) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_aaa'
                 LET g_qryparam.default1 = tm.aed00
                 CALL cl_create_qry() RETURNING tm.aed00
                 DISPLAY BY NAME tm.aed00
                 NEXT FIELD aed00
              WHEN INFIELD(aee01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " aag00 = '",tm.aed00 CLIPPED,"'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aee01
                 NEXT FIELD aee01
              WHEN INFIELD(aee021) #異動碼類型代號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_ahe"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aee021
                NEXT FIELD aee021
              OTHERWISE EXIT CASE
            END CASE
         # FUN-5C0015 (e)
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

         ON ACTION accept
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=1
            EXIT DIALOG
    END DIALOG
  
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW aglr800_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
       EXIT PROGRAM
    END IF
   #FUN-B20054--add--end
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr800'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr800','9031',1)  
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                        " '",tm.aed00 CLIPPED,"'",   #TQC-610056
                        " '",tm.d CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.f CLIPPED,"'",   #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr800',g_time,l_cmd)      # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aglr800_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aglr800()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aglr800_w
 
END FUNCTION
 
FUNCTION aglr800()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       LIKE type_file.chr1000,           # RDSQL STATEMENT                 #No.FUN-680098 VARCHAR(1000)
          l_chr       LIKE type_file.chr1,              #No.FUN-680098   VARCHAR(1)
          sr          RECORD
                         aee01     LIKE aee_file.aee01,#
                         aag02     LIKE aag_file.aag02,#
                         aag13     LIKE aag_file.aag13,#FUN-6C0012
                         aee02     LIKE aee_file.aee02,#
                         aee03     LIKE aee_file.aee03,#
                         bdr       LIKE aed_file.aed05,#期初借方金額
                         bcr       LIKE aed_file.aed05,#期初貸方金額
                         dr        LIKE aed_file.aed05,#本期借方金額
                         cr        LIKE aed_file.aed05,#本期貸方金額
                         edr       LIKE aed_file.aed05,#期末借方金額
                         ecr       LIKE aed_file.aed05 #期末貸方金額
                      END RECORD
 
   #----------------Add MOD-720040 By TSD.hoho CR11 add----------------------(S)
   ### *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #----------------Add MOD-720040 By TSD.hoho CR11 add----------------------(E)
 
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_rlang
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aeeuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aeegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aeegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aeeuser', 'aeegrup')
   #End:FUN-980030
 
   LET l_sql = " SELECT aee01,aag02,aag13,aee02,aee03,0,0,0,0,0,0",  #FUN-6C0012
               "   FROM aee_file LEFT OUTER JOIN aag_file ON aee01=aag01 AND aee00=aag00 ", #MOD-B20026 add aag00
               "  WHERE 1=1 AND ",tm.wc CLIPPED,
               "    AND aee00 = '",tm.aed00,"'"  #MOD-B20026
 
   PREPARE aglr800_prepare1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table)           #FUN-B90028
      EXIT PROGRAM
   END IF
   DECLARE aglr800_curs1 CURSOR FOR aglr800_prepare1
 
  #str TQC-760131 mark
  #CALL cl_outnam('aglr800') RETURNING l_name
  #START REPORT aglr800_rep TO l_name
  #LET g_pageno = 0
  #end TQC-760131 mark
 
   FOREACH aglr800_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT SUM(aed05-aed06) INTO sr.bdr
        FROM aed_file
       WHERE aed01 = sr.aee01
         AND aed011= sr.aee02
         AND aed02 = sr.aee03
         AND aed03 = tm.yy
         AND aed04 < tm.bm
         AND aed00 = tm.aed00     #No.7277
 
      SELECT SUM(aed05),SUM(aed06) INTO sr.dr,sr.cr
        FROM aed_file
       WHERE aed01 = sr.aee01
         AND aed011= sr.aee02
         AND aed02 = sr.aee03
         AND aed03 = tm.yy
         AND aed04 BETWEEN tm.bm AND tm.em
         AND aed00 = tm.aed00     #No.7277
 
      IF sr.bdr IS NULL THEN LET sr.bdr = 0 END IF
      IF sr.bcr IS NULL THEN LET sr.bcr = 0 END IF           #No.7815
 
      IF sr.bdr < 0 THEN
         LET sr.bcr = sr.bdr
         LET sr.bdr = 0
      END IF
 
      IF sr.bcr < 0 THEN LET sr.bcr = sr.bcr * -1 END IF     #No.7815
      IF sr.dr IS NULL THEN LET sr.dr = 0 END IF
      IF sr.cr IS NULL THEN LET sr.cr = 0 END IF
      LET sr.edr = sr.bdr - sr.bcr + sr.dr - sr.cr
 
      IF sr.edr < 0 THEN
         LET sr.ecr = sr.edr
         LET sr.edr = 0
      END IF
 
      IF sr.ecr < 0 THEN LET sr.ecr = sr.ecr * -1 END IF     #No.7815
 
      IF sr.bdr=0 AND sr.bcr=0 AND sr.dr=0 AND sr.cr=0 THEN
         CONTINUE FOREACH
      END IF
 
      #Add MOD-720040 By TSD.hoho CR11---------------------------------------(S)
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
              sr.aee01,sr.aag02,sr.aag13,sr.aee02,sr.aee03,
              sr.bdr,sr.bcr,sr.dr,sr.cr,sr.edr,sr.ecr
      #Add MOD-720040 By TSD.hoho CR11---------------------------------------(E)
   END FOREACH
 
   #Modify MOD-720040 By TSD.hoho CR11---------------------------------------(S)
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aee01,aee02,aee03,aee021')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = " "
   END IF
   #            p1    ;   p2    ;    p3   ;    p4   ;  p5    ;  p6
###GENGRE###   LET g_str = g_str,";",tm.yy,";",tm.bm,";",tm.em,";",tm.d,";",tm.f
###GENGRE###   CALL cl_prt_cs3('aglr800','aglr800',l_sql,g_str)   #FUN-710080 modify
    CALL aglg800_grdata()    ###GENGRE###
   #Modify MOD-720040 By TSD.hoho CR11---------------------------------------(E)
 
END FUNCTION
 
#str TQC-760131 mark
#REPORT aglr800_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)
#          sr           RECORD
#                           aee01     LIKE aee_file.aee01,#
#                           aag02     LIKE aag_file.aag02,#
#                           aag13     LIKE aag_file.aag13,#FUN-6C0012
#                           aee02     LIKE aee_file.aee02,#
#                           aee03     LIKE aee_file.aee03,#
#                           bdr       LIKE aed_file.aed05,#期初借方金額
#                           bcr       LIKE aed_file.aed05,#期初貸方金額
#                           dr        LIKE aed_file.aed05,#本期借方金額
#                           cr        LIKE aed_file.aed05,#本期貸方金額
#                           edr       LIKE aed_file.aed05,#期末借方金額
#                           ecr       LIKE aed_file.aed05 #期末貸方金額
#                        END RECORD
#   DEFINE g_head1       STRING
# 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
# 
#   ORDER BY sr.aee01,sr.aee02,sr.aee03
# 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         LET g_head1 = g_x[9] CLIPPED, tm.yy USING '<<<<','/',tm.bm USING'&&',
#                       '-',tm.yy USING '<<<<','/',tm.em USING'&&'
#         #PRINT g_head1                                                  #FUN-660060 remark
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1 CLIPPED))/2)-1, g_head1  #FUN-660060
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#         PRINT g_dash1
#         LET l_last_sw = 'n'
# 
#      BEFORE GROUP OF sr.aee01
#         PRINT COLUMN g_c[31],sr.aee01;
##              COLUMN g_c[32],sr.aag02   #FUN-6C0012
#         #FUN-6C0012.....begin 
#         IF tm.f = 'N' THEN
#            PRINT COLUMN g_c[32],sr.aag02   
#         ELSE
#            PRINT COLUMN g_c[32],sr.aag13
#         END IF
#         #FUN-6C0012.....end
#      ON EVERY ROW
#         PRINT COLUMN g_c[32],sr.aee03,
#               COLUMN g_c[33],cl_numfor(sr.bdr,33,tm.d),
#               COLUMN g_c[34],cl_numfor(sr.bcr,34,tm.d),
#               COLUMN g_c[35],cl_numfor(sr.dr,35,tm.d),
#               COLUMN g_c[36],cl_numfor(sr.cr,36,tm.d),
#               COLUMN g_c[37],cl_numfor(sr.edr,37,tm.d),   #No:7795
#               COLUMN g_c[38],cl_numfor(sr.ecr,38,tm.d)
#  
#      AFTER GROUP OF sr.aee01
#         PRINT
#          PRINT COLUMN g_c[32],g_x[10] CLIPPED,    #MOD-4A0338
#               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.bdr),33,tm.d),
#               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.bcr),34,tm.d),
#               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.dr),35,tm.d),
#               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.cr),36,tm.d),
#               COLUMN g_c[37],cl_numfor(GROUP SUM(sr.edr),37,tm.d),
#               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.ecr),38,tm.d)
#         PRINT g_dash2
#  
#      ON LAST ROW
#         PRINT
#          PRINT COLUMN g_c[32],g_x[11] CLIPPED,       #MOD-4A0338
#               COLUMN g_c[33],cl_numfor(SUM(sr.bdr),33,tm.d),
#               COLUMN g_c[34],cl_numfor(SUM(sr.bcr),34,tm.d),
#               COLUMN g_c[35],cl_numfor(SUM(sr.dr),35,tm.d),
#               COLUMN g_c[36],cl_numfor(SUM(sr.cr),36,tm.d),
#               COLUMN g_c[37],cl_numfor(SUM(sr.edr),37,tm.d),
#               COLUMN g_c[38],cl_numfor(SUM(sr.ecr),38,tm.d)
#         LET l_last_sw = 'y'
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED          #No.TQC-6B0093
#  
#      PAGE TRAILER
#         IF l_last_sw = 'n' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED          #No.TQC-6B0093
#         ELSE
#            SKIP 2 LINE
#         END IF
#  
#END REPORT
#end TQC-760131 mark

###GENGRE###START
FUNCTION aglg800_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg800")
        IF handler IS NOT NULL THEN
            START REPORT aglg800_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY aee01,aee02,aee03"                #FUN-B90028 add 
          
            DECLARE aglg800_datacur1 CURSOR FROM l_sql
            FOREACH aglg800_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg800_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg800_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg800_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_aee02   STRING
    DEFINE l_month   STRING
    DEFINE l_tmyy    STRING
    DEFINE l_tmbm    STRING
    DEFINE l_tmem    STRING 
    DEFINE l_fmt     STRING    
    DEFINE l_unit    STRING
    DEFINE l_bdr_sum LIKE aed_file.aed05
    DEFINE l_bcr_sum LIKE aed_file.aed05
    DEFINE l_dr_sum  LIKE aed_file.aed05
    DEFINE l_cr_sum  LIKE aed_file.aed05
    DEFINE l_edr_sum LIKE aed_file.aed05
    DEFINE l_ecr_sum LIKE aed_file.aed05 
    DEFINE l_bdr_tot LIKE aed_file.aed05
    DEFINE l_bcr_tot LIKE aed_file.aed05
    DEFINE l_dr_tot  LIKE aed_file.aed05
    DEFINE l_cr_tot  LIKE aed_file.aed05
    DEFINE l_edr_tot LIKE aed_file.aed05
    DEFINE l_ecr_tot LIKE aed_file.aed05

    DEFINE l_sum_tot  LIKE type_file.num20_6

    DEFINE l_sum_tot_fmt STRING
    ORDER EXTERNAL BY sr1.aee01,sr1.aee02,sr1.aee03

    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-B90028 add  g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aee01
        BEFORE GROUP OF sr1.aee02
        BEFORE GROUP OF sr1.aee03

        
        ON EVERY ROW
            LET l_unit = cl_gr_getmsg("gre-220",g_lang,'1')
            LET l_aee02 = l_unit,'-',sr1.aee02
            PRINTX l_aee02
            LET l_fmt = cl_gr_numfmt("aed_file","aed05",tm.d)
            PRINTX l_fmt
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.aee01

            LET l_bdr_sum = GROUP SUM (sr1.bdr)
            PRINTX l_bdr_sum
            LET l_bcr_sum = GROUP SUM (sr1.bcr)
            PRINTX l_bcr_sum
            LET l_dr_sum = GROUP SUM (sr1.dr)
            PRINTX l_dr_sum
            LET l_cr_sum = GROUP SUM (sr1.cr)
            PRINTX l_cr_sum
            LET l_edr_sum = GROUP SUM (sr1.edr)
            PRINTX l_edr_sum
            LET l_ecr_sum = GROUP SUM (sr1.ecr)
            PRINTX l_ecr_sum 
        AFTER GROUP OF sr1.aee02
        AFTER GROUP OF sr1.aee03

        
        ON LAST ROW
            LET l_tmyy = tm.yy
            LET l_tmbm = tm.bm
            LET l_tmem = tm.em
            IF l_tmbm < 10 AND l_tmem < 10 THEN 
               LET l_month = l_tmyy.trim(),'/0',l_tmbm.trim(),'-',l_tmyy.trim(),'/0',l_tmem.trim()
            ELSE 
               IF l_tmbm < 10 AND l_tmem >= 10 THEN
                   LET l_month = l_tmyy.trim(),'/0',l_tmbm.trim(),'-',l_tmyy.trim(),'/',l_tmem.trim()
               ELSE 
                  IF l_tmbm >= 10 AND l_tmem < 10 THEN
                     LET l_month = l_tmyy.trim(),'/',l_tmbm.trim(),'-',l_tmyy.trim(),'/',l_tmem.trim()
          
                  END IF
               END IF
            END IF

            PRINTX l_month
            LET l_bdr_tot = SUM (sr1.bdr)
            PRINTX l_bdr_tot
            LET l_bcr_tot = SUM (sr1.bcr)
            PRINTX l_bcr_tot
            LET l_dr_tot =  SUM (sr1.dr)
            PRINTX l_dr_tot
            LET l_cr_tot = SUM (sr1.cr)
            PRINTX l_cr_tot
            LET l_edr_tot = SUM (sr1.edr)
            PRINTX l_edr_tot
            LET l_ecr_tot = SUM (sr1.ecr)
            PRINTX l_ecr_tot



END REPORT
###GENGRE###END
