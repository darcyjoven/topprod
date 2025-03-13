# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: atmr247.4gl
# Descriptions...: 提案明細表打印
# Date & Author..: 06/03/30 by vivien
# Modify.........: NO.TQC-640165 06/04/20 By vivien 報表格式修改
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: TQC-6A0079 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By Rayven 報表左下角無程式代號
# Modify.........: NO.FUN-860008 08/06/04 By zhaijie 老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.TQC-940087 09/05/08 By mike PREPARE atmr247_prepare1 FROM l_sql時l_azp為空 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD
                     wc      STRING,               # QBE 條件
                     s       LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(03)             # 排列 (INPUT 條件)
                     t       LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(03)             # 跳頁 (INPUT 條件)
                     u       LIKE type_file.chr4,    # Prog. Version..: '5.30.06-13.03.12(03)             # 合計 (INPUT 條件)
                     a       LIKE type_file.chr1,  #No.FUN-680120 VARCHAR(01)
                     more    LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01)             # 輸入其它特殊列印條件
                  END RECORD
DEFINE g_orderA   ARRAY[3] OF LIKE zaa_file.zaa08  #No.FUN-680120 VARCHAR(10)   # 篩選排序條件用變數 # TQC-6A0079
DEFINE g_i        LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_head1    STRING
DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(10000)
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
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
#NO.FUN-860008--start--
   LET g_sql = "tqx01.tqx_file.tqx01,",
               "tqx02.tqx_file.tqx02,",
               "tqx05.tqx_file.tqx05,",
               "tqx09.tqx_file.tqx09,",
               "tqy02.tqy_file.tqy02,",
               "tqy03.tqy_file.tqy03,",
               "tqy38.tqy_file.tqy38,",
               "tqy36.tqy_file.tqy36,",
               "tqy37.tqy_file.tqy37,", 
               "tsb02.tsb_file.tsb02,",
               "tsb03.tsb_file.tsb03,",
               "tsb04.tsb_file.tsb04,",
               "tsb05.tsb_file.tsb05,",
               "tsb06.tsb_file.tsb06,",
               "tsb07.tsb_file.tsb07,",
               "tsb08.tsb_file.tsb08,",
               "tsb09.tsb_file.tsb09,",
               "tsb10.tsb_file.tsb10,",
               "tsb11.tsb_file.tsb11,",
               "tsb12.tsb_file.tsb12,",
               "l_occ02.occ_file.occ02,",
               "l_tqa02a.tqa_file.tqa02,",               
               "l_tqa02b.tqa_file.tqa02,",               
               "l_tqa02c.tqa_file.tqa02,",               
               "l_tqa02d.tqa_file.tqa02,",               
               "l_oaj02.oaj_file.oaj02,",               
               "azi05.azi_file.azi05" 
   LET l_table =cl_prt_temptable('atmr247',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF                      
#NO.FUN-860008---end---
# No.FUN-680120-BEGIN
   CREATE TEMP TABLE curr_tmp(
     curr    LIKE ade_file.ade04,
     amt     LIKE type_file.num20_6,
     order1  LIKE ima_file.ima01,
     order2  LIKE ima_file.ima01,
     order3  LIKE ima_file.ima01);
# No.FUN-680120-END 
 
   IF NOT cl_null(tm.wc) THEN
      CALL r247()
      DROP TABLE curr_tmp
   ELSE
      CALL r247_tm(0,0)
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r247_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r247_w AT p_row,p_col WITH FORM "atm/42f/atmr247"
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
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tqx01,tqx02,tqx03,tqx04,
                                 tqx12,tqx13,tqx07
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tqx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqx"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx01
                 NEXT FIELD tqx01
 
               WHEN INFIELD(tqx03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa1"
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1  = '15'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx03
                 NEXT FIELD tqx03
 
               WHEN INFIELD(tqx04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa1"
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1  = '17'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx04
                 NEXT FIELD tqx04
 
               WHEN INFIELD(tqx12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqb"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx12
                 NEXT FIELD tqx12
 
               WHEN INFIELD(tqx13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa1"
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1  = '20'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqx13
                 NEXT FIELD tqx13
 
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
         CLOSE WINDOW r247_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.more
            WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[123456]' THEN
               NEXT FIELD a
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
         CLOSE WINDOW r247_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='atmr247'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr247','9031',1)
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
            CALL cl_cmdat('atmr247',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r247_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r247()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp   
 
   CLOSE WINDOW r247_w
 
END FUNCTION
 
FUNCTION r247()
DEFINE l_name    LIKE type_file.chr20        #No.FUN-680120 VARCHAR(20)          # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     LIKE type_file.chr1000      # SQL STATEMENT        #No.FUN-680120 VARCHAR(10000)
DEFINE l_za05    LIKE ima_file.ima01         #No.FUN-680120 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF    LIKE ima_file.ima01         #No.FUN-680120 VARCHAR(40)             
DEFINE sr        RECORD order1  LIKE ima_file.ima01,        #No.FUN-680120 VARCHAR(40)        
                        order2  LIKE ima_file.ima01,        #No.FUN-680120 VARCHAR(40)   
                        order3  LIKE ima_file.ima01,        #No.FUN-680120 VARCHAR(40)        
                        tqx01   LIKE tqx_file.tqx01,
                        tqx02   LIKE tqx_file.tqx02,
                        tqx05   LIKE tqx_file.tqx05,
                        tqx09   LIKE tqx_file.tqx09,
                        tqy02   LIKE tqy_file.tqy02,
                        tqy03   LIKE tqy_file.tqy03,
                        tqy38   LIKE tqy_file.tqy38,
                        tqy36   LIKE tqy_file.tqy36,
                        tqy37   LIKE tqy_file.tqy37
                        END RECORD,
          sr2           RECORD                 
                        tsb02   LIKE tsb_file.tsb02,
                        tsb03   LIKE tsb_file.tsb03,
                        tsb04   LIKE tsb_file.tsb04,
                        tsb05   LIKE tsb_file.tsb05,
                        tsb06   LIKE tsb_file.tsb06,
                        tsb07   LIKE tsb_file.tsb07,
                        tsb08   LIKE tsb_file.tsb08,
                        tsb09   LIKE tsb_file.tsb09,
                        tsb10   LIKE tsb_file.tsb10,
                        tsb11   LIKE tsb_file.tsb11,
                        tsb12   LIKE tsb_file.tsb12
                    END RECORD
#NO.FUN-860008--start---
DEFINE l_occ02  LIKE occ_file.occ02
DEFINE l_azp    LIKE azp_file.azp02
DEFINE l_tqa02a LIKE tqa_file.tqa02 
DEFINE l_tqa02b LIKE tqa_file.tqa02 
DEFINE l_tqa02c LIKE tqa_file.tqa02 
DEFINE l_tqa02d LIKE tqa_file.tqa02 
DEFINE l_oaj02  LIKE oaj_file.oaj02 
    CALL  cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'atmr243'
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
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #group 3 小計
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
 
   LET l_sql=" SELECT curr,SUM(amt) FROM curr_tmp ",    #on last row 總計
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
   LET l_sql = "SELECT '','','',                   ",
               "       tqx01, tqx02, tqx05, tqx09, ",
               "       tqy02, tqy03, tqy38, tqy36, tqy37  ",
               "  FROM tqx_file, tqy_file ",
               " WHERE tqx01 = tqy_file.tqy01 ",
               "   AND ", tm.wc CLIPPED
   CASE tm.a                               #客戶狀態
      WHEN '1'                             #已生效
       LET l_sql=l_sql CLIPPED, " AND tqy37='Y' AND tqy38 IS NOT NULL AND tqy38<= '",TODAY,"'"
      WHEN '2'                             #未生效
       LET l_sql=l_sql CLIPPED, " AND (tqy37='N' OR tqy38 IS NULL OR tqy38>='",TODAY,"')" 
     END CASE
   LET l_sql=l_sql CLIPPED, " ORDER BY tqx01,tqy03 "
 
   PREPARE r247_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE r247_curs1 CURSOR FOR r247_prepare1
 
#   CALL cl_outnam('atmr247') RETURNING l_name              #NO.FUN-860008
 
#   START REPORT r247_rep TO l_name                         #NO.FUN-860008
#   LET g_pageno = 0                                        #NO.FUN-860008
   FOREACH r247_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   LET l_sql="SELECT tsb02,tsb03,tsb04,tsb05,tsb06,",
             "       tsb07,tsb08,tsb09,tsb10,tsb11,tsb12 ",
             "  FROM tsb_file       ",
             " WHERE tsb01 ='",sr.tqx01,"' ",
             "   AND tsb03 ='",sr.tqy02,"' "
   PREPARE r247_prepare2 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM 
   END IF
   DECLARE r247_curs2 CURSOR FOR r247_prepare2
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
   FOREACH r247_curs2 INTO sr2.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#NO.FUN-860008--start--mark--
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.tqx01
                                       #LET g_orderA[g_i]= g_x[20]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.tqx02
                                           USING 'yyyymmdd'
                                       #LET g_orderA[g_i]= g_x[21]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr2.tsb02
                                       #LET g_orderA[g_i]= g_x[22]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr2.tsb03
                                       #LET g_orderA[g_i]= g_x[23]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.tqy03
                                      # LET g_orderA[g_i]= g_x[24]
              OTHERWISE LET l_order[g_i]  = '-'
                        #LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
#NO.FUN-860008---end---mark--
#      OUTPUT TO REPORT r247_rep(sr.*,sr2.*)                #NO.FUN-860008
#NO.FUN-860008---end---
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取
        FROM azi_file
       WHERE azi01=sr.tqx09
      #SELECT azp03 INTO l_azp FROM azp_file WHERE azp01=sr.tqy36  #TQC-940087  #FUN-A50102   
      LET l_sql="SELECT occ02",
               #"  FROM ",l_azp CLIPPED,".dbo.occ_file",              #TQC-940087 
               # "  FROM ",s_dbstring(l_azp CLIPPED),"occ_file",   #TQC-940087 #FUN-A50102
                " FROM ", cl_get_target_table( sr.tqy36, 'occ_file' ),         #FUN-A50102
                " WHERE occ01='",sr.tqy03,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102									
      CALL cl_parse_qry_sql(l_sql,sr.tqy36) RETURNING l_sql     #FUN-A50102          
      PREPARE atmr247_prepare1 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM 
      END IF
      DECLARE atmr247_curs1 CURSOR FOR atmr247_prepare1
      IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
      OPEN atmr247_curs1
      FETCH atmr247_curs1 INTO l_occ02
      
     #SELECT azp03 INTO l_azp FROM azp_file WHERE azp01=sr.tqy36 #TQC-940087   
      SELECT tqa02 INTO l_tqa02a FROM tqa_file WHERE tqa01=sr2.tsb04 AND tqa03='1'
      SELECT oaj02 INTO l_oaj02  FROM oaj_file WHERE oaj01=sr2.tsb05
      SELECT tqa02 INTO l_tqa02b FROM tqa_file WHERE tqa01=sr2.tsb08 AND tqa03='8'
      SELECT tqa02 INTO l_tqa02c FROM tqa_file WHERE tqa01=sr2.tsb09 AND tqa03='7'
      SELECT tqa02 INTO l_tqa02d FROM tqa_file WHERE tqa01=sr2.tsb10 AND tqa03='16'
      EXECUTE insert_prep USING
        sr.tqx01,sr.tqx02,sr.tqx05,sr.tqx09,sr.tqy02,sr.tqy03,sr.tqy38,sr.tqy36,
        sr.tqy37,sr2.tsb02,sr2.tsb03,sr2.tsb04,sr2.tsb05,sr2.tsb06,sr2.tsb07,
        sr2.tsb08,sr2.tsb09,sr2.tsb10,sr2.tsb11,sr2.tsb12,l_occ02,l_tqa02a,
        l_tqa02b,l_tqa02c,l_tqa02d,l_oaj02,t_azi05
#NO.FUN-860008---end---
   END FOREACH       
   END FOREACH       
                     
#   FINISH REPORT r247_rep                                  #NO.FUN-860008
#NO.FUN-860008--start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'tqx01,tqx02,tqx03,tqx04,tqx12,tqx13,tqx07')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";", tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
     CALL cl_prt_cs3('atmr247','atmr247',g_sql,g_str) 
#NO.FUN-860008---end---                     
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)             #NO.FUN-860008
                     
END FUNCTION         
#NO.FUN-860008--START---MARK--
#REPORT r247_rep(sr,sr2)
#DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE sr        RECORD order1  LIKE ima_file.ima01,#No.FUN-680120 VARCHAR(40)
#                        order2  LIKE ima_file.ima01,#No.FUN-680120 VARCHAR(40)       
#                        order3  LIKE ima_file.ima01,#No.FUN-680120 VARCHAR(40)     
#                        tqx01   LIKE tqx_file.tqx01,
#                        tqx02   LIKE tqx_file.tqx02,
#                        tqx05   LIKE tqx_file.tqx05,
#                        tqx09   LIKE tqx_file.tqx09,
#                        tqy02   LIKE tqy_file.tqy02,
#                        tqy03   LIKE tqy_file.tqy03,
#                        tqy38   LIKE tqy_file.tqy38,
#                        tqy36   LIKE tqy_file.tqy36,
#                        tqy37   LIKE tqy_file.tqy37
#                        END RECORD,
#          sr1           RECORD                 
#                           curr      LIKE azi_file.azi01, #No.FUN-680120 VARCHAR(04)
#                           amt       LIKE oeb_file.oeb14
#                    END RECORD,
#          sr2           RECORD                 
#                        tsb02   LIKE tsb_file.tsb02,
#                        tsb03   LIKE tsb_file.tsb03,
#                        tsb04   LIKE tsb_file.tsb04,
#                        tsb05   LIKE tsb_file.tsb05,
#                        tsb06   LIKE tsb_file.tsb06,
#                        tsb07   LIKE tsb_file.tsb07,
#                        tsb08   LIKE tsb_file.tsb08,
#                        tsb09   LIKE tsb_file.tsb09,
#                        tsb10   LIKE tsb_file.tsb10,
#                        tsb11   LIKE tsb_file.tsb11,
#                        tsb12   LIKE tsb_file.tsb12
#                    END RECORD,
#                l_str   LIKE ima_file.ima01,  #No.FUN-680120 VARCHAR(40)    
#                l_str1  LIKE ima_file.ima01,  #No.FUN-680120 VARCHAR(40)     
#                l_str2  LIKE gbc_file.gbc05,  #No.FUN-680120 VARCHAR(100)        
#                l_str3  LIKE ima_file.ima01,  #No.FUN-680120 VARCHAR(40)       
#                l_azp    LIKE azp_file.azp02, 
#                l_occ02  LIKE occ_file.occ02, 
#                l_tqa02a LIKE tqa_file.tqa02, 
#                l_tqa02b LIKE tqa_file.tqa02, 
#                l_tqa02c LIKE tqa_file.tqa02, 
#                l_tqa02d LIKE tqa_file.tqa02, 
#                l_oaj02  LIKE oaj_file.oaj02, 
#		l_rowno LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#                l_t1      STRING,  
#                l_t2      STRING,  
#                l_t3      STRING,  
#                l_t4      STRING,  
#                l_t5      STRING,  
#                l_t6      STRING,  
#		l_sum   LIKE feb_file.feb10,  #No.FUN-680120 DECIMAL(10,2)
#		l_sum1  LIKE feb_file.feb10,  #No.FUN-680120 DECIMAL(10,2)
#		l_amt_1 LIKE oeb_file.oeb14,   
#		l_amt_2 LIKE oeb_file.oeb12    
#   DEFINE  l_oeb915    STRING
#   DEFINE  l_oeb912    STRING
#   DEFINE  l_oeb12     STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
# 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.order1,sr.order2,sr.order3,sr.tqx01,sr2.tsb03
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
#      LET g_head1 = g_x[13] CLIPPED,
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
#            g_x[43],
#            g_x[44],
#            g_x[45],
#            g_x[46],
#            g_x[47]
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
##TQC-640165 --begin
#   BEFORE GROUP OF sr.tqx01
#      PRINT COLUMN g_c[31],sr.tqx01 CLIPPED,
#            COLUMN g_c[32],sr.tqx02 CLIPPED,
#            COLUMN g_c[33],sr.tqx05 CLIPPED,
#            COLUMN g_c[34],sr.tqx09 CLIPPED,
#            COLUMN g_c[35],sr2.tsb02 USING '#####';
#
#   BEFORE GROUP OF sr2.tsb03
#      SELECT azi03,azi04,azi05
##       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取  #NO.CHI-6A0004
#        INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取  #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.tqx09
#      LET l_sql="SELECT occ02",
#                "  FROM ",l_azp CLIPPED,".dbo.occ_file",
#                " WHERE occ01='",sr.tqy03,"' " 
#      PREPARE atmr247_prepare1 FROM l_sql
#      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#         EXIT PROGRAM 
#      END IF
#      DECLARE atmr247_curs1 CURSOR FOR atmr247_prepare1
#      IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#      OPEN atmr247_curs1
#      FETCH atmr247_curs1 INTO l_occ02
#      LET l_t1=sr.tqy03 CLIPPED,'  ',l_occ02 CLIPPED
#      PRINT COLUMN g_c[36],sr2.tsb03 CLIPPED,
#            COLUMN g_c[37],l_t1 CLIPPED,
#            COLUMN g_c[38],sr.tqy38 CLIPPED,
#            COLUMN g_c[39],sr.tqy37 CLIPPED;
##TQC-640165 --end  
#
#   ON EVERY ROW
#      SELECT azp03 INTO l_azp FROM azp_file WHERE azp01=sr.tqy36
#      SELECT tqa02 INTO l_tqa02a FROM tqa_file WHERE tqa01=sr2.tsb04 AND tqa03='1'
#      SELECT oaj02 INTO l_oaj02  FROM oaj_file WHERE oaj01=sr2.tsb05
#      SELECT tqa02 INTO l_tqa02b FROM tqa_file WHERE tqa01=sr2.tsb08 AND tqa03='8'
#      SELECT tqa02 INTO l_tqa02c FROM tqa_file WHERE tqa01=sr2.tsb09 AND tqa03='7'
#      SELECT tqa02 INTO l_tqa02d FROM tqa_file WHERE tqa01=sr2.tsb10 AND tqa03='16'
#      LET l_t2=sr2.tsb04 CLIPPED,'  ',l_tqa02a CLIPPED
#      LET l_t3=sr2.tsb05 CLIPPED,'  ',l_oaj02 CLIPPED
#      LET l_t4=sr2.tsb08 CLIPPED,'  ',l_tqa02b CLIPPED
#      LET l_t5=sr2.tsb09 CLIPPED,'  ',l_tqa02c CLIPPED
#      LET l_t6=sr2.tsb10 CLIPPED,'  ',l_tqa02d CLIPPED
#      PRINT COLUMN g_c[40],l_t2 CLIPPED,
#            COLUMN g_c[41],l_t3 CLIPPED,
##           COLUMN g_c[42],cl_numfor(sr2.tsb06,42,g_azi05),   #NO.CHI-6A0004
#            COLUMN g_c[42],cl_numfor(sr2.tsb06,42,t_azi05),   #NO.CHI-6A0004
#            COLUMN g_c[43],l_t4 CLIPPED,
#            COLUMN g_c[44],l_t5 CLIPPED,
#            COLUMN g_c[45],l_t6 CLIPPED,
#            COLUMN g_c[46],sr2.tsb11 CLIPPED,
#            COLUMN g_c[47],sr2.tsb12 CLIPPED
#      INSERT INTO curr_tmp VALUES(sr.tqx09,sr2.tsb06,
#                                  sr.order1,sr.order2,sr.order3)
#		
#   AFTER GROUP OF sr.order1            #金額小計
#      IF tm.u[1,1] = 'Y' THEN
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*
##          SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#           SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#                WHERE azi01 = sr1.curr
#               LET l_str = sr1.curr CLIPPED
#               PRINT COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+g_w[42]+4]
#               PRINT COLUMN g_c[39],g_orderA[1] CLIPPED,
#                     COLUMN g_c[40],g_x[11] CLIPPED,
#                     COLUMN g_c[41],l_str CLIPPED,
##                    COLUMN g_c[42],cl_numfor(sr1.amt,42,g_azi05) CLIPPED   #NO.CHI-6A0004
#                     COLUMN g_c[42],cl_numfor(sr1.amt,42,t_azi05) CLIPPED   #NO.CHI-6A0004
#         END FOREACH
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order2            #金額小計
#      IF tm.u[2,2] = 'Y' THEN
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED
#             PRINT COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+g_w[42]+4]
#             PRINT COLUMN g_c[39],g_orderA[2] CLIPPED,
#                   COLUMN g_c[40],g_x[11] CLIPPED,
#                   COLUMN g_c[41],l_str CLIPPED,
##                  COLUMN g_c[42],cl_numfor(sr1.amt,42,g_azi05) CLIPPED   #NO.CHI-6A0004
#                   COLUMN g_c[42],cl_numfor(sr1.amt,42,t_azi05) CLIPPED   #NO.CHI-6A0004
#         END FOREACH
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3            #金額小計
#      IF tm.u[3,3] = 'Y' THEN
#         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file    #NO.CHI-6A0004
#             SELECT azi05 INTO t_azi05 FROM azi_file    #NO.CHI-6A0004
#              WHERE azi01 = sr1.curr
#             LET l_str = sr1.curr CLIPPED
#             PRINT COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+g_w[41]+g_w[42]+4]
#             PRINT COLUMN g_c[39],g_orderA[3] CLIPPED,
#                   COLUMN g_c[40],g_x[11] CLIPPED,
#                   COLUMN g_c[41],l_str CLIPPED,
##                  COLUMN g_c[42],cl_numfor(sr1.amt,42,g_azi05) CLIPPED   #NO.CHI-6A0004
#                   COLUMN g_c[42],cl_numfor(sr1.amt,42,t_azi05) CLIPPED   #NO.CHI-6A0004
#         END FOREACH
#         PRINT ''
#      END IF
#
#   ON LAST ROW                         #金額總計
#      PRINT ''
#      PRINT COLUMN g_c[40],g_dash2[1,g_w[40]+g_w[41]+g_w[42]+3]
#      PRINT COLUMN g_c[40],g_x[12] CLIPPED;
#      FOREACH tmp4_cs INTO sr1.*
##         SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#          SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#           WHERE azi01 = sr1.curr
#          LET l_str = sr1.curr CLIPPED
#          PRINT COLUMN g_c[41],l_str CLIPPED,
##               COLUMN g_c[42],cl_numfor(sr1.amt,42,g_azi05)   #NO.CHI-6A0004
#                COLUMN g_c[42],cl_numfor(sr1.amt,42,t_azi05)   #NO.CHI-6A0004
#      END FOREACH
#      PRINT ''
#
#      #是否列印選擇條件
##     IF g_zz05 = 'Y' THEN
##        CALL cl_wcchp(tm.wc,'tqx01,tqx02,tsb02,oea04,oea05')
##             RETURNING tm.wc
##        PRINT g_dash[1,g_len]
##CALL cl_prt_pos_wc(tm.wc)
##     END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
##    PRINT  COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-710043 mark
#     PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED  #No.TQC-710043
#
#   #表尾列印
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
##    PRINT     COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-710043 mark
#     PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED  #No.TQC-710043
#      ELSE
#         SKIP 2 LINE
#      END IF
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4]
#             PRINT g_memo
#      END IF
#
#END REPORT
#NO.FUN-860008---END---MARK---
#No.FUN-8701
