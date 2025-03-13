# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: atmr248.4gl
# Descriptions...: 現金折扣單明細表打印
# Date & Author..: 06/04/03 by wujie 
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: TQC-6A0079 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By wujie 替換備注欄位中換行符號，避免造成打印行數的錯誤
# Modify.........: No.TQC-740129 07/04/24 By sherry 打印結果最后沒有顯示程序編號。
# Modify.........: NO.FUN-860008 08/06/10 By zhaijie老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
DEFINE tm         RECORD
                     wc      STRING,               # QBE 條件
                     s       LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(03)            # 排列 (INPUT 條件)
                     t       LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(03)            # 跳頁 (INPUT 條件)
                     u       LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(03)            # 合計 (INPUT 條件)
                     a       LIKE type_file.chr1,  #No.FUN-680120 VARCHAR(01)
                     b       LIKE type_file.chr1,  #No.FUN-680120 VARCHAR(01)
                     more    LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01)            # 輸入其它特殊列印條件
                  END RECORD
DEFINE g_orderA   ARRAY[3] OF LIKE zaa_file.zaa08  #No.FUN-680120 VARCHAR(10)   # 篩選排序條件用變數 # TQC-6A0079
DEFINE g_i        LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_head1    STRING
DEFINE g_sma115   LIKE sma_file.sma115
DEFINE g_sma116   LIKE sma_file.sma116
DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE l_tab2     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
#NO.FUN-860008---start---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
DEFINE l_table1     STRING
#NO.FUN-860008---end---
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   #--外部程式傳遞參數或 Background Job 時接受參數 --#
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   LET tm.t     = ARG_VAL(9)
   LET tm.u     = ARG_VAL(10)
   LET tm.a     = ARG_VAL(11)
   LET tm.more  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#NO.FUN-860008---start---
   LET g_sql = "tqw01.tqw_file.tqw01,",
               "tqw02.tqw_file.tqw02,",
               "tqw03.tqw_file.tqw03,",
               "gem02.gem_file.gem02,",
               "tqw04.tqw_file.tqw04,",
               "gen02.gen_file.gen02,",
               "tqw05.tqw_file.tqw05,",
               "occ02.occ_file.occ02,",
               "tqw17.tqw_file.tqw17,",
               "tqw07.tqw_file.tqw07,",
               "tqw08.tqw_file.tqw08,",
               "tqw081.tqw_file.tqw081,",
               "tqw09.tqw_file.tqw09,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05"
   LET l_table =cl_prt_temptable('atmr248',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "tqw01.oeb_file.oeb1007,",
               "l_oeb01.oeb_file.oeb01,", 
               "l_oeb03.oeb_file.oeb03,", 
               "l_oeb1010.oeb_file.oeb1010,",
               "l_oeb14.oeb_file.oeb14,", 
               "l_oeb14t.oeb_file.oeb14t,",
               "l_ogb01.ogb_file.ogb01,",
               "l_ogb03.ogb_file.ogb03,",
               "l_ogb1010.ogb_file.ogb1010,",
               "l_ogb14.ogb_file.ogb14,",
               "l_ogb14t.ogb_file.ogb14t"
   LET l_table1 =cl_prt_temptable('atmr2481',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
#NO.FUN-860008---end---
   DROP TABLE curr_tmp
# No.FUN-680120-BEGIN
   CREATE TEMP TABLE curr_tmp(
     curr    LIKE ade_file.ade04,
     amt     LIKE type_file.num20_6,
     amt1    LIKE type_file.num20_6,
     amt2    LIKE type_file.num20_6,
     order1  LIKE ima_file.ima01,
     order2  LIKE ima_file.ima01,
     order3  LIKE ima_file.ima01);
# No.FUN-680120-END    
 
   IF NOT cl_null(tm.wc) THEN
      CALL r248()
      DROP TABLE curr_tmp
   ELSE
      CALL r248_tm(0,0)
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r248_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r248_w AT p_row,p_col WITH FORM "atm/42f/atmr248"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tqw01,tqw02,tqw05,tqw03,tqw04,tqw10
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tqw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqw1"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw01
                 NEXT FIELD tqw01
 
               WHEN INFIELD(tqw05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ8"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw05
                 NEXT FIELD tqw05
 
               WHEN INFIELD(tqw03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw03
                 NEXT FIELD tqw03
 
               WHEN INFIELD(tqw04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw04
                 NEXT FIELD tqw04
 
            END CASE
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r248_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.more
            WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         BEFORE FIELD a
            CALL cl_set_comp_entry("b",TRUE)
 
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
            IF tm.a !='Y' THEN
               LET tm.b ='N'
               CALL cl_set_comp_entry("b",FALSE)
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more    #是否輸入其它特殊條件
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r248_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='atmr248'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr248','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('atmr248',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r248_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r248()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp   
 
   CLOSE WINDOW r248_w
 
END FUNCTION
 
FUNCTION r248()
DEFINE l_name    LIKE type_file.chr20         #No.FUN-680120 VARCHAR(20)         # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     LIKE type_file.chr1000       # SQL STATEMENT        #No.FUN-680120 VARCHAR(1000)
DEFINE l_za05    LIKE ima_file.ima01          #No.FUN-680120 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF    LIKE ima_file.ima01           #No.FUN-680120 VARCHAR(40)          
DEFINE sr        RECORD order1  LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)      
                        order2  LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40)     
                        order3  LIKE ima_file.ima01,          #No.FUN-680120,CHAR(40)              
                        tqw01   LIKE tqw_file.tqw01,
                        tqw02   LIKE tqw_file.tqw02,
                        tqw03   LIKE tqw_file.tqw03,
                        gem02   LIKE gem_file.gem02,
                        tqw04   LIKE tqw_file.tqw04,
                        gen02   LIKE gen_file.gen02,
                        tqw05   LIKE tqw_file.tqw05,
                        occ02   LIKE occ_file.occ02,
                        tqw17   LIKE tqw_file.tqw17,
                        tqw07   LIKE tqw_file.tqw07,
                        tqw08   LIKE tqw_file.tqw08,
                        tqw081  LIKE tqw_file.tqw081,
                        tqw09   LIKE tqw_file.tqw09
                        END RECORD
#NO.FUN-860008---start---
DEFINE      l_oeb1007   LIKE oeb_file.oeb1007
DEFINE      l_oeb01     LIKE oeb_file.oeb01 
DEFINE      l_oeb03     LIKE oeb_file.oeb03 
DEFINE      l_oeb1010   LIKE oeb_file.oeb1010
DEFINE      l_oeb14     LIKE oeb_file.oeb14 
DEFINE      l_oeb14t    LIKE oeb_file.oeb14t
DEFINE      l_ogb01     LIKE ogb_file.ogb01
DEFINE      l_ogb03     LIKE ogb_file.ogb03 
DEFINE      l_ogb1010   LIKE ogb_file.ogb1010
DEFINE      l_ogb14     LIKE ogb_file.ogb14
DEFINE      l_ogb14t    LIKE ogb_file.ogb14t
DEFINE      l_buf_str   base.StringBuffer                                                                 
DEFINE      l_str4      STRING
DEFINE      l_flag      LIKE  oeb_file.oeb03
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM
   END IF    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
      EXIT PROGRAM
   END IF    
   CALL  cl_del_data(l_table)
   CALL  cl_del_data(l_table1)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmr248'
#NO.FUN-860008---end---
   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
 
   #No.8991   (針對幣別加總)
   DELETE FROM curr_tmp;
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt1),SUM(amt2) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt1),SUM(amt2) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt1),SUM(amt2) FROM curr_tmp ",    #group 3 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "  GROUP BY curr  "
   PREPARE tmp3_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(amt1),SUM(amt2) FROM curr_tmp ",    #on last row 總計
             "  GROUP BY curr  "
   PREPARE tmp4_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_4:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp4_cs CURSOR FOR tmp4_pre
   #No.8991(end)
#NO.CHI-6A0004 --START
#  SELECT azi03,azi04,azi05
#    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#    FROM azi_file
#   WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
   LET l_sql = "SELECT '','','',                                ",
               "       tqw01, tqw02, tqw03,gem02, tqw04,gen02, tqw05,occ02, tqw17, ",
               "       tqw07, tqw08, tqw081,tqw09 ",
               "  FROM tqw_file, OUTER gem_file,OUTER gen_file,OUTER occ_file ",
               " WHERE tqw_file.tqw03 =gem_file.gem01  ",
               "   AND tqw_file.tqw04 =gen_file.gen01  ",
               "   AND tqw_file.tqw05 =occ_file.occ01  ",
               "   AND ", tm.wc CLIPPED,
               " ORDER BY tqw01,tqw02,tqw03,tqw04,tqw05"
 
   PREPARE r248_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE r248_curs1 CURSOR FOR r248_prepare1
 
#   CALL cl_outnam('atmr248') RETURNING l_name              #NO.FUN-860008
 
#   START REPORT r248_rep TO l_name                         #NO.FUN-860008
#   LET g_pageno = 0                                        #NO.FUN-860008
   FOREACH r248_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#NO.FUN-860008--START--MARK---
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.tqw01
#                                       LET g_orderA[g_i]= g_x[11]
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.tqw02
#                                           USING 'yyyymmdd'
#                                       LET g_orderA[g_i]= g_x[12]
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.tqw05
#                                       LET g_orderA[g_i]= g_x[13]
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.tqw03
#                                       LET g_orderA[g_i]= g_x[14]
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.tqw04
#                                       LET g_orderA[g_i]= g_x[15]
#              OTHERWISE LET l_order[g_i]  = '-'
#                        LET g_orderA[g_i] = ' '          #清為空白
#         END CASE
#      END FOR
 
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_Order[2]
#      LET sr.order3 = l_order[3]
 
#      OUTPUT TO REPORT r248_rep(sr.*)
#NO.FUN-860008---END--MARK--
#NO.FUN-860008---start---
    SELECT azi03,azi04,azi05
      INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取
      FROM azi_file
    WHERE azi01=sr.tqw17                                                                                                          
    LET l_str4=sr.tqw09                                                                                                             
    LET l_buf_str = base.StringBuffer.create()                                                                                      
    CALL l_buf_str.append(l_str4)                                                                                                   
    CALL l_buf_str.replace("\n","",0)                                                                                               
    LET l_str4=l_buf_str.toString()                                                                                                 
    LET sr.tqw09 =l_str4 
    LET l_flag = 0
    LET l_sql ="SELECT oeb1007,oeb01,oeb03,oeb1010,oeb14,oeb14t", 
               "  FROM oeb_file,oea_file",
               " WHERE oeb1007 = '",sr.tqw01,"'",
               "   AND oea01 =oeb01",
               "   AND oeaconf ='Y'",
               " ORDER BY oeb01,oeb03"
    PREPARE oeb_pre FROM l_sql
    DECLARE   oeb_cs SCROLL  CURSOR WITH HOLD FOR oeb_pre
 
    LET l_sql ="SELECT ogb01,ogb03,ogb1010,ogb14,ogb14t", 
               "   FROM ogb_file,oga_file",
               "  WHERE ogb31 =?",
               "    AND ogb32 =?",
               "    AND ogb01 =oga01",
               "    AND ogapost ='Y'",
               " ORDER BY ogb01,ogb03"
    PREPARE ogb_pre FROM l_sql
    DECLARE ogb_cs SCROLL CURSOR WITH HOLD FOR ogb_pre
 
    IF tm.a ='Y' THEN
        FOREACH oeb_cs INTO l_oeb1007,l_oeb01,l_oeb03,l_oeb1010,l_oeb14,l_oeb14t
           IF STATUS THEN EXIT FOREACH END IF
        IF tm.b ='Y' THEN
           FOREACH ogb_cs USING l_oeb01,l_oeb03 INTO l_ogb01,l_ogb03,l_ogb1010,l_ogb14,l_ogb14t
              IF STATUS THEN EXIT FOREACH END IF
           EXECUTE insert_prep1 USING 
                l_oeb1007,l_oeb01,l_oeb03,l_oeb1010,l_oeb14,l_oeb14t,l_ogb01,
                l_ogb03,l_ogb1010,l_ogb14,l_ogb14t  
           LET l_flag =1            
           END FOREACH
        END IF
        IF l_flag = 0 THEN 
          LET l_ogb01 = NULL
          LET l_ogb03 = 0
          LET l_ogb1010 = NULL
          LET l_ogb14 = 0
          LET l_ogb14t = 0
          EXECUTE insert_prep1 USING 
               l_oeb1007,l_oeb01,l_oeb03,l_oeb1010,l_oeb14,l_oeb14t,l_ogb01,
               l_ogb03,l_ogb1010,l_ogb14,l_ogb14t
        END IF
        END FOREACH
    END IF  
    EXECUTE insert_prep USING 
      sr.tqw01,sr.tqw02,sr.tqw03,sr.gem02,sr.tqw04,sr.gen02,sr.tqw05,
      sr.occ02,sr.tqw17,sr.tqw07,sr.tqw08,sr.tqw081,sr.tqw09,t_azi04,t_azi05
#NO.FUN-860008-----end--      
   END FOREACH
 
#   FINISH REPORT r248_rep                                  #NO.FUN-860008
#NO.FUN-860008--start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'tqw01,tqw02,tqw05,tqw03,tqw04,tqw10')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",tm.a,";",tm.b
     CALL cl_prt_cs3('atmr248','atmr248',g_sql,g_str) 
#NO.FUN-860008---end---  
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)             #NO.FUN-860008
 
END FUNCTION
#NO.FUN-860008
#REPORT r248_rep(sr)
#DEFINE l_last_sw        LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE sr        RECORD order1  LIKE ima_file.ima01,    #No.FUN-680120 VARCHAR(40)     
#                        order2  LIKE ima_file.ima01,    #No.FUN-680120 VARCHAR(40)      
#                        order3  LIKE ima_file.ima01,    #No.FUN-680120 VARCHAR(40)      
#                        tqw01   LIKE tqw_file.tqw01,
#                        tqw02   LIKE tqw_file.tqw02,
#                        tqw03   LIKE tqw_file.tqw03,
#                        gem02   LIKE gem_file.gem02,
#                        tqw04   LIKE tqw_file.tqw04,
#                        gen02   LIKE gen_file.gen02,
#                        tqw05   LIKE tqw_file.tqw05,
#                        occ02   LIKE occ_file.occ02,
#                        tqw17   LIKE tqw_file.tqw17,
#                        tqw07   LIKE tqw_file.tqw07,
#                        tqw08   LIKE tqw_file.tqw08,
#                        tqw081  LIKE tqw_file.tqw081,
#                        tqw09   LIKE tqw_file.tqw09
#                        END RECORD,
#          sr1           RECORD                 
#                           curr      LIKE azi_file.azi01,  #No.FUN-680120 VARCHAR(04) 
#                           amt       LIKE tqw_file.tqw07,
#                           amt1      LIKE tqw_file.tqw08,
#                           amt2      LIKE tqw_file.tqw081
#                    END RECORD,
#                l_str   LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)        
#                l_str1  LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)       
#                l_str2  LIKE gbc_file.gbc05,   #No.FUN-680120 VARCHAR(100)     
#                l_str3  LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)  
#                l_tab   LIKE type_file.chr1,   #No.FUN-680120 VARCHAR(01)  
#                l_tab1  LIKE type_file.chr1,   #No.FUN-680120 VARCHAR(01) 
#                g_sql   LIKE type_file.chr1000,#No.FUN-680120 VARCHAR(1000)
#                l_oeb01     LIKE oeb_file.oeb01, 
#                l_oeb03     LIKE oeb_file.oeb03, 
#                l_oeb1010   LIKE oeb_file.oeb1010,
#                l_oeb14     LIKE oeb_file.oeb14, 
#                l_oeb14t    LIKE oeb_file.oeb14t,
#                l_ogb01     LIKE ogb_file.ogb01, 
#                l_ogb03     LIKE ogb_file.ogb03, 
#                l_ogb1010   LIKE ogb_file.ogb1010,
#                l_ogb14     LIKE ogb_file.ogb14, 
#                l_ogb14t    LIKE ogb_file.ogb14t,
#		l_rowno LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#		l_sum   LIKE feb_file.feb10,             #No.FUN-680120 DECIMAL(10,2)
#		l_sum1  LIKE feb_file.feb10,             #No.FUN-680120 DECIMAL(10,2)
#		l_amt_1 LIKE oeb_file.oeb14,   
#		l_amt_2 LIKE oeb_file.oeb12    
#DEFINE          l_buf_str   base.StringBuffer       #No.TQC-710043                                                                  
#DEFINE          l_str4  STRING                      #No.TQC-710043 
# 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.order1,sr.order2,sr.order3,sr.tqw01     
#
#  #格式設定
#  FORMAT
#   #列印表頭
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[10] CLIPPED,
#                    g_orderA[1] CLIPPED,'-',
#                    g_orderA[2] CLIPPED,'-',
#                    g_orderA[3] CLIPPED
#      PRINT g_head1
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39],
#            g_x[40],
#            g_x[41],
#            g_x[42],
#            g_x[43]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'           #跳頁控制
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2       #跳頁控制
#      IF tm.t[2,2] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3       #跳頁控制
#      IF tm.t[3,3] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#
#   SELECT azi03,azi04,azi05
##    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取   #NO.CHI-6A0004
#     INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取   #NO.CHI-6A0004
#     FROM azi_file
#    WHERE azi01=sr.tqw17
##TQC-710043--begin                                                                                                                  
#    LET l_str4=sr.tqw09                                                                                                             
#    LET l_buf_str = base.StringBuffer.create()                                                                                      
#    CALL l_buf_str.append(l_str4)                                                                                                   
#    CALL l_buf_str.replace("\n","",0)                                                                                               
#    LET l_str4=l_buf_str.toString()                                                                                                 
#    LET sr.tqw09 =l_str4                                                                                                            
##TQC-710043--end  
#
#      PRINT COLUMN g_c[31],sr.tqw01 CLIPPED,
#            COLUMN g_c[32],sr.tqw02 CLIPPED,
#            COLUMN g_c[33],sr.tqw03 CLIPPED,
#            COLUMN g_c[34],sr.gem02 CLIPPED,
#            COLUMN g_c[35],sr.tqw04 CLIPPED,
#            COLUMN g_c[36],sr.gen02 CLIPPED,
#            COLUMN g_c[37],sr.tqw05 CLIPPED,
#            COLUMN g_c[38],sr.occ02 CLIPPED,
#            COLUMN g_c[39],sr.tqw17 CLIPPED,
##NO.CHI-6A0004 --START
##           COLUMN g_c[40],cl_numfor(sr.tqw07,40,g_azi04),
##           COLUMN g_c[41],cl_numfor(sr.tqw08,41,g_azi04),
##           COLUMN g_c[42],cl_numfor(sr.tqw081,42,g_azi04),
#            COLUMN g_c[40],cl_numfor(sr.tqw07,40,t_azi04),
#            COLUMN g_c[41],cl_numfor(sr.tqw08,41,t_azi04),
#            COLUMN g_c[42],cl_numfor(sr.tqw081,42,t_azi04),
##NO.CHI-6A0004 --END
#            COLUMN g_c[43],sr.tqw09 CLIPPED
#      INSERT INTO curr_tmp VALUES(sr.tqw17,sr.tqw07,sr.tqw08,sr.tqw081,
#                                  sr.order1,sr.order2,sr.order3)
#
#      AFTER GROUP OF sr.tqw01
#      LET g_sql ="SELECT oeb01,oeb03,oeb1010,oeb14,oeb14t", 
#                 "  FROM oeb_file,oea_file",
#                 " WHERE oeb1007 = '",sr.tqw01,"'",
#                 "   AND oea01 =oeb01",
#                 "   AND oeaconf ='Y'",
#                 " ORDER BY oeb01,oeb03"
#      PREPARE oeb_pre FROM g_sql
#      DECLARE   oeb_cs SCROLL  CURSOR WITH HOLD FOR oeb_pre
#
#      LET g_sql ="SELECT ogb01,ogb03,ogb1010,ogb14,ogb14t", 
#                "   FROM ogb_file,oga_file",
#                "  WHERE ogb31 =?",
#                "    AND ogb32 =?",
#                "    AND ogb01 =oga01",
#                "    AND ogapost ='Y'",
#                " ORDER BY ogb01,ogb03"
#      PREPARE ogb_pre FROM g_sql
#      DECLARE ogb_cs SCROLL CURSOR WITH HOLD FOR ogb_pre
#
#      IF tm.a ='Y' THEN
#          LET l_tab2 =0
#          FOREACH oeb_cs INTO l_oeb01,l_oeb03,l_oeb1010,l_oeb14,l_oeb14t
#             IF STATUS THEN EXIT FOREACH END IF
#             IF l_tab2 =0 THEN
#                PRINT COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+3]
#                PRINT COLUMN g_c[39],g_x[44],
#                      COLUMN g_c[40],g_x[45],
#                      COLUMN g_c[41],g_x[47]
#                PRINT COLUMN g_c[39],g_dash2[1,g_w[39]],
#                      COLUMN g_c[40],g_dash2[1,g_w[40]],
#                      COLUMN g_c[41],g_dash2[1,g_w[41]]
#                LET l_tab2 =1
#             END IF
#             PRINT COLUMN g_c[39],l_oeb01 CLIPPED,
#                   COLUMN g_c[40],l_oeb03 USING '#################&';
#             IF l_oeb1010 ='Y' THEN
##               PRINT COLUMN g_c[41],cl_numfor(l_oeb14t,42,g_azi05) CLIPPED   #NO.CHI-6A0004
#                PRINT COLUMN g_c[41],cl_numfor(l_oeb14t,42,t_azi05) CLIPPED   #NO.CHI-6A0004
#             ELSE  
##               PRINT COLUMN g_c[41],cl_numfor(l_oeb14,42,g_azi05) CLIPPED    #NO.CHI-6A0004
#                PRINT COLUMN g_c[41],cl_numfor(l_oeb14,42,t_azi05) CLIPPED    #NO.CHI-6A0004
#             END IF
#          IF tm.b ='Y' THEN
#             LET l_tab1 =0
#             FOREACH ogb_cs USING l_oeb01,l_oeb03 INTO l_ogb01,l_ogb03,l_ogb1010,l_ogb14,l_ogb14t
#                IF STATUS THEN EXIT FOREACH END IF
#                IF l_tab1 =0 THEN
#                   PRINT COLUMN g_c[40],g_x[48],
#                         COLUMN g_c[41],g_x[45],
#                         COLUMN g_c[42],g_x[49]
#                   PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
#                         COLUMN g_c[41],g_dash2[1,g_w[41]],
#                         COLUMN g_c[42],g_dash2[1,g_w[42]]
#                   LET l_tab1 =1
#                END IF
#                PRINT COLUMN g_c[40],l_ogb01 CLIPPED,
#                      COLUMN g_c[41],l_ogb03 USING '#################&';
#                IF l_ogb1010 ='Y' THEN
##                  PRINT COLUMN g_c[42],cl_numfor(l_ogb14t,42,g_azi05) CLIPPED   #NO.CHI-6A0004
#                   PRINT COLUMN g_c[42],cl_numfor(l_ogb14t,42,t_azi05) CLIPPED   #NO.CHI-6A0004
#                ELSE  
##                  PRINT COLUMN g_c[42],cl_numfor(l_ogb14,42,g_azi05) CLIPPED    #NO.CHI-6A0004
#                   PRINT COLUMN g_c[42],cl_numfor(l_ogb14,42,t_azi05) CLIPPED    #NO.CHI-6A0004
#                END IF
#             END FOREACH
#          END IF
#          PRINT
#          END FOREACH
#      END IF
#
#   AFTER GROUP OF sr.order1            #金額小計
#      IF tm.u[1,1] = 'Y' THEN
#         PRINT COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+5]
#         PRINT COLUMN g_c[37],g_orderA[1] CLIPPED,
#               COLUMN g_c[38],g_x[25] CLIPPED;
#         LET l_tab =0
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
##          SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#           SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#                WHERE azi01 = sr1.curr
#               LET l_str = sr1.curr CLIPPED
#               LET l_tab =1
#               PRINT COLUMN g_c[39],l_str CLIPPED,
##NO.CHI-6A0004 --START
##                    COLUMN g_c[40],cl_numfor(sr1.amt,40,g_azi05) CLIPPED,
##                    COLUMN g_c[41],cl_numfor(sr1.amt1,41,g_azi05) CLIPPED,
##                    COLUMN g_c[42],cl_numfor(sr1.amt2,42,g_azi05) CLIPPED
#                     COLUMN g_c[40],cl_numfor(sr1.amt,40,t_azi05) CLIPPED,
#                     COLUMN g_c[41],cl_numfor(sr1.amt1,41,t_azi05) CLIPPED,
#                     COLUMN g_c[42],cl_numfor(sr1.amt2,42,t_azi05) CLIPPED
##NO.CHI-6A0004 --END
#         END FOREACH
#         IF l_tab =0 THEN
#            PRINT ''
#         END IF
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order2            #金額小計
#      IF tm.u[2,2] = 'Y' THEN
#         PRINT COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+5]
#         PRINT COLUMN g_c[37],g_orderA[2] CLIPPED,
#               COLUMN g_c[38],g_x[25] CLIPPED;
#         LET l_tab =0
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED
#             LET l_tab =1
#               PRINT COLUMN g_c[39],l_str CLIPPED,
##NO.CHI-6A0004 --START
##                    COLUMN g_c[40],cl_numfor(sr1.amt,40,g_azi05) CLIPPED,
##                    COLUMN g_c[41],cl_numfor(sr1.amt1,41,g_azi05) CLIPPED,
##                    COLUMN g_c[42],cl_numfor(sr1.amt2,42,g_azi05) CLIPPED
#                     COLUMN g_c[40],cl_numfor(sr1.amt,40,t_azi05) CLIPPED,
#                     COLUMN g_c[41],cl_numfor(sr1.amt1,41,t_azi05) CLIPPED,
#                     COLUMN g_c[42],cl_numfor(sr1.amt2,42,t_azi05) CLIPPED
##NO.CHI-6A0004 --END
#         END FOREACH
#         IF l_tab =0 THEN
#            PRINT ''
#         END IF
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3            #金額小計
#      IF tm.u[3,3] = 'Y' THEN
#         PRINT COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+5]
#         PRINT COLUMN g_c[37],g_orderA[3] CLIPPED,
#               COLUMN g_c[38],g_x[25] CLIPPED;
#         LET l_tab =0
#         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED
#             LET l_tab =1
#               PRINT COLUMN g_c[39],l_str CLIPPED,
##NO.CHI-6A0004 --START
##                    COLUMN g_c[40],cl_numfor(sr1.amt,40,g_azi05) CLIPPED,
##                    COLUMN g_c[41],cl_numfor(sr1.amt1,41,g_azi05) CLIPPED,
##                    COLUMN g_c[42],cl_numfor(sr1.amt2,42,g_azi05) CLIPPED
#                     COLUMN g_c[40],cl_numfor(sr1.amt,40,t_azi05) CLIPPED,
#                     COLUMN g_c[41],cl_numfor(sr1.amt1,41,t_azi05) CLIPPED,
#                     COLUMN g_c[42],cl_numfor(sr1.amt2,42,t_azi05) CLIPPED
##NO.CHI-6A0004 --END
#         END FOREACH
#         IF l_tab =0 THEN
#            PRINT ''
#         END IF
#         PRINT ''
#      END IF
#
#   ON LAST ROW                         #金額總計
#      PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+4]
#      PRINT COLUMN g_c[38],g_x[09] CLIPPED;
#      LET l_tab =0
#      FOREACH tmp4_cs INTO sr1.*
##         SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#          SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#           WHERE azi01 = sr1.curr
#          LET l_str = sr1.curr CLIPPED
#          LET l_tab =1
#               PRINT COLUMN g_c[39],l_str CLIPPED,
##NO.CHI-6A0004 --START 
##                    COLUMN g_c[40],cl_numfor(sr1.amt,40,g_azi05) CLIPPED,
##                    COLUMN g_c[41],cl_numfor(sr1.amt1,41,g_azi05) CLIPPED,
##                    COLUMN g_c[42],cl_numfor(sr1.amt2,42,g_azi05) CLIPPED
#                     COLUMN g_c[40],cl_numfor(sr1.amt,40,t_azi05) CLIPPED,
#                     COLUMN g_c[41],cl_numfor(sr1.amt1,41,t_azi05) CLIPPED,
#                     COLUMN g_c[42],cl_numfor(sr1.amt2,42,t_azi05) CLIPPED
##NO.CHI-6A0004 --END
#      END FOREACH
#      IF l_tab =0 THEN
#         PRINT ''
#      END IF
#      
#
#      #是否列印選擇條件
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
##    PRINT  COLUMN (g_len-9),g_x[7] CLIPPED  
#     PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-740129
#
#   #表尾列印
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
##    PRINT     COLUMN (g_len-9),g_x[6] CLIPPED  
#     PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED    #No.TQC-740129
#      ELSE
#         SKIP 2 LINE
#      END IF
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
##            PRINT g_x[4]         #No.TQC-740129
#             PRINT g_memo
#         ELSE
##            PRINT                #No.TQC-740129 
#             PRINT
#         END IF
#      ELSE
##            PRINT g_x[4]          #No.TQC-740129
#             PRINT g_memo
#      END IF
#
#END REPORT
##NO.FUN-860008
##No.FUN-870144
