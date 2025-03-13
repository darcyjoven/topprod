# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: atmr232.4gl
# Descriptions...: 客戶訂單明細表
# Date & Author..: 06/03/16 by wujie
# Modify.........: No.FUN-630056 06/04/18 By wujie   客戶欄位調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By Rayven 報表缺少程序名
# Modify.........: No.FUN-710058 07/02/06 By jamie 放寬欄位 報表格式修改
# Modify.........: No.FUN-850164 08/06/26 By Cockroach 報表轉CR
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
                     wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)           # QBE 條件
                     s       LIKE type_file.chr4,               # Prog. Version..: '5.30.06-13.03.12(03)            # 排列 (INPUT 條件)
                     t       LIKE type_file.chr4,               # Prog. Version..: '5.30.06-13.03.12(03)            # 跳頁 (INPUT 條件)
                     u       LIKE type_file.chr4,               # Prog. Version..: '5.30.06-13.03.12(03)            # 合計 (INPUT 條件)
                     a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
                     b       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
                     c       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
                     more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)            # 輸入其它特殊列印條件
                  END RECORD
DEFINE g_orderA   ARRAY[3] OF LIKE zaa_file.zaa08             #No.FUN-680120 VARCHAR(10)  # 篩選排序條件用變數
DEFINE g_i        LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_head1    STRING
DEFINE g_sma115   LIKE sma_file.sma115
DEFINE g_sma116   LIKE sma_file.sma116
DEFINE l_sql      LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num10         #No.FUN-680120 INTEGER
#FUN-850164  --START--
   DEFINE   l_table      STRING                  
   DEFINE   g_sql        STRING                   
   DEFINE   g_str        STRING  
#FUN-850164  --END--
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
   LET tm.b     = ARG_VAL(12)
   LET tm.c     = ARG_VAL(13)
   LET tm.more  = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#FUN-850164  --START--
   LET g_sql =          "order1.gem_file.gem02,",
                        "order2.gem_file.gem02,",
                        "order3.gem_file.gem02,",
                        "oea00.oea_file.oea00,",
                        "oea01.oea_file.oea01,",
                        "oea02.oea_file.oea02,",
                        "oea03.oea_file.oea03,",
                        "oea032.oea_file.oea032,",
                        "oea1011.oea_file.oea1011,",
                        "oea1011_occ02.occ_file.occ02,",
                        "oea1015.oea_file.oea1015,",
                        "oea1015_pmc03.pmc_file.pmc03,",
                        "oea1004.oea_file.oea1004,",
                        "oea1004_occ02.occ_file.occ02,",
                        "oea17.oea_file.oea17,",  
                        "oea17_occ02.occ_file.occ02,",
                        "oeb1003.oeb_file.oeb1003,",
                        "oeb1012.oeb_file.oeb1012,",
                        "oeb1013.oeb_file.oeb1013,",
                        "oea04.oea_file.oea04,",
                        "occ02.occ_file.occ02,",
                        "gen02.gen_file.gen02,",
                        "gem02.gem_file.gem02,",
                        "oea23.oea_file.oea23,",
                        "oea21.oea_file.oea21,",
                        "oea12.oea_file.oea12,",
                        "oea31.oea_file.oea31,",
                        "oea32.oea_file.oea32,",
                        "oeahold.oea_file.oeahold,",
                        "oeaconf.oea_file.oeaconf,",
                        "oea14.oea_file.oea14,", 
                        "oea15.oea_file.oea15,", 
                        "oeb03.oeb_file.oeb03,",
                        "oeb04.oeb_file.oeb04,",
                        "oeb06.oeb_file.oeb06,",
                        "oeb05.oeb_file.oeb05,",
                        "oeb12.oeb_file.oeb12,",
                        "oeb13.oeb_file.oeb13,",
                        "oeb14.oeb_file.oeb14,",
                        "oeb15.oeb_file.oeb15,",
                        "oeb910.oeb_file.oeb910,",
                        "oeb912.oeb_file.oeb912,",
                        "oeb913.oeb_file.oeb913,",
                        "oeb915.oeb_file.oeb915,",
                        "oeb916.oeb_file.oeb916,",
                        "oeb917.oeb_file.oeb917,",
                        "l_ima021.ima_file.ima021,",
                        "l_str2.type_file.chr1000,",
                        "azi03.azi_file.azi03,",
                        "azi04.azi_file.azi04,",
                        "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('atmr232',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   
#FUN-850164  --END--  
   #No.8991
   #DROP TABLE curr_tmp
   # No.FUN-680120-BEGIN
#FUN-850164 --MARK START--
#  CREATE TEMP TABLE curr_tmp(
#    method  LIKE type_file.chr1,  
#    curr    LIKE ade_file.ade04,
#    amt     LIKE type_file.num20_6,
#    oeb1013 LIKE type_file.num20_6,
#    order1  LIKE ima_file.ima01,
#    order2  LIKE ima_file.ima01,
#    order3  LIKE ima_file.ima01);
#  # No.FUN-680120-END 
#  #No.8991(end)
#FUN-850164 --MARK END--
   IF NOT cl_null(tm.wc) THEN
      CALL r232()
      DROP TABLE curr_tmp
   ELSE
      CALL r232_tm(0,0)
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r232_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r232_w AT p_row,p_col WITH FORM "atm/42f/atmr232"
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
   LET tm.b    = '3'
   LET tm.c    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,    #No.FUN-630056    
                                 oea14,oea15,oea23,oea12,oeahold
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()        
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea5"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
 
               WHEN INFIELD(oea03)    #No.FUN-630056
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea03  #No.FUN-630056
                 NEXT FIELD oea03  #No.FUN-630056
 
               WHEN INFIELD(oea04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea04
                 NEXT FIELD oea04
 
               WHEN INFIELD(oea14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea14
                 NEXT FIELD oea14
 
               WHEN INFIELD(oea15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea15
                 NEXT FIELD oea15
 
            END CASE
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r232_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.c,tm.more
            WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[123]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES '[123]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF tm.c NOT MATCHES '[YN]' THEN
               NEXT FIELD c
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
         LET INT_FLAG = 0
         CLOSE WINDOW r232_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='atmr232'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr232','9031',1)
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
            CALL cl_cmdat('atmr232',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r232_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r232()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp 
 
   CLOSE WINDOW r232_w
 
END FUNCTION
 
FUNCTION r232()
DEFINE l_name    LIKE type_file.chr20         #No.FUN-680120 VARCHAR(20)         # External(Disk) file name
#DEFINE  l_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     LIKE type_file.chr1000       # SQL STATEMENT        #No.FUN-680120 VARCHAR(1000)
DEFINE l_za05    LIKE ima_file.ima04          #No.FUN-680120 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF    LIKE ima_file.ima01                  #No.FUN-680120 VARCHAR(40)              
DEFINE sr        RECORD order1  LIKE gem_file.gem02,                 #No.FUN-680120 VARCHAR(40)       
                        order2  LIKE gem_file.gem02,                 #No.FUN-680120 VARCHAR(40)            
                        order3  LIKE gem_file.gem02,                 #No.FUN-680120 VARCHAR(40)      
                        oea00   LIKE oea_file.oea00,
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,
                        oea03   LIKE oea_file.oea03,  #No.FUN-630056
                        oea032  LIKE oea_file.oea032, #客戶簡稱
                        oea1011   LIKE oea_file.oea1011,
                        oea1011_occ02  LIKE occ_file.occ02,	#客戶簡稱
				oea1015   LIKE oea_file.oea1015,
                        oea1015_pmc03  LIKE pmc_file.pmc03,	#客戶簡稱
                        oea1004   LIKE oea_file.oea1004,
                        oea1004_occ02  LIKE occ_file.occ02,	#客戶簡稱
                        oea17     LIKE oea_file.oea17,  
                        oea17_occ02    LIKE occ_file.occ02,  	#客戶簡稱
                        oeb1003   LIKE oeb_file.oeb1003,
                        oeb1012   LIKE oeb_file.oeb1012,
                        oeb1013   LIKE oeb_file.oeb1013,
                        oea04   LIKE oea_file.oea04,	#客戶編號
                        occ02   LIKE occ_file.occ02,	#客戶簡稱
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea23   LIKE oea_file.oea23,
                        oea21   LIKE oea_file.oea21,
                        oea12   LIKE oea_file.oea12,
                        oea31   LIKE oea_file.oea31,
                        oea32   LIKE oea_file.oea32,
                        oeahold LIKE oea_file.oeahold,
                        oeaconf LIKE oea_file.oeaconf,
                        oea14   LIKE oea_file.oea14, 
                        oea15   LIKE oea_file.oea15, 
                        oeb03   LIKE oeb_file.oeb03,
                        oeb04   LIKE oeb_file.oeb04,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,
                        oeb12   LIKE oeb_file.oeb12,
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
                        oeb15   LIKE oeb_file.oeb15,
                        oeb910  LIKE oeb_file.oeb910,
                        oeb912  LIKE oeb_file.oeb912,
                        oeb913  LIKE oeb_file.oeb913,
                        oeb915  LIKE oeb_file.oeb915,
                        oeb916  LIKE oeb_file.oeb916,
                        oeb917  LIKE oeb_file.oeb917 
                        END RECORD
 
#FUN-850164 --END--  
DEFINE          l_str    LIKE ima_file.ima01,         
                l_str1   LIKE ima_file.ima01,     
                l_str2   LIKE type_file.chr1000,        
                l_str3   LIKE ima_file.ima01,          
                l_ima021 LIKE ima_file.ima021, 
		l_rowno  LIKE type_file.num5,  
		l_amt_1  LIKE oeb_file.oeb14,  
		l_total1 LIKE oeb_file.oeb12,   
		l_total2 LIKE oeb_file.oeb12,   
		l_amt_2  LIKE oeb_file.oeb12, 
                l_ima906 LIKE ima_file.ima906
   DEFINE  l_oeb915    STRING
   DEFINE  l_oeb912    STRING
   DEFINE  l_oeb12     STRING 
   DEFINE  m_azi03     LIKE azi_file.azi03
   DEFINE  m_azi04     LIKE azi_file.azi04  
   DEFINE  m_azi05     LIKE azi_file.azi05
   DEFINE  sr1       RECORD               
                           curr      LIKE azi_file.azi01,       
                           amt       LIKE oeb_file.oeb14,
                           oeb1013   LIKE oeb_file.oeb1013
                     END RECORD
   CALL  cl_del_data(l_table) 
#FUN-850164 --END--          
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
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
#FUN-850164 --START--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?
                        ,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? 
                        ,?,?,?,?,?, ?,?,?,?,?, ?                    )"                                                                                  
     PREPARE insert_prep FROM g_sql                                                                                                   
     IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM                                                                             
     END IF 
     
#FUN-850164 --END--   
   
 
   #No.8991   (針對幣別加總)
   DELETE FROM curr_tmp;
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(oeb1013) FROM curr_tmp ",    #group 1 小計
             "  WHERE order1=? ",
             "    AND method=?",
             "  GROUP BY curr"
   PREPARE tmp1_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_1:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(oeb1013) FROM curr_tmp ",    #group 2 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND method=?",
             "  GROUP BY curr  "
   PREPARE tmp2_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_2:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(oeb1013) FROM curr_tmp ",    #group 3 小計
             "  WHERE order1=? ",
             "    AND order2=? ",
             "    AND order3=? ",
             "    AND method=?",
             "  GROUP BY curr  "
   PREPARE tmp3_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_3:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
   LET l_sql=" SELECT curr,SUM(amt),SUM(oeb1013) FROM curr_tmp ",    #on last row 總計
             "  WHERE method=?",
             "  GROUP BY curr  "
   PREPARE tmp4_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('pre_4:',SQLCA.sqlcode,1)
      RETURN
   END IF
   DECLARE tmp4_cs CURSOR FOR tmp4_pre
   #No.8991(end)
 
#CHI-6A0004 --START
#  SELECT azi03,azi04,azi05
#    INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#    FROM azi_file
#   WHERE azi01=g_aza.aza17
#CHI-6A0004 --END
 
   LET l_sql = "SELECT '','','',                                ",
               "      oea00,oea01, oea02, oea03, A.occ02,  ",  #No.FUN-630056
               "      oea1011,C.occ02,oea1015,pmc03,oea1004,E.occ02,",
               "      oea17,F.occ02,oeb1003,oeb1012,oeb1013,oea04, B.occ02,",
               "      gen02, gem02, oea23, oea21, oea12, oea31, ",
               "      oea32, oeahold,oeaconf,oea14,oea15,", 
               "      oeb03, oeb04, oeb06,",                
               "      oeb05, oeb12, oeb13,oeb14, oeb15 ",
               "      ,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ",  
               " FROM oea_file, OUTER occ_file A,OUTER occ_file B,",
               "      OUTER occ_file C,OUTER occ_file E,OUTER occ_file F,OUTER pmc_file,",
               "      OUTER gen_file, OUTER gem_file, oeb_file ",
               " WHERE oea_file.oea03 = A.occ01 AND B.occ01 = oea_file.oea04  ",  #No.FUN-630056
               "   AND gen_file.gen01 = oea_file.oea14 ",
               "   AND  gem_file.gem01 = oea_file.oea15 AND oea01=oeb01 AND oeaconf!='X' ",
               "   AND oea_file.oea1011 =C.occ01",
               "   AND oea_file.oea1015 =pmc_file.pmc01",
               "   AND oea_file.oea1004 =E.occ01",
               "   AND oea_file.oea17   =F.occ01",
               "   AND ", tm.wc CLIPPED
 
   PREPARE r232_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE r232_curs1 CURSOR FOR r232_prepare1
#FUN-850164 --MARK START--
#   CALL cl_outnam('atmr232') RETURNING l_name
 
  SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
#  IF g_sma.sma116 MATCHES '[23]' THEN 
#     LET g_zaa[52].zaa06 = "Y"
#     LET g_zaa[53].zaa06 = "Y"
#     LET g_zaa[58].zaa06 = "N"
#     LET g_zaa[59].zaa06 = "N"
#  ELSE
#     LET g_zaa[52].zaa06 = "N"
#     LET g_zaa[53].zaa06 = "N"
#     LET g_zaa[58].zaa06 = "Y"
#     LET g_zaa[59].zaa06 = "Y"
#  END IF
 
#  IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN  
#     LET g_zaa[57].zaa06 = "N"
#  ELSE
#     LET g_zaa[57].zaa06 = "Y"
#  END IF
#  CALL cl_prt_pos_len()
 
#  START REPORT r232_rep TO l_name
#   LET g_pageno = 0
#FUN-850164 --MARK END
 
   FOREACH r232_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF tm.a = '1' AND sr.oeaconf = 'N' THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.a = '2' AND sr.oeaconf = 'Y' THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.b = '1' AND cl_null(sr.oeahold) THEN
         CONTINUE FOREACH
      END IF
 
      IF tm.b = '2' AND NOT cl_null(sr.oeahold) THEN
         CONTINUE FOREACH
      END IF
 
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea01
                                       LET g_orderA[g_i]= g_x[20]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea02
                                           USING 'yyyymmdd'
                                       LET g_orderA[g_i]= g_x[21]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea03  #No.FUN-630056
                                       LET g_orderA[g_i]= g_x[22]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea04
                                       LET g_orderA[g_i]= g_x[23]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.gen02
                                       LET g_orderA[g_i]= g_x[24]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.gem02
                                       LET g_orderA[g_i]= g_x[25]
              WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
                                       LET g_orderA[g_i]= g_x[26]
              WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oea12
                                       LET g_orderA[g_i]= g_x[27]
              WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i]=sr.oeahold
                                       LET g_orderA[g_i]= g_x[28]
              OTHERWISE LET l_order[g_i]  = '-'
                        LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
 
      IF cl_null(sr.oeb1013) THEN
         LET sr.oeb1013 =0
      END IF
#FUN-850164 --START--
      IF sr.oeb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
          WHERE ima01 = sr.oeb04
      ELSE
         LET l_ima021 = ''
      END IF
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.oeb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                    LET l_str2 = l_oeb912, sr.oeb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                      LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                    LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN   
            IF sr.oeb910 <> sr.oeb916 THEN
               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
               LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
            END IF
      END IF
      SELECT azi03,azi04,azi05
        INTO m_azi03,m_azi04,m_azi05 
        FROM azi_file
       WHERE azi01=sr.oea23
       
      EXECUTE insert_prep USING
      sr.order1,sr.order2,sr.order3,sr.oea00,sr.oea01,sr.oea02,
      sr.oea03,sr.oea032,sr.oea1011,sr.oea1011_occ02,sr.oea1015,
      sr.oea1015_pmc03,sr.oea1004,sr.oea1004_occ02,sr.oea17,
      sr.oea17_occ02,sr.oeb1003,sr.oeb1012,sr.oeb1013,sr.oea04,
      sr.occ02,sr.gen02,sr.gem02,sr.oea23,sr.oea21,sr.oea12,
      sr.oea31,sr.oea32,sr.oeahold,sr.oeaconf,sr.oea14,sr.oea15,
      sr.oeb03,sr.oeb04,sr.oeb06,sr.oeb05,sr.oeb12,sr.oeb13,
      sr.oeb14,sr.oeb15,sr.oeb910,sr.oeb912,sr.oeb913,sr.oeb915,
      sr.oeb916,sr.oeb917,l_ima021,l_str2,m_azi03,m_azi04,m_azi05
    END FOREACH
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                             
    LET g_str = ''
    IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea14,oea15,oea23,oea12,oeahold')
#                     oea14,oea15,oea23,oea12,oeahold') 
              RETURNING tm.wc
    END IF
    LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                          tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                          tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]
    IF g_sma.sma116 MATCHES '[23]' THEN 
       CALL cl_prt_cs3('atmr232','atmr232',l_sql,g_str)
    ELSE IF g_sma115 = "Y" THEN 
            CALL cl_prt_cs3('atmr232','atmr232_1',l_sql,g_str)
         ELSE 
            CALL cl_prt_cs3('atmr232','atmr232_2',l_sql,g_str)   
         END IF
    END IF   
 
 
 
#FUN-850164 --END--
#FUN-850164 --MARK START--
#     OUTPUT TO REPORT r232_rep(sr.*)
#  END FOREACH
 
#  FINISH REPORT r232_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
#REPORT r232_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE l_tab        LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
#DEFINE sr           RECORD order1 LIKE gem_file.gem02,     #No.FUN-680120 VARCHAR(40)  
#                          order2 LIKE gem_file.gem02,     #No.FUN-680120 VARCHAR(40)  
#                          order3 LIKE gem_file.gem02,     #No.FUN-680120 VARCHAR(40)  
#                       oea00   LIKE oea_file.oea00,
#                       oea01   LIKE oea_file.oea01,
#                       oea02   LIKE oea_file.oea02,
#                       oea03   LIKE oea_file.oea03,  #No.FUN-630056
#                       oea032  LIKE oea_file.oea032, #客戶簡稱
#                       oea1011   LIKE oea_file.oea1011,
#                       oea1011_occ02  LIKE occ_file.occ02,	#客戶簡稱
#                       oea1015   LIKE oea_file.oea1015,
#                       oea1015_pmc03  LIKE pmc_file.pmc03,	#客戶簡稱
#                       oea1004   LIKE oea_file.oea1004,
#                       oea1004_occ02  LIKE occ_file.occ02,	#客戶簡稱
#                       oea17     LIKE oea_file.oea17,  
#                       oea17_occ02    LIKE occ_file.occ02,  	#客戶簡稱
#                       oeb1003   LIKE oeb_file.oeb1003,
#                       oeb1012   LIKE oeb_file.oeb1012,
#                       oeb1013   LIKE oeb_file.oeb1013,
#                       oea04   LIKE oea_file.oea04,	#客戶編號
#                       occ02   LIKE occ_file.occ02,	#客戶簡稱
#                       gen02   LIKE gen_file.gen02,
#                       gem02   LIKE gem_file.gem02,
#                       oea23   LIKE oea_file.oea23,
#                       oea21   LIKE oea_file.oea21,
#                       oea12   LIKE oea_file.oea12,
#                       oea31   LIKE oea_file.oea31,
#                       oea32   LIKE oea_file.oea32,
#                       oeahold LIKE oea_file.oeahold,
#                       oeaconf LIKE oea_file.oeaconf,
#                       oea14   LIKE oea_file.oea14, 
#                       oea15   LIKE oea_file.oea15, 
#                       oeb03   LIKE oeb_file.oeb03,
#                       oeb04   LIKE oeb_file.oeb04,
#                       oeb06   LIKE oeb_file.oeb06,
#                       oeb05   LIKE oeb_file.oeb05,
#                       oeb12   LIKE oeb_file.oeb12,
#                       oeb13   LIKE oeb_file.oeb13,
#                       oeb14   LIKE oeb_file.oeb14,
#                       oeb15   LIKE oeb_file.oeb15,
#                       oeb910  LIKE oeb_file.oeb910,
#                       oeb912  LIKE oeb_file.oeb912,
#                       oeb913  LIKE oeb_file.oeb913,
#                       oeb915  LIKE oeb_file.oeb915,
#                       oeb916  LIKE oeb_file.oeb916,
#                       oeb917  LIKE oeb_file.oeb917 
#                   END RECORD,
#         sr1           RECORD                 #No.8991
#                          curr      LIKE azi_file.azi01,             #No.FUN-680120 VARCHAR(04) 
#                          amt       LIKE oeb_file.oeb14,
#                          oeb1013   LIKE oeb_file.oeb1013
#                   END RECORD,
#               l_str   LIKE ima_file.ima01,     #No.FUN-680120 VARCHAR(40)         
#               l_str1  LIKE ima_file.ima01,     #No.FUN-680120 VARCHAR(40)       
#               l_str2  LIKE type_file.chr1000,  #No.FUN-680120 VARCHAR(1000)           
#               l_str3  LIKE ima_file.ima01,     #No.FUN-680120 VARCHAR(40)          
#               l_ima021 LIKE ima_file.ima021, 
#       	l_rowno LIKE type_file.num5,     #No.FUN-680120 SMALLINT
#       	l_amt_1 LIKE oeb_file.oeb14,  
#       	l_total1 LIKE oeb_file.oeb12,   
#       	l_total2 LIKE oeb_file.oeb12,   
#       	l_amt_2 LIKE oeb_file.oeb12   
#  DEFINE  l_oeb915    STRING
#  DEFINE  l_oeb912    STRING
#  DEFINE  l_oeb12     STRING
#  DEFINE  l_ima906    LIKE ima_file.ima906
#
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER EXTERNAL BY sr.order1,sr.order2,sr.order3     #No:8262
 
# #格式設定
# FORMAT
#  #列印表頭
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     LET g_head1 = g_x[13] CLIPPED,
#                   g_orderA[1] CLIPPED,'-',
#                   g_orderA[2] CLIPPED,'-',
#                   g_orderA[3] CLIPPED
#     PRINT g_head1
 
#
#
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],
#           g_x[32],
#           g_x[33],
#           g_x[34],
#           g_x[35],
#           g_x[36],
#           g_x[37],
#           g_x[38],
#           g_x[39],
#           g_x[40],
#           g_x[41],
#           g_x[42],
#           g_x[43],
#           g_x[44],
#           g_x[45],
#           g_x[46],
#           g_x[47],
#           g_x[48],
#           g_x[49],
#           g_x[50],
#           g_x[51],
#           g_x[57],
#           g_x[58],
#           g_x[59],
#           g_x[52],
#           g_x[53],
#           g_x[54],
#           g_x[55],
#           g_x[56],
#           g_x[60],
#           g_x[61],
#           g_x[62],
#           g_x[63],
#           g_x[66],
#           g_x[67],
#           g_x[69],
#           g_x[68],
#           g_x[70]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y'           #跳頁控制
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2       #跳頁控制
#     IF tm.t[2,2] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3       #跳頁控制
#     IF tm.t[3,3] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.oea01
#     SELECT azi03,azi04,azi05
##       INTO g_azi03,g_azi04,g_azi05          #NO.CHI-6A0004
#       INTO t_azi03,t_azi04,t_azi05          #NO.CHI-6A0004
#       FROM azi_file
#      WHERE azi01=sr.oea23
#     PRINT COLUMN g_c[31],sr.oea01 CLIPPED,
#           COLUMN g_c[32],sr.oea02 CLIPPED,
#           COLUMN g_c[33],sr.oea03 CLIPPED,  #No.FUN-630056
#           COLUMN g_c[34],sr.oea032 CLIPPED, #No.FUN-630056
#           COLUMN g_c[35],sr.oea04 CLIPPED,
#           COLUMN g_c[36],sr.occ02 CLIPPED,
#           COLUMN g_c[60],sr.oea1011 CLIPPED,
#           COLUMN g_c[61],sr.oea1011_occ02 CLIPPED;
#      IF sr.oea00 MATCHES '[12345]' THEN
#         PRINT COLUMN g_c[62],' ',
#               COLUMN g_c[63],' ';
#      END IF
#      IF sr.oea00 ='7' THEN
#         PRINT COLUMN g_c[62],sr.oea1015 CLIPPED,
#               COLUMN g_c[63],sr.oea1015_pmc03 CLIPPED;
#      END IF
#      IF sr.oea00 ='6' THEN
#         PRINT COLUMN g_c[62],sr.oea1004 CLIPPED,
#               COLUMN g_c[63],sr.oea1004_occ02 CLIPPED;
#      END IF
#     PRINT COLUMN g_c[66],sr.oea17 CLIPPED,
#           COLUMN g_c[67],sr.oea17_occ02 CLIPPED,
#           COLUMN g_c[37],sr.oea14 CLIPPED,
#           COLUMN g_c[38],sr.gen02 CLIPPED,
#           COLUMN g_c[39],sr.oea15 CLIPPED,
#           COLUMN g_c[40],sr.gem02 CLIPPED,
#           COLUMN g_c[41],sr.oea23 CLIPPED,
#           COLUMN g_c[42],sr.oea12 CLIPPED,
#           COLUMN g_c[43],sr.oea31 CLIPPED,
#           COLUMN g_c[44],sr.oea21 CLIPPED,
#           COLUMN g_c[45],sr.oea32 CLIPPED,
#           COLUMN g_c[46],sr.oeahold CLIPPED,
#           COLUMN g_c[47],sr.oeaconf CLIPPED;
#
#  ON EVERY ROW
#     IF sr.oeb04[1,4] !='MISC' THEN
#        SELECT ima021 INTO l_ima021 FROM ima_file
#         WHERE ima01 = sr.oeb04
#     ELSE
#        LET l_ima021 = ''
#     END IF
 
#     SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                        WHERE ima01=sr.oeb04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#               LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#               IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
#                   CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                   LET l_str2 = l_oeb912, sr.oeb910 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
#                     CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                     LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
#                   CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                   LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#     IF g_sma.sma116 MATCHES '[23]' THEN   
#           IF sr.oeb910 <> sr.oeb916 THEN
#              CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
#              LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
#           END IF
#     END IF
#     PRINT COLUMN g_c[48],sr.oeb03 USING '####';
#           IF sr.oeb1003 ='1' THEN
#              PRINT COLUMN g_c[68],sr.oeb1003,'-',g_x[80];
#           ELSE
#              PRINT COLUMN g_c[68],sr.oeb1003,'-',g_x[71];
#           END IF
#    PRINT  COLUMN g_c[50],sr.oeb06 CLIPPED,
#           #COLUMN g_c[49],sr.oeb04[1,20] CLIPPED,
#           COLUMN g_c[49],sr.oeb04 CLIPPED,   
#           COLUMN g_c[51],l_ima021 CLIPPED,
#           COLUMN g_c[69],sr.oeb1012,
#           COLUMN g_c[57],l_str2 CLIPPED,    
#           COLUMN g_c[58],sr.oeb916 CLIPPED, 
#           COLUMN g_c[59],sr.oeb917 USING '###########&.##' CLIPPED,   
#           COLUMN g_c[52],sr.oeb05 CLIPPED,
#           COLUMN g_c[53],sr.oeb12 USING '###########&.##',
##           COLUMN g_c[54],cl_numfor(sr.oeb13,54,g_azi03),   #NO.CHI-6A0004
#           COLUMN g_c[54],cl_numfor(sr.oeb13,54,t_azi03),   #NO.CHI-6A0004
##           COLUMN g_c[55],cl_numfor(sr.oeb14,55,g_azi04),   #NO.CHI-6A0004
#           COLUMN g_c[55],cl_numfor(sr.oeb14,55,t_azi04),
#           COLUMN g_c[56],sr.oeb15 CLIPPED,
##           COLUMN g_c[70],cl_numfor(sr.oeb1013,70,g_azi04)  #NO.CHI-6A0004
#           COLUMN g_c[70],cl_numfor(sr.oeb1013,70,t_azi04)  #NO.CHI-6A0004
#     #No.8991
#     INSERT INTO curr_tmp VALUES(sr.oeb1003,sr.oea23,sr.oeb14,sr.oeb1013,
#                                 sr.order1,sr.order2,sr.order3)
#     #No.8991(end)
#       	
#  AFTER GROUP OF sr.order1            #金額小計
#     IF tm.u[1,1] = 'Y' THEN
#        PRINT COLUMN g_c[51],g_orderA[1] CLIPPED;
##出貨小計
#        LET l_total1= GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 <> 'Y'
#        PRINT COLUMN g_c[69],g_x[72] CLIPPED,
#             #COLUMN g_c[59],l_total1 USING '############.##',  #FUN-710058 mod
#              COLUMN g_c[59],l_total1 USING '###########&.##',  #FUN-710058 mod
#              COLUMN g_c[53],l_total1 USING '############.##';
#        LET l_tab =0
#        FOREACH tmp1_cs USING sr.order1,'1' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file            #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file            #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            LET l_tab =1
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED    #NO.CHI-6A0004
#                  COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED    #NO.CHI-6A0004
#        END FOREACH
#        IF l_tab=0 THEN
#           PRINT 
#        END IF
##搭贈小計
#        LET l_total2= GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 = 'Y'
#        PRINT COLUMN g_c[69],g_x[73] CLIPPED,
#             #COLUMN g_c[59],l_total2 USING '############.##',   #FUN-710058 mod
#              COLUMN g_c[59],l_total2 USING '###########&.##',   #FUN-710058 mod
#              COLUMN g_c[53],l_total2 USING '############.##'
##可扣小計
#        PRINT COLUMN g_c[69],g_x[74] CLIPPED;
#        LET l_tab =0
#        FOREACH tmp1_cs USING sr.order1,'2' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file       #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file       #NO.CHI-6A0004 
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            LET l_tab =1
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED       #NO.CHI-6A0004
#                  COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED       #NO.CHI-6A0004
#        END FOREACH
#        IF l_tab=0 THEN
#           PRINT 
#        END IF
##應返小計
#        PRINT COLUMN g_c[69],g_x[78] CLIPPED;
#        FOREACH tmp1_cs USING sr.order1,'2' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file       #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file       #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,g_azi05) CLIPPED   #NO.CHI-6A0004
#                  COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,t_azi05) CLIPPED   #NO.CHI-6A0004
#        END FOREACH
#        PRINT ' '
#     END IF
 
#  AFTER GROUP OF sr.order2            #金額小計
#     IF tm.u[2,2] = 'Y' THEN
#        PRINT COLUMN g_c[51],g_orderA[2] CLIPPED;
##出貨小計
#        LET l_total1= GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 ='N'
#        PRINT COLUMN g_c[69],g_x[72] CLIPPED,
#             #COLUMN g_c[59],l_total1 USING '############.##',  #FUN-710058 mod
#              COLUMN g_c[59],l_total1 USING '###########&.##',  #FUN-710058 mod
#              COLUMN g_c[53],l_total1 USING '############.##';
#        LET l_tab =0
#        FOREACH tmp2_cs USING sr.order1,sr.order2,'1' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file        #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file        #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            LET l_tab =1
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED    #NO.CHI-6A0004
#                  COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED    #NO.CHI-6A0004
#        END FOREACH
#        IF l_tab=0 THEN                                                                                                            
#           PRINT                                                                                                                   
#        END IF  
##搭贈小計
#        LET l_total2= GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 = 'Y'
#        PRINT COLUMN g_c[69],g_x[73] CLIPPED,
#             #COLUMN g_c[59],l_total2 USING '############.##',  #FUN-710058 mod
#              COLUMN g_c[59],l_total2 USING '###########&.##',  #FUN-710058 mod
#              COLUMN g_c[53],l_total2 USING '############.##'
##可扣小計
#        PRINT COLUMN g_c[69],g_x[74] CLIPPED;
#        LET l_tab =0
#        FOREACH tmp2_cs USING sr.order1,sr.order2,'2' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            LET l_tab =1
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED   #NO.CHI-6A0004
#                  COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED   #NO.CHI-6A0004
#        END FOREACH
#        IF l_tab=0 THEN                                                                                                            
#           PRINT                                                                                                                   
#        END IF  
##應返小計
#        PRINT COLUMN g_c[69],g_x[78] CLIPPED;
#        FOREACH tmp2_cs USING sr.order1,sr.order2,'2' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,g_azi05) CLIPPED     #NO.CHI-6A0004
#                  COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,t_azi05) CLIPPED     #NO.CHI-6A0004
#        END FOREACH
#        PRINT ' '
#     END IF
 
#  AFTER GROUP OF sr.order3            #金額小計
#     IF tm.u[3,3] = 'Y' THEN
#        PRINT COLUMN g_c[51],g_orderA[3] CLIPPED;
##出貨小計
#        LET l_total1= GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 ='N'
#        LET l_tab =0
#        PRINT COLUMN g_c[69],g_x[72] CLIPPED,
#             #COLUMN g_c[59],l_total1 USING '############.##',  #FUN-710058 mod
#              COLUMN g_c[59],l_total1 USING '###########&.##',  #FUN-710058 mod
#              COLUMN g_c[53],l_total1 USING '############.##';
#        FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3,'1' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file       #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file       #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            LET l_tab =1
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED   #NO.CHI-6A0004
#                  COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED   #NO.CHI-6A0004
#        END FOREACH
#        IF l_tab=0 THEN                                                                                                            
#           PRINT                                                                                                                   
#        END IF  
##搭贈小計
#        LET l_total2= GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 = 'Y'
#        PRINT COLUMN g_c[69],g_x[73] CLIPPED,
#             #COLUMN g_c[59],l_total2 USING '############.##',  #FUN-710058 mod
#              COLUMN g_c[59],l_total2 USING '###########&.##',  #FUN-710058 mod
#              COLUMN g_c[53],l_total2 USING '############.##'
##可扣小計
#        PRINT COLUMN g_c[69],g_x[74] CLIPPED;
#        LET l_tab =0
#        FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3,'2' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file          #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file          #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            LET l_tab =1
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED        #NO.CHI-6A0004
#                  COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED        #NO.CHI-6A0004
#        END FOREACH
#        IF l_tab=0 THEN                                                                                                            
#           PRINT                                                                                                                   
#        END IF  
##應返小計
#        PRINT COLUMN g_c[69],g_x[78] CLIPPED;
#        FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3,'2' INTO sr1.*
##            SELECT azi05 INTO g_azi05 FROM azi_file          #NO.CHI-6A0004
#            SELECT azi05 INTO t_azi05 FROM azi_file          #NO.CHI-6A0004
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#            PRINT COLUMN g_c[54],l_str CLIPPED,
##                  COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,g_azi05) CLIPPED    #NO.CHI-6A0004    
#                  COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,t_azi05) CLIPPED    #NO.CHI-6A0004
#        END FOREACH
#        PRINT ' '
#     END IF
 
#  ON LAST ROW                         #金額總計
#     PRINT ''
##出貨總計
#     LET l_total1= SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012<>'Y'
#     PRINT COLUMN g_c[69],g_x[75] CLIPPED,
#          #COLUMN g_c[59],l_total1 USING '############.##',  #FUN-710058 mod
#           COLUMN g_c[59],l_total1 USING '###########&.##',  #FUN-710058 mod
#           COLUMN g_c[53],l_total1 USING '############.##';
#     LET l_tab =0
#     FOREACH tmp4_cs USING '1' INTO sr1.*
##         SELECT azi05 INTO g_azi05 FROM azi_file      #NO.CHI-6A0004
#         SELECT azi05 INTO t_azi05 FROM azi_file      #NO.CHI-6A0004
#          WHERE azi01 = sr1.curr
#         LET l_str = sr1.curr CLIPPED,':'
#         LET l_tab =1
#         PRINT COLUMN g_c[54],l_str CLIPPED,
##               COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED   #NO.CHI-6A0004
#               COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED   #NO.CHI-6A0004
#     END FOREACH
#     IF l_tab=0 THEN                                                                                                            
#        PRINT                                                                                                                   
#     END IF  
##搭贈總計
#     LET l_total2= SUM(sr.oeb12) WHERE sr.oeb1003='1' AND sr.oeb1012 = 'Y'
#     PRINT COLUMN g_c[69],g_x[76] CLIPPED,
#          #COLUMN g_c[59],l_total2 USING '############.##',  #FUN-710058 mod
#           COLUMN g_c[59],l_total2 USING '###########&.##',  #FUN-710058 mod
#           COLUMN g_c[53],l_total2 USING '############.##'
##可扣總計
#     PRINT COLUMN g_c[69],g_x[77] CLIPPED;
#     LET l_tab =0
#     FOREACH tmp4_cs USING '2' INTO sr1.*
##         SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#         SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#          WHERE azi01 = sr1.curr
#         LET l_str = sr1.curr CLIPPED,':'
#         LET l_tab =1
#         PRINT COLUMN g_c[54],l_str CLIPPED,
##               COLUMN g_c[55],cl_numfor(sr1.amt,55,g_azi05) CLIPPED   #NO.CHI-6A0004
#               COLUMN g_c[55],cl_numfor(sr1.amt,55,t_azi05) CLIPPED   #NO.CHI-6A0004
#     END FOREACH
#     IF l_tab=0 THEN                                                                                                            
#        PRINT                                                                                                                   
#     END IF  
##應返總計
#     PRINT COLUMN g_c[69],g_x[79] CLIPPED;
#     LET l_tab =0
#     FOREACH tmp4_cs USING '2' INTO sr1.*
##         SELECT azi05 INTO g_azi05 FROM azi_file   #NO.CHI-6A0004
#         SELECT azi05 INTO t_azi05 FROM azi_file   #NO.CHI-6A0004
#          WHERE azi01 = sr1.curr
#         LET l_str = sr1.curr CLIPPED,':'
#         LET l_tab =1
#         PRINT COLUMN g_c[54],l_str CLIPPED,
##               COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,g_azi05) CLIPPED   #NO.CHI-6A0004
#               COLUMN g_c[70],cl_numfor(sr1.oeb1013,70,t_azi05) CLIPPED   #NO.CHI-6A0004
#     END FOREACH
#     IF l_tab=0 THEN                                                                                                            
#        PRINT                                                                                                                   
#     END IF  
 
 
 
#     #是否列印選擇條件
#     IF g_zz05 = 'Y' THEN
#        CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')  #No.FUN-630056
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
##    PRINT  COLUMN (g_len-9),g_x[7] CLIPPED    #No.TQC-710043 mark
#    PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-710043 
 
#  #表尾列印
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
# #   PRINT     COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-710043 mark
#    PRINT g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-710043 
#     ELSE
#        SKIP 2 LINE
#     END IF
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[4]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[4]
#            PRINT g_memo
#     END IF
 
#END REPORT
#FUN-850164 --MARK END--
#No.FUN-870144
