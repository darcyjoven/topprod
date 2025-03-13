# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr380.4gl
# Descriptions...: 應收帳款重評價表
# Date & Author..: 02/09/02 By Joe
# Modify by......: 05/04/11 By vivien
# Modify.........: No.FUN-550119 05/06/01 By Smapmin 新增INPUT "匯率選項"
# Modify.........: No.MOD-560008 05/06/02 By Smapmin DEFINE單價,金額,匯率
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.TQC-5B0042 05/11/08 By kim 評價後匯率的內容往後印，造成整行內容超出表頭長度
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6B0190 06/12/04 By Smapmin 增加報表列印條件
# Modify.........: No.TQC-770028 07/07/05 By Rayven 制表日期與報表名稱所在的行數顛倒
# Modify.........: No.TQC-790092 07/09/14 By rainy 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-7B0026 07/11/19 By Lutingting 修改為用Crystal Report 輸出
# Modify.........: No.MOD-810095 08/01/16 By Smapmin 修改欄位打錯;修改幣別取位
# Modify.........: No.MOD-830177 08/03/24 By Smapmin 修改尾差一元問題/待抵類的也要納入
# Modify.........: No.MOD-880072 08/08/13 By Sarah 增加occ40(月底重評價)判斷
# Modify.........: No.MOD-8B0008 08/11/04 By Sarah sr.omb16t的計算公式改為sr.oma56t-l_oob10
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.MOD-940279 09/04/21 By lilingyu l_sql 改成OUTER的串法
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:MOD-A40055 10/04/12 BY Dido 若為預收則須再讀取 oma_file 
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_oma24應給予預設值'',抓不到值不可為'1'
# Modify.........: No:FUN-B20019 11/02/11 By yinhy SQL增加ooa37='1'的条件
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                               # Print condition RECORD
              wc     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)  #TQC-5A0134 VARCHAR-->CHAR # Where condition
              bdate  LIKE type_file.dat,           #No.FUN-680123 DATE
              edate  LIKE type_file.dat,           #No.FUN-680123,DATE
              rate_op LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01) #FUN-550119
              type    LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)  #TQC-5A0134 VARCHAR-->CHAR
              sort    LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)  #TQC-5A0134 VARCHAR-->CHAR
  ##NO.FUN-A10098  mark--begin
#              p1      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p2      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p3      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p4      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p5      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p6      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p7      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
#              p8      LIKE azp_file.azp01,         #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
  ##NO.FUN-A10098  mark--end
              more    LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01) #TQC-5A0134 VARCHAR-->CHAR             # Input more condition(Y/N)
              END RECORD,
          g_yy,g_mm     LIKE type_file.num5        #No.FUN-680123 SMALLINT
  ##NO.FUN-A10098  mark--begin
#         m_dbs         ARRAY[10] OF LIKE type_file.chr20        #No.FUN-680123 ARRAY[10] OF VARCHAR(20) #TQC-5A0134 VARCHAR-->CHAR
  ##NO.FUN-A10098  mark--end
DEFINE    g_title       LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(160)  #TQC-5A0134 VARCHAR-->CHAR
DEFINE    g_i           LIKE type_file.num5        #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE    i             LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE    g_str         STRING                     #No.FUN-7B0026
DEFINE    g_sql         STRING                     #No.FUN-7B0026
DEFINE    l_table       STRING                     #No.FUN-7B0026
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
   LET g_sql="oma02.oma_file.oma02,   oma03.oma_file.oma03,",
             "oma032.oma_file.oma032, oma14.oma_file.oma14,",
             "gen02.gen_file.gen02,   azi03.azi_file.azi03,",
             "azi04.azi_file.azi04,   azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,   ofa01.ofa_file.ofa01,",
             "ofa02.ofa_file.ofa02,   oma01.oma_file.oma01,",
             "oma16.oma_file.oma16,   oma23.oma_file.oma23,",
             "oma24.oma_file.oma24,   oma54t.oma_file.oma54t,",
             "omb14t.omb_file.omb14t, omb16t.omb_file.omb16t,",
             "oag02.oag_file.oag02,   oma11.oma_file.oma11,",
             "oma10.oma_file.oma10,   new_ex.omb_file.omb36,",
             "omb16t_a.omb_file.omb16,diff.omb_file.omb16,",
             "azi04_1.azi_file.azi04, azi05_1.azi_file.azi05"  #MOD-810095
 
   LET l_table =  cl_prt_temptable('axrr380',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?)"   #MOD-810095 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.rate_op = ARG_VAL(10)
   LET tm.type = ARG_VAL(11)
   LET tm.sort = ARG_VAL(12)
  ##NO.FUN-A10098  mark--begin
#   LET tm.p1 = ARG_VAL(13)
#   LET tm.p2 = ARG_VAL(14)
#   LET tm.p3 = ARG_VAL(15)
#   LET tm.p4 = ARG_VAL(16)
#   LET tm.p5 = ARG_VAL(17)
#   LET tm.p6 = ARG_VAL(18)
#   LET tm.p7 = ARG_VAL(19)
#   LET tm.p8 = ARG_VAL(20)
  ##NO.FUN-A10098  mark--end   
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   IF cl_null(tm.wc)
      THEN CALL r380_tm(0,0)             # Input print condition
   ELSE 
      CALL r380()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r380_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #TQC-5A0134 VARCHAR-->CHAR #No.FUN-680123 VARCHAR(1000)
   DEFINE l_n            LIKE type_file.num5           #No.FUN-680123 SMALLINT
 
   LET p_row = 2 LET p_col = 10
 
   OPEN WINDOW r380_w AT p_row,p_col
        WITH FORM "axr/42f/axrr380"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.edate = today
   LET tm.rate_op = 'B'   #FUN-550119
#  LET tm.p1 = g_plant    #NO.FUN-A10098
   LET tm.type = '3'
   LET tm.sort = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma01,ogb04,oma00,oma18, oma10,  oma03,
                              omauser,oma14
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
       ON ACTION locale
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
      LET INT_FLAG = 0 CLOSE WINDOW r380_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.rate_op,tm.type,tm.sort,
  ##NO.FUN-A10098  mark--begin

#                tm.p1,tm.p2,tm.p3,   #FUN-550119
#                tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,
  ##NO.FUN-A10098  mark--end
                 tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD edate
         IF tm.bdate > tm.edate THEN
            NEXT FIELD edate
         END IF
  ##NO.FUN-A10098  mark--begin
#      AFTER FIELD p1
#         IF NOT cl_null(tm.p1) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p1 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p1) THEN
#               NEXT FIELD p1
#            END IF            
#         END IF
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p2 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#         END IF
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p3 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#         END IF
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p4 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#         END IF
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p5 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#         END IF
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p6 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#         END IF
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p7 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#         END IF
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)    #No.FUN-660116
#               NEXT FIELD p8 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#         END IF
  ##NO.FUN-A10098  mark--end
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
 
      ON ACTION CONTROLP
  ##NO.FUN-A10098  mark--begin
#         CASE
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#         END CASE
  ##NO.FUN-A10098  mark--end
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r380_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr380'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr380','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.rate_op CLIPPED,"'",   #TQC-610059
                         " '",tm.type CLIPPED,"'" ,
                         " '",tm.sort CLIPPED,"'" ,
  ##NO.FUN-A10098  mark--begin
#                         " '",tm.p1 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p2 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p3 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p4 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p5 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p6 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p7 CLIPPED,"'",   #TQC-610059
#                         " '",tm.p8 CLIPPED,"'",   #TQC-610059
  ##NO.FUN-A10098  mark--end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr380',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r380_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r380()
   ERROR ""
END WHILE
   CLOSE WINDOW r380_w
END FUNCTION
 
FUNCTION r380()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680123 VARCHAR(20)  #TQC-5A0134 VARCHAR-->CHAR # External(Disk) file name
          l_sql     LIKE type_file.chr1000,      #TQC-5A0134 VARCHAR-->CHAR  #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(40)  #TQC-5A0134 VARCHAR-->CHAR
          l_sort    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(200) #TQC-5A0134 VARCHAR-->CHAR
          l_dbs     LIKE azp_file.azp03,
          l_oob09   LIKE oob_file.oob09,
          l_oob10   LIKE oob_file.oob10,
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_oga011  LIKE oga_file.oga011,         #FUN-550119
          sr        RECORD
                    order1   LIKE   oma_file.oma03,  #No.FUN-680123 VARCHAR(10)  #TQC-5A0134 VARCHAR-->CHAR
                    order2   LIKE   oma_file.oma03,  #No.FUN-680123 VARCHAR(10) #TQC-5A0134 VARCHAR-->CHAR
                    oma00    LIKE   oma_file.oma00,          #帳款類別
                    oma01    LIKE   oma_file.oma01,          #帳款單號
                    oma03    LIKE   oma_file.oma03,          #帳款客戶編號
                    oma032   LIKE   oma_file.oma032,         #客戶簡稱
                    oma08    LIKE   oma_file.oma08,          #內外銷
                    oma10    LIKE   oma_file.oma10,          #發票號碼
                    oma14    LIKE   oma_file.oma14,          #業務員
                    oma23    LIKE   oma_file.oma23,          #幣別
                    oma24    LIKE   oma_file.oma24,          #匯率
                    oma39    LIKE   oma_file.oma39,          #INVOICE
                    oma40    LIKE   oma_file.oma40,          #非,關係人
                    omaconf  LIKE   oma_file.omaconf,        #確認否
                    omavoid  LIKE   oma_file.omavoid,        #作廢否
                    occ37    LIKE   occ_file.occ37,
                    occ40    LIKE   occ_file.occ40,          #月底重評價  #MOD-880072 add
                    omb14t   LIKE   omb_file.omb14t,         #原幣含稅金額
                    omb16t   LIKE   omb_file.omb16t,         #本幣含稅金額
                    oma02    LIKE   oma_file.oma02,          #立帳日
                    ofa01    LIKE   ofa_file.ofa01,          #Inv No.add
                    ofa02    LIKE   ofa_file.ofa02,          #Inv Date.add
                    oma16    LIKE   oma_file.oma16,          #訂單編號   #FUN-550119
                    oma54t   LIKE   oma_file.oma54t,         #應收帳款.add
                    oag02    LIKE   oag_file.oag02,          #付款條件.add
                    oma11    LIKE   oma_file.oma11,          #到期日.add
                    new_ex   LIKE   omb_file.omb37,          #No.FUN-680123 DEC(20,10) #評價後匯率 #FUN-550119
                    omb16t_a LIKE   omb_file.omb16,          #評價後NT金額.add
                    diff     LIKE   omb_file.omb16,          #匯兌損益.add
                    oma56t   LIKE   oma_file.oma56t,         #應收款L
                    oma66    LIKE   oma_file.oma66 
              END RECORD
     DEFINE l_gen02 LIKE gen_file.gen02                      #No.FUN-7B0026
     DEFINE l_oox01   STRING                 #CHI-830003 add
     DEFINE l_oox02   STRING                 #CHI-830003 add
     DEFINE l_str_1   STRING                 #CHI-830003 add
     DEFINE l_sql_1   STRING                 #CHI-830003 add
     DEFINE l_sql_2   STRING                 #CHI-830003 add
     DEFINE l_omb03_1 LIKE omb_file.omb03    #CHI-830003 add
     DEFINE l_count   LIKE type_file.num5    #CHI-830003 add
     DEFINE l_oma24   LIKE oma_file.oma24    #CHI-830003 add     
        
     CALL cl_del_data(l_table)                                        #No.FUN-7B0026
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr380'      #No.FUN-7B0026
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
 
     LET g_yy = YEAR(tm.bdate)
     LET g_mm = MONTH(tm.bdate)
  ##NO.FUN-A10098  mark--begin
#     FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#     LET m_dbs[1]=tm.p1
#     LET m_dbs[2]=tm.p2
#     LET m_dbs[3]=tm.p3
#     LET m_dbs[4]=tm.p4
#     LET m_dbs[5]=tm.p5
#     LET m_dbs[6]=tm.p6
#     LET m_dbs[7]=tm.p7
#     LET m_dbs[8]=tm.p8
  ##NO.FUN-A10098  mark--end
 
    IF tm.sort = '1' THEN
        LET l_sort = " ORDER BY oma40,oma03,oma14,oma02"    #FUN-550119
    ELSE
        IF tm.sort = '2' THEN
        LET l_sort = " ORDER BY oma40,oma14,oma03,oma02"      #FUN-550119
    ELSE
        IF tm.sort = '3' THEN
        LET l_sort = " ORDER BY oma40,oma23,oma11"
        END IF
        END IF
    END IF

 
#     FOR l_i = 1 to 8
#         IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF
#         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]
#         LET l_dbs = s_dbstring(l_dbs CLIPPED)
         LET l_sql = " SELECT DISTINCT '','',oma00,oma01, ",  #FUN-550119
                     " oma03,oma032,oma08,oma10,oma14,oma23,oma24,oma39, ",
                     " oma40,omaconf,omavoid,occ37,occ40,",   #MOD-880072 add occ40
                     " '','',oma02,'','',oma16,oma54t,oag02,oma11,0,0,0, ",     #FUN-550119
                     " oma56t ",
#                    " FROM ",l_dbs CLIPPED," occ_file,",
#                              l_dbs CLIPPED," oma_file ",   #MOD-940279
#                             " LEFT OUTER JOIN ",l_dbs CLIPPED," oag_file ON oma32=oag01 ",
                     " FROM occ_file,oma_file LEFT OUTER JOIN ",cl_get_target_table(g_plant, 'oag_file')," ON oma32=oag01",
                     " WHERE oma03 = occ01 ",
                     " AND oma23 <> '",g_aza.aza17,"'",
                     " AND (oma00 LIKE '1%' OR oma00 LIKE '2%')",   #MOD-830177
                     " AND omaconf = 'Y' AND omavoid = 'N' ",
                     " AND oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                     " AND ",tm.wc CLIPPED,l_sort CLIPPED
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE r380_prepare1 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM 
         END IF
 
         DECLARE r380_curs1 CURSOR FOR r380_prepare1
 
         FOREACH r380_curs1 INTO sr.*
           IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) 
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
              EXIT PROGRAM 
           END IF
           IF sr.occ40='N' THEN CONTINUE FOREACH END IF   #MOD-880072 add
           
           IF g_ooz.ooz07 = 'Y' THEN
             LET l_oox01 = YEAR(tm.edate)
             LET l_oox02 = MONTH(tm.edate)                      	 
             LET l_oma24 = ''    #TQC-B10083 add
              WHILE cl_null(l_oma24)
                 IF g_ooz.ooz62 = 'N' THEN
                    LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                                  " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                                  "   AND oox02 <= '",l_oox02,"'",
                                  "   AND oox03 = '",sr.oma01,"'",
                                  "   AND oox04 = '0'"
                    PREPARE r380_prepare7 FROM l_sql_2
                    DECLARE r380_oox7 CURSOR FOR r380_prepare7
                    OPEN r380_oox7
                    FETCH r380_oox7 INTO l_count
                    CLOSE r380_oox7                       
                    IF l_count = 0 THEN
                       #LET l_oma24 = '1'   #TQC-B10083 mark 
                       EXIT WHILE           #TQC-B10083 add
                    ELSE                  
                       LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                     " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                     "   AND oox02 = '",l_oox02,"'",
                                     "   AND oox03 = '",sr.oma01,"'",
                                     "   AND oox04 = '0'"
                    END IF                 
                 ELSE
                    LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                                  " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                                  "   AND oox02 <= '",l_oox02,"'",
                                  "   AND oox03 = '",sr.oma01,"'",
                                  "   AND oox04 <> '0'"
                    PREPARE r380_prepare8 FROM l_sql_2
                    DECLARE r380_oox8 CURSOR FOR r380_prepare8
                    OPEN r380_oox8
                    FETCH r380_oox8 INTO l_count
                    CLOSE r380_oox8                       
                    IF l_count = 0 THEN
                       #LET l_oma24 = '1'   #TQC-B10083 mark 
                       EXIT WHILE           #TQC-B10083 add 
                    ELSE            
                       SELECT MIN(omb03) INTO l_omb03_1 FROM omb_file
                        WHERE omb01 = sr.oma01
                       IF cl_null(l_omb03_1) THEN
                          LET l_omb03_1 = 0
                       END IF       
                       LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                     " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                     "   AND oox02 = '",l_oox02,"'",
                                     "   AND oox03 = '",sr.oma01,"'",
                                     "   AND oox04 = '",l_omb03_1,"'"                                      
                    END IF
                 END IF   
                 IF l_oox02 = '01' THEN
                    LET l_oox02 = '12'
                    LET l_oox01 = l_oox01-1
                 ELSE    
                    LET l_oox02 = l_oox02-1
                 END IF            
            
                 IF l_count <> 0 THEN        
                    PREPARE r380_prepare07 FROM l_sql_1
                    DECLARE r380_oox07 CURSOR FOR r380_prepare07
                    OPEN r380_oox07
                    FETCH r380_oox07 INTO l_oma24
                    CLOSE r380_oox07
                 END IF              
              END WHILE              
           END IF
           
          #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN           #TQC-B10083 mark
          IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN    #TQC-B10083 mod
             LET sr.oma56t = sr.oma54t * l_oma24
          END IF    
           
           LET g_plant_new=sr.oma66
           CALL s_getdbs()
           LET l_sql =
               "SELECT ofa01,ofa02 ",
  ##NO.FUN-A10098  mark--begin
#              "  FROM ",g_dbs_new CLIPPED,"ofa_file,",
#              "       ",g_dbs_new CLIPPED,"oga_file ",
               "  FROM ", cl_get_target_table(sr.oma66, 'ofa_file'),",",
               cl_get_target_table(sr.oma66, 'oga_file'),
  ##NO.FUN-A10098  mark--end
               " WHERE oga01 = '",sr.oma16,"' ",
               "   AND ofa011= oga011 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           PREPARE r380_pb1 FROM l_sql
           DECLARE r380_bcs1 CURSOR FOR r380_pb1
           OPEN r380_bcs1
           FETCH r380_bcs1 INTO sr.ofa01,sr.ofa02
           IF SQLCA.sqlcode THEN
              LET sr.ofa01=''
              LET sr.ofa02=''
           END IF
 
           LET sr.oma40 = sr.occ37
           IF cl_null(sr.oma40) THEN LET sr.occ37 = 'N' END IF
           IF tm.type = '1' THEN
               IF sr.occ37  = 'N' THEN  CONTINUE FOREACH END IF
           END IF
           IF tm.type = '2' THEN   #非關係人
               IF sr.occ37  = 'Y' THEN  CONTINUE FOREACH END IF
           END IF
 
         IF sr.oma00 MATCHES '1*' THEN   #MOD-830177 
            SELECT sum(oob09),sum(oob10) INTO l_oob09,l_oob10
              FROM oob_file,ooa_file
              WHERE oob03 = '2' AND oob04 = '1'
                AND oob01 = ooa01 AND oob06 = sr.oma01
                AND ooa02 <= tm.edate AND ooaconf = 'Y'
                AND ooa37 = '1'   #FUN-B20019 add
         ELSE
            SELECT sum(oob09),sum(oob10) INTO l_oob09,l_oob10
              FROM oob_file,ooa_file
              WHERE oob03 = '1' AND oob04 = '3'
                AND oob01 = ooa01 AND oob06 = sr.oma01
                AND ooa02 <= tm.edate AND ooaconf = 'Y'
                AND ooa37 = '1'   #FUN-B20019 add
         END IF
        #-MOD-A40055-add-
         IF sr.oma00 MATCHES '23' THEN   
            SELECT sum(oma52),sum(oma53) INTO l_oob09,l_oob10
              FROM oma_file
              WHERE oma19 = sr.oma01 AND oma02 <= tm.edate 
                AND omaconf <> 'X' 
            IF l_oob09 = sr.oma54t THEN CONTINUE FOREACH END IF 
         END IF 
        #-MOD-A40055-end-
         IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
         IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
         #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN             #TQC-B10083 mark
         IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN      #TQC-B10083 mod
            LET l_oob10 = l_oob09 * l_oma24
         END IF    
         IF l_oob10 >= sr.oma56t THEN CONTINUE FOREACH END IF    #MOD-810095
         LET sr.omb14t = sr.oma54t - l_oob09
         LET sr.omb16t = sr.oma56t - l_oob10    #MOD-8B0008
         CALL s_curr3(sr.oma23,tm.edate,tm.rate_op) RETURNING sr.new_ex  #FUN-550119
         LET sr.omb16t_a=sr.omb14t * sr.new_ex
         LET sr.omb16t_a = cl_digcut( sr.omb16t_a,g_azi04) #MOD-830177
         LET sr.omb16t = cl_digcut( sr.omb16t,g_azi04)     #MOD-830177
         LET sr.diff = sr.omb16t_a - sr.omb16t              #no.5196
         IF sr.oma00 MATCHES '2*' THEN
            LET sr.oma54t = sr.oma54t * -1
            LET sr.omb14t = sr.omb14t * -1
            LET sr.omb16t = sr.omb16t * -1
            LET sr.omb16t_a = sr.omb16t_a * -1
            LET sr.diff = sr.diff * -1
         END IF
 
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oma14
          SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
                 FROM azi_file
                 WHERE azi01=sr.oma23
          EXECUTE insert_prep USING
               sr.oma02,sr.oma03,sr.oma032,sr.oma14,l_gen02,t_azi03,t_azi04,
               t_azi05,t_azi07,sr.ofa01,sr.ofa02,sr.oma01,sr.oma16,sr.oma23,
               sr.oma24,sr.oma54t,sr.omb14t,sr.omb16t,sr.oag02,sr.oma11,
               sr.oma10,sr.new_ex,sr.omb16t_a,sr.diff,g_azi04,g_azi05   #MOD-810095
    END FOREACH                                                                                                            
#   END FOR 
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED
      IF g_zz05='Y' THEN 
         CALL cl_wcchp(tm.wc,'oma01,ogb04,oma00,oma18,oma10,oma03,omauser,oma14')
             RETURNING tm.wc
             LET g_str=tm.wc
      END IF
      LET g_str = g_str,";",tm.sort,";",tm.type,";",tm.bdate,";",tm.edate
      CALL cl_prt_cs3('axrr380','axrr380',g_sql,g_str)
END FUNCTION
#No.FUN-9C0072 精簡程式碼
 
