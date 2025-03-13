# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amdr101.4gl(仿amdr100.4gl)
# Descriptions...: 進項憑証明細表列印作業
# Date & Author..: 01/08/03  By  Chien
# Modify.........: No.MOD-530088 05/03/14 By cate 報表標題標準化
# Modify.........: No.FUN-560247 05/06/29 By jackie 單據編號修改
# Modify.........: No.FUN-580010 05/08/08 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.MOD-660059 06/06/15 By Smapmin 修改最後一頁小計中顯示的資料
# Modify.........: No.FUN-660060 06/06/26 By rainy 期間置於中間
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-850053 08/05/14 By sherry 報表改由CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A80039 10/09/09 By Summer 在QBE增加amd22(申報部門),要有開窗功能q_amd
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
            amd173_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
            amd174_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER 
            amd173_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER 
            amd174_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER 
            s           LIKE type_file.chr3,       #No.FUN-680074 VARCHAR(3)
            t           LIKE type_file.chr3,       #No.FUN-680074 VARCHAR(3)
            u           LIKE type_file.chr3,       #No.FUN-680074 VARCHAR(3)
            f           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
            x           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
            more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD
DEFINE g_ary  DYNAMIC ARRAY OF RECORD
              mony  LIKE amd_file.amd08,
              tax   LIKE amd_file.amd07,
              cnt   LIKE type_file.num5            #No.FUN-680074 SMALLINT
           END RECORD
DEFINE g_amd08 LIKE amd_file.amd08
DEFINE g_amd07 LIKE amd_file.amd07
DEFINE l_cnt        LIKE type_file.num5            #No.FUN-680074 SMALLINT
DEFINE g_title      LIKE zaa_file.zaa08            #No.FUN-680074 VARCHAR(30)
 
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose        #No.FUN-680074 SMALLINT
#No.FUN-850053---Begin                                                  
DEFINE g_sql       STRING                                               
DEFINE g_str       STRING                                               
DEFINE l_table     STRING                                               
#No.FUN-850053---End  
 
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
 
   #No.FUN-850053---Begin                                                       
   LET g_sql = "l_no.type_file.num5,",
               "l_ser.type_file.num5,",
               "amd28.amd_file.amd28,",                                         
               "amd01.amd_file.amd01,",                                         
               "amd03.amd_file.amd03,",                                         
               "amd05.amd_file.amd05,",                                         
               "amd171.amd_file.amd171,",                                       
               "amd173.amd_file.amd173,",                                       
               "amd174.amd_file.amd174,",                                       
               "amd04.amd_file.amd04,",                                         
               "amd08.amd_file.amd08,",                                         
               "amd172.amd_file.amd172,",                                       
               "amd07.amd_file.amd07,",                                         
               "amd17.amd_file.amd17,",                                         
               "g_mony_1.amd_file.amd08,",                                      
               "g_mony_2.amd_file.amd08,",                                      
               "g_mony_3.amd_file.amd08,",                                      
               "g_mony_4.amd_file.amd08,",                                      
               "g_mony_5.amd_file.amd08,",                                      
               "g_mony_6.amd_file.amd08,",                                      
               "g_mony_7.amd_file.amd08,",                                      
               "g_mony_8.amd_file.amd08,",  
               "g_mony_9.amd_file.amd08,",                                      
               "g_mony_10.amd_file.amd08,",                                     
               "g_mony_11.amd_file.amd08,",                                     
               "g_mony_12.amd_file.amd08,",                                     
               "g_tax_1.amd_file.amd07,",                                       
               "g_tax_4.amd_file.amd07,",                                       
               "g_tax_7.amd_file.amd07,",                                       
               "g_tax_10.amd_file.amd07,",                                      
               "g_cnt_1.type_file.num5,",                                       
               "g_cnt_2.type_file.num5,",                                       
               "g_cnt_3.type_file.num5,",                                       
               "g_cnt_4.type_file.num5,",                                       
               "g_cnt_5.type_file.num5,",                                       
               "g_cnt_6.type_file.num5,",                                       
               "g_cnt_7.type_file.num5,",                                       
               "g_cnt_8.type_file.num5,",                                       
               "g_cnt_9.type_file.num5,",                                       
               "g_cnt_10.type_file.num5,",                                      
               "g_cnt_11.type_file.num5,",                                      
               "g_cnt_12.type_file.num5"      
 
   LET l_table = cl_prt_temptable('amdr101',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",           
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?  )"           
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-850053---End         
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.amd173_b = ARG_VAL(7)
   LET tm.amd174_b = ARG_VAL(8)
   LET tm.amd173_e = ARG_VAL(9)
   LET tm.amd174_e = ARG_VAL(10)
   LET tm.s = ARG_VAL(11)
   LET tm.t = ARG_VAL(12)
   LET tm.u = ARG_VAL(13)
   LET tm.f = ARG_VAL(14)
#-----TQC-610057---------
   LET tm.wc = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
#-----END TQC-610057-----
 
   LET g_amd08 = 0
   LET g_amd07 = 0
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r101_tm(0,0)
      ELSE CALL r101()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r101_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r101_w AT p_row,p_col
        WITH FORM "amd/42f/amdr101"
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
   LET tm.s='123'
   LET tm.u='Y'
   LET tm.f ='3'
   LET tm.amd173_b = YEAR(g_today)
   LET tm.amd174_b = MONTH(g_today) - 1
   LET tm.amd173_e = YEAR(g_today)
   LET tm.amd174_e = MONTH(g_today) - 1
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc
       ON amd28, amd01, amd03, amd05,amd171,amd17,amd22 #CHI-A80039 add amd22
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

      #CHI-A80039 add --start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(amd22)
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_amd"
               LET g_qryparam.state    ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO amd22
               NEXT FIELD amd22
         END CASE
      #CHI-A80039 add --end--
 
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r101_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
      
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND amduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND amdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND amdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('amduser', 'amdgrup')
   #End:FUN-980030
 
   INPUT BY NAME tm.amd173_b,tm.amd174_b,tm.amd173_e,tm.amd174_e,tm.f,
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD amd173_b
         IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
      AFTER FIELD amd174_b
         IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
      AFTER FIELD amd173_e
         IF cl_null(tm.amd173_e) THEN NEXT FIELD amd173_e END IF
      AFTER FIELD amd174_e
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
         IF tm.amd173_b+tm.amd174_b > tm.amd173_e+tm.amd174_e THEN
            NEXT FIELD amd174_e
         END IF
      AFTER FIELD f
         IF tm.f IS NOT NULL AND tm.f NOT MATCHES '[123]' THEN
            NEXT FIELD f
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr101'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr101','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.amd173_b CLIPPED,"'",
                         " '",tm.amd174_b CLIPPED,"'",
                         " '",tm.amd173_e CLIPPED,"'",
                         " '",tm.amd174_e CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",                #TQC-610057
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('amdr101',g_time,l_cmd)
      END IF
      CLOSE WINDOW r101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r101()
   ERROR ""
END WHILE
   CLOSE WINDOW r101_w
END FUNCTION
 
FUNCTION r101()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_sql     STRING,                      # RDSQL STATEMENT        #No.FUN-680074 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          sr               RECORD
                                  amd28  LIKE amd_file.amd28,   #
                                  amd01  LIKE amd_file.amd01,   #
                                  amd03  LIKE amd_file.amd03,   #
                                  amd05  LIKE amd_file.amd05,   #
                                  amd171 LIKE amd_file.amd171,  #
                                  amd173 LIKE amd_file.amd173,  #
                                  amd174 LIKE amd_file.amd174,  #
                                  amd04  LIKE amd_file.amd04,   #
                                  amd08  LIKE amd_file.amd08,   #
                                  amd172 LIKE amd_file.amd172,  #
                                  amd07  LIKE amd_file.amd07,   #
                                  amd17  LIKE amd_file.amd17    #
                        END RECORD,
         l_ser          LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         l_no           LIKE type_file.num5        #No.FUN-680074 SMALLINT
DEFINE   XX             LIKE aba_file.aba18        #No.FUN-850053         
     CALL cl_del_data(l_table)                   #No.FUN-850053         
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-850053
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-850053---Begin
     #CASE tm.f
     #  WHEN '1'
     #     LET g_title = '稅額500元以下(含)'
     #  WHEN '2'
     #     LET g_title = '稅額500元以上'
     #  WHEN '3'
     #     LET g_title = '全部'
     #END CASE
     #No.FUN-850053---Begin 
#NO.CHI-6A0004--BEGIN
#     SELECT azi04, azi05 INTO g_azi04, g_azi05 FROM azi_file
#                        WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004--END
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND amduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND amdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND amdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     #End:FUN-980030
 
     LET l_sql = "SELECT  amd28,amd01,amd03,amd05,amd171,",
                 " amd173,amd174,amd04,amd08,amd172,amd07,amd17 ",
                 " FROM amd_file ",
                 " WHERE (amd173*12+amd174) BETWEEN ",
                          (tm.amd173_b*12+tm.amd174_b)," AND ",
                          (tm.amd173_e*12+tm.amd174_e),
                #"   AND amd171 matches '2[125]*' ",  #No.B587 010525 by plum
                 "   AND amd171 IN ('21','22','25','26','27','28') ", #BUNO4197
                 "   AND ",tm.wc clipped
     IF tm.f = '1' THEN
        LET l_sql = l_sql CLIPPED," AND amd07 <= 500 "
     END IF
     IF tm.f = '2' THEN
        LET l_sql = l_sql CLIPPED," AND amd07 > 500 "
     END IF
     LET l_sql = l_sql CLIPPED, " ORDER BY amd28 "
     PREPARE r101_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM
     END IF
     DECLARE r101_curs1 CURSOR FOR r101_prepare1
     #No.FUN-850053---Begin
     #CALL cl_outnam('amdr101') RETURNING l_name
     #START REPORT r101_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-850053---End
     LET l_ser = -1
     LET l_no  = 0
     FOR l_idx = 1 TO 14
         LET g_ary[l_idx].mony = 0
         LET g_ary[l_idx].tax = 0
         LET g_ary[l_idx].cnt = 0
     END FOR
     FOREACH r101_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF l_ser = 99  THEN
             LET l_ser = -1
             LET l_no  = l_no + 1
          END IF
          LET l_ser = l_ser + 1
          #No.FUN-850053---Begin 
          #OUTPUT TO REPORT r101_rep(l_no,l_ser,sr.*)
          LET XX =sr.amd17,sr.amd172
          CASE XX
            WHEN '11' LET g_ary[1].mony = g_ary[1].mony + sr.amd08
                      LET g_ary[1].tax  = g_ary[1].tax  + sr.amd07
                      LET g_ary[1].cnt  = g_ary[1].cnt  + 1
            WHEN '12' LET g_ary[2].mony = g_ary[2].mony + sr.amd08
                      LET g_ary[2].cnt  = g_ary[2].cnt  + 1
            WHEN '13' LET g_ary[3].mony = g_ary[3].mony + sr.amd08
                      LET g_ary[3].cnt  = g_ary[3].cnt  + 1
            WHEN '21' LET g_ary[4].mony = g_ary[4].mony + sr.amd08
                      LET g_ary[4].tax  = g_ary[4].tax  + sr.amd07
                      LET g_ary[4].cnt  = g_ary[4].cnt  + 1
            WHEN '22' LET g_ary[5].mony = g_ary[5].mony + sr.amd08
                      LET g_ary[5].cnt  = g_ary[5].cnt  + 1
            WHEN '23' LET g_ary[6].mony = g_ary[6].mony + sr.amd08
                      LET g_ary[6].cnt  = g_ary[6].cnt  + 1
            WHEN '31' LET g_ary[7].mony = g_ary[7].mony + sr.amd08
                      LET g_ary[7].tax  = g_ary[7].tax  + sr.amd07
                      LET g_ary[7].cnt  = g_ary[7].cnt  + 1
            WHEN '32' LET g_ary[8].mony = g_ary[8].mony + sr.amd08
                      LET g_ary[8].cnt  = g_ary[8].cnt  + 1
            WHEN '33' LET g_ary[9].mony = g_ary[9].mony + sr.amd08
                      LET g_ary[9].cnt  = g_ary[9].cnt  + 1
            WHEN '41' LET g_ary[10].mony = g_ary[10].mony + sr.amd08
                      LET g_ary[10].tax  = g_ary[10].tax  + sr.amd07
                      LET g_ary[10].cnt  = g_ary[10].cnt  + 1
            WHEN '42' LET g_ary[11].mony = g_ary[11].mony + sr.amd08
                      LET g_ary[11].cnt  = g_ary[11].cnt  + 1
            WHEN '43' LET g_ary[12].mony = g_ary[12].mony + sr.amd08
                      LET g_ary[12].cnt  = g_ary[12].cnt  + 1
          END CASE
          EXECUTE insert_prep USING l_no,l_ser,sr.amd28,sr.amd01,
                                    sr.amd03,sr.amd05,
                                    sr.amd171,sr.amd173,sr.amd174,      
                                    sr.amd04,sr.amd08,                  
                                    sr.amd172,sr.amd07,sr.amd17,        
                                    g_ary[1].mony,g_ary[2].mony,        
                                    g_ary[3].mony,g_ary[4].mony,        
                                    g_ary[5].mony,g_ary[6].mony,        
                                    g_ary[7].mony,g_ary[8].mony,        
                                    g_ary[9].mony,g_ary[10].mony,       
                                    g_ary[11].mony,g_ary[12].mony,      
                                    g_ary[1].tax,g_ary[4].tax,          
                                    g_ary[7].tax,g_ary[10].tax,         
                                    g_ary[1].cnt,g_ary[2].cnt,          
                                    g_ary[3].cnt,g_ary[4].cnt,          
                                    g_ary[5].cnt,g_ary[6].cnt,          
                                    g_ary[7].cnt,g_ary[8].cnt,          
                                    g_ary[9].cnt,g_ary[10].cnt,         
                                    g_ary[11].cnt,g_ary[12].cnt 
          #No.FUN-850053---End
     END FOREACH
 
     #No.FUN-850053---Begin 
     #FINISH REPORT r101_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05='Y' THEN                                                 
        LET g_str = " "                                                 
        CALL cl_wcchp(tm.wc,'amd28, amd01, amd03, amd05,amd171,amd17')  
             RETURNING g_str                                                 
     END IF                                                             
     LET g_str=g_str,";",g_azi04,";",g_azi05,";",tm.amd174_b,";",tm.amd174_e
               ,";",tm.amd173_b,";",tm.amd173_e,";",tm.f                         
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
     CALL cl_prt_cs3("amdr101","amdr101",l_sql,g_str)                   
     #No.FUN-850053---End   
END FUNCTION
 
#No.FUN-850053---Begin 
#REPORT r101_rep(l_no,l_ser,sr)
#DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#      l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_aa,l_aa1   LIKE type_file.num10,      #No.FUN-680074 INTEGER
#      l_bb,l_bb1   LIKE type_file.num10,      #No.FUN-680074 INTEGER
#      l_cc,l_cc1   LIKE type_file.num10,      #No.FUN-680074 INTEGER
#      l_dd,l_dd1   LIKE type_file.num10,      #No.FUN-680074 INTEGER
#      sr               RECORD
#                                 amd28  LIKE amd_file.amd28,   #
#                                 amd01  LIKE amd_file.amd01,   #
#                                 amd03  LIKE amd_file.amd03,   #
#                                 amd05  LIKE amd_file.amd05,   #
#                                 amd171 LIKE amd_file.amd171,  #
#                                 amd173 LIKE amd_file.amd173,  #
#                                 amd174 LIKE amd_file.amd174,  #
#                                 amd04  LIKE amd_file.amd04,   #
#                                 amd08  LIKE amd_file.amd08,   #
#                                 amd172 LIKE amd_file.amd172,  #
#                                 amd07  LIKE amd_file.amd07,   #
#                                 amd17  LIKE amd_file.amd17    #
#                       END RECORD,
#      XX            LIKE aba_file.aba18,       #No.FUN-680074 VARCHAR(2)
#      l_no          LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_ser         LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_byy         LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      l_eyy         LIKE type_file.num5        #No.FUN-680074 SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY l_no,l_ser,sr.amd28,sr.amd17, sr.amd172
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
##No.FUN-580010 --start--
##     LET l_byy = tm.amd173_b - 1911
##     LET l_eyy = tm.amd173_e - 1911
#      LET l_byy = tm.amd173_b - 2000
#      LET l_eyy = tm.amd173_e - 2000
##No.FUN-580010 --end--
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           #COLUMN 50,g_x[11] CLIPPED, l_byy USING '&&',            #FUN-660060 remark
#           COLUMN (g_len-25)/2+1,g_x[11] CLIPPED, l_byy USING '&&', #FUN-660060
#                     g_x[9] CLIPPED, tm.amd174_b USING '##',
#                     g_x[10] CLIPPED, g_x[34] CLIPPED, l_eyy  USING '&&',
#                     g_x[9] CLIPPED, tm.amd174_e USING '##', g_x[10] CLIPPED,
#                     COLUMN 90,g_x[12] CLIPPED,g_title CLIPPED, #列印範圍
#                     COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT g_dash[1,g_len]
#No.FUN-580010 --start--
##No.FUN-560247 --start--
##    PRINT COLUMN 01, g_x[41] CLIPPED,
##          COLUMN 06, g_x[12] CLIPPED,
##          COLUMN 23, g_x[13] CLIPPED,
##          COLUMN 44, g_x[14] CLIPPED,
##          COLUMN 57, g_x[15] CLIPPED,
##          COLUMN 66, g_x[16] CLIPPED,
##          COLUMN 71, g_x[17] CLIPPED,g_x[18] CLIPPED,
##          COLUMN 78, g_x[19] CLIPPED,
##          COLUMN 95, g_x[20] CLIPPED,
##          COLUMN 112,g_x[21] CLIPPED,
##          COLUMN 122,g_x[22] CLIPPED,
##          COLUMN 138,g_x[23] CLIPPED
##No.FUN-560247 --end--
##    PRINT g_x[45] CLIPPED,g_x[46] CLIPPED,g_x[47] CLIPPED,g_x[48] CLIPPED
#     PRINT g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],
#           g_x[52],g_x[53],g_x[54],g_x[55]
#     PRINT g_dash1
##No.FUN-580010 --end--
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF l_no
#     SKIP TO TOP OF PAGE
 
#  ON EVERY ROW
#     LET XX =sr.amd17,sr.amd172       #扣扺代號 + 課稅別
#No.FUN-580010 --start--
##    PRINT COLUMN 01, l_ser USING '  &&',
##          COLUMN 06, sr.amd28,
##          COLUMN 23, sr.amd01 CLIPPED,
##          COLUMN 41, sr.amd03 CLIPPED,
##          COLUMN 57, sr.amd05 CLIPPED,
##          COLUMN 67, sr.amd171 CLIPPED,
##          COLUMN 71, sr.amd173-1911 USING '&&',
##          COLUMN 73, sr.amd174      USING '&&',
##          COLUMN 77, sr.amd04 CLIPPED,
##          COLUMN 92, cl_numfor(sr.amd08,18,g_azi04) CLIPPED,
##          COLUMN 114, sr.amd172 CLIPPED,
##          COLUMN 118, cl_numfor(sr.amd07,18,g_azi04) CLIPPED,
##          COLUMN 141, sr.amd17
#    PRINT  COLUMN g_c[44], l_ser USING '  &&',
#           COLUMN g_c[45], sr.amd28,
#           COLUMN g_c[46], sr.amd01 CLIPPED,
#           COLUMN g_c[47], sr.amd03 CLIPPED,
#           COLUMN g_c[48], sr.amd05 CLIPPED,
#           COLUMN g_c[49], sr.amd171 CLIPPED,
#           COLUMN g_c[50], sr.amd173-2000 USING '&&',sr.amd174 USING '&&',
#           COLUMN g_c[51], sr.amd04 CLIPPED,
#           COLUMN g_c[52], cl_numfor(sr.amd08,52,g_azi04) CLIPPED,
#           COLUMN g_c[53], sr.amd172 CLIPPED,
#           COLUMN g_c[54], cl_numfor(sr.amd07,54,g_azi04) CLIPPED,
#           COLUMN g_c[55], sr.amd17
##No.FUN-580010 --end--
#     LET g_amd08 = g_amd08 + sr.amd08
#     LET g_amd07 = g_amd07 + sr.amd07
#     CASE XX
#          WHEN '11' LET g_ary[1].mony = g_ary[1].mony + sr.amd08
#                    LET g_ary[1].tax  = g_ary[1].tax  + sr.amd07
#                    LET g_ary[1].cnt  = g_ary[1].cnt  + 1
#          WHEN '12' LET g_ary[2].mony = g_ary[2].mony + sr.amd08
#                    LET g_ary[2].cnt  = g_ary[2].cnt  + 1
#          WHEN '13' LET g_ary[3].mony = g_ary[3].mony + sr.amd08
#                    LET g_ary[3].cnt  = g_ary[3].cnt  + 1
#          WHEN '21' LET g_ary[4].mony = g_ary[4].mony + sr.amd08
#                    LET g_ary[4].tax  = g_ary[4].tax  + sr.amd07
#                    LET g_ary[4].cnt  = g_ary[4].cnt  + 1
#          WHEN '22' LET g_ary[5].mony = g_ary[5].mony + sr.amd08
#                    LET g_ary[5].cnt  = g_ary[5].cnt  + 1
#          WHEN '23' LET g_ary[6].mony = g_ary[6].mony + sr.amd08
#                    LET g_ary[6].cnt  = g_ary[6].cnt  + 1
#          WHEN '31' LET g_ary[7].mony = g_ary[7].mony + sr.amd08
#                    LET g_ary[7].tax  = g_ary[7].tax  + sr.amd07
#                    LET g_ary[7].cnt  = g_ary[7].cnt  + 1
#          WHEN '32' LET g_ary[8].mony = g_ary[8].mony + sr.amd08
#                    LET g_ary[8].cnt  = g_ary[8].cnt  + 1
#          WHEN '33' LET g_ary[9].mony = g_ary[9].mony + sr.amd08
#                    LET g_ary[9].cnt  = g_ary[9].cnt  + 1
#          WHEN '41' LET g_ary[10].mony = g_ary[10].mony + sr.amd08
#                    LET g_ary[10].tax  = g_ary[10].tax  + sr.amd07
#                    LET g_ary[10].cnt  = g_ary[10].cnt  + 1
#          WHEN '42' LET g_ary[11].mony = g_ary[11].mony + sr.amd08
#                    LET g_ary[11].cnt  = g_ary[11].cnt  + 1
#          WHEN '43' LET g_ary[12].mony = g_ary[12].mony + sr.amd08
#                    LET g_ary[12].cnt  = g_ary[12].cnt  + 1
#     END CASE
 
#  AFTER GROUP OF l_no
#No.FUN-580010 --start--
##      PRINT   COLUMN  66, g_x[42] CLIPPED,
##              COLUMN  92, cl_numfor(g_amd08,18,g_azi05) CLIPPED,
##              COLUMN 118, cl_numfor(g_amd07,18,g_azi05) CLIPPED
#      PRINT   COLUMN g_c[51], g_x[42] CLIPPED,
#              COLUMN g_c[52], cl_numfor(g_amd08,52,g_azi05) CLIPPED,
#              COLUMN g_c[54], cl_numfor(g_amd07,54,g_azi05) CLIPPED
##No.FUN-580010 --end--
#        LET g_amd07 = 0
#        LET g_amd08 = 0
 
#  ON LAST ROW
#     #-----MOD-660059---------
#     #FOR l_idx = 1 TO 14
#     #    IF g_ary[l_idx].mony = 0 THEN
#     #       LET g_ary[l_idx].mony = NULL
#     #    END IF
#     #    IF g_ary[l_idx].tax = 0 THEN
#     #       LET g_ary[l_idx].tax = NULL
#     #    END IF
#     #    IF g_ary[l_idx].cnt = 0 THEN
#     #       LET g_ary[l_idx].cnt= NULL
#     #    END IF
#     #END FOR
#     #-----END MOD-660059-----
#     SKIP 1 LINE
#     #--------98/06/08 modify
#     #No.B587 010525 by plum
#     #LET l_aa = SUM(sr.amd08) WHERE sr.amd171 = '21'
#     #LET l_aa1= SUM(sr.amd07) WHERE sr.amd171 = '21'
#     #LET l_bb = SUM(sr.amd08) WHERE sr.amd171 = '22'
#     #LET l_bb1= SUM(sr.amd07) WHERE sr.amd171 = '22'
#      LET l_aa = SUM(sr.amd08) WHERE sr.amd171 = '21' OR sr.amd171 ='26'
#      LET l_aa1= SUM(sr.amd07) WHERE sr.amd171 = '21' OR sr.amd171 ='26'
#      LET l_bb = SUM(sr.amd08) WHERE sr.amd171 = '22' OR sr.amd171 ='27'
#      LET l_bb1= SUM(sr.amd07) WHERE sr.amd171 = '22' OR sr.amd171 ='27'
#     #No.B587..end
#      LET l_cc = SUM(sr.amd08) WHERE sr.amd171 = '25'
#      LET l_cc1= SUM(sr.amd07) WHERE sr.amd171 = '25'
 
#     #BUNO4197..start
#      LET l_dd = SUM(sr.amd08) WHERE sr.amd171 = '28'
#      LET l_dd1= SUM(sr.amd07) WHERE sr.amd171 = '28'
 
#     #-->統一發票扣抵聯(包含電子計算機發票)
##No.FUN-580010 --start--
##     PRINT g_x[38] CLIPPED,
##           COLUMN 47,g_x[36] CLIPPED,cl_numfor(l_aa,18,g_azi05),
##           COLUMN 80,g_x[37] CLIPPED,cl_numfor(l_aa1,18,g_azi05)
#     PRINT COLUMN g_c[44],g_x[38] CLIPPED
#     PRINT COLUMN g_c[51],g_x[36] CLIPPED,
#           COLUMN g_c[52],cl_numfor(l_aa,52,g_azi05),
#           COLUMN g_c[53],g_x[37] CLIPPED,
#           COLUMN g_c[54],cl_numfor(l_aa1,54,g_azi05)
##No.FUN-580010 --end--
#     #-->三聯式收銀機發票扣抵聯
##No.FUN-580010 --start--
##     PRINT g_x[40] CLIPPED,
##           COLUMN 47,g_x[36] CLIPPED,cl_numfor(l_cc,18,g_azi05),
##           COLUMN 80,g_x[37] CLIPPED,cl_numfor(l_cc1,18,g_azi05)
#     PRINT COLUMN g_c[44],g_x[40] CLIPPED
#     PRINT COLUMN g_c[51],g_x[36] CLIPPED,
#           COLUMN g_c[52],cl_numfor(l_cc,52,g_azi05),
#           COLUMN g_c[53],g_x[37] CLIPPED,
#           COLUMN g_c[54],cl_numfor(l_cc1,54,g_azi05)
##No.FUN-580010 --end--
#     #-->載有稅額之其它憑證(包含二聯式收銀機發票)
##No.FUN-580010 --start--
##     PRINT g_x[39] CLIPPED,
##           COLUMN 47,g_x[36] CLIPPED,cl_numfor(l_bb,18,g_azi05),
##           COLUMN 80,g_x[37] CLIPPED,cl_numfor(l_bb1,18,g_azi05)
#     PRINT COLUMN g_c[44],g_x[39] CLIPPED
#     PRINT COLUMN g_c[51],g_x[36] CLIPPED,
#           COLUMN g_c[52],cl_numfor(l_bb,52,g_azi05),
#           COLUMN g_c[53],g_x[37] CLIPPED,
#           COLUMN g_c[54],cl_numfor(l_bb1,54,g_azi05)
##No.FUN-580010 --end--
#     #-->海關代徵營業稅繳納證扣抵聯
##No.FUN-580010 --start--
##     PRINT g_x[43] CLIPPED,
##           COLUMN 47,g_x[36] CLIPPED,cl_numfor(l_dd,18,g_azi05),
##           COLUMN 80,g_x[37] CLIPPED,cl_numfor(l_dd1,18,g_azi05)
#     PRINT COLUMN g_c[44],g_x[43] CLIPPED
#     PRINT COLUMN g_c[51],g_x[36] CLIPPED,
#           COLUMN g_c[52],cl_numfor(l_dd,52,g_azi05),
#           COLUMN g_c[53],g_x[37] CLIPPED,
#           COLUMN g_c[54],cl_numfor(l_dd1,54,g_azi05)
##No.FUN-580010 --end--
#     #BUNO4197..end
 
##     PRINT g_dash_1[1,g_len]
#     PRINT g_dash2    #No.FUN-580010
 
#No.FUN-580010 --start--
##    PRINT COLUMN 06, g_x[35] CLIPPED,
##          COLUMN 31, g_x[29] CLIPPED,
##          COLUMN 52, g_x[30] CLIPPED,
##          COLUMN 66, g_x[33] CLIPPED,
##          COLUMN 78, g_x[31] CLIPPED,
##          COLUMN 93, g_x[33] CLIPPED,
##          COLUMN 112,g_x[32] CLIPPED,
##          COLUMN 126, g_x[33] CLIPPED
##    PRINT COLUMN 26,g_x[49] CLIPPED,g_x[50] CLIPPED,g_x[51] CLIPPED
#     PRINT COLUMN g_c[45],g_x[35] CLIPPED, g_x[29] CLIPPED,g_x[32] CLIPPED
#     PRINT '                        ------------------ ----------------- ---- ---------------- ---- ---------------- ----'
#No.FUN-580010 --end--
#No.FUN-580010 --start--
##    PRINT
##          COLUMN  06, g_x[25] CLIPPED,
##          COLUMN  26, cl_numfor(g_ary[1].mony,18,g_azi05) CLIPPED,
##          COLUMN  46, cl_numfor(g_ary[1].tax,18,g_azi05) CLIPPED,
##          COLUMN  66, g_ary[1].cnt USING '###&' ,
#
##          COLUMN  73, cl_numfor(g_ary[2].mony,18,g_azi05) CLIPPED,
##          COLUMN  93, g_ary[2].cnt USING '###&' ,
#
##          COLUMN 106, cl_numfor(g_ary[3].mony,18,g_azi05) CLIPPED,
##          COLUMN 126, g_ary[3].cnt USING '###&'
#     PRINT COLUMN g_c[45], g_x[25] CLIPPED,
#           COLUMN 25,cl_numfor(g_ary[1].mony,18,g_azi05) CLIPPED,
#                      ' ',cl_numfor(g_ary[1].tax,18,g_azi05) CLIPPED,
#                      ' ',g_ary[1].cnt USING '###&',
#                      ' ',cl_numfor(g_ary[2].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[2].cnt USING '###&',
#                      ' ',cl_numfor(g_ary[3].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[3].cnt USING '###&'
#No.FUN-580010 --end--
#No.FUN-580010 --start--
##    PRINT COLUMN  06, g_x[26] CLIPPED,
##          COLUMN  26, cl_numfor(g_ary[4].mony,18,g_azi05) CLIPPED,
##          COLUMN  46, cl_numfor(g_ary[4].tax,18,g_azi05) CLIPPED,
##          COLUMN  66, g_ary[4].cnt USING '###&',
#
##          COLUMN  73, cl_numfor(g_ary[5].mony,18,g_azi05) CLIPPED,
##          COLUMN  93, g_ary[5].cnt USING '###&',
#
##          COLUMN 106, cl_numfor(g_ary[6].mony,18,g_azi05) CLIPPED,
##          COLUMN 126, g_ary[6].cnt  USING '###&'
#     PRINT COLUMN g_c[45], g_x[26] CLIPPED,
#           COLUMN 25, cl_numfor(g_ary[4].mony,18,g_azi05) CLIPPED,
#                      ' ',cl_numfor(g_ary[4].tax,18,g_azi05) CLIPPED,
#                      ' ',g_ary[4].cnt USING '###&',
#
#                      ' ',cl_numfor(g_ary[5].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[5].cnt USING '###&',
#
#                      ' ',cl_numfor(g_ary[6].mony,18,g_azi05) CLIPPED,
#                      ' ', g_ary[6].cnt  USING '###&'
##No.FUN-580010 --end--
 
#     #-----MOD-660059---------
#     PRINT COLUMN g_c[45], g_x[27] CLIPPED,
#           COLUMN 25, cl_numfor(g_ary[7].mony,18,g_azi05) CLIPPED,
#                      ' ',cl_numfor(g_ary[7].tax,18,g_azi05) CLIPPED,
#                      ' ',g_ary[7].cnt USING '###&',
#                      ' ',cl_numfor(g_ary[8].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[8].cnt USING '###&',
#                      ' ',cl_numfor(g_ary[9].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[9].cnt USING '###&'
 
#     PRINT COLUMN g_c[45], g_x[28] CLIPPED,
#           COLUMN 25, cl_numfor(g_ary[10].mony,18,g_azi05) CLIPPED,
#                      ' ',cl_numfor(g_ary[10].tax,18,g_azi05) CLIPPED,
#                      ' ',g_ary[10].cnt USING '###&',
#                      ' ',cl_numfor(g_ary[11].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[11].cnt USING '###&',
#                      ' ',cl_numfor(g_ary[12].mony,18,g_azi05) CLIPPED,
#                      ' ',g_ary[12].cnt USING '###&'
#     #-----END MOD-660059-----
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850053---End
#Patch....NO.TQC-610035 <001> #
#FUN-870144
