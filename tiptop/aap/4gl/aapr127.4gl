# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aapr127.4gl
# Descriptions...: 應付帳款沖帳明細表作業
# Date & Author..: 94/11/09  By Apple
# Modify.........: No.FUN-540057 05/05/09 By jackie 欄位控制調整
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.MOD-590440 05/11/03 By ice 月底重評價后,報表列印欄位增加
# Modify.........: No.TQC-5B0138 05/11/22 By Rosayu 營運中心給預設值
# Modify.........: No.MOD-5B0053 05/11/28 By ice 程序應依apz27判斷本幣未衝金額是否抓取apa73
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.TQC-630250 06/04/03 By Smapmin 小計有誤
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 金額不需扣除留置金額
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/19 By wuxj 去掉plant，跨DB改為不跨DB
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              #wc      LIKE type_file.chr1000,      # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc       STRING,       # Where condition   #TQC-630166
              a       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
              h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
              #plant   VARCHAR(10),           #FUN-660117 remark
             #plant   LIKE azp_file.azp01, #FUN-660117  #NO.FUN-A10098  mark
              s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Order by sequence
              t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Eject sw
              u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),         # Group total sw
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
#         g_orderA    ARRAY[3] OF VARCHAR(10)
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
          #g_amt1,g_amt2,g_amt3,g_amt4  LIKE type_file.num20_6   #TQC-630250  #No.FUN-690028 DECIMAL(20,6)   #MOD-720128
 
DEFINE   g_head1         LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(100)  #No.FUN-580010
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)  #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate  = ARG_VAL(1)           # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.h     = ARG_VAL(9)
  #NO.FUN-A10098 ---start---
  #LET tm.plant = ARG_VAL(10)
  #LET tm.s     = ARG_VAL(11)
  #LET tm.t     = ARG_VAL(12)
  #LET tm.u     = ARG_VAL(13)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(14)
  #LET g_rep_clas = ARG_VAL(15)
  #LET g_template = ARG_VAL(16)
  ##No.FUN-570264 ---end---
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)
   LET tm.u     = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
  #NO.FUN-A10098 ---end---
   
   #-----MOD-720128---------
   DROP TABLE curr_tmp1
      CREATE TEMP TABLE curr_tmp1(
          apa06 LIKE apa_file.apa06,
          apa01 LIKE apa_file.apa01,
          apa02 LIKE apa_file.apa02,
          apa21 LIKE apa_file.apa21,
          apa13 LIKE apa_file.apa13,
          apa34 LIKE apa_file.apa34,
          apa20 LIKE apa_file.apa20,
          order1 LIKE type_file.chr20,
          order2 LIKE type_file.chr20,
          order3 LIKE type_file.chr20);
 
   DROP TABLE curr_tmp2
      CREATE TEMP TABLE curr_tmp2( 
          apa06 LIKE apa_file.apa06,
          apa01 LIKE apa_file.apa01,
          apa02 LIKE apa_file.apa02,
          apa21 LIKE apa_file.apa21,
          apa13 LIKE apa_file.apa13,
          amt1  LIKE apv_file.apv04,
          order1 LIKE type_file.chr20,
          order2 LIKE type_file.chr20,
          order3 LIKE type_file.chr20);
   #-----END MOD-720128-----
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r127_tm(0,0)        # Input print condition
      ELSE CALL r127()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r127_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5    #No.FUN-940102 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r127_w AT p_row,p_col
        WITH FORM "aap/42f/aapr127"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '1'
   LET tm.h    = '3'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.plant = g_plant #TQC-5B0138  #NO.FUN-A10098 mark
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
   CONSTRUCT BY NAME tm.wc ON apa06,apa01,apa02,apa21,apa13
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r127_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  #INPUT BY NAME tm.plant,tm.a,tm.h,    #NO.FUN-A10098  
   INPUT BY NAME  tm.a,tm.h,            #NO.FUN-A10098
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.more
                   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[12]' OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD h
         IF tm.h NOT MATCHES '[123]' OR cl_null(tm.h) THEN
            NEXT FIELD h
         END IF
    #NO.FUN-A10098 ---start---mark
    # AFTER FIELD plant
    #    IF tm.plant IS NULL AND tm.plant = ' '
    #    THEN NEXT FIELD plant
    #    ELSE SELECT azp03 INTO g_dbs_new FROM azp_file
    #     		WHERE azp01 = tm.plant
    #           IF SQLCA.SQLCODE THEN
    #              LET g_errno='aom-300'
    #              CALL cl_err('tm.plant',g_errno,0)
    #              NEXT FIELD plant
    #          	END IF
    ##No.FUN-940102 --begin--
    #          CALL s_chk_demo(g_user,tm.plant) RETURNING li_result
    #            IF not li_result THEN 
    #               NEXT FIELD plant
    #            END IF 
    ##No.FUN-940102 --end--  
    #    END IF
    #NO.FUN-A10098 ---end---mark
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r127_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr127'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr127','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.h     CLIPPED,"'",
                        #" '",tm.plant CLIPPED,"'",  #NO.FUN-A10098 mark
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aapr127',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r127_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r127()
   ERROR ""
END WHILE
   CLOSE WINDOW r127_w
END FUNCTION
 
FUNCTION r127()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql      STRING,      # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),                        #No.FUN-550030
          sr               RECORD order1   LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),             #No.FUN-550030
                                  order2   LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),             #No.FUN-550030
                                  order3   LIKE apa_file.apa01,      # No.FUN-690028 VARCHAR(16),             #No.FUN-550030
                                  apa00    LIKE apa_file.apa00,  #性質
                                  apa01    LIKE apa_file.apa01,  #帳款編號
                                  apa02    LIKE apa_file.apa02,  #帳款日期
                                  apa06    LIKE apa_file.apa06,  #付款廠商
                                  apa07    LIKE apa_file.apa07,  #簡稱
                                  apa08    LIKE apa_file.apa08,  #發票號碼
                                  apa21    LIKE apa_file.apa21,  #帳款人員
                                  apa36    LIKE apa_file.apa36,  #類別
                                  apa13    LIKE apa_file.apa13,  #幣別
                                  apa34    LIKE apa_file.apa34,  #應付
                                  apa35    LIKE apa_file.apa35,  #已付
                                  payno    LIKE apv_file.apv03,  #沖帳單號
                                  paymoney LIKE apv_file.apv04,  #沖帳金額
                                  paydate  LIKE apa_file.apa02,  #沖帳日期
                                  pay1     LIKE apa_file.apa73,  #MOD-590440
                                  apa73    LIKE apa_file.apa73,  #MOD-590440
                                  azi03    LIKE azi_file.azi03,
                                  azi04    LIKE azi_file.azi04,
                                  azi05    LIKE azi_file.azi05,
                                  apa65    LIKE apa_file.apa65
                        END RECORD,
          l_apg05     LIKE apg_file.apg05,
          l_apf01     LIKE apf_file.apf01,
          l_apf02     LIKE apf_file.apf02
DEFINE l_i       LIKE type_file.num5           #No.MOD-590440  #No.FUN-690028 SMALLINT
DEFINE l_len     LIKE type_file.num5           # No.FUN-690028 SMALLINT         #No.MOD-590440
 
     #-----MOD-720128---------
     ##-----TQC-630250---------
     #LET g_amt1 = 0
     #LET g_amt2 = 0
     #LET g_amt3 = 0
     #LET g_amt4 = 0
     ##-----END TQC-630250-----
     #-----END MOD-720128----- 
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr127'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 150 END IF
#    LET g_len = 162  #No.FUN-550030
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc CLIPPED," AND apauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc CLIPPED," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND apagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
     #End:FUN-980030
 
     #-----MOD-720128---------
     DELETE FROM curr_tmp1;
     DELETE FROM curr_tmp2;
     #-->直接沖帳部份
     LET l_sql = "SELECT '','','',",
                 " apa00, apa01, apa02, apa06, apa07,",
               # " apa08, apa21, apa36, apa13, apa34,apa35,'','','',", #no.4901
                 " apa08, apa21, apa36, apa13, (apa34+apa65),apa35,'','','',",
#                " azi03, azi04, azi05,apa65 ",
                 " (apa35+apa73+apa65),apa73,azi03, azi04, azi05,apa65 ",
                 " FROM apa_file, OUTER azi_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND apa00[1,1] ='1' ",
                 " AND azi_file.azi01 = apa_file.apa13 AND apa42='N' AND apa74='N'"
     IF tm.a ='1' THEN
        #No.MOD-5B0053 --start--
        IF g_apz.apz27 = 'N' THEN
           LET l_sql = l_sql CLIPPED, " AND apa34 > apa35 "
        ELSE
           LET l_sql = l_sql CLIPPED, " AND apa73 > 0 "    #No.MOD-590440
        END IF
        #No.MOD-5B0053 --end--
     END IF
     IF tm.h ='1' THEN LET l_sql = l_sql CLIPPED, " AND apa41='Y' " END IF
     IF tm.h ='2' THEN LET l_sql = l_sql CLIPPED, " AND apa41='N' " END IF
     PREPARE r127_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare :',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r127_curs1 CURSOR FOR r127_prepare1
 
     #-->直接沖帳部份
     LET l_sql = "SELECT apv03, apv04 ",
                 " FROM apv_file,apa_file ",
                 " WHERE apv01 = apa01    ",
                 "   AND apv01 = ? "
     PREPARE r127_preapa FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('preapa:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r127_curapa CURSOR FOR r127_preapa
 
     #-->財務廠沖帳部份
 #NO.FUN-A10098 ---start---mark
 # 	 LET g_plant_new = tm.plant
 # 	 CALL s_getdbs()
 #NO.FUN-A10098 ---end---mark
     LET l_sql = "SELECT apg05, apf01,apf02  ",
                #NO.FUN-A10098 ----start----
                #" FROM  ",g_dbs_new CLIPPED," apg_file, ",
                #"       ",g_dbs_new CLIPPED," apf_file ",
                 " FROM apg_file,apf_file ",
                #NO.FUN-A10098 ----end----
                 " WHERE apg04 = ?   AND apf41='Y'  ",
                 "   AND apg01 = apf01 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE r127_preapg FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('preapg:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
       EXIT PROGRAM
     END IF
     DECLARE r127_curapg CURSOR FOR r127_preapg
 
     CALL cl_outnam('aapr127') RETURNING l_name
     #No.MOD-590440 --start--
     IF g_apz.apz27 = 'N' THEN
        LET g_zaa[44].zaa06 = "Y"
        LET g_zaa[45].zaa06 = "Y"
     ELSE
        LET g_zaa[44].zaa06 = "N"
        LET g_zaa[45].zaa06 = "N"
     END IF
     LET g_len=0
     LET g_dash=NULL
     FOR l_i = 1 TO g_zaa.getLength()
        IF g_zaa[l_i].zaa06 = 'N' THEN
           LET g_len = g_len + g_zaa[l_i].zaa05 + 1
        END IF
     END FOR
     LET g_len = g_len - 1
     FOR l_i = 1 TO g_len LET g_dash[l_i,l_i] = '=' END FOR
     IF g_towhom IS NULL OR g_towhom = ' ' THEN
        LET g_head = ''
     ELSE
        LET g_head = 'TO:',g_towhom CLIPPED,'  '
     END IF
     LET l_len = g_head.getLength()    ### FUN-570264 ##
     IF (g_pdate = 0 ) THEN
        LET g_pdate = g_today
     END IF
     LET g_head = g_head ,g_x[2] CLIPPED,g_pdate ,COLUMN 19+l_len,TIME,COLUMN (g_len-FGL_WIDTH(g_user)-20),'FROM:',
                  g_user CLIPPED,COLUMN (g_len-13),g_x[3] CLIPPED
     #No.MOD-590440 --end--
     START REPORT r127_rep TO l_name
     LET g_pageno = 0
     FOREACH r127_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #-->待抵帳日期
          #SELECT apa02 INTO sr.paydate FROM apa_file WHERE apa01 = sr.payno   #TQC-630250
          #IF SQLCA.sqlcode THEN LET sr.apa02 = '********' END IF   #TQC-630250
          IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
          IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
          IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
          FOR g_i = 1 TO 3
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apa06
                                            LET g_orderA[g_i]= g_x[17]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apa01
                                            LET g_orderA[g_i]= g_x[18]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apa02 USING 'YYYYMMDD'
                                            LET g_orderA[g_i]= g_x[19]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apa21
                                            LET g_orderA[g_i]= g_x[16]
                   WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apa13
                                            LET g_orderA[g_i]= g_x[20]
                   OTHERWISE LET l_order[g_i]  = '-'
                             LET g_orderA[g_i] = ' '          #清為空白
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
          IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
          IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
 
          #-->直接沖帳部份
          FOREACH r127_curapa USING sr.apa01 INTO sr.payno,sr.paymoney
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach-apa:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             SELECT apa02 INTO sr.paydate FROM apa_file WHERE apa01 = sr.payno   #TQC-630250
             IF SQLCA.sqlcode THEN LET sr.paydate = '********' END IF   #TQC-630250
             OUTPUT TO REPORT r127_rep(sr.*)
          END FOREACH
 
          #-->財務廠沖帳部份
          FOREACH r127_curapg USING sr.apa01 INTO l_apg05,l_apf01,l_apf02
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach-aph:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             LET sr.payno    = l_apf01    #付款單號
             LET sr.paymoney = l_apg05    #金額
             LET sr.paydate  = l_apf02    #日期
             OUTPUT TO REPORT r127_rep(sr.*)
          END FOREACH
     END FOREACH
     FINISH REPORT r127_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
END FUNCTION
 
REPORT r127_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr               RECORD order1 LIKE apa_file.apa01,    # No.FUN-690028 VARCHAR(16),               #No.FUN-550030
                                  order2 LIKE apa_file.apa01,    # No.FUN-690028 VARCHAR(16),               #No.FUN-550030
                                  order3 LIKE apa_file.apa01,    # No.FUN-690028 VARCHAR(16),               #No.FUN-550030
                                  apa00    LIKE apa_file.apa00,  #性質
                                  apa01    LIKE apa_file.apa01,  #帳款編號
                                  apa02    LIKE apa_file.apa02,  #帳款日期
                                  apa06    LIKE apa_file.apa06,  #付款廠商
                                  apa07    LIKE apa_file.apa07,  #簡稱
                                  apa08    LIKE apa_file.apa08,  #發票號碼
                                  apa21    LIKE apa_file.apa21,  #帳款人員
                                  apa36    LIKE apa_file.apa36,  #類別
                                  apa13    LIKE apa_file.apa13,  #幣別
                                  apa34    LIKE apa_file.apa34,  #應付
                                  apa35    LIKE apa_file.apa35,  #已付
                                  payno    LIKE apv_file.apv03,  #沖帳單號
                                  paymoney LIKE apv_file.apv04,  #沖帳金額
                                  paydate  LIKE apa_file.apa02,  #沖帳日期
                                  pay1     LIKE apa_file.apa73,  #MOD-590440
                                  apa73    LIKE apa_file.apa73,  #MOD-590440
                                  azi03    LIKE azi_file.azi03,
                                  azi04    LIKE azi_file.azi04,
                                  azi05    LIKE azi_file.azi05,
                                  apa65    LIKE apa_file.apa65
                        END RECORD,
      l_bal        LIKE apa_file.apa34,
      l_bal1       LIKE apa_file.apa34,  #MOD-590440
      l_bal2       LIKE apa_file.apa34,  #MOD-590440,本幣已付金額
      l_bal3       LIKE apa_file.apa34,  #TQC-610098
      l_pay        LIKE apa_file.apa34,
      l_amt_1      LIKE apa_file.apa34,
      l_amt_2      LIKE apa_file.apa34,
      l_amt_3      LIKE apa_file.apa34,  #TQC-610098
      l_amt_bal    LIKE apa_file.apa34,
      l_cnt        LIKE type_file.num5,    #No.FUN-690028 SMALLINT
      l_chr        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      l_apa20      LIKE apa_file.apa20,   #TQC-610098
      l_apa14      LIKE apa_file.apa14    #TQC-610098
DEFINE sum_apa13   LIKE apa_file.apa13   #MOD-720128
DEFINE sum_apa34   LIKE apa_file.apa34   #MOD-720128
DEFINE sum_apa20   LIKE apa_file.apa20   #MOD-720128
DEFINE sum_amt1    LIKE apa_file.apa34   #MOD-720128
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.apa01
  FORMAT
   PAGE HEADER
#No.FUN-580010  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_head1 = g_x[12] CLIPPED, g_orderA[1] CLIPPED,'-',
                    g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
      PRINT g_head1
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
            g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[46],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45] #MOD-610098
            #g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45] #MOD-590440    #TQC-610098
      PRINT g_dash1
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 49,g_x[11] CLIPPED,
#           g_orderA[1] CLIPPED,'-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[12] CLIPPED,
#           COLUMN 40,g_x[13] CLIPPED,
#No.FUN-540057--begin
#           COLUMN 50,g_x[26] CLIPPED,
#           COLUMN 66,g_x[27] CLIPPED,
#           COLUMN 83,g_x[14] CLIPPED,
#           COLUMN 123,g_x[15]  CLIPPED
#No.FUN-550030 start
#     PRINT '---------- ---------- ---------------- -------- ---------------- ',
#           '---- ---- ---- ------------------ ---------------- -------- ',
#           '------------------ ------------------'
#No.FUN-540057--end
#No.FUN-580010  --end
      LET l_last_sw = 'n'
      LET l_bal3 = 0   #TQC-610098
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.apa01
     #-----TQC-610098---------
     SELECT apa20,apa14 INTO l_apa20,l_apa14 FROM apa_file
        WHERE apa01=sr.apa01
     LET l_bal3 = l_apa20*l_apa14
     #LET l_bal = sr.apa34 - l_apa20*l_apa14   #MOD-720128
     LET l_bal = sr.apa34   #MOD-720128
     #-----END TQC-610098-----
      LET l_bal1= 0   #MOD-590440
      LET l_bal2= 0   #MOD-590440
      LET l_pay = 0
      LET l_cnt = 0
#No.FUN-580010  -begin
      PRINT COLUMN g_c[31],sr.apa06,
            COLUMN g_c[32],sr.apa07,
            COLUMN g_c[33],sr.apa01,
            COLUMN g_c[34],sr.apa02,
            COLUMN g_c[35],sr.apa08,
            COLUMN g_c[36],sr.apa00,
            COLUMN g_c[37],sr.apa36,
            COLUMN g_c[38],sr.apa13,
            COLUMN g_c[39],cl_numfor(sr.apa34,39,g_azi04) CLIPPED,
            COLUMN g_c[46],cl_numfor(l_apa20*l_apa14,46,g_azi04);   #TQC-610098
       #-----MOD-720128---------
       INSERT INTO curr_tmp1 VALUES(sr.apa06,sr.apa01,sr.apa02,sr.apa21,
                                    sr.apa13,sr.apa34,l_apa20*l_apa14,sr.order1,
                                    sr.order2,sr.order3)
       ##-----TQC-630250---------
       #LET g_amt1 = g_amt1 + sr.apa34
       #LET g_amt2 = g_amt2 + sr.apa34
       #LET g_amt3 = g_amt3 + sr.apa34
       #LET g_amt4 = g_amt4 + sr.apa34
       ##-----END TQC-630250-----
       #-----END MOD-720128-----
 
#     PRINT COLUMN 01,sr.apa06,
#           COLUMN 12,sr.apa07,
#           COLUMN 23,sr.apa01,
#           COLUMN 40,sr.apa02,
#           COLUMN 49,sr.apa08,
#           COLUMN 67,sr.apa00,
#           COLUMN 71,sr.apa36,
#           COLUMN 77,sr.apa13,
#           COLUMN 80,cl_numfor(sr.apa34,18,g_azi04) CLIPPED;
#No.FUN-580010  -end
   ON EVERY ROW
      LET l_bal = l_bal - sr.paymoney
      #No.MOD-590440 --start--
      IF sr.payno = 'DIFF' THEN
         LET sr.pay1 = 0
         LET l_bal1= l_bal1 - sr.paymoney
      ELSE
         LET l_bal1= sr.pay1 - l_bal2  - sr.paymoney
         LET sr.pay1 = sr.pay1 - l_bal2
      END IF
      #No.MOD-590440 --end--
      LET l_pay = l_pay + sr.paymoney
      LET l_cnt = l_cnt + 1
#No.FUN-580010  -begin
      PRINT COLUMN g_c[40],sr.payno,      #沖帳單號
            COLUMN g_c[41],sr.paydate,    #日期
            COLUMN g_c[42],cl_numfor(sr.paymoney,42,g_azi04) CLIPPED,
            COLUMN g_c[43],cl_numfor(l_bal,43,sr.azi05) CLIPPED,
            COLUMN g_c[44],cl_numfor(sr.pay1,44,sr.azi05) CLIPPED, #No.MOD-590440
            COLUMN g_c[45],cl_numfor(l_bal1,45,sr.azi05) CLIPPED   #No.MOD-590440
      LET l_bal2 = sr.paymoney        #No.MOD-590440
          IF sr.apa34 IS NULL   THEN LET sr.apa34="0" END IF   #add
          IF (l_apa20 OR l_apa14 ) IS NULL   THEN LET l_apa20="0" END IF  #add
      #-----MOD-720128---------
      INSERT INTO curr_tmp2 VALUES(sr.apa06,sr.apa01,sr.apa02,sr.apa21,
                                   sr.apa13,sr.paymoney,sr.order1,
                                   sr.order2,sr.order3)
      #-----END MOD-720128-----
#     PRINT COLUMN 100,sr.payno,      #沖帳單號
#           COLUMN 117,sr.paydate,    #日期
#           COLUMN 125,cl_numfor(sr.paymoney,18,g_azi04) CLIPPED,
#           COLUMN 143,cl_numfor(l_bal,18,sr.azi05) CLIPPED
#No.FUN-580010  -end
#No.FUN-550030 end
 
   AFTER GROUP OF sr.apa01
      IF l_cnt = 0 THEN PRINT ' ' END IF
      IF sr.apa35 + sr.apa65 != l_pay
      THEN PRINT g_x[25] CLIPPED,sr.apa35+sr.apa65
      END IF
 
#-----MOD-720128---------
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         DECLARE  curr_cs1 CURSOR FOR 
             SELECT apa13,SUM(apa34),SUM(apa20) FROM curr_tmp1
               WHERE order1=sr.order1 
               GROUP BY apa13
             PRINTX name=S1 COLUMN g_c[35], g_orderA[1] CLIPPED,g_x[23] CLIPPED;
         FOREACH curr_cs1 INTO sum_apa13,sum_apa34,sum_apa20
             PRINTX name=S1 COLUMN g_c[38],sum_apa13 CLIPPED, 
                            COLUMN g_c[39],cl_numfor(sum_apa34,39,g_azi05),
                            COLUMN g_c[46],cl_numfor(sum_apa20,46,g_azi05);
             SELECT SUM(amt1) INTO sum_amt1 FROM curr_tmp2
                WHERE order1=sr.order1 
                      AND apa13=sum_apa13
             PRINTX name=S1 COLUMN g_c[42],cl_numfor(sum_amt1,42,g_azi05),
                            COLUMN g_c[43],cl_numfor(sum_apa34-sum_amt1,43,g_azi05)
         END FOREACH
      END IF
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         DECLARE  curr_cs2 CURSOR FOR 
             SELECT apa13,SUM(apa34),SUM(apa20) FROM curr_tmp1
               WHERE order1=sr.order1 AND order2=sr.order2
               GROUP BY apa13
             PRINTX name=S1 COLUMN g_c[35], g_orderA[2] CLIPPED,g_x[22] CLIPPED;
         FOREACH curr_cs2 INTO sum_apa13,sum_apa34,sum_apa20
             PRINTX name=S1 COLUMN g_c[38],sum_apa13 CLIPPED, 
                            COLUMN g_c[39],cl_numfor(sum_apa34,39,g_azi05),
                            COLUMN g_c[46],cl_numfor(sum_apa20,46,g_azi05);
             SELECT SUM(amt1) INTO sum_amt1 FROM curr_tmp2
                WHERE order1=sr.order1 AND order2=sr.order2
                      AND apa13=sum_apa13
             PRINTX name=S1 COLUMN g_c[42],cl_numfor(sum_amt1,42,g_azi05),
                            COLUMN g_c[43],cl_numfor(sum_apa34-sum_amt1,43,g_azi05)
         END FOREACH
      END IF
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         DECLARE  curr_cs3 CURSOR FOR 
             SELECT apa13,SUM(apa34),SUM(apa20) FROM curr_tmp1
               WHERE order1=sr.order1 AND order2=sr.order2 AND order3=sr.order3
               GROUP BY apa13
             PRINTX name=S1 COLUMN g_c[35], g_orderA[3] CLIPPED,g_x[21] CLIPPED;
         FOREACH curr_cs3 INTO sum_apa13,sum_apa34,sum_apa20
             PRINTX name=S1 COLUMN g_c[38],sum_apa13 CLIPPED, 
                            COLUMN g_c[39],cl_numfor(sum_apa34,39,g_azi05),
                            COLUMN g_c[46],cl_numfor(sum_apa20,46,g_azi05);
             SELECT SUM(amt1) INTO sum_amt1 FROM curr_tmp2
                WHERE order1=sr.order1 AND order2=sr.order2 AND order3=sr.order3
                      AND apa13=sum_apa13
             PRINTX name=S1 COLUMN g_c[42],cl_numfor(sum_amt1,42,g_azi05),
                            COLUMN g_c[43],cl_numfor(sum_apa34-sum_amt1,43,g_azi05)
         END FOREACH
      END IF
   ON LAST ROW
     
      DECLARE  curr_cs4 CURSOR FOR 
          SELECT apa13,SUM(apa34),SUM(apa20) FROM curr_tmp1
            GROUP BY apa13
          PRINTX name=S1 COLUMN g_c[35],g_x[24] CLIPPED;
      FOREACH curr_cs4 INTO sum_apa13,sum_apa34,sum_apa20
          PRINTX name=S1 COLUMN g_c[38],sum_apa13 CLIPPED, 
                         COLUMN g_c[39],cl_numfor(sum_apa34,39,g_azi05),
                         COLUMN g_c[46],cl_numfor(sum_apa20,46,g_azi05);
             SELECT SUM(amt1) INTO sum_amt1 FROM curr_tmp2
                WHERE apa13=sum_apa13
             PRINTX name=S1 COLUMN g_c[42],cl_numfor(sum_amt1,42,g_azi05),
                            COLUMN g_c[43],cl_numfor(sum_apa34-sum_amt1,43,g_azi05)
      END FOREACH
 
{
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         #LET l_amt_1 = GROUP SUM(sr.apa34) WHERE sr.payno != 'DIFF'   #No.MOD-590440   #TQC-630250
         LET l_amt_1 = g_amt1  #TQC-630250
         IF l_amt_1 IS NULL OR l_amt_1 = ' ' THEN LET l_amt_1 = 0 END IF
         LET l_amt_2 = GROUP SUM(sr.paymoney)
         IF l_amt_2 IS NULL OR l_amt_2 = ' ' THEN LET l_amt_2 = 0 END IF
         #-----TQC-610098---------
         LET l_amt_3 = GROUP SUM(l_bal3)
         IF l_amt_3 IS NULL OR l_amt_3 = ' ' THEN LET l_amt_3 = 0 END IF
         LET l_amt_bal = l_amt_1 - l_amt_2 - l_amt_3
         #LET l_amt_bal = l_amt_1 - l_amt_2
         #-----TQC-610098---------
#No.FUN-580010  -begin
         PRINTX name=S1 COLUMN g_c[35], g_orderA[1] CLIPPED,g_x[23] CLIPPED,
                        COLUMN g_c[39], cl_numfor(l_amt_1,39,g_azi05) CLIPPED,
                        COLUMN g_c[46], cl_numfor(l_amt_3,46,g_azi05) CLIPPED,   #TQC-610098
                        COLUMN g_c[42], cl_numfor(l_amt_2,42,g_azi05) CLIPPED,
                        COLUMN g_c[43], cl_numfor(l_amt_bal,43,g_azi05) CLIPPED
#        PRINT COLUMN 60, g_orderA[1] CLIPPED,g_x[23] CLIPPED,
#              COLUMN 74, cl_numfor(l_amt_1,18,g_azi05) CLIPPED,
#              COLUMN 113, cl_numfor(l_amt_2,18,g_azi05) CLIPPED,
#              COLUMN 132, cl_numfor(l_amt_bal,18,g_azi05) CLIPPED
#No.FUN-580010  -end
      END IF
      LET g_amt1 = 0   #TQC-630250
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         #LET l_amt_1 = GROUP SUM(sr.apa34) WHERE sr.payno != 'DIFF'   #No.MOD-590440   #TQC-630250
         LET l_amt_1 = g_amt2  #TQC-630250
         IF l_amt_1 IS NULL OR l_amt_1 = ' ' THEN LET l_amt_1 = 0 END IF
         LET l_amt_2 = GROUP SUM(sr.paymoney)
         IF l_amt_2 IS NULL OR l_amt_2 = ' ' THEN LET l_amt_2 = 0 END IF
         #-----TQC-610098---------
         LET l_amt_3 = GROUP SUM(l_bal3)
         IF l_amt_3 IS NULL OR l_amt_3 = ' ' THEN LET l_amt_3 = 0 END IF
         LET l_amt_bal = l_amt_1 - l_amt_2 - l_amt_3
         #LET l_amt_bal = l_amt_1 - l_amt_2
         #-----TQC-610098---------
#No.FUN-580010  -begin
         PRINTX name=S2 COLUMN g_c[35], g_orderA[2] CLIPPED,g_x[22] CLIPPED,
                        COLUMN g_c[39], cl_numfor(l_amt_1,39,g_azi05) CLIPPED,
                        COLUMN g_c[46], cl_numfor(l_amt_3,46,g_azi05) CLIPPED,   #TQC-610098
                        COLUMN g_c[42], cl_numfor(l_amt_2,42,g_azi05) CLIPPED,
                        COLUMN g_c[43], cl_numfor(l_amt_bal,43,g_azi05) CLIPPED
#        PRINT COLUMN 60, g_orderA[2] CLIPPED,g_x[22] CLIPPED,
#              COLUMN 74, cl_numfor(l_amt_1,18,g_azi05) CLIPPED,
#              COLUMN 113, cl_numfor(l_amt_2,18,g_azi05) CLIPPED,
#              COLUMN 132, cl_numfor(l_amt_bal,18,g_azi05) CLIPPED
#No.FUN-580010  -end
      END IF
      LET g_amt2 = 0   #TQC-630250
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         #LET l_amt_1 = GROUP SUM(sr.apa34) WHERE sr.payno != 'DIFF'   #No.MOD-590440   #TQC-630250
         LET l_amt_1 = g_amt3  #TQC-630250
         IF l_amt_1 IS NULL OR l_amt_1 = ' ' THEN LET l_amt_1 = 0 END IF
         LET l_amt_2 = GROUP SUM(sr.paymoney)
         IF l_amt_2 IS NULL OR l_amt_2 = ' ' THEN LET l_amt_2 = 0 END IF
         #-----TQC-610098---------
         LET l_amt_3 = GROUP SUM(l_bal3)
         IF l_amt_3 IS NULL OR l_amt_3 = ' ' THEN LET l_amt_3 = 0 END IF
         LET l_amt_bal = l_amt_1 - l_amt_2 - l_amt_3
         #LET l_amt_bal = l_amt_1 - l_amt_2
         #-----TQC-610098---------
#No.FUN-580010  -begin
         PRINTX name=S3 COLUMN g_c[35], g_orderA[3] CLIPPED,g_x[21] CLIPPED,
                        COLUMN g_c[39], cl_numfor(l_amt_1,39,g_azi05) CLIPPED,
                        COLUMN g_c[46], cl_numfor(l_amt_3,46,g_azi05) CLIPPED,   #TQC-610098
                        COLUMN g_c[42], cl_numfor(l_amt_2,42,g_azi05) CLIPPED,
                        COLUMN g_c[43], cl_numfor(l_amt_bal,43,g_azi05) CLIPPED
#        PRINT COLUMN 60, g_orderA[3] CLIPPED, g_x[21] CLIPPED,
#              COLUMN 74, cl_numfor(l_amt_1,18,g_azi05) CLIPPED,
#              COLUMN 113, cl_numfor(l_amt_2,18,g_azi05) CLIPPED,
#              COLUMN 132, cl_numfor(l_amt_bal,18,g_azi05) CLIPPED
#No.FUN-580010  -end
      END IF
      LET g_amt3 = 0   #TQC-630250
 
   ON LAST ROW
      #LET l_amt_1 = SUM(sr.apa34) WHERE sr.payno != 'DIFF'   #No.MOD-59044   #TQC-630250
      LET l_amt_1 = g_amt4  #TQC-630250
      IF l_amt_1 IS NULL OR l_amt_1 = ' ' THEN LET l_amt_1 = 0 END IF
      LET l_amt_2 = SUM(sr.paymoney)
      IF l_amt_2 IS NULL OR l_amt_2 = ' ' THEN LET l_amt_2 = 0 END IF
      #-----TQC-610098---------
      LET l_amt_3 = GROUP SUM(l_bal3)
      IF l_amt_3 IS NULL OR l_amt_3 = ' ' THEN LET l_amt_3 = 0 END IF
      LET l_amt_bal = l_amt_1 - l_amt_2 - l_amt_3
      #LET l_amt_bal = l_amt_1 - l_amt_2
      #-----TQC-610098---------
#No.FUN-580010  -begin
      PRINTX name=S4 COLUMN g_c[35], g_x[24] CLIPPED,
                     COLUMN g_c[39], cl_numfor(l_amt_1,39,g_azi05) CLIPPED,
                     COLUMN g_c[46], cl_numfor(l_amt_3,46,g_azi05) CLIPPED,   #TQC-610098
                     COLUMN g_c[42], cl_numfor(l_amt_2,42,g_azi05) CLIPPED,
                     COLUMN g_c[43], cl_numfor(l_amt_bal,43,g_azi05) CLIPPED
#     PRINT COLUMN 60, g_x[24] CLIPPED,
#           COLUMN 74, cl_numfor(l_amt_1,18,g_azi05) CLIPPED,
#           COLUMN 113,cl_numfor(l_amt_2,18,g_azi05) CLIPPED,
#           COLUMN 132,cl_numfor(l_amt_bal,18,g_azi05) CLIPPED
#No.FUN-580010  -end
}
#-----END MOD-720128-----
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash
         #TQC-630166
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         eLSE SKIP 2 LINE
      END IF
END REPORT
