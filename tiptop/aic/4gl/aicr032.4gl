# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aicr032.4gl
# Descriptions...: 未交貨的客戶明細報表
# Date & Author..: No.FUN-7B0073 07/12/07 by sherry
# Modify.........: No.FUN-830067 08/03/21 by sherry 一筆資料重復打印出4筆
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-950072 09/05/14 BY ve007 含有sfbiicd09 的條件拿掉
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
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
DEFINE tm  RECORD
         #  wc      LIKE type_file.chr1000,
           wc      STRING,               #NO.FUN-910082
           s       LIKE type_file.chr3,
           t       LIKE type_file.chr3,
           u       LIKE type_file.chr3,
           a       LIKE type_file.chr1,
           more    LIKE type_file.chr1
           END RECORD
DEFINE   g_orderA        ARRAY[3] OF LIKE type_file.chr10
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_head1         LIKE type_file.chr1000
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num5
DEFINE g_sql            STRING
DEFINE g_str            STRING
DEFINE l_table          STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
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
 
   LET g_sql = "oea032.oea_file.oea032,",
               "oea10.oea_file.oea10," ,
               "oebiicd01.oebi_file.oebiicd01,",
               "oea02.oea_file.oea02,",
               "oeb04.oeb_file.oeb04,",
               "imaicd06.imaicd_file.imaicd06,",
               "oea01.oea_file.oea01,",
               "oeb03.oeb_file.oeb03,",
               "oeb917.oeb_file.oeb917,",
               "oeb15.oeb_file.oeb15,",
               "oeb13.oeb_file.oeb13,",
               "oea23.oea_file.oea23,",
               "oeb23.oeb_file.oeb23,",
               "img10.img_file.img10,",
               "oeb24.oeb_file.oeb24,",
               "pmm04.pmm_file.pmm04,",
               "pmn87.pmn_file.pmn87,",
               "l_sfb08_cp.sfb_file.sfb08,",
               "l_sfb08_ds.sfb_file.sfb08,",
               "oeb16.oeb_file.oeb16,",
               "l_str4.type_file.chr1000,",
               "oea03.oea_file.oea03,",
               "oea04.oea_file.oea04,",
               "oea14.oea_file.oea14,",
               "oea15.oea_file.oea15,",
               "oeb12.oeb_file.oeb12,",
               "oeb14.oeb_file.oeb14"
               
   LET l_table = cl_prt_temptable('aicr032',g_sql)CLIPPED                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
                                                                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,             
               " values(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               " ?,?,?,?,?, ?,?,?,?,?, ?,?) "                          
   PREPARE insert_prep FROM g_sql                                               
   IF SQLCA.sqlcode THEN          
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                         
   END IF                                             
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)      
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)    
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044

   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r032_tm(0,0)
      ELSE CALL r032()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION r032_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE l_cmd          LIKE type_file.chr1000
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW r032_w AT p_row,p_col WITH FORM "aic/42f/aicr032"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
   LET tm2.s2  = '4'                                                   
   LET tm2.s3  = '3'						
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '2'						
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
 CONSTRUCT BY NAME tm.wc ON oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,ima131 
 
        BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
        ON ACTION CONTROLP    
           IF INFIELD(oea03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           END IF
           IF INFIELD(oea04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea04
              NEXT FIELD oea04
           END IF
           IF INFIELD(oea14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea14
              NEXT FIELD oea14
           END IF
           IF INFIELD(oea15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea15
              NEXT FIELD oea15
           END IF
	    IF INFIELD(ima131)  THEN          
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oba"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima131
            NEXT FIELD ima131
            END IF
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()            
          EXIT CONSTRUCT
 
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
      CLOSE WINDOW r032_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.a,tm.more  WITHOUT DEFAULTS
		
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
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
      CLOSE WINDOW r450_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aicr032'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr032','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
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
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('aicr032',g_time,l_cmd)
      END IF
      CLOSE WINDOW r032_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r032()
   ERROR ""
END WHILE
   CLOSE WINDOW r032_w
END FUNCTION
 
FUNCTION r032()
DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name
DEFINE l_time    LIKE type_file.chr8          # Used time for running the job
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT
DEFINE l_za05    LIKE za_file.za05
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr10               
DEFINE sr        RECORD order1 LIKE type_file.chr20,
                        order2 LIKE type_file.chr20,
                        order3 LIKE type_file.chr20,
                        oea01 LIKE oea_file.oea01,
                        oea02 LIKE oea_file.oea02,
                        oea03 LIKE oea_file.oea03,
                        oea032 LIKE oea_file.oea032,		#客戶簡稱
                        oea04 LIKE oea_file.oea04,		#客戶編號
                        occ02 LIKE occ_file.occ02,		#客戶簡稱
                        gen02 LIKE gen_file.gen02,
                        gem02 LIKE gem_file.gem02,
                        oea23 LIKE oea_file.oea23,
                        oeb03 LIKE oeb_file.oeb03,
                        oeb04 LIKE oeb_file.oeb04,
                        oeb06 LIKE oeb_file.oeb06,
                        oeb05 LIKE oeb_file.oeb05,
                        oeb12 LIKE oeb_file.oeb12,
                        oeb13 LIKE oeb_file.oeb13,
                        oeb14 LIKE oeb_file.oeb14,
                        oeb15 LIKE oeb_file.oeb15,
                        oeb910 LIKE oeb_file.oeb910,            
                        oeb912 LIKE oeb_file.oeb912,            
                        oeb913 LIKE oeb_file.oeb913,            
                        oeb915 LIKE oeb_file.oeb915,            
                        oeb916 LIKE oeb_file.oeb916,            
                        oeb917 LIKE oeb_file.oeb917,            
                        oea14 LIKE oea_file.oea14,              
                        oea15 LIKE oea_file.oea15,              
			oea10 LIKE oea_file.oea10,
			oebiicd01 LIKE oebi_file.oebiicd01,
			oeb24 LIKE oeb_file.oeb24,
			oeb16 LIKE oeb_file.oeb16,
			oeb23 LIKE oeb_file.oeb23,
			imaicd06 LIKE imaicd_file.imaicd06
                        END RECORD,
                l_rowno  LIKE type_file.num5,                                   
                l_rowno1 LIKE type_file.num5,                                   
                l_cnt    LIKE type_file.num5,                                   
                l_amt_1  LIKE oeb_file.oeb14,                                   
                l_amt_2  LIKE oeb_file.oeb12,                                   
                l_amt_3  LIKE type_file.num5,                                   
      l_oga    RECORD                                                           
                 oga01    LIKE oga_file.oga01,                                  
                 oga02    LIKE oga_file.oga02,                                  
                 ogb03    LIKE ogb_file.ogb03,                                  
                 ogb12    LIKE ogb_file.ogb12,                                  
                 ogb13    LIKE ogb_file.ogb13,                     
                 oga23    LIKE oga_file.oga23                     
               END RECORD,                                                      
      l_oma    RECORD                                                           
                 oma01    LIKE oma_file.oma01,                                  
                 oma10    LIKE oma_file.oma10,                                  
                 omb03    LIKE omb_file.omb03                                   
               END RECORD,                                                      
               l_str      LIKE type_file.chr50,             
               l_str1     LIKE type_file.chr50,             
               l_str2     LIKE type_file.chr50,       
               l_str3     LIKE type_file.chr50,             
               l_azi03    LIKE azi_file.azi03,                   
               l_ima021   LIKE ima_file.ima021  
   DEFINE  l_oeb915    LIKE oeb_file.oeb915                                     
   DEFINE  l_oeb912    LIKE oeb_file.oeb912                                     
   DEFINE  l_oeb12     LIKE oeb_file.oeb12                                      
   DEFINE  l_str4      LIKE type_file.chr1000                                   
   DEFINE  l_ima906    LIKE ima_file.ima906                                     
   DEFINE  l_imaicd06  LIKE imaicd_file.imaicd06                                   
   DEFINE  l_pmm04     LIKE pmm_file.pmm04                                      
   DEFINE  l_pmn87     LIKE pmn_file.pmn87                                      
   DEFINE  l_sfb08_cp  LIKE sfb_file.sfb08                                      
   DEFINE  l_sfb08_ds  LIKE sfb_file.sfb08                                      
   DEFINE  l_img10     LIKE img_file.img10                                      
   DEFINE  l_amt_4     LIKE sfb_file.sfb08                                      
   DEFINE  l_amt_5     LIKE sfb_file.sfb08    
 
   #  CALL cl_used(g_prog,l_time,1) RETURNING l_time 
   #  CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80083    ADD  FUN-B90044  MARK
     CALL cl_del_data(l_table)    
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的數據
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的數據
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
 
     SELECT azi03,azi04,azi05
       INTO g_azi03,g_azi04,g_azi05          #幣種檔案小數位數讀取
       FROM azi_file
      WHERE azi01=g_aza.aza17
 
     LET l_sql = "SELECT '','','',",
                 "oea01, oea02, oea03, oea032, oea04, occ02, gen02,",
                 "gem02, oea23, oeb03, oeb04, oeb06, oeb05, oeb12,",
                 "oeb13, oeb14, oeb15,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,oea14, oea15  ",       
		 ",oea10,oebiicd01,oeb24,oeb16,oeb23,imaicd06",
                 " FROM oea_file, OUTER occ_file, ",
                 " OUTER gen_file, OUTER gem_file,oebi_file, oeb_file ,ima_file,imaicd_file ",
                 " WHERE oea_file.oea04 = occ_file.occ01 AND oea_file.oea14 = gen_file.gen01 ",
		 "   AND oea_file.oea15 = gem_file.gem01  AND oea01 = oeb01 ",
                 "   AND oea00 <>'0' ", 
		 "   AND ima01 = oeb04 ", 
		 "   AND ima01 = imaicd00 ", 
                 "   AND oeaconf = 'Y' AND oeahold IS NULL AND ", tm.wc CLIPPED
     CASE tm.a
         WHEN '1'        #已交
            LET l_sql = l_sql CLIPPED," AND oeb24 > 0 "
         WHEN '2'        #未交 BugNo:4038 已結案訂單不可納入
            #LET l_sql = l_sql CLIPPED," AND oeb24 = 0 AND oeb70 != 'Y'"                    
             LET l_sql = l_sql CLIPPED," AND (oeb12-oeb24+oeb25-oeb26) > 0 AND oeb70 != 'Y'" 
 
     END CASE
 
     display 'l_sql:',l_sql
     PREPARE r032_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
        EXIT PROGRAM
     END IF
     DECLARE r032_curs1 CURSOR FOR r032_prepare1
   
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
 
     FOREACH r032_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
      LET l_rowno = 1
      SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
        FROM azi_file
       WHERE azi01=sr.oea23
       
      IF sr.oeb04[1,4] !='MISC' THEN
         SELECT ima021 INTO l_ima021 FROM ima_file
          WHERE ima01 = sr.oeb04
      ELSE
         LET l_ima021 = ''
      END IF
 
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.oeb04
      LET l_str4 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                    LET l_str4 = l_oeb912, sr.oeb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                      LET l_str4 = l_str4 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                    LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN   
            IF sr.oeb910 <> sr.oeb916 THEN
               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
               LET l_str4 = l_str4 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
            END IF
      END IF
      SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
       WHERE oga01=ogb01 AND ogb31=sr.oea01
         AND ogb32=sr.oeb03 AND ogaconf='Y'
         AND oga09 not IN ('1','5','7','9') 
      IF l_cnt = 0 THEN
         DECLARE r032_c1 CURSOR FOR
             SELECT oga01,oga02,ogb03,ogb12,ogb13,oga23 FROM oga_file,ogb_file
              WHERE oga01=ogb01 AND ogb31=sr.oea01
                AND ogb32=sr.oeb03 AND ogaconf='Y'
                AND oga09 not IN ('1','5','7','9') 
                ORDER BY oga01,ogb03
         FOREACH r032_c1 INTO l_oga.*
            IF STATUS THEN
               CALL cl_err('for oga:',STATUS,1)
               EXIT FOREACH
            END IF
            SELECT azi03 INTO l_azi03 FROM azi_file
             WHERE azi01=l_oga.oga23
 
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
             WHERE oma01=omb01 AND omb31=l_oga.oga01
               AND omb32=l_oga.ogb03 AND omaconf='Y'
            IF l_cnt=0 THEN
               LET l_oma.oma01=''
               LET l_oma.oma10=''
               LET l_oma.omb03=''
               DECLARE r032_c2 CURSOR FOR
                  SELECT oma01,oma10,omb03 FROM oma_file,omb_file
                   WHERE oma01=omb01 AND omb31=l_oga.oga01
                     AND omb32=l_oga.ogb03 AND omaconf='Y'
                     ORDER BY oma01,omb03
               FOREACH r032_c2 INTO l_oma.oma01,l_oma.oma10,l_oma.omb03
                  IF SQLCA.sqlcode THEN
                     EXIT FOREACH
                  END IF
               END FOREACH
            END IF
         END FOREACH
      END IF
  
      SELECT imaicd06 INTO l_imaicd06 FROM imaicd_file,ima_file
       WHERE ima01=sr.oeb04 AND ima01 = imaicd00
	    IF SQLCA.sqlcode THEN  LET l_imaicd06 = NULL  END IF
	    SELECT pmm04,pmn87 INTO l_pmm04,l_pmn87 
              FROM pmm_file,pmn_file,pmni_file 
	      WHERE pmm01=pmn01 AND pmm02 ='2' 
	        AND pmniicd01=sr.oea01 AND pmniicd02=sr.oeb03			#CodeRelase 片數,日期
                AND pmni01 = pmn01 AND pmni02 = pmn02 
	      IF SQLCA.sqlcode THEN 
	         LET l_pmn87 = 0 
	         LET l_pmm04 = NULL
	      END IF	
	   SELECT sfb08 INTO l_sfb08_cp FROM sfb_file,sfbi_file
     #       WHERE sfbiicd09 LIKE '1%'                    #NO.TQC-950072
             WHERE sfb22=sr.oea01 AND sfb221=sr.oeb03 
              AND sfbi01 = sfb01 				#CP片數
	   IF SQLCA.sqlcode THEN
	      LET l_sfb08_cp=0
	   END IF
	   SELECT sfb08 INTO l_sfb08_ds FROM sfb_file,sfbi_file 
#            WHERE sfbiicd09 LIKE '2%'                #NO.TQC-950072
	      WHERE sfb22=sr.oea01 AND sfb221=sr.oeb03
              AND sfbi01 =sfb01				#DS片數
	      IF SQLCA.sqlcode THEN
	         LET l_sfb08_ds=0
	      END IF
           SELECT SUM(img10) img10 INTO l_img10 FROM img_file WHERE img01=sr.oeb04
	      IF SQLCA.sqlcode THEN
	         LET l_img10=0
        	END IF    
  	
	  EXECUTE insert_prep USING sr.oea032,sr.oea10,sr.oebiicd01,sr.oea02,
	                            sr.oeb04,l_imaicd06,sr.oea01,sr.oeb03,sr.oeb917,
	                            sr.oeb15,sr.oeb13,sr.oea23,sr.oeb23,l_img10,
                                    sr.oeb24,
	                            l_pmm04,l_pmn87,l_sfb08_cp,l_sfb08_ds,sr.oeb16,
	                            l_str4,sr.oea03,sr.oea04,sr.oea14,sr.oea15,
                                    sr.oeb12,sr.oeb14 
	                             
    END FOREACH
   
    IF g_zz05 = 'Y' THEN                                                       
       CALL cl_wcchp(tm.wc,'oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15,ima131')                          
         RETURNING tm.wc                                                       
    END IF                                                                     
    LET g_str = tm.wc,";",g_azi03,";",g_azi04,";",tm.s[1,1],";",tm.s[2,2],";",
                tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3]                               
    #LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED       #No.FUN-830067  
    LET l_sql = "SELECT DISTINCT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  #No.FUN-830067        
    CALL cl_prt_cs3('aicr032','aicr032',l_sql,g_str)       
 
   # CALL cl_used(g_prog,l_time,2) RETURNING l_time   #FUN-B80083 mark
   #No.FUN-BB0047--mark--Begin---
   #  CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80083    ADD
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-7B0073
