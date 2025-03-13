# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aic030.4gl
# Descriptions...: 客戶訂單明細表
# Date & Author..: 07/12/07 By xiaofeizhu  FUN-7B0027
# Modify   FUN-7B0027
# Modify.........: No.CHI-940010 09/04/08 By hellen 修改SELECT ima或者imaicd欄位卻未JOIN相關表的問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改	
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-BC0103 12/01/13 PIN COUNT以料號設定優先帶入,若無資料則帶icj_file設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
DEFINE tm         RECORD
                     wc      STRING,           #TQC-630166   # QBE 條件
                     s       LIKE type_file.chr3,             # 排列 (INPUT 條件)
                     t       LIKE type_file.chr3,             # 跳頁 (INPUT 條件)
                     u       LIKE type_file.chr3,             # 合計 (INPUT 條件)
                     a       LIKE type_file.chr1,
                     b       LIKE type_file.chr1,
                     c       LIKE type_file.chr1,
                     more    LIKE type_file.chr1              # 輸入其它特殊列印條件
                  END RECORD
DEFINE g_orderA   ARRAY[3] OF LIKE type_file.chr10  # 篩選排序條件用變數
DEFINE g_i        LIKE type_file.num5        #count/index for any purpose
DEFINE g_head1    STRING
DEFINE g_sma115   LIKE sma_file.sma115
DEFINE g_sma116   LIKE sma_file.sma116
DEFINE l_sql      LIKE type_file.chr1000
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num10 
DEFINE l_sql2 LIKE type_file.chr1000
DEFINE l_table       STRING,         
       g_str         STRING,        
       g_sql         STRING
 
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
#------------No.TQC-610089 modify
  #LET tm.more  = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610089 end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                                                                    
      CALL cl_err('','aic-999',1) EXIT PROGRAM                                                                                      
   END IF                                                                                                                           
                                                                                                                                    
##*** -------- 與 Crystal Reports 串聯段 ---- <<<< 產生Temp Table >>>>---*** ##                                                     
   LET g_sql = "oea01.oea_file.oea01,",
               "oea02.oea_file.oea02,",
               "oea03.oea_file.oea03,", 
               "oea032.oea_file.oea032,",
               "oea04.oea_file.oea04,",
               "gen02.gen_file.gen02,",                                                                             
               "gem02.gem_file.gem02,",
               "oea23.oea_file.oea23,",
               "oea12.oea_file.oea12,",
               "oeahold.oea_file.oeahold,",                                                                                             
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
               "oeb12.oeb_file.oeb12,",
               "oeb13.oeb_file.oeb13,",
               "oeb14.oeb_file.oeb14,",   
               "oeb15.oeb_file.oeb15,",
               "oea10.oea_file.oea10,",
               "oebiicd03.oebi_file.oebiicd03,",
               "l_pkg.icj_file.icj04,",
               "l_azf03.azf_file.azf03,",                                                                                             
               "l_str2.type_file.chr1000,",                                                                                             
               "l_azk051.azk_file.azk051"                                                                                               
    LET l_table = cl_prt_temptable('aicr030',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
#   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                       
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                         
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
    CREATE TEMP TABLE curr_tmp
     (curr    LIKE type_file.chr4,
      amt     LIKE oeb_file.oeb14,
      order1  LIKE type_file.chr50,
      order2  LIKE type_file.chr50,
      order3  LIKE type_file.chr50)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044 

   IF NOT cl_null(tm.wc) THEN
      CALL r030()
      DROP TABLE curr_tmp
   ELSE
      CALL r030_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION r030_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r030_w AT p_row,p_col WITH FORM "aic/42f/aicr030"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面欄位
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '2'
   LET tm2.s2  = '1'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '1'
   LET tm.b    = '3'
   LET tm.c    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,
                                 oea14,oea15,oea23,oea12,oeahold
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT
 
         ## No.FUN-4A0016
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea5"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
 
               WHEN INFIELD(oea03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea03
                 NEXT FIELD oea03
 
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
         ## END  No.FUN-4A0016
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r030_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.a,tm.b,tm.c,tm.more
            WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r030_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aicr030'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aicr030','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
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
                       #----------------No.TQC-610089 add
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                       #----------------No.TQC-610089 end
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aicr030',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r030_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r030()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp   #No.MOD-5C0054
 
   CLOSE WINDOW r030_w
 
END FUNCTION
 
FUNCTION r030()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name
DEFINE l_time    LIKE type_file.chr8           # Used time for running the job
DEFINE l_sql     LIKE type_file.chr1000        # SQL STATEMENT
DEFINE l_za05    LIKE type_file.chr50
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr50                  #FUN-560074
DEFINE sr        RECORD order1  LIKE type_file.chr50,              #FUN-560074
                        order2  LIKE type_file.chr50,              #FUN-560074
                        order3  LIKE type_file.chr50,              #FUN-560074
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,	#客戶簡稱
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
                        oea14   LIKE oea_file.oea14,    #FUN-4C0096
                        oea15   LIKE oea_file.oea15,    #FUN-4C0096
			oea24   LIKE oea_file.oea24,
                        oeb03   LIKE oeb_file.oeb03,
                        oeb04   LIKE oeb_file.oeb04,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,
                        oeb12   LIKE oeb_file.oeb12,
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
			oeb24   LIKE oeb_file.oeb24,
			oeb17   LIKE oeb_file.oeb17,
                        oeb15   LIKE oeb_file.oeb15,
                        oeb910  LIKE oeb_file.oeb910,   #FUN-580004
                        oeb912  LIKE oeb_file.oeb912,   #FUN-580004
                        oeb913  LIKE oeb_file.oeb913,   #FUN-580004
                        oeb915  LIKE oeb_file.oeb915,   #FUN-580004
                        oeb916  LIKE oeb_file.oeb916,   #FUN-580004
                        oeb917  LIKE oeb_file.oeb917,    #FUN-580004
			oea10     LIKE oea_file.oea10,
			oebiicd03 LIKE oebi_file.oebiicd03,		#2006/12/04-Steven_yeh-Add
			oebiicd07 LIKE oebi_file.oebiicd07
                        END RECORD
   DEFINE       l_str2  LIKE type_file.chr1000,                                              
                l_ima021 LIKE ima_file.ima021 
 
   DEFINE  l_oeb915    STRING                                                                                                       
   DEFINE  l_oeb912    STRING                                                                                                       
   DEFINE  l_oeb12     STRING                                                                                                       
   DEFINE  l_ima906    LIKE ima_file.ima906                                                                                         
   DEFINE  l_azk051    LIKE azk_file.azk051
   DEFINE  l_pkg       LIKE icj_file.icj04                                                                                          
   DEFINE  l_imaicd06 LIKE imaicd_file.imaicd06                                                                                        
   DEFINE  l_imaicd01 LIKE imaicd_file.imaicd01                                                                                        
   DEFINE  l_azf03     LIKE azf_file.azf03
   
  # CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818  #FUN-B80083 MARK
  #  CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80083    ADD     #FUN-B90044  MARK
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
 
    LET l_sql2= " select azk051 from azk_file ",
		   " where (azk01,azk02) in ( select azk01,max(azk02) from azk_file group by azk01 ) ",
		   " and azk01=? "
       PREPARE tmp6_pre FROM l_sql2
       DECLARE tmp6_cs CURSOR FOR tmp6_pre
 
   SELECT azi03,azi04,azi05
     INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
     FROM azi_file
    WHERE azi01=g_aza.aza17
 
   LET l_sql = "SELECT '','','',                                ",
               "      oea01, oea02, oea03, A.occ02, oea04, B.occ02, ",
               "      gen02, gem02, oea23, oea21, oea12, oea31, ",
               "      oea32, oeahold,oeaconf,oea14,oea15,oea24,", #FUN-4C0096
               "      oeb03, oeb04, oeb06,",                #FUN-4C0096
               "      oeb05, oeb12, oeb13,oeb14,oeb24,oeb17, oeb15 ",
               "      ,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ,oea10",   #FUN-580004
	       "      ,oebiicd03,oebiicd07",						    #2006/12/04-Steven_yeh-Add
               " FROM oea_file, OUTER occ_file A,OUTER occ_file B,",
               "      OUTER gen_file, OUTER gem_file, oeb_file,oebi_file ",
               " WHERE oea_file.oea03 = A.occ01 AND B.occ01 = oea_file.oea04  ",
               "   AND gen_file.gen01 = oea_file.oea14 ",
               "   AND gem_file.gem01 = oea_file.oea15 AND oea01=oeb_file.oeb01 AND oeaconf!='X' AND oea01=oebi_file.oebi01 ",
               "   AND ", tm.wc CLIPPED
 
   PREPARE r030_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   DECLARE r030_curs1 CURSOR FOR r030_prepare1
 
#  CALL cl_outnam('aicr030') RETURNING l_name
     ## *** 與 Crystal Reports 串聯段 --- <<<< 清除暫存資料 >>>> --- *** ##                                                    
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                 
     #------------------------------ CR (2) ------------------------------#
#  CALL cl_prt_pos_len()
 
#  START REPORT r030_rep TO l_name
   LET g_pageno = 0
   FOREACH r030_curs1 INTO sr.*
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
 
      SELECT azi03,azi04,azi05                                                                                                      
        INTO g_azi03,g_azi04,g_azi05                                                                                                
        FROM azi_file                                                                                                               
       WHERE azi01=sr.oea23
 
      IF sr.oeb04[1,4] !='MISC' THEN                                                                                                
         SELECT ima021 INTO l_ima021 FROM ima_file                                                                                  
          WHERE ima01 = sr.oeb04                                                                                                    
      ELSE                                                                                                                          
         LET l_ima021 = ''                                                                                                          
      END IF                                                                                                                        
                                                                                                                                    
     #modify CHI-940010 by hellen --begin 090408
#    SELECT ima021,ima906,imaicd06,imaicd01 INTO l_ima021,l_ima906,l_imaicd06,l_imaicd01 FROM ima_file                              
     SELECT ima021,ima906,imaicd06,imaicd01 
       INTO l_ima021,l_ima906,l_imaicd06,l_imaicd01
       FROM ima_file,imaicd_file                              
      WHERE ima01=sr.oeb04      
        AND ima01 = imaicd00                                                                                                    
     #modify CHI-940010 by hellen --end 090408
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
      IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076                                                                         
            IF sr.oeb910 <> sr.oeb916 THEN                                                                                          
               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12                                                                      
               LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"                                                         
            END IF                                                                                                                  
      END IF
   
   #SELECT icj04 INTO l_pkg FROM icj_file WHERE icj02=sr.oeb04   #FUN-BC0103 mark
   #FUN-BC0103 --START--
   SELECT imaicd18 INTO l_pkg FROM imaicd_file WHERE imaicd00 = sr.oeb04
   IF SQLCA.sqlcode THEN LET l_pkg = NULL END IF
   IF cl_null(l_pkg) THEN
      SELECT icj04 INTO l_pkg FROM icj_file WHERE icj02=sr.oeb04
   END IF  
   #FUN-BC0103 --END--
   select azf03 INTO l_azf03 from azf_file where azf02='R' and azf01=sr.oebiicd07                                                   
   IF SQLCA.sqlcode THEN LET l_azf03=NULL END IF
 
 
 #    FOR g_i = 1 TO 3
 #       CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea01
 #                                     LET g_orderA[g_i]= g_x[20]
 #            WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea02
 #                                         USING 'yyyymmdd'
 #                                     LET g_orderA[g_i]= g_x[21]
 #            WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea03
 #                                     LET g_orderA[g_i]= g_x[22]
 #            WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea04
 #                                     LET g_orderA[g_i]= g_x[23]
 #            WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.gen02
 #                                     LET g_orderA[g_i]= g_x[24]
 #            WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.gem02
 #                                     LET g_orderA[g_i]= g_x[25]
 #            WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
 #                                     LET g_orderA[g_i]= g_x[26]
 #            WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oea12
 #                                     LET g_orderA[g_i]= g_x[27]
 #            WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i]=sr.oeahold
 #                                     LET g_orderA[g_i]= g_x[28]
 #            OTHERWISE LET l_order[g_i]  = '-'
 #                      LET g_orderA[g_i] = ' '          #清為空白
 #       END CASE
 #    END FOR
 
 #    LET sr.order1 = l_order[1]
 #    LET sr.order2 = l_order[2]
 #    LET sr.order3 = l_order[3]
 
 #    OUTPUT TO REPORT r030_rep(sr.*)
        ## *** --- 與 Crystal Reports 串聯段 --- <<<< 寫入暫存檔 >>>> --- *** ##                                                   
           EXECUTE insert_prep USING                                                                                                
                   sr.oea01,sr.oea02,sr.oea03,sr.oea032,sr.oea04,sr.gen02,sr.gem02,
                   sr.oea23,sr.oea12,sr.oeahold,sr.oeb03,sr.oeb04,sr.oeb12,sr.oeb13,
                   sr.oeb14,sr.oeb15,sr.oea10,sr.oebiicd03,l_pkg,l_azf03,l_str2,l_azk051                                                            
          #------------------------------ CR (3) ------------------------------#
   END FOREACH
 
#  FINISH REPORT r030_rep
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04')                                                               
              RETURNING tm.wc
      END IF
    ## **** 與 Crystal Reports 串聯段 --- <<<< CALL cs3() >>>> ---- **** ##                                                     
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                tm.t[2,2],";",tm.t[3,3]                                                                                     
    CALL cl_prt_cs3('aicr030','aicr030',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 #  CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818  #FUN-B80083 MARK
    #No.FUN-BB0047--mark--Begin---
    #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
    #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#{REPORT r030_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1
#DEFINE sr           RECORD order1 LIKE type_file.chr50,          #FUN-560074
#                          order2 LIKE type_file.chr50,          #FUN-560074
#                          order3 LIKE type_file.chr50,          #FUN-560074
#                       oea01   LIKE oea_file.oea01,
#                       oea02   LIKE oea_file.oea02,
#                       oea03   LIKE oea_file.oea03,
#                       oea032  LIKE oea_file.oea032,	#客戶簡稱
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
#                       oea14   LIKE oea_file.oea14,    #FUN-4C0096
#                       oea15   LIKE oea_file.oea15,    #FUN-4C0096
#		oea24   LIKE  oea_file.oea24,    #
#                       oeb03   LIKE oeb_file.oeb03,
#                       oeb04   LIKE oeb_file.oeb04,
#                       oeb06   LIKE oeb_file.oeb06,
#                       oeb05   LIKE oeb_file.oeb05,
#                       oeb12   LIKE oeb_file.oeb12,
#                       oeb13   LIKE oeb_file.oeb13,
#                       oeb14   LIKE oeb_file.oeb14,
#		oeb24   LIKE oeb_file.oeb24,
#		oeb17   LIKE oeb_file.oeb17,
#                       oeb15   LIKE oeb_file.oeb15,
#		oeb910  LIKE oeb_file.oeb910,   #FUN-580004
#                       oeb912  LIKE oeb_file.oeb912,   #FUN-580004
#                       oeb913  LIKE oeb_file.oeb913,   #FUN-580004
#                       oeb915  LIKE oeb_file.oeb915,   #FUN-580004
#                       oeb916  LIKE oeb_file.oeb916,   #FUN-580004
#                       oeb917  LIKE oeb_file.oeb917,    #FUN-580004
#		oea10     LIKE oea_file.oea10,
#		oebiicd03 LIKE oebi_file.oebiicd03,		#2006/12/04-Steven_yeh-Add
#		oebiicd07 LIKE oebi_file.oebiicd07
#                   END RECORD,
#         sr1           RECORD                 #No.8991
#                          curr      LIKE type_file.chr4,
#                          amt       LIKE oeb_file.oeb14
#                   END RECORD,
#               l_str   LIKE type_file.chr50,              #FUN-4C0096 add
#               l_str1  LIKE type_file.chr50,              #FUN-4C0096 add
#               l_str2  LIKE type_file.chr1000,             #No.FUN-580004
#               l_str3  LIKE type_file.chr50,              #FUN-4C0096 add
#               l_ima021 LIKE ima_file.ima021, #FUN-4C0096 add
#	l_rowno LIKE type_file.num5,
#	l_amt_1 LIKE oeb_file.oeb14,   #FUN-4C0096 modify
#	l_amt_2 LIKE oeb_file.oeb12    #FUN-4C0096 modify
#No.FUN-580004--begin
#  DEFINE  l_oeb915    STRING
#  DEFINE  l_oeb912    STRING
#  DEFINE  l_oeb12     STRING
#  DEFINE  l_ima906    LIKE ima_file.ima906
#No.FUN-580004--end  
#  DEFINE  l_pkg       LIKE icj_file.icj04
#  DEFINE  l_imaicd06 LIKE ima_file.imaicd06
#  DEFINE  l_imaicd01 LIKE ima_file.imaicd01
#  DEFINE  l_azf03     LIKE azf_file.azf03
#  DEFINE  l_azk051    LIKE azk_file.azk051
#  DEFINE  l_total     LIKE type_file.num20_6 
   
#  OUTPUT
#     TOP MARGIN 0
#     LEFT MARGIN 0
#     BOTTOM MARGIN 3
#     PAGE LENGTH g_page_line
 
#  ORDER EXTERNAL BY sr.order1,sr.order2,sr.order3     #No:8262
 
 
#FUN-4C0096 modify
  #格式設定
# FORMAT
   #列印表頭
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
#    #PRINT g_head1							#2006/12/04-Steven_yeh-Mark
 
 
#     PRINT g_dash[1,g_len]
#     PRINT g_x[32],g_x[31],g_x[48],g_x[34],g_x[60],g_x[49],g_x[61],g_x[53],g_x[62],g_x[41] #2006/12/04-Steven_yeh-Modify
#          ,g_x[54],g_x[63],g_x[56],g_x[64],g_x[57]   
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
 
#  BEFORE GROUP OF sr.oea02
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05
#       FROM azi_file
#      WHERE azi01=sr.oea23
 
#     PRINT COLUMN g_c[32],sr.oea02 CLIPPED; #訂單日期	#2006/12/04-Steven_yeh-Mark
            
 
#  ON EVERY ROW
#     IF sr.oeb04[1,4] !='MISC' THEN
#        SELECT ima021 INTO l_ima021 FROM ima_file
#         WHERE ima01 = sr.oeb04
#     ELSE
#        LET l_ima021 = ''
#     END IF
#FUN-580004--begin
 
#    SELECT ima021,ima906,imaicd06,imaicd01 INTO l_ima021,l_ima906,l_imaicd06,l_imaicd01 FROM ima_file
#     WHERE ima01=sr.oeb04
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
#     IF g_sma.sma116 MATCHES '[23]' THEN    #No.FUN-610076
#           IF sr.oeb910 <> sr.oeb916 THEN
#              CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
#              LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
#           END IF
#     END IF
#FUN-580004--end      
#2006/12/04-Steven_yeh-Modify-Start
#  SELECT icj04 INTO l_pkg FROM icj_file WHERE icj02=sr.oeb04 
#  select azf03 INTO l_azf03 from azf_file where azf02='R' and azf01=sr.oebiicd07
#  IF SQLCA.sqlcode THEN LET l_azf03=NULL END IF
 
#  PRINT    COLUMN g_c[31],sr.oea01 CLIPPED,
#           COLUMN g_c[48],cl_numfor(sr.oeb03,48,0) CLIPPED,
#           COLUMN g_c[34],sr.oea032 CLIPPED,
#           COLUMN g_c[60],sr.oea10 CLIPPED,
#           COLUMN g_c[49],sr.oeb04 CLIPPED,
#           COLUMN g_c[61],l_pkg CLIPPED,					 #sr.oea14 CLIPPED,       #PKG TYPE
#           COLUMN g_c[53],cl_numfor(sr.oeb12,53,3) CLIPPED,
#           COLUMN g_c[62],cl_numfor((sr.oebiicd03*sr.oeb12)/100,62,3) CLIPPED,	 #SPARE
#           COLUMN g_c[41],sr.oea23 CLIPPED,
#    COLUMN g_c[54],cl_numfor(sr.oeb13,54,5) CLIPPED,
#    COLUMN g_c[63],cl_numfor(sr.oeb14,63,2) CLIPPED, #sr.oeb12*sr.oeb13	         #合計
#           COLUMN g_c[56],sr.oeb15 CLIPPED,#sr.oeahold CLIPPED,
#    COLUMN g_c[64],l_azf03,
#           COLUMN g_c[57],l_str2 CLIPPED #sr.oeaconf CLIPPED;        
#            COLUMN g_c[42],sr.oeb12 * sr.oeb13 * sr.oea24 USING '###########&.##' CLIPPED     #No.FUN-580004
##2006/12/04-Steven_yeh-Modify-End
      
      #No.8991
#     INSERT INTO curr_tmp VALUES(sr.oea23,sr.oeb14,
#                                 sr.order1,sr.order2,sr.order3)
      #No.8991(end)
		
#  AFTER GROUP OF sr.order1            #金額小計
#     IF tm.u[1,1] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.oeb14)
#        LET l_amt_2 = GROUP SUM(sr.oeb12)
	 
 #        PRINT COLUMN g_c[51],g_orderA[1] CLIPPED,
  #             COLUMN g_c[52],g_x[11] CLIPPED,
  #             COLUMN g_c[53],l_amt_2 USING '############.##';
         #No.8991
#        FOREACH tmp1_cs USING sr.order1 INTO sr1.*
#            SELECT azi05 INTO g_azi05 FROM azi_file
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#      PRINT g_dash1
#            PRINT COLUMN g_c[53],sr.oea02 CLIPPED,COLUMN g_c[62],'小計' CLIPPED,COLUMN g_c[41],l_str CLIPPED,
#    	   				#2006/12/06-Steven_yeh-Mark
#                  COLUMN g_c[63],cl_numfor(sr1.amt,63,0) CLIPPED		#2006/12/06-Steven_yeh-Modify
#        END FOREACH
         #No.8991(end)
 #  	 PRINT ''
#     END IF
 
#  AFTER GROUP OF sr.order2            #金額小計
#     IF tm.u[2,2] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.oeb14)
#        LET l_amt_2 = GROUP SUM(sr.oeb12)
    #     PRINT COLUMN g_c[51],g_orderA[2] CLIPPED,
    #           COLUMN g_c[52],g_x[11] CLIPPED,
    #           COLUMN g_c[53],l_amt_2 USING '############.##';
         #No.8991
#        FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*
#            SELECT azi05 INTO g_azi05 FROM azi_file
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#     PRINT g_dash2
#            PRINT COLUMN g_c[53],sr.oea02 CLIPPED,COLUMN g_c[62],'小計' CLIPPED,COLUMN g_c[41],l_str CLIPPED,
#                  COLUMN g_c[63],cl_numfor(sr1.amt,63,0) CLIPPED
#        END FOREACH
         #No.8991(end)
#         PRINT ''
#     END IF
#
#  AFTER GROUP OF sr.order3            #金額小計
#     IF tm.u[3,3] = 'Y' THEN
#        LET l_amt_1 = GROUP SUM(sr.oeb14)
#        LET l_amt_2 = GROUP SUM(sr.oeb12)
      #   PRINT COLUMN g_c[51],g_orderA[3] CLIPPED,
       #        COLUMN g_c[52],g_x[11] CLIPPED,
        #       COLUMN g_c[53],l_amt_2 USING '############.##';
         #No.8991
#        FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*
#            SELECT azi05 INTO g_azi05 FROM azi_file
#             WHERE azi01 = sr1.curr
#            LET l_str = sr1.curr CLIPPED,':'
#      PRINT g_dash[1,g_len]
#            PRINT COLUMN g_c[53],sr.oea02 CLIPPED,COLUMN g_c[62],'小計' CLIPPED,COLUMN g_c[41],sr1.curr CLIPPED,':',
#	 				#2006/12/04-Steven_yeh-Mark
#                  COLUMN g_c[63],cl_numfor(sr1.amt,63,0) CLIPPED
#        END FOREACH
         #No.8991(end)
#         PRINT ''
#     END IF
 
 # ON LAST ROW                         #金額總計
 #    PRINT ''
 #    LET l_amt_1 = SUM(sr.oeb14)
 #    LET l_amt_2 = SUM(sr.oeb12)
#      PRINT COLUMN g_c[52],g_x[12] CLIPPED,
#       PRINT  COLUMN g_c[42],l_amt_2 USING '############.##';
      #No.8991
#     LET l_total=0    
       
#     FOREACH tmp4_cs INTO sr1.*
#         SELECT azi05 INTO g_azi05 FROM azi_file
#          WHERE azi01 = sr1.curr
#         LET l_str = sr1.curr CLIPPED,':'			
#         PRINT COLUMN g_c[62],'總計',COLUMN g_c[41],l_str CLIPPED,
#               COLUMN g_c[63],cl_numfor(sr1.amt,63,0)
#       FOREACH tmp6_cs USING sr1.curr INTO l_azk051 END FOREACH
#LET l_total=l_total+l_azk051*sr1.amt
#     END FOREACH
#     #No.8991(end)
#     PRINT COLUMN g_c[62],'合計',COLUMN g_c[41],'TWD:',COLUMN g_c[63],cl_numfor(l_total,63,0)
 
      #是否列印選擇條件
 #    IF g_zz05 = 'Y' THEN
 #       CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04')    # 刪掉,oeb05
 #            RETURNING tm.wc
 #       PRINT g_dash[1,g_len]
     #        IF tm.wc[001,070] > ' ' THEN            # for 80
     #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
     #        IF tm.wc[071,140] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
     #        IF tm.wc[141,210] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
     #        IF tm.wc[211,280] > ' ' THEN
     #    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	#TQC-630166
#	CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
## FUN-550127
     #PRINT COLUMN g_c[31],g_x[4] CLIPPED,
     #      COLUMN g_c[34],g_x[5] CLIPPED,
     #      COLUMN g_c[37],g_x[9] CLIPPED,
     #      COLUMN g_c[40],g_x[10] CLIPPED,
#    PRINT  COLUMN (g_len-9),g_x[7] CLIPPED  #No.FUN-580004
 
   #表尾列印
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
     #   PRINT COLUMN g_c[31],g_x[4] CLIPPED,
     #         COLUMN g_c[34],g_x[5] CLIPPED,
     #         COLUMN g_c[37],g_x[9] CLIPPED,
     #         COLUMN g_c[40],g_x[10] CLIPPED,
#    PRINT     COLUMN (g_len-9),g_x[6] CLIPPED  #No.FUN-580004
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
## END FUN-550127
 
# Modify   FUN-7B0027
#END REPORT}
