# Prog. Version..: '5.30.06-13.04.19(00009)'     #
#
# Pattern name...: amdr530.4gl
# Descriptions...: 統一發票調節表
# Date & Author..: 01/05/24 By Jiunn
# Modify.........: No:8319 03/11/06 By Kitty 銷退及折讓不應取貸方,應取借方未稅金額
# Modify.........: No:8406 03/11/17 By Kitty l_sql如遇到多張發票對同一張傳票時,金額會成倍數
# Modify.........: No.MOD-4C0165 05/01/07 By Kitty 下條件後發生語法錯誤訊息
# Modify.........: No.FUN-510019 05/01/12 By Smapmin 報表轉XML格式
# Modify.........: NO.TQC-5B0201 05/12/22 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳別權限修改
# Modify.........: No.FUN-680074 06/08/25 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/10 By Carrier 字段打印后加CLIPPED
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.FUN-750095 07/05/28 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-CB0145 12/11/16 By Polly 調整帳款抓取的條件；取消背景顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            amd22       LIKE amd_file.amd22,
            amd173_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
            amd174_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
            amd174_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER
            e           LIKE aaa_file.aaa01, #no.7277
            more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD
DEFINE g_dash_1 LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(132)
DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680074 SMALLINT
DEFINE g_tot1   LIKE amd_file.amd08          #No.FUN-680074 INTEGER
DEFINE g_tot2   LIKE amd_file.amd08          #No.FUN-680074 INTEGER
DEFINE g_tot    LIKE amd_file.amd08          #No.FUN-750095
DEFINE g_ama08  LIKE ama_file.ama08  #NO.TQC-5B0201
DEFINE g_ama09  LIKE ama_file.ama09  #NO.TQC-5B0201
DEFINE g_ama10  LIKE ama_file.ama10  #NO.TQC-5B0201
 
DEFINE g_i          LIKE type_file.num5   #count/index for any purpose        #No.FUN-680074 SMALLINT
DEFINE g_bookno1    LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2    LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_flag       LIKE type_file.chr1   #No.FUN-730033
#No.FUN-750095 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-750095 -- end --
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.amd22 = ARG_VAL(7)
   LET tm.amd173_b = ARG_VAL(8)
   LET tm.amd174_b = ARG_VAL(9)
   LET tm.amd174_e = ARG_VAL(10)
   LET tm.e        = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-750095 -- begin --
   LET g_sql="aag01.aag_file.aag01,",
             "aag02.aag_file.aag02,",
             "amd08.amd_file.amd08,",
             "no.type_file.num10"
 
   LET l_table= cl_prt_temptable('amdr530',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750095 -- end --
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r530_tm(0,0)
      ELSE CALL r530()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r530_tm(p_row,p_col)
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-680074 SMALLINT#No.FUN-670006
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 30
   ELSE LET p_row = 6 LET p_col = 14
   END IF
   OPEN WINDOW r530_w AT p_row,p_col
        WITH FORM "amd/42f/amdr530"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.amd22 = ''
   LET tm.amd173_b = YEAR(g_today)
   LET tm.amd174_b = MONTH(g_today) - 1
   LET tm.amd174_e = MONTH(g_today) - 1
   SELECT aaz64 INTO tm.e FROM aaz_file WHERE aaz00='0' #no.7277
 
WHILE TRUE
   INPUT BY NAME tm.amd22, tm.amd173_b, tm.amd174_b, tm.amd174_e,tm.e,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      #NO.TQC-5B0201 START---
      AFTER FIELD amd22
         IF cl_null(tm.amd22) THEN
            NEXT FIELD amd22
         ELSE
            SELECT ama08,ama09,ama10 INTO g_ama08,g_ama09,g_ama10
              FROM ama_file WHERE ama01 = tm.amd22 AND amaacti = 'Y'
            IF SQLCA.sqlcode THEN
          #    CALL cl_err(tm.amd22,'amd-002',0) #No.FUN-660093
               CALL cl_err3("sel","ama_file",tm.amd22,"","amd-002","","",0)    #No.FUN-660093
               NEXT FIELD amd22
            END IF
            LET tm.amd173_b = g_ama08
            LET tm.amd174_b = g_ama09 + 1
            IF tm.amd174_b > 12 THEN
                LET tm.amd173_b = tm.amd173_b + 1
                LET tm.amd174_b = tm.amd174_b - 12
            END IF
            LET tm.amd174_e = tm.amd174_b + g_ama10 - 1
            DISPLAY tm.amd173_b TO FORMONLY.amd173_b
            DISPLAY tm.amd174_b TO FORMONLY.amd174_b
            DISPLAY tm.amd174_e TO FORMONLY.amd174_e
         END IF
       #NO.TQC-5B0201
 
 
      AFTER FIELD amd173_b
         IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
      AFTER FIELD amd174_b
         IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
         IF tm.amd174_b > 12 OR tm.amd174_b < 1 THEN NEXT FIELD amd174_b END IF
      AFTER FIELD amd174_e
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
         IF tm.amd174_e > 12 OR tm.amd174_e < 1 THEN NEXT FIELD amd174_e END IF
#--NO.TQC-5B0201 MARK
#         IF tm.amd174_b >tm.amd174_e THEN
#            NEXT FIELD amd174_e
#         END IF
#--NO.TQC-5B0201 MARK
      #no.7277
      AFTER FIELD e
         IF cl_null(tm.e) THEN NEXT FIELD e END IF
         IF NOT cl_null(tm.e) THEN
             #No.FUN-670006--begin
             CALL s_check_bookno(tm.e,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
#               LET g_apm.apm09 = g_apm09_t
                NEXT FIELD e
             END IF 
             #No.FUN-670006--end
         END IF
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.e
                                      AND aaaacti IN ('Y','y')
         IF STATUS THEN 
      #     CALL cl_err('sel aaa:',STATUS,0)     #No.FUN-660093
            CALL cl_err3("sel","aaa_file",tm.e,"",STATUS,"","sel aaa:",0)    #No.FUN-660093 
         NEXT FIELD e END IF
      #no.7277(end)
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
       #No.MOD-4C0165 add
      ON ACTION CONTROLP
            IF INFIELD(amd22) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ama"
              LET g_qryparam.default1 = tm.amd22
              CALL cl_create_qry() RETURNING tm.amd22
#              CALL FGL_DIALOG_SETBUFFER( tm.amd22 )
              DISPLAY BY NAME tm.amd22
              NEXT FIELD amd22
            END IF
            IF INFIELD(e) THEN
#              CALL q_aaa(0,0,tm.e) RETURNING tm.e
#              CALL FGL_DIALOG_SETBUFFER( tm.e )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.e
               CALL cl_create_qry() RETURNING tm.e
#               CALL FGL_DIALOG_SETBUFFER( tm.e )
               DISPLAY BY NAME tm.e
               NEXT FIELD e
            END IF
          #No.MOD-4C0165 end
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r530_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
 
   #No.FUN-730033  --Begin
   CALL s_get_bookno(tm.amd173_b)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(tm.amd173_b,'aoo-081',1)
      CONTINUE WHILE 
   END IF
   #No.FUN-730033  --End  
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr530'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr530','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.amd22    CLIPPED,"'",
                         " '",tm.amd173_b CLIPPED,"'",
                         " '",tm.amd174_b CLIPPED,"'",
                         " '",tm.amd174_e CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('amdr530',g_time,l_cmd)
      END IF
      CLOSE WINDOW r530_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r530()
   ERROR ""
END WHILE
   CLOSE WINDOW r530_w
END FUNCTION
 
FUNCTION r530()
   DEFINE l_name  LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20)# External(Disk) file name
#         l_time  LIKE type_file.chr8        #No.FUN-6A0068
          l_sql   STRING,                    # RDSQL STATEMENT        #No.FUN-680074
          l_chr   LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05  LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_cnt   LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          sr      RECORD
                     aag01 LIKE aag_file.aag01, # 科目編號
                     aag02 LIKE aag_file.aag02, # 科目名稱
                     amd08 LIKE amd_file.amd08, #No.FUN-680074 INTEGER# 金額
                     no    LIKE type_file.num10 #No.FUN-680074 INTEGER# 序號
                  END RECORD,
          l_amd01 LIKE amd_file.amd01,          #No:8406
          l_amd28 LIKE amd_file.amd28           #No:8406
 
   CALL cl_del_data(l_table)       #No.FUN-750095
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004--BEGIN
#   SELECT azi04, azi05 INTO g_azi04, g_azi05 FROM azi_file
#      WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004--END
#--No:8406                 #傳票編號         帳款編號
#No.FUN-750095 -- begin --
#   CREATE TEMP TABLE r530_tmp(
#      tmp01 LIKE type_file.chr1000,
#      tmp02 LIKE type_file.chr1)
   CREATE TEMP TABLE r530_tmp(
      tmp01 LIKE amd_file.amd28,
      tmp02 LIKE amd_file.amd01)
#No.FUN-750095 -- end --
   CREATE UNIQUE INDEX t530_01 ON r530_tmp(tmp01)
 
#   LET l_sql = "SELECT amd28,amd01 ",          #No.FUN-750095
   LET l_sql = "SELECT UNIQUE amd28,amd01 ",    #No.FUN-750095
                 "  FROM amd_file",
                 " WHERE amd173 = ",tm.amd173_b,
                 "   AND amd174 BETWEEN ", tm.amd174_b, " AND ", tm.amd174_e,
                 "   AND amd22 = '", tm.amd22, "'",
                 "   AND amdacti = 'Y'",
                 "   AND amd30   = 'Y' "
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r530_pretmp FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare tmp:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE r530_tmp CURSOR FOR r530_pretmp
     FOREACH r530_tmp INTO l_amd28,l_amd01
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          INSERT INTO r530_tmp VALUES(l_amd28,l_amd01)
          IF SQLCA.sqlcode THEN
             CONTINUE FOREACH
          END IF
     END FOREACH
     #No:8406 end
 
     LET l_cnt = 0
     # 本期開立發票金額(1)
    #LET l_sql = "SELECT '本期開立發票金額', '', SUM(amd08), 0",
      LET l_sql = "SELECT '', '', SUM(amd08), 0",            #No.MOD-4C0165
                 "  FROM amd_file",
                 " WHERE amd173 = ",tm.amd173_b,
                 "   AND amd174 BETWEEN ", tm.amd174_b, " AND ", tm.amd174_e,
                 "   AND amd22 = '", tm.amd22, "'",
                 "   AND amd021 IN ('3', '4')",
                 "   AND amd171 NOT LIKE '2%'",                                     #MOD-CB0145 add
                 "   AND amdacti = 'Y'",
                 "   AND amd30   = 'Y' "#,
                #" GROUP BY '本期開立發票金額', '' "       #No.MOD-4C0165
 
    #display l_sql                                                                  #MOD-CB0145 mark
     PREPARE r530_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE r530_curs1 CURSOR FOR r530_prepare1
 
#No.FUN-750095 -- begin --
#     CALL cl_outnam('amdr530') RETURNING l_name
#     START REPORT r530_rep TO l_name
#     LET g_pageno = 0
#No.FUN-750095 -- end --
 
     FOREACH r530_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt = l_cnt + 1
          LET sr.no = l_cnt
          LET g_tot1 = sr.amd08
          LET sr.aag01='本期開立發票金額'       #No.MOD-4C0165
#No.FUN-750095 -- begin --
#          OUTPUT TO REPORT r530_rep(sr.*)
          EXECUTE insert_prep USING sr.*
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
     END FOREACH
 
     LET l_cnt = l_cnt + 1
     LET sr.no = l_cnt
     LET sr.aag01 = '減:'
     LET sr.aag02 = ''
     LET sr.amd08 = 0
#No.FUN-750095 -- begin --
#     OUTPUT TO REPORT r530_rep(sr.*)
     EXECUTE insert_prep USING sr.*
     IF STATUS THEN
        CALL cl_err("execute insert_prep:",STATUS,1)
        RETURN
     END IF
#No.FUN-750095 -- end --
 
     # 減:明細(2)
     LET l_sql = "SELECT aag01, aag02, SUM(abb07), 0",
                 "  FROM amd_file, abb_file, aba_file, aag_file, r530_tmp ",   #No:8406
                 " WHERE amd173 = ",tm.amd173_b,
                 "   AND amd174 BETWEEN ", tm.amd174_b, " AND ", tm.amd174_e,
                 "   AND amd22  = '", tm.amd22, "'",
                 "   AND ((amd021 = '3') OR ",
                 "        (amd021='1' AND ",
                 "         amd171 IN ('31','32','35','36'))) ",      #No:8319
                 "   AND amd28 IS NOT NULL",
                 "   AND amdacti = 'Y'",
                 "   AND amd30   = 'Y' ",
                 "   AND amd28 = abb01",
                 "   AND abb06 = '2'",
                 "   AND aba01 = abb01",
                 "   AND aba00 = abb00",         #no.7277
                 "   AND aba00 = '",tm.e,"'",    #no.7277
                 "   AND aba19 = 'Y'",
                 "   AND aag01 = abb03",
                 "   AND aag00 = abb00 ",   #No.FUN-730033
                 "   AND aag00 = '",g_bookno1,"'",  #No.FUN-730033
                 "   AND abb03 NOT IN",
                 "       (SELECT gec03 FROM gec_file WHERE gec03 IS NOT NULL)",
                 "   AND amd01 = r530_tmp.tmp02 ",    #No:8406
                 " GROUP BY aag01,aag02",
                 " ORDER BY aag01,aag02"
 
    #display 'prepare2:',l_sql                                     #MOD-CB0145 mark
     PREPARE r530_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE r530_curs2 CURSOR FOR r530_prepare2
 
     LET g_tot2 = 0
     FOREACH r530_curs2 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach2:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt = l_cnt + 1
          LET sr.no = l_cnt
          LET g_tot2 = g_tot2 + sr.amd08
#No.FUN-750095 -- begin --
#          OUTPUT TO REPORT r530_rep(sr.*)
          EXECUTE insert_prep USING sr.*
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
     END FOREACH
 
     #No:8319 減:明細(2)  -- 折讓及銷退
  LET l_sql = "SELECT aag01, aag02, SUM(abb07)*-1, 0",
                 "  FROM amd_file, abb_file, aba_file, aag_file,r530_tmp ",
                 " WHERE amd173 = ",tm.amd173_b,
                 "   AND amd174 BETWEEN ", tm.amd174_b, " AND ", tm.amd174_e,
                 "   AND amd22  = '", tm.amd22, "'",
                 "   AND (amd021 IN ('1','3') ",  #1-總帳,3-應收
                 "        AND amd171 IN ('33','34')) ",   #amd171銷退及折讓
                 "   AND amd28 IS NOT NULL",
                 "   AND amdacti = 'Y'",
                 "   AND amd30   = 'Y' ",
                 "   AND amd28 = abb01",
                 "   AND abb06 = '1'",
                 "   AND aba01 = abb01",
                 "   AND aba19 = 'Y'",
                 "   AND aag01 = abb03",
                 "   AND aag00 = abb00 ",   #No.FUN-730033
                 "   AND aag00 = '",g_bookno1,"'",  #No.FUN-730033
                 "   AND abb03 NOT IN",
                 "       (SELECT gec03 FROM gec_file WHERE gec03 IS NOT NULL)",
                 "   AND amd01 = r530_tmp.tmp02 ",
                 " GROUP BY aag01, aag02",
                 " ORDER BY 1, 2"
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r530_prepare21 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare21:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE r530_curs21 CURSOR FOR r530_prepare21
 
     FOREACH r530_curs21 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach21:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
         #IF g_trace='Y' THEN                      #MOD-CB0145 mark
         #   DISPLAY sr.*                          #MOD-CB0145 mark
         #END IF                                   #MOD-CB0145 mark
          LET l_cnt = l_cnt + 1
          LET sr.no = l_cnt
          LET g_tot2 = g_tot2 + sr.amd08
#No.FUN-750095 -- begin --
#          OUTPUT TO REPORT r530_rep(sr.*)
          EXECUTE insert_prep USING sr.*
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
     END FOREACH
     #No:8319 end
     # 差異(3)
     #LET l_sql = "SELECT '科目未立', '', SUM(amd08),0 ",        #No.MOD-4C0165
     LET l_sql = "SELECT '', '', SUM(amd08),0 ",
                 "  FROM amd_file",
                 " WHERE amd173 = ",tm.amd173_b,
                 "   AND amd174 BETWEEN ", tm.amd174_b, " AND ", tm.amd174_e,
                 "   AND amd22  = '", tm.amd22, "'",
                 "   AND amd021 = '4'",
                 "   AND amd28 NOT IN (SELECT abb01 FROM abb_file ",
                                       "WHERE abb00='",tm.e,"')",
                 "   AND amdacti = 'Y'",
                 "   AND amd30   = 'Y' ",
                 "   AND amd171 IN ('31','32','33','34','35','36')"#,
                 #" GROUP BY '科目未立', '' "                #No.MOD-4C0165
 
    #display 'prepare3:',l_sql                               #MOD-CB0145 mark
     PREPARE r530_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE r530_curs3 CURSOR FOR r530_prepare3
 
     FOREACH r530_curs3 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach3:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET l_cnt = l_cnt + 1
          LET sr.no = l_cnt
          LET g_tot2 = g_tot2 + sr.amd08
           LET sr.aag01='科目未立'                #No.MOD-4C0165
#No.FUN-750095 -- begin --
#          OUTPUT TO REPORT r530_rep(sr.*)
          EXECUTE insert_prep USING sr.*
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-750095 -- end --
     END FOREACH
 
#     FINISH REPORT r530_rep     #No.FUN-750095
     DROP TABLE r530_tmp
#No.FUN-750095 -- begin --
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_tot = g_tot1 - g_tot2
     IF cl_null(g_tot) THEN LET g_tot=0 END IF
     LET g_str = g_azi04,';',g_tot,';',g_azi05
     CALL cl_prt_cs3('amdr530','amdr530',l_sql,g_str)
#No.FUN-750095 -- end --
END FUNCTION
 
#No.FUN-750095 -- begin --
#REPORT r530_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
#       g_head1      STRING,                      #No.FUN-680074
#       str          STRING,                      #No.FUN-680074
#       sr           RECORD
#                      aag01 LIKE aag_file.aag01, # 科目編號
#                      aag02 LIKE aag_file.aag02, # 科目名稱
#                      amd08 LIKE amd_file.amd08,      #No.FUN-680074 INTEGER# 金額
#                      no    LIKE type_file.num10       #No.FUN-680074 INTEGER# 序號
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.no, sr.aag01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0093
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[9] CLIPPED, tm.amd173_b USING '#### ',
#                    g_x[10] CLIPPED, tm.amd174_b USING '## ',
#                    '-',tm.amd174_e USING '##'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33]
#      PRINT g_dash1 CLIPPED  #No.TQC-6A0093
#      LET l_last_sw = 'n'
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.aag02;
#      PRINT COLUMN g_c[32],sr.aag01;
#      IF sr.no <> 2 THEN
#        PRINT COLUMN g_c[33],cl_numfor(sr.amd08,33,g_azi04)
#      END IF
#
#   ON LAST ROW
#      IF g_tot2 IS NULL THEN
#         LET g_tot2 = 0
#      END IF
#      PRINT COLUMN g_c[33],g_dash2[1,g_w[33]]
#      PRINT g_x[11] CLIPPED,
#            COLUMN g_c[33],cl_numfor(g_tot1-g_tot2,33,g_azi05)
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#
#END REPORT
#No.FUN-750095 -- end --
#Patch....NO.TQC-610035 <001> #
