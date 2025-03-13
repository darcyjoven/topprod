# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aicr031.4gl
# Descriptions...: wafer未轉code明細表
# Date & Author..: No.FUN-7B0073 07/12/05 by sherry #No.FUN-830067 CRrpt book單號
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30192 11/05/05 By shenyang  修改字段icb05
# Modify.........: No.FUN-B80083 11/08/08 By minpp程序撰寫規範修改
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
DEFINE tm         RECORD
                     wc      LIKE type_file.chr1000,          # QBE 條件
                     s       LIKE type_file.chr3,             # 排列 (INPUT 條件)
                     t       LIKE type_file.chr3,             # 跳頁 (INPUT 條件)
                     u       LIKE type_file.chr3,             # 合計 (INPUT 條件)
                     a       LIKE type_file.chr1,
                     b       LIKE type_file.chr1,
                     c       LIKE type_file.chr1,
                     more    LIKE type_file.chr1              # 輸入其它特殊打印條件
                  END RECORD
DEFINE g_orderA   ARRAY[3] OF LIKE type_file.chr10  # 篩選排序條件用變量
DEFINE g_i        LIKE type_file.num5        #count/index for any purpose
DEFINE g_head1    LIKE type_file.chr1000
DEFINE g_sma115   LIKE sma_file.sma115
DEFINE g_sma116   LIKE sma_file.sma116
DEFINE #l_sql      LIKE type_file.chr1000
       l_sql      STRING     #NO.FUN-910082
DEFINE l_zaa02    LIKE zaa_file.zaa02
DEFINE i          LIKE type_file.num5
DEFINE g_sql      STRING
DEFINE g_str      STRING
DEFINE l_table    STRING 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   #--外部程序傳遞參數或 Background Job 時接受參數 --#
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
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF    
 
   LET g_sql = "oea02.oea_file.oea02,",
               "oea01.oea_file.oea01,",
               "oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04,",
             # "icb05.icb_file.icb05,",  #FUN-B30192
               "imaicd14.imaicd_file.imaicd14,",  #FUN-B30192
               "oeb12.oeb_file.oeb12,",
               "img10_a.img_file.img10,",
               "img10_b.img_file.img10,",
               "oebiicd03.oebi_file.oebiicd03,",
               "imaicd06.imaicd_file.imaicd06,",
               "oeb15.oeb_file.oeb15,",
               "oebiicd06.oebi_file.oebiicd06,",
               "oeaconf.oea_file.oeaconf,",
               "oao06.oao_file.oao06,",
               "oea03.oea_file.oea03,",
               "oea04.oea_file.oea04,",
               "oea14.oea_file.oea14,",
               "oea15.oea_file.oea15,",
               "oea23.oea_file.oea23,",
               "oea12.oea_file.oea12,",
               "oeahold.oea_file.oeahold"  
   LET l_table = cl_prt_temptable('aicr031',g_sql)CLIPPED                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
                                                                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,             
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ", 
               "        ?,?,?,?,?, ? ) "                          
   PREPARE insert_prep FROM g_sql                                               
   IF SQLCA.sqlcode THEN          
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                         
   END IF        
                    
   CREATE TEMP TABLE curr_tmp
    (curr    LIKE type_file.chr4,                    #幣別
     amt     LIKE type_file.num20_6,                 #金額   
     order1  LIKE type_file.chr50,                    
     order2  LIKE type_file.chr50,                    
     order3  LIKE type_file.chr50 );                     

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044     
 
   IF NOT cl_null(tm.wc) THEN
      CALL r031()
      DROP TABLE curr_tmp
   ELSE
      CALL r031_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044 
END MAIN
 
FUNCTION r031_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
 
   LET p_row = 3 LET p_col = 11
   OPEN WINDOW r031_w AT p_row,p_col WITH FORM "aic/42f/aicr031"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #預設畫面字段
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
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea04,
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
         CLOSE WINDOW r031_w
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
         CLOSE WINDOW r031_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aicr031'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aicr031','9031',1)
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
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",          
                        " '",g_template CLIPPED,"'"          
            CALL cl_cmdat('aicr031',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r031_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL r031()
 
      ERROR ""
   END WHILE
 
   DROP TABLE curr_tmp   
 
   CLOSE WINDOW r031_w
 
END FUNCTION
 
FUNCTION r031()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name
DEFINE l_time    LIKE type_file.chr8           # Used time for running the job
DEFINE #l_sql     LIKE type_file.chr1000        # SQL STATEMENT
       l_sql      STRING     #NO.FUN-910082
DEFINE l_za05    LIKE type_file.chr50
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr50                  
DEFINE sr        RECORD order1  LIKE type_file.chr20,              
                        order2  LIKE type_file.chr20,              
                        order3  LIKE type_file.chr20,              
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
                        oeb917  LIKE oeb_file.oeb917,    
			oebiicd03 LIKE oebi_file.oebiicd03,	#SPARE PART
			oebiicd06 LIKE oebi_file.oebiicd06	#已轉片數
                        END RECORD
DEFINE l_ima02     LIKE ima_file.ima02
DEFINE l_ima021    LIKE ima_file.ima021
DEFINE l_img10_a   LIKE img_file.img10
DEFINE l_img10_b   LIKE img_file.img10
DEFINE l_ima906    LIKE ima_file.ima906
DEFINE l_oeb912    LIKE oeb_file.oeb912
DEFINE l_oeb915    LIKE oeb_file.oeb915
DEFINE l_oeb12     LIKE oeb_file.oeb12
DEFINE l_oao06     LIKE oao_file.oao06 
DEFINE l_imaicd06  LIKE imaicd_file.imaicd06
DEFINE l_imaicd01  LIKE imaicd_file.imaicd01
#DEFINE l_icb05     LIKE icb_file.icb05   #FUN-B30192
DEFINE l_imaicd14      LIKE imaicd_file.imaicd14  #FUN-B30192
DEFINE l_str2      LIKE type_file.chr1000  
 
  # CALL cl_used(g_prog,l_time,1) RETURNING l_time   #FUN-B80083 MARK
  #  CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD    FUN-B90044  MARK
   CALL cl_del_data(l_table)    
   #抓取公司名稱
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的數據
   #      LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的數據
   #      LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN   
   #      LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   SELECT azi03,azi04,azi05
     INTO g_azi03,g_azi04,g_azi05          #幣別文件小數位數讀取
     FROM azi_file
    WHERE azi01=g_aza.aza17
 
   LET l_sql = "SELECT '','','',                                ",
               "      oea01, oea02, oea03, A.occ02, oea04, B.occ02, ",
               "      gen02, gem02, oea23, oea21, oea12, oea31, ",
               "      oea32, oeahold,oeaconf,oea14,oea15,", 
               "      oeb03, oeb04, oeb06,",                
               "      oeb05, oeb12, oeb13,oeb14, oeb15 ",
               "      ,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ",   
	       "      ,oebiicd03,oebiicd06",
               " FROM oea_file LEFT OUTER JOIN occ_file A ON(oea_file.oea03 = A.occ01) LEFT OUTER JOIN occ_file B ON(B.occ01 = oea_file.oea04 ) ",
               "       LEFT OUTER JOIN gen_file ON(gen01 = oea14) LEFT OUTER JOIN gem_file ON(gem01 = oea15), oeb_file ,oebi_file ",
               " WHERE  ",
               "    oeb01 = oebi01 AND oeb03 = oebi03 ",
               "    AND oea01=oeb_file.oeb01 AND oeaconf!='X' ",
	       " AND oeb04 not LIKE 'MISC%' ",
               "   AND ", tm.wc CLIPPED
 
   PREPARE r031_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   DECLARE r031_curs1 CURSOR FOR r031_prepare1
 
   FOREACH r031_curs1 INTO sr.*
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
 
      IF sr.oeb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
          WHERE ima01 = sr.oeb04
      ELSE
         LET l_ima021 = ''
      END IF
 
      SELECT ima021,ima906,imaicd06,imaicd01 
        INTO l_ima021,l_ima906,l_imaicd06,l_imaicd01 FROM ima_file,imaicd_file
      WHERE ima01=sr.oeb04 AND imaicd00 = ima01
    # SELECT icb05 INTO l_icb05 FROM icb_file WHERE icb01=l_imaicd01
      CALL s_icdfun_imaicd14(sr.oeb04) RETURNING l_imaicd14   #FUN-B30192
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
      select oao06 into l_oao06 from oao_file where oao01=sr.oea01 and oao03=sr.oeb03
      select SUM(IMG10) IMG10 into l_img10_a from img_file where img02='FIN01' and img01=sr.oeb04
      IF SQLCA.sqlcode THEN  LET l_img10_a=0  END IF
      select SUM(IMG10) IMG10 into l_img10_b from img_file where img02='BON01' and img01=sr.oeb04
      IF SQLCA.sqlcode THEN  LET l_img10_b=0  END IF
     
  #   EXECUTE insert_prep USING sr.oea02,sr.oea01,sr.oeb03,sr.oeb04,l_icb05,
      EXECUTE insert_prep USING sr.oea02,sr.oea01,sr.oeb03,sr.oeb04,l_imaicd14, #FUN-B30192
                                sr.oeb12,l_img10_a,l_img10_b,sr.oebiicd03,
                                l_imaicd06,sr.oeb15,sr.oebiicd06,
                                sr.oeaconf,l_oao06,sr.oea03,sr.oea04,sr.oea14,
                                sr.oea15,sr.oea23,sr.oea12,sr.oeahold 
   END FOREACH
 
   IF g_zz05 = 'Y' THEN                                                       
      CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,                       
                    oea14,oea15,oea23,oea12,oeahold ')                          
        RETURNING tm.wc                                                       
   END IF                                                                     
   LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",
               tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
               tm.u[3,3]
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
   CALL cl_prt_cs3('aicr031','aicr031',l_sql,g_str)       
   #CALL cl_used(g_prog,l_time,2) RETURNING l_time       #FUN-B80083 MARK
   #No.FUN-BB0047--mark--Begin---
   # CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-7B0073  
#No.FUN-830067
